-- Commands for Framework

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
    if IsPlayerAceAllowed(source, "admin") then
        local playerPed = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(playerPed)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1[Server]", "^7Your position: " .. playerCoords.x .. ", " .. playerCoords.y .. ", " .. playerCoords.z}})
    else
        TriggerClientEvent("chat:addMessage", source, {args = {"^1[Server]", "^7You do not have permission to use this command."}})
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

-- Define an Ace permission for the forcesalary command
AddAceResourceCommand("custom_economy", "forcesalary", function(source, args, rawCommand)
    -- Check that the player is authorized to run this command
    if IsPlayerAceAllowed(source, "custom_economy.forcesalary") then
        -- Trigger the GiveSalary() function to pay out salaries to all players
        GiveSalary()
        -- Send a confirmation message to the player who executed the command
        TriggerClientEvent("chat:addMessage", source, { args = { "Economy", "Salaries have been forced for all players." }, color = { 255, 0, 0 } })
    else
        -- Send an error message to the player who executed the command if they're not authorized
        TriggerClientEvent("chat:addMessage", source, { args = { "Economy", "You are not authorized to use this command." }, color = { 255, 0, 0 } })
    end
end, true)
