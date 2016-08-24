local ServerCheck = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyServerCheck", "AceEvent-3.0")
local sendLineID
local sendUnit

function ServerCheck:OnInitialize()
  self.line2guid={}
  self.refused={}
end

function ServerCheck:OnEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
end

function ServerCheck:OnDisable()
	self:UnregisterEvent("UNIT_SPELLCAST_SENT")
	self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
end

function ServerCheck:IsPassed(guid,interval)
  local t = self.refused[guid]
  if not t then return true end
  t = GetTime()-t
  return t > (interval or 0.5)
end

function ServerCheck:UNIT_SPELLCAST_SENT(event,unitID, spell, rank, target, lineID)
	if unitID == "player" then
    local spellId = GetSpellInfo(spell)
    local guid,unit
    if spellId then
      guid = AirjAutoKeyCore:GetLastGUIDBySpellId(spellId)
      unit = guid and AirjAutoKeyCache:FindUnitByGUID(guid)
    end
    if not unit or UnitName(unit) ~= target then
      unit = AirjAutoKeyCache:FindUnitByName()
      guid = unit and UnitGUID(unit)
    end
    self.line2guid[lineID]=guid
	end
end

function ServerCheck:UNIT_SPELLCAST_FAILED(event,unitID, spell, rank, lineID, spellID)
	if unitID == "player" then
    local guid = self.line2guid[lineID]
    if guid then
      self.line2guid[lineID] = nil
      self.refused[guid] = GetTime()
    end
  end
end
