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
    FRAMEWORK.getJob = function()
        return ESX.GetPlayerData().job.name
    end
elseif Config.Framework == 'qbcore' then
    QBCore = loadQBCore()
    FRAMEWORK.getJob = function()
        return QBCore.Functions.GetPlayerData().job.name
    end
end

return FRAMEWORK