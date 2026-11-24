// Control + h / j / k / l を ← ↓ ↑ → として送る常駐プロセス。
// 全キーを横取りする CGEventTap は Control + Space の入力切り替えを遅らせたため、
// 登録した組み合わせだけが届くホットキー（RegisterEventHotKey）で受ける。
import AppKit
import Carbon

let arrows: [UInt32: CGKeyCode] = [4: 123, 38: 125, 40: 126, 37: 124] // h j k l → ← ↓ ↑ →
// Shift・Option・Command を足した組み合わせも登録し、選択や単語移動に使えるようにする。
let extras: [(carbon: Int, flag: CGEventFlags)] = [
    (shiftKey, .maskShift), (optionKey, .maskAlternate), (cmdKey, .maskCommand),
]
let source = CGEventSource(stateID: .privateState)
var repeaters: [UInt32: Timer] = [:]

// KeyRepeat / InitialKeyRepeat は 1/60 秒単位。システムのキーリピート設定に揃える。
func repeatDelay(_ key: String, fallback: Double) -> TimeInterval {
    let value = UserDefaults.standard.double(forKey: key)
    return (value > 0 ? value : fallback) / 60
}

func send(_ key: CGKeyCode, down: Bool, flags: CGEventFlags, isRepeat: Bool = false) {
    guard let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: down) else { return }
    // 押している Control を外さないと Control + 矢印（操作スペースの移動）になる。
    // 実キーボードの矢印キーと同じフラグを付けないと、一部のアプリが矢印として扱わない。
    event.flags = flags.union([.maskNumericPad, .maskSecondaryFn])
    if isRepeat { event.setIntegerValueField(.keyboardEventAutorepeat, value: 1) }
    event.post(tap: .cghidEventTap)
}

func extraFlags(_ combo: UInt32) -> CGEventFlags {
    extras.enumerated()
        .filter { combo & (1 << UInt32($0.offset)) != 0 }
        .reduce(CGEventFlags()) { $0.union($1.element.flag) }
}

func handle(id: UInt32, pressed: Bool) {
    let code = id >> 4
    guard let arrow = arrows[code] else { return }
    let flags = extraFlags(id & 0xF)
    if pressed {
        // ホットキーのリピートの有無に依らず、リピートは自前のタイマーで出す。
        guard repeaters[code] == nil else { return }
        send(arrow, down: true, flags: flags)
        let timer = Timer(fire: Date().addingTimeInterval(repeatDelay("InitialKeyRepeat", fallback: 15)),
                          interval: repeatDelay("KeyRepeat", fallback: 2), repeats: true) { _ in
            send(arrow, down: true, flags: flags, isRepeat: true)
        }
        RunLoop.main.add(timer, forMode: .common)
        repeaters[code] = timer
    } else {
        repeaters.removeValue(forKey: code)?.invalidate()
        send(arrow, down: false, flags: flags)
    }
}

// キーイベントの送出にはアクセシビリティ権限が要る。許可まで待ち、launchd の再起動ループを避ける。
let prompt = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
if !AXIsProcessTrustedWithOptions(prompt) {
    FileHandle.standardError.write("hjkl-arrows: waiting for accessibility\n".data(using: .utf8)!)
    while !AXIsProcessTrusted() { sleep(5) }
}

var specs = [kEventHotKeyPressed, kEventHotKeyReleased].map {
    EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32($0))
}
InstallEventHandler(GetApplicationEventTarget(), { _, event, _ in
    var hotKey = EventHotKeyID()
    GetEventParameter(event, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID),
                      nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKey)
    handle(id: hotKey.id, pressed: GetEventKind(event) == UInt32(kEventHotKeyPressed))
    return noErr
}, specs.count, &specs, nil, nil)

for code in arrows.keys {
    for combo in 0..<UInt32(1 << extras.count) {
        let modifiers = extras.enumerated()
            .filter { combo & (1 << UInt32($0.offset)) != 0 }
            .reduce(controlKey) { $0 | $1.element.carbon }
        var ref: EventHotKeyRef?
        let id = EventHotKeyID(signature: OSType(0x686A_6B6C), id: code << 4 | combo) // 'hjkl'
        let status = RegisterEventHotKey(code, UInt32(modifiers), id, GetApplicationEventTarget(), 0, &ref)
        if status != noErr {
            FileHandle.standardError.write("hjkl-arrows: failed to register \(code)/\(combo): \(status)\n".data(using: .utf8)!)
        }
    }
}

FileHandle.standardError.write("hjkl-arrows: running\n".data(using: .utf8)!)
NSApplication.shared.setActivationPolicy(.prohibited)
NSApplication.shared.run()
