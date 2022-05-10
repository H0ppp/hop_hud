function sendSpeed(content) -- Render text to screen
    BeginTextCommandDisplayText("STRING")
    SetTextFont(1)
    SetTextScale(1.0,1.0)
    SetTextWrap(0.8,0.98)
    SetTextJustification(2)
    SetTextColour(255,255,255,255)          
    AddTextComponentSubstringPlayerName(content)
    EndTextCommandDisplayText(0.9,0.8)
end


function sendLoc(direction, street)
    SendNUIMessage({
        type = "VehData",
        dir = direction,
        location = street
      })
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        ped = GetPlayerPed(-1)
        if (IsPedInAnyVehicle(ped, false)) then
            local vehicle = GetVehiclePedIsIn(ped,true)
            if(GetPedInVehicleSeat(vehicle,-1) == ped and GetIsVehicleEngineRunning(vehicle)) then
                local playerCoords = GetEntityCoords(vehicle) -- Player Location
                -- SPEED
                local speed = GetEntitySpeed(vehicle)*2.236936 -- Vehicle speed in mph
                local speedFloor = math.floor(speed)
                -- CLOSEST STREET
                local ret, cRoad, heading = GetClosestRoad(playerCoords.x, playerCoords.y, playerCoords.z, 10, 1, true)
                local xDiff = math.abs(cRoad.x - playerCoords.x)
                local yDiff = math.abs(cRoad.y - playerCoords.y)
                -- AREA
                local areaLab = GetNameOfZone(playerCoords.x,playerCoords.y,playerCoords.z) -- Get area label
                local area = GetLabelText(areaLab) -- Get Area name
                -- COMPASS
                local rotation = GetEntityRotation(vehicle,2) -- Car rotation vector
                local z, x, y = table.unpack(rotation) -- Coords
                local deg = math.floor(y) -- Car Rotation in degrees

                --Compass
                local direction = "N"
                if(deg >= -30 and deg < 30) then 
                    direction = "N"
                elseif (deg >= 30 and deg < 60) then 
                    direction = "NW"
                elseif (deg >= 60 and deg < 120) then 
                    direction = "W"
                elseif (deg >= 120 and deg < 150) then 
                    direction = "SW"
                elseif (deg >= 150 and deg < 180) then 
                    direction = "S"
                elseif (deg >= -180 and deg < -150) then 
                    direction = "S"
                elseif (deg >= -150 and deg < -120) then 
                    direction = "SE"
                elseif (deg >= -120 and deg < -60) then 
                    direction = "E"
                elseif (deg >= -60 and deg < -30) then 
                    direction = "NE"
                end
                
                sendSpeed(math.floor(speed).." Mph") -- Send vehicle speed to render

                if IsPointOnRoad(playerCoords.x,playerCoords.y,playerCoords.z) then
                    isOffroad = false
                    streetHash, crossingHash = GetStreetNameAtCoord(playerCoords.x,playerCoords.y,playerCoords.z) -- Street name of current location
                    streetName = GetStreetNameFromHashKey(streetHash) -- Get street name
                    sendLoc(direction, streetName)
                else
                    local dist = math.sqrt(math.pow(xDiff,2) + math.pow(yDiff,2))
                    if (dist > 30 or isOffroad == true) then 
                        isOffroad = true
                        sendLoc(direction, area)
                    else 
                        sendLoc(direction, streetName)
                    end
                end
            end
        end
    end
end)
