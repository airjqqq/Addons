local addonsname,modulename = "AirjBossMods","TombofSargeras"
local Core = LibStub("AceAddon-3.0"):GetAddon(addonsname)
local R = Core:NewModule(modulename,"AceEvent-3.0")

function R:OnEnable()
  do
  	local prev = 0
  	function R:GroundEffectDamage(spellId)
  		local now = GetTime()
  		if now-prev > 1.5 then
  			prev = now
        Core:SetVoice("runaway")
        Core:SetTextT({text1="|cffff0000快躲开|r",expires = now+0.5,removes = now+0.5})
  		end
  	end
  end

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
    bossmod.furtureDamage = true
    local aoeCnt = 0
    local fireBallCnt = 0
    local function resetTimeLine(offset)
      local self = bossmod
      local now = GetTime()

      self.basetime = now + offset
      self.timelineChanged = true

      local damage = Core:GetDifficultyDamage(self.difficulty,200e4,133e4,133e4,133e4)
      if aoeCnt>=4 then
        Core:SetFutureDamage({key="233272"..":"..(fireBallCnt+1),start=self.basetime+16,duration=0.1,damage=damage})
        Core:SetFutureDamage({key="233272"..":"..(fireBallCnt+1),start=self.basetime+46,duration=0.1,damage=damage})
      else
        Core:SetFutureDamage({key="233272"..":"..(fireBallCnt+1),start=self.basetime+(bossmod.difficulty==16 and 40 or 30),duration=0.1,damage=damage})
        -- Core:SetFutureDamage({key="233272"..":"..(fireBallCnt+1),start=self.basetime+10,duration=0.1,damage=damage})
      end
      Core:SetFutureDamage({key="233062"..":"..(aoeCnt+1),start=self.basetime+60,duration=0.1,damage=Core:GetDifficultyDamage(self.difficulty,200e4,0,0,0)})

      if aoeCnt >= 4 and difficulty == 16 then
        Core:SetTimeline({text = "火球",color = {0,1,0}, expires = self.basetime + 10})
        Core:SetTimeline({text = "踩圈",color = {0,1,1}, expires = self.basetime + 22})
        Core:SetTimeline({text = "火球",color = {0,1,0}, expires = self.basetime + 40})
      else
        if difficulty == 16 then
          Core:SetTimeline({text = "踩圈",color = {0,1,1}, expires = self.basetime + 12})
        end
        Core:SetTimeline({text = "火球",color = {0,1,0}, expires = self.basetime + (difficulty == 16 and 34 or 24)})
      end
      Core:SetTimeline({text = "AOE - "..aoeCnt, expires = self.basetime + 54, color = {1,0,0}})
    end

    function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
      aoeCnt = 0
      fireBallCnt = 0
      resetTimeLine(0)
      -- Core:RegisterAuraCooldown(233272,{radius = 10, color = {0.5,0,1,0.2}})
    end
    function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
      local now = GetTime()
      if (event == "SPELL_AURA_APPLIED" or event == "SPELL_PERIODIC_DAMAGE" or event == "SPELL_PERIODIC_MISSED") and Core:GetPlayerGUID() == destGUID and spellId == 230348 then
        R:GroundEffectDamage(spellId)
      end
      if event == "SPELL_AURA_APPLIED" then
        --Star
        if spellId == 233272 then
          if destGUID == Core:GetPlayerGUID() then
            Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 6, start = nil, expires = nil, size = 2, name = "火球", reverse = false})
            Core:SetScreen(0,1,0)
            Core:SetTextT({text1 = "|cffff0000火球点你: |cff00ffff{number}|r", text2 = "|cff00ff00火球飞行中...|r",start = nil,expires = now+6})
            Core:SetVoice("bombrun")
            Core:SetVoiceT({str="kuai4                duo3      jian1     ci4     hou4         mian5",time=now+1})
            Core:SetVoice("safenow",now+7.5)
          end
          fireBallCnt = fireBallCnt + 1
          Core:SetFutureDamage({key=spellId..":"..(fireBallCnt),start=now+7,duration=0.1,damage=Core:GetDifficultyDamage(self.difficulty,200e4,133e4,133e4,133e4)})
          Core:CreateCooldown({
    				guid = destGUID,
    				spellId = spellId,
    				radius = 8,
    				duration = 7,
    				color = {1,0,0},
    				alpha = 0.4,
    			})
        end
        --Buring Armor
        if spellId == 231363 then
          Core:SetFutureDamage({key=spellId..":"..destGUID,duration=6,damage=Core:GetDifficultyDamage(self.difficulty,450e4),guid = destGUID})
          Core:SetFutureDamage({key=spellId..":"..destGUID..":e",duration=0.1,start = now + 6,damage=Core:GetDifficultyDamage(self.difficulty,300e4),guid = destGUID})
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
        if spellId == 230345 then
          local damage = Core:GetDifficultyDamage(self.difficulty,800e4,440e4,400e4,200e4)
          Core:SetFutureDamage({key=spellId..":"..destGUID,duration=16,damage=damage,guid = destGUID})
          if destGUID == Core:GetPlayerGUID() then
            Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 16, name = GetSpellInfo(spellId), count = count, scale = false})
          end
        end
      end
      if event == "SPELL_CAST_START" then
        if spellId == 233062 then
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 6, start = nil, expires = nil, size = 2, name = "AOE", reverse = false})
          Core:SetScreen(0,1,0)
          Core:SetTextT({text1 = "|cffffff00即将AOE: |cff00ffff{number}|r", text2 = "|cff00ff00AOE结束|r",start = nil,expires = now+6})
          Core:SetVoice("findshelter")
          Core:SetVoice("safenow",now+6)
          aoeCnt = aoeCnt + 1
          Core:SetFutureDamage({key=spellId..":"..(aoeCnt),start=now+6,duration=0.1,damage=Core:GetDifficultyDamage(self.difficulty,200e4,0,0,0)})
          resetTimeLine(6)
        end
      end
    end
    function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
    	local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
      local now = GetTime()
    	if spellId == 233050 then--Infernal Spike
        -- Core:SetVoice("watchstep")
        Core:SetVoiceT({str="zhu4       yi4      jian1      ci4"})
        Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 2.5, size = 1, name = "尖刺", reverse = false})
        Core:SetTextT({text1 = "|cffff0000尖刺: |cff00ffff{number}|r", text2 = "|cff00ff00尖刺|r",expires = now+2.5})
        Core:SetTimeline({key=spellId,expires = now+17,text = "尖刺",color = {1,1,0}})
    	elseif spellId == 233285 then--Rain of Brimston
        Core:SetVoice("stepring")
        Core:SetIconT({index = 10, texture = GetSpellTexture(spellId), duration = 9, size = 1, name = "踩圈", reverse = false})
        Core:SetTextT({text1 = "|cffff0000踩圈: |cff00ffff{number}|r", text2 = "|cff00ff00踩圈结束|r",expires = now+9})
        Core:SetVoice("safenow",now+9)
        Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+9})
        Core:SetScreen(0,1,1,0.5)
    	elseif spellId == 232249 then
        Core:SetTimeline({key=spellId,expires = now+18,text = "小圈",color = {0,0,1}})
    	end
    end
    local cometName = GetSpellInfo(232249)
    local lastCometTime
    local comets = {}
    function bossmod:Timer10ms()
      local now = GetTime()
    	local hasDebuff, _, _, _, _, _, _, _, _, _, spellId = UnitDebuff("player", cometName)
    	if hasDebuff and spellId == 232249 and (not lastCometTime or now - lastCometTime > 6) then
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
        local damage =
        Core:SeturtureDamage({start=now+5,duration=16,damage=200e4})
    	end
      for i = 1,40 do
        local unit = "raid"..i
        local guid = UnitGUID(unit)
        if guid and (not comets[guid] or (now - comets[guid] > 6)) then
          local hasDebuff, _, _, _, _, _, _, _, _, _, spellId = UnitDebuff(unit, cometName)
          if hasDebuff and spellId == 232249 then
            comets[guid] = now
            Core:CreateCooldown({
              guid = guid,
              spellId = spellId,
              radius = 8,
              duration = 5,
              color = {0,0.6,0},
              alpha = 0.3,
            })

            local damage = Core:GetDifficultyDamage(self.difficulty,800e4,440e4,400e4,200e4)
            Core:SetFutureDamage({key="230345"..":"..guid,duration=16,damage=damage,guid = guid,start=now+5})
          end
        end
      end
    end
  end

  do --2    aoeing | aaa | qusan | bbb | inside Dot
    local bossmod = Core:NewBoss({encounterID = 2048})
    bossmod.furtureDamage = true
    local aoe1cnt, aoe2cnt = 0,0
    function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
      local now = GetTime()
      aoe1cnt, aoe2cnt = 0,0
      Core:SetFutureDamage({key="233441:1",duration=16, start = now + 60, damage=Core:GetDifficultyDamage(self.difficulty,486e4)})
      Core:SetFutureDamage({key="235230:1",duration=16, start = now + 35, damage=Core:GetDifficultyDamage(self.difficulty,486e4)})
      Core:SetFutureDamage({key=234015,duration=0.1, start = now + 12, damage=Core:GetDifficultyDamage(self.difficulty,110e4)})
      Core:RegisterAuraCooldown(233983,{radius = 10, color = {0.5,0,1,0.2}})
      Core:SetTimeline({key=233441,expires = now+60,text = "斧头怪AOE",color = {1,0.5,0}})
      Core:SetTimeline({key=235230,expires = now+35,text = "法系怪AOE",color = {1,0,0.5}})
    end
    function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
      local now = GetTime()
      if (event == "SPELL_AURA_APPLIED" or event == "SPELL_PERIODIC_DAMAGE" or event == "SPELL_PERIODIC_MISSED") and Core:GetPlayerGUID() == destGUID and spellId == 233901 then
        R:GroundEffectDamage(spellId)
      end
      if event == "SPELL_AURA_APPLIED_DOSE" or event == "SPELL_AURA_APPLIED" then
        if spellId == 248713 and destGUID == Core:GetPlayerGUID() then
          local _,count = ...
          count = count or 1
          Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 5, start = nil, expires = nil, size = 1, name = "", count = count, reverse = true})
        end
      end
      if event == "SPELL_AURA_APPLIED" then
        if spellId == 233983 then
          if destGUID == Core:GetPlayerGUID() then
            Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 9, start = nil, expires = nil, size = 2, name = "驱散", reverse = true})
            Core:SetScreen(0.5,0,1)
            Core:SetTextT({text1 = "|cffff0000等待驱散: |cff00ffff{number}|r", text2 = "|cff00ff00驱散结束...|r",start = nil,expires = now+9})
            -- Core:SetVoice("runout")
            Core:SetVoiceT({str="deng3          dai4          qu1        san4",time = now + 1})
            Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+9})
          end
          Core:SetFutureDamage({key=spellId..":"..destGUID,duration=9, guid = destGUID, damage=Core:GetDifficultyDamage(self.difficulty,408e4)})
        end
        if spellId == 236283 then
          if destGUID == Core:GetPlayerGUID() then
            local power = UnitPower("player",10) or "-1"
            Core:SetSay("进入内长 - 能量: "..power)
          end
        end
      end
      if event == "SPELL_AURA_REMOVED" or event == "SPELL_DISPEL" then
        if spellId == 233983 then
          if destGUID == Core:GetPlayerGUID() then
            Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 0, start = nil, expires = nil, size = 2, name = "驱散", reverse = true})
            if event == "SPELL_DISPEL" then
              Core:SetTextT({text1 = "|cff00ff00已经驱散|r", text2 = "",start = nil,expires = now+1})
              Core:SetVoiceT({str="yi3              bei4        qu1        san4",time = now})
            end
            Core:SetPlayerAlpha({alpha = 0,start=now+0,removes=now+9})
          end
          Core:SetFutureDamage({key=spellId..":"..destGUID, guid = destGUID, damage=0})
        end
      end
      if event == "SPELL_CAST_START" then
        if spellId == 233426 then
          if UnitIsUnit("boss2target","player") then
            -- shunpizhan
          end
        end
        if spellId == 239401 then
          -- kick sequence
        end

        if spellId == 234015 then
          -- B aoe
          Core:SetFutureDamage({key=spellId,duration=0.1, start = now + 2, damage=Core:GetDifficultyDamage(self.difficulty,110e4)})
          Core:SetTimeline({key=spellId,expires = now+17,text = "AOE",color = {0,1,1}})
        end
      end
      if event == "SPELL_CAST_SUCCESS" then
        if spellId == 234015 then
          Core:SetFutureDamage({key=spellId,duration=0.1, start = now + 20, damage=Core:GetDifficultyDamage(self.difficulty,110e4)})
          -- B aoe
        end
        if spellId == 233431 then
          local unit = Core:FindHarmUnitByName(sourceName)
          local guid = UnitGUID(unit .."target")
          Core:CreateCooldown({
            guid = guid,
            spellId = spellId,
            radius = 8,
            duration = 4,
            color = {1,1,0},
            alpha = 0.4,
          })
          Core:CreateBeam({fromUnit= unit,toGUID = guid,width = 6,length = 40,color = {1,1,0},alpha = 0.2,removes = now + 4})
          Core:SetFutureDamage({key=spellId,duration=0.1, start=now+4, guid = guid, damage=Core:GetDifficultyDamage(self.difficulty,250e4)})
          if UnitIsUnit(unit .."target","player") then
            Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 4, size = 2, name = "钙化尖刺", reverse = true})
            Core:SetScreen(1,1,0)
            Core:SetTextT({text1 = "|cffff0000尖刺点你: |cff00ffff{number}|r", text2 = "|cff00ff00尖刺结束|r",start = nil,expires = now+4})
            Core:SetVoice("bombrun")
          end
          Core:SetTimeline({key=spellId,expires = now+21,text = "钙化尖刺",color = {1,1,0}})

        end
        if spellId == 233441 then
          if UnitGUID("target") == destGUID then
            -- Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 0, start = nil, expires = nil, size = 2, name = "停手", removes = now + 2, reverse = true})
            Core:SetScreen(1,0,0)
            Core:SetTextT({text1 = "|cffff0000停手|r", text2 = "",start = nil,expires = now+1})
            Core:SetVoice("stopattack")
          end
          aoe2cnt = aoe2cnt + 1
          Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 16, size = 1, name = ""})
          Core:SetFutureDamage({key=spellId..":"..aoe2cnt,duration=16, damage=Core:GetDifficultyDamage(self.difficulty,486e4)})
          Core:SetFutureDamage({key=spellId..":"..(aoe2cnt+1),duration=16, start = now + 60, damage=Core:GetDifficultyDamage(self.difficulty,486e4)})
          Core:SetTimeline({key=spellId,expires = now+60,text = "斧头怪AOE",color = {1,0.5,0}})
        end
        if spellId == 235230 then
          if UnitGUID("target") == destGUID then
            -- Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 0, start = nil, expires = nil, size = 2, name = "停手", removes = now + 2, reverse = true})
            Core:SetScreen(1,0,0)
            Core:SetTextT({text1 = "|cffff0000停手|r", text2 = "",start = nil,expires = now+1})
            Core:SetVoice("stopattack")
          end
          aoe1cnt = aoe1cnt + 1
          Core:SetFutureDamage({key=spellId..":"..aoe1cnt,duration=16, damage=Core:GetDifficultyDamage(self.difficulty,486e4)})
          Core:SetFutureDamage({key=spellId..":"..(aoe1cnt+1),duration=16, start = now + 60, damage=Core:GetDifficultyDamage(self.difficulty,486e4)})
          Core:SetTimeline({key=spellId,expires = now+35,text = "法系怪AOE",color = {1,0,0.5}})
        end
      end
    end

    function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
    	local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
      local now = GetTime()
    	if spellId == 233895 then -- Suffocating Dark
        Core:SetTimeline({key=spellId,expires = now+25,text = "驱散",color = {1,0.5,1}})
        if Core:GetPlayerRole() == "HEALER" then
          Core:SetVoice("dispelnow")
        end
    	end
    end
    local lastPowerTime
    local lastTargetPowerTime
    function bossmod:Timer10ms()
      local now = GetTime()
      local power = UnitPower("player", SPELL_POWER_ALTERNATE_POWER) -- SPELL_POWER_ALTERNATE_POWER = 10
      if power > 90 and (not lastPowerTime or (now - lastPowerTime) > 5) then
        lastPowerTime = now
        local text = string.format("|cffff0000能量过高:%d|r",power)
        Core:SetText(text,now+2,now+2)
        Core:SetVoice("energyhigh")
      end
      power = UnitPower("target") -- SPELL_POWER_ALTERNATE_POWER = 10
      if (UnitIsUnit("target","boss1") and power > 95 or UnitIsUnit("target","boss2") and power > 95) and (not lastTargetPowerTime or (now - lastTargetPowerTime) > 5) then
        lastTargetPowerTime = now
        local text = string.format("|cffff0000准备转火|r")
        Core:SetTextT({text1 = text, removes = now+1, expires = now+1})
        Core:SetVoice("changetarget")
      end
    end
  end

  do --3
    local bossmod = Core:NewBoss({encounterID = 2036})
    bossmod.furtureDamage = true
    local uncheckedRageCnt = 0
    local aoeCnt = 0
    local mobiconindex = 0

    local timeline = {
      {
        phase = 1,
        text = "阶段1",
        timepoints = {
          {
            text = "正面分担 1",
            time = 20,
            color = {1,0,0},
          },
          {
            text = "孵化",
            time = 32,
            color = {1,1,0},
          },
          {
            text = "正面分担 2",
            time = 40,
            color = {1,0,0},
          },
          {
            text = "转 P2",
            time = 58,
            color = {0,1,0},
          },
        },
      },
    }
    local function p1start()
      local self = bossmod
      local now = GetTime()
      uncheckedRageCnt = 0
      Core:SetFutureDamage({key="231854"..":"..1,start=now+23,duration=0.1,damage=Core:GetDifficultyDamage(bossmod.difficulty,200e4)})
      Core:SetFutureDamage({key="233520"..":"..(aoeCnt+1),start=now+67,duration=(aoeCnt+1)*7.5,damage=Core:GetDifficultyDamage(bossmod.difficulty,(aoeCnt+1)*5*44e4+140e4)})
      Core:SetTimeline({expires = now+23,text = "正面分担 - 1",color = {1,0,0}})
      if self.difficulty == 16 then
        Core:SetTimeline({expires = now+32,text = "腐化",color = {1,1,0}})
      end
      Core:SetTimeline({expires = now+58,text = "P2",color = {0,1,0}})
    end
    local function p2start()
      local self = bossmod
      local now = GetTime()
      bossmod.phase = 2
      bossmod.basetime = now

      Core:SetTextT({text1 = "|cff00ffff P2开始|r", expires = now})
      Core:SetVoice("ptwo")
      aoeCnt = aoeCnt + 1
      Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 10, name = GetSpellInfo(spellId)})
      Core:SetVoice("scatter",now+7)
      Core:SetVoice("watchstep",now+10)
      Core:SetTextT({text1 = "|cffffff00快分散|r", text2 = "|cff00ff00注意脚下|r", start = now+7,expires = now+10})
      Core:SetScreen(0,0,1,0.5,now+7)

      Core:SetFutureDamage({key="233520"..":"..(aoeCnt),start=now+10,duration=(aoeCnt)*7.5,damage=Core:GetDifficultyDamage(bossmod.difficulty,(aoeCnt)*5*44e4+140e4)})

      Core:SetTimeline({expires = now+10+aoeCnt*6,text = "P1",color = {0,1,1}})
    end
    function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
      aoeCnt = 0
      mobiconindex = 0
      p1start()
      Core:RegisterAuraBeam(234016,{width = 0.5, alpha = 0.2, color = {1,0,0,0.2}})
      Core:RegisterAuraCooldown(234016,{radius = 5, color = {1,0,0,0.2}})
      Core:RegisterAuraBeam(241600,{width = 0.2, alpha = 0.2, color = {0,1,0,0.2}})
      Core:RegisterAuraCooldown(231729,{radius = 6, color = {0,1,1,0.2}})
      Core:RegisterAuraBeam(240315,{width = 0.5,alpha = 0.3,color={0,0,1,0.3}})
    end
    function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
      local now = GetTime()
      if (event == "SPELL_AURA_APPLIED" or event == "SPELL_PERIODIC_DAMAGE" or event == "SPELL_PERIODIC_MISSED") and spellId == 231768 and destGUID == Core:GetPlayerGUID() then
        R:GroundEffectDamage(spellId)
      end
      if (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_APPLIED_DOSE") and spellId == 231998 then -- JaggedAbrasion
        local _,count = ...
        count = count or 1
        local damage = Core:GetDifficultyDamage(self.difficulty,count*15*40e4)
        Core:SetFutureDamage({key=spellId..":"..destGUID,duration=30,damage=damage,guid = destGUID})
        if Core:GetPlayerGUID() == destGUID then
          Core:SetTextT({text1 = "|cffffff00流血 - |cff00ffff"..count.."|cffffff00层|r", expires = now+1, removes = now+1})
          Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 30, name = GetSpellInfo(spellId), count = count, scale = false})
          -- Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 30, removes = now + 2, name = GetSpellInfo(spellId), size = 2, count = count})
        else
          if Core:GetPlayerRole() == "TANK" then
            local hasDebuff,rank, icon, count, dispelType, duration, expires = UnitDebuff("player",spellName)
            if not hasDebuff or expires - now < 6 then
              Core:SetVoice("tauntboss")
              Core:SetTextT({text1 = "|cffffff00换坦嘲讽|r", expires = now+2, removes = now+2})
            end
          end
        end
      end
      if event == "SPELL_AURA_APPLIED" then
        if spellId == 232061 then
          p2start()
        end
        if spellId == 231729 then
          Core:SetFutureDamage({start=now+6,duration=0.1,guid=destGUID,damage=Core:GetDifficultyDamage(bossmod.difficulty,70e4)})
          if Core:GetPlayerGUID() == destGUID then
            Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 6, name = GetSpellInfo(spellId), size = 2})
            -- Core:SetVoice("runout")
            Core:SetVoiceT({str="lan2       quan1      dian3      ni3",time=now+0})
            Core:SetTextT({text1 = "|cffffff00蓝圈点你|r", text2 = "|cff00ff00注意脚下|r", expires = now+6})
            Core:SetScreen(0,1,1,0.5)
            for i = 0,3 do
              Core:SetSay(""..i,now + 6 - i)
            end
          end
        end
        if spellId == 234016 then
          Core:SetFutureDamage({start=now+4,duration=6,guid=destGUID,damage=Core:GetDifficultyDamage(bossmod.difficulty,70e4)})
          if Core:GetPlayerGUID() == destGUID then
            Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 10, name = GetSpellInfo(spellId), size = 1})
            -- Core:SetVoice("justrun")
            Core:SetVoiceT({str="jiao3       dou4      suo3      ding4",time=now+0})
            Core:SetTextT({text1 = "|cffffff00角斗锁定你|r", text2 = "|cff00ff00锁定结束|r", expires = now+10,removes = now + 2})
            Core:SetScreen(1,1,0,0.5)
          end
        end
        if spellId == 241600 then
          if Core:GetPlayerGUID() == destGUID then
            -- Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 10, name = GetSpellInfo(spellId), size = 1})
            -- Core:SetVoice("justrun")
            -- Core:SetTextT({text1 = "|cffffff00蝌蚪锁定你|r", text2 = "|cff00ff00锁定结束|r", expires = now+1})
            -- Core:SetScreen(0.5,0,1,0.5)
          end
        end

      end
      if event == "SPELL_AURA_REMOVED" then
        if spellId == 234016 then
          if Core:GetPlayerGUID() == destGUID then
            Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 0, name = GetSpellInfo(spellId), size = 1})
            -- Core:SetVoice("safenow")
            Core:SetTextT({text1 = "|cff00ff00锁定结束|r", expires = now+0})
          end
        end
      end
      if (event == "SPELL_AURA_REMOVED_DOSE" or event == "SPELL_AURA_APPLIED_DOSE") and spellId == 233429 then
        local _,count = ...
        Core:SetIconT({index = 10, texture = GetSpellTexture(spellId), duration = 30, removes = count == 0 and now or now+4, name = GetSpellInfo(spellId), count = count, scale = false})
        if event == "SPELL_AURA_REMOVED_DOSE" and count < 3 then
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 30, removes = now + 1, name = GetSpellInfo(spellId), size = 2, count = count})
          Core:SetTextT({text1 = "|cffffff00 P2即将结束:|cff00ffff{number}|r",text2 = "|cff00ff00P2结束|r", expires = now+count*1.5})
          if count == 2 then
            if UnitHealth("player")<200e4 then
              Core:SetScreen(1,0,0,0.5)
              -- Core:SetVoice("defensive")
              Core:SetVoice("holdit")
            end
          end
        end
      end
      if event == "SPELL_CAST_START" then
        if spellId == 231904 then
          if Core:GetPlayerRole() ~= "HEALER" then
            Core:SetVoice("kickcast")

          end
        end
        if spellId == 231854 then
          uncheckedRageCnt = uncheckedRageCnt + 1
          -- Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 0.7, name = "集合分担", size = 1, reverse = false})
          Core:SetFutureDamage({key=spellId..":"..uncheckedRageCnt,start=now+0.7,duration=0.1,damage=Core:GetDifficultyDamage(bossmod.difficulty,200e4)})
          if uncheckedRageCnt == 1 then
            Core:SetTimeline({expires = now+21,text = "正面分担 - 2",color = {1,0,0}})
            Core:SetFutureDamage({key=spellId..":"..2,start=now+22.7,duration=0.1,damage=Core:GetDifficultyDamage(bossmod.difficulty,200e4)})
          else
            Core:SetVoice("killbigmob")
          end
        end
        if spellId == 232174 then
          bossmod.phase = 1
          bossmod.basetime = now
          Core:SetTextT({text1 = "|cff00ffff 返回P1|r", expires = now})
          Core:SetVoice("phasechange")
          p1start()
        end
      end
    end
    function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
    	local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
      local now = GetTime()
      if spellId == 240347 then
        if UnitIsUnit("boss1target","player") then
          Core:SetVoice("bigmobsoon")
          Core:SetScreen(0,1,1,0.5)
        else
          Core:SetVoice("bigmobsoon")
        end
      end
    end
    function bossmod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg, sender, _, _, target)
      if msg:find("123456") then
      end
    end

    local gatherTime
    local seenMobs = {}
    local mobtime
    function bossmod:Timer10ms()
      local now = GetTime()
      local power = UnitPower("boss1")
      if power >= 90 and (not gatherTime or (now - gatherTime > 10)) and bossmod.phase == 1 and (now - bossmod.basetime > 10) then
        Core:SetTextT({text1 = "|cffff0000集合分担: |cff00ffff{number}|r", text2 = "|cff00ff00分担结束|r", expires = now+3})
        Core:SetVoice("gathershare")
        gatherTime = now
      end

    	for i = 1, 5 do
    		local unit = "boss"..i
    		local guid = UnitGUID(unit)
    		if guid and not seenMobs[guid] then
          seenMobs[guid] = true
          local cid = Core:GetCid(guid)
          if cid == 116569 then
            if not mobtime or (now-mobtime>5) then
              Core:SetVoice("killmob")
              mobtime = now
            end
            if UnitIsGroupLeader("player") then
              mobiconindex = mobiconindex + 1
              SetRaidTarget(unit,7 + mobiconindex%2)
            end
          end
        end
      end
    end
    function bossmod:GetTimeline(difficulty)
      return timeline
    end
  end

  do --5
    -- shot all  |  wind/shark  |   shot/tank swip  |  ink debuff  |  2min debuff
    local bossmod = Core:NewBoss({encounterID = 2037})
    local shotCnt = 0
    local windCnt = 0
    local chargeCnt = 0
    local sharkCnt = 0
    local lastShotTime
    function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
      local now = GetTime()
      Core:RegisterAuraBeam(230139,{width = 4, alpha = 0.3, color = {0,1,0,0.3}})
      Core:RegisterAuraCooldown(230139,{radius = 5, color = {0,1,0,0.3}})
      Core:RegisterAuraCooldown(232913,{radius = 5, color = {0.5,0,1,0.3}})
      shotCnt = 0
      windCnt = 0
      chargeCnt = 0
      sharkCnt = 0
      lastShotTime = nil
      if bossMod.difficulty ~= 17 then
        Core:SetFutureDamage({key="230139"..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,180e4),start = now + 6 + 25, duration = 0.1})
        Core:SetFutureDamage({key="232754"..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,232e4),start = now + 6 + 25, duration = 6})
        Core:SetTimeline({expires = now+26,text = "多头蛇射击",color = {0,1,0},phase=bossMod.phase})
      end
    end
    function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
      local now = GetTime()
      if (event == "SPELL_AURA_APPLIED" or event == "SPELL_PERIODIC_DAMAGE" or event == "SPELL_PERIODIC_MISSED") and Core:GetPlayerGUID() == destGUID and spellId == 230959 then
        R:GroundEffectDamage(spellId)
      end
      if event == "SPELL_AURA_APPLIED" then
        if spellId == 230139 then
          if not lastShotTime or now > lastShotTime + 5 then
            lastShotTime = now
            shotCnt = shotCnt + 1
            Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 6, name = GetSpellInfo(spellId), size = 1, scale = false, reverse = false})
            Core:SetFutureDamage({key=spellId..":"..shotCnt,damage = Core:GetDifficultyDamage(bossmod.difficulty,180e4),start = now + 6, duration = 0.1})
            Core:SetFutureDamage({key="232754"..":"..shotCnt,damage = Core:GetDifficultyDamage(bossmod.difficulty,232e4),start = now + 6, duration = 6})
            local interval = bossmod.phase == 2 and 30 or bossmod.difficulty == 16 and 30 or 40
            Core:SetFutureDamage({key=spellId..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,180e4),start = now + 6 + interval, duration = 0.1})
            Core:SetFutureDamage({key="232754"..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,232e4),start = now + 6 + interval, duration = 6})
          end
          if Core:GetPlayerGUID() == destGUID then
            Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 6, name = GetSpellInfo(spellId), size = 2})
            Core:SetVoice("runtoedge")
            Core:SetTextT({text1 = "|cffff0000射击点你:|cff00ffff{number}|r", text2 = "|cff00ff00射击结束|r", expires = now+6})
            Core:SetScreen(0,1,0,0.5)
          end
        end
        if (spellId == 230384 or spellId == 234661)  then
          if Core:GetPlayerGUID() == destGUID then
            Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 120, name = GetSpellInfo(spellId), size = 1, scale = false})
          end
          Core:SetFutureDamage({key=spellId..":"..destGUID, guid = destGUID,damage = Core:GetDifficultyDamage(bossmod.difficulty,80e4*60), duration = 120})
        end
        if spellId == 232913 then
          if Core:GetPlayerGUID() == destGUID then
            Core:SetIconT({index = 13, texture = GetSpellTexture(spellId), duration = 6, name = GetSpellInfo(spellId), size = 1})
          end
          Core:SetTimeline({expires = now+30,text = "多头蛇射击",color = {0,1,0},phase=bossMod.phase})
          Core:SetFutureDamage({key=spellId..":"..destGUID, guid = destGUID,damage = Core:GetDifficultyDamage(bossmod.difficulty,55e4*6), duration = 6})
        end
      end
      if event == "SPELL_AURA_REMOVED" then
        if (spellId == 230384 or spellId == 234661) then
          if Core:GetPlayerGUID() == destGUID then
            Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 0, name = GetSpellInfo(spellId), size = 1, scale = false})
          end
          Core:SetFutureDamage({key=spellId..":"..destGUID,damage = 0, guid = destGUID, duration = 120})
        end
        if spellId == 232913 then
          if Core:GetPlayerGUID() == destGUID then
            Core:SetIconT({index = 13, texture = GetSpellTexture(spellId), duration = 0, name = GetSpellInfo(spellId), size = 1, scale = false})
          end
          Core:SetFutureDamage({key=spellId..":"..destGUID,damage = 0, guid = destGUID, duration = 6})
        end
      end
      if event == "SPELL_CAST_START" then
        if spellId == 230201 then
          if Core:GetPlayerRole() == "TANK" then
            if UnitIsUnit("boss1target","player") then
              Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 2.5, name = GetSpellInfo(spellId), size = 2, reverse = false})
              Core:SetVoice("tauntboss")
              Core:SetTextT({text1 = "|cffffff00换坦嘲讽:|cff00ffff{number}|r", text2 = "|cffffff00换坦嘲讽|r", expires = now+2.5})
              Core:SetScreen(0.5,0,1,0.5)
            end
          end
        end
        if spellId == 232722 then
          windCnt = windCnt + 1
          Core:SetTextT({text1 = "|cffffff00注意旋风:|cff00ffff{number}|r", text2 = "|cffffff00旋风出现|r", expires = now+4})
          Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 4, name = GetSpellInfo(spellId), size = 1, reverse = false})
          Core:SetScreen(1,0,0,0.5)
          Core:SetVoice("wwsoon")
          if bossMod.phase ~= 3 then
            Core:SetTimeline({expires = now+35,text = "旋风",color = {1,1,0},phase=bossMod.phase})
          end
        end
        if spellId == 232827 then
          chargeCnt = chargeCnt + 1
          Core:SetTextT({text1 = "|cffffff00注意波浪:|cff00ffff{number}|r", text2 = "|cffffff00波浪出现|r", expires = now+2})
          Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 6, name = GetSpellInfo(spellId), size = 1, reverse = false})
          Core:SetScreen(0,1,1,0.5)
          Core:SetVoice("watchwave")
          if bossMod.phase == 2 then
            Core:SetTimeline({expires = now+42,text = "波浪",color = {0,1,1},phase=bossMod.phase})
            Core:SetTimeline({expires = now+10,text = "吸人",color = {1,0,0.5},phase=bossMod.phase})
          end
        end
        if spellId == 232746 then
          sharkCnt = sharkCnt + 1
          Core:SetTextT({text1 = "|cffffff00准备运送:|cff00ffff{number}|r", text2 = "|cffffff00运送开始|r", expires = now+2})
          Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 2, name = GetSpellInfo(spellId), size = 1, reverse = false})
          Core:SetScreen(0.5,0,1,0.5)
          Core:SetVoice("inktoshark")
          Core:SetFutureDamage({key=spellId..":"..sharkCnt,damage = Core:GetDifficultyDamage(bossmod.difficulty,300e4),start = now + 4, duration = 6})
          Core:SetFutureDamage({key=spellId..":"..(sharkCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,300e4),start = now + 4, duration = 6})
          Core:SetTimeline({expires = now+42,text = "吸人",color = {1,0,0.5},phase=bossMod.phase})
        end
        if spellId == 230358 then
          Core:SetTextT({text1 = "|cffffff00注意白圈:|cff00ffff{number}|r", text2 = "|cffffff00白圈出现|r", expires = now+2})
          Core:SetScreen(0.8,1,1,0.5)
          Core:SetIconT({index = 13, texture = GetSpellTexture(spellId), duration = 5, name = GetSpellInfo(spellId), size = 1,scale = false})
          Core:SetVoice("watchstep")
        end
      end
    end
    function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
      local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
      local now = GetTime()
    end

    function bossmod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg, sender, _, _, target)
      if msg:find("123456") then
      end
    end

    local lastCometTime
    function bossmod:Timer10ms()
      local now = GetTime()
      local health = UnitHealth("boss1")
      local max = UnitHealthMax("boss1")
      if health > 0 then
        if bossmod.phase == 1 and health/max < 0.70 then
          bossmod.phase = 2
          bossmod.basetime = now
          Core:SetVoice("ptwo")
          Core:SetFutureDamage({key="232746"..":"..1,damage = Core:GetDifficultyDamage(bossmod.difficulty,300e4),start = now + 40, duration = 6})
          if bossMod.difficulty ~= 17 then
            Core:SetFutureDamage({key="230139"..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,180e4),start = now + 20, duration = 0.1})
            Core:SetFutureDamage({key="232754"..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,232e4),start = now + 20, duration = 6})
          end
          Core:SetTimeline({expires = now+14,text = "多头蛇射击",color = {0,1,0},phase=bossMod.phase})
        elseif bossmod.phase == 2 and health/max < 0.40 then
          bossmod.phase = 3
          bossmod.basetime = now
          Core:SetVoice("pthree")
          Core:SetFutureDamage({key="232746"..":"..(sharkCnt+1),damage = 0})
          if bossMod.difficulty ~= 17 then
            Core:SetFutureDamage({key="230139"..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,180e4),start = now + 23, duration = 0.1})
            Core:SetFutureDamage({key="232754"..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,232e4),start = now + 23, duration = 6})
          end
          Core:SetTimeline({expires = now+17,text = "多头蛇射击",color = {0,1,0},phase=bossMod.phase})
          local chargeTimes = {32,103,149}
          for i,v in ipairs(chargeTimes) do
            Core:SetTimeline({key = "232827:"..i,expires = now+v,text = "波浪",color = {0,1,1},phase=bossMod.phase})
          end
          local windTimes = {54,93,127,170}
          for i,v in ipairs(windTimes) do
            Core:SetTimeline({key = "232722:"..i,expires = now+v,text = "旋风",color = {1,1,0},phase=bossMod.phase})
          end
        end
      end
    end
  end
  do --7
    local bossmod = Core:NewBoss({encounterID = 2052})
    local fi = GetSpellInfo(235240)
    local li = GetSpellInfo(235213)
    local changeColorCnt = 0
    local function changeColor()
      local now = GetTime()
      Core:SetTimeline({expires = now+6,text = "奇数球",color = {0,1,1}})
      Core:SetTimeline({key="orb1",expires = now+12,text = "光明锤",color = {1,1,0}})
      Core:SetTimeline({key="orb2",expires = now+14,text = "偶数球",color = {0,1,1}})
      Core:SetTimeline({key="orb3",expires = now+22,text = "奇数球",color = {0,1,1}})
      Core:SetTimeline({expires = now+30,text = "邪能锤",color = {0,1,0}})
      Core:SetTimeline({key="orb4",expires = now+32,text = "偶数球",color = {0,1,1}})
      if changeColorCnt == 2 then
        Core:SetTimeline({expires = now+38,text = "转阶段",color = {1,0,0}})
      else
        Core:SetTimeline({expires = now+38,text = "换色",color = {1,0,0}})
      end
    end
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
            changeColorCnt = 0
            self.phase = 1
            self.basetime = GetTime()
          end
        end
      end
      if event == "SPELL_CAST_START" then
        if spellId == 235271 then -- p1
          Core:SetText("|cffff0000颜色转化：{number}|r","",now+3,now+3)
          Core:SetVoice("runin")
          changeColorCnt = changeColorCnt + 1
          changeColor()
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
      changeColorCnt = 1
      Core:SetTimeline({expires = now+2,text = "换色",color = {1,0,0}})
    end
    local lastCometTime
    function bossmod:Timer10ms()
      local now = GetTime()
    end
  end
  do --8
    local bossmod = Core:NewBoss({encounterID = 2038})
    local sheildtimer
    function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
      Core:RegisterAuraCooldown(239739,{color = {1,0,0.5,0.2}, radius = 8})
    end
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
        if spellId == 239739 then
          if Core:GetPlayerGUID() == destGUID then -- UnboundChaos
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
        if spellId == 233856 and Core:GetPlayerRole() ~= "HEALER" then
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
        if spellId == 233556 and UnitIsUnit("boss2target","player") then
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

    function bossmod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg, sender, _, _, target)
    	if msg:find("234418") then
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
        if p >= 95 and p<100 then
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
      Core:RegisterAuraCooldown(236710,{color = {0,0,1,0.2},radius = 5})

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
          Core:SetIconT({index = 10, texture = GetSpellTexture(239785), duration = 9, size = 1, name = "", reverse = false})
          Core:SetFutureDamage({key="239785",duration=0.1,start = GetTime() + 9,damage=Core:GetDifficultyDamage(self.difficulty,100e4)})
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
          count = count or 1
          Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 60, expires = now + 60, name = GetSpellInfo(spellId), count = count, scale = false})
          Core:SetFutureDamage({key=spellId..":"..destGUID,duration=60,guid=destGUID,damage=Core:GetDifficultyDamage(self.difficulty,count*30*65e4)})
        end
        if spellId == 236710 and Core:GetPlayerGUID() == destGUID then
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 8, start = nil, expires = nil, size = 2, name = "映像", reverse = false})
          Core:SetVoice("gather")
          Core:SetScreen(0.5,0,1)
          Core:SetTextT({text1 = "|cffff0000映像点你: |cff00ffff{number}|r", text2 = "|cff00ff00映像结束|r",start = nil,expires = now+8})
          Core:SetFutureDamage({key=spellId..":1",duration=0.1,start=now+11,damage=Core:GetDifficultyDamage(self.difficulty,50e4)})
          Core:SetFutureDamage({key=spellId..":2",duration=0.1,start=now+14,damage=Core:GetDifficultyDamage(self.difficulty,200e4)})
          for i = 0,3 do
            Core:SetSay(""..i,now + 8 - i)
          end
        end
        if spellId == 239932 then
          local guid = UnitGUID("boss1target")
          if guid then
            Core:SetFutureDamage({key=spellId,guid=guid,duration=9,damage=Core:GetDifficultyDamage(self.difficulty,300e4*5)})
          end
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
          Core:SetFutureDamage({key="241983"..":dot",start=now+7.5,duration=60,damage=0})
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
          Core:SetFutureDamage({key=spellId..":dot",start=now+7.5,duration=60,damage=Core:GetDifficultyDamage(self.difficulty,30e4*60)})
        end
        if spellId == 238999 then
          p3aoecount = p3aoecount + 1

          Core:SetIconT({index = 1, texture = GetSpellTexture(240910), duration = 9, size = 2, name = "千魂", reverse = false})
          Core:SetTextT({text1 = "|cffff0000千魂: |cff00ffff{number}|r", text2 = "|cff00ff00千魂结束|r",expires = now+9})
          if p3aoecount > 1 then
            Core:SetVoice("justrun",now+7)
          else
            Core:SetVoice("defensive",now+5)
            Core:SetFutureDamage({key=spellId,start=now+9,duration=0.1,damage=Core:GetDifficultyDamage(self.difficulty,450e4)})
            Core:SetFutureDamage({key=spellId..":dot",start=now+9,duration=400,damage=Core:GetDifficultyDamage(self.difficulty,30e4*400)})
          end
          Core:SetVoice("safenow",now+9)
        end
      end
      if event == "SPELL_CAST_SUCCESS" then
        if spellId == 238430 then
          Core:CreateCooldown({guid = destGUID,spellId = spellId,radius = 5,duration = 5,color = {1,1,0},alpha = 0.15,})
          Core:SetFutureDamage({key=spellId..":"..destGUID,start=now+5,guid = destGUID,duration=0.1,damage=Core:GetDifficultyDamage(self.difficulty,200e4)})
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
        Core:SetFutureDamage({key=spellId,start=now+10,duration=0.1,damage=Core:GetDifficultyDamage(self.difficulty,80e4)})
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
          local guid = UnitGUID(unit)
          Core:SetFutureDamage({key=spellId..":"..guid,start=now+5,duration=0.1,guid=guid,damage=Core:GetDifficultyDamage(self.difficulty,200e4)})
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
