RegisterCommand('car', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "admin") then
        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
        local veh = args[1]
        if veh == nil then veh = "adder" end
            vehiclehash = GetHashKey(veh)
            RequestModel(vehiclehash)
                Citizen.CreateThread(function() 
                local waiting = 0
                while not HasModelLoaded(vehiclehash) do
                    waiting = waiting + 100
                    Citizen.Wait(100)
                    if waiting > 5000 then
                        ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                        break
                    end
                end 
                CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 0)
            end)
        end
    else
        -- send an error message to players who do not have the 'admin' permission
        TriggerClientEvent("chat:addMessage", source, {
            color = {255, 0, 0},
            args = {"SYSTEM", "You do not have permission to use this command!"}
        })
    end
end, true)
