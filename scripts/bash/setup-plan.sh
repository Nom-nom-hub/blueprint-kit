#!/bin/bash

# Script: setup-plan.sh
# Purpose: Set up the implementation plan files in the Blueprint Kit workflow

# This script sets up the implementation plan and related files
# Usage: ./setup-plan.sh --json

set -euo pipefail

# Function to print JSON output for Claude
print_json() {
    local feature_dir="$1"
    cat <<EOF
{
    "FEATURE_DIR": "$feature_dir"
}
EOF
}

# Function to get current feature directory from git branch or environment
get_feature_dir() {
    # First, try to get from SPECIFY_FEATURE environment variable
    if [[ -n "${BLUEPRINT_FEATURE:-}" ]]; then
        echo ".blueprint/specs/${BLUEPRINT_FEATURE}"
        return
    fi

    # Otherwise, try to get from current git branch name
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch_name
        branch_name=$(git branch --show-current)
        
        # Check if branch name starts with the expected pattern (e.g., "001-", "002-")
        if [[ $branch_name =~ ^[0-9]{3,}- ]]; then
            echo ".blueprint/specs/$branch_name"
            return
        fi
    fi

    # If we can't determine the feature from git branch, look for the most recent spec directory
    if [[ -d ".blueprint/specs" ]]; then
        for dir in $(ls -1d .blueprint/specs/* 2>/dev/null | sort -r); do
            if [[ -d "$dir" ]]; then
                echo "$dir"
                return
            fi
        done
    fi

    # If no spec directory found, return an error
    echo "Error: Cannot determine feature directory" >&2
    exit 1
}

json_mode=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            json_mode=true
            shift
            ;;
        *)
            echo "Unknown parameter: $1" >&2
            exit 1
            ;;
    esac
done

# Get feature directory
feature_dir=$(get_feature_dir)

# Extract feature name from directory path
feature_name=$(basename "$feature_dir")

# If JSON mode is enabled, print the JSON output and exit
if $json_mode; then
    print_json "$feature_name"
    exit 0
fi

# Validate required files exist
required_files=(
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

# Create contracts directory if it doesn't exist
contracts_dir="$feature_dir/contracts"
mkdir -p "$contracts_dir"

# Create data-model.md file
data_model_file="$feature_dir/data-model.md"
cat > "$data_model_file" << 'EOF'
# Data Models for [FEATURE NAME]

## Entity Models

### [Entity 1]
- Field 1: Type - Description
- Field 2: Type - Description
- Field 3: Type - Description

### [Entity 2]
- Field 1: Type - Description
- Field 2: Type - Description
- Field 3: Type - Description

## Relationships
- [Entity 1] [relationship] [Entity 2] - Description of relationship

## Validation Rules
- [Rule 1]: Description
- [Rule 2]: Description

## Business Logic Constraints
- [Constraint 1]: Description
- [Constraint 2]: Description
EOF

# Create research.md file with a research template
research_file="$feature_dir/research.md"
cat > "$research_file" << 'EOF'
# Research for [FEATURE NAME]

## Technology Research

### [Technology/Approach 1]
- **Pros**: 
  - 
  - 
- **Cons**: 
  - 
  - 
- **Use Case**: When to use this approach
- **Alternatives**: Other options to consider

### [Technology/Approach 2]
- **Pros**: 
  - 
  - 
- **Cons**: 
  - 
  - 
- **Use Case**: When to use this approach
- **Alternatives**: Other options to consider

## Architecture Research

### [Architecture Pattern/Decision]
- **Problem**: What problem this solves
- **Solution**: How it solves the problem
- **Trade-offs**: What we gain and lose with this approach
- **Alternatives Considered**: Other solutions evaluated

## Performance Research

### [Performance Consideration]
- **Issue**: The performance issue being addressed
- **Impact**: How it affects the system
- **Solutions**: Possible ways to address it
- **Recommendation**: Which solution to use

## Security Research

### [Security Consideration]
- **Threat**: The security threat being addressed
- **Impact**: Potential damage if exploited
- **Mitigation**: How to prevent or minimize the threat
- **Implementation**: How to implement the mitigation

## Research Summary
- **Key Findings**: Most important discoveries
- **Recommendations**: What approach to take based on research
- **Risks**: Potential issues with recommended approach
- **Next Steps**: What to do with this research
EOF

# Create quickstart.md file
quickstart_file="$feature_dir/quickstart.md"
cat > "$quickstart_file" << 'EOF'
# Quickstart Guide for [FEATURE NAME]

## Overview
This document provides key validation scenarios for the [FEATURE NAME] feature. These scenarios can be used to quickly validate that the implementation meets the core requirements.

## Prerequisites
- [List of requirements to run the validation]
- [Setup steps needed before validation]

## Validation Scenarios

### Scenario 1: [Scenario Name]
- **Objective**: [What this scenario validates]
- **Steps**:
  1. [Step 1]
  2. [Step 2]
  3. [Step 3]
- **Expected Result**: [What should happen]
- **Success Criteria**: [How to verify success]

### Scenario 2: [Scenario Name]
- **Objective**: [What this scenario validates]
- **Steps**:
  1. [Step 1]
  2. [Step 2]
  3. [Step 3]
- **Expected Result**: [What should happen]
- **Success Criteria**: [How to verify success]

### Scenario 3: [Scenario Name]
- **Objective**: [What this scenario validates]
- **Steps**:
  1. [Step 1]
  2. [Step 2]
  3. [Step 3]
- **Expected Result**: [What should happen]
- **Success Criteria**: [How to verify success]

## Edge Case Validation

### Edge Case 1: [Case Name]
- **Condition**: [What triggers this edge case]
- **Expected Behavior**: [How the system should respond]
- **Test Steps**: [How to reproduce and validate]

## Performance Validation
- [Performance metrics to validate]
- [How to measure performance]
- [Acceptable performance thresholds]

## Security Validation
- [Security aspects to validate]
- [How to test security measures]
- [Security requirements to verify]

## Rollback Plan
- [Steps to revert to previous state if needed]
- [How to undo changes if validation fails]
EOF

# Create/update the plan.md file
plan_file="$feature_dir/plan.md"

# Check if plan.md already exists and has content
if [[ -f "$plan_file" ]] && [[ -s "$plan_file" ]]; then
    echo "Plan file already exists, updating it..."
else
    cat > "$plan_file" << 'EOF'
# Implementation Plan for [FEATURE NAME]

## Feature: [FEATURE NAME]
**Spec**: [Link to feature spec file]

## Phase -1: Pre-Implementation Gates
#### Simplicity Gate (Article VII)
- [ ] Using ≤3 projects?
- [ ] No future-proofing?

#### Anti-Abstraction Gate (Article VIII)
- [ ] Using framework directly?
- [ ] Single model representation?

#### Integration-First Gate (Article IX)
- [ ] Contracts defined?
- [ ] Contract tests written?

### Gate Status
- [ ] All gates passed OR complexity documented in "Complexity Tracking" below

### Complexity Tracking (if any gates failed)
- [If any gates failed, document the justification for added complexity here]

---

## Implementation Approach
**Primary Architecture**: [Architecture pattern to be implemented]

**Tech Stack**: [Specific technologies to be used]

**Key Patterns**: [Important design patterns to implement]

## Implementation Phases
### Phase 1: [Phase Name]
**Scope**: [What will be accomplished in this phase]
**Deliverables**:
- [Deliverable 1]
- [Deliverable 2]

### Phase 2: [Phase Name]
**Scope**: [What will be accomplished in this phase]
**Deliverables**:
- [Deliverable 1]
- [Deliverable 2]

### Phase 3: [Phase Name]
**Scope**: [What will be accomplished in this phase]
**Deliverables**:
- [Deliverable 1]
- [Deliverable 2]

## File Creation Order
1. Create `contracts/` with API specifications
2. Create test files in order: contract → integration → e2e → unit
3. Create source files to make tests pass

## Core Implementation
### [Component/Module 1]
- [Description of what needs to be implemented]
- [Files to create/update]
- [Key considerations]

### [Component/Module 2]
- [Description of what needs to be implemented]
- [Files to create/update]
- [Key considerations]

### [Component/Module 3]
- [Description of what needs to be implemented]
- [Files to create/update]
- [Key considerations]

## Testing Strategy
### Test Coverage
- [What needs to be tested at each level]
- [Test data requirements]

### Test Scenarios
- [Specific test cases that need to be implemented]
- [Edge cases that need to be covered]

## Deployment Considerations
- [Any deployment-specific requirements]
- [Configuration needs]
- [Environment requirements]

## Success Criteria
- [How will we know the implementation is successful?]
- [Metrics to validate completion]

## Risks & Mitigations
- [Potential risks during implementation]
- [How they will be mitigated]

## Assumptions
- [Any assumptions made about external dependencies or environment]

## Implementation Details
**IMPORTANT**: This implementation plan should remain high-level and readable.
Any code samples, detailed algorithms, or extensive technical specifications
must be placed in the appropriate `implementation-details/` file.

---

## Review Checklist
- [ ] Implementation approach aligns with architectural blueprint
- [ ] Phases are well-defined with clear deliverables
- [ ] File creation order follows best practices
- [ ] Testing strategy is comprehensive
- [ ] Deployment considerations are addressed
- [ ] Success criteria are defined
- [ ] Risks are identified and mitigated
- [ ] All pre-implementation gates are addressed
EOF
fi

echo "Created/updated implementation plan: $plan_file"
echo "Created data models: $data_model_file"
echo "Created research notes: $research_file"
echo "Created quickstart guide: $quickstart_file"
echo "Created contracts directory: $contracts_dir"

echo "Plan setup complete for feature: $feature_name!"