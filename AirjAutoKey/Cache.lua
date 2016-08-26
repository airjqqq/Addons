local Core = AceAddon:GetAddon("AirjAutoKey")
local Cache = Core:NewModule("AirjAutoKeyCache", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local AirjHack = AceAddon:GetAddon("AirjHack")

local band = bit.band


function Cache:OnInitialize()
	--self.cache.name[key]={t=GetTime(),k=v}
	self.cache = setmetatable({},{
		__index=function(t,k)
			t[k]={}
			return t[k]
	})
end

function Cache:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self:RegisterEvent("UNIT_HEALTH",self.OnHealthChanged,self)
	self:RegisterEvent("UNIT_MAXHEALTH",self.OnHealthChanged,self)
	self:RegisterEvent("UNIT_HEAL_PREDICTION",self.OnHealthChanged,self)
	self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED",self.OnHealthChanged,self)
	self:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED",self.OnHealthChanged,self)
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN",self.OnCoolDownChanged,self)
	self:RegisterEvent("SPELL_UPDATE_CHARGES",self.OnCoolDownChanged,self)
	self:RegisterEvent("SPELL_UPDATE_USABLE",self.OnCoolDownChanged,self)

  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectChanged,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectChanged,self)

	self.interval = {
		buffs = 1,
		debuffs = 1,
		health = 1,
		position = 0.2,
		spell = 10,
	}
	self.scanTimer = self:ScheduleRepeatingTimer(function()
		local units = self:GetUnitList()
		local guids = self:GetUnitGUIDs()
		local t = GetTime()
		self:ScanAuras(t,guids,units)
		self:ScanHealth(t,guids,units)
		self:ScanPosition(t,guids,units)
		self:ScanSpell(t,guids,units)
	end,0.01)

	self.recoverDuration = {
		buffs = 300,
		debuffs = 60,
		health = 30,
		position = 10,
		spell = 300,
	}
	self.recoverTimer = self:ScheduleRepeatingTimer(function()
		local t = GetTime()
		for k,v in pairs(self.cache) do
			self:Recover(v,t,self.recoverDuration[k] or 300)
		end
	end,1)
end

function Cache:OnDisable()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("UNIT_SPELLCAST_SENT")
	self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
end

function Cache:Call(fcnName,...)
	local key = fcnName
	for i,v in ipairs({...}) do
		key = key.."-"..v
	end
	local toRet = self.cache.call[key]
	local t = GetTime()
	if toRet and toRet.t == t then
		return unpack(toRet)
	else
		toRet = {_G[fcnName](...)}
		toRet.t = t
		self.cache.call[key]=toRet
		return unpack(toRet)
	end
end

--util functions
do
	function Cache:Recover(data,t,duration)
		for k,v in pairs(data) do
			if v.t then
				if t-v.t > duration then
					data[k] = nil
				end
			else
				if type(v) == "table" then
					self:Recover(v,t,duration)
				end
			end
		end
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
		return list
		self.unitListCache=list
	end


	local name2unit = {}
	function AirjAutoKey:FindUnitByName(name)
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
	function AirjAutoKey:FindUnitByGUID(guid)
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
					toRet[guid] = true
				end
			end
		end
		self.guidListCache = toRet
		return toRet
	end
end

--events
do
	function Cache:UNIT_SPELLCAST_SENT(event,unitID, spell, rank, target, lineID)
		if unitID == "player" then
			local t = GetTime()
			local _, _, _, _, _, _, spellID = GetSpellInfo(spell)
	    local guid,unit
	    if spellId then
	      guid = AirjAutoKeyCore:GetLastGUIDBySpellId(spellId)
	      unit = guid and self:FindUnitByGUID(guid)
	    end
	    if not unit or UnitName(unit) ~= target then
	      unit = self:FindUnitByName()
	      guid = unit and UnitGUID(unit)
	    end
			self.cache.castSend[spellId]={
				t=t,
				guid=guid,
			}
	    self.cache.line2guid[lineID]={
				t=t,
				guid=guid,
			}
		end
	end

	function Cache:UNIT_SPELLCAST_FAILED(event,unitID, spell, rank, lineID, spellID)
		if unitID == "player" then
	    local data = self.cache.line2guid[lineID]
			if data then
				local guid = data.guid
		    if guid then
		      self.cache.serverRefused[guid] = {
						t=data.t,
					}
		    end
			end
	  end
	end

	function Cache:COMBAT_LOG_EVENT_UNFILTERED(...)
		local t = GetTime()
		local list = Cache.combatLogEventList
		for i,v in ipairs(list) do
			local events = v.events
			local fcn = v.fcn
			if events and fcn then
				local passed = events[event]
				if not passed then
					for e in ipairs(events) do
						if strfind(event,e) then
							passed = true
							break
						end
					end
				end
				if passed then
					fcn(t,...)
				end
			end
			-- body...
		end
	end

	Cache.combatLogEventList = {
		{
			name = "damage",
			events = {
				_DAMAGE=true,
				_MISSED=true,
			},
			fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
				local damage = 0
				local rawDamage = 0
				local args

				if strfind(event,"SWING_") then
					args= {spellId,spellName,spellSchool,...}
					spellId="Swing"
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

				self.cache.damageTo[sourceGUID]=self.cache.damageTo[sourceGUID] or {}
				local to = self.cache.damageTo[sourceGUID]
				to[spellId]=to[spellId] or {}
				to[spellId].last={t=localtime,value=damage,guid=destGUID}
				to[spellId][destGUID]={t=localtime,value=damage}
				to.array = to.array or {}
				tinsert(to.array,{t=localtime,value=damage,guid=destGUID,spellId=spellId},1)

				self.cache.damageBy[destGUID]=self.cache.damageBy[destGUID] or {}
				local by = self.cache.damageBy[destGUID]
				by[spellId]=by[spellId] or {}
				by[spellId].last={t=localtime,value=damage,guid=sourceGUID}
				by[spellId][sourceGUID]={t=localtime,value=damage}
				by.array = by.array or {}
				tinsert(by.array,{t=localtime,value=damage,guid=sourceGUID,spellId=spellId},1)

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
				heal = heal + (amount or 0)+(overhealing or 0)+(absorbed or 0)
				rawHeal = (amount or 0)
				sourceGUID = sourceGUID or "Unknown"
				destGUID = destGUID or "Unknown"
				spellId = spellId or "Unknown"

				self.cache.healTo[sourceGUID]=self.cache.healTo[sourceGUID] or {}
				local to = self.cache.healTo[sourceGUID]
				to[spellId]=to[spellId] or {}
				to[spellId].last={t=localtime,value=heal,guid=destGUID}
				to[spellId][destGUID]={t=localtime,value=heal}
				to.array = to.array or {}
				tinsert(to.array,{t=localtime,value=heal,guid=destGUID,spellId=spellId},1)

				self.cache.healBy[destGUID]=self.cache.healBy[destGUID] or {}
				local by = self.cache.healBy[destGUID]
				by[spellId]=by[spellId] or {}
				by[spellId].last={t=localtime,value=heal,guid=sourceGUID}
				by[spellId][sourceGUID]={t=localtime,value=heal}
				by.array = by.array or {}
				tinsert(by.array,{t=localtime,value=heal,guid=sourceGUID,spellId=spellId,periodic=periodic},1)

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
				if UnitGUID("player") == sourceGUID or UnitGUID("pet") == sourceGUID then
					destGUID = destGUID or "Unknown"
					spellId = spellId or "Unknown"
					local data = self.cache.castSend[spellId]
					local guid
					if data.t and localtime-data.t<1 then
						guid = data.guid
					end
					guid = guid or destGUID
					self.cache.castStartTo[spellId]=self.cache.castStartTo[spellId] or {}
					local to = self.cache.castStartTo[spellId]
					to.last={t=localtime,guid=guid}
					to[guid]={t=localtime}
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

--health
do
	function Cache:OnHealthChanged(event,unit)
		local guid = UnitGUID(unit)
		if guid then
			self.cache.health[guid].changed = true
		end
	end

	function Cache:ScanOnesHealth(t,guid)
		self.cache.health[guid]=self.cache.health[guid] or {}
		local cache = self.cache.health
		cache[guid]=cache[guid] or {}
		local array = cache[guid]
		local current = {AirjHack:UnitHealth(guid)}
		current.t = t
		tinsert(array,current,1)
		array.changed = nill
		array.lastT = t
		return array
	end

	function Cache:ScanHealth(t,guids,units)
		if guids then
			for guid in ipairs(guids) do
				local array = self.cache.health[guid]
				if not array or t - array.lastT>interval.health then
					self:ScanOnesHealth(t,guid)
				end
			end
		end
	end

	function Cache:GetHealth(guid)
		local array = self.cache.health[guid]
		if not array or array.changed then
			array = self:ScanOnesHealth(GetTime(),guid)
		end
		return array[1]
	end
	function Cache:GetHealthArray(guid)
		local array = self.cache.health[guid]
		if not array or array.changed then
			array = self:ScanOnesHealth(GetTime(),guid)
		end
		return array
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
				if guid and guids[guid] then
					local data = self.cache.buffs[guid]
					if not data or t - data.t>interval.buffs then
						Cache:ScanOnesBuffs(t,guid,unit)
					end
					data = self.cache.debuffs[guid]
					if not data or t - data.t>interval.debuffs then
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
			if not mine or caster == "player" then
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
		if not debuffs or debuffs.changed then
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
			if not mine or caster == "player" then
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
		if not scanT or t-scanT>interval.position then
			wipe(self.cache.position)
			local px,py,pz,pf = AirjHack:Position("player")
			local pi = math.pi
			if guids then
				for guid in ipairs(guids) do
					local x,y,z,f,s = AirjHack:Position(guid)
					local dx,dy,dz = x-px, y-py, z-pz
					local distance = sqrt(dx*dx,dy*dy,dz*dz)
					self.cache.position[guid]={x,y,z,f,distance,s}
				end
			end
			scanT = t
		end
	end

	function Cache:ScanSpeed(t,guids,unit)
		local cache = {t=t}
		tinsert(self.cache.speed,cache,1)
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
	function Cache:OnCoolDownChanged(event)
		changed = true
	end
	function Cache:ScanAllSpell(t)
		wipe(self.cache.charge)
		wipe(self.cache.cooldown)
		wipe(self.cache.usable)
		for i=1,200 do
			local name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(i, "spell")
			if not name then
				break
			end
			self.cache.charge[spellID] = {GetSpellCharges(spellID)}
			self.cache.cooldown[spellID] = {GetSpellCooldown(spellID)}
			self.cache.usable[spellID] = {IsUsableSpell(spellID)}
		end

		for i=1,200 do
			local name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(i, "pet")
			if not name then
				break
			end
			self.cache.charge[spellID] = {GetSpellCharges(spellID)}
			self.cache.cooldown[spellID] = {GetSpellCooldown(spellID)}
			self.cache.usable[spellID] = {IsUsableSpell(spellID)}
		end
		changed = nil
		scanT = t
	end
	function Cache:ScanSpell(t,guids,units)
		if not scanT or t-scanT>interval.spell then
			Cache:ScanAllSpell(t)
		end
	end
	function Cache:GetSpellCooldown(spellID)
		local t = GetTime()
		if changed or not scanT then
			self:ScanAllSpell(t)
		end
		local know, usable = false, false
		if self.cache.usable[spellID] then
			know = true
			usable = unpack(self.cache.usable[spellID]) and true or false
		end
		local charges, maxCharges, cstart, cduration = unpack(self.cache.charge[spellID] or {})
		local start, duration, enable = unpack(self.cache.cooldown[spellID] or {})
		local cd = not start and 300 or enable and 0 or (duration - (t - start))
		local charge
		if not charges then
			charge = 0
		elseif charges<maxCharges then
			charge = (t - start)/duration + charges
		else
			charge=maxCharges
		end
		return cd, charge, know, usable
	end
end
