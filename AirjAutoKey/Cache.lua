-- local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):NewAddon("AirjCache", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local AirjHack = LibStub("AceAddon-3.0"):GetAddon("AirjHack")
AirjCache = Cache


local band = bit.band


function Cache:OnInitialize()
	--self.cache.name[key]={t=GetTime(),k=v}
	self.cache = setmetatable({},{
		__index=function(t,k)
			t[k]={}
			return t[k]
		end
	})
end

function Cache:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UI_ERROR_MESSAGE")
	self:RegisterEvent("UNIT_HEALTH",self.OnHealthChanged,self)
	self:RegisterEvent("UNIT_MAXHEALTH",self.OnHealthChanged,self)
	self:RegisterEvent("UNIT_HEAL_PREDICTION",self.OnHealthChanged,self)
	self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED",self.OnHealthChanged,self)
	self:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED",self.OnHealthChanged,self)
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN",self.OnCoolDownChanged,self)
	self:RegisterEvent("SPELL_UPDATE_CHARGES",self.OnCoolDownChanged,self)
	self:RegisterEvent("SPELL_UPDATE_USABLE",self.OnCoolDownChanged,self)
	self:RegisterEvent("UNIT_POWER_FREQUENT",function(event,unit,type)
		if unit == "player" then
			self:OnCoolDownChanged()
		end
	end)

  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectChanged,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectChanged,self)

	self.interval = {
		buffs = 1,
		debuffs = 1,
		health = 0.05,
		position = 0,
		spell = 10,
		spec = 5,
		exists = 1,
	}
	self.scanTimer = self:ScheduleRepeatingTimer(function()
		local units = self:GetUnitList()
		local guids = self:GetUnitGUIDs()
		local tguid = UnitGUID("target")
		if tguid and guids[tguid] == nil then
			guids[tguid] = 9
		end
		local t = GetTime()
		self:ScanAuras(t,guids,units)
		self:ScanSpeed(t,guids,units)
		self:ScanSpell(t,guids,units)
		self:ScanGCD(t,guids,units)
		self:ScanSpec(t,guids,units)
		self:ScanExists(t,guids,units)
		self:ScanCasting(t,guids,units)
	end,0.05)

  self.mainTimerProtectorTimer = self:ScheduleRepeatingTimer(function()
    if GetTime() - (self.lastScanPositionTime or 0) > 0.5 then
      self:Print("RestartScanPositionTimer")
      -- self.lastScanPositionTime = GetTime()
      self:RestartScanPostionTimer()
    end

    if GetTime() - (self.lastRecoverTime or 0) > 2 then
      self:Print("RestarRecovertTimer")
      -- self.lastRecoverTime = GetTime()
      self:RestarRecovertTimer()
    end
    if GetTime() - (self.lastScanHealthTime or 0) > 0.5 then
      self:Print("RestartScanHealthTimer")
      -- self.lastScanHealthTime = GetTime()
      self:RestartScanHealthTimer()
    end
  end,0.1)
	self.recoverDuration = {
		line2guid = 5,
		myhealth = 30,
	}
end

function Cache:RestarRecovertTimer()
	if self.recoverTimer then
		self:CancelTimer(self.recoverTimer,true)
		self.recoverTimer = nil
	end
	self.lastRecoverTime=GetTime()
	self.recoverTimer = self:ScheduleRepeatingTimer(function()
		local t = GetTime()
    self.lastRecoverTime=t
		for k,v in pairs(self.cache) do
			if self.recoverDuration[k] then
				self:Recover(v,t,self.recoverDuration[k])
			end
		end
	end,1)
end
function Cache:RestartScanHealthTimer()
	if self.scanHealthTimer then
		self:CancelTimer(self.scanHealthTimer,true)
		self.scanHealthTimer = nil
	end
	self.lastScanHealthTime=GetTime()
	self.scanHealthTimer = self:ScheduleRepeatingTimer(function()
		local units = self:GetUnitList()
		local guids = self:GetUnitGUIDs()
    local t=GetTime()
    self.lastScanHealthTime=t
		self:ScanHealth(t,guids,units)
	end,0.02)
end
function Cache:RestartScanPostionTimer()
	if self.scanPositionTimer then
		self:CancelTimer(self.scanPositionTimer,true)
		self.scanPositionTimer = nil
	end
	self.lastScanPositionTime = GetTime()
	self.scanPositionTimer = self:ScheduleRepeatingTimer(function()
		local units = self:GetUnitList()
		local guids = self:GetUnitGUIDs()
    local t=GetTime()
    self.lastScanPositionTime=t
		self:ScanPosition(t,guids,units)
	end,0.05)
end

function Cache:OnDisable()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("UNIT_SPELLCAST_SENT")
	self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
end

do
  local playerGUID
  function Cache:PlayerGUID()
    if playerGUID then return playerGUID end
    playerGUID = UnitGUID("player")
    return playerGUID
  end
	local lastT
	function Cache:UnitGUID(unit)
		if not unit then return end
		local t = GetTime()
		local guids = self.cache.guid
		if t~=lastT then
			lastT = t
			wipe(guids)
		end
		local guid = guids[unit]
		if guid == nil then
			guid = UnitGUID(unit)
			guids[unit] = guid or false
			return guid
		elseif guid == false then
			return nil
		else
			return guid
		end
	end
end

function Cache:Call(fcnName,...)
	local key = fcnName
	for i,v in ipairs({...}) do
		key = key.."-"..v
	end
	local toRet = self.cache.call[key]
	local t = GetTime()
	if toRet and toRet.t == t then
		return unpack(toRet,1,20)
	else
		toRet = {_G[fcnName](...)}
		toRet.t = t
		self.cache.call[key]=toRet
		return unpack(toRet,1,20)
	end
end

--util functions
do
	local recoverd = 0
	local function recover(data,t,duration)
		-- if recoverd > 1000 then
		-- 	return
		-- end
		for k,v in pairs(data) do
			if type(v) == "table" then
				recoverd = recoverd + 1
				if v.t then
					if t-v.t > duration then
						if data.isArray then
							tremove(data,k)
						else
							data[k] = nil
						end
					end
				else
					recover(v,t,duration)
				end
			end
		end
	end
	function Cache:Recover(data,t,duration)
		recoverd = 0
		recover(data,t,duration)
	end
	function Cache:GetUnitList()
		if self.unitListCache then return self.unitListCache end
		local subUnit = {"","target","pet","pettarget"}
		local list = {"player","target","targettarget","pet","pettarget","focus","focustarget","mouseover","mouseovertarget"}
		for i = 1,5 do
			tinsert(list,"arena"..i)
		end
		for i = 1,4 do
			tinsert(list,"boss"..i)
			tinsert(list,"boss"..i.."target")
		end
		for _,sub in pairs(subUnit) do
			for i = 1,4 do
				tinsert(list,"party"..i..sub)
			end
		end
		for i = 1,40 do
			for _,sub in pairs(subUnit) do
				tinsert(list,"raid"..i..sub)
			end
		end
		for i = 1,20 do
			tinsert(list,"nameplate"..i)
		end
		self.unitListCache=list
		return list
	end


	local name2unit = {}
	function Cache:FindUnitByName(name)
		if not name then return end
		local unit = name2unit[name]
		if unit and UnitName(unit)==name then
			return unit
		end
		for _,u in ipairs(self:GetUnitList()) do
			local n = UnitName(u)
			if n then
				name2unit[n] = u
				if n == name then
					return u
				end
			end
		end
	end

	local guid2unit = {}
	function Cache:FindUnitByGUID(guid)
		if not guid then return end
		local unit = guid2unit[guid]
		if unit and UnitGUID(unit)==guid then
			return unit
		end
		for _,u in pairs(self:GetUnitList()) do
			local g = UnitGUID(u)
			if g then
				guid2unit[g] = u
				if g == guid then
					return u
				end
			end
		end
	end

	function Cache:OnObjectChanged()
		self.guidListCache = nil
	end

	function Cache:GetUnitGUIDs()
		if self.guidListCache then return self.guidListCache end
		local toRet = {}
		if AirjHack and AirjHack:HasHacked() then
			local objects = AirjHack.objectCache or AirjHack:GetObjects()
			for guid,type in pairs(objects) do
				if band(type,0x08)~=0 then
					toRet[guid] = type
				end
			end
		end
		self.guidListCache = toRet
		return toRet
	end
end

--events
do
	local lastErrorCode
	function Cache:UNIT_SPELLCAST_SENT(...)
		-- print(...)
		local event,unitID, spell, rank, target, lineID = ...
		target = strsplit("-",target)
		if unitID == "player" then
			-- self:Print(GetTime(),...)
			local t = GetTime()
			local spellName, _, _, _, _, _, spellID = GetSpellInfo(spell)
	    local guid,unit
	    if spellID and AirjAutoKey then
	      guid = AirjAutoKey:GetPassedGuidBySpellId(spellID)
	      unit = guid and self:FindUnitByGUID(guid)
	    end
	    if not unit or UnitName(unit) ~= target then
	      unit = self:FindUnitByName(target)
	      guid = unit and UnitGUID(unit)
	    end
			local spellId = spellID
	    if spellID then
				self.cache.castSend[spellId]=self.cache.castSend[spellId] or {}
				self.cache.castSend.last = {t=t,guid=guid,spellId=spellId}
				local to = self.cache.castSend[spellId]
				to.last={t=t,guid=guid}
				if guid then
					to[guid]={t=t}
				end
			end
				-- self:Print("UNIT_SPELLCAST_SENT",lineID)
			if lineID then
		    self.cache.line2guid[lineID]={
					t=t,
					guid=guid,
				}
			end
		end
	end

	function Cache:UNIT_SPELLCAST_FAILED(...)
		local event,unitID, spell, rank, lineID, spellID = ...
		if unitID == "player" then
			-- self:Print(GetTime(),...)
	    local data = self.cache.line2guid[lineID]
			if data then
				if GetTime() - data.t < 1 then
					local guid = data.guid
			    if guid then
						local current = self.cache.serverRefused[guid]
						local increase = lastErrorCode == 50 and 10 or 1
						if current and data.t-current.t<1 then
							current.count = current.count + increase
						else
							self.cache.serverRefused[guid] = {
								t=data.t,
								count=increase,
							}
						end
						if self.cache.serverRefused[guid].count>1 then
							-- self:Print(GetTime(),"Server Refused",guid)
						end
			    end
				end
			end
	  end
	end
	function Cache:UNIT_SPELLCAST_FAILED_QUIET(...)
		local event,unitID, spell, rank, lineID, spellID = ...
	end
	function Cache:UNIT_SPELLCAST_SUCCEEDED(...)
		local event,unitID, spell, rank, lineID, spellID = ...
		if unitID == "player" then
			-- self:Print(GetTime(),...)
			local data = self.cache.line2guid[lineID]
			if data then
				if GetTime() - data.t < 1 then
					local guid = data.guid
					if guid then
						-- self:Print("Server Confirmed",guid)
						self.cache.serverRefused[guid] = nil
					end
				end
			end
		end
	end
	function Cache:UI_ERROR_MESSAGE(event,errorCode,errorMessage)
		lastErrorCode = errorCode
	end

	function Cache:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,...)
		local t = GetTime()
		local list = Cache.combatLogEventList
		for i,v in ipairs(list) do
			local events = v.events
			local fcn = v.fcn
			if events and fcn then
				local event = select(2,...)
				local passed = events[event]
				if not passed then
					for e in pairs(events) do
						if strfind(event,e) then
							passed = true
							break
						end
					end
				end
				if passed then
					local s,m = pcall(fcn,t,...)
					if not s then self:Print("error:",m) end
				end
			end
			-- body...
		end
	end
	do
		local self = Cache
		Cache.combatLogEventList = {
			{
				name = "flag",
				events = {
					_=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,...)
					if sourceGUID then
						self.cache.flag[sourceGUID] = {sourceFlags,sourceFlags2}
					end
					if destGUID then
						self.cache.flag[destGUID] = {destFlags,destFlags2}
					end
				end

			},
			{
				name = "damage",
				events = {
					_DAMAGE=true,
					_MISSED=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
					local periodic = strfind(event,"_PERIODIC") and true or false
					local damage = 0
					local rawDamage = 0
					local args
					if spellId == 196917 then
						return
					end
					if strfind(event,"SWING_") then
						args= {spellId,spellName,spellSchool,...}
						spellId="Swing"
						spellName = "Swing"
					else
						args= {...}
					end
					if strfind(event,"_DAMAGE") then
						local amount,overkill,school,resisted,blocked,absorbed = unpack(args)
						damage = damage + (amount or 0) + (overkill or 0) + (resisted or 0) + (blocked or 0) + (absorbed or 0)
						rawDamage = (amount or 0)
					else
						local missType,isOffHand,amountMissed = unpack(args)
						damage = damage + (amountMissed or 0)
						rawDamage = (amount or 0)
					end
					sourceGUID = sourceGUID or "Unknown"
					destGUID = destGUID or "Unknown"
					spellId = spellId or "Unknown"
					spellName = spellName or "Unknown"

					self.cache.damageTo[sourceGUID]=self.cache.damageTo[sourceGUID] or {}

					local to = self.cache.damageTo[sourceGUID]
					to.array = to.array or {isArray = true}
					tinsert(to.array,{t=localtime,value=damage,guid=destGUID,spellId=spellId,spellName=spellName,periodic=periodic})
					to[spellId]=to[spellId] or {}
					to[spellId].array = to[spellId].array or {isArray = true}
					tinsert(to[spellId].array, {t=localtime,value=damage,guid=destGUID,periodic=periodic})
					-- to[spellId].last={t=localtime,value=damage,guid=destGUID,periodic=periodic}
					-- to[spellId][destGUID]={t=localtime,value=damage,periodic=periodic}


					self.cache.damageBy[destGUID]=self.cache.damageBy[destGUID] or {}
					local by = self.cache.damageBy[destGUID]
					by.array = by.array or {isArray = true}
					tinsert(by.array,{t=localtime,value=damage,guid=sourceGUID,spellId=spellId,spellName=spellName,periodic=periodic})
					by[spellId]=by[spellId] or {}
					by[spellId].array = by[spellId].array or {isArray = true}
					tinsert(by[spellId].array, {t=localtime,value=damage,guid=sourceGUID,periodic=periodic})
					-- by[spellId].last={t=localtime,value=damage,guid=sourceGUID,periodic=periodic}
					-- by[spellId][sourceGUID]={t=localtime,value=damage,periodic=periodic}
					if self.cache.health[destGUID] then
						self.cache.health[destGUID].changed = true
					end
				end
			},
			{
				name = "heal",
				events = {
					_HEAL=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
					local periodic = strfind(event,"_PERIODIC") and true or false
					local heal = 0
					local rawHeal = 0
					local amount,overhealing,absorbed = ...
					if type(amount) ~= "number" then
						amount = 0
					end
					heal = heal + (amount or 0)  -- +(overhealing or 0)+(absorbed or 0)
					if type(overhealing) ~= "number" then
						overhealing = 0
					end
					if type(absorbed) ~= "number" then
						absorbed = 0
					end
					rawHeal = (amount or 0) - ((overhealing or 0)+(absorbed or 0))
					sourceGUID = sourceGUID or "Unknown"
					destGUID = destGUID or "Unknown"
					spellId = spellId or "Unknown"

					self.cache.healTo[sourceGUID]=self.cache.healTo[sourceGUID] or {}
					local to = self.cache.healTo[sourceGUID]
					to.array = to.array or {isArray = true}
					tinsert(to.array,{t=localtime,value=heal,guid=destGUID,spellId=spellId,periodic=periodic})
					to[spellId]=to[spellId] or {}
					to[spellId].array = to[spellId].array or {isArray = true}
					tinsert(to[spellId].array, {t=localtime,value=heal,guid=destGUID,periodic=periodic})
					-- to[spellId].last={t=localtime,value=heal,guid=destGUID,periodic=periodic}
					-- to[spellId][destGUID]={t=localtime,value=heal,periodic=periodic}

					self.cache.healBy[destGUID]=self.cache.healBy[destGUID] or {}
					local by = self.cache.healBy[destGUID]
					by.array = by.array or {isArray = true}
					tinsert(by.array,{t=localtime,value=heal,guid=sourceGUID,spellId=spellId,periodic=periodic})
					by[spellId]=by[spellId] or {}
					by[spellId].array = by[spellId].array or {isArray = true}
					tinsert(by[spellId].array, {t=localtime,value=heal,guid=sourceGUID,periodic=periodic})
					-- by[spellId].last={t=localtime,value=heal,guid=sourceGUID,periodic=periodic}
					-- by[spellId][sourceGUID]={t=localtime,value=heal,periodic=periodic}

					if self.cache.health[destGUID] then
						self.cache.health[destGUID].changed = true
					end
				end
			},
			{
				name = "castSuccess",
				events = {
					SPELL_CAST_SUCCESS=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)

					sourceGUID = sourceGUID or "Unknown"
					destGUID = destGUID or "Unknown"
					spellId = spellId or "Unknown"
					self.cache.castSuccessTo[sourceGUID]=self.cache.castSuccessTo[sourceGUID] or {}
					local to = self.cache.castSuccessTo[sourceGUID]
					to.array = to.array or {isArray = true}
					tinsert(to.array,{t=localtime,guid=destGUID,spellId=spellId})
					to[spellId]=to[spellId] or {}
					to[spellId].last={t=localtime,guid=destGUID}
					to[spellId][destGUID]={t=localtime}

					self.cache.castSuccessBy[destGUID]=self.cache.castSuccessBy[destGUID] or {}
					local by = self.cache.castSuccessBy[destGUID]
					by[spellId]=by[spellId] or {}
					by[spellId].last={t=localtime,guid=sourceGUID}
					by[spellId][sourceGUID]={t=localtime}
				end
			},
			{
				name = "castStart",
				events = {
					SPELL_CAST_START=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
					if self:PlayerGUID() == sourceGUID or UnitGUID("pet") == sourceGUID then
						destGUID = destGUID or "Unknown"
						spellId = spellId or "Unknown"
						local data = self.cache.castSend[spellId] and self.cache.castSend[spellId].last
						local guid
						if data and data.t and localtime-data.t<1 then
							guid = data.guid
						end
						guid = guid or destGUID
						self.cache.castStartTo[spellId]=self.cache.castStartTo[spellId] or {}
						self.cache.castStartTo.last = {t=localtime,guid=guid,spellId=spellId}
						if self:PlayerGUID() == sourceGUID  then
							self.cache.castStartTo.lastplayer = {t=localtime,guid=guid,spellId=spellId}
						end
						local to = self.cache.castStartTo[spellId]
						to.last={t=localtime,guid=guid}
						if guid then
							to[guid]={t=localtime}
						end
					end
				end
			},
			{
				name = "aura+",
				events = {
					_AURA_APPLIED=true,
					_AURA_REFRESH=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,auraType)
					sourceGUID = sourceGUID or "Unknown"
					destGUID = destGUID or "Unknown"
					spellId = spellId or "Unknown"

					self.cache.auraTo[sourceGUID]=self.cache.auraTo[sourceGUID] or {}
					local to = self.cache.auraTo[sourceGUID]
					to[spellId]=to[spellId] or {}
					to[spellId].last={t=localtime,guid=destGUID}
					to[spellId][destGUID]={t=localtime}

					self.cache.auraBy[destGUID]=self.cache.auraBy[destGUID] or {}
					local by = self.cache.auraBy[destGUID]
					by[spellId]=by[spellId] or {}
					by[spellId].last={t=localtime,guid=sourceGUID}
					by[spellId][sourceGUID]={t=localtime}
					local cacheKey = auraType == "DEBUFF" and "debuffs" or "buffs"
					if self.cache[cacheKey][destGUID] then
						self.cache[cacheKey][destGUID].changed = self.cache[cacheKey][destGUID].changed or {}
						self.cache[cacheKey][destGUID].changed[spellId] = true
						self.cache[cacheKey][destGUID].changed[spellName] = true
					end
				end
			},
			{
				name = "aura-",
				events = {
					_AURA_BROKEN=true,
					_AURA_REMOVED=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,auraType)
					sourceGUID = sourceGUID or "Unknown"
					destGUID = destGUID or "Unknown"
					spellId = spellId or "Unknown"
					self.cache.auraTo[sourceGUID]=self.cache.auraTo[sourceGUID] or {}
					local to = self.cache.auraTo[sourceGUID]
					to[spellId]=to[spellId] or {}
					to[spellId][destGUID]=nil

					self.cache.auraBy[destGUID]=self.cache.auraBy[destGUID] or {}
					local by = self.cache.auraBy[destGUID]
					by[spellId]=by[spellId] or {}
					by[spellId][sourceGUID]=nil
					local cacheKey = auraType == "DEBUFF" and "debuffs" or "buffs"
					if self.cache[cacheKey][destGUID] then
						self.cache[cacheKey][destGUID].changed = self.cache[cacheKey][destGUID].changed or {}
						self.cache[cacheKey][destGUID].changed[spellId] = true
						self.cache[cacheKey][destGUID].changed[spellName] = true
					end
				end
			},
		}
	end
end

--health
do
	function Cache:OnHealthChanged(event,unit)
		local guid = unit and UnitGUID(unit)
		if guid and self.cache.health[guid] then
			self.cache.health[guid].changed = true
		end
		if guid == self:PlayerGUID() then
			local data = {AirjHack:UnitHealth(guid)}
			data.t = GetTime()
			tinsert(self.cache.myhealth,data)
		end
	end

	function Cache:ScanOnesHealth(t,guid)
		local data = {AirjHack:UnitHealth(guid)}
		data.t = t
		self.cache.health[guid] = data
		return data
	end

	function Cache:ScanHealth(t,guids,units)
		for guid in pairs(guids) do
		-- for i,unit in ipairs(units) do
		-- 	local guid = UnitGUID(unit)
			-- if guid and guids[guid] then
				local data = self.cache.health[guid]
				if not data or t - data.t>self.interval.health then
					self:ScanOnesHealth(t,guid)
				end
			-- end
		end
		-- if guids then
		-- 	for guid in pairs(guids) do
		-- 	end
		-- end
	end

	function Cache:GetHealth(guid)
		local data = self.cache.health[guid]
		if not data or data.changed then
			data = self:ScanOnesHealth(GetTime(),guid)
		end
		return unpack(data or {})
	end
	function Cache:GetHealthArray()
		return self.cache.myhealth or {}
	end
end

--auras
do
	function Cache:ScanOnesBuffs(t,guid,unit)
		local data = {t=t}
		for i=1,100 do
			local value = {UnitBuff(unit,i)}
			if not value[1] then
				break
			end
			data[i] = value
		end
		self.cache.buffs[guid] = data
		return data
	end

	function Cache:ScanOnesDebuffs(t,guid,unit)
		local data = {t=t}
		for i=1,100 do
			local value = {UnitDebuff(unit,i)}
			if not value[1] then
				break
			end
			data[i] = value
		end
		self.cache.debuffs[guid] = data
		return data
	end

	function Cache:ScanAuras(t,guids,units)
		if units then
			for i,unit in ipairs(units) do
				local guid = UnitGUID(unit)
				if guid then
					local data = self.cache.buffs[guid]
					if not data or t - data.t>self.interval.buffs then
						Cache:ScanOnesBuffs(t,guid,unit)
					end
					data = self.cache.debuffs[guid]
					if not data or t - data.t>self.interval.debuffs then
						Cache:ScanOnesDebuffs(t,guid,unit)
					end
				end
			end
		end
	end

	function Cache:GetBuffs(guid,unit,spellKeys,mine)
		local toRet = {}
		if not guid then return toRet end
		local buffs = self.cache.buffs[guid]
		if not buffs or buffs.changed then
			local needReload
			if spellKeys then
				for k, v in pairs(buffs.changed) do
					if spellKeys[k] then
						needReload = true
						break
					end
				end
			else
				needReload = true
			end
			if needReload then
				buffs =	Cache:ScanOnesBuffs(GetTime(),guid,unit)
			end
		end
		if not buffs then return toRet end
		for i,v in ipairs(buffs) do
			local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
			if not mine or caster == "player" or caster == "pet" then
				if not spellKeys or spellKeys[spellID] or spellKeys[name] then
					tinsert(toRet,v)
				end
			end
		end
		return toRet
	end

	function Cache:GetDebuffs(guid,unit,spellKeys,mine)
		local toRet = {}
		if not guid then return toRet end
		local debuffs = self.cache.debuffs[guid]
		if not unit then unit = self:FindUnitByGUID(guid) end
		if unit and (not debuffs or debuffs.changed) then
			local needReload
			if spellKeys then
				for k, v in pairs(debuffs.changed) do
					if spellKeys[k] then
						needReload = true
						break
					end
				end
			else
				needReload = true
			end
			if needReload then
				debuffs =	Cache:ScanOnesDebuffs(GetTime(),guid,unit)
			end
		end
		if not debuffs then return toRet end
		for i,v in ipairs(debuffs) do
			local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
			if not mine or caster == "player" or caster == "pet" then
				if not spellKeys or spellKeys[spellID] or spellKeys[name] then
					tinsert(toRet,v)
				end
			end
		end
		return toRet
	end
end

--Position
do
	local scanT
	function Cache:ScanPosition(t,guids,units)
		if not scanT or t-scanT>self.interval.position then
			wipe(self.cache.position)
			local px,py,pz,pf = AirjHack:Position("player")
			local pi = math.pi
			if guids then
				for guid,type in pairs(guids) do
					if bit.band(type,0x08)~=0 then
						local x,y,z,f,s = AirjHack:Position(guid)
						if x then
							local dx,dy,dz = x-px, y-py, z-pz
							local distance = sqrt(dx*dx+dy*dy+dz*dz)
							self.cache.position[guid]={x,y,z,f,distance,s}
						end
					end
				end
			end
			scanT = t
		end
	end

	function Cache:ScanSpeed(t,guids,unit)
		local cache = {t=t}
		self.cache.speed.isArray = true
		tinsert(self.cache.speed,cache)
		cache.value = GetUnitSpeed("player")

	end

	function Cache:GetPosition(guid)
		return unpack(self.cache.position[guid] or {})
	end
end

--Spell
do
	local scanT
	local changed
	local externSpellIDs = {}
	function Cache:OnCoolDownChanged(event)
		-- self:Print("changed")
		changed = true
	end
	function Cache:ScanAllSpell(t)
		-- self:Print("ScanAllSpell")
		wipe(self.cache.charge)
		wipe(self.cache.cooldown)
		wipe(self.cache.usable)
		wipe(self.cache.known)
		for i=1,200 do
			-- local name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(i, "spell")
			local t,spellID = GetSpellBookItemInfo(i,"spell")
			if not t then
				break
			end
			if spellID then
				local offId = select(7,GetSpellInfo(i, "spell"))
				self.cache.charge[spellID] = {GetSpellCharges(spellID)}
				self.cache.cooldown[spellID] = {GetSpellCooldown(spellID)}
				self.cache.usable[spellID] = {IsUsableSpell(spellID)}
				self.cache.known[spellID] = true
				if offId then
					self.cache.known[offId] = true
				end
			end
		end

		for i=1,200 do
			local t,spellID = GetSpellBookItemInfo(i,"pet")
			if not t then
				break
			end
			if spellID then
				self.cache.charge[spellID] = {GetSpellCharges(spellID)}
				self.cache.cooldown[spellID] = {GetSpellCooldown(spellID)}
				self.cache.usable[spellID] = {IsUsableSpell(spellID)}
				self.cache.known[spellID] = true
			end
		end
		for spellID in pairs(externSpellIDs) do
			if tonumber(spellID) then
				self.cache.charge[spellID] = {GetSpellCharges(spellID)}
				self.cache.cooldown[spellID] = {GetSpellCooldown(spellID)}
				self.cache.usable[spellID] = {IsUsableSpell(spellID)}
				if IsPlayerSpell(spellID) then
					self.cache.known[spellID] = true
				end
			end
		end
		changed = nil
		scanT = t
		-- self:Print(self.cache.usable[100780][1])
	end
	function Cache:ScanSpell(t,guids,units)
		if not scanT or t-scanT>self.interval.spell then
			Cache:ScanAllSpell(t)
		end
	end
	function Cache:GetSpellCooldown(spellID)
		local t = GetTime()
		if changed or not scanT then
			self:ScanAllSpell(t)
		end
		if not self.cache.cooldown[spellID] then
			externSpellIDs[spellID] = true
			self:ScanAllSpell(t)
		end
		local know, usable
		know = self.cache.known[spellID] and true or false
		usable = self.cache.usable[spellID] and self.cache.usable[spellID][1] or false
		local charges, maxCharges, cstart, cduration = unpack(self.cache.charge[spellID] or {})
		local start, duration, enable = unpack(self.cache.cooldown[spellID] or {})
		local cd = enable~=1 and 300 or start==0 and 0 or (duration - (t - start))
		if cd < 0 then cd = 0 end
		local charge
		if not charges then
			charge = 0
		elseif charges<maxCharges then
			charge = (t - cstart)/cduration + charges
		else
			charge=maxCharges
		end
		return cd, charge, know, usable
	end
	function Cache:ScanGCD(t,guids,units)
		local start,duration = GetSpellCooldown(61304)
		if start ~= 0 then
		  self.cache.gcd.duration = duration
		  self.cache.gcd.start = start
		  -- self:Print(duration)
	  end
	end

	function Cache:ScanCasting(t,guids,unit)
		self.cache.casting.isArray = true
		local name, subText, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo("player")
		local data = self.cache.castStartTo.lastplayer
		if endTime and endTime/1000-t<0.2 then
			if data and data.spellId then
				local startName = GetSpellInfo(data.spellId)
				if startName == name then
					local cache = {t=t}
					cache.guid = data.guid
					cache.spellId = data.spellId
					tinsert(self.cache.casting,cache)
				end
			end
		end
	end
end

-- Specialization
do
	local scanT
	local changed
	local id2info
	function Cache:InitializeSpecId2Info()
		id2info = {}
		for i=1,1000 do
			local v = {GetSpecializationInfoByID(i)}
			if v[1] then
				id2info[i] = v
			end
		end
	end
	function Cache:OnSpecChanged(event)
		changed = true
	end
	function Cache:ScanSpec(t,guids,units)
		if not scanT or t-scanT>self.interval.spec or changed then
			if guids then
				for guid,gt in pairs(guids) do
					if band(gt,0x10)~=0 then
						local spec = AirjHack:ObjectInt(guid,0x10E0)
						self.cache.spec[guid] = spec
					end
				end
			end
			scanT = t
		end
	end
	function Cache:GetSpecInfo(guid)
		if not guid then return end
		if not id2info then self:InitializeSpecId2Info() end
		local spec = self.cache.spec[guid]
		if not spec then return end
		return unpack(id2info[spec] or {})
	end
end

--Unit Exists
do
	local scanT
	local changed
	function Cache:ScanExists(t,guids,units)
		if units then
			if not scanT or t-scanT>self.interval.exists or changed then
				-- self:Print("ScanExists")
				wipe(self.cache.exists)
				local pguid = self:PlayerGUID()
				if guids then
					for guid in pairs(guids) do
						self.cache.exists[guid] = {true,AirjHack:UnitCanAttack(pguid,guid),AirjHack:UnitCanAssist(pguid,guid)}
					end
				end
				scanT = t

				-- local checked = {}
				-- for i,unit in ipairs(units) do
				-- 	local guid = UnitGUID(unit)
				-- 	if guid and guids[guid] and not checked[guid] then
				-- 		checked[guid] = true
				-- 		self.cache.exists[guid] = {UnitExists(unit),UnitCanAttack("player",unit),UnitCanAssist("player",unit)}
				-- 	end
				-- end
				-- scanT = t
			end
		end
	end

	function Cache:GetExists(guid,unit)
		local e,ha,he unpack(self.cache.exists[guid] or {})
		if not e and unit then
			self.cache.exists[guid] = {UnitExists(unit),UnitCanAttack("player",unit),UnitCanAssist("player",unit)}
		end
		return unpack(self.cache.exists[guid] or {})
	end

end

--flag
do
	function Cache:FlagIsSet(guid,mask)
		local flag = self.cache.flag[guid]
		flag = flag and flag[1]
		if not flag then return end
		return bit.band(flag,mask)~=0
	end

end
