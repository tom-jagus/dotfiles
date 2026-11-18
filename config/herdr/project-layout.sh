#!/usr/bin/env bash
# Apply the usual Pi, shell, and Neovim layout to an idle single-pane tab.
set -Eeuo pipefail

error_message="The layout may be incomplete. Check the workspace."

fail() {
    "${HERDR_BIN_PATH:-herdr}" notification show "Layout not applied" \
        --body "$error_message" >/dev/null 2>&1 || true
    exit 1
}
trap fail ERR

pane=${HERDR_ACTIVE_PANE_ID:-}
cwd=${HERDR_ACTIVE_PANE_CWD:-}
herdr=${HERDR_BIN_PATH:-herdr}
[[ -n "$pane" && -n "$cwd" ]] || {
    printf 'Herdr did not provide the active pane ID and directory.\n' >&2
    false
}

for cmd in "$herdr" jq pi nvim; do
    command -v "$cmd" >/dev/null || { printf 'Missing command: %s\n' "$cmd" >&2; false; }
done
[[ -d "$cwd" ]] || { printf 'Directory does not exist: %s\n' "$cwd" >&2; false; }

layout=$("$herdr" pane layout --pane "$pane")
[[ $(jq '.result.layout.panes | length' <<<"$layout") == 1 ]] || {
    error_message="Open a tab with one shell pane before applying the layout."
    false
}

process=$("$herdr" pane process-info --pane "$pane")
jq -e '.result.process_info as $p | ($p.foreground_processes | length == 1 and .[0].pid == $p.shell_pid)' <<<"$process" >/dev/null || {
    printf 'The current pane must have an idle foreground shell.\n' >&2
    false
}

right=$("$herdr" pane split "$pane" --direction right --ratio 0.5 --cwd "$cwd" --no-focus | jq -er '.result.pane.pane_id')
"$herdr" pane split "$pane" --direction down --ratio 0.64 --cwd "$cwd" --no-focus >/dev/null
"$herdr" pane run "$right" 'nvim' >/dev/null
"$herdr" pane run "$pane" 'pi' >/dev/null
