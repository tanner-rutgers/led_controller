local ws2812 = require("ws2812")
local file = require("file")

local module = {}

function module.getConfig()
  local config = {}

  if file.open("config.json", "r") then
    config = sjson.decode(file.read())
    file.close()
  else
    config = require("config").LEDS
  end

  return config
end

local function saveConfig(params)
  if file.open("config.json", "w") then
    file.write(sjson.encode(params))
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

local function getUpdatedConfig(newValues)
  local config = module.getConfig()

  for key, val in pairs(newValues) do
    if config[key] then config[key] = val end
  end

  return config
end

local function updateLEDs(config)
  local strip_buffer = ws2812.newBuffer(config["num_leds"], 3)
  ws2812_effects.init(strip_buffer)
  ws2812_effects.stop()
  ws2812_effects.set_speed(config["speed"])
  ws2812_effects.set_brightness(config["brightness"])
  ws2812_effects.set_color(hexToGRB(config["color"]))
  ws2812_effects.set_mode(config["mode"], config["mode_arg"])
  ws2812_effects.start()
end

function module.setLEDs(params)
  local config = getUpdatedConfig(params)
  updateLEDs(config)
  saveConfig(config)
end

function module.start()
  local config = module.getConfig()

  ws2812.init(ws2812.MODE_SINGLE)

  module.setLEDs(config)
end

return module