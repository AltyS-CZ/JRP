local PlayerData = {}

function GetPlayerData()
    return PlayerData
end

function SetPlayerData(key, val)
    PlayerData[key] = val
end

------------------

RegisterNetEvent('jrp:giveweapon')
AddEventHandler('jrp:giveweapon', function(weapon)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weapon), 1000, false, true)
end)

