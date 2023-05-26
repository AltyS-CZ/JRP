local Config = require('config')


RegisterCommand('tpm', function(source, args, rawCommand)
    -- check if the user is an admin or moderator
    if isAdmin(source) or isModerator(source) then
        TriggerClientEvent('tpm:teleportToWaypoint', source)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'SYSTEM', 'You do not have permission to use this command.' }
        })
    end
end, false)
