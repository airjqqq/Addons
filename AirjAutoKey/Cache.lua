-- local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):NewAddon("AirjCache", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local AirjHack = LibStub("AceAddon-3.0"):GetAddon("AirjHack")
AirjCache = Cache

local band = bit.band


function Cache:OnInitialize()
	--self.cache.name[key]={t=GetTime(),k=v}
	self.cache = setmetatable({},{
		__index=function(t,k)
			t[k]=AirjUtil:NewFIFO(self.fifosize[k] or 1000)
			return t[k]
		end
	})
	self.interval = {
		buffs = 1,
		debuffs = 1,
		health = 0.2,
		position = 0,
		spell = 10,
		spec = 5,
		exists = 1,
	}
	self.recoverDuration = {
		line2guid = 5,
		myhealth = 30,
		casting = 30,
	}
	self.fifosize = {

	}
end

function Cache:OnEnable()

	-- do return end
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
	self:RegisterEvent("PLAYER_TARGET_CHANGED")

  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectChanged,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectChanged,self)

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
	self:ScheduleTimer(function()
	  self.mainTimerProtectorTimer = self:ScheduleRepeatingTimer(function()
	    if GetTime() - (self.lastScanPositionTime or 0) > 0.5 then
	      self:Print("RestartScanPositionTimer")
	      -- self.lastScanPositionTime = GetTime()
	      self:RestartScanPostionTimer()
	    end
	    if GetTime() - (self.lastScanHealthTime or 0) > 0.5 then
	      self:Print("RestartScanHealthTimer")
	      -- self.lastScanHealthTime = GetTime()
	      self:RestartScanHealthTimer()
	    end
	    -- if GetTime() - (self.lastRecoverTime or 0) > 2 then
	    --   self:Print("RestarRecovertTimer")
	    --   -- self.lastRecoverTime = GetTime()
	    --   self:RestarRecovertTimer()
	    -- end
	  end,0.1)
	end,5)
end

-- function Cache:RestarRecovertTimer()
-- 	if self.recoverTimer then
-- 		self:CancelTimer(self.recoverTimer,true)
-- 		self.recoverTimer = nil
-- 	end
-- 	self.lastRecoverTime=GetTime()
-- 	self.recoverTimer = self:ScheduleRepeatingTimer(function()
-- 		local t = GetTime()
--     self.lastRecoverTime=t
-- 		for k,v in pairs(self.cache) do
-- 			if self.recoverDuration[k] then
-- 				self:Recover(v,t,self.recoverDuration[k])
-- 			end
-- 		end
-- 	end,1)
-- end
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
	end,0.1)
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
	end,0.1)
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
	local guids = {}
	function Cache:UnitGUID(unit)
		return UnitGUID(unit)
		-- if not unit then return end
		-- local t = GetTime()
		-- if t~=lastT then
		-- 	lastT = t
		-- 	wipe(guids)
		-- end
		-- local guid = guids[unit]
		-- if guid == nil then
		-- 	guid = UnitGUID(unit)
		-- 	guids[unit] = guid
		-- 	return guid
		-- elseif guid == false then
		-- 	return nil
		-- else
		-- 	return guid
		-- end
	end
end

do

	local lastT
	local calls = {}
	local _G = _G
	function Cache:Call(fcnName,...)
		return _G[fcnName](...)
		-- local key = fcnName
		-- for i,v in ipairs({...}) do
		-- 	key = key.."-"..v
		-- end
		-- local t = GetTime()
		-- if t~=lastT then
		-- 	lastT = t
		-- 	wipe(calls)
		-- end
		-- local toRet = calls[key]
		-- if not toRet then
		-- 	toRet = {_G[fcnName](...)}
		-- 	calls[key] = toRet
		-- end
		-- return unpack(toRet,1,20)
	end
end

--util functions
do
	--[[
	local recoverd = 0
	local function recover(data,t,duration)
		-- if recoverd > 1000 then
		-- 	return
		-- end
		if data.isArray then
			for k,v in ipairs(data) do
				if type(v) == "table" then
					recoverd = recoverd + 1
					if v.t then
						if t-v.t > duration then
							tremove(data,k)
						end
					else
						recover(v,t,duration)
					end
				end
			end
		else
			for k,v in pairs(data) do
				if type(v) == "table" then
					recoverd = recoverd + 1
					if v.t then
						if t-v.t > duration then
							data[k] = nil
						end
					else
						recover(v,t,duration)
					end
				end
			end
		end
	end
	function Cache:Recover(data,t,duration)
		recoverd = 0
		recover(data,t,duration)
	end
	]]
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
				if band(type,0x28)~=0 then
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
	local lasttargetguid
	function Cache:PLAYER_TARGET_CHANGED(...)
		local guid = UnitGUID("target")
		if guid then
			self.cache.targeted:set({t=GetTime()},guid)
		end
		if lasttargetguid then
			self.cache.targeted:set({t=GetTime()},lasttargetguid)
		end
		lasttargetguid = guid
	end

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
				self.cache.castSend:push({t=t,guid=guid,spellId=spellID})
			end
				-- self:Print("UNIT_SPELLCAST_SENT",lineID)
			if lineID then
		    self.cache.line2guid:set({t=t,guid=guid},lineID)
			end
		end
	end

	function Cache:UNIT_SPELLCAST_FAILED(...)
		local event,unitID, spell, rank, lineID, spellID = ...
		if unitID == "player" then
			-- self:Print(GetTime(),...)
	    local data = self.cache.line2guid:get(lineID)
			if data then
				if GetTime() - data.t < 1 then
					local guid = data.guid
			    if guid then
						local current = self.cache.serverRefused:get(guid)
						local increase = lastErrorCode == 50 and 10 or 1
						if current and data.t-current.t<1 then
							current.count = current.count + increase
						else
							self.cache.serverRefused:set({
								t=data.t,
								count=increase,
							},guid)
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
			local data = self.cache.line2guid:get(lineID)
			if data then
				if GetTime() - data.t < 1 then
					local guid = data.guid
					if guid then
						-- self:Print("Server Confirmed",guid)
						self.cache.serverRefused:set(nil,guid)
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
					if not s then self:Print("error:",event,m) end
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
						self.cache.flag:set({sourceFlags,sourceFlags2,t=localtime},sourceGUID)
					end
					if destGUID then
						self.cache.flag:set({destFlags,destFlags2,t=localtime},destGUID)
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
					local isMagic = spellSchool and bit.band(spellSchool,0x7e) ~= 0 or false
					local damage = 0
					local rawDamage = 0
					local args
					local swing
					if spellId == 196917 then
						return
					end
					if strfind(event,"SWING_") then
						args = {spellId,spellName,spellSchool,...}
						swing = true
					else
						args= {...}
						swing = false
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
					local data = {sourceGUID=sourceGUID,t=localtime,value=damage,destGUID=destGUID,spellId=spellId,spellName=spellName,periodic=periodic,magic=isMagic,swing=swing}
					self.cache.damage:push(data)
					self.cache.healthChanged:set(true,destGUID)
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
					local data = {sourceGUID=sourceGUID,t=localtime,value=heal,destGUID=destGUID,spellId=spellId,spellName=spellName,periodic=periodic}
					self.cache.heal:push(data)
					self.cache.healthChanged:set(true,destGUID)
				end
			},
			{
				name = "castSuccess",
				events = {
					SPELL_CAST_SUCCESS=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
					local data = {sourceGUID=sourceGUID,t=localtime,value=heal,destGUID=destGUID,spellId=spellId,spellName=spellName}
					self.cache.castSuccess:push(data)
				end
			},
			{
				name = "castStart",
				events = {
					SPELL_CAST_START=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
					if sourceGUID == AirjCache:PlayerGUID() then
						local send = self.cache.castSend:find({spellId=spellId})
						local guid
						if send and send.t and localtime-send.t<1 then
							guid = send.guid
						end
						destGUID = guid or destGUID
					end
					local data = {sourceGUID=sourceGUID,t=localtime,value=heal,destGUID=destGUID,spellId=spellId,spellName=spellName}
					self.cache.castStart:push(data)
				end
			},
			{
				name = "aura+",
				events = {
					_AURA_APPLIED=true,
					_AURA_REFRESH=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,auraType)
					local data = {sourceGUID=sourceGUID,t=localtime,destGUID=destGUID,spellId=spellId,spellName=spellName,auraType=auraType}
					self.cache.aura:push(data)
					local cacheKey = auraType == "DEBUFF" and "debuffsChanged" or "buffChanged"
					if destGUID then
						self.cache[cacheKey]:set(true,destGUID)
					else
						dump(data)
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
					-- local data,key = self.cache.aura:find({
					-- 	sourceGUID = sourceGUID,
					-- 	destGUID = destGUID,
					-- 	spellId = spellId,
					-- })
					-- if key then
					-- 	self.cache.aura:set(nil,key)
					-- end
					local data = {sourceGUID=sourceGUID,t=localtime,destGUID=destGUID,spellId=spellId,spellName=spellName,auraType=auraType}
					self.cache.auraFade:push(data)
					local cacheKey = auraType == "DEBUFF" and "debuffsChanged" or "buffChanged"
					if destGUID then
						self.cache[cacheKey]:set(true,destGUID)
					else
						dump(data)
					end
				end
			},
			{
				name = "died",
				events = {
					UNIT_DIED=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,auraType)
					local ot = AirjHack:GetGUIDInfo(destGUID)
					if ot == "Creature" then
						self.cache.died:push({t=localtime,guid=destGUID})
					end
				end
			},
			{
				name = "interrupt",
				events = {
					_INTERRUPT=true,
				},
				fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,extraSpellId,extraSpellName,extraSchool)
					local data = {sourceGUID=sourceGUID,t=localtime,value=heal,destGUID=destGUID,spellId=spellId,spellName=spellName,extraSpellId=extraSpellId,extraSpellName=extraSpellName}
					self.cache.interrupt:push(data)
				end
			},
		}
	end
end

--health
do
	function Cache:OnHealthChanged(event,unit)
		local guid = unit and UnitGUID(unit)
		if guid then
			self.cache.healthChanged:set(true,guid)
		end
		if guid == self:PlayerGUID() then
			local data = {AirjHack:UnitHealth(guid)}
			data.t = GetTime()
			self.cache.myhealth:push(data)
		end
	end

	function Cache:ScanOnesHealth(t,guid)
		local data = {AirjHack:UnitHealth(guid)}
		data.t = t
		self.cache.health:set(data,guid)
		self.cache.healthChanged:set(nil,guid)
		return data
	end

	function Cache:ScanHealth(t,guids,units)
		for guid in pairs(guids) do
			local data = self.cache.health:get(guid)
			if not data or t - data.t>self.interval.health then
				self:ScanOnesHealth(t,guid)
			end
		end
	end

	function Cache:GetHealth(guid)
		local data = self.cache.health:get(guid)
		local changed = self.cache.healthChanged:get(guid)
		if not data or changed then
			data = self:ScanOnesHealth(GetTime(),guid)
		end
		return unpack(data or {})
	end
	function Cache:GetHealthArray()
		return self.cache.myhealth
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
	    local a=AirjGameTooltip or CreateFrame("GameTooltip","AirjGameTooltip",UIParent,"GameTooltipTemplate")
	    a:SetOwner(UIParent,"ANCHOR_NONE")
	    a:SetUnitBuff(unit,i)
			local tooltip = AirjGameTooltipTextLeft2:GetText()
			value.tooltip = tooltip
			data[i] = value
		end
		self.cache.buffs:set(data,guid)
		self.cache.buffChanged:set(nil,guid)
		return data
	end

	function Cache:ScanOnesDebuffs(t,guid,unit)
		local data = {t=t}
		for i=1,100 do
			local value = {UnitDebuff(unit,i)}
			if not value[1] then
				break
			end
	    local a=AirjGameTooltip or CreateFrame("GameTooltip","AirjGameTooltip",UIParent,"GameTooltipTemplate")
	    a:SetOwner(UIParent,"ANCHOR_NONE")
	    a:SetUnitDebuff(unit,i)
			local tooltip = AirjGameTooltipTextLeft2:GetText()
			value.tooltip = tooltip
			data[i] = value
		end
		self.cache.debuffs:set(data,guid)
		self.cache.debuffChanged:set(nil,guid)
		return data
	end

	function Cache:ScanAuras(t,guids,units)
		if units then
			for i,unit in ipairs(units) do
				local guid = UnitGUID(unit)
				if guid then
					local data = self.cache.buffs:get(guid)
					if not data or t - data.t>self.interval.buffs then
						Cache:ScanOnesBuffs(t,guid,unit)
					end
					data = self.cache.debuffs:get(guid)
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
		local buffs
		local changed = self.cache.buffChanged:get(guid)
		if not changed then
			buffs = self.cache.buffs:get(guid)
		end
		if not buffs then
			if not unit then unit = self:FindUnitByGUID(guid) end
			if unit then
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
		local debuffs
		local changed = self.cache.debuffChanged:get(guid)
		if not changed then
			debuffs = self.cache.debuffs:get(guid)
		end
		if not debuffs then
			if not unit then unit = self:FindUnitByGUID(guid) end
			if unit then
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
	local position = {}
	function Cache:ScanPosition(t,guids,units)
		if not scanT or t-scanT>self.interval.position then
			local px,py,pz,pf = AirjHack:Position(self:PlayerGUID())
			local pi = math.pi
			wipe(position)
			if guids then
				for guid,type in pairs(guids) do
					if bit.band(type,0x28)~=0 then
						local x,y,z,f,s = AirjHack:Position(guid)
						if x then
							local dx,dy,dz = x-px, y-py, z-pz
							local distance = sqrt(dx*dx+dy*dy+dz*dz)
							position[guid] = {x,y,z,f,distance,s}
							-- self.cache.position:set({x,y,z,f,distance,s},guid)
						end
					end
				end
			end
			scanT = t
		end
	end

	function Cache:ScanSpeed(t,guids,unit)
		self.cache.speed:push({t=t,value=GetUnitSpeed("player")})
	end

	function Cache:GetPosition(guid)
		return unpack(position[guid] or {})
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
	local spells = {}
	Cache.testspells = spells
	Cache.testspells1 = {}
	local knows = {}
	function Cache:ScanAllSpell(t)
		wipe(spells)
		wipe(knows)
		for i=1,200 do
			-- local name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(i, "spell")
			local t,spellID = GetSpellBookItemInfo(i,"spell")
			if not t then
				break
			end
			if spellID then
				local offId = select(7,GetSpellInfo(i, "spell"))
				local data = {
					charge = {GetSpellCharges(spellID)},
					cooldown = {GetSpellCooldown(spellID)},
					usable = {IsUsableSpell(spellID)},
				}
				spells[spellID] = data
				knows[spellID] = true
				if offId then
					local data = {
						charge = {GetSpellCharges(offId)},
						cooldown = {GetSpellCooldown(offId)},
						usable = {IsUsableSpell(offId)},
					}
					spells[offId] = data
					knows[offId] = true
				end
				Cache.testspells1[spellID] = data
			end
		end

		for i=1,200 do
			local t,spellID = GetSpellBookItemInfo(i,"pet")
			if not t then
				break
			end
			if spellID then
				local data = {
					charge = {GetSpellCharges(spellID)},
					cooldown = {GetSpellCooldown(spellID)},
					usable = {IsUsableSpell(spellID)},
				}
				spells[spellID] = data
				knows[spellID] = true
			end
		end
		for spellID in pairs(externSpellIDs) do
			if tonumber(spellID) then
				local data = {
					charge = {GetSpellCharges(spellID)},
					cooldown = {GetSpellCooldown(spellID)},
					usable = {IsUsableSpell(spellID)},
				}
				spells[spellID] = data
				if IsPlayerSpell(spellID) then
					knows[spellID] = true
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
		local data = spells[spellID]
		if not data then
			externSpellIDs[spellID] = true
			self:ScanAllSpell(t)
			data = spells[spellID]
		end
		if not data then return end
		local know = knows[spellID]
		local usable = data.usable[1] or false
		local charges, maxCharges, cstart, cduration = unpack(data.charge or {})
		local start, duration, enable = unpack(data.cooldown or {})
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

	function Cache:GetGCDInfo()
		if not self.cache.gcd.duration then
			self:ScanGCD(GetTime())
		end
		return self.cache.gcd.duration,self.cache.gcd.start
	end

	function Cache:ScanCasting(t,guids,units)
		local name, subText, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo("player")
		local data = self.cache.castStart:find({sourceGUID=self:PlayerGUID()})
		local cache = {t=t}
		if endTime and endTime/1000-t<0.3 then
			if data and data.spellId then
				local startName = GetSpellInfo(data.spellId)
				if startName == name or data.spellName == name then
					cache.guid = data.destGUID
					cache.spellId = data.spellId
				end
			end
			cache.spellName = name
			cache.endTime = endTime
			local lastData = self.cache.casting:geti()
			if not lastData or lastData.endTime ~= endTime or lastData.spellName ~= spellName then
				self.cache.casting:push(cache)
			end
		end
		for i,unit in pairs(units) do
			local name, subText, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit)
			if name then
				if endTime and endTime/1000-t<0.3 then
					local cache = {t=t}
					cache.spellName = name
					cache.endTime = endTime
					cache.guid = UnitGUID(unit)
					local lastData = self.cache.castingOthers:geti()
					if not lastData or lastData.endTime ~= endTime or lastData.spellName ~= spellName then
						self.cache.castingOthers:push(cache)
					end
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
		return id2info
	end
	function Cache:OnSpecChanged(event)
		changed = true
	end
	function Cache:ScanSpec(t,guids,units)
		if not scanT or t-scanT>self.interval.spec or changed then
			if guids then
				for guid,gt in pairs(guids) do
					if band(gt,0x10)~=0 then
						local spec = AirjHack:ObjectInt(guid,0x10D0)  --0x0320 0x0D80
						self.cache.spec:set(spec,guid)
					end
				end
			end
			scanT = t
		end
	end
	function Cache:GetSpecInfo(guid)
		if not guid then return end
		if not id2info then self:InitializeSpecId2Info() end
		local spec = self.cache.spec:get(guid)
		if not spec then return end
		return unpack(id2info[spec] or {})
	end
end

--Unit Exists
do
	local scanT
	local changed
	local exists = {}
	Cache.exists = exists
	function Cache:ScanExists(t,guids,units)
		if units then
			if not scanT or t-scanT>self.interval.exists or changed then
				-- self:Print("ScanExists")
				-- self.cache.exists:flush()
				wipe(exists)
				local pguid = self:PlayerGUID()
				if guids then
					for guid in pairs(guids) do
						-- self.cache.exists:set({true,AirjHack:UnitCanAttack(pguid,guid),AirjHack:UnitCanAssist(pguid,guid)},guid)
						exists[guid] = {true,AirjHack:UnitCanAttack(pguid,guid),AirjHack:UnitCanAssist(pguid,guid)}
					end
				end
				scanT = t
			end
		end
	end

	function Cache:GetExists(guid,unit)
		-- local data = self.cache.exists:get(guid)
		local data = exists[guid]
		if not data and unit then
			data = {UnitExists(unit),UnitCanAttack("player",unit),UnitCanAssist("player",unit)}
			-- self.cache.exists:set(data,guid)
			exists[guid] = data
		end
		return unpack(data or {})
	end
end

--flag
do
	function Cache:FlagIsSet(guid,mask)
		local flag = self.cache.flag:get(guid)
		flag = flag and flag[1]
		if not flag then return end
		return bit.band(flag,mask)~=0
	end
end
