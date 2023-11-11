local sync = {}
local createdEntitys = {}
local crackingSafe = false

-- Declaring all used natives (performance)
local CreatePed <const> = CreatePed
local SetEntityHeading <const> = SetEntityHeading
local SetEntityAsMissionEntity <const> = SetEntityAsMissionEntity
local SetPedHearingRange <const> = SetPedHearingRange
local SetPedSeeingRange <const> = SetPedSeeingRange
local SetPedAlertness <const> = SetPedAlertness
local SetPedFleeAttributes <const> = SetPedFleeAttributes
local SetBlockingOfNonTemporaryEvents <const> = SetBlockingOfNonTemporaryEvents
local SetPedCombatAttributes <const> = SetPedCombatAttributes
local SetPedDropsWeaponsWhenDead <const> = SetPedDropsWeaponsWhenDead
local RequestModel <const> = RequestModel
local HasModelLoaded <const> = HasModelLoaded
local CreateObject <const> = CreateObject
local AttachEntityToEntity <const> = AttachEntityToEntity
local DetachEntity <const> = DetachEntity
local GetEntityCoords <const> = GetEntityCoords
local GetPedBoneIndex <const> = GetPedBoneIndex
local DeleteEntity <const> = DeleteEntity
local GetClosestObjectOfType <const> = GetClosestObjectOfType
local DoesEntityExist <const> = DoesEntityExist
local IsEntityDead <const> = IsEntityDead
local HasEntityClearLosToEntityInFront <const> = HasEntityClearLosToEntityInFront
local IsPedDeadOrDying <const> = IsPedDeadOrDying
local TaskPlayAnim <const> = TaskPlayAnim
local IsEntityPlayingAnim <const> = IsEntityPlayingAnim
local GetGameTimer <const> = GetGameTimer
local Wait <const> = Wait
local DrawRect <const> = DrawRect
local DrawText <const> = DrawText
local SetTextFont <const> = SetTextFont
local SetTextScale <const> = SetTextScale
local SetTextColour <const> = SetTextColour
local SetTextCentre <const> = SetTextCentre
local SetTextDropshadow <const> = SetTextDropshadow
local SetTextEdge <const> = SetTextEdge
local SetTextEntry <const> = SetTextEntry
local AddTextComponentString <const> = AddTextComponentString
local PlaySoundFrontend <const> = PlaySoundFrontend
local IsPlayerFreeAiming <const> = IsPlayerFreeAiming
local GetAmmoInPedWeapon <const> = GetAmmoInPedWeapon
local GetSelectedPedWeapon <const> = GetSelectedPedWeapon
local IsControlPressed <const> = IsControlPressed
local TriggerServerEvent <const> = TriggerServerEvent
local CreateModelSwap <const> = CreateModelSwap
local IsPedArmed <const> = IsPedArmed
local SetTimeout <const> = SetTimeout
local SetEntityCoords <const> = SetEntityCoords
local ApplyForceToEntity <const> = ApplyForceToEntity
local vector3 <const> = vector3
local CreateThread <const> = CreateThread
local IsControlJustPressed <const> = IsControlJustPressed
local pairs <const> = pairs
local GiveWeaponToPed <const> = GiveWeaponToPed
local SetPedRelationshipGroupHash <const> = SetPedRelationshipGroupHash
local SetPedRelationshipGroupDefaultHash <const> = SetPedRelationshipGroupDefaultHash
local SetPedCombatAbility <const> = SetPedCombatAbility
local TaskShootAtEntity <const> = TaskShootAtEntity
local SetPedAccuracy <const> = SetPedAccuracy
local exports <const> = exports
local RegisterNetEvent <const> = RegisterNetEvent
local ClearPedTasks <const> = ClearPedTasks

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
    SetPedDropsWeaponsWhenDead(ped, false)
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
    SetTimeout(Config.Cooldown * 60000, function()
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
    local speedAdjustment = 0.0

    local endTime = startTime + Config.Progress.Duration * 1000
    local progressBarTimer = startTime
    local rougeSettings = Config.Stores[shop.store].Ped.Rouge
    local rouge = false

    if rougeSettings and rougeSettings.Enabled then
        local chance = math.random(1, 100)
        if chance <= rougeSettings.Chance then
            rouge = true
            local weapon = rougeSettings.Weapons[math.random(#rougeSettings.Weapons)]
            GiveWeaponToPed(entity, weapon, 255, false, true)
            SetBlockingOfNonTemporaryEvents(entity, false)

            SetPedRelationshipGroupHash(entity, `ROGUE_OWNER`)
            SetPedRelationshipGroupDefaultHash(entity, `ROGUE_OWNER`)
            SetPedRelationshipGroupHash(ped, `ROGUE_OWNER`)
            SetPedRelationshipGroupDefaultHash(ped, `ROGUE_OWNER`)

            SetPedCombatAbility(entity, 100)
            SetPedAlertness(entity, 3)
            SetPedAccuracy(entity, 100)
            SetPedFleeAttributes(entity, 0, false)

            Config.Notification({ type = 'warning', title = locale('rouge_title'), message = locale('rouge_message') })

            while not IsPedDeadOrDying(entity) and #(GetEntityCoords(ped) - GetEntityCoords(entity)) <= 7.5 and not sync.isPlayerDead() do
                TaskShootAtEntity(entity, ped, 1000, `FIRING_PATTERN_FULL_AUTO`)
                Wait(500)
            end
        end
    end

    if rouge then return end

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

    if IsPedDeadOrDying(entity) or sync.isPlayerDead() then return sync.failedRobbery(shop) end

    SetEntityCoords(entity, Config.Stores[shop.store].Ped.Position)
    lib.requestAnimDict('mp_am_hold_up')
    TaskPlayAnim(entity, "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 2, 0, false, false, false)
    while not IsEntityPlayingAnim(entity, "mp_am_hold_up", "holdup_victim_20s", 3) do Wait(0) end

    local timer = GetGameTimer() + 10800
    while timer >= GetGameTimer() do
        if IsPedDeadOrDying(entity) or sync.isPlayerDead() then break end
        Wait(0)
    end

    if IsPedDeadOrDying(entity) or sync.isPlayerDead() then return sync.failedRobbery(shop) end

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

    if IsPedDeadOrDying(entity) or sync.isPlayerDead() then return sync.failedRobbery(shop) end

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

function sync.clearEntitys()
    for k, v in pairs(createdEntitys) do
        DeleteEntity(v)
    end
end

local textUi = false

function sync.addSafe(v, store)
    if Config.Target then
        local size = 0.7

        exports.ox_target:addBoxZone({
            coords = v.Safe.TargetCoords,
            debug = false,
            size = vec3(size, size, size + 0.2),
            options = {
                {
                    label = locale('safe_label'),
                    icon = locale('safe_icon'),
                    serverEvent = 'trase_storerobbery:server:openSafe',
                    args = store
                }
            }
        }) 
    else
        local point = lib.points.new({ coords = v.Safe.MarkerCoords, distance = 5 })
   
        function point:nearby()
            if not crackingSafe then
                DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.4, 0.4, 0.4, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)
                
                if self.currentDistance < 1.2 then
                    if not textUi then
                        textUi = true
                        lib.showTextUI(locale('open_safe'))
                    end

                    if IsControlJustPressed(0, 38) then
                        crackingSafe = true
                        lib.hideTextUI()
                        TriggerServerEvent('trase_storerobbery:server:openSafe', { args = store })
                    end
                else
                    if textUi then
                        textUi = false
                        lib.hideTextUI()
                    end
                end
            end
        end
    end
end

local ANIMATION_LIB <const> = {
    Begin = { dict = 'move_crouch_proto', anim = 'idle_intro' },
    Loop = { dict = 'anim@amb@business@weed@weed_inspecting_lo_med_hi@', anim = 'weed_crouch_checkingleaves_idle_01_inspector' },
    End = { dict = 'move_crouch_proto', anim = 'idle_transition' }
}

local function KeycardHack()
    if Config.Safes.Hack == "howdy-hackminigame" then
        return exports["howdy-hackminigame"]:Begin(4, 5000)
    end

    local p = promise.new()


    if Config.Safes.Hack == "ps-ui" then
        exports["ps-ui"]:Scrambler(function(success)
            p:resolve(success)
        end, "numeric", 30, 0)
    elseif Config.Safes.Hack == "ultra-voltlab" then
        TriggerEvent("ultra-voltlab", 30, function(outcome)
            p:resolve(outcome == 1)
        end)
    elseif Config.Safes.Hack == "ultra-keypadhack" then
        TriggerEvent("ultra-keypadhack", 2, 30, function(outcome)
            p:resolve(outcome == 1)
        end)
    elseif Config.Safes.Hack == "datacrack" then
        exports["datacrack"]:Start(3.5)
    elseif Config.Safes.Hack == "utk_fingerprint" then
        TriggerEvent("utk_fingerprint:Start", 2, 3, 2, function(success)
            p:resolve(success)
        end)
    elseif Config.Safes.Hack == "electus_hacking" then
        exports.electus_hacking:RunHack("binaryPuzzle", 2, 5, true, function(success)
            p:resolve(success)
        end)
    end

    return Citizen.Await(p)
end

RegisterNetEvent('trase_storerobbery:client:openSafe', function(coords, storeId)
    if (GlobalState['trase_storerobbery:store:safe' .. storeId]) then
        crackingSafe = false
        return Config.Notification({ type = 'error', title = locale('please_wait_safe'), message = locale('please_wait_safe_message') })
    end

    local playerPed = cache.ped

    lib.requestAnimDict(ANIMATION_LIB.Begin.dict)
    lib.requestAnimDict(ANIMATION_LIB.Loop.dict)
    lib.requestAnimDict(ANIMATION_LIB.End.dict)

    TaskPlayAnim(playerPed, ANIMATION_LIB.Begin.dict, ANIMATION_LIB.Begin.anim, 8.0, -8.0, -1, 0, 0, false, false, false)

    Wait(1000)

    local hacking = true

    CreateThread(function()
        success = KeycardHack()
        Wait(1000)
        if not success then
            Config.Notification({ type = 'error', title = locale('safe_failed'), message = locale('safe_failed_message') })
        end
        Wait(1000)
        hacking = false
        crackingSafe = false
    end)
 
    while hacking do
        if not IsEntityPlayingAnim(playerPed, ANIMATION_LIB.Loop.dict, ANIMATION_LIB.Loop.anim, 3) then
            SetEntityHeading(playerPed, coords.w)
            TaskPlayAnim(playerPed, ANIMATION_LIB.Loop.dict, ANIMATION_LIB.Loop.anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        end

        Wait(0)
    end

    TaskPlayAnim(playerPed, ANIMATION_LIB.End.dict, ANIMATION_LIB.End.anim, 8.0, -8.0, -1, 0, 0, false, false, false)
    Wait(1000)
    ClearPedTasks(playerPed)

    if success then
        TriggerServerEvent('trase_storerobbery:server:crackSafe', storeId)
    end
end)

return sync