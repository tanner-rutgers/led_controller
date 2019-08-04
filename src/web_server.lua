local wifi = require("wifi")
local app = require("application")
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

  app.start()
end

function module.start()
  print("Configuring Wifi ...")

  wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
  wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)

  wifi.setmode(wifi.STATION)
  wifi.sta.config({ssid=config.WIFI.SSID, pwd=config.WIFI.PWD})
end

return module
