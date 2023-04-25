local shopMenu = nil
local shopItems = {}

function OpenShopMenu(items)
    shopItems = items
    local elements = {}
    for _, item in pairs(shopItems) do
        table.insert(elements, {label = item.label .. " ($" .. comma_value(item.price) .. ")", value = item})
    end
    shopMenu = exports["nh-context"]:openContext({
        {
            header = "Shop",
            rows = elements
        }
    })
end

function CloseShopMenu()
    exports["nh-context"]:closeContext(shopMenu)
end

RegisterNetEvent("custom_economy:showShopMenu")
AddEventHandler("custom_economy:showShopMenu", function(items)
    OpenShopMenu(items)
end)

RegisterNetEvent("custom_economy:closeShopMenu")
AddEventHandler("custom_economy:closeShopMenu", function()
    CloseShopMenu()
end)

RegisterNetEvent("custom_economy:buySuccessful")
AddEventHandler("custom_economy:buySuccessful", function(item)
    TriggerEvent("chat:addMessage", {args = {"[Shop]", "You purchased " .. item.label .. " for $" .. comma_value(item.price) .. "."}})
end)

RegisterNetEvent("custom_economy:buyFailed")
AddEventHandler("custom_economy:buyFailed", function(errorMsg)
    TriggerEvent("chat:addMessage", {args = {"[Shop]", errorMsg}})
end)
