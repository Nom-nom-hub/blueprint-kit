#!/bin/bash

# Script: check-prerequisites.sh
# Purpose: Check that all required tools and directories are available for Blueprint Kit workflow

set -euo pipefail

echo "Checking Blueprint Kit prerequisites..."

# Check for required command-line tools
required_tools=("git")
optional_tools=("python3" "pip" "node" "npm" "dotnet" "docker" "kubectl")

all_present=true

echo
echo "Required tools:"

for tool in "${required_tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        version=$("$tool" --version 2>/dev/null | head -n 1 || echo "Version unknown")
        echo "  ✓ $tool - $version"
    else
        echo "  ✗ $tool - NOT FOUND"
        all_present=false
    fi
done

echo
echo "Optional tools:"

for tool in "${optional_tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        version=$("$tool" --version 2>/dev/null | head -n 1 || echo "Version unknown")
        echo "  ✓ $tool - $version"
    else
        echo "  ○ $tool - NOT FOUND (optional)"
    fi
done

echo
echo "Directory structure:"

# Define required directories
required_dirs=(".blueprint/memory" ".blueprint/scripts" ".blueprint/templates")

for dir in "${required_dirs[@]}"; do
    if [[ -d "$dir" ]]; then
        echo "  ✓ $dir"
    else
        echo "  ✗ $dir - MISSING"
        all_present=false
    fi
done

# Check for optional specs directory
if [[ -d "specs" ]]; then
    spec_count=$(find specs -maxdepth 1 -type d 2>/dev/null | wc -l)
    echo "  ✓ specs/ ($((spec_count - 1)) features)"
else
    echo "  ○ specs/ - NOT FOUND (will be created when needed)"
fi

echo
# Check for configuration files
config_files=(".blueprint/memory/constitution.md")

echo "Configuration files:"
for file in "${config_files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "  ✓ $file"
    else
        echo "  ○ $file - NOT FOUND (will be created with /blueprint.constitution)"
    fi
done

echo

if [[ "$all_present" == true ]]; then
    echo "✓ All required prerequisites are satisfied"
    exit 0
else
    echo "✗ Some required prerequisites are missing"
    exit 1
fi