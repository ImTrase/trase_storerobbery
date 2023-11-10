local Framework = require 'modules.framework.server'
local sync = require 'modules.sync.server'
lib.locale()

local legit = {}

RegisterNetEvent('trase_storerobbery:server:collectBag', function(storeId)
    local src = source
    local store = Config.Stores[storeId]
    if not store then return end

    local coords = store.Ped.Position
    local ped = GetPlayerPed(src)
    local dist = #(coords.xyz - GetEntityCoords(ped).xyz)
    if dist >= 15.0 or not legit[src] then return end -- Modder

    local rewards = store.Rewards

    for k, v in pairs(rewards) do
        local reward = math.random(v[1], v[2])
        Framework.addItem(src, k, reward)
    end

    legit[src] = nil

    SetTimeout(Config.Cooldown * 60000, function()
        TriggerClientEvent('trase_storerobbery:server:setStore', -1, storeId, false)
    end)
    
    TriggerClientEvent('trase_storerobbery:client:notify', src, { type = 'success', title = locale('bag_pickup_title'), message = locale('bag_pickup_description') })
end)

RegisterNetEvent('trase_storerobbery:server:robberyStarted', function(storeId)
    local src = source
    local store = Config.Stores[storeId]
    if not store then return end

    legit[src] = true

    sync.alertPolice(store.Ped.Position)
    TriggerClientEvent('trase_storerobbery:server:setStore', -1, storeId, true)
end)

RegisterNetEvent('trase_storerobbery:server:robberyFailed', function(storeId)
    local src = source
    local store = Config.Stores[storeId]
    if not store then return end

    legit[src] = nil

    TriggerClientEvent('trase_storerobbery:server:setStore', -1, storeId, false)
end)