local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('neiz-stash:server:register', function(id, label, slots, weight, job)
    if Config.Inventory == "ox" then
        if job then
            exports.ox_inventory:RegisterStash(id, label, slots, weight, false, job)
        else
            exports.ox_inventory:RegisterStash(id, label, slots, weight, false)
        end
    elseif Config.Inventory == "qb" then
        TriggerEvent("inventory:server:addStash", id, label, slots, weight)
    end
end)