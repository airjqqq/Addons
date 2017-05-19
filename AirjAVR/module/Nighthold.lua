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
    color={0,1,0,0.2},
    radius=5,
  }
  Core:RegisterAuraUnit(218304,data)
  data = {
    width = 0.2,
    alpha = 0.3,
    classColor = true,
  }
  Core:RegisterAuraLink(218342,data)



  -- data = {
  --   color={1,0,1,0.3},
  --   radius=5,
  -- }
  -- Core:RegisterAuraUnit(206388,data)

  --星术师

  data = {
    color={0,1,1,0.3},
    radius=8,
  }
  Core:RegisterAuraUnit(206936,data)

  data = {
    color={1,0,0,0.3},
    radius=3,
  }
  Core:RegisterAuraUnit(205445,data)
  data = {
    color={0,1,0,0.3},
    radius=3,
  }
  Core:RegisterAuraUnit(216345,data)
  data = {
    color={1,1,0,0.3},
    radius=3,
  }
  Core:RegisterAuraUnit(205429,data)
  data = {
    color={1,0,1,0.3},
    radius=5,
  }
  Core:RegisterAuraUnit(205649,data)


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
  data = {
    color={1,1,0,0.3},
    color2={1,0,0,0.1},
    radius=2,
  }
  Core:RegisterAuraUnit(221606,data)
  Core:RegisterAuraUnit(221603,data)

  Core:RegisterCreatureLink(109082,{
    color = {0.5,0,1,0.3},
    width = 10,
    destUnit = "boss1",
    length = 100,
  })
  --109082
  -- end

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
  -- M+
  -- data = {
  --   color={0.8,0,0,0.2},
  --   color2={1,0.5,0,0.3},
  --   radius=3,
  --   duration=3,
  -- }
  -- Core:RegisterAreaTriggerCircle(124503,data)

  data = {
    width = 0.5,
    alpha = 0.7,
    -- classColor = true,
    color={0.8,0,0,0.6},
  }
  Core:RegisterAuraLink(234425,data)
  data = {
    color={0.4,0.7,0,0.2},
    color2={0.7,0.0,0,0.5},
    line={{-3,0,0},{3,0,0},{5,60,0},{-5,60,0}},
    duration=2,
  }
  Core:RegisterBreath(234631,data) --Infested Breath
  data = {
    color={0.4,0.7,0,0.2},
    color2={0.7,0.0,0,0.5},
    line={{-2,0,0},{2,0,0},{3,20,0},{-3,20,0}},
    duration=1,
  }
  Core:RegisterBreath(236537,data) --Infested Breath
end

function mod:OnEnable()
  self.timer=mod:ScheduleRepeatingTimer(self.Timer,0.2,self)
  self:RegisterEvent("UNIT_SPELLCAST_START")
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

  Core:RegisterChatCommand("ass",function(str)
    local cx,cy,cz = AirjHack:Position(UnitGUID("target"))
    if cx then
      for i=1,8 do
        local range
        if i == 4 or i == 8 then
          range = 8
        else
          range = 13
        end
        local a = -math.pi*0.25 + (math.pi/4)*(i-1)
        PlaceRaidMarker(i)
        AirjHack:TerrainClick(cx+range*math.cos(a),cy+range*math.sin(a),cz)
      end
    end
  end)
end


do
  local index = 1
  function mod:NewSearing(guid)
    local unit = Cache:FindUnitByGUID(guid)
    SetRaidTarget(unit,index)
    index = index + 1
    if index > 6 then index = 1 end
  end
end

function mod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)

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
