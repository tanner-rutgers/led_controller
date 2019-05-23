local module = {}

local function hex_to_char(x)
  return string.char(tonumber(x, 16))
end

local function parseFormData(body)
   local data = {}
   for kv in body.gmatch(body, "%s*&?([^=]+=[^&]+)") do
      local key, value = string.match(kv, "(.*)=(.*)")
      data[key] = value:gsub("%+", " "):gsub("%%(%x%x)", hex_to_char)
   end
   return data
end

local function getRequestData(payload)
   local requestData
   return function ()
      local mimeType = string.match(payload, "Content%-Type: ([%w/-]+)")
      local bodyStart = payload:find("\r\n\r\n", 1, true)
      local body = payload:sub(bodyStart, #payload)
      payload = nil
      collectgarbage()
      return parseFormData(body)
   end
end

function module.parseRequest(request)
   local e = request:find("\r\n", 1, true)
   local line = request:sub(1, e - 1)
   local r = {}
   local _, i
   _, i, r.method, r.request = line:find("^([A-Z]+) (.-) HTTP/[1-9]+.[0-9]+$")
   r.getRequestData = getRequestData(request)
   return r
end

return module