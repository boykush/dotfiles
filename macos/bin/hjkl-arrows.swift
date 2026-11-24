// 右 Control を押している間だけ h / j / k / l を ← ↓ ↑ → に読み替える常駐プロセス。
// 物理の左 Control は hidutil で右 Control に読み替えてある（macos/*-keyboard.json）。
// Caps Lock 由来の左 Control と区別でき、Ctrl+H などの通常の Control 操作を残せる。
import ApplicationServices
import Foundation

let arrows: [Int64: Int64] = [4: 123, 38: 125, 40: 126, 37: 124] // h j k l → ← ↓ ↑ →
let rightControl: UInt64 = 0x2000 // NX_DEVICERCTLKEYMASK
let leftControl: UInt64 = 0x0001  // NX_DEVICELCTLKEYMASK
var remapped = Set<Int64>()
var tap: CFMachPort?

func remap(_ event: CGEvent, to arrow: Int64) {
    event.setIntegerValueField(.keyboardEventKeycode, value: arrow)
    var flags = event.flags.rawValue & ~rightControl
    if flags & leftControl == 0 { flags &= ~CGEventFlags.maskControl.rawValue }
    // 実キーボードの矢印キーと同じフラグを付けないと、一部のアプリが矢印として扱わない。
    flags |= CGEventFlags.maskNumericPad.rawValue | CGEventFlags.maskSecondaryFn.rawValue
    event.flags = CGEventFlags(rawValue: flags)
}

let callback: CGEventTapCallBack = { _, type, event, _ in
    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        if let tap { CGEvent.tapEnable(tap: tap, enable: true) }
        return Unmanaged.passUnretained(event)
    }
    let code = event.getIntegerValueField(.keyboardEventKeycode)
    guard let arrow = arrows[code] else { return Unmanaged.passUnretained(event) }
    if type == .keyDown {
        if event.flags.rawValue & rightControl != 0 {
            remapped.insert(code)
            remap(event, to: arrow)
        } else {
            remapped.remove(code)
        }
    } else if type == .keyUp, remapped.remove(code) != nil {
        // Control を先に離しても、押し始めた矢印の keyUp を送って押しっぱなしを防ぐ。
        remap(event, to: arrow)
    }
    return Unmanaged.passUnretained(event)
}

// 権限が無いとタップを作れない。許可されるまで待ち、launchd の再起動ループを避ける。
let prompt = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
_ = AXIsProcessTrustedWithOptions(prompt)
_ = CGRequestListenEventAccess()
var waiting = ""
while true {
    let missing = [AXIsProcessTrusted() ? nil : "accessibility", CGPreflightListenEventAccess() ? nil : "input monitoring"]
        .compactMap { $0 }.joined(separator: ", ")
    if missing.isEmpty { break }
    if missing != waiting {
        FileHandle.standardError.write("hjkl-arrows: waiting for \(missing)\n".data(using: .utf8)!)
        waiting = missing
    }
    sleep(5)
}

let mask = CGEventMask((1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue))
guard let created = CGEvent.tapCreate(
    tap: .cgSessionEventTap, place: .headInsertEventTap, options: .defaultTap,
    eventsOfInterest: mask, callback: callback, userInfo: nil
) else {
    FileHandle.standardError.write("failed to create event tap\n".data(using: .utf8)!)
    exit(1)
}
tap = created
CFRunLoopAddSource(CFRunLoopGetCurrent(), CFMachPortCreateRunLoopSource(nil, created, 0), .commonModes)
CGEvent.tapEnable(tap: created, enable: true)
FileHandle.standardError.write("hjkl-arrows: running\n".data(using: .utf8)!)
CFRunLoopRun()
