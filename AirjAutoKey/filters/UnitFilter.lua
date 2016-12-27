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
  self:RegisterFilter("PVEATTACK",L["PVE Should Attack"])
  self:RegisterFilter("COMBAT",L["Is Combat"])
  self:RegisterFilter("ISPLAYER",L["Is Player"])
  self:RegisterFilter("ISPLAYERREAL",L["Is Player Real"])
  self:RegisterFilter("ISPLAYERCTRL",L["Is Player Controlled"])
  self:RegisterFilter("ISINRAID",L["Unit In Group"])
  self:RegisterFilter("CLASS",L["Class"],{unit= {},name= {name=L["Big Letter"]}})
  self:RegisterFilter("UNITSPEC",L["Spec"],{unit= {},name= {name=L["Number"]}})
  self:RegisterFilter("RAIDTARGET",L["Raid Target"],{unit= {},name= {name=L["number"]}})
  self:RegisterFilter("UNITISTANK",L["Is Tank"])
  self:RegisterFilter("UNITISMELEE",L["Is Melee"])
  self:RegisterFilter("UNITISHEALER",L["Is Healer"])
  self:RegisterFilter("SPEED",L["Unit Move Speed"],{unit={},greater={},value={}})
  self:RegisterFilter("UNITISUNIT",L["Unit Is Unit"],{unit= {},name= {name=L["Other Unit (Multi)"]}})
  self:RegisterFilter("UNITNAME",L["Unit Name"],{unit= {},name= {name=L["Names (Multi)"]}})
  self:RegisterFilter("CASTING",L["Unit Cast or Channel"],{unit= {},name= {name=L["Spell ID (None or Multi)"]},greater={},value={}},{START = L["Start"]})
  self:RegisterFilter("CASTINGCHANNEL",L["Unit Channel"],{unit= {},name= {name=L["Spell ID (None or Multi)"]},greater={},value={}})
  self:RegisterFilter("CASTINGINTERRUPT",L["Unit Cast[I]"],{unit= {},name= {name=L["Spell ID (None or Multi)"]},greater={},value={}})
  self:RegisterFilter("CHANNELINTERRUPT",L["Unit Channel[I]"],{unit= {},name= {name=L["Spell ID (None or Multi)"]},greater={},value={}})

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

function F:PVEATTACK(filter)
  filter.unit = filter.unit or "target"
  if UnitIsUnit(filter.unit,"target") then
    return true
  end
  if UnitIsUnit(filter.unit,"focus") then
    return true
  end
  local guid = Cache:UnitGUID(filter.unit)
  local objectType,serverId,instanceId,zone,id,spawn = AirjHack:GetGUIDInfo(guid)
  local _, instanceType, difficulty, difficultyName, _, _, _, _, instanceGroupSize = Cache:Call("GetInstanceInfo")
  if id == "105721" and difficulty == 16 then
    local health, max, prediction, absorb, healAbsorb, isdead = AirjHack:UnitHealth(guid)
    if health and health/max > 0.5 then
      return true
    end
    local index = GetRaidTargetIndex(filter.unit)
    if index == 8 then
      return true
    end
    if index == 7 and health and health/max > 0.4 then
      return true
    end
    return false
  end
  if id == "103694" then
    return false
  end
  if id == "114568" then
    local health, max, prediction, absorb, healAbsorb, isdead = AirjHack:UnitHealth(Cache:UnitGUID("boss1") or "")
    if health and health/max>0.4 then
      return false
    end
  end

  return true
end

function F:COMBAT(filter)
  filter.unit = filter.unit or "player"
  if IsResting() and not UnitIsPlayer(filter.unit) then return true end
  if UnitExists("boss1") then return true end
  return Cache:Call("UnitAffectingCombat",filter.unit) and true or false
end

function F:ISPLAYER(filter)
  filter.unit = filter.unit or "target"
  local _,currentZoneType = IsInInstance()
	if currentZoneType ~= "pvp" and currentZoneType ~= "arena" then
    if UnitLevel(filter.unit) <=  UnitLevel("player") then
	    return true
    end
	end
  -- if IsResting() then return true end
  return Cache:Call("UnitIsPlayer",filter.unit) and true or false
end
function F:ISPLAYERREAL(filter)
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
function F:RAIDTARGET(filter)
  filter.unit = filter.unit or "target"
  assert(filter.name)
  local indexes = Core:ToKeyTable(filter.name)
  local index = GetRaidTargetIndex(filter.unit) or 0
  return indexes[index] or false
end

function F:UNITSPEC(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local id, name, description, icon, background, role, class = Cache:GetSpecInfo(guid)
  local specs = Core:ToKeyTable(filter.name)
  return specs[id] or false
end

function F:UNITISTANK(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local id, name, description, icon, background, role, class = Cache:GetSpecInfo(guid)
  return role == "TANK"
end

local melee = {
  [70] = true,
  [71] = true,
  [72] = true,
  [103] = true,
  [251] = true,
  [252] = true,
  [256] = true,
  [259] = true,
  [260] = true,
  [261] = true,
  [263] = true,
  [269] = true,
  [577] = true,
}

function F:UNITISMELEE(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local id, name, description, icon, background, role, class = Cache:GetSpecInfo(guid)
  return melee[id] or false
end

function F:UNITISHEALER(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local id, name, description, icon, background, role, class = Cache:GetSpecInfo(guid)
  if IsResting and UnitIsUnit("focus",filter.unit) then return true end
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
    castName, _, _, _, startTime, endTime,_,notInterruptible = Cache:Call("UnitChannelInfo",filter.unit)
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
function F:CHANNELINTERRUPT(filter)
  filter.unit = filter.unit or "player"
  local castName, _, _, _, startTime, endTime,_,notInterruptible = Cache:Call("UnitChannelInfo",filter.unit)
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
    return GetTime()-startTime/1000
  else
    return false
  end
end
