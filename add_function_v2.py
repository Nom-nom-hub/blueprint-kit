# Script to add our function to the CLI

with open('src/blueprint_cli/__init__.py', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Find the exact location before @app.command() for init function
insert_idx = -1
for i, line in enumerate(lines):
    if '@app.command()' in line and i + 1 < len(lines) and 'def init(' in lines[i + 1]:
        insert_idx = i
        break

if insert_idx != -1:
    print(f'Found insertion point at line {insert_idx}')
    
    # Define our function as a series of lines
    function_code = '''def generate_agent_commands_in_project(project_path: Path, agent: str, tracker: StepTracker = None):
    """Generate agent-specific command files in the project after initialization."""
    import re
    from pathlib import Path

    # Define agent configurations
    agents = {
        'claude': {'dir': '.claude/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'gemini': {'dir': '.gemini/commands', 'ext': 'toml', 'arg_format': '{{args}}', 'script_variants': ['sh', 'ps']},
        'copilot': {'dir': '.github/prompts', 'ext': 'prompt.md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'cursor-agent': {'dir': '.cursor/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'qwen': {'dir': '.qwen/commands', 'ext': 'toml', 'arg_format': '{{args}}', 'script_variants': ['sh', 'ps']},
        'opencode': {'dir': '.opencode/command', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'windsurf': {'dir': '.windsurf/workflows', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'codex': {'dir': '.codex/prompts', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'kilocode': {'dir': '.kilocode/workflows', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'auggie': {'dir': '.augment/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'roo': {'dir': '.roo/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'codebuddy': {'dir': '.codebuddy/commands', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
        'q': {'dir': '.amazonq/prompts', 'ext': 'md', 'arg_format': '$ARGUMENTS', 'script_variants': ['sh', 'ps']},
    }

    if agent not in agents:
        if tracker:
            tracker.error(f"agent-{agent}", f"Unsupported agent: {agent}")
        else:
            console.print(f"[red]Error:[/red] Unsupported agent: {agent}")
        return

    agent_config = agents[agent]

    # Get the template command files from the project
    templates_commands_dir = project_path / ".blueprint" / "templates" / "commands"
    if not templates_commands_dir.exists():
        # Fallback: try relative to current file location
        cli_dir = Path(__file__).parent
        templates_commands_dir = cli_dir.parent.parent / "templates" / "commands"

        if not templates_commands_dir.exists():
            if tracker:
                tracker.error(f"agent-{agent}", "Command templates not found")
            else:
                console.print("[red]Error:[/red] Command templates not found")
            return

    # Create the agent-specific directory
    agent_dir = project_path / agent_config["dir"]
    agent_dir.mkdir(parents=True, exist_ok=True)

    if tracker:
        tracker.add(f"agent-{agent}", f"Generate {agent} commands")
        tracker.start(f"agent-{agent}", f"Creating {agent_config["dir"]} directory")

    # Process each command template
    command_files = list(templates_commands_dir.glob("*.md"))
    for cmd_file in command_files:
        try:
            # Read the template
            content = cmd_file.read_text(encoding="utf-8")

            # Extract YAML frontmatter
            yaml_match = re.match(r"^---\n(.*?)\n---\n(.*)", content, re.DOTALL)
            if not yaml_match:
                continue  # Skip if invalid frontmatter

            yaml_content = yaml_match.group(1)
            body_content = yaml_match.group(2)

            # Parse description from YAML
            description_match = re.search(r"^description:\s*(.*)$", yaml_content, re.MULTILINE)
            description = description_match.group(1).strip().strip('"') if description_match else ""

            # Extract scripts dictionary
            scripts_match = re.search(r"^scripts:\s*\n((?:\s+[a-z_]+:.*)+)", yaml_content, re.MULTILINE)
            scripts_dict = {}
            if scripts_match:
                script_content = scripts_match.group(1)
                for line in script_content.split("\n"):
                    line = line.strip()
                    if ":" in line:
                        key, value = line.split(":", 1)
                        scripts_dict[key.strip()] = value.strip().strip('"')

            # Process for each script variant
            for variant in agent_config["script_variants"]:
                # Replace {SCRIPT} placeholder with the appropriate script command
                script_command = scripts_dict.get(variant, "(Missing script command)")
                replaced_content = body_content.replace("{SCRIPT}", script_command)

                # Replace {ARGS} placeholder with the appropriate argument format
                replaced_content = replaced_content.replace("{ARGS}", agent_config["arg_format"])

                # Replace $ARGUMENTS with the actual argument format
                replaced_content = replaced_content.replace("$ARGUMENTS", agent_config["arg_format"])

                # Apply path rewrites (change paths to use .blueprint instead of /)
                replaced_content = re.sub(r"(/?)memory/", r".blueprint/memory/", replaced_content)
                replaced_content = re.sub(r"(/?)scripts/", r".blueprint/scripts/", replaced_content)
                replaced_content = re.sub(r"(/?)templates/", r".blueprint/templates/", replaced_content)

                # Create the output file
                output_filename = f"blueprintkit.{cmd_file.stem}.{agent_config["ext"]}"
                output_path = agent_dir / output_filename

                # For TOML files, wrap content in proper TOML structure
                if agent_config["ext"] == "toml":
                    toml_content = f"description = \"\"\"{description}\"\"\"\n\nprompt = \"\"\"{replaced_content}\"\"\""
                    output_path.write_text(toml_content, encoding="utf-8")
                else:
                    output_path.write_text(replaced_content, encoding="utf-8")

        except Exception as e:
            if tracker:
                tracker.error(f"cmd-{cmd_file.stem}", f"Error: {str(e)}")
            else:
                console.print(f"[red]Error processing {cmd_file}:[/red] {e}")

    if tracker:
        tracker.complete(f"agent-{agent}", f"Created {len(command_files)} commands for {agent}")
    else:
        console.print(f"[green]Created {len(command_files)} command files for {agent} agent in {agent_config["dir"]}[/green]")


'''

    # Split the function code into lines and insert at the correct position
    function_lines = function_code.split('\n')
    
    # Insert the function lines at the correct position
    for line in reversed(function_lines):  # Insert in reverse to maintain order
        if line.strip():  # Only insert non-empty lines
            lines.insert(insert_idx, line + '\n')
    
    # Write the updated content back
    with open('src/blueprint_cli/__init__.py', 'w', encoding='utf-8') as f:
        f.writelines(lines)
    
    print('Successfully added the function at the correct location')
else:
    print('Could not find the insertion point')