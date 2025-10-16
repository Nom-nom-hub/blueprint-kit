# PowerShell Script: setup-plan.ps1
# Purpose: Set up the implementation plan files in the Blueprint Kit workflow

# This script sets up the implementation plan and related files
# Usage: .\setup-plan.ps1 -Json

param(
    [Parameter(Mandatory=$false)]
    [switch]$Json
)

# Function to get current feature directory from git branch or environment
function Get-FeatureDir {
    # First, try to get from BLUEPRINT_FEATURE environment variable
    if ($env:BLUEPRINT_FEATURE) {
        return ".blueprint\specs\$($env:BLUEPRINT_FEATURE)"
    }

    # Otherwise, try to get from current git branch name
    $isGitRepo = $false
    try {
        $null = git rev-parse --git-dir 2>$null
        $isGitRepo = $LASTEXITCODE -eq 0
    } catch {
        # Git not available or not in repo
    }

    if ($isGitRepo) {
        $branchName = git branch --show-current 2>$null
        
        # Check if branch name starts with the expected pattern (e.g., "001-", "002-")
        if ($branchName -match '^[0-9]{3,}-') {
            return ".blueprint\specs\$branchName"
        }
    }

    # If we can't determine the feature from git branch, look for the most recent spec directory
    if (Test-Path ".blueprint\specs" -PathType Container) {
        $dirs = Get-ChildItem -Path ".blueprint\specs" -Directory -ErrorAction SilentlyContinue | Sort-Object {$_.Name} -Descending
        if ($dirs) {
            foreach ($dir in $dirs) {
                return $dir.FullName
            }
        }
    }

    # If no spec directory found, return an error
    Write-Error "Error: Cannot determine feature directory"
    exit 1
}

# Get feature directory
$featureDir = Get-FeatureDir

# Extract feature name from directory path
$featureName = Split-Path -Path $featureDir -Leaf

# If JSON mode is enabled, print the JSON output and exit
if ($Json) {
    $jsonOutput = @{
        FEATURE_DIR = $featureName
    } | ConvertTo-Json -Compress
    
    Write-Output $jsonOutput
    exit 0
}

# Validate required files exist
$requiredFiles = @(
    "$featureDir\spec.md",
    "$featureDir\goals.md",
    "$featureDir\blueprint.md"
)

foreach ($file in $requiredFiles) {
    if (!(Test-Path $file -PathType Leaf)) {
        Write-Error "Error: Required file does not exist: $file"
        exit 1
    }
}

# Create contracts directory if it doesn't exist
$contractsDir = "$featureDir\contracts"
New-Item -ItemType Directory -Path $contractsDir -Force | Out-Null

# Create data-model.md file
$dataModelFile = "$featureDir\data-model.md"
$dataModelContent = @'
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
'@

Set-Content -Path $dataModelFile -Value $dataModelContent

# Create research.md file with a research template
$researchFile = "$featureDir\research.md"
$researchContent = @'
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
'@

Set-Content -Path $researchFile -Value $researchContent

# Create quickstart.md file
$quickstartFile = "$featureDir\quickstart.md"
$quickstartContent = @'
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
'@

Set-Content -Path $quickstartFile -Value $quickstartContent

# Create/update the plan.md file
$planFile = "$featureDir\plan.md"

# Check if plan.md already exists and has content
$planFileExists = Test-Path $planFile -PathType Leaf
$planHasContent = $false
if ($planFileExists) {
    $planHasContent = (Get-Item $planFile).Length -gt 0
}

if ($planFileExists -and $planHasContent) {
    Write-Host "Plan file already exists, updating it..."
} else {
    $planContent = @'
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
'@
    Set-Content -Path $planFile -Value $planContent
}

Write-Host "Created/updated implementation plan: $planFile"
Write-Host "Created data models: $dataModelFile"
Write-Host "Created research notes: $researchFile"
Write-Host "Created quickstart guide: $quickstartFile"
Write-Host "Created contracts directory: $contractsDir"

Write-Host "Plan setup complete for feature: $featureName!"