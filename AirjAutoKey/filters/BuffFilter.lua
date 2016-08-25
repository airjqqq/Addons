local F = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyBuffFilter")
local Cache

function OnInitialize()
  Cache = AirjAutoKeyCache
end

function F:BUFF(filter)
  assert(filter.name)
  local buffs = 
