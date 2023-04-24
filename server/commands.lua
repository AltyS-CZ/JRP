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
