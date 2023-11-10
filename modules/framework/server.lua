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
elseif Config.Framework == 'qbcore' then
    QBCore = loadQBCore()
    FRAMEWORK.getJob = function()
        return QBCore.Functions.GetPlayerData().job.name
    end
end

return FRAMEWORK