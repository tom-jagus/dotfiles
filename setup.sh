#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
  printf 'Usage: %s\n' "$0" >&2
  exit 2
fi

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
config_home=${XDG_CONFIG_HOME:-$HOME/.config}
plugins_file="$repo_root/config/herdr-plugins"

for command in herdr jq; do
  command -v "$command" >/dev/null || { printf 'Required command missing: %s\n' "$command" >&2; exit 1; }
done
[[ -f "$plugins_file" ]] || { printf 'Missing plugin list: %s\n' "$plugins_file" >&2; exit 1; }

sources=(
  "$repo_root/.bashrc"
  "$repo_root/config/starship.toml"
  "$repo_root/config/herdr"
  "$repo_root/config/yazi"
)
targets=(
  "$HOME/.bashrc"
  "$config_home/starship.toml"
  "$config_home/herdr"
  "$config_home/yazi"
)

# Check everything before changing any targets.
for source in "${sources[@]}"; do
  if [[ ! -e "$source" ]]; then
    printf 'Missing source: %s\n' "$source" >&2
    exit 1
  fi
done
for source in "$repo_root/config/herdr" "$repo_root/config/yazi"; do
  if [[ ! -d "$source" ]]; then
    printf 'Expected directory: %s\n' "$source" >&2
    exit 1
  fi
done

for i in "${!sources[@]}"; do
  source=${sources[$i]}
  target=${targets[$i]}
  if [[ -L "$target" && $(readlink -f -- "$target" 2>/dev/null || true) == "$source" ]]; then
    printf 'Already linked: %s\n' "$target"
    continue
  fi

  mkdir -p -- "$(dirname -- "$target")"
  if [[ -e "$target" || -L "$target" ]]; then
    backup="$target.backup.$(date +%Y%m%d%H%M%S)"
    suffix=1
    while [[ -e "$backup" || -L "$backup" ]]; do
      backup="$target.backup.$(date +%Y%m%d%H%M%S).$suffix"
      ((suffix += 1))
    done
    mv -- "$target" "$backup"
    printf 'Backed up: %s -> %s\n' "$target" "$backup"
  fi
  ln -s -- "$source" "$target"
  printf 'Linked: %s -> %s\n' "$target" "$source"
done

while read -r id repository extra || [[ -n ${id:-} ]]; do
  [[ -z ${id:-} || $id == \#* ]] && continue
  if [[ -z ${repository:-} || -n ${extra:-} || ! $id =~ ^[a-z0-9][a-z0-9_-]*$ || ! $repository =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]]; then
    printf 'Invalid plugin entry in %s: %s %s %s\n' "$plugins_file" "$id" "${repository:-}" "${extra:-}" >&2
    exit 1
  fi
  installed=$(herdr plugin list --plugin "$id" --json)
  if jq -e '.result.plugins | length > 0' >/dev/null <<< "$installed"; then
    printf 'Already installed: %s\n' "$id"
  else
    herdr plugin install "$repository" --yes
  fi
done < "$plugins_file"
