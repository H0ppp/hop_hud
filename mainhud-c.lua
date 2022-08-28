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
    LastPlayerInfo.armor = 0
    LastPlayerInfo.water = 0
    LastPlayerInfo.food = 0
    LastPlayerInfo.cash = 0
    while true do
        Citizen.Wait(500)
        while hudActive do
            Citizen.Wait(0)
            local ped = GetPlayerPed(-1)
            local playerData = ESX.GetPlayerData()
            local VehStateChanged = false
            local PlayerStateChanged = false


            PlayerInfo.health = GetEntityHealth(ped) 
            PlayerInfo.armor = GetPedArmour(ped) 
            PlayerInfo.water = waterLevel
            PlayerInfo.food = foodLevel
            for k,v in ipairs(playerData.accounts) do
                if v.name == 'money' then
                    PlayerInfo.cash = v.money
                end
            end
            if (IsPedInAnyVehicle(ped,true)) then 
                vehicle = GetVehiclePedIsIn(ped,true)
                if(GetPedInVehicleSeat(vehicle,-1) == ped and GetIsVehicleEngineRunning(vehicle)) then
                    DisplayRadar(true)
                    SendCar(true)
                    VehicleInfo.fuel = exports["hop_fuel"]:GetFuel(vehicle)
                    VehicleInfo.nos = exports["hop_nitro"]:GetNitroFuelLevel(vehicle)
                    VehicleInfo.health = GetVehicleEngineHealth(vehicle)

                    for i, v in pairs(VehicleInfo) do 
                        if(v ~= LastVehicleInfo[i]) then 
                            VehStateChanged = true
                        end
                    end

                    if(VehStateChanged) then
                        SendNUIMessage({
                            type = "VehicleInfo",
                            fuel = VehicleInfo.fuel,
                            nos = VehicleInfo.nos,
                            health = VehicleInfo.health
                        });
                    end
                else 
                    SendCar(false)
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
                    heal = PlayerInfo.health,
                    armor = PlayerInfo.armor,
                    water = PlayerInfo.water,
                    food = PlayerInfo.food,
                    cash = PlayerInfo.cash
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