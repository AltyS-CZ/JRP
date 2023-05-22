-- Example function to initialize the inventory database
function InitializeInventoryDatabase()
    exports.oxmysql:execute('CREATE TABLE IF NOT EXISTS player_inventory (identifier VARCHAR(40) NOT NULL, item VARCHAR(50), count INT, PRIMARY KEY (identifier, item))')
end

-- Example function to add an item to a player's inventory
function AddInventoryItem(identifier, item, count)
    exports.oxmysql:execute('INSERT INTO player_inventory (identifier, item, count) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE count = count + ?',
        {identifier, item, count, count})
end

-- Example function to remove an item from a player's inventory
function RemoveInventoryItem(identifier, item, count)
    exports.oxmysql:execute('UPDATE player_inventory SET count = count - ? WHERE identifier = ? AND item = ?',
        {count, identifier, item})
end

-- Example function to display a player's inventory
function DisplayPlayerInventory(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    exports.oxmysql:fetch('SELECT * FROM player_inventory WHERE identifier = ?', {identifier}, function(result)
        if result then
            local message = 'Inventory: '
            for i = 1, #result do
                message = message .. '\n' .. result[i].item .. ': ' .. result[i].count
            end
            TriggerClientEvent('chat:addMessage', source, {args = {message}})
        else
            TriggerClientEvent('chat:addMessage', source, {args = {'You have no items.'}})
        end
    end)
end

-- Event handler for when a player is dropping
AddEventHandler('playerDropped', function(reason)
    local identifier = GetPlayerIdentifiers(source)[1]

    -- Save player's inventory to the database here
    SavePlayerInventory(identifier)
end)

-- Event handler for when a player is connecting
--[[RegisterServerEvent('playerConnecting')
AddEventHandler('playerConnecting', function()
    local identifier = GetPlayerIdentifiers(source)[1]

    -- Load player's inventory from the database here
    LoadPlayerInventory(identifier)
end)]]

-- Assuming you have a table storing player's inventory in memory
local player_inventories = {}

function SavePlayerInventory(identifier)
    local inventory = player_inventories[identifier]
    if inventory then
        for item, count in pairs(inventory) do
            -- Use AddInventoryItem function to add/update items in the database
            AddInventoryItem(identifier, item, count)
        end
    end
end







RegisterNetEvent('AddInvItem')
AddEventHandler('AddInvItem', function(identifier, item, count)
	local identifier = GetPlayerIdentifiers(source)[1]
    AddInventoryItem(identifier, item, count)
end)

RegisterNetEvent('RemoveInvItem')
AddEventHandler('RemoveInvItem', function(identifier, item, count)
	local identifier = GetPlayerIdentifiers(source)[1]
    RemoveInventoryItem(identifier, item, count)
end)


-- Function to send the inventory menu to the client
function SendInventoryMenu(playerId, inventory)
    TriggerClientEvent('inventory:openMenu', playerId, inventory)
end

-- Command to open the inventory menu
RegisterCommand('inv', function(source, args)
    local playerId = source
    local playerIdentifier = GetPlayerIdentifier(playerId)

    -- Fetch the player's inventory from the database
    exports.oxmysql:fetch('SELECT * FROM player_inventory WHERE identifier = ?', { playerIdentifier }, function(result)
        if result then
            local inventory = {}
            for _, row in ipairs(result) do
                inventory[row.item] = row.count
            end

            -- Trigger the client event to open the inventory menu and display the items
            TriggerClientEvent('inventory:openMenu', playerId, inventory)
        else
            TriggerClientEvent('chat:addMessage', playerId, { args = { 'Error', 'Failed to retrieve inventory.' } })
        end
    end)
end)


function GivePlayerItem(playerId, item, count)
    local identifier = GetPlayerIdentifier(playerId)

    -- Check if the item already exists in the player's inventory
    exports.oxmysql:scalar('SELECT COUNT(*) FROM player_inventory WHERE identifier = ? AND item = ?',
        { identifier, item },
        function(existingCount)
            if existingCount > 0 then
                -- Item already exists, update the count
                exports.oxmysql:execute('UPDATE player_inventory SET count = count + ? WHERE identifier = ? AND item = ?',
                    { count, identifier, item },
                    function(affectedRows)
                        if affectedRows and affectedRows.affectedRows > 0 then -- Access affectedRows inside the table
                            --print("Item count has been updated in the player's inventory.")
                        else
                            --print("Failed to update item count in the player's inventory.")
                        end
                    end
                )
            else
                -- Item doesn't exist, insert a new row
                exports.oxmysql:execute('INSERT INTO player_inventory (identifier, item, count) VALUES (?, ?, ?)',
                    { identifier, item, count },
                    function(affectedRows)
                        if affectedRows and affectedRows.affectedRows > 0 then -- Access affectedRows inside the table
                            --print("Item has been added to the player's inventory.")
                        else
                            --print("Failed to add item to the player's inventory.")
                        end
                    end
                )
            end
        end
    )
end





RegisterCommand('giveitem', function(source, args)
    local playerId = source
    local identifier = nil

    -- Get the player's identifier from their server ID
    for _, player in ipairs(GetPlayers()) do
        if tonumber(player) == playerId then
            identifier = GetPlayerIdentifier(player)
            break
        end
    end

    -- Check if the player's identifier is valid
    if identifier then
        local item = args[2]
        local count = tonumber(args[3])

        -- Check if the item and count are provided
        if item and count then
            -- Call the GivePlayerItem function with the player's identifier
            GivePlayerItem(playerId, item, count)
        else
            --print("Invalid command usage. Correct usage: /giveitem <item> <count>")
			TriggerClientEvent('chat:addMessage', source, {args = {"^1Error: Wrong usage! Correct usage: /giveitem [id] [item name] [amonut]"}})
        end
    else
        --print("Failed to retrieve player identifier.")
	    TriggerClientEvent('chat:addMessage', source, {args = {"^1Error: ^7Couldn't get player's inventory"}})


    end
end)




