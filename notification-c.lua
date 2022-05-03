Queue = {}


function SendNotification(Notification)
	if(Notification) then
		if(Notification.sent == false) then
			SendNUIMessage({
				type = "notification",
				title = Notification.title,
				content = Notification.content,
				delay = Notification.delay
			});
			PlaySoundFrontend(-1, "CHALLENGE_UNLOCKED", "HUD_AWARDS")
			Notification.sent = true;
		end
	end
end

function AddNotification(locTitle, locContent, locDelay)
	Queue[#Queue+1] = {title = locTitle, content = locContent, delay = locDelay, shown = false, sent = false}
end


Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if #Queue ~= 0 then
			if Queue[1].shown == true then 
				for k,notif in ipairs(Queue) do 
					Queue[k-1] = notif
				end
				Queue[#Queue] = nil
				SendNotification(Queue[1])
			else
				SendNotification(Queue[1])
			end
		end
	end
end)

RegisterNUICallback('notifySuccess', function(data)
    local itemId = data.itemId
	if(itemId == "success") then 
		Queue[1].shown = true
	end
end)

RegisterNetEvent("hop_hud:addNotification")
AddEventHandler("hop_hud:addNotification", AddNotification)

RegisterCommand("testNotification", function()
	TriggerEvent("hop_hud:addNotification","Test Notification!","This is a test", 5000)
end, false)