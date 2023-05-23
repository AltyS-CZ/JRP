-- load the configuration file
local Config = require('config')

-- create the /getpos command
RegisterCommand('getpos', function(source, args, rawCommand)
    -- check if the user is an admin or moderator
    if isAdmin(source) or isModerator(source) then
        local coords = GetEntityCoords(GetPlayerPed(source))
        local heading = GetEntityHeading(GetPlayerPed(source))

        -- print the player's coordinates
        TriggerClientEvent('chat:addMessage', -1, {
            args = { 'SYSTEM', 'Coords: '..coords..', Heading: '..heading }
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'SYSTEM', 'You do not have permission to use this command.' }
        })
    end
end, false)
