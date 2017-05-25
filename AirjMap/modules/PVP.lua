local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjMap")
local P = Core:NewModule("PVP","AceEvent-3.0","AceTimer-3.0")
local LibPlayerSpells

function P:OnInitialize()
end

function P:OnEnable()
  LibPlayerSpells = LibStub('LibPlayerSpells-1.0')
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  self.drawables = {}
  self.harmUnits = {}
	self:RegisterEvent("GROUP_ROSTER_UPDATE",self.UpdateArenaUnits,self)
	self:RegisterEvent("ARENA_OPPONENT_UPDATE",self.UpdateArenaUnits,self)
  self:UpdateArenaUnits()
	-- self:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
  self.auraSpells = self:BuildSpellIdMaps()
end

function P:IsInArena()
  return IsInInstance() == "arena" or true --debug
end

function P:UpdateArenaUnits()
  for guid,data in pairs(self.drawables) do
    data.mayremove = true
  end
  if self:IsInArena() then
    for i,unit in ipairs({"player","party1","party2"}) do
      local guid = UnitGUID(unit)
      if guid then
        if not self.drawables[guid] then
          self.drawables[guid] = {
            unit = unit,
            drawable = Core.HelpPlayer({position={type="guid",data=guid}}),
          }
        else
          self.drawables[guid].mayremove = nil
        end
      end
    end
    for i,unit in ipairs({"arena1","arena2","arena3"}) do
      local guid = UnitGUID(unit)
      if guid then
        if not self.drawables[guid] then
          self.drawables[guid] = {
            unit = unit,
            drawable = Core.HelpPlayer({position={type="guid",data=guid}}),
          }
        else
          self.drawables[guid].mayremove = nil
        end
      end
    end
  end
  for guid,data in pairs(self.drawables) do
    if data.mayremove then
      data.drawable.remove = true
      self.drawables[guid] = nil
    end
  end
end

function P:BuildSpellIdMaps ()
  local toRet = {}

  local stun = {
    color={0.4,0.0,0,1},
    color2={1,0.0,0,1},
    radius=3,
    priority=70,
  }
  local cc = {
    color={0.5,0.5,0,1},
    color2={0.8,0.8,0,1},
    radius=5,
    priority=80,
  }
  local root = {
    color={0.0,0.2,0.5,0.05},
    color2={0.0,0.4,0.8,0.1},
    radius=3,
  }
  local deffensive = {
    color={0.5,0.2,0.0,0.05},
    color2={0.8,0.4,0.0,0.1},
    isbuff=true,
    radius=3,
    priority=50,
  }
  local offensive = {
    color={0.0,0.5,0.0,0.05},
    color2={0.0,0.8,0.0,0.1},
    isbuff=true,
    radius=3,
    priority=40,
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
      toRet[spellId] = data
    end
  end
  return toRet
end

function P:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
  if self.auraSpells[spellId] and self.drawables[destGUID] then
    if event=="SPELL_AURA_APPLIED" then
      local data = self.auraSpells[spellId]
  		local unit = AirjCache:FindUnitByGUID(destGUID)
  		if unit then
        local isbuff = ... == "BUFF"
  			local fcn = isbuff and UnitBuff or UnitDebuff
  			local name, rank, icon, count, dispelType, duration, expires = fcn(unit,spellName)
  			if name then
          if duration == 0 then
            duration,expires = 5,GetTime() + 5
          end
          local priority, c1, c2,size = data.priority, data.color2, data.color,data.radius
          self.drawables[destGUID].drawable:AddAura(priority,duration, expires, c1, c2,size)
  			end
  		end
    elseif event == "SPELL_AURA_REMOVED" then
    end
  end
end
