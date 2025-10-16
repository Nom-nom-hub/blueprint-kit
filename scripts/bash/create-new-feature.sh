#!/bin/bash

# Script: create-new-feature.sh
# Purpose: Create a new feature branch and spec file in the Blueprint Kit workflow

# This script creates a new feature branch and specification file
# Usage: ./create-new-feature.sh "Feature description" --json

set -euo pipefail

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

# Parse arguments
feature_desc=""
json_mode=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            json_mode=true
            shift
            ;;
        *)
            feature_desc="$*"
            shift $#
            ;;
    esac
done

# Validate input
if [[ -z "$feature_desc" ]]; then
    echo "Error: Feature description is required" >&2
    exit 1
fi

# Create .blueprint/specs directory if it doesn't exist
mkdir -p .blueprint/specs

# Get feature number
feature_num=$(get_feature_number)

# Create branch name from feature description
# Convert to lowercase, replace spaces with hyphens, remove special characters
branch_name="${feature_num}-$(echo "$feature_desc" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/-$//' | sed 's/^-*//')"

# If branch_name is empty after processing, use a default
if [[ -z "$branch_name" ]]; then
    branch_name="${feature_num}-feature"
fi

# Create the feature directory
feature_dir=".blueprint/specs/$branch_name"
mkdir -p "$feature_dir"

# Create spec file
spec_file="$feature_dir/spec.md"

# Create the spec file with template content
cat > "$spec_file" << 'EOF'
# [FEATURE NAME]

## Feature Overview
**What**: 

**Why**: 

**Context**: 

## User Scenarios & Testing

### Primary User Scenarios
1. 
2. 
3. 

### Acceptance Scenarios
- 
- 
- 

### Edge Cases
- 

## Functional Requirements
1. 
2. 
3. 

### Requirements Rationale
- 

## Success Criteria
- 
- 
- 

## Key Entities
- 

## Clarifications
- 

## Assumptions
- 

## Dependencies
- 

## Review & Acceptance Checklist
- [ ] All user scenarios are clearly defined
- [ ] Acceptance scenarios are testable and comprehensive
- [ ] Functional requirements are specific and measurable
- [ ] Success criteria are defined and measurable
- [ ] Edge cases are considered
- [ ] Assumptions are documented
- [ ] Dependencies are identified
- [ ] No implementation details mentioned (languages, frameworks, APIs)
EOF

# If JSON mode is enabled, print the JSON output and exit
if $json_mode; then
    print_json "$branch_name" "$spec_file"
    exit 0
fi

# Create goals file
goals_file="$feature_dir/goals.md"

cat > "$goals_file" << 'EOF'
# [GOAL NAME]

## Goal Definition
**What**: 

**Why**: 

**Success Metrics**: 

## Success Criteria
- 
- 
- 

## Key Stakeholders
- 

## Timeline
- 

## Constraints & Assumptions
- 

## Success Indicators
- 
- 

## Validation Approach
- 

## Review Checklist
- [ ] Goal is specific and clearly defined
- [ ] Success criteria are measurable and achievable
- [ ] Timeline is realistic
- [ ] Constraints and assumptions are documented
- [ ] Success indicators are defined
- [ ] Validation approach is clear
- [ ] Stakeholders are identified
EOF

# Create blueprint file
blueprint_file="$feature_dir/blueprint.md"

cat > "$blueprint_file" << 'EOF'
# [ARCHITECTURAL BLUEPRINT NAME]

## Architecture Overview
**What**: 

**Why**: 

**Context**: 

## Core Components
- [Component 1]: 
- [Component 2]: 
- [Component 3]: 

## System Design
### Architecture Pattern
- 

### Technology Stack
- [Framework/Platform]: 
- [Database]: 
- [Communication]: 
- [Security]: 

### Data Flow
- 

## Interface Design
### APIs
- 

### External Dependencies
- 

## Deployment Architecture
- 

## Quality Attributes
- [Performance]: 
- [Security]: 
- [Scalability]: 
- [Maintainability]: 

## Constraints & Decisions
- 

## Risks & Mitigations
- 

## Review Checklist
- [ ] Architecture addresses the feature requirements
- [ ] Technology choices are appropriate for the requirements
- [ ] Data flow is clearly defined
- [ ] Security considerations are addressed
- [ ] Scalability requirements are met
- [ ] Deployment approach is feasible
- [ ] Quality attributes are defined
- [ ] Risks are identified and mitigated
EOF

# Create initial plan file placeholder
plan_file="$feature_dir/plan.md"
touch "$plan_file"

# Create initial tasks file placeholder
tasks_file="$feature_dir/tasks.md"
touch "$tasks_file"

# Create checklists directory
mkdir -p "$feature_dir/checklists"

echo "Created feature directory: $feature_dir"
echo "Created spec file: $spec_file"
echo "Created goals file: $goals_file"
echo "Created blueprint file: $blueprint_file"
echo "Created plan file: $plan_file"
echo "Created tasks file: $tasks_file"
echo "Created checklists directory: $feature_dir/checklists"

# Create git branch if in a git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
    # Check if the branch already exists
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        echo "Branch $branch_name already exists, checking it out"
    else
        echo "Creating and switching to branch: $branch_name"
        git checkout -b "$branch_name"
    fi
else
    echo "Not in a git repository, skipping branch creation"
fi

echo "Feature setup complete!"