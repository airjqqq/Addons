local GladiusEx = _G.GladiusEx
local L = LibStub("AceLocale-3.0"):GetLocale("GladiusEx")
local fn = LibStub("LibFunctional-1.0")
local CT = LibStub("LibCooldownTracker-1.0")

-- upvalues
local pairs = pairs
local min, max = math.min, math.max
local tinsert, tremove = table.insert, table.remove
local GetSpellTexture, GetTime = GetSpellTexture, GetTime

local function GetDefaultSpells()
	local pvp_trinket = { size = 2, color = { r = 1, g = 1, b = 1, a = 1 } }
	local offensive = { size = 1.8, color = { r = 1, g = 0.4, b = 0, a = 1 } }
	local defensive = { size = 1.8, color = { r = 0, g = 0.3, b = 1, a = 1 } }
	local cc = { size = 1.2, color = { r = 0.5, g = 0, b = 1, a = 1 } }
	local blink = { size = 1.2, color = { r = 1, g = 1, b = 0, a = 1 } }
	local interrupt = { size = 1.5, color = { r = 1, g = 0, b = 1, a = 1 } }
	local dispel = { size = 1.5, color = { r = 0, g = 1, b = 0, a = 1 } }
	local toRet = {}
	for id,spelldata in pairs(CT:GetCooldownsData()) do
		if spelldata.interrupt then
			toRet[id] = interrupt
		elseif spelldata.pvp_trinket then
			toRet[id] = pvp_trinket
		elseif spelldata.dispel then
			toRet[id] = dispel
		elseif spelldata.blink then
			toRet[id] = blink
		elseif spelldata.cc and spelldata.cooldown then
			toRet[id] = cc
		elseif spelldata.offensive then
			toRet[id] = offensive
		elseif spelldata.defensive then
			toRet[id] = defensive
		end
	end
	return toRet
end

local spellDatas = GetDefaultSpells()

local ignoreSpells = {
	--warrior
	[126664] = true,
	[ 50622] = true,
	[ 52174] = true,
	--mage
	[228597] = true,

	[1234] = true,
	[240022] = true,
}


local defaults = {
	MaxIcons = 5,
	IconSize = 32,
	BorderSize = 2,
	Margin = 2,
	PaddingX = 0,
	PaddingY = 0,
	BackgroundColor = { r = 0, g = 0, b = 0, a = 0 },
	Crop = false,

	Timeout = 5,
	MoveSpeed = 0.5,
	TimeoutAnimDuration = 0.5,

	EnterAnimDuration = 0.2,
	EnterAnimEase = "OUT",
	EnterAnimEaseMode = "CUBIC",
}

local MAX_ICONS = 40

local SkillHistory = GladiusEx:NewGladiusExModule("SkillHistory",
-- {
-- 	minShowSize = 1,
-- 	AttachTo = "Frame",
-- 	Anchor = "TOPRIGHT",
-- 	RelativePoint = "TOPLEFT",
-- 	GrowDirection = "LEFT",
-- 	OffsetX = -0,
-- 	OffsetY = -0,
-- }
	fn.merge(defaults, {
		minShowSize = 1,
		AttachTo = "Frame",
		Anchor = "TOPLEFT",
		RelativePoint = "TOPRIGHT",
		GrowDirection = "RIGHT",
		OffsetX = 120,
		OffsetY = 0,
	}),
	fn.merge(defaults, {
		minShowSize = 1,
		AttachTo = "Frame",
		Anchor = "TOPLEFT",
		RelativePoint = "TOPRIGHT",
		GrowDirection = "RIGHT",
		OffsetX = 120,
		OffsetY = 0,
	}))

function SkillHistory:OnEnable()
	if not self.frame then
		self.frame = {}
	end

	self:RegisterEvent("UNIT_NAME_UPDATE")
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "UNIT_SPELLCAST_STOP")


	CT.RegisterCallback(self, "LCT_CooldownUsed")
end

function SkillHistory:OnDisable()
	self:UnregisterAllEvents()

	for unit in pairs(self.frame) do
		self.frame[unit]:Hide()
	end
end

function SkillHistory:CreateFrame(unit)
	local button = GladiusEx.buttons[unit]
	if not button then return end

	-- create frame
	self.frame[unit] = CreateFrame("Frame", "GladiusEx" .. self:GetName() .. unit, button)
end

function SkillHistory:Update(unit)
	local testing = GladiusEx:IsTesting(unit)

	-- create frame
	if not self.frame[unit] then
		self:CreateFrame(unit)
	end

	-- frame
	local parent = GladiusEx:GetAttachFrame(unit, self.db[unit].AttachTo)
	self.frame[unit]:ClearAllPoints()
	self.frame[unit]:SetPoint(self.db[unit].Anchor, parent, self.db[unit].RelativePoint, self.db[unit].OffsetX, self.db[unit].OffsetY)
	self.frame[unit]:SetFrameLevel(9)

	-- size
	self.frame[unit]:SetWidth(self.db[unit].MaxIcons * self.db[unit].IconSize + (self.db[unit].MaxIcons - 1) * self.db[unit].Margin + self.db[unit].PaddingX * 2)
	self.frame[unit]:SetHeight(self.db[unit].IconSize + self.db[unit].PaddingY * 2)

	-- backdrop
	local bgcolor = self.db[unit].BackgroundColor
	self.frame[unit]:SetBackdrop({ bgFile = [[Interface\Buttons\WHITE8X8]], tile = true, tileSize = 8 })
	self.frame[unit]:SetBackdropColor(bgcolor.r, bgcolor.g, bgcolor.b, bgcolor.a)

	-- -- icons
	-- if not self.frame[unit].enter then
	-- 	self:CreateIcon(unit, "enter")
	-- end
	-- self:UpdateIcon(unit, "enter")
	-- for i = 1, MAX_ICONS do
	-- 	if not self.frame[unit][i] then
	-- 		if i <= self.db[unit].MaxIcons then
	-- 			self:CreateIcon(unit, i)
	-- 		else
	-- 			break
	-- 		end
	-- 	end
	-- 	self:UpdateIcon(unit, i)
	-- end
	--
	-- self:StopAnimation(unit)
	-- self:UpdateSpells(unit)

	self.frame[unit]:Hide()
end

function SkillHistory:Show(unit)
	self.frame[unit]:Show()
end

function SkillHistory:Reset(unit)
	if not self.frame[unit] then return end
	-- hide
	-- self:ClearUnit(unit)
	self.frame[unit]:Hide()
end

function SkillHistory:Test(unit)
	-- self:ClearUnit(unit)
	--
	-- -- local spells = { GetSpecializationSpells(GetSpecialization()) }
	-- -- for i = 1, #spells / 2 do
	-- -- 	self:QueueSpell(unit, spells[i * 2 - 1], GetTime())
	-- -- end
	-- local specID, class, race
	-- specID = GladiusEx.testing[unit].specID
	-- class = GladiusEx.testing[unit].unitClass
	-- race = GladiusEx.testing[unit].unitRace
	-- local n = 1
	-- for spellid, spelldata in LibStub("LibCooldownTracker-1.0"):IterateCooldowns(class, specID, race) do
	-- 	self:QueueSpell(unit, spellid, GetTime() + n * self.db[unit].EnterAnimDuration)
	-- 	n = n + 1
	-- end
end

function SkillHistory:Refresh(unit)
end

local prev_lineid = {}
local caststarted = {}
local cdToCast = {
	[214027] = true,
}

function SkillHistory:LCT_CooldownUsed(event, unit, spellId)
	if self.frame[unit] then
		if cdToCast[spellId] then
			print(unit,spellId)
			self:SpellCasted(unit, spellId)
		end
	end
end

function SkillHistory:UNIT_SPELLCAST_SUCCEEDED(event, unit, spellName, rank, lineID, spellId)
	if self.frame[unit] then
		-- casts with lineID = 0 seem to be secondary effects not directly casted by the unit
		if lineID ~= 0 and lineID ~= prev_lineid[unit] and not caststarted[lineID] then
			prev_lineid[unit] = lineID
			-- self:QueueSpell(unit, spellId, GetTime())
			self:SpellCasted(unit, spellId, lineID)
		end
		caststarted[lineID] = nil
	end
end
function SkillHistory:UNIT_SPELLCAST_START(event, unit, spellName, rank, lineID, spellId)
	if self.frame[unit] then
		-- casts with lineID = 0 seem to be secondary effects not directly casted by the unit
		if lineID ~= 0 and lineID ~= prev_lineid[unit] then
			caststarted[lineID] = true
			prev_lineid[unit] = lineID
			-- self:QueueSpell(unit, spellId, GetTime())
			self:SpellCasted(unit, spellId, lineID)
		end
	end
end
function SkillHistory:UNIT_SPELLCAST_STOP(event, unit, spellName, rank, lineID, spellId)
	if event == "UNIT_SPELLCAST_STOP" then return end
	if self.frame[unit] then
		-- casts with lineID = 0 seem to be secondary effects not directly casted by the unit
		caststarted[lineID] = nil
		self:SpellCanceled(unit, spellId, lineID)
	end
end

function SkillHistory:UNIT_NAME_UPDATE(event, unit)
	if self.frame[unit] then
		-- self:ClearUnit(unit)
	end
end

local unit_spells = {}
local unit_queue = {}
local unit_icons = {}
local unit_icons_caches = {}

local function InverseDirection(direction)
	if direction == "LEFT" then
		return "RIGHT", -1
	elseif direction == "RIGHT" then
		return "LEFT", 1
	else
		assert(false, "Invalid grow direction")
	end
end

function SkillHistory:NewIcon(unit)
	unit_icons_caches[unit] = unit_icons_caches[unit] or {}
	local icon = tremove(unit_icons_caches[unit])
	if not icon then
		icon = CreateFrame("Frame", nil, self.frame[unit])
		icon.icon = icon:CreateTexture(nil, "OVERLAY")
		icon.canceled = icon:CreateTexture(nil, "OVERLAY",nil,1)
		icon.canceled:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_7")
		icon.canceled:SetAllPoints()
		icon:SetBackdrop({ bgFile = [[Interface\Buttons\WHITE8X8]], tile = true, tileSize = 8 })
		icon:SetBackdropColor(0,0,0,1)
		icon:EnableMouse(false)
		icon:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetSpellByID(icon.spellid)
		end)
		icon:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	return icon
end

function SkillHistory:SpellCasted(unit, spellid, lineID)
	if ignoreSpells[spellid] then
		return
	end
	local spelldata = spellDatas[spellid]
	local size = spelldata and spelldata.size or 1
	if size < self.db[unit].minShowSize then
		return
	end


	local speed = self.db[unit].MoveSpeed
	local icon = self:NewIcon(unit)
	icon.spellid = spellid
	icon.width = size
	icon.height = size
	icon.color = spelldata and spelldata.color
	icon.started = 0
	icon.delayed = 0
	icon.canceled:Hide()
	icon.lineID = lineID
	icon:SetScript("OnUpdate",function(f,escape)
		-- speed up
		local delta = escape * speed
		if icon.delayed > 0 then
			local extern = math.min(delta*10,icon.delayed)
			icon.started = icon.started + delta + extern
			icon.delayed = icon.delayed - extern
		else
			icon.started = icon.started + delta
		end

		-- hide icon
		if icon.started > self.db[unit].MaxIcons then
			for i, v in pairs(unit_icons[unit]) do
				if v == icon then
					tremove(unit_icons[unit],i)
					icon:Hide()
					icon:SetScript("OnUpdate",nil)
					unit_icons_caches[unit] = unit_icons_caches[unit] or {}
					tinsert(unit_icons_caches[unit],icon)
					break
				end
			end
		end

		-- position
		local dir = self.db[unit].GrowDirection
		local invdir, sign = InverseDirection(dir)

		local posx = self.db[unit].PaddingX + (self.db[unit].IconSize + self.db[unit].Margin) * icon.started
		icon:ClearAllPoints()
		icon:SetPoint(invdir, self.frame[unit], invdir, sign * posx, 0)
		icon:SetSize(icon.width * self.db[unit].IconSize, icon.height * self.db[unit].IconSize)

		-- border

		local bordersize = self.db[unit].BorderSize
		if icon.width > 1 then
			bordersize = bordersize * 2
		end
		icon.icon:ClearAllPoints()
		icon.icon:SetPoint("TOPLEFT",bordersize,-bordersize)
		icon.icon:SetPoint("BOTTOMRIGHT",-bordersize,bordersize)
		if icon.color then
			icon:SetBackdropColor(icon.color.r,icon.color.g,icon.color.b,icon.color.a)
		else
			icon:SetBackdropColor(0,0,0,1)
		end


		-- alpha
		local alpha = 1
		local started = icon.started
		if started < self.db[unit].EnterAnimDuration then
			alpha = started/self.db[unit].EnterAnimDuration
		elseif started > self.db[unit].MaxIcons - self.db[unit].TimeoutAnimDuration then
			alpha = (self.db[unit].MaxIcons - started) / self.db[unit].TimeoutAnimDuration
		end
		icon:SetAlpha(alpha)
	end)
	icon.icon:SetTexture(GetSpellTexture(spellid))

	if self.db[unit].Crop then
		local n = 5
		icon.icon:SetTexCoord(n / 64, 1 - n / 64, n / 64, 1 - n / 64)
	else
		icon.icon:SetTexCoord(0, 1, 0, 1)
	end

	-- insert to list
	unit_icons[unit] = unit_icons[unit] or {}
	local heap = icon.width
	for i, v in pairs(unit_icons[unit]) do
		if v.started < heap then
			v.delayed = heap - v.started
		end
		heap = heap + v.width
	end
	tinsert(unit_icons[unit],1,icon)

	icon:Show()
end

function SkillHistory:SpellCanceled(unit, spellid, lineID)
	unit_icons[unit] = unit_icons[unit] or {}
	for i, v in pairs(unit_icons[unit]) do
		if v.lineID == lineID then
			v.canceled:Show()
		end
	end
end

--[[
function SkillHistory:QueueSpell(unit, spellid, time)
	if not unit_queue[unit] then unit_queue[unit] = {} end
	local uq = unit_queue[unit]

	-- avoid duplicate events
	-- if #uq > 0 then
	-- 	local last = uq[#uq]
	-- 	if last.spellid == spellid and (last.time + 1) > time then
	-- 		return
	-- 	end
	-- end

	-- replace trinket icon
	-- if spellid == 42292 then
	-- end

	local entry = {
		["spellid"] = spellid,
		["time"] = time
	}

	tinsert(uq, entry)

	if not self:IsAnimating(unit) then
		self:SetupAnimation(unit)
	end
end


local ease_funcs = {
	["LINEAR"] = function(t) return t end,
	["QUAD"] = function(t) return t * t end,
	["CUBIC"] = function(t) return t * t * t end,
}

local ease_methods = {
	["NONE"] = function(f) return function(t) return t end end,
	["IN"] = function(f) return f end,
	["OUT"] = function(f) return function(t) return 1 - f(1 - t) end end,
	["IN_OUT"] = function(f) return function(t) return .5 * (t < .5 and f(2 * t) or (2 - f(2 - 2 * t))) end end,
}

local ease_cache = setmetatable({}, {
	__index = function(t1, func)
		assert(ease_funcs[func], "Unknown ease function " .. tostring(func))
		local m = setmetatable({}, {
			__index = function(t2, method)
				assert(ease_methods[method], "Invalid ease method " .. tostring(method))
				local f = ease_funcs[func]
				local m = ease_methods[method]
				local mf = m(f)
				rawset(t2, method, mf)
				return mf
			end
		})
		rawset(t1, func, m)
		return m
	end
})

local function GetEaseFunc(method, func)
	return ease_cache[func][method]
end

function SkillHistory:IsAnimating(unit)
	local frame = self.frame[unit]
	return frame and frame.animating
end

function SkillHistory:SetupAnimation(unit)
	local frame = self.frame[unit]
	local uq = unit_queue[unit]
	local us = unit_spells[unit]
	local entry = uq[1]

	local dir = self.db[unit].GrowDirection
	local iconsize = self.db[unit].IconSize
	local margin = self.db[unit].Margin
	local maxicons = self.db[unit].MaxIcons
	local crop = self.db[unit].Crop
	local animdur = self.db[unit].EnterAnimDuration
	-- speed up animation if there are too many queued spells
	if #uq >= 2 then
		animdur = animdur * 0.1
	end

	local st = GetTime()
	local off = iconsize + margin

	local enter = frame.enter
	local leave = frame[maxicons]

	enter.entry = entry
	enter.icon:SetTexture(GetSpellTexture(entry.spellid))
	--enter:SetAlpha(0)
	enter:Show()

	if leave then leave.icon:ClearAllPoints() end
	enter.icon:ClearAllPoints()

	local ease = GetEaseFunc(self.db[unit].EnterAnimEase, self.db[unit].EnterAnimEaseMode)

	-- while this could be implemented with AnimationGroups, they are more
	-- trouble than it is worth, sadly
	local function AnimationFrame(f,escape)
		-- if #uq > 0 then
		-- 	animdur = self.db[unit].EnterAnimDuration * 0.1
		-- else
		-- 	animdur = self.db[unit].EnterAnimDuration
		-- end
		-- local t = (GetTime() - st) / animdur
		-- if t < 1 then
		-- 	t = ease(t)
		-- 	local ox = off * t
		-- 	local oy = 0
		-- 	-- move all but the last icon
		-- 	for i = 1, maxicons - 1 do
		-- 		if not frame[i] or not frame[i]:IsShown() then break end
		-- 		self:UpdateIconPosition(unit, i, ox, oy)
		-- 	end
		--
		-- 	if leave then
		-- 		-- move the leaving icon with clipping
		-- 		self:UpdateIconPosition(unit, maxicons, ox, oy)
		-- 		local left, right
		-- 		if dir == "LEFT" then
		-- 			left = min(iconsize, ox)
		-- 			right = 0
		-- 		elseif dir == "RIGHT" then
		-- 			left = 0
		-- 			right = min(iconsize, ox)
		-- 		end
		-- 		leave.icon:SetPoint("TOPLEFT", left, 0)
		-- 		leave.icon:SetPoint("BOTTOMRIGHT", -right, 0)
		-- 		if crop then
		-- 			local n = 5
		-- 			local range = 1 - (n / 32)
		-- 			local texleft = n / 64 + (left / iconsize * range)
		-- 			local texright = n / 64 + ((1 - right / iconsize) * range)
		-- 			leave.icon:SetTexCoord(texleft, texright, n / 64, 1 - n / 64)
		-- 		else
		-- 			leave.icon:SetTexCoord(left / iconsize, 1 - right / iconsize, 0, 1)
		-- 		end
		--
		-- 		-- fade out leaving icon to alpha 0
		-- 		--frame[maxicons]:SetAlpha(1 - t)
		-- 	end
		--
		-- 	-- enter new icon with clipping
		-- 	self:UpdateIconPosition(unit, "enter", ox, oy)
		-- 	local left, right
		-- 	if dir == "LEFT" then
		-- 		left = 0
		-- 		right = iconsize - max(0, ox - margin)
		-- 	elseif dir == "RIGHT" then
		-- 		left = iconsize - max(0, ox - margin)
		-- 		right = 0
		-- 	end
		-- 	enter.icon:SetPoint("TOPLEFT", left, 0)
		-- 	enter.icon:SetPoint("BOTTOMRIGHT", -right, 0)
		-- 	if crop then
		-- 		local n = 5
		-- 		local range = 1 - (n / 32)
		-- 		local texleft = n / 64 + (left / iconsize * range)
		-- 		local texright = n / 64 + ((1 - right / iconsize) * range)
		-- 		enter.icon:SetTexCoord(texleft, texright, n / 64, 1 - n / 64)
		-- 	else
		-- 		enter.icon:SetTexCoord(left / iconsize, 1 - right / iconsize, 0, 1)
		-- 	end
		--
		-- 	-- fade in enter icon to alpha 1
		-- 	--enter:SetAlpha(t)
		-- else
		-- 	-- restore last icon
		-- 	if leave then
		-- 		self:UpdateIcon(unit, maxicons)
		-- 	end
		--
		-- 	-- after:
		-- 	--  updatespells, hide tmp1
		-- 	tremove(uq, 1)
		-- 	-- if #uq > 0 then
		-- 	-- 	self:SetupAnimation(unit)
		-- 	-- else
		-- 	-- 	self:StopAnimation(unit)
		-- 	-- end
		--
		-- 	self:AddSpell(unit, entry)
		-- end

		-- local ox = off * t
		-- local oy = 0
		-- -- move all but the last icon
		-- for i = 1, maxicons - 1 do
		-- 	if not frame[i] or not frame[i]:IsShown() then break end
		-- 	self:UpdateIconPosition(unit, i, ox, oy)
		-- end
		-- for i = 1, maxicons - 1 do
		-- 	if not frame[i] or not frame[i]:IsShown() then break end
		-- 	self:UpdateIconPosition(unit, i, ox, oy)
		-- end

	end

	frame.animating = true
	frame:SetScript("OnUpdate", AnimationFrame)
	AnimationFrame()
end

function SkillHistory:StopAnimation(unit)
	local frame = self.frame[unit]
	frame.animating = false
	frame:SetScript("OnUpdate", nil)
	if frame.enter then
		frame.enter:Hide()
	end
end

function SkillHistory:ClearQueue(unit)
		unit_queue[unit] = {}
	self:StopAnimation(unit)
end

function SkillHistory:AddSpell(unit, entry)
	if not unit_spells[unit] then unit_spells[unit] = {} end
	local us = unit_spells[unit]

	tremove(us, self.db[unit].MaxIcons)
	tinsert(us, 1, entry)

	self:UpdateSpells(unit)
end

function SkillHistory:ClearSpells(unit)
	unit_spells[unit] = {}
	self:UpdateSpells(unit)
end

function SkillHistory:UpdateSpells(unit)
	local frame = self.frame[unit]
	local us = unit_spells[unit]
	if not frame or not us then return end

	local now = GetTime()
	local timeout = self.db[unit].Timeout
	local timeout_duration = self.db[unit].TimeoutAnimDuration
	local ease = GetEaseFunc(self.db[unit].EnterAnimEase, self.db[unit].EnterAnimEaseMode)

	-- remove timed out spells
	for i = #us, 1, -1 do
		if (us[i].time + timeout + timeout_duration) < now then
			tremove(us, i)
		else
			break
		end
	end

	-- update icons
	local n = min(#us, self.db[unit].MaxIcons)
	for i = 1, n do
		self:UpdateIconPosition(unit, i, 0, 0)

		local entry = unit_spells[unit][i]
		frame[i].entry = entry
		frame[i].icon:SetTexture(GetSpellTexture(entry.spellid))
		frame[i]:SetAlpha(1)
		frame[i]:Show()

		local function IconFadeFrame(icon)
			local t = (GetTime() - icon.entry.time - timeout) / timeout_duration
			if t >= 1 then
				icon:Hide()
				icon:SetScript("OnUpdate", nil)
			elseif t >= 0 then
				icon:SetAlpha(1 - ease(t))
			end
		end
		frame[i]:SetScript("OnUpdate", IconFadeFrame)
		IconFadeFrame(frame[i])
	end

	-- hide unused icons
	for i = n + 1, MAX_ICONS do
		if not frame[i] or not frame[i]:IsShown() then break end
		frame[i]:Hide()
		frame[i]:SetScript("OnUpdate", nil)
		frame[i].entry = false
	end
end

function SkillHistory:ClearUnit(unit)
	self:ClearQueue(unit)
	self:ClearSpells(unit)
end

function SkillHistory:CreateIcon(unit, i)
	self.frame[unit][i] = CreateFrame("Frame", nil, self.frame[unit])
	self.frame[unit][i].icon = self.frame[unit][i]:CreateTexture(nil, "OVERLAY")

	self.frame[unit][i]:EnableMouse(false)
	self.frame[unit][i]:SetScript("OnEnter", function(self)
		if self.entry then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetSpellByID(self.entry.spellid)
		end
	end)
	self.frame[unit][i]:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
end

function SkillHistory:UpdateIcon(unit, index)
	self.frame[unit][index]:ClearAllPoints()
	self.frame[unit][index]:SetSize(self.db[unit].IconSize, self.db[unit].IconSize)
	self.frame[unit][index].icon:SetAllPoints()

	-- crop
	if self.db[unit].Crop then
		local n = 5
		self.frame[unit][index].icon:SetTexCoord(n / 64, 1 - n / 64, n / 64, 1 - n / 64)
	else
		self.frame[unit][index].icon:SetTexCoord(0, 1, 0, 1)
	end
end

function SkillHistory:UpdateIconPosition(unit, index, ox, oy)
	local i = index == "enter" and 0 or index

	-- position
	local dir = self.db[unit].GrowDirection
	local invdir, sign = InverseDirection(dir)

	local posx = self.db[unit].PaddingX + (self.db[unit].IconSize + self.db[unit].Margin) * (i - 1)
	self.frame[unit][index]:SetPoint(invdir, self.frame[unit], invdir, sign * (posx + ox), oy)
end

]]

function SkillHistory:GetOptions(unit)
	local options
	options = {
		general = {
			type = "group",
			name = L["General"],
			order = 1,
			args = {
				widget = {
					type = "group",
					name = L["Widget"],
					desc = L["Widget settings"],
					inline = true,
					order = 1,
					args = {
						BackgroundColor = {
							type = "color",
							name = L["Background color"],
							desc = L["Color of the frame background"],
							hasAlpha = true,
							get = function(info) return GladiusEx:GetColorOption(self.db[unit], info) end,
							set = function(info, r, g, b, a) return GladiusEx:SetColorOption(self.db[unit], info, r, g, b, a) end,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 1,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 13,
						},
						Crop = {
							type = "toggle",
							name = L["Crop borders"],
							desc = L["Toggle if the icon borders should be cropped or not"],
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 14,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 14.5,
						},
						MaxIcons = {
							type = "range",
							name = L["Icons max"],
							desc = L["Number of max icons"],
							min = 1, max = MAX_ICONS, step = 1,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 20,
						},
					},
				},
				enteranim = {
					type = "group",
					name = L["Enter animation"],
					desc = L["Enter animation settings"],
					inline = true,
					order = 2,
					args = {
						EnterAnimDuration = {
							type = "range",
							name = L["Duration"],
							desc = L["Duration of the enter animation, in seconds"],
							min = 0.1, softMax = 5, bigStep = 0.05,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 1,
						},
						MoveSpeed = {
							type = "range",
							name = "Speed",
							desc = "N/s",
							min = 0.1, softMax = 3, bigStep = 0.05,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 4,
						},
						-- EnterAnimEase = {
						-- 	type = "select",
						-- 	name = L["Ease mode"],
						-- 	desc = L["Animation ease mode"],
						-- 	values = {
						-- 		["IN"] = L["In"],
						-- 		["IN_OUT"] = L["In-Out"],
						-- 		["OUT"] = L["Out"],
						-- 		["NONE"] = L["None"],
						-- 	},
						-- 	disabled = function() return not self:IsUnitEnabled(unit) end,
						-- 	order = 2,
						-- },
						-- EnterAnimEaseMode = {
						-- 	type = "select",
						-- 	name = L["Ease function"],
						-- 	desc = L["Animation ease function"],
						-- 	values = {
						-- 		["QUAD"] = L["Quadratic"],
						-- 		["CUBIC"] = L["Cubic"],
						-- 	},
						-- 	disabled = function() return not self:IsUnitEnabled(unit) end,
						-- 	order = 3,
						-- },
					},
				},
				timeout = {
					type = "group",
					name = L["Timeout"],
					desc = L["Timeout settings"],
					inline = true,
					order = 2,
					args = {
						-- Timeout = {
						-- 	type = "range",
						-- 	name = L["Timeout"],
						-- 	desc = L["Timeout, in seconds"],
						-- 	min = 1, softMin = 3, softMax = 30, bigStep = 0.5,
						-- 	disabled = function() return not self:IsUnitEnabled(unit) end,
						-- 	order = 1,
						-- },
						TimeoutAnimDuration = {
							type = "range",
							name = L["Fade out duration"],
							desc = L["Duration of the fade out animation, in seconds"],
							min = 0.1, softMax = 3, bigStep = 0.05,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 2,
						},
					},
				},
				size = {
					type = "group",
					name = L["Size"],
					desc = L["Size settings"],
					inline = true,
					order = 3,
					args = {
						IconSize = {
							type = "range",
							name = L["Icon size"],
							desc = L["Size of the cooldown icons"],
							min = 1, softMin = 10, softMax = 100, step = 1,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 3,
						},
						minShowSize = {
							type = "range",
							name = "minShowSize",
							desc = "",
							min = 1, max = 3, bigStep = 0.05, isPercent = true,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 4,
						},
						BorderSize = {
							type = "range",
							name = L["Border size"],
							desc = L["Size of the cooldown icon borders"],
							min = -10, softMin = 0, softMax = 10, step = 1,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 5,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 13,
						},
						PaddingY = {
							type = "range",
							name = L["Vertical padding"],
							desc = L["Vertical padding of the icons"],
							min = 0, softMax = 30, step = 1,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 15,
						},
						PaddingX = {
							type = "range",
							name = L["Horizontal padding"],
							desc = L["Horizontal padding of the icons"],
							disabled = function() return not self:IsUnitEnabled(unit) end,
							min = 0, softMax = 30, step = 1,
							order = 20,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 23,
						},
						Margin = {
							type = "range",
							name = L["Horizontal spacing"],
							desc = L["Horizontal spacing of the icons"],
							disabled = function() return not self:IsUnitEnabled(unit) end,
							min = 0, softMax = 30, step = 1,
							order = 30,
						},
					},
				},
				position = {
					type = "group",
					name = L["Position"],
					desc = L["Position settings"],
					inline = true,
					order = 4,
					args = {
						AttachTo = {
							type = "select",
							name = L["Attach to"],
							desc = L["Attach to the given frame"],
							values = function() return self:GetOtherAttachPoints(unit) end,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 1,
						},
						Position = {
							type = "select",
							name = L["Position"],
							desc = L["Position of the frame"],
							values = GladiusEx:GetGrowSimplePositions(),
							get = function()
								return GladiusEx:GrowSimplePositionFromAnchor(
									self.db[unit].Anchor,
									self.db[unit].RelativePoint,
									self.db[unit].GrowDirection)
							end,
							set = function(info, value)
								self.db[unit].Anchor, self.db[unit].RelativePoint =
									GladiusEx:AnchorFromGrowSimplePosition(value, self.db[unit].GrowDirection)
								GladiusEx:UpdateFrames()
							end,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							hidden = function() return GladiusEx.db.base.advancedOptions end,
							order = 2,
						},
						GrowDirection = {
							type = "select",
							name = L["Grow direction"],
							desc = L["Grow direction of the icons"],
							values = {
								["LEFT"] = L["Left"],
								["RIGHT"] = L["Right"],
							},
							set = function(info, value)
								if not GladiusEx.db.base.advancedOptions then
									self.db[unit].Anchor, self.db[unit].RelativePoint =
										GladiusEx:AnchorFromGrowDirection(
											self.db[unit].Anchor,
											self.db[unit].RelativePoint,
											self.db[unit].GrowDirection,
											value)
								end
								self.db[unit].GrowDirection = value
								GladiusEx:UpdateFrames()
							end,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 3,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 7,
						},
						Anchor = {
							type = "select",
							name = L["Anchor"],
							desc = L["Anchor of the frame"],
							values = GladiusEx:GetPositions(),
							disabled = function() return not self:IsUnitEnabled(unit) end,
							hidden = function() return not GladiusEx.db.base.advancedOptions end,
							order = 10,
						},
						RelativePoint = {
							type = "select",
							name = L["Relative point"],
							desc = L["Relative point of the frame"],
							values = GladiusEx:GetPositions(),
							disabled = function() return not self:IsUnitEnabled(unit) end,
							hidden = function() return not GladiusEx.db.base.advancedOptions end,
							order = 15,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 17,
						},
						OffsetX = {
							type = "range",
							name = L["Offset X"],
							desc = L["X offset of the frame"],
							softMin = -100, softMax = 100, bigStep = 1,
							disabled = function() return not self:IsUnitEnabled(unit) end,
							order = 20,
						},
						OffsetY = {
							type = "range",
							name = L["Offset Y"],
							desc = L["Y offset of the frame"],
							disabled = function() return not self:IsUnitEnabled(unit) end,
							softMin = -100, softMax = 100, bigStep = 1,
							order = 25,
						},
					},
				},
			},
		},
	}

	return options
end
