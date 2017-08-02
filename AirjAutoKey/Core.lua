local Core = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKey", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
AirjAutoKey = Core
AAK = Core
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local db
local GUI
function Core:OnInitialize()
  self.filterTypes = {}
  self.passedSpell = {}
  self.templatePassed = {}
  db = self:InitializeDB()
  self.db = db
  self:InitializeParam()
  self:InitializeBasicFilters()
  GUI = self:GetModule("GUI")
end

function Core:OnEnable()
  -- do return end
  self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED",self.SelectSuitableRotation,self)

	self:SecureHook("UseAction", function(slot, target, button)
		-- self:SetParamTemporary("auto",false,0.4)
    -- print(slot, target, button)
    if slot == 169 and button == "RightButton" then return end
    self:OnChatCommmand("onceGCD",-0.4)

	end)

  self.paramTimer = self:ScheduleRepeatingTimer(function()
    local t = GetTime()
    for k,v in pairs(self.paramBack) do
      if t>v.expires then
        Core:SetParam(k,v.value)
      end
    end
  end,0.02)

  self.mainTimerProtectorTimer = self:ScheduleRepeatingTimer(function()
    if GetTime() - (self.lastScanTime or 0) > 0.5 then
      self:Print("RestartTimer")
      self.lastScanTime = GetTime()
      self:RestartTimer()
    end
  end,0.1)

  self:SelectSuitableRotation()

  self:RegisterChatCommand("aak", function(str)
    local key, value, nextposition = self:GetArgs(str, 2)
    local subString
    if nextposition~=1e9 then
      subString = strsub(str,nextposition)
    end
    self:OnChatCommmand(key,value,subString)
  end)

  self:RegisterChatCommand("aaki", function(str)
    local ids = {strsplit(" ",str)}
    local keys
    for i,v in ipairs(ids) do
      local id = tonumber(v)
      if id then
        keys = keys or {}
        keys[id] = true
      end
    end
    AirjHack:InteractUID(keys)
  end)
  self:RegisterChatCommand("aakiu", function(str)
    local guid = UnitGUID(str and str~="" and str or "target")
    if guid then
      AirjHack:Interact(guid)
    end
  end)
  self:RegisterChatCommand("aaks", function(str)
    local key,value,time = strsplit(" ",str)
    if value == "nil" then
      value = nil
    else
      value = tonumber(value) or value
    end
    time = tonumber(time)
    if time then
      self:SetParamTemporary(key,value,time)
    else
      self:SetParam(key,value)
    end
  end)
  self:RegisterChatCommand("aaksp", function(str)
    local key,value,time = strsplit(" ",str)
    if value == "nil" then
      value = nil
    else
      value = {AirjHack:Position(UnitGUID(value or "player"))}
    end
    time = tonumber(time)
    if time then
      self:SetParamTemporary(key,value,time)
    else
      self:SetParam(key,value)
    end
  end)
  self:RegisterChatCommand("aaklp", function(str)
    local key = strsplit(" ",str)
    local value = self:GetParam(key)
    if value then
      AirjMove:SetMoveTarget("point",{value[1],value[2],value[3]},true)

      AirjMove:SetMoveFacing ("facing",math.pi/2 + value[4])
    end
  end)
  self:RegisterChatCommand("aakr", function(str)
    local name,unit = strsplit(" ",str)
    self:ExecuteSpecificSequence(name,unit)
  end)
  -- starttest

end

function Core:OnDisable()

end
-- db
do
  local db
  local function db2core(key,default)
    default = default or {}
    if not db[key] then db[key] = default end
    Core[key] = db[key]
    return Core[key]
  end
  function Core:InitializeDB()
    AirjAutoKeyDBT = AirjAutoKeyDBT or {}
    db = AirjAutoKeyDBT

    self:ReloadRotations()
    db2core("param")
    db2core("paramBack")
    db2core("rotationDataBaseArray")

    return db
  end

  function Core:ReloadRotations()
    self.rotationDataBaseArray = {}
    for k,v in pairs(db.rotationDataBaseArray or {}) do
      tinsert(self.rotationDataBaseArray,v)
    end
  end

  function Core:NewRotation(rotation)
    rotation = rotation or {}
    tinsert(db.rotationDataBaseArray,rotation)
    Core:ReloadRotations()
    return rotation,#db.rotationDataBaseArray
  end

  function Core:SelectRotation(index)
    self.param.selectedRotationIndex = index
    self.param.editingRotationIndex = index
    self.rotationDB = self.rotationDataBaseArray[index]
    return self.rotationDB
  end

  function Core:SetEditingRotation(index)
    self.param.editingRotationIndex = index
  end

  function Core:GetEidtingRotation()
    local index = self.param.editingRotationIndex
    return index and self.rotationDataBaseArray[index]
  end

  function Core:SelectSuitableRotation(defaultIndex)
    local selfspec = GetSpecializationInfo(GetSpecialization())
    local _,class = UnitClass("player")
    local classIndex
  	for i,rotation in ipairs(self.rotationDataBaseArray) do
  		if rotation.autoSwap then
        if selfspec and rotation.spec and math.abs(selfspec - rotation.spec)<0.1 then
          self:SelectRotation(i)
          return i
        end
        if rotation.class == class then
          classIndex = i
        end
  		end
  	end
    if self.param.selectedRotationIndex then
      self:SelectRotation(self.param.selectedRotationIndex)
      return self.param.selectedRotationIndex
    end
    if classIndex then
      self:SelectRotation(classIndex)
      return classIndex
    end
    defaultIndex = defaultIndex or 1
    return self:SelectRotation(defaultIndex) and defaultIndex
  end
end


-- param
do
  local chatCommands = {
    inv = function(value)
      Core:SetParam("inv",tonumber(value) or 0.01)
    end,
    auto = function(value)
      if value == "off" then
        value = 0
      end
      if tonumber(value) == 0 then
        value = 0
        Core:Print("off")
      else
        value = 1
        Core:Print("on")
      end
      Core:SetParam("auto",value)
    end,
    world = function(time, value)
      if Core.worldTimer then
        Core:CancelTimer(Core.worldTimer)
        Core.worldTimer = nil
      end
      if not time or time == "" then
      else
        local channel, message  = strsplit(" ",value,2)
        local function findChannelByName(name)
          local channels = {GetChannelList()}
          for i = 1,#channels/2 do
            local j,n = channels[i*2-1],channels[i*2]
            if n == name then
              return j
            end
          end
        end
        local fcn = function()
          local tc = channel
          if not tonumber(tc) then
            local c = findChannelByName(tc)
            if not c then JoinPermanentChannel(tc,nil,3) end
            c = findChannelByName(channel)
            if c then tc = c end
          end
          print(tc,message)
          -- Core:Print(value,message,"CHANNEL",nil,tonumber(channel) or channel)
          -- SendChatMessage(message,"CHANNEL",nil,tonumber(channel) or channel)
          AirjHack:RunMacroText("/"..tc.." "..message)
        end
        Core.worldTimer = Core:ScheduleRepeatingTimer(fcn,tonumber(time) or 60)
        -- fcn()
      end
    end,
    once = function(value)
      value = tonumber(value) or 0.4
      local to
      if value > 0 then to = 1 else to = 0 value = -value end
      Core:SetParamTemporary("auto",to,value)
    end,
    onceGCD = function(value)
      value = tonumber(value) or 0.4
      local start,duration = GetSpellCooldown(61304)
      local remain
      if start == 0 then
        remain = 0
      else
        remain = duration - (GetTime() - start)
      end
      local to
      if value > 0 then to = 1 else to = 0 value = -value end
      value = value + remain
      if remain>duration*0.5 then
        value = 0.4
      end
      Core:SetParamTemporary("auto",to,value)
    end,
    target = function(value)
      Core:SetParam("target",tonumber(value) or 1)
    end,
    cd = function(value)
      Core:SetParam("cd",tonumber(value) or 60)
    end,
    burst = function(value)
      value = GetTime() + (tonumber(value) or 15)
      Core:SetParam("burst",value)
    end,
    gui = function(value)
      if AirjAutoKey_GUI_anchor then
        AirjAutoKey_GUI_anchor:ClearAllPoints()
        AirjAutoKey_GUI_anchor:SetPoint("CENTER",UIParent,"CENTER",0,-240)
      end
    end,
  }
  function Core:OnChatCommmand(key,value,nextString)
    if chatCommands[key] then
      chatCommands[key](value,nextString)
    else
      self:SetParam(key,value)
    end
  end
  function Core:InitializeParam()
    self:SetParamIf("auto",1)
    self:SetParamIf("target",1)
    self:SetParamIf("cd",60)
  end
  function Core:SetParamTemporary(key,value,time)
    local back = self.paramBack[key]
    if not back then
      self.paramBack[key] = {value = self.param[key],expires = GetTime() + time,start = GetTime()}
    else
      self.paramBack[key].expires = GetTime() + time
      self.paramBack[key].start = GetTime()
    end
    self.param[key] = value
  end
  function Core:SetParamIf(key,value,toCheck)
    if self.param[key] == toCheck then
      self.paramBack[key] = nil
      self.param[key] = value
    end
  end
  function Core:SetParam(key,value)
    self.paramBack[key] = nil
    self.param[key] = value
  end
  function Core:SetParamExpire(key,value)
    self.paramBack[key] = nil
    self.param[key] = GetTime() + value
  end
  function Core:GetParam(key)
    return self.param[key]
  end

  function Core:GetParamTemporaryRemain(key)
    local back = self.paramBack[key]
    if not back then
      return 0
    end
    return back.expires - GetTime()
  end
  function Core:GetParamTemporaryStarted(key)
    local back = self.paramBack[key]
    if not back then
      return 0
    end
    return GetTime() - back.start
  end
  function Core:GetParamNotExpired(key)
    local value = self.param[key]
    if not value then
      return false
    end
    return value > GetTime()
  end
end

-- main timer
do
  local presetMacros = {
    stopcasting = "/stopcasting",
    stopattack = "/stopattack",
    startattack = "/startattack",
    petattack = "/petattack _air_",
    petfollow = "/petfollow",
    loot = "/run AirjHack:Loot()",
    clicki = "/click AAKItemButton",
    extra = "/click ExtraActionButton1 RightButton",
  }
  local found = {}
  local groupDeep = 1
  local prepassed = {}

  function Core:GetAirUnit()
    return self.airUnit
  end

  function Core:SetAirUnit(unit)
    self.airUnit = unit
  end

  function Core:GetGroupUnit()
    return self.groupUnit
  end

  function Core:SetGroupUnit(unit)
    self.groupUnit = unit
  end

  function Core:FindTemplateFilter(name)
    local sequenceArray = self.rotationDB.spellArray
    for i,sequence in ipairs(sequenceArray) do
      if sequence.spell == "templates" or sequence.note == "templates" then
        for i,filter in pairs(sequence.filter) do
          if filter.note == name then
            return filter
          end
        end
      end
    end
  end

  function Core:ExecuteSpecificSequence(name,unit)
    -- unit = unit or self:GetAirUnit()

    local sequenceArray = self.rotationDB.spellArray
    for i,sequence in ipairs(sequenceArray) do
      if sequence.spell == "templates" or sequence.note == "templates" then
        for i,s in ipairs(sequence) do
          if s.spell == name or s.note == name then
            return self:ExecuteSequence(s,unit)
          end
        end
      end
    end
    do
      local sequenceArray = self.rotationDB.spellArray
      for i,sequence in ipairs(sequenceArray) do
        if sequence.spell == name or sequence.note == name then
          return self:ExecuteSequence(sequence,unit)
        end
      end
    end
  end
  function Core:ExecuteSpecificRotation(name,unit)
    -- print("ExecuteSpecificRotation",name)
    -- unit = unit or self:GetAirUnit()

    local sequenceArray = self.rotationDB.spellArray
    for i,rotation in ipairs(self.rotationDataBaseArray) do
      -- dump(rotation)
      if rotation.class == "_TEMPLATE" and rotation.note == name then
        -- print("ExecuteSpecificRotation",name)
        -- dump(rotation)
        return self:ExecuteGroupSequence(rotation.spellArray,unit)
      end
      if rotation.class == "_TEMPLATE" and rotation.note == "all" then
        for i,sequence in ipairs(rotation.spellArray) do
          if sequence.spell == name or sequence.note == name then
            return self:ExecuteSequence(sequence,unit)
          end
        end
      end
    end
  end

  function Core:ExecuteGroupSequence(sequenceArray,unit)
    groupDeep = groupDeep + 1
    local f
    for i,sequence in ipairs(sequenceArray) do
      self:SetAirUnit(unit)
      self:CheckAndExecuteSequence(sequence)
      if found[groupDeep] then
        f = true
        break
      end
    end
    found[groupDeep] = nil
    groupDeep = groupDeep - 1
    -- self:SetAirUnit()
    if f and not sequenceArray.continue then
      found[groupDeep] = true
      self:SetAirUnit()
      return true
    end
  end

  function Core:GetPresetMacro(key,unit)
    return presetMacros[key]
  end

  function Core:ToBasicMacroText(key,unit)
    if not key or key == "" then return end
    local macros = self.rotationDB.macroArray or {}
    if macros[key] then return macros[key] end
    if string.sub(key,1,1) == "/" then
      key = string.gsub(key,"\\n","\n")
      -- key = string.gsub(key,"|","\n")
      -- print(key)
      return key
    end
    local pre = self:GetPresetMacro(key,unit)
    if pre then return pre end
    local name, _, _, _, _, _, spellID  = Cache:Call("GetSpellInfo",key)
    if name then return "/cast "..name, name, spellID end
  end
  local pickUpTimer
  function Core:ExecuteMacro(macrotext,unit)
    if not macrotext then return end
    if unit then
  		macrotext = string.gsub(macrotext,"/cast ","/cast [@"..unit.."]")
  		macrotext = string.gsub(macrotext,"_air_",unit)
  		macrotext = string.gsub(macrotext,"_airguid_",UnitGUID(unit) or "nil")
    end

    -- self:Print(macrotext)
    local type, data, subType, subData = GetCursorInfo()
    AirjHack:RunMacroText(macrotext)
    -- if type == "spell" then
    --   if pickUpTimer then
    --     self:CancelTimer(pickUpTimer)
    --     pickUpTimer = nil
    --   end
    --   pickUpTimer = self:ScheduleTimer(function() PickupSpell(subData) end,0.2)
    -- end
  end

  function Core:ExecuteSequence(sequence,unit)
    self.passedSpell[tostring(sequence)] = unit or true
    local m,s,u = strsplit(" ",sequence.spell or "")
    if m == "runs" then
      local f = self:ExecuteSpecificSequence(s,u or unit)
      if f and not sequence.continue then
        found[groupDeep] = true
        self:SetAirUnit()
        return true
      end
    elseif m == "runr" then
      local f = self:ExecuteSpecificRotation(s,u or unit)
      if f and not sequence.continue then
        found[groupDeep] = true
        self:SetAirUnit()
        return true
      end
    elseif sequence.group then
      return self:ExecuteGroupSequence(sequence,unit)
    else
      local macroText, spellName, spellId = self:ToBasicMacroText(sequence.spell,unit)
      self:ExecuteMacro(macroText,unit)
      self:CachePassedInfo(spellId,unit)
      if not sequence.continue then
        found[groupDeep] = true
        self:SetAirUnit()
        return true
      end
    end
  end

  function Core:SplitAndCheckFilterArray(filter,priority,unitList)
    local checked = {}
    local tfilter = self:DeepCopy(filter)
    tfilter.oppo = nil
    tfilter.unit = nil
    tfilter.value = nil
    tfilter.greater = nil
    tfilter.note = nil
    local count = 0
    for _,unit in ipairs(unitList) do
      self:SetGroupUnit(unit)
      local key = Cache:UnitGUID(unit)
      if key and not checked[key] then
        checked[key] = true
        if self:CheckFilterArray(tfilter) then
          count = count + 1
        end
      end
    end
    self:SetGroupUnit(nil)
    local passed = count <= (filter.value or 0)
    if filter.greater then passed = not passed end
    -- self:Print(passed)
    if filter.note and filter.note ~= "" then
      if strfind(filter.note,"debug") then
        local str = string.format("%.3f",count)
        self:Print(AirjHack:GetDebugChatFrame(),filter.note,str)
      end
      local key,time = string.match(filter.note,"aaks (%w+) (%d+)")
      if key then
        -- print("aaks",key,count)
        self:SetParamTemporary(key,count,time or 1)
      end
    end
    return passed,priority
  end

  function Core:CheckGroupFilter(filter,priority)
    local unitList = self:GetUnitListByAirType(filter.unit)
    local passed
    if unitList then
      passed,priority = self:SplitAndCheckFilterArray(filter,priority,unitList)
    else
      passed,priority = self:CheckFilterArray(filter,priority)
    end
    return passed,priority
  end

  function Core:RegisterFilter(key,data)
    self.filterTypes[key] = data
    local index = #self.filterTypes
    self.filterTypesCount = self.filterTypesCount or 1
    data.order = self.filterTypesCount
    self.filterTypesCount = self.filterTypesCount + 1
  	if data.color and data.name then
  		data.name = "|cff" .. data.color .. data.name .."|r"
  	end
    if not data.keys then
      data.keys = {
        value = {},
        name = {},
        greater = {},
        unit= {},
      }
    end
    -- self:Print(AirjHack:GetDebugChatFrame(),"Register Filter:",data.name)
  end

  function Core:ParseValue(fv)
    if type(fv) == "string" then
      local suf = strsub(fv,-1,-1)
      if suf == "g" then
        local haste = GetHaste()
        local gcd = 1.5/(1+haste/100)
        gcd = max(gcd,0.75)
        fv = strsub(fv,1,-2)
        fv = tonumber(fv) or 1
        fv = fv * gcd
      elseif suf == "h" then
        local haste = GetHaste()
        haste = (1+haste/100)
        fv = strsub(fv,1,-2)
        fv = tonumber(fv) or 1
        fv = fv * haste
      elseif suf == "r" then
        local unit = self:GetAirUnit() or "target"
        local guid = UnitGUID(unit)
        local range
        if guid then
          range = select(5,Cache:GetPosition(guid))
        end
        if not range then range = 5 end
        fv = strsub(fv,1,-2)
        fv = tonumber(fv) or 1
        fv = fv * range
      elseif suf == "p" then
        fv = strsub(fv,1,-2)
        local k,v = strsplit("*",fv,2)
        if v then
          fv = (tonumber(k) or 1) * (self:GetParam(v) or 0)
        else
          fv = (self:GetParam(fv) or 0)
        end
      else
        fv = tonumber(fv) or 0
      end
    end
    return fv
  end

  function Core:ParseValueMulti(value)
    local fv
    if type(value) == "string" then
      local fvs = {strsplit(",",value)}
      local total = 0
      for k,v in pairs(fvs) do
        total = total + self:ParseValue(v)
      end
      fv = total
    else
      fv = value
    end
    return fv
  end

  function Core:MatchValue(value,filter)
    local fv = self:ParseValueMulti(filter.value)
    local passed = value <= (fv or 0)
    if filter.greater then
      passed = not passed
    end
    return passed
  end

  function Core:CheckTypeFilter(filter,priority)
    if not filter.type then
      return false,priorit
    end
    local unit = self:ParseUnit(filter.unit)
    if unit then
      filter = self:DeepCopy(filter)
      filter.unit = unit
    end
    local data = self.filterTypes[filter.type]
    if not data then error("no filter data found",2) end
    local fcn = data.fcn
    local value = fcn(self,filter)
    -- self:Print(unit,value)
    local passed
    if data.priority then
      priority = priority or 1
      if type(value) ~= "number" then
        value = 1
      end
      if filter.value then
        value = value + filter.value
      end
      if filter.oppo then
        priority = priority / value
      else
        priority = priority * value
      end
      passed = true
  	  if filter.oppo then passed = not passed end
    else
      if type(value) == "number" then
        if filter.note and filter.note ~= "" then
          if strfind(filter.note,"debug") then
            local str = string.format("%.3f",value)
            self:Print(AirjHack:GetDebugChatFrame(),filter.note,str)
          end
          local key,time = string.match(filter.note,"aaks (%w+) (%d+)")
          if key then
            self:SetParamTemporary(key,value,time or 1)
          end
        end
        passed = Core:MatchValue(value,filter)
      else
        passed = value
      end
    end
    return passed,priority
  end

  function Core:CheckFilter(filter,priority)
    local passed
    if filter.name and type(filter.name) ~="table" then
      filter.name = self:ToValueTable(filter.name)
    end
    if filter.type == "GROUP" then
      passed,priority = self:CheckGroupFilter(filter,priority)
    else
      passed,priority = self:CheckTypeFilter(filter,priority)
    end
	  if filter.oppo then passed = not passed end
    return passed,priority
  end

  function Core:CheckFilterArray(filterArray,priority)
    if filterArray.name and #filterArray.name>0 and false then

    else
      local countToPass = filterArray.value or 0
    	if countToPass <= 0 then
    		countToPass = countToPass + #filterArray
    	end
      local countToFail = #filterArray - countToPass
    	local passedCount = 0
    	local failedCount = 0
      for i,filter in ipairs(filterArray) do
        local passed
        -- passed, priority = self:CheckFilter(filter,priority)
        local success
        local lastPriority = priority
        success, passed, priority = pcall(self.CheckFilter,self,filter,priority)
        if not success then
          passed, priority = false, lastPriority
        end
        if passed then
          passedCount = passedCount + 1
        else
          failedCount = failedCount + 1
        end
        if passedCount >= countToPass then
          return true, priority
        end
        if failedCount > countToFail then
          return false, priority
        end
      end
    	return true, priority
    end
  end

  function Core:PreCheckSplitedUnit(unit,checked)
    local guid = Cache:UnitGUID(unit)
    local passed = false
    if guid and not checked[guid] then
      checked[guid] = true
      if prepassed[guid]~=nil then return prepassed[guid] end
      local t = Cache.cache.serverRefused:get(guid)
      if not t or t.count<2 or (GetTime() - t.t > 0.4) or (GetTime() - t.t > 0.2) and guid == UnitGUID("target") then
        passed = true
        prepassed[guid] = true
      else
        prepassed[guid] = false
      end
    end
    return passed
  end

  function Core:SplitAndCheckSequence(sequence,unitList,executed)
    if not unitList then return end
    local filterArray = sequence.filter
    local checked = {}
    local priorityList = {}
    local realcheck
    for _,unit in ipairs(unitList) do
      if self:PreCheckSplitedUnit(unit,checked) or sequence.isr then
        local guid = UnitGUID(unit)
        if not executed or executed and guid and not executed[guid] then
          realcheck = true
          -- if executed then
          --   print(unit)
          -- end
          self:SetAirUnit(unit)
          local passed,priority = Core:CheckFilterArray(filterArray)
            -- self:Print("SplitAndCheckSequence",passed,unit)
          if passed then
            -- self:Print(unit,passed,priority)
            if priority then
              priorityList[unit] = priority
            else
              return unit
            end
          end
        end
      else
      end
    end
    local maxKey,maxValue
    for unit,priority in pairs(priorityList) do
      if not maxValue or priority > maxValue then
        maxKey = unit
        maxValue = priority
      end
    end
    return maxKey,not realcheck
  end


  function Core:Barcast()
    if self:GetParam("fc") then return false end
    local notMoving=(Cache:Call("GetUnitSpeed","player") == 0 and not Cache:Call("IsFalling"))
    if notMoving then return true end
    -- local guid = Cache:UnitGUID("player")
    -- local buffs = Cache:GetBuffs(guid,"player",{[108839]=true,[193223]=true,[202461]=true,[236431]=true})
    -- return #buffs > 0
    local movebuffremain = self:GetMoveCastBuffRemain()
    return movebuffremain and movebuffremain>0.2 or false
    --
  end

  function Core:GetMoveCastBuffRemain()
    local guid = Cache:UnitGUID("player")
    local buffs = Cache:GetBuffs(guid,"player",{[108839]=true,[193223]=true,[202461]=true,[236431]=true})
    local now = GetTime()
    local maxremain
    for i,v in pairs(buffs) do
      local remain = v[7] == 0 and 5 or v[7] - now
      if not maxremain or remain>maxremain then
        maxremain = remain
      end
    end
    return maxremain
  end

  function Core:CheckAndExecuteSequence(sequence,executed)
    if not self:CheckBasicFilters(sequence) then return end
    local unitList = self:GetUnitListByAirType(sequence.anyinraid)
    -- dump(unitList)
    local filterReturn, unit
    local allexcuted
    local lastunit = self:GetAirUnit()
    if unitList then
      filterReturn,allexcuted = self:SplitAndCheckSequence(sequence,unitList,executed)
      unit = filterReturn
      if sequence.pollall then
        executed = executed or {}
        if unit then
          executed[UnitGUID(unit)] = true
        end
      end
    else
      filterReturn = self:CheckFilterArray(sequence.filter or {},unitList)
      unit = lastunit
    end
    self:SetAirUnit(lastunit)
    if filterReturn then
      local execute
      if sequence.barcast then
        if self:Barcast() then
          execute = true
          self.maybarcast = GetTime()
        else
          self.needbarcast = GetTime()
          -- AirjMove:NeedBarCast()
        end
      else
        execute = true
      end
      if execute then
        self:ExecuteSequence(sequence,unit)
        if sequence.pollall then
          if not allexcuted then
            self:CheckAndExecuteSequence(sequence,executed)
          end
        end
      end
    end
  end

  function Core:ScanSequenceArray(sequenceArray)
    for i,sequence in ipairs(sequenceArray) do
      self:SetAirUnit()
      self:CheckAndExecuteSequence(sequence)
      if found[groupDeep] then return end
    end
  end

  function Core:Scan()
    local t=GetTime()
    local inv = Core:GetParam("inv") or 0.05
    self.lastScanTime = self.lastScanTime or t
    if t - self.lastScanTime < inv then
      return
    end
    self.lastScanTime=t
    wipe(self.passedSpell)
    wipe(self.templatePassed)
    wipe(prepassed)
    wipe(found)
    groupDeep = 1
    if self:Barcast() then
      self.needbarcast = nil
    end
    self:ClearCachePassedArray()
    if not self.rotationDB then return end
    local sequenceArray = self.rotationDB.spellArray
    self:ScanSequenceArray(sequenceArray)
  end

  function Core:RestartTimer()
    if self.mainTimer then
	    self:CancelTimer(self.mainTimer,true)
      self.mainTimer = nil
    end
  	self.mainTimer = self:ScheduleRepeatingTimer(self.Scan,0.02,self)
  end

  --  Scan
  --    ScanSequenceArray
  --      for CheckAndExecuteSequence
  --        CheckFilterArray
  --        ExecuteSequence
  --          ExecuteGroupSequence

end

-- basic filters
do
  local basicFilters = {}
  function Core:InitializeBasicFilters()
    tinsert(basicFilters,self.CheckIfDisable)
    tinsert(basicFilters,self.CheckTargetNumber)
    tinsert(basicFilters,self.CheckCooldown)
  end

  function Core:CheckBasicFilters(sequence)
    for i,v in ipairs(basicFilters) do
      if not v(self,sequence) then
        return false
      end
    end
    return true
  end

  function Core:CheckIfDisable(sequence)
    return not sequence.disable
  end
  function Core:CheckTargetNumber(sequence)
    local smin = sequence.tarmin or 1
    local smax = sequence.tarmax or 10
    local p = self.param.target or 1
    return p>=smin and p<=smax
  end
  function Core:CheckCooldown(sequence)
    local cd = sequence.cd
    if not cd then
      local spellId = sequence.spellId or sequence.spell
      cd = (spellId and GetSpellBaseCooldown(spellId) or 0)/1000
    end
    local p = self.param.cd or 60
    return cd<=p
  end
end

--unit
do
  local unitListCache = {}
  local knownAirType={
    help = true,
    pveharm = true,
    pvpharm = true,
    arena = true,
    all = true,
  }
  function Core:GetUnitListByAirType(airType)
    if not airType then return end
    if not knownAirType[airType] then local t = {strsplit(",",airType)} return t end
    if unitListCache[airType] then return unitListCache[airType] end
    local unitList = {"target","mouseover","player","targettarget","focus","focustarget","pet","pettarget"};
    if airType == "help" or airType == "all" then
      for i = 1,4 do
        tinsert(unitList,"party"..i)
      end
      for i = 1,4 do
        tinsert(unitList,"party"..i.."pet")
      end
      for i = 1,40 do
        tinsert(unitList,"raid"..i)
      end
      for i = 1,40 do
        tinsert(unitList,"raid"..i.."pet")
      end
    end
    if airType == "pveharm" or airType == "all" then
  		for i = 1,5 do
  			tinsert(unitList,"boss"..i)
  		end
  		for i = 1,50 do
  			tinsert(unitList,"nameplate"..i)
  		end
    end
    if airType == "pvpharm" or airType == "all" then
			for i = 1,4 do
				tinsert(unitList,"party"..i.."target")
			end
			for i = 1,40 do
				tinsert(unitList,"raid"..i.."target")
			end
    end
    if airType == "arena" or airType == "pvpharm" or airType == "all" then
      for i = 1,5 do
  			tinsert(unitList,"arena"..i)
  		end
    end
    unitListCache[airType] = unitList
  	return unitList
  end

  function Core:ParseUnit(unit)
    if unit == "air" then
      return self:GetAirUnit()
    elseif unit == "airtarget" then
      local au = self:GetAirUnit()
      if au then
        return au.."target"
      else
        return
      end
    elseif unit == "lcu" then
      local data = Cache.cache.castStart:find({sourceGUID=Cache:PlayerGUID()})
      if not data then return end
      local guid = data.destGUID
      return Cache:FindUnitByGUID(guid)
    elseif unit == "bgu" then
      return self:GetGroupUnit()
    elseif unit == "bgutarget" then
      return self:GetGroupUnit() and (self:GetGroupUnit().."target")
    else
      return
    end
  end

end
-- passcache
do
  local cache = {}
  local array = {}
  function Core:CachePassedInfo(spellId,unit)
    if spellId and unit then
      cache[spellId] = Cache:UnitGUID(unit)
    end
    if spellId then
      tinsert(array,{spellId,unit})
      -- if GUI then
      --   GUI:SetMainIcon(spellId,unit)
      --   self:Print(spellId,unit)
      -- end
    end
  end
  function Core:ClearCachePassedArray()
    wipe(array)
  end
  function Core:GetLastCachePassed()
    local index = #array
    if index ~= 0 then
      return unpack(array[index])
    end
  end
  function Core:GetPassedGuidBySpellId(spellId)
    return cache[spellId]
  end
end
--util
do
  function Core:DeepCopy(table)
  	if type(table) == "table" then
  		local toRet = {}
  		for k,v in pairs(table) do
  			toRet[k] = self:DeepCopy(v)
  		end
  		return toRet
  	else
  		return table
  	end
  end
  function Core:ToKeyTable(value)
    local toRet = {}
    if type(value) == "table" then
      for k,v in pairs(value) do
        v = v and tonumber(v) or v
        toRet[v] = true
      end
    elseif value and value ~= "" then
      toRet[value] = true
    else
      --rst = {}
    end
    return toRet
  end
  function Core:ToValueTable(value)
    local toRet = {}
    if type(value) == "table" then
      for i=1,100 do
        local v = value[i]
        local n = tonumber(v)
        if v == "" then
          v = nil
        else
          v = n or v
        end
        toRet[i] = v
      end
    elseif value and value ~= "" then
      tinsert(toRet,value and tonumber(value) or value)
    else
      --rst = {}
    end
    return toRet
  end
end

function Core:StopIfNot(name)
  local cname = UnitCastingInfo("player") or UnitChannelInfo("player")
  if name ~= cname then
    AirjHack:RunMacroText("/stopcasting")
  end
end
