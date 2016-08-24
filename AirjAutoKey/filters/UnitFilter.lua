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
