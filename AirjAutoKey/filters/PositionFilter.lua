local filterName = "PositionFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName)
local color = "7FBFFF"
local L = setmetatable({},{__index = function(t,k) return k end})

function F:OnInitialize()
  self:RegisterFilter("HANGLE",L["Face Angle(Deg)"],{
    value = {},
    greater = {},
    unit = {},
  })
  self:RegisterFilter("HFRONTLINE",L["Front Width"],{
    value = {},
    greater = {},
    unit = {},
  })
  self:RegisterFilter("HDRANGE",L["Map Range"],{
    value = {},
    greater = {},
    unit = {name="To Unit"},
    name = {name="From Unit"},
  })
  self:RegisterFilter("EDGERANGE",L["Edge Range"],{
    value = {},
    greater = {},
    unit = {name="To Unit"},
    name = {name="From Unit"},
  })
  self:RegisterFilter("SRANGE",L["Spell In Range"],{
    unit = {},
    name = {name="Spell ID"},
  })
  self:RegisterFilter("SRANGEAOE",L["Spell AOE Range"],{
    unit = {},
    name = {name="Spell ID"},
  })
  self:RegisterFilter("RSRANGE",L["Spell In Range (API)"],{
    unit = {},
    name = {name="Spell ID"},
  })
end

function F:RegisterFilter(key,name,keys,subtypes)
  assert(self[key])
  Core:RegisterFilter(key,{
    name = name,
    fcn = self[key],
    color = color,
    keys = keys,
    subtypes = subtypes,
  })
end

local pi = math.pi
local FAR_AWAY = 1000

function F:HANGLE(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  local pguid = Cache:PlayerGUID()
  local px,py,pz,f = Cache:GetPosition(pguid)
  local x,y,z = Cache:GetPosition(guid)
  if not x then return 180 end
  local dx,dy,dz = x-px, y-py, z-pz

  local angle = math.atan2(dy,dx)

  angle = angle - (f + pi/2)
  if angle < -pi then
    angle = angle + 2*pi
  elseif angle > pi then
    angle = angle - 2*pi
  end
  return math.abs(angle*180/pi)
end
function F:HFRONTLINE(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  local pguid = Cache:PlayerGUID()
  local px,py,pz,f = Cache:GetPosition(pguid)
  local x,y,z,_,distance = Cache:GetPosition(guid)
  if not x then return FAR_AWAY end
  local dx,dy,dz = x-px, y-py, z-pz

  local angle = math.atan2(dy,dx)
  angle = angle - (f + pi/2)
  if angle < -pi then
    angle = angle + 2*pi
  elseif angle > pi then
    angle = angle - 2*pi
  end
  if angle > pi/2 or angle < -pi/2 then
    return FAR_AWAY
  end
  return distance * math.sin(math.abs(angle))
end
function F:HDRANGE(filter)
  filter.unit = filter.unit or "target"
  filter.name = filter.name or {"player"}
  local unit2 = filter.name[1]
  unit2 = Core:ParseUnit(unit2) or unit2

  local guid1 = Cache:UnitGUID(filter.unit)
  local x1,y1,z1,_,distance = Cache:GetPosition(guid1)
  if not x1 then return FAR_AWAY end
  if unit2 == "player" then
    return distance or FAR_AWAY
  end
  local guid2 = Cache:UnitGUID(unit2)
  local x2,y2,z2 = Cache:GetPosition(guid2)
  if not x2 then return FAR_AWAY end
	local dx,dy,dz = x1-x2, y1-y2, z1-z2
	local d = sqrt(dx*dx+dy*dy+dz*dz)
  return d
end
function F:EDGERANGE(filter)
  filter.unit = filter.unit or "target"
  filter.name = filter.name or {"player"}
  local unit2 = filter.name[1]
  unit2 = Core:ParseUnit(unit2) or unit2

  local guid1 = Cache:UnitGUID(filter.unit)
  local x1,y1,z1,_,distance,s1 = Cache:GetPosition(guid1)
  if not x1 then return FAR_AWAY end
  if unit2 == "player" then
    return distance and (distance-s1-1.5) or FAR_AWAY
  end
  local guid2 = Cache:UnitGUID(unit2)
  local x2,y2,z2,_,_,s2 = Cache:GetPosition(guid2)
  if not x2 then return FAR_AWAY end
	local dx,dy,dz = x1-x2, y1-y2, z1-z2
	local d = sqrt(dx*dx+dy*dy+dz*dz) - s1 -s2
  return d
end
function F:SRANGE(filter)
  filter.unit = filter.unit or "target"
  assert(type(filter.name)=="number")
  local name, rank, icon, castingTime, minRange, maxRange, spellID = Cache:Call("GetSpellInfo",filter.name)
  if not maxRange then return false end
  local guid = Cache:UnitGUID(filter.unit)
  local x,y,z,_,distance,size = Cache:GetPosition(guid)
  if not x then return false end
  if maxRange == 0 then maxRange = 1.33 end
  local maxPassed = distance < math.max(5,maxRange + size + 1.5)
  if not maxPassed then return false end
  if minRange>0 then
    if distance < minRange + size + 1.5 then
      return false
    end
  end
  return true
end
function F:SRANGEAOE(filter)
  filter.unit = filter.unit or "target"
  assert(type(filter.name)=="number")
  local name, rank, icon, castingTime, minRange, maxRange, spellID = Cach:Call("GetSpellInfo",filter.name)
  if not maxRange then return false end
  local guid = Cache:UnitGUID(filter.unit)
  local x,y,z,_,distance,size = Cache:GetPosition(guid)
  if not x then return false end
  if maxRange == 0 then maxRange = 8 end
  return distance < maxRange + size
end
function F:RSRANGE(filter)
  filter.unit = filter.unit or "target"
  assert(type(filter.name)=="number")
  local name, rank, icon, castingTime, minRange, maxRange, spellID = Cach:Call("GetSpellInfo",filter.name)
  return Cache:Call("IsSpellInRange",name,filter.unit) and true or false
end
