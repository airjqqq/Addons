local parent = AirjMacros
local mod = {}
local AceGUI = LibStub("AceGUI-3.0")
local AceEvent = LibStub("AceEvent-3.0")
local LAB = LibStub("LibActionButton-1.0")
local ICONSIZE = 40
mod.buttons = {}

function mod:UpdateMainGroup()

end

local macroWidgets = {
	{
		widget = "Heading",
		text = "简要设置",
		width = "fill",
	},
	{
		key = "disable",
		widget = "CheckBox",
		text = "禁用",
	},
	{
		key = "dotdelete",
		widget = "CheckBox",
		text = "不删除",
	},
	{
		key = "binding",
		widget = "Keybinding",
		text = "按键绑定",
		width = "x2",
	},
	{
		key = "spell",
		widget = "EditBox",
		text = "技能名称",
		width = "x2",
	},
	{
		key = "delete",
		widget = "Button",
		text = "删除",
		desc = "按住Ctrl",
	},
	{
		key = "deleteAllDefault",
		widget = "Button",
		text = "删除默认按键",
		desc = "按住ALT+SHIFT",
		width = "x2",
	},
	{
		key = "spellId",
		widget = "EditBox",
		text = "技能Id",
		width = "fill",
	},
	{
		widget = "SimpleGroup",
			width = "fill",
	},
	{
		key = "help",
		widget = "CheckBox",
		text = "友善技能",
		width = 120,
	},
	{
		key = "mouseover",
		widget = "CheckBox",
		text = "鼠标指向",
		width = 120,
	},
	{
		key = "altself",
		widget = "CheckBox",
		text = "[alt]自身",
		width = 120,
	},
	{
		key = "altfocus",
		widget = "CheckBox",
		text = "[alt]焦点",
		width = 120,
	},
	{
		key = "stopcasting",
		widget = "CheckBox",
		text = "停止施法",
		width = 120,
	},
	{
		key = "startattack",
		widget = "CheckBox",
		text = "停止施法",
		width = 120,
	},
	{
		widget = "Heading",
		text = "高级设置",
		desc = "需要与[按键设置]中的技能名完全一致",
			width = "fill",
	},
	{
		key = "macrotext",
		widget = "MultiLineEditBox",
		text = "宏",
			width = "fill",
	},
}

local function SetDescription(widget,desc)
	widget:SetCallback("OnEnter",function(widget)
		GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT");
		GameTooltip:AddLine(desc, 1, 1, 1, 1);
		GameTooltip:Show();
		GameTooltip:SetFrameLevel(50);
	end)
	widget:SetCallback("OnLeave", function(widget)
		GameTooltip:Hide()
	end)
end

local function SetIconDescription(frame)
	frame:SetScript("OnEnter",function(frame)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT");
		GameTooltip:AddLine(frame.key);
		local pres = {"","SHIFT-","ALT-","CTRL-"}
		local currentKeys = {}
		for k,v in pairs(pres) do
			local key = v..frame.key
			local spellId = mod.currentDatas[key].spellId or ""
			local spellIds = {strsplit(",",spellId)}
			local spellName = mod.currentDatas[key].spell or ""
			local icons ={}
			local spellNames = {strsplit(",",spellName)}
			for _,sn in ipairs(spellNames) do
				local _,_,icon = GetSpellInfo(sn)
				if icon and icon ~= "" then
					icons[#icon+1] = icon
				end
			end
			if spellName~= "" then
				GameTooltip:AddDoubleLine(spellName,key,1,1,1,1,1,1);
			end
			for _,icon in pairs(icons) do
				if icon and icon ~= "" then
					GameTooltip:AddTexture(icon)
				end
			end
		end
		GameTooltip:Show();
		GameTooltip:SetFrameLevel(50);

	end)
	frame:SetScript("OnLeave", function(frame)
		GameTooltip:Hide()
	end)
end

function mod:CreateButton(key,parent)
	local button = CreateFrame("Button",nil,parent)
	button:SetSize(ICONSIZE,ICONSIZE)
	button:SetBackdropColor(1,1,0)
	local backdrop = {
	  -- path to the background texture
	  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	  -- path to the border texture
	  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	  -- true to repeat the background texture to fill the frame, false to scale it
	  tile = true,
	  -- size (width or height) of the square repeating background tiles (in pixels)
	  tileSize = 20,
	  -- thickness of edge segments and square size of edge corners (in pixels)
	  edgeSize = 14,
	  -- distance from the edges of the frame to those of the background texture (in pixels)
	  insets = {
	    left = 3,
	    right = 3,
	    top = 2,
	    bottom = 2
	  }
	}
	button:SetBackdrop(backdrop)
	button:SetBackdropColor(0, 0, 0)
	button:SetFrameStrata("HIGH")
	button:RegisterForClicks("MiddleButtonUp","LeftButtonUp","RightButtonUp")
	button:RegisterForDrag("LeftButton","RightButton")
	SetIconDescription(button)
	local fontstring = button:CreateFontString()
	fontstring:SetFontObject(GameFontHighlight)
	fontstring:SetPoint("TOPRIGHT")
	local keyName = key
	if keyName:find("NUMPAD") then
		keyName = "n"..keyName:sub(7,7)
	elseif keyName:len() >3 then
		keyName = keyName:sub(1,3)
	end
	fontstring:SetText(keyName)
	button.fontstring = fontstring

	local texture = button:CreateTexture()
	texture:SetAllPoints()
	texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
	button.texture = texture

	local selected = button:CreateTexture()
	selected:SetAllPoints()
	selected:SetTexture(0,1,0)
	selected:SetDrawLayer("OVERLAY", 0)
	selected:SetAlpha(0.3)
	selected:SetBlendMode("ADD")
	selected:Hide()
	button.selected = selected

	local hasmacro = button:CreateTexture()
	hasmacro:SetAllPoints()
	hasmacro:SetTexture(0,1,1)
	hasmacro:SetDrawLayer("OVERLAY", 0)
	hasmacro:SetAlpha(0.6)
	hasmacro:SetBlendMode("ADD")
	hasmacro:Hide()
	button.hasmacro = hasmacro

	local ignore = button:CreateTexture()
	ignore:SetAllPoints()
	ignore:SetTexture(0.5,0,1)
	ignore:SetDrawLayer("OVERLAY", 0)
	ignore:SetAlpha(0.6)
	ignore:SetBlendMode("ADD")
	ignore:Hide()
	button.ignore = ignore

	local function OnReceiveDrag(b,mouseButton)
		 if not mod.currentDatas then
			return
		end
		local keyStr = b.key
		if IsShiftKeyDown() then
			keyStr = "SHIFT-"..keyStr
		elseif IsAltKeyDown() then
			keyStr = "ALT-"..keyStr
		elseif IsControlKeyDown() then
			keyStr = "CTRL-"..keyStr
		end

		local type, data, subType, subData = GetCursorInfo()
		local spellName, spellId
		if type == "spell" then
			spellName = GetSpellInfo(subData)
			spellId = subData
			ClearCursor()
		elseif type == "item" then
			spellName = GetItemInfo(data)
			spellId = "i"..data
			ClearCursor()
		elseif type == "mount" then
			local name,id = C_MountJournal.GetMountInfo(subType)
			spellName = name
			spellId = id
			ClearCursor()
		end
		mod.currentData = mod.currentDatas[keyStr]
		if not mod.currentData.spellId and spellId then
			local name = GetSpellInfo(spellId)
			if name and IsHelpfulSpell(name) then
				mod.currentData.help = true
			end
		end
		if mouseButton == "MiddleButton" then
			self.currentData.spell = nil
			self.currentData.spellId = nil
		end
		if spellId then
			if self.currentData.spellId then
				spellId = self.currentData.spellId..","..spellId
			end
			self.currentData.spellId = spellId
		end
--		if spellName then
--			if self.currentData.spell then
--				spellName = self.currentData.spell..","..spellName
--			end
--			self.currentData.spell = spellName
--		end
		mod:UpdateKeyboard()
	end

	button:SetScript("OnClick", function(b,mouseButton)
		OnReceiveDrag(b,mouseButton)
	end)

	button:SetScript("OnReceiveDrag", function(b)
		OnReceiveDrag(b,nil)
	end)

	button:SetScript("OnDragStart", function(b,button)
		if not mod.currentDatas then
			return
		end

		local keyStr = b.key
		if IsShiftKeyDown() then
			keyStr = "SHIFT-"..keyStr
		elseif IsAltKeyDown() then
			keyStr = "ALT-"..keyStr
		elseif IsControlKeyDown() then
			keyStr = "CTRL-"..keyStr
		end
		mod.dragData = mod.currentDatas[keyStr]
		mod.dragButton = button

		local spellNames = {strsplit(",", mod.currentDatas[keyStr].spell or "")}
		local spellIds = {strsplit(",", mod.currentDatas[keyStr].spellId or "")}
		local texture
		for k,v in ipairs(spellIds) do
			_,_,texture = GetSpellInfo(v)
			if texture and texture~="" then
				break
			end
		end
		if not texture or texture == "" then
			for k,v in ipairs(spellNames) do
				_,_,texture = GetSpellInfo(v)
				if texture and texture~="" then
					break
				end
			end
		end

		if not texture or texture == "" then
			texture = "Interface\\Icons\\INV_Misc_QuestionMark"
		end

		SetCursor(texture)
	end)

	button:SetScript("OnDragStop", function(self,button)
		if not mod.currentDatas then
			return
		end
		ResetCursor()
		if(GetMouseFocus().key) then
			local targetkey = GetMouseFocus().key

			local keyStr = targetkey
			if IsShiftKeyDown() then
				keyStr = "SHIFT-"..keyStr
			elseif IsAltKeyDown() then
				keyStr = "ALT-"..keyStr
			elseif IsControlKeyDown() then
				keyStr = "CTRL-"..keyStr
			end
			targetkey = keyStr

			local targetData = mod.currentDatas[targetkey]
			mod.currentDatas[targetkey] = {}
			local newtargetData = mod.currentDatas[targetkey]
			for k,v in pairs(mod.dragData) do
				newtargetData[k] = v
			end
			newtargetData.key = targetkey
			if mod.dragButton == "LeftButton" then
				local sourcekey = mod.dragData.key
				mod.currentDatas[sourcekey] = {}
				local sourceData = mod.currentDatas[sourcekey]
				for k,v in pairs(targetData) do
					sourceData[k] = v
				end
				sourceData.key = sourcekey
			end
			mod.currentData = mod.currentDatas[targetkey]
			mod:UpdateKeyboard()
		end
	end)

	button.key = key
	return button
end

function mod:UpdateKeyboard()
	local data = self.currentData
	if not data then
		self.disable:SetDisabled(true)
		self.binding:SetDisabled(true)
		self.spell:SetDisabled(true)
		self.spellId:SetDisabled(true)
		self.help:SetDisabled(true)
		self.mouseover:SetDisabled(true)
		self.altself:SetDisabled(true)
		self.altfocus:SetDisabled(true)
		self.macrotext:SetDisabled(true)

	else
		self.disable:SetDisabled(false)
		self.binding:SetDisabled(false)
		self.spell:SetDisabled(false)
		self.spellId:SetDisabled(false)
		self.help:SetDisabled(false)
		self.mouseover:SetDisabled(false)
		self.altself:SetDisabled(false)
		self.altfocus:SetDisabled(false)
		self.macrotext:SetDisabled(false)

		self.disable:SetValue(data.disable)
		self.dotdelete:SetValue(data.dotdelete)

		self.binding:SetKey(data.key)
		self.spell:SetText(data.spell)
		self.spellId:SetText(data.spellId)
		self.help:SetValue(data.help)
		self.mouseover:SetValue(data.mouseover)
		self.altself:SetValue(data.altself)
		self.altfocus:SetValue(data.altfocus)
		self.stopcasting:SetValue(data.stopcasting)
		self.startattack:SetValue(data.startattack)

		local macrotext,realmacro = parent:GetMacroText(data)
		macrotext = macrotext or ""
		if not realmacro then
			self.macrotext.editBox:SetTextColor(1, 1, 0, 1)
		else
			self.macrotext.editBox:SetTextColor(1, 1, 1, 1)
		end
		self.macrotext:SetText(macrotext)
	end
	self:UpDateIcons()
	parent:UpdateRealButtons()
end

function mod:UpDateIcons()
	local pres = {"","SHIFT-","ALT-","CTRL-"}
	local data = self.currentData

	local pre
	if IsShiftKeyDown() then
		pre = "SHIFT-"
	elseif IsAltKeyDown() then
		pre = "ALT-"
	elseif IsControlKeyDown() then
		pre = "CTRL-"
	else
		pre = ""
	end
	for key,button in pairs(self.buttons) do

		local currentKeys = {}
		for k,v in pairs(pres) do
			currentKeys[v..key] = true
		end


		if self.currentDatas[pre..key].disable then
			button.ignore:Show()
		else
			button.ignore:Hide()
			if self.currentDatas[pre..key].macrotext then
				button.hasmacro:Show()
			else
				button.hasmacro:Hide()
			end
		end

		if data and currentKeys[data.key] then
			button.selected:Show()
		else
			button.selected:Hide()
		end
		self:SetIconTexture(button,self.currentDatas[pre..key])
	end
end

function mod:SetIconTexture(button,data)
	local defaultTexture = "Interface\\Icons\\INV_Misc_QuestionMark"
	local spellName = data.spell or ""
	local spellId = data.spellId or ""
	local texture
	for k,v in ipairs({strsplit(",",spellId)}) do
		texture = GetSpellTexture(v or "")
		if not texture or texture=="" then
			texture = v and (v~="") and GetItemIcon(string.sub(v,2)) or nil
		end
		if texture and texture ~= "" then
			break
		end
	end
	if not texture or texture == "" then
		for k,v in ipairs({strsplit(",",spellName)}) do
			texture = GetSpellTexture(v or "")
			if not texture or texture=="" then
				texture = v and (v~="") and GetItemIcon(v) or nil
			end
			if texture and texture ~= "" then
				break
			end
		end
	end
	if not texture or texture == "" then
		local macrotext = data.macrotext or AirjMacros:GetMacroText(data)
		if macrotext then
			local submacro = {strsplit("\n",macrotext)}
			for i,v in ipairs(submacro) do
				if v~="" then
					local spell,target = SecureCmdOptionParse(v)
					local macrotexture = GetSpellTexture(spell or "")
					if not macrotexture or macrotexture=="" then
						macrotexture = GetItemIcon(spell or "")
					end
					if macrotexture and macrotexture~="" and macrotexture~=defaultTexture then
						texture = macrotexture
						break
					end
				end
			end
		end
	end
	if not texture or texture == "" then
		for k,v in ipairs({strsplit(",",spellId)}) do
			local mod,id = string.match(v,"%[(.+)%](.+)")
			texture = GetSpellTexture(id or "")
			if not texture or texture=="" then
				texture = id and (id~="") and GetItemIcon(string.sub(id,2)) or nil
			end
			if texture and texture ~= "" then
				break
			end
		end
	end


	if not texture or texture == "" then
		if data.spell or data.spellId or data.macrotext then
			texture = defaultTexture
		else
			texture = ""
		end
	end
	button.texture:SetTexture(texture)
end


function mod:CreateKeyboard(group)
	local keyboardbg = AceGUI:Create("ScrollFrame")
	keyboardbg:SetHeight((ICONSIZE+2)*4)
	keyboardbg:SetFullWidth(true)
	group:AddChild(keyboardbg)

	local keyArray = parent.keyArray
	widthArray = {
		TAB = 1.5,
		CAPSLOCK = 1.8,
	}
	offsetArray = {
		Z = 2.3,
		MOUSEWHEELDOWN = 0.5,
		MOUSEWHEELUP = 0.5,
		BUTTON5 = 0.5,
		BUTTON4 = 0.5,
	}
--	local header = CreateFrame("CheckButton", "AirjMacrosHeader", UIParent,"SecureHandlerEnterLeaveTemplate")
	local header = CreateFrame("Frame", "AirjMacrosHeader", group and group.frame or UIParent)
	header:SetSize(1,ICONSIZE)
	header:SetPoint("TOPLEFT")
	local anchor
	for row,keys in pairs(keyArray)do
		anchor = header
		for index, key in pairs(keys) do
			local button = self:CreateButton(key,header)
			local width = button:GetWidth();
			if index == 1 then
				local xoffset,yoffset
				if row>=5 then
					xoffset = width * 8
					yoffset = -(row-5)*(ICONSIZE+0)
				else
					xoffset = 0
					yoffset = -(row-1)*(ICONSIZE+0)
				end
				button:SetPoint("LEFT",anchor,"RIGHT",xoffset + 0 + (offsetArray[key] or 0)*width,yoffset)
			else
				button:SetPoint("LEFT",anchor,"RIGHT",0 + (offsetArray[key] or 0)*width,0)
			end
			if widthArray[key] then
				button:SetWidth(width*widthArray[key])
			end
			button:Show()
			self.buttons[key] = button
			anchor = button
		end
	end

	local widgets = macroWidgets
	for i,v in ipairs(widgets) do
		local widget = AceGUI:Create(v.widget)
		if widget.SetLabel then
			widget:SetLabel(v.text)
		elseif widget.SetText then
			widget:SetText(v.text)
		end
		if v.min and v.max and v.step and widget.SetSliderValues then
			widget:SetSliderValues(v.min,v.max,v.step)
		end
		SetDescription(widget,v.desc)
		if v.width == "fill" then
			widget:SetFullWidth(true)
		elseif v.width == "x2" then
			widget:SetWidth(160)
		else
			widget:SetWidth(v.width or 80)
		end
		group:AddChild(widget)
		if v.key then
			self[v.key] = widget
		end
	end
	self.spellId.editbox:SetScript("OnReceiveDrag", function(frame)
		local self = frame.obj
		local type, id, info = GetCursorInfo()
		if type == "item" then
			local spellId = "i"..id
			self:SetText(spellId)
			self:Fire("OnEnterPressed", spellId)
			ClearCursor()
		elseif type == "spell" then
			local _,_,_,_,_,_,spellId = GetSpellInfo(id, info)
			self:SetText(spellId)
			self:Fire("OnEnterPressed", spellId)
			ClearCursor()
		elseif type == "mount" then
			local _,name = C_MountJournal.GetMountInfo(info)
			self:SetText(name)
			self:Fire("OnEnterPressed", name)
			ClearCursor()
		end
		AceGUI:ClearFocus()
	end)

	self.disable:SetCallback("OnValueChanged",function(widget,event,checked)
		self.currentData.disable = checked
		self:UpdateKeyboard()
	end)
	self.dotdelete:SetCallback("OnValueChanged",function(widget,event,checked)
		self.currentData.dotdelete = checked
		self:UpdateKeyboard()
	end)
	self.binding:SetCallback("OnKeyChanged",function(widget,event,keyPressed)
		local key = self.currentData.key
		self.currentDatas[keyPressed] = self.currentData
		self.currentDatas[key] = nil
		self.currentData.key = keyPressed
		self:UpdateKeyboard()
	end)

	self.spell:SetCallback("OnEnterPressed",function(widget,event,text)
		self.currentData.spell = text
		self:UpdateKeyboard()
	end)
	self.spellId:SetCallback("OnEnterPressed",function(widget,event,text)
		self.currentData.spellId = text
		self:UpdateKeyboard()
	end)
	self.delete:SetCallback("OnClick",function(widget,event)
		if IsControlKeyDown() then
			self.currentDatas[self.currentData.key] = nil
		end
		self:UpdateKeyboard()
	end)
	self.deleteAllDefault:SetCallback("OnClick",function(widget,event)
		if IsShiftKeyDown() and IsAltKeyDown() then
			for k,v in pairs(self.currentDatas) do
				if (not v.macrotext or v.macrotext == "") and not v.dotdelete then
					self.currentDatas[k] = nil
				end
			end
		end
		self:UpdateKeyboard()
	end)
	self.help:SetCallback("OnValueChanged",function(widget,event,checked)
		self.currentData.help = checked
		self:UpdateKeyboard()
	end)
	self.mouseover:SetCallback("OnValueChanged",function(widget,event,checked)
		self.currentData.mouseover = checked
		self:UpdateKeyboard()
	end)
	self.altself:SetCallback("OnValueChanged",function(widget,event,checked)
		self.currentData.altself = checked
		self:UpdateKeyboard()
	end)
	self.altfocus:SetCallback("OnValueChanged",function(widget,event,checked)
		self.currentData.altfocus = checked
		self:UpdateKeyboard()
	end)
	self.stopcasting:SetCallback("OnValueChanged",function(widget,event,checked)
		self.currentData.stopcasting = checked
		self:UpdateKeyboard()
	end)
	self.startattack:SetCallback("OnValueChanged",function(widget,event,checked)
		self.currentData.startattack = checked
		self:UpdateKeyboard()
	end)
	self.macrotext:SetHeight(180)
	self.macrotext:SetCallback("OnEnterPressed",function(widget,event,text)
		if text == "" then
			text = nil
		end
		self.currentData.macrotext = text
		self:UpdateKeyboard()
	end)


	AceEvent:RegisterEvent("MODIFIER_STATE_CHANGED",function(...)
		self:UpDateIcons()
	end)
end

function mod:KeyBoard()
	local mainGroup = self.mainGroup
	if not mainGroup then
		mainGroup = AceGUI:Create("ScrollFrame")
		mainGroup:SetLayout("Flow")
		self.mainGroup = mainGroup
		mod:CreateKeyboard(mainGroup)
		local tabGroup = parent.tabGroup
		tabGroup:AddChild(mainGroup)
	end
	if parent.selectedIndex and parent.selectedIndex > 0 then
		mainGroup.frame:Show()
		local currentDatas = parent.macroDataBaseArray[parent.selectedIndex].macroArray
		self.currentDatas = setmetatable(currentDatas,{__index = function(tb,key)
			tb[key] = {key = key}
			return tb[key]
		end})
		self:UpdateMainGroup()
		self:UpdateKeyboard()
		parent:SelectTab(mainGroup)
	else
		mainGroup.frame:Hide()
	end
end

function parent:KeyBoard()
	mod:KeyBoard()
end

parent:RegisterTab("KeyBoard","键盘设置",mod)
