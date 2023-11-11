Config = {}

Config.Framework = 'auto' -- auto, esx, qbcore (custom setup in modules/framework)
Config.Cooldown = 5 -- Time (in minutes) until the store is reset.
Config.Target = true -- Enable 3-erd eye (requires: ox_target)

Config.Progress = {
    Duration = 2, -- Time in seconds it takes to complete the NPC robbery.
    Increases = { Aiming = 0.3, Shooting = 5.7 }, -- How much the progress increases when aiming or shooting.
    Bar = { -- Progress bar
        Enabled = true, -- Enable or disable the progress bar.
        Color = { 0, 255, 0, 200 }, -- RGBA
        Position = { 0.5, 0.15 }, -- X, Y
    },
    HelpText = { -- Help text
        Enabled = true, -- Enable or disable the help text that displays above the progress bar.
        Color = { 255, 255, 255, 255 }, -- RGBA
        Position = { 0.5, 0.10 }, -- X, Y
    }
}

Config.CashRegister = {
    Model = `prop_till_01`, -- Model
    BrokenModel = `prop_till_01_dam` -- Broken model
}

Config.BlacklistedJobs = { -- Jobs that are not allowed to rob stores.
    ['police'] = true,
    ['ambulance'] = true,
    ['mechanic'] = true,
}

--[[
    Supported Hack Minigames (can be edited in modules/sync/client.lua):
    - ps-ui (reccomended): https://github.com/Project-Sloth/ps-ui
    - ultra-voltlab: https://github.com/ultrahacx/ultra-voltlab
    - ultra-keypadhack: https://github.com/ultrahacx/ultra-keypackhack
    - datacrack: https://github.com/utkuali/datacrack
    - howdy-hackminigame: https://github.com/HiHowdy/howdy-hackminigame

    - electus_hacking (paid): https://forum.cfx.re/t/qb-esx-paid-electus-hacking-hacker-job-terminal-hack/4989175
]]

Config.Safes = { -- Safe Configuration
    Hack = 'ps-ui', -- Hacking minigame, see below for a list of minigames.
    Cooldown = 5, -- Time (in minutes) until the safe is reset.
    CooldownOnAttempt = true, -- Enable cooldown as soon as a player attempts to open the safe.
}

Config.PoliceJobs = { 'police', 'sheriff', 'unemployed' } -- Used in disatch, dispatch can be edited in modules/sync/server.lua

Config.Stores = {
    [1] = {
        Ped = {
            Model = `a_m_y_mexthug_01`,
            Position = vec4(2555.5, 380.8461, 107.6230, 0.0),
            Rouge = {
                Enabled = false,
                Chance = 100, -- Percentage
                Weapons = { `WEAPON_PISTOL`, `WEAPON_PUMPSHOTGUN`, `WEAPON_MICROSMG` },
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
        Safe = {
            Enabled = true,
            TargetCoords = vec3(2548.6, 384.8648, 108.06),
            MarkerCoords = vec3(2549.3774, 384.8537, 108.6228),
            AnimStart = vec4(2549.5813, 384.8207, 108.6229, 95.9525),
            RequiredItems = {
                ['hacking_laptop'] = 1
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
    }
}

Config.Notification = function(data)
    lib.notify({ type = data.type, title = data.title, description = data.message })
end