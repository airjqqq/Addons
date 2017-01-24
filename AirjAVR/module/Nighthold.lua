local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("Nighthold","AceEvent-3.0","AceTimer-3.0")

local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")

function mod:OnInitialize()
  local data
  data = {
    color={0,1,1,0.2},
    color2={0,0.5,1,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(206617,data)


  -- data = {
  --   color={0,1,1,0.2},
  --   color2={0,0.5,1,0.3},
  --   radius=4,
  -- }
  -- Core:RegisterAuraUnit(208915,data)
  -- Core:RegisterAuraUnit(208910,data)

  data = {
    color={1,1,0,0.2},
    color2={1,0.5,0,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(211615,data)
  Core:RegisterAuraUnit(208499,data)

  data = {
    color={0,0.4,0,0.2},
    color2={0,1,0,0.3},
    radius=8,
    duration = 20,
  }
  Core:RegisterAuraUnit(206838,data)
  --4
  data = {
    color={0,0.4,1,0.2},
    color2={0,1,1,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(212531,data)
  Core:RegisterAuraUnit(212587,data)
  data = {
    color={1,0.4,0,0.2},
    color2={1,1,0,0.3},
    radius=8,
    duration = 30,
  }
  Core:RegisterAuraUnit(213166,data)


  data = {
    color={1,0.4,0,0.2},
    color2={1,1,0,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(212531,data)

  data = {
    color={1,0.4,0,0.2},
    color2={1,1,0,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(205344,data)
  data = {
    color={1,0.4,0,0.2},
    color2={1,1,0,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(218809,data)
  data = {
    color={1,0.4,0,0.3},
    color2={1,1,0,0.1},
    radius=8,
  }
  Core:RegisterAuraUnit(211261,data)
  data = {
    color={0,0.4,1,0.3},
    color2={0,1,1,0.1},
    radius=5,
  }
  Core:RegisterAuraUnit(209973,data)
  -- data = {
  --   color={1,0.4,0,0.2},
  --   color2={1,1,0,0.3},
  --   radius=2,
  -- }
  -- Core:RegisterAuraUnit(206480,data)
  -- data = {
  --   color={0,0.5,0,0.2},
  --   color2={0,0.1,0.2,0.3},
  --   radius=8,
  -- }
  -- Core:RegisterAuraUnit(212794,data)

  --High

end

function mod:OnEnable()
  self.timer=mod:ScheduleRepeatingTimer(self.Timer,0.2,self)
  self:RegisterEvent("UNIT_SPELLCAST_START")
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function mod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)

end

function mod:UNIT_SPELLCAST_START(event,unitId,spell,rank,spellGUID)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(event,unitId,spell,rank,spellGUID)
end

function mod:Timer()
end
