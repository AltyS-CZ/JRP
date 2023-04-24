-- Admin commands


RegisterCommand('givemoney', function(source, args, rawCommand)
    -- Check if the player has permission to use this command
    if not IsPlayerAceAllowed(source, 'custom_economy.givemoney') then
        TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'You do not have permission to use this command.'}})
        return
    end

    -- Check if the command has the correct number of arguments
    if #args ~= 3 then
        TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Invalid syntax. Usage: /givemoney [player ID] [account type] [amount]'}})
        return
    end

    -- Get the player ID and account type from the command arguments
    local playerId = tonumber(args[1])
    local accountType = args[2]
    local amount = tonumber(args[3])

    -- Check if the player ID and account type are valid
    if not playerId or not accountType or (accountType ~= 'cash' and accountType ~= 'bank' and accountType ~= 'dirtymoney') or not amount then
        TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Invalid syntax. Usage: /givemoney [player ID] [account type] [amount]'}})
        return
    end

    -- Add the money to the player's account in the database
    exports.oxmysql:execute('UPDATE users SET ' .. accountType .. ' = ' .. accountType .. ' + ? WHERE id = ?', {amount, playerId}, function(result)
        if result.affectedRows == 1 then
            TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'You have given $' .. amount .. ' to player ' .. playerId .. ' in their ' .. accountType .. ' account.'}})
            TriggerClientEvent('custom_economy:updateMoneyDisplay', playerId)
        else
            TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Failed to add money to player account.'}})
        end
    end)
end, true)

-- SETJOB COMMAND

RegisterCommand('setjob', function(source, args, rawCommand)
    if #args ~= 2 then
        TriggerClientEvent('chat:addMessage', source, {args = {'^1Syntax error: ^7/setjob [player ID] [job]'}})
        return
    end

    local playerId = tonumber(args[1])
    local job = args[2]
    setPlayerJob(playerId, job)

    TriggerClientEvent('chat:addMessage', source, {args = {'^1Success! ^7Player ' .. playerId .. ' is now a ' .. job}})
end, true)

--INFO COMMAND
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


