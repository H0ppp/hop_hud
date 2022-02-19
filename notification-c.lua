notifQueue = {}

function sendNotification(locTitle, locContent, locDelay)
    SendNUIMessage({
        type = "notification",
        title = locTitle,
        content = locContent,
        delay = locDelay
    });
    PlaySoundFrontend(-1, "Notification", "&Global_19670", true)
end

function addNotification(locTitle, locContent, locDelay)
    SendNUIMessage({
        type = "notification",
        title = locTitle,
        content = locContent,
        delay = locDelay
    });
end




RegisterNetEvent("hop_hud:addNotification")
AddEventHandler("hop_hud:addNotification", addNotification)



RegisterCommand("testNotification", function()
    --sendNotif("Test Notification!","This is a test", 5000)
    TriggerEvent("hop_hud:addNotification","Test Notification!","This is a test", 5000)
end, false)

function notifQueue.new ()
    return {first = 0, last = -1}
end

function notifQueue.pushleft (list, value)
    local first = list.first - 1
    list.first = first
    list[first] = value
  end
  
  function notifQueue.pushright (list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
  end
  
  function notifQueue.popleft (list)
    local first = list.first
    if first > list.last then error("list is empty") end
    local value = list[first]
    list[first] = nil        -- to allow garbage collection
    list.first = first + 1
    return value
  end
  
  function notifQueue.popright (list)
    local last = list.last
    if list.first > last then error("list is empty") end
    local value = list[last]
    list[last] = nil         -- to allow garbage collection
    list.last = last - 1
    return value
  end
  