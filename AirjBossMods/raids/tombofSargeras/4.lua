local addonsname = "AirjBossMods"
local modulename = "TombofSargeras-4"
local Core = LibStub("AceAddon-3.0"):GetAddon(addonsname)
local R = Core:NewModule(modulename,"AceEvent-3.0")

-- maydiebuff  | mythic buff | Silence Circle| need swap buff | week buff
function R:OnEnable()
  local bossmod = Core:NewBoss({encounterID = 2050})
  local aoeCnt = 0
  local vulnHistory = {}
  local function updateTimeLines(length)
    local now = GetTime()
    local space = length/8
    local offset = -2
    Core:SetTimeline({text = "满月 - "..(aoeCnt+1), expires = now+length, color = {0,1,1}})
    Core:SetTimeline({text = "AOEING - "..(((aoeCnt-1)%4)+1), expires = now+12, color = {1,0,0}})
    local gi = Core:GetPlayerKeyFromBoardData()
    for i=1,7 do
      Core:SetTimeline({key = "swap"..i,text = "换区 - "..i, expires = now+space*i+offset, preshow = now+space*(i-1)+offset+2, start = now+space*(i-1)+offset, removes = now+space*(i+0)+offset+2, color = {0,0,1,0.6}})
      if gi == i then
        local name = GetSpellInfo(236330)
        local timer
        timer = Core:ScheduleRepeatingTimer(function()
          if GetTime()>now+space*i+offset - 1 then
            if not UnitDebuff("player",name) then
              Core:SetVoiceT({file="changemoon"})
              Core:SetScreen(1,1,0,0.3)
              Core:CancelTimer(timer)
            end
          end
        end,0.1)
      elseif not gi then
        for j = 1,3 do
          Core:SetVoiceT({file="count\\"..i,time = now+space*i+offset+(j-2)*0.3})
        end
      end
    end
  end
  function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
    local now = GetTime()
    aoeCnt = 0
    updateTimeLines(48.3)
    Core:SetFutureDamage({key="aoe"..":"..(aoeCnt+1),start=now+48.3+6,duration=6,damage=Core:GetDifficultyDamage(self.difficulty,600e4)})

    Core:RegisterAuraCooldown(236519,{color={0,1,1,0.2},radius=3}) -- moon burn
    Core:RegisterAuraCooldown(236550,{color={0,1,1,0.2},radius=3}) -- tank swap debuff
    Core:RegisterAuraCooldown(236712,{color={0,1,0,0.2},radius=8})  --p3 out debuff
    Core:RegisterAuraCooldown(237561,{color={1,0,0,0.2},radius=5})  -- red arrow
    Core:RegisterAuraCooldown(236305,{color={0.5,0,1,0.2},radius=8})  -- purple line

    Core:RegisterAuraBeam(237561,{width=2,color={1,0,0,0.2}})  -- red arrow
    Core:RegisterAuraBeam(236305,{width=4,color={0.5,0,1,0.1}}) -- purple line
    vulnHistory = {}
    Core:SetInfo(vulnHistory)
  end
  local lastaoe
  local function aoe()
    local now = GetTime()
    if lastaoe and now - lastaoe < 10 then
      return
    end
    lastaoe = now
    aoeCnt = aoeCnt + 1
    updateTimeLines(54.7)
    Core:SetFutureDamage({key="aoe"..":"..(aoeCnt+0),start=now+6,duration=6,damage=Core:GetDifficultyDamage(self.difficulty,600e4)})
    Core:SetFutureDamage({key="aoe"..":"..(aoeCnt+1),start=now+54.7+6,duration=6,damage=Core:GetDifficultyDamage(self.difficulty,600e4)})
    local rc = aoeCnt%4
    local ri = Core:GetPlayerKeyFromBoardData("r")
    if ri == rc or Core:ShowAllMessage() or Core:GetPlayerRole() == "HEALER" then
      Core:SetTextT({text1 = "|cffffff00"..rc.."减伤|r",text2 = "", expires = now+2})
      Core:SetVoiceT({file = "defensive"})
      Core:SetVoiceT({file = "count\\"..rc,time=now+0.7})
    end
    if ri == rc then
      Core:SetVoiceT({file = "uu",time=now+1.4})
    end
  end
  local vulns = {}
  local lastVulns = 0
  local vulnCnt = 0
  function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
    local now = GetTime()

    if (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_APPLIED_DOSE") then
      if spellId == 236330 then
        if Core:GetPlayerGUID() == destGUID then
          local _,count = ...
          count = count or 1
          Core:SetIconT({index = 10, texture = GetSpellTexture(spellId), duration = 2, size = 1, name = "", count = count, scale = false})
        end
      end
    end
    if (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_APPLIED_DOSE") then
      if spellId == 234996 or spellId == 234995 then
        if Core:GetPlayerGUID() == destGUID then
          local _,count = ...
          count = count or 1
          Core:SetTextT({text1 = "|cff7f00ff月灼:|cff00ffff{number}|r",text2 = "|cff00ff00紫线结束|r", expires = now+6})
        end
      end
    end
    if event == "SPELL_AURA_APPLIED" then
      if spellId == 236305 then
        aoe()
        if Core:GetPlayerGUID() == destGUID then
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 6, size = 2, name = "紫线", reverse = true})
          -- Core:SetVoiceT({file = "holdit", time = now + 3})
          Core:SetVoiceT({str="zi5       xian4                 dian3         ni3"})
          Core:SetTextT({text1 = "|cff7f00ff紫线:|cff00ffff{number}|r",text2 = "|cff00ff00紫线结束|r", expires = now+6})
          Core:SetScreen(0,0.5,1)
          Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+6})
          Core:SetSay("紫线点我")
          for i = 0,3 do
            Core:SetSay(""..i,now + 6 - i)
          end
        end
      end
      if spellId == 236519 then
        Core:SetFutureDamage({key=spellId..":"..destGUID,guid = destGUID,start=now+0,duration=30,damage=Core:GetDifficultyDamage(self.difficulty,1500e4)})
        if Core:GetPlayerGUID() == destGUID then
          Core:SetTextT({text1 = "|cffffff00月灼|r",text2 = "", expires = now+1})
          Core:SetIconT({index = 13, texture = GetSpellTexture(spellId), duration = 30, size = 1, name = "", reverse = true})
          -- moon burn
        end
      end
      if spellId == 236550 then
        if Core:GetPlayerGUID() == destGUID then
          Core:SetTextT({text1 = "|cffffff00无形|r",text2 = "", expires = now+1})
          Core:SetIconT({index = 13, texture = GetSpellTexture(spellId), duration = 30, size = 1, name = "", reverse = true})
          -- tank debuff
        end
      end
      if spellId == 236596 then
        Core:SetFutureDamage({key=spellId..":"..destGUID,guid = destGUID,start=now,duration=8,damage=Core:GetDifficultyDamage(self.difficulty,1000e4)})
        if Core:GetPlayerGUID() == destGUID then
          Core:SetTextT({text1 = "|cffff0000急速射击: |cff00ffff{number}|r", text2 = "|cff00ff00急速射击结束|r",start = nil,expires = now+8})
          Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 8, size = 1, name = "", reverse = true})
          Core:SetVoiceT({file = "defensive"})
          -- moon burn
        end
      end
      if spellId == 236712 then
        Core:SetFutureDamage({key=spellId..":"..destGUID,guid = destGUID,start=now,duration=10,damage=Core:GetDifficultyDamage(self.difficulty,1000e4)})
        if Core:GetPlayerGUID() == destGUID then
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 6, size = 2, name = "", reverse = true})
          Core:SetVoiceT({file = "bombrun"})
          -- Core:SetVoiceT({str="chen2          mo4            dian3         ni3"})
          Core:SetScreen(0.5,0,1)
          Core:SetTextT({text1 = "|cffffff00沉默圈点你: |cff00ffff{number}|r", text2 = "|cff00ff00沉默圈开始|r",start = nil,expires = now+6})
          Core:SetTextT({text1 = "|cffff0000沉默圈: |cff00ffff{number}|r", text2 = "|cff00ff00沉默圈结束|r",start = now+6,expires = now+10})
          for i = 0,3 do
            Core:SetSay(""..i,now + 6 - i)
          end
          for i = 0,3 do
            Core:SetSay(""..i,now + 10 - i)
          end
          -- p3 debuff
        end
      end
      if spellId == 237561 then
        Core:SetFutureDamage({key=spellId..":"..destGUID,guid = destGUID,start=now+3,duration=0.1,damage=Core:GetDifficultyDamage(self.difficulty,250e4)})
        if Core:GetPlayerGUID() == destGUID then
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 3, size = 2, name = "", reverse = true})
          Core:SetTextT({text1 = "|cffffff00红箭头: |cff00ffff{number}|r", text2 = "|cff00ff00红箭头结束|r",start = nil,expires = now+3})
          -- Core:SetVoiceT({str="fei1                 dao1          dian3         ni3"})
          Core:SetScreen(1,0,0)
          Core:SetVoiceT({file = "laserrun"})
          for i = 0,3 do
            Core:SetSay(""..i,now + 3 - i)
          end
          Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+3})
          -- red arrow
        end
        Core:SetTimeline({text = "红箭头", expires = now+20, color = {1,0,0}, color2 = {0,1,0,1},removes = now+35,phase = bossmod.phase})
      end
    end
    if event == "SPELL_AURA_REMOVED" then
      if spellId == 236550 or spellId == 236519 then

        Core:SetFutureDamage({key=spellId..":"..destGUID,guid = destGUID,start=now+0,duration=30,damage=0})
        if Core:GetPlayerGUID() == destGUID then
          Core:ClearIcon(13)
          -- tank debuff
          -- moon burn
        end
      end
    end
    if event == "SPELL_CAST_START" then
      if spellId == 239379 then
        aoe()
      end
      if spellId == 236442 then

        Core:ScanBossTarget(sourceGUID,function(unit,target)
          local toGuid = UnitGUID(target)
          Core:CreateCooldown({guid = toGuid, spellId = spellId,
          radius = 8, duration = 3, color = {1,1,0}, alpha = 0.2})
          if UnitIsUnit(target,"player") then
            Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 3, size = 2, name = "箭雨", reverse = true})
            Core:SetScreen(0.5,0,1)
            Core:SetTextT({text1 = "|cffff0000箭雨点你: |cff00ffff{number}|r", text2 = "|cff00ff00箭雨结束|r",start = nil,expires = now+3})
            -- Core:SetVoiceT({str="jian4            yu3        dian3         ni3"})
            Core:SetVoiceT({file = "bombrun"})
            for i = 0,3 do
              Core:SetSay(""..i,now + 3 - i)
            end
            Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+3})
          end
        end)
      end
    end
    if event == "SPELL_CAST_SUCCESS" then
      if spellId == 236442 then
        Core:SetTimeline({text = "箭雨", expires = now+20, color = {1,1,0}, color2 = {0,1,0,1},removes = now+35,phase = bossmod.phase})
      end
      if spellId == 233263 then
        aoe()
      end
      if spellId == 236330 then
        local last = vulns[sourceGUID] or 0
        if now-last > 0.1 then
          local unit = Core:FindHelpUnitByGuid(sourceGUID)
          local interval = now-lastVulns
          if interval < 2 then
            vulnCnt = vulnCnt + 1
          else
            vulnCnt = 0
          end
          local color = interval<2 and "|cffff0000" or "|cff00ff00"
          -- Core:SetSay(UnitName(unit).."["..vulnCnt.."]".."-"..Core:GetTimeString(interval))
          tinsert(vulnHistory,1,{left=Core:GetUnitString(unit),right=interval< 100 and ("["..vulnCnt.."] "..color..Core:GetTimeString(interval).."|r")})
          vulnHistory[9] = nil
          Core:NotifyInfoChanged()
          vulns[sourceGUID] = now
          lastVulns = now
          if Core:GetPlayerGUID() == sourceGUID then
            Core:SetScreen(0,1,0)
            Core:SetVoiceT({file = "safenow"})
          end
        end
      end
    end
  end
  function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
  	local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
    local now = GetTime()
    if spellId == 235268 then
      bossmod.phase = bossmod.phase + 1
    end
  end
  function bossmod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg, sender, _, _, target)
    local now = GetTime()
    if msg:find("123456") then
    end
  end
  function bossmod:Timer10ms()
    local now = GetTime()
  end
end
