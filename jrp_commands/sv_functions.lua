
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

