AirjAutoKey_GUI = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKey_GUI", "AceConsole-3.0", "AceEvent-3.0");
--local L = LibStub("AceLocale-3.0"):GetLocale("AirjAutoKey_GUI", true)
local meta = {
__index = function(t,k) return k end
}
local L = setmetatable({}, meta);
local AceGUI = LibStub("AceGUI-3.0");

function AirjAutoKey_GUI:OnInitialize()
	-- Called when the addon is loaded

	-- Print a message to the chat frame
	self:Print("OnInitialize Event Fired: Hello")
	self:CreateGUI();
	self:RegisterMessage("AIRJAUTOKEY_SPELL_TEXTURE_CHANGED");
	self:RegisterMessage("AIRJAUTOKEY_CONFIG_CHANGED");
end

function AirjAutoKey_GUI:OnEnable()
	-- Called when the addon is enabled

	-- Print a message to the chat frame
	self:Print("OnEnable Event Fired: Hello, again ;)")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

function AirjAutoKey_GUI:OnDisable()
	-- Called when the addon is disabled
end

local castingname
function AirjAutoKey_GUI:COMBAT_LOG_EVENT_UNFILTERED(realEvent,timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,...)
	if (event == "SPELL_CAST_SUCCESS" or event == "SPELL_CAST_START") and UnitGUID("player") == sourceGUID then
		local spellid = select(1,...)
		local spellName = select(2,...)
		local name,_,texture = GetSpellInfo(spellid)
		if GetSpellCooldown(name) or true then
			if not(castingname and castingname== name) and event == "SPELL_CAST_SUCCESS" or event == "SPELL_CAST_START" then
				local class
				if destGUID and destGUID then
					_,_,class = pcall(GetPlayerInfoByGUID,destGUID);
				end
				destName = AirjAutoKey:FindUnitByGUID(destGUID) or destName
				if not destName and (event == "SPELL_CAST_START" or spellName and SpellHasRange(spellName)) then  -- and GetTime() - AirjAutoKey.lastCastSendTime < 1.5
					destName = AirjAutoKey.lastSentUnitList[spellName]
					destGUID = AirjAutoKey.lastSentList[spellName]
					_,_,class = pcall(GetPlayerInfoByGUID,destGUID);
				end
				self:CreateCastedIcon(spellid,texture,destName,class)
				--print(name)
			end
			if event == "SPELL_CAST_START" then
				castingname = name
			else
				castingname = nil
			end
		end
	end
	if UnitGUID("player") == sourceGUID then
--		dump({realEvent,timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,...})
	end
end

function AirjAutoKey_GUI:AIRJAUTOKEY_SPELL_TEXTURE_CHANGED(event,spellId)
	local cd = self.castIconCooldown
	cd:Show()
	cd:SetReverse(false)
	self.castSpellId = spellId
	self.spellTexture = GetSpellTexture(spellId)

	local spellId = self.castSpellId
	self.castIconTexture:SetTexture(self.spellTexture or "");
	local spellName = GetSpellInfo(spellId) or ""
	local selfName = GetSpellBookItemName(spellName) or ""
	local start, duration, enabled = GetSpellCooldown(selfName);
	if start and start~=0 then
		local cd = self.castIconCooldown
		cd:SetCooldown(start, duration,0,1);
		cd:Show()
		cd:SetAlpha(1)
		cd:SetReverse(false)
	end
end

function AirjAutoKey_GUI:AIRJAUTOKEY_CONFIG_CHANGED(event,key,value,starter)
	if starter and starter == "AirjAutoKey_GUI" then return end
	local widgetArray =
	{
		auto = self.autoCheckBox,
		cd = self.longCDCheckBox,
		target = self.multiCheckBox,
	}
	if not widgetArray[key] then return end
	local widget = widgetArray[key];
	local flag
	if key == "target" then
		flag = value >= 3;
	elseif key == "cd" then
		flag = value >60;
	else
		flag = value and true;
	end
	self:UnregisterMessage("AIRJAUTOKEY_CONFIG_CHANGED");
	widget:SetValue(flag);
	self:RegisterMessage("AIRJAUTOKEY_CONFIG_CHANGED");
end
function AirjAutoKey_GUI:CreateGUI()
	local anchor = CreateFrame("Frame","AirjAutoKey_GUI_anchor",UIParent);
	anchor:SetSize(270,20);
	anchor:SetPoint("CENTER");
	anchor:EnableMouse(true);
	anchor:SetMovable(true);
	anchor:RegisterForDrag("LeftButton");
	anchor:SetScript("OnDragStart", function(self,button)
		self:StartMoving();
	end)
	anchor:SetScript("OnDragStop", function(self,button)
		self:StopMovingOrSizing();
		self:SetUserPlaced(true)
	end)
	anchor:SetScript("OnMouseDown", function(self,button)
		if IsShiftKeyDown() then
			self:Hide();
		end
	end)
	anchor:Hide()
	self.anchor = anchor;

	local anchorbackground = anchor:CreateTexture(nil,"BACKGROUND");
	anchorbackground:SetAllPoints();
	anchorbackground:SetTexture(0,0.5,0)

	local fontString = anchor:CreateFontString(nil,"OVERLAY","GameFontHighlight");
	fontString:SetAllPoints();
	fontString:SetText("anchor");

	local container = CreateFrame("Frame","AirjAutoKey_GUI_frame",UIParent);
	container:SetSize(270,68);
	container:SetPoint("TOPLEFT",anchor,"BOTTOMLEFT");
	self.container = container;

	local background = container:CreateTexture(nil,"BACKGROUND");
	background:SetAllPoints();
	background:SetTexture(0,0,0,0.2)

	local castIcon = CreateFrame("Frame",nil, container)
	castIcon:SetPoint("TOPLEFT",container,"TOPLEFT",2,-2);
	castIcon:SetSize(64,64)
	self.castIcon = castIcon

	local castIconCooldown = CreateFrame("Cooldown",nil,castIcon,"CooldownFrameTemplate")
	castIconCooldown:SetAllPoints();
	castIconCooldown:SetCooldown(GetTime(), 1)
	castIconCooldown:SetScript("OnUpdate",function()
--		if self.castSpellId then
--			local spellId = self.castSpellId
--			self.castIconTexture:SetTexture(self.spellTexture or "");
--			local spellName = GetSpellInfo(spellId) or ""
--			local selfName = GetSpellBookItemName(spellName) or ""
--			local start, duration, enabled = GetSpellCooldown(selfName);
--			if start and start~=0 then
--				local cd = self.castIconCooldown
--				cd:SetCooldown(start, duration,0,1);
--				cd:Show()
--				cd:SetAlpha(1)
--				cd:SetReverse(false)
--			end
--
--		end
	end)
	self.castIconCooldown = castIconCooldown;

	local castIconTexture = castIcon:CreateTexture(nil,"BACKGROUND")
	castIconTexture:SetAllPoints()
	castIconTexture:SetTexture(0,0,0)
	self.castIconTexture = castIconTexture;

	local starter = "AirjAutoKey_GUI"
	local autoCheckBox = AceGUI:Create("CheckBox");
	autoCheckBox:SetPoint("BOTTOMLEFT",castIconCooldown,"BOTTOMRIGHT");
	autoCheckBox:SetWidth(100);
	autoCheckBox:SetHeight(20)
	autoCheckBox:SetLabel(L["自动循环"]);
	autoCheckBox:SetCallback("OnEnter", function(widget)
		GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT");
		GameTooltip:AddLine(L["Check this box will automatic cast the spell, even without pressing any key"], 1, 1, 1, 1);
		GameTooltip:Show();
	end)
	autoCheckBox:SetCallback("OnLeave", function(widget)
		GameTooltip:Hide()
	end)
	autoCheckBox:SetCallback("OnValueChanged", function(widget, event, value)
		if value then
			AirjAutoKey:SetConfigValue("auto", true, starter)
		else
			AirjAutoKey:SetConfigValue("auto", false, starter)
		end
	end)
	autoCheckBox.frame:SetParent(container);
	autoCheckBox.frame:Show();
	self.autoCheckBox = autoCheckBox

	local longCDCheckBox = AceGUI:Create("CheckBox");
	longCDCheckBox:SetPoint("BOTTOMLEFT",castIconCooldown,"BOTTOMRIGHT",0,18);
	longCDCheckBox:SetWidth(100);
	longCDCheckBox:SetHeight(20)
	longCDCheckBox:SetLabel(L["大招"]);
	longCDCheckBox:SetCallback("OnEnter", function(widget)
		GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT");
		GameTooltip:AddLine(L["Check this box will cast the big move spell."], 1, 1, 1, 1);
		GameTooltip:Show();
	end)
	longCDCheckBox:SetCallback("OnLeave", function(widget)
		GameTooltip:Hide()
	end)
	longCDCheckBox:SetCallback("OnValueChanged", function(widget, event, value)
		if value then
			AirjAutoKey:SetConfigValue("cd", 600, starter)
		else
			AirjAutoKey:SetConfigValue("cd", 60, starter)
		end
	end)
	longCDCheckBox.frame:SetParent(container);
	longCDCheckBox.frame:Show();
	self.longCDCheckBox = longCDCheckBox

	local multiCheckBox = AceGUI:Create("CheckBox");
	multiCheckBox:SetPoint("BOTTOMLEFT",castIconCooldown,"BOTTOMRIGHT",100,18);
	multiCheckBox:SetWidth(100);
	multiCheckBox:SetHeight(20)
	multiCheckBox:SetLabel(L["多目标"]);
	multiCheckBox:SetCallback("OnEnter", function(widget)
		GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT");
		GameTooltip:AddLine(L["Check this box will cast multi target spells."], 1, 1, 1, 1);
		GameTooltip:Show();
	end)
	multiCheckBox:SetCallback("OnLeave", function(widget)
		GameTooltip:Hide()
	end)
	multiCheckBox:SetCallback("OnValueChanged", function(widget, event, value)
		if value then
			AirjAutoKey:SetConfigValue("target", 3, starter)
		else
			AirjAutoKey:SetConfigValue("target", 1, starter)
		end
	end)
	multiCheckBox.frame:SetParent(container);
	multiCheckBox.frame:Show();
	self.multiCheckBox = multiCheckBox

	local movableCheckBox = AceGUI:Create("CheckBox");
	movableCheckBox:SetPoint("BOTTOMLEFT",castIconCooldown,"BOTTOMRIGHT",100,0);
	movableCheckBox:SetWidth(100);
	movableCheckBox:SetHeight(20)
	movableCheckBox:SetLabel(L["移动框体"]);
	movableCheckBox:SetCallback("OnEnter", function(widget)
		GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT");
		GameTooltip:AddLine(L["Check this box will show the anchor frame."], 1, 1, 1, 1);
		GameTooltip:Show();
	end)
	movableCheckBox:SetCallback("OnLeave", function(widget)
		GameTooltip:Hide()
	end)
	movableCheckBox:SetCallback("OnValueChanged", function(widget, event, value)
		if value then
			anchor:Show()
		else
			anchor:Hide()
		end
	end)
	movableCheckBox.frame:SetParent(container);
	movableCheckBox.frame:Show();
	self.movableCheckBox = movableCheckBox
end
local iconLevel = 0
function AirjAutoKey_GUI:CreateCastedIcon(spellid,textureString,text,class)

--	self:Print("CreateCastedIcon")
	local container = self.container;
	local castIconCooldown = self.castIconCooldown;
	local icon = CreateFrame("Frame",nil,container);
	icon:SetSize(32,32);
	icon:SetPoint("TOPRIGHT",castIconCooldown,"TOPRIGHT",64,0);
	icon:SetFrameLevel(iconLevel)
	icon:Raise()
	iconLevel = iconLevel +1;
	if iconLevel > 99 then
		iconLevel = 1;
	end

	local texture = icon:CreateTexture(nil,"BACKGROUND");
	texture:SetAllPoints();
	texture:SetTexture(textureString);
	local fontString = icon:CreateFontString(nil,"OVERLAY","GameFontHighlight");
	if iconLevel%2 == 0 then
		fontString:SetPoint("BOTTOMLEFT");
	else
		fontString:SetPoint("TOPLEFT");
	end
	--fontString:SetAllPoints();
	f,s = fontString:GetFont();
	fontString:SetFont(f,14);
	fontString:SetSize(64,20);
	fontString:SetText(text);
	local color = RAID_CLASS_COLORS[class or ""]
	if color then
		fontString:SetTextColor(color.r,color.g,color.b)
	end
	--local start,duration = GetSpellCooldown(AirjAutoKey.spellArray.gcd or "")
	local start,duration = GetSpellCooldown(AirjAutoKey.GCDSpell)
	if start and start ~= 0 then
		self.gcdTime = duration
	end
	duration = duration ~= 0 and duration or self.gcdTime or 1
	icon:SetWidth(duration*32)
	local animationGroup = icon:CreateAnimationGroup();
	local animation = animationGroup:CreateAnimation("Translation");
	animation:SetOffset(32*5, 0);
	animation:SetDuration(1*5);
	animation:SetOrder(1);
	animation:SetSmoothing("NONE")
	animationGroup:Play();
	animationGroup:SetScript("OnFinished",function(self)
		icon:Hide();
	end)
end
