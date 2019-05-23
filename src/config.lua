local module = {}

-- WIFI
module.WIFI = {
  SSID = "FIX ME",
  PWD = ""
}

-- WEB SERVER
module.PORT = 80
module.HOSTNAME = "leds"

-- LEDS
module.LEDS = {
  ["device_name"] = "<does not compute>",
  ["num_leds"] = 6,
  ["speed"] = 240,
  ["brightness"] = 100,
  ["color"] = "#FF0000",
  ["mode"] = "rainbow",
  ["mode_arg"] = 1
}

return module