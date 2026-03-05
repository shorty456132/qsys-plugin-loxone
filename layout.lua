local CurrentPage = PageNames[props["page_index"].Value]

if CurrentPage == "Control" then
  -- Plugin background
  table.insert(graphics, {
    Type = "GroupBox",
    Fill = { 35, 35, 35 },
    StrokeColor = { 35, 35, 35 },
    StrokeWidth = 0,
    CornerRadius = 0,
    Position = { 0, 0 },
    Size = { 420, 630 },
    ZOrder = -10
  })

  -- Connection Status section
  table.insert(graphics, {
    Type = "GroupBox",
    Text = "Connection",
    Fill = { 55, 55, 55 },
    Color = { 221, 221, 221 },
    StrokeColor = { 80, 80, 80 },
    StrokeWidth = 1,
    CornerRadius = 8,
    Font = "Roboto",
    FontSize = 11,
    Position = { 10, 10 },
    Size = { 400, 55 },
    ZOrder = -5
  })

  table.insert(graphics, {
    Type = "Label",
    Text = "Connect",
    Color = { 200, 200, 200 },
    Font = "Roboto",
    FontSize = 11,
    HTextAlign = "Right",
    Position = { 20, 32 },
    Size = { 65, 20 }
  })

  layout["Connect"] = {
    PrettyName = "Connection~Connect",
    Style = "Button",
    ButtonVisualStyle = "Flat",
    Position = { 90, 30 },
    Size = { 90, 24 },
    Color = { 0, 180, 80 },
    OffColor = { 80, 80, 80 },
    UnlinkOffColor = true,
    Legend = "Connect",
    FontSize = 12,
    CornerRadius = 4
  }

  layout["Status"] = {
    PrettyName = "Connection~Status",
    Position = { 195, 30 },
    Size = { 205, 24 }
  }

  -- Digital Controls section
  table.insert(graphics, {
    Type = "GroupBox",
    Text = "Digital Controls",
    Fill = { 50, 50, 50 },
    Color = { 221, 221, 221 },
    StrokeColor = { 75, 75, 75 },
    StrokeWidth = 1,
    CornerRadius = 8,
    Font = "Roboto",
    FontSize = 11,
    Position = { 10, 75 },
    Size = { 400, 295 },
    ZOrder = -5
  })

  -- Digital column headers
  table.insert(graphics, {
    Type = "Label", Text = "Control Name",
    Color = { 170, 170, 170 }, Font = "Roboto", FontSize = 10,
    HTextAlign = "Center", Position = { 20, 95 }, Size = { 130, 17 }
  })
  table.insert(graphics, {
    Type = "Label", Text = "On",
    Color = { 170, 170, 170 }, Font = "Roboto", FontSize = 10,
    HTextAlign = "Center", Position = { 155, 95 }, Size = { 48, 17 }
  })
  table.insert(graphics, {
    Type = "Label", Text = "Off",
    Color = { 170, 170, 170 }, Font = "Roboto", FontSize = 10,
    HTextAlign = "Center", Position = { 208, 95 }, Size = { 48, 17 }
  })
  table.insert(graphics, {
    Type = "Label", Text = "Pulse",
    Color = { 170, 170, 170 }, Font = "Roboto", FontSize = 10,
    HTextAlign = "Center", Position = { 261, 95 }, Size = { 53, 17 }
  })
  table.insert(graphics, {
    Type = "Label", Text = "State",
    Color = { 170, 170, 170 }, Font = "Roboto", FontSize = 10,
    HTextAlign = "Center", Position = { 323, 95 }, Size = { 30, 17 }
  })

  local dCount = math.floor(props["Digital Control Count"].Value)
  for i = 1, dCount do
    local rowY = 115 + (i - 1) * 32

    layout["Digital Name " .. i] = {
      PrettyName = "Digital " .. i .. "~Control Name",
      Style = "Text",
      Position = { 20, rowY },
      Size = { 130, 24 },
      FontSize = 11
    }

    layout["Digital On " .. i] = {
      PrettyName = "Digital " .. i .. "~On",
      Style = "Button",
      ButtonVisualStyle = "Flat",
      Position = { 155, rowY },
      Size = { 48, 24 },
      Color = { 0, 180, 80 },
      Legend = "On",
      FontSize = 11,
      CornerRadius = 4
    }

    layout["Digital Off " .. i] = {
      PrettyName = "Digital " .. i .. "~Off",
      Style = "Button",
      ButtonVisualStyle = "Flat",
      Position = { 208, rowY },
      Size = { 48, 24 },
      Color = { 200, 60, 60 },
      Legend = "Off",
      FontSize = 11,
      CornerRadius = 4
    }

    layout["Digital Pulse " .. i] = {
      PrettyName = "Digital " .. i .. "~Pulse",
      Style = "Button",
      ButtonVisualStyle = "Flat",
      Position = { 261, rowY },
      Size = { 53, 24 },
      Color = { 60, 120, 200 },
      Legend = "Pulse",
      FontSize = 11,
      CornerRadius = 4
    }

    layout["Digital State " .. i] = {
      PrettyName = "Digital " .. i .. "~State",
      Style = "Led",
      Position = { 330, rowY + 4 },
      Size = { 16, 16 },
      Color = { 0, 220, 60 },
      OffColor = { 100, 40, 40 },
      UnlinkOffColor = true
    }
  end

  -- Analog Controls section
  table.insert(graphics, {
    Type = "GroupBox",
    Text = "Analog Controls",
    Fill = { 50, 50, 50 },
    Color = { 221, 221, 221 },
    StrokeColor = { 75, 75, 75 },
    StrokeWidth = 1,
    CornerRadius = 8,
    Font = "Roboto",
    FontSize = 11,
    Position = { 10, 380 },
    Size = { 400, 205 },
    ZOrder = -5
  })

  -- Analog column headers
  table.insert(graphics, {
    Type = "Label", Text = "Control Name",
    Color = { 170, 170, 170 }, Font = "Roboto", FontSize = 10,
    HTextAlign = "Center", Position = { 20, 400 }, Size = { 115, 17 }
  })
  table.insert(graphics, {
    Type = "Label", Text = "Value",
    Color = { 170, 170, 170 }, Font = "Roboto", FontSize = 10,
    HTextAlign = "Center", Position = { 140, 400 }, Size = { 85, 17 }
  })
  table.insert(graphics, {
    Type = "Label", Text = "Send",
    Color = { 170, 170, 170 }, Font = "Roboto", FontSize = 10,
    HTextAlign = "Center", Position = { 230, 400 }, Size = { 55, 17 }
  })
  table.insert(graphics, {
    Type = "Label", Text = "State",
    Color = { 170, 170, 170 }, Font = "Roboto", FontSize = 10,
    HTextAlign = "Center", Position = { 290, 400 }, Size = { 110, 17 }
  })

  local aCount = math.floor(props["Analog Control Count"].Value)
  for i = 1, aCount do
    local rowY = 420 + (i - 1) * 40

    layout["Analog Name " .. i] = {
      PrettyName = "Analog " .. i .. "~Control Name",
      Style = "Text",
      Position = { 20, rowY },
      Size = { 115, 24 },
      FontSize = 11
    }

    layout["Analog Value " .. i] = {
      PrettyName = "Analog " .. i .. "~Value",
      Style = "Text",
      Position = { 140, rowY },
      Size = { 85, 24 },
      FontSize = 11
    }

    layout["Analog Send " .. i] = {
      PrettyName = "Analog " .. i .. "~Send",
      Style = "Button",
      ButtonVisualStyle = "Flat",
      Position = { 230, rowY },
      Size = { 55, 24 },
      Color = { 60, 120, 200 },
      Legend = "Send",
      FontSize = 11,
      CornerRadius = 4
    }

    layout["Analog State " .. i] = {
      PrettyName = "Analog " .. i .. "~State",
      Style = "Text",
      Position = { 290, rowY },
      Size = { 110, 24 },
      FontSize = 10
    }
  end

  -- Build version
  table.insert(graphics, {
    Type = "Label",
    Text = "v" .. PluginInfo.BuildVersion,
    Color = { 100, 100, 100 },
    Font = "Roboto",
    FontSize = 9,
    HTextAlign = "Left",
    Position = { 10, 612 },
    Size = { 100, 16 }
  })

elseif CurrentPage == "Setup" then
  -- Plugin background
  table.insert(graphics, {
    Type = "GroupBox",
    Fill = { 35, 35, 35 },
    StrokeColor = { 35, 35, 35 },
    StrokeWidth = 0,
    CornerRadius = 0,
    Position = { 0, 0 },
    Size = { 420, 630 },
    ZOrder = -10
  })

  -- Connection Settings section
  table.insert(graphics, {
    Type = "GroupBox",
    Text = "Connection Settings",
    Fill = { 55, 55, 55 },
    Color = { 221, 221, 221 },
    StrokeColor = { 80, 80, 80 },
    StrokeWidth = 1,
    CornerRadius = 8,
    Font = "Roboto",
    FontSize = 11,
    Position = { 10, 10 },
    Size = { 400, 135 },
    ZOrder = -5
  })

  table.insert(graphics, {
    Type = "Label", Text = "IP Address",
    Color = { 200, 200, 200 }, Font = "Roboto", FontSize = 11,
    HTextAlign = "Right", Position = { 20, 38 }, Size = { 85, 20 }
  })
  layout["IPAddress"] = {
    PrettyName = "Connection~IP Address",
    Style = "Text",
    Position = { 110, 36 },
    Size = { 175, 24 },
    FontSize = 11,
    CornerRadius = 4
  }

  table.insert(graphics, {
    Type = "Label", Text = "Username",
    Color = { 200, 200, 200 }, Font = "Roboto", FontSize = 11,
    HTextAlign = "Right", Position = { 20, 70 }, Size = { 85, 20 }
  })
  layout["Username"] = {
    PrettyName = "Connection~Username",
    Style = "Text",
    Position = { 110, 68 },
    Size = { 150, 24 },
    FontSize = 11,
    CornerRadius = 4
  }

  table.insert(graphics, {
    Type = "Label", Text = "Password",
    Color = { 200, 200, 200 }, Font = "Roboto", FontSize = 11,
    HTextAlign = "Right", Position = { 20, 102 }, Size = { 85, 20 }
  })
  layout["Password"] = {
    PrettyName = "Connection~Password",
    Style = "Text",
    Position = { 110, 100 },
    Size = { 150, 24 },
    FontSize = 11,
    CornerRadius = 4
  }

  layout["Test Connection"] = {
    PrettyName = "Connection~Test Connection",
    Style = "Button",
    ButtonVisualStyle = "Flat",
    Position = { 275, 100 },
    Size = { 120, 24 },
    Color = { 60, 120, 200 },
    Legend = "Test Connection",
    FontSize = 11,
    CornerRadius = 4
  }

  -- Device Info section
  table.insert(graphics, {
    Type = "GroupBox",
    Text = "Device Info",
    Fill = { 55, 55, 55 },
    Color = { 221, 221, 221 },
    StrokeColor = { 80, 80, 80 },
    StrokeWidth = 1,
    CornerRadius = 8,
    Font = "Roboto",
    FontSize = 11,
    Position = { 10, 155 },
    Size = { 400, 90 },
    ZOrder = -5
  })

  table.insert(graphics, {
    Type = "Label", Text = "Device Name",
    Color = { 200, 200, 200 }, Font = "Roboto", FontSize = 11,
    HTextAlign = "Right", Position = { 20, 183 }, Size = { 85, 20 }
  })
  layout["DeviceName"] = {
    PrettyName = "Device~Device Name",
    Style = "Text",
    Position = { 110, 181 },
    Size = { 285, 24 },
    FontSize = 11
  }

  table.insert(graphics, {
    Type = "Label", Text = "Firmware",
    Color = { 200, 200, 200 }, Font = "Roboto", FontSize = 11,
    HTextAlign = "Right", Position = { 20, 213 }, Size = { 85, 20 }
  })
  layout["DeviceFirmware"] = {
    PrettyName = "Device~Firmware Version",
    Style = "Text",
    Position = { 110, 211 },
    Size = { 285, 24 },
    FontSize = 11
  }

  -- Debug section
  table.insert(graphics, {
    Type = "GroupBox",
    Text = "Debug",
    Fill = { 55, 55, 55 },
    Color = { 221, 221, 221 },
    StrokeColor = { 80, 80, 80 },
    StrokeWidth = 1,
    CornerRadius = 8,
    Font = "Roboto",
    FontSize = 11,
    Position = { 10, 255 },
    Size = { 400, 55 },
    ZOrder = -5
  })

  table.insert(graphics, {
    Type = "Label", Text = "Debug Print",
    Color = { 200, 200, 200 }, Font = "Roboto", FontSize = 11,
    HTextAlign = "Right", Position = { 20, 278 }, Size = { 85, 20 }
  })
  layout["Debug Print"] = {
    PrettyName = "Debug~Debug Print",
    Style = "Button",
    ButtonVisualStyle = "Flat",
    Position = { 110, 276 },
    Size = { 90, 24 },
    Color = { 200, 140, 0 },
    OffColor = { 80, 80, 80 },
    UnlinkOffColor = true,
    Legend = "Debug On",
    FontSize = 11,
    CornerRadius = 4
  }

  -- Properties reference note
  table.insert(graphics, {
    Type = "Label",
    Text = "HTTP Port, HTTPS, control counts, and poll interval are configured in Plugin Properties.",
    Color = { 130, 130, 130 },
    Font = "Roboto",
    FontSize = 10,
    HTextAlign = "Left",
    Position = { 20, 325 },
    Size = { 380, 30 }
  })

  -- Build version
  table.insert(graphics, {
    Type = "Label",
    Text = "v" .. PluginInfo.BuildVersion,
    Color = { 100, 100, 100 },
    Font = "Roboto",
    FontSize = 9,
    HTextAlign = "Left",
    Position = { 10, 612 },
    Size = { 100, 16 }
  })

end
