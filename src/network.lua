local wifi = require("wifi")
local config = require("config")

local module = {}

local wifi_connect_event = function(T)
  print("Connection to " .. T.SSID .. " established!")
  print("Waiting for IP address...")
end

local wifi_got_ip_event = function(T)
  print("Wifi connection is ready!")

  print("============================")
  print("MAC Address: " .. wifi.ap.getmac())
  print("IP Address: " .. wifi.sta.getip())
  print("============================")
end

function module.start(callback)
  print("Configuring Wifi ...")

  wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
  wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
    wifi_got_ip_event(T)
    callback()
  end)

  wifi.setmode(wifi.STATION)
  wifi.sta.config({ssid=config.WIFI.SSID, pwd=config.WIFI.PWD})
end

return module
