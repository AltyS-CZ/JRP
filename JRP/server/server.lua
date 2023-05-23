local cash = 0
local bank = 0
local dirtyMoney = 0
------------------------------------SERVER FUNCTIONS---------------------------------------


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

-- Define the getPlayerBankBalance function
local function getPlayerBankBalance(playerId)
    -- Perform the database query to fetch the bank balance
    -- Replace this with your actual database query code
    local bankBalance = 0 -- Replace with your database retrieval logic

    -- Return the bank balance
    return bankBalance
end


--- Get player date such as cash, bank and dirty money
local function getPlayerData(player, callback)
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

------------- PLAYER INFO COMMAND ----------------
RegisterCommand("info", function(source, args)
    local player = source
    getPlayerData(player, function(data)
        if data ~= nil then
            local message = "Cash: $" .. data.cash .. ", Bank: $" .. data.bank .. ", Dirty Money: $" .. data.dirty_money .. ", Job: " .. data.job
            TriggerClientEvent('chat:addMessage', player, {args = {"Server", message}})
        else
            TriggerClientEvent('chat:addMessage', player, {args = {"Server", "Unable to retrieve player data."}})
        end
    end)
end)

function SavePlayerData(identifier, playerId, playerData)
    exports.oxmysql:execute('UPDATE players SET cash = @cash, bank = @bank WHERE identifier = @identifier AND player_id = @playerId',
        {
            ['@identifier'] = identifier,
            ['@playerId'] = playerId,
            ['@cash'] = playerData.cash,
            ['@bank'] = playerData.bank
        }
    )
end


function SetPlayerCash(identifier, playerId, amount, account)
    -- Retrieve the player's current cash and bank data based on the identifier and player ID
    local playerData = GetPlayerData(identifier, playerId)

    -- Update the cash or bank based on the provided account
    if account == "cash" then
        playerData.cash = playerData.cash + amount
    elseif account == "bank" then
        playerData.bank = playerData.bank + amount
    end

    -- Save the updated player data
    SavePlayerData(identifier, playerId, playerData)
end
------------------------------------SERVER EVENTS---------------------------------------


RegisterServerEvent("jrp:giveMoney")
AddEventHandler("jrp:giveMoney", function(targetId, amount, account)
    local source = tonumber(source)
    local identifier = GetPlayerIdentifier(source, 0)

    -- Call the function to set the player's money data
    SetPlayerCash(identifier, targetId, amount, account)
end)

RegisterCommand("givemoney", function(source, args)
    local targetId = tonumber(args[1])
    local amount = tonumber(args[2])
    local account = args[3]

    if targetId ~= nil and amount ~= nil and account ~= nil then
        TriggerEvent("jrp:giveMoney", targetId, amount, account)
        TriggerClientEvent("chatMessage", source, "^2SUCCESS", {255, 255, 255}, "You have given $" .. amount .. " to player ID " .. targetId .. "'s " .. account)
    else
        TriggerClientEvent("chatMessage", source, "^1ERROR", {255, 255, 255}, "Invalid usage! Correct usage: /givemoney [targetID] [amount] [account]")
    end
end)

RegisterServerEvent("jrp:removeMoney")
AddEventHandler("jrp:removeMoney", function(targetId, amount, account)
    local source = tonumber(source)
    local identifier = GetPlayerIdentifier(source, 0)
    local moneyData = GetPlayerCash(targetId)

    if account == "cash" then
        if moneyData.cash >= amount then
            moneyData.cash = moneyData.cash - amount
        else
            -- Not enough cash
            return
        end
    elseif account == "bank" then
        if moneyData.bank >= amount then
            moneyData.bank = moneyData.bank - amount
        else
            -- Not enough money in the bank
            return
        end
    end
end)

RegisterCommand("removemoney", function(source, args)
    local targetId = tonumber(args[1])
    local amount = tonumber(args[2])
    local account = args[3]

    if targetId ~= nil and amount ~= nil and account ~= nil then
        TriggerEvent("jrp:removeMoney", targetId, amount, account)
        TriggerClientEvent("chatMessage", source, "^2SUCCESS", {255, 255, 255}, "You have removed $" .. amount .. " from player ID " .. targetId .. "'s " .. account)
    else
        TriggerClientEvent("chatMessage", source, "^1ERROR", {255, 255, 255}, "Invalid usage! Correct usage: /removemoney [targetID] [amount] [account]")
    end
end)
