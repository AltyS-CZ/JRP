-- Function to update the money display
function updateMoneyDisplay(cash, bank, dirtymoney)
    SendNUIMessage({
        type = "updateMoney",
        cash = comma_value(cash),
        bank = comma_value(bank),
        dirtymoney = comma_value(dirtymoney)
    })
end

-- Event to update the money display
RegisterNetEvent("custom_economy:updateMoneyDisplay")
AddEventHandler("custom_economy:updateMoneyDisplay", function(cash, bank, dirtymoney)
    updateMoneyDisplay(cash, bank, dirtymoney)
end)


function UpdateMoney()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(60000) -- wait for 1 minute
            
            -- Get the player's money and send it to the client
            local player = GetPlayerFromServerId(source)
            if player ~= -1 then
                local money = GetPlayerMoney(player)
                local bank = GetPlayerBank(player)
                local dirtyMoney = GetPlayerDirtyMoney(player)
                TriggerClientEvent("custom_economy:updateMoneyDisplay", player, money, bank, dirtyMoney)
            end
        end
    end)
end


local PlayerData = {}

function GetPlayerData()
    return PlayerData
end

function SetPlayerData(key, val)
    PlayerData[key] = val
end

function GetPlayerJob()
    return PlayerData.job
end

function SetPlayerJob(job)
    PlayerData.job = job
end


-- Event handler to update the job display for the local player
RegisterNetEvent("custom_economy:updateJobDisplay")
AddEventHandler("custom_economy:updateJobDisplay", function(job)
    PlayerData.job = job
end)



------------------
