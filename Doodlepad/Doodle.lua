--[[
Name: Doodlepad
Revision: $Rev: 74 $
Author(s): Humbedooh
Description: A doodlepad for doodling with doodles.
Optional dependencies: LibStub, Ace3
License: All Rights Reserved!
]]
-----------------------------------------------------------------------
--[[ UPVALUES ]]--
local tinsert, twipe, tremove, abs, sqrt, min, max, floor, random, pow = table.insert, table.wipe, table.remove, math.abs, math.sqrt, math.min, math.max, math.floor, math.random, math.pow

--[[ MODULES AND DB ]] --
if not Doodleboard then Doodleboard = {} end
local libmg = LibStub("LibMouseGestures-1.0");
local AceGUI = LibStub("AceGUI-3.0");
local LDB = LibStub("LibDataBroker-1.1");
local LDBIcon = LibStub("LibDBIcon-1.0");

--[[ DEFAULT VARIABLES ]]--
local Doodlepad = {messages = {}};
local myRec,overlaySelector,Storyboard_Frame = nil,nil,nil;
-- 4.1-4.2 Rise of the Zandalari, Rage of Firelands maps, last id: 44
-- 4.3 The Dragon Soul maps, last id: 60
-- 5.0 Mists of Pandaria, last id: 70
local instanceMaps = {
	{0, "Blank sheet", nil},
 	{54, "Dragon Soul (1)", [[DragonSoul\DragonSoul]]},
 	{55, "Dragon Soul (2)", [[DragonSoul\DragonSoul1_]]},
 	{56, "Dragon Soul (3)", [[DragonSoul\DragonSoul2_]]},
 	{57, "Dragon Soul (4)", [[DragonSoul\DragonSoul3_]]},
 	{58, "Dragon Soul (5)", [[DragonSoul\DragonSoul4_]]},
 	{59, "Dragon Soul (6)", [[DragonSoul\DragonSoul5_]]},
 	{60, "Dragon Soul (7)", [[DragonSoul\DragonSoul6_]]},
	{42, "Firelands (1)", [[Firelands\Firelands]]},
	{41, "Firelands (2)", [[Firelands\Firelands2_]]},
	{40, "Firelands (Volcanus)", [[Firelands\Firelands1_]]},
	{1, "Blackwing Descent (1)", [[BlackwingDescent\BlackwingDescent1_]]},
	{2, "Blackwing Descent (2)", [[BlackwingDescent\BlackwingDescent2_]]},
	{10, "The Bastion of Twilight (1)", [[TheBastionofTwilight\TheBastionofTwilight1_]]},
	{11, "The Bastion of Twilight (2)", [[TheBastionofTwilight\TheBastionofTwilight2_]]},
	{12, "The Bastion of Twilight (3)", [[TheBastionofTwilight\TheBastionofTwilight3_]]},
	{18, "Throne of the Four Winds", [[Throneofthefourwinds\Throneofthefourwinds1_]]},
	{3, "Baradin Hold", [[BaradinHold\BaradinHold1_]]},
 	{45, "End Time (1)", [[EndTime\EndTime]]},
 	{46, "End Time (2)", [[EndTime\EndTime1_]]},
 	{47, "End Time (3)", [[EndTime\EndTime2_]]},
 	{48, "End Time (4)", [[EndTime\EndTime3_]]},
 	{49, "End Time (5)", [[EndTime\EndTime4_]]},
 	{50, "End Time (6)", [[EndTime\EndTime5_]]},
 	{51, "Well of Eternity", [[WellOfEternity\WellOfEternity]]},
 	{52, "Hour of Twilight (1)", [[HourofTwilight\HourofTwilight]]},
 	{53, "Hour of Twilight (2)", [[HourofTwilight\HourofTwilight1_]]},
	{43, "Zul'Aman", [[ZulAman\ZulAman]]},
	{44, "Zul'Gurub", [[ZulGurub\ZulGurub]]},
	{27, "Blackrock Caverns (1)", [[BlackrockCaverns\BlackrockCaverns1_]]},
	{28, "Blackrock Caverns (2)", [[BlackrockCaverns\BlackrockCaverns2_]]},
	{5, "Halls Of Origination (1)", [[HallsOfOrigination\HallsOfOrigination1_]]},
	{6, "Halls Of Origination (2)", [[HallsOfOrigination\HallsOfOrigination2_]]},
	{7, "Halls Of Origination (3)", [[HallsOfOrigination\HallsOfOrigination3_]]},
	{9, "The Vortex Pinnacle (Skywall)", [[Skywall\Skywall1_]]},
	{15, "The Stone Core", [[TheStoneCore\TheStoneCore1_]]},
	{16, "Throne of Tides (1)", [[ThroneOfTides\ThroneOfTides1_]]},
	{17, "Throne of Tides (2)", [[ThroneOfTides\ThroneOfTides2_]]},
	{8, "Lost City of Tolvir", [[LostCityofTolvir\LostCityofTolvir]]},
	{4, "Grim Batol", [[GrimBatol\GrimBatol1_]]},
	{13, "The Deadmines (1)", [[TheDeadmines\TheDeadmines1_]]},
	{14, "The Deadmines (2)", [[TheDeadmines\TheDeadmines2_]]},
	{19, "Icecrown Citadel (1)", [[IcecrownCitadel\IcecrownCitadel1_]]},
	{20, "Icecrown Citadel (2)", [[IcecrownCitadel\IcecrownCitadel2_]]},
	{21, "Icecrown Citadel (3)", [[IcecrownCitadel\IcecrownCitadel3_]]},
	{22, "Icecrown Citadel (4)", [[IcecrownCitadel\IcecrownCitadel4_]]},
	{23, "Icecrown Citadel (5)", [[IcecrownCitadel\IcecrownCitadel5_]]},
	{24, "Icecrown Citadel (6)", [[IcecrownCitadel\IcecrownCitadel6_]]},
	{25, "Icecrown Citadel (7)", [[IcecrownCitadel\IcecrownCitadel7_]]},
	{26, "Icecrown Citadel (8)", [[IcecrownCitadel\IcecrownCitadel8_]]},
	{29, "Battle for Gilneas", [[GilneasBattleground2\GilneasBattleground2]]},
	{39, "Twin Peaks", [[TwinPeaks\TwinPeaks]]},
	{30, "Dalaran", [[Dalaran\Dalaran1_]]},
	{31, "Darnassus", [[Darnassus\Darnassus]]},
	{32, "Gilneas City", [[GilneasCity\GilneasCity]]},
	{33, "Ironforge", [[Ironforge\Ironforge]]},
	{34, "Orgrimmar", [[Ogrimmar\Ogrimmar]]},
	{35, "Stormwind City", [[StormwindCity\StormwindCity]]},
	{36, "Thunder Bluff", [[ThunderBluff\ThunderBluff]]},
	{37, "Undercity", [[Undercity\Undercity]]},
	{38, "Silvermoon City", [[SilvermoonCity\SilvermoonCity]]},

-- Mists of Pandaria instances
	{61, "Mogu'Shan Palace", [[MogushanPalace\MogushanPalace1_]]},
	{62, "Temple of the Jade Serpent (1)", [[EastTemple\EastTemple1_]]},
	{63, "Temple of the Jade Serpent (2)", [[EastTemple\EastTemple2_]]},
	{64, "Stormstout Brewery (1)", [[StormstoutBrewery\StormstoutBrewery1_]]},
	{65, "Stormstout Brewery (2)", [[StormstoutBrewery\StormstoutBrewery2_]]},
	{66, "Stormstout Brewery (3)", [[StormstoutBrewery\StormstoutBrewery3_]]},
	{67, "Stormstout Brewery (4)", [[StormstoutBrewery\StormstoutBrewery4_]]},
	{68, "Shado-pan Monastery (1)", [[ShadowpanHideout\ShadowpanHideout1_]]},
	{69, "Shado-pan Monastery (2)", [[ShadowpanHideout\ShadowpanHideout2_]]},
	{70, "Shado-pan Monastery (3)", [[ShadowpanHideout\ShadowpanHideout3_]]},

	{71, "Mogu'Shan Vaults (1)", [[MogushanVaults\MogushanVaults1_]]},
	{72, "Mogu'Shan Vaults (2)", [[MogushanVaults\MogushanVaults2_]]},
	{73, "Mogu'Shan Vaults (3)", [[MogushanVaults\MogushanVaults3_]]},

	{74, "Heart of Fear (1)", [[HeartOfFear\HeartOfFear1_]]},
	{75, "Heart of Fear (2)", [[HeartOfFear\HeartOfFear2_]]},

	{76, "Terrace of Endless Spring", [[TerraceOfEndlessSpring\TerraceOfEndlessSpring]]},

	{77, "Siege of Orgrimmar (1)", [[OrgrimmarRaid\OrgrimmarRaid1_]]},
	{78, "Siege of Orgrimmar (2)", [[OrgrimmarRaid\OrgrimmarRaid2_]]},
	{79, "Siege of Orgrimmar (3)", [[OrgrimmarRaid\OrgrimmarRaid3_]]},
	{80, "Siege of Orgrimmar (4)", [[OrgrimmarRaid\OrgrimmarRaid4_]]},
	{81, "Siege of Orgrimmar (5)", [[OrgrimmarRaid\OrgrimmarRaid5_]]},
	{82, "Siege of Orgrimmar (6)", [[OrgrimmarRaid\OrgrimmarRaid6_]]},
	{83, "Siege of Orgrimmar (7)", [[OrgrimmarRaid\OrgrimmarRaid7_]]},
	{84, "Siege of Orgrimmar (8)", [[OrgrimmarRaid\OrgrimmarRaid8_]]},
	{85, "Siege of Orgrimmar (9)", [[OrgrimmarRaid\OrgrimmarRaid9_]]},
	{86, "Siege of Orgrimmar (10)", [[OrgrimmarRaid\OrgrimmarRaid10_]]},
	{87, "Siege of Orgrimmar (11)", [[OrgrimmarRaid\OrgrimmarRaid11_]]},
	{88, "Siege of Orgrimmar (12)", [[OrgrimmarRaid\OrgrimmarRaid12_]]},
	{89, "Siege of Orgrimmar (13)", [[OrgrimmarRaid\OrgrimmarRaid13_]]},
	{90, "Siege of Orgrimmar (14)", [[OrgrimmarRaid\OrgrimmarRaid14_]]},

	{91, "Throne of Thunder (1)", [[ThunderKingRaid\ThunderKingRaid1_]]},
	{92, "Throne of Thunder (2)", [[ThunderKingRaid\ThunderKingRaid2_]]},
	{93, "Throne of Thunder (3)", [[ThunderKingRaid\ThunderKingRaid3_]]},
	{94, "Throne of Thunder (4)", [[ThunderKingRaid\ThunderKingRaid4_]]},
	{95, "Throne of Thunder (5)", [[ThunderKingRaid\ThunderKingRaid5_]]},
	{96, "Throne of Thunder (6)", [[ThunderKingRaid\ThunderKingRaid6_]]},
	{97, "Throne of Thunder (7)", [[ThunderKingRaid\ThunderKingRaid7_]]},
	{98, "Throne of Thunder (8)", [[ThunderKingRaid\ThunderKingRaid8_]]},
	}

local colors = {
	{1.000,0.000,0.000,1}, -- red
	{1.000,0.549,0.000,1}, -- orange
	{1.000,1.000,0.000,1}, -- yellow
	{0.000,0.850,0.000,1}, -- green
	{0.000,0.502,0.502,1}, -- teal
	{0.000,0.000,1.000,1}, -- blue
	{0.502,0.000,0.502,1}, -- purple
	{1.000,0.412,0.706,1}, -- pink
	{0.502,0.502,0.502,1}, -- gray
	{0.000,0.000,0.000,1}, -- black
	{0.545,0.271,0.075,1}  -- brown
}
local icons = {
	[[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_1]],
	[[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_2]],
	[[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_3]],
	[[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_4]],
	[[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_5]],
	[[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_6]],
	[[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_7]],
	[[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_8]],
	[[Interface\AddOns\Doodlepad\Textures\apply]],
	[[Interface\AddOns\Doodlepad\Textures\cancel]]
};

local bases = { '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z' }; -- for rebasing
local OpenDoodles = {};
local dw,dh = 1000,1000; -- default width/height. Used for the uniform coordinate system.
local odw,odh = 480, 320; -- default width/height for rev. 45 and older.
local penWidth = 92; -- default pen size.
local myName = UnitName("player"); -- my name...or your name!
local syntax = "S2"; -- Syntax version control
local dpd_debug = false;


Doodlepad.consoleOptions = {
	name = "Doodlepad",
	type = 'group',
	args = {
		confdesc = {
			order = 1,
			type = "description",
			name = "Here you can set the general configuration of Doodlepad.",
			cmdHidden = true
		},
		receivingDoodles = {
			order = 1,
			name = "Receiving doodles",
			type = "group",
			inline = true,
			args = {
				raidRank = {
				order = 1,
				name  = "Receiving from raid channel",
				desc = "Here you can set who will be allowed to |cff44cc22send|r you doodles through the raid channel",
				type = 'select',
				values = {'Everyone','Raid Leader + Assisstant', 'Raid Leader'},
				get = function(info) return Doodleboard.allowReceiveRaid; end,
				set = function(info,v)
					Doodleboard.allowReceiveRaid = v or Doodleboard.allowReceiveRaid;
					end,
				},
				guildRank = {
				order = 1,
				name  = "Receiving from guild channel",
				desc = "Here you can set who will be allowed to |cff44cc22send|r you doodles through the guild channel",
				type = 'select',
				values = {'Guild Master','Rank 1','Rank 2', 'Rank 3', 'Rank 4', 'Rank 5', 'Rank 6', 'Rank 7', 'Rank 8', 'Everyone'},
				get = function(info) return Doodleboard.allowReceiveGuild; end,
				set = function(info,v)
					Doodleboard.allowReceiveGuild = v or Doodleboard.allowReceiveGuild;
					end,
				},
				partyRank = {
				order = 1,
				name  = "Receiving from party channel",
				desc = "Here you can set who will be allowed to |cff44cc22send|r you doodles through the party channel",
				type = 'select',
				values = {'Everyone', 'Party Leader'},
				get = function(info) return Doodleboard.allowReceiveParty; end,
				set = function(info,v)
					Doodleboard.allowReceiveParty = v or Doodleboard.allowReceiveParty;
					end,
				},
				whisperRank = {
				order = 1,
				name  = "Receiving private doodles",
				desc = "Here you can set who will be allowed to |cff44cc22send|r you doodles privately",
				type = 'select',
				values = {'Everyone','Friends only'},
				get = function(info) return Doodleboard.allowReceiveWhisper; end,
				set = function(info,v)
					Doodleboard.allowReceiveWhisper = v or Doodleboard.allowReceiveWhisper;
					end,
				},
			}
		},
		collabDoodles = {
			order = 2,
			name = "Doodle collaboration",
			type = "group",
			inline = true,
			args = {
				raidRank = {
				order = 1,
				name  = "Collaboration in raid channel",
				desc = "Here you can set who will be allowed to |cffcc4422edit|r doodles that others are broadcasting in the raid",
				type = 'select',
				values = {'Everyone','Raid Leader + Assisstant', 'Raid Leader', 'Original author only'},
				get = function(info) return Doodleboard.allowEditRaid; end,
				set = function(info,v)
					Doodleboard.allowEditRaid = v or Doodleboard.allowEditRaid;
					end,
				},
				guildRank = {
				order = 1,
				name  = "Receiving from guild channel",
				desc = "Here you can set who will be allowed to |cffcc4422edit|r doodles that others are broadcasting in the guild",
				type = 'select',
				values = {'Guild Master','Rank 1','Rank 2', 'Rank 3', 'Rank 4', 'Rank 5', 'Rank 6', 'Rank 7', 'Rank 8', 'Everyone', 'Original author only'},
				get = function(info) return Doodleboard.allowEditGuild; end,
				set = function(info,v)
					Doodleboard.allowEditGuild = v or Doodleboard.allowEditGuild;
					end,
				},
				partyRank = {
				order = 1,
				name  = "Receiving from party channel",
				desc = "Here you can set who will be allowed to |cffcc4422edit|r doodles that others are broadcasting in your party",
				type = 'select',
				values = {'Everyone', 'Party Leader', 'Original author only'},
				get = function(info) return Doodleboard.allowEditParty; end,
				set = function(info,v)
					Doodleboard.allowEditParty = v or Doodleboard.allowEditParty;
					end,
				},
			}
		},
		minimap = {
			order = 3,
			name = "Minimap icon",
			type = "group",
			inline = true,
			args = {
				minimap =	{
				order = 1,
				name  = "Enable minimap button",
				desc = "Show or hide the minimap button",
				type = 'toggle',
				get = function(info) return Doodleboard.enableMinimap or false; end,
				set = function(info,v)
					Doodleboard.enableMinimap = v;
					if ( Doodleboard.enableMinimap == true ) then LDBIcon:Show("Doodlepad");
					else LDBIcon:Hide("Doodlepad");
					end
				end,
				}
			}
		},
	}
}

--[[ CONFIG MENU AND DEFAULTS ]]--
LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Doodlepad", Doodlepad.consoleOptions)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Doodlepad", "Doodlepad")



--[[ GENERIC TOOLS ]]--
local function dprint(msg) print(NORMAL_FONT_COLOR_CODE .. "[Doodlepad]:|r |cffaaccff" .. msg .. "|r") end

local function rebase(number, from, to)
	local num = tonumber(number, from) or 0;
	local y,retval,rem = to - 1,"",num;
	while ( num > y ) do local x = floor(num/to); rem = num - (x*to); num = x;retval = (bases[rem+1] or 0) .. (retval or 0);end
	retval = (bases[num+1] or 0) .. ( retval or 0);
	return retval;
end

function genuid() return (rebase(floor(random(time())), 10, 32) .. rebase((random(GetTime())), 10, 32) ):sub(1,8) end

local function Doodle_Broadcast_Prepare(doodle, cdoodle)
	if ( doodle.chan and doodle.chan:len() > 1 and ((#cdoodle > 1 or (cdoodle[1] and cdoodle[1][4] ~= 0)) or (cdoodle[1] and cdoodle[1].text))) then
		if ( (doodle.chan or ""):len() < 2 or (doodle.uid or ""):len() == 0 or (doodle.chan == myName and not dpd_debug) ) then return end
		if ( doodle.chan == "WHISPER" ) then doodle.chan = doodle.sender; end
		local x = 0;
		local c = "";
		--[[ Regular doodle lines ]]--
		local Type = cdoodle[1].type;
		local layer = ("%2s"):format(rebase(cdoodle.layer or 1, 10, 32));
		if ( not Type ) then
			local color = ("%02x%02x%02x"):format(cdoodle.color[1]*255, cdoodle.color[2]*255, cdoodle.color[3]*255);
			for n = 1, #cdoodle do
				x = x + 1;
				c = c .. ("%2s%2s"):format(rebase(floor(cdoodle[n][1]), 10, 32), rebase(floor(cdoodle[n][2]), 10, 32));
				if ( x > 50 ) then
					if ( doodle.chan == "RAID" or doodle.chan == "GUILD" or doodle.chan == "PARTY" or doodle.chan == "INSTANCE_CHAT" ) then
						tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .. "D" .. 5 .. color .. c, doodle.chan});
					else
						tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .."D" .. 5 .. color .. c, "WHISPER", doodle.chan});
					end
					c = ("%2s%2s"):format(rebase(floor(cdoodle[n][1]), 10, 32), rebase(floor(cdoodle[n][2]), 10, 32));
					x = 0;
				end
			end
			if ( c:len() > 0 ) then
				if ( doodle.chan == "RAID" or doodle.chan == "GUILD" or doodle.chan == "PARTY" or doodle.chan == "INSTANCE_CHAT" ) then
					tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .."D" .. 5 .. color .. c, doodle.chan});
				else
					tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .."D" .. 5 .. color .. c, "WHISPER", doodle.chan});
				end
			end
		--[[ Text strings ]]--
		elseif ( Type == "text" ) then
			local color = ("%02x%02x%02x"):format(cdoodle.color[1]*255, cdoodle.color[2]*255, cdoodle.color[3]*255);
			local c = color .. ("%2s%2s"):format(rebase(floor(cdoodle[1].x), 10, 32), rebase(floor(cdoodle[1].y), 10, 32));
			if ( doodle.chan == "RAID" or doodle.chan == "GUILD" or doodle.chan == "PARTY" or doodle.chan == "INSTANCE_CHAT" ) then
				tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .."T" .. 5 .. c .. cdoodle[1].text, doodle.chan});
			else
				tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .."T" .. 5 .. c .. cdoodle[1].text, "WHISPER", doodle.chan});
			end
		--[[ Icons ]]--
		elseif ( Type == "icon" ) then
			local c = ("%2s%2s%2s"):format(rebase(floor(cdoodle[1].x), 10, 32), rebase(floor(cdoodle[1].y), 10, 32), rebase(cdoodle[1].icon or 1, 10, 32));
			if ( doodle.chan == "RAID" or doodle.chan == "GUILD" or doodle.chan == "PARTY" or doodle.chan == "INSTANCE_CHAT" ) then
				tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .."I" .. 5 .. c, doodle.chan});
			else
				tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .."I" .. 5 .. c, "WHISPER", doodle.chan});
			end
		--[[ Map overlays ]]--
		elseif ( Type == "map" ) then
			local c = ("%2s%04u%04u%04u%04u"):format(rebase(floor(cdoodle[1].map or 0), 10, 32), unpack(cdoodle[1].mapCoordsLarge or {0,0,4000,3000}));
			if ( doodle.chan == "RAID" or doodle.chan == "GUILD" or doodle.chan == "PARTY" or doodle.chan == "INSTANCE_CHAT" ) then
				tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .."M" .. 5 .. c, doodle.chan});
			else
				tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .."M" .. 5 .. c, "WHISPER", doodle.chan});
			end
		--[[ Polygons ]]--
		elseif ( Type == "polygon" ) then
			local color = ("%02x%02x%02x"):format(cdoodle.color[1]*255, cdoodle.color[2]*255, cdoodle.color[3]*255);
			local c = color .. ("%1s%2s%2s%2s%2s"):format(cdoodle[1].polyType, rebase(floor(cdoodle[1].x), 10, 32), rebase(floor(cdoodle[1].y), 10, 32), rebase(floor(cdoodle[1].w), 10, 32), rebase(floor(cdoodle[1].h), 10, 32));
			if ( doodle.chan == "RAID" or doodle.chan == "GUILD" or doodle.chan == "PARTY" or doodle.chan == "INSTANCE_CHAT" ) then
				tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .."P" .. 5 .. c, doodle.chan});
			else
				tinsert(Doodlepad.messages, {doodle.uid .. syntax .. layer .."P" .. 5 .. c, "WHISPER", doodle.chan});
			end
		end
	end
end

local function MapOverlay(rec, announce)
	if not rec or not rec.drawLayer then return end
	local map, canvas, x1,y1,x2,y2 = nil, rec.drawLayer, unpack(rec.mapCoords or {0,0,3.9,2.6});
	if rec.map then
		rec.map = tonumber(rec.map);
		for n=1,#instanceMaps do
			if instanceMaps[n][1] == rec.map then
				map = instanceMaps[n][3];
				break;
			end
		end
	end
	x1,y1,x2,y2 = x1 or 0,y1 or 0,x2 or 4,y2 or 3; -- default to the full 3x4 tile rectangle
	local _,_,w,h = canvas:GetRect();
	if not canvas.overlays then -- Create the texture objects needed for displaying the maps
		canvas.overlays = {};
		for a = 1, 3 do
			for b = 1, 4 do
				local n = ((a-1)*4) + b;
				canvas.overlays[n] = canvas:CreateTexture();
				local c = canvas.overlays[n];
				c:SetDrawLayer("BACKGROUND")
				if n == 1 then c:SetPoint("TOPLEFT", canvas, "TOPLEFT");
				elseif b == 1 then c:SetPoint("TOPLEFT", canvas.overlays[n-4], "BOTTOMLEFT");
				else c:SetPoint("TOPLEFT", canvas.overlays[n-1], "TOPRIGHT");
				end
			end
		end
	end
	local x, y = x2-x1, y2-y1; -- Total width and height of the map to show
	for a = 1, 3 do
		for b = 1, 4 do
			local n = ((a-1)*4) + b;
			local c = canvas.overlays[n];
			if map then
				c:SetTexture(([[Interface\WorldMap\%s%u]]):format(map, n));
				c:SetAlpha(0.8)
				-- height
				local ta,tb = max(a-1, y1), min(a, y2);
				if tb <= ta then c:SetHeight(0.001) ta, tb = 0,0
				else c:SetHeight(((tb-ta)/y)*h) ta,tb = ta-a+1, tb-a+1
				end
				-- width
				local tc,td = max(b-1, x1), min(b, x2);
				if td <= tc then c:SetWidth(0.001) tc,td = 0,0
				else c:SetWidth(((td-tc)/x)*w) tc,td = tc-b+1, td-b+1
				end
				c:SetTexCoord(tc,td,ta,tb);
			else
				canvas.overlays[n]:SetTexture(nil);
			end
		end
	end
	if announce then Doodle_Broadcast_Prepare(rec.doodle, {{type="map",map=rec.map, mapCoordsLarge={x1*1000,y1*1000,x2*1000,y2*1000}}}); end
end

local function Doodle_ParseLink(...)
	local linktype, uid = strsplit(":", (select(1, ...)))
	if linktype == "DPD" then
		for n = 1, #OpenDoodles do
			if OpenDoodles[n].uid == uid then OpenDoodles[n].frame:Show() break end
		end
	else
		Doodlepad.itemref(...)
	end
end

local function Doodle_DrawLine(rec, T, sx, sy, ex, ey, color)
	sx = sx * (rec.width/dw);
	sy = -sy * (rec.height/dh);
	ex = ex * (rec.width/dw);
	ey = -ey * (rec.height/dh);
	T:SetTexCoord(0,1,0,1);
	local C = rec.drawLayer;
    local w = penWidth;
    local dx,dy = ex - sx, ey - sy;
    local cx,cy = (sx + ex) / 2, (sy + ey) / 2;
    if (dx < 0) then
        dx,dy = -dx,-dy;
    end
    local Z = (256/255) / 2;
    local l = sqrt((dx * dx) + (dy * dy));
    local s,c = -dy / l, dx / l;
    local sc = s * c;
    local Bwid, Bhgt, BLx, BLy, TLx, TLy, TRx, TRy, BRx, BRy;
    if (dy >= 0) then
        Bwid = ((l * c) - (w * s)) * Z;
        Bhgt = ((w * c) - (l * s)) * Z;
        BLx, BLy, BRy = (w / l) * sc, s * s, (l / w) * sc;
        BRx, TLx, TLy, TRx = 1 - BLy, BLy, 1 - BRy, 1 - BLx;
        TRy = BRx;
    else
        Bwid = ((l * c) + (w * s)) * Z;
        Bhgt = ((w * c) + (l * s)) * Z;
        BLx, BLy, BRx = s * s, -(l / w) * sc, 1 + (w / l) * sc;
        BRy, TLx, TLy, TRy = BLx, 1 - BRx, 1 - BLx, 1 - BLy;
        TRx = TLy;
    end
    T:SetDrawLayer("BORDER", 0)
	T:ClearAllPoints();
	if not (Bwid-1<Bwid) or not (Bhgt-1<Bhgt) then return; end -- discard bad data (IND or INF)
    T:SetVertexColor(color[1],color[2],color[3],color[4]);
    T:SetTexCoord(TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy);
    T:SetPoint("TOPLEFT",   C, "TOPLEFT", cx - Bwid, cy + Bhgt);
    T:SetSize(Bwid*2,Bhgt*2);
    T:Show()
end

local function channelColor(chan)
	local c = ChatTypeInfo[chan:upper():gsub("[^A-Z_]", "")]
	if c then return ("|cff%02x%02x%02x%s|r"):format(c.r*255,c.g*255, c.b*255, chan:gsub("_"," ")) else return "" end
end


--[[ PERMISSION CHECKS ]]--
local function Doodlepad_AllowReceive(channel, sender)
	if channel == "WHISPER" then
		if Doodleboard.allowReceiveWhisper == 1 then return true; -- Everyone is allowed to whisper doodles
		elseif Doodleboard.allowReceiveWhisper == 2 then -- Only friends can whisper
			local numfriends = GetNumFriends()
			if not numfriends or numfriends == 0 then return false end
			for i=1,numfriends do
				local friend = (GetFriendInfo(i))
				if friend and friend == sender then
					return true
				end
			end
		end
	elseif channel == "GUILD" then
		-- If permission is set to EVERYONE return true
		if (Doodleboard.allowReceiveGuild == 10) then
			return true
		end

		local total = GetNumGuildMembers(true)
		for i = 1, total do
			local name, rank, rankIndex = GetGuildRosterInfo(i)
			if name and name == sender then
				if rankIndex and rankIndex <= (Doodleboard.allowReceiveGuild) then
					return true
				end
				return false
			end
		end
	elseif channel == "RAID" or channel == "INSTANCE_CHAT" then
		return (Doodleboard.allowReceiveRaid == 3 and UnitIsGroupLeader(sender)) or (Doodleboard.allowReceiveRaid == 2 and UnitIsRaidOfficer(sender)) or (Doodleboard.allowReceiveRaid == 1);
	elseif channel == "PARTY" then
		return (Doodleboard.allowReceiveParty == 2 and UnitIsGroupLeader(sender)) or (Doodleboard.allowReceiveParty == 1);
	end
end

function Doodlepad_AllowEdit(channel, sender)
	if channel == "WHISPER" then return true
	elseif channel == "GUILD" then
		-- If allow edit set to everyone return immediately
		if (Doodleboard.allowEditGuild == 10) then
			return true
		end
		local total = GetNumGuildMembers(true)
		for i = 1, total do
			local name, rank, rankIndex = GetGuildRosterInfo(i)
			if name and name == sender then
				if rankIndex and rankIndex <= (Doodleboard.allowEditGuild or 9) then
					return true
				end
				return false
			end
		end
	elseif channel == "RAID" or channel == "INSTANCE_CHAT" then
		return (Doodleboard.allowEditRaid == 3 and UnitIsGroupLeader(sender)) or (Doodleboard.allowEditRaid == 2 and UnitIsRaidOfficer(sender)) or (Doodleboard.allowEditRaid == 1);
	elseif channel == "PARTY" then
		return (Doodleboard.allowEditParty == 2 and UnitIsGroupLeader(sender)) or (Doodleboard.allowEditParty == 1);
	end
end



--[[ DRAWING FUNCTIONS ]]--
local function Doodle_Draw_Point(rec, pointa, pointb, col)
	if ( not pointa.type ) then
		if pointb then
			if not pointa[3] then
				local T = tremove(rec.free) or rec.drawLayer:CreateTexture();
				T:SetTexture([[Interface\AddOns\Doodlepad\line]]);
				pointa[3] = T; tinsert(rec.texs, T);
			end
			Doodle_DrawLine(rec, pointa[3], pointb[1], pointb[2], pointa[1], pointa[2], col);
		end
	elseif ( pointa.type == "icon" ) then
		local x,y = pointa.x, pointa.y;
		x,y = x * (rec.width/dw), y * (rec.height/dh);
		local T = tremove(rec.free) or rec.drawLayer:CreateTexture();
		T:SetDrawLayer("ARTWORK");
		T:SetTexture(icons[pointa.icon] or nil);
		T:SetVertexColor(1,1,1,1);
		T:SetWidth(32);T:SetHeight(32);T:SetPoint("TOPLEFT", x-16, -y+16);
		tinsert(rec.texs, T); pointa[3] = T;
		T:Show();
	elseif ( pointa.type == "polygon" ) then
		local x,y,w,h = pointa.x, pointa.y, pointa.w, pointa.h;
		x,y,w,h = x * (rec.width/dw), y * (rec.height/dh),w * (rec.width/dw), h * (rec.height/dh);
		local T = tremove(rec.free) or rec.drawLayer:CreateTexture();
		local R,G,B = unpack(col);
		T:SetDrawLayer("BACKGROUND",7);
		if pointa.polyType == "R" then
			T:SetColorTexture(R,G,B,0.9);
		else
			T:SetTexture([[Interface\AddOns\Doodlepad\Textures\circle]]);
			T:SetVertexColor(R,G,B,0.9);
		end
		T:SetSize(w,h);
		T:SetPoint("TOPLEFT", x,-y);
		tinsert(rec.texs, T);
		pointa[3] = T;
		T:Show();
	elseif ( pointa.type == "text" ) then
		local x,y = pointa.x, pointa.y;
		x,y = x * (rec.width/dw), y * (rec.height/dh);
		local caption = rec.drawLayer:CreateFontString(nil, "OVERLAY");
		caption:SetParent(rec.drawLayer);
		caption:SetFontObject(SystemFont_Shadow_Med2);
		caption:SetTextColor(unpack(col));
		caption:SetText(pointa.text);
		caption:SetPoint("CENTER", rec.drawLayer, "TOPLEFT", x, -y);
		tinsert(rec.strings, caption);
	end
end

local function Doodle_Draw(rec, wipe, col)
	if ( wipe == true ) then
		for n = 1, #rec.texs do
			local T = tremove(rec.texs);
			T:Hide();
			T:SetTexCoord(0,1,0,1);
			tinsert(rec.free, T);
		end
		for n = 1, #rec.strings do
			local T = tremove(rec.strings);
			T:Hide();
		end
	else
		local col = rec.cdoodle.color or colors[1];
		if rec.cdoodle[1] and rec.cdoodle[1].type then
			Doodle_Draw_Point(rec, rec.cdoodle[1], nil, col);
		else
			for n = 1, #rec.cdoodle do Doodle_Draw_Point(rec, rec.cdoodle[n], rec.cdoodle[n-1], col); end
		end
	end
end

local function Doodle_Redraw(rec)
	Doodle_Draw(rec, true)
	for n = 1, #rec.doodles do
		local doodle = rec.doodles[n];
		local col = doodle.color or colors[5];
		if doodle[1] and doodle[1].type then
			Doodle_Draw_Point(rec, doodle[1], nil, col);
		else
			for x = 1, #doodle do doodle[x][3] = nil; Doodle_Draw_Point(rec, doodle[x], doodle[x-1], col); end
		end
	end
	local doodle = rec.cdoodle;
	local col = doodle.color or colors[5];
	if doodle[1] and doodle[1].type then
		Doodle_Draw_Point(rec, doodle[1], nil, col);
	else
		for x = 1, #doodle do doodle[x][3] = nil; Doodle_Draw_Point(rec, doodle[x], doodle[x-1], col); end
	end
end

local function Doodlepad_Undo(rec, author, wipe, layer)
	if wipe then
		for n = #rec.doodles, 1, -1 do
			local doodle = rec.doodles[n];
			if ( doodle and (doodle.creator == author or not doodle.creator)) then
				tremove(rec.doodles, n);
			end
		end
		local doodle = rec.doodle or {};
		if ( author == myName and doodle.chan and doodle.uid and doodle.uid:len() >= 8) then
			if ( doodle.chan == "RAID" or doodle.chan == "GUILD" or doodle.chan == "PARTY" or doodle.chan == "INSTANCE_CHAT" ) then
				tinsert(Doodlepad.messages, {doodle.uid .. syntax .."01W", doodle.chan});
			elseif ( doodle.chan:len() > 1 ) then
				tinsert(Doodlepad.messages, {doodle.uid .. syntax .."01W", "WHISPER", doodle.chan});
			end
		end
	else
		for n = #rec.doodles, 1, -1 do
			local doodle = rec.doodles[n];
			if ( doodle and (doodle.creator == author or not doodle.creator)) then
				if layer then twipe(doodle) else tremove(doodle); end
				if ( #doodle == 0 ) then
					tremove(rec.doodles, n);
				end
				local doodle = rec.doodle or {};
				local T = "01" .. (layer and "L" or "U");
				if ( author == myName and doodle.chan and doodle.uid and doodle.uid:len() >= 8) then
					if ( doodle.chan == "RAID" or doodle.chan == "GUILD" or doodle.chan == "PARTY" or doodle.chan == "INSTANCE_CHAT" ) then
						tinsert(Doodlepad.messages, {doodle.uid .. syntax ..T, doodle.chan});
					elseif ( doodle.chan:len() > 1 ) then
						tinsert(Doodlepad.messages, {doodle.uid .. syntax ..T, "WHISPER", doodle.chan});
					end
				end
				break;
			end
		end
	end
	Doodle_Redraw(rec);
end

local function Doodle_Update(rec,a,b,c,d)
	if not IsControlKeyDown() then
		if ( #rec.cdoodle > 0 ) then
			local l = rec.cdoodle[#rec.cdoodle];
			if ( floor(l[1]) ~= floor(c) or floor(l[2]) ~= floor(d) ) then
				local dist = sqrt( pow(l[1] - c, 2) + pow(l[2] - d, 2));
				if ( dist >= 3 and (rec.x ~= c or rec.y ~= d)) then -- Any lines shorter than 3 pixels get discarded.
					rec.x, rec.y = c,d;
					tinsert(rec.cdoodle, {c*(dw/rec.width),d*(dh/rec.height),nil});
				end
			end
		else
			tinsert(rec.cdoodle, {c*(dw/rec.width),d*(dh/rec.height),nil});
			rec.x, rec.y = c,d;
		end
		Doodle_Draw(rec, nil, rec.cdoodle.color);
	end
end

local function Doodle_Start(rec,a,b,c,d)
	rec.cdoodle.color = rec.color;
	local now = GetTime();
	if ( rec.lastClick and (now - rec.lastClick) < 0.25) then -- double click for placing text
		rec.editbox:ClearAllPoints();
		rec.editbox:SetPoint("CENTER", rec.drawLayer, "TOPLEFT", c, -d);
		rec.editbox:SetWidth(96);
		rec.editbox:SetHeight(16);
		rec.editbox:SetText("");
		rec.editbox.x,rec.editbox.y = c,d;
		rec.editbox:SetJustifyH("CENTER");
		rec.editbox:SetTextInsets(0, 0, 3, 3);
		rec.editbox:Show();
		rec.editbox:Raise();
	end
	rec.lastClick = now;
end

local function Doodle_Stop(rec,a,b,c,d)
	if IsControlKeyDown() then -- Insert raid target icon if control key is down
		rec.cdoodle[1] = {type="icon", x=c*(dw/rec.width),y=d*(dh/rec.height), icon=rec.icon or 1};
		Doodle_Draw(rec);
	end
	rec.cdoodle.creator = myName;
	if rec.cdoodle[1].type or (#rec.cdoodle > 1) then
		tinsert(rec.doodles, rec.cdoodle);
		Doodle_Broadcast_Prepare(rec.doodle, rec.cdoodle);
	end
	rec:StartCapture(Doodlepad.defaultScript);
	rec.cdoodle = {creator=myName};
end

local function Doodle_Cancel(rec)
	if IsShiftKeyDown() then -- wipe the canvas if shift is down.
		Doodlepad_Undo(rec, myName, true);
	elseif IsControlKeyDown() then
		Doodlepad_Undo(rec, myName, false, true); -- wipe the last layer only (eventually)
	else
		Doodlepad_Undo(rec, myName);
	end
	rec.cdoodle = {creator=myName};
	rec:StartCapture(Doodlepad.defaultScript);
end


--[[ DATA HANDLING ]]--
local function Doodle_Broadcast()
	if ( #Doodlepad.messages > 0 ) then
		local now = GetTime();
		Doodlepad.last = Doodlepad.last or now;
		if ( now - Doodlepad.last >= 0.6 ) then
			Doodlepad.last = now;
			local msg, chan, target = unpack(tremove(Doodlepad.messages, 1));
			SendAddonMessage("DPD2", msg, chan, target);
			if dpd_debug then print(msg) end
		end
	end
end

local function Doodlepad_Incoming(prefix, msg, chan, sender)

	-- dprint(string.format("Incoming from - %s : %s : %s", prefix, chan, sender));
	-- dprint(string.format("%s %s %s %s", prefix, msg, chan, sender));

	if dpd_debug then sender = "Moomintroll" end
	if (sender == myName or prefix ~= "DPD2" ) then return end

	local uid, syn, lay, typ, scale, data = msg:sub(1,8), msg:sub(9,10), msg:sub(11,12), msg:sub(13,13), msg:sub(14,14), msg:sub(15);
	if dpd_debug then uid = "12345678" end
	if syn ~= syntax then return end
	local found = false;
	local doodle = nil;
	for n = 1, #OpenDoodles do
		if ( OpenDoodles[n].uid == uid ) then
			found = true;
			doodle = OpenDoodles[n];
			break;
		end
	end

	if not found then
		if ( Doodlepad_AllowReceive(chan, sender) ) then
			local frame, recorder = Doodlepad_window(chan, uid,true,sender);
			frame.caption:SetText("Doodlepad - Broadcast by " .. sender);
			doodle = { frame = frame, recorder = recorder, uid = uid, sender = sender, painters={sender}};
			tinsert(OpenDoodles, doodle );
			doodle.painters = {sender};
			doodle.chan = chan;
			dprint(string.format("%s is broadcasting a doodle. |HDPD:%s|h|cFFFFFF00[Click here]|r|h to view it",sender, uid));
		end
	end

	if ( doodle ) then
		if sender == doodle.sender or Doodlepad_AllowEdit(chan, sender) then
			local found = false;
			for i = 1, #doodle.painters do
				if ( doodle.painters[i] == sender ) then found = true; break; end
			end
			if ( not found ) then
				dprint( ("%s has joined %s's doodle session"):format(sender, doodle.sender));
				tinsert(doodle.painters, sender);
			end
			local rec = doodle.recorder;
			if ( #rec.cdoodle > 0 ) then
				tinsert(rec.doodles, rec.cdoodle);
				rec.cdoodle = {creator=sender, layer=lay};
			else rec.cdoodle.layer = lay;
			end
			if ( typ == "D" ) then -- drawings
				local color, data = data:sub(1,6), data:sub(7);
				local Color = {}; string.gsub(color, "([0-9a-fA-F][0-9a-fA-F])", function (x) tinsert(Color, tonumber(x, 16) / 255); end);
				rec.cdoodle.creator = sender;
				rec.cdoodle.color = Color;
				for n = 1, floor(data:len()/4) do
					local p = ((n-1)*4)+1;
					local x, y = rebase(data:sub(p, p+1), 32, 10), rebase(data:sub(p+2, p+3), 32, 10);
					tinsert(rec.cdoodle, {x,y,nil});
					Doodle_Draw(rec, false, Color);
				end
				tinsert(rec.doodles, rec.cdoodle);
				rec.cdoodle = {creator=sender};
			elseif ( typ == "U" ) then Doodlepad_Undo(rec, sender); -- Undo single step
			elseif ( typ == "L" ) then Doodlepad_Undo(rec, sender, false, true); -- Undo layer
			elseif ( typ == "W" ) then Doodlepad_Undo(rec, sender, true); -- Undo all (wipe)
			elseif ( typ == "T" ) then -- text
				local color, data = data:sub(1,6), data:sub(7);
				local Color = {}; string.gsub(color, "([0-9a-fA-F][0-9a-fA-F])", function (x) tinsert(Color, tonumber(x, 16) / 255); end);
				rec.cdoodle.creator = sender;
				rec.cdoodle.color = Color;
				local x, y, t = rebase(data:sub(1,2), 32, 10), rebase(data:sub(3,4), 32, 10), data:sub(5);
				tinsert(rec.cdoodle, {type="text", text=t, x=x,y=y});
				Doodle_Draw(rec);
				tinsert(rec.doodles, rec.cdoodle);
				rec.cdoodle = {creator=sender};
			elseif ( typ == "M" ) then -- Map overlay
				local m,a,b,c,d = rebase(data:sub(1,2), 32, 10), tonumber(data:sub(3,6)) or 0,tonumber(data:sub(7,10)) or 0,tonumber(data:sub(11,14)) or 3900,tonumber(data:sub(15,18)) or 2600;
				a,b,c,d = a/1000,b/1000,c/1000,d/1000;
				rec.map = m or 0;
				rec.mapCoords = {a,b,c,d};
				MapOverlay(rec);
			elseif ( typ == "P" ) then -- Polygon
				local color, data = data:sub(1,6), data:sub(7);
				local Color = {}; string.gsub(color, "([0-9a-fA-F][0-9a-fA-F])", function (x) tinsert(Color, tonumber(x, 16) / 255); end);
				local p, x, y, w, h = data:sub(1,1), rebase(data:sub(2,3), 32, 10), rebase(data:sub(4,5), 32, 10), rebase(data:sub(6,7), 32, 10),rebase(data:sub(8,9), 32, 10);
				rec.cdoodle.color = Color;
				tinsert(rec.cdoodle, {type="polygon", polyType=p, x=x,y=y,w=w,h=h});
				Doodle_Draw(rec);
				tinsert(rec.doodles, rec.cdoodle);
				rec.cdoodle = {creator=sender};
			elseif ( typ == "I" ) then -- Icon
				local x, y, i = rebase(data:sub(1,2), 32, 10), rebase(data:sub(3,4), 32, 10), tonumber(data:sub(5,6), 32);
				tinsert(rec.cdoodle, {type="icon",x=x,y=y,icon=i});
				Doodle_Draw(rec);
				tinsert(rec.doodles, rec.cdoodle);
				rec.cdoodle = {creator=sender};
			elseif not rec.unknown then -- some other unknown command was sent (from a newer version?)
				rec.unknown = true; -- boolean to stop doodlepad from spamming
				dprint("An unknown doodle command was received. You may need to update your copy of Doodlepad to view the entire doodle being broadcast.");
			end
		end
	end
end

local function Storyboard_Save(doodle)
	local canvas;
	for n = 1, #Doodleboard do
		if ( Doodleboard[n].uid == doodle.uid ) then
			Doodleboard[n].doodles = {};
			canvas = Doodleboard[n].doodles;
			Doodleboard[n].map = doodle.recorder.map;
			Doodleboard[n].mapCoords = doodle.recorder.mapCoords;
			break;
		end
	end
	if ( not canvas ) then
		Doodleboard[#Doodleboard+1] = {uid=doodle.uid, creator = doodle.sender, doodles = {}, map = doodle.recorder.map, mapCoords = doodle.recorder.mapCoords};
		canvas = Doodleboard[#Doodleboard].doodles;
	end
	for n = 1, #doodle.recorder.doodles do
		local doodle = doodle.recorder.doodles[n];
		local t = doodle[1].type;
		if not t then
			if not doodle.color then doodle.color = {0.96,0.82,0.2,1} end
			local c = ("L%02x%02x%02x"):format(doodle.color[1]*255, doodle.color[2]*255, doodle.color[3]*255);
			for i = 1, #doodle do
				c = c .. ("%02s%02s"):format(rebase(floor(doodle[i][1] or 0), 10, 32), rebase(floor(doodle[i][2] or 0), 10, 32));
			end
			tinsert(canvas, c);
		elseif ( t == "text" ) then
			if not doodle.color then doodle.color = {0,0,0} end
			local c = ("S%02x%02x%02x"):format(doodle.color[1]*255, doodle.color[2]*255, doodle.color[3]*255);
			c = c .. ("%2s%2s%s"):format(rebase(floor(doodle[1].x or 0), 10, 32), rebase(floor(doodle[1].y or 0), 10, 32), doodle[1].text or "");
			tinsert(canvas, c);
		elseif ( t == "polygon" ) then
			if not doodle.color then doodle.color = {0,0,0} end
			local c = ("P%02x%02x%02x"):format(doodle.color[1]*255, doodle.color[2]*255, doodle.color[3]*255);
			c = c .. ("%1s%2s%2s%2s%2s"):format(doodle[1].polyType or "R", rebase(floor(doodle[1].x or 0), 10, 32), rebase(floor(doodle[1].y or 0), 10, 32), rebase(floor(doodle[1].w or 0), 10, 32), rebase(floor(doodle[1].h or 0), 10, 32));
			tinsert(canvas, c);
		elseif ( t == "icon" ) then
			c = ("I%2s%2s%2s"):format(rebase(floor(doodle[1].x or 0), 10, 32), rebase(floor(doodle[1].y or 0), 10, 32), rebase(doodle[1].icon or 0, 10, 32));
			tinsert(canvas, c);
		end
	end
end

local function Storyboard_Load(uid)
	local doodle;
	local retdoodle = {};
	for n = 1, #Doodleboard do
		if ( Doodleboard[n].uid == uid ) then
			doodle = Doodleboard[n];
			break;
		end
	end
	if (doodle) then
		if doodle.uid:len() ~= 8 then doodle.uid = genuid(); end
		retdoodle.uid = doodle.uid;
		retdoodle.creator = myName;
		retdoodle.doodles = {};
		retdoodle.cdoodle = {creator=myName};
		retdoodle.map = doodle.map;
		retdoodle.mapCoords = doodle.mapCoords;
		local layer = 1;
		for n = 1, #doodle.doodles do
			local d = doodle.doodles[n];
			local t = d:sub(1,1);
			local data = d:sub(2);
			layer = layer + 1;
			--[[ backwards compatibility for types D and T (now L/I and S respectively) ]]--
			if ( t == "D" ) then
				local color, data = data:sub(1,6), data:sub(7);
				local Color = {}; string.gsub(color, "([0-9a-fA-F][0-9a-fA-F])", function (x) tinsert(Color, tonumber(x, 16) / 255); end);
				local s = {creator=myName, color=Color, layer=layer};
				for n = 1, floor(data:len()/5) do
					local p = ((n-1)*5)+1;
					local x, y, z = rebase(data:sub(p, p+1), 32, 10), rebase(data:sub(p+2, p+3), 32, 10), data:sub(p+4, p+4);
					x, y = x/odw*dw, y/odh*dh;
					if tonumber(z) ~= 0 then
						tinsert(retdoodle.doodles, {{type="icon", icon=z, x=x,y=y},creator=myName,layer=layer});
					else
						tinsert(s, {x,y,nil});
					end
				end
				tinsert(retdoodle.doodles, s);
			elseif ( t == "L" ) then
				local color, data = data:sub(1,6), data:sub(7);
				local Color = {}; string.gsub(color, "([0-9a-fA-F][0-9a-fA-F])", function (x) tinsert(Color, tonumber(x, 16) / 255); end);
				local s = {creator=myName, color=Color, layer=layer};
				for n = 1, floor(data:len()/4) do
					local p = ((n-1)*4)+1;
					local x, y = rebase(data:sub(p, p+1), 32, 10), rebase(data:sub(p+2, p+3), 32, 10);
					tinsert(s, {x,y,nil});
				end
				tinsert(retdoodle.doodles, s);
			elseif (t == "T" ) then
				local x, y, t = rebase(data:sub(1,2), 32, 10), rebase(data:sub(3,4), 32, 10), data:sub(5);
				x, y = x/odw*dw, y/odh*dh;
				tinsert(retdoodle.doodles, {color={0.96,0.82,0.2},{type="text",x=x,y=y,text=t}, layer=layer});
			elseif (t == "I" ) then
				local x, y, i = rebase(data:sub(1,2), 32, 10), rebase(data:sub(3,4), 32, 10), tonumber(rebase(data:sub(5,6), 32, 10));
				tinsert(retdoodle.doodles, {{type="icon",x=x,y=y,icon=i},layer=layer});
			elseif (t == "P" ) then
				local color, data = data:sub(1,6), data:sub(7);
				local Color = {}; string.gsub(color, "([0-9a-fA-F][0-9a-fA-F])", function (x) tinsert(Color, tonumber(x, 16) / 255); end);
				local polyType, x, y, w, h = data:sub(1,1), rebase(data:sub(2,3), 32, 10), rebase(data:sub(4,5), 32, 10), rebase(data:sub(6,7), 32, 10), rebase(data:sub(8,9), 32, 10);
				tinsert(retdoodle.doodles, {color=Color,{type="polygon",polyType=polyType,x=x,y=y,w=w,h=h,color=Color},layer=layer});
			elseif (t == "S" ) then
				local color, data = data:sub(1,6), data:sub(7);
				local Color = {}; string.gsub(color, "([0-9a-fA-F][0-9a-fA-F])", function (x) tinsert(Color, tonumber(x, 16) / 255); end);
				local x, y, t = rebase(data:sub(1,2), 32, 10), rebase(data:sub(3,4), 32, 10), data:sub(5);
				tinsert(retdoodle.doodles, {color=Color,{type="text",x=x,y=y,text=t},layer=layer});
			end
		end
	end
	retdoodle.layer = layer;
	return retdoodle;
end

local function Storyboard_Scroll(value)
	Storyboard_Frame.X = (Storyboard_Frame.X or 1) - value;
	if ( (Storyboard_Frame.X+2) > #Doodleboard ) then Storyboard_Frame.X = #Doodleboard - 2; end
	if ( Storyboard_Frame.X < 1 ) then Storyboard_Frame.X = 1; end
	local i = 0;
	for n = Storyboard_Frame.X, Storyboard_Frame.X+2 do
		i = i + 1;
		if ( Doodleboard[n] ) then
			Doodleboard[n].title = Doodleboard[n].title or "Unnamed Doodle";
			local doodle = Storyboard_Load(Doodleboard[n].uid);
			Storyboard_Frame.doodles[i].doodles = doodle.doodles;
			Storyboard_Frame.doodles[i].uid = doodle.uid;
			Storyboard_Frame.doodles[i].map = doodle.map;
			Storyboard_Frame.doodles[i].mapCoords = doodle.mapCoords;
			Storyboard_Frame.doodles[i].creator = doodle.creator;
			Storyboard_Frame.doodles[i].caption:SetText(Doodleboard[n].title);
			Storyboard_Frame.doodles[i].pointer = Doodleboard[n];
			Doodle_Redraw(Storyboard_Frame.doodles[i]);
			MapOverlay(Storyboard_Frame.doodles[i]);
			Storyboard_Frame.doodles[i].drawLayer:SetScript("OnEnter", function(caller)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(caller, "ANCHOR_BOTTOM");
			GameTooltip:SetText(Doodleboard[n].title);
			GameTooltip:AddLine("Created by " .. (doodle.creator or "??"));
			GameTooltip:Show();
			end);
			Storyboard_Frame.doodles[i].drawLayer:SetScript("OnLeave", function() GameTooltip:Hide() end);
		else
			Storyboard_Frame.doodles[i].doodles = {};
			Storyboard_Frame.doodles[i].uid = nil;
			Storyboard_Frame.doodles[i].map = nil;
			Storyboard_Frame.doodles[i].creator = myName;
			Storyboard_Frame.doodles[i].caption:SetText("");
			Storyboard_Frame.doodles[i].drawLayer:SetScript("OnEnter",nil);
			Storyboard_Frame.doodles[i].drawLayer:SetScript("OnLeave",nil);
			Doodle_Redraw(Storyboard_Frame.doodles[i]);
			Doodle_Redraw(Storyboard_Frame.doodles[i]);
		end
	end
end

local function Storyboard_Delete(uid)
	for n = 1, #Doodleboard do
		if ( Doodleboard[n].uid == uid ) then
			tremove(Doodleboard, n)
			break
		end
	end
	Storyboard_Scroll(0)
end



--[[ UI FUNCTIONS ]]--
local drawIcon = {
	startButton		= "LeftButtonDown",
	stopButton		= "LeftButtonUp",
	cancelButton    = "RightButtonUp",
	stopFunc 		= function(rec,a,b,c,d)
		rec.cdoodle[1] = {type="icon", x=c*(dw/rec.width),y=d*(dh/rec.height), icon=rec.xicon or 1};
		Doodle_Draw(rec);
		rec:StartCapture(Doodlepad.defaultScript)
		rec.drawLayer.mouseLine:Hide();
		tinsert(rec.doodles, rec.cdoodle);
		Doodle_Broadcast_Prepare(rec.doodle, rec.cdoodle);
		rec.cdoodle = {creator=myName};
	end,
	cancelFunc = function(rec) rec:StartCapture(Doodlepad.defaultScript) rec.drawLayer.mouseLine:Hide();end,
	updateFunc	= function(rec,a,b,c,d)
		local C = rec.drawLayer;
		local T = C.mouseLine or C:CreateTexture()
		C.mouseLine = T;
		T:SetTexture(icons[rec.xicon]);
		T:SetVertexColor(1,1,1,1);
		T:SetDrawLayer("OVERLAY")
		T:ClearAllPoints();
		T:SetPoint("CENTER", C, "TOPLEFT", c, -d);
		T:SetSize(32,32);
		T:Show()
		end,
};

local drawText = {
	startButton		= "LeftButtonDown",
	stopButton		= "LeftButtonUp",
	cancelButton    = "RightButtonUp",
	stopFunc 		= function(rec,a,b,c,d)
		rec.editbox:ClearAllPoints();
		rec.editbox:SetPoint("CENTER", rec.drawLayer, "TOPLEFT", c, -d);
		rec.editbox:SetWidth(96);
		rec.editbox:SetHeight(16);
		rec.editbox:SetText("");
		rec.editbox.x,rec.editbox.y = c,d;
		rec.editbox:SetJustifyH("CENTER");
		rec.editbox:SetTextInsets(0, 0, 3, 3);
		rec.editbox:Show();
		rec.editbox:Raise();
		rec.drawLayer.mouseLine:Hide();
		rec:StartCapture(Doodlepad.defaultScript)
		--;
	end,
	cancelFunc = function(rec) rec:StartCapture(Doodlepad.defaultScript) rec.drawLayer.mouseLine:Hide(); end,
	updateFunc	= function(rec,a,b,c,d)
		local C = rec.drawLayer;
		local T = C.mouseLine or C:CreateTexture()
		C.mouseLine = T;
		T:ClearAllPoints();
		T:SetTexture([[Interface\AddOns\Doodlepad\Textures\caret]]);
		T:SetVertexColor(1,1,1,1);
		T:SetDrawLayer("OVERLAY")
		T:SetPoint("TOPLEFT", C, "TOPLEFT", c-12, -d+12);
		T:SetSize(24,24);
		T:Show()
		end,
};

local drawRect = {
	startButton		= "LeftButtonDown",
	stopButton		= "LeftButtonUp",
	cancelButton    = "RightButtonUp",
	updateFunc		= function(rec)
		local a,b,dx,dy = rec:GetBounds(true);
		local C = rec.drawLayer;
		local T = C.mouseLine or C:CreateTexture()
		C.mouseLine = T;
		T:SetColorTexture(1,1,1,1);
		local R,G,B = unpack(rec.color);
		T:SetVertexColor(R,G,B,0.8);
		T:SetTexCoord(0,1,0,1);
		T:SetDrawLayer("OVERLAY")
		T:SetPoint("TOPLEFT", C, "TOPLEFT", a, -b);
		T:SetSize(dx,dy);
		T:Show()
		end,
	stopFunc 		= function(rec)
		if rec.drawLayer.mouseLine then rec.drawLayer.mouseLine:SetTexture(nil); end
		local _,_,w,h = rec.drawLayer:GetRect();
		local a,b,dx,dy = rec:GetBounds(true)
		a,b,dx,dy = a/(w/dw), b/(h/dh), dx/(w/dw), dy/(h/dh);
		rec:StartCapture(Doodlepad.defaultScript)
		tinsert(rec.cdoodle, {type="polygon", polyType="R", x=a,y=b,w=dx,h=dy});
		rec.cdoodle.color = rec.color;
		Doodle_Draw(rec);
		tinsert(rec.doodles, rec.cdoodle);
		Doodle_Broadcast_Prepare(rec.doodle, rec.cdoodle);
		rec.cdoodle = {creator=myName};
	end,
	cancelFunc		= function(rec) if rec.drawLayer.mouseLine then rec.drawLayer.mouseLine:SetTexture(nil); end rec:StartCapture(Doodlepad.defaultScript) end,
}
local drawCircle = {
	startButton		= "LeftButtonDown",
	stopButton		= "LeftButtonUp",
	cancelButton    = "RightButtonUp",
	updateFunc		= function(rec)
		local a,b,dx,dy = rec:GetBounds(true);
		local C = rec.drawLayer;
		local T = C.mouseLine or C:CreateTexture()
		C.mouseLine = T;
		T:SetTexture([[Interface\AddOns\Doodlepad\Textures\circle]]);
		local R,G,B = unpack(rec.color);
		T:SetVertexColor(R,G,B,0.8);
		T:SetTexCoord(0,1,0,1);
		T:SetDrawLayer("OVERLAY")
		T:SetPoint("TOPLEFT", C, "TOPLEFT", a, -b);
		T:SetSize(dx,dy);
		T:Show()
		end,
	stopFunc 		= function(rec)
		if rec.drawLayer.mouseLine then rec.drawLayer.mouseLine:SetTexture(nil); end
		local _,_,w,h = rec.drawLayer:GetRect();
		local a,b,dx,dy = rec:GetBounds(true)
		a,b,dx,dy = a/(w/dw), b/(h/dh), dx/(w/dw), dy/(h/dh);
		rec:StartCapture(Doodlepad.defaultScript)
		tinsert(rec.cdoodle, {type="polygon", polyType="C", x=a,y=b,w=dx,h=dy});
		rec.cdoodle.color = rec.color;
		Doodle_Draw(rec);
		tinsert(rec.doodles, rec.cdoodle);
		Doodle_Broadcast_Prepare(rec.doodle, rec.cdoodle);
		rec.cdoodle = {creator=myName};
	end,
	cancelFunc		= function(rec) if rec.drawLayer.mouseLine then rec.drawLayer.mouseLine:SetTexture(nil); end rec:StartCapture(Doodlepad.defaultScript) end,
}


local function Doodlepad_Button(parent, title, image, func)
	local button = CreateFrame("Button",nil,parent);
	button:SetSize(24,24);
	parent.bLeft = parent.bLeft or 6;
	button:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", parent.bLeft, 5);
	button:SetNormalTexture([[Interface\AddOns\Doodlepad\Textures\Button]]);
	parent.bLeft = parent.bLeft + 26;
	button.overlay = button:CreateTexture(nil, "OVERLAY");
	button.overlay:SetPoint("CENTER");
	button.overlay:SetSize(18,18);
	button.overlay:SetTexture(image);
	button:SetHighlightTexture([[Interface\BUTTONS\ButtonHilight-Square]]);
	button:SetScript("OnClick", function() func(button, parent.recorder) end);
	button:SetScript("OnEnter", function(caller) GameTooltip:ClearLines(); GameTooltip:SetOwner(caller, "ANCHOR_TOP"); GameTooltip:SetText(title); GameTooltip:Show(); end);
    button:SetScript("OnLeave", function() GameTooltip:Hide(); end);
	return button;
end

local function Doodlepad_ChangeColor(button, rec)
	if ColorPickerFrame:IsShown() then
		ColorPickerFrame:Hide()
	else
		button.r, button.g, button.b = unpack(rec.color);
		button.hasOpacity = false
		button.swatchFunc =
			function()
				button.r, button.g, button.b = ColorPickerFrame:GetColorRGB()
				button.overlay:SetVertexColor(button.r, button.g, button.b)
				rec.color = {button.r, button.g, button.b};
			end
		button.cancelFunc =
			function()
				button.r, button.g, button.b = ColorPicker_GetPreviousValues()
				button.overlay:SetVertexColor(button.r, button.g, button.b)
				rec.color = {button.r, button.g, button.b};
			end
		OpenColorPicker(button)
		ColorPickerFrame:SetFrameStrata("TOOLTIP")
		ColorPickerFrame:Raise()
	end
end

function Doodlepad_window(chan, uid, silent, sender)
	uid = uid or "";
    local frame = CreateFrame("Frame", nil, UIParent);
    frame:SetBackdrop({bgFile = "Interface/GLUES/loading",edgeFile = "Interface/GLUES/Common/TextPanel-Border",edgeSize = 16,insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    frame:SetBackdropColor(0.3,0.3,0.3,0.85);
    frame:SetWidth(dw/2)
    frame:SetHeight(dh/3);
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
	frame:RegisterForDrag("LeftButton");
	frame:SetScript("OnDragStart",function()  frame:StartMoving(); end);
	frame:SetScript("OnDragStop", function()  frame:StopMovingOrSizing(); end);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:EnableMouseWheel(true);
	frame:SetResizable(true);
	frame:SetMinResize(180,80);
	local subFrame = CreateFrame("Frame");
	subFrame:SetParent(frame);
	subFrame:SetPoint("TOPLEFT", 5, -28);
	subFrame:SetPoint("BOTTOMRIGHT", -5, 32);
	local canvas = subFrame:CreateTexture("BACKGROUND");
	canvas:SetColorTexture(1,1,1,0.85);
	canvas:SetAllPoints(subFrame);
	local recorder = libmg:New(subFrame);
	frame.recorder = recorder;
	recorder.colorbtn = Doodlepad_Button(frame, "Change pen color", [[Interface\AddOns\Doodlepad\Textures\Brush]], Doodlepad_ChangeColor);
	recorder.colorbtn.overlay:SetVertexColor(1,0,0);

	-- Map overlay button
	local icon = Doodlepad_Button(frame, "Set or change background map", [[Interface\Icons\Ability_Spy]], function(frame) myRec = recorder; overlaySelector:Show(); overlaySelector:Raise(); end)

	-- Rectangle button
	Doodlepad_Button(frame, "Add a rectangle", [[Interface\AddOns\Doodlepad\Textures\Rectangle]], function(frame,rec) rec:StartCapture(drawRect); end)

	-- Ellipse button
	Doodlepad_Button(frame, "Add an ellipse (or a circle)", [[Interface\AddOns\Doodlepad\Textures\Ellipse]], function(frame,rec) rec:StartCapture(drawCircle); end)

	-- Text button
	Doodlepad_Button(frame, "Add some text", [[Interface\AddOns\Doodlepad\Textures\Text]], function(frame,rec) rec:StartCapture(drawText); rec.isRecording = true; end)

	-- Icon button
	local DrawIconMenu = {
		{ text = "Select an icon:", isTitle = true},
	};
	for x = 1, #icons do
		tinsert(DrawIconMenu, {text=" ", icon=icons[x], func = function() recorder.xicon = x; recorder:StartCapture(drawIcon); recorder.isRecording = true; end });
	end
	Doodlepad_Button(frame, "Add an icon", [[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_8]], function() EasyMenu(DrawIconMenu, Storyboard_Frame.menuFrame, "cursor", 0 , 0, "MENU"); end)


	local xframe = subFrame;
	if ( uid:len() >= 8 ) then frame:Hide();
	else uid = genuid();
	end
	recorder.editbox = CreateFrame("EditBox", ("DoodleEditbox_%08x"):format(random(time())), recorder.drawLayer, "InputBoxTemplate");
    recorder.editbox:SetAutoFocus(true);
    recorder.editbox:SetScript("OnEscapePressed", function(me) me:Hide(); end);
    recorder.editbox:SetScript("OnEnterPressed",  function(me)
		local txt = {type="text", text=me:GetText(), x = me.x*(dw/recorder.width),y=me.y*(dh/recorder.height)};
		tinsert(recorder.cdoodle, txt);
		recorder.cdoodle.color = recorder.color or {0.96,0.82,0.2};
		Doodle_Draw(recorder);
		tinsert(recorder.doodles, recorder.cdoodle);
		Doodle_Broadcast_Prepare(recorder.doodle, recorder.cdoodle);
		recorder.cdoodle = {creator=myName};
		me:Hide();
		end);
    recorder.editbox:SetTextInsets(0, 0, 3, 3);
    recorder.editbox:SetMaxLetters(100);
    recorder.editbox:Hide();

	-- caption
	local caption = frame:CreateFontString(nil, "DIALOG");
	caption:SetParent(frame);
	caption:SetFontObject(ChatFontNormal);
	caption:SetText("Doodlepad");
	caption:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5);
	caption:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 5, -25);
	frame.caption = caption;

    -- close button
    local close = CreateFrame("button", nil, frame, "UIPanelCloseButton");
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0);
    close:Show();

	-- resizer
    local sizer = CreateFrame("frame", nil, frame);
    sizer:SetPoint("BOTTOMRIGHT")
    sizer:SetHeight(15);
    sizer:SetWidth(15);
    sizer:EnableMouse()
    sizer:SetScript("OnMouseDown",function(frame) frame:GetParent():StartSizing("BOTTOMRIGHT") subFrame:SetAlpha(0.25) end)
    sizer:SetScript("OnMouseUp", function(frame) frame:GetParent():StopMovingOrSizing() subFrame:SetAlpha(1) recorder.width = xframe:GetWidth(); recorder.height = xframe:GetHeight(); Doodle_Redraw(recorder); end)
	frame:SetScript("OnSizeChanged", function(frame) MapOverlay(recorder, false);end);

    local line1 = sizer:CreateTexture(nil, "BACKGROUND")
    line1:SetWidth(14)
    line1:SetHeight(14)
    line1:SetPoint("BOTTOMRIGHT", 0, 0)
    line1:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
    local x = 0.1 * 14/17
    line1:SetTexCoord(0.05 - x, 0.5, 0.05, 0.5 + x, 0.05, 0.5 - x, 0.5 + x, 0.5)

    local line2 = sizer:CreateTexture(nil, "BACKGROUND")
    line2:SetWidth(8)
    line2:SetHeight(8)
    line2:SetPoint("BOTTOMRIGHT", 0,0)
    line2:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
    local x = 0.1 * 8/17
    line2:SetTexCoord(0.05 - x, 0.5, 0.05, 0.5 + x, 0.05, 0.5 - x, 0.5 + x, 0.5)

	recorder.width, recorder.height = subFrame:GetSize();
	recorder.doodles, recorder.cdoodle, recorder.texs, recorder.free, recorder.icon,recorder.strings = {},{creator=myName},{},{}, 1, {};
	recorder.color = colors[1];
	recorder.target = recorder.drawLayer:CreateTexture("OVERLAY",7);
	recorder.target:SetTexture([[Interface\TARGETINGFRAME\UI-RaidTargetingIcon_]] .. recorder.icon);
	recorder.target:SetWidth(32);
	recorder.target:SetHeight(32);

	frame:SetScript("OnMouseWheel",
		function(caller, value)
			if ( IsControlKeyDown() ) then
				recorder.icon = recorder.icon - value;
				if ( recorder.icon > #icons ) then recorder.icon = 1; end
				if ( recorder.icon < 1 ) then recorder.icon = #icons; end
			else
				recorder.xcolor = (recorder.xcolor or 1) - value;
				if ( recorder.xcolor > #colors ) then recorder.xcolor = 1; end
				if ( recorder.xcolor < 1 ) then recorder.xcolor = #colors; end
				recorder.color = colors[recorder.xcolor];
				recorder.colorbtn.overlay:SetVertexColor(unpack(recorder.color))
			end
		end);
	subFrame:SetScript("OnUpdate",
		function()
			if ( subFrame:IsMouseOver() ) then
				if ( IsControlKeyDown() ) then
					recorder.target:SetTexture(icons[recorder.icon]);
					recorder.target:SetWidth(32);
					recorder.target:SetHeight(32);
				else
					if type(recorder.color) == "number" then
						recorder.target:SetColorTexture(unpack(colors[recorder.color or 1]));
					else
						recorder.target:SetColorTexture(unpack(recorder.color));
					end
					recorder.target:SetWidth(4);
					recorder.target:SetHeight(4);
				end
				recorder.target:SetPoint("CENTER", recorder.drawLayer, "TOPLEFT", recorder.mouseEnd[1], -recorder.mouseEnd[2]);
				recorder.target:Show();
			else
				recorder.target:Hide();
			end
		end);
	local xchan = string.upper(chan or "");
	if ( xchan == "RAID" or xchan == "PARTY" or xchan == "GUILD" or xchan == "INSTANCE_CHAT" ) then
		if not silent then dprint("Sharing doodle with the " .. chan); caption:SetText("Doodlepad: Broadcasting to the " .. chan); end
		chan = xchan;
	elseif ( xchan:len() > 1 ) then
		if not silent then dprint("Sharing doodle with " .. chan); caption:SetText("Doodlepad: Sharing with " .. chan); end
	end
	local doodle = nil;
	local found = false;
	for n = 1, #OpenDoodles do
		if OpenDoodles[n].uid == uid then found = true doodle = OpenDoodles[n]; if xchan:len() > 1 then doodle.chan = chan; end break end
	end
	if not found then
		doodle = {uid=uid, recorder=recorder, sender=sender or myName, painters={sender or myName}, frame=frame, chan=chan};
		tinsert(OpenDoodles, doodle);
	end
	close:SetScript("OnClick",
		function()
		frame:Hide();
		Doodle_Draw(recorder, true); -- wipe the pad
		if ( #doodle.recorder.doodles > 0 ) then
			dprint("Pad closed. The doodle has been saved in your storyboard for later use.");
			Storyboard_Save(doodle);
		end
		Storyboard_Scroll(0);
		end);
	recorder.doodle = doodle;
	recorder:StartCapture(Doodlepad.defaultScript);
	MapOverlay(recorder);
	return frame, recorder;
end

local function Doodle_Open(caller, rec, target)
	EasyMenu({}, Storyboard_Frame.menuFrame, "cursor", 0 , 0, "MENU");
	local f,r = Doodlepad_window(target or "",rec.uid);
	r.uid = rec.uid;
	r.doodles = rec.doodles;
	r.map = rec.map;
	r.mapCoords = rec.mapCoords;
	MapOverlay(r,true)
	Doodle_Redraw(r);
	f:Show();
	f:Raise();
	Storyboard_Frame:Hide();
	if target then
		for n=1, #rec.doodles do Doodle_Broadcast_Prepare(r, rec.doodles[n]); end
	end
end

local function Doodle_OpenTarget(caller, rec)
		EasyMenu({}, Storyboard_Frame.menuFrame, "cursor", 0 , 0, "MENU");
		local frame = CreateFrame("Frame", nil, UIParent);
		frame:SetBackdrop({bgFile = "Interface/GLUES/loading",edgeFile = "Interface/GLUES/Common/TextPanel-Border",edgeSize = 16,insets = { left = 4, right = 4, top = 4, bottom = 4 }});
		frame:SetBackdropColor(0.2,0.2,0.2,0.75);
		frame:SetSize(300,80);
		frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
		frame:EnableMouse(true);
		local editbox = CreateFrame("EditBox", "DoodleWhisper" .. time(), frame, "InputBoxTemplate");
		editbox:SetSize(100,24);
		editbox:SetAutoFocus(true);
		editbox:SetScript("OnEscapePressed", function(me) frame:Hide(); end);
		editbox:SetScript("OnEnterPressed",  function(me)
				local txt = me:GetText();
				Doodle_Open(nil,rec,txt);
				frame:Hide();
				end);
		editbox:SetTextInsets(0, 0, 3, 3);
		editbox:SetMaxLetters(12);
		editbox:SetPoint("CENTER", frame);
		editbox:Show()
		local caption = frame:CreateFontString(nil, "DIALOG");
		caption:SetParent(frame);
		caption:SetFontObject(ChatFontNormal);
		caption:SetText("Enter name of recipient:");
		caption:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5);
		caption:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 5, -25);
		local close = CreateFrame("button", nil, frame, "UIPanelCloseButton");
		close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0);
		close:Show();
		frame:SetFrameStrata("FULLSCREEN");
		frame:Raise();
	end

local function Storyboard_Context(rec)
	local menu = {
    { text = "Tools:", isTitle = true},
    { text = "Open doodle", func = function() local f,r = Doodlepad_window("", rec.uid); r.chan = ""; r.uid = rec.uid; r.map = rec.map; r.mapCoords = rec.mapCoords; MapOverlay(r) r.doodles = rec.doodles; Doodle_Redraw(r); f:Show(); f:Raise(); Storyboard_Frame:Hide(); end },
	{ text = "Open and broadcast to:", hasArrow = true, menuList = {
		{ text = channelColor("Whisper..."), func = Doodle_OpenTarget, arg1=rec},
        { text = channelColor("Raid"), func = Doodle_Open, arg1=rec, arg2="raid" },
		{ text = channelColor("Party"), func = Doodle_Open, arg1=rec, arg2="party"},
		{ text = channelColor("Guild"), func = Doodle_Open, arg1=rec, arg2="guild"},
		{ text = channelColor("Instance_Chat"), func = Doodle_Open, arg1=rec, arg2="instance_chat"},
		}
    },
	{ text = "Open as new doodle", func = function() local f,r = Doodlepad_window(""); r.uid = nil; r.doodles = rec.doodles; Doodle_Redraw(r); f:Show(); f:Raise(); Storyboard_Frame:Hide(); end },
	{ text = "Rename", func = function() rec.editbox:SetText(rec.pointer.title); rec.editbox:SetAllPoints(rec.caption); rec.editbox:Show(); end},
	{ text = "Delete doodle", func = function() Storyboard_Delete(rec.uid) end },
    { text = "Cancel"},
    };
    EasyMenu(menu, Storyboard_Frame.menuFrame, "cursor", 0 , 0, "MENU");
end


---- Storyboard ----
Storyboard_Frame = CreateFrame("Frame", nil, UIParent);
Storyboard_Frame:SetBackdrop({bgFile = "Interface/GLUES/loading",edgeFile = "Interface/GLUES/Common/TextPanel-Border",edgeSize = 16,insets = { left = 4, right = 4, top = 4, bottom = 4 }});
Storyboard_Frame:SetBackdropColor(1,1,1,0.4);
Storyboard_Frame:SetWidth(640)
Storyboard_Frame:SetHeight(220);
Storyboard_Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
Storyboard_Frame:RegisterForDrag("LeftButton");
Storyboard_Frame:SetScript("OnDragStart",function()  Storyboard_Frame:StartMoving(); end);
Storyboard_Frame:SetScript("OnDragStop", function()  Storyboard_Frame:StopMovingOrSizing(); end);
Storyboard_Frame:SetScript("OnMouseWheel", function(caller, value)  Storyboard_Scroll(value); end);
Storyboard_Frame:SetMovable(true);
Storyboard_Frame:EnableMouse(true);
Storyboard_Frame:EnableMouseWheel(true);
Storyboard_Frame:Hide();
Storyboard_Frame.menuFrame = CreateFrame("Frame", "Storyboard_Frame_Menu", UIParent, "UIDropDownMenuTemplate")

--Container frames
Storyboard_Frame.doodles = {};
local x = 10;
for n = 1, 3 do
	Storyboard_Frame.doodles[n] = CreateFrame("Frame", nil, Storyboard_Frame);
	Storyboard_Frame.doodles[n]:SetWidth(200);Storyboard_Frame.doodles[n]:SetHeight(150);
	Storyboard_Frame.doodles[n].canvas = Storyboard_Frame.doodles[n]:CreateTexture("BACKGROUND", -7);
	Storyboard_Frame.doodles[n].drawLayer = CreateFrame("Frame", nil, Storyboard_Frame.doodles[n])
	Storyboard_Frame.doodles[n].drawLayer:SetAllPoints();
	Storyboard_Frame.doodles[n].canvas:SetColorTexture(1,1,1,1);
	Storyboard_Frame.doodles[n].canvas:SetAllPoints();
	Storyboard_Frame.doodles[n]:SetPoint("TOPLEFT", x,-40);
	Storyboard_Frame.doodles[n].texs = {};
	Storyboard_Frame.doodles[n].free = {};
	Storyboard_Frame.doodles[n].strings = {};
	Storyboard_Frame.doodles[n].cdoodle = {};
	Storyboard_Frame.doodles[n].doodles = {};
	Storyboard_Frame.doodles[n].width = 200;
	Storyboard_Frame.doodles[n].height = 150;
	Storyboard_Frame.doodles[n].drawLayer:EnableMouse(true);
	Storyboard_Frame.doodles[n].drawLayer:SetScript("OnMouseup", function(caller,event) if ( event == "RightButton" ) then Storyboard_Context(Storyboard_Frame.doodles[n]) end end);
	Storyboard_Frame.doodles[n].caption = Storyboard_Frame.doodles[n]:CreateFontString(nil, "DIALOG");
	Storyboard_Frame.doodles[n].caption:SetParent(Storyboard_Frame);
	Storyboard_Frame.doodles[n].caption:SetFontObject(ChatFontNormal);
	Storyboard_Frame.doodles[n].caption:SetText("");
	Storyboard_Frame.doodles[n].caption:SetTextColor(1,0.6,0,0.8);
	Storyboard_Frame.doodles[n].caption:SetPoint("TOPLEFT", Storyboard_Frame.doodles[n], "TOPLEFT", 5, 16);
	Storyboard_Frame.doodles[n].caption:SetPoint("BOTTOMRIGHT", Storyboard_Frame.doodles[n], "TOPRIGHT", -5, -2);
	Storyboard_Frame.doodles[n].editbox = CreateFrame("EditBox", nil, Storyboard_Frame.doodles[n], "InputBoxTemplate");
    Storyboard_Frame.doodles[n].editbox:SetAutoFocus(true);
    Storyboard_Frame.doodles[n].editbox:SetScript("OnEscapePressed", function(me) me:Hide(); end);
    Storyboard_Frame.doodles[n].editbox:SetScript("OnEnterPressed",  function(me)
		local txt = me:GetText();
		Storyboard_Frame.doodles[n].pointer.title = txt;
		me:Hide();
		Storyboard_Scroll(0);
		end);
    Storyboard_Frame.doodles[n].editbox:SetTextInsets(0, 0, 3, 3);
    Storyboard_Frame.doodles[n].editbox:SetMaxLetters(100);
	Storyboard_Frame.doodles[n].editbox:SetJustifyH("CENTER");
    Storyboard_Frame.doodles[n].editbox:Hide();
	x = x + 210;
end

-- caption
local caption = Storyboard_Frame:CreateFontString(nil, "DIALOG");
caption:SetParent(Storyboard_Frame);
caption:SetFontObject(ChatFontNormal);
caption:SetText("Storyboard");
caption:SetPoint("TOPLEFT", Storyboard_Frame, "TOPLEFT", 5, -5);
caption:SetPoint("BOTTOMRIGHT", Storyboard_Frame, "TOPRIGHT", 5, -25);

caption = Storyboard_Frame:CreateFontString(nil, "DIALOG");
caption:SetParent(Storyboard_Frame);
caption:SetFontObject(ChatFontNormal);
caption:SetText("Use your mouse wheel to scroll through the saved doodles. Right click a doodle for file actions.");
caption:SetPoint("TOPLEFT", Storyboard_Frame, "BOTTOMLEFT", 5, 25);
caption:SetPoint("BOTTOMRIGHT", Storyboard_Frame, "BOTTOMRIGHT", 5, 5);

-- close button
local close = CreateFrame("button", nil, Storyboard_Frame, "UIPanelCloseButton");
close:SetPoint("TOPRIGHT", Storyboard_Frame, "TOPRIGHT", 0, 0);
close:Show();


-- Instance map overlay selector
local frame = CreateFrame("Frame", nil, UIParent);
frame:SetBackdrop({bgFile = "Interface/GLUES/loading",edgeFile = "Interface/GLUES/Common/TextPanel-Border",edgeSize = 16,insets = { left = 4, right = 4, top = 4, bottom = 4 }});
frame:SetBackdropColor(0,0,0,0.85);
frame:SetSize(680,420);
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
frame:RegisterForDrag("LeftButton");
frame:SetScript("OnDragStart",function()  frame:StartMoving(); end);
frame:SetScript("OnDragStop", function()  frame:StopMovingOrSizing(); end);
frame:SetMovable(true);
frame:EnableMouse(true);
frame:EnableMouseWheel(true);
frame:SetResizable(true);
local filetree = AceGUI:Create("TreeGroup");
local tbl = {
		{
            value = "$$Empty$$",
            text = "|cffffffffSelect a background:|r",
            icon = "",
            disabled = true,
        },
        {
            value = "$$map=1$$",
            text = "Blank white sheet",
        },
        {
            value = "$$Empty$$",
            text = "   ",
            icon = "",
            disabled = true,
        },
    };
for n = 2, #instanceMaps do
	tinsert(tbl, { value="$$map=" .. n .. "$$", text = instanceMaps[n][2]});
end
filetree:SetTree(tbl);
filetree:SetUserData("tree", tbl);
filetree.frame:SetParent(frame);
filetree.frame:SetPoint("TOPLEFT", 5, -28);
filetree.frame:SetPoint("BOTTOMRIGHT", -5, 50);
local subFrame = CreateFrame("Frame");
subFrame:SetParent(filetree.content);
subFrame:SetAllPoints();
--subFrame:SetPoint("BOTTOMRIGHT", -5, 50);
local canvas = subFrame:CreateTexture("BACKGROUND");
canvas:SetColorTexture(1,1,1,0.85);
canvas:SetAllPoints(subFrame);
local recorder = libmg:New(subFrame);
frame.recorder = recorder;
overlaySelector = frame;
frame:SetFrameStrata("FULLSCREEN_DIALOG");
-- caption
local caption = frame:CreateFontString(nil, "DIALOG");
caption:SetParent(frame);
caption:SetFontObject(ChatFontNormal);
caption:SetText("Select background:");
caption:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5);
caption:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 5, -25);
local caption = frame:CreateFontString(nil, "DIALOG");
caption:SetParent(frame);
caption:SetFontObject(ChatFontNormal);
caption:SetText("Select a map name or use your mouse wheel to scroll through backgrounds.|n|cff44AA55Optionally, you can draw a rectangle on the map to zoom in.|r");
caption:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 5, 48);
caption:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -120, 5);
frame.caption = caption;
frame:Hide();
-- close button
local close = CreateFrame("button", nil, frame, "UIPanelCloseButton");
close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0);
close:Show();
--close:SetScript("OnClick", function() MapOverlay(myRec,true); frame:Hide(); end);

recorder.width, recorder.height = dw,dh;
recorder.target = recorder.drawLayer:CreateTexture("OVERLAY",7);
recorder.target:SetColorTexture(0.5,0,0.7,0.5);

-- accept/cancel buttons
local btn = CreateFrame("button", nil, frame, "UIPanelButtonTemplate");
btn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 10);
btn:SetText("Cancel");
btn:SetSize(80,22);
btn:Show();
btn:SetScript("OnClick", function() frame:Hide(); end);

local btn = CreateFrame("button", nil, frame, "UIPanelButtonTemplate");
btn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -100, 10);
btn:SetSize(80,22);
btn:SetText("Okay");
btn:Show();
btn:SetScript("OnClick", function() MapOverlay(myRec,true); frame:Hide(); end);

-- map scripts
filetree:SetCallback("OnClick",
        function(caller, event, value)
            local subtree, subval = (value):match("%$(%a+)=([^%$]+)%$");
			if subtree == "map" then
				local n = tonumber(subval);
				if n and instanceMaps[n] then
					recorder.xmap = n;
					recorder.map = instanceMaps[recorder.xmap][1];
					recorder.mapCoords = {0,0,3.9,2.6}
					MapOverlay(recorder);
					myRec.map = recorder.map;
				end
			end
		end);
frame:SetScript("OnMouseWheel",
	function(caller, value)
		recorder.xmap = (recorder.xmap or 1) - value;
		if ( recorder.xmap > #instanceMaps ) then recorder.xmap = 1; end
		if ( recorder.xmap < 1 ) then recorder.xmap = #instanceMaps; end
		recorder.map = instanceMaps[recorder.xmap][1];
		recorder.mapCoords = {0,0,3.9,2.6}
		MapOverlay(recorder);
		myRec.map = recorder.map;
	end);

local overlayScript = {
	startButton		= "LeftButtonDown",
	stopButton		= "LeftButtonUp",
	cancelButton    = "RightButtonUp",
	updateFunc		= function(rec)
		local a,b,dx,dy = rec:GetBounds(true);
		local C = rec.drawLayer;
		local T = C.mouseLine or C:CreateTexture()
		C.mouseLine = T;
		T:SetColorTexture(1,1,1,1);
		T:SetTexCoord(0,1,0,1);
		T:SetDrawLayer(layer or "OVERLAY")
		T:SetVertexColor(0.7,0,0.8,0.5);
		T:SetPoint("TOPLEFT", C, "TOPLEFT", a, -b);
		T:SetSize(dx,dy);
		T:Show()
		end,
	stopFunc 		= function(rec) local _,_,w,h = rec.drawLayer:GetRect(); local a,b,dx,dy = rec:GetBounds(true) a,b = a/(w/3.9), b/(h/2.6); myRec.mapCoords = {a,b,a+(dx/(w/3.9)),b+(dy/(h/2.6))}; rec:StartCapture(rec._CaptureScript) end,
	cancelFunc		= function(rec) if rec.drawLayer.mouseLine then rec.drawLayer.mouseLine:Hide() end myRec.mapCoords = {0,0,3.9,2.6} rec:StartCapture(rec._CaptureScript) end,
}

recorder:StartCapture(overlayScript);


--[[ DEFAULTS ]] --
local function Doodlepad_SetDefaults(addon) -- Set default configuration values
	if not (addon == "Doodlepad") then return end
	RegisterAddonMessagePrefix("DPD2")
	Doodleboard.allowReceiveRaid = Doodleboard.allowReceiveRaid or 1;
	Doodleboard.allowReceiveGuild = Doodleboard.allowReceiveGuild or 9;
	Doodleboard.allowReceiveWhisper = Doodleboard.allowReceiveWhisper or 1;
	Doodleboard.allowReceiveParty = Doodleboard.allowReceiveParty or 1;
	Doodleboard.allowEditRaid = Doodleboard.allowEditRaid or 2;
	Doodleboard.allowEditGuild = Doodleboard.allowEditGuild or 2;
	Doodleboard.allowEditParty = Doodleboard.allowEditParty or 1;
	Doodleboard.enableMinimap = Doodleboard.enableMinimap or false;

	local launcher = LDB:NewDataObject("Doodlepad", {
		type = "launcher",
		text = "Doodlepad",
		icon = "Interface\\Addons\\Doodlepad\\Textures\\Logo",
		OnClick = function(_, button)
			if ( button == "LeftButton" ) then
				Doodlepad_window("")
			elseif ( button == "RightButton" ) then
				Storyboard_Scroll(0); Storyboard_Frame:Show();
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine("Doodlepad");
			tooltip:AddLine("|cff00ff00Left click|r to open a new pad.",1,1,1);
			tooltip:AddLine("|cffff3300Right click|r to open the storyboard.",1,1,1);
		end,
	})
	LDBIcon:Register("Doodlepad",launcher,{hide=not Doodleboard.enableMinimap});
end


Doodlepad.defaultScript = {
	startButton		= "LeftButtonDown",
	stopButton		= "LeftButtonUp",
	cancelButton    = "RightButtonUp",
	startFunc 		= Doodle_Start,
	updateFunc		= Doodle_Update,
	stopFunc 		= Doodle_Stop,
	cancelFunc		= Doodle_Cancel,
};

local function Doodle_OnEvent(self,event,...)
	if ( event == "CHAT_MSG_ADDON" ) then
		Doodlepad_Incoming(...)
	elseif ( event == "ADDON_LOADED" )
		then Doodlepad_SetDefaults(...)
	end
end


SLASH_DOODLE1 = '/doodlepad';
SLASH_DOODLE2 = '/pad';
SLASH_STORYBOARD1 = '/storyboard';
SLASH_STORYBOARD2 = '/board';
SlashCmdList['DOODLE'] = function(chan) Doodlepad_window(chan) end;
SlashCmdList['STORYBOARD'] = function(chan) Storyboard_Scroll(0); Storyboard_Frame:Show(); end;
local frame = CreateFrame("Frame");
frame:SetParent(UIParent);frame:SetPoint("TOPLEFT");
frame:RegisterEvent("CHAT_MSG_ADDON");
frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", Doodle_OnEvent);
frame:SetScript("OnUpdate", Doodle_Broadcast);
Doodlepad.itemref = _G.SetItemRef;
_G.SetItemRef = Doodle_ParseLink;
