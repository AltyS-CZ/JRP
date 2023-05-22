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
function LoadPlayerInventory(identifier, callback)
    exports.oxmysql:fetch('SELECT * FROM player_inventory WHERE identifier = ?', {identifier}, function(result)
        if result and #result > 0 then
            local inventory = {}
            for _, row in ipairs(result) do
                inventory[row.item] = row.count
            end
            callback(inventory)
        else
            callback({})
        end
    end)
end
RegisterServerEvent('useItem')
AddEventHandler('useItem', function(item)
    local _source = source
    local identifier = GetPlayerIdentifier(_source)

    print("Selected item:", item)

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

        print("Item Name:", itemName)

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
                end
            end
        )
    else
        print("Invalid item:", item)
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

