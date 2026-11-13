-- Claps Lock for Hammerspoon.
--
-- Double-tap Caps Lock to enter "claps lock" mode:
--   * Caps Lock stays on, so letters are upper case.
--   * Each space becomes " 👏 ".
-- Tap Caps Lock once to leave the mode.
--
-- Install: copy this file to ~/.hammerspoon/ and add to ~/.hammerspoon/init.lua:
--   clapsLock = require("claps_lock")
--   clapsLock.start()

local M = {}

M.doubleTapWindow = 0.4      -- seconds between the two taps
M.replacement = " 👏 "

local CAPS_KEYCODE = 57
local SPACE_KEYCODE = 49
local ALPHA_SHIFT = hs.eventtap.event.rawFlagMasks.alphaShift

local active = false
local lastOnTime = 0
local flagsTap, keyTap, menu

local function setActive(on)
    active = on
    if on then
        if not menu then
            menu = hs.menubar.new()
            menu:setTitle("👏")
            menu:setTooltip("Claps Lock is on")
        end
        hs.alert.show("👏 CLAPS LOCK 👏", 0.8)
    else
        if menu then
            menu:delete()
            menu = nil
        end
        hs.alert.show("Claps Lock off", 0.6)
    end
end

-- Caps Lock sends flagsChanged events. Read the new Caps Lock state from the
-- event, then detect an ON -> OFF change inside the double-tap window.
local function onFlagsChanged(e)
    if e:getKeyCode() ~= CAPS_KEYCODE then return false end

    local capsOn = (e:rawFlags() & ALPHA_SHIFT) ~= 0
    local now = hs.timer.secondsSinceEpoch()

    if active then
        -- The ON event that our own capslock.set(true) makes arrives here too.
        -- Only an OFF change ends the mode.
        if not capsOn then
            lastOnTime = 0
            setActive(false)
        end
        return false
    end

    if capsOn then
        lastOnTime = now
    elseif now - lastOnTime <= M.doubleTapWindow then
        -- Second tap turned Caps Lock off again. Turn it back on and enter the mode.
        lastOnTime = 0
        hs.hid.capslock.set(true)
        setActive(true)
    end
    return false
end

local function onKeyDown(e)
    if not active or e:getKeyCode() ~= SPACE_KEYCODE then return false end

    -- Leave Cmd/Ctrl/Opt + Space (Spotlight, input source switch) alone.
    local f = e:getFlags()
    if f.cmd or f.ctrl or f.alt then return false end

    local down = hs.eventtap.event.newKeyEvent({}, "space", true)
    local up = hs.eventtap.event.newKeyEvent({}, "space", false)
    down:setUnicodeString(M.replacement)
    up:setUnicodeString(M.replacement)
    -- Drop the original space and post the replacement in its place.
    return true, { down, up }
end

function M.start()
    M.stop()
    flagsTap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, onFlagsChanged)
    keyTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, onKeyDown)
    flagsTap:start()
    keyTap:start()
    return M
end

function M.stop()
    if flagsTap then flagsTap:stop() end
    if keyTap then keyTap:stop() end
    flagsTap, keyTap = nil, nil
    if active then setActive(false) end
end

function M.isActive()
    return active
end

return M
