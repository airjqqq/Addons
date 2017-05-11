local filterName = "BuffFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName)
local color = "7FFF7F"
local L = setmetatable({},{__index = function(t,k) return k end})

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

function F:OnInitialize()
  self:RegisterFilter("BUFF",L["Buff"],nil,{
    COUNT = L["Count"],
    START = L["From start"],
    OBSERV = L["Obsorb (value2)"],
    OBSERV1 = L["Obsorb (value1)"],
  })
  self:RegisterFilter("BUFFSELF",L["Buff (mine)"],nil,{
    COUNT = L["Count"],
    START = L["From start"],
    OBSERV = L["Obsorb (value2)"],
  })
  self:RegisterFilter("DEBUFF",L["Debuff"],nil,{
    COUNT = L["Count"],
    -- DOT = L["Dot"],
    START = L["From start"],
    NUMBER = L["Damage (value2)"],
  })

  self:RegisterFilter("DEBUFFSELF",L["Debuff (mine)"],nil,{
    COUNT = L["Count"],
    START = L["From start"],
    NUMBER = L["Damage (value2)"],
  })
  self:RegisterFilter("DTYPE",L["Debuff Dispel Type"])
  self:RegisterFilter("DEBUFFDOT",L["Dot"],{unit={},greater={},value={}})
  self:RegisterFilter("CANSTEAL",L["Stealable Buff"],{
    value = {},
    greater = {},
    unit= {},
  },{
    COUNT = L["Count"],
  })
end

-- no buff ~= value<=0 any more
function F:BUFF(filter)
  assert(filter.name)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local spells = Core:ToKeyTable(filter.name)
  local buffs = Cache:GetBuffs(guid,filter.unit,spells)
  local t = GetTime()
  for i,v in pairs(buffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local value
    if filter.subtype == "COUNT" then
      value = count
    elseif filter.subtype == "START" then
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (t-expires+duration)/timeMod
      end
    elseif filter.subtype == "OBSERV" then
      value = value2
    elseif filter.subtype == "OBSERV1" then
      value = value1
    else
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (expires - t)/timeMod
      end
    end
    if Core:MatchValue(value,filter) then
      return true
    end
  end
  return false
end

function F:BUFFSELF(filter)
  assert(filter.name)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local spells = Core:ToKeyTable(filter.name)
  local buffs = Cache:GetBuffs(guid,filter.unit,spells,true)
  local t = GetTime()
  for i,v in pairs(buffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local value
    if filter.subtype == "COUNT" then
      value = count
    elseif filter.subtype == "START" then
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (t-expires+duration)/timeMod
      end
    elseif filter.subtype == "OBSERV" then
      value = value2
    else
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (expires - t)/timeMod
      end
    end
    if Core:MatchValue(value,filter) then
      return true
    end
  end
  return false
end

-- no buff ~= value<=0 any more
function F:DEBUFF(filter)
  assert(filter.name)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local spells = Core:ToKeyTable(filter.name)
  local debuffs = Cache:GetDebuffs(guid,filter.unit,spells)
  local t = GetTime()
  for i,v in pairs(debuffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local value
    if filter.subtype == "COUNT" then
      value = count
    elseif filter.subtype == "START" then
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (t-expires+duration)/timeMod
      end
    elseif filter.subtype == "DOT" then
      local tooltip = v.tooltip
      value = 0
			if tooltip then
				local t,d,s = tooltip:match("每(%d+)秒.+(%d+)点(.*)伤害")
        if t and d then
          t = tonumber(t)
          d = tonumber(d)
          if t and d then
            value = d/t
          end
        end
			end
    elseif filter.subtype == "NUMBER" then
      value = value2
    else
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (expires - t)/timeMod
      end
    end
    if Core:MatchValue(value,filter) then
      return true
    end
  end
  return false
end

function F:DEBUFFDOT(filter)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local debuffs = Cache:GetDebuffs(guid,filter.unit)
  local t = GetTime()
  local totalDPS = 0
  for i,v in pairs(debuffs) do
    local tooltip = v.tooltip
		if tooltip then
			local t,d,s = tooltip:match("每(%d+)秒[^%d]+(%d+)点(.*)伤害")
      -- print(t,d, tooltip)
      if t and d then
        t = tonumber(t)
        d = tonumber(d)
        if t and d then
          totalDPS = totalDPS + d/t
        end
      end
		end
  end
  return totalDPS
end

function F:DEBUFFSELF(filter)
  assert(filter.name)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local spells = Core:ToKeyTable(filter.name)
  local debuffs = Cache:GetDebuffs(guid,filter.unit,spells,true)
  local t = GetTime()
  for i,v in pairs(debuffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local value
    if filter.subtype == "COUNT" then
      value = count
    elseif filter.subtype == "START" then
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (t-expires+duration)/timeMod
      end
    elseif filter.subtype == "NUMBER" then
      value = value2
    else
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (expires - t)/timeMod
      end
    end
    if Core:MatchValue(value,filter) then
      return true
    end
  end
  return false
end

function F:DTYPE(filter)
  filter.name = filter.name or {"Magic","Curse","Poison","Disease"}
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local debuffs = Cache:GetDebuffs(guid,filter.unit)
  local t = GetTime()
  local types = Core:ToKeyTable(filter.name)
  for i,v in pairs(debuffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    if dispelType and types[dispelType] then
      local value = (expires - t)/timeMod
      if Core:MatchValue(value,filter) then
        return true
      end
    end
  end
  return false
end

function F:CANSTEAL(filter)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local debuffs = Cache:GetBuffs(guid,filter.unit)
  local t = GetTime()
  if filter.subtype == "COUNT" then
    local buffcount = 0
    for i,v in pairs(debuffs) do
      local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)

      if dispelType == "Magic" or isStealable then
        if expires - t > 0 then
          buffcount = buffcount + 1
        end
      end
    end
    return buffcount
  else
    for i,v in pairs(debuffs) do
      local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
      if dispelType == "Magic" or isStealable then
        local value = (expires - t)/timeMod
        if Core:MatchValue(value,filter) then
          return true
        end
      end
    end
    return false
  end
end
