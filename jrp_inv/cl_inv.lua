
-- Event handler to open the inventory menu
RegisterNetEvent('inventory:openMenu')
AddEventHandler('inventory:openMenu', function(inventory)
    local inventoryMenu = MenuV:CreateMenu('Inventory', 'Welcome to the Inventory', 'bottomright')

    -- Iterate over the inventory items and add them as buttons
    for item, count in pairs(inventory) do
        local itemLabel = item .. " (" .. count .. ")"
        local itemButton = inventoryMenu:AddButton({ label = itemLabel, description = 'Item description' })

        -- Register an event for the item button selection (click)
        itemButton:On('select', function(button)
            -- Handle item button click
            local selectedItem = item

            -- Trigger the server event to use the selected item
            TriggerServerEvent('useItem', selectedItem)
        end)
    end

    -- Display the inventory menu
    inventoryMenu:Open()
end)


