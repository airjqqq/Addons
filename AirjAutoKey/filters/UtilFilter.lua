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

function F:CANCAST(filter)
  local notMoving=(Cache:Call("GetUnitSpeed","player") == 0 and not Cache:Call("IsFalling"))
  if notMoving then return true end
  local guid = Cache:Call("UnitGUID","player")
  local buffs = Cache:GetBuffs(guid,"player",{[137587]=true})
  return #buffs > 0
end

function F:STARTMOVETIME(filter)
  local t = GetTime()
  for i,v in ipairs(Cache.cache.speed) do
    if v.value == 0 then
      return t-v.t
    end
  end
  return 120
end

function F:SPEEDTIME(filter)
  local t = GetTime()
  for i,v in ipairs(Cache.cache.speed) do
    if v.value ~= 0 then
      return t-v.t
    end
  end
  return 120
end

function F:STANCE(filter)
  return (filter.value or 0) == (Cache:Call("GetShapeshiftForm") or 0)
end
