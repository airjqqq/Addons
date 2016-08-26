local F = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyCombatLogFilter")
local Cache = AirjAutoKeyCache
local Core = AirjAutoKey

function OnInitialize()
end

--LASTDAMAGEDONETIME
function F:CHANNELDAMAGE(filter)
  assert(filter.name and type(filter.name)=="number")
  filter.unit = filter.unit or "player"
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 120 end
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
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 0 end
  local by = Cache.cache.damageBy[guid]
  if not by then return 0 end
  local array = by.array or {}
  local guids = {}
  local t = GetTime()
  local count = 0
  for i, v in ipairs(array) do
    local eventTime,sourceGUID,spellId = v.t,v.guid,v.spellId
    if t-eventTime>time then
      break
    end
    if spellId=="Swing" then
      if not guids[sourceGUID] then
        guids[sourceGUID] = true
        count = count + 1
      end
    end
  end
  return count
end

local function getDamageTaken(guid,time)
  local by = Cache.cache.damageBy[guid]
  if not by then return 0 end
  local array = by.array or {}
  local t = GetTime()
  local total = 0
  for i, v in ipairs(array) do
    local eventTime,sourceGUID,spellId,damage = v.t,v.guid,v.spellId,v.value
    if t-eventTime>time then
      break
    end
    total = total + damage
  end
  return total
end

function F:DAMAGETAKEN(filter)
  filter.unit = filter.unit or "player"
	local time = tonumber(filter.name) or 5
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 0 end
  return getDamageTaken(guid,time)
end

function F:DAMAGETAKENSWING(filter)
  filter.unit = filter.unit or "player"
	local time = tonumber(filter.name) or 5
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 0 end
  local by = Cache.cache.damageBy[guid]
  if not by then return 0 end
  local array = by.array or {}
  local guids = {}
  local t = GetTime()
  local total = 0
  for i, v in ipairs(array) do
    local eventTime,sourceGUID,spellId,damage = v.t,v.guid,v.spellId,v.value
    if t-eventTime>time then
      break
    end
    if spellID == spellId then
      total = total + damage
    end
  end
  return total
end

local function getHealTaken(guid,time)
  local by = Cache.cache.healBy[guid]
  if not by then return 0 end
  local array = by.array or {}
  local t = GetTime()
  local total = 0
  for i, v in ipairs(array) do
    local eventTime,sourceGUID,spellId,value = v.t,v.guid,v.spellId,v.value
    if t-eventTime>time then
      break
    end
    total = total + value
  end
end

function F:HEALTAKEN(filter)
  filter.unit = filter.unit or "player"
	local time = tonumber(filter.name) or 5
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 0 end
  return getHealTaken(guid,time)
end

function F:HEALTAKENDIRECT(filter)
  filter.unit = filter.unit or "player"
	local time = tonumber(filter.name) or 5
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 0 end
  local by = Cache.cache.healBy[guid]
  if not by then return 0 end
  local array = by.array or {}
  local guids = {}
  local t = GetTime()
  local total = 0
  for i, v in ipairs(array) do
    local eventTime,sourceGUID,spellId,value,periodic = v.t,v.guid,v.spellId,v.value,v.periodic
    if t-eventTime>time then
      break
    end
    if not periodic then
      total = total + value
    end
  end
  return count
end

function F:TIMETODIE(filter)
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 0 end
  local health, max, prediction, absorb, healAbsorb, isdead = unpack(Cache:GetHealth(guid) or {})
  if not health then return 0 end
	local time = tonumber(filter.name) or 5
  local damage = getDamageTaken(guid,time)
  local heal = getHealTaken(guid,time)
  health = health + prediction + absorb
  if heal>=damage then return 3600 end
  return health/(damage-heal)*time
end

function F:LASTCASTSEND(filter)
  assert(filter.name)
  local data = Cache.cache.castSend[filter.name]
  if not data then return 120 end
  return GetTime() - data.t
end

function F:CASTSTART(filter)
  assert(filter.name)
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 0 end
  local data = Cache.cache.castStartTo[filter.name]
  if not data then return 120 end
  data = data[guid]
  if not data then return 120 end
  return GetTime() - data.t
end

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
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 0 end
  local pguid = Cache:Call("UnitGUID","player")
  local data = Cache.cache.castSuccessTo[pguid]
  if not data then return 120 end
  data = data[filter.name]
  if not data then return 120 end
  data = data[guid]
  if not data then return 120 end
  return GetTime() - data.t
end

function F:ALLCASTSUCCESSED(filter)
  assert(filter.name)
  local guid = Cache:Call("UnitGUID",filter.unit)
  if not guid then return 0 end
  local pguid = Cache:Call("UnitGUID","player")
  local data = Cache.cache.castSuccessTo[pguid]
  if not data then return 120 end
  data = data[filter.name]
  if not data then return 120 end
  data = data.last
  if not data then return 120 end
  return GetTime() - data.t
end

function F:AURANUM(filter)
  local pguid = Cache:Call("UnitGUID","player")
  local data = Cache.cache.auraTo[pguid]
  if not data then return 0 end
  data = data[filter.name]
  if not data then return 0 end
  local count = 0
  for k,v in pairs(data) do
    count = count + 1
  end
  return count
end
