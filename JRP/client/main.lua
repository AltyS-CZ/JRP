-- Configuration
local respawnCoords = vector3(123.45, 67.89, 0.0) -- Adjust the coordinates as needed
local showText = false
local deathPosition = nil

-- Display text on screen
function DrawRespawnText()
    SetTextFont(0)
    SetTextScale(0.4, 0.4)
    SetTextColour(255, 255, 255, 255) -- White color
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString("~r~Press ~w~[E]~r~ to respawn or ~w~[R]~r~ to revive.\nRemember to remain in character.")
    DrawText(0.5, 0.85) -- Adjust the y-axis position (0.85) to move the text higher on the screen
end

-- Check player death
Citizen.CreateThread(function()
    -- Disable auto-spawn by modifying spawnmanager resource directly
    TriggerEvent('spawnmanager:spawnPlayer')
    TriggerEvent('spawnmanager:setAutoSpawn', false)
    Citizen.Wait(0)

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        if IsEntityDead(playerPed) and not showText then
            showText = true
            deathPosition = GetEntityCoords(playerPed)
            TriggerEvent("chat:addMessage", {
                color = { 255, 0, 0 },
                args = { "[DEATH]", "You died! Press [E] to respawn or [R] to revive." }
            })
        elseif not IsEntityDead(playerPed) then
            showText = false
            deathPosition = nil
        end

        if showText then
            DrawRespawnText()
            if IsControlJustReleased(0, 38) then -- E key
                showText = false
                DoScreenFadeOut(500)
                Citizen.Wait(500)
                if deathPosition then
                    SetEntityCoordsNoOffset(playerPed, deathPosition.x, deathPosition.y, deathPosition.z, false, false, false, true)
                else
                    SetEntityCoordsNoOffset(playerPed, respawnCoords.x, respawnCoords.y, respawnCoords.z, false, false, false, true)
                end
                NetworkResurrectLocalPlayer(respawnCoords.x, respawnCoords.y, respawnCoords.z, true, true, false)
                SetPlayerInvincible(playerPed, false)
                SetEntityHealth(playerPed, 200)
                Citizen.Wait(500)
                DoScreenFadeIn(500)
            elseif IsControlJustReleased(0, 45) then -- R key
                showText = false
                SetEntityHealth(playerPed, 200)
                NetworkResurrectLocalPlayer(GetEntityCoords(playerPed, true), true, true, false)
                SetPlayerInvincible(playerPed, false)
            end
        end
    end
end)
