-- client.lua

RegisterNetEvent('healthNotification')
AddEventHandler('healthNotification', function(notificationType, notificationText)
    exports.ox_lib:notify({
        title = 'Health Update',
        description = notificationText,
        type = notificationType,
        icon = 'user-injured',
        position = 'center-right',
        duration = 3000
    })
end)
