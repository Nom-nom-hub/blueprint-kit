#!/usr/bin/env bash
set -euo pipefail

# get-current-and-previous-tags.sh
# Extract the current tag that triggered this workflow and the previous tag
# Usage: get-current-and-previous-tags.sh

# Get the current tag that triggered this workflow
CURRENT_TAG=$(git describe --exact-match --tags HEAD 2>/dev/null || echo "")
if [ -z "$CURRENT_TAG" ]; then
  echo "Error: Could not determine current tag" >&2
  exit 1
fi

# Get the previous tag (the one before the current tag)
PREVIOUS_TAG=$(git describe --tags --abbrev=0 $(git rev-list --tags --skip=1 --max-count=1) 2>/dev/null || echo "v0.0.0")

echo "current_tag=$CURRENT_TAG" >> $GITHUB_OUTPUT
echo "previous_tag=$PREVIOUS_TAG" >> $GITHUB_OUTPUT
echo "Using current tag: $CURRENT_TAG, previous tag: $PREVIOUS_TAG"