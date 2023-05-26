-- Event for drinking water
RegisterNetEvent('drinkWater')
AddEventHandler('drinkWater', function()
    lib.progressBar({
        duration = 2000,
        label = 'Drinking water',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'mp_player_intdrink',
            clip = 'loop_bottle'
        },
        prop = {
            model = `prop_ld_flow_bottle`,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.0, 0.0, -1.5)
        },
        onComplete = function(cancelled)
            if cancelled then
                print('Do stuff when cancelled')
            else
                print('Do stuff when complete')
            end
        end
    })
end)
