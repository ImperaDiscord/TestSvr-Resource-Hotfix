local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)
Citizen.CreateThread(function()
    -- Main Thread
    SpawnNpc() -- Call of Spawn NPC
    while true do
    Citizen.Wait(1) -- While loop to determine distance, runs every frame (This can have a negative impact on performance)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Coords.x, Config.Coords.y, Config.Coords.z, true)
    if distance < 1.5 then -- Distance Check
        DrawText3Ds(Config.Coords.x, Config.Coords.y, Config.Coords.z, "Press ~g~[E]~s~ for Medic") -- 3D Text, you can alter the control if desired, make sure to adjust it on the next line as well
            if IsControlJustReleased(0, 38) then -- Checking for key press, visit https://docs.fivem.net/docs/game-references/controls/ for more info
                ESX.TriggerServerCallback('irp-medic:checkAmbulance', function(isAvailable) -- Callback to ensure there are less then a specificed amount of medics online, check server for more info
                    if isAvailable then
                        exports['progressBars']:startUI((10000), "RECOVERING") -- Replace this with any progress bar
                        Citizen.Wait(10000)
                        ESX.ShowNotification('Welcome to the land of the living')
                        TriggerEvent('vanq_ambulancejob:revive')
                    else
                        ESX.ShowNotification("There are medics online")
                    end
    end)
end
end
end
end)

function SpawnNpc() -- Simple function to spawn NPC at config.coords, thank you to t1ger for helping me figure this out.
    RequestModel(GetHashKey("s_m_y_autopsy_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_autopsy_01")) do
		Citizen.Wait(50)
    end
    local medicped = CreatePed(7, GetHashKey("s_m_y_autopsy_01"), Config.Coords.x, Config.Coords.y, Config.Coords.z, 250.23, true, true)
    FreezeEntityPosition(medicped,true)
	SetEntityInvincible(medicped,true)

end
 -- Misc Draw 3D text, not my function
 function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end
