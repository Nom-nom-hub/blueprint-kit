#!/bin/bash

# Script: common.sh
# Purpose: Common functions and utilities for the Blueprint Kit workflow

# Function to print JSON output for Claude
print_json() {
    local branch_name="$1"
    local spec_file="$2"
    cat <<EOF
{
    "BRANCH_NAME": "$branch_name",
    "SPEC_FILE": "$spec_file"
}
EOF
}

# Function to create unique feature number
get_feature_number() {
    local base_path="specs"
    if [[ -d "$base_path" ]]; then
        # Find the highest numbered directory and add 1
        local max_num=0
        for dir in "$base_path"/*; do
            if [[ -d "$dir" ]]; then
                local dir_name=$(basename "$dir")
                # Extract number from beginning of directory name (e.g., "001-feature" -> "001")
                local num_str=$(echo "$dir_name" | sed 's/^[0]*\([0-9]*\).*/\1/')
                if [[ "$num_str" =~ ^[0-9]+$ ]]; then
                    local num=$((10#$num_str))  # Force base-10 interpretation
                    if [[ $num -gt $max_num ]]; then
                        max_num=$num
                    fi
                fi
            fi
        done
        
        local next_num=$((max_num + 1))
        printf "%03d" "$next_num"
    else
        # No specs directory exists yet, start with 001
        echo "001"
    fi
}

# Function to validate required files exist
validate_required_files() {
    local feature_dir="$1"
    local required_files=(
        "$feature_dir/spec.md"
        "$feature_dir/goals.md"
        "$feature_dir/blueprint.md"
    )
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            echo "Error: Required file does not exist: $file" >&2
            exit 1
        fi
    done
}

# Function to get feature directory from environment or git
get_feature_dir() {
    # First, try to get from BLUEPRINT_FEATURE environment variable
    if [[ -n "${BLUEPRINT_FEATURE:-}" ]]; then
        echo ".blueprint/specs/${BLUEPRINT_FEATURE}"
        return 0
    fi

    # Otherwise, try to get from current git branch name
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch_name
        branch_name=$(git branch --show-current 2>/dev/null)
        
        # Check if branch name starts with the expected pattern (e.g., "001-", "002-")
        if [[ $branch_name =~ ^[0-9]{3,}- ]]; then
            echo ".blueprint/specs/$branch_name"
            return 0
        fi
    fi

    # If we can't determine the feature from git branch, look for the most recent spec directory
    if [[ -d ".blueprint/specs" ]]; then
        for dir in $(ls -1d .blueprint/specs/* 2>/dev/null | sort -r); do
            if [[ -d "$dir" ]]; then
                echo "$dir"
                return 0
            fi
        done
    fi

    # If no spec directory found, return an error
    echo "Error: Cannot determine feature directory" >&2
    return 1
}

# Function to create feature directory structure
create_feature_structure() {
    local feature_dir="$1"
    
    # Create the feature directory
    mkdir -p "$feature_dir"
    
    # Create checklists directory
    mkdir -p "$feature_dir/checklists"
    
    # Create contracts directory
    mkdir -p "$feature_dir/contracts"
}

# Function to convert description to branch name
description_to_branch_name() {
    local feature_num="$1"
    local feature_desc="$2"
    
    # Create branch name from feature description
    # Convert to lowercase, replace spaces with hyphens, remove special characters
    local branch_name="${feature_num}-$(echo "$feature_desc" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/-$//' | sed 's/^-*//')"
    
    # If branch_name is empty after processing, use a default
    if [[ -z "$branch_name" ]]; then
        branch_name="${feature_num}-feature"
    fi
    
    echo "$branch_name"
}

# Function to check if we're in a git repository
is_git_repo() {
    git rev-parse --git-dir > /dev/null 2>&1
}

# Function to checkout or create feature branch
checkout_feature_branch() {
    local branch_name="$1"
    
    if is_git_repo; then
        # Check if the branch already exists
        if git show-ref --verify --quiet "refs/heads/$branch_name"; then
            echo "Branch $branch_name already exists, checking it out"
            git checkout "$branch_name" > /dev/null
        else
            echo "Creating and switching to branch: $branch_name"
            git checkout -b "$branch_name" > /dev/null
        fi
    else
        echo "Not in a git repository, skipping branch creation"
    fi
}

# Function to load constitution file if it exists
load_constitution() {
    if [[ -f ".blueprint/memory/constitution.md" ]]; then
        echo "Loaded constitution from .blueprint/memory/constitution.md"
    else
        echo "No constitution file found at .blueprint/memory/constitution.md"
    fi
}