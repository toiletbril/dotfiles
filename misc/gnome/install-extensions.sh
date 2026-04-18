#!/usr/bin/env bash

set -euo pipefail

DCONF_FILE="${1:?Usage: $0 <dconf-dump-file>}"
EGO_API="https://extensions.gnome.org"

for cmd in jq curl gnome-shell gnome-extensions; do
    command -v "$cmd" &>/dev/null || { echo "Missing dependency: $cmd"; exit 1; }
done

# extract GNOME Shell version in multiple forms for API matching
SHELL_VERSION_FULL=$(gnome-shell --version | grep -oP '\d+(\.\d+)*')
SHELL_VERSION_MAJOR=$(echo "$SHELL_VERSION_FULL" | cut -d. -f1)
echo "GNOME Shell version: $SHELL_VERSION_FULL (major: $SHELL_VERSION_MAJOR)"

# parse enabled-extensions from the dconf dump
# format in dump: enabled-extensions=['uuid@foo', 'uuid@bar']
RAW=$(grep -oP "enabled-extensions=\K.*" "$DCONF_FILE" || true)

if [[ -z "$RAW" ]]; then
    echo "No enabled-extensions key found in $DCONF_FILE"
    exit 1
fi

# parse GVariant array into JSON array, then extract with jq
# format: ['uuid@foo', 'uuid@bar'] or @as ['uuid@foo', 'uuid@bar']
mapfile -t UUIDS < <(
  echo "$RAW" \
  | sed "s/^@as //" \
  | tr "'" '"' \
  | jq -r '.[]'
)

echo "Found ${#UUIDS[@]} extension(s) to install:"
printf '  %s\n' "${UUIDS[@]}"
echo ""

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

FAILED=()
SKIPPED=()
INSTALLED=()

for UUID in "${UUIDS[@]}"; do
  # skip if already installed
  if gnome-extensions info "$UUID" &>/dev/null; then
    SKIPPED+=("$UUID")
    echo "[skip] $UUID already installed"
    continue
  fi

  echo "[fetch] $UUID"

  ZIP="${TMPDIR}/${UUID}.zip"

  # the download endpoint resolves the best version server-side via 302
  if ! curl -sfL -o "$ZIP" "${EGO_API}/download-extension/${UUID}.shell-extension.zip?shell_version=${SHELL_VERSION_MAJOR}"; then
    echo "  -> not found or no compatible version"
    FAILED+=("$UUID")
    continue
  fi

  if gnome-extensions install --force "$ZIP" 2>/dev/null; then
    echo "  -> installed"
    INSTALLED+=("$UUID")
  else
    echo "  -> install command failed"
    FAILED+=("$UUID")
  fi
done

echo ""
echo "Installed: ${#INSTALLED[@]}"
echo "Skipped  : ${#SKIPPED[@]}"
echo "Failed   : ${#FAILED[@]}"

if [[ ${#FAILED[@]} -gt 0 ]]; then
    printf '  FAILED: %s\n' "${FAILED[@]}"
fi
