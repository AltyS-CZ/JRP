local Config = require('config')


RegisterCommand('car', function(source, args, rawCommand)
    -- check if the user is an admin or moderator
    if isAdmin(source) or isModerator(source) then
        local car = args[1] or 'adder' -- default to 'adder' if no argument was given
        TriggerClientEvent('spawn:car', source, car)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'SYSTEM', 'You do not have permission to use this command.' }
        })
    end
end, false)
