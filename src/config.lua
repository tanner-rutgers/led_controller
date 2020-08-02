local module = {}

module.LEDS = {
  ["enabled"] = "true",
  ["device_name"] = "",
  ["num_leds"] = 10,
  ["speed"] = 240,
  ["brightness"] = 100,
  ["color"] = "#FF0000",
  ["mode"] = "rainbow",
  ["mode_arg"] = 1
}

module.MQTT = {
}

module.WIFI = {
  SSID = "SSID",
  PWD = "PWD"
}

return module