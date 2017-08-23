local parent = AirjAutoKey_Options
local mod = {}
local AirjAutoKey = AirjAutoKey
local AceGUI = LibStub("AceGUI-3.0")
local f2n = {}
FillLocalizedClassList(f2n)
f2n._TEMPLATE = "模版"
local specId = {}
for i = 1,1000 do
	local _,specName,_,_,_,class = GetSpecializationInfoByID(i)
	if class then
		specId[class] = specId[class] or {}
		specId[class][i] = specName
	end
end

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
function mod:GetCurrentRotation()
	local rotation = AirjAutoKey.rotationDataBaseArray[self.currentRotationIndex]
	return rotation
end

function mod:CreateMainConfigGroup()
	local rotation = {}
	local group = AceGUI:Create("ScrollFrame")
	group:SetLayout("Flow")
	local rotationConfigWidgets = {
		{
			key = "class",
			widget = "Dropdown",
			text = "职业",
			desc = "",
			width = 160,
		},
		{
			key = "spec",
			widget = "Dropdown",
			text = "专精",
			desc = "",
			width = 160,
		},
		{
			key = "note",
			widget = "EditBox",
			text = "注释",
			desc = "会显示在左面的列表中,方便查找",
			width = 160,
		},
		{
			key = "heading1",
			widget = "SimpleGroup",
			text = "",
			desc = "",
			width = "fill",
		},
		{
			key = "autoSwap",
			widget = "CheckBox",
			text = "自动选择",
			desc = "",
			width = 160,
		},
		{
			key = "select",
			widget = "Button",
			text = "选中",
			desc = "",
			width = 160,
		},
		{
			key = "edit",
			widget = "Button",
			text = "编辑",
			desc = "",
			width = 160,
		},
		{
			key = "heading1",
			widget = "SimpleGroup",
			text = "",
			desc = "",
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
			key = "send",
			widget = "Button",
			text = "发送",
			desc = "",
			width = 160,
		},
		{
			key = "heading1",
			widget = "SimpleGroup",
			text = "",
			desc = "",
			width = "fill",
		},
		{
			key = "showotherclass",
			widget = "CheckBox",
			text = "显示其他职业",
			desc = "",
			width = 240,
		},
		{
			key = "sort",
			widget = "Button",
			text = "排序",
			desc = "按住Shift+Alt",
			width = 240,
		},
		{
			key = "heading1",
			widget = "SimpleGroup",
			text = "",
			desc = "",
			width = "fill",
		},
		{
			key = "info",
			widget = "Label",
			text = "",
			width = "fill",
			desc = "",
		},
		{
			key = "inst",
			widget = "MultiLineEditBox",
			text = "",
			width = "fill",
			desc = "",
		},
	}

	for i,v in ipairs(rotationConfigWidgets) do
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
		else
			widget:SetWidth(v.width or 80)
		end
		group:AddChild(widget)
		group[v.key] = widget
	end

	group.class:SetList(f2n)
	group.class:SetCallback("OnValueChanged",function(widget,event,key)
		local currentRotation = self:GetCurrentRotation()
		currentRotation.class = key
		local specList = key and specId[key] or {}
		group.spec:SetText("")
		group.spec:SetList(specList)
		currentRotation.spec = nil
		self:UpdateRotationTreeGroup()
	end)
	group.spec:SetCallback("OnValueChanged",function(widget,event,key)
		local currentRotation = self:GetCurrentRotation()
		currentRotation.spec = key
		self:UpdateRotationTreeGroup()
	end)
	group.note:SetCallback("OnEnterPressed",function(widget,event,text)
		if text == "" then
			text = nil
		end
		local currentRotation = self:GetCurrentRotation()
		currentRotation.note = text
		self:UpdateRotationTreeGroup()
	end)

	group.select:SetCallback("OnClick", function(widget,event)
		AirjAutoKey:SelectRotation(self.currentRotationIndex)
		self:UpdateRotationTreeGroup()
	end)
	group.edit:SetCallback("OnClick", function(widget,event)
		AirjAutoKey:SetEditingRotation(self.currentRotationIndex)
		self:UpdateRotationTreeGroup()
	end)
	group.autoSwap:SetCallback("OnValueChanged", function(widget,event,key)
		local currentRotation = self:GetCurrentRotation()
		currentRotation.autoSwap = key and true or nil;
	end)
	group.showotherclass:SetCallback("OnValueChanged", function(widget,event,key)
		self.showotherclass = key and true or nil;
		self:UpdateRotationTreeGroup()
	end)
	group.send:SetCallback("OnClick", function(widget,event)
		local currentRotation = self:GetCurrentRotation()
		parent:SendComm(currentRotation)
	end)
	group.new:SetCallback("OnClick", function(widget,event)
		self.currentRotationIndex = self.currentRotationIndex + 1

		local rdb = {
			spellArray = {},
			macroArray = {},
		}
		self:NewRotation(rdb)
	end)
	group.inport:SetCallback("OnClick", function(widget,event)
		parent.inportStatus = {1,1,self.currentRotationIndex}
		parent:Inport()
	end)

	group.export:SetCallback("OnClick", function(widget,event)
		local currentRotation = self:GetCurrentRotation()
		parent:Export("rotation",currentRotation)
	end)

	group.delete:SetCallback("OnClick", function(widget,event)
		if not IsControlKeyDown() then return end
		tremove(AirjAutoKey.rotationDataBaseArray,self.currentRotationIndex)
		local sri = AirjAutoKey:GetParam("selectedRotationIndex")
		if self.currentRotationIndex <= sri then
			AirjAutoKey:SelectRotation(sri - 1)
		end
		if self.currentRotationIndex and self.currentRotationIndex>1 then
			self.currentRotationIndex = self.currentRotationIndex - 1
		end
		self:UpdateRotationTreeGroup()
	end)
	group.sort:SetCallback("OnClick", function(widget,event)
		if not IsAltKeyDown() then return end
		if not IsShiftKeyDown() then return end
		local srindex = AirjAutoKey:GetParam("selectedRotationIndex")
		local sa = AirjAutoKey.rotationDataBaseArray[srindex]
		table.sort(AirjAutoKey.rotationDataBaseArray,function(a,b)
      if a == nil or b == nil then
        return false
      end
      if a == b then
				return false
			end
			if (a.spec or 0) ~= (b.spec or 0) then
				return (a.spec or 0)<=(b.spec or 0)
			end
			return (a.note or "")<=(b.note or "")
		end)
		for i,v in ipairs(AirjAutoKey.rotationDataBaseArray) do
			if v == sa then
				self.currentRotationIndex = i
				AirjAutoKey:SelectRotation(i)
				break
			end
		end
		self:UpdateRotationTreeGroup()
	end)
	group.inst:SetCallback("OnEnterPressed",function(widget,event,text)
		local currentRotation = self:GetCurrentRotation()
		if text == "" then
			text = nil
		end
		currentRotation.inst = text
	end)

	self.mainConfigGroup = group
end

function mod:UpdateMainConfigGroup()
	local group = self.mainConfigGroup
	local rotation = self:GetCurrentRotation() or {}
	group.class:SetValue(rotation.class)
	group.class:SetDisabled(rotation.isDefault)
	local specList = specId[rotation.class] or {}
	group.spec:SetList(specList)
	if specList[rotation.spec] then
		group.spec:SetValue(rotation.spec)
	else
		group.spec:SetText("")
	end
	group.spec:SetDisabled(rotation.isDefault)
	group.note:SetText(rotation.note)
	group.note:SetDisabled(rotation.isDefault)
	group.select:SetDisabled(AirjAutoKey:GetParam("selectedRotationIndex") == self.currentRotationIndex)
	group.edit:SetDisabled(AirjAutoKey:GetParam("editingRotationIndex") == self.currentRotationIndex)
	group.autoSwap:SetValue(rotation.autoSwap)
	group.delete:SetDisabled(rotation.isDefault)
	group.inst:SetDisabled(rotation.isDefault)
	do
		local infoText = {}
		local num = 0
		for k,v in pairs(rotation.macroArray or {}) do
			num = num + 1
		end
		tinsert(infoText, num.."个按键")
		local targets = {}
		for k,v in pairs(rotation.spellArray or {}) do
			local tarmin, tarmax = v.tarmin, v.tarmax
			if tarmin then
				targets[tarmin] = true
			end
			if tarmax then
			--	targets[tarmax] = true
			end
		end
		local targetNum = {}
		for k,v in pairs(targets) do
			tinsert(targetNum,k)
		end
		tinsert(infoText, "支持目标数:"..table.concat(targetNum,", "))
		group.info:SetText(table.concat(infoText,"\n"))
	end
	group.inst:SetText(rotation.inst or "")
end
function mod:UpdateRotationTreeGroup()
	local mainGroup = self.mainGroup
	local rotationDataBaseArray = AirjAutoKey.rotationDataBaseArray
	local tree = {}
	local texture = [[Interface\Glues\CharacterCreate\UI-CharacterCreate-Classes]]
	local _,playerClass = UnitClass("player")
	for i,v in pairs(rotationDataBaseArray) do
		local class = v.class
		local _, specName, _, icon = GetSpecializationInfoByID(v.spec or 0)
		local note = v.note or (v.isDefault and "默认")
		local name = {}
		tinsert(name,f2n[class])
		tinsert(name,specName)
		tinsert(name,note)
		name = table.concat(name," - ")
		if name == "" then
			name = "Undefined"
		end
		if AirjAutoKey:GetParam("selectedRotationIndex") == i then
			name = "|cff00ff00"..name.."|r"
		end
		if AirjAutoKey:GetParam("editingRotationIndex") == i then
			name = "[|cff00ffff"..name.."|r]"
		end
		if(self.showotherclass or class == playerClass or class == "_TEMPLATE" or not class) then
			tinsert(tree,{value = i,icon = icon,text = name})
		end
	end
	mainGroup:SetTree(tree)
	mainGroup:Select(self.currentRotationIndex)
	self:UpdateMainConfigGroup()
end

function mod:NewRotation(rotation,index)
	if not index then
		index = self.currentRotationIndex or 1
	else
		self.currentRotationIndex = index or 1
	end
	rotation.isDefault = nil
	if index == 0 then
		index = nil
	end
	tinsert(AirjAutoKey.rotationDataBaseArray,index,rotation)
	if not AirjAutoKey:GetParam("selectedRotationIndex") then
		AirjAutoKey:SetParam("selectedRotationIndex", 0)
	end
	if index < AirjAutoKey:GetParam("selectedRotationIndex") then
		local i = AirjAutoKey:GetParam("selectedRotationIndex") + 1
		AirjAutoKey:SetParam("selectedRotationIndex", i)
	elseif index == AirjAutoKey:GetParam("selectedRotationIndex") then
		AirjAutoKey:SelectRotation(AirjAutoKey:GetParam("selectedRotationIndex") + 1)
	end
	AirjAutoKey:SetEditingRotation(self.currentRotationIndex)
	self:UpdateRotationTreeGroup()
end

function mod:RotationSelect()
	self.currentRotationIndex = self.currentRotationIndex or 0
	local mainGroup = self.mainGroup
	if not mainGroup then
		mainGroup = AceGUI:Create("TreeGroup")
		mainGroup:SetTreeWidth(240,true)
		mainGroup:SetLayout("Flow")
		mainGroup:SetCallback("OnGroupSelected",function(widget,event,uniquevalue)
			self.currentRotationIndex = uniquevalue
			self:UpdateMainConfigGroup()
		end)
		self.mainGroup = mainGroup
	end
	if not self.mainConfigGroup then
		self:CreateMainConfigGroup()
		mainGroup:SetLayout("Fill")
		mainGroup:AddChild(self.mainConfigGroup)
	end
	self:UpdateRotationTreeGroup()
	parent:SelectTab(mainGroup)
end

function parent:RotationSelect()
	mod:RotationSelect()
end

parent:RegisterTab("RotationSelect","循环选择",mod)
