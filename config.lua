Config = {}

Config.Framework = 'auto' -- auto, esx, qbcore (custom setup in modules/framework)
Config.Cooldown = 5 -- Time (in minutes) until the store is reset.

Config.Progress = {
    Duration = 2,
    Increases = { Aiming = 0.3, Shooting = 5.7 },

    Bar = {
        Enabled = true,
        Color = { 0, 255, 0, 200 }, -- RGBA
        Position = { 0.5, 0.15 }, -- X, Y
    },
    HelpText = {
        Enabled = true,
        Color = { 255, 255, 255, 255 }, -- RGBA
        Position = { 0.5, 0.10 }, -- X, Y
    }
}

Config.ProgressBarColor = { 0, 255, 0, 200 } -- RGBA

Config.CashRegister = {
    Model = `prop_till_01`,
    BrokenModel = `prop_till_01_dam`
}

Config.BlacklistedJobs = {
    ['police'] = true,
    ['ambulance'] = true,
    ['mechanic'] = true,
}

Config.PoliceJobs = { 'police', 'sheriff', 'unemployed' } -- Used in disatch, dispatch can be edited in modules/sync/server.lua

Config.Stores = {
    [1] = {
        Ped = {
            Model = `a_m_y_mexthug_01`,
            Position = vec4(2555.5, 380.8461, 107.6230, 0.0),
            Rouge = {
                Enabled = true,
                Chance = 100,
                Weapon = `WEAPON_PUMPSHOTGUN`
            }
        },
        Rewards = {
            ['black_money'] = { 25000, 50000 } -- Min, Max
        }
    }
}

Config.Notification = function(data)
    lib.notify({ type = data.type, title = data.title, description = data.message })
end