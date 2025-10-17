#!/usr/bin/env bash
set -euo pipefail

# get-tag-version.sh
# Extract the version from the current tag and output GitHub Actions variables
# Usage: get-tag-version.sh

# Get the current tag that triggered this workflow
CURRENT_TAG=$(git describe --exact-match --tags HEAD 2>/dev/null || echo "")
if [ -z "$CURRENT_TAG" ]; then
  echo "Error: Could not determine current tag" >&2
  exit 1
fi

echo "latest_tag=$CURRENT_TAG" >> $GITHUB_OUTPUT
echo "new_version=$CURRENT_TAG" >> $GITHUB_OUTPUT
echo "Using current tag as version: $CURRENT_TAG"