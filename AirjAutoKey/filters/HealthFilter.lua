local filterName = "HealthFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName)
local color = "00FF00"
local L = setmetatable({},{__index = function(t,k) return k end})
local CombatLogFilter

function F:OnInitialize()
  CombatLogFilter = Filter:GetModule("CombatLogFilter")
  self:RegisterFilter("ISDEAD",L["Is Dead or Ghost"])
  self:RegisterFilter("HTIME",L["Low Health Time"],{name= {name=L["Percent Threshold"]},greater={},value={}})
  self:RegisterFilter("HEALTH",L["Health"],{unit= {},name= {name=L["Include Types"]},greater={},value={}},{ABS=L["Absolute"]})
  self:RegisterFilter("HEALTHTOTLE",L["Health Totle"],{unit= {},greater={},value={}})
  self:RegisterFilter("HEALTHABSORB",L["Health Absorb"],{unit= {},greater={},value={}},{ABS=L["Absolute"]})
  self:RegisterFilter("FUTUREHEALTH",L["Health Future"],{
    unit= {},name= {name=L["Time"]},greater={},value={}
  })
  self:RegisterFilter("FUTUREHEALTHLOST",L["H Lost Future"],{
    unit= {},name= {name=L["Time"]},greater={},value={}
  })
  self:RegisterFilter("FUTUREHOTUPTIME",L["HOT Uptime"],{
    unit= {},name= {name=L["Time"]},greater={},value={}
  })
  self:RegisterFilter("RAIDHEALTH",L["Raid HP"],{
    name= {name=L["Min to Ignore | Time"]},greater={},value={}
  },nil,"40FFC0")
  self:RegisterFilter("RAIDHEALTHLOST",L["Raid H Lost"],{
    name= {name=L["Max to Ignore | Time"]},greater={},value={}
  },{AVERAGE = L["Average"]},"40FFC0")
  self:RegisterFilter("RAIDHOTUPDATETIME",L["Raid Hot Uptime"],{
    name= {name=L["Time | Start"]},greater={},value={}
  },{AVERAGE = L["Average"]},"40FFC0")
  self:RegisterFilter("RAIDLOWHEALTHNUMBER",L["Low h count"],{
    name= {name=L["Threshold | Time"]},greater={},value={}
  },{PERCENT = L["Percent"]},"40FFC0")
  self:RegisterFilter("STAGGER",L["Stagger"],{greater={},value={}},{ABS=L["Absolute"]})
  self:RegisterFilter("POWER",L["Power"],{unit= {},greater={},value={}},{
    [SPELL_POWER_MANA]=L["Mana"],
    [SPELL_POWER_MAELSTROM]=L["Maelstrom"],
    [SPELL_POWER_RAGE]=L["Rage"],
    [SPELL_POWER_COMBO_POINTS]=L["Combo Points"],
    [SPELL_POWER_FOCUS]=L["Focus"],
    [SPELL_POWER_ENERGY]=L["Energy"],
    [SPELL_POWER_RUNIC_POWER]=L["Runic Power"],
    [SPELL_POWER_SOUL_SHARDS]=L["Soul Shards"],
    [SPELL_POWER_HOLY_POWER]=L["Holy Power"],
    [SPELL_POWER_CHI]=L["Chi"],
    [SPELL_POWER_PAIN]=L["Pain"],
    [SPELL_POWER_INSANITY]=L["Insanity"],
    [SPELL_POWER_LUNAR_POWER]=L["Lunar Power"],
    [SPELL_POWER_FURY]=L["Fury"],
    [SPELL_POWER_ARCANE_CHARGES]=L["Arcane C"],
  })
  self:RegisterFilter("BOSSMANA",L["Boss Mana"],{unit= {},greater={},value={}})
end

function F:RegisterFilter(key,name,keys,subtypes,c)
  assert(self[key])
  Core:RegisterFilter(key,{
    name = name,
    fcn = self[key],
    color = c or color,
    keys = keys or {unit= {}},
    subtypes = subtypes,
  })
end

function getTimeHealthMax(guid,time)
  local t = GetTime()
  local array = Cache:GetHealthArray(guid)
  local toRet
  for i = #array,1,-1 do
  -- for i,v in ipairs(array) do
    local v = array[i]
    local health, max, prediction, absorb, healAbsorb, isdead = unpack(v)
    if not health or isdead or t-v.t>time then
      break
    end
    local value = (health+prediction-healAbsorb)/max
    toRet = math.max(toRet or 0,value)
  end
  return toRet or 0
end

function F:HTIME(filter)
  filter.name = filter.name or {0.5}
  local toCmp = unpack(Core:ToValueTable(filter.name),1,1)
  local guid = Cache:PlayerGUID()
  if not guid then return false end
  local t = GetTime()
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if health/max >toCmp then
    return 0
  end
  for v in Cache.cache.myhealth:iterator() do
    local health, max, prediction, absorb, healAbsorb = unpack(v)
    if health/max >toCmp then
      return t-v.t
    end
  end
  return 120
end

function F:ISDEAD(filter)
  filter.unit = filter.unit or "player"
  return Cache:Call("UnitIsDeadOrGhost",filter.unit)
end

function F:HEALTHTOTLE(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  return max
end

function F:HEALTH(filter)
  filter.name = filter.name or {"prediction","absorb","healAbsorb"}
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  -- if health and health < 0 then
  --   health = 2^32+health
  -- end
  -- if max and max < 0 then
  --   max = 2^32+max
  -- end
  if not health then return false end
  if isdead then return false end
  local types = Core:ToKeyTable(filter.name)
  if types.prediction then
    health = health + prediction * 2
  end
  if types.absorb then
    health = health + absorb
  end
  if types.healAbsorb then
    health = health - healAbsorb
  end
  local toRet = health
  if filter.subtype == "ABS" then
  else
    toRet = health/max
  end
  return toRet
end

function F:HEALTHABSORB(filter)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return false end
  if isdead then return false end
  local toRet = absorb
  if filter.subtype == "ABS" then
  else
    toRet = absorb/max
  end
  return toRet
end
function F:STAGGER(filter)
  local guid = Cache:PlayerGUID()
  if not guid then return false end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return false end
  if isdead then return false end
  local toRet = UnitStagger("player")
  if filter.subtype == "ABS" then
  else
    toRet = toRet/max
  end
  return toRet
end

local hpsMythic = 40e4
local function getHPS(guid)
  local hps = AirjBossMods:GetDifficultyDamage(bossmod.difficulty,hpsMythic)
  local id, name, description, icon, role, class = Cache:GetSpecInfo(guid)
  if role == "TANK" then
    hps = hps * 2
  end
  return hps
end
local furtureHealthCache = {}
Core.furtureHealthCache = furtureHealthCache
function F:GetFutureHealth(guid,unit,time)
  local now = GetTime()
  if not furtureHealthCache.t or now > furtureHealthCache.t + 0.1 then
    wipe(furtureHealthCache)
    furtureHealthCache.t = now
  end
  local cache = furtureHealthCache[guid..":"..time]
  if cache then
    return cache
  end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return end
  if isdead then return end
  health = health - healAbsorb*2
  local BuffFilter = Filter:GetModule("BuffFilter")
  local furtureDamage
  if AirjBossMods then
    local bossmod = AirjBossMods:GetCurrentBossMod()
    if bossmod and bossmod.furtureDamage then
      local hps = getHPS(guid)
      furtureDamage = true
      local frames = AirjBossMods:GetFutureDamageFrames(guid,time)
      local last = GetTime()
      local dps = 0
      for i, f in pairs(frames) do
        local d = f.time - last
        if d > 0 then
          health = min(health + (hps-dps)*d,max)
          dps = dps + f.dps
          last = f.time
        end
      end
      if last < now + time then
        health = min(health + (now + time - last)*hps,max)
      end
    end
  end
  if not furtureDamage then
    local dotdamage = BuffFilter:GetDotDamageFurture(guid,unit,time)
    health = health - dotdamage
  end
  furtureHealthCache[guid..":"..time] = health/max
  return health/max
end
function Core:GetFutureHealth(guid,time)
  return F:GetFutureHealth(guid,nil,time)
end

local furtureHealthLostCache = {}
Core.furtureHealthLostCache = furtureHealthLostCache
function F:GetFutureHealthLost(guid,unit,time)
  local now = GetTime()
  if not furtureHealthLostCache.t or now > furtureHealthLostCache.t + 0.1 then
    wipe(furtureHealthLostCache)
    furtureHealthLostCache.t = now
  end
  local cache = furtureHealthLostCache[guid..":"..time]
  if cache then
    return cache
  end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return end
  if isdead then return end
  health = health - healAbsorb*2
  local healthLost = max - health
  if time and time > 0 then
    local BuffFilter = Filter:GetModule("BuffFilter")
    local furtureDamage
    if AirjBossMods then
      local bossmod = AirjBossMods:GetCurrentBossMod()
      if bossmod and bossmod.furtureDamage then
        furtureDamage = true
        local damage = AirjBossMods:GetFutureDamage(guid,time)
        healthLost = healthLost + damage
      end
    end
    if not furtureDamage then
      local dotdamage = BuffFilter:GetDotDamageFurture(guid,unit,time)
      healthLost = healthLost + dotdamage
    end
  end
  furtureHealthLostCache[guid..":"..time] = healthLost/max
  return healthLost/max
end
function Core:GetFutureHealthLost(guid,time)
  return F:GetFutureHealthLost(guid,nil,time)
end

local furtureHotUptimeCache = {}
Core.furtureHotUptimeCache = furtureHotUptimeCache
function F:GetFutureHotUptime(guid,unit,time,start)
  local now = GetTime()
  if not furtureHotUptimeCache.t or now > furtureHotUptimeCache.t + 0.1 then
    wipe(furtureHotUptimeCache)
    furtureHotUptimeCache.t = now
  end
  start = start or 0
  local cache = furtureHotUptimeCache[guid..":"..time..":"..start]
  if cache then
    return cache
  end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return end
  if isdead then return end
  health = health - healAbsorb*2
  local BuffFilter = Filter:GetModule("BuffFilter")
  local furtureDamage
  local uptime = 0
  if AirjBossMods then
    local bossmod = AirjBossMods:GetCurrentBossMod()
    if bossmod and bossmod.furtureDamage then
      furtureDamage = true
      local hps = getHPS(guid)
      local frames = AirjBossMods:GetFutureDamageFrames(guid,time+start)
      local last = GetTime()
      local startT = last+start
      local dps = 0
      for i, f in pairs(frames) do
        local d = f.time - last
        if d > 0 then
          local h2 = min(health + (hps-dps)*d,max)
          local detla = 0
          if last >= startT then
            if dps > 0 then
              detla = d
            elseif h2 < max then
              detla = d
            elseif health < max then
              detla = (max-health)/hps
            end
          elseif f.time > startT then
            if dps > 0 then
              detla = f.time - startT
            elseif h2 < max then
              detla = f.time - startT
            elseif health < max then
              local notfulltime = (max-health)/hps
              notfulltime = notfulltime - (startT - last)
              if notfulltime > 0 then
                detla = notfulltime
              end
            end
          end
          uptime = uptime + detla
          -- print(dps,health,h2,detla,uptime)
          health = h2
        end
        dps = dps + f.dps
        last = f.time
      end
      if last < now + time + start then
        if last >= startT then
          uptime = uptime + min((now + time + start - last),(max-health)/hps)
        else
          local notfulltime = min((now + time + start - last),(max-health)/hps)
          notfulltime = notfulltime - (startT - last)
          if notfulltime > 0 then
            uptime = uptime + notfulltime
          end
        end

        -- print(uptime)
      end
    end
  end
  if not furtureDamage then
    uptime = BuffFilter:GetDotDamageDuration(guid,unit,time+start) + (max-health)/max*20 - start
  end
  furtureHotUptimeCache[guid..":"..time..":"..start] = uptime
  return uptime
end
function Core:GetFutureHealth(guid,time)
  return F:GetFutureHealth(guid,nil,time)
end


--
function F:FUTUREHEALTH(filter)
  filter.unit = filter.unit or "player"
  filter.value = filter.value or 1
  filter.name = filter.name or {5}
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local time = unpack(Core:ToValueTable(filter.name),1,1)
  return F:GetFutureHealth(guid,filter.unit,time)
end

function F:FUTUREHEALTHLOST(filter)
  filter.unit = filter.unit or "player"
  filter.value = filter.value or 1
  filter.name = filter.name or {5}
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local time = unpack(Core:ToValueTable(filter.name),1,1)
  return F:GetFutureHealthLost(guid,filter.unit,time)
end

function F:FUTUREHOTUPTIME(filter)
  filter.unit = filter.unit or "player"
  filter.value = filter.value or 1
  filter.name = filter.name or {5}
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local time = unpack(Core:ToValueTable(filter.name),1,1)
  return F:GetFutureHotUptime(guid,filter.unit,time)
end

function F:RAIDHEALTH(filter)
  filter.name = filter.name or {0.5}
  local time = filter.name[2]
  local unitLst = Core:GetUnitListByAirType("help")
  local checked = {}
  local amount = 0
  local scanCount = 0
  local maxIgnore = unpack(Core:ToValueTable(filter.name),1,2)
  local fv = Core:ParseValueMulti(filter.value)
  maxIgnore = math.max(maxIgnore,1-(1-fv)*2.5)
  maxIgnore = math.min(maxIgnore,1-(1-fv)*1.5)
  for _,unit in pairs(unitLst) do
    local guid = Cache:UnitGUID(unit)
    if guid and not checked[guid] then
      checked[guid] = true
      local x,y,z,f,d,s = Cache:GetPosition(guid)
      local exists,harm,help = Cache:GetExists(guid,filter.unit)
      local ir, cr = UnitInRange(unit)
      if d and d-s-1.5<60 and UnitIsPlayer(unit) and help and not (cr and not ir) then
        local value
        local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
        if health and not isdead then
          if time then
            value = F:GetFutureHealth(guid,unit,time)
          else
            value = (health+prediction-healAbsorb)/max
          end
          value = math.max(value,maxIgnore)
          scanCount = scanCount + 1
          amount = amount + value
        end
      end
    end
  end
  if amount == 0 then return 0 end
  return amount/scanCount
end

function F:RAIDHEALTHLOST(filter)
  filter.name = filter.name or {0.5}
  local time = filter.name[2]
  local unitLst = Core:GetUnitListByAirType("help")
  local checked = {}
  local amount = 0
  local scanCount = 0
  local maxIgnore = unpack(Core:ToValueTable(filter.name),1,2)

  if filter.subtype == "AVERAGE" then
    local fv = Core:ParseValueMulti(filter.value)
    maxIgnore = math.min(maxIgnore,fv*2.5)
    maxIgnore = math.max(maxIgnore,fv*1.5)
  end
  for _,unit in pairs(unitLst) do
    local guid = Cache:UnitGUID(unit)
    if guid and not checked[guid] then
      checked[guid] = true
      local x,y,z,f,d,s = Cache:GetPosition(guid)
      local exists,harm,help = Cache:GetExists(guid,filter.unit)
      local ir, cr = UnitInRange(unit)
      if d and d-s-1.5<60 and UnitIsPlayer(unit) and help and not (cr and not ir) then
        local value
        local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
        if not health or isdead then
          value = 0
        else
          if time then
            value = F:GetFutureHealthLost(guid,unit,time) or 0
          else
            value = 1-(health+prediction-healAbsorb)/max
          end
          value = math.min(value,maxIgnore)
          value = math.max(value,0)
          scanCount = scanCount + 1
          amount = amount + value
        end
      end
    end
  end
  if amount == 0 then return 0 end
  if filter.subtype == "AVERAGE" then
    return amount/scanCount
  else
    return amount
  end
end

function F:RAIDHOTUPDATETIME(filter)
  filter.name = filter.name or {5,0}
  local time = filter.name[1]
  local start = filter.name[2]
  local unitLst = Core:GetUnitListByAirType("help")
  local checked = {}
  local amount = 0
  local scanCount = 0
  local maxIgnore = unpack(Core:ToValueTable(filter.name),1,2)

  if filter.subtype == "AVERAGE" then
    local fv = Core:ParseValueMulti(filter.value)
    maxIgnore = math.min(maxIgnore,fv*2.5)
    maxIgnore = math.max(maxIgnore,fv*1.5)
  end
  for _,unit in pairs(unitLst) do
    local guid = Cache:UnitGUID(unit)
    if guid and not checked[guid] then
      checked[guid] = true
      local x,y,z,f,d,s = Cache:GetPosition(guid)
      local exists,harm,help = Cache:GetExists(guid,filter.unit)
      local ir, cr = UnitInRange(unit)

      if d and d-s-1.5<60 and UnitIsPlayer(unit) and help and not (cr and not ir) then
        local value
        local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
        if not health or isdead then
          value = 0
        else
          value = F:GetFutureHotUptime(guid,unit,time,start)
          value = math.min(value,maxIgnore)
          value = math.max(value,0)
          scanCount = scanCount + 1
          amount = amount + value
        end
      end
    end
  end
  if amount == 0 then return 0 end
  if filter.subtype == "AVERAGE" then
    return amount/scanCount
  else
    return amount
  end
end

function F:RAIDLOWHEALTHNUMBER(filter)
  filter.name = filter.name or {0.6}
  local threshold = filter.name[1]
  local time = filter.name[2]
  local unitLst = Core:GetUnitListByAirType("help")
  local checked = {}
  local passed = 0
  local all = 0
  for _,unit in pairs(unitLst) do
    local guid = Cache:UnitGUID(unit)
    if guid and not checked[guid] then
      checked[guid] = true
      local x,y,z,f,d,s = Cache:GetPosition(guid)
      local exists,harm,help = Cache:GetExists(guid,filter.unit)
      if d and d-s-1.5<60 and UnitIsPlayer(unit) and help then
        local value
        local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
        if not health or isdead then
        else
          if time then
            value = F:GetFutureHealth(guid,unit,time)
          else
            value = (health+prediction-healAbsorb)/max
          end
          if value < threshold then
            passed = passed + 1
          end
          all = all + 1
        end
      end
    end
  end
  if all == 0 then return 0 end

  if filter.subtype == "PERCENT" then
    return passed
  else
    return passed/all
  end
end

function F:POWER(filter)
  filter.unit = filter.unit or "player"
  local powerType = filter.subtype or Cache:Call("UnitPowerType",filter.unit)
  local power = Cache:Call("UnitPower",filter.unit,powerType)
  local filterValue = Core:ParseValue(filter.value or 0)
  if filterValue<0 then
    local max = Cache:Call("UnitPowerMax",filter.unit,powerType)
    power = power - max
  else
    local scale = 1
    power = power/scale
  end
  return power
end

function F:BOSSMANA(filter)
  filter.unit = filter.unit or "boss1"
  filter.value = filter.value or 0.1
  local power = Cache:Call("UnitPower","player",SPELL_POWER_MANA)
  local maxPower = Cache:Call("UnitPowerMax","player",SPELL_POWER_MANA)
  local bossguid = UnitGUID(filter.unit)
  local bosshealth,powerPercent
  if bossguid then
    local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(bossguid)
    bosshealth = health/max
  end
  if power then
    powerPercent = power/maxPower
  end
  if bosshealth and powerPercent then
    return powerPercent - bosshealth
  end
  return true
end
