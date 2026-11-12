#!/bin/sh
# Download and inspect this file before running it. No sudo or shell-profile edits.
set -eu
version=${1:-}
if ! printf '%s' "$version" | LC_ALL=C grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+([.-][A-Za-z0-9.-]+)?$'; then
  echo 'Usage: sh install.sh v0.1.0 (choose a published release)' >&2; exit 2
fi
case "$(uname -s)" in Darwin) os=darwin;; Linux) os=linux;; *) echo 'Use install.ps1 on Windows' >&2; exit 2;; esac
case "$(uname -m)" in arm64|aarch64) arch=arm64;; x86_64|amd64) arch=amd64;; *) echo 'Unsupported CPU architecture' >&2; exit 2;; esac
name="archinario_${version#v}_${os}_${arch}.tar.gz"
base="https://github.com/archinario/archinario-agent/releases/download/$version"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM
curl --fail --show-error --silent --location --proto '=https' --tlsv1.2 "$base/$name" -o "$work/$name"
curl --fail --show-error --silent --location --proto '=https' --tlsv1.2 "$base/SHA256SUMS" -o "$work/SHA256SUMS"
expected=$(awk -v file="$name" '$2==file {print $1}' "$work/SHA256SUMS")
[ "${#expected}" -eq 64 ] || { echo 'Release checksum is missing or invalid' >&2; exit 1; }
if command -v sha256sum >/dev/null 2>&1; then actual=$(sha256sum "$work/$name" | awk '{print $1}'); else actual=$(shasum -a 256 "$work/$name" | awk '{print $1}'); fi
[ "$expected" = "$actual" ] || { echo 'Checksum mismatch; nothing installed' >&2; exit 1; }
tar -xzf "$work/$name" -C "$work" archinario
[ -f "$work/archinario" ] && [ ! -L "$work/archinario" ] || { echo 'Invalid archive binary' >&2; exit 1; }
destination=${ARCHINARIO_INSTALL_DIR:-"$HOME/.local/bin"}
mkdir -p "$destination"
install -m 755 "$work/archinario" "$destination/archinario"
"$destination/archinario" version
printf 'Installed: %s/archinario\nUse this absolute path in MCP settings.\n' "$destination"
