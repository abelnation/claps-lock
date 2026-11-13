# Claps Lock

Double-tap Caps Lock to type LIKE 👏 THIS 👏 RIGHT 👏 HERE.

In Claps Lock mode, Caps Lock is on and each space becomes ` 👏 `.
Tap Caps Lock once to leave the mode.

There are two versions. Use one of them, not both.

## Hammerspoon

1. Copy `hammerspoon/claps_lock.lua` to `~/.hammerspoon/`.
2. Add these lines to `~/.hammerspoon/init.lua`:

   ```lua
   clapsLock = require("claps_lock")
   clapsLock.start()
   ```

3. Reload the Hammerspoon config.
4. Give Hammerspoon Accessibility access if macOS asks.

A 👏 icon shows in the menu bar while the mode is on.
To change the timing, set `clapsLock.doubleTapWindow` (seconds) before `start()`.

## Karabiner-Elements

Karabiner-Elements cannot send emoji. The rule calls a small Swift helper,
`clapstype`, that types ` 👏 ` through a CGEvent.

1. Run `karabiner/install.sh`. It needs the Xcode command line tools (`swiftc`).
   It builds `~/.local/bin/clapstype` and copies the rule file to
   `~/.config/karabiner/assets/complex_modifications/`.
2. In Karabiner-Elements, open Complex Modifications > Add predefined rule.
   Enable "Claps Lock".
3. Give Accessibility access if macOS asks. The helper posts keyboard events.

## Known limits

- Both versions replace every space, including a space after the last word.
- Holding space repeats the replacement.
- Karabiner: the helper runs as a separate process. If you type very fast,
  a letter can land before the ` 👏 `.
- Karabiner: the rule tracks Caps Lock state in its own variable. If Caps Lock
  changes outside the rule (for example, it was on before Karabiner started),
  the first double-tap can leave Caps Lock off. Tap once more to resync.
- Apple keyboards ignore very short Caps Lock taps. If a double-tap does not
  register in the Hammerspoon version, hold each tap a little longer.

## License

GPL-3.0. See `LICENSE`.
