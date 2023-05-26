local Config = require('config')

function isAdmin(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in ipairs(identifiers) do
        if string.sub(id, 1, string.len("steam:")) == "steam:" then
            for _, admin in ipairs(Config.admins) do
                if id == admin then
                    return true
                end
            end
        end
    end
    return false
end

-- create a function to check if a player is a moderator
function isModerator(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in ipairs(identifiers) do
        if string.sub(id, 1, string.len("steam:")) == "steam:" then
            for _, mod in ipairs(Config.moderators) do
                if id == mod then
                    return true
                end
            end
        end
    end
    return false
end



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


