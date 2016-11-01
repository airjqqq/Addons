AirjMacros = LibStub("AceAddon-3.0"):NewAddon("AirjMacros", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
local mod = AirjMacros
local AceGUI = LibStub("AceGUI-3.0")
local LAB = LibStub("LibActionButton-1.0")
mod.tabs = {}
mod.tabOnSelectMethod = {}
mod.modChildren = {}
mod.macroDataBaseArray = {}

mod.keyArray = {}
local keyArray = mod.keyArray
keyArray[1] = {"`","1","2","3","4","5","6"}
keyArray[2] = {"TAB","Q","W","E","R","T","Y"}
keyArray[3] = {"CAPSLOCK","A","S","D","F","G","H"}
keyArray[4] = {"Z","X","C","V","B"}
keyArray[5] = {"NUMPAD1","NUMPAD2","NUMPAD3","MOUSEWHEELUP"}
keyArray[6] = {"NUMPAD4","NUMPADDECIMAL","NUMPAD6","MOUSEWHEELDOWN"}
keyArray[7] = {"NUMPAD7","NUMPAD8","NUMPAD9","BUTTON5"}
keyArray[8] = {"NUMPAD0","NUMPADMINUS","NUMPADPLUS","BUTTON4"}

local hacked
local InCombatLockdown = function()
	-- if AirjHack and AirjHack:HasHacked() then
	-- 	hacked = true
	-- 	return false
	-- end
	return _G.InCombatLockdown()
end

function mod:OnInitialize()

	local default =
	{
		profile = {
			width = 800,
			height = 600,
		}
	}
	self.db = LibStub("AceDB-3.0"):New("AirjMacrosDB",default,true)
	-- print(#self.db.profile.macroDataBaseArray)

	self.db.profile.macroDataBaseArray = self.db.profile.macroDataBaseArray or {}
	self.macroDataBaseArray = self.db.profile.macroDataBaseArray

	self:LoadAutoData()

	local mainFrame = AceGUI:Create("Frame")
	mainFrame:SetTitle("AirjMacros选项")
	mainFrame:SetWidth(850)
	mainFrame:SetHeight(700)
	mainFrame:Hide()
	self.mainFrame = mainFrame

	local tabGroup = AceGUI:Create("TabGroup")
	tabGroup:SetTabs(self.tabs)
	tabGroup:SetCallback("OnGroupSelected",function(widget,event,value)
		self[self.tabOnSelectMethod[value] ](self)
	end)
	mainFrame:SetLayout("Fill")
	mainFrame:AddChild(tabGroup)
	self.tabGroup = tabGroup
	self:RegisterComm("AIRJMACROS_COMM")
	local frame = tabGroup.frame
	frame.name = "AirjMacros"
	frame.refresh = function()
	--	mainFrame:Hide()
	end
	InterfaceOptions_AddCategory(frame)
  --	InterfaceOptionsFrame_OpenToCategory("AirjMacros")

	self.timer100ms = self:ScheduleRepeatingTimer(function()
		self:TimerCallback()
	end,1)
	local tab = self.tabs[1] or {}
	if tab.value then
		self.tabGroup:SelectTab(tab.value)
	end
	self:CreateHandle()
	self:CreateRealButtons()
	self:UpdateRealButtons()

	self:RegisterChatCommand("amo", function(str,...)
		self:Toggle()
		self.modChildren.DataSelect:UpdateDataTreeGroup()
	end)
	self:RegisterChatCommand("amop", function(str,...)
		local _,_,id = GameTooltip:GetSpell()
		if id then
			PickupSpell(id)
		end
	end)
	self:RegisterChatCommand("arf", function(str,...)
		local profile = {
			["autoActivateSpec2"] = true,
			["autoActivateSpec1"] = true,
			["autoActivatePvE"] = true,
			["autoActivatePvP"] = true,
			["autoActivate2Players"] = true,
			["autoActivate3Players"] = true,
			["autoActivate5Players"] = false,
			["autoActivate10Players"] = false,
			["autoActivate15Players"] = false,
			["autoActivate25Players"] = false,
			["autoActivate40Players"] = false,
			["shown"] = true,
			["keepGroupsTogether"] = false,
			["horizontalGroups"] = false,
			["displayAggroHighlight"] = true,
			["useClassColors"] = true,
			["locked"] = true,
			["displayBorder"] = false,
			["displayMainTankAndAssist"] = true,
			["displayHealPrediction"] = true,
			["displayPowerBar"] = true,
			["displayOnlyDispellableDebuffs"] = false,
			["displayPets"] = true,
			["healthText"] = "none",
			["displayNonBossDebuffs"] = true,
			["sortBy"] = "group",
			["frameHeight"] = 60,
			["frameWidth"] = 100,
		}
		if not RaidProfileExists("ARF") then
			CreateNewRaidProfile("ARF")
		end
		for k,v in pairs(profile) do
			SetRaidProfileOption("ARF",k,v)
		end
		SetRaidProfileSavedPosition("ARF",false,"TPP",200,"BOTTOM",200,"ATTACHED",-10)
	end)


--	hooksecurefunc("SpellButton_OnEnter",function(self,...)
--		print("SpellButton_OnEnter")
--		dump(SpellBook_GetSpellBookSlot(self))
--	end)

--	hooksecurefunc("SpellButton_UpdateButton",function(self,...)
--		self.isPassive = false
--	end)

	hooksecurefunc("SpellButton_OnDrag",function(self,...)
		local slot, slotType = SpellBook_GetSpellBookSlot(self);
		if (not slot or slot > MAX_SPELLS or not _G[self:GetName().."IconTexture"]:IsShown()) then
			return;
		end
		if (slotType == "FUTURESPELL") then
			--self:SetChecked(0);
			local spellId = select(7,GetSpellInfo(slot,SpellBookFrame.bookType))
			--dump(spellId)
			PickupSpell(spellId)
		end
	end)

	LoadAddOn("Blizzard_CompactRaidFrames")
	CRFSort_Group=function(t1, t2)
		-- print(t1,t2)
		if UnitIsUnit(t1,"player") then
			return true
		elseif UnitIsUnit(t2,"player") then
			return false
		else
			return t1 < t2
		end
	end
	CompactRaidFrameContainer.flowSortFunc=CRFSort_Group


end

function mod:OnEnable()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED",function(event,unit)
			if unit == "player" then
				self:Reload()
			end
	end)
	self:RegisterEvent("UNIT_EXITED_VEHICLE",self.Reload,self)

	if not (self.selectedIndex) then
		self:LoadAutoData()
		self:UpdateRealButtons()
	end
end

function mod:Reload()
	self:LoadAutoData()
	self:UpdateRealButtons()
end

function mod:CreateHandle()
	local driver = CreateFrame("Frame", "AirjMacrosDriver", UIParent, "SecureHandlerStateTemplate")
	-- RegisterStateDriver(driver, "possess", "[nopossessbar] 0; [possessbar] 1")
	-- driver:SetAttribute("_onstate-possess", [[
	-- 		--print("_onstate-possess",stateid,newstate)
	--     self:SetAttribute("state", newstate)
	--     control:ChildUpdate("state", newstate)
	-- ]])
end


local ShiftNumberMap =
{
	["SHIFT-NUMPAD1"] = "END",
	["SHIFT-NUMPAD2"] = "DOWN",
	["SHIFT-NUMPAD3"] = "PAGEDOWN",
	["SHIFT-NUMPAD4"] = "LEFT",
	["SHIFT-NUMPADDECIMAL"] = "DELETE",
	["SHIFT-NUMPAD6"] = "RIGHT",
	["SHIFT-NUMPAD7"] = "HOME",
	["SHIFT-NUMPAD8"] = "UP",
	["SHIFT-NUMPAD9"] = "PAGEUP",
	["SHIFT-NUMPAD0"] = "INSERT",
}
function mod:CreateRealButtons()
	local driver = AirjMacrosDriver
	local pres = {"","SHIFT-","ALT-","CTRL-"}
	for row,keys in pairs(self.keyArray)do
		for index, key in pairs(keys) do
			for _,pre in pairs(pres) do
				local keyStr = key
				keyStr = pre..key
				--print("AirjMacros_"..keyStr)(id, name, header, config)
				local real = _G["AirjMacros_"..keyStr] or CreateFrame("Button","AirjMacros_"..keyStr, driver,"SecureActionButtonTemplate")
				real:SetSize(1,1)
				real:SetPoint("BOTTOM",UIParent,"TOP")
				real:SetAttribute("type","macro")
				real:SetAttribute("key",keyStr)
				real:RegisterForClicks("AnyDown")
				real:EnableMouse(false)
				real.key = ShiftNumberMap[keyStr] or keyStr
				real.header = driver
				real:SetAttribute("SwapState",[[
					local message = ...
					self:SetAttribute("macrotext",self:GetAttribute("macrotext"..message))
				]])
				real:SetAttribute("key",real.key);
				real:SetAttribute("_childupdate-state", [[
					if message == 0 then
						if self:GetAttribute("macrotext") then
							self:SetBindingClick(true,self:GetAttribute("key"),self:GetName())
						else
							self:ClearBinding(self:GetAttribute("key"))
						end
					else
						self:ClearBinding(self:GetAttribute("key"))
					end
				]])

				real:SetScript("PreClick",function(self,...)
					if AirjAutoKey then
						local keyIndex = tonumber(self.key)
						if keyIndex and keyIndex<=3 then
							--AirjAutoKey:SetConfigValue("target", keyIndex*2-1)
						end
						local datas = mod.macroDataBaseArray[mod.selectedIndex].macroArray
						local data = datas[self.key] or {}
						-- dump(data)
						if not data.dontStopAuto then
							AirjAutoKey:OnChatCommmand("onceGCD",-0.4)
						end
						if real.macrotext and hacked then
				    	AirjHack:RunMacroText(real.macrotext)
						end
					end
				end)
			end
		end
	end
end

function mod:UpdateRealButtons()
	-- self:Print("UpdateRealButtons",self.selectedIndex)
	if not self.selectedIndex or self.selectedIndex==0 then
		return
	end

	if InCombatLockdown() then
		self.UpdateWhileCombat = true
		message("战斗状态无法更新按键设置,战斗结束后自动更新")
		return
	end
	self.UpdateWhileCombat = nil

	if _G.InCombatLockdown() then
		self.UpdateWhileCombat = true
	end

	local pres = {"","SHIFT-","ALT-","CTRL-"}
	local datas = self.macroDataBaseArray[self.selectedIndex].macroArray
	for _,keys in pairs(self.keyArray) do
		for _,nomodkey in pairs(keys) do
			for _,pre in pairs(pres) do
				local key = pre..nomodkey
				local data = datas[key] or {}
				if type(key) == "string" then
					local real = _G["AirjMacros_"..key]
					if real then
						local macrotext
						if data.disable then
							macrotext = nil
						else
							macrotext = self:GetMacroText(data)
						end
						self:SetMacro(real,macrotext)
					end
				end
			end
		end
	end
end

function mod:SetMacro(button,macro)
	ClearOverrideBindings(button)
	if macro then
		local key = button.key
		SetOverrideBindingClick(button,true,key,button:GetName())
		if not hacked then
			button:SetAttribute("macrotext",macro)
		end
		button.macrotext = macro
	else
		if not hacked then
			button:SetAttribute("macrotext",nil)
		end
		button.macrotext = nil
	end
	if hacked and not _G.InCombatLockdown() then
		button:SetAttribute("macrotext",nil)
	end
end

function mod:BlizzardActionBar(on)
	if (InCombatLockdown()) then return end
	if (on) then
		local button
		for i=1, NUM_OVERRIDE_BUTTONS do
			button = _G["OverrideActionBarButton"..i]
			handler:WrapScript(button, "OnShow", [[
				local key = GetBindingKey("ACTIONBUTTON"..self:GetID())
				if (key) then
					self:SetBindingClick(true, key, self:GetName())
				end
			]])
			handler:WrapScript(button, "OnHide", [[
				local key = GetBindingKey("ACTIONBUTTON"..self:GetID())
				if (key) then
					self:ClearBinding(key)
				end
			]])
		end

		TextStatusBar_Initialize(MainMenuExpBar)
		MainMenuExpBar:RegisterEvent("PLAYER_ENTERING_WORLD")
		MainMenuExpBar:RegisterEvent("PLAYER_XP_UPDATE")
		MainMenuExpBar.textLockable = 1
		MainMenuExpBar.cvar = "xpBarText"
		MainMenuExpBar.cvarLabel = "XP_BAR_TEXT"
		MainMenuExpBar.alwaysPrefix = true
		MainMenuExpBar_SetWidth(1024)

		MainMenuBar_OnLoad(MainMenuBarArtFrame)
		MainMenuBarVehicleLeaveButton_OnLoad(MainMenuBarVehicleLeaveButton)

		MainMenuBar:SetPoint("BOTTOM", 0, 0)
		MainMenuBar:Show()

		OverrideActionBar_OnLoad(OverrideActionBar)
		OverrideActionBar:SetPoint("BOTTOM", 0, 0)

		ExtraActionBarFrame:SetPoint("BOTTOM", 0, 160)

		ActionBarController_OnLoad(ActionBarController)


	else
		MainMenuExpBar:UnregisterAllEvents()
		MainMenuBarArtFrame:UnregisterAllEvents()
		MainMenuBarArtFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
		MainMenuBarArtFrame:RegisterEvent("UNIT_LEVEL")
		MainMenuBarVehicleLeaveButton:UnregisterAllEvents()

		MainMenuBar:SetPoint("BOTTOM", 0, -200)
		MainMenuBar:Hide()
--[[
		local button
		for i=1, NUM_OVERRIDE_BUTTONS do
			button = _G["OverrideActionBarButton"..i]
			handler:UnwrapScript(button, "OnShow")
			handler:UnwrapScript(button, "OnHide")
		end
		OverrideActionBar:UnregisterAllEvents()
		OverrideActionBar:SetPoint("BOTTOM", 0, -200)
		OverrideActionBar:Hide()

		ExtraActionBarFrame:SetPoint("BOTTOM", 0, -200)
		ExtraActionBarFrame:Hide()
		ActionBarController:UnregisterAllEvents()
--]]
	end
end

function mod:LoadAutoData()
	local selfspec = GetSpecializationInfo(GetSpecialization() or 0) or 0
	for k,data in pairs(self.macroDataBaseArray) do
		if data.autoSwap then
			if floor(selfspec - (data.spec or 0)+0.5) == 0 then
				self:SelectDataDB(k)
				break;
			end
		end
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

function mod:SelectDataDB(index)
	self.selectedIndex = index or 0
	self:UpdateRealButtons()
end

function mod:TimerCallback()
	if not _G.InCombatLockdown() and self.UpdateWhileCombat then
		mod:UpdateRealButtons()
	end
end

function mod:GetMacroText(data,real)
	if data.macrotext and data.macrotext~="" then
		return data.macrotext,true
	end
	if (not data.spellId or data.spellId == "") and (not data.spell or data.spell == "") then
		return nil
	end
	local midstr, rec
	if data.help then
		rec = "help"
	else
		rec = "harm"
	end
	midstr = ("[@target,%s<,custom>][@targettarget,%s<,custom>][<,custom>]"):format(rec,rec)
	if data.mouseover then
		midstr = ("[@mouseover,%s<,custom>]"):format(rec)..midstr
	end
	if data.altself then
		midstr = ("[mod:alt,@player<,custom>]")..midstr
	end
	if data.altfocus then
		midstr = ("[mod:alt,@focus<,custom>]")..midstr
	end
	local macrotext = ""
	if data.stopcasting then
		macrotext = macrotext .. "/stopcasting\n/stopcasting\n"
	end
	if data.startattack then
		macrotext = macrotext .. "/startattack\n"
	end
	if (data.spellId and data.spellId ~= "") then
		for i,v in pairs({strsplit(",",data.spellId)}) do
			local name
			local mod,id = string.match(v,"%[(.*)%](.*)")
			id = id or v
			local dontback
			if string.sub(id,1,1) == "!" then
				dontback = true
				id = string.sub(id,2)
			end
			if string.sub(id,1,1) == "i" then
				name = name or GetItemInfo(string.sub(id,2))
			else
				name = GetSpellInfo(id)
			end
			if dontback then
				name = "!"..name
			end
			mod = mod and string.gsub(mod,"|",",")
			local realMid = string.gsub(midstr,"<,custom>",mod and (","..mod) or "")
			if name then
				macrotext = macrotext .. "/cast "..realMid.." "..name.."\n"
			end
		end
	else
		local realMid = string.gsub(midstr,"<,custom>", "")
		for i,v in pairs({strsplit(",",data.spell)}) do
			macrotext = macrotext .. "/cast "..realMid.." "..v.."\n"
		end
	end
	return macrotext
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
			self:SendCommMessage("AIRJMACROS_COMM",self:Serialize(data),channel,target,BULK,function(arg1,current,totle)
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

		editor.button:SetScript("OnClick",function(widget,event)
			group:Submit()
		end)
		editor.editBox:SetScript("OnEnterPressed",function(widget,event)
			group:Submit()
		end)
		editor.editBox:SetScript("OnEscapePressed",function(widget,event)
			group:Hide()
		end)
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
	group.editor:SetText("")
	group.editor.editBox:HighlightText()
	group.editor:SetFocus()
end

function mod:ImportTables(tables,status)
	local path,spellIndex,rotationIndex = unpack(status)
	local spellArray = self.currentSpellArray
	local type, data, dataIndex = tables[1], tables[2]
	if type == "macrokeys" then
		local child = self.modChildren["DataSelect"]
		child:NewData(data,spellIndex + 1)
	else
		message("Error")
	end
end
