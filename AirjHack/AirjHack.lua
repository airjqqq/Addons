local mod = LibStub("AceAddon-3.0"):NewAddon("AirjHack", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"
AirjHack = mod

function mod:OnInitialize()
end

function mod:OnEnable()
  self.objectCache = {}
  self.eventTimer = self:ScheduleRepeatingTimer(function()
    self:CheckAndSendMessage()
  end,0.01)
end

function mod:OnDisable()
  self:CancelTimer(self.eventTimer)
end

local function HasHacked()
  return AirjUpdateObjects and type(AirjUpdateObjects) == "function" or false
end

function mod:CheckAndSendMessage()
  if not HasHacked() then return end
  local objects = mod:GetObjects()
  for guid, type in pairs(objects) do
    if self.objectCache[guid] then
      self.objectCache[guid] = nil
    else
      self:SendMessage("AIRJ_HACK_OBJECT_CREATED",guid,type)
    end
  end
  for guid, type in pairs(self.objectCache) do
    self:SendMessage("AIRJ_HACK_OBJECT_DESTROYED",guid,type)
  end
  self.objectCache = objects
end


function mod:HasHacked()
  return HasHacked()
end

function mod:GetObjects()
  if not HasHacked() then return end
	local objNumber = AirjUpdateObjects()
	local toRet = {}
	for i = 0,objNumber do
		local guid, type = AirjGetObjectGUID(i)
		if guid and type then
			toRet[guid] = type
		end
	end
	return toRet, objNumber
end

function mod:GetAreaTriggerBySpellName(spellNames,objects)
  if not HasHacked() then return end
	objects = objects or self:GetObjects()
	local toRet = {}
	for guid,oType in pairs(objects) do
		if bit.band(oType,0x100)~=0 then
			local spellId = AirjGetObjectDataInt(guid,0x88)
			local name = GetSpellInfo(spellId)
			if not spellNames or spellNames[name] then
				toRet[guid] = {
					name = name,
					spellId = spellId,
				}
			end
		end
	end
	return toRet
end

function mod:UnitGUID (unit)
  if not HasHacked() then return end
  return AirjGetObjectGUIDByUnit(unit)
end

function mod:Position(key)
  if not HasHacked() then return end
  if key == nil then return end
	local starts = {
		Player = true,
		Creature = true,
		GameObject = true,
		AreaTrigger = true,
	}
	local subs = {string.split("-",key)}
	if not starts[subs[1]] then
		key = UnitGUID(key)
	end

  local x,y,z,f = AirjGetObjectPosition(key)
  if not x then return nil end
	return -y,x,z,f
end

function mod:Target(guid)
  if not HasHacked() then return end
  return AirjTargetByGUID(guid)
end

function mod:Focus(guid)
  if not HasHacked() then return end
  return AirjFocusByGUID(guid)
end

function mod:Interact(guid)
  if not HasHacked() then return end
  return AirjInteractByGUID(guid)
end

function mod:GetCamera()
    if not HasHacked() then return end
    local r,f,t,x,y,z,h = AirjGetCamera()
    if not x then return nil end
  	return r,f,t,-y,x,z,h
end
