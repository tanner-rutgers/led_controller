local leds = require("leds")
local web_server = require("web_server")

local function start()
  node.stripdebug(3)
  leds.start()
  web_server.start()
end

-- wait a bit so we can flash this thing out of a restart loop
local timer = tmr.create()
timer:alarm(5000, tmr.ALARM_SINGLE, start)