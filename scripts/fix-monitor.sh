#!/bin/bash
#
# Fix: external monitor not detected on macOS.
# Removes WindowServer preference files so macOS regenerates display config on next boot.
# A reboot is required for changes to take effect.

set -e

TARGET="$HOME/Library/Preferences/ByHost/com.apple.windowserver"*.plist

shopt -s nullglob 2>/dev/null || true
files=( $TARGET )

if [ ${#files[@]} -eq 0 ]; then
  echo "No com.apple.windowserver*.plist files found in ~/Library/Preferences/ByHost/"
  exit 0
fi

echo "Removing the following files:"
for f in "${files[@]}"; do
  echo "  $f"
done

rm -f $TARGET

echo ""
echo "Done. Reboot your Mac for the changes to take effect."
