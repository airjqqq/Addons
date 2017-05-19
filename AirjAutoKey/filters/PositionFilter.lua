local filterName = "PositionFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName)
local color = "7FBFFF"
local L = setmetatable({},{__index = function(t,k) return k end})

function F:OnInitialize()
  self:RegisterFilter("AAKFASTMOVE",L["Fast Move"],{
    name = {},
    value = {},
    greater = {},
  })
  self:RegisterFilter("AAKFASTCORPSE",L["Move Corpse"],{
    name = {},
  })
  self:RegisterFilter("AAKMSTUCKED",L["Stucked"],{
    name = {},
    value = {},
    greater = {},
  })
  self:RegisterFilter("DISTACETONEAREST",L["To UID"],{
    name = {},
    value = {},
    greater = {},
  })
  self:RegisterFilter("SAMEANGLE",L["Sidewinders"],{
    name = {name = "from unit"},
    unit = {},
  })
  self:RegisterFilter("HANGLE",L["Face Angle(Deg)"],{
    value = {},
    greater = {},
    unit = {},
  })
  self:RegisterFilter("TANGLE",L["Target Angle(Deg)"],{
    value = {},
    greater = {},
    unit = {},
  })
  self:RegisterFilter("HFRONTLINE",L["Front Width"],{
    value = {},
    greater = {},
    unit = {},
  })
  self:RegisterFilter("HFRONTLINER",L["Front Length"],{
    value = {},
    greater = {},
    unit = {},
  })
  self:RegisterFilter("HFRONTTRAP",L["Front Trap"],{
    name = {},
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
  self:RegisterFilter("FOLLOWRANGE",L["Follow Range"],{
    value = {},
    greater = {},
  })
  self:RegisterFilter("NEARESTRANGE",L["Nearest Range"],{
    value = {},
    greater = {},
  })
  self:RegisterFilter("CENTERRANGE",L["Center Range"],{
    value = {},
    greater = {},
    unit = {name="Center Unit"},
    name = {name="Edge Unit"},
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
  self:RegisterFilter("INCIRCLE",L["InCircle"],{
    value = {},
    greater = {},
    unit = {},
    name = {name="x|y|z"},
  })
  -- self:RegisterFilter("FOLLOWRANGE",L["Follow Range"],{
  --   value = {},
  --   greater = {},
  -- })
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

function F:AAKFASTCORPSE(filter)
  local h = filter.name and filter.name[1]
  local cx,cy = GetCorpseMapPosition()
  if cx and cy then
    local mapId = GetCurrentMapAreaID()
    local _,_,_,l,r,t,b = GetAreaMapInfo(mapId)
    l = -l
    r = -r
    cx = l+(r-l)*cx
    cy = t+(b-t)*cy
    AirjMove:MoveTo({cx,cy,-10000},h)
    return true
  end
end

function F:AAKFASTMOVE(filter)

  local uid = Core:ToKeyTable(filter.name)
  if AirjMove:CheckStuckedTime(5)>2 then
    local lu = AirjMove.lastNearestUid
    local lg = AirjMove.lastNearestGuid
    if lu and lg then
      AirjMove.ignores[lu][lg] = true
    end
  end
  local g,u,d = AirjMove:MoveToNearest(uid,1)
  if g then
    AirjMove.isCruise = false
    AirjHack:Interact(g)
  end
  return d
end
function F:AAKMSTUCKED(filter)

  return AirjMove:CheckStuckedTime(filter.name[1])
end
function F:DISTACETONEAREST(filter)
  local guids = AirjHack:GetObjects()
  local uid = Core:ToKeyTable(filter.name or {})
  local ignore
  local ignoreName = filter.name[1]
  if type(ignoreName) == "string" then
    ignore = _G[ignoreName]
  end
	local targetguid=UnitGUID("target")
	local playerGUID = UnitGUID("player")
	local minDistance,minDistanceGUID,minDistancePoint
	for guid,t in pairs(guids) do
    if not ignore or not ignore[guid] then
  		local ot,_,_,_,oid = AirjHack:GetGUIDInfo(guid)
  		if ot == "Creature" or ot == "GameObject" then
  			if uid and uid[oid] then
          local mignore = AirjMove.ignores[oid]
          if not mignore or not mignore[guid] then
    				local x1,y1,z1,_,distance = AirjCache:GetPosition(guid)
    				if distance then
    					if not minDistance or distance<minDistance then
    						minDistance = distance
    						minDistanceGUID = guid
    						minDistancePoint = {x1,y1,z1}
    					end
    				end
          end
  			end
      end
		end
	end
  return minDistance
end

function angle(guid)

  local pguid = Cache:PlayerGUID()
  local px,py,pz,f = Cache:GetPosition(pguid)
  local x,y,z,_,d = Cache:GetPosition(guid)
  if not x then return 180 end
  local dx,dy,dz = x-px, y-py, z-pz

  local angle = math.atan2(dy,dx)
  return  angle,d
end

function F:SAMEANGLE(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  filter.name = filter.name or {"target"}
  local guid2 = Cache:UnitGUID(filter.name[1])
  if not guid or not guid2 then return end
  local a1,d1 = angle(guid)
  local a2,d2 = angle(guid2)
  local angle = a1-a2
  angle = angle%(2*pi)
  if angle > pi then
    angle = 2*pi - angle
  end
  if d1 <= 1.5 then return true end
  local ea = math.asin(1.5/d1)
  -- print(angle,ea)
  angle = angle - ea
  -- angle = math.abs(angle)
  if angle*180/pi>30 then return false end
  if d1*math.cos(angle) >d2+8 then
    return false
  end
  return true
end
function F:HANGLE(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  local pguid = Cache:PlayerGUID()
  local px,py,pz,f = Cache:GetPosition(pguid)
  local x,y,z,_,d,s = Cache:GetPosition(guid)
  if not x then return 180 end
  if d<s then return 0 end
  local dx,dy,dz = x-px, y-py, z-pz

  local angle = math.atan2(dy,dx)
  angle = angle - (f + pi/2)
  angle = angle%(2*pi)
  if angle > pi then
    angle = 2*pi - angle
  end
  local ea = math.asin(s/d)
  angle = angle - ea
  return angle*180/pi
end

function F:TANGLE(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  local pguid = Cache:PlayerGUID()
  local px,py,pz = Cache:GetPosition(pguid)
  local x,y,z,f = Cache:GetPosition(guid)
  if not x then return 180 end
  local dx,dy,dz = x-px, y-py, z-pz

  local angle = math.atan2(dy,dx)

  angle = angle - (f + pi/2)
  if angle < -pi then
    angle = angle + 2*pi
  elseif angle > pi then
    angle = angle - 2*pi
  end
  return 180-math.abs(angle*180/pi)
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
function F:HFRONTLINER(filter)
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
  return distance * math.cos(math.abs(angle))
end
function F:HFRONTTRAP(filter)
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
  local l = distance * math.cos(math.abs(angle))
  local w = distance * math.sin(math.abs(angle))
  local x1,y1,x2,y2 = unpack(Core:ToValueTable(filter.name),1,4)
  if l<y1 or l>y2 then
    return false
  end
  local x = (l-y1)/(y2-y1)*(x2-x1)+x1
  -- print(x,w)
  return w<x
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
function F:FOLLOWRANGE(filter)
  local d = AirjMove.targetDistance
  return d
end
function F:NEARESTRANGE(filter)
  local d = AirjMove.lastNearestDistance
  local guids = AirjHack:GetObjects()
  local guid = AirjMove.lastNearestGuid
  if guids[guid] then
    if GetTime() - AirjMove.lastNearestTime < 15 then
      return d
    end
  end
end
function F:CENTERRANGE(filter)
  filter.unit = filter.unit or "target"
  filter.name = filter.name or {"target"}
  filter.value = filter.value or 8
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
	local d = sqrt(dx*dx+dy*dy+dz*dz) -s2
  return d
end
function F:SRANGE(filter)
  filter.unit = filter.unit or "target"
  local name, rank, icon, castingTime, minRange, maxRange, spellID = Cache:Call("GetSpellInfo",filter.name[1])
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

function F:INCIRCLE(filter)
  filter.unit = filter.unit or "target"
  filter.value = filter.value or 15
  local x2,y2,z2 = Cache:GetPosition(Cache:PlayerGUID())
  --AirjCache:GetPosition(AirjCache:PlayerGUID())
  -- dump({"INCIRCLE",filter})
  filter.name = filter.name or x2 and {x2,y2,z2}
  -- local name = {x2,y2,z2}
  -- x2,y2,z2 = unpack(Core:ToValueTable(filter.name),1,3)
  -- if not y2 or y2 == "" then
  --   filter.name = name
  -- end
  local guid1 = Cache:UnitGUID(filter.unit)
  local x1,y1,z1,_,distance = Cache:GetPosition(guid1)
  if not x1 then return FAR_AWAY end
  if not x2 or not y2 then return FAR_AWAY end
	local dx,dy,dz = x1-x2, y1-y2, z1-z2
	local d = sqrt(dx*dx+dy*dy+dz*dz)
  return d
end

-- function F:FOLLOWRANGE(filter)
--   filter.value = filter.value or 0
--   local value = AirjMove.targetDistance
--   return value or false
-- end
