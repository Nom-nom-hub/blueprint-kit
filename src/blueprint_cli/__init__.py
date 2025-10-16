#!/usr/bin/env python3
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "typer",
#     "rich",
#     "platformdirs",
#     "readchar",
#     "httpx",
# ]
# ///

"""
Blueprint Kit CLI - Setup tool for Blueprint-Kit projects

Usage:
    uvx blueprint-cli.py init <project-name>
    uvx blueprint-cli.py init .
    uvx blueprint-cli.py init --here

Or install globally:
    uv tool install --from blueprint-cli.py blueprint-cli
    blueprint init <project-name>
    blueprint init .
    blueprint init --here
"""

import sys
import typer
from rich.console import Console
from rich.align import Align
from typer.core import TyperGroup

from .core.cli import BANNER, TAGLINE
from .commands.init import init
from .commands.check import check, show_banner


class BannerGroup(TyperGroup):
    """Custom group that shows banner before help."""

    def format_help(self, ctx, formatter):
        # Show banner before help
        show_banner()
        super().format_help(ctx, formatter)


# Create the main Typer application
app = typer.Typer(
    name="blueprint",
    help="Setup tool for Blueprint-Kit blueprint-driven development projects",
    add_completion=False,
    invoke_without_command=True,
    cls=BannerGroup,
)


@app.callback()
def callback(ctx: typer.Context):
    """Show banner when no subcommand is provided."""
    if ctx.invoked_subcommand is None and "--help" not in sys.argv and "-h" not in sys.argv:
        show_banner()
        console = Console()
        console.print(Align.center("[dim]Run 'blueprint --help' for usage information[/dim]"))
        console.print()


# Register the commands with the app
app.command()(init)
app.command()(check)


def main():
    app()


if __name__ == "__main__":
    main()