local filterName = "UtilFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName)
local color = "DFDF3F"
local L = setmetatable({},{__index = function(t,k) return k end})

local CombatLogFilter

function F:OnInitialize()
  local blue = "3F7FBF"
  self:RegisterFilter("AUTOON",L["auto ~= 0"],{},nil,blue)
  self:RegisterFilter("PARAMVALUE",L["Check Param"],nil,nil,blue)
  self:RegisterFilter("BURST",L["Is Bursting"],{},nil,blue)
  self:RegisterFilter("PARAMEXPIRED",L["Param Not Expired"],{name={}},nil,blue)
  self:RegisterFilter("AOENUM",L["AOE Count"],{name={name=L["Radius | Scan Interval | Spell ID"]},value={},greater={}},nil,blue)
  self:RegisterFilter("FASTSPELL",L["Fast Spell"],{unit={},name={name="spell ID | Cooldown | Range | Is help"}},nil,"FF7D0A")
  self:RegisterFilter("CD",L["Spell Cooldown"])
  self:RegisterFilter("ICD",L["Item Cooldown"])
  self:RegisterFilter("CHARGE",L["Spell Charge"])
  self:RegisterFilter("KNOWS",L["Spell Known"],{name={}})
  self:RegisterFilter("ISUSABLE",L["Spell Usable"],{name={}})
  self:RegisterFilter("CSPELL",L["Cursor Spell"],{name={}})
  self:RegisterFilter("CANCAST",L["Bar Cast"],{})
  self:RegisterFilter("STARTMOVETIME",L["Since Start Move"],{value={},greater={}})
  self:RegisterFilter("SPEEDTIME",L["Since Stop Move"],{value={},greater={}})
  self:RegisterFilter("STANCE",L["Stance"],{value={}})
  self:RegisterFilter("RUNE",L["Rune"],{name={name=L["Offset"]},value={},greater={}})
  self:RegisterFilter("CDENERGY",L["CD Energy"],{name={name=L["Spell ID | CD Time "]},value={},greater={}})
  self:RegisterFilter("TOTEMTIME",L["Totem Time"],{name={},value={},greater={}},{
    [1]=L["Fire"],
    [2]=L["Eath"],
    [3]=L["Water"],
    [4]=L["Air"],
  })
  CombatLogFilter = Filter:GetModule("CombatLogFilter")
end

function F:RegisterFilter(key,name,keys,subtypes,c)
  assert(self[key])
  Core:RegisterFilter(key,{
    name = name,
    fcn = self[key],
    color = c or color,
    keys = keys or {name= {},greater= {},value= {}},
    subtypes = subtypes,
  })
end
function F:AUTOON(filter)
  return Core:GetParam("auto") ~= 0
end
function F:PARAMVALUE(filter)
  local name = filter.name and filter.name[1] or "auto"
  return Core:GetParam(name)
end
function F:BURST(filter)
  return Core:GetParamNotExpired("burst")
end
function F:PARAMEXPIRED(filter)
    local name = filter.name and filter.name[1] or "burst"
  return Core:GetParamNotExpired(name)
end

local function checkSwingInRange (radius,time)
  local t = GetTime()
  local count = 0
  for guid, to in pairs(Cache.cache.damageTo) do
    if to.Swing then
      local data = to.Swing.last
      if data and t-data.t<time then
        local isdead = select(6,Cache:GetHealth(guid))
        if isdead==false and Cache:FlagIsSet(guid,COMBATLOG_OBJECT_REACTION_FRIENDLY)==false then
          local x,y,z,f,d,s = Cache:GetPosition(guid)
          if d and d-s<radius then
            count = count + 1
          end
        end
      end
    end
  end
  return count
end

function F:AOENUM(filter)
  filter.value = filter.value or 2
  -- local value = Core:GetParam("target")
  local value = 0
  if value > filter.value then return value end
  local pguid = Cache:UnitGUID("player")
  local spells = Core:ToValueTable(filter.name)
  local radius,time = unpack(spells,1,2)
  radius = radius or 8
  time = time or 5
  tremove(spells,1)
  tremove(spells,1)
  for i,spellId in ipairs(spells) do
    value = max(value,CombatLogFilter:GetSpellHitCount(pguid,spellId,time))
    if value > filter.value then return value end
  end
  value = max(value,checkSwingInRange(radius,time))
  if value > filter.value then return value end
  return value
end

function F:FASTSPELL(filter)
  local spellId, cdthd, range, ishelp = unpack(Core:ToValueTable(filter.name),1,4)
  if not cdthd or cdthd == "" then cdthd = 0.2 end
  ishelp = ishelp and ishelp ~= 0 and true or false
  assert(spellId)
  local cd, charge, know, usable = Cache:GetSpellCooldown(spellId)
  -- self:Print(cd, charge, know, usable)
  if cd > cdthd or not know or not usable then
    return false
  end
  local name, rank, icon, castingTime, minRange, maxRange, spellID = Cache:Call("GetSpellInfo",spellId)
  if filter.unit and not(filter.unit == "player" and ishelp) then
    local guid = Cache:UnitGUID(filter.unit)
    if not guid then return false end
    local exists,harm,help = Cache:GetExists(guid,filter.unit)
    if not exists or ishelp and not help or not ishelp and not harm then
      return false
    end
    -- local isdead = Cache:Call(UnitIsDeadOrGhost,filter.unit)
    local isdead = select(6,Cache:GetHealth(guid))
    if isdead then
      -- self:Print(AirjHack:GetDebugChatFrame(),"isdead",filter.unit,name)
      return false
    end
    local x,y,z,f,d,s = Cache:GetPosition(guid)
    if not x then return false end
    if not range then
      range = maxRange
    end
    assert(range)
    if range == 0 then range = 1.33 end
    if d > math.max(5,range + s + 1.5) then
      return false
    end
  end
  if castingTime > 0 then
    if not F:CANCAST() then
      return false
    end
  end
    -- self:Print("FASTSPELL",unit)
  return true
end
function F:CD(filter)
  filter.value = filter.value or 0.2
  local name = filter.name and filter.name[1] or 61304
  local value = Cache:GetSpellCooldown(name)
  return value
end

function F:ICD(filter)
  assert(type(filter.name)=="table")
  local name = filter.name[1]
  local start, duration,enable = Cache:Call("GetItemCooldown",name)
  local value = not start and 300 or enable and 0 or (duration - (GetTime() - start))
  return value
end

function F:CHARGE(filter)
  assert(type(filter.name)=="table")
  local name = filter.name[1]
  local _,value = Cache:GetSpellCooldown(name)
  return value
end

function F:KNOWS(filter)
  assert(type(filter.name)=="table")
  local name = filter.name[1]
  local _,_,value = Cache:GetSpellCooldown(name)
  return value
end

function F:ISUSABLE(filter)
  assert(type(filter.name)=="table")
  local name = filter.name[1]
  local _,_,_,value = Cache:GetSpellCooldown(name)
  return value
end

function F:CSPELL(filter)
  assert(filter.name)
  local keys = Core:ToKeyTable(filter.name)
  for k,v in pairs(keys) do
    local spellName = Cache:Call("GetSpellInfo",k)
    if Cache:Call("IsCurrentSpell",spellName) then
      local castName = Cache:Call("UnitCastingInfo","player")
      local channelName = Cache:Call("UnitChannelInfo","player")
      if spellName ~= castName and spellName ~= channelName then
        return true
      end
    end
  end
  return false
end

function F:CANCAST(filter)
  local notMoving=(Cache:Call("GetUnitSpeed","player") == 0 and not Cache:Call("IsFalling"))
  if notMoving then return true end
  local guid = Cache:UnitGUID("player")
  local buffs = Cache:GetBuffs(guid,"player",{[137587]=true})
  return #buffs > 0
end

function F:STARTMOVETIME(filter)
  local t = GetTime()
  for i,v in ipairs(Cache.cache.speed) do
    if v.value == 0 then
      return t-v.t
    end
  end
  return 120
end

function F:SPEEDTIME(filter)
  local t = GetTime()
  for i,v in ipairs(Cache.cache.speed) do
    if v.value ~= 0 then
      return t-v.t
    end
  end
  return 120
end

function F:STANCE(filter)
  return (filter.value or 0) == (Cache:Call("GetShapeshiftForm") or 0)
end

function F:RUNE(filter)
  -- assert(type(filter.name)=="table")
  local offset = filter.name and filter.name[1] or 0
  local t = GetTime()
  local value = 0
  for slot = 1,6 do
    local start, duration, runeReady = Cache:Call("GetRuneCooldown",slot)
    if runeReady or (t+offset>start+duration) then
      value = value +1
    end
  end
  return value
end

function F:TOTEMTIME(filter)
	assert(filter.subtype)
  local names = Core:ToKeyTable(filter.name)
	local value = 0
	if filter.subtype then
		local haveTotem, name, startTime, duration = GetTotemInfo(tonumber(filter.subtype))
		if haveTotem and (names[name] or not filter.name) then
			value = startTime + duration - GetTime()
		end
	end
  return value
end

function F:CDENERGY(filter)
  filter.value = filter.value or 50
  local name = filter.name and filter.name[1]
  assert(name)
  local cdoffset = filter.name and filter.name[2] or 0
  local cd = Cache:GetSpellCooldown(name)
  cd = math.max(cd-cdoffset,0)
  local inactiveRegen, activeRegen = GetPowerRegen()
  local power = Cache:Call("UnitPower","player",SPELL_POWER_ENERGY)
  power = power + cd*activeRegen
  return power
end
