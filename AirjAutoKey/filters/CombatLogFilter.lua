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
  self:RegisterFilter("LASTSPELLINTERVAL",L["Hit Combo"],{
    value = {},
    greater = {},
    name = {name="Spell ID"},
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
  assert(filter.name and #filter.name==1)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local list = Cache.cache.damageTo[guid]
  if not list then return 120 end
  local spellId = filter.name[1]
  list = list[spellId]
  if not list then return 120 end
  list = list.array
  if #list == 0 then return 120 end
  local lastT = list[#list].t
  return GetTime()-lastT
end

function F:BEHITEDCNT(filter)
  filter.unit = filter.unit or "player"
  filter.name = filter.name or {5}
  assert(filter.name and #filter.name==1)
	local time = filter.name[1]
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
  local array = to.array
  if not array then return 0 end
  local array = to.array
  if #array == 0 then return 0 end
  local last = array[#array]
  if not last then return 0 end
  local pguid = Cache:PlayerGUID()
  local castTo = Cache.cache.castSuccessTo[pguid]
  if castTo then
    castTo = castTo[spellId]
    if castTo and castTo.last and abs(castTo.last.t - last.t)>0.5 then
      return 0
    end
  end
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
  filter.name = filter.name or {5}
	local time = filter.name[1]
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
  filter.name = filter.name or {5}
	local time = filter.name[1]
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  if filter.subtype == "DIRECT" then
    return F:GetHealTakenDirect(guid,time)
  else
    return F:GetHealTaken(guid,time)
  end
end

function F:TIMETODIE(filter)
  filter.unit = filter.unit or "player"
  filter.name = filter.name or {5}
	local time = filter.name[1]
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return 3600 end
  if isdead then return 0 end
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
  assert(filter.name and #filter.name == 1 and type(filter.name[1])=="number")
	local spellID = filter.name[1]
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
  else
    guid = "last"
  end
  if not guid then return false end
  local data = Cache.cache.castSend[spellID]
  if not data then return 120 end
  data = data[guid]
  if not data then return 120 end
  return GetTime() - data.t
end

function F:CASTSTART(filter)
  assert(filter.name and #filter.name == 1 and type(filter.name[1])=="number")
	local spellID = filter.name[1]
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
  else
    guid = "last"
  end
  if not guid then return false end
  local data = Cache.cache.castStartTo[spellID]
  if not data then return 120 end
  data = data[guid]
  if not data then return 120 end
  return GetTime() - data.t
end

function F:CASTSUCCESSED(filter)
  assert(filter.name and #filter.name == 1 and type(filter.name[1])=="number")
	local spellID = filter.name[1]
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
  else
    guid = "last"
  end
  if not guid then return false end
  local pguid = Cache:PlayerGUID()
  local data = Cache.cache.castSuccessTo[pguid]
  if not data then return 120 end
  data = data[spellID]
  if not data then return 120 end
  data = data[guid]
  if not data then return 120 end
  return GetTime() - data.t
end

function F:AURANUM(filter)
  assert(filter.name and #filter.name == 1 and type(filter.name[1])=="number")
	local spellID = filter.name[1]
  local pguid = Cache:PlayerGUID()
  local data = Cache.cache.auraTo[pguid]
  local overTimeData
  if filter.subtype == "DOT" then
    overTimeData = Cache.cache.damageTo[pguid]
  elseif filter.subtype == "HOT" then
    overTimeData = Cache.cache.healTo[pguid]
  end
  if not data then return 0 end
  data = data[spellID]
  if overTimeData then overTimeData = overTimeData[spellID] end
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

function F:GetFutureDamagePVE(guid,time,futureTime)
  time = time or 5
  local damageBy = Cache.cache.damageBy[guid]
  if not damageBy then return {} end
  local t = GetTime()
  local debuffsBySpellName = {}
  local debuffs = Cache:GetDebuffs(guid)
  for i,v in ipairs(debuffs) do
    local name = v[1]
    debuffsBySpellName[name] = v
  end
  local periodicDamage = {}
  for i = #damageBy,1,-1 do
    local data = damageBy[i]
    if t-data.t>time then break end
    if data.periodic then -- periodic damage
      local timeLeft
      local spellName = data.spellName
      if periodicDamage[spellName] then
        if periodicDamage[spellName].first then
          periodicDamage[spellName].interval = periodicDamage[spellName].first-data.t
          periodicDamage[spellName].first = nil
        end
      else
        local debuff = debuffsBySpellName[spellName]
        if not debuff then
          timeLeft = 15
        else
          timeLeft = debuff[7] - t
          timeLeft = max(timeLeft,0)
        end
        periodicDamage[spellName] = {
          timeLeft = timeLeft,
          value = data.value,
          first = data.t,
        }
      end
    else -- directdamage
      -- do nothing
    end
  end
  futureTime = futureTime or 15
  local totalDamage = 0
  for i,data in pairs(periodicDamage) do
    local dps = data.value/(data.interval or max(1,t-data.first))
    totalDamage = dps* min(data.timeLeft,futureTime)
  end
  return totalDamage
end

local careSpellIds = {
  [205320] = true,
  [100784] = true,
  [113656] = true,
  [101546] = true,
  [101545] = true,
  [107428] = true,
  [117952] = true,
  [100780] = true,
  [115080] = true,
  [123986] = true,
  [115098] = true,
  [116847] = true,
  [152175] = true,
}

function F:LASTSPELLINTERVAL(filter)
  assert(filter.name and #filter.name == 1 and type(filter.name[1])=="number")
	local spellID = filter.name[1]
  local pguid = Cache:PlayerGUID()
  local data = Cache.cache.castSuccessTo[pguid]
  if not data then return 120 end
  local array = data.array
  local interval = 0
  for i=#array,1,-1 do
    local spellId = array[i].spellId
    if careSpellIds[spellId] then
      interval = interval + 1
    end
    if spellId == spellID then
      return interval
    end
  end
  return 120
end
