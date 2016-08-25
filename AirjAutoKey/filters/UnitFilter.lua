local F = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyUnitFilter")
local Cache

function OnInitialize()
  Cache = AirjAutoKeyCache
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
  local classes = self:ToKeyTable(filter.name)
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
  local units = AirjAutoKey:ToKeyTable(filter.name)
  for k,v in pairs(units) do
    local unit2 = self:ParseUnit(k)
    if Cache:Call("UnitIsUnit",unit2,filter.unit) then
      return true
    end
  end
  return false
end

function F:UNITNAME(filter)
  local names = AirjAutoKey:ToKeyTable(filter.name)
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
    local names = AirjAutoKey:ToKeyTable(filter.name)
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
    local names = AirjAutoKey:ToKeyTable(filter.name)
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
    local names = AirjAutoKey:ToKeyTable(filter.name)
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
