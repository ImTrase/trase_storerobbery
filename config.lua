Config = {}

Config.Framework = 'auto' -- auto, esx, qbcore (custom setup in modules/framework)
Config.Cooldown = 5 -- Time (in minutes) until the store is reset.
Config.Target = true -- Enable 3-erd eye (requires: ox_target)

Config.Progress = {
    Duration = 180, -- Time in seconds it takes to complete the NPC robbery.
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

Config.PoliceJobs = { 'police', 'sheriff' } -- Used in disatch, dispatch can be edited in modules/sync/server.lua
Config.Alarm = {
    Enabled = true, -- Enable or disable the alarm.
    Time = 4, -- Time in minutes until the alarm is disabled. (Make this matches up with the progress bar duration)
    Distance = 70.0 -- Distance on how far the alarm can be heard.
}

Config.Stores = {
    [1] = {
        Ped = {
            Enabled = true,
            Model = `a_m_y_mexthug_01`,
            Position = vec4(2555.5, 380.8461, 107.6230, 0.0),
            Rouge = {
                Enabled = true,
                Chance = 15, -- Percentage
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
            RequiredItems = {
                ['hacking_laptop'] = 1
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
    },
    [2] = {
        Ped = {
            Enabled = true,
            Model = `a_m_y_mexthug_01`,
            Position = vec4(24.4093, -1345.55, 28.4970, 269.4767),
            Rouge = {
                Enabled = true,
                Chance = 15, -- Percentage
                Weapons = { `WEAPON_PISTOL`, `WEAPON_PUMPSHOTGUN`, `WEAPON_MICROSMG` },
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
        Safe = {
            Enabled = true,
            TargetCoords = vec3(28.2239, -1338.6665, 29.0),
            MarkerCoords = vec3(28.1904, -1339.5475, 29.4971),
            RequiredItems = {
                ['hacking_laptop'] = 1
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
    },
    [3] = {
        Ped = {
            Enabled = true,
            Model = `a_m_y_mexthug_01`,
            Position = vec4(-3040.5515, 584.0319, 6.9089, 20.2426),
            Rouge = {
                Enabled = true,
                Chance = 15, -- Percentage
                Weapons = { `WEAPON_PISTOL`, `WEAPON_PUMPSHOTGUN`, `WEAPON_MICROSMG` },
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
        Safe = {
            Enabled = true,
            TargetCoords = vec3(-3048.40, 585.38, 7.4187),
            TargetRotation = 18, -- Only needed if the safe is rotated.
            MarkerCoords = vec3(-3047.7292, 585.6232, 7.9089),
            RequiredItems = {
                ['hacking_laptop'] = 1
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
    },
    [4] = {
        Ped = {
            Enabled = true,
            Model = `a_m_y_mexthug_01`,
            Position = vec4(-3244.0239, 1000.1387, 11.8307, 355.0845),
            Rouge = {
                Enabled = true,
                Chance = 15, -- Percentage
                Weapons = { `WEAPON_PISTOL`, `WEAPON_PUMPSHOTGUN`, `WEAPON_MICROSMG` },
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
        Safe = {
            Enabled = true,
            TargetCoords = vec3(-3250.68, 1004.42, 12.3),
            TargetRotation = -5, -- Only needed if the safe is rotated.
            MarkerCoords = vec3(-3249.9309, 1004.4118, 12.8307),
            RequiredItems = {
                ['hacking_laptop'] = 1
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
    },
    [5] = {
        Ped = {
            Enabled = true,
            Model = `a_m_y_mexthug_01`,
            Position = vec4(1728.5294, 6416.6875, 34.0372, 246.6288),
            Rouge = {
                Enabled = true,
                Chance = 15, -- Percentage
                Weapons = { `WEAPON_PISTOL`, `WEAPON_PUMPSHOTGUN`, `WEAPON_MICROSMG` },
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
        Safe = {
            Enabled = true,
            TargetCoords = vec3(1735.05, 6421.4, 34.5808),
            TargetRotation = 65, -- Only needed if the safe is rotated.
            MarkerCoords = vec3(1734.6799, 6420.6294, 35.0372),
            RequiredItems = {
                ['hacking_laptop'] = 1
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
    },
    [6] = {
        Ped = {
            Enabled = true,
            Model = `a_m_y_mexthug_01`,
            Position = vec4(1698.5894, 4922.3311, 41.0636, 326.1037),
            Rouge = {
                Enabled = true,
                Chance = 15, -- Percentage
                Weapons = { `WEAPON_PISTOL`, `WEAPON_PUMPSHOTGUN`, `WEAPON_MICROSMG` },
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
        Safe = {
            Enabled = true,
            TargetCoords = vec3(1708.2, 4920.9, 41.7093),
            TargetRotation = -35, -- Only needed if the safe is rotated.
            MarkerCoords = vec3(1707.7706, 4920.2700, 42.0636),
            RequiredItems = {
                ['hacking_laptop'] = 1
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
    },
    [7] = {
        Ped = {
            Enabled = true,
            Model = `a_m_y_mexthug_01`,
            Position = vec4(1959.2300, 3741.4182, 31.3437, 300.3361),
            Rouge = {
                Enabled = true,
                Chance = 15, -- Percentage
                Weapons = { `WEAPON_PISTOL`, `WEAPON_PUMPSHOTGUN`, `WEAPON_MICROSMG` },
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
        Safe = {
            Enabled = true,
            TargetCoords = vec3(1958.95, 3749.42, 31.8596),
            TargetRotation = -60, -- Only needed if the safe is rotated.
            MarkerCoords = vec3(1959.2604, 3748.8372, 32.3437),
            RequiredItems = {
                ['hacking_laptop'] = 1
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
    },
    [8] = {
        Ped = {
            Enabled = true,
            Model = `a_m_y_mexthug_01`,
            Position = vec4(549.2698, 2669.6697, 41.1565, 98.3748),
            Rouge = {
                Enabled = true,
                Chance = 15, -- Percentage
                Weapons = { `WEAPON_PISTOL`, `WEAPON_PUMPSHOTGUN`, `WEAPON_MICROSMG` },
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
        Safe = {
            Enabled = true,
            TargetCoords = vec3(546.54, 2662.18, 41.5875),
            TargetRotation = 7, -- Only needed if the safe is rotated.
            MarkerCoords = vec3(546.4713, 2662.8386, 42.1565),
            RequiredItems = {
                ['hacking_laptop'] = 1
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
    },
    [9] = {
        Ped = {
            Enabled = true,
            Model = `a_m_y_mexthug_01`,
            Position = vec4(2676.4519, 3280.2256, 54.2411, 331.3642),
            Rouge = {
                Enabled = true,
                Chance = 15, -- Percentage
                Weapons = { `WEAPON_PISTOL`, `WEAPON_PUMPSHOTGUN`, `WEAPON_MICROSMG` },
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
        Safe = {
            Enabled = true,
            TargetCoords = vec3(2672.2, 3286.90, 54.7),
            TargetRotation = -30, -- Only needed if the safe is rotated.
            MarkerCoords = vec3(2672.9041, 3286.5183, 55.2411),
            RequiredItems = {
                ['hacking_laptop'] = 1
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
    },
    [10] = {
        Ped = {
            Enabled = true,
            Model = `a_m_y_mexthug_01`,
            Position = vec4(372.9451, 328.1276, 102.5664, 253.5359),
            Rouge = {
                Enabled = true,
                Chance = 15, -- Percentage
                Weapons = { `WEAPON_PISTOL`, `WEAPON_PUMPSHOTGUN`, `WEAPON_MICROSMG` },
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
        Safe = {
            Enabled = true,
            TargetCoords = vec3(378.2868, 334.0286, 103.0514),
            TargetRotation = -15, -- Only needed if the safe is rotated.
            MarkerCoords = vec3(378.0569, 333.2210, 103.5664),
            RequiredItems = {
                ['hacking_laptop'] = 1
            },
            Rewards = {
                ['black_money'] = { 25000, 50000 }, -- Min, Max (ESX Example)
                -- ['marked_bills'] = { 1, 2 }, -- Min, Max (QBCore Example)
            }
        },
    },
}

Config.Notification = function(data)
    lib.notify({ type = data.type, title = data.title, description = data.message })
end