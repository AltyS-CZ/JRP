-- main script
local Config = require('config')

-- To access the item_list, use Config.item_list

RegisterServerEvent('useItem')
AddEventHandler('useItem', function(item)
    local identifier = GetPlayerIdentifiers(source)[1]

    -- Check if the item exists in our item_list
    if not table.contains(Config.item_list, item) then
        -- Item does not exist in our list
        TriggerClientEvent('chat:addMessage', source, {args = {'That item does not exist.'}})
        return
    end

    -- Check if player has the item
    exports.oxmysql:fetch('SELECT count FROM player_inventory WHERE identifier = ? AND item = ?', {identifier, item}, function(result)
        if result[1] and result[1].count > 0 then
            -- Player has the item, so use it and then remove it from the inventory
            UseItem(identifier, item)
            RemoveInventoryItem(identifier, item, 1)
        else
            -- Player does not have the item
            TriggerClientEvent('chat:addMessage', source, {args = {'You do not have that item.'}})
        end
    end)
end)

-- Function to check if a table contains a value
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

RegisterCommand('giveitem', function(source, args, rawCommand)
    -- args[1] is the player's server ID
    -- args[2] is the item name

    -- Check if the correct number of arguments has been passed
    if #args ~= 2 then
        TriggerClientEvent('chat:addMessage', source, {args = {'Usage: /giveitem [playerID] [itemName]'}})
        return
    end

    local target = tonumber(args[1])
    local item = args[2]

    -- Check if the item exists in our Config.item_list
    if not table.contains(Config.item_list, item) then
        -- Item does not exist in our list
        TriggerClientEvent('chat:addMessage', source, {args = {'That item does not exist.'}})
        return
    end

    -- Check if the player is valid
    if target and GetPlayerName(target) then
        -- Give the item to the player
        local identifier = GetPlayerIdentifiers(target)[1]
        AddInventoryItem(identifier, item, 1)
    else
        TriggerClientEvent('chat:addMessage', source, {args = {'That player does not exist.'}})
    end
end, false) -- false means this command can be used by any player, not just admins

