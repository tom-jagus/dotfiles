#!/bin/bash

CONFIG_INCLUDE_PATH="$HOME/.config/git/config"
GITCONFIG_FILE="$HOME/.gitconfig"

echo "Checking for Git config include..."

# Check if the include path already exists
if grep -qF "$CONFIG_INCLUDE_PATH" "$GITCONFIG_FILE" 2>/dev/null; then
  echo "Git include already exists in ~/.gitconfig"
else
  echo "Adding Git include to ~/.gitconfig..."

  # Ensure the file exists
  mkdir -p "$(dirname "$GITCONFIG_FILE")"
  touch "$GITCONFIG_FILE"

  # Append the include block
  {
    echo ""
    echo "[include]"
    echo "    path = $CONFIG_INCLUDE_PATH"
  } >>"$GITCONFIG_FILE"

  echo "Git include path added: $CONFIG_INCLUDE_PATH"
fi
