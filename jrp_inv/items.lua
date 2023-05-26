-- main script
local Config = require('config')

function IsItemInCategory(item, category)
    for _, cat in ipairs(Config.item_list.categories) do
        for _, itemData in ipairs(cat.items) do
            if itemData.item == item then
                return cat.name == category
            end
        end
    end
    return false
end


RegisterNetEvent('checkItemCategory')
AddEventHandler('checkItemCategory', function(item)
    local category = nil

    for _, cat in ipairs(Config.item_list.categories) do
        for _, itemData in ipairs(cat.items) do
            if itemData.item == item then
                category = cat.name
                break
            end
        end
        if category then
            break
        end
    end

    if category and string.lower(category) == "drinks" then
        TriggerClientEvent("drinkWater", source)
        print("Drink")
    elseif category and string.lower(category) == "food" then
        print("Food")
    elseif category and string.lower(category) == "items" then
        print("Item")
    end
end)


-- To access the item_list, use Config.item_list
function UseItem(item)
    local selectedItem = nil
    for _, categoryData in ipairs(Config.item_list.categories) do
        for _, itemData in ipairs(categoryData.items) do
            if itemData.item == item or itemData.name == item then
                selectedItem = itemData
                break
            end
        end
        if selectedItem then
            break
        end
    end

    if selectedItem then
        TriggerServerEvent('useItem', selectedItem.item)
    else
        print("Selected item is not valid")
    end
end




RegisterNetEvent('useItem')
AddEventHandler('useItem', function(item)
    local _source = source
    local identifier = GetPlayerIdentifier(_source)

    local selectedItem = nil
    for _, category in ipairs(Config.item_list.categories) do
        for _, configItem in ipairs(category.items) do
            if configItem.item == item or configItem.name == item then
                selectedItem = configItem
                break
            end
        end
        if selectedItem then
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
                    -- Item has been removed from the player's inventory
                    TriggerClientEvent('chat:addMessage', _source, { args = { '^2Success:', 'Item ' .. itemName .. ' has been used.' } })

                    -- Check if the count is now 0 and remove the item from the table
                    exports.oxmysql:execute('DELETE FROM player_inventory WHERE identifier = ? AND item = ? AND count = 0',
                        { identifier, itemKey },
                        function(deleteResult)
                            if deleteResult and deleteResult.affectedRows > 0 then
                                -- Item has been completely removed from the player's inventory
                                TriggerClientEvent('chat:addMessage', _source, { args = { '^2Success:', 'Item ' .. itemName .. ' has been completely removed from your inventory.' } })
                            end
                        end
                    )

                    -- Trigger the checkItemCategory event
                    TriggerEvent('checkItemCategory', _source, item)
                end
            end
        )
    else
        -- Invalid item
        TriggerClientEvent('chat:addMessage', _source, { args = { '^1Error:', 'Invalid item: ' .. item } })
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

