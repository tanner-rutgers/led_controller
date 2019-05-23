local file = require("file")
local wifi = require("wifi")

local leds = require("leds")

local module = {}

local function getHTMLTemplate()
  local parts = {}

  if file.open("index.html.template", "r") then
    local part = file.read()
    while part do
      table.insert(parts, part)
      part = file.read()
    end
    file.close()
  end

  return parts
end

function module.get()
  local template = getHTMLTemplate()

  local config = leds.getConfig()
  for i=1,#template do
    for var,value in pairs(config) do
      template[i] = template[i]:gsub("{{" .. var .. "}}", value)
    end
  end

  return template
end

return module