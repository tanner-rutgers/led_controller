local wifi = require("wifi")
local tmr = require("tmr")

local app = require("application")
local config = require("config")

local module = {}

local timer = tmr.create()

local function waitForIP()
  if wifi.sta.getip() == nil then
    print("IP unavailable, Waiting...")
  else
    timer:unregister()
    print("====================================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is ".. wifi.sta.getip())
    print("====================================")

    app.start()
  end
end

local function connectToNetwork(aps)
  if aps then
    print("Looking for network " .. config.WIFI.SSID .. "...")
    for key, _ in pairs(aps) do
      print("Found " .. key)
      if key == config.WIFI.SSID then
        print("Connecting to " .. key .. " ...")
        wifi.sta.config({ssid=config.WIFI.SSID, pwd=config.WIFI.PWD})
        wifi.sta.connect()

        timer:alarm(2500, tmr.ALARM_AUTO, waitForIP)
      end
    end
  else
    print("Error getting AP list")
  end
end

function module.start(callback)
  print("Configuring Wifi ...")
  wifi.setmode(wifi.STATION)
  wifi.sta.getap(connectToNetwork)
end

return module