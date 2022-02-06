
-- Hide minimap when out of car, and replace health/armor bars
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (IsPedInAnyVehicle(GetPlayerPed(-1),true)) then 
            DisplayRadar(true)
            TriggerEvent("enteredCar", true)
        else
            DisplayRadar(false)
            TriggerEvent("exitCar", true)
        end

        local ped = GetPlayerPed(-1)
        local health = GetEntityHealth(ped)
        local armor = GetPedArmour(ped)
        SendNUIMessage({
            heal = health,
            armor = armor
        });
    end
end)


-- Hide original UI
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        HideHudComponentThisFrame(6) --Vehicle Name
        HideHudComponentThisFrame(7) --Area
        HideHudComponentThisFrame(8) --Vehicle Class
        HideHudComponentThisFrame(9) --Street Name
    end
end)

AddEventHandler("playerSpawned", function()
	local ped = GetPlayerPed(-1)
	if GetPedMaxHealth(ped) ~= 200 and not IsEntityDead(ped) then
		SetPedMaxHealth(ped, 200)
		SetEntityHealth(ped, GetEntityHealth(ped) + 25)
	end
end)


--Remove Health/Armour from minimap
Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

RegisterNetEvent('enteredCar')
AddEventHandler('enteredCar', function()
  SendNUIMessage({
    type = "ui",
    display = true
  })
end)

RegisterNetEvent('exitCar')
AddEventHandler('exitCar', function()
  SendNUIMessage({
    type = "ui",
    display = false
  })
end)