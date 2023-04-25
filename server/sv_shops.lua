-- WARNING
-- DO NOT TOUCH
-- SHOPS ARE NOT YET READY


-- Define shop marker size and color
local markerSize = {x = 1.5, y = 1.5, z = 0.5}
local markerColor = {r = 0, g = 128, b = 255, a = 100}

function CreateMarker(x, y, z, r, g, b, a, type)
    local marker = {
        x = x,
        y = y,
        z = z,
        r = r,
        g = g,
        b = b,
        a = a,
        type = type
    }
    return marker
end
  
local blip = AddBlipForCoord(coords)

SetBlipSprite(blip, Config.BlipSprite)
SetBlipDisplay(blip, 4)
SetBlipScale(blip, Config.BlipScale)
SetBlipColour(blip, Config.BlipColor)
SetBlipAsShortRange(blip, true)
  
BeginTextCommandSetBlipName("STRING")
AddTextComponentString(Config.ShopName)
EndTextCommandSetBlipName(blip)
  

-- Create markers for each shop location
for _, shop in pairs(Config.Shops) do
    local marker = CreateMarker(27, shop.x, shop.y, shop.z - 0.95, markerSize.x, markerSize.y, markerSize.z, markerColor.r, markerColor.g, markerColor.b, markerColor.a, false, true, 2, false, nil, nil, false)
    local blip = AddBlipForCoord(shop.x, shop.y, shop.z)
    SetBlipSprite(blip, 110)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)

    -- Add event handler for player interactions with the markers
    AddEventHandler("custom_economy:shopInteract", function(markerId)
        if marker == markerId then
            TriggerClientEvent("custom_economy:showShop", source, shop.items)
        end
    end)
end

-- Handle player purchases from the shop
RegisterServerEvent("custom_economy:purchaseItem")
AddEventHandler("custom_economy:purchaseItem", function(itemName, itemPrice)
    local source = source
    exports.oxmysql:execute('SELECT money FROM users WHERE identifier = ?', {GetPlayerIdentifier(source)}, function(result)
        if result and result[1] and result[1].money >= itemPrice then
            local newMoney = result[1].money - itemPrice
            exports.oxmysql:execute('UPDATE users SET money = ? WHERE identifier = ?', {newMoney, GetPlayerIdentifier(source)}, function(rowsChanged)
                if rowsChanged > 0 then
                    TriggerClientEvent("custom_economy:updateMoneyDisplay", source, newMoney)
                    TriggerClientEvent("chat:addMessage", source, {color = {255, 255, 0}, args = {"Shop", "You purchased a " .. itemName .. " for $" .. itemPrice .. "."}})
                else
                    TriggerClientEvent("chat:addMessage", source, {color = {255, 0, 0}, args = {"Shop", "Failed to purchase item."}})
                end
            end)
        else
            TriggerClientEvent("chat:addMessage", source, {color = {255, 0, 0}, args = {"Shop", "You do not have enough money to purchase this item."}})
        end
    end)
end)
