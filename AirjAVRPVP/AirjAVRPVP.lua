local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("PVP","AceEvent-3.0","AceTimer-3.0")
local LibPlayerSpells = LibStub('LibPlayerSpells-1.0')
local Cache
function mod:OnInitialize()
  Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
end
AirjAVRPVP = mod

function mod:OnEnable()
  --constants
  local stun = {
    color={1,0.0,0,0.3},
    radius=4,
  }
  local cc = {
    color={1,1,0,0.1},
    radius=5,
  }
  local root = {
    color={0.0,0.2,0.5,0.05},
    color2={0.0,0.4,0.8,0.1},
    radius=3,
  }
  local survival = {
    color={0.5,0.2,0.0,0.05},
    color2={0.8,0.4,0.0,0.1},
    isbuff=true,
    radius=3,
  }
  local burst = {
    color={0.0,0.5,0.0,0.05},
    color2={0.0,0.8,0.0,0.1},
    isbuff=true,
    radius=3,
  }
  local isStun = LibPlayerSpells:GetFlagTester("STUN")
  local isCC = LibPlayerSpells:GetFlagTester("DISORIENT INCAPACITATE")
  local isRoot = LibPlayerSpells:GetFlagTester("ROOT")

  for spellId, flags, providers, modifiedSpells, moreFlags in LibPlayerSpells:IterateSpells("CROWD_CTRL") do
    local data
    if isStun(moreFlags) then
      data = stun
    elseif isCC(moreFlags) then
      data = cc
    elseif isRoot(moreFlags) then
      -- data = root
    end
    if data then
      Core:RegisterAuraCooldowns(spellId,data)
    end
  end
  -- for spellId, flags, providers, modifiedSpells, moreFlags in LibPlayerSpells:IterateSpells("SURVIVAL") do
  --   local data = survival
  --   Core:RegisterAuraCooldowns(spellId,data)
  -- end
  -- for spellId, flags, providers, modifiedSpells, moreFlags in LibPlayerSpells:IterateSpells("BURST") do
  --   local data = burst
  --   Core:RegisterAuraCooldowns(spellId,data)
  -- end
  local mdata = {
    width = 2,
    alpha = 0.4,
    classColor = true,
  }
  local mdata2 = {
    width = 2,
    alpha = 0.4,
    classColor = true,
    length = 5,
  }
  local spells = {
    [118] = 2, -- poly
    -- [28272] = 2, -- poly
    [214634] = 0.8, -- black ice

    [209753] = 2, -- cyclone
    -- [33786] = 2, -- cyclone
    [5782] = 2, --Fear

    [339] = 1.4,
    [8936] = 0.8,
  }
  local pguid = Cache:PlayerGUID()
  if Cache then
    local fcn = function()
      local name,_,_,_,st,et = UnitCastingInfo("player")
      local matched
      local sid,width
      for id,w in pairs(spells) do
        if GetSpellInfo(id) == name then
          matched = true
          sid = id
          width = w
          break
        end
      end
      if matched then
        local data = Cache.cache.castStart:find({sourceGUID = pguid,spellId=sid})
        -- dump({data,sourceGUID = pguid,spellId=sid})
        local guid = data and data.destGUID
        if guid then
          local _,_,_,_,distance = Cache:GetPosition(guid)
          if not self.lcum1 then
            self.lcum1 = Core:CreateBeam({
    					classColor = true,
    					alpha = 0.4,
              removes = GetTime() + 1e100,
    				})
            self.lcum2 = Core:CreateBeam({
    					classColor = true,
    					alpha = 0.4,
              removes = GetTime() + 1e100,
    				})
          end
          local m1 = Core.createdMeshs[self.lcum1]
          local m2 = Core.createdMeshs[self.lcum2]
          if m1 and m2 then
            if m1.target ~= guid then
              m1:SetTarget(guid)
              m2:SetTarget(guid)
            end
            m1.width = width
            m2.width = width
            m1.length = distance
            m2.length = distance*(GetTime()*1000-st)/(et-st)
            m1.visible = true
            m2.visible = true
          end
        end
      else
        if self.lcum1 then
          local m1 = Core.createdMeshs[self.lcum1]
          local m2 = Core.createdMeshs[self.lcum2]
          m1.visible = false
          m2.visible = false
        end
      end
    end
    self:ScheduleRepeatingTimer(function() pcall(fcn) end,0.01)
  end
  local data
  Core:RegisterCreateAreaTrigger(191034,{color={0.0,0.7,0.7,0.2}})
  Core:RegisterCreateAreaTrigger(187651,{color={0.0,0.7,0.7,0.2}})
  Core:RegisterCreateAreaTrigger(194278,{color={0.8,0.8,0,0.2}})
  Core:RegisterCreatureCooldown(100943,{color={0,1,0.5,0.2},spellId=198838})
  self.drawables = {}
  self.timers = {}

  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  self:RegisterEvent("GROUP_ROSTER_UPDATE",self.UpdateArenaUnits,self)
  self:RegisterEvent("ARENA_OPPONENT_UPDATE",self.UpdateArenaUnits,self)
  self:UpdateArenaUnits()
end

function mod:IsInArena()
  -- return IsInInstance() == "arena" or true --debug
  return IsInInstance() == "arena"
end
local function getClassColor(class)
	local d = RAID_CLASS_COLORS[class]
	if d then
		return d.r,d.g,d.b,1
	end
end

local function rotate(x,y,a)
  local s,c = math.sin(a),math.cos(a)
  return x*c - y*s, x*s+y*c
end
local helpLine = {}
do
  local number = 36
  local t = {}
  for i = 1,number do
    local a = i*math.pi*2/number
    local b = a
    if b > math.pi then
      b = 2*math.pi-b
    end
    local size = 1.5
    if math.abs(b)<math.pi/3 then
      size = size*(1+1/math.cos(math.abs(b)-math.pi/3))/2
    end
    local x,y = rotate(0,size,a)
    t[i] = {x,y,0}
  end
  helpLine = {t}
end
local function getArrow(aw2,alf,alb,als,abs,size)
  abs = abs or 0
  local arrow = {
  	{{0,-alb-abs*1.5},{aw2+abs,-(alb-aw2)-abs*0.5},{-aw2-abs,-(alb-aw2)-abs*0.5},{aw2+abs,alf-aw2+abs*0.5},{-aw2-abs,alf-aw2+abs*0.5},{0,alf+abs*1.5}},
    {{aw2+abs,alf-aw2+abs*0.5},{aw2+abs,alf-aw2*3-abs*2.5},{als+abs,alf-als+abs*0.5},{als+abs,alf-als-aw2*2-abs*2.5}},
    {{-aw2-abs,alf-aw2+abs*0.5},{-aw2-abs,alf-aw2*3-abs*2.5},{-als-abs,alf-als+abs*0.5},{-als-abs,alf-als-aw2*2-abs*2.5}},
  }
  local toRet = {}
  local function multi(t,p)
    return {t[1]*p,t[2]*p,0}
  end
  for _,p in ipairs(arrow) do
    for j = 3, #p do
      tinsert(toRet,{multi(p[j-2],size),multi(p[j-1],size),multi(p[j],size)})
    end
  end
  return toRet
end

local harmLine = getArrow(0.4,2.3,1.3,1.3,0,1.5)

local petLine = {}
do
  local number = 36
  local t = {}
  for i = 1,number do
    local a = i*math.pi*2/number
    local b = a
    if b > math.pi then
      b = 2*math.pi-b
    end
    local size = 1
    if math.abs(b)<math.pi/3 then
      -- size = size*(1+1/math.cos(math.abs(b)-math.pi/3))/2
    end
    local x,y = rotate(0,size,a)
    t[i] = {x,y,0}
  end
  petLine = {t}
end
function mod:GenerateMesh(guid,unit,lines)

  local scene = AVR:GetTempScene(100)
  local m = AVRPolygonMesh:New(lines)
  -- local m = AVRPolygonMesh:New(helpLine)
  scene:AddMesh(m,false,false)
  m:SetFollowUnit(guid)
  -- m:SetFollowUnit(unit)
  local _,class = UnitClass(unit)
  local r,g,b = getClassColor(class)
  m:SetColor(r,g,b,unit == "player" and 0.2 or 0.5)

  local pm = AVRPolygonMesh:New(petLine)
  scene:AddMesh(pm,false,false)
  pm:SetFollowUnit(unit.."pet")
  pm:SetColor(r,g,b,0.5)
  self.drawables[guid] = {
    unit = unit,
    drawable = m,
    drawablePet = pm,
  }
end

function mod:UpdateArenaUnits()
  for u,timer in pairs(self.timers) do
    self:CancelTimer(timer)
  end
  wipe(self.timers)
  for guid,data in pairs(self.drawables) do
    data.mayremove = true
  end
  if self:IsInArena() then
    for i,unit in ipairs({"player","party1","party2"}) do

      local guid = UnitGUID(unit)
      if guid and UnitClass(unit) then
        if not self.drawables[guid] then
          self:GenerateMesh(guid,unit,helpLine)
        else
          self.drawables[guid].mayremove = nil
          -- self.drawables[guid].drawable.rebuild = true
        end
      else
        local timer
        timer = self:ScheduleRepeatingTimer(function()
          local guid = UnitGUID(unit)
          if guid and UnitClass(unit) then
            if not self.drawables[guid] then
              self:GenerateMesh(guid,unit,helpLine)
            end
            self:CancelTimer(timer)
            self.timers[unit] = nil
          end
        end,0.1)
        self.timers[unit] = timer
      end
    end
    for i,unit in ipairs({"arena1","arena2","arena3"}) do
      local guid = UnitGUID(unit)
      if guid and UnitClass(unit) then
        if not self.drawables[guid] then
          self:GenerateMesh(guid,unit,getArrow(0.4,2.3,1.3,1.3,0,1.5))
        else
          self.drawables[guid].mayremove = nil
          -- self.drawables[guid].drawable.rebuild = true
        end
      else
        local timer
        timer = self:ScheduleRepeatingTimer(function()
          local guid = UnitGUID(unit)
          if guid and UnitClass(unit) then
            if not self.drawables[guid] then
              self:GenerateMesh(guid,unit,getArrow(0.4,2.3,1.3,1.3,0,1.5))
            end
            self:CancelTimer(timer)
            self.timers[unit] = nil
          end
        end,0.1)
        self.timers[unit] = timer
      end
    end
  end
  for guid,data in pairs(self.drawables) do
    if data.mayremove then
      data.drawable:Remove()
      data.drawablePet:Remove()
      self.drawables[guid] = nil
    end
  end
end
local kicks = {
  --priest
  [ 15487] = {30,45}, -- silence
    --dk

    --dk
  [ 47528] = {15,15,3,250,251,252},
  --warrior
  [  6552] = {2,15,4,71,72,73}, -- Pummel
  -- paly
  [ 96231] = {2,15,4,66,70}, -- Rebuke
  -- hunter
	[147362] = {40,24,3,253,254}, -- Counter Shot
	[187707] = {2,15,3,255}, -- Muzzle
  -- shaman
  [ 57994] = {25,12,3,262,263,264}, -- Wind Shear
  --dh
	[183752] = {15,15,3,577,581}, -- Consume Magic
  --druid
	[106839] = {13,15,4,103,104}, -- Skull Bash
  -- monk
	[116705] = {2,15,4,268,269}, -- Spear Hand Strike
  -- rouge
	[  1766] = {2,15,5,259,260,261}, -- Kick
  -- mage
	[  2139] = {40,24,6,62,63,64}, -- Counterspell
  -- warlock
	[ 19647] = {40,24,6,"417"}, -- Spell Lock (Felhunter)
  -- [119910] = {40,24,265,266,267}, -- Spell Lock (Comand Demon with Felhunter)
  [171138] = {40,24,6,"78215"}, -- Shadow Lock (Doomguard with Grimoire of Supremacy)
  -- [171140] = {40,24,265,266,267}, -- Shadow Lock (Command Demon with Doomguard)
	-- [111897] = {40,90,265,266,267}, -- Grimoire: Felhunter
}

local function say(source,action,dest,extra,icon)
  local link = GetSpellLink(extra) or ""
  icon = icon or ""
  -- SendChatMessage(icon.." ["..source.."] "..action.." ["..dest.."] "..link..icon,"RAID")
end

local kicktimers= {}
local cm

function mod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
  if event == "SPELL_INTERRUPT" then
    local sc = sourceGUID and GetPlayerInfoByGUID(sourceGUID) or ""
    local dc = destGUID and GetPlayerInfoByGUID(destGUID) or ""
    local extraSpellID = ...
    say(sourceName.." - "..sc,"成功打断",destName.." - "..dc,extraSpellID,"{三角}")
    if kicktimers[sourceGUID] then
      self:CancelTimer(kicktimers[sourceGUID])
      kicktimers[sourceGUID] = nil
    end
    if kicks[spellId] then
      local d = kicks[spellId][3]
      Core:CreateCooldown({
				guid = destGUID,
				spellId = spellId,
				radius = 5,
				duration = d,
				color = {0.3,0.7,0},
				alpha = 0.3,
			})
    end
  end
  if event == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") then
    if spellId == 48018 or spellId == 101643 or spellId == 119996 then
      local scene = AVR:GetTempScene(100)
      local m = AVRCircleMesh:New(40)
      m:TranslateMesh(AirjHack:Position(sourceGUID))
      scene:AddMesh(m,false,false)
      if cm then
        cm:Remove()
      end
      cm = m
    end
  end
  if event == "SPELL_CAST_SUCCESS" and kicks[spellId] then
    local sc = sourceGUID and GetPlayerInfoByGUID(sourceGUID)
    local dc = destGUID and GetPlayerInfoByGUID(destGUID)
    sc = sc and sourceName.." - "..sc or sourceName
    dc = dc and destName.." - "..dc or destName
    kicktimers[sourceGUID] = self:ScheduleTimer(function()
      say(sc,"打断失败",dc,spellId,"{十字}")
    end,0.1)
  end
end
