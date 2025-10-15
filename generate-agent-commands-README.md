# Agent Command Generator for Blueprint Kit

This script generates agent-specific command files for CLI agents in Blueprint Kit projects, enabling slash commands like `/blueprintkit.specify`, `/blueprintkit.goal`, etc.

## Purpose

When you initialize a project with the Blueprint CLI (`blueprint init`), agent-specific command files are automatically created. However, if you're working in an existing project that wasn't initialized with Blueprint CLI, or if you need to regenerate these files, this script will create the necessary command directories and files.

## Prerequisites

- Python 3.7+
- A Blueprint Kit project with the `templates/commands/` directory containing command templates

## Usage

1. Copy the `generate-agent-commands.py` script to your project directory

2. Ensure your project has a `templates/commands/` directory with the command templates (analyze.md, blueprint.md, checklist.md, clarify.md, constitution.md, goal.md, implement.md, plan.md, specify.md, tasks.md)

3. Run the script:
   ```bash
   python generate-agent-commands.py
   ```

   Or specify specific agents:
   ```bash
   python generate-agent-commands.py --agents claude
   ```

   Multiple agents:
   ```bash
   python generate-agent-commands.py --agents claude cursor-agent gemini
   ```

## Supported Agents

The script supports all agents that Blueprint Kit supports:
- `claude` - Claude Code
- `gemini` - Gemini CLI
- `copilot` - GitHub Copilot
- `cursor-agent` - Cursor
- `qwen` - Qwen Code
- `opencode` - opencode
- `windsurf` - Windsurf
- `codex` - Codex CLI
- `kilocode` - Kilo Code
- `auggie` - Auggie CLI
- `roo` - Roo Code
- `codebuddy` - CodeBuddy
- `q` - Amazon Q Developer CLI

## What Gets Created

For each agent you choose, the script will create:
- The appropriate agent directory (e.g., `.claude/commands/`)
- Agent-specific command files (e.g., `blueprintkit.constitution.md`, `blueprintkit.specify.md`, etc.)
- Properly formatted content with correct argument placeholders for each agent

## Example

To generate command files for Claude and Cursor only:
```bash
python generate-agent-commands.py --agents claude cursor-agent
```

This will create:
- `.claude/commands/blueprintkit.*.md` files
- `.cursor/commands/blueprintkit.*.md` files

## After Running

Once the command files are created, your CLI agents will recognize Blueprint Kit slash commands when working in your project directory.