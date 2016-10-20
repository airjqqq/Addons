local Core = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKey", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
AirjAutoKey = Core
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local db
local GUI
function Core:OnInitialize()
  self.filterTypes = {}
  self.passedSpell = {}
  db = self:InitializeDB()
  self:InitializeParam()
  self:InitializeBasicFilters()
  GUI = self:GetModule("GUI")
end

function Core:OnEnable()
  self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED",self.SelectSuitableRotation,self)

	self:SecureHook("UseAction", function(slot, target, button)
		-- self:SetParamTemporary("auto",false,0.4)
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
  if GetCVar("reducedLagTolerance") ~= "1" then
    SetCVar("reducedLagTolerance", 1)
    SetCVar("MaxSpellStartRecoveryOffset", 50)
  end
  -- starttest
  -- self:OnChatCommmand("world",150,"4 上班族公会招人,主打M团队副本。进度：H全通，M-3/7。只要上班族,详情M聊。打扰抱歉")
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
    self.rotationDB = self.rotationDataBaseArray[index]
    return self.rotationDB
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
        local channel, message  = Core:GetArgs(value, 2)
        local fcn = function()
          -- Core:Print(value,message,"CHANNEL",nil,tonumber(channel) or channel)
          -- SendChatMessage(message,"CHANNEL",nil,tonumber(channel) or channel)
          AirjHack:RunMacroText("/"..channel.." "..message)
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
        AirjAutoKey_GUI_anchor:SetPoint("BOTTOMLEFT",UIParent,"BOTTOM",0,120)
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
      self.paramBack[key] = {value = self.param[key],expires = GetTime() + time}
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
    petattack = "/petattack",
    petfollow = "/petfollow",
  }
  local found
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

  function Core:ExecuteGroupSequence(sequence,unit)
    self:SetAirUnit(unit)
    self:ScanSequenceArray(sequence)
    -- self:SetAirUnit()
    if sequence.continue then
      found = false
    end
  end

  function Core:GetPresetMacro(key)
    return presetMacros[key]
  end

  function Core:ToBasicMacroText(key)
    if not key or key == "" then return end
    local macros = self.rotationDB.macroArray or {}
    if macros[key] then return macros[key] end
    if string.sub(key,1,1) == "/" then return key end
    local pre = self:GetPresetMacro(key)
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
    end
    -- self:Print(macrotext)
    local type, data, subType, subData = GetCursorInfo()
    AirjHack:RunMacroText(macrotext)
    if type == "spell" then
      if pickUpTimer then
        self:CancelTimer(pickUpTimer)
        pickUpTimer = nil
      end
      pickUpTimer = self:ScheduleTimer(function() PickupSpell(subData) end,0.2)
    end
  end

  function Core:ExecuteSequence(sequence,unit)
    self.passedSpell[tostring(sequence)] = unit or true
    if sequence.group then
      self:ExecuteGroupSequence(sequence,unit)
    else
      local macroText, spellName, spellId = self:ToBasicMacroText(sequence.spell)
      self:ExecuteMacro(macroText,unit)
      self:CachePassedInfo(spellId,unit)
    end
    if not sequence.continue then
      found = true
      self:SetAirUnit()
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
    self:Print(AirjHack:GetDebugChatFrame(),"Register Filter:",data.name)
  end

  function Core:MatchValue(value,filter)
    local passed = value <= (filter.value or 0)
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
      if filter.oppo then
        priority = priority / value
      else
        priority = priority * value
      end
      passed = true
  	  if filter.oppo then passed = not passed end
    else
      if type(value) == "number" then
        if filter.note == "debug" then
          self:Print(AirjHack:GetDebugChatFrame(),"note=debug",value)
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

  function Core:PreCheckSplitedUnit(unit,checked)
    local guid = Cache:UnitGUID(unit)
    local passed = false
    if guid and not checked[guid] then
      checked[guid] = true
      if prepassed[guid]~=nil then return prepassed[guid] end
      local t = Cache.cache.serverRefused[guid]
      if not t or t.count<2 or (GetTime() - t.t > 1) then
        passed = true
        prepassed[guid] = true
      else
        prepassed[guid] = false
      end
    end
    return passed
  end

  function Core:SplitAndCheckSequence(sequence,unitList)
    if not unitList then return end
    local filterArray = sequence.filter
    local checked = {}
    local priorityList = {}
    for _,unit in ipairs(unitList) do
      if self:PreCheckSplitedUnit(unit,checked) then
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
    return maxKey
  end

  function Core:CheckAndExecuteSequence(sequence)
    if not self:CheckBasicFilters(sequence) then return end
    local unitList = self:GetUnitListByAirType(sequence.anyinraid)
    local filterReturn, unit
    if unitList and not self:GetAirUnit() then
      filterReturn = self:SplitAndCheckSequence(sequence,unitList)
      unit = filterReturn
    else
      filterReturn = self:CheckFilterArray(sequence.filter or {},unitList)
    end
    if filterReturn then
      self:ExecuteSequence(sequence,unit)
    end
  end

  function Core:ScanSequenceArray(sequenceArray)
    for i,sequence in ipairs(sequenceArray) do
      self:SetAirUnit()
      self:CheckAndExecuteSequence(sequence)
      if found then return end
    end
  end

  function Core:Scan()
    local t=GetTime()
    self.lastScanTime=t
    -- wipe(self.passedSpell)
    wipe(prepassed)
    found = false
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
    if not knownAirType[airType] then return {airType} end
    if unitListCache[airType] then return unitListCache[airType] end
    local unitList = {"target","mouseover","player","targettarget","focus","pet","pettarget"};
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
  		for i = 1,20 do
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
    elseif unit == "airjtarget" then
      local au = self:GetAirUnit()
      if au then
        return au.."target"
      else
        return
      end
    elseif unit == "lcu" then
      local data = Cache.cache.castStartTo.last
      if not data then return end
      local guid = data.guid
      return Cache:FindUnitByGUID(guid)
    elseif unit == "bgu" then
      return self:GetGroupUnit()
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
