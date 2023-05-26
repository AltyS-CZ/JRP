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
            -- Create a submenu for 'Use' and 'Cancel' options
            local submenu = MenuV:CreateMenu('Item Actions', '', 'bottomright')
            local useButton = submenu:AddButton({ label = 'Use' })
            local cancelButton = submenu:AddButton({ label = 'Cancel' })
            -- Register an event for the 'Use' button selection (click)
            useButton:On('select', function()
                -- Trigger the useItem event
                TriggerServerEvent('useItem', selectedItem)
			    TriggerServerEvent('checkItemCategory', selectedItem)
                -- Close the submenu
                submenu:Close()
            end)
            -- Register an event for the 'Cancel' button selection (click)
            cancelButton:On('select', function()
                -- Close the submenu
                submenu:Close()
            end)
            -- Open the submenu when the item button is selected
            submenu:Open()
        end)
    end
    -- Display the inventory menu
    inventoryMenu:Open()
end)
