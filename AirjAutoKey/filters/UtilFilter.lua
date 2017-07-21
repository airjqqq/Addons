local filterName = "UtilFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName, "AceEvent-3.0", "AceTimer-3.0")
local color = "DFDF3F"
local L = setmetatable({},{__index = function(t,k) return k end})

local CombatLogFilter

function F:OnInitialize()
  local blue = "3F7FBF"
  self:RegisterFilter("AUTOON",L["auto ~= 0"],{},nil,blue)
  self:RegisterFilter("LUASTRING",L["Lua"],{unit={},name={name="lua string"},greater={},value={}},nil,blue)
  self:RegisterFilter("TEMPLATE",L["Template"],{name={name="Template name"}},nil,blue)
  self:RegisterFilter("INWORLD",L["In World"],{},nil,blue)
  self:RegisterFilter("ISFRAMESHOW",L["Frame Shown"],{name={}},nil,blue)
  self:RegisterFilter("PARAMVALUE",L["Check Param"],{name={}},nil,blue)
  self:RegisterFilter("PARAMVALUE2",L["Check Value"],nil,nil,blue)
  self:RegisterFilter("PARAMVALUESTARTED",L["Param Started"],nil,nil,blue)
  self:RegisterFilter("PARAMVALUEREMAIN",L["Param Remain"],nil,nil,blue)
  self:RegisterFilter("BURST",L["Is Bursting"],{},nil,blue)
  self:RegisterFilter("MOUNTED",L["Is Mounted"],{},nil,blue)
  self:RegisterFilter("CANLOOT",L["Can Loot"],{},nil,blue)
  self:RegisterFilter("PARAMEXPIRED",L["Param Not Expired"],{name={}},nil,blue)
  self:RegisterFilter("AOENUM",L["AOE Count"],{name={name=L["Radius | Scan Interval | Spell ID"]},value={},greater={},unit={}},nil,blue)
  self:RegisterFilter("LINKNUM",L["Link Count"],{name={name=L["Range"]},value={},greater={},unit={}},nil,blue)
  self:RegisterFilter("AIRCIRCLE",L["Circle max"],{name={name=L["Max Range | Radius | Is help"]},value={},greater={}})
  self:RegisterFilter("FASTSPELL",L["Fast Spell"],{unit={},name={name="spell ID | Cooldown | Range | Is help"}},{
    IGNOREUSABLE = L["Ignore usable"]
  },"FF7D0A")
  self:RegisterFilter("CD",L["Spell Cooldown"])
  self:RegisterFilter("CDDEF",L["CD Different"],{name={name="spell ID 1 | spell ID 2 | times"},greater= {},value= {}})
  self:RegisterFilter("SPELLCOUNT",L["Spell Count"])
  self:RegisterFilter("ICD",L["Item Cooldown"])
  self:RegisterFilter("ECD",L["Equipt Cooldown"])
  self:RegisterFilter("EITEM",L["Equipt Item"])
  self:RegisterFilter("CHARGE",L["Spell Charge"])
  self:RegisterFilter("SPELLCOST",L["Spell Cost"])
  self:RegisterFilter("KNOWS",L["Spell Known"],{name={}})
  self:RegisterFilter("ISUSABLE",L["Spell Usable"],{name={}})
  self:RegisterFilter("CSPELL",L["Cursor Spell"],{name={}})
  self:RegisterFilter("CANCAST",L["Bar Cast"],{})
  self:RegisterFilter("STARTMOVETIME",L["Since Start Move"],{value={},greater={}})
  self:RegisterFilter("SPEEDTIME",L["Since Stop Move"],{value={},greater={}})
  self:RegisterFilter("STANCE",L["Stance"],{value={}})
  self:RegisterFilter("STEALTH",L["Stealth"],{})
  self:RegisterFilter("RUNE",L["Rune"],{name={name=L["Offset"]},value={},greater={}})
  self:RegisterFilter("BUFFENERGY",L["Buff Energy"],{name={name=L["Spell ID | CD Time "]},value={},greater={}})
  self:RegisterFilter("CDDEBUFF",L["CD Debuff"],{name={name=L["Spell ID | CD Time "]},value={},greater={},unit={}})
  self:RegisterFilter("CDENERGY",L["CD Energy"],{name={name=L["Spell ID | CD Time "]},value={},greater={}})
  self:RegisterFilter("CDFOCUS",L["CD Focus"],{name={name=L["Spell ID | CD Time | Fps"]},value={},greater={}})
  self:RegisterFilter("UACOUNT",L["UA Count"],{value={},greater={},unit={}})
  self:RegisterFilter("PMULTIPLIER",L["P multiplier"],{value={},greater={},unit={},name={}})
  self:RegisterFilter("NEXTINSANITY",L["Next Insanity"])
  self:RegisterFilter("LUNAPOWER",L["Luna Power"])
  self:RegisterFilter("INSANITYDRAINSTACK",L["Insanity Drain"])
  -- self:RegisterFilter("FOCUSTTM",L["Focus TTM"])
  self:RegisterFilter("TOTEMTIME",L["Totem Time"],{name={},value={},greater={}},{
    [1]=L["Fire"],
    [2]=L["Eath"],
    [3]=L["Water"],
    [4]=L["Air"],
  })
  CombatLogFilter = Filter:GetModule("CombatLogFilter")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  self:RegisterEvent("UNIT_POWER")
  self:ScheduleRepeatingTimer(function()
    self:InsanityTimer()
  end,0.01)
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



function F:TEMPLATE(filter)
  assert(filter.name)
  for i,n in pairs(filter.name) do
    Core.templatePassed[n] = Core.templatePassed[n] or {}
    local air = Core:GetAirUnit() or "NOAIR"
    local passed
    if Core.templatePassed[n][air] == nil then
      local templateFliter = Core:FindTemplateFilter(n)
      passed = Core:CheckFilter(templateFliter,1)
      Core.templatePassed[n][air] = passed and true or false
    else
      passed = Core.templatePassed[n][air]
    end
    if not passed then
      return false
    end
  end
  return true
end

function F:LUASTRING(filter)
  local luas = "local filter = ... "..table.concat(filter.name,",")
  local toRet = loadstring(luas)(filter)
  return toRet
end

function F:AUTOON(filter)
  return Core:GetParam("auto") ~= 0
end
function F:PARAMVALUE(filter)
  local name = filter.name and filter.name[1] or "auto"
  local value = Core:GetParam(name)
  return value and value~=0 or false
end
function F:PARAMVALUE2(filter)
  local name = filter.name and filter.name[1] or "auto"
  local value = Core:GetParam(name)
  return value or 0
end
function F:PARAMVALUEREMAIN(filter)
  local name = filter.name and filter.name[1] or "auto"
  local value = Core:GetParamTemporaryRemain(name)
  return value or 0
end
function F:PARAMVALUESTARTED(filter)
  local name = filter.name and filter.name[1] or "auto"
  local value = Core:GetParamTemporaryStarted(name)
  return value or 0
end
function F:BURST(filter)
  if Core:GetParam("cd") > 60 then
    return true
  end
  return Core:GetParamNotExpired("burst")
end
function F:MOUNTED(filter)
  return IsMounted()
end

function F:ISFRAMESHOW(filter)
  local name = filter.name[1]
  if name then
    return _G[name] and type(_G[name].IsVisible)=="function" and _G[name]:IsVisible()
  end
end


function F:CANLOOT(filter)
	local ct = GetTime()
  for data in Cache.cache.died:iterator() do
		if data.t and ct - data.t <1 and not data.looted then
  		local guid = data.guid
			local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
			if isdead then
				local x1,y1,z1,f1,distance,s = Cache:GetPosition(guid)
				if distance and (distance <= 5 or distance - s < 2.83) then
					return true
				end
			end
		end
	end
end
function F:PARAMEXPIRED(filter)
    local name = filter.name and filter.name[1] or "burst"
  return Core:GetParamNotExpired(name)
end

local function checkEnemyInRange (radius,unit)
  -- local t = GetTime()
  local count = 0
  local center
  if unit then
    local guid = UnitGUID(unit)
    center = {Cache:GetPosition(guid)}
    if not center[1] then return 0 end
  end
  for guid,data in pairs(Cache.exists) do
    if data[2] then
      local health,_,_,_,_,isdead = Cache:GetHealth(guid)
      if health > 100 and isdead==false then
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

local function getNearestEnemy(start,range,exclude)
  exclude = exclude or {}
  if not start then return end
  local center = {Cache:GetPosition(start)}
  if not center[1] then return end
  local nearest = range
  local nearestGUID
  for guid,data in pairs(Cache.exists) do
    if data[2] and not exclude[guid] then
      local isdead = select(6,Cache:GetHealth(guid))
      if isdead==false then
        local x,y,z,f,d,s = Cache:GetPosition(guid)
        if x then
          local dx,dy,dz = x-center[1],y-center[2],z-center[3]
          local d = sqrt(dx*dx+dy*dy+dz*dz)
          if d and d-s<range then
            if nearest > d-s then
              nearest = d-s
              nearestGUID = guid
            end
          end
        end
      end
    end
  end
  return nearestGUID
end

local function checkEnemyLink (range,unit)
  local start = UnitGUID(unit)
  local exclude = {}
  local count = 0
  while start do
    exclude[start] = true
    start = getNearestEnemy(start,range,exclude)
    count = count + 1
  end
  return count
end

local function rangeD(x,y,z,a,b,c)
  x,y,z = x-a,y-b,z-c
  return math.sqrt(x*x+y*y+z*z)
end




local function getUnitInCircle(cx,cy,cz,r,ishelp)
  local value = 0
  local maxr = 0
  local outofpvp
  local _,currentZoneType = IsInInstance()
  if currentZoneType ~= "pvp" and currentZoneType ~= "arena" then
    outofpvp = true
  end
  local pguid = Cache:PlayerGUID()
  for g,t in pairs(AirjHack.objectCache) do
    if bit.band(t,0x08)~=0 then
      if outofpvp or strfind(g,"Player-") then
        local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(g)
        if health and health> 100 and not dead then
          local x,y,z,f,d = Cache:GetPosition(g)
          local cr = rangeD(x,y,z,cx,cy,cz)
          if d and d<60 and cr < r then
            local _,harm,help = Cache:GetExists(g)
            if harm and not ishelp or help and ishelp then
              value = value + 1
              if cr > maxr then
                maxr = cr
              end
            end
          end
        end
      end
    end
  end
  return value,maxr
end

function F:AIRCIRCLE(filter)
  local range,radius,ishelp = unpack(Core:ToValueTable(filter.name),1,3)
  local points = {}
  local outofpvp
  local _,currentZoneType = IsInInstance()
  if currentZoneType ~= "pvp" and currentZoneType ~= "arena" then
    outofpvp = true
  end
  for g,t in pairs(AirjHack.objectCache) do
    if bit.band(t,0x08)~=0 then
      if outofpvp or strfind(g,"Player-") then
        local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(g)
        if health and health> 100 and not dead then
          local x,y,z,f,d = Cache:GetPosition(g)
          if d<60 then
            local _,harm,help = Cache:GetExists(g)
            if harm and not ishelp or help and ishelp then
              tinsert(points,{x,y,z,f,d})
            end
          end
        end
      end
    end
  end
  local maxvalue,minr = 0,0
  local guid = Cache:PlayerGUID()
  local px,py,pz = Cache:GetPosition(guid)
  for i,p1 in ipairs(points) do
    for i,p2 in ipairs(points) do
      local d = rangeD(p1[1],p1[2],p1[3],p2[1],p2[2],p2[3])
      if d < radius * 2 then
        local x,y,z = (p1[1]+p2[1])/2,(p1[2]+p2[2])/2,(p1[3]+p2[3])/2
        if rangeD(x,y,z,px,py,pz) < range then
          local value = 0
          local mr = 0
          for i,p in ipairs(points) do
            local r = rangeD(x,y,z,p[1],p[2],p[3])
            if r < radius then
              value = value + 1
              if r > mr then mr = r end
            end
          end
          if not maxvalue or value > maxvalue or value==maxvalue and mr<minr then
            maxvalue = value
            minr = mr
            AirjAutoKey.center = {x,y,z}
          end
        end
      end
    end
  end
  return maxvalue
end

function F:AIRCIRCLE1(filter)
  local range,radius,ishelp = unpack(Core:ToValueTable(filter.name),1,3)
  local guid = Cache:PlayerGUID()
  local x,y,z,f,d,s = Cache:GetPosition(guid)
  local maxvalue,minr
  minr = 0
  for i = -50,50,5 do
    for j = -50,50,5 do
      local r = math.sqrt(i*i+j*j)
      if r < range then
        local value,mr = getUnitInCircle(x+i,y+j,z,radius,ishelp)
        -- local value = 1
        if not maxvalue or value > maxvalue or value==maxvalue and mr<minr then
          maxvalue = value
          minr = mr
          AirjAutoKey.center = {x+i,y+j,z}
        end
      end
    end
  end
  return maxvalue
end

function F:AOENUM(filter)
  filter.value = filter.value or 2
  filter.name = filter.name or {8}
  range = filter.name[1] or 8
  return checkEnemyInRange(range,filter.unit)
end


function F:LINKNUM(filter)
  filter.name = filter.name or {8}
  filter.unit = filter.unit or "target"
  range = filter.name[1] or 8
  local value = checkEnemyLink(range,filter.unit)
  return value
end


function F:TARGETNUMBER(filter)
  filter.value = filter.value or 2
  value = max(value,Core:GetParam("target"))
  return value or 1
 end

 local notinrangeCache = {}

function F:FASTSPELL(filter)
  local spellId, cdthd, range, ishelp = unpack(filter.name,1,4)
  if not cdthd or cdthd == "" then cdthd = 0.2 end
  ishelp = ishelp and ishelp ~= 0 and true or false
  assert(spellId)
  local maxRange
  if spellId == 0 then
    maxRange = 0
  else
    local cd, charge, know, usable = Cache:GetSpellCooldown(spellId)
    -- self:Print(cd, charge, know, usable)
    if filter.subtype == "IGNOREUSABLE" then usable = true end
    if cd > cdthd or not know or not usable then
      return false
    end
    maxRange = select(6,Cache:Call("GetSpellInfo",spellId))
  end
  if filter.unit and not(filter.unit == "player" and ishelp) then
    local guid = Cache:UnitGUID(filter.unit)
    if not guid then return false end
    local exists,harm,help = Cache:GetExists(guid,filter.unit)
    if not exists or ishelp and not help or not ishelp and not harm then
      return false
    end

    if not range then
      range = maxRange
    end
    if ishelp and (range <=45) then
      local now = GetTime()
      if not notinrangeCache.t or now > notinrangeCache.t then
        wipe(notinrangeCache)
        notinrangeCache.t = now
      end
      local ni = notinrangeCache[guid]
      if ni == nil then
        local i,c = UnitInRange(filter.unit)
        if c and not i then
          ni = true
        elseif c and i then
          ni = false
        else
          ni = "unchecked"
        end
        notinrangeCache[guid] = ni
      end
      if ni == true then
        return false
      elseif ni == false then
        if range >=40 and range <=45 then
          -- return true
        end
      end
    end
    -- local isdead = Cache:Call(UnitIsDeadOrGhost,filter.unit)
    local isdead = select(6,Cache:GetHealth(guid))
    if isdead then
      -- self:Print(AirjHack:GetDebugChatFrame(),"isdead",filter.unit,name)
      return false
    end
    local x,y,z,f,d,s = Cache:GetPosition(guid)
    if not x then return false end
    assert(range)
    local mr,md = 5,1.33
    do
      -- feral druid
      local _,_,value = Cache:GetSpellCooldown(197488)
      if value then
        mr,md = 10, 6.33
      end
      _,_,value = Cache:GetSpellCooldown(202790)
      if value and (spellId == 1079 or spellId == 22570) then
        mr = mr + 5
        md = md + 5
      end

        --windwalker monk
      _,_,value = Cache:GetSpellCooldown(205003)
      if value and (spellId == 113656) then
        mr = mr + 5
        md = md + 5
      end
      _,_,value = Cache:GetSpellCooldown(201769)
      if value and (spellId == 116095) then
        mr = mr + 7
        md = md + 7
      end
      _,_,value = Cache:GetSpellCooldown(198500)
      if value and (spellId == 163201) then
        mr = mr + 10
        md = md + 10
      end

    end
    if range == 0 then range = md end
    if d > math.max(mr,range + s + 1.5) then
      return false
    end
  end
  -- if castingTime > 0 then
  --   if not F:CANCAST() then
  --     return false
  --   end
  -- end
    -- self:Print("FASTSPELL",unit)
  return true
end
function F:CD(filter)
  filter.value = filter.value or 0.2
  local name = filter.name and filter.name[1] or 61304
  local value = Cache:GetSpellCooldown(name)
  return value
end

function F:UNIT_POWER(event,unit,type)
  if unit=="player" and type == "INSANITY" then
    local power = Cache:Call("UnitPower","player",SPELL_POWER_INSANITY)

  end
end

local fstart, sstart, stotal
local pmultiplier = {
  [  1079] = {},
  [155722] = {},
}

local function getPmultiplier()

  local multiplier = {
    [145152] = 1.5,
    [  5217] = 1.15,
    [ 52610] = 1.25,
  }
  local pm = 1
  for s,m in pairs(multiplier) do
    local name = GetSpellInfo(s)
    if UnitBuff("player",name) then
      pm = pm*m
    end
  end
  return pm
end

function F:COMBAT_LOG_EVENT_UNFILTERED (event, t, realEvent, ...)
  local sourceGUID = select(2,...)
  local destGUID = select(6,...)
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
    if realEvent == "SPELL_CAST_SUCCESS" then
      if spellId == 15407 then
        -- print("Start"..GetTime())
      end
    end
    if realEvent == "SPELL_PERIODIC_DAMAGE" then
      if spellId == 15407 then
        -- print(GetTime())
      end
    end
    if realEvent == "SPELL_CAST_SUCCESS" then
      if spellId == 1079 or spellId == 155722 then
        if destGUID then
          pmultiplier[spellId][destGUID] = getPmultiplier()
        end
      end
    end
  end
    -- body...
end


function F:PMULTIPLIER(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return end
  local spellId = filter.name[1]
  local dpm = pmultiplier[spellId][guid] or 1
  local cpm = getPmultiplier() or 1
  return cpm/dpm
end

function F:UACOUNT(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return 0 end
  local casting
  local data = Cache.cache.casting:find({guid=guid,spellId=30108})
  if data and GetTime() - data.endTime/1000 < 0.5 then casting = true end

  local debuffs = Cache:GetDebuffs(guid,filter.unit,{[233496]=true,[233497]=true,[233498]=true,[233499]=true,[233490]=true,},true)

  local percents = {0,0,0,0,0}
  for i,v in ipairs(debuffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local percent = (expires - GetTime())/duration
    for j = 1,5 do
      if percent > (5.8-j)/5.3 then
        percents[j] = percents[j] + 1
        break
      end
    end
  end

  if casting and percents[1] <= 0 then
    percents[1] = percents[1] + 1
  end
  local count = 0
  for i = 1,5 do
    count = count + percents[i]
    if count + 1 < i then
      break
    end
  end
  return count
end

function F:INSANITYDRAINSTACK(filter)
  local guid = Cache:PlayerGUID()
  local buffs = Cache:GetBuffs(guid,"player",{[194249]=true})
  if buffs[1] and fstart and stotal then
    return GetTime()-fstart-stotal
  end
  return 0
end
local lastInsanity = 0
local lastInsanityTime = 0
function F:InsanityTimer()
  local power = UnitPower("player",SPELL_POWER_INSANITY)
  if power then
    if power ~= lastInsanity then
      lastInsanityTime = GetTime()
      lastInsanity = power
    end
  end
end

function F:NEXTINSANITY(filter)
  filter.value = filter.value or 10
  local power = Cache:Call("UnitPower","player",SPELL_POWER_INSANITY)
  if power then
    if power ~= lastInsanity then
      lastInsanityTime = GetTime()
      lastInsanity = power
    end
  end
  local name, offset,c = unpack(Core:ToValueTable(filter.name),1,3)
  -- if name == 205448 and not offset then
  --   filter.name[2] = 0.2
  --   offset = 0.2
  -- end
  offset = offset or 0
  if c then
    local haste = GetHaste()
    local gcd = 1.5/(1+haste/100)
    gcd = max(gcd,0.75)
    offset = offset+c*gcd
  end
  name = name or 61304
  local gcd = Cache.cache.gcd.duration
  local guid = Cache:PlayerGUID()
  local buffs = Cache:GetBuffs(guid,"player",{[194249]=true})
  if buffs[1] and fstart then
    local value = Cache:GetSpellCooldown(name)
    local speed = 6+ math.floor(GetTime()-fstart-stotal+1)*0.66
    -- if speed > 55 then
    --   speed = speed + 4
    -- end
    local blzbugdelay = GetTime()-lastInsanityTime
    power = power - speed*blzbugdelay
    power = power - speed*(value+offset+0.1)
  end
  -- local castName, _, _, _, startTime, endTime = Cache:Call("UnitCastingInfo","player")
  -- local spellName = GetSpellInfo(8092)
  -- local spellName2 = GetSpellInfo(34914)
  local casting = 0
  local data = Cache.cache.casting:find({spellId=8092})
  if data and GetTime() - data.endTime/1000 < 0.1 then
    casting  = 15
  end
  data = Cache.cache.casting:find({spellId=34914})
  if data and GetTime() - data.endTime/1000 < 0.1 then
    casting  = 6
  end
  data = Cache.cache.casting:find({spellId=205351})
  if data and GetTime() - data.endTime/1000 < 0.1 then
    casting  = 25
  end
  if casting>0 then
    local insbuffs = Cache:GetBuffs(guid,"player",{[193223]=true})
    if #insbuffs>0 then
      power = power + casting*2
    else
      power = power + casting
    end
  end
  power = math.floor(power)
  return power
end

function F:LUNAPOWER(filter)
  filter.value = filter.value or 10
  local power = Cache:Call("UnitPower","player",SPELL_POWER_LUNAR_POWER)

  local cps = {
    [202768] = 20,
    [202767] = 10,
    [202771] = 40,
    [194153] = 12,
    [109984] = 8,
  }
  local cpms = {
    [194153] = 12,
    [109984] = 8,
  }
  local castSpellId
  local data = Cache.cache.casting:find({})
  if data and GetTime() - data.endTime/1000 < 0.3 then
    castSpellId  = data.spellId
  end
  if castSpellId then
    local buffs = Cache:GetBuffs(UnitGUID("player"),"player",{[202737]=true})
    local cp = cps[castSpellId]
    if cp then
      if cpms[castSpellId] and #buffs > 0 then
        cp = cp*1.25
      end
      power = power + cp
      -- print(cp,power)
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
  if enable~=1 then return 300 end
  if start == 0 then return 0 end
  return (duration - (GetTime() - start))
end
function F:ECD(filter)
  assert(type(filter.name)=="table")
  local name = filter.name[1]
  name = tonumber(name)
  local start, duration,enable = Cache:Call("GetInventoryItemCooldown","player",name)
  if not start then return 300 end
  if enable~=1 then return 300 end
  if start == 0 then return 0 end
  return (duration - (GetTime() - start))
end
function F:EITEM(filter)
  assert(type(filter.name)=="table")
  local name = Core:ToKeyTable(filter.name)
  for i = 1,17 do
    local id = Cache:Call("GetInventoryItemID","player",i)
    if name[id] then
      return true
    end
  end
end

function F:CHARGE(filter)
  assert(type(filter.name)=="table")
  local name = filter.name[1]
  local _,value = Cache:GetSpellCooldown(name)
  return value
end
function F:SPELLCOST(filter)
  assert(type(filter.name)=="table")
  local name = filter.name[1]
  local table = GetSpellPowerCost(name)
  if not table then return false end
  local value = table[1].cost
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
  return Core:Barcast()
  -- local notMoving=(Cache:Call("GetUnitSpeed","player") == 0 and not Cache:Call("IsFalling"))
  -- if notMoving then return true end
  -- local guid = Cache:UnitGUID("player")
  -- local buffs = Cache:GetBuffs(guid,"player",{[108839]=true,[193223]=true})
  -- return #buffs > 0
end

function F:STARTMOVETIME(filter)
  local t = GetTime()
  for v in Cache.cache.speed:iterator() do
    if v.value == 0 then
      return t-v.t
    end
  end
  return 120
end

function F:SPEEDTIME(filter)
  local t = GetTime()
  for v in Cache.cache.speed:iterator() do
    if v.value ~= 0 then
      return t-v.t
    end
  end
  return 120
end

function F:STANCE(filter)
  return (filter.value or 0) == (Cache:Call("GetShapeshiftForm") or 0)
end
function F:STEALTH(filter)
  return Cache:Call("IsStealthed")
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

function F:CDDEBUFF(filter)
  filter.value = filter.value or 50
  local name = filter.name and filter.name[1]
  assert(name)
  local cdoffset = filter.name and filter.name[2] or 0
  local cd = Cache:GetSpellCooldown(name)
  cd = math.max(cd-cdoffset,0)
  local tfilter = {
    type = "DEBUFFSELF",
    name = {select(2,unpack(filter.name))},
    unit = filter.unit,
    greater = filter.greater,
    value = filter.value - cd,
  }
  return self:CheckTypeFilter(tfilter)
end

function F:BUFFENERGY(filter)
  filter.value = filter.value or 50
  local name = filter.name and filter.name[1]
  assert(name)
  local cdoffset = filter.name and filter.name[2] or 0
  local buffs = Cache:GetBuffs(guid,filter.unit,{[name] = true})
  local cd
  if buffs[1] then
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(buffs[1])
    cd = (expires - t)/timeMod
  end
  cd = cd and math.max(cd-cdoffset,0) or 0
  local inactiveRegen, activeRegen = GetPowerRegen()
  local power = Cache:Call("UnitPower","player",SPELL_POWER_ENERGY)
  power = power + cd*activeRegen
  return power
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

function F:CDFOCUS(filter)
  filter.value = filter.value or 50
  local name = filter.name and filter.name[1]
  assert(name)
  local cdoffset = filter.name and filter.name[2] or 0
  local fps = filter.name and filter.name[3] or 0
  local cd = Cache:GetSpellCooldown(name)
  cd = math.max(cd-cdoffset,0)
  local inactiveRegen, activeRegen = GetPowerRegen()
  local power = Cache:Call("UnitPower","player",SPELL_POWER_FOCUS)
  power = power + cd*(activeRegen+fps)
  return power
end

function F:INWORLD(filter)
  local a,b = IsInInstance()
  return b=="none"
end
