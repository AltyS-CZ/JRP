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

-- Function to get the player's cash
function GetPlayerCash(source)
    local player = source
    local cash = 0

    -- Retrieve the cash from the database
    exports.oxmysql:execute('SELECT cash FROM users WHERE identifier = ?', { GetPlayerIdentifier(player, 0) }, function(result)
        if result[1] ~= nil then
            cash = tonumber(result[1].cash)
        end
    end)

    return cash
end

-- Function to add cash to the player
function AddPlayerCash(source, amount)
    local player = source
    local currentCash = GetPlayerCash(player)

    -- Calculate the new cash value
    local newCash = currentCash + amount

    -- Update the cash in the database
    exports.oxmysql:execute('UPDATE users SET cash = ? WHERE identifier = ?', { newCash, GetPlayerIdentifier(player, 0) })
end

-- Function to remove cash from the player
function RemovePlayerCash(source, amount)
    local player = source
    local currentCash = GetPlayerCash(player)

    -- Check if the player has enough cash
    if currentCash >= amount then
        -- Calculate the new cash value
        local newCash = currentCash - amount

        -- Update the cash in the database
        exports.oxmysql:execute('UPDATE users SET cash = ? WHERE identifier = ?', { newCash, GetPlayerIdentifier(player, 0) })
        -- Cash successfully removed
        TriggerClientEvent('chat:addMessage', player, { args = { '^2Success:', '$' .. amount ' was removed from your cash.'} })
        return true
    else
        TriggerClientEvent('chat:addMessage', player, { args = { '^1Error:', 'Insufficient funds' } })
        return false
    end
end

-- Event to handle the remove cash command
RegisterNetEvent('custom_economy:removeCash')
AddEventHandler('custom_economy:removeCash', function(amount)
    local player = source

    -- Remove cash from the player
    local success = RemovePlayerCash(player, amount)
--[[
    if success then
        -- Cash successfully removed
        TriggerClientEvent('chat:addMessage', player, { args = { '^2Success:', 'You have lost $' .. amount } })
    else
        -- Player does not have enough cash
        TriggerClientEvent('chat:addMessage', player, { args = { '^1Error:', 'Insufficient funds' } })
    end ]]
end)

-- Define the getPlayerBankBalance function
local function getPlayerBankBalance(playerId)
    -- Perform the database query to fetch the bank balance
    -- Replace this with your actual database query code
    local bankBalance = 0 -- Replace with your database retrieval logic

    -- Return the bank balance
    return bankBalance
end


-- Export the functions
exports('getPlayerBankBalance', getPlayerBankBalance)
exports('GetPlayerCash', GetPlayerCash)
exports('AddPlayerCash', AddPlayerCash)
exports('RemovePlayerCash', RemovePlayerCash)

