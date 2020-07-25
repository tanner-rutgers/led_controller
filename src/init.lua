local leds = require("leds")
local network = require("network")
local application = require("application")

local function start()
  node.stripdebug(3)
  leds.start()
  network.start(application.start)
end

-- wait a bit so we can flash this thing out of a restart loop
local timer = tmr.create()
timer:alarm(5000, tmr.ALARM_SINGLE, start)