local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterServerCallback('irp-medic:checkAmbulance', function(source, callback)
    local players = ESX.GetPlayers()
    local numberofMedics = 0
    for i = 1, #players, 1 do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        if xPlayer.job.name == Config.JobName then -- EMS job name in database
            numberofMedics = numberofMedics + 1
    end
end
    if numberofMedics < Config.MaxNumberMedics then 
        callback(true)
    else
        callback(false)
    end
 end)