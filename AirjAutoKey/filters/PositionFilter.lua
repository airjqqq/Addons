local F = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyPositionFilter")
local Cache
local pi = math.pi
local FAR_AWAY = 1000

function OnInitialize()
  Cache = AirjAutoKeyCache
end

function F:HANGLE(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:Call("UnitGUID",filter.unit)
  local pguid = Cache:Call("UnitGUID","player")
  local px,py,pz,f = Cache:GetPosition(pguid)
  local x,y,z = Cache:GetPosition(guid)
  if not x then return FAR_AWAY end
  local dx,dy,dz = x-px, y-py, z-pz

  local angle = math.atan2(dy,dx)
  angle = angle - f
  if angle < -pi then
    angle = angle + 2*pi
  elseif angle > pi then
    angle = angle - 2*pi
  end
  return math.abs(angle)
end
function F:HFRONTLINE(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:Call("UnitGUID",filter.unit)
  local pguid = Cache:Call("UnitGUID","player")
  local px,py,pz,f = Cache:GetPosition(pguid)
  local x,y,z,_,distance = Cache:GetPosition(guid)
  if not x then return FAR_AWAY end
  local dx,dy,dz = x-px, y-py, z-pz

  local angle = math.atan2(dy,dx)
  angle = angle - f
  if angle < -pi then
    angle = angle + 2*pi
  elseif angle > pi then
    angle = angle - 2*pi
  end
  if angle > pi/2 then
    return FAR_AWAY
  end
  return distance * math.sin(math.abs(angle))
end
function F:HDRANGE(filter)
  filter.unit = filter.unit or "target"
  filter.name = filter.name or "player"
  local unit2 = Core:ParseUnit(filter.name)

  local guid1 = Cache:Call("UnitGUID",filter.unit)
  local x1,y1,z1,_,distance = Cache:GetPosition(guid1)
  if not x1 then return FAR_AWAY end
  if unit2 == "player" then
    return distance or FAR_AWAY
  end
  local guid2 = Cache:Call("UnitGUID",unit2)
  local x2,y2,z2 = Cache:GetPosition(guid2)
  if not x2 then return FAR_AWAY end
	local dx,dy,dz = x1-x2, y1-y2, z1-z2
	local d = sqrt(dx*dx+dy*dy+dz*dz)
  return d
end
function F:SRANGE(filter)
  filter.unit = filter.unit or "target"
  assert(type(filter.name)=="number")
  local name, rank, icon, castingTime, minRange, maxRange, spellID = Cach:Call("GetSpellInfo",filter.name)
  if not maxRange then return false end
  local guid = Cache:Call("UnitGUID",filter.unit)
  local x,y,z,_,distance,size = Cache:GetPosition(guid)
  if not x then return false end
  if maxRange == 0 then maxRange = 1.33 end
  return distance < math.max(5,maxRange + size + 1.5)
end

function F:SRANGEAOE(filter)
  filter.unit = filter.unit or "target"
  assert(type(filter.name)=="number")
  local name, rank, icon, castingTime, minRange, maxRange, spellID = Cach:Call("GetSpellInfo",filter.name)
  if not maxRange then return false end
  local guid = Cache:Call("UnitGUID",filter.unit)
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
