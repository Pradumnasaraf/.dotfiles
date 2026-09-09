#!/bin/bash
#
# Backup: Lunar display settings into this repo.
# Exports ~/Library/Preferences/fyi.lunar.Lunar.plist as readable XML with
# secrets stripped out (license tokens, local API key, GPS coordinates).
# Run this after changing Lunar settings you want to keep.

set -e

SRC="$HOME/Library/Preferences/fyi.lunar.Lunar.plist"
DEST_DIR="$(cd "$(dirname "$0")/.." && pwd)/lunar"
DEST="$DEST_DIR/fyi.lunar.Lunar.plist.xml"

if [ ! -f "$SRC" ]; then
  echo "Lunar preferences not found at $SRC"
  exit 1
fi

mkdir -p "$DEST_DIR"

python3 - "$SRC" "$DEST" <<'PY'
import plistlib, sys

src, dest = sys.argv[1], sys.argv[2]

# This repo is public, so these keys never get committed. The real ones to
# keep out are the local CLI API key and the home coordinates used for solar
# mode. The Paddle and Sparkle keys are per-install bookkeeping (the Lunar
# licence here is the free tier), so they are dropped as noise, not secrets.
DROP_EXACT = {
    "apiKey", "secure", "location", "paddleUUID",
    "SUHasLaunchedBefore", "SULastCheckTime", "SUUpdateGroupIdentifier",
    # Solar times are computed from the coordinates above. Day length with a
    # date gives latitude back, and solar noon gives longitude, so leaving
    # these in would undo the point of dropping "location".
    "sunrise", "sunset", "solarNoon", "dayLength",
    "civilTwilightBegin", "civilTwilightEnd",
    "nauticalTwilightBegin", "nauticalTwilightEnd",
    "astronomicalTwilightBegin", "astronomicalTwilightEnd",
}
DROP_PREFIX = ("Paddle-",)

with open(src, "rb") as f:
    prefs = plistlib.load(f)

removed = []
for key in list(prefs):
    if key in DROP_EXACT or key.startswith(DROP_PREFIX):
        del prefs[key]
        removed.append(key)

with open(dest, "wb") as f:
    plistlib.dump(prefs, f, fmt=plistlib.FMT_XML, sort_keys=True)

print("Wrote %s" % dest)
print("Saved %d settings, stripped %d: %s" % (len(prefs), len(removed), ", ".join(sorted(removed))))
PY
