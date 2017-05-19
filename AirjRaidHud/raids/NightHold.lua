local H = LibStub("AceAddon-3.0"):GetAddon("AirjRaidHud")
local R = H:NewModule("NightHold","AceEvent-3.0", "AceTimer-3.0")

function R:OnInitialize()
end

function R:OnEnable()
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function R:OnDisable()
end
do
  local starSigns = {}
  local starSignsLayer = 10
  local reson = "StarSign"
  local colors = {
    [216345] = {0,1,0,0.3},
    [205429] = {1,1,0,0.3},
    [205445] = {1,0,0,0.3},
    [774] = {1,0,0,0.3},
  }

  function R:NewStarSign(spellId,guid)
    local expire = GetTime() + 15
    H:NewBuffPoint({spellId,guid,colors[spellId],5},expire,starSignsLayer)
    local _,class = GetPlayerInfoByGUID(guid)
    H:ShowPlayerByGUID(reson,guid,class,expire)
    local playerGuid = UnitGUID("player")
    if guid==playerGuid then
      H:ShowLayer(reson,starSignsLayer,expire)
      H:ShowLayer(reson,15,expire)
      H:SetRange(30)
      H:SetBar(expire)
      self:StartDrawLineForMe(spellId)
    end
    starSigns[spellId] = starSigns[spellId] or {}
    starSigns[spellId][guid] = GetTime()
  end

  function R:RemoveStarSign(spellId,guid)
    H:RemoveBuffPoint({spellId,guid})
    H:HidePlayerByGUID(reson,guid)
    local playerGuid = UnitGUID("player")
    if guid==playerGuid then
      H:HideLayer(reson,starSignsLayer)
      H:HideLayer(reson,15)
      H:SetBar()
      self:StopDrawLineForMe(spellId)
    end
    if starSigns[spellId] then
      starSigns[spellId][guid] = nil
    end
  end

    -- list = {{{guid1,guid2},{guid3,guid4}},...}
  local function listHasKey(list,key1,key2)
    for _,e in ipairs(list) do
      for _,p in ipairs(e) do
        local k = p[1]..":"..p[2]
        if key1 == k or key2 == k then
          return true
        end
      end
    end
  end

  local function pickTwo (guids,keys,list)
    for guid1,v in pairs(guids) do
      for guid2,v in pairs(guids) do
        if guid1 ~= guid2 then
          local key1 = guid1..":"..guid2
          local key2 = guid2..":"..guid1
          if not keys[key1] and not keys[key2] then
            keys[key1] = true
            keys[key2] = true
            if not listHasKey(list,key1,key2) then
              return guid1,guid2
            end
          end
        end
      end
    end
  end


  local function getList(guids)
    local keys = {}
    local list = {}
    while true do
      local guid1,guid2 = pickTwo(guids,keys,list)
      if not guid1 then break end
      local restguids = H:DeepCopy(guids)
      restguids[guid1] = nil
      restguids[guid2] = nil
      local count = 0
      for guid, _ in pairs(restguids) do
        count = count + 1
      end
      if count<2 then
        tinsert(list,{{guid1,guid2}})
      else
        local sublist = getList(restguids)
        for i,v in ipairs(sublist) do
          tinsert(v,{guid1,guid2})
          tinsert(list,v)
        end
      end
    end
    return list
  end

  local function getMinRangeList (list)
    local maxPoint
    local maxPointE
    for _,e in ipairs(list) do
      local point = 0
      for _,p in ipairs(e) do
        local d = H:GetDistance(p[1],p[2])
        if d then
          point = point + 1/d
        end
      end
      if not maxPoint or point>maxPoint then
        maxPoint = point
        maxPointE = e
      end
    end
    return maxPointE
  end

  function H:Test(n)
    local test = {}
    for i = 1,n do
      test[i] = true
    end
    return getList(test)
  end

  local timer
  local line

  function R:StartDrawLineForMe(spellId)
    timer = self:ScheduleRepeatingTimer(self.DrawLineForMe,0.1,self,spellId)
  end

  function R:StopDrawLineForMe(spellId)
    self:CancelTimer(timer)
    if line and line.expire then
      line.remove = true
    end
  end
  function R:DrawLineForMe(spellId)
    if starSigns[spellId] then
      local count = 0
      local guids = {}
      for guid, time in pairs(starSigns[spellId]) do
        if time + 15 > GetTime() then
          guids[guid] = true
          count = count + 1
        end
      end

      local targetGuid
      local playerGuid = UnitGUID("player")
      if count <=6 then
        local list = getList(guids)
        local e = getMinRangeList(list)
        if e then
          for _,p in ipairs(e) do
            if playerGuid == p[1] then
              targetGuid = p[2]
              break
            elseif playerGuid == p[2] then
              targetGuid = p[1]
              break
            end
          end
        end
      end
      if line and line.expire then
        line.to.guid = targetGuid or playerGuid
      else
        local color = colors[spellId]
        line = H:New("Line",{color=color,expire=GetTime()+15,from={unit="player"},to={guid=targetGuid},layer=starSignsLayer})
      end
    end
  end
end

function R:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
  -- star augur
  local playerGuid = UnitGUID("player")
  do

    if spellId == 206921 then
      local guid = UnitGUID("boss1target")
      if guid then
        H:NewBuffPoint({spellId,guid,{0,0.5,1,0.5},8},GetTime()+3,10)
      end
    end

    if spellId == 205408 then
      local reason = "PreStarSign"
      if event == "SPELL_CAST_START" then
        local expire = GetTime() + 4
        H:ShowAllPlayers(reason,expire)
        H:ShowLayer(reason,15,expire)
        H:SetRange(15)
        H:SetBar(expire)
      end
      if event == "SPELL_CAST_SUCCESS" then

      end
    end
    local ids = {
      [216345] = true,
      [205429] = true,
      [205445] = true,
    }

    if ids[spellId] then
      if event == "SPELL_AURA_APPLIED" then
        R:NewStarSign(spellId,destGUID)
      end
      if event == "SPELL_AURA_REMOVED" then
        R:RemoveStarSign(spellId,destGUID)
      end
    end
  end
end
