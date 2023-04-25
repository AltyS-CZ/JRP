-- Commands for Framework

-------------------------

--INFO COMMAND (ALL)


RegisterCommand("info", function(source, args)
    local player = source
    getPlayerData(player, function(data)
        if data ~= nil then
            local message = "Cash: $" .. data.cash .. ", Bank: $" .. data.bank .. ", Dirty Money: $" .. data.dirty_money .. ", Job: " .. data.job
            TriggerClientEvent('chat:addMessage', player, {args = {"Server", message}})
        else
            TriggerClientEvent('chat:addMessage', player, {args = {"Server", "Unable to retrieve player data."}})
        end
    end)
end)
-------------------------
-- COORDS COMMAND (ADMIN)

RegisterCommand("getpos", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "admin") then
        local playerPed = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(playerPed)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1[Server]", "^7Your position: " .. playerCoords.x .. ", " .. playerCoords.y .. ", " .. playerCoords.z}})
    else
        TriggerClientEvent("chat:addMessage", source, {args = {"^1[Server]", "^7You do not have permission to use this command."}})
    end
end, true)


-- Command to spawn a vehicle by model name
RegisterCommand("car", function(source, args, rawCommand)
    -- Check if the player is an admin
    if IsPlayerAceAllowed(source, "admin") then
        -- Get the player's coordinates and heading
        local playerPed = GetPlayerPed(source)
        local playerPos = GetEntityCoords(playerPed)
        local playerHeading = GetEntityHeading(playerPed)

        -- Get the model name of the vehicle to spawn
        local model = args[1]

        -- Check if a model name was provided
        if model ~= nil then
            -- Request the model to be loaded
            RequestModel(model)

            -- Wait for the model to load
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end

            -- Spawn the vehicle at the player's location and heading
            local vehicle = CreateVehicle(model, playerPos, playerHeading, true, false)

            -- Set the vehicle as the player's current vehicle
            SetPedIntoVehicle(playerPed, vehicle, -1)

            -- Send a message to the player that the vehicle was spawned
            TriggerClientEvent("chat:addMessage", source, {color = {255, 255, 0}, args = {"Server", "Spawned " .. GetDisplayNameFromVehicleModel(model) .. " at your location."}})
        else
            -- Send an error message to the player if no model name was provided
            TriggerClientEvent("chat:addMessage", source, {color = {255, 0, 0}, args = {"Error", "Invalid model name."}})
        end
    end
end, true)


---------------------------

-- TPM (ADMIN)

RegisterCommand("tpc", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "admin") then
        local playerPed = GetPlayerPed(source)
        local x = tonumber(args[1])
        local y = tonumber(args[2])
        local z = tonumber(args[3])
        
        if x ~= nil and y ~= nil and z ~= nil then
            SetEntityCoords(playerPed, x, y, z)
            TriggerClientEvent("chat:addMessage", source, {color = {255, 255, 0}, args = {"Server", "Teleported to marker."}})
        else
            TriggerClientEvent("chat:addMessage", source, {color = {255, 0, 0}, args = {"Error", "Invalid coordinates."}})
        end
    end
end, true)

RegisterCommand('tpm', function(source, args)
    if IsPlayerAceAllowed(source, 'admin') then
        local waypoint = GetFirstBlipInfoId(8)
        if DoesBlipExist(waypoint) then
            local playerPed = GetPlayerPed(source)
            local waypointCoords = GetBlipInfoIdCoord(waypoint)
            SetEntityCoords(playerPed, waypointCoords.x, waypointCoords.y, waypointCoords.z, 0, 0, 0, 0)
            TriggerClientEvent('chat:addMessage', source, { args = { '^1Teleport', '^7You have been teleported to the waypoint.' } })
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1Teleport', '^7No waypoint found.' } })
        end
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1Teleport', '^7Insufficient permission.' } })
    end
end, true)
