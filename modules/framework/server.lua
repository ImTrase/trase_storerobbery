local FRAMEWORK = {}
local ESX, QBCore

local function loadESX()
    local _, ESX = pcall(function()
        return exports['es_extended']:getSharedObject()
    end)

    if not ESX then
        AddEventHandler('esx:getSharedObject', function(obj)
            ESX = obj
        end)
    end

    return ESX
end

local function loadQBCore()
    local _, QBCore = pcall(function()
        return exports['qb-core']:GetCoreObject()
    end)

    return QBCore
end

if Config.Framework == 'auto' then
    if loadESX() then
        Config.Framework = 'esx'
    elseif loadQBCore() then
        Config.Framework = 'qbcore'
    end
end

if Config.Framework == 'esx' then
    ESX = loadESX()

    FRAMEWORK.getPlayer = function(target)
        if not target then return end
        local xPlayer = ESX.GetPlayerFromId(target)
        if not xPlayer then return end
        return xPlayer
    end

    local money_found = { 'money', 'black_money', 'bank' }

    FRAMEWORK.addItem = function(target, item, amount)
        if item == 'cash' then item = 'money' end -- Conversion for QBCore
        local xPlayer = FRAMEWORK.getPlayer(target)
        if not xPlayer then return end

        if type(item) == 'string' then
            if item == money_found then
                xPlayer.addAccountMoney(item, amount)
            else
                xPlayer.addInventoryItem(item, amount)
            end
        end
    end

    FRAMEWORK.getItem = function(target, item)
        if item == 'cash' then item = 'money' end -- Conversion for QBCore
        local xPlayer = FRAMEWORK.getPlayer(target)
        if not xPlayer then return end

        if type(item) == 'string' then
            if item == money_found then
                return xPlayer.getAccount(item).money
            else
                local itemData = xPlayer.getInventoryItem(item)
                if not itemData then return end
                return itemData.count
            end
        end
    end
elseif Config.Framework == 'qbcore' then
    QBCore = loadQBCore()

    FRAMEWORK.getPlayer = function(target)
        if not target then return end
        local player = QBCore.Functions.GetPlayer(target)
        if not player then return end
        return player
    end

    local money_found = { 'cash', 'crypto', 'bank' }

    FRAMEWORK.addItem = function(target, item, amount)
        if item == 'money' then item = 'cash' end -- Conversion for ESX
        local player = FRAMEWORK.getPlayer(target)
        if not player then return end

        if type(item) == 'string' then
            if item == money_found then
                player.Functions.AddMoney(item, amount)
            else
                if item == 'markedbills' then
                    local info = { worth = amount }
                    player.Functions.AddItem(item, 1, false, info)
                else
                    player.Functions.AddItem(item, amount)
                end
            end
        end
    end

    FRAMEWORK.getItem = function(target, item)
        if item == 'money' then item = 'cash' end -- Conversion for ESX
        local player = FRAMEWORK.getPlayer(target)
        if not player then return end

        if type(item) == 'string' then
            if item == money_found then
                return player.PlayerData.money
            else
                local itemData = player.Functions.GetItemByName(item)
                if not itemData then return end
                return itemData.count or itemData.amount or 0
            end
        end
    end
end

return FRAMEWORK