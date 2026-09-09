#!/bin/bash
#
# Restore: Lunar display settings from this repo.
# Quits Lunar, applies the saved settings over the live preferences while
# keeping this machine's local values (API key, coordinates, activation),
# then relaunches Lunar.

set -e

SAVED="$(cd "$(dirname "$0")/.." && pwd)/lunar/fyi.lunar.Lunar.plist.xml"
LIVE="$HOME/Library/Preferences/fyi.lunar.Lunar.plist"

if [ ! -f "$SAVED" ]; then
  echo "No saved Lunar settings found at $SAVED"
  exit 1
fi

if [ -f "$LIVE" ]; then
  BACKUP="$LIVE.$(date +%Y%m%d-%H%M%S).bak"
  cp "$LIVE" "$BACKUP"
  echo "Current settings backed up to $BACKUP"
fi

echo "Quitting Lunar so it does not overwrite the file on exit."
osascript -e 'tell application "Lunar" to quit' 2>/dev/null || true
for _ in $(seq 1 10); do
  pgrep -x Lunar >/dev/null || break
  sleep 1
done
if pgrep -x Lunar >/dev/null; then
  killall Lunar 2>/dev/null || true
  sleep 1
fi

python3 - "$SAVED" "$LIVE" <<'PY'
import os, plistlib, sys

saved, live = sys.argv[1], sys.argv[2]

# Values that belong to this machine, not to the saved config.
KEEP_EXACT = {
    "apiKey", "secure", "location", "paddleUUID",
    "SUHasLaunchedBefore", "SULastCheckTime", "SUUpdateGroupIdentifier",
}
KEEP_PREFIX = ("Paddle-",)

with open(saved, "rb") as f:
    prefs = plistlib.load(f)

current = {}
if os.path.exists(live):
    with open(live, "rb") as f:
        current = plistlib.load(f)

kept = []
for key, value in current.items():
    if key in KEEP_EXACT or key.startswith(KEEP_PREFIX):
        prefs[key] = value
        kept.append(key)

with open(live, "wb") as f:
    plistlib.dump(prefs, f, fmt=plistlib.FMT_BINARY)
os.chmod(live, 0o600)

print("Restored %d settings." % len(prefs))
if kept:
    print("Kept local values: %s" % ", ".join(sorted(kept)))
PY

# Drop the preferences cache so Lunar reads the file we just wrote.
killall cfprefsd 2>/dev/null || true

open -a Lunar
echo "Done. Lunar relaunched."
