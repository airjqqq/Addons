local mod = LibStub("AceAddon-3.0"):NewAddon("AirjHack", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"
AirjHack = mod

local fcn = GetPlayerFacing

local function dump(...)
	if not DevTools_Dump then
		SlashCmdList["DUMP"]("")
	end
	if DevTools_Dump then
		DevTools_Dump({...})
	end
end

function mod:OnInitialize()
  if not _G["dump"] then
    _G["dump"] = dump
  end
end

function mod:OnEnable()
  self.objectCache = {}
  self.eventTimer = self:ScheduleRepeatingTimer(function()
    self:CheckAndSendMessage()
  end,0.1)
end

function mod:OnDisable()
  self:CancelTimer(self.eventTimer)
end

function mod:HasHacked()
	if self.hacked then return true end
	local returned = fcn("AirjGetObjectGUIDByUnit","player")
	if type(returned) == "string" then
		self.hacked = true
		return true
	else
		return false
	end
end

function mod:CheckAndSendMessage()
  if not self:HasHacked() then return end
  local objects = mod:GetObjects()
  for guid, type in pairs(objects) do
    if self.objectCache[guid] then
      self.objectCache[guid] = nil
    else
      self:SendMessage("AIRJ_HACK_OBJECT_CREATED",guid,type)
    end
  end
  for guid, type in pairs(self.objectCache) do
    self:SendMessage("AIRJ_HACK_OBJECT_DESTROYED",guid,type)
  end
	wipe(self.objectCache)
  self.objectCache = objects
end

function mod:GetObjects()
  if not self:HasHacked() then return end
	local objNumber = fcn("AirjUpdateObjects")
	local toRet = {}
	for i = 0,objNumber do
		local guid, type = fcn("AirjGetObjectGUID",i)
		if guid and type then
			toRet[guid] = type
		end
	end
	return toRet, objNumber
end

function mod:GetAreaTriggerBySpellName(spellNames,objects)
  if not self:HasHacked() then return end
	objects = objects or self:GetObjects()
	local toRet = {}
	for guid,oType in pairs(objects) do
		if bit.band(oType,0x100)~=0 then
			local spellId = fcn("AirjGetObjectDataInt",guid,0x88)
			local name = GetSpellInfo(spellId)
			if not spellNames or spellNames[name] then
				toRet[guid] = {
					name = name,
					spellId = spellId,
				}
			end
		end
	end
	return toRet
end

function mod:UnitGUID (unit)
  if not self:HasHacked() then return end
  return fcn("AirjGetObjectGUIDByUnit",unit)
end

function mod:ObjectInt(guid,offset)
	return fcn("AirjGetObjectDataInt",guid,offset or 0)
end
function mod:ObjectFloat(guid,offset)
	return fcn("AirjGetObjectDataFloat",guid,offset or 0)
end

function mod:UnitHealth(guid)
  if not self:HasHacked() then return end
  return fcn("AirjGetHealth",guid)
end

function mod:Position(key)
  if not self:HasHacked() then return end
  if key == nil then return end
	local starts = {
		Player = true,
		Vehicle = true,
		Creature = true,
		GameObject = true,
		AreaTrigger = true,
	}
	local subs = {string.split("-",key)}
	if not starts[subs[1]] then
		key = self:UnitGUID(key)
		if key then
			subs = {string.split("-",key)}
			if not starts[subs[1]] then
				return
			end
		end
	end

	if key then
	  local x,y,z,f,s = fcn("AirjGetObjectPosition",key)
	  if not x then return nil end
		return -y,x,z,f,s
	end
end

function mod:TerrainClick(x,y,z)
  if not self:HasHacked() then return end
	local rx,ry = y,-x
	fcn("AirjHandleTerrainClick",rx,ry,z)
end
function mod:UnitCanAttack(s,d)
	return fcn("AirjUnitCanAttack",s,d)

end
function mod:UnitCanAssist(s,d)
	return fcn("AirjUnitCanAssist",s,d)
end
function mod:Target(guid)
  if not self:HasHacked() then return end
  return fcn("AirjTargetByGUID",guid)
end

function mod:Focus(guid)
  if not self:HasHacked() then return end
  return fcn("AirjFocusByGUID",guid)
end

function mod:Interact(guid)
  if not self:HasHacked() then return end
  return fcn("AirjInteractByGUID",guid)
end

function mod:GetCamera()
    if not self:HasHacked() then return end
    local r,f,t,x,y,z,h = fcn("AirjGetCamera")
    if not x then return nil end
  	return r,f,t,-y,x,z,h
end

function mod:SetCameraDistance(range)
    if not self:HasHacked() then return end
    return fcn("AirjSetCameraDistance",range or 50)
end

function mod:RunMacroText(text)
  if not self:HasHacked() then return end
	RunMacroText(text)
end

local debugChatFrame

function mod:GetDebugChatFrame()
	-- if debugChatFrame then return debugChatFrame end
	-- local count = 1;
	-- local chatFrame, chatTab;
	-- local name = "AirjDebug"
	--
	-- for i=1, NUM_CHAT_WINDOWS do
	-- 	local fname, _, _, _, _, _, shown = FCF_GetChatWindowInfo(i);
	-- 	chatFrame = _G["ChatFrame"..i];
	-- 	chatTab = _G["ChatFrame"..i.."Tab"];
	--
	-- 	if name == fname then
	-- 		debugChatFrame = chatFrame
	-- 		return chatFrame
	-- 	end
	--
	-- 	if ( (not shown and not chatFrame.isDocked) or (count == NUM_CHAT_WINDOWS) ) then
	-- 		if ( not name or name == "" ) then
	-- 			name = format(CHAT_NAME_TEMPLATE, i);
	-- 		end
	--
	-- 		-- initialize the frame
	-- 		FCF_SetWindowName(chatFrame, name);
	-- 		FCF_SetWindowColor(chatFrame, DEFAULT_CHATFRAME_COLOR.r, DEFAULT_CHATFRAME_COLOR.g, DEFAULT_CHATFRAME_COLOR.b);
	-- 		FCF_SetWindowAlpha(chatFrame, DEFAULT_CHATFRAME_ALPHA);
	-- 		SetChatWindowLocked(i, false);
	--
	-- 		-- clear stale messages
	-- 		chatFrame:Clear();
	--
	-- 		-- Listen to the standard messages
	-- 		ChatFrame_RemoveAllMessageGroups(chatFrame);
	-- 		ChatFrame_RemoveAllChannels(chatFrame);
	-- 		ChatFrame_ReceiveAllPrivateMessages(chatFrame);
	--
	-- 		ChatFrame_AddMessageGroup(chatFrame, "SAY");
	-- 		ChatFrame_AddMessageGroup(chatFrame, "YELL");
	-- 		ChatFrame_AddMessageGroup(chatFrame, "GUILD");
	-- 		ChatFrame_AddMessageGroup(chatFrame, "WHISPER");
	-- 		ChatFrame_AddMessageGroup(chatFrame, "BN_WHISPER");
	-- 		ChatFrame_AddMessageGroup(chatFrame, "PARTY");
	-- 		ChatFrame_AddMessageGroup(chatFrame, "PARTY_LEADER");
	-- 		ChatFrame_AddMessageGroup(chatFrame, "CHANNEL");
	--
	-- 		--Clear the edit box history.
	-- 		chatFrame.editBox:ClearHistory();
	--
	-- 		-- Show the frame and tab
	-- 		chatFrame:Show();
	-- 		chatTab:Show();
	-- 		SetChatWindowShown(i, true);
	--
	-- 		-- Dock the frame by default
	-- 		FCF_DockFrame(chatFrame, (#FCFDock_GetChatFrames(GENERAL_CHAT_DOCK)+1), true);
	-- 		-- FCF_FadeInChatFrame(FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK));
	-- 		self:Print("new?>")
	-- 		return chatFrame;
	-- 	end
	-- 	count = count + 1;
	-- end
	return DEFAULT_CHAT_FRAME
end
