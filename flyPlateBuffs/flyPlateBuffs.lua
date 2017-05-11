local AddonName, fPB = ...
L = fPB.L


local	C_NamePlate_GetNamePlateForUnit, C_NamePlate_GetNamePlates, CreateFrame, CreateTexture, CreateFontString, UnitDebuff, UnitBuff, UnitName, UnitIsUnit, UnitIsPlayer, UnitPlayerControlled, UnitIsEnemy, UnitIsFriend, GetSpellInfo, table_sort, table_insert, table_remove, strmatch, format, type, wipe, pairs, GetTime, math_floor =
		C_NamePlate.GetNamePlateForUnit, C_NamePlate.GetNamePlates, CreateFrame, CreateTexture, CreateFontString, UnitDebuff, UnitBuff, UnitName, UnitIsUnit, UnitIsPlayer, UnitPlayerControlled, UnitIsEnemy, UnitIsFriend, GetSpellInfo, table.sort, table.insert, table.remove, strmatch, format, type, wipe, pairs, GetTime, math.floor

local defaultSpells1, defaultSpells2 = fPB.defaultSpells1, fPB.defaultSpells2

local LSM = LibStub("LibSharedMedia-3.0")
fPB.LSM = LSM

local config = LibStub("AceConfig-3.0")
local dialog = LibStub("AceConfigDialog-3.0")

fPB.db = {}
local db

local fPBMainOptions
local fPBSpellsList
local fPBProfilesOptions

fPB.chatColor = "|cFFFFA500"
fPB.linkColor = "|cff71d5ff"
local chatColor = fPB.chatColor
local linkColor = fPB.linkColor

local cachedSpells = {}
local PlatesBuffs = {}

local DefaultSettings = {
	profile = {
		showDebuffs = 2,		-- 1 = all, 2 = mine + spellList, 3 = only spellList, 4 = only mine, 5 = none
		showBuffs = 3,			-- 1 = all, 2 = mine + spellList, 3 = only spellList, 4 = only mine, 5 = none
		hidePermanent = true,

		showOnPlayers = true,
		showOnPets = true,
		showOnNPC = true,

		showOnEnemy = true,
		showOnFriend = true,
		showOnNeutral = true,

		showOnlyInCombat = false,
		showUnitInCombat = false,

		parentWorldFrame = false,

		baseWidth = 24,
		baseHeight = 24,
		myScale = 0.2,
		cropTexture = true,

		buffAnchorPoint = "BOTTOM",
		plateAnchorPoint = "TOP",

		xInterval = 4,
		yInterval = 12,

		xOffset = 0,
		yOffset = 4,

		buffPerLine = 6,
		numLines = 3,

		showStdCooldown = true,
		showStdSwipe = false,

		showDuration = true,
		durationSize = 10,
		blinkTimeleft = 0.2,

		stackSize = 10,

		font = "Friz Quadrata TT",

		borderStyle = 1,	-- 1 = \\texture\\border.tga, 2 = Blizzard, 3 = none
		colorizeBorder = true,
		colorTypes = {
			Magic 	= {0.20,0.60,1.00},
			Curse 	= {0.60,0.00,1.00},
			Disease = {0.60,0.40,0},
			Poison 	= {0.00,0.60,0},
			none 	= {0.80,0,   0},
			Buff 	= {0.00,1.00,0},
		},

		disableSort = false,
		sortMode = {
			"my", -- [1]
			"expiration", -- [2]
			"disable", -- [3]
			"disable", -- [4]
		},

		Spells = {},
		ignoredDefaultSpells = {},

		showSpellID = false,

		nameplateMaxDistance = false,
		nameplateInset = false,
		fixNames = false,
	},
}

do --add default spells
for i=1, #defaultSpells1 do
	local spellID = defaultSpells1[i]
	local name = GetSpellInfo(spellID)
	if name then
		DefaultSettings.profile.Spells[spellID] = {
			name = name,
			spellID = spellID,
			scale = 2,
			durationSize = 18,
			show = 1,	-- 1 = always, 2 = mine, 3 = never, 4 = on ally, 5 = on enemy
			stackSize = 18,
		}
	end
end

for i=1, #defaultSpells2 do
	local spellID = defaultSpells2[i]
	local name = GetSpellInfo(spellID)
	if name then
		DefaultSettings.profile.Spells[spellID] = {
			name = name,
			spellID = spellID,
			scale = 1.5,
			durationSize = 14,
			show = 1,	-- 1 = always, 2 = mine, 3 = never, 4 = on ally, 5 = on enemy
			stackSize = 14,
		}
	end
end

end

local timeIntervals = {
	[1]	= {60 * 60 * 24 * 365, "y"},-- year
	[2]	= {60 * 60 * 24 * 30, "mo"},-- month
	[3]	= {60 * 60 * 24 * 7, "w"},-- week
	[4]	= {60 * 60 * 24, "d"},-- day
	[5]	= {60 * 60, "h"},-- hour
	[6]	= {60, "m"},-- minute
}

local function FormatTime(seconds)
	local text = ""
	if seconds == 0 then
		text = "0s"
	else
		for i, data in ipairs(timeIntervals) do
			local num = 0
			while seconds > data[1] do
				num	= num + 1;
				seconds	= seconds - data[1];
			end
			if num > 0 then
				text = num..data[2];
				return text
			end
		end
		return seconds
	end
end

local function GetColorByTime(current, max)
	if max == 0 then max = 1 end
	local percentage = (current/max)*100
	local red,green = 0,0
	if percentage >= 50 then
		--green to yellow
		green		= 1
		red			= ((100 - percentage) / 100) * 2
	else
		--yellow to red
		red	= 1
		green		= ((100 - (100 - percentage)) / 100) * 2
	end
	return red, green, 0
end

local function SortFunc(a,b)
	local i = 1
	while db.sortMode[i] do
		local mode, rev = db.sortMode[i],db.sortMode[i+0.5]
		if mode ~= "disable" and a[mode] ~= b[mode] then
			if mode == "my" and not rev then -- self first
				return (a.my and 1 or 0) > (b.my and 1 or 0)
			elseif mode == "my" and rev then
				return (a.my and 1 or 0) < (b.my and 1 or 0)
			elseif mode == "expiration" and not rev then
				return (a.expiration > 0 and a.expiration or 5000000) < (b.expiration > 0 and b.expiration or 5000000)
			elseif mode == "expiration" and rev then
				return (a.expiration > 0 and a.expiration or 5000000) > (b.expiration > 0 and b.expiration or 5000000)
			elseif (mode == "type" or mode == "scale") and not rev then
				return a[mode] > b[mode]
			else
				return a[mode] < b[mode]
			end
		end
		i = i+1
	end
end

local function DrawOnPlate(frame)

	if not (#frame.fPBiconsFrame.iconsFrame > 0) then return end

	local maxWidth = 0
	local sumHeight = 0

	local buffIcon = frame.fPBiconsFrame.iconsFrame

	local breaked = false
	for l = 1, db.numLines do
		if breaked then break end

		local lineWidth = 0
		local lineHeight = 0

		for k = 1, db.buffPerLine do

			local i = db.buffPerLine*(l-1)+k
			if not buffIcon[i] or not buffIcon[i]:IsShown() then breaked = true; break end
			if l == 1 and k == 1 then
				buffIcon[i]:SetPoint("BOTTOMLEFT", frame.fPBiconsFrame, "BOTTOMLEFT", 0, 0)
			elseif k == 1 then
				buffIcon[i]:SetPoint("BOTTOMLEFT", buffIcon[i-db.buffPerLine], "TOPLEFT", 0, db.yInterval)
			else
				buffIcon[i]:SetPoint("BOTTOMLEFT", buffIcon[i-1], "BOTTOMRIGHT", db.xInterval, 0)
			end

			lineWidth = lineWidth + buffIcon[i].width + db.xInterval
			lineHeight = (buffIcon[i].height > lineHeight) and buffIcon[i].height or lineHeight
		end
		maxWidth = max(maxWidth, lineWidth)
		sumHeight = sumHeight + lineHeight + db.yInterval
	end
	frame.fPBiconsFrame:SetWidth(maxWidth-db.xInterval)
	frame.fPBiconsFrame:SetHeight(sumHeight - db.yInterval)
	frame.fPBiconsFrame:SetPoint(db.buffAnchorPoint,frame,db.plateAnchorPoint,db.xOffset,db.yOffset)
	-- TEST frame
	-- local testTexture = frame.fPBiconsFrame:CreateTexture(nil,"BACKGROUND")
	-- testTexture:SetColorTexture(0.5, 0.5, 0.5)
	-- testTexture:SetAllPoints(frame.fPBiconsFrame)
end

local function AddBuff(frame, type, icon, stack, debufftype, duration, expiration, my, scale, durationSize, stackSize)
	if not PlatesBuffs[frame] then PlatesBuffs[frame] = {} end
	PlatesBuffs[frame][#PlatesBuffs[frame] + 1] = {
		type = type,
		icon = icon,
		stack = stack,
		debufftype = debufftype,
		duration = duration,
		expiration = expiration,
		scale = (my and db.myScale + 1 or 1) * (scale or 1),
		durationSize = durationSize,
		stackSize = stackSize,
	}
end

local function FilterBuffs(isAlly, frame, type, name, icon, stack, debufftype, duration, expiration, caster, spellID)
	if type == "debuff" and db.showDebuffs == 5 then return end
	if type == "buff" and db.showBuffs == 5 then return end

	local Spells = db.Spells
	local listedSpell
	local my = caster == "player"
	local cachedID = cachedSpells[name]

	if Spells[spellID] and not db.ignoredDefaultSpells[spellID] then
		listedSpell = Spells[spellID]
	elseif cachedID then
		if cachedID == "noid" then
			listedSpell = Spells[name]
		else
			listedSpell = Spells[cachedID]
		end
	end

	-- showDebuffs  1 = all, 2 = mine + spellList, 3 = only spellList, 4 = only mine, 5 = none
	-- listedSpell.show  -- 1 = always, 2 = mine, 3 = never, 4 = on ally, 5 = on enemy
	if not listedSpell then
		if db.hidePermanent and duration == 0 then
			return
		end
		if (type == "debuff" and (db.showDebuffs == 1 or ((db.showDebuffs == 2 or db.showDebuffs == 4) and my)))
		or (type == "buff"   and (db.showBuffs   == 1 or ((db.showBuffs   == 2 or db.showBuffs   == 4) and my))) then
			AddBuff(frame, type, icon, stack, debufftype, duration, expiration, my)
			return
		else
			return
		end
	else --listedSpell
		if (type == "debuff" and (db.showDebuffs == 2 or db.showDebuffs == 3))
		or (type == "buff" and (db.showBuffs == 2 or db.showBuffs == 3)) then
			if listedSpell.show == 1 or
			(listedSpell.show == 2 and my) or
			(listedSpell.show == 4 and isAlly) or
			(listedSpell.show == 5 and not isAlly) then
				AddBuff(frame, type, icon, stack, debufftype, duration, expiration, my, listedSpell.scale, listedSpell.durationSize, listedSpell.stackSize)
				return
			end
		else
			return
		end
	end
end

local function ScanUnitBuffs(nameplateID, frame)

	if PlatesBuffs[frame] then
		wipe(PlatesBuffs[frame])
	end
	local isAlly = UnitIsFriend(nameplateID,"player")
	local i = 1
	while UnitDebuff(nameplateID,i) do
		local name, _, icon, stack, debufftype, duration, expiration, caster, _, _, spellID = UnitDebuff(nameplateID,i)
		FilterBuffs(isAlly, frame, "debuff", name, icon, stack, debufftype, duration, expiration, caster, spellID)
		i = i + 1
	end

	i = 1
	while UnitBuff(nameplateID,i) do
		local name, _, icon, stack, debufftype, duration, expiration, caster, _, _, spellID = UnitBuff(nameplateID,i)
		FilterBuffs(isAlly, frame, "buff", name, icon, stack, debufftype, duration, expiration, caster, spellID)
		i = i + 1
	end
end

local function FilterUnits(nameplateID)

	if db.showOnlyInCombat and not UnitAffectingCombat("player") then return true end -- InCombatLockdown()
	if db.showUnitInCombat and not UnitAffectingCombat(nameplateID) then return true end

	-- filter units
	if UnitIsUnit(nameplateID,"player") then return true end
	if UnitIsPlayer(nameplateID) and not db.showOnPlayers then return true end
	if UnitPlayerControlled(nameplateID) and not UnitIsPlayer(nameplateID) and not db.showOnPets then return true end
	if not UnitPlayerControlled(nameplateID) and not UnitIsPlayer(nameplateID) and not db.showOnNPC then return true end
	if UnitIsEnemy(nameplateID,"player") and not db.showOnEnemy then return true end
	if UnitIsFriend(nameplateID,"player") and not db.showOnFriend then return true end
	if not UnitIsFriend(nameplateID,"player") and not UnitIsEnemy(nameplateID,"player") and not db.showOnNeutral then return true end

	return false
end

local total = 0
local function iconOnUpdate(self, elapsed)
	total = total + elapsed
	if total > 0 then
		total = 0
		if self.expiration and self.expiration > 0 then
			local timeLeft = self.expiration - GetTime()
			if timeLeft < 0 then
				-- local frame = self:GetParent():GetParent()
				-- self:Hide()
				-- UpdateUnitAuras(frame.namePlateUnitToken)
				return
			end

			if timeLeft < 10 then
				timeLeft = math_floor(timeLeft * 10 + 0.5)/10
			else
				timeLeft = math_floor(timeLeft)
			end
			if db.showDuration then
				self.cd:SetText(FormatTime(timeLeft))
				self.cd:SetTextColor(GetColorByTime(timeLeft,self.duration))
				self.cdbg:SetWidth(self.cd:GetStringWidth())
				self.cdbg:SetHeight(self.cd:GetStringHeight())
			end
			if (timeLeft / (self.duration + 0.01) ) < db.blinkTimeleft and timeLeft < 60 then --buff only has 20% timeleft and is less then 60 seconds.
				local f = GetTime() % 1
				if f > 0.5 then
					f = 1 - f
				end
				self:SetAlpha(f * 3)
			end
		end
	end
end
local function GetTexCoordFromSize(frame,size,size2)
	local arg = size/size2
	local abj
	if arg > 1 then
		abj = 1/size*((size-size2)/2)

		frame:SetTexCoord(0 ,1,(0+abj),(1-abj))
	elseif arg < 1 then
		abj = 1/size2*((size2-size)/2)

		frame:SetTexCoord((0+abj),(1-abj),0,1)
	else
		frame:SetTexCoord(0, 1, 0, 1)
	end
end
local function UpdateBuffIcon(self)

	self:SetAlpha(1)
	self.stacktext:Hide()
	self.border:Hide()
	self.cooldown:Hide()
	self.cd:Hide()
	self.cdbg:Hide()

	self:SetWidth(self.width)
	self:SetHeight(self.height)

	self.texture:SetTexture(self.icon)
	if db.cropTexture then
		GetTexCoordFromSize(self.texture,self.width,self.height)
	else
		self.texture:SetTexCoord(0, 1, 0, 1)
	end

	if self.stack > 1 then
		self.stacktext:SetText(tostring(self.stack))
		self.stacktext:SetFont(fPB.font, (self.stackSize or db.stackSize), "OUTLINE")
		self.stacktext:Show()
	end

	if db.borderStyle ~= 3 then
		if db.borderStyle == 1 then
			self.border:SetTexture("Interface\\Addons\\flyPlateBuffs\\texture\\border.tga")
			self.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92)		--хз почему отображает не на всю иконку по дефолту, цифры подбором
		elseif db.borderStyle == 2 then
			self.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
			self.border:SetTexCoord(0.296875,0.5703125,0,0.515625)		-- if "Interface\\Buttons\\UI-Debuff-Overlays"
		end

		local color
		if self.type == "buff" then
			color = db.colorTypes.Buff
		else
			if db.colorizeBorder then
				color = db.colorTypes[self.debufftype] or db.colorTypes.none
			else
				color = db.colorTypes.none
			end
		end
		self.border:SetVertexColor(color[1], color[2], color[3])
		self.border:Show()
	end

	if (db.showStdCooldown or db.showStdSwipe) and self.expiration > 0 then
		if not db.showStdSwipe then
			self.cooldown:SetDrawSwipe(false)
		else
			self.cooldown:SetDrawSwipe(true)
			self.cooldown:SetSwipeColor(0, 0, 0, 0.6)
		end
		if not db.showStdCooldown then
			self.cooldown:SetHideCountdownNumbers(true)
		end
		local start, duration = self.cooldown:GetCooldownTimes()
		if (start ~= (self.expiration - self.duration)) or duration ~= self.durationthen then
			self.cooldown:SetCooldown(self.expiration - self.duration, self.duration)
		end
	end

	if db.showDuration and self.expiration > 0 then
		self.cd:SetFont(fPB.font, (self.durationSize or db.durationSize), "NORMAL")
		self.cd:Show()
		self.cdbg:Show()
	end
end
local function iconOnHide(self)
	self.stacktext:Hide()
	self.border:Hide()
	self.cooldown:Hide()
	self.cd:Hide()
	self.cdbg:Hide()
end
local function CreateBuffIcon(frame,i)
	frame.fPBiconsFrame.iconsFrame[i] = CreateFrame("Frame")
	frame.fPBiconsFrame.iconsFrame[i]:SetParent(frame.fPBiconsFrame)
	local buffIcon = frame.fPBiconsFrame.iconsFrame[i]

	buffIcon.texture = buffIcon:CreateTexture(nil, "BACKGROUND")
	buffIcon.texture:SetAllPoints(buffIcon)

	buffIcon.stacktext = buffIcon:CreateFontString(nil, "ARTWORK", "ChatFontNormal")
	buffIcon.stacktext:SetPoint("BOTTOMRIGHT", buffIcon.texture, "BOTTOMRIGHT", -1, 3)
	buffIcon.stacktext:SetText("")

	buffIcon.border = buffIcon:CreateTexture(nil,"BORDER")
	buffIcon.border:SetAllPoints(buffIcon.texture)

	buffIcon.cooldown = CreateFrame("Cooldown", nil, buffIcon, "CooldownFrameTemplate")
	buffIcon.cooldown:SetReverse(true)
	buffIcon.cooldown:SetDrawEdge(false)

	buffIcon.cd = buffIcon:CreateFontString(nil, "ARTWORK", "ChatFontNormal")
	buffIcon.cd:SetText("")
	buffIcon.cd:SetPoint("TOP", buffIcon, "BOTTOM", 0, -1)

	buffIcon.cdbg = buffIcon:CreateTexture(nil,"BACKGROUND")
	buffIcon.cdbg:SetColorTexture(0,0,0,.75)
	buffIcon.cdbg:SetPoint("CENTER", buffIcon.cd)

	buffIcon.stacktext:Hide()
	buffIcon.border:Hide()
	buffIcon.cooldown:Hide()
	buffIcon.cd:Hide()
	buffIcon.cdbg:Hide()

	buffIcon:SetScript("OnHide", iconOnHide)
	buffIcon:SetScript("OnUpdate", iconOnUpdate)
end


local function UpdateUnitAuras(nameplateID)
	local frame = C_NamePlate_GetNamePlateForUnit(nameplateID)
	if not frame then return end 	-- modifying friendly nameplates is restricted in instances since 7.2

	if FilterUnits(nameplateID) then
		if frame.fPBiconsFrame then
			frame.fPBiconsFrame:Hide()
		end
		return
	end

	ScanUnitBuffs(nameplateID, frame)
	if not PlatesBuffs[frame] then
		if frame.fPBiconsFrame then
			frame.fPBiconsFrame:Hide()
		end
		return
	end
	if not db.disableSort then
		table_sort(PlatesBuffs[frame],SortFunc)
	end

	if not frame.fPBiconsFrame then
		-- if parent == frame then it will change scale and alpha with nameplates
		-- otherwise use UIParent, but this causes mess of icon/border textures
		frame.fPBiconsFrame = CreateFrame("Frame", nil, db.parentWorldFrame and WorldFrame or frame)
	end
	if not frame.fPBiconsFrame.iconsFrame then
		frame.fPBiconsFrame.iconsFrame = {}
	end



	for i = 1, #PlatesBuffs[frame] do
		if not frame.fPBiconsFrame.iconsFrame[i] then
			CreateBuffIcon(frame,i)
		end

		local buff = PlatesBuffs[frame][i]
		local buffIcon = frame.fPBiconsFrame.iconsFrame[i]
		buffIcon.type = buff.type
		buffIcon.icon = buff.icon
		buffIcon.stack = buff.stack
		buffIcon.debufftype = buff.debufftype
		buffIcon.duration = buff.duration
		buffIcon.expiration = buff.expiration
		buffIcon.durationSize = buff.durationSize
		buffIcon.stackSize = buff.stackSize
		buffIcon.width = db.baseWidth * buff.scale
		buffIcon.height = db.baseHeight * buff.scale
		UpdateBuffIcon(buffIcon)
		buffIcon:Show()
	end
	frame.fPBiconsFrame:Show()

	if #frame.fPBiconsFrame.iconsFrame > #PlatesBuffs[frame] then
		for i = #PlatesBuffs[frame]+1, #frame.fPBiconsFrame.iconsFrame do
			if frame.fPBiconsFrame.iconsFrame[i] then
				frame.fPBiconsFrame.iconsFrame[i]:Hide()
			end
		end
	end

	DrawOnPlate(frame)
end

function fPB.UpdateAllNameplates()
	for i, p in ipairs(C_NamePlate_GetNamePlates()) do
		UpdateUnitAuras(p.namePlateUnitToken)
	end
end
local UpdateAllNameplates = fPB.UpdateAllNameplates

local function Nameplate_Added(...)
	local nameplateID = ...
	local frame = C_NamePlate_GetNamePlateForUnit(nameplateID)

	if frame.UnitFrame.BuffFrame then
		frame.UnitFrame.BuffFrame:SetAlpha(0)	--Hide terrible standart debuff frame
	end

	UpdateUnitAuras(nameplateID)
end
local function Nameplate_Removed(...)
	local nameplateID = ...
	local frame = C_NamePlate_GetNamePlateForUnit(nameplateID)

	if frame.fPBiconsFrame then
		frame.fPBiconsFrame:Hide()
	end
	if PlatesBuffs[frame] then
		PlatesBuffs[frame] = nil
	end
end

function fPB.CacheSpells() -- spells filtered by names, not checking id
	cachedSpells = {}
	for spell,s in pairs(db.Spells) do
		if not s.checkID and not db.ignoredDefaultSpells[spell] then
			if s.spellID then
				cachedSpells[s.name] = s.spellID
			else
				cachedSpells[s.name] = "noid"
			end
		end
	end
end
local CacheSpells = fPB.CacheSpells 
function fPB.AddNewSpell(spell)
	local defaultSpell
	if db.ignoredDefaultSpells[spell] then
		db.ignoredDefaultSpells[spell] = nil
		defaultSpell = true
	end
	local spellID = tonumber(spell)
	if db.Spells[spell] and not defaultSpell then
		if spellID then
			DEFAULT_CHAT_FRAME:AddMessage(chatColor..L["Spell with this ID is already in the list. Its name is "]..linkColor.."|Hspell:"..spellID.."|h["..GetSpellInfo(spellID).."]|h|r")
			return
		else
			DEFAULT_CHAT_FRAME:AddMessage(spell..chatColor..L[" already in the list."].."|r")
			return
		end
	end
	if spellID then
		if not db.Spells[spellID] then
			db.Spells[spellID] = {
				show = 1,
				name = GetSpellInfo(spellID),
				spellID = spellID,
				scale = 1,
				stackSize = db.stackSize,
				durationSize = db.durationSize,
			}
		end
	else
		db.Spells[spell] = {
			show = 1,
			name = spell,
			scale = 1,
			stackSize = db.stackSize,
			durationSize = db.durationSize,
		}
	end

	CacheSpells()
	UpdateAllNameplates()
	fPB.BuildSpellList()
end
function fPB.RemoveSpell(spell)
	if DefaultSettings.profile.Spells[spell] then
		db.ignoredDefaultSpells[spell] = true
	end
	db.Spells[spell] = nil
	CacheSpells()
	UpdateAllNameplates()
	fPB.BuildSpellList()
end
function fPB.ChangeSpellID(oldID, newID)
	if db.Spells[newID] then
		DEFAULT_CHAT_FRAME:AddMessage(chatColor..L["Spell with this ID is already in the list. Its name is "]..linkColor.."|Hspell:"..newID.."|h["..GetSpellInfo(newID).."]|h|r")
		return
	end
	db.Spells[newID] = {}
	for k,v in pairs(db.Spells[oldID]) do
		db.Spells[newID][k] = v
		db.Spells[newID].spellID = newID
	end
	fPB.RemoveSpell(oldID)
	DEFAULT_CHAT_FRAME:AddMessage(GetSpellInfo(newID)..chatColor..L[" ID changed "].."|r"..(tonumber(oldID) or "nil")..chatColor.." -> |r"..newID)
	UpdateAllNameplates()
	fPB.BuildSpellList()
end

local function ConvertDBto2()
	local temp
	for _,p in pairs(flyPlateBuffsDB.profiles) do
		if p.Spells then
			temp = {}
			for n,s in pairs(p.Spells) do
				local spellID = s.spellID
				if not spellID then
					for i=1, #defaultSpells1 do
						if n == GetSpellInfo(defaultSpells1[i]) then
							spellID = defaultSpells1[i]
							break
						end
					end
				end
				if not spellID then
					for i=1, #defaultSpells2 do
						if n == GetSpellInfo(defaultSpells2[i]) then
							spellID = defaultSpells2[i]
							break
						end
					end
				end
				local spell = spellID and spellID or n
				if spell then
					temp[spell] = {}
					for k,v in pairs(s) do
						temp[spell][k] = v
					end
					temp[spell].name = GetSpellInfo(spellID) and GetSpellInfo(spellID) or n
				end
			end
			p.Spells = temp
			temp = nil
		end
		if p.ignoredDefaultSpells then
			temp = {}
			for n,v in pairs(p.ignoredDefaultSpells) do
				local spellID
				for i=1, #defaultSpells1 do
					if n == GetSpellInfo(defaultSpells1[i]) then
						spellID = defaultSpells1[i]
						break
					end
				end
				if not spellID then
					for i=1, #defaultSpells2 do
						if n == GetSpellInfo(defaultSpells2[i]) then
							spellID = defaultSpells2[i]
							break
						end
					end
				end
				if spellID then
					temp[spellID] = true
				end
			end
			p.ignoredDefaultSpells = temp
			temp = nil
		end
	end
	flyPlateBuffsDB.version = 2
end
function fPB.OnProfileChanged()
	db = fPB.db.profile
	fPB.OptionsOnEnable()
	UpdateAllNameplates()
end
local function Initialize()
	if flyPlateBuffsDB and (not flyPlateBuffsDB.version or flyPlateBuffsDB.version < 2) then
		ConvertDBto2()
	end

	fPB.db = LibStub("AceDB-3.0"):New("flyPlateBuffsDB", DefaultSettings, true)
	fPB.db.RegisterCallback(fPB, "OnProfileChanged", "OnProfileChanged")
	fPB.db.RegisterCallback(fPB, "OnProfileCopied", "OnProfileChanged")
	fPB.db.RegisterCallback(fPB, "OnProfileReset", "OnProfileChanged")

	db = fPB.db.profile
	fPB.font = fPB.LSM:Fetch("font", db.font)
	CacheSpells()

	config:RegisterOptionsTable(AddonName, fPB.MainOptionTable)
	fPBMainOptions = dialog:AddToBlizOptions(AddonName, AddonName)

	config:RegisterOptionsTable(AddonName.." Spells", fPB.SpellsTable)
	fPBSpellsList = dialog:AddToBlizOptions(AddonName.." Spells", L["Specific spells"], AddonName)

	config:RegisterOptionsTable(AddonName.." Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(fPB.db))
	fPBProfilesOptions = dialog:AddToBlizOptions(AddonName.." Profiles", L["Profiles"], AddonName)

	SLASH_FLYPLATEBUFFS1, SLASH_FLYPLATEBUFFS2 = "/fpb", "/pb"
	function SlashCmdList.FLYPLATEBUFFS(msg, editBox)
		InterfaceOptionsFrame_OpenToCategory(fPBMainOptions)
		InterfaceOptionsFrame_OpenToCategory(fPBSpellsList)
		InterfaceOptionsFrame_OpenToCategory(fPBMainOptions)
	end
end

function fPB.RegisterCombat()
	fPB.Events:RegisterEvent("PLAYER_REGEN_DISABLED")
	fPB.Events:RegisterEvent("PLAYER_REGEN_ENABLED")
end
function fPB.UnregisterCombat()
	fPB.Events:UnregisterEvent("PLAYER_REGEN_DISABLED")
	fPB.Events:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

fPB.Events = CreateFrame("Frame")
fPB.Events:RegisterEvent("ADDON_LOADED")
fPB.Events:RegisterEvent("PLAYER_ENTERING_WORLD")

fPB.Events:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" and (...) == AddonName then
		Initialize()
	elseif event == "PLAYER_ENTERING_WORLD" then
		fPB.OptionsOnEnable()
		fPB.FixBlizzard()
		if db.showSpellID then fPB.ShowSpellID() end

		fPB.Events:RegisterEvent("NAME_PLATE_UNIT_ADDED")
		fPB.Events:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

		if db.showOnlyInCombat then
			fPB.RegisterCombat()
		else
			fPB.Events:RegisterEvent("UNIT_AURA")
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		fPB.Events:RegisterEvent("UNIT_AURA")
		UpdateAllNameplates()
	elseif event == "PLAYER_REGEN_ENABLED" then
		fPB.Events:UnregisterEvent("UNIT_AURA")
		UpdateAllNameplates()
	elseif event == "NAME_PLATE_UNIT_ADDED" then
		Nameplate_Added(...)
	elseif event == "NAME_PLATE_UNIT_REMOVED" then
		Nameplate_Removed(...)
	elseif event == "UNIT_AURA" then
		if strmatch((...),"nameplate%d+") then
			UpdateUnitAuras(...)
		end
	end
end)
