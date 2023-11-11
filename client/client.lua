local sync = require 'modules.sync.client'
local Framework = require 'modules.framework.client'

local createdAssets = {}
lib.locale()

CreateThread(function()
    for k, v in pairs(Config.Stores) do
        local ped = sync.createPed(v)
        local coords = GetEntityCoords(ped)

        sync.replaceRegister(coords)

        createdAssets[#createdAssets +1] = { entity = ped, store = k }

        if v.Safe.Enabled then
            if Config.Target then
                sync.addSafe(v, k)
            end
        end
    end

    while true do
        local sleep = 1500

        local armed = sync.isPlayerArmed()
        local job = Framework.getJob()

        if armed and not Config.BlacklistedJobs[job] then
            local aiming = IsPlayerFreeAiming(cache.playerId)
            if aiming then
                for _, shop in pairs(createdAssets) do
                    local validEntity = sync.isValidEntity(shop.entity)
                    local currentShop = Config.Stores[shop.store]
                    if validEntity and currentShop and not currentShop.inProgress then
                        currentShop.inProgress = true
                        sync.robbingShop(shop)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k, v in pairs(createdAssets) do
            DeleteEntity(v.entity)
            sync.clearEntitys()
        end
    end
end)

RegisterNetEvent('trase_storerobbery:client:alertPolice', function(coords)
    local job = Framework.getJob()
    local found = false
    for k, v in pairs(Config.PoliceJobs) do
        if v == job then
            found = true
            break
        end
    end

    if found then
        local blip = AddBlipForCoord(coords)
        SetBlipSprite(blip, 161)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 1.5)
        SetBlipAsShortRange(blip, false)
        SetBlipDisplay(blip, 2)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(locale("dispatch_label"))
        EndTextCommandSetBlipName(blip)

        Config.Notification({ type = 'warning', title = locale('dispatch_label'), message = locale('dispatch_description') })

        Wait(5 * 60 * 1000)

        RemoveBlip(blip)
    end
end)

RegisterNetEvent('trase_storerobbery:client:notify', Config.Notification)

RegisterNetEvent('trase_storerobbery:client:setStore', function(storeId, state)
    local store = Config.Stores[storeId]
    if not store then return end

    store.inProgress = state
end)

function addToCreatedAssets(entity)
    createdAssets[#createdAssets +1] = entity
end


-- Config Checking:

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
    else
        for k, v in pairs(HACKING_MINIGAMES) do
            if GetResourceState(k) == 'started' then
                Config.Safes.Hack = k
            end
        end
    end
end)