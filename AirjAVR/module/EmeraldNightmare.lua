local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("EmeraldNightmare","AceEvent-3.0","AceTimer-3.0")

function mod:OnInitialize()
  local data
  do --test
  end
  do -- Nythendra
    --202977
    data = {
      color={0.0,0.7,0,0.1},
      color2={0.0,0.7,0,0.2},
      line={{0,10,0},{50,60,0},{-50,60,0}},
      duration=8,
    }
    Core:RegisterBreath(202977,data) --Infested Breath
    data = {
      color={0.2,0.5,0,0.2},
      color2={0.3,0.7,0,0.3},
      radius=8,
      duration=9,
    }
    Core:RegisterAuraUnit(203096,data) --溃烂
    data = {
      color={0.2,0.5,0,0.2},
      color2={0.3,0.7,0,0.3},
      radius=8,
      duration=9,
    }
    Core:RegisterAuraUnit(221028,data) --不稳定的
    data = {
      color={0.4,0.0,0,0.2},
      color2={0.7,0.0,0,0.3},
      radius=15,
      duration=8,
    }
    Core:RegisterAuraUnit(204463,data) --爆裂溃烂
    data = {
      color={0.0,0.4,0,0.2},
      color2={0.0,0.7,0,0.3},
      radius=5,
      duration=20,
    }
    Core:RegisterAuraUnit(205043,data) --感染意志 205043
    -- data = {
    --   color={0.2,0.1,0.5,0.2},
    --   color2={0.4,0.0,0.8,0.3},
    --   radius=8,
    --   duration=10,
    --   spellId = 203646,
    -- }
    -- Core:RegisterCreatureLink("Creature",102998,data) --腐化的害虫
  end
  do --Il'gynoth
    data = {
      width = 0.2,
      alpha = 0.3,
      color={1,0,0,0.2},
    }
    Core:RegisterCreatureLink(105383,data) --小触手
    data = {
      color={0.2,0.5,0,0.2},
      color2={0.3,0.7,0,0.3},
      radius=5,
      duration=10,
    }
    Core:RegisterAuraUnit(208929,data) --Spew Corruption
    data = {
      width = 0.2,
      alpha = 0.3,
      classColor = true,
    }
    Core:RegisterAuraLink(210099,data) --Ichor Fixate
    data = {
      color={0.5,0.0,0,0.2},
      color2={0.8,0.0,0,0.3},
      radius=11,
      duration=8,
    }
    Core:RegisterAuraUnit(215128,data) --Blood
  end
  do --4 dragen
    data = {
      color={0.2,0.5,0,0.1},
      color2={0.3,0.7,0,0.2},
      radius=8,
      duration=90,
    }
    Core:RegisterAuraUnit(203787,data) --Spew Corruption
    data = {
      color={0.2,0,0.5,0.1},
      color2={0.3,0,0.7,0.2},
      radius=4,
      duration=8,
    }
    Core:RegisterAuraUnit(203770,data) --Spew Corruption
  end
  do -- ER
    data = {
      color={0.0,0.5,0,0.2},
      color2={0.0,0.8,0,0.3},
      radius=8,
      duration=6,
    }
    Core:RegisterAuraUnit(215460,data) --Necrotic Venom
    data = {
      color={0.0,0.7,0,0.2},
      color2={0.0,0.5,0,0.3},
      radius=8,
      duration=6,
    }
    Core:RegisterAuraUnit(215460,data) --Necrotic Venom
  end
  do --Cenarius
    data = {
      color={0.0,0.5,0,0.2},
      color2={0.0,0.8,0,0.3},
      radius=5,
      duration=8,
    }
    Core:RegisterAuraUnit(211368,data) -- Touch of Life
    data = {
      color= {0.3,0.0,0.5,0.2},
      color2={0.5,0.0,0.8,0.3},
      radius=8,
      duration=8,
    }
    Core:RegisterAuraUnit(211471,data) --Scroned Touch
    --
    -- data = {
    --   width = 0.4,
    --   alpha = 0.3,
    --   color={1,0,0,0.2},
    -- }
    -- Core:RegisterCreatureLink(104636,data) --P1 mod
  end
  do --Xavius
    data = {
      color={0.0,0.8,0,0.2},
      color2={0.0,0.5,0,0.2},
      radius=25,
      duration=15,
    }
    -- Core:RegisterAuraUnit(206651,data)
    -- Core:RegisterAuraUnit(209158,data)
    data = {
      color={0.0,0.5,0,0.2},
      color2={0.0,0.8,0,0.3},
      radius=5,
      duration=4,
    }
    Core:RegisterAuraUnit(211802,data) -- Blades
    data = {
      color={0.5,0.5,0,0.2},
      color2={0.8,0.8,0,0.3},
      radius=5,
      duration=10,
    }
    Core:RegisterAuraUnit(210451,data) -- Terror
    Core:RegisterAuraUnit(209034,data) -- Terror
    data = {
      color= {0.3,0.0,0.5,0.2},
      color2={0.5,0.0,0.8,0.3},
      radius=12,
      duration=5,
    }
    Core:RegisterAuraUnit(224508,data)
    data = {
      width = 0.2,
      alpha = 0.3,
      classColor = true,
    }
    Core:RegisterAuraLink(205771,data) --Fxiation
    data = {
      color= {0.0,0.0,0.5,0.2},
      color2={0.0,0.0,0.8,0.3},
      radius=6,
      duration=20,
    }
    Core:RegisterAuraUnit(208431,data) --
    data = {
      width = 0.2,
      alpha = 0.3,
      color={0,0,1,0.2},
    }
    Core:RegisterCreatureLink(105611,data) --P2 mod
    data = {
      width = 0.4,
      alpha = 0.3,
      color={1,0,0,0.2},
    }
    Core:RegisterCreatureLink(103695,data) --P1 mod
  end

  self:RegisterEvent("UNIT_SPELLCAST_START")
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function mod:OnEnable()
  self.timer=mod:ScheduleRepeatingTimer(self.Timer,0.2,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectCreated,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectDestroyed,self)
  self:RegisterEvent("RAID_TARGET_UPDATE")
end

function mod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
  if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event =="SPELL_AURA_APPLIED_DOSE" then
    if spellId == 210099 then
      self:NewIchor(sourceGUID,destName)
    end
  end


end

function mod:UNIT_SPELLCAST_START(event,unitId,spell,rank,spellGUID)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(event,unitId,spell,rank,spellGUID)
end

function mod:Timer()
  self:IchorMaker()
end

do
  local ichors = {}
  local markers = {}
  local fixate = {}

  function mod:NewIchor(sourceGUID,destName)
    fixate[sourceGUID] = destName
  end

  function mod:RAID_TARGET_UPDATE()
    local units = Core:GetUnitList()
    for _,unit in pairs(units) do
      local guid = UnitGUID(unit)
      if guid then
        local index = GetRaidTargetIndex(unit)
        if index then
          markers[index] = guid
        else
          for i=1,8 do
            if markers[i] == guid then
              markers[i] = nil
            end
          end
        end
      end
    end
  end

  function mod:OnObjectCreated(event,guid,type)
    if bit.band(type,0x08)~=0 then
      local objectType,serverId,instanceId,zone,id,spawn = AirjHack:GetGUIDInfo(guid)
      -- if id == "108538" then
      if id == "105721" then
        ichors[guid] = true
      end
    end
  end
  function mod:OnObjectDestroyed(event,guid)
    for i=1,8 do
      if markers[i] == guid then
        markers[i] = nil
      end
    end
  end

  function mod:IchorMaker()
    -- local boss1guid = UnitGUID("player")
    local boss1guid = UnitGUID("boss1")
    local objectType,serverId,instanceId,zone,id,spawn = AirjHack:GetGUIDInfo(boss1guid)
    if id ~= "105906" then return end
    local bx,by,bz,_,bs = AirjHack:Position(boss1guid)
    local inranged = {}
    local mindistance = 100
    for guid in pairs(ichors) do
      local x,y,z = AirjHack:Position(guid)
      if x then
        local dx,dy,dz = bx-x,by-y,bz-z
        local distance = math.sqrt(dx*dx+dy*dy+dz*dz)-bs
        if distance<100 then
          local health, max, prediction, absorb, healAbsorb, isdead = AirjHack:UnitHealth(guid)
          inranged[guid] = {distance,health/max}
          mindistance = math.min(distance,mindistance)
        end
      end
    end
    for guid,data in pairs(inranged) do
      health = data[2]
      for i=1,8 do
        if markers[i] == guid then
          if health < 0.02 then
            markers[i] = nil
          end
        end
      end
    end
    local noskull,skullnotlow
    if not markers[8] then
      noskull = true
    else
      local skull = markers[8]
      if not inranged[skull] then
        noskull = true
      else
        local distance,health = inranged[skull][1],inranged[skull][2]
        if distance > math.max(mindistance+10,30) then
          noskull = true
        end
        if health> 0.2 then
          skullnotlow=true
        end
      end
    end
    -- dump(noskull)

    if noskull then
      local pro = {}
      local sorted = {}
      for guid,data in pairs(inranged) do
        distance,health = data[1],data[2]
        if health>=0.02 then
          local value
          if health<0.2 then
            if distance<10 then
              value = health
            else
              value = health + 0.2
            end
          elseif health<0.5 then
            if distance<20 then
              value = health + 0.2
            else
              value = health + 0.5
            end
          else
            value = health + 1
          end
          if guid == markers[8] then
            value = value*0
          end
          if guid == markers[7] then
            value = value*0.5
          end
          if guid == markers[6] then
            value = value*0.7
          end
          if guid == markers[5] then
            value = value*0.9
          end
          if distance > 10 then
            value = distance/60 + value
          end
          pro[guid] = value
          tinsert(sorted,guid)
        end
      end
      table.sort(sorted,function(a,b) return pro[a]<pro[b] end)
      local index = 8
      for i,guid in ipairs(sorted) do
        markers[index] = guid
        AirjHack:SetRaidTarget(guid,index)
        local name
        if AirjCache then
          local unit = AirjCache:FindUnitByGUID(guid)
          if unit then
            name = UnitName(unit.."target")
          end
        end
        if not name then
          name = fixate[guid]
        end
        if name then
          if index == 8 then
            -- SendChatMessage("你的软泥为>>骷髅<<快来眼球下", "WHISPER", nil, name);
          elseif index == 7 then
            -- SendChatMessage("下一个是你的软泥", "WHISPER", nil, name);
          end
        end
        index = index - 1
        if index==4 then
          break
        end
      end
    end
  end
end
