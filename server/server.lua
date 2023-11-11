local Framework = require 'modules.framework.server'
local sync = require 'modules.sync.server'
lib.locale()

local legit = {}

local function ErrorPrint(...)
    print('^4[Trase_StoreRobbery] ^1[ERROR]^0: ', ...)
end

CreateThread(function()
    for k, v in pairs(Config.Stores) do
        GlobalState['trase_storerobbery:store:safe' .. k] = false
    end
end)

RegisterNetEvent('trase_storerobbery:server:collectBag', function(storeId)
    local src = source
    local store = Config.Stores[storeId]
    if not store then return end

    local coords = store.Ped.Position
    local ped = GetPlayerPed(src)
    local dist = #(coords.xyz - GetEntityCoords(ped).xyz)
    if dist >= 15.0 or not legit[src] then return end -- Modder

    local rewards = store.Ped.Rewards

    for k, v in pairs(rewards) do
        local reward = math.random(v[1], v[2])
        Framework.addItem(src, k, reward)
    end

    legit[src] = nil

    SetTimeout(Config.Cooldown * 60000, function()
        TriggerClientEvent('trase_storerobbery:client:setStore', -1, storeId, false)
    end)
    
    TriggerClientEvent('trase_storerobbery:client:notify', src, { type = 'success', title = locale('bag_pickup_title'), message = locale('bag_pickup_description') })
end)

RegisterNetEvent('trase_storerobbery:server:robberyStarted', function(storeId)
    local src = source
    local store = Config.Stores[storeId]
    if not store then return end

    legit[src] = true

    sync.alertPolice(store.Ped.Position)
    TriggerClientEvent('trase_storerobbery:client:setStore', -1, storeId, true)
end)

RegisterNetEvent('trase_storerobbery:server:robberyFailed', function(storeId)
    local src = source
    local store = Config.Stores[storeId]
    if not store then return end

    legit[src] = nil

    TriggerClientEvent('trase_storerobbery:client:setStore', -1, storeId, false)
end)

RegisterNetEvent('trase_storerobbery:server:openSafe', function(data)
    local src = source
    local storeId = data.args
    local store = Config.Stores[storeId]

    if not store then return end

    local coords = store.Safe.TargetCoords

    local ped = GetPlayerPed(src)
    local dist = #(coords.xyz - GetEntityCoords(ped).xyz)
    if dist >= 15.0 then return end -- Modder

    local requiredItems = store.Safe.RequiredItems
    if requiredItems and type(requiredItems) == 'table' and next(requiredItems) then
        for k, v in pairs(requiredItems) do
            local itemCount = Framework.getItem(src, k)
            if itemCount then
                if itemCount < v then
                    return TriggerClientEvent('trase_storerobbery:client:notify', src, { type = 'error', title = locale('safe_no_items'), message = locale('safe_no_items_message') })
                end
            else
                ErrorPrint(('The item %s is configured as a requirement in the safe but does not exist.'):format(k))
            end
        end
    end

    sync.alertPolice(store.Ped.Position)
    TriggerClientEvent('trase_storerobbery:client:openSafe', src, store.Safe.AnimStart, storeId)

    if Config.Safes.CooldownOnAttempt then
        GlobalState['trase_storerobbery:store:safe' .. storeId] = true

        SetTimeout(Config.Safes.Cooldown * 60000, function()
            GlobalState['trase_storerobbery:store:safe' .. storeId] = false
        end)
    end
end)

RegisterNetEvent('trase_storerobbery:server:crackSafe', function(storeId)
    local src = source
    local store = Config.Stores[storeId]
    if not store then return end

    local coords = store.Safe.AnimStart
    local ped = GetPlayerPed(src)
    local dist = #(coords.xyz - GetEntityCoords(ped).xyz)

    if dist >= 15.0 then return end -- Modder

    local rewards = store.Safe.Rewards

    for k, v in pairs(rewards) do
        local reward = math.random(v[1], v[2])
        Framework.addItem(src, k, reward)
    end

    if not GlobalState['trase_storerobbery:store:safe' .. storeId] then
        GlobalState['trase_storerobbery:store:safe' .. storeId] = true

        SetTimeout(Config.Safes.Cooldown * 60000, function()
            GlobalState['trase_storerobbery:store:safe' .. storeId] = false
        end)
    end

    TriggerClientEvent('trase_storerobbery:client:notify', src, { type = 'success', title = locale('safe_crack_title'), message = locale('safe_crack_description') })
end)

-- Config checking, overides if needed.
local HACKING_MINIGAMES <const> = {
    ['ps-ui'] = true,
    ['ultra-voltlab'] = true,
    ['ultra-keypadhack'] = true,
    ['datacrack'] = true,
    ['electus_hacking'] = true,
    ['howdy-hackminigame'] = true,
}

CreateThread(function()
    if not HACKING_MINIGAMES[Config.Safes.Hack] then
        Config.Safes.Hack = 'ps-ui'
        ErrorPrint('Config.Safes.Hack is not a valid hacking minigame, defaulting to ps-ui.')
    end

    for k, v in pairs(HACKING_MINIGAMES) do
        if GetResourceState(k) == 'started' then
            Config.Safes.Hack = k
        end
    end


end)