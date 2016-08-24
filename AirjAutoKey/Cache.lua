local C = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyCache", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local band = bit.band

function C:GetUnitList()
	local unitlist = {"player","target","mouseover","focus","pet"}
	for i=1,40 do
		tinsert(unitlist,guid)
	end
	for i=1,4 do
		tinsert(unitlist,guid)
	end
	return unitlist
end

function C:GetUnitGUIDs()
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
function C:ScanHealth()
	local guids = self:GetUnitGUIDs()
	if guids then
		local cache = {time=GetTime()}
		tinsert(self.cache.health,cache,1)
		for i,guid in ipairs(guids) do
			local health = AirjHack:GetObjectOffsetInt(guid,0xf0)
			local maxHealth = AirjHack:GetObjectOffsetInt(guid,0x110)
			local power = AirjHack:GetObjectOffsetInt(guid,0xf8)
			local maxPower = AirjHack:GetObjectOffsetInt(guid,0x118)
			cache[guid]={
				health=health,
				maxHealth=maxHealth,
				power=power,
				maxPower=maxPower
			}
		end
	end
end
