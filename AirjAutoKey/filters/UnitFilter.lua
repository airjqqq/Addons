local Core = AceAddon:GetAddon("AirjAutoKey")
local Cache = Core:GetModule("AirjAutoKeyCache")
local Filter = Core:GetModule("AirjAutoKeyFilter")

local F = Filter:NewModule("AirjAutoKeyUnitFilter")

function OnInitialize()
end

function F:UNITEXISTS(filter)
  assert(not filter.subtype or _G[filter.subtype])
  filter.unit = filter.unit or "target"
  if not Cache:Call("UnitExists",filter.unit) return false end
  if not filter.subtype then return true end
  return Cache:Call(filter.subtype,"player",filter.unit) and true or false
end
function F:ISPLAYER(filter)
  filter.unit = filter.unit or "target"
  return Cache:Call("UnitIsPlayer",filter.unit) and true or false
end

function F:ISPLAYERCTRL(filter)
  filter.unit = filter.unit or "target"
  return Cache:Call("UnitPlayerControlled",filter.unit) and true or false
end

function F:ISINRAID(filter)
  filter.unit = filter.unit or "target"
  return (Cache:Call("UnitInRaid",filter.unit) or Cache:Call("UnitInParty",filter.unit)) and true or false
end

function F:CLASS(filter)
  filter.unit = filter.unit or "target"
  assert(filter.name)
  local classes = Core:ToKeyTable(filter.name)
  local _,class = Cache:Call("UnitClass",filter.unit)
  return classes[class] or false
end

function F:UNITISTANK(filter)
  return true
end

function F:UNITISMELEE(filter)
  return true
end

function F:UNITISHEALER(filter)
  return true
end

function F:SPEED(filter)
  filter.unit = filter.unit or "player"
  local speed = Cache:Call("GetUnitSpeed",filter.unit)
  return speed
end

function F:UNITISUNIT(filter)
  filter.name = filter.name or "player"
  local units = Core:ToKeyTable(filter.name)
  for k,v in pairs(units) do
    local unit2 = Core:ParseUnit(k)
    if Cache:Call("UnitIsUnit",unit2,filter.unit) then
      return true
    end
  end
  return false
end

function F:UNITNAME(filter)
  local names = Core:ToKeyTable(filter.name)
  for name,v in pairs(names) do
    if Cache:Call("UnitName",filter.unit) == name then
      return true
    end
  end
  return false
end

function F:CASTING(filter)
  filter.unit = filter.unit or "player"
  local castName, _, _, _, startTime, endTime = Cache:Call("UnitCastingInfo",filter.unit)
  if not castName then
    castName, _, _, _, startTime, endTime = Cache:Call("UnitChannelInfo",filter.unit)
  end
  if not castName then return 0 end
  local match
  if filter.name then
    local names = Core:ToKeyTable(filter.name)
    for k,v in pairs(names) do
      local name = Cache:Call("GetSpellInfo",k)
      if name == castName then
        match = true
        break
      end
    end
  else
    match = true
  end
  if match then
    if filter.subtype == "START" then
      return GetTime()-startTime/1000
    else
      return endTime/1000-GetTime()
    end
  else
    return 0
  end
end


function F:CASTINGCHANNEL(filter)
  filter.unit = filter.unit or "player"
  local castName, _, _, _, startTime, endTime = Cache:Call("UnitChannelInfo",filter.unit)
  if not castName then return 0 end
  local match
  if filter.name then
    local names = Core:ToKeyTable(filter.name)
    for k,v in pairs(names) do
      local name = Cache:Call("GetSpellInfo",k)
      if name == castName then
        match = true
        break
      end
    end
  else
    match = true
  end
  if match then
    if filter.subtype == "START" then
      return GetTime()-startTime/1000
    else
      return endTime/1000-GetTime()
    end
  else
    return 0
  end
end

function F:CASTINGINTERRUPT(filter)
  filter.unit = filter.unit or "player"
  local castName, _, _, _, startTime, endTime_,_,notInterruptible = Cache:Call("UnitCastingInfo",filter.unit)
  if not castName then
    castName, _, _, _, startTime, endTime_,notInterruptible = Cache:Call("UnitChannelInfo",filter.unit)
  end
  if not castName or notInterruptible then return 0 end
  local match
  if filter.name then
    local names = Core:ToKeyTable(filter.name)
    for k,v in pairs(names) do
      local name = Cache:Call("GetSpellInfo",k)
      if name == castName then
        match = true
        break
      end
    end
  else
    match = true
  end
  if match then
    if filter.subtype == "START" then
      return GetTime()-startTime/1000
    else
      return endTime/1000-GetTime()
    end
  else
    return 0
  end
end

function F:HTIME(filter)
  filter.unit = filter.unit or "player"
  assert(type(filter.name)=="number")
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 0 end
  local t = GetTime()
  local array = Cache:GetHealthArray(guid)
  for i,v in ipairs(array) do
    local health, max, prediction, absorb, healAbsorb = unpack(v)
    if not health or health/maxHealth>filter.name then
      return t-v.t
    end
  end
  return 120
end

function F:ISDEAD(filter)
  filter.unit = filter.unit or "player"
  return Cache:Call("UnitIsDeadOrGhost",filter.unit)
end

function F:HEALTH(filter)
  filter.name = filter.name or {"perdiction","absorb","healAbsorb"}
  filter.unit = filter.unit or "player"
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 0 end
  local health, max, prediction, absorb, healAbsorb, isdead = unpack(Cache:GetHealth(guid) or {})
  if not health then return 0 end
  local types = Core:ToKeyTable(filter.name)
  if type.perdiction then
    health = health + perdiction
  end
  if type.absorb then
    health = health + absorb
  end
  if type.healAbsorb then
    health = health - healAbsorb
  end
  local toRet = health
  if filter.subtype == "ABS" then
  else
    toRet = health/max
  end
  return toRet
end


--{"mana","race","focus","energy","combo point","rune","rune power","soul shards",nil,"holy power",nil,nil,nil,"chi"}

function F:POWER(filter)
  filter.unit = filter.unit or "player"
  local powerType = filter.subtype or Cache:Call("UnitPowerType",filter.unit)
  local power = Cache:Call("UnitPower",filter.unit,powerType)
  local filterValue = filter.value
  if filterValue<0 then
    local max = Cache:Call("UnitPowerMax",filter.unit,powerType)
    power = power - max
  else
    local scale = 1
    power = power/scale
  end
end
