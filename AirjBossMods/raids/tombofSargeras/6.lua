local addonsname = "AirjBossMods"
local modulename = "TombofSargeras-6"
local Core = LibStub("AceAddon-3.0"):GetAddon(addonsname)
local R = Core:NewModule(modulename,"AceEvent-3.0")

-- maydiebuff  | mythic buff | Silence Circle| need swap buff | week buff
function R:OnEnable()
  local bossmod = Core:NewBoss({encounterID = 2054})
  bossmod.furtureDamage = true

  local sheildCnt = 0
  local info = {}

  function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)

    local now = GetTime()

    Core:RegisterAuraBeam(238018,{width=4,length = 30,color={0,1,0,0.2}})
    Core:RegisterAuraCooldown(238018,{color={0,1,0,0.2},radius=5})

    Core:RegisterAuraCooldown(236459,{color={1,1,0,0.2},radius=5})

    Core:RegisterAuraCooldown(235924,{color={0,1,1,0.3},radius=5})
    Core:RegisterAuraCooldown(238442,{color={0,0.5,1,0.2},radius=5})

    Core:RegisterAuraCooldown(236513,{color={1,0,0,0.2},radius=5})

    Core:RegisterAuraCooldown(236131,{color={0,1,1,0.2},radius=3})
    Core:RegisterAuraCooldown(236138,{color={0,1,1,0.2},radius=3})
    --
    -- aoeCnt = 0
    -- updateTimeLines(48.3)
    -- Core:SetFutureDamage({key="aoe1"..":"..(aoeCnt+1),start=now+48.3,duration=0.1,damage=Core:GetDifficultyDamage(self.difficulty,300e4)})
    -- Core:SetFutureDamage({key="aoe2"..":"..(aoeCnt+1),start=now+48.3+6,duration=0.1,damage=Core:GetDifficultyDamage(self.difficulty,300e4)})
    --
    -- -- Core:RegisterAuraCooldown(236519,{color={0,1,1,0.2},radius=3}) -- moon burn
    -- -- Core:RegisterAuraCooldown(236550,{color={0,1,1,0.2},radius=3}) -- tank swap debuff
    -- Core:RegisterAuraCooldown(236712,{color={0,1,0,0.2},radius=8})  --p3 out debuff
    -- Core:RegisterAuraCooldown(237561,{color={1,0,0,0.2},radius=5})  -- red arrow
    -- Core:RegisterAuraCooldown(236305,{color={0.5,1,0,0.2},radius=8})  -- purple line
    --
    -- Core:RegisterAuraBeam(237561,{width=2,color={1,0,0,0.2}})  -- red arrow
    -- Core:RegisterAuraBeam(236305,{width=4,color={0.5,0,1,0.1}}) -- purple line
    -- vulnHistory = {}
    -- Core:SetInfo(vulnHistory)
    Core:SetTimeline({text = "内场AOE", expires = now+60, color = {0,1,1}})

    sheildCnt = 0
    info = {}
    Core:SetInfo(info)
  end
  local ssavrcds = {}
  local linkavrs = {}
  local linkguid, linktime
  function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
    local now = GetTime()
    if (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_APPLIED_DOSE") then
      if spellId == 236515 or spellId == 235969 then
        local _,count = ...
        if spellId == 235969 then
          count = 0
        else
          count = count or 1
        end
        local id = ssavrcds[destGUID]
        if id then
          local m = AirjAVR and AirjAVR.createdMeshs[id]
          if m then
            m.visible=false
            m:Remove()
          end
        end
        id= Core:CreateCooldown({
  				guid = destGUID,
  				spellId = spellId,
  				radius = 8,
  				duration = 5,
  				expires = now+(5-count),
  				color = {0,1,0},
  				alpha = 0.2,
  				suffix = " - "..count,
  			})
        ssavrcds[destGUID]  = id
        if Core:GetPlayerGUID() == destGUID then
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 5, expires = now+(5-count), size = 2, name = "破盾", count = count, reverse = false})
          Core:SetSay(string.rep ("{rt2}", count+1))
          Core:SetVoiceT({str="po4              dun4 "..count})
          Core:SetTextT({text1 = "|cff00ff00破盾:|cff00ffff"..count.."|r",text2 = "|cff00ff00破盾结束|r", expires = now+1.2})
          if count == 0 then
            Core:SetScreen(0,1,0)
          end
          Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+(5-count)})
        end
      end
    end
    if event == "SPELL_AURA_REMOVED" then
      if spellId == 236515 or spellId == 235969 then
        local id = ssavrcds[destGUID]
        if id then
          local m = AirjAVR and AirjAVR.createdMeshs[id]
          if m then
            m.visible=false
            m:Remove()
          end
        end
        if Core:GetPlayerGUID() == destGUID then
          Core:SetVoiceT({file="safenow"})
          Core:ClearIcon(1)
        end
      end
    end
    if event == "SPELL_AURA_APPLIED" then
      if spellId == 236459 then
        if linktime and now - linktime < 5 then
  				local id = Core:CreateBeam({
            fromGUID = linkguid,
  					toGUID = destGUID,
  					width = 2,
  					color = {1,1,0},
  					alpha = 0.2,
            removes = now + 30,
  				})
          linkavrs[destGUID] = id
          linkavrs[linkguid] = id
        end
        linkguid = destGUID
        linktime = now
        if Core:GetPlayerGUID() == destGUID then
          Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 0, removes = now + 30, size = 2, name = "连线", count = count, reverse = true})

          Core:SetVoiceT({str="lian2      xian4"})
          Core:SetScreen(1,1,0)
          Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+5})
          Core:SetTextT({text1 = "|cff00ff00连线|r",text2 = "", expires = now+1})
          local name = GetSpellInfo(spellId)
          local count = 0
          local timer
          timer = Core:ScheduleRepeatingTimer(function()
            if not UnitDebuff("player",name) and not UnitBuff("player",name) then
              Core:CancelTimer(timer)
              return
            end
            count = count + 1
            Core:SetSay(string.rep ("{rt1}", count))
          end,1)
        end
      end
    end
    if event == "SPELL_AURA_REMOVED" then
      if spellId == 236459 then
        local id = linkavrs[destGUID]
        if id then
          local m = AirjAVR and AirjAVR.createdMeshs[id]
          if m then
            m.visible=false
            m:Remove()
          end
        end

        if Core:GetPlayerGUID() == destGUID then
          Core:SetVoiceT({file="safenow"})
          Core:ClearIcon(1)
        end
      end
    end

    if event == "SPELL_AURA_APPLIED" then
      if spellId == 235924 and Core:GetPlayerGUID() == destGUID then
        Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 6, removes = now + 6, size = 2, name = "长矛"})
        Core:SetVoiceT({file="bombrun"})
        Core:SetVoiceT({file="holdit",time = now + 3})
        Core:SetScreen(0,1,1)
        Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+6})
        Core:SetTextT({text1 = "|cffff0000长矛:|cff00ffff"..count.."|r",text2 = "|cff00ff00c长矛结束|r", expires = now+6})
        for i = 0,3 do
          Core:SetSay(""..i,now + 6 - i)
        end
      end
    end
    if event == "SPELL_AURA_APPLIED" then
      if spellId == 238018 and Core:GetPlayerGUID() == destGUID then
        Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 4, removes = now + 4, size = 2, name = "激光"})
        Core:SetVoiceT({file="lazerun"})
        Core:SetScreen(0,1,0)
        Core:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+4})
        Core:SetTextT({text1 = "|cffff0000激光:|cff00ffff"..count.."|r",text2 = "|cff00ff00c激光结束|r", expires = now+4})
        for i = 0,3 do
          Core:SetSay(""..i,now + 4 - i)
        end
      end
    end

    if event =="SPELL_AURA_APPLIED" or event =="SPELL_PERIODIC_DAMAGE" or event =="SPELL_PERIODIC_MISSED" then
      if spellId == 236011 or spellId == 238018 or spellId == 235907 then
        if Core:GetPlayerGUID() == destGUID then
          Core:GroundEffectDamage(spellId)
        end
      end
    end
    if event =="SPELL_AURA_APPLIED" then
      if spellId == 236131 or spellId == 236138 then
        if Core:GetPlayerGUID() == destGUID then
          Core:SetIconT({index = 3, texture = GetSpellTexture(spellId), duration = 60, removes = now + 60, size = 1, name = ""})
        end
      end
    end
    if event =="SPELL_AURA_REMOVED" then
      if spellId == 236131 or spellId == 236138 then
        if Core:GetPlayerGUID() == destGUID then
          Core:ClearIcon(3)
        end
      end
    end
    if event == "SPELL_CAST_START" then
      if spellId == 238570 then
        -- out aoe
        Core:SetTimeline({text = "内场AOE", expires = now+60, color = {0,1,1}})
      end
    end
    if event == "SPELL_CAST_SUCCESS" then
      if spellId == 236072 then
        -- in aoe
        Core:SetTimeline({text = "外场AOE", expires = now+60, color = {1,0,0}})
      end
    end

    if event == "SPELL_AURA_APPLIED" then
      if spellId == 236513 then
        local objectType,serverId,instanceId,zone,cid,spawn = AirjHack:GetGUIDInfo(destGUID)
        if cid == 119939 then
          sheildCnt = sheildCnt + 1
          info[1] = {left="骨盾",right=sheildCnt}
          Core:NotifyInfoChanged()
        end
      end
    end
    if event == "SPELL_AURA_REMOVED" then
      if spellId == 236513 then
        local objectType,serverId,instanceId,zone,cid,spawn = AirjHack:GetGUIDInfo(destGUID)
        if cid == 119939 then
          sheildCnt = sheildCnt - 1
          Core:SetVoiceT({file="bigmob"})
          info[1] = {left="骨盾",right=sheildCnt}
          Core:NotifyInfoChanged()
        end
      end
    end

  end
  local lastPhaseChangeTime
  function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent, uId, spellName, _, spellGUID)
  	local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
    local now = GetTime()
    if spellId == 235268 then
      if not lastPhaseChangeTime or now - lastPhaseChangeTime > 10 then
        lastPhaseChangeTime = now
        bossmod.phase = bossmod.phase + 1

        if bossmod.phase == 3 then
          Core:SetFutureDamage({key="aoe1"..":"..(aoeCnt+1),duration=0.1,damage=0})
        elseif bossmod.phase == 2  then
          Core:SetFutureDamage({key="aoe2"..":"..(aoeCnt+1),duration=0.1,damage=0})
        end
      end
    end
  end
  function bossmod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg, sender, _, _, target)
    local now = GetTime()
    if msg:find("123456") then
    end
  end
  function bossmod:Timer10ms()
    local now = GetTime()
    local name = GetSpellInfo(235732)
    local ins = {}
    local outs = {}
    local inc,outc=0,0
    for i = 1,20 do
      local unit = "raid"..i
      if UnitGUID(unit) and not UnitIsDeadOrGhost(unit) then
        if UnitDebuff(unit,name) then
          ins[unit] = true
          inc = inc + 1
        else
          outs[unit] = true
          outc = outc + 1
        end
      end
    end
    info[1] = info[1] or {left = "骨盾", right=0}
    info[2] = {left="外场",right=outc}
    info[3] = {left="内场",right=inc}
    Core:NotifyInfoChanged()
  end
end
