"""Check command implementation for the Blueprint-Kit CLI."""

import typer
from rich.console import Console
from rich.panel import Panel

from ..core.step_tracker import StepTracker
from ..core.agent_config import AGENT_CONFIG
from ..core.cli import BANNER, TAGLINE
from ..services.git import check_tool


console = Console()


def show_banner():
    """Display the ASCII art banner."""
    from rich.text import Text
    from rich.align import Align

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


def check():
    """Check that all required tools are installed."""
    show_banner()
    console.print("[bold]Checking for installed tools...[/bold]\n")

    tracker = StepTracker("Check Available Tools")

    tracker.add("git", "Git version control")
    git_ok = check_tool("git", tracker=tracker)
    
    agent_results = {}
    for agent_key, agent_config in AGENT_CONFIG.items():
        agent_name = agent_config["name"]
        
        tracker.add(agent_key, agent_name)
        agent_results[agent_key] = check_tool(agent_key, tracker=tracker)
    
    # Check VS Code variants (not in agent config)
    tracker.add("code", "Visual Studio Code")
    code_ok = check_tool("code", tracker=tracker)
    
    tracker.add("code-insiders", "Visual Studio Code Insiders")
    code_insiders_ok = check_tool("code-insiders", tracker=tracker)

    console.print(tracker.render())

    console.print("\n[bold green]Blueprint-Kit CLI is ready to use![/bold green]")

    if not git_ok:
        console.print("[dim]Tip: Install git for repository management[/dim]")

    if not any(agent_results.values()):
        console.print("[dim]Tip: Install an AI assistant for the best experience[/dim]")