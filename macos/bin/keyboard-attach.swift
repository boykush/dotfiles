// 外付けキーボードの接続で launchd に起動され、`mise run macos:keyboard` を流す。
// IOKit マッチングのイベントは XPC で受け取らないと launchd が起動し直し続けるため、
// シェルではなく Swift で受け取る。
import Foundation
import XPC

xpc_set_event_stream_handler("com.apple.iokit.matching", DispatchQueue.main) { _ in }

// デバイスの接続直後は HID のサービスがまだ揃っておらず、hidutil の --matching が空振りする。
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/bin/zsh")
    // 未導入ツールの自動インストールを待つと、割り当てがその間ずっと入らないため止める。
    task.arguments = ["-c", "MISE_TASK_RUN_AUTO_INSTALL=false exec \"$HOME/dotfiles/bin/mise\" run macos:keyboard"]
    do {
        try task.run()
        task.waitUntilExit()
        exit(task.terminationStatus)
    } catch {
        FileHandle.standardError.write("failed to run macos:keyboard: \(error)\n".data(using: .utf8)!)
        exit(1)
    }
}

dispatchMain()
