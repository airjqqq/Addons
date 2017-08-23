local addonsname = "AirjBossMods"
local modulename = "TombofSargeras-5"
local Core = LibStub("AceAddon-3.0"):GetAddon(addonsname)
local R = Core:NewModule(modulename,"AceEvent-3.0")

-- maydiebuff  | mythic buff | Silence Circle| need swap buff | week buff
function R:OnEnable()

  do --5 -- shot all  |  wind/shark  |   shot/tank swip  |  ink debuff  |  2min debuff
    local bossmod = Core:NewBoss({encounterID = 2037})
    bossmod.furtureDamage = true
    local shotCnt = 0
    local windCnt = 0
    local chargeCnt = 0
    local sharkCnt = 0
    local lastShotTime
    local shotGuids = {}
    local shotNumber = 0
    function bossmod:ENCOUNTER_START(event,encounterID, name, difficulty, size)
      local now = GetTime()
      Core:RegisterAuraBeam(230139,{width = 1, alpha = 0.1, color = {0,1,0,0.1}})
      Core:RegisterAuraCooldown(230139,{radius = 5, color = {0,1,0,0.2}})
      Core:RegisterAuraCooldown(232913,{radius = 3, color = {0.5,0,1,0.1}})
      shotCnt = 0
      windCnt = 0
      chargeCnt = 0
      sharkCnt = 0
      lastShotTime = nil
      shotNumber = 0
      wipe(shotGuids)
      if bossmod.difficulty ~= 17 then
        Core:SetFutureDamage({key="230139"..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,180e4),start = now + 5 + 25, duration = 0.1})
        Core:SetFutureDamage({key="232754"..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,232e4),start = now + 5 + 25, duration = 6})
        Core:SetTimeline({expires = now+26,text = "多头蛇射击",color = {0,1,0},phase=bossMod.phase})
      end
      if bossmod.difficulty == 16 then
        Core:SetTimeline({expires = now+90+14,text = "丢鱼",color = {1,0,0},phase=bossMod.phase})
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
            Core:SetIconT({index = 0, texture = GetSpellTexture(spellId), duration = 6, name = GetSpellInfo(spellId), size = 1, scale = false, reverse = false, count = shotCnt})
            Core:SetFutureDamage({key=spellId..":"..shotCnt,damage = Core:GetDifficultyDamage(bossmod.difficulty,180e4),start = now + 5, duration = 0.1})
            Core:SetFutureDamage({key="232754"..":"..shotCnt,damage = Core:GetDifficultyDamage(bossmod.difficulty,232e4),start = now + 5, duration = 6})
            local interval = bossmod.phase == 2 and 30 or bossmod.difficulty == 16 and 30 or 40
            Core:SetFutureDamage({key=spellId..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,180e4),start = now + 5 + interval, duration = 0.1})
            Core:SetFutureDamage({key="232754"..":"..(shotCnt+1),damage = Core:GetDifficultyDamage(bossmod.difficulty,232e4),start = now + 5 + interval, duration = 6})
            Core:SetTimeline({expires = now+6,text = "多头蛇射击中 - "..shotCnt,color = {0,1,1}})


            local rc = (shotCnt-1)%7+1
            local ri = Core:GetPlayerKeyFromBoardData("r")
            if ri == rc or Core:ShowAllMessage() or Core:GetPlayerRole() == "HEALER" then
              Core:SetVoiceT({file = "defensive"})
              Core:SetVoiceT({file = "count\\"..rc,time=now+0.7})
            end
            if ri == rc then
              Core:SetVoiceT({file = "uu",time=now+1.4})
            end

          end
          shotNumber = shotNumber + 1
          shotGuids[destGUID] = shotNumber
          if Core:GetPlayerGUID() == destGUID then
            Core:SetIconT({index = 1, texture = GetSpellTexture(spellId), duration = 6, name = GetSpellInfo(spellId), size = 2})
            Core:SetVoice("laserrun")
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
          Core:SetTimeline({expires = now+30,text = "墨汁",color = {0,1,0},phase=bossMod.phase})
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
    local rm = {1,3,4,6}
    local wm = {5,3,2,1}
    local function setupShot(shotGuids,shotNumber)
      if not shotGuids then
        shotGuids = {}
        shotNumber = 0
        for i = 1,4 do
          local guid = UnitGUID("raid"..(i+1))
          if guid then
            shotGuids[guid] = i
            shotNumber = shotNumber + 1
          end
        end
      end
      local iconIndexs = {}
      local angles = {}
      local getAngle
      local bx,by,bz
      if AirjHack and AirjHack:HasHacked() then
        bx,by,bz = AirjHack:Position(UnitGUID("boss1") or UnitGUID("player"))
        local offset = 1
        local baseT
        local function checkAngle(t)
          for i,a in pairs(angles) do
            local da = t-a
            da = da % (2*math.pi)
            if da > math.pi then
              da = 2*math.pi - da
            end
            if da < math.pi/4 then
              local oa = offset*math.pi/32*(offset%2==0 and -1 or 1)
              return (baseT + oa) % (2*math.pi)
            end
          end
        end
        getAngle = function(guid)
          local x,y = AirjHack:Position(guid)
          if not x or not bx then return end
          local t = math.atan2(y-by,x-bx)
          offset = 1
          baseT = t
          while true do
            local a = checkAngle(t)
            offset = offset + 1
            if not a then
              return t
            else
              t = a
            end
          end
        end
      end
      local shareIndex = {}
      local si = 0
      local debuffname = GetSpellInfo(239375)
      local debuffname2 = GetSpellInfo(230201)
      for i = 20,1,-1 do
        local unit = "raid"..i
        local guid = UnitGUID(unit)
        if guid then
          if not UnitDebuff(unit,debuffname) and not UnitDebuff(unit,debuffname2) then
            local ii = shotGuids[guid]
            if ii then
              iconIndexs[i] = rm[ii]
              SetRaidTarget(unit,rm[ii])
              -- if AirjHack and AirjHack:HasHacked() then
              --   local t = getAngle(guid)
              --   if t then
              --     angles[ii] = t
              --     local r = 10
              --     local x,y = bx + r*math.cos(t), by + r*math.sin(t)
              --     AirjMove:RaidPillar(wm[ii],x,y,bz)
              --   end
              -- end
            else
              shareIndex[i] = rm[si%shotNumber + 1]
              si = si + 1
            end
          end
        end
      end
      Core:SendComm({type="method",method="SayRaidIcon",args={iconIndexs,4,5}})
      Core:SendComm({type="method",method="SayRaidIcon",args={shareIndex,4,1}})
    end
    AIT = setupShot
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
      if UnitIsGroupLeader("player") then
        if lastShotTime and now - lastShotTime > 0.2 then
          lastShotTime = nil
          setupShot(shotGuids,shotNumber)
          shotNumber = 0
          wipe(shotGuids)
        end
      end
    end
  end
end
