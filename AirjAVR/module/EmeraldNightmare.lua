local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("EmeraldNightmare","AceEvent-3.0")

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
    Core:RegisterAuraUnit(215128,data) --Spew Corruption
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

function mod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)

end

function mod:UNIT_SPELLCAST_START(event,unitId,spell,rank,spellGUID)
	-- local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
  -- local link = GetSpellLink(spellId)
  -- local guid = UnitGUID(unitId)
  -- local objectType,serverId,instanceId,zone,cid,spawn = Core:GetGUIDInfo(guid)
  -- if objectType~="Player" then
  --   Core:Print(AirjHack:GetDebugChatFrame(),"UNIT_SPELLCAST_START",guid,link)
  -- end
end
function mod:UNIT_SPELLCAST_SUCCEEDED(event,unitId,spell,rank,spellGUID)
	-- local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
  -- local link = GetSpellLink(spellId)
  -- local guid = UnitGUID(unitId)
  -- local objectType,serverId,instanceId,zone,cid,spawn = Core:GetGUIDInfo(guid)
  -- if objectType~="Player" then
  --   Core:Print(AirjHack:GetDebugChatFrame(),"UNIT_SPELLCAST_SUCCEEDED",guid,link)
  -- end
  -- if spellId == 210290 then
  --   if not UnitExists(unitId.."target") then return end--Blizzard decided to go even further out of way to break this detection, if this happens we don't want nil errors for users.
  --   local guid = UnitGUID(unitId.."target")
  --   local data = {
  --     color= {0.0,0.5,0.5,0.2},
  --     color2={0.0,0.8,0.8,0.3},
  --     radius=8,
  --     duration=12,
  --   }
  --   self:ShowUnitMesh(data,210290,nil,guid)
  -- elseif spellId == 202968 then--Infested Breath (CAST_SUCCESS and CAST_START pruned from combat log)
  --   Core:Print("Breath")
  --   for i = 1, 20 do
  --     local unit = "raid"..i
  --     local _, _, _, dcount = UnitDebuff(unit,"感染")
  --     local name, rank, icon, count, dispelType, duration, expires = UnitDebuff(unit,"溃烂")
  --     if name then
  --       local remain = expires-GetTime()
  --       dcount = dcount + math.ceil(remain/3)
  --     end
  --     if dcount>= 10 then
  --       local guid = UnitGUID(unit)
  --       local data = {
  --         color= {0.0,0.5,0.5,0.2},
  --         color2={0.0,0.8,0.8,0.3},
  --         radius=8,
  --         duration=6,
  --       }
  --       self:ShowUnitMesh(data,205043,nil,guid)
  --     end
  --   end
  -- end
end
