// clapstype: types a Unicode string at the cursor.
//
// Karabiner-Elements cannot send emoji directly, so the Claps Lock rule calls
// this helper through shell_command.
//
// Usage: clapstype [text]      (default text: " 👏 ")

import CoreGraphics
import Foundation

let args = CommandLine.arguments.dropFirst()
let text = args.isEmpty ? " 👏 " : args.joined(separator: " ")

// One CGEvent carries at most 20 UTF-16 units, so send the text in chunks.
let units = Array(text.utf16)
let chunkSize = 20
let spaceKey: CGKeyCode = 49

for start in stride(from: 0, to: units.count, by: chunkSize) {
    let chunk = Array(units[start..<min(start + chunkSize, units.count)])
    for keyDown in [true, false] {
        guard let event = CGEvent(keyboardEventSource: nil, virtualKey: spaceKey, keyDown: keyDown) else {
            FileHandle.standardError.write("clapstype: cannot create event\n".data(using: .utf8)!)
            exit(1)
        }
        event.flags = []
        event.keyboardSetUnicodeString(stringLength: chunk.count, unicodeString: chunk)
        event.post(tap: .cghidEventTap)
    }
}
