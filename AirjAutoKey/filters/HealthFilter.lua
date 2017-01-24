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
  self:RegisterFilter("HEALTHABSORB",L["Health Absorb"],{unit= {},greater={},value={}},{ABS=L["Absolute"]})
  self:RegisterFilter("FUTUREHEALTH",L["Health Future"],{
    unit= {},name= {name=L["Time"]},greater={},value={}
  })
  self:RegisterFilter("RAIDHEALTHLOST",L["Health Lost"],{
    name= {name=L["Max To Ignore"]},greater={},value={}
  },{AVERAGE = L["Average"]},"00FF00")
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
  local array = Cache:GetHealthArray()
  for i = #array,1,-1 do
  -- for i,v in ipairs(array) do
    local v = array[i]
    local health, max, prediction, absorb, healAbsorb = unpack(v)
    if not health or health/max >toCmp then
      return t-v.t
    end
  end
  return 120
end

function F:ISDEAD(filter)
  filter.unit = filter.unit or "player"
  return Cache:Call("UnitIsDeadOrGhost",filter.unit)
end

function F:HEALTH(filter)
  filter.name = filter.name or {"prediction","absorb","healAbsorb"}
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if health < 0 then
    health = 2^32+health
  end
  if max < 0 then
    max = 2^32+max
  end
  if not health then return false end
  if isdead then return false end
  local types = Core:ToKeyTable(filter.name)
  if types.prediction then
    health = health + prediction
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


function F:GetFutureHealth(guid,time)
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return false end
  if isdead then return false end
  health = health + prediction - healAbsorb
  local damage = CombatLogFilter:GetFutureDamagePVE(guid,10,time)
  -- health = damage
  health = health - damage
  return health/max
end

function F:FUTUREHEALTH(filter)
  filter.unit = filter.unit or "player"
  filter.value = filter.value or 1
  filter.name = filter.name or {5}
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local time = unpack(Core:ToValueTable(filter.name),1,1)
  return F:GetFutureHealth(guid,time)
end

function F:RAIDHEALTHLOST(filter)
  filter.name = filter.name or {0.5}
  local unitLst = Core:GetUnitListByAirType("help")
  local checked = {}
  local amount = 0
  local scanCount = 0
  local maxIgnore = unpack(Core:ToValueTable(filter.name),1,2)
  for _,unit in pairs(unitLst) do
    local guid = Cache:UnitGUID(unit)
    if guid and not checked[guid] then
      checked[guid] = true
      local x,y,z,f,d,s = Cache:GetPosition(guid)
      if d and d-s-1.5<40 then
        local value
        local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
        if not health or isdead then
          value = 0
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
  if amount == 0 then return 0 end
  if filter.subtype == "AVERAGE" then
    return amount/scanCount
  else
    return amount
  end
end

function F:POWER(filter)
  filter.unit = filter.unit or "player"
  local powerType = filter.subtype or Cache:Call("UnitPowerType",filter.unit)
  local power = Cache:Call("UnitPower",filter.unit,powerType)
  local filterValue = filter.value or 0
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
  local power = Cache:Call("UnitPower","power",SPELL_POWER_MANA)
  local maxPower = Cache:Call("UnitPowerMax","power",SPELL_POWER_MANA)
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
