; Claps Lock for AutoHotkey v2 (Windows).
;
; Double-tap Caps Lock to enter "claps lock" mode:
;   * Caps Lock stays on, so letters are upper case.
;   * Each space becomes " 👏 ".
; Tap Caps Lock once to leave the mode.
;
; Save this file as UTF-8 so the emoji survives.

#Requires AutoHotkey v2.0
#SingleInstance Force

DoubleTapMs := 400
Replacement := " 👏 "

clapsMode := false
lastTap := 0

*CapsLock:: {
    global clapsMode, lastTap
    now := A_TickCount

    if clapsMode {
        ; One tap ends the mode.
        clapsMode := false
        lastTap := 0
        SetCapsLockState "Off"
        ToolTip
    } else if (now - lastTap <= DoubleTapMs) {
        ; Second tap: enter the mode. Caps Lock is on whatever its state was.
        clapsMode := true
        lastTap := 0
        SetCapsLockState "On"
        CoordMode "ToolTip", "Screen"
        ToolTip "👏 CLAPS LOCK 👏", 0, 0
    } else {
        ; First tap: normal Caps Lock toggle.
        lastTap := now
        SetCapsLockState GetKeyState("CapsLock", "T") ? "Off" : "On"
    }

    ; Wait for release so key repeat does not count as a second tap.
    KeyWait "CapsLock"
}

#HotIf clapsMode
; No "*" prefix, so Ctrl/Alt/Win + Space keep their normal behavior.
Space::SendText Replacement
+Space::SendText Replacement
#HotIf
