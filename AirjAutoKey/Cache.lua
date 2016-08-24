local Cache = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyCache", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
AirjAutoKeyCache = Cache
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
end

function Cache:OnDisable()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("UNIT_SPELLCAST_SENT")
	self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
end

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
		name = "swing",
		events = {
			SWING_DAMAGE=true,
			SWING_MISSED=true,
		},
		fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,...)
			local damage = 0
			if event=="SWING_DAMAGE" then
				local amount	overkill	school	resisted	blocked	absorbed = ...
				damage = damage + (amount or 0) + (overkill or 0) + (resisted or 0) + (blocked or 0) + (absorbed or 0)
			else
				local missType	isOffHand	amountMissed = ...
				damage = damage + (amountMissed or 0)
			end
			self.cache.swingBy[destGUID]=self.cache.swingBy[destGUID] or {}
			self.cache.swingBy[destGUID].last={t=localtime,value=damage,guid=sourceGUID}
			self.cache.swingBy[destGUID][sourceGUID]={t=localtime,value=damage}
			self.cache.swingTo[sourceGUID]=self.cache.swingTo[sourceGUID] or {}
			self.cache.swingTo[sourceGUID].last={t=localtime,value=damage,guid=destGUID}
			self.cache.swingTo[sourceGUID][destGUID]={t=localtime,value=damage}
		end
	},
	{
		name = "spell",
		events = {
			SWING_DAMAGE=true,
			SWING_MISSED=true,
		},
		fcn = function(localtime,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,...)
			local damage = 0
			if event=="SWING_DAMAGE" then
				local amount	overkill	school	resisted	blocked	absorbed = ...
				damage = damage + (amount or 0) + (overkill or 0) + (resisted or 0) + (blocked or 0) + (absorbed or 0)
			else
				local missType	isOffHand	amountMissed = ...
				damage = damage + (amountMissed or 0)
			end
		end
	},
}

	if (strfind(event, "SPELL_DAMAGE") or strfind(event, "SPELL_MISSED")) and (UnitGUID("player") == sourceGUID or UnitGUID("pet") == sourceGUID)  then
		local spellName = select(2,...)
		if spellName then
			if spellName == "刀扇" or spellName == "剑刃乱舞" then
				if GetTime() -( self.daoshanTimestamp or 0 ) <0.9 then
					self.daoshanCnt =  self.daoshanCnt + 1
				else
					self.daoshanCnt = 1
				end
				self.daoshanTimestamp = GetTime()
			end
			self.aoeSpellHit[spellName] = self.aoeSpellHit[spellName] or {}
			self.aoeSpellHit[spellName].guids  =  self.aoeSpellHit[spellName].guids or {}
			if GetTime() -( self.aoeSpellHit[spellName].timestamp or 0 ) < 0.9 then
			else
				wipe(self.aoeSpellHit[spellName].guids)
				self.aoeSpellHit[spellName].timestamp = GetTime()
			end
			self.aoeSpellHit[spellName].guids[destGUID] = GetTime()
		end
	end


	-- damage stuff
	if strfind(event, "_DAMAGE") and destGUID then
		local amount
		local offset
		if strfind(event, "SWING") then
			offset = 0
		else
			offset = 3
		end
		local arg1 = select(1+offset,...)
		amount = (type(arg1)=="number" and arg1 or 0) + (select(4+offset,...) or 0) + (select(5+offset,...) or 0) + (select(6+offset,...) or 0)
		self.damageList[destGUID] = self.damageList[destGUID] or {}
		self.damageList[destGUID][timestamp] = (self.damageList[destGUID][timestamp] or 0) + amount

		local spellName = select(2,...)
		if self:IsMeleeSpell(spellName) then
			self.damageListMelee[destGUID] = self.damageListMelee[destGUID] or {}
			self.damageListMelee[destGUID][timestamp] = (self.damageListMelee[destGUID][timestamp] or 0) + amount
		end
	end
	if strfind(event, "SWING_DAMAGE") and destGUID then
		local amount
		local offset
		if strfind(event, "SWING") then
			offset = 0
		else
			offset = 3
		end
		local arg1 = select(1+offset,...)
		amount = (type(arg1)=="number" and arg1 or 0) + (select(4+offset,...) or 0) + (select(5+offset,...) or 0) + (select(6+offset,...) or 0)
		self.damageListSwing[destGUID] = self.damageListSwing[destGUID] or {}
		self.damageListSwing[destGUID][timestamp] = (self.damageListSwing[destGUID][timestamp] or 0) + amount
		self.damageListMelee[destGUID] = self.damageListMelee[destGUID] or {}
		self.damageListMelee[destGUID][timestamp] = (self.damageListMelee[destGUID][timestamp] or 0) + amount
	end
	if (strfind(event, "_MISSED") and (select(1,...)=="ABSORB")) and destGUID then
		local amount
		local offset
		if strfind(event, "SWING") then
			offset = 0
		else
			offset = 3
		end
		amount = (select(3 + offset,...) or 0)
		self.damageList[destGUID] = self.damageList[destGUID] or {}
		if type(amount) ~= "number" then
			amount = 0;
		end

		self.damageList[destGUID][timestamp] = (self.damageList[destGUID][timestamp] or 0) + amount
	end

	--swing stuff
	if strfind(event, "SWING") and sourceGUID then
		self.swingTime[sourceGUID] = timestamp
	end

	-- channel stuff
	if strfind(event, "_DAMAGE") and (UnitGUID("player") == sourceGUID or UnitGUID("pet") == sourceGUID)  then
		local spellName = select(2,...)
		local spellId = select(1,...)
		if spellName then
			local channelName = UnitChannelInfo("player")
			if spellName == channelName then
				self.channelTime[spellName] = timestamp
			--	print("吸取灵魂",GetTime())
			end
			if spellId == 15407 then
				self.channelTime[spellName] = timestamp
			--	print("吸取灵魂",GetTime())
			end
		end
	end
	--cast success stuff
	if (strfind(event, "_CAST_SUCCESS")) and (UnitGUID("player") == sourceGUID or UnitGUID("pet") == sourceGUID) then
		local spellName = select(2,...)
		if spellName then
			if not destGUID or destGUID == "" then
				destGUID = self.lastSentList[spellName]
			end
			if not destGUID then destGUID = UnitGUID("player") end
			if destGUID then
				self.castSuccessList[spellName] = self.castSuccessList[spellName] or {}
				self.castSuccessList[spellName][destGUID] = timestamp
--				print("castSuccessList",spellName)
			end
			self.allCastSuccessList[spellName] = timestamp
		end

		if self.debugmode then
			if self.lastSpellIndex ~= spellIndex then
				self:Print(GetTime(),"Casted --------- ",spellName)
				self.lastSpellIndex = spellIndex
			end
		end
	end

	--cast start stuff
	if (strfind(event, "_CAST_START")) and (UnitGUID("player") == sourceGUID or UnitGUID("pet") == sourceGUID) then
		local spellName = select(2,...)
		if not destGUID or destGUID == "" then
			destGUID = self.lastSentList[spellName]
		end
--		print(spellName,destGUID,UnitGUID("target"))
		if destGUID and spellName then
			self.castStartList[spellName] = self.castStartList[spellName] or {}
			self.castStartList[spellName][destGUID] = timestamp
		end
		self.allCastStartList[spellName] = timestamp
		self.castStartGUID = destGUID
		self.lastCastUnit=self.lastCastSendUnit
		self.lastCastGUID=self.lastCastSendGUID
--		print(spellName,self.lastCastUnit,self.lastCastGUID)
	end

	-- aura stuff
	if (strfind(event, "_AURA_APPLIED") or strfind(event, "_AURA_REFRESH")) and (UnitGUID("player") == sourceGUID or UnitGUID("pet") == sourceGUID) then
		local spellName = select(2,...)
		self.auraList[spellName] = self.auraList[spellName] or {}
		self.auraList[spellName][destGUID] = timestamp

		self.dotList[spellName] = self.dotList[spellName] or {}
		self.dotList[spellName][destGUID] = timestamp
	end
	if (strfind(event, "_AURA_BROKEN") or strfind(event, "_AURA_REMOVED")) and (UnitGUID("player") == sourceGUID or UnitGUID("pet") == sourceGUID) then
		local spellName = select(2,...)
		if destGUID and spellName then
			self.auraList[spellName] = self.auraList[spellName] or {}
			self.auraList[spellName][destGUID] = nil
			self.dotList[spellName] = self.dotList[spellName] or {}
			self.dotList[spellName][destGUID] = nil
		end
	end
	--dot stuf

	if (strfind(event, "SPELL_PERIODIC_DAMAGE")) and (UnitGUID("player") == sourceGUID or UnitGUID("pet") == sourceGUID) then
		local spellName = select(2,...)
		self.dotList[spellName] = self.dotList[spellName] or {}
		self.dotList[spellName][destGUID] = timestamp
	end

	-- dotPower stuff
--	if (strfind(event, "_CAST_SUCCESS") or strfind(event, "_AURA_APPLIED") and not strfind(event, "_AURA_APPLIED_DOSE") or strfind(event, "_AURA_REFRESH")) and UnitGUID("player") == sourceGUID then
--		local spellName = select(2,...)
--		local spellid = select(1,...)
--		if spellid == 119678 or spellid == 86213 then
--			spellName = "痛楚"
--		end
--		if destGUID and spellName then
--			self.powerList[spellName] = self.powerList[spellName] or {}
--			self.powerList[spellName][destGUID] = {timestamp = timestamp, power = self.CurrentPower()}
--		end
--	end
--	if (strfind(event, "_AURA_BROKEN") or strfind(event, "_AURA_REMOVED")) and UnitGUID("player") == sourceGUID then
--		local spellName = select(2,...)
--		if destGUID and spellName then
--			self.powerList[spellName] = self.powerList[spellName] or {}
--			self.powerList[spellName][destGUID] = nil
--		end
--	end

	if (strfind(event, "_ENERGIZE") and sourceGUID == UnitGUID("player")) then
		local spellName = select(2,...)
		if spellName == "刺客的尊严" then
			self.lastZunYan = GetTime()
		end
	end
	if (strfind(event, "_AURA_BROKEN_SPELL")) then
		local spellList = {
			["变形术"] = true,
			["致盲"] = true,
			["凿击"] = true,
			["闷棍"] = true,
		}
		local spellName = select(2,...)
		if spellList[spellName] then
			local brokeName = select(5,...)
			local type = select(7,...)
			local pre = ""
			if sourceGUID == UnitGUID("player") then
				pre = "YOU_______"
			end
			if type == "DEBUFF" then
				print(pre.."BROKEN:"..spellName.." of "..destName.." by "..sourceName.."'s "..brokeName)
			end
		end
	end


	--cas


	-- dr
	if (strfind(event, "_AURA_APPLIED") or strfind(event, "_AURA_REFRESH")) then
		local spellId = select(1,...)
		local type = select(4,...)
		local cat = self.drSpells[spellId]
		if type == "DEBUFF" and cat then
			self.drList[destGUID] = self.drList[destGUID] or {}
			local data = self.drList[destGUID][cat]
			local count
			if data and data.timestamp > timestamp then
				count = data.count + 1
			else
				count = 1
			end
			self.drList[destGUID][cat] = {timestamp = timestamp+18.5, count = count}
		end
	end
	if (strfind(event, "_AURA_BROKEN") or strfind(event, "_AURA_REMOVED"))then
		local spellId = select(1,...)
		local type = select(4,...)
		local cat = self.drSpells[spellId]
		if type == "DEBUFF" and cat then
			self.drList[destGUID] = self.drList[destGUID] or {}
			local data = self.drList[destGUID][cat]
			local count
			if data and data.timestamp > timestamp then
				count = data.count
			else
				count = 1
			end
			self.drList[destGUID][cat] = {timestamp = timestamp+18.5, count = count}
		end
	end
end


function Cache:GetUnitList()
	local subUnit = {"","target","pet","pettarget"}
	local unitCheckList = {"player","target","targettarget","pet","pettarget","focus","focustarget","mouseover","mouseovertarget"}
	for i = 1,5 do
		tinsert(unitCheckList,"arena"..i)
	end
	if IsInRaid() then
		for i = 1,GetNumGroupMembers() do
			for _,sub in pairs(subUnit) do
				tinsert(unitCheckList,"raid"..i..sub)
			end
		end
	else
		for _,sub in pairs(subUnit) do
			--tinsert(unitCheckList,"player"..sub)
			for i = 1,GetNumGroupMembers() do
				tinsert(unitCheckList,"party"..i..sub)
			end
		end
	end
	return unitCheckList
end


local name2unit = {}
function AirjAutoKey:FindUnitByName(name)
	local unit = name2unit[name]
	if unit and UnitName(unit)==name then
		return unit
	end
	for _,u in ipairs(self.unitList) do
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

function Cache:GetUnitGUIDs()
	local toRet = {}
	if AirjHack and AirjHack:HasHacked() then
		local objects = AirjHack:GetObjects()
		for guid,type in pairs(objects) do
			if band(type,0x08)~=0 then
				tinsert(toRet,guid)
			end
		end
		return toRet
	else
		-- local units=self:GetUnitList()
		-- for i,unit in ipairs(units) do
		-- 	local guid=UnitGUID(unit)
		-- 	if guid then
		-- 		tinsert(toRet,guid)
		-- 	end
		-- end
		-- return toRet
	end
end
function Cache:ScanHealth()
	local guids = self:GetUnitGUIDs()
	if guids then
		local cache = {time=GetTime()}
		tinsert(self.cache.health,cache,1)
		for i,guid in ipairs(guids) do
			local health = AirjHack:GetObjectOffsetInt(guid,0xf0)
			local maxHealth = AirjHack:GetObjectOffsetInt(guid,0x110)
			cache[guid]={
				health=health,
				maxHealth=maxHealth,
			}
		end
	end
end
