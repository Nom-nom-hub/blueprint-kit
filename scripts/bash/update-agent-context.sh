#!/bin/bash

# Script: update-agent-context.sh
# Purpose: Update agent context files with current Blueprint Kit methodology

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Define file paths for different agents
CLAUDE_FILE="$REPO_ROOT/.claude/claude"
GEMINI_FILE="$REPO_ROOT/.gemini/roles/blueprint-kit-role.md"
QWEN_FILE="$REPO_ROOT/.qwen/QWEN.md"
OPENCODE_FILE="$REPO_ROOT/.opencode/BRAIN.md"
CODEX_FILE="$REPO_ROOT/.codex/codex.md"
WINDSURF_FILE="$REPO_ROOT/.windsurf/rules/specify-rules.md"
ROO_FILE="$REPO_ROOT/.roo/roo.md"
CODEBUDDY_FILE="$REPO_ROOT/.codebuddy/codebuddy.md"
KILCODE_FILE="$REPO_ROOT/.kilocode/kilocode.md"
AUGGIE_FILE="$REPO_ROOT/.augment/rules.md"
AMAZONQ_FILE="$REPO_ROOT/.amazonq/prompts/blueprint-kit-prompt.md"

# Function to update an agent file
update_agent_file() {
    local file_path="$1"
    local agent_name="$2"
    
    # Extract the directory path
    local dir_path
    dir_path=$(dirname "$file_path")
    
    # Create directory if it doesn't exist
    mkdir -p "$dir_path"
    
    # Copy the agent template to the agent-specific file
    if [[ -f "$REPO_ROOT/templates/agent-file-template.md" ]]; then
        cp "$REPO_ROOT/templates/agent-file-template.md" "$file_path"
        echo "Updated $agent_name context file: $file_path"
    else
        echo "Warning: Agent template not found at $REPO_ROOT/templates/agent-file-template.md"
        # Create a minimal file if template is missing
        cat > "$file_path" << EOF
# $agent_name Context for Blueprint Kit

This file provides context for $agent_name when working with the Blueprint Kit methodology.
Please refer to the main documentation for complete details on Blueprint Kit commands and workflows.
EOF
        echo "Created minimal $agent_name context file: $file_path"
    fi
}

# Determine the agent type from the first argument (if provided)
AGENT_TYPE="${1:-}"

case "$AGENT_TYPE" in
    claude) update_agent_file "$CLAUDE_FILE" "Claude" ;;
    gemini) update_agent_file "$GEMINI_FILE" "Gemini" ;;
    qwen) update_agent_file "$QWEN_FILE" "Qwen" ;;
    opencode) update_agent_file "$OPENCODE_FILE" "opencode" ;;
    codex) update_agent_file "$CODEX_FILE" "Codex" ;;
    windsurf) update_agent_file "$WINDSURF_FILE" "Windsurf" ;;
    roo) update_agent_file "$ROO_FILE" "Roo" ;;
    codebuddy) update_agent_file "$CODEBUDDY_FILE" "CodeBuddy" ;;
    kilocode) update_agent_file "$KILCODE_FILE" "Kilo Code" ;;
    auggie) update_agent_file "$AUGGIE_FILE" "Auggie" ;;
    q) update_agent_file "$AMAZONQ_FILE" "Amazon Q Developer" ;;
    "")
        # If no agent type specified, update all files that exist
        [[ -f "$REPO_ROOT/.claude/claude" ]] || [[ -d "$REPO_ROOT/.claude" ]] && update_agent_file "$CLAUDE_FILE" "Claude"
        [[ -f "$REPO_ROOT/.gemini/roles/blueprint-kit-role.md" ]] || [[ -d "$REPO_ROOT/.gemini" ]] && update_agent_file "$GEMINI_FILE" "Gemini"
        [[ -f "$REPO_ROOT/.qwen/QWEN.md" ]] || [[ -d "$REPO_ROOT/.qwen" ]] && update_agent_file "$QWEN_FILE" "Qwen"
        [[ -f "$REPO_ROOT/.opencode/BRAIN.md" ]] || [[ -d "$REPO_ROOT/.opencode" ]] && update_agent_file "$OPENCODE_FILE" "opencode"
        [[ -f "$REPO_ROOT/.codex/codex.md" ]] || [[ -d "$REPO_ROOT/.codex" ]] && update_agent_file "$CODEX_FILE" "Codex"
        [[ -f "$REPO_ROOT/.windsurf/rules/specify-rules.md" ]] || [[ -d "$REPO_ROOT/.windsurf" ]] && update_agent_file "$WINDSURF_FILE" "Windsurf"
        [[ -f "$REPO_ROOT/.roo/roo.md" ]] || [[ -d "$REPO_ROOT/.roo" ]] && update_agent_file "$ROO_FILE" "Roo"
        [[ -f "$REPO_ROOT/.codebuddy/codebuddy.md" ]] || [[ -d "$REPO_ROOT/.codebuddy" ]] && update_agent_file "$CODEBUDDY_FILE" "CodeBuddy"
        [[ -f "$REPO_ROOT/.kilocode/kilocode.md" ]] || [[ -d "$REPO_ROOT/.kilocode" ]] && update_agent_file "$KILCODE_FILE" "Kilo Code"
        [[ -f "$REPO_ROOT/.augment/rules.md" ]] || [[ -d "$REPO_ROOT/.augment" ]] && update_agent_file "$AUGGIE_FILE" "Auggie"
        [[ -f "$REPO_ROOT/.amazonq/prompts/blueprint-kit-prompt.md" ]] || [[ -d "$REPO_ROOT/.amazonq" ]] && update_agent_file "$AMAZONQ_FILE" "Amazon Q Developer"
        ;;
    *)
        echo "Unknown agent type: $AGENT_TYPE"
        echo "Supported types: claude, gemini, qwen, opencode, codex, windsurf, roo, codebuddy, kilocode, auggie, q"
        exit 1
        ;;
esac