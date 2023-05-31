-- Config
local startingCash = 5000
local startingBank = 5000
local startingJob = 'Unemployed'

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


-------------- JOB STUFF DO NOT TOUCH -----------------
-- Set default job
local defaultJob = 'Unemployed'

-- Command
RegisterCommand('setjob', function(source, args, rawCommand)
    -- Check arguments
    if #args ~= 2 then
        TriggerClientEvent('chat:addMessage', source, { args = {"^1[Error]", "Invalid number of arguments. Usage: /setjob [id] [job]"} })
        return
    end

    -- Variables
    local targetId = args[1] -- Removed tonumber
    local jobName = tostring(args[2])

    if targetId and jobName then
        -- Verify job exists
        exports.oxmysql:execute('SELECT * FROM job_list WHERE job = ?', {jobName}, function(result)
            if result and next(result) ~= nil then
                -- Update job
                exports.oxmysql:execute('UPDATE users SET job = ? WHERE identifier = ?', {jobName, GetPlayerIdentifier(targetId, 0)}, function(affectedRows)
                    if affectedRows and next(affectedRows) ~= nil then
                        TriggerClientEvent('chat:addMessage', source, { args = {"^2[Success]", "Job updated successfully."} })
                    else
                        TriggerClientEvent('chat:addMessage', source, { args = {"^1[Error]", "Failed to update job."} })
                    end
                end)
            else
                TriggerClientEvent('chat:addMessage', source, { args = {"^1[Error]", "Job does not exist."} })
            end
        end)
    else
        TriggerClientEvent('chat:addMessage', source, { args = {"^1[Error]", "Invalid arguments. Usage: /setjob [id] [job]"} })
    end
end, false)
