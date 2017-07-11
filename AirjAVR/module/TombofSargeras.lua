local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("TombofSargeras","AceEvent-3.0","AceTimer-3.0")

local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")

function mod:OnInitialize()
  local data

  -- 1
  -- data = {
  --   color={0,1,0,0.2},
  --   color2={0,0.5,0,0.3},
  --   radius=10,
  -- }
  -- Core:RegisterAuraUnit(230345,data)
  data = {
    color={0.5,0,0,0.1},
    color2={1,0,0,0.3},
    radius=10,
  }
  Core:RegisterAuraUnit(233272,data)

  --2
  data = {
    color={0.5,0,0.5,0.05},
    color2={1,0,1,0.1},
    radius=10,
  }
  Core:RegisterAuraUnit(233983,data)

  --3

  data = {
    width = 0.2,
    alpha = 0.3,
    classColor = true,
  }
  Core:RegisterAuraLink(234016,data)
  data = {
    color={0,0,0.5,0.05},
    color2={0,0,1,0.1},
    radius=8,
  }
  Core:RegisterAuraUnit(231729,data)

  --4
  data = {
    color={0,0,0.5,0.05},
    color2={0,0,1,0.1},
    radius=8,
  }
  Core:RegisterAuraUnit(236519,data)
  data = {
    color={0,0,0.5,0.05},
    color2={0,0,1,0.1},
    radius=8,
  }
  Core:RegisterAuraUnit(236550,data)
  data = {
    width = 4,
    alpha = 0.3,
    color={1,0,0,0.3},
    -- classColor = true,
  }
  Core:RegisterAuraLink(236541,data)
  data = {
    color={0.5,0,0,0.1},
    color2={1,0,0.0,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(236712,data)
  data = {
    color={0.5,0,0.5,0.1},
    color2={1,0,0.1,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(236541,data)
  data = {
    width = 4,
    alpha = 0.3,
    color={1,0,1,0.3},
  }
  Core:RegisterAuraLink(236541,data)


  --5
  data = {
    color={0,0,0.5,0.05},
    color2={0,0,1,0.3},
    radius=5,
  }
  Core:RegisterAuraUnit(232913,data)
  data = {
    color={0,0.5,0,0.1},
    color2={0,1,0.0,0.3},
    radius=5,
  }
  Core:RegisterAuraUnit(230139,data)
  data = {
    width = 4,
    alpha = 0.3,
    color={0,1,0,0.3},
    -- classColor = true,
  }
  Core:RegisterAuraLink(230139,data)

  --6
  data = {
    color={0,0,0.5,0.05},
    color2={0,0,1,0.3},
    radius=5,
  }
  Core:RegisterAuraUnit(236361,data)
  data = {
    width = 4,
    alpha = 0.3,
    color={0,1,0,0.3},
    -- classColor = true,
  }
  Core:RegisterAuraLink(238018,data)
  data = {
    color={0,0.5,0,0.1},
    color2={0,1,0.0,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(236515,data)
  Core:RegisterAuraUnit(235969,data)
  data = {
    color={0.5,0.5,0,0.1},
    color2={1,1,0.0,0.3},
    radius=5,
  }
  Core:RegisterAuraUnit(236459,data)
  data = {
    color={0.5,0,0,0.1},
    color2={1,0,0.0,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(238442,data)
  --7
  data = {
    color={0.5,0,0,0.1},
    color2={1,0,0.0,0.3},
    radius=5,
  }
  Core:RegisterAuraUnit(235117,data)

  --8
  data = {
    color={0.5,0,0.5,0.1},
    color2={1,0,1,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(239739,data)
  data = {
    color={0,0.5,0,0.1},
    color2={0,1,0.0,0.3},
    radius=10,
    duration = 15,
    isbuff = true,
  }
  Core:RegisterAuraUnit(241008,data)
  --9

  data = {
    color={0,0,0.5,0.1},
    color2={0,0,1.0,0.3},
    radius=5,
  }
  Core:RegisterAuraUnit(236710,data)

  data = {
    width = 1,
    alpha = 0.3,
    color={1,0,0,0.3},
  }
  Core:RegisterCreatureLink(124590,data)
  -- Core:RegisterCreatureLink(96829,data)



--120270

end

function mod:OnEnable()
  self.timer=mod:ScheduleRepeatingTimer(self.Timer,0.2,self)
  self:RegisterEvent("UNIT_SPELLCAST_START")
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  self:RegisterEvent("CHAT_MSG_ADDON")
  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectCreated,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectDestroyed,self)
end

local demonicObelisk = {}

function mod:OnObjectCreated(event,guid,type)
	-- print(guid,type)
  if bit.band(type,0x2)==0 then
    local objectType,serverId,instanceId,zone,cid,spawn = Core:GetGUIDInfo(guid)
    if objectType == "Creature" and cid == 120270 then
      local scene = AVR:GetTempScene(100)
      local lines = {{{-100,2,0},{-100,-2,0},{100,-2,0},{100,2,0}},{{-2,100,0},{-2,-100,0},{2,-100,0},{2,100,0}}}
      local m = AVRPolygonMesh:New(lines)
      scene:AddMesh(m,false,false)
      m:SetFollowUnit(guid)
      m.nofacing = true
      m:SetColor(0,1,0,0.2)
      demonicObelisk[guid] = m
    end
  end
end

function mod:OnObjectDestroyed(event,guid,type)
  local m = demonicObelisk[guid]
  if m then
    m:Remove()
  end
end

function mod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
  if event == "SPELL_CAST_SUCCESS" and (spellId == 238430) then
    -- print("logging")
    local data = {
      color={0.5,0.1,0,0.05},
      color2={1,0.5,0,0.15},
      radius=15,
      duration = 5,
    }
    Core:ShowUnitMesh(data,spellId,sourceGUID,destGUID)

  end
  -- if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event =="SPELL_AURA_APPLIED_DOSE" then
  --   if spellId == 213166 then
  --   -- if spellId == 774 then
  --     self:NewSearing(destGUID)
  --   end
  -- end
end

function mod:UNIT_SPELLCAST_START(event,unitId,spell,rank,spellGUID)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(event,unitId,spell,rank,spellGUID)
end

function mod:Timer()
end

--DBM
function mod:CHAT_MSG_ADDON(prefix, msg, channel, targetName)
	if prefix ~= "Transcriptor" then return end
	if msg:find("spell:236604") then--Rapid fire
		targetName = Ambiguate(targetName, "none")
    if targetName then
      for i = 1,40 do
        local unit = "raid"..i
        local name = UnitName(unit)
        if name == targetName then
          local guid = UnitGUID(unit)
          local data = {
            color={0.5,0,0.5,0.1},
            color2={1,0,1,0.3},
            radius=10,
            isbuff = true,
            duration = 3,
          }
          Core:ShowUnitMesh(data,236604,guid,guid)
        end
      end
    end
	end
end
