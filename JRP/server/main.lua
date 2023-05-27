-- Config
local startingCash = 5000
local startingBank = 5000
local startingJob = 'unemployed'

-- Event
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local player = source
    local identifier = GetPlayerIdentifiers(player)[1]

    exports.oxmysql:fetch('SELECT * FROM users WHERE identifier = ?', { identifier }, function(result)
        if result[1] == nil then
            exports.oxmysql:execute('INSERT INTO users (identifier, cash, bank, dirty_money, job) VALUES (?, ?, ?, ?, ?)', {
                identifier, startingCash, startingBank, 0, startingJob
            })
        end
    end)
end)
