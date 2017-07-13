local Core = AirjAVR



--Common
--[[
{
  color = "string" or {r,g,b},
  alpha = 0.5,
  start = now,
  removes = now + 5,
}
]]

--[[
{
  fromUnit = "player",
  toUnit = "target",
  fromGUID = "overwrite fromUnit",
  toGUID = "overwrite fromUnit",
  width = 5,
  lenght = nil,
  classColor = nil,
}
]]
function Core:CreateBeam(data)
  local now = GetTime()
  data.type = "Beam"
  data.fromUnit = data.fromUnit or data.fromGUID == nil and "player"
  data.toUnit = data.toUnit or data.toGUID == nil and "target"
  data.width = data.width or 5
  data.removes = data.removes or now + 3600
  return self:AddData(data)
end

--[[
{
  unit = "target",
  guid = nil,
  radius = 8,
  duration = 5,
  expires = now + 5,
  spellId = nil,
  text = nil,
  suffix = nil,
  reverse = true,
}
]]
function Core:CreateCooldown(data)
  local now = GetTime()
  data.type = "Cooldown"
  data.unit = data.unit or data.guid == nil and "target"
  data.radius = data.radius or 8
  data.duration = data.duration or 5
  data.expires = data.expires or now + data.duration
  data.removes = data.removes or data.expires
  data.reverse = data.reverse == nil and true or data.reverse
  return self:AddData(data)
end
