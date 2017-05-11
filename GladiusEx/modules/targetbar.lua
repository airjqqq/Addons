local GladiusEx = _G.GladiusEx
local L = LibStub("AceLocale-3.0"):GetLocale("GladiusEx")
local fn = LibStub("LibFunctional-1.0")

local defaults = {
	OffsetX = 0,
	OffsetY = 0,
	Height = 24,
	Width = 96,
	Inverse = false,
	Color = { r = 1, g = 1, b = 1, a = 1 },
	ClassColor = true,
	BackgroundColor = { r = 0, g = 0, b = 0, a = 1 },
	GlobalTexture = true,
	Texture = GladiusEx.default_bar_texture,
	Icon = true,
	IconCrop = true,
}

local TargetBar = GladiusEx:NewUnitBarModule("TargetBar",
	fn.merge(defaults, {
		AttachTo = "Frame",
		RelativePoint = "BOTTOMLEFT",
		Anchor = "BOTTOMRIGHT",
		IconPosition = "LEFT",
		OffsetX = -5,
		OffsetY = 0,
	}),
	fn.merge(defaults, {
		AttachTo = "Frame",
		RelativePoint = "BOTTOMRIGHT",
		Anchor = "BOTTOMLEFT",
		IconPosition = "LEFT",
		OffsetX = 5,
		OffsetY = 0,
	}))

function TargetBar:GetFrameUnit(unit)
	if unit == "player" then
		return "target", false
	else
		return unit .. "target", true
	end
end

function TargetBar:RegisterCustomEvents()
	self:RegisterEvent("UNIT_TARGET")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", function() self:UNIT_TARGET("PLAYER_TARGET_CHANGED", "player") end)
end

function TargetBar:UNIT_TARGET(event, unit)
	if self.frame[unit] then
		self:Refresh(unit)
	end
end
