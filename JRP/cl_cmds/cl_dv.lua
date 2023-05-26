RegisterNetEvent("jrp:deletePlayerVehicle")
AddEventHandler("jrp:deletePlayerVehicle", function(isInVehicle)
    local playerId = PlayerId()
    if isInVehicle then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        DeleteEntity(vehicle)
        TriggerEvent("chatMessage", "^2SUCCESS", {255, 255, 255}, "Vehicle you are sitting in deleted.")
    else
        TriggerEvent("chatMessage", "^1ERROR", {255, 255, 255}, "You are not sitting in a vehicle.")
    end
end)

RegisterNetEvent("jrp:deleteVehiclesInRadius")
AddEventHandler("jrp:deleteVehiclesInRadius", function(radius)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = {}
    local vehicleList = GetGamePool("CVehicle")

    for _, vehicle in ipairs(vehicleList) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = GetDistanceBetweenCoords(playerCoords, vehicleCoords, true)
        if distance <= radius then
            table.insert(vehicles, vehicle)
        end
    end

    for _, vehicle in ipairs(vehicles) do
        DeleteEntity(vehicle)
    end

    local playerId = PlayerId()
    local message = "Vehicles within a radius of " .. radius .. " meters deleted."
    if #vehicles == 0 then
        message = "No vehicles found within the specified radius."
    end
    TriggerEvent("chatMessage", "^2SUCCESS", {255, 255, 255}, message)
end)



RegisterNetEvent("jrp:checkPlayerVehicle")
AddEventHandler("jrp:checkPlayerVehicle", function()
    local playerPed = PlayerPedId()
    local isInVehicle = IsPedInAnyVehicle(playerPed, false)
    TriggerServerEvent("jrp:deletePlayerVehicle", isInVehicle)
end)
