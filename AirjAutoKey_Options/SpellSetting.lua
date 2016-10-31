local parent = AirjAutoKey_Options
local mod = {}
local AirjAutoKey = AirjAutoKey
local AceGUI = LibStub("AceGUI-3.0")

local L = setmetatable({},{__index = function(t,k) return k end})

local typeList
local typeOrder
local typeDesc
local typesPerGroup = 39
local typeTree = {}
local typeTreeBack = {}
local typeTreeBackTableGroupIndex = {}
local function setupTypeList()
	local list = {["UNDEFINED"] = "|cFFFF0000Undefined|r"}
	local order = {"UNDEFINED"}
	local descs = {"请选择"}
	list["GROUP"] = "|cFFFF8888G|r|cFFFFFF88r|r|cFF88FF88o|r|cFF88FFFFu|r|cFF8888FFp|r"
	tinsert(order,"GROUP")
	tinsert(descs,"|cFFFF8888G|r|cFFFFFF88r|r|cFF88FF88o|r|cFF88FFFFu|r|cFF8888FFp|r")
	local sorted = {}
	local filterTypes = AirjAutoKey.filterTypes
	for k,v in pairs(filterTypes) do
		sorted[v.order] = k
	end
	for i,k in ipairs(sorted) do
		local v = filterTypes[k]
		list[k] = v.name
		tinsert(order,k)
		local desc = v.desc or ""
		if desc == "" then
			desc = v.name
		end
		tinsert(descs,desc)
	end
	typeList = list
	typeOrder = order
	typeDesc = descs
	for i,k in ipairs(typeOrder) do
		local v = typeList[k]
		local tableIndex = math.ceil(i/typesPerGroup)
		local offset = i - (tableIndex-1) * typesPerGroup
		typeTree[tableIndex] = typeTree[tableIndex] or {}
		typeTree[tableIndex][offset] = {value = offset, text = v, key = k}
		typeTreeBack[k] = offset
		typeTreeBackTableGroupIndex[k] = tableIndex
	end
end

local function copy(t)
	local success,nt = parent:Deserialize(parent:Serialize(t))
	return nt
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

local spellConfigWidgets = {
	{
		key = "heading",
		widget = "SimpleGroup",
		text = "",
		width = "fill",
	},
	{
		key = "refresh",
		widget = "CheckBox",
		text = L["Live Update"],
		desc = "",
		width = "x2",
	},
	{
		key = "new",
		widget = "Button",
		text = L["New Sequence"],
		desc = "",
		width = 320,
	},
	{
		key = "heading",
		widget = "SimpleGroup",
		text = "",
		width = "fill",
	},
	{
		key = "spell",
		widget = "EditBox",
		text = L["Spell Id or Macro key"],
		desc = "",
			width = "x2",
	},
	{
		key = "note",
		widget = "EditBox",
		text = L["Note"],
		desc = "",
	},
	{
		key = "group",
		widget = "CheckBox",
		text = L["Group"],
		desc = "",
	},
	{
		key = "disable",
		widget = "CheckBox",
		text = L["Disable"],
		desc = "",
	},
	{
		key = "continue",
		widget = "CheckBox",
		text = L["No block"],
		desc = "",
	},
	{
		key = "heading",
		widget = "SimpleGroup",
		text = "",
		width = "fill",
	},
	{
		key = "inport",
		widget = "Button",
		text = L["Import S"],
		desc = "",
	},
	{
		key = "export",
		widget = "Button",
		text = L["Export S"],
		desc = "",
	},
	{
		key = "copy",
		widget = "Button",
		text = L["Copy S"],
		desc = "",
	},
	{
		key = "delete",
		widget = "Button",
		text = L["Delete S"],
		desc = "Hold Alt and Shift",
	},
	{
		key = "upper",
		widget = "Button",
		text = L["Move up"],
		desc = "",
	},
	{
		key = "lower",
		widget = "Button",
		text = L["Move down"],
		desc = "",
	},
	{
		key = "heading",
		widget = "SimpleGroup",
		text = "",
		width = "fill",
	},
	{
		key = "anyinraid",
		widget = "EditBox",
		text = L["Scan Units"],
		desc = "help: for friend\npveharm: for enemy(pve)\narena: for arena(pvp)\npvpharm: for enemy(pvp)\nall for all\n",
	},
	{
		key = "icon",
		widget = "EditBox",
		text = L["Icon"],
		desc = "",
	},
	{
		key = "barcast",
		widget = "CheckBox",
		text = L["Barcast"],
		desc = "",
	},
	{
		key = "cd",
		widget = "EditBox",
		text = L["Cooldown"],
		desc = "",
	},
	{
		key = "tarmin",
		widget = "Slider",
		text = L["Min Target"],
		min = 0,
		max = 6,
		step = 1,
		desc = "",
	},
	{
		key = "tarmax",
		widget = "Slider",
		text = L["Max Target"],
		min = 0,
		max = 6,
		step = 1,
		desc = "",
	},
}
local filterConfigWidgets = {
	{
		key = "new",
		widget = "Button",
		text = L["New Filter"],
		desc = "",
		width = "x2",
	},
	{
		key = "newGroup",
		widget = "Button",
		text = L["Surround with Group"],
		desc = "",
		width = "x2",
	},
	{
		key = "heading",
		widget = "SimpleGroup",
		text = "",
		width = "fill",
	},
	{
		key = "type",
		widget = "Dropdown",
		text = L["Filter Type"],
		desc = "",
		width = "x2",
	},
	{
		key = "subtype",
		widget = "Dropdown",
		text = L["Filter Subtype"],
		desc = "",
		width = "x2",
	},
	{
		key = "note",
		widget = "EditBox",
		text = L["Note"],
		desc = "",
		width = "x2",
	},
	{
		key = "oppo",
		widget = "CheckBox",
		text = L["Reverse result"],
		desc = "",
		width = "x2",
	},
	{
		key = "heading",
		widget = "SimpleGroup",
		text = "",
		width = "fill",
	},
	{
		key = "expanision",
		widget = "Button",
		text = L["Expand"],
		desc = "",
	},
	{
		key = "collapse",
		widget = "Button",
		text = L["Collapse"],
		desc = "",
	},
	{
		key = "upper",
		widget = "Button",
		text = L["Move up"],
		desc = "",
	},
	{
		key = "lower",
		widget = "Button",
		text = L["Move down"],
		desc = "",
	},
	{
		key = "heading",
		widget = "SimpleGroup",
		text = "",
		width = "fill",
	},

	{
		key = "inport",
		widget = "Button",
		text = L["Import F"],
		desc = "",
	},
	{
		key = "export",
		widget = "Button",
		text = L["Export F"],
		desc = "",
	},
	{
		key = "copy",
		widget = "Button",
		text = L["Copy F"],
		desc = "",
	},
	{
		key = "delete",
		widget = "Button",
		text = L["Delete F"],
		desc = "Hold Ctrl",
	},
	{
		key = "heading",
		widget = "SimpleGroup",
		text = "",
		width = "fill",
	},
	{
		key = "name",
		widget = "MultiLineEditBox",
		text = L["Name or Spell Id"],
		desc = "",
		width = "x4",
	},
	{
		key = "unit",
		widget = "EditBox",
		text = L["Unit"],
		desc = "",
	},
	{
		key = "unittarget",
		widget = "Button",
		text = "T",
		desc = "target",
		width = 40,
	},
	{
		key = "unitair",
		widget = "Button",
		text = "A",
		desc = "air",
		width = 40,
	},
	{
		key = "greater",
		widget = "CheckBox",
		text = L["Greater"],
		desc = "",
		--width = "x2",
	},
	{
		key = "value",
		widget = "EditBox",
		text = L["Value"],
		desc = "",
		--width = "x2",
	},
}

function mod:CreateMainConfigGroup()
	local group = AceGUI:Create("ScrollFrame")
	group:SetLayout("Flow")

	local widgets = spellConfigWidgets
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
			text = nil
		end
		mod:GetCurrentSpell().spell = text
		mod:GetCurrentSpell().spellId = nil
		mod:GetCurrentSpell().spellName = nil
		mod:GetCurrentSpell().cd = nil

		self:UpdateSpellTreeGroup()
	end)
	local spellDraged = function(frame)
		local self = frame.obj
		local type, id, info, aid = GetCursorInfo()
		-- dump(GetCursorInfo())
		if type == "item" then
			local spellId = "i"..id
			self:SetText(spellId)
			self:Fire("OnEnterPressed", spellId)
			ClearCursor()
		elseif type == "spell" then
			-- local _,_,_,_,_,_,spellId = GetSpellInfo(id, info)
			local spellId=aid
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
	end
	group.spell.editbox:SetScript("OnReceiveDrag", spellDraged)
	group.spell.editbox:SetScript("OnMouseDown", spellDraged)
	group.disable:SetCallback("OnValueChanged",function(widget,event,value)
		mod:GetCurrentSpell().disable = value or nil
		self:UpdateSpellTreeGroup()
	end)
	group.barcast:SetCallback("OnValueChanged",function(widget,event,value)
		mod:GetCurrentSpell().barcast = value or nil
		self:UpdateSpellTreeGroup()
	end)

	group.anyinraid:SetCallback("OnEnterPressed",function(widget,event,text)
		if text == "" then
			text = nil
		end
		mod:GetCurrentSpell().anyinraid = text or nil
		self:UpdateSpellTreeGroup()
	end)


	group.refresh:SetCallback("OnValueChanged", function(widget,event,value)
		self:SetupTrace ()
		if value then
			self.refreshTimer = parent:ScheduleRepeatingTimer(function()
				self:UpdateTrace()
			end,0.05)
		else
			parent:CancelTimer(self.refreshTimer)
		end
	end)
	group.continue:SetCallback("OnValueChanged",function(widget,event,value)
		mod:GetCurrentSpell().continue = value or nil
		self:UpdateSpellTreeGroup()
	end)
	group.group:SetCallback("OnValueChanged",function(widget,event,value)
		local spell = mod:GetCurrentSpell()
		spell.group = value or nil
		if spell.group then
		end
		self:UpdateSpellTreeGroup()
	end)

	group.upper:SetCallback("OnClick", function(widget,event)

		local currentSpell,parentSpell,currentIndex = self:GetCurrentSpell()
		local swapIndex = currentIndex -1
		if swapIndex == 0 then return end
		local tempSpell = parentSpell[swapIndex]
		parentSpell[swapIndex] = parentSpell[currentIndex]
		parentSpell[currentIndex] = tempSpell
		self.currentSpellPath = self:OffsetPath(self.currentSpellPath, -1)
		--dump(strsplit("\001", self.currentSpellPath))
		self:UpdateSpellTreeGroup()
	end)

	group.lower:SetCallback("OnClick", function(widget,event)
		local currentSpell,parentSpell,currentIndex = self:GetCurrentSpell()
		local swapIndex = currentIndex + 1
		if swapIndex == #parentSpell + 1 then return end
		local tempSpell = parentSpell[swapIndex]
		parentSpell[swapIndex] = parentSpell[currentIndex]
		parentSpell[currentIndex] = tempSpell
		self.currentSpellPath = self:OffsetPath(self.currentSpellPath, 1)
		self:UpdateSpellTreeGroup()
	end)
	group.new:SetCallback("OnClick", function(widget,event)
		local path = self:NextSpellPath()
		self:NewSpell({},path)
		self:UpdateSpellTreeGroup()
	end)
	group.note:SetCallback("OnEnterPressed",function(widget,event,text)
		if text == "" then
			text = nil
		end
		mod:GetCurrentSpell().note = text
		self:UpdateSpellTreeGroup()
	end)

	group.inport:SetCallback("OnClick", function(widget,event)
		parent.inportStatus = {self.currentFilterPath,self.currentSpellPath,AirjAutoKey.selectedIndex}
		parent:Inport()
	end)

	group.export:SetCallback("OnClick", function(widget,event)
		local spell = mod:GetCurrentSpell()
		parent:Export("spell",spell)
	end)

	group.copy:SetCallback("OnClick", function(widget,event)
		local spell = mod:GetCurrentSpell()
		local success,newSpell = parent:Deserialize(parent:Serialize(spell))
		if success then
			self:NewSpell(newSpell,self:NextSpellPath())
		end
	end)
	group.delete:SetCallback("OnClick", function(widget,event)
		if not IsAltKeyDown() then return end
		if not IsShiftKeyDown() then return end
		local spell,parentSpell,currentIndex = mod:GetCurrentSpell()
		tremove(parentSpell,currentIndex)
		self:UpdateSpellTreeGroup()
	end)

	group.icon:SetCallback("OnEnterPressed",function(widget,event,text)
		if text == "" then
			text = nil
		end
		mod:GetCurrentSpell().icon = text
		self:UpdateSpellTreeGroup()
	end)

	group.cd:SetCallback("OnEnterPressed",function(widget,event,text)
		local cd
		if text == "" then
		else
			cd = tonumber(text)
		end
		mod:GetCurrentSpell().cd = cd
	end)

	group.tarmin:SetCallback("OnMouseUp", function(widget,event,value)
		mod:GetCurrentSpell().tarmin = value
	end)

	group.tarmax:SetCallback("OnMouseUp", function(widget,event,value)
		mod:GetCurrentSpell().tarmax = value
	end)

	--filters stuff
	local filtersHeading = AceGUI:Create("Heading")
	filtersHeading:SetText("Filters")
	filtersHeading:SetFullWidth(true)
	group:AddChild(filtersHeading)

	local filtersGroup = AceGUI:Create("TreeGroup")
	filtersGroup:SetTreeWidth(200,true)
	group:AddChild(filtersGroup)
	group.filtersGroup = filtersGroup

	filtersGroup:SetFullWidth(true)
	filtersGroup:SetTree({})
	filtersGroup:SetCallback("OnGroupSelected",function(widget,event,group)
		self.currentFilterPath = group
		self:UpdateFilterConfigGroup()
	end)
	filtersGroup:EnableButtonTooltips(false)

	filtersGroup:SetCallback("OnButtonEnter",function(widget,event,path,frame)
		local spell = self:GetCurrentSpell()
		local filter = self:GetFilterByPath(spell.filter,path)
		if filter then
			GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT");
			local spells = AirjAutoKey:ToValueTable(filter.name)
			GameTooltip:AddLine(filter.type or "UNKNOWN", 1, 1, 1, 1);
			for _,name in pairs(spells) do
				local text , spellId , icon
				local id = name and tonumber(name) or name
				if id then
					text , _ , icon,_,_,_,spellId = GetSpellInfo(id)
				end
				text = text or name
				if icon then
					text = "|T"..icon..":0|t " .. text
					--text = string.format("%6d",spellId) .." - ".. text
				end
			--	GameTooltip:AddLine(text, 1, 1, 1);
				GameTooltip:AddDoubleLine(text,spellId,0,1,0,1,0,1)
				--GameTooltip:AddTexture(icon)
			end
			GameTooltip:Show();
			GameTooltip:SetFrameLevel(50);
		end
	end)
	filtersGroup:SetLayout("Flow")

	for i,v in ipairs(filterConfigWidgets) do
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
		elseif v.width == "x4" then
			widget:SetWidth(320)
		else
			widget:SetWidth(v.width or 80)
		end
		filtersGroup:AddChild(widget)
		group["filter_"..v.key] = widget
	end

	group.filter_type:SetList(typeList,typeOrder)
	for k,v in group.filter_type.pullout:IterateItems() do
		--SetDescription(v,typeDesc[k])
	end
	group.filter_type:SetCallback("OnValueChanged",function(widget,event,key)
		local filter = self:GetCurrentFilter()
		filter.type = key
		self:UpdateFilterTreeGroup()
	end)

	group.filter_subtype:SetCallback("OnValueChanged",function(widget,event,key)
		local filter = self:GetCurrentFilter()
		filter.subtype = key ~= "_" and key or nil
		self:UpdateFilterTreeGroup()
	end)

	group.filter_note:SetCallback("OnEnterPressed",function(widget,event,text)
		local filter = self:GetCurrentFilter()
		if text == "" then
			text = nil
		end
		filter.note = text
		self:UpdateFilterTreeGroup()
	end)

	group.filter_oppo:SetCallback("OnValueChanged",function(widget,event,checked)
		local filter = self:GetCurrentFilter()
		filter.oppo = checked or nil
		self:UpdateFilterTreeGroup()
	end)

	group.filter_new:SetCallback("OnClick",function(widget,event)
		self:NewFilter({},self:NextFilterPath())
	end)

	group.filter_newGroup:SetCallback("OnClick",function(widget,event)
		local spell = mod:GetCurrentSpell()
		local pathstr = {strsplit("\001",self.currentFilterPath)}
		local paths = {}
		for i,v in ipairs(pathstr) do
			paths[i] = tonumber(v)
		end
		local filter = spell.filter
		for i = 1,#paths -1 do
			filter = filter[paths[i]]
		end
		local child = tremove(filter,paths[#paths])
		tinsert(filter,paths[#paths],{type="GROUP",oppo=true,[1]={type="GROUP",oppo=true,[1]=child}})
		local filtersGroup = self.mainConfigGroup.filtersGroup
		local status = filtersGroup.status or filtersGroup.localstatus
		status[self.currentFilterPath] = true
		self.currentFilterPath = self.currentFilterPath.."\0011\0011"
		self:UpdateFilterTreeGroup()
	end)

	group.filter_inport:SetCallback("OnClick", function(widget,event)
		parent.inportStatus = {self.currentFilterPath,self.currentSpellPath,AirjAutoKey.selectedIndex}
		parent:Inport()
	end)

	group.filter_export:SetCallback("OnClick", function(widget,event)
		local filter = self:GetCurrentFilter()
		parent:Export("filter",filter)
	end)

	group.filter_copy:SetCallback("OnClick", function(widget,event)
		local filter = self:GetCurrentFilter()
		local success,newFilter = parent:Deserialize(parent:Serialize(filter))
		if success then
			self:NewFilter(newFilter,self:NextFilterPath())
		end
	end)
	group.filter_delete:SetCallback("OnClick", function(widget,event)
		if not IsControlKeyDown() then return end
		local spell = mod:GetCurrentSpell()
		local pathstr = {strsplit("\001",self.currentFilterPath)}
		local paths = {}
		for i,v in ipairs(pathstr) do
			paths[i] = tonumber(v)
		end
		local filter = spell.filter
		for i = 1,#paths -1 do
			filter = filter[paths[i]]
		end
		tremove(filter,paths[#paths])
		self:UpdateFilterTreeGroup()
	end)


	group.filter_expanision:SetCallback("OnClick", function(widget,event)
		mod:ExpanAllTree(self.mainConfigGroup.filtersGroup)
	end)

	group.filter_collapse:SetCallback("OnClick", function(widget,event)
		local filtersGroup =  self.mainConfigGroup.filtersGroup
		local statusTable = filtersGroup.status or filtersGroup.localstatus
		statusTable.groups = {}
		filtersGroup:SetStatusTable(statusTable)
	end)
	group.filter_upper:SetCallback("OnClick", function(widget,event)

		local spell = mod:GetCurrentSpell()
		local pathstr = {strsplit("\001",self.currentFilterPath)}
		local paths = {}
		for i,v in ipairs(pathstr) do
			paths[i] = tonumber(v)
		end
		local filter = spell.filter
		for i = 1,#paths -1 do
			filter = filter[paths[i]]
		end
		local index = paths[#paths]
		if index ~= 1 then
			local t = filter[index]
			filter[index] = filter[index-1]
			filter[index-1] = t
			index = index - 1
		end
		paths[#paths] = index
		self.currentFilterPath = table.concat(paths,"\001")
		self:UpdateFilterTreeGroup()
	end)

	group.filter_lower:SetCallback("OnClick", function(widget,event)

		local spell = mod:GetCurrentSpell()
		local pathstr = {strsplit("\001",self.currentFilterPath)}
		local paths = {}
		for i,v in ipairs(pathstr) do
			paths[i] = tonumber(v)
		end
		local filter = spell.filter
		for i = 1,#paths -1 do
			filter = filter[paths[i]]
		end
		local index = paths[#paths]
		if index ~= #filter then
			local t = filter[index]
			filter[index] = filter[index+1]
			filter[index+1] = t
			index = index+1
		end
		paths[#paths] = index
		self.currentFilterPath = table.concat(paths,"\001")
		self:UpdateFilterTreeGroup()
	end)
	group.filter_name:SetNumLines(7)

	local onDrag = function(self,...)
		local editBox = self.obj
		local type, id, info, aid = GetCursorInfo()
		local text
		if type == "item" then
			local spellId = "i"..id
			text = spellId
		elseif type == "spell" then
			-- local _,_,_,_,_,_,spellId = GetSpellInfo(id, info)
			local spellId = aid
			text = spellId
		elseif type == "mount" then
			local _,name = C_MountJournal.GetMountInfo(info)
			text = name
		end
		if text then
			local oldText = editBox:GetText()
			if oldText and oldText~="" then
				text = oldText..","..text
			end
			editBox:SetText(text)
			editBox:Fire("OnEnterPressed", text)
		end
		ClearCursor()
		AceGUI:ClearFocus()
	end

	group.filter_name.scrollFrame:SetScript("OnReceiveDrag", onDrag)
	group.filter_name.editBox:SetScript("OnReceiveDrag", onDrag)
	group.filter_name.editBox:SetScript("OnMouseDown", onDrag)
	group.filter_name:SetCallback("OnEnterPressed",function(widget,event,text)
		local filter = self:GetCurrentFilter()
		text = gsub(text,"\n",",")
		local lasttext = ""
		while lasttext~= text do
			lasttext = text
			text = gsub(text,", ",",")
			text = gsub(text," ,",",")
		end
		local nameTable = {strsplit(",",text)}
		do
			local tab = {}
			local notNil = false
			for k,v in ipairs(nameTable) do
				if v == "" then
					tab[k] = nil
				else
					tab[k] = tonumber(v) or v
					notNil = true
				end
			end
			if notNil then
				filter.name = tab
			else
				filter.name = nil
			end
		end
		self:UpdateFilterTreeGroup()
	end)

	group.filter_unittarget:SetCallback("OnClick",function(widget,event,text)
		local filter = self:GetCurrentFilter()
		filter.unit = "target"
		self:UpdateFilterTreeGroup()
	end)
	group.filter_unitair:SetCallback("OnClick",function(widget,event,text)
		local filter = self:GetCurrentFilter()
		filter.unit = "air"
		self:UpdateFilterTreeGroup()
	end)
	group.filter_unit:SetCallback("OnEnterPressed",function(widget,event,text)
		local filter = self:GetCurrentFilter()
		local nameTable = {strsplit(",",text)}
		if #nameTable <=1 then
			if text == "" then
				text = nil
			elseif tonumber(text) then
				text = tonumber(text)
			end
			filter.unit = text
		else
			local tab = {}
			for k,v in pairs(nameTable) do
				tab[k] = tonumber(v) or v
			end
			filter.unit = tab
		end
		self:UpdateFilterTreeGroup()
	end)

	group.filter_greater:SetCallback("OnValueChanged",function(widget,event,checked)
		local filter = self:GetCurrentFilter()
		filter.greater = checked or nil
		self:UpdateFilterTreeGroup()
	end)

	group.filter_value:SetCallback("OnEnterPressed",function(widget,event,text)
		local filter = self:GetCurrentFilter()
		if text == "" then
			text = nil
		elseif tonumber(text) then
			text = tonumber(text)
		end
		filter.value = text
		self:UpdateFilterTreeGroup()
	end)

	self.mainConfigGroup = group
end

function mod:ExpanAllTree(group)
	local statusTable = group.status or group.localstatus
	statusTable.groups = {}
	local lastLinenum = 0
	local linenum = 1
	while (linenum ~= lastLinenum) do
		lastLinenum = linenum
		for i,v in ipairs(group.lines) do
			statusTable.groups[v.uniquevalue] = true
		end
		group:SetStatusTable(statusTable)
		linenum = #group.lines
	end
end

function mod:OffsetPath (path,offset)
	local paths = {strsplit("\001",path)}
	local laswPath = tonumber(paths[#paths])+offset
	paths[#paths] = laswPath
	path = table.concat(paths,"\001")
	return tonumber(path) or path
end
-- trace section begin

local spellToButton = {}

function mod:GetTraceButton(index,parent)
	if not self.traceButton[index] then
		local fontString = parent:CreateFontString()
		fontString:SetFont("Fonts\\FRIZQT__.TTF",14);
		fontString:SetPoint("RIGHT",parent,"LEFT",-40,0)
		fontString:SetText("")
		fontString:SetTextColor(0,1,0)
		local animationGroup = fontString:CreateAnimationGroup();
		local animation = animationGroup:CreateAnimation("Translation");
		animation:SetOffset(-400, 0);
		animation:SetDuration(10);
		animation:SetOrder(1);
		animation:SetSmoothing("NONE")
		animationGroup:SetScript("OnFinished",function(self)
			fontString:Hide();
		end)
		fontString.animationGroup = animationGroup

		self.traceButton[index] = fontString
	end
	return self.traceButton[index]
end

function mod:UpdateSpellToButton(spell,path)
	local mainGroup = self.mainGroup
	MG = mainGroup
	local key = tostring(spell)
	for i,v in ipairs(mainGroup.buttons or {}) do
		if v.uniquevalue == path then
			--print(spell.spell,path)
			spellToButton[key] = self:GetTraceButton(i,v)
			break
		end
	end
	if spell.group then
		for i,v in ipairs(spell) do
			local p = path.."\001"..i
			self:UpdateSpellToButton(v,p)
		end
	end
end

function mod:SetupTrace ()
	local spellArray = self.currentSpellArray or {}
	wipe(spellToButton)
	for i,v in ipairs(spellArray) do
 		self:UpdateSpellToButton(v,i)
	end
		local mainGroup = self.mainGroup
end
local lastTime = {}
local lastPassed = {}
local lastGCD = 1
function mod:UpdateTraceButton(spell)
	local key = tostring(spell)
	local button = spellToButton[key]
	local unit = AirjAutoKey.passedSpell[key]
	if button then
		if unit then
			AirjAutoKey.passedSpell[key] = nil
			if unit == true then unit = "PASSED" end
			button:SetAlpha(1)
			local text = unit and "["..unit.."]" or ""
			button:SetText(text)
			button.animationGroup:Stop()
			button:Show()
		else
		--		local text = button:GetText()
		--		if text then
		--			text = text .. " "
		--			button:SetText(text)
		--		end
			local time
			if lastPassed[key] then
				if not lastTime[key] then
					time = 0
				else
					time = (GetTime() - lastTime[key])/lastGCD
				end
				local timeText = string.format("%2.3f",time)
				local text = button:GetText(text)
				text = text.." - "..timeText
				button:SetText(text)
				lastTime[key] = GetTime()
			end
			button.animationGroup:Play()
			--local alpha = button:GetAlpha()
			--alpha = alpha - 0.1
			--alpha = math.max(alpha,0)
			--button:SetAlpha(alpha)
		end
		lastPassed[key] = unit
	end
	if spell.group then
		for i,v in ipairs(spell) do
			self:UpdateTraceButton(v)
		end
	end
end

function mod:UpdateTrace()

	local start,duration = GetSpellCooldown(61304)
	if start ~= 0 then lastGCD = duration end
	local spellArray = self.currentSpellArray or {}
	for i,v in ipairs(spellArray) do
		self:UpdateTraceButton(v)
	end
end

-- trace section end

-- spell tree section begin

function mod:NextSpellPath(path)
	path = path or self.currentSpellPath
	local filter = self:GetSpellByPath(self.currentSpellArray,path)
	local pathstr = {strsplit("\001",path)}
	local paths = {}
	for i,v in ipairs(pathstr) do
		paths[i] = tonumber(v)
	end
	if #paths == 0 then
		return 1
	end
	if not filter then
	elseif filter.group then
		paths[#paths+1] = 1
	else
		paths[#paths] = paths[#paths] + 1
	end
	local path = table.concat(paths,"\001")
	return tonumber(path) or path
end

function mod:GetSpellByPath(spell,path,...)
	if spell and path and path ~= "" then
		local thisPath, nextPath = strsplit("\001",path,2)
		thisPath = tonumber(thisPath)
		return mod:GetSpellByPath(spell and thisPath and spell[thisPath] or nil,nextPath,spell,thisPath,...)
	else
		return spell,...
	end
end

function mod:GetCurrentSpell()
	return mod:GetSpellByPath(self.currentSpellArray,self.currentSpellPath)
end

function mod:GetSpellTreeElement(spell)
	local v = spell
	local spellName = strsplit("_", v.spell or "") or ""
	local icon = GetSpellTexture(v.icon or "") or v.icon or GetSpellTexture(spellName)
	local text = v.spell and string.sub(v.spell,1,20)
	if not text then
		--dump(v)
		if v.filter and v.filter[1] and v.filter[1].type then
			local filter = AirjAutoKey.filterTypes[v.filter[1].type]
			if filter then
				text = filter.name
			end
		end
	end
	text = text or "Unknown"
	if v.note and v.note ~= "" then
		text = text.." - "..v.note
	else
		text = text
	end
	if v.anyinraid then
		text = "**"..text
	else
		text = "  "..text
	end
	if v.disable then
		text = "|cff7f00ff" .. text .. "|r"
	elseif AirjAutoKey.rotationDB.macroArray[v.spell or "_"] or AirjAutoKey:GetPresetMacro(v.spell or "_") then
		text = "|cff00ff00" .. text .. "|r"
	end

	local element = {text = text,icon = icon or "",}
	if spell.group then
		element.children = {}
		for i,v in ipairs(spell or {}) do
			local child = mod:GetSpellTreeElement(v)
			child.value = i
			tinsert(element.children,child)
		end
	end
	return element
end

function mod:RegisterSpellTreeGroupDrag(buttons)
	local group = self.mainGroup
	for i,button in ipairs(buttons) do
		button:RegisterForDrag('LeftButton')
		button:SetMovable(false)

		button:SetScript("OnMouseUp", function(b)
			local mouseButton = group.mouseButton
			mouseButton:StopMovingOrSizing();
			mouseButton:Hide()
			button:Click()
			local firstButton = group.buttons[1]
			if firstButton then
				local scale = 1
				local frame = firstButton
				while frame do
					scale = scale * (frame:GetScale())
					frame = frame:GetParent()
				end
				local left, bottom, width, height = firstButton:GetRect()
				local cursorX, cursorY = GetCursorPosition()
				if cursorX > left*scale and cursorX < left*scale + width*scale then
					local lineNumber = math.ceil(1 - (cursorY/scale - bottom)/height)
					local buttonnum = #(group.lines)
					if lineNumber>=0 and lineNumber <= buttonnum then
						local currentUnique
						if lineNumber == 0 then
							currentUnique = ""
						else
							currentUnique = group.buttons[lineNumber].uniquevalue
						end
						local mouseUnique = self.mouseSpellUnique
						if mouseUnique and currentUnique then
							if string.find(currentUnique,mouseUnique) ~= 1 then

								local mouseSpellArray = self.mouseSpellArray
								if not IsControlKeyDown() then
									self.currentSpellPath = self:NextSpellPath(currentUnique)
								else
									self.currentSpellPath = currentUnique
								end
								self:NewSpell(copy(mouseSpellArray[1]))
								if not IsShiftKeyDown() then
									for k,v in pairs(mouseSpellArray[2]) do
										if v == mouseSpellArray[1] then
											tremove(mouseSpellArray[2],k)
										end
									end
								end
							end
						end
					end
				end
			end

			mod:UpdateSpellTreeGroup()
		end)

		button:SetScript("OnMouseDown",function(b)
			local mouseButton = group.mouseButton
			if not mouseButton then
				mouseButton = group:CreateButton()
				mouseButton:SetParent(UIParent)
				mouseButton:SetMovable(true);
				mouseButton:SetFrameStrata("TOOLTIP")
				group.mouseButton = mouseButton
			end

			mouseButton:SetAllPoints(button);
			mouseButton:Show()
			mouseButton:StartMoving();
			--mouseButton:SetMovable(true);
			local treeline = button.treeline
			local level = treeline.level
			local text = treeline.text or ""
			local icon = treeline.icon

			local path = treeline.uniquevalue
			local spellArray = {mod:GetSpellByPath(self.currentSpellArray,path)}
			self.mouseSpellArray = spellArray
			self.mouseSpellUnique = path

			if ( level == 1 ) then
				mouseButton:SetNormalFontObject("GameFontNormal")
				mouseButton:SetHighlightFontObject("GameFontHighlight")
				mouseButton.text:SetPoint("LEFT", (icon and 16 or 0) + 8, 2)
			else
				mouseButton:SetNormalFontObject("GameFontHighlightSmall")
				mouseButton:SetHighlightFontObject("GameFontHighlightSmall")
				mouseButton.text:SetPoint("LEFT", (icon and 16 or 0) + 8 * level, 2)
			end

			mouseButton.text:SetText(text)
			mouseButton.icon:SetTexture(icon)
			mouseButton.icon:SetPoint("LEFT", 8 * level, (level == 1) and 0 or 1)


			button.text:SetText("")
			button.icon:SetTexture(nil)
		end)
		--dump({i,button})
	end
end

function mod:UpdateSpellTreeGroup()
	local spellArray = self.currentSpellArray or {}
	local mainGroup = self.mainGroup
	local tree = {}
	for i,v in ipairs(spellArray) do
		local element = mod:GetSpellTreeElement(v)
		element.value = i
		tinsert(tree,element)
	end
	mainGroup:SetTree(tree)
	mainGroup:SelectByValue(self.currentSpellPath or "")
	self.traceButton = self.traceButton or {}
	parent:ScheduleTimer(self.SetupTrace,0.1,self)
	parent:ScheduleTimer(self.RegisterSpellTreeGroupDrag,0.1,self,mainGroup.buttons)

	--	self:UpdateMainConfigGroup()
end

function mod:UpdateMainConfigGroup()
	local group = self.mainConfigGroup
	if not group then
		return
	end
	local spell = mod:GetCurrentSpell()

	if not spell then
		spell = {}
	end
	group.spell:SetText(spell.spell or "")

	group.disable:SetValue(spell.disable or false)
	group.barcast:SetValue(spell.barcast or false)
	group.anyinraid:SetText(type(spell.anyinraid)=="boolean" and "all" or spell.anyinraid or "")
	group.continue:SetValue(spell.continue or false)
	group.group:SetValue(spell.group or false)
	group.note:SetText(spell.note or "")
	local spellName = strsplit("_", spell.spell or "")
	local icon = GetSpellTexture(spell.icon or "") or spell.icon or GetSpellTexture(spellName) or ""
	group.icon:SetText(icon)
	local cd = spell.cd or (GetSpellBaseCooldown(spellName) or 0)/1000
	group.cd:SetText(cd or "0")
	group.tarmin:SetValue(spell.tarmin or 0)
	group.tarmax:SetValue(spell.tarmax or 10)

	self:UpdateFilterTreeGroup()
	group:DoLayout()
end

-- spell tree section end

-- filter tree section begin

function mod:NextFilterPath(path,spellPath)
	path = path or self.currentFilterPath
	spellPath = spellPath or self.currentSpellPath
 	local spell = mod:GetSpellByPath(self.currentSpellArray,spellPath)
	--local spell = mod:GetCurrentSpell()
	if not spell then
		return
	end
	local filter = self:GetFilterByPath(spell.filter,path)
	local pathstr = {strsplit("\001",path)}
	local paths = {}
	for i,v in ipairs(pathstr) do
		paths[i] = tonumber(v)
	end
	if not filter then
	elseif filter.group or filter.type == "GROUP" or path == "" then
		paths[#paths+1] = 1
	else
		paths[#paths] = paths[#paths] + 1
	end
	local path = table.concat(paths,"\001")
	return tonumber(path) or path
end

function mod:GetFilterByPath(filter,path,...)
	if path and path ~= "" then
		local thisPath, nextPath = strsplit("\001",path,2)
		return mod:GetFilterByPath(filter and filter[tonumber(thisPath)],nextPath,filter,tonumber(thisPath),...)
	else
		return filter,...
	end
end

function mod:GetCurrentFilter()
	local spell = mod:GetCurrentSpell()
	if not spell then return end
	local path = self.currentFilterPath
	return mod:GetFilterByPath(spell.filter,path)
end

function mod:GetFilterTreeElement(filter,isRoot)
	local element = {}
	if filter.group or filter.type == "GROUP" or isRoot then
		element.children = {}
		for k,v in ipairs(filter) do
			element.children[k] = self:GetFilterTreeElement(v)
			element.children[k].value = k
		end
	end
	element.text = filter.type and typeList[filter.type] or filter.group and typeList.GROUP or filter.type or ""
	local	name
	if type(filter.name) == "table" then
		name = filter.name[1]
	else
		name = filter.name
	end
	if name and strsub(name,1,1) == "_" then
		name = strsub(name,2)
	end
	element.icon = name and GetSpellTexture(tonumber(name) or name) or ""

	if filter.note then
		element.text = element.text.." - "..filter.note
	end
	local airUnit = AirjAutoKey:GetAirUnit()
	AirjAutoKey:SetAirUnit("target")
	local status, passed = pcall(AirjAutoKey.CheckFilter, AirjAutoKey, filter)
	AirjAutoKey:SetAirUnit(airUnit)
	-- if (filter.oppo) then passed = not passed end
	element.text = element.text .." " ..(passed and "√" or "×")
	if not status then
		local text = element.text
		local pos = strfind(text,"|c")
		if pos then
			text = strsub(text,1,pos-1)..strsub(text,pos+10)
			text = gsub(text,"|r","")
		end
		element.text = "|cffff0000"..text.."|r"
		print( passed )
	end
	return isRoot and element.children or element
end

function mod:RegisterFilterTreeGroupDrag(buttons)
	local filtersGroup = self.mainConfigGroup.filtersGroup
	for i,button in ipairs(buttons) do
		button:RegisterForDrag('LeftButton')
		button:SetMovable(false)

		button:SetScript("OnMouseUp", function(b)
			local mouseButton = filtersGroup.mouseButton
			mouseButton:StopMovingOrSizing();
			mouseButton:Hide()
			button:Click()
			local firstButton = filtersGroup.buttons[1]
			if firstButton then
				local scale = 1
				local frame = firstButton
				while frame do
					scale = scale * (frame:GetScale())
					frame = frame:GetParent()
				end
				local left, bottom, width, height = firstButton:GetRect()
				local cursorX, cursorY = GetCursorPosition()
				if cursorX > left*scale and cursorX < left*scale + width*scale then
					local lineNumber = math.ceil(1 - (cursorY/scale - bottom)/height)
					local buttonnum = #(filtersGroup.lines)
					if lineNumber>=0 and lineNumber <= buttonnum then
						local currentUnique
						if lineNumber == 0 then
							currentUnique = ""
						else
							currentUnique = filtersGroup.buttons[lineNumber].uniquevalue
						end
						local mouseUnique = self.mouseFilterUnique
						if mouseUnique and currentUnique then
							if string.find(currentUnique,mouseUnique) ~= 1 then
								local spell = mod:GetCurrentSpell()
								if spell then
									--local currentFilterArray = {mod:GetFilterByPath(spell.filter,currentUnique)}
									local mouseFilterArray = self.mouseFilterArray
									--	dump(mouseFilterArray)
									if not IsControlKeyDown() then
										self.currentFilterPath = self:NextFilterPath(currentUnique)
									else
										self.currentFilterPath = (currentUnique)
									end
									self:NewFilter(copy(mouseFilterArray[1]))
									--dump(strsplit("\001",self.currentFilterPath))
									if not IsShiftKeyDown() then
										for k,v in pairs(mouseFilterArray[2]) do
											if v == mouseFilterArray[1] then
												tremove(mouseFilterArray[2],k)
											end
										end
									end
									--tinsert(currentFilterArray[2],currentFilterArray[3],mouseFilterArray[1])
								end
							end
						end
					end
				end
			end

			mod:UpdateFilterTreeGroup()
		end)

		button:SetScript("OnMouseDown",function(b)
			local mouseButton = filtersGroup.mouseButton
			if not mouseButton then
				mouseButton = filtersGroup:CreateButton()
				mouseButton:SetParent(UIParent)
				mouseButton:SetMovable(true);
				mouseButton:SetFrameStrata("TOOLTIP")
				filtersGroup.mouseButton = mouseButton
			end

			mouseButton:SetAllPoints(button);
			mouseButton:Show()
			mouseButton:StartMoving();
			--mouseButton:SetMovable(true);
			local treeline = button.treeline
			local level = treeline.level
			local text = treeline.text or ""
			local icon = treeline.icon



			local spell = mod:GetCurrentSpell()
			if spell then
				local path = treeline.uniquevalue
				local filterArray = {mod:GetFilterByPath(spell.filter,path)}
				self.mouseFilterArray = filterArray
				self.mouseFilterUnique = path
			end

			if ( level == 1 ) then
				mouseButton:SetNormalFontObject("GameFontNormal")
				mouseButton:SetHighlightFontObject("GameFontHighlight")
				mouseButton.text:SetPoint("LEFT", (icon and 16 or 0) + 8, 2)
			else
				mouseButton:SetNormalFontObject("GameFontHighlightSmall")
				mouseButton:SetHighlightFontObject("GameFontHighlightSmall")
				mouseButton.text:SetPoint("LEFT", (icon and 16 or 0) + 8 * level, 2)
			end

			mouseButton.text:SetText(text)
			mouseButton.icon:SetTexture(icon)
			mouseButton.icon:SetPoint("LEFT", 8 * level, (level == 1) and 0 or 1)


			button.text:SetText("")
			button.icon:SetTexture(nil)
		end)
		--dump({i,button})
	end
end

function mod:UpdateFilterTreeGroup()
	local spell = self:GetCurrentSpell()
	local group = self.mainConfigGroup
	local filtersGroup = group.filtersGroup
	if spell then
		spell.filter = spell.filter or {}
		local filterArray = spell.filter
		local tree = self:GetFilterTreeElement(filterArray,true)
		filtersGroup:SetTree(tree,true)
		filtersGroup:RefreshTree()
		--		dump(tree,#filtersGroup.buttons)
		filtersGroup:SelectByValue(tonumber(self.currentFilterPath) or self.currentFilterPath)
		parent:ScheduleTimer(mod.RegisterFilterTreeGroupDrag,0.1,self,filtersGroup.buttons)
	else
		filtersGroup:SetTree({},true)
		self:UpdateFilterConfigGroup()
	end
	--
end

function mod:UpdateFilterConfigGroup()
	local group = self.mainConfigGroup
	local currentFilter = self:GetCurrentFilter()
	currentFilter = currentFilter or {}
	local maintype,subtype = currentFilter.type,currentFilter.subtype
	if not maintype and currentFilter.fcn then
		maintype,subtype = "FCN",currentFilter.fcn
	elseif not maintype and currentFilter.group then
		maintype = "GROUP"
	end
	group.filter_type:SetValue(maintype or "_")
	local tableGroupIndex = typeTreeBackTableGroupIndex[maintype or "_"];
	for i, v in ipairs(self.typeGroup) do
		local toSelect
		if i == tableGroupIndex then
			toSelect = typeTreeBack[maintype or "_"]
		end
		v:SetSelected(toSelect)
		v:RefreshTree(true)
	end
	self:UpdateFilterConfigGroupType()
	group.filter_subtype:SetValue(subtype and tostring(subtype) or subtype or "_")
	group.filter_oppo:SetValue(currentFilter.oppo)
	local nameText = ""
	if type(currentFilter.name) == "table" then
		local size = 0
		for i = 1,100 do
			local v = currentFilter.name[i]
			if v ~= nil then size = i end
		end
		if size > 0 then

			local connector
			if size > 7 then
				connector = ", "
			else
				connector = "\n"
			end
			for i = 1,size do
				local v = currentFilter.name[i]
				nameText = nameText .. (v or "") .. (i==size and "" or connector)
			end
		end
	end
	group.filter_name:SetText(nameText or "")
	group.filter_note:SetText(currentFilter.note)

	local unitText = currentFilter.unit
	if type(unitText) == "table" then
		unitText = table.concat(unitText,",")
	end
	group.filter_unit:SetText(unitText or "")
	group.filter_value:SetText(currentFilter.value or currentFilter.value or 0)
	group.filter_greater:SetValue(currentFilter.greater)
end

function mod:UpdateFilterConfigGroupType()
	local filter = self:GetCurrentFilter() or {}
	local key = filter.type
	if key == self.lastType then
		--return
	end
	self.lastType = key
	local typeInfo = AirjAutoKey.filterTypes[key] or {}
	local keys = typeInfo.keys or {}
	local subtypes = typeInfo.subtypes
	if key == "GROUP" then
		keys = {
			unit = {desc = "'raid'搜索全队"},
			value = {name = "数量",desc = "unit = 'raid'时的数量"},
			greater = {},
			--name = {},
		}
	--	filter.group = true
	else
	--	filter.group = nil
	end
	local group = self.mainConfigGroup
	local list
	local isfcn
	if key == "FCN" then
		isfcn = true
		group.filter_subtype:SetDisabled(self.isDefault or false)
		group.filter_subtype:SetLabel("自定义函数")
		list = {_ = "请选择"}
		for k,v in pairs(AirjAutoKey.fcnArray) do
			list[k] = k
		end
	elseif subtypes then
		group.filter_subtype:SetDisabled(self.isDefault or false)
		group.filter_subtype:SetLabel("Subtype")
		list = {_ = "Default"}
		for k,v in pairs(subtypes) do
			list[tostring(k)] = v
		end
	else
		group.filter_subtype:SetDisabled(self.isDefault or true)
		group.filter_subtype:SetLabel("Subtype")
		list = {_ = "Not available"}
	end
	group.filter_subtype:SetList(list)
	local infoKeys =
	{
		"name",
		"unit",
		"value",
		"greater",
	}
	local default =
	{
		["name"] = "Name or Spell ID",
		["unit"] = "Unit",
		["value"] = "Value",
		["greater"] = "Greater",
	}

	local defaultDesc =
	{
		["name"] = "",
		["unit"] = "",
		["value"] = "",
		["greater"] = "",
	}

	for k,v in pairs(infoKeys) do
		local widget = group["filter_"..v]
		if keys[v] or isfcn then
			widget:SetDisabled(self.isDefault or false)
			widget:SetLabel(keys[v] and keys[v].name or default[v])
			SetDescription(widget,keys[v] and (keys[v].desc or keys[v].name) or defaultDesc[v] or "")
		else
			widget:SetDisabled(self.isDefault or true)
			filter[v] = nil
			widget:SetLabel(default[v])
			SetDescription(widget,defaultDesc[v] or default[v] or "")
		end
	end
end

-- filter tree section end

function mod:NewSpell(spell,spellPath)
	local spellArray = self.currentSpellArray
	if not spellPath then
		spellPath = self.currentSpellPath
	else
		self.currentSpellPath = spellPath
	end

	local pathstr = {strsplit("\001",spellPath)}
	local paths = {}
	for i,v in ipairs(pathstr) do
		paths[i] = tonumber(v)
	end
	local lastPath = tonumber(paths[#paths])
	paths[#paths] = nil
	local parentPath = table.concat(paths,"\001")

	local parentSpell = mod:GetSpellByPath(self.currentSpellArray,parentPath)
	tinsert(parentSpell,lastPath,spell)
	self:UpdateSpellTreeGroup()
end

function mod:NewFilter(filter,path,spellPath)
	if type(filter) ~= "table" then return end
	if not path then
		path = self.currentFilterPath
	else
		self.currentFilterPath = path
	end
	if not spellPath then
		spellPath = self.currentSpellPath
	else
		self.currentSpellPath = spellPath
	end
	local spell = self:GetCurrentSpell()
	local pathstr = {strsplit("\001",path)}
	local paths = {}
	for i,v in ipairs(pathstr) do
		paths[i] = tonumber(v)
	end
	local lastPath = paths[#paths]
	paths[#paths] = nil
	local parentPath = table.concat(paths,"\001")
	local parentFilter = mod:GetFilterByPath(spell.filter,parentPath)
	filter.type = filter.type or "UNDEFINED"
	tinsert(parentFilter,lastPath,filter)
	self:UpdateFilterTreeGroup()
end

-- register mode

function mod:SpellSetting()
	local mainGroup = self.mainGroup
	if not mainGroup then
		mainGroup = AceGUI:Create("TreeGroup")
		mainGroup:SetTreeWidth(200,true)
		mainGroup:SetCallback("OnGroupSelected",function(widget,event,uniquevalue)
			self.currentSpellPath = uniquevalue
			self.currentFilterPath = 1
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
	local treeWidth = 160

	if not self.typeGroup then
		self.typeGroup = {}
		for i,v in ipairs(typeTree) do
			typeGroup = AceGUI:Create("TreeGroup")
			typeGroup:SetTreeWidth(treeWidth)
			typeGroup:SetWidth(treeWidth*2)
			typeGroup.frame:SetParent(mainGroup.frame)
			typeGroup.treeframe:SetBackdropColor(0, 0, 0, 1)
			typeGroup.treeframe:SetBackdropBorderColor(0,0,0,0)
			local xoffset = i*treeWidth -treeWidth
			typeGroup:SetPoint("TOPLEFT", mainGroup.frame, "TOPRIGHT", xoffset, 60)
			typeGroup:SetPoint("BOTTOMLEFT", mainGroup.frame, "BOTTOMRIGHT", xoffset, -40)
			typeGroup.border:Hide()
			typeGroup:SetTree(v)
			typeGroup:SetCallback("OnGroupSelected",function(widget,event,uniquevalue)
				if (uniquevalue) then
					local filter = self:GetCurrentFilter()
					if filter then
						filter.type = v[uniquevalue].key
						self:UpdateFilterTreeGroup()
					end
				end
			end)
			self.typeGroup[i] = typeGroup
		end

	end

	parent:SelectTab(mainGroup)
	self:UpdateSpellTreeGroup()
end

function parent:SpellSetting()
	setupTypeList()
	if mod.currentSpellArray ~= AirjAutoKey.rotationDB.spellArray then
		mod.currentSpellArray = AirjAutoKey.rotationDB.spellArray
		local spell
		mod.currentSpellPath,spell = next(mod.currentSpellArray)
		local filterArray = spell and spell.filter or {}
		mod.currentFilterPath = next(filterArray)
		mod.isDefault = AirjAutoKey.rotationDB.isDefault
	end
	mod:SpellSetting()
end

parent:RegisterTab("SpellSetting","循环设置",mod)
