local wifi = require("wifi")
local enduser_setup = require("enduser_setup")

local module = {}

local wifi_on_connect = function(callback)
  print("Wifi connection is ready!")

  local timer = tmr.create()
  timer:alarm(3000, tmr.ALARM_AUTO, function()
    if wifi.sta.getip() == nil then
      print("Waiting for IP...")
    else
       print("Got IP address: " .. wifi.sta.getip())
       timer:unregister()
       if callback ~= nil then callback() end
    end
  end)
end

local wifi_on_error = function(err, callback)
  print("Error connecting WiFi: " .. err)
end

function module.start(callback)
  print("Configuring Wifi ...")
  enduser_setup.start(
    -- on success
    function()
      wifi_on_connect(callback)
    end,
    -- on failure
    function(err, str)
      wifi_on_error(str, callback)
    end,
    -- on debug
    print
  )

end

return module
