# PowerShell Script: check-prerequisites.ps1
# Purpose: Check that all required tools and directories are available for Blueprint Kit workflow

Write-Host "Checking Blueprint Kit prerequisites..." -ForegroundColor Cyan

# Check for required command-line tools
$requiredTools = @("git")
$optionalTools = @("python", "pip", "node", "npm", "dotnet", "docker", "kubectl")

$allPresent = $true

Write-Host ""
Write-Host "Required tools:" -ForegroundColor Yellow

foreach ($tool in $requiredTools) {
    try {
        $version = & $tool --version 2>$null | Select-Object -First 1
        if ($version) {
            Write-Host "  ✓ $tool - $version" -ForegroundColor Green
        } else {
            Write-Host "  ✓ $tool - Found" -ForegroundColor Green
        }
    } catch {
        Write-Host "  ✗ $tool - NOT FOUND" -ForegroundColor Red
        $allPresent = $false
    }
}

Write-Host ""
Write-Host "Optional tools:" -ForegroundColor Yellow

foreach ($tool in $optionalTools) {
    try {
        $version = & $tool --version 2>$null | Select-Object -First 1
        if ($version) {
            Write-Host "  ✓ $tool - $version" -ForegroundColor Green
        } else {
            Write-Host "  ✓ $tool - Found" -ForegroundColor Green
        }
    } catch {
        Write-Host "  ○ $tool - NOT FOUND (optional)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "Directory structure:" -ForegroundColor Yellow

# Define required directories
$requiredDirs = @(".blueprintkit\memory", ".blueprintkit\scripts", ".blueprintkit\templates")

foreach ($dir in $requiredDirs) {
    if (Test-Path $dir -PathType Container) {
        Write-Host "  ✓ $dir" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $dir - MISSING" -ForegroundColor Red
        $allPresent = $false
    }
}

# Check for optional specs directory
if (Test-Path "specs" -PathType Container) {
    $specCount = (Get-ChildItem -Path "specs" -Directory -ErrorAction SilentlyContinue | Measure-Object).Count
    Write-Host "  ✓ specs/ ($specCount features)" -ForegroundColor Green
} else {
    Write-Host "  ○ specs/ - NOT FOUND (will be created when needed)" -ForegroundColor Gray
}

Write-Host ""
# Check for configuration files
$configFiles = @(".blueprintkit\memory\constitution.md")

Write-Host "Configuration files:" -ForegroundColor Yellow
foreach ($file in $configFiles) {
    if (Test-Path $file -PathType Leaf) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ○ $file - NOT FOUND (will be created with /blueprintkit.constitution)" -ForegroundColor Gray
    }
}

Write-Host ""

if ($allPresent) {
    Write-Host "✓ All required prerequisites are satisfied" -ForegroundColor Green
    exit 0
} else {
    Write-Host "✗ Some required prerequisites are missing" -ForegroundColor Red
    exit 1
}