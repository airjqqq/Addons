local parent = AirjAutoKey_Options
local mod = {}
local AirjAutoKey = AirjAutoKey
local AceGUI = LibStub("AceGUI-3.0")


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

local widgets = {
	{
		key = "spell",
		widget = "EditBox",
		text = "函数名称",
		desc = "修改已被循环设定的函数名可能引起致命错误,请勿随意改动",
		width = 320,
	},
	{
		key = "heading",
		widget = "SimpleGroup",
		text = "",
		width = "fill",
	},
	{
		key = "new",
		widget = "Button",
		text = "新建",
		desc = "",
	},
	{
		key = "inport",
		widget = "Button",
		text = "导入",
		desc = "",
	},
	{
		key = "export",
		widget = "Button",
		text = "导出",
		desc = "",
	},
	{
		key = "delete",
		widget = "Button",
		text = "删除",
		desc = "按住Ctrl",
	},
	{
		key = "fcn",
		widget = "MultiLineEditBox",
		text = "函数",
		desc = "",
		width = "fill",
	},
}

function mod:CreateMainConfigGroup()
	local group = AceGUI:Create("ScrollFrame")
	group:SetLayout("Flow")
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
		group[v.key] = widget
	end
	group.spell:SetCallback("OnEnterPressed",function(widget,event,text)
		if text == "" then
			text = "_"
		end
		local currentFcnArray = self.currentFcnArray
		local currentFcnIndex = self.currentFcnIndex
		local fcn = currentFcnArray[currentFcnIndex]
		currentFcnArray[currentFcnIndex] = nil
		currentFcnArray[text] = fcn
		self.currentFcnIndex = text
		self:UpdateFcnTreeGroup()
	end)

	group.new:SetCallback("OnClick",function(widget,event)
		self:NewFcn("")
	end)

	group.inport:SetCallback("OnClick", function(widget,event)
		parent.inportStatus = {1,1,AirjAutoKey.selectedIndex}
		parent:Inport("fcn",self.currentFcnArray[self.currentFcnIndex],self.currentFcnIndex)
	end)

	group.export:SetCallback("OnClick", function(widget,event)
		parent:Export("fcn",filter)
	end)

	group.delete:SetCallback("OnClick", function(widget,event)
		if not IsControlKeyDown() then return end
		self.currentFcnArray[self.currentFcnIndex] = nil
		self.currentFcnIndex = next(self.currentFcnArray)
		self:UpdateFcnTreeGroup()
	end)

	group.fcn.button:SetScript("OnClick",function(button)
		button:Disable()
		local text = group.fcn:GetText()
		local currentFcnArray = self.currentFcnArray
		local currentFcnIndex = self.currentFcnIndex
		currentFcnArray[currentFcnIndex] = text
		self:UpdateFcnTreeGroup()
	end)

	group.fcn:SetHeight(300)

	self.mainConfigGroup = group
end

function mod:UpdateFcnTreeGroup()
	local fcnArray = self.currentFcnArray
	local mainGroup = self.mainGroup
	local tree = {}
	for k,v in pairs(fcnArray) do
		local spellName = strsplit("_", k) or ""
		local icon = GetSpellTexture(spellName)
		local text = k ~= "_" and k or "未定义"
		tinsert(tree,{value = k,text = text,icon = icon,})
	end
	mainGroup:SetTree(tree,true)
	mainGroup:Select(self.currentFcnIndex)
	self:UpdateMainConfigGroup()
end

function mod:UpdateMainConfigGroup()
	local group = self.mainConfigGroup
	for k,v in pairs(widgets) do
		local key = v.key
		if key and group[key] and group[key].SetDisabled then
			group[key]:SetDisabled(self.isDefault or self.currentFcnIndex == nil)
		end
	end
	group.new:SetDisabled(self.isDefault)
	group.export:SetDisabled(self.currentFcnIndex == nil or false)
	local currentFcnArray = self.currentFcnArray
	local currentFcnIndex = self.currentFcnIndex or ""
	group.spell:SetText(currentFcnIndex)
	local fcn = currentFcnArray[currentFcnIndex] or ""
	if fcn == "" then
		fcn = "function(filter, defaultunit, data)\n\treturn true\nend"
	end
	group.fcn:SetText(fcn)
end

function mod:NewFcn(fcn,name)
	name = name or "_"
	self.currentFcnArray[name] = fcn
	self.currentFcnIndex = name
	self:UpdateFcnTreeGroup()
end

function mod:FunctionSetting()
	local mainGroup = self.mainGroup
	if not mainGroup then
		mainGroup = AceGUI:Create("TreeGroup")
		mainGroup:SetTreeWidth(200,true)
		mainGroup:SetCallback("OnGroupSelected",function(widget,event,uniquevalue)
			self.currentFcnIndex = uniquevalue
			self:UpdateMainConfigGroup()
		end)
		self.mainGroup = mainGroup
		local tabGroup = parent.tabGroup
		tabGroup:AddChild(mainGroup)
	end
	if not self.mainConfigGroup then
		self:CreateMainConfigGroup()
		mainGroup:SetLayout("Fill")
		mainGroup:AddChild(self.mainConfigGroup)
	end
	self:UpdateFcnTreeGroup()
	parent:SelectTab(mainGroup)
end

function parent:FunctionSetting()
	if mod.currentFcnArray ~= AirjAutoKey.fcnArray then
		mod.currentFcnArray = AirjAutoKey.fcnArray
		mod.currentFcnIndex = next(mod.currentFcnArray)
		mod.isDefault = AirjAutoKey.rotationDB.isDefault
	end
	mod:FunctionSetting()
end

-- parent:RegisterTab("FunctionSetting","自定义函数",mod)
