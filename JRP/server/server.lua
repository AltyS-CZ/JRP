------------------------------------ DO NOT TOUCH --------------------------------------
------------------------------------ DO NOT TOUCH --------------------------------------


local cash = 0
local bank = 0
local dirtyMoney = 0


function GetPlayerData(source, callback)
    local playerId = tonumber(source)
    if not playerId then
        callback(nil)
        return
    end

    exports.oxmysql:execute('SELECT * FROM users WHERE id = ?', { playerId }, function(result)
        if result and #result > 0 then
            local playerData = result[1]
            callback(playerData)
        else
            callback(nil)
        end
    end)
end



local function GetPlayerMoney(playerId, account)
    -- Fetch player data from the 'users' table using the playerId
    local playerData = exports.oxmysql:fetchSync('SELECT * FROM users WHERE id = ?', { playerId })
    if playerData and #playerData > 0 then
        if account == 'cash' then
            return playerData[1].cash or 0
        elseif account == 'bank' then
            return playerData[1].bank or 0
        end
    end
    return 0
end

local function SetPlayerMoney(playerId, account, amount)
    -- Update the 'users' table with the new money amount
    exports.oxmysql:execute('UPDATE users SET ' .. account .. ' = ? WHERE id = ?', { amount, playerId })
end

local function GivePlayerMoney(playerId, account, amount)
    local currentMoney = GetPlayerMoney(playerId, account)
    local newMoney = currentMoney + amount
    SetPlayerMoney(playerId, account, newMoney)
end

local function RemovePlayerMoney(playerId, account, amount)
    local currentMoney = GetPlayerMoney(playerId, account)
    if currentMoney >= amount then
        local newMoney = currentMoney - amount
        SetPlayerMoney(playerId, account, newMoney)
    end
end


--- Get player date such as cash, bank and dirty money
function getPlayerData(player, callback)
    local playerId = tonumber(player)
    local identifiers = GetPlayerIdentifiers(playerId)
    local identifier = identifiers[1]
    exports.oxmysql:execute('SELECT * FROM users WHERE identifier = ?', {identifier}, function(result)
        if result[1] ~= nil then
            local data = {
                identifier = result[1].identifier,
                license = result[1].license,
                name = result[1].name,
                job = result[1].job or "Citizen",
                cash = result[1].cash,
                bank = result[1].bank,
                dirty_money = result[1].dirty_money,
                position = json.decode(result[1].position) or nil
            }
            callback(data)
        else
            callback(nil)
        end
    end)
end

RegisterCommand('info', function(source, args)
    getPlayerData(source, function(playerData)
        if playerData then
            local cash = playerData.cash
            local bank = playerData.bank
            local message = string.format("Cash: $%s | Bank: $%s", cash, bank)
            TriggerClientEvent('chatMessage', source, "^4[INFO]", { 255, 255, 255 }, message)
        else
            TriggerClientEvent('chatMessage', source, "^1[ERROR]", { 255, 255, 255 }, "Failed to retrieve player data.")
        end
    end)
end, false)


RegisterCommand('givemoney', function(source, args)
    local playerId = tonumber(args[1])
    local account = args[2]
    local amount = tonumber(args[3])

    if not playerId or not account or not amount then
        TriggerClientEvent('chatMessage', source, "^1[ERROR]", {255, 255, 255}, "Invalid command usage. Correct syntax: /givemoney [playerId] [account] [amount]")
        return
    end

    getPlayerData(playerId, function(playerData)
        if playerData then
            local currentAmount = playerData[account]
            local newAmount = currentAmount + amount
            exports.oxmysql:execute('UPDATE users SET ' .. account .. ' = ? WHERE identifier = ?', { newAmount, playerData.identifier })
            TriggerClientEvent('chatMessage', source, "^2[SUCCESS]", {255, 255, 255}, "Money given successfully.")
        else
            TriggerClientEvent('chatMessage', source, "^1[ERROR]", {255, 255, 255}, "Player data not found.")
        end
    end)
end, true)


RegisterCommand('removemoney', function(source, args)
    local playerId = tonumber(args[1])
    local account = args[2]
    local amount = tonumber(args[3])

    if not playerId or not account or not amount then
        TriggerClientEvent('chatMessage', source, "^1[ERROR]", {255, 255, 255}, "Invalid command usage. Correct syntax: /removemoney [playerId] [account] [amount]")
        return
    end

    getPlayerData(playerId, function(playerData)
        if playerData then
            local currentAmount = playerData[account]
            local newAmount = currentAmount - amount
            if newAmount < 0 then
                newAmount = 0
            end
            exports.oxmysql:execute('UPDATE users SET ' .. account .. ' = ? WHERE identifier = ?', { newAmount, playerData.identifier })
            TriggerClientEvent('chatMessage', source, "^2[SUCCESS]", {255, 255, 255}, "Money removed successfully.")
        else
            TriggerClientEvent('chatMessage', source, "^1[ERROR]", {255, 255, 255}, "Player data not found.")
        end
    end)
end, true)
