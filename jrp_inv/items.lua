-- main script
local Config = require('config')

-- To access the item_list, use Config.item_list

function UseItem(item)
    local selectedItem = Config.item_list[item] -- Get the selected item from the config

    if selectedItem then
        TriggerServerEvent('useItem', selectedItem)
    else
        print("Selected item is not valid")
    end
end

-- Event handler to use an item
RegisterServerEvent('useItem')
AddEventHandler('useItem', function(item)
    local _source = source
    local identifier = GetPlayerIdentifier(_source)

    local selectedItem = nil
    for _, configItem in ipairs(Config.item_list) do
        if configItem.item == item or configItem.name == item then
            selectedItem = configItem
            break
        end
    end

    if selectedItem then
        local itemName = selectedItem.name
        local itemKey = selectedItem.item

        -- Update the inventory and perform other actions as needed
        exports.oxmysql:execute('UPDATE player_inventory SET count = count - 1 WHERE identifier = ? AND item = ? AND count > 0',
            { identifier, itemKey },
            function(numRowsAffected)
                if numRowsAffected and numRowsAffected.affectedRows > 0 then
                    print("Item has been removed from the player's inventory.")

                    -- Check if the count is now 0 and remove the item from the table
                    exports.oxmysql:execute('DELETE FROM player_inventory WHERE identifier = ? AND item = ? AND count = 0',
                        { identifier, itemKey },
                        function(deleteResult)
                            if deleteResult and deleteResult.affectedRows > 0 then
                                print("Item has been completely removed from the player's inventory.")
                            end
                        end
                    )

                    -- Perform additional actions as needed
                else
                    print("Item not found in the player's inventory or count is insufficient.")
					TriggerClientEvent('chat:addMessage', _source, { args = { 'Success:', string.format('Item %s has been removed item.', item) } })
                end
            end
        )
    else
        TriggerClientEvent('chat:addMessage', _source, { args = { '^1Error:', string.format('Item %s is not a valid item.', item) } })
    end
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

-- Command to give an item to a player
RegisterCommand('giveitem', function(source, args)
    if #args < 3 then
        print("Invalid usage. Correct syntax: /giveitem [playerId] [item] [count]")
        return
    end

    local playerId = tonumber(args[1])
    local item = args[2]
    local count = tonumber(args[3])

    if not playerId or not item or not count then
        print("Invalid arguments. Correct syntax: /giveitem [playerId] [item] [count]")
        return
    end

    local selectedItem = nil
    for _, configItem in ipairs(Config.item_list) do
        if configItem.item == item or configItem.name == item then
            selectedItem = configItem
            break
        end
    end

    if selectedItem then
        local itemKey = selectedItem.item

        -- Check if the player already has the item in their inventory
        exports.oxmysql:execute('SELECT count FROM player_inventory WHERE identifier = ? AND item = ?',
            { GetPlayerIdentifier(playerId, 0), itemKey },
            function(rows)
                if rows and #rows > 0 then
                    local currentCount = rows[1].count or 0
                    local newCount = currentCount + count

                    -- Add the item to the player's inventory in the database
                    exports.oxmysql:execute('INSERT INTO player_inventory (identifier, item, count) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE count = ?',
                        { GetPlayerIdentifier(playerId, 0), itemKey, newCount, newCount },
                        function(rowsAffected)
                            if rowsAffected and rowsAffected.affectedRows > 0 then
                                print(string.format("%s x%s has been added to player %s's inventory.", item, count, playerId))
                            else
                                print("Failed to add item to player's inventory.")
                            end
                        end
                    )
                else
                    print("Failed to retrieve player inventory.")
                end
            end
        )
    else
        print("Invalid item.")
    end
end)


RegisterCommand('useitem', function(source, args, rawCommand)
    -- Check if the correct number of arguments has been passed
    if #args ~= 1 then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1Error:', 'Usage: /useitem [item]' } })
        return
    end

    local item = string.lower(args[1]) -- Convert the item name to lowercase

    -- Get the player's identifier
    local identifier = GetPlayerIdentifier(source, 0)

    -- Load the player's inventory
    LoadPlayerInventory(identifier, function(inventory)
        -- Check if the player has the specified item in their inventory
        if inventory and inventory[item] and inventory[item] > 0 then
            -- Trigger the 'useItem' event and pass the necessary data
            TriggerEvent('useItem', source, item)

            -- Notify the player about using the item
            TriggerClientEvent('chat:addMessage', source, { args = { '^2Success:', 'You used ' .. item .. ' (1)' } })

            -- Remove the used item from the player's inventory
            RemoveInventoryItem(identifier, item, 1)
        else
            -- Notify the player if they don't have the specified item in their inventory
            TriggerClientEvent('chat:addMessage', source, { args = { '^1Error:', 'You do not have ' .. item .. ' in your inventory' } })
        end
    end)
end, false)


RegisterServerEvent('inventory:useItem')
AddEventHandler('inventory:useItem', function(item)
    -- Handle item usage logic
    TriggerEvent("useItem")
    -- Update inventory and perform other actions as needed
end)

