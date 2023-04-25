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
