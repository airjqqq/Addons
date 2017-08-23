local GatherMate2 = LibStub("AceAddon-3.0"):GetAddon("GatherMate2",true)
if not GatherMate2 then
	print("GatherMate2 not found, exiting")
	return
end

local Sharing = {}
Sharing = GatherMate2:NewModule("Sharing","AceEvent-3.0","AceComm-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GatherMate_Sharing",false)

-- addon defaults
local defaults = {
	profile = {
		sharingChannel = "GUILD",
		enableSync = true,
		syncAdds = true,
		syncDeletes = false,
	}
}

-- local variables
local dbIndexes = {
	["Herb Gathering"] = 1,
	["Mining"] = 2,
	["Fishing"] = 3,
	["Extract Gas"] = 4,
	["Treasure"] = 5,
	["Archaeology"] = 6,
	["Logging"] = 7,
	[1] = "Herb Gathering",
	[2] = "Mining",
	[3] = "Fishing",
	[4] = "Extract Gas",
	[5] = "Treasure",
	[6] = "Archaeology",
	[7] = "Logging",
}
local db
local options
local gm2prefix = "GM2SD"
local aTemplate = "A:%i:%i:%s:%i"
local dTemplate = "D:%i:%i:%s"
local actingOnComm = false

-- localize some globals
local format = format
local strsplit = strsplit
local tonumber = tonumber
local format = string.format
-- addon functions
function Sharing:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("GatherMate_SharingDB", defaults)
	db = self.db.profile
end
function Sharing:OnEnable()
	if db.enableSync then
		self:RegisterMessage("GatherMate2NodeAdded", "Node2Added")
		self:RegisterMessage("GatherMate2NodeDeleted", "Node2Deleted")
		self:RegisterComm(gm2prefix, "OnMessage")
	else
		self:Disable()
	end
end
function Sharing:OnDisable()
	-- Ace3 unregisters all messages/comms/events for us
end

-- callback for node added for GM2
function Sharing:Node2Added(event, zone, nodeType, coord, name)
	if not db.enableSync then return end
	if db.sharingChannel == "NONE" then return end
	if db.sharingChannel == "GUILD" and not IsInGuild() then return end
	if actingOnComm then return end	
	local nodeData = format(aTemplate, zone, dbIndexes[nodeType], coord, GatherMate2.nodeIDs[nodeType][name])
	self:SendCommMessage(gm2prefix, nodeData, db.sharingChannel, nil)
end
-- callback for node deletion for GM2
function Sharing:Node2Deleted(event, zone, nodeType, coord, name)
	if not db.enableSync then return end
	if db.sharingChannel == "NONE" then return end
	if db.sharingChannel == "GUILD" and not IsInGuild() then return end
	if actingOnComm then return end
	local nodeData = format(dTemplate, zone, dbIndexes[nodeType], coord)
	self:SendCommMessage(gm2prefix, nodeData, db.sharingChannel, nil)
end

-- Callback for comm system
function Sharing:OnMessage(prefix, message, distribution, sender)
	if not db.enableSync then return end
	if prefix ~= gm2prefix then return end
	if actingOnComm then return end
	local cmd, zone, nodeType, coord, nodeID = strsplit(":", message)
	-- don't use zone+0 etc type implicit type-conversion, because it fails and errors
	-- if the received string/message isn't valid
	zone = tonumber(zone)
	nodeType = tonumber(nodeType)
	coord = tonumber(coord)
	nodeID = tonumber(nodeID)
	local x,y,nodeName, level
	if not GatherMate2.reverseNodeIDs[ dbIndexes[nodeType] ][nodeID] then
		return -- invalid nodeID
	end
	x,y,level = GatherMate2:DecodeLoc(coord)
	nodeName = GatherMate2.reverseNodeIDs[dbIndexes[nodeType]][nodeID]
	if cmd == 'A' and db.syncAdds then
		actingOnComm = true
		GatherMate2:AddNode(zone,x,y,level,dbIndexes[nodeType],nodeName)
		actingOnComm = false
	elseif cmd == 'D' and db.syncDeletes then
		actingOnComm = true
		GatherMate2:RemoveNodeByID(zone, dbIndexes[nodeType], coord)			
		actingOnComm = false
	end
end

-- options table
options = {
	name = L["Gathermate_Sharing"],
	desc = L["Gathermate_Sharing"],
	type = "group",
	order = 200,
	get = function(info) return db[info.arg] end,
	set = function(info, v) db[info.arg] = v end,
	args = {
		desc = {
			name = L["MODULE_DESC"],
			type = "description",
			order = 0,
		},
		enableSync = {
			name = L["Enable GatherMate_Sharing"],
			desc = L["Enable or disable syncing of GatherMate data with other players."],
			type = "toggle",
			arg = "enableSync",
			order = 1,
			set = function(info, v)
				db[info.arg] = v
				if v then Sharing:Enable() else Sharing:Disable() end
			end,
			disabled = false,
			width = "double",
		},
		options = {
			name = L["Gathermate_Sharing Options"],
			desc = L["Gathermate_Sharing Options"],
			type = "group",
			inline = true,
			order = 2,
			disabled = function(info) return not db.enableSync end,
			args = {
				syncAdds = {
					name = L["Sync node additions"],
					desc = L["When other players add nodes to their GatherMate, automatically add the same node to your database too."],
					type = "toggle",
					arg = "syncAdds",
					order = 1,
				},
				syncDeletes = {
					name = L["Sync node deletions"],
					desc = L["When other players delete nodes from their GatherMate, automatically delete the same node from your database too."],
					type = "toggle",
					arg = "syncDeletes",
					order = 2,
				},
				shareingChannel = {
					name = L["Sync Channel"],
					desc = L["Communication channel to send sync messages."],
					type = "select",
					arg = "sharingChannel",
					values = { 
						["GUILD"] = L["GUILD"], 
						["NONE"] = L["NONE"],
						["PARTY"] = L["PARTY"],
						["RAID"] = L["RAID"],
					},
					order = 3,
				},
			},
		},
	},
}

-- Register our options table with GatherMate's Config
local Config = GatherMate2:GetModule("Config")
Config:RegisterModule("Sharing", options)
