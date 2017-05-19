
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
  local center2 = {}
  local a = math.pi/2.5
  for i=1,5 do
    local b = math.pi/2 - a*(i-1)
    center[i] = {cx+22*math.cos(b),cy+22*math.sin(b)}
    center2[i] = {cx+33*math.cos(b),cy+33*math.sin(b)}
  end
  local markercolor = {
    {0,1,0,0.8},
    {1,0,0.8,0.8},
    {1,0.5,0,0.8},
    {1,1,0,0.8},
    {0,0.7,1,0.8},
  }
  local sounds = {
    "frontcenter",
    "frontright",
    "backright",
    "backleft",
    "frontleft",
    -- "Interface\\AddOns\\DBM-VPYike\\frontcenter.ogg",
    -- "Interface\\AddOns\\DBM-VPYike\\frontright.ogg",
    -- "Interface\\AddOns\\DBM-VPYike\\backright.ogg",
    -- "Interface\\AddOns\\DBM-VPYike\\backleft.ogg",
    -- "Interface\\AddOns\\DBM-VPYike\\frontleft.ogg",
  }
  function H:OdynP3(index)
    local guid = UnitGUID("player")
    local position = self.position[guid]
    if position then
      local x,y = unpack(position)
      if x then
        -- print(x,y)
        local tx,ty
        if self:Distance(x,y,cx,cy)<r then
          tx,ty = unpack(center[index])
        elseif x<cx then
          tx,ty = unpack(left[index])
        else
          tx,ty = unpack(right[index])
        end
        local color = markercolor[index]
        local expire=GetTime()+10
        local a = self:New("Line",{color=color,expire=expire,from={unit="player"},to={x=tx,y=ty}})
        self:New("Point",{color=color,expire=expire,position={x=tx,y=ty}})
        self:SetBar(expire)
        local function play()
          local px,py = unpack(self.playerPosition)
          if a and a.type and self:Distance(px,py,tx,ty)>10 and GetTime()<expire then
            -- PlaySoundFile("Interface\\AddOns\\AirjRaidHud\\sounds\\".."odyn"..index..".mp3", "Master")
            self:PlayYike(sounds[index])
            self:ScheduleTimer(play,3)
          end
        end
        play()
      end
    end
  end
  local lp1,lp2
  function H:OdynP1(index)
    local tx,ty = unpack(center2[index])
    local color = markercolor[index]
    local expire=GetTime()+20
    lp1 = self:New("Line",{color=color,expire=expire,from={unit="player"},to={x=tx,y=ty}})
    lp2 = self:New("Point",{color=color,expire=expire,position={x=tx,y=ty}})
    local function play()
      if lp1 and lp1.type and GetTime()<expire  then
        -- PlaySoundFile("Interface\\AddOns\\AirjRaidHud\\sounds\\".."odyn"..index..".mp3", "Master")
        self:PlayYike(sounds[index])
        self:ScheduleTimer(play,3)
      end
    end
    play()
    for k,v in pairs(self.dbmtimers) do
      if v.spellId == 227629 then
        if v.expire + 5 > GetTime() and v.expire + 5 < GetTime()+30 then
          self:SetBar(v.expire + 5,v.expire + 5 - 20)
          break
        end
      end
    end
  end

  function H:OdynP1Clear()
    if lp1 and type(lp1) == "table" and lp1.type then
      lp1.remove = true
      lp1 = nil
    end
    if lp2 and type(lp2) == "table" and lp2.type then
      lp2.remove = true
      lp2 = nil
    end
  end
end

do --Guarm
  local constids = {
    228758,
    228768,
    228769,
  }
  local constNames = {}
  for i,v in ipairs(constids) do
    constNames[i] = GetSpellInfo(v)
  end
  local colors = {
    {1,0.5,0,1},
    {0,1,0.5,1},
    {0.8,0,1,1},
  }
  local messages = {
    "{rt2}",
    "{rt6}",
    "{rt3}",
  }
  local sounds = {
    "mm2",
    "mm6",
    "mm3",
  }
  function H:GuarmFoam2()
    for i = 1,3 do
      if UnitDebuff("player",constNames[i]) then
        if self.buffer.foamtimer3 then
          self:CancelTimer(self.buffer.foamtimer3)
        end
        self.buffer.foamtimer3 = self:ScheduleRepeatingTimer(function()
          SendChatMessage(messages[i],"SAY")
        end,0.75)
        if self.buffer.foamtimer4 then
          self:CancelTimer(self.buffer.foamtimer4)
        end
        self.buffer.foamtimer4 = self:ScheduleTimer(function()
          self:CancelTimer(self.buffer.foamtimer3)
        end,9)
        return
      end
    end
    -- body...
  end
  function H:GuarmFoam(index)
    if UnitDebuff("player",constNames[index]) then return end
    self.buffer.foam = self.buffer.foam or {}
    -- SendChatMessage(messages[index],"SAY")
    self.buffer.foamtimer = self:ScheduleRepeatingTimer(function()
      -- SendChatMessage(messages[index],"SAY")
    end,0.75)
    self.buffer.foamtimer2 = self:ScheduleTimer(function()
      self:CancelTimer(self.buffer.foamtimer)
    end,9)
    local expire = GetTime() + 9
    self:SetBar(expire,expire-9)
    local function play()
      if self.buffer.foamtimer and  GetTime()<expire then
        self:PlayYike(sounds[index])
        self:ScheduleTimer(play,1.5)
      end
    end
    play()

    for i=1,20 do
      local u = "raid"..i
      if not UnitIsUnit("player",u) then
        local color
        if UnitDebuff(u,constNames[index]) then
          color = colors[index]
        else
          color = {0.8,0.8,0.8,0.6}
        end
        self.buffer.foam[i] = self:New("Point",{color=color,radius=2,expire=expire,position={unit=u}})
      end
    end
  end

  function H:GuarmFoamClear()
    self.buffer.foam = self.buffer.foam or {}
    self:CancelTimer(self.buffer.foamtimer)
    self:CancelTimer(self.buffer.foamtimer2)
    self.buffer.foamtimer = nil
    for k,v in pairs(self.buffer.foam) do
      v.remove = true
      self.buffer.foam[k] = nil
    end
  end
end

function H:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
  if self.db.disable then
    return
  end
  local playerGuid = UnitGUID("player")
  do
    if spellId==211802 and event == "SPELL_AURA_APPLIED" then  -- blade
      if self.buffer.lastblade then
        self:SetRange(30)
        local a = self:New("Line",{length = 200,width = 3, color={1,0.3,0,0.5},expire=GetTime()+6,from={guid=self.buffer.lastblade},to={guid=destGUID}})
        self:ScheduleTimer(function() self:Freeze(a.from) self:Freeze(a.to) end,5)
        self:SetBar(GetTime()+6)
        self.buffer.lastblade = nil
      else
        self.buffer.lastblade = destGUID
        self:ScheduleTimer(function() self.buffer.lastblade = nil end,4)
      end
    end
    if (spellId==209034 or spellId == 210451) and event == "SPELL_AURA_APPLIED" then  -- Terror
      if self.buffer.lastterror then
        if self.buffer.lastterror == playerGuid or destGUID == playerGuid then
          self:SetRange(20)
          self.buffer.lastterrorAct = self:New("Line",{width = 1, color={1,0.3,0,0.5},expire=GetTime()+20,from={guid=self.buffer.lastterror},to={guid=destGUID}})
          local targetGuid
          if self.buffer.lastterror == playerGuid then
            targetGuid = destGUID
          else
            targetGuid = self.buffer.lastterror
          end
          self.buffer.lastterrorAct2 = self:New("Point",{radius = 2, color={1,0.3,0,0.5},expire=GetTime()+20,position={guid=targetGuid}})
        end
        self.buffer.lastterror = nil
      else
        self.buffer.lastterror = destGUID
        self:ScheduleTimer(function() self.buffer.lastterror = nil end,4)
      end
    end
    if (spellId==209034 or spellId == 210451) and event == "SPELL_AURA_REMOVED" and destGUID == playerGuid then  -- Terror
      if self.buffer.lastterrorAct then
        self.buffer.lastterrorAct.remove = true
        self.buffer.lastterrorAct = nil
      end
      if self.buffer.lastterrorAct2 then
        self.buffer.lastterrorAct2.remove = true
        self.buffer.lastterrorAct2 = nil
      end
    end
    if spellId==206651 and event == "SPELL_AURA_APPLIED_DOSE" then  -- tank debuff
      local _,amount = ...
      if amount==3 then
        self:SetRange(40)
        self.buffer.soul = self.buffer.soul or {}
        self.buffer.soul[destGUID.."1"] = self:New("Point",{radius = 25, color={0,0.5,1,0.1},expire=GetTime()+60,position={guid=destGUID}})
      	local	_, class = GetPlayerInfoByGUID(destGUID)
        if class then
          local c = RAID_CLASS_COLORS[class]
          self.buffer.soul[destGUID.."2"] = self:New("Point",{radius = 2, color={c.r,c.g,c.b,1},expire=GetTime()+60,position={guid=destGUID}})
        end
      end
    end
    if spellId==206651 and event == "SPELL_AURA_REMOVED" then  -- tank debuff
      if self.buffer.soul[destGUID.."1"] then
        self.buffer.soul[destGUID.."1"].remove = true
        self.buffer.soul[destGUID.."1"] = nil
      end
      if self.buffer.soul[destGUID.."2"] then
        self.buffer.soul[destGUID.."2"].remove = true
        self.buffer.soul[destGUID.."2"] = nil
      end
    end

  end

  --Odyn
  do
    local odynp3 = {
      [231346] = 1,
      [231311] = 2,
      [231342] = 3,
      [231344] = 4,
      [231345] = 5,
    }
    local odynp1 = {
      [229583] = 1,
      [229579] = 2,
      [229580] = 3,
      [229581] = 4,
      [229582] = 5,
    }
    local time = GetTime()
    if destGUID == playerGuid and odynp3[spellId] and event == "SPELL_AURA_APPLIED" then  -- p3
      self:SetRange(30)
      self:OdynP3(odynp3[spellId])
    end

    if odynp1[spellId] and event == "SPELL_AURA_APPLIED" then -- p1
      if destGUID == playerGuid then
        if not self.buffer.odynp1get or time > self.buffer.odynp1get +30 then
        else
        end
        self:SetRange(30)
        self:OdynP1Clear()
        self:OdynP1(odynp1[spellId])
        self.buffer.odynp1get = time
      end
      self.buffer.odynp1buffs = self.buffer.odynp1buffs or {}
      self.buffer.odynp1buffs[spellId] = time
      local count = 0
      local index
      for i,v in pairs(odynp1) do
        local t = self.buffer.odynp1buffs[i]
        if t and t > time-30 then
          count = count + 1
        else
          index = v
        end
      end
      if count == 4 and index then
        if not self.buffer.odynp1get or time > self.buffer.odynp1get +30 then
          self:SetRange(30)
          self:OdynP1Clear()
          self:OdynP1(index)
          self.buffer.odynp1get = time
        end
      end
    end

    if spellId == 229584 and event == "SPELL_AURA_APPLIED" then -- p1
      if destGUID == playerGuid then
        self:PlayYike("safenow")
        self:OdynP1Clear()
      end
    end
    if destGUID == playerGuid and spellId == 227807 and event == "SPELL_AURA_REMOVED" then
      self:PlayYike("runin")
    end

    if spellId == 228162 and event == "SPELL_CAST_START" then  -- sheild of holy
      self:SetRange(20)
      local unit
      for i = 1,4 do
        if sourceGUID== UnitGUID("boss"..i) then
          unit = "boss"..i
          break
        end
      end
      -- if not unit then
      --   if sourceGUID== playerGuid then
      --     unit = "player" --test
      --   end
      -- end
      if unit then
        self:New("Line",{ray=true,length = 200,width = 5, color={1,1,0,0.5},expire=GetTime()+4,from={unit=unit},to={unit=unit.."target"}})
        self:SetBar(GetTime()+4)
        for i=1,20 do
          local u = "raid"..i
          if not UnitIsUnit("player",u) then
            local _,class = UnitClass(u)
            if class then
              local c = RAID_CLASS_COLORS[class]
              self:New("Point",{color={c.r,c.g,c.b,1},radius=2,expire=GetTime()+4,position={unit=u}})
            end
          end
        end
      end
    end
    if spellId == 228012 and event == "SPELL_CAST_START" then  --
      self:SetRange(20)
      self:New("Point",{color={0,0.5,0,0.5},radius=6,expire=GetTime()+4.5,position={unit="player"}})
      self:SetBar(GetTime()+4.5)
      for i=1,20 do
        local u = "raid"..i
        if not UnitIsUnit("player",u) then
          local _,class = UnitClass(u)
          if class then
            local c = RAID_CLASS_COLORS[class]
            self:New("Point",{color={c.r,c.g,c.b,1},radius=2,expire=GetTime()+4.5,position={unit=u}})
          end
        end
      end
    end
  end
  do -- Guarm
    local debuffs = {
      [228744] = 1,
      [228810] = 2,
      [228818] = 3,
      [228794] = 1,
      [228811] = 2,
      [228819] = 3,
    }

    if debuffs[spellId] and event == "SPELL_AURA_APPLIED" then -- foam
      H:GuarmFoam2()
      if destGUID == playerGuid then
        self:SetRange(30)
        self:GuarmFoamClear()
        self:GuarmFoam(debuffs[spellId])
      end
    end

    if destGUID == playerGuid and debuffs[spellId] and event == "SPELL_AURA_REMOVED" then -- foam
      self:GuarmFoamClear()
    end
  end
  --Nighthold
  do
    -- if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event =="SPELL_AURA_APPLIED_DOSE" then
    --   -- if spellId == 213166 then
    --   if spellId == 774 then
    --     self:BuffPoint(spellId,destGUID,{1,0,0,0.5})
    --   end
    -- end
    -- if event == "SPELL_AURA_REMOVED" then
    --   if spellId == 774 then
    --     self:BuffPoint(spellId,destGUID)
    --   end
    -- end
  end
  if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event =="SPELL_AURA_APPLIED_DOSE" then
    if spellId == 213166 then
      self:SearingBrand(destGUID)
    end
  end
end
