RegisterServerEvent("jrp:updateMoney")
AddEventHandler("jrp:updateMoney", function()
    getPlayerMoney(source)
end)



-- Event to handle giving money to a player
RegisterServerEvent("jrp:giveMoney")
AddEventHandler("jrp:giveMoney", function(amount, account)
    local source = tonumber(source)
    local identifier = GetPlayerIdentifier(source, 0)
    local moneyData = getPlayerMoney(identifier)

    if account == "cash" then
        moneyData.cash = moneyData.cash + amount
    elseif account == "bank" then
        moneyData.bank = moneyData.bank + amount
    elseif account == "dirty" then
        moneyData.dirtyMoney = moneyData.dirtyMoney + amount
    end

    updatePlayerMoney(identifier, moneyData)
    updateMoneyDisplay(source)
end)


-- Event to handle the remove cash command
RegisterNetEvent('jrp:removeCash')
AddEventHandler('jrp:removeCash', function(amount)
    local player = source

    -- Remove cash from the player
    local success = RemovePlayerCash(source, amount)
    if success then
		return true
	else
		return false
	end
end)
