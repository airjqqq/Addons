local Core = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKey", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
AirjAutoKey = Core
local db
function Core:OnInitialize()
  db = Core:InitializeDB()
end

function Core:OnEnable()
  self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED",self.SelectSuitableRotation,self)

	self:SecureHook("UseAction", function(slot, target, button)
		self:SetParamTemporary("auto",false,0.4)
	end)

  self.paramTimer = self:ScheduleRepeatingTimer(function()
    local t = GetTime()
    for k,v in pairs(self.paramBack) do
      if t>v.expires then
        Core:SetParam(k,v.value)
      end
    end
  end,0.01)

  self.mainTimerProtectorTimer = self:ScheduleRepeatingTimer(function()
    if GetTime() - (self.lastScanTime or 0) > 0.5 then
      self:RestartTimer()
    end
  end,0.1)
  self:SelectSuitableRotation()
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
        if math.abs(elfspec - rotation.spec)<0.1 then
          self:SelectRotation(i)
          return i
        end
        if rotation.class == class then
          classIndex = i
        end
  		end
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
  function Core:SetParamTemporary(key,value,time)
    local back = self.paramBack[key]
    if not back then
      self.paramBack[key] = {value = self.param[key],expires = GetTime() + time}
    end
    self.param[key] = value
  end
  function Core:SetParam(key,value)
    self.paramBack[key] = nil
    self.param[key] = value
  end
end

-- main timer
do
  function Core:RestartTimer()
  	self:CancelTimer(self.mainTimer,true)
  	self.mainTimer = self:ScheduleRepeatingTimer(function()
      self:Scan()
  	end,0.01)
  end

  function Core:Scan()
    local t=GetTime()
    self.lastScanTime=t

    local sequenceArray = self.rotationDB.spellArray
    self:ScanSequenceArray(sequenceArray)

  end

  function Core:GetAirUnit()
    return self.airUnit
  end

  function Core:SetAirUnit(unit)
    self.airUnit = unit
  end

  function Core:ExecuteSequence(sequence)
  end

  function Core:CheckFilterArray(filterArray,unitList)
    if unitList and not self:GetAirUnit() then
      local checked = {}
      local priorityList = {}
      for _,unit in ipairs(unitList) do
        local guid = Cache:Call("UnitGUID",unit)
        if guid and not checked[guid] then
          checked[guid] = true
          self:SetAirUnit(unit)
          local passed,priority = Core:CheckFilterArray(filterArray)
          if passed then
            if priority then
              priorityList[unit] = priority
            else
              return unit
            end
          end
        end
      end
      local maxKey,maxValue
      for unit,priority in pairs(priorityList) do
        if not maxValue or priority > maxValue then
          maxKey = unit
        end
      end
      return maxKey
    end
  end

  function Core:CheckAndExecuteSequence(sequence)
    if not self:CheckBasicFilters(sequence) then return end
    local unitList = self:GetUnitListByAirType(sequence.anyinraid)
    local filterReturn = self:CheckFilterArray(sequence.filter or {},unitList)
    if filterReturn then
      self:ExecuteSequence(sequence,filterReturn)
    end
  end

  function Core:ScanSequenceArray(sequenceArray)
    for i,sequence in ipairs(sequenceArray) do
      self:CheckAndExecuteSequence(sequence)
    end
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
      local spellId = sequence.spellId or spellKey
      cd = (GetSpellBaseCooldown(spellId) or 0)/1000
    end
    local p = self.param.cd or 60
    return cd<=p
  end
end

--unit
do
  local unitListCache = {}
  function Core:GetUnitListByAirType(airType)
    if not airType then return end
    if unitListCache[airType] then return unitListCache[airjType] end
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

  end
end
