local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("TrialOfVaior","AceEvent-3.0","AceTimer-3.0")

function mod:OnInitialize()
end

function mod:OnEnable()
  self:RegisterEvent("UNIT_SPELLCAST_START")
  self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  -- self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectCreated,self)
  -- self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectDestroyed,self)
  -- self:RegisterEvent("RAID_TARGET_UPDATE")

  local data
  do --Odyn
    -- data = {
    --   color={0.0,0.4,0,0.2},
    --   color2={0.0,0.7,0,0.3},
    --   radius=5,
    --   duration=60,
    -- }
    -- Core:RegisterAuraUnit(227500,data)
    -- data = {
    --   color={0.4,0.2,0,0.2},
    --   color2={0.7,0.4,0,0.3},
    --   radius=5,
    --   duration=60,
    -- }
    -- Core:RegisterAuraUnit(227491,data)
    -- data = {
    --   color={0.4,0.4,0,0.2},
    --   color2={0.7,0.7,0,0.3},
    --   radius=5,
    --   duration=60,
    -- }
    -- Core:RegisterAuraUnit(227498,data)
    -- data = {
    --   color={0.4,0.0,0.3,0.2},
    --   color2={0.7,0.0,0.5,0.3},
    --   radius=5,
    --   duration=60,
    -- }
    -- Core:RegisterAuraUnit(227490,data)
    -- data = {
    --   color={0.0,0.4,0.4,0.2},
    --   color2={0.0,0.7,0.7,0.3},
    --   radius=5,
    --   duration=60,
    -- }
    -- Core:RegisterAuraUnit(227499,data)

    --P3 blue circle
    data = {
      color={0.0,0.4,0.4,0.1},
      color2={0.0,0.7,0.7,0.2},
      radius=8,
      duration=5,
    }
    Core:RegisterAuraUnit(227807,data)

    -- Hyrja's Golden Circle
    data = {
      color={0.4,0.4,0.0,0.1},
      color2={0.7,0.7,0.0,0.2},
      radius=8,
      duration=3,
    }
    Core:RegisterAuraUnit(228029,data)

    -- data = {
    --   width = 2,
    --   alpha = 0.3,
    --   classColor = true,
    -- }
    -- Core:RegisterAuraLink(228029,data)

  end
  self.timer=mod:ScheduleRepeatingTimer(self.Timer,0.2,self)
end

function mod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)

  local data
  if spellId == 228162 and event == "SPELL_CAST_START" then

  end
  if spellId == 228162 and event == "SPELL_CAST_SUCCESS" then
    data = {
      width = 2,
      alpha = 0.3,
      classColor = true,
    }
    print(destName)
    Core:HideLinkMesh(data,spellId,sourceGUID,destGUID)
  end
end

function mod:UNIT_SPELLCAST_START(event,unitId,spell,rank,spellGUID)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(event,unitId,spell,rank,spellGUID)
end

function mod:Timer()
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event,msg, _, _, _, target)
	if msg:find("spell:228162") then
    local from,to
    for i = 1,4 do
      local unit = "boss"..i
      local guid = nitGUID(unit)
      if guid then
        local objectType,serverId,instanceId,zone,cid,spawn = self:GetGUIDInfo(guid)
        if cid == 114360 then
          from = guid
          break
        end
      end
    end
    if from then
      to = UnitGUID("target")
      data = {
        width = 2,
        alpha = 0.3,
        classColor = true,
      }
      Core:ShowLinkMesh(data,spellId,from,to)
    end
	end
end
