--[[
    SpeedHub X | Blue Library — Full Component Example
    Every component is visible and working.
    Replace the URL below with wherever you host libs_blue.lua
]]

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/biarzxc1/library/refs/heads/main/libs.lua"
))()

-- ══════════════════════════════════════════
--  WINDOW
-- ══════════════════════════════════════════
local Window = Library:CreateWindow({
    ["Title"]       = "Kaizen Hub",
    ["Description"] = "",
    ["Tab Width"]   = 160,
})

-- ══════════════════════════════════════════
--  TAB 1 — Main
-- ══════════════════════════════════════════
local MainTab = Window:CreateTab({
    ["Name"] = "Main",
    ["Icon"] = "rbxassetid://10723407389",
})

local MainSection = MainTab:AddSection("Main Controls", true)

-- Paragraph
MainSection:AddParagraph({
    ["Title"]   = "Welcome",
    ["Content"] = "This is a paragraph component. Use it to show info to the user.",
})

-- Separator
MainSection:AddSeperator({
    ["Title"] = "Movement",
})

-- Toggle
local SpeedToggle = MainSection:AddToggle({
    ["Title"]    = "Speed Boost",
    ["Content"]  = "Enables fast walk speed",
    ["Default"]  = false,
    ["Callback"] = function(value)
        local char = game.Players.LocalPlayer.Character
        if char then
            char.Humanoid.WalkSpeed = value and 80 or 16
        end
    end,
})

-- Slider
local SpeedSlider = MainSection:AddSlider({
    ["Title"]     = "Walk Speed",
    ["Content"]   = "Drag or type a value",
    ["Increment"] = 1,
    ["Min"]       = 16,
    ["Max"]       = 250,
    ["Default"]   = 50,
    ["Callback"]  = function(value)
        local char = game.Players.LocalPlayer.Character
        if char then
            char.Humanoid.WalkSpeed = value
        end
    end,
})

-- Line divider
MainSection:AddLine()

-- Slider
local JumpSlider = MainSection:AddSlider({
    ["Title"]     = "Jump Power",
    ["Content"]   = "How high you jump",
    ["Increment"] = 5,
    ["Min"]       = 50,
    ["Max"]       = 500,
    ["Default"]   = 50,
    ["Callback"]  = function(value)
        local char = game.Players.LocalPlayer.Character
        if char then
            char.Humanoid.JumpPower = value
        end
    end,
})

-- Button
MainSection:AddButton({
    ["Title"]    = "Reset Character",
    ["Content"]  = "Respawns your character",
    ["Icon"]     = "rbxassetid://10734933222",
    ["Callback"] = function()
        game.Players.LocalPlayer:LoadCharacter()
    end,
})

-- ══════════════════════════════════════════
--  TAB 2 — Settings
-- ══════════════════════════════════════════
local SettingsTab = Window:CreateTab({
    ["Name"] = "Settings",
    ["Icon"] = "rbxassetid://10734950309",
})

local SettingsSection = SettingsTab:AddSection("Player Settings", true)

-- Input
local NameInput = SettingsSection:AddInput({
    ["Title"]    = "Display Name",
    ["Content"]  = "Shown above your head",
    ["Default"]  = "Player",
    ["Callback"] = function(value)
        -- apply name logic here
    end,
})

-- Separator
SettingsSection:AddSeperator({
    ["Title"] = "Toggles",
})

-- Toggle (default ON)
local AntiAFKToggle = SettingsSection:AddToggle({
    ["Title"]    = "Anti-AFK",
    ["Content"]  = "Prevents being kicked for idling",
    ["Default"]  = true,
    ["Callback"] = function(value)
        -- handle anti-afk logic here
    end,
})

-- Toggle
local NoclipToggle = SettingsSection:AddToggle({
    ["Title"]    = "No Clip",
    ["Content"]  = "Walk through walls",
    ["Default"]  = false,
    ["Callback"] = function(value)
        -- noclip logic here
    end,
})

-- Line
SettingsSection:AddLine()

-- Dropdown — single select
local GamemodeDropdown = SettingsSection:AddDropdown({
    ["Title"]    = "Game Mode",
    ["Content"]  = "Select one mode",
    ["Multi"]    = false,
    ["Options"]  = { "Normal", "Spectator", "God Mode", "Creative" },
    ["Default"]  = { "Normal" },
    ["Callback"] = function(selected)
        local mode = selected[1]
        -- apply mode logic here
    end,
})

-- Dropdown — multi select
local FeatureDropdown = SettingsSection:AddDropdown({
    ["Title"]    = "Active Features",
    ["Content"]  = "Pick multiple to enable",
    ["Multi"]    = true,
    ["Options"]  = { "ESP", "Auto Farm", "Aimbot", "Fly", "Inf Jump" },
    ["Default"]  = {},
    ["Callback"] = function(selected)
        for _, feature in ipairs(selected) do
            -- enable each feature
        end
    end,
})

-- ══════════════════════════════════════════
--  TAB 3 — Utilities
-- ══════════════════════════════════════════
local UtilTab = Window:CreateTab({
    ["Name"] = "Utilities",
    ["Icon"] = "rbxassetid://10747383470",
})

local UtilSection = UtilTab:AddSection("Utility Tools", true)

-- Notification demo
UtilSection:AddSeperator({ ["Title"] = "Notifications" })

UtilSection:AddButton({
    ["Title"]    = "Show Notification",
    ["Content"]  = "Fires a test notification",
    ["Icon"]     = "rbxassetid://10709775704",
    ["Callback"] = function()
        Library:SetNotification({
            [1] = "Kaizen Hub",
            [2] = "Blue",
            [3] = "Notification is working correctly!",
            [5] = 0.4,
            [6] = 4,
        })
    end,
})

UtilSection:AddLine()

-- Reset all values using :Set()
UtilSection:AddSeperator({ ["Title"] = "Reset" })

UtilSection:AddButton({
    ["Title"]    = "Reset All Defaults",
    ["Content"]  = "Resets every component to its default value",
    ["Icon"]     = "rbxassetid://10734940376",
    ["Callback"] = function()
        SpeedToggle:Set(false)
        SpeedSlider:Set(50)
        JumpSlider:Set(50)
        AntiAFKToggle:Set(true)
        NoclipToggle:Set(false)
        NameInput:Set("Player")
        GamemodeDropdown:Set({ "Normal" })
        FeatureDropdown:Set({})

        Library:SetNotification({
            [1] = "Reset",
            [2] = "Blue",
            [3] = "All values have been reset to defaults.",
            [5] = 0.4,
            [6] = 3,
        })
    end,
})
