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
  self:RegisterFilter("AIRSPECIFICUNIT",L["[P] Specific Unit"],{name={},value={}})
  self:RegisterFilter("AIRHEALER",L["[P] Healer"],{name={},value={}})
  self:RegisterFilter("AIRPVPSPEC",L["[P] PVP Spec"],{value={}})
  self:RegisterFilter("AIRRANGE",L["[P] Range (near)"],{value={}})
  self:RegisterFilter("AIRLOWHEALTH",L["[P] Health (low)"],{value={}})
  self:RegisterFilter("AIRLOWHEALTHFUTURE",L["[P] Health Future (low)"],{name={},value={}})
  self:RegisterFilter("AIRHEALTHLOSTFUTURE",L["[P] H Lost Future (more)"],{name={},value={}})
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
function F:AIRHEALER(filter)
  filter.value = filter.value or 0
  filter.name = filter.name or {2}
  local unitKeys = Core:ToKeyTable(filter.name)
  local unit = Core:GetAirUnit()
  local value = 1
  local guid = Cache:UnitGUID(unit)
  if not guid then return false end
  local id, name, description, icon, role, class = Cache:GetSpecInfo(guid)
  if role == "HEALER" then
    value = filter.name[1]
  else
    value = 1
  end
  return value
end
local specP = {
  [62] = 4,--奥术 -- [1]
  [63] = 6,--火焰 -- [2]
  [64] = 6,--冰霜 -- [3]
  [65] = 5,--神圣 -- [4]
  [66] = 15,--防护 -- [5]
  [70] = 4,--惩戒 -- [6]
  [71] = 4,--武器 -- [7]
  [72] = 4,--狂怒 -- [8]
  [73] = 1,--防护 -- [9]
  [102] = 4,--平衡 -- [13]
  [103] = 5,--野性 -- [14]
  [104] = 3,--守护 -- [15]
  [105] = 3,--恢复 -- [16]
  [250] = 1,--鲜血 -- [17]
  [251] = 3,--冰霜 -- [18]
  [252] = 4,--邪恶 -- [19]
  [253] = 6,--野兽控制 -- [20]
  [254] = 5,--射击 -- [21]
  [255] = 5,--生存 -- [22]
  [256] = 8,--戒律 -- [23]
  [257] = 8,--神圣 -- [24]
  [258] = 10,--暗影 -- [25]
  [259] = 5,--刺杀 -- [26]
  [260] = 3,--狂徒 -- [27]
  [261] = 6,--敏锐 -- [28]
  [262] = 6,--元素 -- [29]
  [263] = 4,--增强 -- [30]
  [264] = 10,--恢复 -- [31]
  [265] = 6,--痛苦 -- [32]
  [266] = 6,--恶魔学识 -- [33]
  [267] = 50,--毁灭 -- [34]
  [268] = 1,--酒仙 -- [35]
  [269] = 4,--踏风 -- [36]
  [270] = 5,--织雾 -- [37]
  [577] = 4,--浩劫 -- [41]
  [581] = 1,--复仇 -- [42]
}

local specMP = {
  [62] = 1,--奥术 -- [1]
  [63] = 1,--火焰 -- [2]
  [64] = 1,--冰霜 -- [3]
  -- [65] = 10,--神圣 -- [4]
  [66] = 0.8,--防护 -- [5]
  [70] = 0.5,--惩戒 -- [6]
  [71] = 0,--武器 -- [7]
  [72] = 0,--狂怒 -- [8]
  [73] = 0,--防护 -- [9]
  [102] = 1,--平衡 -- [13]
  [103] = 0,--野性 -- [14]
  [104] = 0,--守护 -- [15]
  -- [105] = 6,--恢复 -- [16]
  [250] = 0,--鲜血 -- [17]
  [251] = 0.5,--冰霜 -- [18]
  [252] = 0.8,--邪恶 -- [19]
  [253] = 0,--野兽控制 -- [20]
  [254] = 0,--射击 -- [21]
  [255] = 0.2,--生存 -- [22]
  -- [256] = 10,--戒律 -- [23]
  -- [257] = 10,--神圣 -- [24]
  [258] = 1,--暗影 -- [25]
  [259] = 0,--刺杀 -- [26]
  [260] = 0,--狂徒 -- [27]
  [261] = 0,--敏锐 -- [28]
  [262] = 1,--元素 -- [29]
  [263] = 0.5,--增强 -- [30]
  -- [264] = 10,--恢复 -- [31]
  [265] = 1,--痛苦 -- [32]
  [266] = 1,--恶魔学识 -- [33]
  [267] = 1,--毁灭 -- [34]
  [268] = 0,--酒仙 -- [35]
  [269] = 0,--踏风 -- [36]
  -- [270] = 8,--织雾 -- [37]
  [577] = 0.5,--浩劫 -- [41]
  [581] = 1,--复仇 -- [42]
}

Core.spec2MagicDamagePercent = specMP

function F:AIRPVPSPEC(filter)
  filter.value = filter.value or 0
  local unit = Core:GetAirUnit()
  local value = 1
  local guid = Cache:UnitGUID(unit)
  if not guid then return false end
  local id, name, description, icon, role, class = Cache:GetSpecInfo(guid)
  if not id then return false end
  value = specP[id] or 1
  local playerid = Cache:GetSpecInfo(Cache:PlayerGUID())
  local mp = specMP[playerid]

  local health, maxHealth = Cache:GetHealth(Cache:PlayerGUID())
  local dh = Filter:GetDefensivedHealth(unit,mp,mp<=0.5 and 1 or mp<1 and 0.5 or 0)
  local dhp = exp(-dh/maxHealth)
  value = value * dhp
  local dr = Core:GetDrData("STUN",guid)
  local time = -10
  if dr then
    time = dr.t - GetTime()
  end
  local drp
  if time < 0 then
    drp = 1
  elseif time> 16 then
    drp = 1.2
  else
    drp = exp(-time/96)
  end
  value = value * drp

  local ps = {0,0,0}
  local cnt = 0
  local hps = {"player","party1","party2"}
  for i,hp in ipairs(hps) do
    local hguid = UnitGUID(hp)
    if hguid then
      local id, name, description, icon, role, class = Cache:GetSpecInfo(hguid)
      local c = 1
      if role == "DAMAGER" then
        c = 1
      else
        c = 0.5
      end

      local hp = {Cache:GetPosition(hguid)}
      if hp[1] then
        for j = 1,3 do
          ps[j] = ps[j] + hp[j] * c
        end
        cnt = cnt + c
      end
    end
  end
  if cnt > 0 then
    for j = 1,3 do
      ps[j] = ps[j]/cnt
    end
    local ap = {Cache:GetPosition(guid)}
    local d = Core:GetDistance(ps,ap)
    local rp
    if d > 45 then
      rp = exp(-d/10+3.75)
    else
      rp = exp(-d/60)
    end
    value = value * rp
  end
  return value
end
function Core:GetDistance(p1,p2)
	return sqrt((p1[1]-p2[1])^2 + (p1[2]-p2[2])^2 + (p1[3]-p2[3])^2)
end

function F:AIRRANGE(filter)
  -- filter.value = filter.value or 1
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end
  local x,y,z,f,d,s = Cache:GetPosition(guid)
  d = d or 0
  return exp(-d/40)
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
  filter.name = filter.name or {5}
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end

  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  local id, name, description, icon, role, class = Cache:GetSpecInfo(guid)
  local brewmaster
  if id == 268 then
    if health/max > 0.35 then
      return exp(-health*2.5/max)
    end
  end
  local HealthFilter = Filter:GetModule("HealthFilter")
  local value = HealthFilter:GetFutureHealth(guid,unit,filter.name[1])
  return value and exp(-value) or exp(-1)
end
function F:AIRHEALTHLOSTFUTURE(filter)
  filter.name = filter.name or {5}
  local unit = Core:GetAirUnit()
  local guid = unit and Cache:UnitGUID(unit)
  if not guid then return end

  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  local id, name, description, icon, role, class = Cache:GetSpecInfo(guid)
  local brewmaster
  if id == 268 then
    if health/max > 0.35 then
      return exp(-health*2.5/max)
    end
  end
  local HealthFilter = Filter:GetModule("HealthFilter")
  local value = HealthFilter:GetFutureHealthLost(guid,unit,filter.name[1])
  return value or 0
end
function F:AIRAOECOUNT(filter)
  local radius,time = unpack(Core:ToValueTable(filter.name),1,2)
  radius = radius or 8
  local unit = Core:GetAirUnit()
  local value = checkEnemyInRange(radius,0,unit)
  return value
end
