local filterName = "UtilFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName, "AceEvent-3.0")
local color = "DFDF3F"
local L = setmetatable({},{__index = function(t,k) return k end})

local CombatLogFilter

function F:OnInitialize()
  local blue = "3F7FBF"
  self:RegisterFilter("AUTOON",L["auto ~= 0"],{},nil,blue)
  self:RegisterFilter("PARAMVALUE",L["Check Param"],nil,nil,blue)
  self:RegisterFilter("BURST",L["Is Bursting"],{},nil,blue)
  self:RegisterFilter("PARAMEXPIRED",L["Param Not Expired"],{name={}},nil,blue)
  self:RegisterFilter("AOENUM",L["AOE Count"],{name={name=L["Radius | Scan Interval | Spell ID"]},value={},greater={},unit={}},nil,blue)
  self:RegisterFilter("FASTSPELL",L["Fast Spell"],{unit={},name={name="spell ID | Cooldown | Range | Is help"}},nil,"FF7D0A")
  self:RegisterFilter("CD",L["Spell Cooldown"])
  self:RegisterFilter("CDDEF",L["CD Different"],{name={name="spell ID 1 | spell ID 2 | times"},greater= {},value= {}})
  self:RegisterFilter("SPELLCOUNT",L["Spell Count"])
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
  self:RegisterFilter("NEXTINSANITY",L["Next Insanity"])
  self:RegisterFilter("TOTEMTIME",L["Totem Time"],{name={},value={},greater={}},{
    [1]=L["Fire"],
    [2]=L["Eath"],
    [3]=L["Water"],
    [4]=L["Air"],
  })
  CombatLogFilter = Filter:GetModule("CombatLogFilter")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
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
  local value = Core:GetParam(name)
  return value and value~=0 or false
end
function F:BURST(filter)
  if Core:GetParam("cd") > 60 then
    return true
  end
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

local function checkEnemyInRange (radius,time,unit)
  local t = GetTime()
  local count = 0
  local center
  if unit then
    local guid = UnitGUID(unit)
    center = {Cache:GetPosition(guid)}
    if not center[1] then return 0 end
  end
  for guid, data in pairs(Cache.cache.exists) do
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

function F:AOENUM(filter)
  filter.value = filter.value or 2
  -- local value = Core:GetParam("target")
  local value = 0
  if value > filter.value then return value end
  local pguid = Cache:UnitGUID("player")
  local spells = filter.name or {}
  local radius,time = unpack(Core:ToValueTable(filter.name),1,2)
  radius = radius or 8
  time = time or 5
  for i=3,100 do
    spellId = spells[i]
    value = max(value,CombatLogFilter:GetSpellHitCount(pguid,spellId,time))
    if value > filter.value then return value end
  end
  value = max(value,checkEnemyInRange(radius,time,filter.unit))
  if value > filter.value then
     return value
  end
  value = max(value,Core:GetParam("target"))
  if value > filter.value then
     return value
   end
  return value
end

function F:FASTSPELL(filter)
  local spellId, cdthd, range, ishelp = unpack(filter.name,1,4)
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

    local buffs = Cache:GetBuffs(guid,filter.unit,{[209915]=true})
    if #buffs>0 then
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



local fstart, sstart, stotal
function F:COMBAT_LOG_EVENT_UNFILTERED (event, t, realEvent, ...)
  local sourceGUID = select(2,...)
  if sourceGUID == UnitGUID("player") then
    local spellId = select(10,...)
    if realEvent == "SPELL_AURA_APPLIED" then
      if spellId == 194249 then
        fstart = GetTime()
        stotal = 0
      elseif spellId == 205065 or spellId == 47585 then
        sstart = GetTime()
      end
    end

    if realEvent == "SPELL_AURA_REMOVED" then
      if spellId == 194249 then
        if fstart then
          Core:Print("shadow form last "..(GetTime()-fstart))
        end
        fstart = nil
        stotal = nil
      elseif spellId == 205065 or spellId == 47585 then
        if stotal and sstart then
          stotal = stotal + GetTime() - sstart
          Core:Print("shadow stoped "..(GetTime()-sstart))
        end
        sstart = nil
      end
    end
  end
    -- body...
end

function F:NEXTINSANITY(filter)
  filter.value = filter.value or 10
  local power = Cache:Call("UnitPower","player",SPELL_POWER_INSANITY)
  local name, offset = unpack(Core:ToValueTable(filter.name),1,2)
  offset = offset or 0
  name = name or 61304
  local gcd = Cache.cache.gcd.duration
  local guid = Cache:PlayerGUID()
  local buffs = Cache:GetBuffs(guid,"player",{[194249]=true})
  if buffs[1] and fstart then
    local value = Cache:GetSpellCooldown(name)
    local speed = 10+(GetTime()-fstart-stotal)/2
    power = power - speed*(value+offset+0.2)
  end
  local castName, _, _, _, startTime, endTime = Cache:Call("UnitCastingInfo","player")
  local spellName = GetSpellInfo(8092)
  local spellName2 = GetSpellInfo(34914)

  local data = Cache.cache.castStartTo[8092]
  local data2 = Cache.cache.castStartTo[34914]
  local mbtime = 10
  if data and data.last and data.last.t then
    mbtime = GetTime()-data.last.t
  end
  local vptime = 10
  if data2 and data2.last and data2.last.t then
    vptime = GetTime()-data.last.t
  end
  if castName == spellName or data and mbtime<gcd+0.4 then
    local insbuffs = Cache:GetBuffs(guid,"player",{[193223]=true})
    if #insbuffs>0 then
      power = power + 12*2.5
    else
      power = power + 12
    end
  elseif castName == spellName2 or data2 and vptime<gcd+0.4 then
    local insbuffs = Cache:GetBuffs(guid,"player",{[193223]=true})
    if #insbuffs>0 then
      power = power + 4*2.5
    else
      power = power + 4
    end
  end

  return power
end


function F:CDDEF(filter)
  filter.value = filter.value or 0
  assert(filter.name)
  local spellId1, spellId2, times = unpack(Core:ToValueTable(filter.name))
  assert(spellId1)
  assert(spellId2)
  times = times or 1
  local value1 = Cache:GetSpellCooldown(spellId1)
  local value2 = Cache:GetSpellCooldown(spellId2)
  return value1*times-value2
end


function F:SPELLCOUNT(filter)
  filter.value = filter.value or 0
  local name = filter.name and filter.name[1] or 61304
  local value = GetSpellCount(name)
  return value
end

function F:ICD(filter)
  assert(type(filter.name)=="table")
  local name = filter.name[1]
  local start, duration,enable = Cache:Call("GetItemCooldown",name)
  if not start then return 300 end
  if start == 0 then return 0 end
  return (duration - (GetTime() - start))
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
  local buffs = Cache:GetBuffs(guid,"player",{[108839]=true,[193223]=true})
  return #buffs > 0
end

function F:STARTMOVETIME(filter)
  local t = GetTime()
  for i = #Cache.cache.speed,1,-1 do
    local v = Cache.cache.speed[i]
    if v.value == 0 then
      return t-v.t
    end
  end
  return 120
end

function F:SPEEDTIME(filter)
  local t = GetTime()
  for i = #Cache.cache.speed,1,-1 do
    local v = Cache.cache.speed[i]
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
