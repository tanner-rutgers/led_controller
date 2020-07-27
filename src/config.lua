local module = {}

module.WIFI = {
  SSID = "ssid",
  PWD = "pwd"
}

module.PORT = 80

module.LEDS = {
  ["onny_offy"] = "true",
  ["device_name"] = "",
  ["num_leds"] = 10,
  ["speed"] = 240,
  ["brightness"] = 100,
  ["color"] = "#FF0000",
  ["mode"] = "rainbow",
  ["mode_arg"] = 1
}

module.MQTT = {
  HOST = "host",
  USER = "user",
  PWD = "pwd"
}

return module