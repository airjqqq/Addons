
local QuestNotifier = LibStub("AceAddon-3.0"):NewAddon("QuestNotifier", "AceEvent-3.0", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("QuestNotifier")

local RScanQuests = RScanQuests
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestLink = GetQuestLink
local IsQuestWatched = IsQuestWatched
local RemoveQuestWatch = RemoveQuestWatch
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local SendChatMessage = SendChatMessage
local IsInGroup, IsInRaid, LE_PARTY_CATEGORY_HOME, LE_PARTY_CATEGORY_INSTANCE, UnitInParty, UnitInRaid = IsInGroup, IsInRaid, LE_PARTY_CATEGORY_HOME, LE_PARTY_CATEGORY_INSTANCE, UnitInParty, UnitInRaid
local find, pairs = string.find, pairs

--[[ The defaults a user without a profile will get. ]]--
local defaults = {
	profile={
		settings = {
			enable = true,
			every = 1,
			sound = false,
			detail = true,
			completex = true,
			debug = false
		},
		announceTo = {
			chatFrame = true,
			raidWarningFrame = false,
			uiErrorsFrame = false,
		},
		announceIn = {
			say = false,
			party = true,
			guild = false,
			officer = false,
			whisper = false,
			whisperWho = nil
		}
	}
}

local QHisFirst = true
local lastList
local RGBStr = {
	R = "|CFFFF0000",
	G = "|CFF00FF00",
	B = "|CFF0000FF",
	Y = "|CFFFFFF00",
	K = "|CFF00FFFF",
	D = "|C0000AAFF",
	P = "|CFFD74DE1"
}

--[[ QuestNotifier Initialize ]]--
function QuestNotifier:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("QuestNotifierDB", defaults, true)

	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileReset")
	self.db.RegisterCallback(self, "OnNewProfile", "OnNewProfile")

	self:SetupOptions()
end

function QuestNotifier:OnEnable()
	--[[ We're looking at the UI_INFO_MESSAGE for quest messages ]]--
	self:RegisterEvent("QUEST_LOG_UPDATE")

	self:SendDebugMsg("Addon Enabled :: "..tostring(QuestNotifier.db.profile.settings.enable))
end

--[[ Event handlers ]]--
function QuestNotifier:QUEST_LOG_UPDATE(self, event)
	local QA_Progress = L["Progress"]
	local QA_ItemMsg,QA_ItemColorMsg = " "," "

	if QHisFirst then
		lastList = RScanQuests()
		QHisFirst = false
	end

	local currList = RScanQuests()

	for i,v in pairs(currList) do
		local TagStr = " ";
		if currList[i].Tag and (currList[i].Group < 2) then TagStr = RGBStr.Y .. "["..currList[i].Tag.."]|r" end
		if currList[i].Tag and (currList[i].Group > 1) then TagStr = RGBStr.Y .. "["..currList[i].Tag..currList[i].Group.."]|r" end
		if currList[i].Daily == 1 and currList[i].Tag then
			TagStr = RGBStr.D .. "[" .. DAILY .. currList[i].Tag .. "]|r" ;
		elseif currList[i].Daily == 1 then
			TagStr = RGBStr.D .. "[" .. DAILY .. "]|r";
		elseif currList[i].Tag then
			TagStr = "["..currList[i].Tag .. "]";
		end

		if lastList[i] then  -- 已有任务，上次和本次Scan都有这一个任务
			if not lastList[i].Complete then
				if (#currList[i] > 0) and (#lastList[i] > 0) then
					for j=1,#currList[i] do
						if currList[i][j] and lastList[i][j] and currList[i][j].DoneNum and lastList[i][j].DoneNum then
							if currList[i][j].DoneNum > lastList[i][j].DoneNum then
							--	QA_ItemMsg = L["Quest"]..currList[i].Link..QA_Progress ..": ".. currList[i][j].NeedItem ..":".. currList[i][j].DoneNum .. "/"..currList[i][j].NeedNum
								QA_ItemMsg = QA_Progress ..":" .. currList[i][j].NeedItem ..": ".. currList[i][j].DoneNum .. "/"..currList[i][j].NeedNum
								QA_ItemColorMsg = "QA:" .. RGBStr.G..L["Quest"].."|r".. RGBStr.P .. "["..currList[i].Level.."]|r "..currList[i].Link..RGBStr.G..QA_Progress..":|r"..RGBStr.K..currList[i][j].NeedItem..":|r"..RGBStr.Y..currList[i][j].DoneNum .. "/"..currList[i][j].NeedNum .."|r"
								--[[ Show Detail message ]]--
								if QuestNotifier.db.profile.settings.detail == true then
									QuestNotifier:SendMsg(QA_ItemMsg)
								end
							end
						end
					end
				end
			end
			if (#currList[i] > 0) and (#lastList[i] > 0) and (currList[i].Complete == 1) then
				if not lastList[i].Complete then
					if (currList[i].Group > 1) and currList[i].Tag then
						QA_ItemMsg = L["Quest"].."["..currList[i].Level.."]".."["..currList[i].Tag..currList[i].Group.."]"..currList[i].Link.." "..L["Complete"]
					else
						QA_ItemMsg = L["Quest"].."["..currList[i].Level.."]"..tostring(currList[i].Link).." "..L["Complete"]
					end
					QA_ItemColorMsg = "QA:" .. RGBStr.G .. L["Quest"] .. "|r" .. RGBStr.P .. "[" .. currList[i].Level .. "]|r " .. currList[i].Link .. TagStr .. RGBStr.K .. L["Complete"] .. "|r"
					QuestNotifier:SendMsg(QA_ItemMsg)
					UIErrorsFrame:AddMessage(QA_ItemColorMsg);
				end
			end
		end

		if not lastList[i] then  -- last List have not the Quest, New Quest Accepted
			if (currList[i].Group > 1) and currList[i].Tag then
				QA_ItemMsg = L["Accept"]..":["..currList[i].Level.."]".."["..currList[i].Tag..currList[i].Group.."]"..currList[i].Link
			elseif currList[i].Daily == 1 then
				QA_ItemMsg = L["Accept"]..":["..currList[i].Level.."]".."[" .. DAILY .. "]"..currList[i].Link
			else
				QA_ItemMsg = L["Accept"]..":["..currList[i].Level.."]"..currList[i].Link
			end
			QA_ItemColorMsg = "QA:"..RGBStr.K .. L["Accept"]..":|r" .. RGBStr.P .."["..currList[i].Level.."]|r "..TagStr..currList[i].Link
			QuestNotifier:SendMsg(QA_ItemMsg)
		end
	end

	lastList = currList
end

function QuestNotifier:OnProfileChanged(event, db)
	self.db.profile = db.profile
end

function QuestNotifier:OnProfileReset(event, db)
	for k, v in pairs(defaults) do
		db.profile[k] = v
	end
	self.db.profile = db.profile
end

function QuestNotifier:OnNewProfile(event, db)
	for k, v in pairs(defaults) do
		db.profile[k] = v
	end
end

--[[ Sends a debugging message if debug is enabled and we have a message to send ]]--
function QuestNotifier:SendDebugMsg(msg)
	if(msg ~= nil and self.db.profile.settings.debug) then
		QuestNotifier:Print("QN_DEBUG :: "..msg)
	end
end

--[[ Sends a chat message to the selected chat channels and frames where applicable,
	if we have a message to send; will also send a debugging message if debug is enabled ]]--
function QuestNotifier:SendMsg(msg)
	local announceIn = self.db.profile.announceIn
	local announceTo = self.db.profile.announceTo

	QuestNotifier:SendDebugMsg("QuestNotifier:SendMsg - "..tostring(msg))

	if (msg ~= nil and self.db.profile.settings.enable) then
		if(announceTo.chatFrame) then
			if(announceIn.say) then
				SendChatMessage(msg, "SAY")
			end

			--[[ GetNumGroupMembers is group-wide; GetNumSubgroupMembers is confined to your group of 5 ]]--
			--[[ Ref: http://www.wowpedia.org/API_GetNumSubgroupMembers or http://www.wowpedia.org/API_GetNumGroupMembers ]]--
			if(announceIn.party) then
				if(IsInGroup() and GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME) > 0) then
					SendChatMessage(msg, "PARTY")
				end
			end

			if(announceIn.instance) then
				if (IsInInstance() and GetNumSubgroupMembers(LE_PARTY_CATEGORY_INSTANCE) > 0) then
					SendChatMessage(msg, "INSTANCE_CHAT")
				end
			end

			if(announceIn.guild) then
				if(IsInGuild()) then
					SendChatMessage(msg, "GUILD")
				end
			end

			if(announceIn.officer) then
				if(IsInGuild()) then
					SendChatMessage(msg, "OFFICER")
				end
			end

			if(announceIn.whisper) then
				local who = announceIn.whisperWho
				if(who ~= nil and who ~= "") then
					SendChatMessage(msg, "WHISPER", nil, who)
				end
			end
		end

		if(announceTo.raidWarningFrame) then
			RaidNotice_AddMessage(RaidWarningFrame, msg, ChatTypeInfo["RAID_WARNING"])
		end

		if(announceTo.uiErrorsFrame) then
			UIErrorsFrame:AddMessage(msg, 1.0, 1.0, 0.0, 7)
		end

		if(self.db.profile.settings.sound) then
			PlaySound("RAIDWARNING", "Master")
		end
	end

end

function RScanQuests()
	local QuestList = {}
	local qIndex = 1
	local qLink
	local splitdot = L["Colon"]           -- zh_CN 为全角" ：" ,en_US 为半角的 ":" ,zh_TW 请自行试验
	while GetQuestLogTitle(qIndex) do
		local qTitle, qLevel, qGroup, qisHeader, qisCollapsed, qisComplete, frequency, qID = GetQuestLogTitle(qIndex)
		local qTag, qTagName = GetQuestTagInfo(qID)
		if not qisHeader then
			qLink = GetQuestLink(qID)
			QuestList[qID]={
				Title    =qTitle,          -- String
				Level    =qLevel,          -- Integer
				Tag      =qTagName,        -- String
				Group    =qGroup,          -- Integer
				Header   =qisHeader,       -- boolean
				Collapsed=qisCollapsed,    -- boolean
				Complete =qisComplete,     -- Integer
				Daily    =0, --frequency,  -- Integer
				QuestID  =qID,             -- Integer
				Link     =qLink
			}
			if qisComplete == 1 and ( IsQuestWatched(qIndex) ) and QuestNotifier.db.profile.settings.completex == true then
				-- RemoveQuestWatch(qIndex)
			--	WatchFrame_Update()
				ObjectiveTracker_Update()
			end
			for i=1,GetNumQuestLeaderBoards(qIndex) do
				local leaderboardTxt, itemType, isDone = GetQuestLogLeaderBoard(i,qIndex);
			--	local j, k, itemName, numItems, numNeeded = string.find(leaderboardTxt, "(.*)"..splitdot.."%s*([%d]+)%s*/%s*([%d]+)");
				local _, _, numItems, numNeeded, itemName = find(leaderboardTxt, "(%d+)/(%d+) ?(.*)")
			--	local numstr, itemName = strsplit(" ", leaderboardTxt)
			--	local numItems, numNeeded = strsplit("/", numstr)
			--	print(qID,qTitle,qLevel,qTag,qGroup,qisHeader,qisCollapsed,qisComplete,qisDaily,leaderboardTxt,itemType,isDone,j,k,itemName,numItems,numNeeded)
				QuestList[qID][i]={
					NeedItem = itemName,      -- String
					NeedNum  = numNeeded,     -- Integer
					DoneNum  = numItems       -- Integer
				}
			end
		end

		qIndex = qIndex + 1
	end
	return QuestList
end
