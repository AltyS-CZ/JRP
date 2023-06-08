RegisterCommand("job", function(source, args)
    local playerId = source
    -- assuming that the identifier is steam hex
    local identifier = GetPlayerIdentifiers(playerId)[1] or false

    if not identifier then
        TriggerClientEvent('chat:addMessage', playerId, { args = { 'SYSTEM', 'Identifier not found.' } })
        return
    end

    local query = 'SELECT job FROM users WHERE identifier = @identifier'
    local parameters = {
        ['@identifier'] = identifier
    }

    exports.oxmysql:scalar(query, parameters, function(job)
        if not job then
            TriggerClientEvent('chat:addMessage', playerId, { args = { 'SYSTEM', 'No job found.' } })
            return
        end

        TriggerClientEvent('chat:addMessage', playerId, { args = { 'SYSTEM', 'Your job: ' .. job } })
    end)
end, false)
