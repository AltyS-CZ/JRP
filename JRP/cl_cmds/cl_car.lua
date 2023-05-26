RegisterNetEvent('spawn:car')
AddEventHandler('spawn:car', function(car)
    -- get the player's position
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)

    -- request the model for the specified car
    local model = GetHashKey(car)
    RequestModel(model)

    -- wait until the model is loaded
    while not HasModelLoaded(model) do
        Wait(1)
    end

    -- spawn the car
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- cleanup
    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(model)

    TriggerEvent('chat:addMessage', {
        args = { 'SYSTEM', 'Spawned a ' .. car }
    })
end)
