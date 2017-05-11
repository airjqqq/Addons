AirjAutoKey_Options = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKey_Options", "AceConsole-3.0", "AceEvent-3.0","AceSerializer-3.0","AceComm-3.0","AceTimer-3.0");
local mod = AirjAutoKey_Options
local AirjAutoKey = AirjAutoKey
local AceGUI = LibStub("AceGUI-3.0")
mod.tabs = {}
mod.tabOnSelectMethod = {}
mod.modChildren = {}

function mod:OnInitialize()
	local default =
	{
		profile = {
			width = 850,
			height = 1000,
		}
	}
	self.db = LibStub("AceDB-3.0"):New("AirjAutoKey_OptionsDB",default,true)
	local mainFrame = AceGUI:Create("Frame")
	mainFrame:SetTitle("AirjAutoKey选项")
	mainFrame:SetWidth(850)
	mainFrame:SetHeight(750)

	mainFrame:Hide()
	self.mainFrame = mainFrame

	local tabGroup = AceGUI:Create("TabGroup")
	tabGroup:SetTabs(self.tabs)
	tabGroup:SetCallback("OnGroupSelected",function(widget,event,value)
		self[self.tabOnSelectMethod[value]](self)
	end)
	mainFrame:SetLayout("Fill")
	mainFrame:AddChild(tabGroup)
	self.tabGroup = tabGroup
	self:RegisterComm("AIRJAUTOKEY_COMM")
	local frame = tabGroup.frame
	frame.name = "AirjAutoKey选项"
--	frame.parent = "AirjAutoKey"
	frame.refresh = function()
	--	mainFrame:Hide()
	end
	InterfaceOptions_AddCategory(frame)
--	InterfaceOptionsFrame_OpenToCategory("AirjAutoKey_Setting")
	local tab = self.tabs[1] or {}
	if tab.value then
		tabGroup:SelectTab(tab.value)
	end
	self:RegisterChatCommand("aako", function(str,...)
		if str == "reset" then
			mainFrame:ClearAllPoints()
			mainFrame:SetPoint("CENTER",UIParent)
			-- mainFrame:
		else
			mod:Toggle()
		end
	end)
end

function mod:Toggle()
	local mainFrame = self.mainFrame
	local tabGroup = self.tabGroup
	if mainFrame:IsShown() then
		mainFrame:Hide()
	else
		tabGroup:SetParent(mainFrame)
		mainFrame:Show()
		mainFrame:DoLayout()
	end
end

function mod:SendComm(data)
	local group = self.sendCommGroup
	if not group then
		group = AceGUI:Create("Frame")
		group:SetWidth(600)
		group:SetHeight(300)
		group:SetTitle("发送")
		group:SetLayout("Flow")
		self.sendCommGroup = group
		local dropdown = AceGUI:Create("Dropdown")
		local list =
		{
			GUILD = "公会",
			OFFICER = "公会官员",
			PARTY = "小队",
			RAID = "团队",
			WHISPER = "特定人",
			TARGET = "目标",
		}
		dropdown:SetList(list)
		dropdown:SetLabel("频道")
		dropdown:SetWidth(180)
		dropdown:SetCallback("OnValueChanged",function(widget,event,key)
			group.channel = key
			group.editBox:SetDisabled(key ~= "WHISPER")
			group.button:SetDisabled(false)
		end)
		group:AddChild(dropdown)
		group.dropdown = dropdown

		local editBox = AceGUI:Create("EditBox")
		editBox:SetLabel("目标")
		editBox:SetWidth(180)
		dropdown:SetCallback("OnEnterPressed",function(widget,event,text)
			group.target = text
		end)
		group:AddChild(editBox)
		group.editBox = editBox

		local button = AceGUI:Create("Button")
		button:SetText("发送")
		button:SetCallback("OnClick",function(widget,event)
			local channel = group.channel
			if not channel then return end
			local target = group.target or ""
			local data = group.data or {}
			if channel == "TARGET" then
				channel = "WHISPER"
				target = UnitName("target") or ""
			end
			self:SendCommMessage("AIRJAUTOKEY_COMM",self:Serialize(data),channel,target,BULK,function(arg1,current,totle)
				local text
				if current<totle then
					text = "已发送 "..("%d"):format(100*current/totle).."%"
				else
					text = "完成"
					group:Hide()
				end
				group.button:SetText(text)
			end)
			group.button:SetDisabled(true)
		end)
		group:AddChild(button)
		group.button = button
		group.button:SetDisabled(true)
	end
	group:ClearAllPoints()
	group:SetPoint("CENTER",UIParent,"CENTER",0,50)
	group:Hide()
	group:Show()
	group.editBox:SetText("")
	group.data = data
	group.button:SetDisabled(false)
	group.button:SetText("发送")
end

function mod:OnCommReceived(prefix,data,channel,sender)
	local match, tab = self:Deserialize(data)
	if not match then return end
	local group = self.receivedCommGroup
	if not group then
		group = AceGUI:Create("Frame")
		group:SetWidth(500)
		group:SetHeight(300)
		group:SetTitle("接收")
		--group:SetLayout("Flow")
		self.receivedCommGroup = group

		local label = AceGUI:Create("Label")
		group.list =
		{
			GUILD = "公会",
			OFFICER = "公会官员",
			PARTY = "小队",
			RAID = "团队",
			WHISPER = "特定人",
		}
		label:SetFullWidth(true)
		label:SetHeight(200)
		group:AddChild(label)
		group.label = label
		local button = AceGUI:Create("Button")
		button:SetText("接受")
		button:SetCallback("OnClick",function(widget,event)
			local data = group.data or {}
			self:RotationSelect()
			local child = self.modChildren["RotationSelect"]
			child.currentRotationIndex = child.currentRotationIndex + 1
			child:NewRotation(data)
			group:Hide()
		end)
		button:SetWidth(100)
		group:AddChild(button)
		group.button = button
	end
	group:ClearAllPoints()
	group:SetPoint("CENTER",UIParent,"CENTER",0,50)
	group:Hide()
	group:Show()
	local str = "收到来自["..sender.."]通过<"..(group.list[channel] or "")..">发送来的循环配置"
	local info = "\n"
	local _,spec = GetSpecializationInfoByID(tab.spec or 0)
	spec = spec or ""
	local className = {}
	FillLocalizedClassList(className)
	local class = className[tab.class] or ""
	info = info .. spec..class
	group.label:SetText(str..info)
	group.data = tab
end

function mod:Export(...)
	local group = self.exportGroup
	if not group then
		group = AceGUI:Create("Frame")
		group:SetWidth(500)
		group:SetHeight(300)
		group:SetTitle("导出")
		group:SetLayout("Fill")
		self.exportGroup = group
		local editor = AceGUI:Create("MultiLineEditBox")
		editor:SetLabel("Ctrl-c复制")
		group:AddChild(editor)
		editor:DisableButton(true)
		editor.editBox:SetScript("OnEnterPressed",function(widget,event)
			group:Hide()
		end)
		editor.editBox:SetScript("OnEscapePressed",function(widget,event)
			group:Hide()
		end)
		group.editor = editor
	end
	group:ClearAllPoints()
	group:SetPoint("CENTER",UIParent,"CENTER",0,50)
	group:Hide()
	group:Show()
	group.frame:SetFrameStrata("TOOLTIP")
	group.editor:SetText(self:Serialize(...))
	group.editor.editBox:HighlightText()
	group.editor:SetFocus()
end

function mod:Inport()
	local group = self.inportGroup
	if not group then
		group = AceGUI:Create("Frame")
		group:SetWidth(500)
		group:SetHeight(300)
		group:SetTitle("导入")
		group:SetLayout("Fill")
		self.inportGroup = group
		local editor = AceGUI:Create("MultiLineEditBox")
		editor:SetLabel("Ctrl-v粘贴")

		--editor.button:ClearAllPoints()
		--editor.button:SetWidth(300)
		editor.button:SetPoint("BOTTOMRIGHT", 0, 4)
		editor.button:SetFrameStrata("TOOLTIP")
		editor.button:SetScript("OnClick",function(widget,event)
			group:Submit()
		end)
		editor.editBox:SetScript("OnEnterPressed",function(widget,event)
			group:Submit()
		end)
		editor.editBox:SetScript("OnEscapePressed",function(widget,event)
			group:Hide()
		end)
		editor.editBox:SetFrameStrata("TOOLTIP")
		group:AddChild(editor)
		group.editor = editor
	end
	group.Submit = function(group)
		local text = group.editor:GetText()
		local tables = {self:Deserialize(text)}
		if tables[1] then
			tremove(tables,1)
			local status = self.inportStatus
			self:ImportTables(tables,status)
			group:Hide()
		else
			group.editor:SetText("ERRPR: "..tables[2])
		end
	end
	group:ClearAllPoints()
	group:SetPoint("CENTER",UIParent,"CENTER",0,50)
	group:Hide()
	group:Show()
	group.frame:SetFrameStrata("TOOLTIP")
	group.editor:SetText("")
	group.editor.editBox:HighlightText()
	group.editor:SetFocus()
end

function mod:ImportTables(tables,status)
	local path,spellPath,rotationIndex = unpack(status)
	local spellArray = self.currentSpellArray
	local type, data, dataIndex = tables[1], tables[2]
	if type == "spell" then
		local child = self.modChildren["SpellSetting"]
		child:NewSpell(data,child:NextSpellPath(spellPath))
	elseif type == "filter" then
		local child = self.modChildren["SpellSetting"]
		local path = child:NextFilterPath(path)
		child.currentFilterPath = path
		child:NewFilter(data, path,spellPath)
	elseif type == "rotation" then
		local child = self.modChildren["RotationSelect"]
		child:NewRotation(data,rotationIndex + 1)
	elseif type == "macro" then
		local child = self.modChildren["MacroSetting"]
		child:NewMacro(data,dataIndex)
	elseif type == "fcn" then
		local child = self.modChildren["FunctionSetting"]
		child:NewFcn(data,dataIndex)
	else
		message("Error")
	end
end

function mod:SelectTab(group)
	local children = self.tabGroup.children
	for k,v in pairs(children) do
		v.frame:Hide()
		children[k] = nil
	end
	self.tabGroup:SetLayout("Fill")
	self.tabGroup:AddChild(group)
end

function mod:RegisterTab(value,name,mod,mothed)
	local tab =
	{
		value = value,
		text = name,
	}
	tinsert(self.tabs,tab)
	--self.tabGroup:BuildTabs()
	self.tabOnSelectMethod[value] = mothed or value
	self.modChildren[value] = mod
end
