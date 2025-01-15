local playerPed = PlayerPedId()
local playerCoords = GetEntityCoords(playerPed)
local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for _, stash in pairs(Config.Depolar) do
        local blip = AddBlipForCoord(stash.coords.x, stash.coords.y, stash.coords.z)
        SetBlipSprite(blip, 414)
        SetBlipColour(blip, 29)
        SetBlipScale(blip, 0.75)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(stash.label)
        EndTextCommandSetBlipName(blip)
    end
end)

CreateThread(function()
    while true do
        local sleep = 2000
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)

        for _, stash in pairs(Config.Depolar) do
            local distance = #(playerCoords - stash.coords)

            if distance < Config.DrawDistance then
                sleep = 0
                local text = stash.personal and "[E] Kişisel Depo" or "[E] Depo"
                Draw3DText(stash.coords.x, stash.coords.y, stash.coords.z, text)

                if distance < 1.5 and IsControlJustReleased(0, 38) then
                    local stashId = stash.id

                    if stash.jobs and QBCore.Functions.GetPlayerData().job.name ~= stash.jobs then
                        QBCore.Functions.Notify("Bu Depo'yu Açmaya İznin Yok.", "error")
                        break
                    elseif stash.gangs and QBCore.Functions.GetPlayerData().gang.name ~= stash.gangs then
                        QBCore.Functions.Notify("Bu Depo'yu Açmaya İznin Yok.", "error")
                        break
                    end

                    if stash.personal then
                        stashId = stash.shared 
                            and "Personel_" .. QBCore.Functions.GetPlayerData().citizenid 
                            or stash.id .. "_" .. QBCore.Functions.GetPlayerData().citizenid
                    end

                    if Config.Inventory == "ox" then
                        if not exports.ox_inventory:openInventory('stash', stashId) then
                            TriggerServerEvent('neiz-stash:server:register', stashId, stash.label, stash.slots, stash.weight, stash.jobs)
                            exports.ox_inventory:openInventory('stash', stashId)
                        end
                    elseif Config.Inventory == "qb" then
                        TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, {
                            maxweight = stash.weight,
                            slots = stash.slots
                        })
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local scale = 0.35

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextColour(255, 255, 255, 215)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = string.len(text) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 150)
    end
end
