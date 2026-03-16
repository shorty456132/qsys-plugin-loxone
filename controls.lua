-- Connection controls (reserved names)
table.insert(ctrls, {
  Name = "IPAddress",
  ControlType = "Text",
  UserPin = true,
  PinStyle = "Input",
  Count = 1
})

table.insert(ctrls, {
  Name = "Username",
  ControlType = "Text",
  UserPin = false,
  PinStyle = "None",
  Count = 1
})

table.insert(ctrls, {
  Name = "Password",
  ControlType = "Text",
  UserPin = false,
  PinStyle = "None",
  Count = 1
})

table.insert(ctrls, {
  Name = "Status",
  ControlType = "Indicator",
  IndicatorType = "Status",
  UserPin = true,
  PinStyle = "Output",
  Count = 1
})

table.insert(ctrls, {
  Name = "Connect",
  ControlType = "Button",
  ButtonType = "Toggle",
  UserPin = true,
  PinStyle = "Input",
  Count = 1
})

table.insert(ctrls, {
  Name = "Test Connection",
  ControlType = "Button",
  ButtonType = "Momentary",
  UserPin = true,
  PinStyle = "Input",
  Count = 1
})

table.insert(ctrls, {
  Name = "Debug Print",
  ControlType = "Button",
  ButtonType = "Toggle",
  UserPin = false,
  PinStyle = "None",
  Count = 1
})

-- Device info (reserved names)
table.insert(ctrls, {
  Name = "DeviceName",
  ControlType = "Indicator",
  IndicatorType = "Text",
  UserPin = true,
  PinStyle = "Output",
  Count = 1
})

table.insert(ctrls, {
  Name = "DeviceFirmware",
  ControlType = "Indicator",
  IndicatorType = "Text",
  UserPin = true,
  PinStyle = "Output",
  Count = 1
})

-- Digital controls with sensor reading capability
local dCount = math.floor(props["Digital Control Count"].Value)
for i = 1, dCount do
  table.insert(ctrls, {
    Name = "Digital Name " .. i,
    ControlType = "Text",
    UserPin = false,
    PinStyle = "None",
    Count = 1
  })
  table.insert(ctrls, {
    Name = "Digital On " .. i,
    ControlType = "Button",
    ButtonType = "Momentary",
    UserPin = true,
    PinStyle = "Input",
    Count = 1
  })
  table.insert(ctrls, {
    Name = "Digital Off " .. i,
    ControlType = "Button",
    ButtonType = "Momentary",
    UserPin = true,
    PinStyle = "Input",
    Count = 1
  })
  table.insert(ctrls, {
    Name = "Digital Pulse " .. i,
    ControlType = "Button",
    ButtonType = "Momentary",
    UserPin = true,
    PinStyle = "Input",
    Count = 1
  })
  table.insert(ctrls, {
    Name = "Digital State " .. i,
    ControlType = "Indicator",
    IndicatorType = "Led",
    UserPin = true,
    PinStyle = "Output",
    Count = 1
  })
  -- New: Digital State Text for sensor readings
  table.insert(ctrls, {
    Name = "Digital State Text " .. i,
    ControlType = "Indicator",
    IndicatorType = "Text",
    UserPin = true,
    PinStyle = "Output",
    Count = 1
  })
end

-- Analog controls
local aCount = math.floor(props["Analog Control Count"].Value)
for i = 1, aCount do
  table.insert(ctrls, {
    Name = "Analog Name " .. i,
    ControlType = "Text",
    UserPin = false,
    PinStyle = "None",
    Count = 1
  })
  table.insert(ctrls, {
    Name = "Analog Value " .. i,
    ControlType = "Text",
    UserPin = true,
    PinStyle = "Both",
    Count = 1
  })
  table.insert(ctrls, {
    Name = "Analog Send " .. i,
    ControlType = "Button",
    ButtonType = "Momentary",
    UserPin = true,
    PinStyle = "Input",
    Count = 1
  })
  table.insert(ctrls, {
    Name = "Analog State " .. i,
    ControlType = "Indicator",
    IndicatorType = "Text",
    UserPin = true,
    PinStyle = "Output",
    Count = 1
  })
end
