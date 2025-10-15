# Adding Blueprint Kit Slash Commands to Your Project

If you're working in an existing project and want to use Blueprint Kit's slash commands (like `/blueprintkit.specify`, `/blueprintkit.goal`, etc.), follow these steps:

## Step 1: Get the Command Generator Script

Copy the `generate-agent-commands.py` script to your project directory.

## Step 2: Ensure You Have Command Templates

Make sure your project has a `templates/commands/` directory with the following files:
- analyze.md
- blueprint.md
- checklist.md
- clarify.md
- constitution.md
- goal.md
- implement.md
- plan.md
- specify.md
- tasks.md

If you don't have these files, you can copy them from the Blueprint Kit repository.

## Step 3: Generate Agent Commands

Run the script to generate the command files for your specific agent:

For Claude only:
```
python generate-agent-commands.py --agents claude
```

For Cursor only:
```
python generate-agent-commands.py --agents cursor-agent
```

For multiple agents:
```
python generate-agent-commands.py --agents claude cursor-agent
```

For all supported agents:
```
python generate-agent-commands.py
```

## Step 4: Use the Slash Commands

After running the script, your CLI agent will recognize the Blueprint Kit slash commands:
- `/blueprintkit.constitution` - Establish project principles
- `/blueprintkit.specify` - Create baseline specification
- `/blueprintkit.goal` - Define measurable goals
- `/blueprintkit.blueprint` - Create architectural blueprints
- `/blueprintkit.plan` - Create implementation plan
- `/blueprintkit.tasks` - Generate actionable tasks
- `/blueprintkit.implement` - Execute implementation

## Supported Agents

The script supports:
- Claude Code (`claude`)
- Cursor (`cursor-agent`)
- Gemini CLI (`gemini`)
- Qwen Code (`qwen`)
- GitHub Copilot (`copilot`)
- And many others (see full list in the documentation)

## Notes

- This script creates agent-specific command files in the appropriate directories (like `.claude/commands/` or `.cursor/commands/`)
- The slash commands will only work when you're working in the project directory where the command files were created
- Only generate command files for the agents you actually use to keep your project clean