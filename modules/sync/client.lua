local sync = {}
local createdEntitys = {}

local CreatePed <const> = CreatePed

function sync.createPed(Data)
    lib.requestModel(Data.Ped.Model)
    local ped = CreatePed(4, Data.Ped.Model, Data.Ped.Position, false, false)
    SetEntityHeading(ped, Data.Ped.Position.w)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, false)
    return ped
end

function sync.replaceRegister(coords)
    local brokenRegister = GetClosestObjectOfType(coords, 5.0, Config.CashRegister.BrokenModel)
    if DoesEntityExist(brokenRegister) then
        CreateModelSwap(GetEntityCoords(brokenRegister), 0.5, Config.CashRegister.BrokenModel, Config.CashRegister.Model, false)
    end
end

function sync.isPlayerDead()
    return LocalPlayer.state.dead or IsPlayerDead(cache.playerId)
end

function sync.isPlayerArmed()
    return IsPedArmed(cache.ped, 7)
end

function sync.isValidEntity(entity)
    local ped = cache.ped

    -- Check conditions and return the result
    return DoesEntityExist(entity) and
           not IsEntityDead(entity) and
           HasEntityClearLosToEntityInFront(ped, entity, 19) and
           not IsPedDeadOrDying(entity) and
           #(GetEntityCoords(ped) - GetEntityCoords(entity)) <= 5.0
end

local HANDSUP <const> = { dict = 'missheist_agency2ahands_up', anim = 'handsup_anxious' }
function sync.handsUp(entity)
    lib.requestAnimDict(HANDSUP.dict)
    TaskPlayAnim(entity, HANDSUP.dict, HANDSUP.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
end

-- function add draw 2d text
local function draw2dText()
    SetTextFont(4)
    SetTextScale(0.0, 0.5)
    SetTextColour(Config.Progress.HelpText.Color[1], Config.Progress.HelpText.Color[2], Config.Progress.HelpText.Color[3], Config.Progress.HelpText.Color[4])
    SetTextCentre(true)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextEntry('STRING')
    AddTextComponentString(locale('shoot_help_text'))
    DrawText(Config.Progress.HelpText.Position[1], Config.Progress.HelpText.Position[2])
end

local function drawProgressBar(progress)
    DrawRect(Config.Progress.Bar.Position[1], Config.Progress.Bar.Position[2], 0.2, 0.03, 75, 75, 75, 200)
    local draw = progress / 500
    DrawRect(Config.Progress.Bar.Position[1], Config.Progress.Bar.Position[2], draw, 0.03, Config.Progress.Bar.Color[1], Config.Progress.Bar.Color[2], Config.Progress.Bar.Color[3], Config.Progress.Bar.Color[4])
end

local function adjustSpeed()
    local adjustment = 0.0

    if IsPlayerFreeAiming(cache.playerId) then
        adjustment = Config.Progress.Increases.Aiming
    elseif sync.isPlayerArmed() and GetAmmoInPedWeapon(cache.ped, GetSelectedPedWeapon(cache.ped)) > 0 and IsControlPressed(0, 24) then
        adjustment = Config.Progress.Increases.Shooting
    end

    return adjustment
end

function sync.failedRobbery(shop)
    TriggerServerEvent('trase_storerobbery:server:robberyFailed', shop.store)
    SetTimeout(60000, function()
        DeleteEntity(shop.entity)

        for k, v in pairs(Config.Stores) do
            if v.inProgress then
                local ped = sync.createPed(v)
                local coords = GetEntityCoords(ped)
                sync.replaceRegister(coords)
                addToCreatedAssets({ entity = ped, store = k })
                v.inProgress = false
            end
        end
    end)
end

function sync.robbingShop(shop)
    TriggerServerEvent('trase_storerobbery:server:robberyStarted', shop.store, shop.entity)
    local entity, ped = shop.entity, cache.ped
    local isRobbing = true

    local startTime = GetGameTimer()
    local baseSpeed = 1.0
    local speedAdjustment = 0.0

    local endTime = startTime + Config.Progress.Duration * 1000
    local progressBarTimer = startTime

    local rouge = Config.Stores[shop.store].Ped.Rouge
    local chance = math.random(1, 100)
    if rouge.Enabled and chance <= rouge.Chance then
        GiveWeaponToPed(entity, rouge.Weapon, 1, false, true)

        -- while not IsPedDeadOrDying(entity) and #(GetEntityCoords(ped) - GetEntityCoords(entity)) <= 7.5 and not sync.isPlayerDead() do
        --     Wait(0)

        --     TaskShootAtEntity(entity, cache.ped, 1000, -1, 2685983626)
        -- end

        -- Testing commit
    else
        sync.handsUp(shop.entity)

        while isRobbing and not IsPedDeadOrDying(entity) and #(GetEntityCoords(ped) - GetEntityCoords(entity)) <= 7.5 and not sync.isPlayerDead() and progressBarTimer < endTime do
            Wait(0)
    
            draw2dText()
    
            speedAdjustment = adjustSpeed()
    
            if Config.Progress.Bar.Enabled then
                local timeRemaining = endTime - GetGameTimer()
                local progressDelta = 100 * (1 - timeRemaining / ((endTime - startTime) + 1)) + speedAdjustment
                drawProgressBar(progressDelta)
            end
    
            progressBarTimer = GetGameTimer()
        end
    
        if IsPedDeadOrDying(entity) or sync.isPlayerDead() then return sync.failedRobbery(shop.store) end
    
        SetEntityCoords(entity, Config.Stores[shop.store].Ped.Position)
        lib.requestAnimDict('mp_am_hold_up')
        TaskPlayAnim(entity, "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 2, 0, false, false, false)
        while not IsEntityPlayingAnim(entity, "mp_am_hold_up", "holdup_victim_20s", 3) do Wait(0) end
    
        local timer = GetGameTimer() + 10800
        while timer >= GetGameTimer() do
            if IsPedDeadOrDying(entity) or sync.isPlayerDead() then break end
            Wait(0)
        end
    
        if IsPedDeadOrDying(entity) or sync.isPlayerDead() then return sync.failedRobbery(shop.store) end
    
        local pedCoords = GetEntityCoords(entity)
    
        local cashRegister = GetClosestObjectOfType(pedCoords, 5.0, Config.CashRegister.Model)
        if DoesEntityExist(cashRegister) then
            CreateModelSwap(GetEntityCoords(cashRegister), 0.5, Config.CashRegister.Model, Config.CashRegister.BrokenModel, false)
        end
    
        local model = `prop_poly_bag_01`
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end
        local bag = CreateObject(model, pedCoords, false, false)
        AttachEntityToEntity(bag, entity, GetPedBoneIndex(entity, 60309), 0.1, -0.11, 0.08, 0.0, -75.0, -75.0, 1, 1, 0, 0, 2, 1)
        createdEntitys[#createdEntitys +1] = bag
    
        local timer = GetGameTimer() + 10000
        while timer >= GetGameTimer() do
            if IsPedDeadOrDying(entity) or sync.isPlayerDead() then break end
            Wait(0)
        end
    
        if IsPedDeadOrDying(entity) or sync.isPlayerDead() then return sync.failedRobbery(shop.store) end
    
        DetachEntity(bag, true, false)
    
        local timer = GetGameTimer() + 75
        while timer >= GetGameTimer() do
            if IsPedDeadOrDying(entity) or sync.isPlayerDead() then break end
            Wait(0)
        end
    
        SetEntityHeading(bag, Config.Stores[shop.store].Ped.Position.w)
        ApplyForceToEntity(bag, 3, vector3(0.0, 75.0, 0.0), 0.0, 0.0, 0.0, 0, true, true, false, false, true)
    
        CreateThread(function()
            local showntextUI = false
            while true do
                Wait(5)
                if DoesEntityExist(bag) then
                    local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(bag))
                    if dist <= 1.5 then
                        if not showntextUI then
                            showntextUI = true
                            lib.showTextUI(locale('collect_bag'))
                        end
    
                        if (IsControlJustPressed(0, 38) and not sync.isPlayerDead()) then
                            showntextUI = false
                            lib.hideTextUI()
                            lib.requestAnimDict('pickup_object')
                            TaskPlayAnim(cache.ped, 'pickup_object', 'pickup_low', 8.0, -8.0, -1, 0, 0, false, false, false)
                            Wait(1000)
                            PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
                            DeleteEntity(bag)
                            TriggerServerEvent('trase_storerobbery:server:collectBag', shop.store)
                            break
                        end
                    else
                        if showntextUI then
                            showntextUI = false
                            lib.hideTextUI()
                        end
                    end
                else
                    if showntextUI then
                        showntextUI = false
                        lib.hideTextUI()
                    end
    
                    break
                end
            end
        end)
    end
end

function sync.clearEntitys()
    for k, v in pairs(createdEntitys) do
        DeleteEntity(v)
    end
end

return sync