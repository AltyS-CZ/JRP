local oxmysql = exports.oxmysql
------------------------------------------------ PLEASE DO NOT TOUCH -----------------------------------------------------------------------------
-- Load player data on server start
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('^5 JRP Framework has been sucessfully initialized.')
end)

-- Add new player to the database
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local identifier = identifiers[1]

    -- Check if player already exists in the database
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] == nil then
            -- Add new player to the database
            exports.oxmysql:execute('INSERT INTO users (identifier, job, cash, bank, dirty_money) VALUES (@identifier, @job, @cash, @bank, @dirty_money)', {
                ['@identifier'] = identifier,
                ["@job"] = "Citizen",
                ['@cash'] = Config.StartingCash,
                ['@bank'] = Config.StartingBank,
                ['@dirty_money'] = 0
            }, function(rowsChanged)
                print('new user added to database')
            end)
        else
            print('existing user found in database')
        end
    end)
end)

