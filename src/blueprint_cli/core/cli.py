"""CLI utilities for the Blueprint CLI."""

import os
import shlex
from pathlib import Path


SCRIPT_TYPE_CHOICES = {"sh": "POSIX Shell (bash/zsh)", "ps": "PowerShell"}

CLAUDE_LOCAL_PATH = Path.home() / ".claude" / "local" / "claude"

BANNER = """
===============================================================================
                              BLUEPRINT CLI

+----------------------------------------------------------------------------+
|                                                                            |
| BBBBBBB   L        U   U   EEEEEEE  PPPPPP   RRRRRR   IIIII NN  NN TTTTTTT |
| BB    BB  L        U   U   EE       PP   PP  RR   RR   III  NNN NN   TTT   |
| BBBBBBB   L        U   U   EEEEE    PPPPPP   RRRRRR    III  NN NNN   TTT   |
| BB    BB  L        U   U   EE       PP       RR  RR    III  NN  NN   TTT   |
| BBBBBBB   LLLLLLL   UUU    EEEEEEE  PP       RR   RR  IIIII NN  NN   TTT   |
|                                                                            |
+----------------------------------------------------------------------------+

===============================================================================
"""

TAGLINE = "Blueprint-Kit - Blueprint-Driven Development Toolkit"