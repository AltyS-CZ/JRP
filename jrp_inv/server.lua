function RemoveCash(amount)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)
  
    -- Retrieve current cash value from the database
    exports.oxmysql:execute('SELECT cash FROM users WHERE identifier = ?', {identifier}, function(result)
        if result[1] then
            local currentCash = result[1].cash

            -- Check if the player has enough cash
            if currentCash >= amount then
                -- Perform the cash deduction
                local newCash = currentCash - amount

                -- Update the cash value in the database
                exports.oxmysql:execute('UPDATE users SET cash = ? WHERE identifier = ?', {newCash, identifier})

                -- Trigger a client event to notify the player
                TriggerClientEvent('chat:addMessage', src, {
                    color = {255, 0, 0},
                    args = {'Server', 'You lost $' .. amount .. ' from your cash.'}
                })
            else
                TriggerClientEvent('chat:addMessage', src, {
                    color = {255, 0, 0},
                    args = {'Server', 'Insufficient funds!'}
                })
            end
        end
    end)
end


RegisterServerEvent('custom_economy:removeCash')
AddEventHandler('custom_economy:removeCash', function(amount)
    RemoveCash(amount)
end)

----------------


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
RegisterServerEvent('playerConnecting')
AddEventHandler('playerConnecting', function()
    local identifier = GetPlayerIdentifiers(source)[1]

    -- Load player's inventory from the database here
    LoadPlayerInventory(identifier)
end)

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

function LoadPlayerInventory(identifier, callback)
    exports.oxmysql:fetch('SELECT * FROM player_inventory WHERE identifier = ?', {identifier}, function(result)
        if result then
            local inventory = {}
            for i = 1, #result do
                inventory[result[i].item] = result[i].count
            end
            callback(inventory)
        else
            callback({})
        end
    end)
end



-- ... other code ...
--[[
RegisterCommand('inv', function(source, args, rawCommand)
    -- Display the player's inventory when the /inv command is used
    DisplayPlayerInventory(source)
end, false) -- false means this command can be used by any player, not just admins

RegisterCommand('inv', function(source, args, rawCommand)
    local player = source
    local identifier = GetPlayerIdentifier(source)
    local inventory = LoadPlayerInventory(identifier)
	TriggerClientEvent('displayInventory', player, inventory)

end, false)
--]]

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
RegisterCommand('inv', function(source, args, rawCommand)
    local identifier = GetPlayerIdentifier(source, 0)
    
    -- Load the player's inventory
    LoadPlayerInventory(identifier, function(inventory)
        -- Trigger the client-side event to open the menu and pass the inventory data
        TriggerClientEvent('inventory:openMenu', source, inventory)
    end)
end, false)


