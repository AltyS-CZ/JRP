RegisterCommand("dv", function(source, args)
    local playerId = source

    if args[1] then
        local radius = tonumber(args[1])
        if radius then
            DeleteVehiclesInRadius(playerId, radius)
        else
            TriggerClientEvent("chatMessage", playerId, "^1ERROR", {255, 255, 255}, "Invalid radius specified.")
        end
    else
        DeletePlayerVehicle(playerId)
    end
end)

function DeletePlayerVehicle(playerId)
    local playerPed = GetPlayerPed(playerId)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
        TriggerClientEvent("chatMessage", playerId, "^2SUCCESS", {255, 255, 255}, "Vehicle you are sitting in deleted.")
    else
        TriggerClientEvent("chatMessage", playerId, "^1ERROR", {255, 255, 255}, "You are not sitting in a vehicle.")
    end
end

function DeleteVehiclesInRadius(playerId, radius)
    local playerPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = {}

    for _, vehicle in ipairs(GetAllVehicles()) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(playerCoords - vehicleCoords)
        if distance <= radius then
            DeleteEntity(vehicle)
            table.insert(vehicles, vehicle)
        end
    end

    local message = "Vehicles within a radius of " .. radius .. " meters deleted."
    if #vehicles == 0 then
        message = "No vehicles found within the specified radius."
    end
    TriggerClientEvent("chatMessage", playerId, "^2SUCCESS", {255, 255, 255}, message)
end
