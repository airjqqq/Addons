local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("TrialOfVaior","AceEvent-3.0","AceTimer-3.0","AceConsole-3.0")

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

	mod:RegisterChatCommand("aodyn", function(str,...)
    mod:SetRaidMarkerForOdyn()
  end)
end

local function range (x1,y1,x2,y2)
  local dx,dy = x1-x2,y1-y2
  return sqrt(dx*dx+dy*dy)
end

do -- odyn
  local markerindex = {2,3,6,5,1}
  local cx,cy,cz = -528.5,2428.7,749
  local r = 32
  local left = {
    {-552.2,2497.5},
    {-533.5,2480.0},
    {-549.2,2458.5},
    {-574.3,2447.7},
    {-573.0,2473.1},
  }
  local right = {}
  for i,v in pairs(left) do
    local x,y = v[1],v[2]
    local j = i
    if j >1 then j = 7-i end
    x = cx*2-x
    right[j] = {x,y}
  end
  local center = {}
  local a = math.pi/2.5
  for i=1,5 do
    local b = math.pi/2 - a*(i-1)
    center[i] = {cx+22*math.cos(b),cy+22*math.sin(b)}
  end
  function mod:SetRaidMarkerForOdynWithIndex(index)
    local marks
    if index == 2 then
      marks = center
    elseif index == 1 then
      marks = left
    else
      marks = right
    end
    for i,v in ipairs(marks) do
      local mi = markerindex[i]
      PlaceRaidMarker(mi)
      AirjHack:TerrainClick(v[1],v[2],cz)
    end
  end
  function mod:SetRaidMarkerForOdyn()
    -- print("test")
    if UnitCastingInfo("player") or UnitChannelInfo("player") then
      self:ScheduleTimer(self.SetRaidMarkerForOdyn,0.75,self)
      return
    end
    local x,y = AirjHack:Position("boss1")
    if not x then
      x,y = AirjHack:Position("player")
    end
    if x then
      if range(x,y,cx,cy)<r then
        self:SetRaidMarkerForOdynWithIndex(2)
      elseif x<cx then
        self:SetRaidMarkerForOdynWithIndex(1)
      else
        self:SetRaidMarkerForOdynWithIndex(3)
      end
    end
  end

	-- mod:RegisterChatCommand("aodyn", function(str,...)
  --   mod:SetRaidMarkerForOdyn()
  -- end)
end
do
  local markerindex = {6,1,3}
  local offset = {
    {10,30},
    {0,30},
    {-10,30},
  }
  function mod:SetRaidMarkerForGuarm(s)
    if UnitCastingInfo("player") or UnitChannelInfo("player") then
      self:ScheduleTimer(self.SetRaidMarkerForGuarm,0.75,self,s)
      return
    end
    -- local bx,by,z,f = AirjHack:Position("player")
    local bx,by,z,f = AirjHack:Position("boss1")
    if bx then
      for i,v in ipairs(s) do
        local x,y
        local ox,oy = unpack(offset[i])
        x = bx+ox*math.cos(f)-oy*math.sin(f)
        y = by+oy*math.cos(f)+ox*math.sin(f)
        local mi = markerindex[i]
        PlaceRaidMarker(mi)
        AirjHack:TerrainClick(x,y,z)
      end
    end
  end
	mod:RegisterChatCommand("agom", function(str,...)
    mod:SetRaidMarkerForGuarm({1,2,3})
  end)
end

function mod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)

  local data
  if spellId == 228162 and event == "SPELL_CAST_START" then

  end
  if spellId == 227807 and event == "SPELL_CAST_SUCCESS" then
    self:SetRaidMarkerForOdyn()
  end
  if spellId == 228162 and event == "SPELL_CAST_SUCCESS" then
    data = {
      width = 2,
      alpha = 0.3,
      classColor = true,
    }
    -- print(destName)
    Core:HideLinkMesh(data,spellId,sourceGUID,destGUID)
  end
  -- 232810 132
  -- 232808 231
  -- 232809 312
  -- 232811 123
  -- 232807 321
  -- 232775 213
  local breathids = {
    [232810] = {1,3,2},
    [232808] = {2,3,1},
    [232809] = {3,1,2},
    [232811] = {1,2,3},
    [232807] = {3,2,1},
    [232775] = {2,1,3},
  }
  if breathids[spellId] and event == "SPELL_CAST_SUCCESS" then
    mod:SetRaidMarkerForGuarm(breathids[spellId])
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
