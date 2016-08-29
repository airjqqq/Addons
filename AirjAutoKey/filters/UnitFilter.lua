local filterName = "UnitFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName)
local color = "FFBF7F"
local L = setmetatable({},{__index = function(t,k) return k end})
local CombatLogFilter

function F:OnInitialize()
  CombatLogFilter = Filter:GetModule("CombatLogFilter")
  self:RegisterFilter("UNITEXISTS",L["Exists / Help / Harm"],nil,{
    HELP = L["Help Only"],
    HARM = L["Harm Only"],
    OBSERV = L["Obsorb (value2)"],
  })
  self:RegisterFilter("COMBAT",L["Is Combat"])
  self:RegisterFilter("ISDEAD",L["Is Dead or Ghost"])
  self:RegisterFilter("ISPLAYER",L["Is Player"])
  self:RegisterFilter("ISPLAYERCTRL",L["Is Player Controlled"])
  self:RegisterFilter("ISINRAID",L["Unit In Group"])
  self:RegisterFilter("CLASS",L["Class"])
  self:RegisterFilter("UNITISTANK",L["Is Tank"])
  self:RegisterFilter("UNITISMELEE",L["Is Melee"])
  self:RegisterFilter("UNITISHEALER",L["Is Healer"])
  self:RegisterFilter("SPEED",L["Unit Move Speed"],{unit={},greater={},value={}})
  self:RegisterFilter("UNITISUNIT",L["Unit Is Unit"],{unit= {},name= {name=L["Other Unit (Multi)"]}})
  self:RegisterFilter("UNITNAME",L["Unit Name"],{unit= {},name= {name=L["Names (Multi)"]}})
  self:RegisterFilter("CASTING",L["Unit Cast or Channel"],{unit= {},name= {name=L["Spell ID (None or Multi)"]},greater={},value={}})
  self:RegisterFilter("CASTINGCHANNEL",L["Unit Channel"],{unit= {},name= {name=L["Spell ID (None or Multi)"]},greater={},value={}})
  self:RegisterFilter("CASTINGINTERRUPT",L["Unit Cast Interruptable"],{unit= {},name= {name=L["Spell ID (None or Multi)"]},greater={},value={}})
  self:RegisterFilter("HTIME",L["Low Health Time"],{unit= {},name= {name=L["Percent Threshold"]},greater={},value={}},nil,"00FF00")
  self:RegisterFilter("HEALTH",L["Health Percent"],{unit= {},name= {name=L["Include Types"]},greater={},value={}},{ABS=L["Absolute"]},"00FF00")
  self:RegisterFilter("HEALTHPOINT",L["Health Point"],{
    unit= {},name= {name=L["Time"]},greater={},value={}
  },nil,"00FF00")
  self:RegisterFilter("RAIDHEALTH",L["Health Lost Total"],{
    name= {name=L["Time | Max To Ignore"]},greater={},value={}
  },nil,"00FF00")
  self:RegisterFilter("POWER",L["Power"],{unit= {},greater={},value={}},{
    [SPELL_POWER_MANA]=L["Mana"],
    [SPELL_POWER_RAGE]=L["Rage"],
    [SPELL_POWER_FOCUS]=L["Focus"],
    [SPELL_POWER_ENERGY]=L["Energy"],
    [SPELL_POWER_RUNIC_POWER]=L["Runic Power"],
    [SPELL_POWER_SOUL_SHARDS]=L["Soul Shards"],
    [SPELL_POWER_HOLY_POWER]=L["Holy Power"],
    [SPELL_POWER_CHI]=L["Chi"],
  })
  --{"mana","race","focus","energy","combo point","rune","rune power","soul shards",nil,"holy power",nil,nil,nil,"chi"}
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

function F:UNITEXISTS(filter)
  filter.unit = filter.unit or "target"
  if filter.subtype == "HELP" then
    return Cache:Call("UnitCanAssist","player",filter.unit)
  elseif filter.subtype == "HARM" then
    return Cache:Call("UnitCanAttack","player",filter.unit)
  else
    return Cache:Call("UnitExists",filter.unit)
  end
end

function F:COMBAT(filter)
  filter.unit = filter.unit or "player"
  return Cache:Call("UnitAffectingCombat",filter.unit) and true or false
end

function F:ISPLAYER(filter)
  filter.unit = filter.unit or "target"
  return Cache:Call("UnitIsPlayer",filter.unit) and true or false
end

function F:ISPLAYERCTRL(filter)
  filter.unit = filter.unit or "target"
  return Cache:Call("UnitPlayerControlled",filter.unit) and true or false
end

function F:ISINRAID(filter)
  filter.unit = filter.unit or "target"
  return (Cache:Call("UnitInRaid",filter.unit) or Cache:Call("UnitInParty",filter.unit)) and true or false
end

function F:CLASS(filter)
  filter.unit = filter.unit or "target"
  assert(filter.name)
  local classes = Core:ToKeyTable(filter.name)
  local _,class = Cache:Call("UnitClass",filter.unit)
  return classes[class] or false
end

function F:UNITISTANK(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return false end
  local id, name, description, icon, background, role, class = Cache:GetSpecInfo(guid)
  return role == "TANK"
end

function F:UNITISMELEE(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return false end
  local id, name, description, icon, background, role, class = Cache:GetSpecInfo(guid)
  -- F:Print(role)
  -- TODO list all specid for melee
  return role == "DAMAGER"
end

function F:UNITISHEALER(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return false end
  local id, name, description, icon, background, role, class = Cache:GetSpecInfo(guid)
  return role == "HEALER"
end

function F:SPEED(filter)
  filter.unit = filter.unit or "player"
  local speed = Cache:Call("GetUnitSpeed",filter.unit)
  return speed
end

function F:UNITISUNIT(filter)
  filter.name = filter.name or "player"
  local units = Core:ToKeyTable(filter.name)
  for k,v in pairs(units) do
    local unit2 = Core:ParseUnit(k) or k
    if Cache:Call("UnitIsUnit",unit2,filter.unit) then
      return true
    end
  end
  return false
end

function F:UNITNAME(filter)
  local names = Core:ToKeyTable(filter.name)
  for name,v in pairs(names) do
    if Cache:Call("UnitName",filter.unit) == name then
      return true
    end
  end
  return false
end

function F:CASTING(filter)
  filter.unit = filter.unit or "player"
  local castName, _, _, _, startTime, endTime = Cache:Call("UnitCastingInfo",filter.unit)
  if not castName then
    castName, _, _, _, startTime, endTime = Cache:Call("UnitChannelInfo",filter.unit)
  end
  if not castName then return false end
  local match
  if filter.name then
    local names = Core:ToKeyTable(filter.name)
    for k,v in pairs(names) do
      local name = Cache:Call("GetSpellInfo",k)
      if name == castName then
        match = true
        break
      end
    end
  else
    match = true
  end
  if match then
    if filter.subtype == "START" then
      return GetTime()-startTime/1000
    else
      return endTime/1000-GetTime()
    end
  else
    return false
  end
end


function F:CASTINGCHANNEL(filter)
  filter.unit = filter.unit or "player"
  local castName, _, _, _, startTime, endTime = Cache:Call("UnitChannelInfo",filter.unit)
  if not castName then return false end
  local match
  if filter.name then
    local names = Core:ToKeyTable(filter.name)
    for k,v in pairs(names) do
      local name = Cache:Call("GetSpellInfo",k)
      if name == castName then
        match = true
        break
      end
    end
  else
    match = true
  end
  if match then
    if filter.subtype == "START" then
      return GetTime()-startTime/1000
    else
      return endTime/1000-GetTime()
    end
  else
    return false
  end
end

function F:CASTINGINTERRUPT(filter)
  filter.unit = filter.unit or "player"
  local castName, _, _, _, startTime, endTime,_,_,notInterruptible = Cache:Call("UnitCastingInfo",filter.unit)
  if not castName then
    castName, _, _, _, startTime, endTime_,notInterruptible = Cache:Call("UnitChannelInfo",filter.unit)
  end
  if not castName or notInterruptible then
    return false
  end
  local match
  if filter.name then
    local names = Core:ToKeyTable(filter.name)
    for k,v in pairs(names) do
      local name = Cache:Call("GetSpellInfo",k)
      if name == castName then
        match = true
        break
      end
    end
  else
    match = true
  end
  if match then
    if filter.subtype == "START" then
      return GetTime()-startTime/1000
    else
      return endTime/1000-GetTime()
    end
  else
    return false
  end
end

function getTimeHealthMax(guid,time)
  local t = GetTime()
  local array = Cache:GetHealthArray(guid)
  local toRet
  for i,v in ipairs(array) do
    local health, max, prediction, absorb, healAbsorb, isdead = unpack(v)
    if not health or isdead or t-v.t>time then
      break
    end
    local value = (health+prediction-healAbsorb)/max
    toRet = math.max(toRet or 0,value)
  end
  return toRet
end

function F:HTIME(filter)
  filter.unit = filter.unit or "player"
  assert(type(filter.name)=="number")
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return false end
  local t = GetTime()
  local array = Cache:GetHealthArray(guid)
  for i,v in ipairs(array) do
    local health, max, prediction, absorb, healAbsorb = unpack(v)
    if not health or health/max >filter.name then
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
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return false end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
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

function F:HEALTHPOINT(filter)
  -- filter.name = filter.name or {"prediction","absorb","healAbsorb"}
  filter.unit = filter.unit or "player"
  filter.value = filter.value or 0.5
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return false end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return false end
  if isdead then return false end
  health = health + prediction - healAbsorb
  local value = health/max
  if value<filter.value then return value end
  local time = unpack(Core:ToValueTable(filter.name),1,1)
  time = time or 5
  local damage = CombatLogFilter:GetDamageTaken(guid,time)
  local minValue = value
  value = 1 - damage/max/time*2
  if value<filter.value then return value end
  local damageSwing = CombatLogFilter:GetDamageTakenSwing(guid,time)
  minValue = min(value,minValue)
  value = 1 - damageSwing/max/time*5
  if value<filter.value then return value end
  local heal = CombatLogFilter:GetHealTaken(guid,time)
  minValue = min(value,minValue)
  value = 1 - (damage-heal)/max/time*3
  if value<filter.value then return value end
  local thealth = getTimeHealthMax(guid,time)
  minValue = min(value,minValue)
  value = 1 - (1 - thealth)*(1+time/5)
  if value<filter.value then return value end
  local thealth = getTimeHealthMax(guid,time*2)
  minValue = min(value,minValue)
  value = 1 - (1 - thealth)*(1+time/2)
  if value<filter.value then return value end
  minValue = min(value,minValue)
  return minValue
end

function F:RAIDHEALTH(filter)
  local unitLst = Core:GetUnitListByAirType("help")
  local checked = {}
  local amount = 0
  local time,maxIgnore = unpack(Core:ToValueTable(filter.name),1,2)
  if time == 0 then time = nil end
  maxIgnore = maxIgnore or 0.5
  for _,unit in pairs(unitLst) do
    local guid = Cache:Call("UnitGUID",unit)
    if guid and not checked[guid] then
      checked[guid] = true
      local x,y,z,f,d,s = Cache:GetPosition(guid)
      if d and d-s-1.5<40 then
        local value
        if time then
          value = 1-getTimeHealthMax(guid,time)
        else
          local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
          if not health or isdead then
            value = 0
          else
            value = 1-(health+prediction-healAbsorb)/max
          end
        end
        value = math.min(value,maxIgnore)
        value = math.max(value,0)
        amount = amount + value
      end
    end
  end
  return amount
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
