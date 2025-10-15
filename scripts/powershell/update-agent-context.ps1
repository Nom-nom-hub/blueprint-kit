# PowerShell Script: update-agent-context.ps1
# Purpose: Update agent context files with current Blueprint Kit methodology

param(
    [Parameter(Mandatory=$false)]
    [string]$AgentType = ""
)

# Get the directory where this script is located
$ScriptDir = Split-Path -Parent $PSCommandPath
$RepoRoot = Split-Path -Parent $ScriptDir

# Define file paths for different agents
$claudeFile = Join-Path $RepoRoot '.claude\claude'
$geminiFile = Join-Path $RepoRoot '.gemini\roles\blueprint-kit-role.md'
$qwenFile = Join-Path $RepoRoot '.qwen\QWEN.md'
$opencodeFile = Join-Path $RepoRoot '.opencode\BRAIN.md'
$codexFile = Join-Path $RepoRoot '.codex\codex.md'
$windsurfFile = Join-Path $RepoRoot '.windsurf\rules\specify-rules.md'
$rooFile = Join-Path $RepoRoot '.roo\roo.md'
$codebuddyFile = Join-Path $RepoRoot '.codebuddy\codebuddy.md'
$kilocodeFile = Join-Path $RepoRoot '.kilocode\kilocode.md'
$auggieFile = Join-Path $RepoRoot '.augment\rules.md'
$amazonqFile = Join-Path $RepoRoot '.amazonq\prompts\blueprint-kit-prompt.md'

# Function to update an agent file
function Update-AgentFile {
    param(
        [string]$FilePath,
        [string]$AgentName
    )
    
    # Extract the directory path
    $DirPath = Split-Path -Parent $FilePath
    
    # Create directory if it doesn't exist
    if (!(Test-Path $DirPath)) {
        New-Item -ItemType Directory -Path $DirPath -Force | Out-Null
    }
    
    # Copy the agent template to the agent-specific file
    $templatePath = Join-Path $RepoRoot 'templates\agent-file-template.md'
    if (Test-Path $templatePath) {
        Copy-Item -Path $templatePath -Destination $FilePath
        Write-Host "Updated $AgentName context file: $FilePath"
    } else {
        Write-Host "Warning: Agent template not found at $templatePath"
        # Create a minimal file if template is missing
        $minimalContent = @"
# $AgentName Context for Blueprint Kit

This file provides context for $AgentName when working with the Blueprint Kit methodology.
Please refer to the main documentation for complete details on Blueprint Kit commands and workflows.
"@
        Set-Content -Path $FilePath -Value $minimalContent
        Write-Host "Created minimal $AgentName context file: $FilePath"
    }
}

switch ($AgentType) {
    "claude" { Update-AgentFile $claudeFile "Claude" }
    "gemini" { Update-AgentFile $geminiFile "Gemini" }
    "qwen" { Update-AgentFile $qwenFile "Qwen" }
    "opencode" { Update-AgentFile $opencodeFile "opencode" }
    "codex" { Update-AgentFile $codexFile "Codex" }
    "windsurf" { Update-AgentFile $windsurfFile "Windsurf" }
    "roo" { Update-AgentFile $rooFile "Roo" }
    "codebuddy" { Update-AgentFile $codebuddyFile "CodeBuddy" }
    "kilocode" { Update-AgentFile $kilocodeFile "Kilo Code" }
    "auggie" { Update-AgentFile $auggieFile "Auggie" }
    "q" { Update-AgentFile $amazonqFile "Amazon Q Developer" }
    "" {
        # If no agent type specified, update all files that exist
        if ((Test-Path (Split-Path $claudeFile -Parent) -PathType Container)) { Update-AgentFile $claudeFile "Claude" }
        if ((Test-Path (Split-Path $geminiFile -Parent) -PathType Container)) { Update-AgentFile $geminiFile "Gemini" }
        if ((Test-Path (Split-Path $qwenFile -Parent) -PathType Container)) { Update-AgentFile $qwenFile "Qwen" }
        if ((Test-Path (Split-Path $opencodeFile -Parent) -PathType Container)) { Update-AgentFile $opencodeFile "opencode" }
        if ((Test-Path (Split-Path $codexFile -Parent) -PathType Container)) { Update-AgentFile $codexFile "Codex" }
        if ((Test-Path (Split-Path $windsurfFile -Parent) -PathType Container)) { Update-AgentFile $windsurfFile "Windsurf" }
        if ((Test-Path (Split-Path $rooFile -Parent) -PathType Container)) { Update-AgentFile $rooFile "Roo" }
        if ((Test-Path (Split-Path $codebuddyFile -Parent) -PathType Container)) { Update-AgentFile $codebuddyFile "CodeBuddy" }
        if ((Test-Path (Split-Path $kilocodeFile -Parent) -PathType Container)) { Update-AgentFile $kilocodeFile "Kilo Code" }
        if ((Test-Path (Split-Path $auggieFile -Parent) -PathType Container)) { Update-AgentFile $auggieFile "Auggie" }
        if ((Test-Path (Split-Path $amazonqFile -Parent) -PathType Container)) { Update-AgentFile $amazonqFile "Amazon Q Developer" }
    }
    default {
        Write-Error "Unknown agent type: $AgentType"
        Write-Host "Supported types: claude, gemini, qwen, opencode, codex, windsurf, roo, codebuddy, kilocode, auggie, q"
        exit 1
    }
}