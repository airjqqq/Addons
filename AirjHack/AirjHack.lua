local mod = LibStub("AceAddon-3.0"):NewAddon("AirjHack", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0","AceHook-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"
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
	self:HookScript(WorldFrame,"OnMouseDown",function(widget,button) self:WorldFrameButton(button,1) end)
	self:HookScript(WorldFrame,"OnMouseUp",function(widget,button) self:WorldFrameButton(button,0) end)
end

local buttons = {}
function mod:WorldFrameButton(button,state)
	if state == 1 then
		buttons[button] = true
	else
		buttons[button] = nil
	end
end

function mod:OnDisable()
	if self.eventTimer then
  	self:CancelTimer(self.eventTimer)
		self.eventTimer = nil
	end
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

function mod:ObjectGUID4(guid)
  if not self:HasHacked() then return end
	return fcn("AirjGetObjectGUID4",guid)
end

function mod:ObjectInt(guid,offset)
  if not self:HasHacked() then return end
	return fcn("AirjGetObjectDataInt",guid,offset or 0)
end
function mod:PlayerSpec(guid)
	return self:ObjectInt(guid,0x10D0)
end

function mod:ObjectFloat(guid,offset)
  if not self:HasHacked() then return end
	return fcn("AirjGetObjectDataFloat",guid,offset or 0)
end

function mod:UnitHealth(guid)
  if not self:HasHacked() then return end
  return fcn("AirjGetHealth",guid)
end

function mod:GetPitch()
	return fcn("AirjGetPitch")
end

function mod:Position(key)
  if not self:HasHacked() then return end
  -- if key == nil then return end
	-- local starts = {
	-- 	Player = true,
	-- 	Pet = true,
	-- 	Vehicle = true,
	-- 	Creature = true,
	-- 	GameObject = true,
	-- 	AreaTrigger = true,
	-- }
	-- local subs = {string.split("-",key)}
	-- if not starts[subs[1]] then
	-- 	key = self:UnitGUID(key)
	-- 	if key then
	-- 		subs = {string.split("-",key)}
	-- 		if not starts[subs[1]] then
	-- 			return
	-- 		end
	-- 	end
	-- end

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
	-- if buttons.LeftButton then
	-- 	CameraOrSelectOrMoveStart()
	-- 	self:ScheduleTimer(function()
	-- 		CameraOrSelectOrMoveStart()
	--   end,0.1)
	-- end
	-- if buttons.RightButton then
	-- 	TurnOrActionStart()
	-- 	self:ScheduleTimer(function()
	-- 		TurnOrActionStart()
	--   end,0.1)
	-- end
end

function mod:GreenCast(spell,unit,maxrange,minrange)
	local spellName = GetSpellInfo(spell)
	if not spellName then return end
	local guid = UnitGUID(unit)
	if not guid then return end
	local tx,ty,tz = self:Position(guid)
	local x,y,z = AirjHack:Position(UnitGUID("player"))
	local dx,dy,dz = tx-x,ty-y,tz-z
	local d = sqrt(dx*dx+dy*dy+dz*dz)
	maxrange = maxrange or select(6,GetSpellInfo(spell)) or 35
	local r = maxrange
	if d>maxrange-0.5 then
		x,y,z=x+dx*maxrange/d,y+dy*maxrange/d,z+dz*maxrange/d
	elseif minrange and d>minrange+0.5 then
		x,y,z=x+dx*minrange/d,y+dy*minrange/d,z+dz*minrange/d
	else
		x,y,z = tx,ty,tz
	end
	self:RunMacroText("/cast "..spellName)
	AirjHack:TerrainClick(x,y,z)
	self:RunMacroText("/cancelspelltarget")
end
function mod:SetFacing(angle)
  if not self:HasHacked() then return end
	return fcn("AirjSetFacing",angle)
end
function mod:UnitCanAttack(s,d)
  if not self:HasHacked() then return end
	return fcn("AirjUnitCanAttack",s,d)
end
function mod:UnitCanAssist(s,d)
  if not self:HasHacked() then return end
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

local interacted = {}
function mod:Interact(guid)
  if not self:HasHacked() then return end
	local t = GetTime()
	if not interacted[guid] or t-interacted[guid]>0.4 then
		interacted[guid] = t
  	return fcn("AirjInteractByGUID",guid)
	end
end
---/run AirjHack:InteractUID(94194)
function mod:InteractUID(uid)
  if not self:HasHacked() then return end
	local guids = self:GetObjects()
	local targetguid=UnitGUID("target")
	local playerGUID = UnitGUID("player")
	for guid,t in pairs(guids) do
		local ot,_,_,_,oid = self:GetGUIDInfo(guid)
		if ot == "Creature" or ot == "GameObject" then
		-- print(oid)
			local interact
			if not uid and not self:UnitCanAttack(playerGUID,guid) then
				local x1,y1,z1,_,distance = AirjCache:GetPosition(guid)
				if distance and distance <= 20 then
					interact = true
				end
			end
			if uid and uid[oid] then
				interact = true
			end
			if interact then
				self:Interact(guid)
				local tg = UnitGUID("target")
				if targetguid ~= tg then
					self:RunMacroText("/targetlasttarget")
				elseif not targetguid then
					self:RunMacroText("/cleartarget")
				end
			end
		end
	end
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
	return RunMacroText(text)
end

local debugChatFrame

function mod:GetDebugChatFrame()
	if debugChatFrame then return debugChatFrame end
	for i=1, NUM_CHAT_WINDOWS do
		local fname, _, _, _, _, _, shown = FCF_GetChatWindowInfo(i);
		if "AirjDebug" == fname then
			debugChatFrame = chatFrame
			return chatFrame
		end
	end

	-- local count = 1;
	-- local chatFrame, chatTab;
	-- local name = "AirjDebug"
	--
	-- chatFrame = _G["ChatFrame"..i];
	-- chatTab = _G["ChatFrame"..i.."Tab"];

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

function mod:SetRaidTarget(guid,index)
  -- if not self:HasHacked() then return end
	-- if not guid then return end
	-- index = index or 8
	-- local focusguid=UnitGUID("focus")
	-- self:Focus(guid)
	-- SetRaidTarget("focus",index)
	-- if focusguid then
	-- 	self:Focus(focusguid)
	-- else
	-- 	self:RunMacroText("/clearfocus")
	-- end
end

function mod:GetGUIDInfo(guid)
  if not guid then return end
  local guids = {string.split("-",guid)}
  local objectType,serverId,instanceId,zone,id,spawn
  objectType = guids[1]
  if objectType == "Player" then
    _,serverId,id = unpack(guids)
		-- id = tonumber(id)
  elseif objectType == "Creature" or objectType == "GameObject" or objectType == "AreaTrigger" then
    objectType,_,serverId,instanceId,zone,id,spawn = unpack(guids)
		id = tonumber(id)
  end
  return objectType,serverId,instanceId,zone,id,spawn
end

function mod:Attack(unit)
  if not self:HasHacked() then return end
	local targetguid=UnitGUID("target")
	local guid = UnitGUID(unit)
	self:RunMacroText("/target "..unit)
	self:RunMacroText("/startattack")
	self:RunMacroText("/startattack")
	if targetguid ~= guid then
		self:RunMacroText("/targetlasttarget")
	elseif not targetguid then
		self:RunMacroText("/cleartarget")
	end
	-- self:ScheduleTimer(function()
	-- end,0.01)
end

local Cache
local lastloot
function mod:Loot()
	if lastloot and GetTime() - lastloot <0.05 then return end
	Cache = Cache or AirjCache
	if not Cache then return end
	local targetguid=UnitGUID("target")
	local looted
	local ct = GetTime()
	for data in Cache.cache.died:iterator() do
		local guid = data.guid
		if data.t and (ct - data.t <15 or not data.looted) and ct - data.t >0.2 then
			local x1,y1,z1,f1,distance,s = Cache:GetPosition(guid)
			if distance and (distance <= 5 or distance - s < 2.83) then
				self:Interact(guid)
				lastloot = GetTime()
				looted = true
				if ct - data.t > 1 then
					data.looted = true
				end
				break
			end
		end
	-- 		local health, max, prediction, absorb, healAbsorb, isdead = self:UnitHealth(guid)
	-- 		if isdead then
	-- 			local x1,y1,z1,f1,distance,s = Cache:GetPosition(guid)
	-- 			if distance and (distance <= 5 or distance - s < 2.83) then
	-- 				self:Interact(guid)
	-- 				lastloot = GetTime()
	-- 				looted = true
	-- 				if ct - dt > 1 then
	-- 					data.looted = true
	-- 				end
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	end
	if looted then
		if targetguid and targetguid ~= UnitGUID("target") then
			self:RunMacroText("/targetlasttarget")
		elseif not targetguid then
			self:RunMacroText("/cleartarget")
		end
	end
end

function mod:Quest()
	Cache = Cache or AirjCache
	if not Cache then return end
	local guids = self:GetObjects()
	local targetguid=UnitGUID("target")
	for guid,t in pairs(guids) do
		local ot,_,_,_,oid = self:GetGUIDInfo(guid)
		if ot == "Creature" then
			local canattack = self:UnitCanAttack(Cache:PlayerGUID(),guid)
			if not canattack then
				local x1,y1,z1,_,distance = Cache:GetPosition(guid)
				if distance and distance <= 5 then
					self:Interact(guid)
					if targetguid ~= guid then
						self:RunMacroText("/targetlasttarget")
					elseif not targetguid then
						self:RunMacroText("/cleartarget")
					end
				end
			end
		end
	end
end
