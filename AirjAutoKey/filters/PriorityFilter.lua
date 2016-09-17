local filterName = "PriorityFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName)
local color = "7F7F3F"
local L = setmetatable({},{__index = function(t,k) return k end})

function F:OnInitialize()
  self:RegisterFilter("AIRTYPE",L["[P] Other Filter"],{name={}})
  self:RegisterFilter("AIRSPECIFICUNIT",L["[P] Specific Unit"],{name={},value={}})
  self:RegisterFilter("AIRRANGE",L["[P] Range (near)"])
  self:RegisterFilter("AIRLOWHEALTH",L["[P] Health (low)"])
  self:RegisterFilter("AIRBUFF",L["[P] Buff (short)"],{name={}})
  self:RegisterFilter("AIRDEBUFF",L["[P] Debuff (short)"],{name={}})
end

function F:RegisterFilter(key,name,keys,subtypes,c)
  assert(self[key])
  Core:RegisterFilter(key,{
    name = name,
    fcn = self[key],
    color = c or color,
    keys = keys or {},
    subtypes = subtypes,
    priority = true,
  })
end

function F:AIRTYPE(filter)
  local tfilter = Core:DeepCopy(filter)
  local names = Core:ToValueTable(filter.name)
  local type = tremove(names,1)
  tfilter.name = names
  tfilter.type = type
  local data = Core.filterTypes[type]
  if not data then error("no filter data found",1) end
  local fcn = data.fcn
  local value = fcn(Core,tfilter)
  return exp(-value)
end

function F:AIRSPECIFICUNIT(filter)
  filter.value = filter.value or 2
  filter.name = filter.name or "player"
  local unitKeys = Core:ToKeyTable(filter.name)
  local unit = Core:GetAirUnit()
  for u in pairs(unitKeys) do
    if Cache:Call("UnitIsUnit",unit) then
      return filter.value
    end
  end
end

function F:AIRRANGE(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local x,y,z,f,d,s = Cache:GetPosition(guid)
  return exp(-d)
end

function F:AIRLOWHEALTH(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return end
  local value = (health+absorb+healAbsorb)/max
  return exp(-value)
end

function F:AIRBUFF(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local spells = Core:ToKeyTable(filter.name)
  local buffs = Cache:GetBuffs(guid,filter.unit,spells,true)
  if #buffs == 0 then return end
  local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(buffs[1])
  if not name then return end
  local value
  if duration == 0 and expires ==0 then
    value = 1
  else
    value = (expires - GetTime())/100
  end
  return exp(-value)
end

function F:AIRDEBUFF(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local spells = Core:ToKeyTable(filter.name)
  local buffs = Cache:GetDebuffs(guid,unit,spells,true)
  if #buffs == 0 then return end
  local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(buffs[1])
  if not name then return end
  local value
  if duration == 0 and expires ==0 then
    value = 1
  else
    value = (expires - GetTime())/100
  end
  return exp(-value)
end
