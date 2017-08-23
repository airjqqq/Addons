

local _detalhes	= 	_G._detalhes
local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

local CreateFrame = CreateFrame
local pairs = pairs 
local UIParent = UIParent
local UnitGUID = UnitGUID 
local tonumber= tonumber 
local LoggingCombat = LoggingCombat

SLASH_DETAILS1, SLASH_DETAILS2, SLASH_DETAILS3 = "/details", "/dt", "/de"

function SlashCmdList.DETAILS (msg, editbox)

	local command, rest = msg:match("^(%S*)%s*(.-)$")
	command = string.lower (command)
	
	if (command == Loc ["STRING_SLASH_WIPE"] or command == "wipe") then
	
	elseif (command == "api") then
		_detalhes.OpenAPI()
	
	elseif (command == Loc ["STRING_SLASH_NEW"] or command == "new") then
		_detalhes:CriarInstancia (nil, true)
		
	elseif (command == Loc ["STRING_SLASH_HISTORY"] or command == "history") then
		_detalhes:OpenRaidHistoryWindow()
	
	elseif (command == Loc ["STRING_SLASH_TOGGLE"] or command == "toggle") then
		
		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber (instance)
		if (instance) then
			_detalhes:ToggleWindow (instance)
		else
			_detalhes:ToggleWindows()
		end
		
	elseif (command == Loc ["STRING_SLASH_HIDE"] or command == Loc ["STRING_SLASH_HIDE_ALIAS1"] or command == "hide") then
	
		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber (instance)
		if (instance) then
			local this_instance = _detalhes:GetInstance (instance)
			if (not this_instance) then
				return _detalhes:Msg (Loc ["STRING_WINDOW_NOTFOUND"])
			end
			if (this_instance:IsEnabled() and this_instance.baseframe) then
				this_instance:ShutDown()
			end
		else
			_detalhes:ShutDownAllInstances()
		end
	
	elseif (command == Loc ["STRING_SLASH_SHOW"] or command == Loc ["STRING_SLASH_SHOW_ALIAS1"] or command == "show") then
	
		_detalhes.LastShowCommand = GetTime()
		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber (instance)
		if (instance) then
			local this_instance = _detalhes:GetInstance (instance)
			if (not this_instance) then
				return _detalhes:Msg (Loc ["STRING_WINDOW_NOTFOUND"])
			end
			if (not this_instance:IsEnabled() and this_instance.baseframe) then
				this_instance:EnableInstance()
			end
		else	
			_detalhes:ReabrirTodasInstancias()
		end
	
	elseif (command == Loc ["STRING_SLASH_WIPECONFIG"] or command == "reinstall") then
		_detalhes:WipeConfig()
	
	elseif (command == Loc ["STRING_SLASH_RESET"] or command == Loc ["STRING_SLASH_RESET_ALIAS1"] or command == "reset") then
		_detalhes.tabela_historico:resetar()
	
	elseif (command == Loc ["STRING_SLASH_DISABLE"] or command == "disable") then
	
		_detalhes:CaptureSet (false, "damage", true)
		_detalhes:CaptureSet (false, "heal", true)
		_detalhes:CaptureSet (false, "energy", true)
		_detalhes:CaptureSet (false, "miscdata", true)
		_detalhes:CaptureSet (false, "aura", true)
		_detalhes:CaptureSet (false, "spellcast", true)
		
		print (Loc ["STRING_DETAILS1"] .. Loc ["STRING_SLASH_CAPTUREOFF"])
	
	elseif (command == Loc ["STRING_SLASH_ENABLE"] or command == "enable") then
	
		_detalhes:CaptureSet (true, "damage", true)
		_detalhes:CaptureSet (true, "heal", true)
		_detalhes:CaptureSet (true, "energy", true)
		_detalhes:CaptureSet (true, "miscdata", true)
		_detalhes:CaptureSet (true, "aura", true)
		_detalhes:CaptureSet (true, "spellcast", true)
		
		print (Loc ["STRING_DETAILS1"] .. Loc ["STRING_SLASH_CAPTUREON"])
	
	elseif (command == Loc ["STRING_SLASH_OPTIONS"] or command == "options" or command == "config") then
	
		if (rest and tonumber (rest)) then
			local instanceN = tonumber (rest)
			if (instanceN > 0 and instanceN <= #_detalhes.tabela_instancias) then
				local instance = _detalhes:GetInstance (instanceN)
				_detalhes:OpenOptionsWindow (instance)
			end
		else
			local lower_instance = _detalhes:GetLowerInstanceNumber()
			if (not lower_instance) then
				local instance = _detalhes:GetInstance (1)
				_detalhes.CriarInstancia (_, _, 1)
				_detalhes:OpenOptionsWindow (instance)
			else
				_detalhes:OpenOptionsWindow (_detalhes:GetInstance (lower_instance))
			end
			
		end

	elseif (command == Loc ["STRING_SLASH_WORLDBOSS"] or command == "worldboss") then
		
		local questIds = {{"Tarlna the Ageless", 81535}, {"Drov the Ruiner ", 87437}, {"Rukhmar", 87493}}
		for _, _table in pairs (questIds) do 
			print (format ("%s: \124cff%s\124r", _table [1], IsQuestFlaggedCompleted (_table [2]) and "ff0000"..Loc ["STRING_KILLED"] or "00ff00"..Loc ["STRING_ALIVE"]))
		end
		
	elseif (command == Loc ["STRING_SLASH_CHANGES"] or command == Loc ["STRING_SLASH_CHANGES_ALIAS1"] or command == Loc ["STRING_SLASH_CHANGES_ALIAS2"] or command == "news" or command == "updates") then
		_detalhes:OpenNewsWindow()
	
	elseif (command == "feedback") then
		_detalhes.OpenFeedbackWindow()
		
	elseif (command == "profile") then
		if (rest and rest ~= "") then
		
			local profile = _detalhes:GetProfile (rest)
			if (not profile) then
				return _detalhes:Msg ("Profile Not Found.")
			end
			
			if (not _detalhes:ApplyProfile (rest)) then
				return
			end
			
			_detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_LOADED"], rest)
			if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
				_G.DetailsOptionsWindow:Hide()
				GameCooltip:Close()
			end
		else
			_detalhes:Msg ("/details profile <profile name>")
		end
	
-------- debug ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	
	elseif (msg == "exitlog") then
	
		local exitlog = _detalhes_global.exit_log
		local exiterrors = _detalhes_global.exit_errors
		
		print ("EXIT LOG:")
		for index, text in ipairs (exitlog) do
			print (text)
		end
		print ("ERRORS:")
		if (exiterrors) then
			for index, text in ipairs (exiterrors) do
				print (text)
			end
		else
			print ("|cFF00FF00No error occured!|r")
		end
	
	elseif (msg == "realmsync") then
		
		_detalhes.realm_sync = not _detalhes.realm_sync
		_detalhes:Msg ("Realm Sync: ", _detalhes.realm_sync and "Enabled" or "Disabled")
		
		if (not _detalhes.realm_sync) then
			LeaveChannelByName ("Details")
		else
			_detalhes:CheckChatOnLeaveGroup()
		end

	elseif (msg == "load") then
		
		print (DetailsDataStorage)
		
		local loaded, reason = LoadAddOn ("Details_DataStorage")
		print (loaded, reason, DetailsDataStorage)
		
	
	elseif (msg == "owner2") then
	
		local tip = CreateFrame('GameTooltip', 'GuardianOwnerTooltip', nil, 'GameTooltipTemplate')
		function GetGuardianOwner(guid)
			tip:SetOwner(WorldFrame, 'ANCHOR_NONE')
			tip:SetHyperlink('unit:' .. guid or '')
			local text = GuardianOwnerTooltipTextLeft2
			--return strmatch(text and text:GetText() or '', "^([^%s']+)'")
			return text:GetText()
		end
	
		print (GetGuardianOwner(UnitGUID ("target")))
	
	elseif (msg == "chat") then
	
	
	elseif (msg == "chaticon") then
		_detalhes:Msg ("|TInterface\\AddOns\\Details\\images\\icones_barra:" .. 14 .. ":" .. 14 .. ":0:0:256:32:0:32:0:32|tteste")
	
	elseif (msg == "align") then
		local c = RightChatPanel
		local w,h = c:GetSize()
		print (w,h)
		
		local instance1 = _detalhes.tabela_instancias [1]
		local instance2 = _detalhes.tabela_instancias [2]
		
		instance1.baseframe:ClearAllPoints()
		instance2.baseframe:ClearAllPoints()

		instance1.baseframe:SetSize (w/2 - 4, h-20-21-8)
		instance2.baseframe:SetSize (w/2 - 4, h-20-21-8)
		
		instance1.baseframe:SetPoint ("bottomleft", RightChatDataPanel, "topleft", 1, 1)
		instance2.baseframe:SetPoint ("bottomright", RightChatToggleButton, "topright", -1, 1)
		
	elseif (msg == "addcombat") then
		
		local combat = _detalhes.combate:NovaTabela (true, _detalhes.tabela_overall, 1)
		local self = combat[1]:PegarCombatente (UnitGUID ("player"), UnitName ("player"), 1297, true)
		self.total = 100000
		self.total_without_pet = 100000
		
		if (not _detalhes.um___) then
			_detalhes.um___ = 0
			_detalhes.next_um = 3
		end
		
		local cima = true
		
		_detalhes.um___ = _detalhes.um___ + 1
		
		if (_detalhes.um___ == _detalhes.next_um) then
			_detalhes.next_um = _detalhes.next_um + 3
			cima = false
		end
		
		if (cima) then
			local frostbolt = self.spells:PegaHabilidade (116, true, "SPELL_DAMAGE")
			local frostfirebolt = self.spells:PegaHabilidade (44614, true, "SPELL_DAMAGE")
			local icelance = self.spells:PegaHabilidade (30455, true, "SPELL_DAMAGE")
			
			self.spells._ActorTable [116].total = 50000
			self.spells._ActorTable [44614].total = 25000
			self.spells._ActorTable [30455].total = 25000
		else
			local frostbolt = self.spells:PegaHabilidade (84721, true, "SPELL_DAMAGE")
			local frostfirebolt = self.spells:PegaHabilidade (113092, true, "SPELL_DAMAGE")
			local icelance = self.spells:PegaHabilidade (122, true, "SPELL_DAMAGE")
			
			self.spells._ActorTable [84721].total = 50000
			self.spells._ActorTable [113092].total = 25000
			self.spells._ActorTable [122].total = 25000
		end
		
		combat.start_time = GetTime()-30
		combat.end_time = GetTime()
		
		combat.totals_grupo [1] = 100000
		combat.totals [1] = 100000
	
		--combat.instance_type = "raid"
		--combat.is_trash = true
	
		_detalhes.tabela_vigente = combat
		
		_detalhes.tabela_historico:adicionar (combat)
	
		_detalhes:InstanciaCallFunction (_detalhes.gump.Fade, "in", nil, "barras")
		_detalhes:InstanciaCallFunction (_detalhes.AtualizaSegmentos) -- atualiza o instancia.showing para as novas tabelas criadas
		_detalhes:InstanciaCallFunction (_detalhes.AtualizaSoloMode_AfertReset) -- verifica se precisa zerar as tabela da janela solo mode
		_detalhes:InstanciaCallFunction (_detalhes.ResetaGump) --_detalhes:ResetaGump ("de todas as instancias")
		_detalhes:AtualizaGumpPrincipal (-1, true) --atualiza todas as instancias
		
		

	elseif (msg == "pets") then
		local f = _detalhes:CreateListPanel()
		
		local i = 1
		for k, v in pairs (_detalhes.tabela_pets.pets) do
			if (v[6] == "Guardian of Ancient Kings") then
				_detalhes.ListPanel:add ( k.. ": " ..  v[1] .. " | " .. v[2] .. " | " .. v[3] .. " | " .. v[6], i)
				i = i + 1
			end
		end
		
		f:Show()
		
	elseif (msg == "savepets") then
		
		_detalhes.tabela_vigente.saved_pets = {}
		
		for k, v in pairs (_detalhes.tabela_pets.pets) do
			_detalhes.tabela_vigente.saved_pets [k] = {v[1], v[2], v[3]}
		end
		
		_detalhes:Msg ("pet table has been saved on current combat.")

	elseif (msg == "move") then
	
		print ("moving...")
		
		local instance = _detalhes.tabela_instancias [1]
		instance.baseframe:ClearAllPoints()
		--instance.baseframe:SetPoint ("CENTER", UIParent, "CENTER", 300, 100)
		instance.baseframe:SetPoint ("left", DetailsWelcomeWindow, "right", 10, 0)
	
	elseif (msg == "model") then
		local frame = CreateFrame ("PlayerModel");
		frame:SetPoint("center",UIParent,"center");
		frame:SetHeight(600);
		frame:SetWidth(300);
		frame:SetDisplayInfo (49585);
		
	elseif (msg == "ej2") then
	
		--[[ get the EJ_ raid id
		local wantRaids = true -- set false to get 5-man list
		for i=1,1000 do
		    instanceID,name,description,bgImage,buttonImage,loreImage, dungeonAreaMapID, link = EJ_GetInstanceByIndex(i,wantRaids)
		    if not instanceID then break end
		    DEFAULT_CHAT_FRAME:AddMessage(      instanceID.." "..name ,1,0.7,0.5)
		end
		--]]
		
		local iid=362

		for i=1, 100 do
		    local name, description, encounterID, rootSectionID, link = EJ_GetEncounterInfoByIndex (i, iid)

		    if not encounterID then break end
		    local msg = encounterID .. " , " ..  name .. ", ".. rootSectionID.. ", "..link
		    DEFAULT_CHAT_FRAME:AddMessage(msg, 1,0.7,0.5)
		end
		
	elseif (msg == "ej") then
		function PrintAllEncounterSections(encounterID, difficultyID)
			EJ_SetDifficulty(difficultyID)
			local stack, encounter, _, _, curSectionID = {}, EJ_GetEncounterInfo(encounterID)
			print(stack, encounter, _, _, curSectionID)
			repeat
				local title, desc, depth, icon, model, siblingID, nextSectionID, filteredByDifficulty, link, _, f1, f2, f3, f4 = EJ_GetSectionInfo(curSectionID)
				if not filteredByDifficulty then
					--print(("  "):rep(depth) .. link .. ": " .. desc)
					--npcs nao tem icone e possuel modelo diferente de zero.
					--spells tem icone e possuel modelo = zero
					print (title, icon, model, siblingID)
				end
				table.insert(stack, siblingID)
				table.insert(stack, nextSectionID)
				curSectionID = table.remove(stack)
			until not curSectionID
		end
		
		-- Print everything in 25-man Normal Madness of Deathwing:
		PrintAllEncounterSections (869, 4)		
		
	elseif (msg == "time") then
		print ("GetTime()", GetTime())
		print ("time()", time())

	elseif (msg == "buffs") then
	
		for buffIndex = 1, 41 do
		
			--local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitAura ("player", buffIndex, nil, "HELPFUL")
			--if (name) then
			--	print (name, unitCaster, spellid)
			--end
			
			local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitAura ("raid1", buffIndex, nil, "HELPFUL")
			if (name) then
				print (name, unitCaster, spellid)
			end
			
			local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitAura ("raid2", buffIndex, nil, "HELPFUL")
			if (name) then
				print (name, unitCaster, spellid)
			end
		
		end
	
		
	elseif (msg == "malkorok") then
	
		print ("nome | count | unitCaster | spellId |  isBossDebuff | value1 | value2 | value3")
	
		do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3  = UnitDebuff ("player", 1)
			if (name) then
				print (name, " | ", count, " | ", unitCaster, " | ",spellId, " | ", isBossDebuff, " | ", value1, " | ", value2, " | ", value3)
			end
		end
		do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3  = UnitDebuff ("player", 2)
			if (name) then
				print (name, " | ", count, " | ", unitCaster, " | ",spellId, " | ", isBossDebuff, " | ", value1, " | ", value2, " | ", value3)
			end
		end
		do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3  = UnitDebuff ("player", 3)
			if (name) then
				print (name, " | ", count, " | ", unitCaster, " | ",spellId, " | ", isBossDebuff, " | ", value1, " | ", value2, " | ", value3)
			end
		end
		
	elseif (msg == "copy") then
		_G.DetailsCopy:Show()
		_G.DetailsCopy.MyObject.text:HighlightText()
		_G.DetailsCopy.MyObject.text:SetFocus()
	
	elseif (msg == "garbage") then
		local a = {}
		for i = 1, 10000 do 
			a [i] = {math.random (50000)}
		end
		table.wipe (a)
	
	elseif (msg == "unitname") then
	
		local nome, realm = UnitName ("target")
		if (realm) then
			nome = nome.."-"..realm
		end
		print (nome, realm)
	
	elseif (msg == "raid") then
	
		local player, realm = "Ditador", "Azralon"
	
		local actorName
		if (realm ~= GetRealmName()) then
			actorName = player.."-"..realm
		else
			actorName = player
		end
		
		print (actorName)
	
		local guid = _detalhes:FindGUIDFromName ("Ditador")
		print (guid)
		
		for i = 1, GetNumGroupMembers()-1, 1 do 
			local name, realm = UnitName ("party"..i)
			print (name, " -- ", realm)
		end

	elseif (msg == "cacheparser") then
		_detalhes:PrintParserCacheIndexes()
	elseif (msg == "parsercache") then
		_detalhes:PrintParserCacheIndexes()
	
	elseif (msg == "captures") then
		for k, v in pairs (_detalhes.capture_real) do 
			print ("real -",k,":",v)
		end
		for k, v in pairs (_detalhes.capture_current) do 
			print ("current -",k,":",v)
		end
	
	elseif (msg == "slider") then
		
		local f = CreateFrame ("frame", "TESTEDESCROLL", UIParent)
		f:SetPoint ("center", UIParent, "center", 200, -2)
		f:SetWidth (300)
		f:SetHeight (150)
		f:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		f:SetBackdropColor (0, 0, 0, 1)
		f:EnableMouseWheel (true)
		
		local rows = {}
		for i = 1, 7 do 
			local row = CreateFrame ("frame", nil, UIParent)
			row:SetPoint ("topleft", f, "topleft", 10, -(i-1)*21)
			row:SetWidth (200)
			row:SetHeight (20)
			row:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
			local t = row:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			t:SetPoint ("left", row, "left")
			row.text = t
			rows [#rows+1] = row
		end
		
		local data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
		
		
	
	elseif (msg == "bcollor") then
	
		--local instancia = _detalhes.tabela_instancias [1]
		_detalhes.ResetButton.Middle:SetVertexColor (1, 1, 0, 1)
		
		--print (_detalhes.ResetButton:GetHighlightTexture())
		
		local t = _detalhes.ResetButton:GetHighlightTexture()
		t:SetVertexColor (0, 1, 0, 1)
		--print (t:GetObjectType())
		--_detalhes.ResetButton:SetHighlightTexture (t)
		_detalhes.ResetButton:SetNormalTexture (t)
		
		print ("backdrop", _detalhes.ResetButton:GetBackdrop())
		
		_detalhes.ResetButton:SetBackdropColor (0, 0, 1, 1)
		
		--vardump (_detalhes.ResetButton)
	
	elseif (command == "mini") then
		local instance = _detalhes.tabela_instancias [1]
		--vardump ()
		--print (instance, instance.StatusBar.options, instance.StatusBar.left)
		print (instance.StatusBar.options [instance.StatusBar.left.mainPlugin.real_name].textSize)
		print (instance.StatusBar.left.options.textSize)
	
	elseif (command == "owner") then
	
		local petname = rest:match ("^(%S*)%s*(.-)$")
		local petGUID = UnitGUID ("target")

		if (not _G.DetailsScanTooltip) then
			local scanTool = CreateFrame ("GameTooltip", "DetailsScanTooltip", nil, "GameTooltipTemplate")
			scanTool:SetOwner (WorldFrame, "ANCHOR_NONE")
		end
		
		function getPetOwner (petName)
			local scanTool = _G.DetailsScanTooltip
			local scanText = _G ["DetailsScanTooltipTextLeft2"] -- This is the line with <[Player]'s Pet>
			
			scanTool:ClearLines()
			
			print (petName)
			scanTool:SetUnit (petName)
			
			local ownerText = scanText:GetText()
			if (not ownerText) then 
				return nil 
			end
			local owner, _ = string.split ("'", ownerText)

			return owner -- This is the pet's owner
		end
		
		--print (getPetOwner (petname))
		print (getPetOwner (petGUID))

	
	elseif (command == "buffsof") then
		
		local playername, segment = rest:match("^(%S*)%s*(.-)$")
		segment = tonumber (segment or 0)
		print ("dumping buffs of ", playername, segment)
		
		local c = _detalhes:GetCombat ("current")
		if (c) then
		
			local playerActor
		
			if (segment and segment ~= 0) then
				local c = _detalhes:GetCombat (segment)
				playerActor = c (4, playername)
				print ("using segment", segment, c, "player actor:", playerActor)
			else
				playerActor = c (4, playername)
			end
			
			print ("actor table: ", playerActor)
			
			if (not playerActor) then
				print ("actor table not found")
				return
			end
			
			if (playerActor and playerActor.buff_uptime_spells and playerActor.buff_uptime_spells._ActorTable) then
				for spellid, spellTable in pairs (playerActor.buff_uptime_spells._ActorTable) do 
					local spellname = GetSpellInfo (spellid)
					if (spellname) then
						print (spellid, spellname, spellTable.uptime)
					end
				end
			end
		end
	
	elseif (msg == "comm") then
		
		local test_plugin = TESTPLUGIN
		if (not test_plugin) then
			local p = _detalhes:NewPluginObject ("DetailsTestPlugin", nil, "STATUSBAR")
			_detalhes:InstallPlugin ("STATUSBAR", "Plugin Test", [[Interface\COMMON\StreamCircle]], p, "TESTPLUGIN", 1, "Details!", "v1.0")
			test_plugin = TESTPLUGIN
			
			function test_plugin:ReceiveAA (a, b, c, d, e, f, g)
				print ("working 1", a, b, c, d, e, f, g)
			end
			
			function test_plugin:ReceiveAB (a, b, c, d, e, f, g)
				print ("working 2", a, b, c, d, e, f, g)
			end
			
			test_plugin:RegisterPluginComm ("PTAA", "ReceiveAA")
			test_plugin:RegisterPluginComm ("PTAB", "ReceiveAB")
		end
		
		test_plugin:SendPluginCommMessage ("PTAA", nil, "teste 1", "teste 2", "teste3")
		

	elseif (msg == "teste") then
		
		local a, b = _detalhes:GetEncounterEnd (1098, 3)
		print (a, unpack (b))
		
	elseif (msg == "yesno") then
		--_detalhes:Show()
	
	elseif (msg == "imageedit") then
		
		local callback = function (width, height, overlayColor, alpha, texCoords)
			print (width, height, alpha)
			print ("overlay: ", unpack (overlayColor))
			print ("crop: ", unpack (texCoords))
		end
		
		_detalhes.gump:ImageEditor (callback, "Interface\\TALENTFRAME\\bg-paladin-holy", nil, {1, 1, 1, 1}) -- {0.25, 0.25, 0.25, 0.25}

	elseif (msg == "chat") then
	
		local name, fontSize, r, g, b, a, shown, locked = FCF_GetChatWindowInfo (1);
		print (name,"|",fontSize,"|", r,"|", g,"|", b,"|", a,"|", shown,"|", locked)
		
		--local fontFile, unused, fontFlags = self:GetFont();
		--self:SetFont(fontFile, fontSize, fontFlags);
	
	elseif (msg == "error") then
		a = nil + 1
		
	--> debug
	elseif (command == "resetcapture") then
		_detalhes.capture_real = {
			["damage"] = true,
			["heal"] = true,
			["energy"] = true,
			["miscdata"] = true,
			["aura"] = true,
		}
		_detalhes.capture_current = _detalhes.capture_real
		_detalhes:CaptureRefresh()
		print (Loc ["STRING_DETAILS1"] .. "capture has been reseted.")

	--> debug
	elseif (command == "barra") then 
	
		local qual_barra = rest and tonumber (rest) or 1
	
		local instancia = _detalhes.tabela_instancias [1]
		local barra = instancia.barras [qual_barra]
		
		for i = 1, barra:GetNumPoints() do 
			local point, relativeTo, relativePoint, xOfs, yOfs = barra:GetPoint (i)
			print (point, relativeTo, relativePoint, xOfs, yOfs)
		end
	
	elseif (msg == "opened") then 
		print ("Instances opened: " .. _detalhes.opened_windows)
	
	--> debug, get a guid of something
	elseif (command == "backdrop") then --> localize-me
		local f = MacroFrameTextBackground
		local backdrop = MacroFrameTextBackground:GetBackdrop()
		
		vardump (backdrop)
		vardump (backdrop.insets)
		
		print ("bgcolor:",f:GetBackdropColor())
		print ("bordercolor",f:GetBackdropBorderColor())
	
	elseif (command == "myguid") then --> localize-me
	
		local g = UnitGUID ("player")
		print (type (g))
		print (g)
		print (string.len (g))
		local serial = g:sub (12, 18)
		serial = tonumber ("0x"..serial)
		print (serial)
		
		--tonumber((UnitGUID("target")):sub(-12, -9), 16))
		
	elseif (command == "callfunction") then
	
		_detalhes:InstanceCall (_detalhes.SetCombatAlpha, nil, nil, true)
	
	elseif (command == "guid") then --> localize-me
	
		local pass_guid = rest:match("^(%S*)%s*(.-)$")
	
		if (not _detalhes.id_frame) then 
		
			local backdrop = {
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			tile = true, edgeSize = 1, tileSize = 5,
			}
		
			_detalhes.id_frame = CreateFrame ("Frame", "DetailsID", UIParent)
			_detalhes.id_frame:SetHeight(14)
			_detalhes.id_frame:SetWidth(120)
			_detalhes.id_frame:SetPoint ("center", UIParent, "center")
			_detalhes.id_frame:SetBackdrop(backdrop)
			
			tinsert (UISpecialFrames, "DetailsID")
			
			_detalhes.id_frame.texto = CreateFrame ("editbox", nil, _detalhes.id_frame)
			_detalhes.id_frame.texto:SetPoint ("topleft", _detalhes.id_frame, "topleft")
			_detalhes.id_frame.texto:SetAutoFocus(false)
			_detalhes.id_frame.texto:SetFontObject (GameFontHighlightSmall)			
			_detalhes.id_frame.texto:SetHeight(14)
			_detalhes.id_frame.texto:SetWidth(120)
			_detalhes.id_frame.texto:SetJustifyH("CENTER")
			_detalhes.id_frame.texto:EnableMouse(true)
			_detalhes.id_frame.texto:SetBackdrop(ManualBackdrop)
			_detalhes.id_frame.texto:SetBackdropColor(0, 0, 0, 0.5)
			_detalhes.id_frame.texto:SetBackdropBorderColor(0.3, 0.3, 0.30, 0.80)
			_detalhes.id_frame.texto:SetText ("") --localize-me
			_detalhes.id_frame.texto.perdeu_foco = nil
			
			_detalhes.id_frame.texto:SetScript ("OnEnterPressed", function () 
				_detalhes.id_frame.texto:ClearFocus()
				_detalhes.id_frame:Hide() 
			end)
			
			_detalhes.id_frame.texto:SetScript ("OnEscapePressed", function() 
				_detalhes.id_frame.texto:ClearFocus()
				_detalhes.id_frame:Hide() 
			end)
			
		end
		
		_detalhes.id_frame:Show()
		_detalhes.id_frame.texto:SetFocus()
		
		if (pass_guid == "-") then
			local guid = UnitGUID ("target")
			if (guid) then 
				local g = _detalhes:GetNpcIdFromGuid (guid)
				_detalhes.id_frame.texto:SetText ("" .. g)
				_detalhes.id_frame.texto:HighlightText()
			end
		
		else
			print (pass_guid.. " -> " .. tonumber (pass_guid:sub(6, 10), 16))
			_detalhes.id_frame.texto:SetText (""..tonumber (pass_guid:sub(6, 10), 16))
			_detalhes.id_frame.texto:HighlightText()
		end
		
	--> debug
	
	elseif (msg == "auras") then
		if (IsInRaid()) then
			for raidIndex = 1, GetNumGroupMembers() do 
				for buffIndex = 1, 41 do
					local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitAura ("raid"..raidIndex, buffIndex, nil, "HELPFUL")
					print (name, unitCaster, "==", "raid"..raidIndex)
					if (name and unitCaster == "raid"..raidIndex) then
						
						local playerName, realmName = UnitName ("raid"..raidIndex)
						if (realmName and realmName ~= "") then
							playerName = playerName .. "-" .. realmName
						end
						
						_detalhes.parser:add_buff_uptime (nil, GetTime(), UnitGUID ("raid"..raidIndex), playerName, 0x00000417, UnitGUID ("raid"..raidIndex), playerName, 0x00000417, spellid, name, in_or_out)
						
					else
						--break
					end
				end
			end
		end
		
	elseif (command == "profile") then
	
		local profile = rest:match("^(%S*)%s*(.-)$")
		
		print ("Force apply profile: ", profile)
		
		_detalhes:ApplyProfile (profile, false)
	
	elseif (msg == "users") then
		_detalhes.users = {}
		_detalhes.sent_highfive = GetTime()
		_detalhes:SendRaidData (_detalhes.network.ids.HIGHFIVE_REQUEST)
		print (Loc ["STRING_DETAILS1"] .. "highfive sent.")
	
	elseif (command == "showusers") then
		local users = _detalhes.users
		if (not users) then
			return _detalhes:Msg ("there is no users.")
		end
		
		local f = _detalhes.ListPanel
		if (not f) then
			f = _detalhes:CreateListPanel()
		end
		
		local i = 0
		for _, t in ipairs (users) do 
			i = i + 1
			f:add (t [1] .. " | " .. t [2] .. " | " .. t [3] , i)
		end
		
		print (i, "users found.")
	
		f:Show()
	
	elseif (command == "names") then
		local t, filter = rest:match("^(%S*)%s*(.-)$")

		t = tonumber (t)
		if (not t) then
			return print ("not T found.")
		end

		local f = _detalhes.ListPanel
		if (not f) then
			f = _detalhes:CreateListPanel()
		end
		
		local container = _detalhes.tabela_vigente [t]._NameIndexTable
		
		local i = 0
		for name, _ in pairs (container) do 
			i = i + 1
			f:add (name, i)
		end
		
		print (i, "names found.")
	
		f:Show()
		
	elseif (command == "actors") then
	
		local t, filter = rest:match("^(%S*)%s*(.-)$")

		t = tonumber (t)
		if (not t) then
			return print ("not T found.")
		end

		local f = _detalhes.ListPanel
		if (not f) then
			f = _detalhes:CreateListPanel()
		end
		
		local container = _detalhes.tabela_vigente [t]._ActorTable
		print (#container, "actors found.")
		for index, actor in ipairs (container) do 
			f:add (actor.nome, index, filter)
		end
	
		f:Show()
	
	--> debug
	elseif (msg == "save") then
		print ("running... this is a debug command, details wont work until next /reload.")
		_detalhes:PrepareTablesForSave()
	
	elseif (msg == "id") then
		local one, two = rest:match("^(%S*)%s*(.-)$")
		if (one ~= "") then
			print("NPC ID:", one:sub(-12, -9), 16)
			print("NPC ID:", tonumber((one):sub(-12, -9), 16))
		else
			print("NPC ID:", tonumber((UnitGUID("target")):sub(-12, -9), 16) )
		end

	--> debug
	elseif (command == "debug") then
		if (_detalhes.debug) then
			_detalhes.debug = false
			print (Loc ["STRING_DETAILS1"] .. "diagnostic mode has been turned off.")
			return
		else
			_detalhes.debug = true
			print (Loc ["STRING_DETAILS1"] .. "diagnostic mode has been turned on.")
			
			if (rest and rest ~= "") then
				if (rest == "-clear") then
					_detalhes_global.debug_chr_log = ""
					print (Loc ["STRING_DETAILS1"] .. "log for characters has been wiped.")
					return
				end
				_detalhes.debug_chr = rest
				_detalhes_global.debug_chr_log = _detalhes_global.debug_chr_log or ""
				print (Loc ["STRING_DETAILS1"] .. "diagnostic for character " .. rest .. " turned on.")
				return
			end
		end
	
	--> debug combat log
	elseif (msg == "combatlog") then
		if (_detalhes.isLoggingCombat) then
			LoggingCombat (false)
			print ("Wow combatlog record turned OFF.")
			_detalhes.isLoggingCombat = nil
		else
			LoggingCombat (true)
			print ("Wow combatlog record turned ON.")
			_detalhes.isLoggingCombat = true
		end
		
	elseif (msg == "gs") then
		_detalhes:teste_grayscale()
		
	elseif (msg == "bwload") then
		if not BigWigs then LoadAddOn("BigWigs_Core") end
		BigWigs:Enable()

		LoadAddOn ("BigWigs_Highmaul")
		
		local mod = BigWigs:GetBossModule("Imperator Mar'gok")
		mod:Enable()
		
	elseif (msg == "bwsend") then
		local mod = BigWigs:GetBossModule("Imperator Mar'gok")
		mod:Message("stages", "Neutral", "Long", "Phase 2", false)
		
	elseif (msg == "bwregister") then
	
		local addon = {}
		BigWigs.RegisterMessage(addon, "BigWigs_Message")
		function addon:BigWigs_Message(event, module, key, text)
		  if module.journalId  == 1197 and text:match("^Phase %d$") then -- 1197 = Margok
		   print ("Phase Changed!", event, module, key, text)
		  end
		end
	
	elseif (msg == "pos") then
		local x, y = GetPlayerMapPosition ("player")
		
		if (not DetailsPosBox) then
			_detalhes.gump:CreateTextEntry (UIParent, function()end, 200, 20, nil, "DetailsPosBox")
			DetailsPosBox:SetPoint ("center", UIParent, "center")
		end
		
		local one, two = rest:match("^(%S*)%s*(.-)$")
		if (one == "2") then
			DetailsPosBox.MyObject.text = "{x2 = " .. x .. ", y2 = " .. y .. "}"
		else
			DetailsPosBox.MyObject.text = "{x1 = " .. x .. ", y1 = " .. y .. "}"
		end
		DetailsPosBox.MyObject:SetFocus()
		DetailsPosBox.MyObject:HighlightText()
	
	elseif (msg == "outline") then
	
		local instancia = _detalhes.tabela_instancias [1]
		for _, barra in ipairs (instancia.barras) do 
			local _, _, flags = barra.texto_esquerdo:GetFont()
			print ("outline:",flags)
		end
	
	elseif (msg == "sell") then
		
		--sell gray
		local c, i, n, v = 0
		for b = 0, 4 do
			for s = 1, GetContainerNumSlots(b) do 
				i = {GetContainerItemInfo (b, s)}
				n = i[7]
				if n and string.find(n,"9d9d9d") then 
					v = {GetItemInfo(n)}
					q = i[2]
					c = c+v[11]*q
					UseContainerItem (b, s)
					print (n, q)
				end
			end
		end
		print(GetCoinText(c))
		
		--sell green equip
		local c, i, n, v = 0
		for b = 0, 4 do
			for s = 1, GetContainerNumSlots(b) do 
				local texture, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo (b, s)
				if (quality == 2) then --a green item
					local itemName, itemLink, itemRarity, itemLevel, _, itemType, itemSubType = GetItemInfo (itemLink)
					if (itemType == "Armor" or itemType == "Weapon") then --a weapon or armor
						if (itemLevel < 460) then
							print ("Selling", itemName, itemType)
							UseContainerItem (b, s)
						end
					end
				end
			end
		end
	
	elseif (msg == "forge") then
		_detalhes:OpenForge()
	
	elseif (msg == "parser") then
		
		_detalhes:OnParserEvent (
			"COMBAT_LOG_EVENT_UNFILTERED", --evento = 
			1548754114, --time = 
			"SPELL_DAMAGE", --token = 
			nil, --hidding = 
			"0000000000000000", --who_serial = 
			nil, --who_name = 
			0x514, --who_flags = 
			0x0, --who_flags2 = 
			"Player-3676-06F3C3FA", --alvo_serial = 
			"Icybluefur-Area52", --alvo_name = 
			0x514, --alvo_flags = 
			0x0, --alvo_flags2 = 
			157247, --spellid = 
			"Reverberations", --spellname = 
			0x1, --spelltype = 
			4846, --amount = 
			-1, --overkill = 
			1 --school = 
		)
		
	elseif (msg == "ejloot") then
		EJ_SelectInstance (669) -- hellfire citadel
		EJ_SetDifficulty (16)
		
		local r = {}
		local total = 0
		
		for i = 1, 100 do
			local name, description, encounterID, rootSectionID, link = EJ_GetEncounterInfoByIndex (i, 669)
			if (name) then
				EJ_SelectEncounter (encounterID)
				print (name, encounterID, EJ_GetNumLoot())

				for o = 1, EJ_GetNumLoot() do
					local name, icon, slot, armorType, itemID, link, encounterID = EJ_GetLootInfoByIndex (o)
					r[slot] = r[slot] or {}
					tinsert (r[slot], {itemID, encounterID})
					total = total + 1
				end
			end
		end	
	
		print ("total loot", total)
		_detalhes_global.ALOOT  = r
	
	elseif (msg == "ilvl2") then

		local item_amount = 16
		local item_level = 0
		local failed = 0
		local unitid = "player"
		local two_hand = {
			["INVTYPE_2HWEAPON"] = true,
			["INVTYPE_RANGED"] = true,
			["INVTYPE_RANGEDRIGHT"] = true,
		}
		
		for equip_id = 1, 17 do

			if (equip_id ~= 4) then --shirt slot
				local item = GetInventoryItemLink (unitid, equip_id)
				if (item) then
					local iName, _, itemRarity, iLevel, _, _, _, _, equipSlot = GetItemInfo (item)
					if (iLevel) then
						
						--local _, _, _, _, _, _, _, _, _, _, _, upgradeTypeID, _, numBonusIDs, bonusID1, bonusID2 = strsplit (":", item)
						--> upgrades handle by LibItemUpgradeInfo-1.0
						--> http://www.wowace.com/addons/libitemupgradeinfo-1-0/
						
						local artifact_offhands = {
							["133959"] = true, --mage fire
							["128293"] = true, --dk frost
							["127830"] = true, --dh havoc
							["128831"] = true, --dh vengeance
							["128859"] = true, --druid feral
							["128822"] = true, --druid guardian
							["133948"] = true, --monk ww
							["128866"] = true, --paladin prot
							["133958"] = true, --priest shadow
							["128869"] = true, --rogue assassination
							["134552"] = true, --rogue outlaw
							["128479"] = true, --rogue subtlety
							["128936"] = true, --shaman elemental
							["128873"] = true, --shaman en
							["128934"] = true, --shaman resto
							["137246"] = true, --warlock demo
							["128289"] = true, --warrior prot
						}

						if (equip_id == 17) then -- and false
							local itemId = select (2, strsplit (":", item))
							if (artifact_offhands [itemId]) then
								local mainHand = GetInventoryItemLink (unitid, 16)
								if (mainHand) then
									local iName, _, itemRarity, mainHandILevel, _, _, _, _, equipSlot = GetItemInfo (mainHand)
									if (iLevel) then
										item = mainHand
										iLevel = mainHandILevel
									end
								end
							end
						end
						
						local ItemUpgradeInfo = LibStub ("LibItemUpgradeInfo-1.0")
						if (ItemUpgradeInfo) then
							local ilvl = ItemUpgradeInfo:GetUpgradedItemLevel (item)
							item_level = item_level + (ilvl or iLevel)
							print (item, ilvl, iLevel)
						else
							item_level = item_level + iLevel
							print (iName, iLevel, "-|cFFFF0000lib not found|r-")
						end
						
						--> 16 = main hand 17 = off hand
						-->  if using a two-hand, ignore the off hand slot
						if (equip_id == 16 and two_hand [equipSlot]) then
							item_amount = 15
							break
						end
					end
				else
					failed = failed + 1
					if (failed > 2) then
						break
					end
				end
			end
		end
		
		local average = item_level / item_amount
		print ("gear score:", item_level, "item amount:", item_amount, "ilvl:", average)
	
	elseif (msg == "ilvl") then
	
		--
		local ilvl_frame = CreateFrame ("GameTooltip", "details_ilvl_tooltip", UIParent, "GameTooltipTemplate");
		local get_ilvl = function (itemLink)
			ilvl_frame:SetOwner (UIParent, "ANCHOR_NONE")
			ilvl_frame:ClearLines()
			ilvl_frame:SetHyperlink (itemLink)
			
			for i = 1, 13 do
				local text = _G ["details_ilvl_tooltipTextLeft" .. i] and _G ["details_ilvl_tooltipTextLeft" .. i]:GetText()
				if (text and text:find (ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL)) then
					print ("ItemLevel:", text:gsub (ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, ""))
					break
				end
			end
		end
		
		local item = GetInventoryItemLink ("player", 14)
		get_ilvl (item)

		print (item)
		local ItemUpgradeInfo = LibStub("LibItemUpgradeInfo-1.0")
		local SlotNames = "Trinket1"
		local Slot = GetInventoryItemLink ("player", GetInventorySlotInfo (("%sSlot"):format (SlotNames)))
		print (Slot)
		--local upgrade, max, delta = ItemUpgradeInfo:GetItemUpgradeInfo (item)
		local upgrade, max, delta = ItemUpgradeInfo:GetItemUpgradeInfo (item)
		local ilvl = ItemUpgradeInfo:GetUpgradedItemLevel (item)
		
		print (ilvl, upgrade, max, delta)
		
		print (GetItemInfo (item))
		
	elseif (msg == "score") then
		
		_detalhes:OpenRaidHistoryWindow ("Hellfire Citadel", 1800, 15, "DAMAGER", "Rock Lobster", 2, "Keyspell")
	
	elseif (msg == "bar") then
		local bar = _G.DetailsTestBar
		if (not bar) then
			bar = Details.gump:CreateBar (UIParent, nil, 600, 200, 100, nil, "DetailsTestBar")
			_G.DetailsTestBar = bar
			bar:SetPoint ("center", 0, 0)
			bar.RightTextIsTimer = true
			bar.BarIsInverse = true
		end
		
		bar.color = "HUNTER"
		
		local start = GetTime()-45
		local fim = GetTime()+5
		
		bar:SetTimer (start, fim)
		
		--C_Timer.After (5, function() bar:CancelTimerBar() end)
	
	
	elseif (msg == "q") then
	
		local myframe = TestFrame
		if (not myframe) then
			myframe = TestFrame or CreateFrame ("frame", "TestFrame", UIParent)
			myframe:SetPoint ("center", UIParent, "center")
			myframe:SetSize (300, 300)
			myframe.texture = myframe:CreateTexture (nil, "overlay")
			myframe.texture:SetAllPoints()
			myframe.texture:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\icon_flag_common]])
		else
			if (myframe.texture:IsShown()) then
				myframe.texture:Hide()
			else
				print (myframe.texture:GetTexture())
				myframe.texture:Show()
				print (myframe.texture:GetTexture())
			end
		end
		
		
		
		if (true) then
			return
		end
	
		local y = -50
		local allspecs = {}
		
		for a, b in pairs (_detalhes.class_specs_coords) do
			tinsert (allspecs, a)
		end
		
		for i = 1, 10 do
	
			local a = CreateFrame ("statusbar", nil, UIParent)
			a:SetPoint ("topleft", UIParent, "topleft", i*32, y)
			a:SetSize (32, 32)
			a:SetMinMaxValues (0, 1)
			
			local texture = a:CreateTexture (nil, "overlay")
			texture:SetSize (32, 32)
			texture:SetPoint ("topleft")
			
			if (i%10 == 0) then
				y = y - 32
			end

--	/run for o=1,10 do local f=CreateFrame("frame");f:SetPoint("center");f:SetSize(300,300); local t=f:CreateTexture(nil,"overlay");t:SetAllPoints();f:SetScript("OnUpdate",function() t:SetTexture("Interface\\1024")end);end;
--	https://www.dropbox.com/s/ulyeqa2z0ummlu7/1024.tga?dl=0

			local time = 0
			a:SetScript ("OnUpdate", function (self, deltaTime)
				time = time + deltaTime
				
				--texture:SetSize (math.random (50, 300), math.random (50, 300))
				--local spec = allspecs [math.random (#allspecs)]
				texture:SetTexture ([[Interface\AddOns\Details\images\options_window]])
				--texture:SetTexture ([[Interface\Store\Store-Splash]])
				--texture:SetTexture ([[Interface\AddOns\Details\images\options_window]])
				--texture:SetTexture ([[Interface\CHARACTERFRAME\Button_BloodPresence_DeathKnight]])
				--texture:SetTexCoord (unpack (_detalhes.class_specs_coords [spec]))
				
				--a:SetAlpha (abs (math.sin (time)))
				--a:SetValue (abs (math.sin (time)))
			end)
		end
	
	elseif (msg == "alert") then
		--local instancia = _detalhes.tabela_instancias [1]
		local f = function (a, b, c, d, e, f, g) print (a, b, c, d, e, f, g) end
		--instancia:InstanceAlert (Loc ["STRING_PLEASE_WAIT"], {[[Interface\COMMON\StreamCircle]], 22, 22, true}, 5, {f, 1, 2, 3, 4, 5})
	
		local lower_instance = _detalhes:GetLowerInstanceNumber()
		if (lower_instance) then
			local instance = _detalhes:GetInstance (lower_instance)
			if (instance) then
				local func = {_detalhes.OpenRaidHistoryWindow, _detalhes, "Hellfire Citadel", 1800, 15, "DAMAGER", "Rock Lobster", 2, "Keyspell"}
				instance:InstanceAlert ("Boss Defeated, Open History! ", {[[Interface\AddOns\Details\images\icons]], 16, 16, false, 434/512, 466/512, 243/512, 273/512}, 40, func, true)
			end
		end
		
	elseif (msg == "astudio") then	
	
		if (not DetailsAnimationStudio) then
			local FW = _detalhes.gump
			
			FW:InstallTemplate ("button", "LIST_BUTTON_TEMPLATE", {backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true}, backdropcolor = {0, 0, 0, .5}, backdropbordercolor = {0, 0, 0, 1}})
			FW:InstallTemplate ("font", "LIST_BUTTON_TEMPLATE", {color = "orange", size = 12, font = "Accidental Presidency"})
			FW:InstallTemplate ("font", "PROGRESSBAR_TEMPLATE", {color = "silver", size = 10, font = "Accidental Presidency"})
			
			DetailsAnimationStudio = FW:CreateSimplePanel (UIParent)
			DetailsAnimationStudio:SetPoint ("center", UIParent, "center")
			DetailsAnimationStudio:SetSize (800, 600)
			
			local f = DetailsAnimationStudio
			
			local textEntryTemplate = FW:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
			local textTemplate = FW:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
				
			--Main Menu
				local menuYOffset = -20
				
				--new animation button
					local CreateNewAnimation = function()
					
						--hide the previous animation preview
						if (f.CurrentAnimation) then
							f.CurrentAnimation.FrameObject:Hide()
						end
					
						--create the new table
						local t = {
							Name = "",
							Widgets = {},
							FrameObject = CreateFrame ("frame", "NewAnimation" .. math.random (999999), f)
						}
						f.CurrentAnimation = t
						
						--clear the left scroll with widgets
						f:ClearWidgetList()
						--hide the widget config frame
						f.widgetConfigFrame:Hide()
						--hide the animation frame
						f.HideAnimationList()
						f:HideAnimationConfigFrames()
						--show the animation on the preview frame
						f.CurrentAnimation.FrameObject:Show()
						f.CurrentAnimation.FrameObject:SetPoint ("topright", f, "topright", -10, -30)
						f.CurrentAnimation.FrameObject:SetSize (300, 300)
						
						f.CurrentAnimation.FrameObject:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], tile = true, tileSize = 128, insets = {left=3, right=3, top=3, bottom=3},
						edgeFile = [[Interface\AddOns\Details\images\border_welcome]], edgeSize = 2})
						f.CurrentAnimation.FrameObject:SetBackdropColor (1, 1, 1, 0.75)
						
						f.UpdateProgressBarPoint()
					end
					local newAnimationButton = FW:CreateButton (f, CreateNewAnimation, 100, 20, "New Animation")
					newAnimationButton:SetPoint (10, -20 + menuYOffset)
				
				--new texture button
				local CreateNewTexture = function()
					if (not f.CurrentAnimation) then
						return
					end
					
					local textureObject = f.CurrentAnimation.FrameObject:CreateTexture (nil, "overlay")
					local animationHub = FW:CreateAnimationHub (textureObject, function() end)
					
					textureObject:SetPoint ("center", 0, 0)
					
					local texture = {
						textureObject = textureObject,
						animationHub = animationHub,
						type = "texture",
						file = "Interface\\Destiny\\EndscreenImage",
						memberName = "Texture " .. #f.CurrentAnimation.Widgets + 1,
						width = 100,
						height = 100,
						locationX = 0,
						locationY = 0,
						desaturated = false,
						texCoords = {0, 1, 0, 1},
						alpha = 1,
						color = {1, 1, 1},
						
						Animations = {},
					}
					
					textureObject:SetTexture (texture.file)
					textureObject:SetSize (texture.width, texture.height)
					textureObject:SetPoint ("center", texture.locationX, texture.locationY)
					textureObject:SetDesaturated (texture.desaturated)
					textureObject:SetTexCoord (unpack (texture.texCoords))
					textureObject:SetVertexColor (unpack (texture.color))
					textureObject:SetAlpha (texture.alpha)

					tinsert (f.CurrentAnimation.Widgets, texture)
					f:UpdateWidgetList()
					
				end
				
				local newTextureButton = FW:CreateButton (f, CreateNewTexture, 100, 20, "Add Texture")
				newTextureButton:SetPoint (10, -40 + menuYOffset)
				
				--new sound button
				local newAudioButton = FW:CreateButton (f, function() end, 100, 20, "Add Audio")
				newAudioButton:SetPoint (10, -60 + menuYOffset)
				
				--scroll of textures and sounds created
				function f.EditWidget (self, fixedParameter, index)

					if (not f.CurrentAnimation) then
						return
					end
					
					local t = f.CurrentAnimation.Widgets [index]
					
					if (not t) then
						return
					end
					
					if (t.type == "texture") then
						f.CurrentWidget = t
						
						--set the parameters on the widget config panel
						f.widgetConfigFrame.MemberName.text = t.memberName
						f.widgetConfigFrame.TexturePath.text = t.file
						f.widgetConfigFrame:RefreshOptions()
						
						--refresh the animation list
							f:UpdateAnimationList()
							
							--esconde o painel de config de anima��es
							
						
						--show the config frame
						f.widgetConfigFrame:Show()
					end
					
					f.HideAnimationConfigFrames()
				end
				
				local widgetList = {}
				for i = 1, 20 do
					--todo: a funcao para quando clicar nele, ele abre o painel para editar a textura
					--carrega os parametros do main frame e da fill nos campos
					--o fill nos campos � automatico, basta informar a fonte/source
					
					local b = FW:CreateButton (f, f.EditWidget, 100, 20, "-- x -- x --", i)
					b:SetPoint (10, -80 + (i*-20) + menuYOffset)
					tinsert (widgetList, b)
				end
				
				function f:ClearWidgetList()
					for i = 1, 20 do
						widgetList [i]:Hide()
					end
				end
				
				function f:UpdateWidgetList()
					f:ClearWidgetList()
					if (not f.CurrentAnimation) then
						return
					end
					
					local buttonIndex = 1
					
					for i = 1, #f.CurrentAnimation.Widgets do
						local button = widgetList [buttonIndex]
						local widget = f.CurrentAnimation.Widgets [i]
						if (button) then
							button:Show()
							button.text = widget.memberName
						end
						buttonIndex = buttonIndex + 1
					end
				end
			
			--Edit Panel
			
				local widgetConfigFrame = CreateFrame ("frame", "$parentConfigWidget", f)
				widgetConfigFrame:SetPoint ("topleft", 200, 0)
				widgetConfigFrame:SetSize (300, 600)
				f.widgetConfigFrame = widgetConfigFrame
				
				--member name
					local on_commitMemberName = function()
						f.CurrentWidget.memberName = widgetConfigFrame.MemberName.text
					end
					local memberName = FW:CreateTextEntry (widgetConfigFrame, on_commitMemberName, 120, 20, "MemberName", nil, nil, textEntryTemplate)
					local memberNameText = FW:CreateLabel (widgetConfigFrame, "Member Name:", textTemplate)
					memberName:SetPoint ("left", memberNameText, "right", 2, 0)
					memberNameText:SetPoint (0, -20 + menuYOffset)

				--texture
					local on_commitTextureFile = function()
						f.CurrentWidget.file = widgetConfigFrame.TexturePath.text
						f.CurrentWidget.textureObject:SetTexture (f.CurrentWidget.file)
					end
					local texturePath = FW:CreateTextEntry (widgetConfigFrame, on_commitTextureFile, 120, 20, "TexturePath", nil, nil, textEntryTemplate)
					local texturePathText = FW:CreateLabel (widgetConfigFrame, "Texture Path:", textTemplate)
					texturePath:SetPoint ("left", texturePathText, "right", 2, 0)
					texturePathText:SetPoint (0, -40 + menuYOffset)

				local options_text_template = FW:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
				local options_dropdown_template = FW:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
				local options_switch_template = FW:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
				local options_slider_template = FW:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
				local options_button_template = FW:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
				
				local ImageEditorCallback = function (width, height, color, alpha, texCoords)
					f.CurrentWidget.color = color
					f.CurrentWidget.alpha = alpha

					local coords = f.CurrentWidget.texCoords
					coords[1], coords[2], coords[3], coords[4] = texCoords[1], texCoords[2], texCoords[3], texCoords[4]
					
					f.CurrentWidget.textureObject:SetTexCoord (coords[1], coords[2], coords[3], coords[4])
					f.CurrentWidget.textureObject:SetVertexColor (unpack (color))
					f.CurrentWidget.textureObject:SetAlpha (alpha)
				end
				
				local WidgetSettings = {
					{
						--Location X
						type = "range",
						get = function() 
							if (f.CurrentWidget) then
								return f.CurrentWidget.locationX
							else
								return 0
							end
						end,
						set = function (self, fixedparam, value) 
							f.CurrentWidget.locationX = value
							--update on the preview
							f.CurrentWidget.textureObject:SetPoint ("center", value, f.CurrentWidget.locationY)
						end,
						min = -300,
						max = 300,
						step = 1,
						thumbscale = 1.7,
						name = "Location X",
						desc = "Location X",
					},
					{
						--Location X
						type = "range",
						get = function() 
							if (f.CurrentWidget) then
								return f.CurrentWidget.locationY
							else
								return 0
							end
						end,
						set = function (self, fixedparam, value) 
							f.CurrentWidget.locationY = value
							--update preview
							f.CurrentWidget.textureObject:SetPoint ("center", f.CurrentWidget.locationX, value)
						end,
						min = -300,
						max = 300,
						step = 1,
						thumbscale = 1.7,
						name = "Location Y",
						desc = "Location Y",
					},
					{
						--Size X
						type = "range",
						get = function() 
							if (f.CurrentWidget) then
								return f.CurrentWidget.width
							else
								return 0
							end
						end,
						set = function (self, fixedparam, value) 
							f.CurrentWidget.width = value
							f.CurrentWidget.textureObject:SetWidth (value)
						end,
						min = 1,
						max = 512,
						step = 1,
						thumbscale = 1.7,
						name = "Width",
						desc = "Width",
					},
					{
						--Size Y
						type = "range",
						get = function() 
							if (f.CurrentWidget) then
								return f.CurrentWidget.height
							else
								return 0
							end
						end,
						set = function (self, fixedparam, value) 
							f.CurrentWidget.height = value
							f.CurrentWidget.textureObject:SetHeight (value)
						end,
						min = 1,
						max = 512,
						step = 1,
						thumbscale = 1.7,
						name = "Height",
						desc = "Height",
					},
					{
						type = "toggle",
						get = function() 
							if (f.CurrentWidget) then
								return f.CurrentWidget.desaturated
							else
								return false
							end
						end,
						set = function (self, fixedparam, value) 
							f.CurrentWidget.desaturated = value
							f.CurrentWidget.textureObject:SetDesaturated (value)
						end,
						name = "Desaturated",
						desc = "Desaturated",
					},
					{
						type = "execute",
						func = function() 
							FW:ImageEditor (ImageEditorCallback, f.CurrentWidget.file, f.CurrentWidget.texCoords, f.CurrentWidget.color, f.CurrentWidget.width, f.CurrentWidget.height, nil, f.CurrentWidget.alpha)
						end,
						name = "Edit Crop and Color",
						desc = "Edit Image",
					},
				}
			
				FW:BuildMenu (widgetConfigFrame, WidgetSettings, 0, -60 + menuYOffset, 300, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)	
				
				--Add Animations
				local AddAnimationText = FW:CreateLabel (widgetConfigFrame, "Add Animation:", textTemplate)
				AddAnimationText:SetPoint (0, -200 + menuYOffset)
				
				local AddNewAnimation = function (self, fixedParameter, animationType)
					
					if (not f.CurrentWidget or not f.CurrentWidget.Animations) then
						return
					end
					
					local newAnimation = {
						Name = string.lower (animationType),
						Duration = 1,
						Order = 1,
						Type = animationType,
					}
					
					if (animationType == "ALPHA") then
						newAnimation ["FromAlpha"] = 0
						newAnimation ["ToAlpha"] = 1
						
						newAnimation.AnimationObject = FW:CreateAnimation (f.CurrentWidget.animationHub, animationType, #f.CurrentWidget.Animations + 1, 1, 0, 1)

					elseif (animationType == "SCALE") then
						newAnimation ["FromScaleX"] = 0
						newAnimation ["ToScaleX"] = 1
						newAnimation ["FromScaleY"] = 0
						newAnimation ["ToScaleY"] = 1
						newAnimation ["OriginPoint"] = "center"
						newAnimation ["OriginX"] = 0
						newAnimation ["OriginY"] = 0
						
						newAnimation.AnimationObject = FW:CreateAnimation (f.CurrentWidget.animationHub, animationType, #f.CurrentWidget.Animations + 1, 1, 0, 0, 1, 1)
						
					elseif (animationType == "ROTATION") then
						newAnimation ["Degrees"] = 360
						newAnimation ["OriginPoint"] = "center"
						newAnimation ["OriginX"] = 0
						newAnimation ["OriginY"] = 0
						
						newAnimation.AnimationObject = FW:CreateAnimation (f.CurrentWidget.animationHub, animationType, #f.CurrentWidget.Animations + 1, 1, 0)
						
					elseif (animationType == "TRANSLATION") then
						newAnimation ["OffsetX"] = 0
						newAnimation ["OffsetY"] = 0
						
						newAnimation.AnimationObject = FW:CreateAnimation (f.CurrentWidget.animationHub, animationType, #f.CurrentWidget.Animations + 1, 1, 0, 0)
						
					end
					
					tinsert (f.CurrentWidget.Animations, newAnimation)
					
					--update the animation list
					f:UpdateAnimationList()
					
					--update the animation preview
					f.UpdatePreview()
				end
				
				--add alpha
				local AddAlphaButton = FW:CreateButton (widgetConfigFrame, AddNewAnimation, 100, 20, "Alpha", "ALPHA", nil, nil, nil, nil, nil, options_button_template, options_text_template)
				AddAlphaButton:SetPoint (0, -220 + menuYOffset)
				--add scale
				local AddScaleButton = FW:CreateButton (widgetConfigFrame, AddNewAnimation, 100, 20, "Scale", "SCALE", nil, nil, nil, nil, nil, options_button_template, options_text_template)
				AddScaleButton:SetPoint ("left", AddAlphaButton, "right", 2, 0)
				--add rotation
				local AddRotationButton = FW:CreateButton (widgetConfigFrame, AddNewAnimation, 100, 20, "Rotation", "ROTATION", nil, nil, nil, nil, nil, options_button_template, options_text_template)
				AddRotationButton:SetPoint (0, -240 + menuYOffset)
				--add translation
				local AddTranslationButton = FW:CreateButton (widgetConfigFrame, AddNewAnimation, 100, 20, "Translation", "TRANSLATION", nil, nil, nil, nil, nil, options_button_template, options_text_template)
				AddTranslationButton:SetPoint ("left", AddRotationButton, "right", 2, 0)
				
				--Animation List
				local AnimationsText = FW:CreateLabel (widgetConfigFrame, "Animations:", textTemplate)
				AnimationsText:SetPoint (0, -270 + menuYOffset)
				
				function f.EditAnimation (self, fixedParameter, index)
					--is valid?
					if (not f.CurrentWidget or not f.CurrentWidget.Animations or not f.CurrentWidget.Animations [index]) then
						return
					end
					
					--get the animation
					local animation = f.CurrentWidget.Animations [index]
					
					--set the current editing animation for this widget
					f.CurrentWidget.CurrentAnimation = animation
					
					--create the animation frames if not created yet
					if (not f.AnimationMenusInitialized) then
						f.InitializeAnimationMenus()
					end
					
					--show the animation config frame
					f.HideAnimationConfigFrames()
					--header (name and duration)
					f.AnimationFrames ["GENERAL"]:RefreshOptions()
					f.AnimationFrames ["GENERAL"]:Show()
					--specific settings for the animation
					f.AnimationFrames [animation.Type]:RefreshOptions()
					f.AnimationFrames [animation.Type]:Show()

				end
				
				function f.MoveAnimation (self, fixedParameter, index, moveTo)
					
					--is valid?
					if (not f.CurrentWidget or not f.CurrentWidget.Animations or not f.CurrentWidget.Animations [index]) then
						return
					end
					
					--get the animation
					local animation = f.CurrentWidget.Animations [index]
					
					if (moveTo == "UP") then
						tremove (f.CurrentWidget.Animations, index)
						tinsert (f.CurrentWidget.Animations, index - 1, animation)
						
					elseif (moveTo == "DOWN") then
						tremove (f.CurrentWidget.Animations, index)
						tinsert (f.CurrentWidget.Animations, index + 1, animation)
						
					end
					
					f.UpdateAnimationList (true)
					f.UpdatePreview()
				end
				
				--create the 12 buttons to select widget animations
				local AnimationList = {}
				for i = 1, 18 do
				
					local EditAnimationButton = FW:CreateButton (widgetConfigFrame, f.EditAnimation, 100, 14, "-- x -- x --", i, nil, nil, nil, nil, nil, FW:GetTemplate ("button", "LIST_BUTTON_TEMPLATE"),  FW:GetTemplate ("font", "LIST_BUTTON_TEMPLATE"))
					local upButton = FW:CreateButton (EditAnimationButton, f.MoveAnimation, 20, 14, "", i, "UP", nil, nil, nil, false, FW:GetTemplate ("button", "LIST_BUTTON_TEMPLATE"))
					local downButton = FW:CreateButton (EditAnimationButton, f.MoveAnimation, 20, 14, "", i, "DOWN", nil, nil, nil, false, FW:GetTemplate ("button", "LIST_BUTTON_TEMPLATE"))

					if (i == 1) then
						upButton:Disable()
						upButton:SetIcon ("Interface\\BUTTONS\\JumpUpArrow", 12, 8, "overlay", {0, 1, 0, 0.65625}, {.5, .5, .5}, 0, 0, 0, false) -- textdistance, leftpadding, textheight
						downButton:SetIcon ("Interface\\BUTTONS\\JumpUpArrow", 12, 8, "overlay", {0, 1, 0.65625, 0}, {1, 1, 1}, 0, 0, 0, false) -- textdistance, leftpadding, textheight
					else
						upButton:SetIcon ("Interface\\BUTTONS\\JumpUpArrow", 12, 8, "overlay", {0, 1, 0, 0.65625}, {1, 1, 1}, 0, 0, 0, false) -- textdistance, leftpadding, textheight
						downButton:SetIcon ("Interface\\BUTTONS\\JumpUpArrow", 12, 8, "overlay", {0, 1, 0.65625, 0}, {1, 1, 1}, 0, 0, 0, false) -- textdistance, leftpadding, textheight
					end

					EditAnimationButton:SetPoint (52, -280 + (i*-15) + menuYOffset)
					downButton:SetPoint ("right", EditAnimationButton, "left", -2, 0)
					upButton:SetPoint ("right", downButton, "left", -2, 0)
					
					EditAnimationButton.DownButton = downButton
					EditAnimationButton.UpButton = upButton

					tinsert (AnimationList, EditAnimationButton)
				end
				
				
				--update the list of animations
				function f.UpdateAnimationList (NoConfigHide)
					--hide all buttons
					f.HideAnimationList()
					
					--hide the config frames
					if (not NoConfigHide) then
						f:HideAnimationConfigFrames()
					end
					
					--is valid?
					if (not f.CurrentWidget or not f.CurrentWidget.Animations) then
						return
					end
					
					--update the list
					local buttonIndex = 1
					for i = 1, #f.CurrentWidget.Animations do
						local EditAnimationButton = AnimationList [buttonIndex]
						local animation = f.CurrentWidget.Animations [i]
						if (EditAnimationButton) then
							EditAnimationButton:Show()
							EditAnimationButton.text = animation.Name
						end
						
						if (i == #f.CurrentWidget.Animations) then
							EditAnimationButton.DownButton:Disable()
							EditAnimationButton.DownButton.icon:SetVertexColor (.5, .5, .5)

						else
							EditAnimationButton.DownButton:Enable()
							EditAnimationButton.DownButton.icon:SetVertexColor (1, 1, 1)
							
						end
						
						buttonIndex = buttonIndex + 1
					end
				end
				
			--Animation Config
				
				local locX, locY, AnimationOffset = 500, -370, -50
				
				f.AnimationFrames = {}
				
				--general settings
					local AnimationGeneralConfig = CreateFrame ("frame", "$parentConfigGeneralAnimation", f)
					AnimationGeneralConfig:SetPoint ("topleft", f, "topleft", locX, locY)
					AnimationGeneralConfig:SetSize (200, 60)
					f.AnimationFrames ["GENERAL"] = AnimationGeneralConfig
					
					local GeneralAnimationSettings = {
						{
							--animation name
							type = "textentry",
							get = function() return f.CurrentWidget.CurrentAnimation.Name end,
							set = function (self, capsule, text)
								f.CurrentWidget.CurrentAnimation.Name = text
								--refresh animation list
								f.UpdateAnimationList (true)
							end,
							name = "Name",
							desc = "",
						},
							{
							--duration
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.Duration end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.Duration = value
								--
								f.UpdatePreview()
							end,
							min = 0.016,
							max = 10,
							step = 0.5,
							thumbscale = 1.7,
							name = "Duration",
							usedecimals = true,
							desc = "",
						},
					}
					
				--alpha config
					local AlphaConfig = CreateFrame ("frame", "$parentConfigAlphaAnimation", f)
					AlphaConfig:SetPoint ("topleft", f, "topleft", locX, locY + AnimationOffset)
					AlphaConfig:SetSize (200, 200)
					f.AnimationFrames ["ALPHA"] = AlphaConfig
					
					local AplhaAnimationSettings = {
						{
							--from alpha
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.FromAlpha end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.FromAlpha = value
								--
								f.UpdatePreview()
							end,
							min = 0,
							max = 1,
							step = 0.1,
							thumbscale = 1.7,
							name = "From Alpha",
							usedecimals = true,
							desc = "",
						},
						{
							--to alpha
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.ToAlpha end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.ToAlpha = value
								--
								f.UpdatePreview()
							end,
							min = 0,
							max = 1,
							step = 0.1,
							thumbscale = 1.7,
							name = "To Alpha",
							usedecimals = true,
							desc = "",
						},
					}
				
				--Scale config
					local ScaleConfig = CreateFrame ("frame", "$parentConfigScaleAnimation", f)
					ScaleConfig:SetPoint ("topleft", f, "topleft", locX, locY + AnimationOffset)
					ScaleConfig:SetSize (200, 200)
					f.AnimationFrames ["SCALE"] = ScaleConfig
					
					local OnScaleOriginChanged = function (_, _, value)
						f.CurrentWidget.CurrentAnimation.OriginPoint = value
						--
						f.UpdatePreview()
					end
					local origin_options = {
						{label = "Center", value = "center", onclick = OnScaleOriginChanged},
						{label = "Top Left", value = "topleft", onclick = OnScaleOriginChanged},
						{label = "Left", value = "left", onclick = OnScaleOriginChanged},
						{label = "Bottom Left", value = "bottomleft", onclick = OnScaleOriginChanged},
						{label = "Bottom", value = "bottom", onclick = OnScaleOriginChanged},
						{label = "Bottom Right", value = "bottomright", onclick = OnScaleOriginChanged},
						{label = "Right", value = "right", onclick = OnScaleOriginChanged},
						{label = "Top Right", value = "topright", onclick = OnScaleOriginChanged},
						{label = "Top", value = "top", onclick = OnScaleOriginChanged},
					}
					
					local ScaleAnimationSettings = {
						{
							--from scale x
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.FromScaleX end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.FromScaleX = value
								--
								f.UpdatePreview()
							end,
							min = 0,
							max = 3,
							step = 0.1,
							thumbscale = 1.7,
							name = "From Scale X",
							usedecimals = true,
							desc = "",
						},
						{
							--to scale X
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.ToScaleX end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.ToScaleX = value
								--
								f.UpdatePreview()
							end,
							min = 0,
							max = 3,
							step = 0.1,
							thumbscale = 1.7,
							name = "To Scale X",
							usedecimals = true,
							desc = "",
						},
						{
							--from scale Y
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.FromScaleY end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.FromScaleY = value
								--
								f.UpdatePreview()
							end,
							min = 0,
							max = 3,
							step = 0.1,
							thumbscale = 1.7,
							name = "From Scale Y",
							usedecimals = true,
							desc = "",
						},
						{
							--to scale Y
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.ToScaleY end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.ToScaleY = value
								--
								f.UpdatePreview()
							end,
							min = 0,
							max = 3,
							step = 0.1,
							thumbscale = 1.7,
							name = "To Scale Y",
							usedecimals = true,
							desc = "",
						},
						{
							type = "select",
							get = function() return f.CurrentWidget.CurrentAnimation.OriginPoint end,
							values = function() return origin_options end,
							name = "Origin Point",
							desc = "",
						},
						{
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.OriginX end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.OriginX = value
								--
								f.UpdatePreview()
							end,
							min = -200,
							max = 200,
							step = 1,
							thumbscale = 1.7,
							name = "Origin X",
							desc = "",
						},
						{
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.OriginY end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.OriginY = value
								--
								f.UpdatePreview()
							end,
							min = -200,
							max = 200,
							step = 1,
							thumbscale = 1.7,
							name = "Origin Y",
						},
						
					}
				
				--Rotation config
					local RotationConfig = CreateFrame ("frame", "$parentConfigRotationAnimation", f)
					RotationConfig:SetPoint ("topleft", f, "topleft", locX, locY + AnimationOffset)
					RotationConfig:SetSize (200, 200)
					f.AnimationFrames ["ROTATION"] = RotationConfig
					
					local OnRotationOriginChanged = function (_, _, value)
						f.CurrentWidget.CurrentAnimation.OriginPoint = value
						--
						f.UpdatePreview()
					end
					local rotation_origin_options = {
						{label = "Center", value = "center", onclick = OnRotationOriginChanged},
						{label = "Top Left", value = "topleft", onclick = OnRotationOriginChanged},
						{label = "Left", value = "left", onclick = OnRotationOriginChanged},
						{label = "Bottom Left", value = "bottomleft", onclick = OnRotationOriginChanged},
						{label = "Bottom", value = "bottom", onclick = OnRotationOriginChanged},
						{label = "Bottom Right", value = "bottomright", onclick = OnRotationOriginChanged},
						{label = "Right", value = "right", onclick = OnRotationOriginChanged},
						{label = "Top Right", value = "topright", onclick = OnRotationOriginChanged},
						{label = "Top", value = "top", onclick = OnRotationOriginChanged},
					}					
					
					local RotationAnimationSettings = {
						{
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.Degrees end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.Degrees = value
								--
								f.UpdatePreview()
							end,
							min = 1,
							max = 360,
							step = 1,
							thumbscale = 1.7,
							name = "Degrees",
							desc = "",
						},
						{
							type = "select",
							get = function() return f.CurrentWidget.CurrentAnimation.OriginPoint end,
							values = function() return rotation_origin_options end,
							name = "Origin Point",
							desc = "",
						},
						{
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.OriginX end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.OriginX = value
								--
								f.UpdatePreview()
							end,
							min = -200,
							max = 200,
							step = 1,
							thumbscale = 1.7,
							name = "Origin X",
							desc = "",
						},
						{
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.OriginY end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.OriginY = value
								--
								f.UpdatePreview()
							end,
							min = -200,
							max = 200,
							step = 1,
							thumbscale = 1.7,
							name = "Origin Y",
						},
					}
					
				--Translation config
					local TranslationConfig = CreateFrame ("frame", "$parentConfigTranslationAnimation", f)
					TranslationConfig:SetPoint ("topleft", f, "topleft", locX, locY + AnimationOffset)
					TranslationConfig:SetSize (200, 200)
					f.AnimationFrames ["TRANSLATION"] = TranslationConfig
					
					local TranslationAnimationSettings = {
						{
							--Location X
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.OffsetX end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.OffsetX = value
								--
								f.UpdatePreview()
							end,
							min = -200,
							max = 200,
							step = 1,
							thumbscale = 1.7,
							name = "OffSet X",
							desc = "",
						},
						{
							--Location X
							type = "range",
							get = function() return f.CurrentWidget.CurrentAnimation.OffsetY end,
							set = function (self, fixedparam, value) 
								f.CurrentWidget.CurrentAnimation.OffsetY = value
								--
								f.UpdatePreview()
							end,
							min = -200,
							max = 200,
							step = 1,
							thumbscale = 1.7,
							name = "OffSet Y",
							desc = "",
						},
					}
				
				function f.InitializeAnimationMenus()
					FW:BuildMenu (AlphaConfig, AplhaAnimationSettings, 0, -20, 300, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)	
					FW:BuildMenu (ScaleConfig, ScaleAnimationSettings, 0, -20, 300, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)	
					FW:BuildMenu (RotationConfig, RotationAnimationSettings, 0, -20, 300, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)	
					FW:BuildMenu (TranslationConfig, TranslationAnimationSettings, 0, -20, 300, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)	
					FW:BuildMenu (AnimationGeneralConfig, GeneralAnimationSettings, 0, -20, 300, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)	
					f.AnimationMenusInitialized = true
				end
				
				function f.HideAnimationConfigFrames()
					--hide the 4 frames for config each type of animation
					for _, frame in pairs (f.AnimationFrames) do
						frame:Hide()
					end
				end
				
				function f.HideAnimationList()
					--hide 12 animation buttons
					for i = 1, 12 do
						AnimationList [i]:Hide()
					end
				end
			
				
			--Preview Engine
				function f.UpdatePreview()
					--iterate among the widgets and update the animations
					local TotalTime = 0
					
					for i = 1, #f.CurrentAnimation.Widgets do
						local thisWidget = f.CurrentAnimation.Widgets [i]
						local thisWidgetTime = 0
						
						thisWidget.animationHub:Stop()
						thisWidget.animationHub:SetLooping ("Repeat")
						
						if (thisWidget.type == "texture") then
							for index, animation in ipairs (thisWidget.Animations) do
							
								animation.AnimationObject:SetOrder (index)
								animation.AnimationObject:SetDuration (animation.Duration)
								
								if (animation.Type == "ALPHA") then
									animation.AnimationObject:SetFromAlpha (animation.FromAlpha)
									animation.AnimationObject:SetToAlpha (animation.ToAlpha)
									
								elseif (animation.Type == "SCALE") then
									animation.AnimationObject:SetFromScale (animation.FromScaleX, animation.FromScaleY)
									animation.AnimationObject:SetToScale (animation.ToScaleX, animation.ToScaleY)
									animation.AnimationObject:SetOrigin (animation.OriginPoint, animation.OriginX, animation.OriginY)
								
								elseif (animation.Type == "ROTATION") then						
									animation.AnimationObject:SetDegrees (animation.Degrees)
									animation.AnimationObject:SetOrigin (animation.OriginPoint, animation.OriginX, animation.OriginY)
								
								elseif (animation.Type == "TRANSLATION") then
									animation.AnimationObject:SetOffset (animation.OffsetX, animation.OffsetY)
								
								end
								
								thisWidgetTime = thisWidgetTime + animation.Duration
							end
						end

						thisWidget.animationHub:Play()
						if (thisWidgetTime > TotalTime) then
							TotalTime = thisWidgetTime
						end
					end
					
					if (TotalTime > 0) then
						f.ProgressBar.AnimationHub:Stop()
						f.ProgressBar.AnimationHub.Animation:SetDuration (TotalTime)
						f.ProgressBar.EndTime.text = format ("%.2f", TotalTime)
						f.ProgressBar.AnimationHub:Play()
						f.ProgressBar.TotalTime = TotalTime
						f.ProgressBar:SetScript ("OnUpdate", function (self)
							self.Elapsed.text = format ("%.2f", self.AnimationHub:GetProgress() * self.TotalTime)
						end)
					else
						f.ProgressBar.AnimationHub:Stop()
						f.ProgressBar.TotalTime = 0
					end
					
				end
				
				local ProgressBar = CreateFrame ("frame", "AnimationPreviewProgressBar", f)
				ProgressBar:SetHeight (2)
				ProgressBar:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}})
				ProgressBar:SetBackdropColor (1, 1, 1, .5)
				ProgressBar.Spark = ProgressBar:CreateTexture (nil, "overlay")
				ProgressBar.Spark:SetTexture ([[Interface\CastingBar\UI-CastingBar-Spark]])
				ProgressBar.Spark:SetBlendMode ("ADD")
				ProgressBar.Spark:SetHeight (16)
				ProgressBar.Spark:SetAlpha (.8)
				ProgressBar.Spark:SetPoint ("left", ProgressBar, "left", -13, 0)
				
				local animationHub = FW:CreateAnimationHub (ProgressBar.Spark, onPlay, onFinished)
				animationHub:SetLooping ("Repeat")
				animationHub.Animation = FW:CreateAnimation (animationHub, "TRANSLATION", 1, 1, 294, 0)
				
				local initialTime = FW:CreateLabel (ProgressBar, "0", FW:GetTemplate ("font", "PROGRESSBAR_TEMPLATE"))
				initialTime:SetPoint ("topleft", ProgressBar, "bottomleft", 0, -4)
				local endTime = FW:CreateLabel (ProgressBar, "0", FW:GetTemplate ("font", "PROGRESSBAR_TEMPLATE"))
				endTime:SetPoint ("topright", ProgressBar, "bottomright", 0, -4)
				local elapsedTime = FW:CreateLabel (ProgressBar, "0", FW:GetTemplate ("font", "PROGRESSBAR_TEMPLATE"))
				elapsedTime:SetPoint ("top", ProgressBar, "bottom", 0, -4)
				
				f.ProgressBar = ProgressBar
				ProgressBar.AnimationHub = animationHub
				ProgressBar.EndTime = endTime
				ProgressBar.Elapsed = elapsedTime
				
				function f.UpdateProgressBarPoint()
					ProgressBar:SetPoint ("topleft", f.CurrentAnimation.FrameObject, "bottomleft", 0, -10)
					ProgressBar:SetPoint ("topright", f.CurrentAnimation.FrameObject, "bottomright", 0, -10)
				end
				
		end
		
		DetailsAnimationStudio:Show()
	
	
	elseif (msg == "recordtest") then	
	
		local f = DetailsRecordFrameAnimation 
		if (not f) then
			f = CreateFrame ("frame", "DetailsRecordFrameAnimation", UIParent)
			
			--estrela no inicio dando um giro
			--Interface\Cooldown\star4
			--efeito de batida?
			--Interface\Artifacts\ArtifactAnim2
			
			
			
			local DF = _detalhes.gump
			
			local animationHub = DF:CreateAnimationHub (f, function() f:Show() end)

			DF:CreateAnimation (animationHub, "Scale", 1, .10, .9, .9, 1.1, 1.1)
			DF:CreateAnimation (animationHub, "Scale", 2, .10, 1.2, 1.2, 1, 1)
			
			
		end
		
		
	
	else
		
		--if (_detalhes.opened_windows < 1) then
		--	_detalhes:CriarInstancia()
		--end
		
		print (" ")
		print (Loc ["STRING_DETAILS1"] .. "(" .. _detalhes.userversion .. ") " ..  Loc ["STRING_COMMAND_LIST"])
		
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_NEW"] .. "|r: " .. Loc ["STRING_SLASH_NEW_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_SHOW"] .. " " .. Loc ["STRING_SLASH_HIDE"] .. " " .. Loc ["STRING_SLASH_TOGGLE"] .. "|r|cfffcffb0 <" .. Loc ["STRING_WINDOW_NUMBER"] .. ">|r: " .. Loc ["STRING_SLASH_SHOWHIDETOGGLE_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_ENABLE"] .. " " .. Loc ["STRING_SLASH_DISABLE"] .. "|r: " .. Loc ["STRING_SLASH_CAPTURE_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_RESET"] .. "|r: " .. Loc ["STRING_SLASH_RESET_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_OPTIONS"] .. "|r|cfffcffb0 <" .. Loc ["STRING_WINDOW_NUMBER"] .. ">|r: " .. Loc ["STRING_SLASH_OPTIONS_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. "API" .. "|r: " .. Loc ["STRING_SLASH_API_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_CHANGES"] .. "|r: " .. Loc ["STRING_SLASH_CHANGES_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_WIPECONFIG"] .. "|r: " .. Loc ["STRING_SLASH_WIPECONFIG_DESC"])
		
		--print ("|cffffaeae/details " .. Loc ["STRING_SLASH_WORLDBOSS"] .. "|r: " .. Loc ["STRING_SLASH_WORLDBOSS_DESC"])
		print (" ")

	end
end

function _detalhes:CreateListPanel()

	local f = _detalhes.ListPanel
	if (f) then
		return f
	end

	_detalhes.ListPanel = _detalhes.gump:NewPanel (UIParent, nil, "DetailsActorsFrame", nil, 300, 600)
	_detalhes.ListPanel:SetPoint ("center", UIParent, "center", 300, 0)
	_detalhes.ListPanel.barras = {}
	
	tinsert (UISpecialFrames, "DetailsActorsFrame")
	_detalhes.ListPanel.close_with_right = true

	local container_barras_window = CreateFrame ("ScrollFrame", "Details_ActorsBarrasScroll", _detalhes.ListPanel.widget) 
	local container_barras = CreateFrame ("Frame", "Details_ActorsBarras", container_barras_window)
	_detalhes.ListPanel.container = container_barras

	_detalhes.ListPanel.width = 500
	_detalhes.ListPanel.locked = false
	
	container_barras_window:SetBackdrop({
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-gold-Border", tile = true, tileSize = 16, edgeSize = 5,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})
	container_barras_window:SetBackdropBorderColor (0, 0, 0, 0)
	
	container_barras:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})		
	container_barras:SetBackdropColor (0, 0, 0, 0)

	container_barras:SetAllPoints (container_barras_window)
	container_barras:SetWidth (500)
	container_barras:SetHeight (150)
	container_barras:EnableMouse (true)
	container_barras:SetResizable (false)
	container_barras:SetMovable (true)
	
	container_barras_window:SetWidth (460)
	container_barras_window:SetHeight (550)
	container_barras_window:SetScrollChild (container_barras)
	container_barras_window:SetPoint ("TOPLEFT", _detalhes.ListPanel.widget, "TOPLEFT", 21, -10)

	_detalhes.gump:NewScrollBar (container_barras_window, container_barras, -10, -17)
	container_barras_window.slider:Altura (560)
	container_barras_window.slider:cimaPoint (0, 1)
	container_barras_window.slider:baixoPoint (0, -3)
	container_barras_window.slider:SetFrameLevel (10)

	container_barras_window.ultimo = 0
	
	container_barras_window.gump = container_barras
	
	function _detalhes.ListPanel:add (text, index, filter)
		local row = _detalhes.ListPanel.barras [index]
		if (not row) then
			row = {text = _detalhes.ListPanel.container:CreateFontString (nil, "overlay", "GameFontNormal")}
			_detalhes.ListPanel.barras [index] = row
			row.text:SetPoint ("topleft", _detalhes.ListPanel.container, "topleft", 0, -index * 15)
		end
		
		if (filter and text:find (filter)) then
			row.text:SetTextColor (1, 1, 0)
		else
			row.text:SetTextColor (1, 1, 1)
		end
		
		row.text:SetText (text)
	end	
	
	return _detalhes.ListPanel
end

--endd elsee
