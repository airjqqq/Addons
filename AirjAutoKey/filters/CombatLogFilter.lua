local filterName = "CombatLogFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName)
local color = "BF7FFF"
local L = setmetatable({},{__index = function(t,k) return k end})

function F:OnInitialize()
  self:RegisterFilter("DAMGETAKENSPELL",L["DT By Spell"])
  self:RegisterFilter("CHANNELDAMAGE",L["Since Last Damage"])
  self:RegisterFilter("CHANNELHEAL",L["Since Last Heal"])
  self:RegisterFilter("NEXTSWING",L["Next Swing"],{
    value = {},
    greater = {},
    unit = {},
  })
  self:RegisterFilter("DAMAGETAKEN",L["Damage Taken"],{
    value = {},
    greater = {},
    name = {name="Scan Interval"},
    unit = {},
  },{
    SWING = L["Swing"],
    DIRECT = L["Direct"],
    PERIODIC = L["Periodic"],
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
    PERIODIC = L["Periodic"],
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
  self:RegisterFilter("SINCECASTING",L["Since Casting"],{
    value = {},
    greater = {},
    name = {name="Spell ID, blank as anyspell"},
    unit = {name="Unit, blank as anybody"},
  })
  self:RegisterFilter("SINCECASTINGOTHERS",L["Other's Casting"],{
    value = {},
    greater = {},
    name = {name="Spell ID, blank as anyspell"},
    unit = {name=""},
  })
  self:RegisterFilter("CASTSUCCESSED",L["Cast Success"],{
    value = {},
    greater = {},
    name = {name="Spell ID"},
    unit = {name="Unit, blank as anybody"},
  })
  self:RegisterFilter("CASTSUCCESSEDBY",L["Casted By"],{
    value = {},
    greater = {},
    name = {name="Spell ID"},
    unit = {name="Unit, blank as anybody"},
  })
  self:RegisterFilter("CASTSUCCESSEDFROM",L["Casted From"],{
    value = {},
    greater = {},
    name = {name="Spell ID"},
    unit = {name="Unit, blank as anybody"},
  })
  self:RegisterFilter("CASTSUCCESSEDUNIT",L["Cast Unit"],{
    name = {name="Spell ID"},
    unit = {name="Unit, blank as anybody"},
  })
  self:RegisterFilter("SINCELASTCAST",L["Since Last Cast"],{
    unit = {},
    value = {},
    greater = {},
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

function F:DAMGETAKENSPELL(filter)
  -- filter.name
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  local toFind = {destGUID = guid,spellId = filter.name}
  local data = Cache.cache.damage:find(toFind,nil,nil,{t=GetTime()-(Core:ParseValue(filter.value) or 0)})
  if data then
    return GetTime() - data.t
  else
    return 120
  end
end

function F:CHANNELDAMAGE(filter)
  assert(filter.name and #filter.name==1)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  local toFind = {sourceGUID = guid,spellId = filter.name[1]}
  local data = Cache.cache.damage:find(toFind)
  if data then
    return GetTime() - data.t
  end
end
function F:CHANNELHEAL(filter)
  assert(filter.name and #filter.name==1)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  local toFind = {sourceGUID = guid,spellId = filter.name[1]}
  local data = Cache.cache.heal:find(toFind)
  if data then
    return GetTime() - data.t
  else
    return 120
  end
end

function F:NEXTSWING(filter)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local list = Cache.cache.damageTo[guid]
  if not list then return 0 end
  list = list.Swing
  if not list then return 0 end
  list = list.array
  if #list == 0 then return 0 end
  local lastT = list[#list].t
  local speed = UnitAttackSpeed(filter.unit)
  return speed - (GetTime()-lastT)
end

-- filter = {swing = true/false, magic = true/false, periodic = true/false}
function F:GetDamageTaken(guid,time,filter)
  local t = GetTime()
  local total = 0
  filter = filter or {}
  filter.destGUID = guid
  for v,k,i in Cache.cache.damage:iterator(filter) do
    if t-v.t>time then
      break
    end
    total = total+v.value
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
    return F:GetDamageTaken(guid,time,{swing=true})
  elseif filter.subtype == "DIRECT" then
    return F:GetDamageTaken(guid,time,{periodic=false})
  elseif filter.subtype == "PERIODIC" then
    return F:GetDamageTaken(guid,time,{periodic=true})
  else
    return F:GetDamageTaken(guid,time)
  end
end

function F:GetHealTaken(guid,time,filter)
  local t = GetTime()
  local total = 0
  filter = filter or {}
  filter.destGUID = guid
  for v,k,i in Cache.cache.heal:iterator(filter) do
    if t-v.t>time then
      break
    end
    total = total+v.value
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
    return F:GetHealTakenDirect(guid,time,{periodic=false})
  else
    return F:GetHealTaken(guid,time)
  end
end

function F:TIMETODIE(filter)
  filter.unit = filter.unit or "player"
  filter.name = filter.name or {5}
	local time = filter.name[1]
  if not Cache:Call("UnitAffectingCombat",filter.unit) and not IsResting() then
    return 120
  end
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
    local damage = F:GetDamageTaken(guid,time,{swing=true})
    if damage == 0 then
      return 3600
    else
      return health/(damage)*time
    end
  elseif filter.subtype == "MAGIC" then
    local damage = F:GetDamageTaken(guid,time,{magic=true})
    if damage == 0 then
      return 3600
    else
      return health/(damage)*time
    end
  elseif filter.subtype == "PERIODIC" then
    local damage = F:GetDamageTaken(guid,time,{periodic=true})
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
	local spellId = filter.name[1]
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
    if not guid then return false end
  end
  local data = Cache.cache.castSend:find({spellId=spellId,guid=guid})
  if not data then return 120 end
  return GetTime() - data.t
end

function F:CASTSTART(filter)
  assert(filter.name and #filter.name == 1 and type(filter.name[1])=="number")
	local spellId = filter.name[1]
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
    if not guid then return false end
  end
  local sourceGUID = AirjCache:PlayerGUID()
  local data = Cache.cache.castStart:find({spellId=spellId,destGUID=guid,sourceGUID=sourceGUID})
  if not data then return 120 end
  return GetTime() - data.t
end

function F:SINCECASTING(filter)

  local spellId = filter.name and filter.name[1]
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
    if not guid then return false end
  end
  local data = Cache.cache.casting:find({spellId=filter.name,guid=guid})
  if not data then return 120 end
  return GetTime() - data.endTime/1000
end
function F:SINCECASTINGOTHERS(filter)
  filter.unit = filter.unit or "target"
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
    if not guid then return false end
  end
  local data = Cache.cache.castingOthers:find({spellId=filter.name,guid=guid})
  if not data then return 120 end
  return GetTime() - data.endTime/1000
end

function F:CASTSUCCESSED(filter)
  assert(filter.name and #filter.name == 1 and type(filter.name[1])=="number")
	local spellId = filter.name[1]
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
    if not guid then return false end
  end
  local sourceGUID = AirjCache:PlayerGUID()
  local data = Cache.cache.castSuccess:find({spellId=spellId,destGUID=guid,sourceGUID=sourceGUID},nil,nil,{t=GetTime()-(Core:ParseValue(filter.value) or 0)})
  if not data then return 120 end
  return GetTime() - data.t
end
function F:CASTSUCCESSEDBY(filter)
  assert(filter.name)
	-- local spellId = filter.name[1]
  local guid
  if filter.unit then
    guid = Cache:UnitGUID(filter.unit)
    if not guid then return false end
  end
  local sourceGUID = AirjCache:PlayerGUID()
  local data = Cache.cache.castSuccess:find({spellId=filter.name,sourceGUID=guid,destGUID=sourceGUID},nil,nil,{t=GetTime()-(Core:ParseValue(filter.value) or 0)})
  if not data then return 120 end
  return GetTime() - data.t
end
function F:CASTSUCCESSEDFROM(filter)
  assert(filter.name)
  assert(filter.unit)
	-- local spellId = filter.name[1]
  local guid
  guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local data = Cache.cache.castSuccess:find({spellId=filter.name,sourceGUID=guid},nil,nil,{t=GetTime()-(Core:ParseValue(filter.value)or 0)})
  if not data then return 120 end
  return GetTime() - data.t
end
function F:CASTSUCCESSEDUNIT(filter)
  assert(filter.name and #filter.name == 1 and type(filter.name[1])=="number")
	local spellId = filter.name[1]
  local guid
  guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local sourceGUID = AirjCache:PlayerGUID()
  local data = Cache.cache.castSuccess:find({spellId=spellId,sourceGUID=sourceGUID})
  return data and data.destGUID == guid or false
end

function F:SINCELASTCAST(filter)
  local guid
  guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local data = Cache.cache.castSuccess:find({sourceGUID=guid})
  if not data then return 120 end
  return GetTime() - data.t
end

function F:AURANUM(filter)
  assert(filter.name and #filter.name == 1 and type(filter.name[1])=="number")
	local spellId = filter.name[1]
  local sourceGUID = AirjCache:PlayerGUID()
  local guids = {}
  local t = GetTime()
  local overTimeFifo
  if filter.subtype == "DOT" then
    overTimeFifo = Cache.cache.damage
  elseif filter.subtype == "HOT" then
    overTimeFifo = Cache.cache.heal
  end

  local getguids = {}
  for v,k,i in Cache.cache.aura:iterator({sourceGUID=sourceGUID,spellId=spellId}) do
    if t-v.t>120 then
      break
    end
    if v.destGUID then
      if v.destGUID then
        if not getguids[v.destGUID] or v.t > getguids[v.destGUID] then
          if overTimeFifo then
            local od = overTimeFifo:find({sourceGUID=sourceGUID,spellId=spellId,destGUID=v.destGUID})
            if od and t-od.t<5 then
              getguids[v.destGUID] = v.t
            end
          else
            getguids[v.destGUID] = v.t
          end
        end
      end
    end
  end

  local fadeguids = {}
  for v,k,i in Cache.cache.auraFade:iterator({sourceGUID=sourceGUID,spellId=spellId}) do
    if t-v.t>120 then
      break
    end
    if v.destGUID then
      if not fadeguids[v.destGUID] or v.t > fadeguids[v.destGUID] then
        fadeguids[v.destGUID] = v.t
      end
    end
  end
  local count = 0
  for guid,time in pairs(getguids) do
    if not fadeguids[guid] or time >fadeguids[guid] then
      count = count + 1
    end
  end
  return count
end

function F:GetFutureDamagePVE(guid,time,futureTime)
  local pd = F:GetDamageTaken(guid,time,{periodic=true})
  local sd = F:GetDamageTaken(guid,time,{swing=true})
  return (pd+sd)*futureTime/time
end

local windWalkerMonkCareSpellIds = {
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
  local spellId = filter.name[1]
  local sourceGUID = AirjCache:PlayerGUID()
  local interval = 0
  for v,k,i in Cache.cache.castSuccess:iterator({sourceGUID=sourceGUID}) do
    if windWalkerMonkCareSpellIds[v.spellId] then
      interval = interval + 1
    end
    if v.spellId == spellId then
      return interval
    end
  end
  return 120
end
