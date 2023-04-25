local oxmysql = exports.oxmysql

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


local cash = 0
local bank = 0
local dirtyMoney = 0

function GetPlayerMoney(source)
    local player = GetPlayerIdentifier(source)
    local result = nil

    exports.oxmysql:execute('SELECT cash, bank, dirty_money FROM users WHERE identifier = ?', {player}, function(data)
        result = data[1]
    end)

    while result == nil do
        Citizen.Wait(0)
    end

    return result.cash, result.bank, result.dirty_money
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

-- Function to update the player's money display
function updateMoneyDisplay(source)
    local identifier = GetPlayerIdentifier(source, 0)
    local moneyData = getPlayerMoney(identifier)
    TriggerClientEvent("custom_economy:updateMoneyDisplay", source, moneyData)
end

-- Event to handle giving money to a player
RegisterServerEvent("custom_economy:giveMoney")
AddEventHandler("custom_economy:giveMoney", function(amount, account)
    local source = tonumber(source)
    local identifier = GetPlayerIdentifier(source, 0)
    local moneyData = getPlayerMoney(identifier)

    if account == "cash" then
        moneyData.cash = moneyData.cash + amount
    elseif account == "bank" then
        moneyData.bank = moneyData.bank + amount
    elseif account == "dirty" then
        moneyData.dirtyMoney = moneyData.dirtyMoney + amount
    end

    updatePlayerMoney(identifier, moneyData)
    updateMoneyDisplay(source)
end)

function SetPlayerMoney(playerId, moneyType, amount)
    local identifier = GetPlayerIdentifier(playerId)
    exports.oxmysql:execute('UPDATE users SET ' .. moneyType .. ' = ? WHERE identifier = ?', {amount, identifier})
end

-------------------------------------------------------



