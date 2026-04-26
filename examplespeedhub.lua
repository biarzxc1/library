--[[
    SpeedHub X | Blue Library — Full Component Example
    Shows every available component: Separator, Line, Button,
    Toggle, Slider, Input, Dropdown (single & multi), Notification
]]

-- ── Load the library (replace URL with wherever you host libs_blue.lua)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/libs_blue.lua"))()

-- ── Create the main window
local Window = Library:CreateWindow({
    ["Title"]       = "Speed Hub X",
    ["Description"] = "Blue Theme",
    ["Tab Width"]   = 160,
})

-- ════════════════════════════════════════════
--  TAB 1 — Basics  (Button, Toggle, Separator, Line)
-- ════════════════════════════════════════════
local BasicTab = Window:CreateTab({
    ["Name"] = "Basics",
    ["Icon"] = "rbxassetid://10723407389",
})

local BasicSection = BasicTab:AddSection("Basic Components", true)

-- Separator (styled header row)
BasicSection:AddSeperator({
    ["Title"] = "— Buttons & Toggles —"
})

-- Line (thin divider)
BasicSection:AddLine()

-- Button
local MyButton = BasicSection:AddButton({
    ["Title"]    = "Click Me",
    ["Content"]  = "Fires a callback when pressed",
    ["Icon"]     = "rbxassetid://7734010488",
    ["Callback"] = function()
        Library:SetNotification({
            "Button Pressed",       -- Title
            "Blue",                 -- Description / accent label
            "The button was clicked successfully!", -- Content
            nil,                    -- unused slot
            0.4,                    -- slide-in time
            3,                      -- auto-dismiss delay (seconds)
        })
    end,
})

-- Toggle (default OFF)
local SpeedToggle = BasicSection:AddToggle({
    ["Title"]    = "Speed Boost",
    ["Content"]  = "Enables walk-speed override",
    ["Default"]  = false,
    ["Callback"] = function(value)
        -- value is true/false
        local speed = value and 50 or 16
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end,
})

-- Toggle (default ON)
local AntiBanToggle = BasicSection:AddToggle({
    ["Title"]    = "Anti-AFK",
    ["Content"]  = "Keeps your session alive automatically",
    ["Default"]  = true,
    ["Callback"] = function(value)
        -- handle anti-afk logic here
    end,
})

-- ════════════════════════════════════════════
--  TAB 2 — Controls  (Slider, Input)
-- ════════════════════════════════════════════
local ControlTab = Window:CreateTab({
    ["Name"] = "Controls",
    ["Icon"] = "rbxassetid://10723407389",
})

local ControlSection = ControlTab:AddSection("Sliders & Inputs", true)

BasicSection:AddSeperator({ ["Title"] = "— Value Controls —" })

-- Slider
local SpeedSlider = ControlSection:AddSlider({
    ["Title"]     = "Walk Speed",
    ["Content"]   = "Drag to set walk speed",
    ["Increment"] = 1,
    ["Min"]       = 16,
    ["Max"]       = 250,
    ["Default"]   = 50,
    ["Callback"]  = function(value)
        local char = game.Players.LocalPlayer.Character
        if char then char.Humanoid.WalkSpeed = value end
    end,
})

-- Another slider
local JumpSlider = ControlSection:AddSlider({
    ["Title"]     = "Jump Power",
    ["Content"]   = "Adjusts how high the player jumps",
    ["Increment"] = 5,
    ["Min"]       = 50,
    ["Max"]       = 500,
    ["Default"]   = 50,
    ["Callback"]  = function(value)
        local char = game.Players.LocalPlayer.Character
        if char then char.Humanoid.JumpPower = value end
    end,
})

ControlSection:AddLine()

-- Text Input
local NameInput = ControlSection:AddInput({
    ["Title"]    = "Custom Chat Tag",
    ["Content"]  = "Text shown before your name in chat",
    ["Default"]  = "Speed Hub",
    ["Callback"] = function(value)
        -- use value here
    end,
})

-- Numeric Input
local TeleportInput = ControlSection:AddInput({
    ["Title"]    = "Teleport Position",
    ["Content"]  = "Format: X,Y,Z  e.g. 100,50,200",
    ["Default"]  = "0,0,0",
    ["Callback"] = function(value)
        local parts = string.split(value, ",")
        if #parts == 3 then
            local x, y, z = tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3])
            if x and y and z then
                local char = game.Players.LocalPlayer.Character
                if char then
                    char.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
                end
            end
        end
    end,
})

-- ════════════════════════════════════════════
--  TAB 3 — Dropdowns
-- ════════════════════════════════════════════
local DropTab = Window:CreateTab({
    ["Name"] = "Dropdowns",
    ["Icon"] = "rbxassetid://10723407389",
})

local DropSection = DropTab:AddSection("Dropdown Examples", true)

-- Single-select dropdown
local GamemodeDropdown = DropSection:AddDropdown({
    ["Title"]    = "Game Mode",
    ["Content"]  = "Choose one mode to activate",
    ["Multi"]    = false,
    ["Options"]  = { "Normal", "Creative", "Spectator", "God Mode" },
    ["Default"]  = { "Normal" },
    ["Callback"] = function(selected)
        -- selected is a table, e.g. {"Normal"}
        local mode = selected[1]
        -- apply mode logic here
    end,
})

DropSection:AddLine()

-- Multi-select dropdown
local FeatureDropdown = DropSection:AddDropdown({
    ["Title"]    = "Active Cheats",
    ["Content"]  = "Pick multiple features to enable at once",
    ["Multi"]    = true,
    ["Options"]  = { "No Clip", "Infinite Jump", "Speed Hack", "Auto Farm", "ESP" },
    ["Default"]  = {},
    ["Callback"] = function(selected)
        -- selected is a table of all chosen options
        for _, feature in ipairs(selected) do
            -- enable feature
        end
    end,
})

-- Programmatic refresh example
task.delay(5, function()
    FeatureDropdown:Refresh(
        { "No Clip", "Infinite Jump", "Speed Hack", "Auto Farm", "ESP", "Fly" }, -- new list
        { "Speed Hack" } -- pre-select
    )
end)

-- ════════════════════════════════════════════
--  TAB 4 — Misc & Notifications
-- ════════════════════════════════════════════
local MiscTab = Window:CreateTab({
    ["Name"] = "Misc",
    ["Icon"] = "rbxassetid://10723407389",
})

local MiscSection = MiscTab:AddSection("Notifications & Utilities", true)

MiscSection:AddSeperator({ ["Title"] = "— Notification Tests —" })

MiscSection:AddButton({
    ["Title"]    = "Info Notify",
    ["Content"]  = "Shows a short info notification",
    ["Callback"] = function()
        Library:SetNotification({
            "Information",
            "Blue",
            "This is a regular notification. It will auto-dismiss in 4 seconds.",
            nil, 0.4, 4,
        })
    end,
})

MiscSection:AddButton({
    ["Title"]    = "Warning Notify",
    ["Content"]  = "Shows a warning-style notification",
    ["Callback"] = function()
        Library:SetNotification({
            "Warning",
            "Blue",
            "Something needs your attention! Check your settings before proceeding.",
            nil, 0.4, 6,
        })
    end,
})

MiscSection:AddLine()

MiscSection:AddSeperator({ ["Title"] = "— Programmatic API —" })

-- Demonstrating :Set() on existing components
MiscSection:AddButton({
    ["Title"]    = "Reset All Values",
    ["Content"]  = "Resets speed, jump and input to defaults",
    ["Callback"] = function()
        SpeedSlider:Set(50)
        JumpSlider:Set(50)
        SpeedToggle:Set(false)
        NameInput:Set("Speed Hub")
        GamemodeDropdown:Set({ "Normal" })
        FeatureDropdown:Set({})

        Library:SetNotification({
            "Reset Complete",
            "Blue",
            "All components have been set back to their default values.",
            nil, 0.4, 3,
        })
    end,
})
