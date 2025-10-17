#!/usr/bin/env bash
set -euo pipefail

# generate-release-notes.sh
# Generate release notes from git history
# Usage: generate-release-notes.sh <current_tag> <previous_tag>

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <current_tag> <previous_tag>" >&2
  exit 1
fi

CURRENT_TAG="$1"
PREVIOUS_TAG="$2"

# If the current tag is the same as the previous tag (first release), or if there's no previous tag, 
# get the first few commits
if [ "$CURRENT_TAG" = "$PREVIOUS_TAG" ] || [ "$PREVIOUS_TAG" = "v0.0.0" ]; then
  # Get the first set of commits if this is the initial release
  COMMIT_COUNT=$(git rev-list --count HEAD)
  if [ "$COMMIT_COUNT" -gt 10 ]; then
    COMMITS=$(git log --oneline --pretty=format:"- %s" HEAD~10..HEAD)
  else
    COMMITS=$(git log --oneline --pretty=format:"- %s" HEAD~$COMMIT_COUNT..HEAD 2>/dev/null || git log --oneline --pretty=format:"- %s")
  fi
else
  # Get commits between the previous tag and the current tag
  COMMITS=$(git log --oneline --pretty=format:"- %s" $PREVIOUS_TAG..$CURRENT_TAG)
fi

# Create release notes
cat > release_notes.md << EOF
This is the latest set of releases that you can use with your agent of choice. We recommend using the Blueprint CLI to scaffold your projects, however you can download these independently and manage them yourself.

## Changelog

$COMMITS

EOF

echo "Generated release notes:"
cat release_notes.md