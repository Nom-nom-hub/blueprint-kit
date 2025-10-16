#!/usr/bin/env bash
set -euo pipefail # Corrected: Removed space before pipefail

# create-release-packages.sh
# Build Blueprint Kit template release archives for each supported AI assistant and script type.
# Usage: .github/workflows/scripts/create-release-packages.sh <version>
# Example: ./create-release-packages.sh v0.2.0

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version-with-v-prefix>" >&2
  exit 1
fi

NEW_VERSION="$1"
if [[ ! $NEW_VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Version must look like v0.0.0" >&2
  exit 1
fi

echo "Building release packages for $NEW_VERSION"

GENRELEASES_DIR=".genreleases"
mkdir -p "$GENRELEASES_DIR"
rm -rf "$GENRELEASES_DIR"/* || true

rewrite_paths() {
  local input
  input=$(cat)

  input="${input//\/memory\//.blueprint\/memory\/}"
  input="${input//\/scripts\//.blueprint\/scripts\/}"
  input="${input//\/templates\//.blueprint\/templates\/}"

  input="${input//memory\//.blueprint\/memory\/}"
  input="${input//scripts\//.blueprint\/scripts\/}"
  input="${input//templates\//.blueprint\/templates\/}"

  printf '%s' "$input"
}

generate_commands() {
  local agent=$1 ext=$2 arg_format=$3 output_dir=$4 script_variant=$5
  mkdir -p "$output_dir"

  for template in templates/commands/*.md; do
    [[ -f "$template" ]] || continue
    local name description script_command agent_script_command body file_content
    name=$(basename "$template" .md)
    file_content=$(tr -d '\r' < "$template")

    description=$(printf '%s\n' "$file_content" | awk '/^description:/ {sub(/^description:[[:space:]]*/, ""); print; exit}')
    script_command=$(printf '%s\n' "$file_content" | awk -v sv="$script_variant" '/^[[:space:]]*'"$script_variant"':[[:space:]]*/ {sub(/^[[:space:]]*'"$script_variant"':[[:space:]]*/, ""); print; exit}')

    if [[ -z $script_command ]]; then
      echo "Warning: no script command found for $script_variant in $template" >&2
      script_command="(Missing script command for $script_variant)"
    fi

    agent_script_command=$(printf '%s\n' "$file_content" | awk '
      /^agent_scripts:$/ { in_agent_scripts=1; next }
      in_agent_scripts && /^[[:space:]]*'"$script_variant"':[[:space:]]*/ {
        sub(/^[[:space:]]*'"$script_variant"':[[:space:]]*/, "")
        print
        exit
      }
      in_agent_scripts && /^[a-zA-Z]/ { in_agent_scripts=0 }
    ')

    body=$(printf '%s\n' "$file_content" | sed "s|{SCRIPT}|${script_command}|g")

    if [[ -n $agent_script_command ]]; then
      body=$(printf '%s\n' "$body" | sed "s|{AGENT_SCRIPT}|${agent_script_command}|g")
    fi

    body=$(printf '%s\n' "$body" | awk '
      /^---$/ { print; if (++dash_count == 1) in_frontmatter=1; else in_frontmatter=0; next }
      in_frontmatter && /^scripts:$/ { skip_scripts=1; next }
      in_frontmatter && /^agent_scripts:$/ { skip_scripts=1; next }
      in_frontmatter && /^[a-zA-Z].*:/ && skip_scripts { skip_scripts=0 }
      in_frontmatter && skip_scripts && /^[[:space:]]/ { next }
      { print }
    ')

    body=$(printf '%s\n' "$body" | sed "s/{ARGS}/$arg_format/g" | sed "s/__AGENT__/$agent/g" | rewrite_paths)

    case $ext in
      toml)
        # Replace any backslashes with forward slashes, then wrap in proper TOML quoting
        clean_body=$(printf '%s\n' "$body" | sed 's/\\/\//g')
        {
          echo "description = \"$description\""
          echo
          echo "prompt = \"\"\""
          echo "$clean_body"
          echo "\"\"\""
        } > "$output_dir/blueprintkit.$name.$ext"
        ;;
      md)
        echo "$body" > "$output_dir/blueprintkit.$name.$ext"
        ;;
      prompt.md)
        echo "$body" > "$output_dir/blueprintkit.$name.$ext"
        ;;
    esac
  done
}

build_variant() {
  local agent=$1 script=$2
  local base_dir="$GENRELEASES_DIR/bdd-${agent}-package-${script}"

  echo "Building $agent ($script) package..."
  mkdir -p "$base_dir"
  BP_DIR="$base_dir/.blueprint"
  mkdir -p "$BP_DIR"

  [[ -d memory ]] && { cp -r memory "$BP_DIR/"; echo "Copied memory -> .blueprint"; }

  if [[ -d scripts ]]; then
    mkdir -p "$BP_DIR/scripts"
    case $script in
      sh)
        [[ -d scripts/bash ]] && cp -r scripts/bash "$BP_DIR/scripts/"
        find scripts -maxdepth 1 -type f -exec cp {} "$BP_DIR/scripts/" \; 2>/dev/null || true
        ;;
      ps)
        [[ -d scripts/powershell ]] && cp -r scripts/powershell "$BP_DIR/scripts/"
        find scripts -maxdepth 1 -type f -exec cp {} "$BP_DIR/scripts/" \; 2>/dev/null || true
        ;;
    esac
  fi

  [[ -d templates ]] && { mkdir -p "$BP_DIR/templates"; find templates -type f -not -path "templates/commands/*" -not -name "vscode-settings.json" -exec cp --parents {} "$BP_DIR"/ \; }

  case $agent in
    claude)
      mkdir -p "$base_dir/.claude/commands"
      generate_commands claude md "\$ARGUMENTS" "$base_dir/.claude/commands" "$script"
      ;;
    gemini)
      mkdir -p "$base_dir/.gemini/commands"
      generate_commands gemini toml "{{args}}" "$base_dir/.gemini/commands" "$script"
      [[ -f agent_templates/gemini/GEMINI.md ]] && cp agent_templates/gemini/GEMINI.md "$base_dir/GEMINI.md"
      ;;
    copilot)
      mkdir -p "$base_dir/.github/prompts"
      generate_commands copilot prompt.md "\$ARGUMENTS" "$base_dir/.github/prompts" "$script"
      mkdir -p "$base_dir/.vscode"
      [[ -f templates/vscode-settings.json ]] && cp templates/vscode-settings.json "$base_dir/.vscode/settings.json"
      ;;
    cursor-agent)
      mkdir -p "$base_dir/.cursor/commands"
      generate_commands cursor-agent md "\$ARGUMENTS" "$base_dir/.cursor/commands" "$script"
      ;;
    qwen)
      mkdir -p "$base_dir/.qwen/commands"
      generate_commands qwen toml "{{args}}" "$base_dir/.qwen/commands" "$script"
      [[ -f agent_templates/qwen/QWEN.md ]] && cp agent_templates/qwen/QWEN.md "$base_dir/QWEN.md"
      ;;
    opencode)
      mkdir -p "$base_dir/.opencode/command"
      generate_commands opencode md "\$ARGUMENTS" "$base_dir/.opencode/command" "$script"
      ;;
    windsurf)
      mkdir -p "$base_dir/.windsurf/workflows"
      generate_commands windsurf md "\$ARGUMENTS" "$base_dir/.windsurf/workflows" "$script"
      ;;
    codex)
      mkdir -p "$base_dir/.codex/prompts"
      generate_commands codex md "\$ARGUMENTS" "$base_dir/.codex/prompts" "$script"
      ;;
    kilocode)
      mkdir -p "$base_dir/.kilocode/workflows"
      generate_commands kilocode md "\$ARGUMENTS" "$base_dir/.kilocode/workflows" "$script"
      ;;
    auggie)
      mkdir -p "$base_dir/.augment/commands"
      generate_commands auggie md "\$ARGUMENTS" "$base_dir/.augment/commands" "$script"
      ;;
    roo)
      mkdir -p "$base_dir/.roo/commands"
      generate_commands roo md "\$ARGUMENTS" "$base_dir/.roo/commands" "$script"
      ;;
    codebuddy)
      mkdir -p "$base_dir/.codebuddy/commands"
      generate_commands codebuddy md "\$ARGUMENTS" "$base_dir/.codebuddy/commands" "$script"
      ;;
    q)
      mkdir -p "$base_dir/.amazonq/prompts"
      generate_commands q md "\$ARGUMENTS" "$base_dir/.amazonq/prompts" "$script"
      ;;
  esac

  (cd "$base_dir" && zip -r "../blueprint-kit-template-${agent}-${script}-${NEW_VERSION}.zip" .)
  echo "Created $GENRELEASES_DIR/blueprint-kit-template-${agent}-${script}-${NEW_VERSION}.zip"
}

ALL_AGENTS=(claude gemini copilot cursor-agent qwen opencode windsurf codex kilocode auggie roo codebuddy q)
ALL_SCRIPTS=(sh ps)

norm_list() {
  tr ',\n' '  ' | awk '{for(i=1;i<=NF;i++){if(!seen[$i]++){printf((out?" ":"") $i)}}}END{printf("\n")}'
}

validate_subset() {
  local type=$1; shift; local -n allowed=$1; shift; local items=("$@")
  local ok=1
  for it in "${items[@]}"; do
    local found=0
    for a in "${allowed[@]}"; do [[ $it == "$a" ]] && { found=1; break; }; done
    if [[ $found -eq 0 ]]; then
      echo "Error: unknown $type '$it' (allowed: ${allowed[*]})" >&2
      ok=0
    fi
  done
  return $ok
}

if [[ -n ${AGENTS:-} ]]; then
  mapfile -t AGENT_LIST < <(printf '%s' "$AGENTS" | norm_list)
  validate_subset agent ALL_AGENTS "${AGENT_LIST[@]}" || exit 1
else
  AGENT_LIST=("${ALL_AGENTS[@]}")
fi

if [[ -n ${SCRIPTS:-} ]]; then
  mapfile -t SCRIPT_LIST < <(printf '%s' "$SCRIPTS" | norm_list)
  validate_subset script ALL_SCRIPTS "${SCRIPT_LIST[@]}" || exit 1
else
  SCRIPT_LIST=("${ALL_SCRIPTS[@]}")
fi

echo "Agents: ${AGENT_LIST[*]}"
echo "Scripts: ${SCRIPT_LIST[*]}"

for agent in "${AGENT_LIST[@]}"; do
  for script in "${SCRIPT_LIST[@]}"; do
    build_variant "$agent" "$script"
  done
done

echo "Archives in $GENRELEASES_DIR:"
ls -1 "$GENRELEASES_DIR"/blueprint-kit-template-*-"$NEW_VERSION".zip