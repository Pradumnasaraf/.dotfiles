// Makes the external display the main one (menu bar and Dock) and keeps the
// current arrangement by shifting every display so the external sits at (0, 0).
// Run with: swift set-main-display.swift
import CoreGraphics
var n: UInt32 = 0; var ids = [CGDirectDisplayID](repeating: 0, count: 16)
CGGetOnlineDisplayList(16, &ids, &n)
let displays = Array(ids.prefix(Int(n)))
guard let ext = displays.first(where: { CGDisplayIsBuiltin($0) == 0 }) else { print("No external display found"); exit(1) }
let o = CGDisplayBounds(ext).origin
var cfg: CGDisplayConfigRef?
CGBeginDisplayConfiguration(&cfg)
for d in displays { let b = CGDisplayBounds(d); CGConfigureDisplayOrigin(cfg, d, Int32(b.origin.x - o.x), Int32(b.origin.y - o.y)) }
let err = CGCompleteDisplayConfiguration(cfg, .permanently)
print(err == .success ? "External display is now main" : "Failed: \(err.rawValue)")
