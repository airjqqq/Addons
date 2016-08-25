local F = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyCombatLogFilter")
local Cache

function OnInitialize()
  Cache = AirjAutoKeyCache
end

--LASTDAMAGEDONETIME
function F:CHANNELDAMAGE(filter)
  assert(filter.name and type(filter.name)=="number")
  filter.unit = filter.unit or "player"
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 120 end
  local list = Cache.cache.damageTo[guid]
  if not list then return 120 end
  local spellId = filter.name
  list = list[spellId]
  if not list then return 120 end
  return GetTime()-list.last.t
end
