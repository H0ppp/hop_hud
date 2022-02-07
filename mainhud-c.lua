local waterLevel = 0
local foodLevel = 0


-- Hide minimap when out of car, and replace health/armor bars
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = GetPlayerPed(-1)
        local health = GetEntityHealth(ped)


        if (IsPedInAnyVehicle(GetPlayerPed(-1),true)) then 
            DisplayRadar(true)
            TriggerEvent("enteredCar", true)
            local fuelLevel = exports["hop_fuel"]:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1),true))
            local nosLevel = exports["hop_nitro"]:GetNitroFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1),true))

            SendNUIMessage({
                heal = health,
                water = waterLevel,
                food = foodLevel,
                fuel = fuelLevel,
                nos = nosLevel,
                show = IsPauseMenuActive()
            });
        else
            DisplayRadar(false)
            TriggerEvent("exitCar", true)
            SendNUIMessage({
                heal = health,
                water = waterLevel,
                food = foodLevel,
                show = IsPauseMenuActive()
            });
        end
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


AddEventHandler("hop_hud:updateBasics", function(basics)
    waterLevel, foodLevel = basics[1].percent, basics[2].percent
end)