local F = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyUtilFilter")
local Cache
function OnInitialize()
  Cache = AirjAutoKeyCache
end
function F:CD(filter)
  assert(type(filter.name)=="number")
  local value = Cache:GetSpellCooldown(filter.name)
  return value
end

function F:ICD(filter)
  assert(type(filter.name)=="number")
  local start, duration,enable = Cache:Call("GetItemCooldown",filter.name)
  local value = not start and 300 or enable and 0 or (duration - (GetTime() - start))
  return value
end

function F:CHARGE(filter)
  assert(type(filter.name)=="number")
  local _,value = Cache:GetSpellCooldown(filter.name)
  return value
end

function F:KNOWS(filter)
  assert(type(filter.name)=="number")
  local _,_,value = Cache:GetSpellCooldown(filter.name)
  return value
end

function F:CSPELL(filter)
  assert(filter.name)
  local keys = self:ToKeyTable(filter.name)
  for k,v in pairs(keys) do
    local spellName = Cache:Call("GetSpellInfo",k)
    if Cache:Call("IsCurrentSpell",spellName) then
      local castName = Cache:Call("UnitCastingInfo","player")
      local channelName = Cache:Call("UnitChannelInfo","player")
      if spellName ~= castName and spellName ~= channelName then
        return true
      end
    end
  end
  return false
end
