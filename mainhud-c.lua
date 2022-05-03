local waterLevel = 0
local foodLevel = 0
local cashValue = 0
local bankValue = 0
ESX = nil
playerData = nil
isPaused = false

local cashDisplay = true

RegisterCommand("showcash", function()
    if(cashDisplay == true) then 
        cashDisplay = false
    else
        cashDisplay = true 
    end
    SendNUIMessage({
        type = "cashui",
        showCash = cashDisplay
      })
end, false)

Citizen.CreateThread(function() -- ESX Thread
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function() -- Main Thread
    Citizen.Wait(2000)
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local health = GetEntityHealth(ped)
        playerData = ESX.GetPlayerData()

        for k,v in ipairs(playerData.accounts) do
            if v.name == 'money' then
                cashValue = "$" .. ESX.Math.GroupDigits(v.money)
            end
            if v.name == 'bank' then
                bankValue = "$" .. ESX.Math.GroupDigits(v.money)
            end
        end

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
                bank = bankValue,
                cash = cashValue
            });
            
        else
            DisplayRadar(false)
            TriggerEvent("exitCar", true)
            SendNUIMessage({
                heal = health,
                water = waterLevel,
                food = foodLevel,
                bank = bankValue,
                cash = cashValue
            });
        end

        if (IsPauseMenuActive()) then 
            isPaused = true;
            TriggerEvent("pause", true)
        else
            isPaused = false;
            TriggerEvent("unPause", true)
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
    Citizen.Wait(1)
    SetMinimapComponentPosition("minimap", "L", "B", -0.006, -0.032, 0.150, 0.188888)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.020, 0.002, 0.111, 0.159)
    SetMinimapComponentPosition("minimap_blur", "L", "B", -0.03, -0.008, 0.266, 0.237)

    local minimap = RequestScaleformMovie("minimap")
    SetBigmapActive(true, false)
    Citizen.Wait(0)
    SetBigmapActive(false, false)

    while true do
        Citizen.Wait(0)
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

RegisterNetEvent('pause')
AddEventHandler('pause', function()
    SendNUIMessage({
        type = "pause",
        showHUD = isPaused
      })
end)

RegisterNetEvent('unPause')
AddEventHandler('unPause', function()
    SendNUIMessage({
        type = "pause",
        showHUD = isPaused
      })
end)


AddEventHandler("hop_hud:updateBasics", function(basics)
    foodLevel, waterLevel = basics[1].percent, basics[2].percent
end)