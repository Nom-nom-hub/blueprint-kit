# PowerShell Script: create-new-feature.ps1
# Purpose: Create a new feature branch and spec file in the Blueprint Kit workflow

# This script creates a new feature branch and specification file
# Usage: .\create-new-feature.ps1 -FeatureDescription "Feature description" -Json

param(
    [Parameter(Mandatory=$false)]
    [string]$FeatureDescription = "",
    
    [Parameter(Mandatory=$false)]
    [switch]$Json
)

# Function to create unique feature number
function Get-FeatureNumber {
    $basePath = "specs"
    
    if (Test-Path $basePath -PathType Container) {
        # Find the highest numbered directory and add 1
        $maxNum = 0
        $dirs = Get-ChildItem -Path $basePath -Directory -ErrorAction SilentlyContinue
        if ($dirs) {
            foreach ($dir in $dirs) {
                $dirName = $dir.Name
                # Extract number from beginning of directory name (e.g., "001-feature" -> "001")
                $match = [regex]::Match($dirName, '^[0]*([0-9]*)')
                if ($match.Success) {
                    $numStr = $match.Groups[1].Value
                    if ($numStr -match '^[0-9]+$') {
                        $num = [int]$numStr
                        if ($num -gt $maxNum) {
                            $maxNum = $num
                        }
                    }
                }
            }
        }
        
        $nextNum = $maxNum + 1
        return $nextNum.ToString("000")
    } else {
        # No specs directory exists yet, start with 001
        return "001"
    }
}

# Validate input
if ([string]::IsNullOrEmpty($FeatureDescription)) {
    Write-Error "Error: Feature description is required"
    exit 1
}

# Create specs directory if it doesn't exist
if (!(Test-Path "specs" -PathType Container)) {
    New-Item -ItemType Directory -Path "specs" -Force | Out-Null
}

# Get feature number
$featureNum = Get-FeatureNumber

# Create branch name from feature description
# Convert to lowercase, replace spaces and special characters with hyphens
$branchName = "${featureNum}-$($FeatureDescription.ToLower() -replace '[^a-z0-9]', '-' -replace '-+', '-' -replace '^-*|-*$', '')"

# If branch_name is empty after processing, use a default
if ([string]::IsNullOrEmpty($branchName)) {
    $branchName = "${featureNum}-feature"
}

# Create the feature directory
$featureDir = "specs\$branchName"
New-Item -ItemType Directory -Path $featureDir -Force | Out-Null

# Create spec file
$specFile = "$featureDir\spec.md"

# Create the spec file with template content
$specContent = @'
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
'@

Set-Content -Path $specFile -Value $specContent

# If JSON mode is enabled, print the JSON output and exit
if ($Json) {
    $jsonOutput = @{
        BRANCH_NAME = $branchName
        SPEC_FILE = $specFile
    } | ConvertTo-Json -Compress
    
    Write-Output $jsonOutput
    exit 0
}

# Create goals file
$goalsFile = "$featureDir\goals.md"

$goalsContent = @'
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
'@

Set-Content -Path $goalsFile -Value $goalsContent

# Create blueprint file
$blueprintFile = "$featureDir\blueprint.md"

$blueprintContent = @'
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
'@

Set-Content -Path $blueprintFile -Value $blueprintContent

# Create initial plan file placeholder
$planFile = "$featureDir\plan.md"
New-Item -ItemType File -Path $planFile -Force | Out-Null

# Create initial tasks file placeholder
$tasksFile = "$featureDir\tasks.md"
New-Item -ItemType File -Path $tasksFile -Force | Out-Null

# Create checklists directory
$checklistsDir = "$featureDir\checklists"
New-Item -ItemType Directory -Path $checklistsDir -Force | Out-Null

Write-Host "Created feature directory: $featureDir"
Write-Host "Created spec file: $specFile"
Write-Host "Created goals file: $goalsFile"
Write-Host "Created blueprint file: $blueprintFile"
Write-Host "Created plan file: $planFile"
Write-Host "Created tasks file: $tasksFile"
Write-Host "Created checklists directory: $checklistsDir"

# Create git branch if in a git repository
$isGitRepo = $false
try {
    $null = git rev-parse --git-dir 2>$null
    $isGitRepo = $LASTEXITCODE -eq 0
} catch {
    # Git not available or not in repo
}

if ($isGitRepo) {
    # Check if the branch already exists
    $branchExists = $false
    try {
        $result = git show-ref --verify --quiet "refs/heads/$branchName" 2>$null
        $branchExists = $LASTEXITCODE -eq 0
    } catch {
        # Branch does not exist
    }
    
    if ($branchExists) {
        Write-Host "Branch $branchName already exists, checking it out"
        git checkout $branchName | Out-Null
    } else {
        Write-Host "Creating and switching to branch: $branchName"
        git checkout -b $branchName | Out-Null
    }
} else {
    Write-Host "Not in a git repository, skipping branch creation"
}

Write-Host "Feature setup complete!"