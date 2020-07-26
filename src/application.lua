print("Loading application...")

local mqtt = require("mqtt")
local wifi = require("wifi")

local leds = require("leds")
local config = require("config")

local module = {}

local CLIENT_ID = wifi.sta.getmac():lower():gsub(":","_")
local CLIENT_TOPIC = "/clients/" .. CLIENT_ID
local STATE_TOPIC = CLIENT_TOPIC .. "/state"
local LEDS_TOPIC = CLIENT_TOPIC .. "/leds"

local publish_online = function(client)
  client:publish(STATE_TOPIC, "1", 1, 1, function(client)
    print("Published " .. 1 .. " to " .. STATE_TOPIC)
  end)
end

local subscribe_to_leds = function(client)
  client:subscribe(LEDS_TOPIC, 1, function(client)
    print("Subscribed to " .. LEDS_TOPIC)
  end)
end

local on_connect = function(client)
  publish_online(client)
  subscribe_to_leds(client)
end

local on_connect_failure = function(client, reason)
  print("Could not connect to " .. config.MQTT.HOST .. ": ", reason)
end

local on_message = function(client, topic, data)
  if data ~= nil then
    leds.setLEDs(sjson.decode(data))
  end
end

local connect_to_mqtt = function(client)
  print("Connecting to " .. config.MQTT.HOST)
  client:connect(config.MQTT.HOST, 1883, false, on_connect, on_connect_failure)
end

local on_disconnect = function(client)
  print("Disconnected from " .. config.MQTT.HOST)
  connect_to_mqtt(client)
end

function module.start()
  print("Creating MQTT client...")
  local m = mqtt.Client(CLIENT_ID, 120, config.MQTT.USER, config.MQTT.PWD)

  print("Sending MQTT lwt...")
  m:lwt(STATE_TOPIC, "0", 1, 1)

  print("Setting up MQTT client callbacks...")
  m:on("connect", function(client) print("MQTT connected") end)
  m:on("offline", on_disconnect)
  m:on("message", on_message)

  connect_to_mqtt(m)
end

return module
