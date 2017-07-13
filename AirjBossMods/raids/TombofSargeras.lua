local addonsname,modulename = "AirjBossMods","TombofSargeras"
local Core = LibStub("AceAddon-3.0"):GetAddon(addonsname)
local R = Core:NewModule(modulename,"AceEvent-3.0")

function R:OnEnable()

  do --template
    local bossmod = Core:NewBoss({encounterID = 1})
    function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
      local now = GetTime()
      if event == "SPELL_AURA_APPLIED" then
      end
      if event == "SPELL_CAST_START" then
      end
    end
    function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
    	local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
      local now = GetTime()
    end

    function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
    end

    function bossmod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg, sender, _, _, target)
      if msg:find("123456") then
      end
    end

    local lastCometTime
    function bossmod:Timer10ms()
      local now = GetTime()
    end
    local timeline = {
      {
        phase = 1,
        text = "阶段1",
        timepoints = {
        },
      },
    }
    function bossmod:GetTimeline(difficulty)
      return timeline
    end
  end
  do --1
    local bossmod = Core:NewBoss({encounterID = 2032})
    local aoeCnt = 0
    function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
      local now = GetTime()
      if event == "SPELL_AURA_APPLIED" then
        --Star
        if spellId == 233272 and destGUID == Core:GetPlayerGUID() then
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 6, start = nil, expires = nil, size = 2, name = "火球", reverse = false})
          Core:SetScreen(0,1,0)
          Core:SetTextT({text1 = "|cffff0000火球点你: |cff00ffff{number}|r", text2 = "|cff00ff00火球飞行中...|r",start = nil,expires = now+6})
          Core:SetVoice("bombrun")
          Core:SetVoice("safenow",now+7.5)
        end
        --Buring Armor
        if spellId == 231363 then
          if destGUID == Core:GetPlayerGUID() then


            Core:SetIconT({index = 13, texture = GetSpellTexture(spellId), duration = 6, start = nil, expires = nil, size = 1, name = "破甲", reverse = false})
            Core:SetScreen(1,0,0,0.5)
            Core:SetTextT({text1 = "|cffff0000远离人群: |cff00ffff{number}|r", text2 = "|cff00ff00返回|r",start = nil,expires = now+6})
            Core:SetVoice("runout")
            Core:SetVoice("runin",now+6)
            Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+6})
            for i = 3,6 do
              Core:SetSay(""..(6-i),now + i)
            end
          else
            if Core:GetPlayerRole() == "TANK" then
              Core:SetVoice("tauntboss")
              Core:SetText("|cffffff00换坦嘲讽|r","",now+2,now+2)
            end
          end
        end
        --Melted Armor
        if spellId == 234264 and destGUID == Core:GetPlayerGUID() then
          Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 20, name = GetSpellInfo(spellId), count = count, scale = false})
        end
        --Crashing Comet
        if spellId == 230345 and destGUID == Core:GetPlayerGUID() then
          Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 16, name = GetSpellInfo(spellId), count = count, scale = false})
        end
      end
      if event == "SPELL_CAST_START" then
        if spellId == 233062 then
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 6, start = nil, expires = nil, size = 2, name = "AOE", reverse = false})
          Core:SetScreen(0,1,0)
          Core:SetTextT({text1 = "|cffffff00即将AOE: |cff00ffff{number}|r", text2 = "|cff00ff00AOE结束|r",start = nil,expires = now+6})
          Core:SetVoice("findshelter")
          Core:SetVoice("safenow",now+6)
          self.basetime = GetTime() + 6
          aoeCnt = aoeCnt + 1
          self.timelineChanged = true
        end
        -- if spellId == 8936 then
        --   Core:SetText("|cffff0000即将 AOE：{number}|r","|cff00ff00AOE 结束...|r",now+6,now+7.5)
        --   Core:SetVoice("findshelter")
        --   Core:SetVoice("safenow",now+6)
        --   self.basetime = GetTime() + 6
        --   aoeCnt = aoeCnt + 1
        --   self.timelineChanged = true
        -- end
      end
    end
    function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
    	local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
      local now = GetTime()
    	if spellId == 233050 then--Infernal Spike
        Core:SetVoice("watchstep")
        Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 2.5, size = 1, name = "尖刺", reverse = false})
        Core:SetTextT({text1 = "|cffff0000尖刺: |cff00ffff{number}|r", text2 = "|cff00ff00尖刺|r",expires = now+2.5})
    	elseif spellId == 233285 then--Rain of Brimston

        Core:SetVoice("stepring")
        Core:SetIconT({index = 10, texture = GetSpellTexture(spellId), duration = 9, size = 1, name = "踩圈", reverse = false})
        Core:SetTextT({text1 = "|cffff0000踩圈: |cff00ffff{number}|r", text2 = "|cff00ff00踩圈结束|r",expires = now+9})
        Core:SetVoice("safenow",now+9)
        Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+9})
        Core:SetScreen(0,1,1,0.5)
    	elseif spellId == 232249 then
    	end
    end
    function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
      local now = GetTime()
      aoeCnt = 0
    end
    local cometName = GetSpellInfo(232249)
    local lastCometTime
    function bossmod:Timer10ms()
      local now = GetTime()
    	local hasDebuff, _, _, _, _, _, _, _, _, _, spellId = UnitDebuff("player", cometName)
    	if hasDebuff and spellId == 232249 and (not lastCometTime or now - lastCometTime > 10) then
    		lastCometTime = now
        Core:SetIconT({index = 13, texture = GetSpellTexture(spellId), duration = 5, start = nil, expires = nil, size = 1, name = "小圈", reverse = false})
        Core:SetScreen(1,0,0,0.5)
        Core:SetTextT({text1 = "|cffff0000小圈点你: |cff00ffff{number}|r", text2 = "|cff00ff00返回人群|r",start = nil,expires = now+6})
        Core:SetVoice("runout")
        Core:SetVoice("runin",now+5)
        Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+5})
        for i = 2,5 do
          Core:SetSay(""..(5-i),now + i)
        end
    	end
    end
    local timeline1 = {
      {
        phase = 1,
        text = "阶段1",
        timepoints = {
          {
            text = "AOE 结束",
            time = 0,
            color = {1,0,0},
          },
          {
            text = "分担",
            time = 12,
            color = {0,1,1},
          },
          {
            text = "火雨",
            time = 30,
            color = {1,0.5,0},
          },
          {
            text = "火球",
            time = 34,
            color = {0,1,0},
          },
          {
            text = "AOE",
            time = 54,
            color = {1,0,0},
          },

        },
      },
    }
    local timeline2 = {
      {
        phase = 1,
        text = "阶段1",
        timepoints = {
          {
            text = "AOE 结束",
            time = 0,
            color = {1,0,0},
          },
          {
            text = "火球",
            time = 10,
            color = {0,1,0},
          },
          {
            text = "分担",
            time = 22,
            color = {0,1,1},
          },
          {
            text = "火球",
            time = 40,
            color = {0,1,0},
          },
          {
            text = "AOE",
            time = 54,
            color = {1,0,0},
          },
        },
      },
    }
    function bossmod:GetTimeline(difficulty)
      return aoeCnt>4 and timeline2 or timeline1
    end
  end

  do --2
    local bossmod = Core:NewBoss({encounterID = 1867})
    function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
      local now = GetTime()
      if event == "SPELL_AURA_APPLIED" then
        if spellId == 233983 and Core:GetPlayerGUID() == destGUID then
          Core:SetText(text,now+2,now+2)
          Core:SetVoice("runout")
          Core:SetIcon(1,GetSpellTexture(spellId),2,9)
          Core:SetScreen(0.5,0,1,0.5)
          Core:SetScreen(0.5,0,1,0.5,now+0.6)
        end
      end
      if event == "SPELL_AURA_REMOVED" then
        if spellId == 233983 and Core:GetPlayerGUID() == destGUID then
          Core:SetIcon(1,GetSpellTexture(spellId),2,0)
          Core:SetVoice("safenow")
        end
      end
      if event == "SPELL_CAST_START" then
      end
    end
    function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
    	local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
      local now = GetTime()
    end
    local lastPowerTime
    function bossmod:Timer10ms()
      local now = GetTime()
      local power = UnitPower("player", SPELL_POWER_ALTERNATE_POWER) -- SPELL_POWER_ALTERNATE_POWER = 10
      if power > 90 and (not lastPowerTime or (now - lastPowerTime) > 5) then
        lastPowerTime = now
        local text = string.format("|cffff0000能量个过高:%d|r",power)
        Core:SetText(text,now+2,now+2)
        Core:SetVoice("energyhigh")
      end
    end
    local timeline = {
      {
        phase = 1,
        text = "阶段1",
        timepoints = {
        },
      },
    }
    function bossmod:GetTimeline(difficulty)
      return timeline
    end
  end

  do --7
    local bossmod = Core:NewBoss({encounterID = 1897})
    local fi = GetSpellInfo(235240)
    local li = GetSpellInfo(235213)
    function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
      local now = GetTime()
      if event == "SPELL_AURA_APPLIED" then
        if spellId == 235028 then -- p2
          if self.phase == 1 then
            self.phase = 2
            self.basetime = GetTime()
          end
        elseif spellId == 235240 then--Fel Infusion
      		if Core:GetPlayerGUID() == destGUID then
            Core:SetText("|cff00ff00邪能灌注：{number}|r","",now+5,now+5)
            Core:SetVoice("felinfusion")
            for i = 0,1 do
              Core:SetScreen(0,1,0,1,now+i*0.6)
            end
            Core:SetIcon(10,GetSpellTexture(spellId),1,0,nil,now+120)
            Core:SetIcon(1,GetSpellTexture(spellId),2,5)
      		end
      	elseif spellId == 235213 then--Light Infusion
      		if Core:GetPlayerGUID() == destGUID then
            Core:SetText("|cffffff00光明灌注：{number}|r","",now+5,now+5)
            Core:SetVoice("lightinfusion")
            for i = 0,1 do
              Core:SetScreen(1,1,0.5,1,now+i*0.6)
            end
            Core:SetIcon(10,GetSpellTexture(spellId),1,0,nil,now+120)
            Core:SetIcon(1,GetSpellTexture(spellId),2,5)
      		end
      	elseif spellId == 235117 or spellId == 240209 then
          if Core:GetPlayerGUID() == destGUID then
            if self.difficulty == 16 then
              Core:SetText("|cffff0000炸弹 - 跳坑：{number}|r","|cffff0000注意换边|r",now+6.5,now+8)
            else
              Core:SetText("|cffff0000炸弹 - 跳坑：{number}|r","|cffff0000面向中心|r",now+6.5,now+8)
            end
            Core:SetVoice("bombrun")
            Core:SetVoice("jumpinpit",now + 6.5)
            Core:SetIcon(1,GetSpellTexture(spellId),2,8)
          end
      	end
      end
      if event == "SPELL_AURA_REMOVED" then
        if spellId == 235117 or spellId == 240209 then
        elseif spellId == 235028 then--Bulwark Removed
          Core:SetVoice("kickcast")
        elseif spellId == 234891 then--Wrath Interrupted
          if self.phase == 2 then
            self.phase = 1
            self.basetime = GetTime()
          end
        end
      end
      if event == "SPELL_CAST_START" then
        if spellId == 235271 then -- p1
          Core:SetText("|cffff0000颜色转化：{number}|r","",now+3,now+3)
          Core:SetVoice("runin")
        elseif spellId == 241635 then--Light Hammer
          if UnitDebuff("player",li) then
            Core:SetText("|cffff0000集合分担：{number}|r","|cff00ff00分担结束|r",now+2.5,now+3)
            Core:SetVoice("gathershare")
          end
      	elseif spellId == 241636 then--Fel Hammer
          if UnitDebuff("player",fi) then
            Core:SetText("|cffff0000集合分担：{number}|r","|cff00ff00分担结束|r",now+2.5,now+3)
            Core:SetVoice("gathershare")
          end
        end
      end
      if event == "SPELL_CAST_SUCCESS" then
        if spellId == 241635 then --Light Hammer
          if UnitDebuff("player",fi) then
            Core:SetText("|cffff0000注意躲圈：{number}|r","",now+4,now+4)
            Core:SetVoice("watchstep",now + 1.5)
          end
        elseif spellId == 241636 then--Fel Hammer
          if UnitDebuff("player",li) then
            Core:SetText("|cffff0000注意躲圈：{number}|r","",now+4,now+4)
            Core:SetVoice("watchstep",now + 1.5)
          end
        end
      end
    end
    function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
    	local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
      local now = GetTime()
      if spellId == 239153 then --Orbs
        if UnitDebuff("player",fi) then
          Core:SetText("|cffff0000注意球：{number}|r","",now+2,now+2)
          Core:SetVoice("watchorb")
        end
      end
    end
    function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
      local now = GetTime()
      self.basetime = now - 38
    end
    local lastCometTime
    function bossmod:Timer10ms()
      local now = GetTime()
    end
    local timeline = {
      {
        phase = 1,
        text = "阶段1",
        timepoints = {
          {
            text = "换色",
            time = 2,
            color = {1,0,0},
          },
          {
            text = "奇数球",
            time = 8,
            color = {0,0.5,0.5},
          },
          {
            text = "光明锤",
            time = 14,
            color = {1,1,0},
          },
          {
            text = "偶数球",
            time = 16,
            color = {0,0.5,0.5},
          },
          {
            text = "奇数球",
            time = 24,
            color = {0,0.5,0.5},
          },
          {
            text = "邪能锤",
            time = 32,
            color = {0,1,0},
          },
          {
            text = "偶数球",
            time = 34,
            color = {0,0.5,0.5},
          },
          {
            text = "换色",
            time = 40,
            color = {1,0,0},
          },
          {
            text = "奇数球",
            time = 46,
            color = {0,0.5,0.5},
          },
          {
            text = "光明锤",
            time = 50,
            color = {1,1,0},
          },
          {
            text = "偶数球",
            time = 54,
            color = {0,0.5,0.5},
          },
          {
            text = "奇数球",
            time = 62,
            color = {0,0.5,0.5},
          },
          {
            text = "邪能锤",
            time = 68,
            color = {0,1,0},
          },
          {
            text = "偶数球",
            time = 70,
            color = {0,0.5,0.5},
          },
          {
            text = "转P2",
            time = 82,
            color = {0.5,1,1},
          },
        },
      },
      {
        phase = 1,
        text = "阶段2",
        timepoints = {
          {
            text = "球结束",
            time = 20,
            color = {0,0.5,0.5},
          },
        },
      },
    }
    function bossmod:GetTimeline(difficulty)
      return timeline
    end
  end
  do --8
    local bossmod = Core:NewBoss({encounterID = 2038})
    local sheildtimer
    function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
      local now = GetTime()
      if event == "SPELL_AURA_APPLIED" then
        if spellId == 234059 and Core:GetPlayerGUID() == destGUID then -- UnboundChaos
          Core:SetVoice("keepmove")
          Core:SetVoice("watchstep",now + 1)
          Core:SetIcon(1,GetSpellTexture(spellId),2,4)
          for i = 1,4 do
            Core:SetSay(""..(4-i),now + i)
          end
          Core:SetText("|cffff0000躲避小圈:{number}|r","|cff00ff00躲圈结束|r",now+4,now+5)
        end
        if spellId == 239739 and Core:GetPlayerGUID() == destGUID then -- UnboundChaos
          local hasDebuff,rank, icon, count, dispelType, duration, expires = UnitDebuff("player",spellName)
          Core:SetIcon(1,GetSpellTexture(spellId),2,duration)
          for i = 0,4 do
            Core:SetSay(""..i,expires-i)
          end
          Core:SetText("|cffff0000紫圈点你:{number}|r","|cff00ff00紫圈结束|r",now+duration,now+duration+1)
          Core:SetScreen(0.5,0,1,0.5)
          Core:SetVoice("targetyou")
        end
      end
      if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_APPLIED_DOSE" then
        if spellId == 236494 then
          local desname = spellName
          if Core:GetPlayerGUID() == destGUID then
            local c = select(4,UnitDebuff("player",desname)) or 1
            Core:SetText("|cffff0000破甲 - "..c.."层|r",nil,now+2,now+2)
            Core:SetIcon(1,GetSpellTexture(spellId),2,29,nil,now+3,nil,c)
            Core:SetIcon(10,GetSpellTexture(spellId),1,29,nil,nil,nil,c)
          else
            if Core:GetPlayerRole() == "TANK" then
              local hasDebuff,rank, icon, count, dispelType, duration, expires = UnitDebuff("player",desname)
              if not hasDebuff or expires - now < 11 then
                Core:SetVoice("tauntboss")
                Core:SetText("|cffff0000换坦嘲讽|r","",now+2,now+2)
              end
            end
          end
        end
      end
      -- if event == "SPELL_AURA_REMOVED" then
      --   if spellId == 236494 and Core:GetPlayerGUID() == destGUID then
      --     if not UnitIsUnit("boss1target","player") then
      --       Core:SetVoice("tauntboss")
      --       Core:SetText("|cffff0000换坦嘲讽|r","",now+2,now+2)
      --     end
      --   end
      -- end
      if event == "SPELL_AURA_REMOVED" then
        if spellId == 233739 then
          if sheildtimer then
            Core:CancelTimer(sheildtimer)
            sheildtimer = nil
          end
          Core:SetText("|cff00ff00护盾结束|r","",now + 2)
        end
      end
      if event == "SPELL_CAST_START" then
        if spellId == 239207 then -- TouchofSargeras
          Core:SetText("|cffff0000准备踩圈:{number}|r","|cff00ff00踩圈结束|r",now+10.5,now+11)
          Core:SetVoice("stepring")
        end
        if spellId == 239132 or spellId == 235572 then -- RuptureRealities
          Core:SetText("|cffff0000远离BOSS:{number}|r","|cff00ff00AOE结束|r",now+7.5,now+8)
          Core:SetIcon(1,GetSpellTexture(spellId),2,7.5)
          Core:SetVoice("justrun")
        end
        if spellId == 236494 then -- Desolate
          if UnitIsUnit("boss1target","player") then
            Core:SetVoice("defensive")
          end
        end
        if spellId == 233856 and Core:GetPlayerRole() == "DAMAGEER" then
          Core:SetVoice("bigmob")
          Core:SetScreen(1,1,0,0.5)
          Core:SetText("|cffffff00快打侍女|r","",now + 2)
          local expires = now + 18
          sheildtimer = Core:ScheduleRepeatingTimer(function()
            if not UnitIsUnit("boss2","target") and not UnitIsDeadOrGhost("player") then
              Core:SetVoice("targetchange")
            end
            if expires - GetTime() < 5 then
              Core:SetText("|cffff0000秒杀AOE:{number}|r","",expires,expires)
            end
          end,2)
        end
        if spellId == 233556 and UnitIsUnit("boss2tarnget","player") then
          Core:SetVoice("bosstobeam")
          Core:SetScreen(0,1,0,0.5)
          Core:SetText("|cffffff00快挡光:{number}|r","",now + 10)
        end
      end
      if event == "SPELL_CAST_SUCCESS" then
        if spellId == 240594 then
          Core:SetText("|cffff0000侍女被吃!!|r","",now+5,now+5)
          self.phase = 2
          self.basetime = now
        end
        if spellId == 235597 then
          self.phase = 2
          self.basetime = now
          Core:SetVoice("ptwo")
        end
      end
    end
    function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
    	local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
      local now = GetTime()
    end

    function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
    end

    function bossmod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg, sender, _, _, target)
    	if msg:find("234418") then -- Rain of the Destroyer
        local spellId = 234418
        Core:SetVoice("runout")
        Core:SetIcon(1,GetSpellTexture(spellId),5)
        for i = 1,5 do
          Core:SetSay("飞刀 - "..(5-i),now + i)
        end
        Core:SetText("|cffff0000飞刀点你{number}|r","|cff00ff00飞刀结束|r",now+5,now+6)
        Core:SetScreen(0.5,0,1,1)
    	end
    end

    local lastPowerTime
    function bossmod:Timer10ms()
      local now = GetTime()
      if (not lastPowerTime or now - lastPowerTime > 5) and UnitExists("boss2") then
        local p = UnitPower("boss2")
        if p > 90 and p<100 then
          Core:SetText("|cffff0000侍女能量: ".. p .."|r","",now+2,now+2)
          Core:SetVoice("bigmobsoon")
          lastPowerTime = now
        end
      end
    end
    local timeline = {
      {
        phase = 1,
        text = "阶段1",
        timepoints = {
          {
            text = "跑圈 + 6s + 分担",
            time = 10,
            color = {1,1,0},
          },
          {
            text = "AOE",
            time = 32,
            color = {0,1,0},
          },
          {
            text = "跑圈 + 换光",
            time = 49,
            color = {1,1,0},
          },
          {
            text = "飞刀 + 分担 + 转侍女",
            time = 57,
            color = {0.5,0,1},
          },
          {
            text = "飞刀 + 跑圈 + AOE + 换光",
            time = 87,
            color = {0.5,0,1},
          },
          {
            text = "分担",
            time = 110,
            color = {0,1,1},
          },
          {
            text = "飞刀 + 转侍女 + 跑圈",
            time = 131,
            color = {0.5,0,1},
          },
          {
            text = "换光+分担",
            time = 150,
            color = {0,1,1},
          },
          {
            text = "飞刀 + 跑圈 + AOE",
            time = 174,
            color = {0.5,0,1},
          },
          {
            text = "分担 + 换光",
            time = 197,
            color = {0,1,1},
          },
          {
            text = "转侍女 + 跑圈",
            time = 212,
            color = {1,1,0},
          },
          {
            text = "飞刀",
            time = 224,
            color = {0.5,0,1},
          },
          {
            text = "分担 + 10s + 换光",
            time = 240,
            color = {0,1,1},
          },
          {
            text = "跑圈",
            time = 260,
            color = {1,1,0},
          },
          {
            text = "飞刀 + AOE",
            time = 268,
            color = {0.5,0,1},
          },
          {
            text = "转侍女 + 分担",
            time = 284,
            color = {0,1,1},
          },
        },
      },
    }
    function bossmod:GetTimeline(difficulty)
      return timeline
    end
  end
  do --9
    local atname = GetSpellInfo(234310)
    local fcname = GetSpellInfo(245509)
    local p3aoecount = 0
    local bossmod = Core:NewBoss({encounterID = 2051})

    function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
      p3aoecount = 0
      Core:RegisterCreatureBeam(121227,{width = 1,alpha = 0.3,color={1,0,0,0.3},removes = GetTime() + 1e9})
      Core:RegisterAuraCooldowns(236710,{color = {0,0,1,0.2},radius = 5})

    end
    function bossmod:ENCOUNTER_END(event,encounterID, name, difficulty, size)
      Core:RegisterCreatureBeam(121227)
    end
    local demonicObelisk = {}
    function bossmod:AIRJ_HACK_OBJECT_CREATED(event,guid,type)
    	-- print(guid,type)
      if bit.band(type,0x2)==0 then
        local objectType,serverId,instanceId,zone,cid,spawn = AirjHack:GetGUIDInfo(guid)
        if objectType == "Creature" and cid == 120270 then --88076
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
    function bossmod:AIRJ_HACK_OBJECT_DESTROYED(event,guid,type)
      local m = demonicObelisk[guid]
      if m then
        m:Remove()
      end
    end
    function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
      local now = GetTime()
      if (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event == "SPELL_AURA_APPLIED_DOSE") then
        --p1
        if spellId == 234310 and Core:GetPlayerGUID() == destGUID then
          local count = select(2,...)
          Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 60, expires = now + 60, name = GetSpellInfo(spellId), count = count, scale = false})
        end
        if spellId == 236710 and Core:GetPlayerGUID() == destGUID then
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 8, start = nil, expires = nil, size = 2, name = "映像", reverse = false})
          Core:SetVoice("gather")
          Core:SetScreen(0.5,0,1)
          Core:SetTextT({text1 = "|cffff0000映像点你: |cff00ffff{number}|r", text2 = "|cff00ff00映像结束|r",start = nil,expires = now+8})
          for i = 0,3 do
            Core:SetSay(""..i,now + 8 - i)
          end
        end
        if spellId == 239932 then
          if UnitIsUnit("boss1target","player") then
            Core:SetVoice("defensive",now+6)
            Core:SetTextT({text1 = "|cffffff00邪爪开始|r", text2 = "",start = nil,expires = now+2})
            Core:SetScreen(1,0,0)
          end
          if Core:GetPlayerRole() == "HEALER" then
            Core:SetVoice("tankheal")
            Core:SetTextT({text1 = "|cffffff00邪爪开始|r", text2 = "",start = nil,expires = now+2})
          end
          if Core:GetPlayerRole() == "TANK" then
            Core:SetIconT({index = 13, texture = GetSpellTexture(spellId), duration = 11.5, size = 1, name = "邪爪"})
          end
        end
        if spellId == 244834 then
          self.phase = 1.5
          self.basetime = now
          Core:SetVoice("phasechange")
        end
        if spellId == 241721 and Core:GetPlayerGUID() == destGUID then
          Core:SetIconT({index = 13, texture = GetSpellTexture(spellId), duration = 20, expires = nil, name = GetSpellInfo(spellId), count = count, scale = false})
        end
        if Core:GetPlayerGUID() == destGUID and spellId==239932 and Core:GetPlayerRole() == "TANK" then
          local c = select(4,UnitDebuff("player",fcname)) or 0
          Core:SetTextT({text1 = "|cffffff00邪爪 - |cff00ffff"..c.." |cffffff00层|r", text2 = "",start = nil,expires = now+2})
          Core:SetIconT({index = 13, texture = GetSpellTexture(spellId), duration = 20, expires = nil, name = GetSpellInfo(spellId), count = c, scale = c==1})
        end
      end
      if event == "SPELL_AURA_REMOVED" then
        if (spellId == 234310) and Core:GetPlayerGUID() == destGUID then
          Core:ClearIcon(3)
        end
        if (spellId == 241721 or spellId == 239932) and Core:GetPlayerGUID() == destGUID then
          Core:ClearIcon(13)
        end
        if spellId == 239932 then
          if not UnitDebuff("player",fcname) then
            if Core:GetPlayerRole() == "TANK" then
              Core:SetVoice("tauntboss")
              Core:SetTextT({text1 = "|cffffff00换坦嘲讽|r", text2 = "",start = nil,expires = now+2})
            end
          end
        end
        if spellId == 244834 then
          self.phase = 2
          self.basetime = now
          Core:SetVoice("ptwo")
        end
        if spellId == 241983 then
          self.phase = 3
          self.basetime = now
          Core:SetVoice("pthree")
        end
      end
      if event == "SPELL_CAST_START" then
        if spellId == 240910 then
          local hasDebuff,rank, icon, count, dispelType, duration, expires = UnitDebuff("player",atname)
          if not hasDebuff or expires - now < 9 then
            Core:SetVoice("stepring")
            Core:SetIconT({index = 10, texture = GetSpellTexture(spellId), duration = 9, size = 1, name = "末日决战", reverse = false})
            Core:SetTextT({text1 = "|cffff0000末日决战: |cff00ffff{number}|r", text2 = "|cff00ff00决战结束|r",expires = now+9})
            Core:SetVoice("safenow",now+9)
            Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+9})
          end
        end
        if spellId == 241983 then
          self.phase = 2.5
          self.basetime = now
          Core:SetVoice("phasechange")
        end
        if spellId == 238999 then
          p3aoecount = p3aoecount + 1

          Core:SetIconT({index = 1, texture = GetSpellTexture(240910), duration = 9, size = 2, name = "千魂", reverse = false})
          Core:SetTextT({text1 = "|cffff0000千魂: |cff00ffff{number}|r", text2 = "|cff00ff00千魂结束|r",expires = now+9})
          if p3aoecount > 1 then
            Core:SetVoice("justrun",now+7)
          else
            Core:SetVoice("defensive",now+5)
          end
          Core:SetVoice("safenow",now+9)
        end
      end
      if event == "SPELL_CAST_SUCCESS" then
        if spellId == 238430 then
          Core:CreateCooldown({guid = destGUID,spellId = spellId,radius = 15,duration = 5,color = {1,1,0},alpha = 0.2,})
          if Core:GetPlayerGUID() == destGUID then
            Core:SetIcon(1,GetSpellTexture(spellId),2,5)
            -- Core:SetIcon(1,GetSpellTexture(238430),2,5)
            Core:SetVoice("bombrun")
            Core:SetTextT({text1 = "|cffff0000大圈点你: |cff00ffff{number}|r", text2 = "|cff00ff00大圈结束|r",start = nil,expires = now+5})
            Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 5, start = nil, expires = nil, size = 2, name = "大圈爆炸", reverse = false})
            for i = 0,3 do
              Core:SetSay(""..i,now + 5 - i)
            end
            Core:SetScreen(1,1,0)
          end
        end
      end
    end
    function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
      local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
      local now = GetTime()
      if spellId == 244856 then
        Core:SetVoice("watchstep")
        Core:SetVoice("watchorb",now + 3)
        Core:SetTextT({text1 = "|cffff0000火球: |cff00ffff{number}|r", text2 = "|cff00ff00火球生成|r",expires = now+5,start = nil})
        Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 5, name = "火球", reverse = false})
        Core:SetScreen(0,1,1)
      end
    end


    function bossmod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg, sender, _, _, target)
      local now = GetTime()
      if msg:find("235059") then
        local spellId = 235059
        Core:SetVoice("movecenter", now)
        Core:SetVoice("carefly",now+5)
        Core:SetTextT({text1 = "|cffffff00准备击飞: |cff00ffff{number}|r", text2 = "|cff00ff00击飞...|r",expires = now+10,start = now+5})
        Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 10, name = "奇点", reverse = false})
        Core:SetScreen(0,1,1)
      end
      if msg:find("238502") then
        local spellId = 238502
        if Core:GetPlayerGUID() == UnitGUID(target) then
          Core:SetVoice("laserrun")
          Core:SetTextT({text1 = "|cffff0000激光点你: |cff00ffff{number}|r", text2 = "|cff00ff00激光结束|r",start = nil,expires = now+5})
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 5, start = nil, expires = nil, size = 2, name = "激光", reverse = false})
          for i = 0,3 do
            Core:SetSay(""..i,now + 5 - i)
          end
          Core:SetScreen(1,0,0)
          Core:ScheduleTimer(function()
            if (GetUnitSpeed("player") or 1) > 0 then
              Core:SetVoice("stopmove")
            end
          end,3)
        else
          Core:SetVoice("range5")
        end
        Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+5})
        local unit = Core:FindHelpUnitByName(target)
        if unit then
          Core:CreateBeam({fromUnit= "boss1",toGUID = UnitGUID(unit),width = 6,length = 100,color = {1,0,0},alpha = 0.2,removes = now + 5})
          Core:CreateCooldown({guid = UnitGUID(unit),spellId = spellId,radius = 8,duration = 5,color = {1,0,0},alpha = 0.2})
        end
      end
    end

    function bossmod:Timer10ms()
      local now = GetTime()
    end
    local timeline = {
      {
        phase = 1,
        text = "阶段1",
        timepoints = {
          {
            time = 10,
            color = {1,0,0},
            text = "末日决战",
          },
          {
            time = 20,
            color = {0.5,0,1},
            text = "3小怪{mr1}",
          },
          -- {
          --   time = 25,
          --   color = {0,1,0},
          --   text = "邪爪 - 1 {sr1}",
          -- },
          -- {
          --   time = 50,
          --   color = {0,1,0},
          --   text = "邪爪 - 2 {sr2}",
          -- },
          {
            time = 58,
            color = {0,1,1},
            text = "紫圈",
          },
          {
            time = 70,
            color = {1,0,0},
            text = "转阶段 80%",
          },
        },
      },
      {
        phase = 1.5,
        text = "阶段1.5",
        timepoints = {
          {
            time = 6.5,
            color = {1,0,0},
            text = "大圈 + 末日决战(别提前动)",
          },
          {
            time = 23,
            color = {0,1,1},
            text = "击飞 + 激光",
          },
          {
            time = 36,
            color = {1,0,0},
            text = "激光 + 末日决战 {mr2}",
          },
          {
            time = 54,
            color = {0,1,1},
            text = "击飞 + 大圈 {sb1}",
          },
          {
            time = 60,
            color = {0,1,0},
            text = "转阶段 1min",
          },
        },
      },
      {
        phase = 2,
        text = "阶段2",
        timepoints = {
          -- {
          --   time = 15,
          --   color = {0,1,0},
          --   text = "邪爪 - 1 {sr3}",
          -- },
          {
            time = 22,
            color = {0,1,1},
            text = "小怪 + 激光",
          },
          -- {
          --   time = 40,
          --   color = {0,1,0},
          --   text = "邪爪 - 2 {sr4}",
          -- },
          {
            time = 50,
            color = {1,0,0},
            text = "大圈 + 末日决战(别提前动) {mr3}",
          },
          -- {
          --   time = 65,
          --   color = {0,1,0},
          --   text = "邪爪 - 3 {sr5}",
          -- },
          {
            time = 77,
            color = {0,1,1},
            text = "激光 + 2s + 击飞",
          },
          -- {
          --   time = 90,
          --   color = {0,1,0},
          --   text = "邪爪 - 4 {sr6}",
          -- },
          {
            time = 100,
            color = {0,1,1},
            text = "大圈 + 中场击飞 {sb1}",
          },
          -- {
          --   time = 115,
          --   color = {0,1,0},
          --   text = "邪爪 - 5 {sr7}",
          -- },
          {
            time = 127,
            color = {1,0,0},
            text = "末日决战 + 小怪 + 激光 {mr1}",
          },
          -- {
          --   time = 140,
          --   color = {0,1,0},
          --   text = "邪爪 - 6 {sr8}",
          -- },
          {
            time = 162,
            color = {1,0,0},
            text = "转阶段 40%",
          },
        },
      },
      {
        phase = 2.5,
        text = "阶段2.5",
        timepoints = {
          {
            time = 10,
            color = {0,1,1},
            text = "寻找伊利丹{mr2}",
          },
        },
      },
      {
        phase = 3,
        text = "阶段3",
        timepoints = {
          {
            time = 0,
            color = {0,1,1},
            text = "千魂{mr3}",
          },
          {
            time = 36,
            color = {1,0,0},
            text = "火球 + 4s + 方尖碑射 + 大圈",
          },
          {
            time = 67,
            color = {1,0,0},
            text = "火球 + 大圈 + 8s + 方尖碑射 {mr1}",
          },
          {
            time = 80,
            color = {0,1,1},
            text = "激光",
          },
          {
            time = 93,
            color = {0,1,1},
            text = "千魂",
          },
          {
            time = 131,
            color = {1,0,0},
            text = "火球 + 4s + 方尖碑射 + 大圈",
          },
          {
            time = 162,
            color = {1,0,0},
            text = "火球 + 大圈 + 8s + 方尖碑射 {mr2}",
          },
          {
            time = 175,
            color = {0,1,1},
            text = "激光",
          },
          {
            time = 188,
            color = {0,1,1},
            text = "千魂",
          },
          {
            time = 226,
            color = {1,0,0},
            text = "火球 + 4s + 方尖碑射 + 大圈",
          },
          {
            time = 267,
            color = {1,0,0},
            text = "火球 + 大圈 + 8s + 方尖碑射 {mr1}",
          },
        },
      }
    }
    function bossmod:GetTimeline(difficulty)
      return timeline
    end
  end
end
