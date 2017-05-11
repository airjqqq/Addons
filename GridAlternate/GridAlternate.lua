--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2016 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://mods.curse.com/addons/wow/grid
	http://www.wowinterface.com/downloads/info5747-Grid.html
------------------------------------------------------------------------
	Power.lua
	Grid status module for unit power.
----------------------------------------------------------------------]]

local Grid = Grid
local L = Grid.L
local GridRoster = Grid:GetModule("GridRoster")

local GridStatusPower = Grid:NewStatusModule("GridStatusPower")
GridStatusPower.menuName = L["Alternate"]

GridStatusPower.defaultDB = {
	unit_power = {
		enable = true,
		color = { r = 1, g = 1, b = 1, a = 1 },
		priority = 30,
		range = false,
		deadAsFullPower = true,
		useClassColors = true,
	},
}

local powerOptions = {
	enable = false, -- you can't disable this
	useClassColors = {
		name = L["Use class color"],
		desc = L["Color power based on class."],
		type = "toggle", width = "double",
		get = function()
			return GridStatusPower.db.profile.unit_power.useClassColors
		end,
		set = function(_, v)
			GridStatusPower.db.profile.unit_power.useClassColors = v
			GridStatusPower:UpdateAllUnits()
		end,
	},
}


function GridStatusPower:PostInitialize()
	self:RegisterStatus("unit_power", L["Alternate"], powerOptions)
end

-- you can't disable the unit_power status, so no need to ever unregister
function GridStatusPower:PostEnable()
	self:RegisterMessage("Grid_UnitJoined")

	self:RegisterEvent("UNIT_AURA", "UpdateUnit")
	self:RegisterEvent("UNIT_CONNECTION", "UpdateUnit")
	self:RegisterEvent("UNIT_HEALTH", "UpdateUnit")
	self:RegisterEvent("UNIT_MAXHEALTH", "UpdateUnit")
	self:RegisterEvent("UNIT_NAME_UPDATE", "UpdateUnit")

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateAllUnits")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateAllUnits")

	self:RegisterMessage("Grid_ColorsChanged", "UpdateAllUnits")
end

function GridStatusPower:OnStatusEnable(status)
	self:UpdateAllUnits()
end

function GridStatusPower:OnStatusDisable(status)
	self.core:SendStatusLostAllUnits(status)
end

function GridStatusPower:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:Grid_UnitJoined("UpdateAllUnits", guid, unitid)
	end
end

function GridStatusPower:Grid_UnitJoined(event, guid, unitid)
	if unitid then
		self:UpdateUnit(event, unitid, true)
		self:UpdateUnit(event, unitid)
	end
end

local UnitGUID, UnitPower, UnitPowerMax, UnitIsConnected, UnitIsDeadOrGhost, UnitIsFeignDeath = UnitGUID, UnitPower, UnitPowerMax, UnitIsConnected, UnitIsDeadOrGhost, UnitIsFeignDeath

function GridStatusPower:UpdateUnit(event, unitid, ignoreRange)
	local guid = UnitGUID(unitid)

	if not GridRoster:IsGUIDInRaid(guid) then
		return
	end

	local cur, max = UnitPower(unitid,ALTERNATE_POWER_INDEX), UnitPowerMax(unitid,ALTERNATE_POWER_INDEX)
	if max == 0 then
		-- fix for 4.3 division by zero
		cur, max = 0, 1
	end

	local powerSettings = self.db.profile.unit_power
	local deficitSettings = self.db.profile.unit_powerDeficit
	local powerPriority = powerSettings.priority

	local powerText
	if cur == 0 then
		powerText = ""
	else
		powerText = cur..""
	end
	local deficitText

	-- function GridStatus:SendStatusGained(guid, status, priority, range, color, text, value, maxValue, texture, start, duration, count, texCoords)
	self.core:SendStatusGained(guid, "unit_power",
		powerPriority,
		(not ignoreRange and powerSettings.range),
		(powerSettings.useClassColors and self.core:UnitColor(guid) or powerSettings.color),
		powerText,
		cur,
		max,
		powerSettings.icon)
end
