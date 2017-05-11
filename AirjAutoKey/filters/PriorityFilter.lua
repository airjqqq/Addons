local filterName = "PriorityFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName)
local color = "7F7F3F"
local L = setmetatable({},{__index = function(t,k) return k end})
local CombatLogFilter

function F:OnInitialize()
  CombatLogFilter = Filter:GetModule("CombatLogFilter")
  self:RegisterFilter("AIRTYPE",L["[P] Other Filter"],{name={}})
  self:RegisterFilter("AIRSPECIFICUNIT",L["[P] Specific Unit"],{name={}})
  self:RegisterFilter("AIRRANGE",L["[P] Range (near)"],{value={}})
  self:RegisterFilter("AIRLOWHEALTH",L["[P] Health (low)"],{value={}})
  self:RegisterFilter("AIRLOWHEALTHFUTURE",L["[P] Health Future (low)"],{value={}})
  self:RegisterFilter("AIRHIGHHEALTH",L["[P] Health (high)"])
  self:RegisterFilter("AIRBUFF",L["[P] Buff (short)"],{name={},value={}})
  self:RegisterFilter("AIRDEBUFF",L["[P] Debuff (short)"],{name={},value={}})
  self:RegisterFilter("AIRDEBUFFORTARGET",L["[P] Debuff or target"],{name={}})
  self:RegisterFilter("AIRFASTTODIE",L["[P] ToDie (fast)"])
  self:RegisterFilter("AIRAOECOUNT",L["[P] AOE (more)"],{name={}})
end

local function checkEnemyInRange (radius,time,unit)
  local t = GetTime()
  local count = 0
  local center
  if unit then
    local guid = UnitGUID(unit)
    center = {Cache:GetPosition(guid)}
    if not center[1] then return 0 end
  end
  for guid,data in pairs(Cache.exists) do
    if data[2] then
      local isdead = select(6,Cache:GetHealth(guid))
      if isdead==false then
        local x,y,z,f,d,s = Cache:GetPosition(guid)
        if x then
          if not unit then
            if d and d-s<radius then
              count = count + 1
            end
          else
            local dx,dy,dz = x-center[1],y-center[2],z-center[3]
            local d = sqrt(dx*dx+dy*dy+dz*dz)
            if d and d-s<radius then
              count = count + 1
            end
          end
        end
      end
    end
  end
  return count
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
  filter.name = filter.name or {"player"}
  local unitKeys = Core:ToKeyTable(filter.name)
  local unit = Core:GetAirUnit()
  local value = 1
  for key,v in pairs(unitKeys) do
    local u,m = strsplit(":",key)
    m = tonumber(m)
    if m then
      if Cache:Call("UnitIsUnit",u,unit) then
        if m < 1 then
          value = math.min(value,m)
        else
          value = math.max(value,m)
        end
      end
    end
  end
  return value
end

function F:AIRRANGE(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local x,y,z,f,d,s = Cache:GetPosition(guid)
  d = d or 0
  return exp(-d)
end

function F:AIRLOWHEALTH(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return end
  local id, name, description, icon, role, class = Cache:GetSpecInfo(guid)
  local brewmaster
  if id == 268 then
    if health/max > 0.35 then
      health = math.min(health*2.5,max)
    end
  end
  local value = (health+absorb-healAbsorb*2+prediction*2)/max
  return exp(-value)
end

function F:AIRHIGHHEALTH(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return end
  local value = health
  return value
end

function F:AIRBUFF(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local spells = Core:ToKeyTable(filter.name)
  local buffs = Cache:GetBuffs(guid,filter.unit,spells,true)
  local minValue = 1
  for i,v in pairs(buffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local value
    if duration == 0 and expires ==0 then
      value = 1
    else
      value = (expires - GetTime())/100
    end
    minValue = min(minValue,value)
  end
  return exp(-minValue)
end

function F:AIRDEBUFF(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local spells = Core:ToKeyTable(filter.name)
  local buffs = Cache:GetDebuffs(guid,unit,spells,true)
  local minValue = 1
  for i,v in pairs(buffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local value
    if duration == 0 and expires ==0 then
      value = 1
    else
      value = (expires - GetTime())/100
    end
    minValue = min(minValue,value)
  end
  return exp(-minValue)
end

function F:AIRDEBUFFORTARGET(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local spells = Core:ToKeyTable(filter.name)
  local buffs = Cache:GetDebuffs(guid,unit,spells,true)
  if #buffs == 0 then return end
  local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(buffs[1])
  if not name then
    if UnitIsUnit(unit,"target") then
      return 1.2
    end
    return
  elseif UnitIsUnit(unit,"target") then
    return 0.8
  else
    return 0.5
  end
end

function F:AIRFASTTODIE(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return end
  if isdead then return end
  health = health + prediction + absorb
  local damage = CombatLogFilter:GetDamageTaken(guid,5)
  if damage == 0 then
    return
  else
    return 1 + exp(-health/(damage)*5+10)
  end
end

function F:AIRLOWHEALTHFUTURE(filter)
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if not health then return end
  local damage = CombatLogFilter:GetDamageTaken(guid,5)
  local value = (health+absorb-healAbsorb*2+prediction*2-damage)/max
  return exp(-value)
end
function F:AIRAOECOUNT(filter)
  local radius,time = unpack(Core:ToValueTable(filter.name),1,2)
  radius = radius or 8
  local unit = Core:GetAirUnit()
  local value = checkEnemyInRange(radius,0,unit)
  return value
end
