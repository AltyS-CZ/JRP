local oxmysql = exports.oxmysql

-- Load player data on server start
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
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
            MySQL.Async.execute('INSERT INTO users (identifier, cash, bank, dirty_money) VALUES (@identifier, @cash, @bank, @dirty_money)', {
                ['@identifier'] = identifier,
                ['@cash'] = 0,
                ['@bank'] = 0,
                ['@dirty_money'] = 0
            }, function(rowsChanged)
                print('new user added to database')
            end)
        else
            print('existing user found in database')
        end
    end)
end)


RegisterCommand('info', function(source, args, rawCommand)
    getPlayerMoney(source)
end, false)

function setPlayerJob(player, job)
    local playerId = getPlayerId(player)
    exports.oxmysql:execute('UPDATE users SET job = ? WHERE id = ?', {job, playerId})
end

local cash = 0
local bank = 0
local dirtyMoney = 0

function getPlayerMoney(player)
    local playerId = getPlayerId(player)
    local identifiers = GetPlayerIdentifiers(playerId)
    local identifier = identifiers[1]
    exports.oxmysql:execute('SELECT cash, bank, dirty_money, job FROM users WHERE identifier = ?', {identifier}, function(result)
        cash = result[1].cash
        bank = result[1].bank
        dirtyMoney = result[1].dirty_money
        local job = result[1].job
        TriggerClientEvent("custom_economy:updateMoneyDisplay", playerId, cash, bank, dirtyMoney, job)
    end)
end

RegisterServerEvent("custom_economy:updateMoney")
AddEventHandler("custom_economy:updateMoney", function()
    getPlayerMoney(source)
end)

function getPlayerId(player)
    if type(player) == 'number' then
        return player
    elseif type(player) == 'string' then
        for _, id in ipairs(GetPlayers()) do
            if GetPlayerName(id) == player then
                return id
            end
        end
    elseif type(player) == 'userdata' then
        return tonumber(PlayerId())
    end
    return nil
end
