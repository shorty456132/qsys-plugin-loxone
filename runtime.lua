--[[ Loxone Miniserver Runtime
  Communicates with Loxone Miniserver via HTTP Web Services API.
  Supports digital (On/Off/Pulse) and analog virtual I/O with periodic polling.
  Authentication uses HTTP Basic Auth (User/Password fields in HttpClient.Download).
]]

--------------------
-- Components ------
--------------------
-- (none required — uses HttpClient for HTTP requests)
-- End Components --

--------------------
-- Variables -------
--------------------
MaxDigital = 8
MaxAnalog = 4

-- Status state codes (matching Q-SYS StatusState enum)
StatusState = {
  OK           = 0,
  COMPROMISED  = 1,
  FAULT        = 2,
  NOTPRESENT   = 3,
  MISSING      = 4,
  INITIALIZING = 5
}

PollTimer = Timer.New()
DebugPrint = false
-- End Variables ---

--------------------
-- Functions -------
--------------------

-- Build base URL from IP address and properties
function GetBaseUrl()
  local scheme = Properties["Use HTTPS"].Value and "https" or "http"
  local host = Controls["IPAddress"].String
  local port = math.floor(Properties["HTTP Port"].Value)  -- floor prevents Lua 5.3 %d float error
  return string.format("%s://%s:%d", scheme, host, port)
end

-- URL-encode a control name (spaces and special characters)
function UrlEncode(s)
  return s:gsub("[^%w%-_%.~]", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
end

-- Set plugin status indicator
function SetStatus(state, msg)
  Controls["Status"].Value = StatusState[state] or StatusState.FAULT
  Controls["Status"].String = msg or ""
end

-- Parse Loxone XML response: <LL control="..." value="1" Code="200"/>
function ParseLL(xml)
  local code = xml:match('Code="(%d+)"')
  local value = xml:match('value="([^"]*)"')
  return tonumber(code), value
end

-- Send a digital command (On, Off, Pulse) to a named Loxone virtual input
function SendDigitalCommand(controlName, cmd, idx)
  if controlName == "" then
    print("Digital " .. tostring(idx) .. ": No control name configured")
    return
  end

  local url = GetBaseUrl() .. "/dev/sps/io/" .. UrlEncode(controlName) .. "/" .. cmd
  print("TX: " .. url)

  HttpClient.Download({
    Url = url,
    Method = "GET",
    User = Controls["Username"].String,
    Password = Controls["Password"].String,
    Timeout = 5,
    EventHandler = function(tbl, code, data, err, headers)
      if DebugPrint then
        print("RX [" .. tostring(code) .. "]: " .. tostring(data))
      end
      if code == 200 then
        SetStatus("OK", "OK")
        local respCode, value = ParseLL(data or "")
        if value and idx then
          Controls["Digital State " .. idx].Boolean = (value == "1")
        end
      elseif code == 401 then
        SetStatus("FAULT", "Auth Failed")
        print("Auth Error: Check Username/Password")
      elseif code == 0 then
        SetStatus("FAULT", "No Response")
        print("Digital " .. tostring(idx) .. ": No response (timeout or unreachable)")
      else
        SetStatus("FAULT", "HTTP Error " .. tostring(code))
        print("HTTP Error [" .. tostring(code) .. "]: " .. tostring(err))
      end
    end
  })
end

-- Send an analog value to a named Loxone virtual input
function SendAnalogCommand(controlName, value, idx)
  if controlName == "" then
    print("Analog " .. tostring(idx) .. ": No control name configured")
    return
  end

  local numValue = tonumber(value)
  if not numValue then
    print("Analog " .. tostring(idx) .. ": Invalid numeric value: " .. tostring(value))
    return
  end

  local url = GetBaseUrl() .. "/dev/sps/io/" .. UrlEncode(controlName) .. "/" .. tostring(numValue)
  print("TX: " .. url)

  HttpClient.Download({
    Url = url,
    Method = "GET",
    User = Controls["Username"].String,
    Password = Controls["Password"].String,
    Timeout = 5,
    EventHandler = function(tbl, code, data, err, headers)
      if DebugPrint then
        print("RX [" .. tostring(code) .. "]: " .. tostring(data))
      end
      if code == 200 then
        SetStatus("OK", "OK")
        local respCode, respValue = ParseLL(data or "")
        if respValue and idx then
          Controls["Analog State " .. idx].String = respValue
        end
      elseif code == 401 then
        SetStatus("FAULT", "Auth Failed")
        print("Auth Error: Check Username/Password")
      elseif code == 0 then
        SetStatus("FAULT", "No Response")
        print("Analog " .. tostring(idx) .. ": No response (timeout or unreachable)")
      else
        SetStatus("FAULT", "HTTP Error " .. tostring(code))
        print("HTTP Error [" .. tostring(code) .. "]: " .. tostring(err))
      end
    end
  })
end

-- Poll the state of a single digital control
function PollDigital(idx, controlName)
  if controlName == "" then return end

  local url = GetBaseUrl() .. "/dev/sps/io/" .. UrlEncode(controlName) .. "/state"
  if DebugPrint then print("TX (poll): " .. url) end

  HttpClient.Download({
    Url = url,
    Method = "GET",
    User = Controls["Username"].String,
    Password = Controls["Password"].String,
    Timeout = 5,
    EventHandler = function(tbl, code, data, err, headers)
      if DebugPrint then
        print("RX Digital " .. idx .. " [" .. tostring(code) .. "]: " .. tostring(data))
      end
      if code == 200 then
        SetStatus("OK", "Polling")
        if data and data ~= "" then
          local respCode, value = ParseLL(data)
          if value then
            Controls["Digital State " .. idx].Boolean = (value == "1")
          end
        end
      elseif code == 0 then
        SetStatus("COMPROMISED", "Connection Lost")
        print("Poll Digital " .. idx .. ": No response (timeout or unreachable)")
      elseif code == 401 then
        SetStatus("FAULT", "Auth Failed")
        print("Poll Digital " .. idx .. ": Auth Error (401)")
      else
        SetStatus("COMPROMISED", "Poll Error " .. tostring(code))
        print("Poll Digital " .. idx .. " error [" .. tostring(code) .. "]: " .. tostring(err))
      end
    end
  })
end

-- Poll the state of a single analog control
function PollAnalog(idx, controlName)
  if controlName == "" then return end

  local url = GetBaseUrl() .. "/dev/sps/io/" .. UrlEncode(controlName) .. "/state"
  if DebugPrint then print("TX (poll): " .. url) end

  HttpClient.Download({
    Url = url,
    Method = "GET",
    User = Controls["Username"].String,
    Password = Controls["Password"].String,
    Timeout = 5,
    EventHandler = function(tbl, code, data, err, headers)
      if DebugPrint then
        print("RX Analog " .. idx .. " [" .. tostring(code) .. "]: " .. tostring(data))
      end
      if code == 200 then
        SetStatus("OK", "Polling")
        if data and data ~= "" then
          local respCode, value = ParseLL(data)
          if value then
            Controls["Analog State " .. idx].String = value
          end
        end
      elseif code == 0 then
        SetStatus("COMPROMISED", "Connection Lost")
        print("Poll Analog " .. idx .. ": No response (timeout or unreachable)")
      elseif code == 401 then
        SetStatus("FAULT", "Auth Failed")
        print("Poll Analog " .. idx .. ": Auth Error (401)")
      else
        SetStatus("COMPROMISED", "Poll Error " .. tostring(code))
        print("Poll Analog " .. idx .. " error [" .. tostring(code) .. "]: " .. tostring(err))
      end
    end
  })
end

-- Poll all configured controls
function PollAll()
  if Controls["IPAddress"].String == "" then
    SetStatus("MISSING", "No IP Address")
    return
  end

  local digitalCount = math.floor(Properties["Digital Control Count"].Value)
  for i = 1, digitalCount do
    local idx = i
    local name = Controls["Digital Name " .. idx].String
    PollDigital(idx, name)
  end

  local analogCount = math.floor(Properties["Analog Control Count"].Value)
  for i = 1, analogCount do
    local idx = i
    local name = Controls["Analog Name " .. idx].String
    PollAnalog(idx, name)
  end
end

-- Fetch device info from Miniserver configuration endpoints
function FetchDeviceInfo()
  local base = GetBaseUrl()
  local user = Controls["Username"].String
  local pass = Controls["Password"].String

  -- Device name
  HttpClient.Download({
    Url = base .. "/dev/cfg/device",
    Method = "GET",
    User = user,
    Password = pass,
    Timeout = 5,
    EventHandler = function(tbl, code, data, err, headers)
      if code == 200 then
        local respCode, value = ParseLL(data or "")
        if value then
          Controls["DeviceName"].String = value
          print("Device Name: " .. value)
        end
      else
        if DebugPrint then
          print("Device Name fetch error [" .. tostring(code) .. "]: " .. tostring(err))
        end
      end
    end
  })

  -- Firmware version
  HttpClient.Download({
    Url = base .. "/dev/cfg/version",
    Method = "GET",
    User = user,
    Password = pass,
    Timeout = 5,
    EventHandler = function(tbl, code, data, err, headers)
      if code == 200 then
        local respCode, value = ParseLL(data or "")
        if value then
          Controls["DeviceFirmware"].String = value
          print("Firmware: " .. value)
        end
      else
        if DebugPrint then
          print("Firmware fetch error [" .. tostring(code) .. "]: " .. tostring(err))
        end
      end
    end
  })
end

-- Start polling
function StartPolling()
  if Controls["IPAddress"].String == "" then
    SetStatus("MISSING", "No IP Address")
    Controls["Connect"].Boolean = false
    print("Cannot start: No IP Address configured")
    return
  end

  print("Starting polling for Loxone at " .. Controls["IPAddress"].String)
  SetStatus("INITIALIZING", "Connecting...")

  PollAll()
  FetchDeviceInfo()
  PollTimer:Start(Properties["Poll Interval"].Value)
end

-- Stop polling
function StopPolling()
  PollTimer:Stop()
  SetStatus("NOTPRESENT", "Not Polling")
  print("Polling stopped")
end
-- End Functions ---

--------------------
-- EventHandlers ---
--------------------

-- Polling timer fires PollAll on each interval
PollTimer.EventHandler = function()
  PollAll()
end

-- Connect toggle: start or stop polling
Controls["Connect"].EventHandler = function(ctl)
  if ctl.Boolean then
    StartPolling()
  else
    StopPolling()
  end
end

-- Test Connection button: polls PLC state to verify connectivity
Controls["Test Connection"].EventHandler = function()
  if Controls["IPAddress"].String == "" then
    SetStatus("MISSING", "No IP Address")
    return
  end

  local url = GetBaseUrl() .. "/dev/sps/state"
  print("TX: " .. url)

  HttpClient.Download({
    Url = url,
    Method = "GET",
    User = Controls["Username"].String,
    Password = Controls["Password"].String,
    Timeout = 5,
    EventHandler = function(tbl, code, data, err, headers)
      if DebugPrint then
        print("RX [" .. tostring(code) .. "]: " .. tostring(data))
      end
      if code == 200 then
        local respCode, value = ParseLL(data or "")
        local plcStates = {
          ["0"] = "None",        ["1"] = "Booting",
          ["2"] = "Loaded",      ["3"] = "Started",
          ["4"] = "Link started",["5"] = "Running",
          ["6"] = "Config changed", ["7"] = "Error",
          ["8"] = "Update"
        }
        local stateStr = (value and plcStates[value]) or ("State " .. tostring(value))
        SetStatus("OK", "PLC: " .. stateStr)
        print("Test Connection OK — PLC State: " .. stateStr)
      elseif code == 401 then
        SetStatus("FAULT", "Auth Failed")
        print("Test Connection: Auth Error (401)")
      elseif code == 0 then
        SetStatus("FAULT", "Unreachable")
        print("Test Connection: No response (timeout or unreachable)")
      else
        SetStatus("FAULT", "Error " .. tostring(code))
        print("Test Connection Error [" .. tostring(code) .. "]: " .. tostring(err))
      end
    end
  })
end

-- Debug Print toggle
Controls["Debug Print"].EventHandler = function(ctl)
  DebugPrint = ctl.Boolean
  print("Debug Print: " .. (DebugPrint and "ON" or "OFF"))
end

-- Digital control event handlers (bound to exactly the configured count)
for i = 1, math.floor(Properties["Digital Control Count"].Value) do
  local idx = i

  Controls["Digital On " .. idx].EventHandler = function()
    local name = Controls["Digital Name " .. idx].String
    SendDigitalCommand(name, "On", idx)
  end

  Controls["Digital Off " .. idx].EventHandler = function()
    local name = Controls["Digital Name " .. idx].String
    SendDigitalCommand(name, "Off", idx)
  end

  Controls["Digital Pulse " .. idx].EventHandler = function()
    local name = Controls["Digital Name " .. idx].String
    SendDigitalCommand(name, "Pulse", idx)
  end
end

-- Analog control event handlers (bound to exactly the configured count)
for i = 1, math.floor(Properties["Analog Control Count"].Value) do
  local idx = i

  Controls["Analog Send " .. idx].EventHandler = function()
    local name = Controls["Analog Name " .. idx].String
    local value = Controls["Analog Value " .. idx].String
    SendAnalogCommand(name, value, idx)
  end
end

--End Eventhandlers-

-- Initialize --
function Initialize()
  SetStatus("NOTPRESENT", "Not Polling")
  DebugPrint = false

  -- Auto-start polling if IP address is already configured
  if Controls["IPAddress"].String ~= "" then
    Controls["Connect"].Boolean = true
    StartPolling()
  end
end

Initialize()
