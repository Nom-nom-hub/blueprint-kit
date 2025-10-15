#!/usr/bin/env python3
"""
Script to generate agent-specific command files for CLI agents in Blueprint Kit projects.

This script creates agent-specific command directories and files that allow CLI agents 
to recognize and use Blueprint Kit slash commands like /blueprintkit.specify, 
/blueprintkit.goal, etc.

Usage:
    python generate-agent-commands.py                    # Generate for all agents
    python generate-agent-commands.py --agents claude   # Generate for specific agent
    python generate-agent-commands.py --agents claude cursor-agent qwen  # Multiple agents
"""

import os
import re
import sys
import argparse
import shutil
from pathlib import Path
from typing import Dict, List, Tuple

def read_command_template(template_path: Path) -> Tuple[str, str, Dict[str, str]]:
    """
    Read a command template file and extract YAML frontmatter and content.
    
    Returns:
        (description, content, scripts_dict)
    """
    content = template_path.read_text(encoding='utf-8')
    
    # Extract YAML frontmatter
    yaml_match = re.match(r'^---\n(.*?)\n---\n(.*)', content, re.DOTALL)
    if not yaml_match:
        raise ValueError(f"Invalid YAML frontmatter in {template_path}")
    
    yaml_content = yaml_match.group(1)
    body_content = yaml_match.group(2)
    
    # Parse description and scripts from YAML
    description_match = re.search(r'^description:\s*(.*)$', yaml_content, re.MULTILINE)
    description = description_match.group(1).strip().strip('"\'') if description_match else ""
    
    # Extract scripts dictionary
    scripts_match = re.search(r'^scripts:\s*\n((?:\s+[a-z_]+:.*)+)', yaml_content, re.MULTILINE)
    scripts_dict = {}
    if scripts_match:
        script_content = scripts_match.group(1)
        for line in script_content.split('\n'):
            line = line.strip()
            if ':' in line:
                key, value = line.split(':', 1)
                scripts_dict[key.strip()] = value.strip().strip('"\'')
    
    return description, body_content, scripts_dict


def generate_agent_command(
    agent: str,
    command_name: str,
    description: str,
    body_content: str,
    scripts_dict: Dict[str, str],
    arg_format: str,
    script_variant: str
) -> str:
    """
    Generate an agent-specific command file content.
    """
    # Replace {SCRIPT} placeholder with the appropriate script command
    script_command = scripts_dict.get(script_variant, "(Missing script command)")
    replaced_content = body_content.replace('{SCRIPT}', script_command)
    
    # Replace {ARGS} placeholder with the appropriate argument format
    replaced_content = replaced_content.replace('{ARGS}', arg_format)
    
    # Replace $ARGUMENTS with the actual argument format
    replaced_content = replaced_content.replace('$ARGUMENTS', arg_format)
    
    # Apply path rewrites (change paths to use .blueprint instead of /)
    replaced_content = re.sub(r'(/?)memory/', r'.blueprint/memory/', replaced_content)
    replaced_content = re.sub(r'(/?)scripts/', r'.blueprint/scripts/', replaced_content)
    replaced_content = re.sub(r'(/?)templates/', r'.blueprint/templates/', replaced_content)
    
    return replaced_content


def create_agent_command_files(target_agents=None):
    """
    Create agent-specific command files for specified agents.
    
    Args:
        target_agents: List of agent names to generate commands for. If None, all agents are processed.
    """
    # Define agent configurations
    all_agents = {
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
    
    # Determine which agents to process
    if target_agents is None:
        agents = all_agents
        print("Generating command files for all supported agents...")
    else:
        # Validate provided agent names
        invalid_agents = [agent for agent in target_agents if agent not in all_agents]
        if invalid_agents:
            print(f"Error: Invalid agent names: {', '.join(invalid_agents)}")
            print(f"Supported agents: {', '.join(all_agents.keys())}")
            sys.exit(1)
        
        agents = {agent: all_agents[agent] for agent in target_agents}
        print(f"Generating command files for agents: {', '.join(target_agents)}")
    
    # Define command files to generate
    command_files = list(Path('templates/commands').glob('*.md'))
    
    if not command_files:
        print("Error: No command templates found in templates/commands/")
        sys.exit(1)
    
    # Process each agent
    for agent, config in agents.items():
        agent_dir = Path(config['dir'])
        agent_dir.mkdir(parents=True, exist_ok=True)
        
        print(f"Generating commands for {agent} in {agent_dir}/")
        
        for variant in config['script_variants']:
            for cmd_file in command_files:
                try:
                    # Read the template
                    description, body_content, scripts_dict = read_command_template(cmd_file)
                    command_name = cmd_file.stem
                    
                    # Generate agent-specific command content
                    command_content = generate_agent_command(
                        agent=agent,
                        command_name=command_name,
                        description=description,
                        body_content=body_content,
                        scripts_dict=scripts_dict,
                        arg_format=config['arg_format'],
                        script_variant=variant
                    )
                    
                    # Create the output file
                    output_filename = f"blueprintkit.{command_name}.{config['ext']}"
                    output_path = agent_dir / output_filename
                    
                    # For TOML files, wrap content in proper TOML structure
                    if config['ext'] == 'toml':
                        toml_content = f'description = """{description}"""\n\nprompt = """{command_content}"""'
                        output_path.write_text(toml_content, encoding='utf-8')
                    else:
                        output_path.write_text(command_content, encoding='utf-8')
                    
                    print(f"  Created: {output_path}")
                    
                except Exception as e:
                    print(f"  Error processing {cmd_file} for {agent}/{variant}: {e}")
    
    print("\nAgent command files generated successfully!")


def main():
    parser = argparse.ArgumentParser(description='Generate agent-specific command files for Blueprint Kit projects')
    parser.add_argument('--agents', nargs='+', help='Specific agents to generate commands for (e.g., claude cursor-agent qwen). If not specified, all agents are processed.')
    
    args = parser.parse_args()
    
    print("Blueprint Kit Agent Command Generator")
    print("=====================================")
    
    # Verify we're in a Blueprint Kit project
    if not Path('templates/commands').exists():
        print("Error: This doesn't appear to be a Blueprint Kit project (templates/commands directory not found)")
        sys.exit(1)
    
    create_agent_command_files(target_agents=args.agents)


if __name__ == "__main__":
    main()