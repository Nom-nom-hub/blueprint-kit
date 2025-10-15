# PowerShell Script: common.ps1
# Purpose: Common functions and utilities for the Blueprint Kit workflow

# Function to print JSON output for Claude
function Print-Json {
    param(
        [string]$BranchName,
        [string]$SpecFile
    )
    
    $jsonOutput = @{
        BRANCH_NAME = $BranchName
        SPEC_FILE = $SpecFile
    } | ConvertTo-Json -Compress
    
    Write-Output $jsonOutput
}

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

# Function to validate required files exist
function Validate-RequiredFiles {
    param(
        [string]$FeatureDir
    )
    
    $requiredFiles = @(
        "$FeatureDir\spec.md",
        "$FeatureDir\goals.md",
        "$FeatureDir\blueprint.md"
    )
    
    foreach ($file in $requiredFiles) {
        if (!(Test-Path $file -PathType Leaf)) {
            Write-Error "Error: Required file does not exist: $file"
            exit 1
        }
    }
}

# Function to get feature directory from environment or git
function Get-FeatureDir {
    # First, try to get from BLUEPRINT_FEATURE environment variable
    if ($env:BLUEPRINT_FEATURE) {
        return "specs\$($env:BLUEPRINT_FEATURE)"
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
            return "specs\$branchName"
        }
    }

    # If we can't determine the feature from git branch, look for the most recent spec directory
    if (Test-Path "specs" -PathType Container) {
        $dirs = Get-ChildItem -Path "specs" -Directory -ErrorAction SilentlyContinue | Sort-Object {$_.Name} -Descending
        if ($dirs) {
            foreach ($dir in $dirs) {
                return $dir.FullName
            }
        }
    }

    # If no spec directory found, return an error
    Write-Error "Error: Cannot determine feature directory"
    return $null
}

# Function to create feature directory structure
function Create-FeatureStructure {
    param(
        [string]$FeatureDir
    )
    
    # Create the feature directory
    New-Item -ItemType Directory -Path $FeatureDir -Force | Out-Null
    
    # Create checklists directory
    New-Item -ItemType Directory -Path "$FeatureDir\checklists" -Force | Out-Null
    
    # Create contracts directory
    New-Item -ItemType Directory -Path "$FeatureDir\contracts" -Force | Out-Null
}

# Function to convert description to branch name
function Convert-DescriptionToBranchName {
    param(
        [string]$FeatureNum,
        [string]$FeatureDesc
    )
    
    # Create branch name from feature description
    # Convert to lowercase, replace spaces and special characters with hyphens
    $branchName = "${featureNum}-$($FeatureDesc.ToLower() -replace '[^a-z0-9]', '-' -replace '-+', '-' -replace '^-*|-*$', '')"
    
    # If branch_name is empty after processing, use a default
    if ([string]::IsNullOrEmpty($branchName)) {
        $branchName = "${featureNum}-feature"
    }
    
    return $branchName
}

# Function to check if we're in a git repository
function Test-GitRepo {
    try {
        $null = git rev-parse --git-dir 2>$null
        return $LASTEXITCODE -eq 0
    } catch {
        return $false
    }
}

# Function to checkout or create feature branch
function Set-FeatureBranch {
    param(
        [string]$BranchName
    )
    
    if (Test-GitRepo) {
        # Check if the branch already exists
        $branchExists = $false
        try {
            $result = git show-ref --verify --quiet "refs/heads/$BranchName" 2>$null
            $branchExists = $LASTEXITCODE -eq 0
        } catch {
            # Branch does not exist
        }
        
        if ($branchExists) {
            Write-Host "Branch $BranchName already exists, checking it out"
            git checkout $BranchName | Out-Null
        } else {
            Write-Host "Creating and switching to branch: $BranchName"
            git checkout -b $BranchName | Out-Null
        }
    } else {
        Write-Host "Not in a git repository, skipping branch creation"
    }
}

# Function to load constitution file if it exists
function Get-Constitution {
    if (Test-Path ".blueprintkit\memory\constitution.md" -PathType Leaf) {
        Write-Host "Loaded constitution from .blueprintkit\memory\constitution.md"
        return $true
    } else {
        Write-Host "No constitution file found at .blueprintkit\memory\constitution.md"
        return $false
    }
}