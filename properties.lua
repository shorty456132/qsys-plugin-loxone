table.insert(props, {
  Name = "HTTP Port",
  Type = "integer",
  Min = 1,
  Max = 65535,
  Value = 80
})

table.insert(props, {
  Name = "Use HTTPS",
  Type = "boolean",
  Value = false
})

table.insert(props, {
  Name = "Digital Control Count",
  Type = "integer",
  Min = 0,
  Max = 8,
  Value = 4
})

table.insert(props, {
  Name = "Analog Control Count",
  Type = "integer",
  Min = 0,
  Max = 4,
  Value = 2
})

table.insert(props, {
  Name = "Poll Interval",
  Type = "integer",
  Min = 1,
  Max = 60,
  Value = 5
})
