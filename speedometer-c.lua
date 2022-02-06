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

function sendDir(content)
    SendNUIMessage({
        type = "vehui",
        dir = content
      })
end

function sendLoc(content)
    SendNUIMessage({
        type = "vehui",
        location = content
      })
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        local playerCoords = GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1),false)) -- Player Location
        -- SPEED
        local speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1),false))*2.236936 -- Vehicle speed in mph
        local speedFloor = math.floor(speed)
        -- CLOSEST STREET
        local ret, cRoad, heading = GetClosestRoad(playerCoords.x, playerCoords.y, playerCoords.z, 10, 1, true)
        local xDiff = math.abs(cRoad.x - playerCoords.x)
        local yDiff = math.abs(cRoad.y - playerCoords.y)
        -- AREA
        local areaLab = GetNameOfZone(playerCoords.x,playerCoords.y,playerCoords.z) -- Get area label
        local area = GetLabelText(areaLab) -- Get Area name
        -- COMPASS
        local rotation = GetEntityRotation(GetVehiclePedIsIn(GetPlayerPed(-1),false),2) -- Car rotation vector
        local z, x, y = table.unpack(rotation) -- Coords
        local deg = math.floor(y) -- Car Rotation in degrees

        if (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
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
            
            sendDir(direction) -- Send vehicle direction to NUI
            sendSpeed(math.floor(speed).." Mph") -- Send vehicle speed to render

            if IsPointOnRoad(playerCoords.x,playerCoords.y,playerCoords.z) then
                isOffroad = false
                streetHash, crossingHash = GetStreetNameAtCoord(playerCoords.x,playerCoords.y,playerCoords.z) -- Street name of current location
                streetName = GetStreetNameFromHashKey(streetHash) -- Get street name
                sendLoc(streetName) -- Send vehicle location to NUI
            else
                local dist = math.sqrt(math.pow(xDiff,2) + math.pow(yDiff,2))
                if (dist > 30 or isOffroad == true) then 
                    isOffroad = true
                    sendLoc(area) -- Send vehicle location to NUI
                else 
                    sendLoc(streetName) -- Send vehicle location to NUI
                end
            end
        end
        Citizen.Wait(500);
    end
end)
