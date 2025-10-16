"""Git service for the Blueprint-Kit CLI."""

import subprocess
import shutil
from pathlib import Path
from typing import Tuple


def check_tool(tool: str, tracker: 'StepTracker' = None) -> bool:
    """Check if a tool is installed. Optionally update tracker.
    
    Args:
        tool: Name of the tool to check
        tracker: Optional StepTracker to update with results
        
    Returns:
        True if tool is found, False otherwise
    """
    from ..core.agent_config import AGENT_CONFIG  # Import here to avoid circular dependencies
    CLAUDE_LOCAL_PATH = Path.home() / ".claude" / "local" / "claude"
    
    # Special handling for Claude CLI after `claude migrate-installer`
    # See: https://github.com/nom-nom-hub/spec-kit/issues/123
    # The migrate-installer command REMOVES the original executable from PATH
    # and creates an alias at ~/.claude/local/claude instead
    # This path should be prioritized over other claude executables in PATH
    if tool == "claude":
        if CLAUDE_LOCAL_PATH.exists() and CLAUDE_LOCAL_PATH.is_file():
            if tracker:
                tracker.complete(tool, "available")
            return True
    
    found = shutil.which(tool) is not None
    
    if tracker:
        if found:
            tracker.complete(tool, "available")
        else:
            tracker.error(tool, "not found")
    
    return found


def is_git_repo(path: Path = None) -> bool:
    """Check if the specified path is inside a git repository."""
    if path is None:
        path = Path.cwd()
    
    if not path.is_dir():
        return False

    try:
        # Use git command to check if inside a work tree
        subprocess.run(
            ["git", "rev-parse", "--is-inside-work-tree"],
            check=True,
            capture_output=True,
            cwd=path,
        )
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False


def init_git_repo(project_path: Path, quiet: bool = False) -> Tuple[bool, str | None]:
    """Initialize a git repository in the specified path.
    
    Args:
        project_path: Path to initialize git repository in
        quiet: if True suppress console output (tracker handles status)
        
    Returns:
        Tuple of (success: bool, error_message: str | None)
    """
    try:
        original_cwd = Path.cwd()
        import os
        os.chdir(project_path)
        if not quiet:
            from rich.console import Console
            console = Console()
            console.print("[cyan]Initializing git repository...[/cyan]")
        subprocess.run(["git", "init"], check=True, capture_output=True, text=True)
        subprocess.run(["git", "add", "."], check=True, capture_output=True, text=True)
        subprocess.run(["git", "commit", "-m", "Initial commit from Blueprint-Kit template"], check=True, capture_output=True, text=True)
        if not quiet:
            from rich.console import Console
            console = Console()
            console.print("[green]✓[/green] Git repository initialized")
        return True, None

    except subprocess.CalledProcessError as e:
        error_msg = f"Command: {' '.join(e.cmd)}\nExit code: {e.returncode}"
        if e.stderr:
            error_msg += f"\nError: {e.stderr.strip()}"
        elif e.stdout:
            error_msg += f"\nOutput: {e.stdout.strip()}"
        
        if not quiet:
            from rich.console import Console
            console = Console()
            console.print(f"[red]Error initializing git repository:[/red] {e}")
        return False, error_msg
    finally:
        import os
        os.chdir(original_cwd)