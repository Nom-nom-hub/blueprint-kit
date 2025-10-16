"""Init command implementation for the Blueprint-Kit CLI."""

import os
import subprocess
import sys
import zipfile
import tempfile
import shutil
import shlex
from pathlib import Path
from typing import Optional
import typer
from rich.console import Console
from rich.panel import Panel
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.text import Text
from rich.live import Live
from rich.align import Align
from rich.table import Table
import httpx
# For cross-platform keyboard input
import readchar
import ssl
import truststore

# Define SSL context for secure connections
ssl_context = truststore.SSLContext(ssl.PROTOCOL_TLS_CLIENT)

from ..core.step_tracker import StepTracker
from ..core.agent_config import AGENT_CONFIG
from ..core.cli import SCRIPT_TYPE_CHOICES, CLAUDE_LOCAL_PATH, BANNER, TAGLINE
from ..core.utils import _github_token, _github_auth_headers, is_git_repo
from ..services.github import download_template_from_github
from ..services.git import check_tool, init_git_repo


console = Console()

def get_key():
    """Get a single keypress in a cross-platform way using readchar."""
    key = readchar.readkey()

    if key == readchar.key.UP or key == readchar.key.CTRL_P:
        return 'up'
    if key == readchar.key.DOWN or key == readchar.key.CTRL_N:
        return 'down'

    if key == readchar.key.ENTER:
        return 'enter'

    if key == readchar.key.ESC:
        return 'escape'

    if key == readchar.key.CTRL_C:
        raise KeyboardInterrupt

    return key

def select_with_arrows(options: dict, prompt_text: str = "Select an option", default_key: str = None) -> str:
    """
    Interactive selection using arrow keys with Rich Live display.
    
    Args:
        options: Dict with keys as option keys and values as descriptions
        prompt_text: Text to show above the options
        default_key: Default option key to start with
        
    Returns:
        Selected option key
    """
    option_keys = list(options.keys())
    if default_key and default_key in option_keys:
        selected_index = option_keys.index(default_key)
    else:
        selected_index = 0

    selected_key = None

    def create_selection_panel():
        """Create the selection panel with current selection highlighted."""
        table = Table.grid(padding=(0, 2))
        table.add_column(style="cyan", justify="left", width=3)
        table.add_column(style="white", justify="left")

        for i, key in enumerate(option_keys):
            if i == selected_index:
                table.add_row("▶", f"[cyan]{key}[/cyan] [dim]({options[key]})[/dim]")
            else:
                table.add_row(" ", f"[cyan]{key}[/cyan] [dim]({options[key]})[/dim]")

        table.add_row("", "")
        table.add_row("", "[dim]Use ↑/↓ to navigate, Enter to select, Esc to cancel[/dim]")

        return Panel(
            table,
            title=f"[bold]{prompt_text}[/bold]",
            border_style="cyan",
            padding=(1, 2)
        )

    console.print()

    def run_selection_loop():
        nonlocal selected_key, selected_index
        with Live(create_selection_panel(), console=console, transient=True, auto_refresh=False) as live:
            while True:
                try:
                    key = get_key()
                    if key == 'up':
                        selected_index = (selected_index - 1) % len(option_keys)
                    elif key == 'down':
                        selected_index = (selected_index + 1) % len(option_keys)
                    elif key == 'enter':
                        selected_key = option_keys[selected_index]
                        break
                    elif key == 'escape':
                        console.print("\n[yellow]Selection cancelled[/yellow]")
                        raise typer.Exit(1)

                    live.update(create_selection_panel(), refresh=True)

                except KeyboardInterrupt:
                    console.print("\n[yellow]Selection cancelled[/yellow]")
                    raise typer.Exit(1)

    run_selection_loop()

    if selected_key is None:
        console.print("\n[red]Selection failed.[/red]")
        raise typer.Exit(1)

    return selected_key

def show_banner():
    """Display the ASCII art banner."""
    try:
        banner_lines = BANNER.strip().split('\n')
        colors = ["bright_blue", "blue", "cyan", "bright_cyan", "white", "bright_white"]

        styled_banner = Text()
        for i, line in enumerate(banner_lines):
            color = colors[i % len(colors)]
            styled_banner.append(line + "\n", style=color)

        console.print(Align.center(styled_banner))
        console.print(Align.center(Text(TAGLINE, style="italic bright_yellow")))
        console.print()
    except UnicodeEncodeError:
        # Fallback for systems that can't handle Unicode colors
        console.print(BANNER)
        console.print(TAGLINE)
        console.print()


def run_command(cmd: list[str], check_return: bool = True, capture: bool = False, shell: bool = False) -> Optional[str]:
    """Run a shell command and optionally capture output."""
    try:
        if capture:
            result = subprocess.run(cmd, check=check_return, capture_output=True, text=True, shell=shell)
            return result.stdout.strip()
        else:
            subprocess.run(cmd, check=check_return, shell=shell)
            return None
    except subprocess.CalledProcessError as e:
        if check_return:
            console.print(f"[red]Error running command:[/red] {' '.join(cmd)}")
            console.print(f"[red]Exit code:[/red] {e.returncode}")
            if hasattr(e, 'stderr') and e.stderr:
                console.print(f"[red]Error output:[/red] {e.stderr}")
            raise
        return None


def download_and_extract_template(project_path: Path, ai_assistant: str, script_type: str, is_current_dir: bool = False, *, verbose: bool = True, tracker: StepTracker | None = None, client: httpx.Client = None, debug: bool = False, github_token: str = None) -> Path:
    """Download the latest release and extract it to create a new project.
    Returns project_path. Uses tracker if provided (with keys: fetch, download, extract, cleanup)
    """
    current_dir = Path.cwd()

    if tracker:
        tracker.start("fetch", "contacting GitHub API")
    try:
        zip_path, meta = download_template_from_github(
            ai_assistant,
            current_dir,
            script_type=script_type,
            verbose=verbose and tracker is None,
            show_progress=(tracker is None),
            client=client,
            debug=debug,
            github_token=github_token
        )
        if tracker:
            tracker.complete("fetch", f"release {meta['release']} ({meta['size']:,} bytes)")
            tracker.add("download", "Download template")
            tracker.complete("download", meta['filename'])
    except Exception as e:
        if tracker:
            tracker.error("fetch", str(e))
        else:
            if verbose:
                console.print(f"[red]Error downloading template:[/red] {e}")
        raise

    if tracker:
        tracker.add("extract", "Extract template")
        tracker.start("extract")
    elif verbose:
        console.print("Extracting template...")

    try:
        if not is_current_dir:
            project_path.mkdir(parents=True)

        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_contents = zip_ref.namelist()
            if tracker:
                tracker.start("zip-list")
                tracker.complete("zip-list", f"{len(zip_contents)} entries")
            elif verbose:
                console.print(f"[cyan]ZIP contains {len(zip_contents)} items[/cyan]")

            if is_current_dir:
                with tempfile.TemporaryDirectory() as temp_dir:
                    temp_path = Path(temp_dir)
                    zip_ref.extractall(temp_path)

                    extracted_items = list(temp_path.iterdir())
                    if tracker:
                        tracker.start("extracted-summary")
                        tracker.complete("extracted-summary", f"{len(extracted_items)} items")
                    elif verbose:
                        console.print(f"[cyan]Extracted {len(extracted_items)} items to temp location[/cyan]")

                    source_dir = temp_path
                    if len(extracted_items) == 1 and extracted_items[0].is_dir():
                        source_dir = extracted_items[0]
                        if tracker:
                            tracker.add("flatten", "Flatten nested directory")
                            tracker.complete("flatten")
                        elif verbose:
                            console.print(f"[cyan]Found nested directory structure[/cyan]")

                    for item in source_dir.iterdir():
                        dest_path = project_path / item.name
                        if item.is_dir():
                            if dest_path.exists():
                                if verbose and not tracker:
                                    console.print(f"[yellow]Merging directory:[/yellow] {item.name}")
                                for sub_item in item.rglob('*'):
                                    if sub_item.is_file():
                                        rel_path = sub_item.relative_to(item)
                                        dest_file = dest_path / rel_path
                                        dest_file.parent.mkdir(parents=True, exist_ok=True)
                                        shutil.copy2(sub_item, dest_file)
                            else:
                                shutil.copytree(item, dest_path)
                        else:
                            if dest_path.exists() and verbose and not tracker:
                                console.print(f"[yellow]Overwriting file:[/yellow] {item.name}")
                            shutil.copy2(item, dest_path)
                    if verbose and not tracker:
                        console.print(f"[cyan]Template files merged into current directory[/cyan]")
            else:
                zip_ref.extractall(project_path)

                extracted_items = list(project_path.iterdir())
                if tracker:
                    tracker.start("extracted-summary")
                    tracker.complete("extracted-summary", f"{len(extracted_items)} top-level items")
                elif verbose:
                    console.print(f"[cyan]Extracted {len(extracted_items)} items to {project_path}:[/cyan]")
                    for item in extracted_items:
                        console.print(f"  - {item.name} ({'dir' if item.is_dir() else 'file'})")

                if len(extracted_items) == 1 and extracted_items[0].is_dir():
                    nested_dir = extracted_items[0]
                    temp_move_dir = project_path.parent / f"{project_path.name}_temp"

                    shutil.move(str(nested_dir), str(temp_move_dir))

                    project_path.rmdir()

                    shutil.move(str(temp_move_dir), str(project_path))
                    if tracker:
                        tracker.add("flatten", "Flatten nested directory")
                        tracker.complete("flatten")
                    elif verbose:
                        console.print(f"[cyan]Flattened nested directory structure[/cyan]")

    except Exception as e:
        if tracker:
            tracker.error("extract", str(e))
        else:
            if verbose:
                console.print(f"[red]Error extracting template:[/red] {e}")
                if debug:
                    console.print(Panel(str(e), title="Extraction Error", border_style="red"))

        if not is_current_dir and project_path.exists():
            shutil.rmtree(project_path)
        raise typer.Exit(1)
    else:
        if tracker:
            tracker.complete("extract")
    finally:
        if tracker:
            tracker.add("cleanup", "Remove temporary archive")

        if zip_path.exists():
            zip_path.unlink()
            if tracker:
                tracker.complete("cleanup")
            elif verbose:
                console.print(f"Cleaned up: {zip_path.name}")

    return project_path


def ensure_executable_scripts(project_path: Path, tracker: StepTracker | None = None) -> None:
    """Ensure POSIX .sh scripts under .blueprint/scripts (recursively) have execute bits (no-op on Windows)."""
    if os.name == "nt":
        return  # Windows: skip silently
    scripts_root = project_path / ".blueprint" / "scripts"
    if not scripts_root.is_dir():
        return
    failures: list[str] = []
    updated = 0
    for script in scripts_root.rglob("*.sh"):
        try:
            if script.is_symlink() or not script.is_file():
                continue
            try:
                with script.open("rb") as f:
                    if f.read(2) != b"#!":
                        continue
            except Exception:
                continue
            st = script.stat(); mode = st.st_mode
            if mode & 0o111:
                continue
            new_mode = mode
            if mode & 0o400: new_mode |= 0o100
            if mode & 0o040: new_mode |= 0o010
            if mode & 0o004: new_mode |= 0o001
            if not (new_mode & 0o100):
                new_mode |= 0o100
            os.chmod(script, new_mode)
            updated += 1
        except Exception as e:
            failures.append(f"{script.relative_to(scripts_root)}: {e}")
    if tracker:
        detail = f"{updated} updated" + (f", {len(failures)} failed" if failures else "")
        tracker.add("chmod", "Set script permissions recursively")
        (tracker.error if failures else tracker.complete)("chmod", detail)
    else:
        if updated:
            console.print(f"[cyan]Updated execute permissions on {updated} script(s) recursively[/cyan]")
        if failures:
            console.print("[yellow]Some scripts could not be updated:[/yellow]")
            for f in failures:
                console.print(f"  - {f}")


def generate_agent_commands_in_project(project_path: Path, agent: str, tracker: StepTracker = None):
    """
    Generate agent-specific command files in the project after initialization.
    
    Args:
        project_path: Path to the project directory
        agent: The selected AI agent
        tracker: Optional StepTracker to update with progress
    """
    import re
    import shutil
    from pathlib import Path
    
    # Define agent configurations - Updated for correct AI tool formats
    agents = {
        'claude': {'dir': '.claude/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'gemini': {'dir': '.gemini/commands', 'ext': 'toml', 'arg_format': '{{args}}', 'script_variants': ['sh', 'ps']},
        'copilot': {'dir': '.github/copilot-instructions', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'cursor-agent': {'dir': '.cursor/rules', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'qwen': {'dir': '.qwen/commands', 'ext': 'toml', 'arg_format': '{{args}}', 'script_variants': ['sh', 'ps']},
        'opencode': {'dir': '.opencode/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'windsurf': {'dir': '.windsurf/workflows', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'codex': {'dir': '.codex/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'kilocode': {'dir': '.kilocode/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'auggie': {'dir': '.augment/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'roo': {'dir': '.roo/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'codebuddy': {'dir': '.codebuddy/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'q': {'dir': '.amazonq/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
    }
    
    if agent not in agents:
        if tracker:
            tracker.error(f"agent-{agent}", f"Unsupported agent: {agent}")
        else:
            console.print(f"[red]Error:[/red] Unsupported agent: {agent}")
        return
    
    agent_config = agents[agent]
    
    # Get the template command files - use current working directory as primary method
    templates_commands_dir = Path.cwd() / "templates" / "commands"

    if not templates_commands_dir.exists():
        if tracker:
            tracker.error(f"agent-{agent}", f"Command templates not found at {templates_commands_dir}")
        else:
            console.print("[red]Error:[/red] Command templates not found")
            console.print(f"[yellow]Expected location:[/yellow] {templates_commands_dir}")
        return
    
    # Create the agent-specific directory
    agent_dir = project_path / agent_config['dir']
    agent_dir.mkdir(parents=True, exist_ok=True)

    if tracker:
        tracker.add(f"agent-{agent}", f"Generate {agent} commands")
        tracker.start(f"agent-{agent}", f"Creating {agent_config['dir']} directory")
    else:
        console.print(f"[cyan]Creating agent directory:[/cyan] {agent_config['dir']}")
        console.print(f"[cyan]Template directory found:[/cyan] {templates_commands_dir}")
    
    # Process each command template
    command_files = list(templates_commands_dir.glob('*.md'))
    for cmd_file in command_files:
        try:
            # Read the template
            content = cmd_file.read_text(encoding='utf-8')
            
            # Extract YAML frontmatter
            yaml_match = re.match(r'^---\n(.*?)\n---\n(.*)', content, re.DOTALL)
            if not yaml_match:
                continue  # Skip if invalid frontmatter
            
            yaml_content = yaml_match.group(1)
            body_content = yaml_match.group(2)
            
            # Parse description from YAML
            description_match = re.search(r'^description:\s*(.*)', yaml_content, re.MULTILINE)
            description = description_match.group(1).strip().strip('"') if description_match else ""
            
            # Extract scripts dictionary
            scripts_match = re.search(r'^scripts:\s*\n((?:\s+[a-z_]+:.*)+)', yaml_content, re.MULTILINE)
            scripts_dict = {}
            if scripts_match:
                script_content = scripts_match.group(1)
                for line in script_content.split('\n'):
                    line = line.strip()
                    if ':' in line:
                        key, value = line.split(':', 1)
                        scripts_dict[key.strip()] = value.strip().strip('"')
        
            # Process for each script variant
            for variant in agent_config['script_variants']:
                # Replace {SCRIPT} placeholder with the appropriate script command
                script_command = scripts_dict.get(variant, "(Missing script command)")
                replaced_content = body_content.replace('{SCRIPT}', script_command)
                
                # Replace {ARGS} placeholder with the appropriate argument format
                replaced_content = replaced_content.replace('{ARGS}', agent_config['arg_format'])
                
                # Replace $ARGUMENTS with the actual argument format
                replaced_content = replaced_content.replace('$ARGUMENTS', agent_config['arg_format'])
                
                # Apply path rewrites, being careful not to duplicate .blueprint prefixes
                # The original regex (/?memory/) would match both /memory/ and memory/, causing duplication
                # We should only match root paths that start with / but are not already prefixed with .blueprint/
                replaced_content = re.sub(r'(?<!\.blueprint)/(memory|scripts|templates)/', r'.blueprint/\1/', replaced_content)
                
                # Create the output file - use just the command name for slash command recognition
                output_filename = f"{cmd_file.stem}.{agent_config['ext']}"
                output_path = agent_dir / output_filename
                
                # For TOML files, wrap content in proper TOML structure
                if agent_config['ext'] == 'toml':
                    # Convert any backslashes to forward slashes to ensure
                    # AI agents can properly recognize and work with TOML files
                    desc_escaped = description.replace('\\\\', '/')
                    content_escaped = replaced_content.replace('\\\\', '/')
                    toml_content = f'description = "{desc_escaped}"\n\nprompt = """\n{content_escaped}\n"""'
                    output_path.write_text(toml_content, encoding='utf-8')
                else:
                    # Also fix backslashes in regular files for consistency
                    content_escaped = replaced_content.replace('\\\\', '/')
                    output_path.write_text(content_escaped, encoding='utf-8')
        
        except Exception as e:
            if tracker:
                tracker.error(f"cmd-{cmd_file.stem}", f"Error: {str(e)}")
            else:
                console.print(f"[red]Error processing {cmd_file}:[/red] {e}")
    
    if tracker:
        tracker.complete(f"agent-{agent}", f"Created {len(command_files)} commands for {agent}")
    else:
        console.print(f"[green]Created {len(command_files)} command files for {agent} agent in {agent_config['dir']}[/green]")
        console.print(f"[cyan]Debug:[/cyan] Agent directory: {agent_dir}")
        console.print(f"[cyan]Debug:[/cyan] Files created: {list(agent_dir.glob('*'))}")


def create_agent_specific_md_file(project_path: Path, agent: str, tracker: StepTracker = None):
    """
    Create an agent-specific MD file in the project root based on agent-file-template.md
    
    Args:
        project_path: Path to the project directory
        agent: The selected AI agent
        tracker: Optional StepTracker to update with progress
    """
    import importlib.resources
    import traceback
    from pathlib import Path
    
    try:
        # Get the agent file template - use current working directory
        templates_root_dir = Path.cwd() / "templates"

        if not templates_root_dir.exists():
            error_msg = f"Templates not found at {templates_root_dir}"
            print(f"DEBUG: {error_msg}")
            if tracker:
                tracker.error(f"agent-md-{agent}", error_msg)
            return

        # Read the agent template
        agent_template_path = templates_root_dir / "agent-file-template.md"
        if not agent_template_path.exists():
            error_msg = f"Agent template not found: {agent_template_path}"
            print(f"DEBUG: {error_msg}")
            if tracker:
                tracker.error(f"agent-md-{agent}", error_msg)
            return

        print(f"DEBUG: Reading template from {agent_template_path}")
        template_content = agent_template_path.read_text(encoding='utf-8')
        print(f"DEBUG: Template content length: {len(template_content)}")

        # Create agent-specific filename based on agent name
        # Map agent names to appropriate file names
        agent_name_mapping = {
            'qwen': 'QWEN.md',
            'kilocode': 'KILO.md',
            'claude': 'CLAUDE.md',
            'gemini': 'GEMINI.md',
            'copilot': 'COPILOT.md',
            'cursor-agent': 'CURSOR.md',
            'opencode': 'OPENCODE.md',
            'codex': 'CODEX.md',
            'windsurf': 'WINDSURF.md',
            'auggie': 'AUGGIE.md',
            'roo': 'ROO.md',
            'codebuddy': 'CODEBUDDY.md',
            'q': 'Q.md',
        }

        # Use the mapping or default to a generic format based on agent name
        filename = agent_name_mapping.get(agent, f"{agent.upper()}.md")
        print(f"DEBUG: Creating file {filename} for agent {agent}")

        # Create the agent-specific MD file in the project root
        output_path = project_path / filename
        print(f"DEBUG: Writing file to {output_path}")
        output_path.write_text(template_content, encoding='utf-8')
        print(f"DEBUG: Successfully wrote file {output_path}")

        success_msg = f"Created {filename} with agent-specific configuration in project root"
        if tracker:
            tracker.add(f"agent-md-{agent}", f"Create {filename} file")
            tracker.complete(f"agent-md-{agent}", f"Created {filename} in project root")

    except Exception as e:
        error_msg = f"Error: {str(e)}\nTraceback: {traceback.format_exc()}"
        print(f"DEBUG: {error_msg}")
        if tracker:
            tracker.error(f"agent-md-{agent}", error_msg)


def init(
    project_name: str = typer.Argument(None, help="Name for your new project directory (optional if using --here, or use '.' for current directory)"),
    ai_assistant: str = typer.Option(None, "--ai", help="AI assistant to use: claude, gemini, copilot, cursor-agent, qwen, opencode, codex, windsurf, kilocode, auggie, codebuddy, or q"),
    script_type: str = typer.Option(None, "--script", help="Script type to use: sh or ps"),
    ignore_agent_tools: bool = typer.Option(False, "--ignore-agent-tools", help="Skip checks for AI agent tools like Claude Code"),
    no_git: bool = typer.Option(False, "--no-git", help="Skip git repository initialization"),
    here: bool = typer.Option(False, "--here", help="Initialize project in the current directory instead of creating a new one"),
    force: bool = typer.Option(False, "--force", help="Force merge/overwrite when using --here (skip confirmation)"),
    skip_tls: bool = typer.Option(False, "--skip-tls", help="Skip SSL/TLS verification (not recommended)"),
    debug: bool = typer.Option(False, "--debug", help="Show verbose diagnostic output for network and extraction failures"),
    github_token: str = typer.Option(None, "--github-token", help="GitHub token to use for API requests (or set GH_TOKEN or GITHUB_TOKEN environment variable)"),
):
    """
    Initialize a new Blueprint-Kit project from the latest template.
    
    This command will:
    1. Check that required tools are installed (git is optional)
    2. Let you choose your AI assistant
    3. Download the appropriate template from GitHub
    4. Extract the template to a new project directory or current directory
    5. Initialize a fresh git repository (if not --no-git and no existing repo)
    6. Optionally set up AI assistant commands
    
    Examples:
        blueprint init my-project
        blueprint init my-project --ai claude
        blueprint init my-project --ai copilot --no-git
        blueprint init --ignore-agent-tools my-project
        blueprint init . --ai claude         # Initialize in current directory
        blueprint init .                     # Initialize in current directory (interactive AI selection)
        blueprint init --here --ai claude    # Alternative syntax for current directory
        blueprint init --here --ai codex
        blueprint init --here --ai codebuddy
        blueprint init --here
        blueprint init --here --force  # Skip confirmation when current directory not empty
    """

    show_banner()

    if project_name == ".":
        here = True
        project_name = None  # Clear project_name to use existing validation logic

    if here and project_name:
        console.print("[red]Error:[/red] Cannot specify both project name and --here flag")
        raise typer.Exit(1)

    if not here and not project_name:
        console.print("[red]Error:[/red] Must specify either a project name, use '.' for current directory, or use --here flag")
        raise typer.Exit(1)

    if here:
        project_name = Path.cwd().name
        project_path = Path.cwd()

        existing_items = list(project_path.iterdir())
        if existing_items:
            console.print(f"[yellow]Warning:[/yellow] Current directory is not empty ({len(existing_items)} items)")
            console.print("[yellow]Template files will be merged with existing content and may overwrite existing files[/yellow]")
            if force:
                console.print("[cyan]--force supplied: skipping confirmation and proceeding with merge[/cyan]")
            else:
                response = typer.confirm("Do you want to continue?")
                if not response:
                    console.print("[yellow]Operation cancelled[/yellow]")
                    raise typer.Exit(0)
    else:
        project_path = Path(project_name).resolve()
        if project_path.exists():
            error_panel = Panel(
                f"Directory '[cyan]{project_name}[/cyan]' already exists\n"
                "Please choose a different project name or remove the existing directory.",
                title="[red]Directory Conflict[/red]",
                border_style="red",
                padding=(1, 2)
            )
            console.print()
            console.print(error_panel)
            raise typer.Exit(1)

    current_dir = Path.cwd()

    setup_lines = [
        "[cyan]Blueprint-Kit Project Setup[/cyan]",
        "",
        f"{'Project':<15} [green]{project_path.name}[/green]",
        f"{'Working Path':<15} [dim]{current_dir}[/dim]",
    ]

    if not here:
        setup_lines.append(f"{'Target Path':<15} [dim]{project_path}[/dim]")

    console.print(Panel("\n".join(setup_lines), border_style="cyan", padding=(1, 2)))

    should_init_git = False
    if not no_git:
        should_init_git = check_tool("git")
        if not should_init_git:
            console.print("[yellow]Git not found - will skip repository initialization[/yellow]")

    if ai_assistant:
        if ai_assistant not in AGENT_CONFIG:
            console.print(f"[red]Error:[/red] Invalid AI assistant '{ai_assistant}'. Choose from: {', '.join(AGENT_CONFIG.keys())}")
            raise typer.Exit(1)
        selected_ai = ai_assistant
    else:
        # Create options dict for selection (agent_key: display_name)
        ai_choices = {key: config["name"] for key, config in AGENT_CONFIG.items()}
        selected_ai = select_with_arrows(
            ai_choices, 
            "Choose your AI assistant:", 
            "copilot"
        )

    if not ignore_agent_tools:
        agent_config = AGENT_CONFIG.get(selected_ai)
        if agent_config and agent_config["requires_cli"]:
            install_url = agent_config["install_url"]
            if not check_tool(selected_ai):
                error_panel = Panel(
                    f"[cyan]{selected_ai}[/cyan] not found\n"
                    f"Install from: [cyan]{install_url}[/cyan]\n"
                    f"{agent_config['name']} is required to continue with this project type.\n\n"
                    "Tip: Use [cyan]--ignore-agent-tools[/cyan] to skip this check",
                    title="[red]Agent Detection Error[/red]",
                    border_style="red",
                    padding=(1, 2)
                )
                console.print()
                console.print(error_panel)
                raise typer.Exit(1)

    if script_type:
        if script_type not in SCRIPT_TYPE_CHOICES:
            console.print(f"[red]Error:[/red] Invalid script type '{script_type}'. Choose from: {', '.join(SCRIPT_TYPE_CHOICES.keys())}")
            raise typer.Exit(1)
        selected_script = script_type
    else:
        default_script = "ps" if os.name == "nt" else "sh"

        if sys.stdin.isatty():
            selected_script = select_with_arrows(SCRIPT_TYPE_CHOICES, "Choose script type (or press Enter)", default_script)
        else:
            selected_script = default_script

    console.print(f"[cyan]Selected AI assistant:[/cyan] {selected_ai}")
    console.print(f"[cyan]Selected script type:[/cyan] {selected_script}")

    tracker = StepTracker("Initialize Blueprint-Kit Project")

    sys._specify_tracker_active = True

    tracker.add("precheck", "Check required tools")
    tracker.complete("precheck", "ok")
    tracker.add("ai-select", "Select AI assistant")
    tracker.complete("ai-select", f"{selected_ai}")
    tracker.add("script-select", "Select script type")
    tracker.complete("script-select", selected_script)
    for key, label in [
        ("fetch", "Fetch latest release"),
        ("download", "Download template"),
        ("extract", "Extract template"),
        ("zip-list", "Archive contents"),
        ("extracted-summary", "Extraction summary"),
        ("chmod", "Ensure scripts executable"),
        ("cleanup", "Cleanup"),
        ("git", "Initialize git repository"),
        ("final", "Finalize")
    ]:
        tracker.add(key, label)

    # Track git error message outside Live context so it persists
    git_error_message = None

    with Live(tracker.render(), console=console, refresh_per_second=8, transient=True) as live:
        tracker.attach_refresh(lambda: live.update(tracker.render()))
        try:
            verify = not skip_tls
            local_ssl_context = ssl_context if verify else False
            local_client = httpx.Client(verify=local_ssl_context)

            download_and_extract_template(project_path, selected_ai, selected_script, here, verbose=False, tracker=tracker, client=local_client, debug=debug, github_token=github_token)

            # Generate agent-specific command files for the selected AI assistant
            console.print(f"[cyan]Debug:[/cyan] About to generate agent commands for {selected_ai}")
            try:
                generate_agent_commands_in_project(project_path, selected_ai, tracker=tracker)
                console.print(f"[green]Debug:[/green] Agent command generation completed for {selected_ai}")
            except Exception as e:
                print(f"ERROR in generate_agent_commands_in_project: {e}")
                import traceback
                traceback.print_exc()
                raise  # Re-raise to maintain original behavior

            # Create agent-specific MD file for the selected AI assistant
            print(f"DEBUG: About to create agent-specific MD file for {selected_ai}")
            try:
                create_agent_specific_md_file(project_path, selected_ai, tracker=tracker)
                print(f"DEBUG: Agent-specific MD file creation completed for {selected_ai}")
            except Exception as e:
                print(f"ERROR in create_agent_specific_md_file: {e}")
                import traceback
                traceback.print_exc()
                raise  # Re-raise to maintain original behavior

            ensure_executable_scripts(project_path, tracker=tracker)
            console.print(f"[cyan]Debug:[/cyan] Executable scripts step completed")

            if not no_git:
                tracker.start("git")
                if is_git_repo(project_path):
                    tracker.complete("git", "existing repo detected")
                elif should_init_git:
                    success, error_msg = init_git_repo(project_path, quiet=True)
                    if success:
                        tracker.complete("git", "initialized")
                    else:
                        tracker.error("git", "init failed")
                        git_error_message = error_msg
                else:
                    tracker.skip("git", "git not available")
            else:
                tracker.skip("git", "--no-git flag")

            tracker.complete("final", "project ready")
        except Exception as e:
            tracker.error("final", str(e))
            console.print(Panel(f"Initialization failed: {e}", title="Failure", border_style="red"))
            if debug:
                _env_pairs = [
                    ("Python", sys.version.split()[0]),
                    ("Platform", sys.platform),
                    ("CWD", str(Path.cwd())),
                ]
                _label_width = max(len(k) for k, _ in _env_pairs)
                env_lines = [f"{k.ljust(_label_width)} → [bright_black]{v}[/bright_black]" for k, v in _env_pairs]
                console.print(Panel("\n".join(env_lines), title="Debug Environment", border_style="magenta"))
            if not here and project_path.exists():
                shutil.rmtree(project_path)
            raise typer.Exit(1)
        finally:
            pass

    console.print(tracker.render())
    console.print("\n[bold green]Project ready.[/bold green]")
    
    # Show git error details if initialization failed
    if git_error_message:
        console.print()
        git_error_panel = Panel(
            f"[yellow]Warning:[/yellow] Git repository initialization failed\n\n"
            f"{git_error_message}\n\n"
            f"[dim]You can initialize git manually later with:\n"
            f"[cyan]cd {project_path if not here else '.'}[/cyan]\n"
            f"[cyan]git init[/cyan]\n"
            f"[cyan]git add .[/cyan]\n"
            f"[cyan]git commit -m \"Initial commit\"[/cyan]",
            title="[red]Git Initialization Failed[/red]",
            border_style="red",
            padding=(1, 2)
        )
        console.print(git_error_panel)

    # Agent folder security notice
    agent_config = AGENT_CONFIG.get(selected_ai)
    if agent_config:
        agent_folder = agent_config["folder"]
        security_notice = Panel(
            f"Some agents may store credentials, auth tokens, or other identifying and private artifacts in the agent folder within your project.\n"
            f"Consider adding [cyan]{agent_folder}[/cyan] (or parts of it) to [cyan].gitignore[/cyan] to prevent accidental credential leakage.",
            title="[yellow]Agent Folder Security[/yellow]",
            border_style="yellow",
            padding=(1, 2)
        )
        console.print()
        console.print(security_notice)

    steps_lines = []
    if not here:
        steps_lines.append(f"1. Go to the project folder: [cyan]cd {project_name}[/cyan]")
        step_num = 2
    else:
        steps_lines.append("1. You're already in the project directory!")
        step_num = 2

    # Add Codex-specific setup step if needed
    if selected_ai == "codex":
        codex_path = project_path / ".codex"
        quoted_path = shlex.quote(str(codex_path))
        if os.name == "nt":  # Windows
            cmd = f"setx CODEX_HOME {quoted_path}"
        else:  # Unix-like systems
            cmd = f"export CODEX_HOME={quoted_path}"
        
        steps_lines.append(f"{step_num}. Set [cyan]CODEX_HOME[/cyan] environment variable before running Codex: [cyan]{cmd}[/cyan]")
        step_num += 1

    steps_lines.append(f"{step_num}. Start using slash commands with your AI agent:")

    steps_lines.append("   2.1 [cyan]/constitution[/] - Establish project principles")
    steps_lines.append("   2.2 [cyan]/specify[/] - Create baseline specification")
    steps_lines.append("   2.3 [cyan]/goal[/] - Define measurable goals")
    steps_lines.append("   2.4 [cyan]/blueprint[/] - Create architectural blueprints")
    steps_lines.append("   2.5 [cyan]/plan[/] - Create implementation plan")
    steps_lines.append("   2.6 [cyan]/tasks[/] - Generate actionable tasks")
    steps_lines.append("   2.7 [cyan]/implement[/] - Execute implementation")

    steps_lines.append("\n[cyan]Note: These slash commands are available in your project after initialization[/cyan]")
    steps_lines.append("[cyan]and are recognized by supported AI agents when working in the project directory.[/cyan]")

    steps_panel = Panel("\n".join(steps_lines), title="Next Steps", border_style="cyan", padding=(1,2))
    console.print()
    console.print(steps_panel)

    enhancement_lines = [
        "Optional commands that you can use for your specs [bright_black](improve quality & confidence)[/bright_black]",
        "",
        f"○ [cyan]/clarify[/] [bright_black](optional)[/bright_black] - Ask structured questions to de-risk ambiguous areas before planning (run before [cyan]/plan[/] if used)",
        f"○ [cyan]/analyze[/] [bright_black](optional)[/bright_black] - Cross-artifact consistency & alignment report (after [cyan]/tasks[/], before [cyan]/implement[/])",
        f"○ [cyan]/checklist[/] [bright_black](optional)[/bright_black] - Generate quality checklists to validate requirements completeness, clarity, and consistency (after [cyan]/plan[/])"
    ]
    enhancements_panel = Panel("\n".join(enhancement_lines), title="Enhancement Commands", border_style="cyan", padding=(1,2))
    console.print()
    console.print(enhancements_panel)