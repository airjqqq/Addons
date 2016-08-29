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
		text = "按键名称",
		desc = "需要与[循环设置]中的技能名完全一致,使用<技能>_其他区分多个技能相同的宏",
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
		key = "macro",
		widget = "MultiLineEditBox",
		text = "宏",
		desc = "留空则使用默认技能",
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
		local currentMacroArray = self.currentMacroArray
		local currentMacroIndex = self.currentMacroIndex
		local macro = currentMacroArray[currentMacroIndex]
		currentMacroArray[currentMacroIndex] = nil
		currentMacroArray[text] = macro
		self.currentMacroIndex = text
		self:UpdateMacroTreeGroup()
	end)

	group.new:SetCallback("OnClick",function(widget,event)
		self:NewMacro("")
	end)

	group.inport:SetCallback("OnClick", function(widget,event)
		parent.inportStatus = {1,1,AirjAutoKey.selectedIndex}
		parent:Inport("macro",self.currentMacroArray[self.currentMacroIndex],self.currentMacroIndex)
	end)

	group.export:SetCallback("OnClick", function(widget,event)
		parent:Export("macro",filter)
	end)

	group.delete:SetCallback("OnClick", function(widget,event)
		if not IsControlKeyDown() then return end
		self.currentMacroArray[self.currentMacroIndex] = nil
		self.currentMacroIndex = next(self.currentMacroArray)
		self:UpdateMacroTreeGroup()
	end)

	group.macro.button:SetScript("OnClick",function(button)
		button:Disable()
		local text = group.macro:GetText()
		local currentMacroArray = self.currentMacroArray
		local currentMacroIndex = self.currentMacroIndex
		currentMacroArray[currentMacroIndex] = text
		self:UpdateMacroTreeGroup()
	end)

	group.macro:SetHeight(300)

	self.mainConfigGroup = group
end

function mod:UpdateMacroTreeGroup()
	local macroArray = self.currentMacroArray
	local mainGroup = self.mainGroup
	local tree = {}
	for k,v in pairs(macroArray) do
		local spellId,post = strsplit("_", k,2) or "",""
		local	spellName = GetSpellInfo(spellId) or spellId
		local icon = GetSpellTexture(spellName)
		local link = GetSpellLink(spellId) or spellId
		local listlab
		if post and post~="" then
			listlab = link.."_"..post
		else
			listlab = link
		end
		local text = k ~= "_" and (listlab) or "Undefined"
		tinsert(tree,{value = k,text = text,icon = icon,})
	end
	mainGroup:SetTree(tree,true)
	mainGroup:Select(self.currentMacroIndex)
	self:UpdateMainConfigGroup()
end

function mod:UpdateMainConfigGroup()
	local group = self.mainConfigGroup
	local currentMacroIndex = self.currentMacroIndex
	for k,v in pairs(widgets) do
		local key = v.key
		if key and group[key] and group[key].SetDisabled then
			group[key]:SetDisabled(self.isDefault or currentMacroIndex == nil)
		end
	end
	group.export:SetDisabled(currentMacroIndex == nil)
	group.new:SetDisabled(self.isDefault)

	local currentMacroArray = self.currentMacroArray
	group.spell:SetText(currentMacroIndex)
	local macro = AirjAutoKey:ToBasicMacroText(currentMacroIndex) or ""
	--[[
	if macro == "" then
		local spell = currentMacroIndex and strsplit("_",currentMacroIndex)
		macro = "/cast "..(spell or "")
	end
	]]
	group.macro:SetText(macro)
end

function mod:NewMacro(macro,name)
	name = name or "_"
	self.currentMacroArray[name] = macro
	self.currentMacroIndex = name
	self:UpdateMacroTreeGroup()
end

function mod:MacroSetting()
	local mainGroup = self.mainGroup
	if not mainGroup then
		mainGroup = AceGUI:Create("TreeGroup")
		mainGroup:SetTreeWidth(200,true)
		mainGroup:EnableButtonTooltips(false)
		mainGroup:SetCallback("OnGroupSelected",function(widget,event,uniquevalue)
			self.currentMacroIndex = uniquevalue
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
	self:UpdateMacroTreeGroup()
	parent:SelectTab(mainGroup)
end

function parent:MacroSetting()
	if mod.currentMacroArray ~= AirjAutoKey.rotationDB.macroArray then
		mod.currentMacroArray = AirjAutoKey.rotationDB.macroArray
		mod.currentMacroIndex = next(mod.currentMacroArray)
		mod.isDefault = AirjAutoKey.rotationDB.isDefault
	end
	mod:MacroSetting()
end

parent:RegisterTab("MacroSetting","按键设置",mod)
