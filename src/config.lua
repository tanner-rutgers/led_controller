local module = {}

-- WIFI
module.WIFI = {
  SSID = "CHANGE ME",
  PWD = ""
}

-- WEB SERVER
module.PORT = 80

-- LEDS
module.LEDS = {
  ["device_name"] = "",
  ["num_leds"] = 6,
  ["speed"] = 240,
  ["brightness"] = 100,
  ["color"] = "#FF0000",
  ["mode"] = "rainbow",
  ["mode_arg"] = 1
}

return module