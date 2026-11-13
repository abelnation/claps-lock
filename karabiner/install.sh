#!/bin/sh
# Builds the clapstype helper and installs the Claps Lock rule for Karabiner-Elements.
set -eu
here="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$HOME/.local/bin"
swiftc -O "$here/clapstype.swift" -o "$HOME/.local/bin/clapstype"
echo "Built $HOME/.local/bin/clapstype"

dest="$HOME/.config/karabiner/assets/complex_modifications"
mkdir -p "$dest"
cp "$here/claps-lock.json" "$dest/claps-lock.json"
echo "Copied rule to $dest/claps-lock.json"
echo "Next: Karabiner-Elements > Complex Modifications > Add predefined rule > Claps Lock > Enable."
