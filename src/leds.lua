local ws2812 = require("ws2812")
local file = require("file")

local module = {}

local function getConfig()
  local config = {}

  if file.open("config.json", "r") then
    print("Loading config from config.json")
    config = sjson.decode(file.read())
    file.close()
  else
    print("Loading config from config.lua")
    config = require("config").LEDS
  end

  return config
end

local function saveConfig(config)
  if file.open("config.json", "w") then
    print("Saving config.json")
    file.write(sjson.encode(config) .. "\n")
    file.close()
  else
    print("Could not open config.json to write...")
  end
end

local function hexToGRB(hex)
  hex = hex:gsub("#","")
  r, g, b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
  return g, r, b
end

local function updateLEDs(config)
  local strip_buffer = ws2812.newBuffer(config["num_leds"], 3)
  ws2812_effects.init(strip_buffer)
  ws2812_effects.stop()
  ws2812_effects.set_speed(config["speed"])
  if config["onny_offy"] == "true" then
    ws2812_effects.set_brightness(config["brightness"])
  else
    ws2812_effects.set_brightness(0)
  end
  ws2812_effects.set_color(hexToGRB(config["color"]))
  ws2812_effects.set_mode(config["mode"], config["mode_arg"])
  ws2812_effects.start()
end

function module.setLEDs(params)
  local config = getConfig()

  local changed = false
  if params == nil then
    changed = true
  else
    for key, val in pairs(params) do
      if config[key] ~= nil and config[key] ~= val then
        config[key] = val
        changed = true
      end
    end
  end

  if changed then
    print("Updating LEDs")
    updateLEDs(config)
    saveConfig(config)
  else
    print("Not updating LEDs, no changes")
  end
end

function module.start()
  ws2812.init(ws2812.MODE_SINGLE)
  module.setLEDs()
end

return module