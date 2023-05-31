
RegisterCommand('checkhealth', function(source, args)
    local players = GetPlayers()

    for _, player in ipairs(players) do
        local ped = GetPlayerPed(player)
        local health = GetEntityHealth(ped)
        local notificationType, notificationText = GetNotificationData(health)
        TriggerClientEvent('healthNotification', player, notificationType, notificationText)
    end
end, false)

function GetNotificationData(health)
    if health >= 200 then
        return 'info', 'No injuries detected.'
    elseif health >= 125 and health < 170 then
        return 'info', "You're pretty banged up, but you'll live."
    elseif health >= 75 and health < 125 then
        return 'error', 'Something feels broken, you should probably go to the hospital.'
    elseif health < 75 then
        return 'error', "You're on the verge of death. Get to a hospital asap."
    end
end
