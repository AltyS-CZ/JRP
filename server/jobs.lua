-- Configuration

local jobs = {
    ["citizen"] = {
      label = "Citizen",
      salary = 100,
    },
    ["police"] = {
      label = "Police",
      salary = 500,
    },
    ["mechanic"] = {
      label = "Mechanic",
      salary = 250,
    },
    -- Add more jobs here...
  }
  


local lastSalaryPayment = os.time()
local salaryIntervalSeconds = 600 -- change this value to set the interval between salary payments in seconds


-- Function to pay out salaries to all players with a job
function PaySalaries()
    local query = "UPDATE users SET bank = bank + salary WHERE job = ?"

    for jobName, jobData in pairs(jobs) do
        if jobData.salary ~= nil then
            local updateParams = {jobName}
            exports.oxmysql:execute(query, updateParams, function(rowsAffected)
                print("Paid salaries of $" .. jobData.salary .. " to " .. tostring(rowsAffected) .. " players with job " .. jobName)
            end)
        else
            print("No salary found for job " .. jobName)
        end
    end
end



function SetJob(playerId, job)
    -- Get the player's identifier
    local identifier = GetPlayerIdentifier(playerId, 0)

    -- Find the job in the jobs table
    local jobData = nil
    for _, v in pairs(jobs) do
        if v.name == job then
            jobData = v
            break
        end
    end

    -- Check if the job exists
    if not jobData then
        TriggerClientEvent('chat:addMessage', playerId, {
            color = {255, 0, 0},
            args = {"Server", "Invalid job name: " .. job}
        })
        return
    end

    -- Check if the player has permission to set jobs
    if not IsPlayerAceAllowed(playerId, "custom_economy.setjob") then
        TriggerClientEvent('chat:addMessage', playerId, {
            color = {255, 0, 0},
            args = {"Server", "You do not have permission to use /setjob"}
        })
        return
    end
  
    -- Update the job and salary in the database for the specified player
    local salary = jobData.salary
    exports.oxmysql:execute('UPDATE users SET job = ?, salary = ? WHERE identifier = ?', {job, salary, identifier}, function(rowsAffected)
        if rowsAffected > 0 then
            TriggerClientEvent('chat:addMessage', playerId, {
                color = {0, 255, 0},
                args = {"Server", "Set job to " .. job}
            })
            -- Force the player's job to refresh immediately
            TriggerClientEvent('custom_economy:setJob', playerId, job)
        end
    end)
end

  

-- Register the chat command to set a player's job (admin only)
RegisterCommand("setjob", function(source, args, rawCommand)
    if not IsPlayerAceAllowed(source, "admin") then
        TriggerClientEvent("chat:addMessage", source, { args = { "Error", "You do not have permission to use this command" }, color = { 255, 0, 0 } })
        return
    end
  
    local playerId = tonumber(args[1])
    local job = args[2]
  
    if not playerId or not job or not jobs[job] then
        TriggerClientEvent("chat:addMessage", source, { args = { "Usage", "Usage: /setjob [id] [job]" }, color = { 255, 0, 0 } })
        return
    end
  
    SetJob(playerId, job)
    TriggerClientEvent("chat:addMessage", source, { args = { "Job", "Set job for player " .. playerId .. " to " .. job }, color = { 0, 255, 0 } })
    TriggerClientEvent("chat:addMessage", playerId, { args = { "Job", "Your job has been set to " .. job } })
end)

Citizen.CreateThread(function()
    while true do
        Wait(salaryIntervalSeconds * 1000)
        PaySalaries()
    end
end)
  


-- Functions
 

function GiveSalary()
    for _, player in ipairs(GetPlayers()) do
        local identifier = GetPlayerIdentifier(player, 0)
        local job = nil
        local salary = nil

        local query = "SELECT job FROM users WHERE identifier = ?"
        local params = {identifier}

        exports.oxmysql:scalar(query, params, function(jobName)
            job = jobName

            if jobs[job] ~= nil then
                salary = jobs[job].salary
            end

            if salary ~= nil then
                local updateQuery = "UPDATE users SET bank = bank + ? WHERE identifier = ?"
                local updateParams = {salary, identifier}

                exports.oxmysql:execute(updateQuery, updateParams, function(rowsAffected)
                    if rowsAffected == 1 then
                        print("Gave salary of $" .. salary .. " to player with identifier " .. identifier)
                    else
                        print("Failed to give salary to player with identifier " .. identifier)
                    end
                end)
            else
                print("No salary found for job " .. job .. " of player with identifier " .. identifier)
            end
        end)
    end
end


 
function GetJob(player)
    local identifier = GetPlayerIdentifier(player)
    local result = exports.oxmysql:execute("SELECT job FROM users WHERE identifier = @identifier", {["@identifier"] = identifier})
    return result
end

  
-- Register the chat command to display a player's job
RegisterCommand("job", function(source, args, rawCommand)
    local playerId = tonumber(source)
    exports.oxmysql:execute("SELECT job FROM users WHERE identifier = ?", { GetPlayerIdentifier(playerId) }, function(result)
        if result and result[1] then
            local job = result[1].job
            TriggerClientEvent("chat:addMessage", playerId, { args = { "Job", "Your current job is " .. job } })
        else
            TriggerClientEvent("chat:addMessage", playerId, { args = { "Error", "Failed to get job" } })
        end
    end)
end)
  

  
