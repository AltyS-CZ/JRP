-- spawns a local (not networked) car and warps the user into it.
function spawnCar(modelName)
    Citizen.CreateThread(function() -- create a new thread, to run parallel. 
        -- variables with local are only existend inside this function. 
        local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName)) -- check if the given name is a hash, otherwise get the HasKey with the native.

        if not HasModelLoaded(model) then -- load the model. If we do not do this the car could be invisible. Most likely for custom cars.
            RequestModel(model)
    
            while not HasModelLoaded(model) do
                Citizen.Wait(1)
            end
        end
        -- by now the model is loaded and ready, spawn the vehicle. 
        -- Where do we spawn it? 
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed) -- fetch our current position and use it

        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(playerPed), 
            false,  -- BOOL isNetwork: Whether to create a network object for the vehicle. If false, the vehicle exists only locally.
            false   -- BOOL netMissionEntity: Whether to register the vehicle as pinned to the script host in the R* network model.
        )

        TaskWarpPedIntoVehicle(playerPed,  vehicle, 
            -1 -- int seatIndex. -1 = driver seat.
        )
    end)
end

RegisterNetEvent("spawnVehicle")
AddEventHandler("spawnVehicle", function(coords, model)
  RequestModel(model)
  while not HasModelLoaded(model) do
    Citizen.Wait(0)
  end
  local vehicle = CreateVehicle(model, coords, GetEntityHeading(GetPlayerPed(PlayerId())), true, false)
  SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
  SetModelAsNoLongerNeeded(model)
end)


RegisterNetEvent("admin:on_car")
AddEventHandler("admin:on_car", function(args)
    if args[1] then
        spawnCar(args[1])
    end
end)
