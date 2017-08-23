local addonName = "EPGPAutoStandby"
local dbName = "EPGPAutoStandbyDB"

local addon = LibStub("AceAddon-3.0"):NewAddon(addonName,"AceHook-3.0", "AceEvent-3.0", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local CallbackHandler = LibStub("CallbackHandler-1.0")
if not addon.callbacks then
  addon.callbacks = CallbackHandler:New(addon)
end
local callbacks = addon.callbacks


function addon:OnInitialize()  
   self.db = LibStub("AceDB-3.0"):New(dbName)
end

function addon:SetUpOptionsPanel()
  local options = {
    name = "EPGPAutoStandby",
    type = "group",
    childGroups = "tab",
    handler = self,
    args = {
      help = {
        order = 1,
        type = "description",
        name = "Automatically add selected online guild members with the given rank to the EPGP standby list. EPGP only clears the standby list every mass EP award or raid disbanding."
      },
	clearOffline = {
	   order = 2,
	   type = "toggle",
	   width = "full",
	   name = "Immediately remove the guild member from the standby list when they are offline.",
	   get = function() return self.db.profile["clearOfflineMembers"] end,
	   set = function(info, val)
self.db.profile["clearOfflineMembers"] = val
addon:ModifyStandby()
end,
	},
	empty = {
		order = 3,
		type = "description",
		width = "full",
		name = "",
		disabled = true,
	}
   },
  }

for i=0,GuildControlGetNumRanks()-1 do

local rankName = GuildControlGetRankName(i+1)
if rankName then
options["args"]["guildRank"..i] = {
	order=1000+i,
	type= "toggle",
	name=rankName,
	get=function(info) return self.db.profile["rank"..i] end,
	set=function(info, val) 
		self.db.profile["rank"..i]=val
		addon:ClearAll()
		addon:ModifyStandby()
 	end
}
end

end


   LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options, {"epgpautostandby"})
   self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, addonName)

end

function addon:GetEligibleMembers()
	local members =  {}
	for i = 1, GetNumGuildMembers() do
    local fullName, rank, rankIndex, level, classs, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(i)
	if online then
		if self.db.profile["rank"..rankIndex] then
			table.insert(members, fullName)
		end
	end
	end
	return members
end

function addon:AddToStandby(member)
	local EPGP = LibStub("AceAddon-3.0"):GetAddon("EPGP")
	if EPGP then
	local fullName = EPGP:GetFullCharacterName(member)
	if not EPGP:GetEPGP(member) then
	-- Empty
  	elseif EPGP:IsMemberInAwardList(member) then
	-- Empty
  	else
    		EPGP:SelectMember(fullName)
  	end
	end
end

function addon:ClearAll()
local EPGP = LibStub("AceAddon-3.0"):GetAddon("EPGP")
	if EPGP then

	for i = 1, GetNumGuildMembers() do
    local fullName, rank, rankIndex, level, classs, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(i)
		fullName = EPGP:GetFullCharacterName(fullName)
		if not EPGP:GetEPGP(fullName) then
			-- Empty
  		elseif EPGP:IsMemberInAwardList(fullName) then
			EPGP:DeSelectMember(fullName)
  		end
	end
	end
end


function addon:ClearOffline()
local EPGP = LibStub("AceAddon-3.0"):GetAddon("EPGP")
	if EPGP and self.db.profile["clearOfflineMembers"] then
	for i = 1, GetNumGuildMembers() do
    local fullName, rank, rankIndex, level, classs, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(i)
	if (not online) then
		fullName = EPGP:GetFullCharacterName(fullName)
		if not EPGP:GetEPGP(fullName) then
			-- Empty
  		elseif EPGP:IsMemberInAwardList(fullName) then
			EPGP:DeSelectMember(fullName)
  		end
	end
	end
	end
end

function addon:ModifyStandby()
	if not self.isModifying then

		self.isModifying = true
		addon:ClearOffline()
	local members = addon:GetEligibleMembers()
	for _,i in ipairs(members) do
		addon:AddToStandby(i)	
	end
	self.isModifying = false
	end
end

function addon:OnEnable()
	addon:SetUpOptionsPanel(addonOption)
	self.isModifying = false
	local EPGP = LibStub("AceAddon-3.0"):GetAddon("EPGP")
	if EPGP then
		hooksecurefunc(EPGP, "GROUP_ROSTER_UPDATE", addon.ModifyStandby)
		hooksecurefunc(EPGP, "GUILD_ROSTER_UPDATE", addon.ModifyStandby)
		hooksecurefunc(EPGP, "DeSelectMember", addon.ModifyStandby)
	end
end


