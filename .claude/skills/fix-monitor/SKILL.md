---
name: fix-monitor
description: Fix the external monitor (LG ULTRAWIDE over HDMI) not showing up on the Mac. Use when the user says their monitor or external display is not working, not detected, or black.
---

# Fix external monitor not detected

The setup: MacBook Pro (M2 Pro) with an LG ULTRAWIDE on the built-in HDMI port, display settings managed by Lunar.

The usual failure: macOS shows only the built-in screen, but the hardware is fine. The fix is to wipe the WindowServer display config (both copies) and restart in a way that stops macOS from writing the old config back.

## 1. Diagnose

Run these and compare with the patterns below.

```bash
# What the window system has turned on
system_profiler SPDisplaysDataType | grep -E '^\s{8}\S.*:$|Resolution|Online'

# Whether the HDMI side sees the monitor at all
ioreg -lw0 | grep -c 'LG ULTRAWIDE'
ioreg -lw0 | grep '"LinkActive"'
```

For a more reliable answer than system_profiler, ask CoreGraphics directly. Save this to a temp file and run it with `swift`:

```swift
import CoreGraphics
var n: UInt32 = 0; var ids = [CGDirectDisplayID](repeating: 0, count: 16)
CGGetOnlineDisplayList(16, &ids, &n); print("online:", n)
for i in 0..<Int(n) { let d = ids[i]; print(d, CGDisplayIsBuiltin(d) != 0 ? "builtin" : "external", "asleep:", CGDisplayIsAsleep(d) != 0, CGDisplayPixelsWide(d), "x", CGDisplayPixelsHigh(d)) }
```

What the results mean:

- **ioreg finds `LG ULTRAWIDE` and `LinkActive = Yes`, but only the built-in display is online.** The cable and port work, and the saved display config is bad. Go to step 2.
- **ioreg finds nothing for the LG.** Physical problem. Check the cable at both ends, the monitor's input source, and power cycle the monitor for 30 seconds. Try a different cable or a USB-C adapter before touching config files.

## 2. Rule out the quick causes

- **Lunar BlackOut.** The saved Lunar config binds BlackOut to `Ctrl + Cmd + 6`, which blanks the monitor and looks exactly like it died. Check with `defaults read fyi.lunar.Lunar | grep -o '\\"blackout\\":[a-z]*'` (all should be false) and look for `keepDisconnected` set to true. Quitting Lunar (`osascript -e 'tell application "Lunar" to quit'`) and checking again also rules it out. Relaunch it afterwards with `open -a Lunar`.
- **Asleep display.** `caffeinate -u -t 2`, then check again.
- **Stuck HDMI handshake.** Ask the user to unplug the HDMI cable for 10 seconds and plug it back in.

If none of these help, go to step 3.

## 3. Back up the display config

There are two files, and both matter:

- `~/Library/Preferences/ByHost/com.apple.windowserver.displays.<id>.plist` (user copy)
- `/Library/Preferences/com.apple.windowserver.displays.plist` (system copy, owned by root)

Back them up to the home folder. Do not use the Claude scratchpad or `/tmp`, because they are wiped on restart.

```bash
B=~/windowserver-backup-$(date +%Y%m%d)
mkdir -p "$B"
cp -p ~/Library/Preferences/ByHost/com.apple.windowserver*.plist /Library/Preferences/com.apple.windowserver.displays.plist "$B/"
```

## 4. Delete both files and restart immediately

Tell the user this restarts the Mac right away with no save prompts, ends the Claude session, and needs their password. Get a yes before running it.

sudo needs a password, so run it through the macOS admin dialog:

```bash
osascript -e 'do shell script "rm -f /Library/Preferences/com.apple.windowserver.displays.plist '"$HOME"'/Library/Preferences/ByHost/com.apple.windowserver*.plist && shutdown -r now" with administrator privileges with prompt "Reset display config and restart to fix the external monitor."'
```

The user can also run it themselves with `!`:

```bash
sudo rm -f /Library/Preferences/com.apple.windowserver.displays.plist ~/Library/Preferences/ByHost/com.apple.windowserver*.plist && sudo shutdown -r now
```

Why it has to be done this way:

- **Delete both files.** Deleting only the user copy (what the old `scripts/fix-monitor.sh` did) is not enough. The system copy keeps the bad config.
- **Use `shutdown -r now`, not a normal restart.** A normal restart (Apple menu, or `osascript -e 'tell application "System Events" to restart'`) lets macOS write its in-memory display config back to disk during logout, which undoes the delete.

## 5. Verify after the restart

When the user is back, run the step 1 checks again. Success looks like the LG listed as online at 2560 x 1080 next to the built-in display, and a fresh, small `/Library/Preferences/com.apple.windowserver.displays.plist` (about 1 KB instead of 20 KB or more).

## 6. Make the LG the main display

After the reset macOS makes the built-in screen the main display. The user wants the LG as main (menu bar and Dock) with the built-in screen to its right. Run:

```bash
swift ~/.dotfiles/.claude/skills/fix-monitor/set-main-display.swift
```

It moves the external display to (0, 0), which is what makes it main, and shifts the built-in screen by the same amount so the arrangement stays the same. Check the result with the CoreGraphics snippet from step 1, or with `CGDisplayIsMain`.

If Lunar brightness or display settings look wrong afterwards, restore them with `~/.dotfiles/scripts/lunar-restore.sh`.

Once everything works, the user can delete the backup folder.

## History

- 2026-11-19: Only the built-in screen came up. The HDMI link was up and the LG's EDID was readable. The old `scripts/fix-monitor.sh` (now removed) plus a normal restart did not work, because the config was written back on shutdown. Quitting Lunar and replugging HDMI did not work either. Deleting both plists and running `shutdown -r now` fixed it.
