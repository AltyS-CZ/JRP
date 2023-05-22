-------------------------

--INFO COMMAND (ALL)
--- The function must be kept
-- in order for the info command to work
local function getPlayerData(player, callback)
    local playerId = tonumber(player)
    local identifiers = GetPlayerIdentifiers(playerId)
    local identifier = identifiers[1]
    exports.oxmysql:execute('SELECT * FROM users WHERE identifier = ?', {identifier}, function(result)
        if result[1] ~= nil then
            local data = {
                identifier = result[1].identifier,
                license = result[1].license,
                name = result[1].name,
                job = result[1].job or "Citizen",
                cash = result[1].cash,
                bank = result[1].bank,
                dirty_money = result[1].dirty_money,
                position = json.decode(result[1].position) or nil
            }
            callback(data)
        else
            callback(nil)
        end
    end)
end

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
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    TriggerClientEvent("chat:addMessage", source, {args = {"^1[Server]", "^7Your position: " .. playerCoords.x .. ", " .. playerCoords.y .. ", " .. playerCoords.z}})
end, true)


-- Command to spawn a vehicle by model name
RegisterCommand("car", function(source --[[ this is the player ID (on the server): a number ]], args --[[ this is a table of the arguments provided ]], rawCommand --[[ this is what the user entered ]])
    if source > 0 then
        TriggerClientEvent("admin:on_car", source, args)
    else
        print("This is console!")
    end
end, true)


---------------------------

-- TPM (ADMIN)

RegisterCommand("tpc", function(source, args, rawCommand)
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
end, true)

RegisterCommand("tpm", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "admin") then
        local waypointBlip = GetFirstBlipInfoId(8)
        if waypointBlip ~= nil then
            local waypointCoords = GetBlipCoords(waypointBlip)
            -- Teleport the player to the waypoint coordinates
            if waypointCoords ~= nil then
                SetEntityCoords(GetPlayerPed(source), waypointCoords.x, waypointCoords.y, waypointCoords.z)
            end
        else
            -- No waypoint found
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"Server", "You haven't set a waypoint."}
            })
        end
    else
        -- Player does not have permission to use the command
        -- You can send a chat message to inform the player
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Server", "You don't have permission to use this command."}
        })
    end
end, false)

RegisterCommand("dv", function(source, args, rawCommand)
    -- Check if the player has the 'admin' permission using ACE
    if IsPlayerAceAllowed(source, "admin") then
        -- Delete the player's vehicle
        DeletePlayerVehicle(source)
    else
        -- Player does not have permission to use the command
        -- You can send a chat message to inform the player
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Server", "You don't have permission to use this command."}
        })
    end
end, false)

-----------------
-- /removemoney command
RegisterCommand("removemoney", function(source, args, rawCommand)
    local player = source
    local targetPlayer = tonumber(args[1])
    local accountType = args[2] -- "cash" or "bank"
    local amount = tonumber(args[3])

    -- Check if the player is an admin
    if not IsAdmin(GetPlayerIdentifier(player, 0)) then
        -- Player is not an admin, show error message
        TriggerClientEvent('chat:addMessage', player, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Server", "You don't have permission to use this command."}
        })
        return
    end

    -- Remove money from the targetPlayer
    TriggerEvent("custom_economy:removeMoney", targetPlayer, accountType, amount)
end, false)

-- /givemoney command
RegisterCommand("givemoney", function(source, args, rawCommand)
    local player = source
    local targetPlayer = tonumber(args[1])
    local accountType = args[2] -- "cash" or "bank"
    local amount = tonumber(args[3])

    -- Check if the player is an admin
    if not IsAdmin(GetPlayerIdentifier(player, 0)) then
        -- Player is not an admin, show error message
        TriggerClientEvent('chat:addMessage', player, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Server", "You don't have permission to use this command."}
        })
        return
    end

    -- Give money to the targetPlayer
    TriggerEvent("custom_economy:addMoney", targetPlayer, accountType, amount)
end, false)
