local net = require("net")
local wifi = require("wifi")

local index = require("index")
local http = require("http")
local leds = require("leds")
local config = require("config")

local module = {}

function receiver(sck, data)
  local request = http.parseRequest(data)

  if request.method == "POST" then
    leds.setLEDs(request.getRequestData())
  end

  request = nil

  local page = { "HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n" }
  local page_parts = index.get()
  for _, page_part in pairs(page_parts) do
    table.insert(page, page_part)
  end
  page_parts = nil

  local function send(localSocket)
    if #page > 0 then
      localSocket:send(table.remove(page, 1))
    else
      localSocket:close()
      page = nil
    end
  end

  sck:on("sent", send)

  send(sck)
end

function module.start()
  local s = net.createServer(net.TCP)

  print("====================================")
  print("Server Started")
  print("Open " .. wifi.sta.getip() .. " in your browser")
  print("====================================")

  s:listen(config.PORT, function(connection)
    connection:on("receive", receiver)
  end)
end

return module