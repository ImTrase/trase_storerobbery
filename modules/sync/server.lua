local sync = {}

function sync.alertPolice(coords)

    if GetResourceState("qs-dispatch") == "started" then
        TriggerEvent("qs-dispatch:server:CreateDispatchCall", {
            job = Config.PoliceJobs,
            callLocation = coords,
            callCode = {
                code = locale("dispatch_label"),
                snippet = locale("dispatch_brevity_code")
            },
            message = locale("dispatch_description", {
                bank = bank.name
            }),
            flashes = true,
            image = nil,
            blip = {
                sprite = 108,
                scale = 1.5,
                colour = 1,
                flashes = true,
                text = locale("dispatch_label"),
                time = 5 * 60 * 1000,
            }
        })
    elseif GetResourceState("ps-dispatch") == "started" then
        TriggerEvent("ps-dispatch:server:notify", {
            message = locale("dispatch_description", {
                bank = bank.name
            }),
            codeName = locale("dispatch_label"),
            code = locale("dispatch_brevity_code"),
            icon = "fas fa-vault",
            priority = 2,
            coords = coords,
            jobs = Config.PoliceJobs,
        })
    elseif GetResourceState("cd_dispatch") == "started" then
        TriggerClientEvent("cd_dispatch:AddNotification", -1, {
            job_table = Config.PoliceJobs,
            coords = coords,
            title = locale("dispatch_label"),
            message = locale("dispatch_description", {
                bank = bank.name
            }),
            flash = 0,
            unique_id = tostring(math.random(0000000,9999999)),
            sound = 1,
            blip = {
                sprite = 108,
                scale = 1.5,
                colour = 1,
                flashes = false,
                text = locale("dispatch_label"),
                time = 5,
                radius = 0,
            }
        })
    else
        TriggerClientEvent("trase_storerobbery:client:alertPolice", -1, coords)
    end
end

return sync