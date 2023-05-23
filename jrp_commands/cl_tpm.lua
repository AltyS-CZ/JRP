
RegisterNetEvent('tpm:teleportToWaypoint')
AddEventHandler('tpm:teleportToWaypoint', function()
    local ped = GetPlayerPed(-1)

    if IsPedInAnyVehicle(ped, false) then
        ped = GetVehiclePedIsUsing(ped)
    end

    local blip = GetFirstBlipInfoId(8) -- 8 is the id for waypoint in GTA V

    if DoesBlipExist(blip) then -- check if the waypoint exists
        local coord = GetBlipInfoIdCoord(blip)
        for height = 1, 1000 do
            SetEntityCoordsNoOffset(ped, coord.x, coord.y, height, 0, 0, 0)

            if GetGroundZFor_3dCoord(coord.x, coord.y, height) then -- ensure the destination has a ground
                SetEntityCoordsNoOffset(ped, coord.x, coord.y, height, 0, 0, 0)
                break
            end

            Citizen.Wait(5)
        end
    else
        TriggerEvent('chat:addMessage', {
            args = { 'SYSTEM', 'No waypoint set.' }
        })
    end
end)


