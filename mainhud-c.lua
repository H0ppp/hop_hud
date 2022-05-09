local waterLevel = 0
local foodLevel = 0
local cashValue = 0
ESX = nil
playerData = nil
local hudActive = false
local PlayerInfo = {}
local VehicleInfo = {}
local LastPlayerInfo = {}
local LastVehicleInfo = {}

local cashDisplay = true

Citizen.CreateThread(function() -- ESX Thread
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function() -- Main Thread
    Citizen.Wait(2000)
    DisplayRadar(false)
    LastPlayerInfo.health = 0 
    LastPlayerInfo.water = 0
    LastPlayerInfo.food = 0
    LastPlayerInfo.cash = 0
    while true do
        Citizen.Wait(500)
        while hudActive do
            Citizen.Wait(0)
            local ped = GetPlayerPed(-1)
            local health = GetEntityHealth(ped)
            playerData = ESX.GetPlayerData()
            local VehStateChanged = false
            local PlayerStateChanged = false

            for k,v in ipairs(playerData.accounts) do
                if v.name == 'money' then
                    cashValue = "$" .. ESX.Math.GroupDigits(v.money)
                end
            end

            PlayerInfo.health = health 
            PlayerInfo.water = waterLevel
            PlayerInfo.food = foodLevel
            PlayerInfo.cash = cashValue
            if (IsPedInAnyVehicle(GetPlayerPed(-1),true)) then 
                DisplayRadar(true)
                SendCar(true)
                local fuelLevel = exports["hop_fuel"]:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1),true))
                local nosLevel = exports["hop_nitro"]:GetNitroFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1),true))
                VehicleInfo.fuel = fuelLevel
                VehicleInfo.nos = nosLevel

                for i, v in pairs(VehicleInfo) do 
                    if(v ~= LastVehicleInfo[i]) then 
                        VehStateChanged = true
                    end
                end

                if(VehStateChanged) then
                    SendNUIMessage({
                        type = "VehicleInfo",
                        fuel = fuelLevel,
                        nos = nosLevel
                    });
                end
            else
                DisplayRadar(false)
                SendCar(false)
            end

            for i, v in pairs(PlayerInfo) do 
                if(v ~= LastPlayerInfo[i]) then 
                    PlayerStateChanged = true
                end
            end

            if(PlayerStateChanged) then
                SendNUIMessage({
                    type = "PlayerInfo",
                    heal = health,
                    water = waterLevel,
                    food = foodLevel,
                    fuel = fuelLevel,
                    nos = nosLevel,
                    cash = cashValue
                });
            end

            if (IsPauseMenuActive()) then 
                SendVisibility(false)
            else
                SendVisibility(true)
            end
            for i, v in pairs(PlayerInfo) do 
                LastPlayerInfo[i] = v 
            end
            for i, v in pairs(VehicleInfo) do 
                LastVehicleInfo[i] = v 
            end
        end
    end
end)

function SendCar(bool) 
    SendNUIMessage({
        type = "VehDataVisible",
        display = bool
      })
end

function SendVisibility(bool) 
    SendNUIMessage({
        type = "Visible",
        showHUD = bool
      })
end


RegisterCommand("showcash", function()
    if(cashDisplay == true) then 
        cashDisplay = false
    else
        cashDisplay = true 
    end
    SendNUIMessage({
        type = "CashVisible",
        showCash = cashDisplay
      })
end, false)


RegisterCommand("hud", function()
    if(hudActive == true) then 
        TriggerEvent("hop_hud:hide")
    else
        TriggerEvent("hop_hud:show")
    end
end, false)

RegisterNetEvent('hop_hud:show')
AddEventHandler('hop_hud:show', function()
    hudActive = true
    SendVisibility(hudActive) 
end)

RegisterNetEvent('hop_hud:hide')
AddEventHandler('hop_hud:hide', function()
    hudActive = false
    SendVisibility(hudActive)
end)

AddEventHandler("hop_hud:updateBasics", function(basics)
    foodLevel, waterLevel = basics[1].percent, basics[2].percent
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