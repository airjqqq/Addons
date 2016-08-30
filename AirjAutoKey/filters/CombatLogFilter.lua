local filterName = "CombatLogFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName)
local color = "BF7FFF"
local L = setmetatable({},{__index = function(t,k) return k end})

function F:OnInitialize()
  self:RegisterFilter("CHANNELDAMAGE",L["Since Last Damage"])
  self:RegisterFilter("BEHITEDCNT",L["Swing By"],{
    value = {},
    greater = {},
    name = {name="Scan Interval"},
    unit = {},
  })
  self:RegisterFilter("SPELLHITCNT",L["Spell Hited"],{
    value = {},
    greater = {},
    name = {name="Spell ID|Scan Interval"},
    unit = {},
  })
  self:RegisterFilter("DAMAGETAKEN",L["Damage Taken"],{
    value = {},
    greater = {},
    name = {name="Scan Interval"},
    unit = {},
  },{
    SWING = L["Swing"]
  })
  self:RegisterFilter("HEALTAKEN",L["Heal Taken"],{
    value = {},
    greater = {},
    name = {name="Scan Interval"},
    unit = {},
  },{
    DIRECT = L["Direct"]
  })
  self:RegisterFilter("TIMETODIE",L["Time To Die"],{
    value = {},
    greater = {},
    name = {name="Scan Interval"},
    unit = {},
  },{
    -- TIMETOFULL = L["Time To Full"]
    NOHEAL = L["Exclude Heal"],
    SWING = L["Swing[Exclude Heal]"],
    MAGIC = L["Magic[Exclude Heal]"],
  })
  self:RegisterFilter("LASTCASTSEND",L["Cast Send"],{
    value = {},
    greater = {},
    name = {name="Spell ID"},
    unit = {name="Unit, blank as anybody"},
  })
  self:RegisterFilter("CASTSTART",L["Cast Start"],{
    value = {},
    greater = {},
    name = {name="Spell ID"},
    unit = {name="Unit, blank as anybody"},
  })
  self:RegisterFilter("CASTSUCCESSED",L["Cast Success"],{
    value = {},
    greater = {},
    name = {name="Spell ID"},
    unit = {name="Unit, blank as anybody"},
  })
  self:RegisterFilter("AURANUM",L["Aura Number"],{
    value = {},
    greater = {},
    name = {name="Spell ID"},
  },{
    HOT = L["HOT"],
    DOT = L["DOT"],
  })
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
--LASTDAMAGEDONETIME
function F:CHANNELDAMAGE(filter)
  assert(filter.name and type(filter.name)=="number")
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local list = Cache.cache.damageTo[guid]
  if not list then return 120 end
  local spellId = filter.name
  list = list[spellId]
  if not list then return 120 end
  return GetTime()-list.last.t
end

function F:BEHITEDCNT(filter)
  filter.unit = filter.unit or "player"
	local time = tonumber(filter.name) or 5
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return 0 end
  local by = Cache.cache.damageBy[guid]
  if not by then return 0 end
  local array = by.array or {}
  local guids = {}
  local t = GetTime()
  local count = 0
  for i = #array,1,-1 do
  -- for i,v in ipairs(array) do
    local v = array[i]
    local eventTime,sourceGUID,spellId = v.t,v.guid,v.spellId
    if t-eventTime>time then
      break
    end
    if spellId=="Swing" then
      if not guids[sourceGUID] then
        guids[sourceGUID] = true
        local isdead = select(6,Cache:GetHealth(sourceGUID))
        if isdead == false then
          count = count + 1
        end
      end
    end
  end
  return count
end

function F:GetSpellHitCount(guid,spellId,time)
  local to = Cache.cache.damageTo[guid]
  if not to then return 0 end
  to = to[spellId]
  if not to then return 0 end
  local last = to.last
  if not last then return 0 end
  local pguid = Core:PlayerGUID()
  local castTo = Cache.cache.castSuccessTo[pguid]
  if castTo then
    castTo = castTo[spellId]
    if castTo and castTo.last and abs(castTo.last.t - last.t)>0.5 then
      return 0
    end
  end
  local array = to.array
  if not array then return 0 end
  local calculated = {}
  local count = 0
  local t = GetTime()
  for i = #array,1,-1 do
  -- for i,v in ipairs(array) do
    local v = array[i]
    if t - v.t > time then
      break
    end
    if abs(v.t - last.t)>0. then
      break
    end
    local guid = v.guid
    if not calculated[guid] then
      calculated[guid] = true
      local isdead = select(6,Cache:GetHealth(guid))
      if isdead == false then
        count = count + 1
      end
    end
  end
  return count
end

function F:SPELLHITCNT(filter)
  local spellId, time = unpack(Core:ToValueTable(filter.name))
  filter.unit = filter.unit or "player"
  assert(spellId)
	local time = time or 5
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  return F:GetSpellHitCount(guid,spellId,time)
end

function F:GetDamageTaken(guid,time)
  local by = Cache.cache.damageBy[guid]
  if not by then return 0 end
  local array = by.array or {}
  local t = GetTime()
  local total = 0
  for i = #array,1,-1 do
  -- for i,v in ipairs(array) do
    local v = array[i]
    local eventTime,sourceGUID,spellId,damage = v.t,v.guid,v.spellId,v.value
    if t-eventTime>time then
      break
    end
    total = total + damage
  end
  return total
end

function F:GetDamageTakenSwing(guid,time)
  local by = Cache.cache.damageBy[guid]
  if not by then return 0 end
  local array = by.array or {}
  local t = GetTime()
  local total = 0
  for i = #array,1,-1 do
  -- for i,v in ipairs(array) do
    local v = array[i]
    local eventTime,sourceGUID,spellId,damage = v.t,v.guid,v.spellId,v.value
    if t-eventTime>time then
      break
    end
    if "Swing" == spellId then
      total = total + damage
    end
  end
  return total
end

function F:DAMAGETAKEN(filter)
  filter.unit = filter.unit or "player"
	local time = tonumber(filter.name) or 5
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  if filter.subtype == "SWING" then
    return F:GetDamageTakenSwing(guid,time)
  else
    return F:GetDamageTaken(guid,time)
  end
end

function F:GetHealTaken(guid,time)
  local by = Cache.cache.healBy[guid]
  if not by then return 0 end
  local array = by.array or {}
  local t = GetTime()
  local total = 0
  for i = #array,1,-1 do
  -- for i,v in ipairs(array) do
    local v = array[i]
    local eventTime,sourceGUID,spellId,value = v.t,v.guid,v.spellId,v.value
    if t-eventTime>time then
      break
    end
    total = total + value
  end
  return total
end

function F:GetHealTakenDirect(guid,time)
  local by = Cache.cache.healBy[guid]
  if not by then return 0 end
  local array = by.array or {}
  local t = GetTime()
  local total = 0
  for i = #array,1,-1 do
  -- for i,v in ipairs(array) do
    local v = array[i]
    local eventTime,sourceGUID,spellId,value,periodic = v.t,v.guid,v.spellId,v.value,v.periodic
    if t-eventTime>time then
      break
    end
    if not periodic then
      total = total + value
    end
  end
  return total
end

function F:HEALTAKEN(filter)
  filter.unit = filter.unit or "player"
	local time = tonumber(filter.name) or 5
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  if filter.subtype == "DIRECT" then
    return F:GetHealTakenDirect(guid,time)
  else
    return F:GetHealTaken(guid,time)
  end
end

function F:TIMETODIE(filter)
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return 3600 end
  if isdead then return 0 end
	local time = tonumber(filter.name) or 5
  health = health + prediction + absorb
  if filter.subtype == "NOHEAL" then
    local damage = F:GetDamageTaken(guid,time)
    if damage == 0 then
      return 3600
    else
      return health/(damage)*time
    end
  elseif filter.subtype == "SWING" then
    local damage = F:GetDamageTakenSwing(guid,time)
    if damage == 0 then
      return 3600
    else
      return health/(damage)*time
    end
  elseif filter.subtype == "MAGIC" then
    local damage = F:GetDamageTakenMagic(guid,time)
    if damage == 0 then
      return 3600
    else
      return health/(damage)*time
    end
  else
    local damage = F:GetDamageTaken(guid,time)
    local heal = F:GetHealTaken(guid,time)
    if heal>=damage then
      return 3600
    else
      return health/(damage-heal)*time
    end
  end
end

function F:LASTCASTSEND(filter)
  assert(filter.name)
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
  else
    guid = "last"
  end
  if not guid then return false end
  local data = Cache.cache.castSend[filter.name]
  if not data then return 120 end
  data = data[guid]
  if not data then return 120 end
  return GetTime() - data.t
end

function F:CASTSTART(filter)
  assert(filter.name)
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
  else
    guid = "last"
  end
  if not guid then return false end
  local data = Cache.cache.castStartTo[filter.name]
  if not data then return 120 end
  data = data[guid]
  if not data then return 120 end
  return GetTime() - data.t
end
--Deprecated
function F:CASTSTARTALL(filter)
  assert(filter.name)
  local data = Cache.cache.castStartTo[filter.name]
  if not data then return 120 end
  data = data.last
  if not data then return 120 end
  return GetTime() - data.t
end

function F:CASTSUCCESSED(filter)
  assert(filter.name)
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
  else
    guid = "last"
  end
  if not guid then return false end
  local pguid = Core:PlayerGUID()
  local data = Cache.cache.castSuccessTo[pguid]
  if not data then return 120 end
  data = data[filter.name]
  if not data then return 120 end
  data = data[guid]
  if not data then return 120 end
  return GetTime() - data.t
end
--Deprecated
function F:ALLCASTSUCCESSED(filter)
  assert(filter.name)
  local pguid = Core:PlayerGUID()
  local data = Cache.cache.castSuccessTo[pguid]
  if not data then return 120 end
  data = data[filter.name]
  if not data then return 120 end
  data = data.last
  if not data then return 120 end
  return GetTime() - data.t
end

function F:AURANUM(filter)
  local pguid = Core:PlayerGUID()
  local data = Cache.cache.auraTo[pguid]
  local overTimeData
  if filter.subtype == "DOT" then
    overTimeData = Cache.cache.damageTo[pguid]
  elseif filter.subtype == "HOT" then
    overTimeData = Cache.cache.healTo[pguid]
  end
  if not data then return 0 end
  data = data[filter.name]
  if overTimeData then overTimeData = overTimeData[filter.name] end
  if not data then return 0 end
  if filter.subtype and not overTimeData then return 0 end
  local count = 0
  local t = GetTime()
  for k,v in pairs(data) do
    if k~="last" then
      if overTimeData then
        local d = overTimeData[k]
        if d and t-d.t<5 or t-v.t<5 then
          count = count + 1
        end
      else
        count = count + 1
      end
    end
  end
  return count
end
