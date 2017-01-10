local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("PVP","AceEvent-3.0","AceTimer-3.0")
local LibPlayerSpells = LibStub('LibPlayerSpells-1.0')
local Cache
function mod:OnInitialize()
  Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
  --constants
  local stun = {
    color={0.4,0.0,0,0.05},
    color2={1,0.0,0,0.2},
    radius=3,
  }
  local cc = {
    color={0.5,0.5,0,0.05},
    color2={0.8,0.8,0,0.1},
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
      Core:RegisterAuraUnit(spellId,data)
    end
  end
  -- for spellId, flags, providers, modifiedSpells, moreFlags in LibPlayerSpells:IterateSpells("SURVIVAL") do
  --   local data = survival
  --   Core:RegisterAuraUnit(spellId,data)
  -- end
  -- for spellId, flags, providers, modifiedSpells, moreFlags in LibPlayerSpells:IterateSpells("BURST") do
  --   local data = burst
  --   Core:RegisterAuraUnit(spellId,data)
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
    118, -- poly
    209753, -- cyclone
    5782, --Fear
  }
  local pguid = Cache:PlayerGUID()
  if Cache then
    local fcn = function()
      if self.lcum then
        Core:HideLinkMeshM(self.lcum)
        Core:HideLinkMeshM(self.lcum2)
        self.lcum = nil
        self.lcum2 = nil
      end
      local name,_,_,_,st,et = UnitCastingInfo("player")
      local matched
      for i,v in pairs(spells) do
        if GetSpellInfo(v) == name then
          matched = true
          break
        end
      end
      if matched then
        local data = Cache.cache.castStartTo.lastplayer
        local guid = AirjAutoKey.lastpoly or data and data.guid
        if guid then
          self.lcum = Core:ShowLinkMesh(mdata,data.spellId.."bg",pguid,guid)
          local _,_,_,_,distance = Cache:GetPosition(guid)
          mdata2.length = distance*(GetTime()*1000-st)/(et-st)
          self.lcum2 = Core:ShowLinkMesh(mdata2,data.spellId,pguid,guid)
        end
      end
    end
    self:ScheduleRepeatingTimer(function() pcall(fcn) end,0.01)
  end
  local data
  data = {
    color={0.0,0.7,0.7,0.05},
    color2={0.0,0.9,0.9,0.1},
    radius=19,
    duration=9.6,
  }
  Core:RegisterAreaTriggerCircle(191034,data)
  data = {
    color={0.0,0.7,0.7,0.05},
    color2={0.0,0.9,0.9,0.1},
    duration=60,
  }
  Core:RegisterAreaTriggerCircle(187651,data)
  data = {
    color={0.8,0.8,0.0,0.15},
    color2={0.9,0.3,0.0,0.2},
    duration=15,
  }
  Core:RegisterAreaTriggerCircle(194278,data)

  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local kicks = {
  --priest
  [ 15487] = {30,45}, -- silence
    --dk
  [ 47528] = {15,15,250,251,252},
  --warrior
  [  6552] = {2,15,71,72,73}, -- Pummel
  -- paly
  [ 96231] = {2,15,66,70}, -- Rebuke
  -- hunter
	[147362] = {40,24,253,254}, -- Counter Shot
	[187707] = {2,15,255}, -- Muzzle
  -- shaman
  [ 57994] = {25,12,262,263,264}, -- Wind Shear
  --dh
	[183752] = {15,15,577,581}, -- Consume Magic
  --druid
	[106839] = {13,15,103,104}, -- Skull Bash
  -- monk
	[116705] = {2,15,268,269}, -- Spear Hand Strike
  -- rouge
	[  1766] = {2,15,259,260,261}, -- Kick
  -- mage
	[  2139] = {40,24,62,63,64}, -- Counterspell
  -- warlock
	[ 19647] = {40,24,"417"}, -- Spell Lock (Felhunter)
  -- [119910] = {40,24,265,266,267}, -- Spell Lock (Comand Demon with Felhunter)
  [171138] = {40,24,"78215"}, -- Shadow Lock (Doomguard with Grimoire of Supremacy)
  -- [171140] = {40,24,265,266,267}, -- Shadow Lock (Command Demon with Doomguard)
	-- [111897] = {40,90,265,266,267}, -- Grimoire: Felhunter
}

local function say(source,action,dest,extra,icon)
  local link = GetSpellLink(extra) or ""
  icon = icon or ""
  -- SendChatMessage(icon.." ["..source.."] "..action.." ["..dest.."] "..link..icon,"RAID")
end

local kicktimers= {}

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
