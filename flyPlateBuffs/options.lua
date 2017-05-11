local AddonName, fPB = ...
local L = fPB.L

local db = {}
local UpdateAllNameplates = fPB.UpdateAllNameplates

local 	GetSpellInfo, tonumber, pairs, table_sort, table_insert =
		GetSpellInfo, tonumber, pairs, table.sort, table.insert
local	DISABLE = DISABLE
local chatColor = fPB.chatColor
local linkColor = fPB.linkColor

function fPB.OptionsOnEnable()
	db = fPB.db.profile

	fPB.BuildSpellList()
end

fPB.tooltip = fPB.tooltip or CreateFrame("GameTooltip", AddonName.."Tooltip", UIParent, "GameTooltipTemplate")
local tooltip = fPB.tooltip
tooltip:Show()
tooltip:SetOwner(UIParent, "ANCHOR_NONE")


local minIconSize = 10
local maxIconSize = 100
local minTextSize = 6
local maxTextSize = 30
local minInterval = 0
local maxInterval = 80

local function CheckSort()
	local i = 1
	while db.sortMode[i] do
		if db.sortMode[i] ~= "disable" then
			return true
		end
		i = i+1
	end
	return false
end

fPB.MainOptionTable = {
	name = L["Display options"],
	type = "group",
	childGroups = "tab",
	get = function(info)
        return db[info[#info]]
    end,

	set = function(info, value)
        db[info[#info]] = value
		UpdateAllNameplates()
    end,

	args = {
		displayConditions = {
			order = 1,
			name = L["Display conditions"],
			type = "group",
			args = {
				showDebuffs = {
					order = 1,
					type = "select",
					style = "dropdown",
					name = L["Show debuffs"],
					values = {
							L["All"],
							L["Mine + SpellList"],
							L["Only SpellList"],
							L["Only mine"],
							L["None"],
					},
				},
				showBuffs = {
					order = 2,
					type = "select",
					style = "dropdown",
					name = L["Show buffs"],
					values = {
							L["All"],
							L["Mine + SpellList"],
							L["Only SpellList"],
							L["Only mine"],
							L["None"],
					},
				},
				hidePermanent = {
					order = 3,
					type = "toggle",
					name = L["Hide permanent effects"],
					desc = L["Do not show effects without duration."],
				},
				showOnlyInCombat = {
					order = 6,
					type = "toggle",
					name = L["Player in combat"],
					desc = L["Show only if player is in combat"],
					set = function(info,value)
						db.showOnlyInCombat = value
						UpdateAllNameplates()
						if value then
							fPB.RegisterCombat()
							if not InCombatLockdown() then fPB.Events:UnregisterEvent("UNIT_AURA") end
						else
							fPB.UnregisterCombat()
							fPB.Events:RegisterEvent("UNIT_AURA")
						end
					end,
				},
				showUnitInCombat = {
					order = 7,
					type = "toggle",
					name = L["Unit in combat"],
					desc = L["Show only if unit is in combat"],
				},
				break1 = {
					order = 8,
					type = "header",
					name = "",
				},
				showOnPlayers = {
					order = 9,
					type = "toggle",
					name = L["Players"],
					desc = L["Show on players"],
				},
				blank1 = {
					order = 10,
					type = "description",
					name = "",
					width = "normal",
				},
				showOnEnemy = {
					order = 11,
					type = "toggle",
					name = L["Enemies"],
					desc = L["Show on enemies"],
				},
				showOnPets = {
					order = 12,
					type = "toggle",
					name = L["Pets"],
					desc = L["Show on pets"],
				},
				blank2 = {
					order = 13,
					type = "description",
					name = "",
					width = "normal",
				},
				showOnFriend = {
					order = 14,
					type = "toggle",
					name = L["Allies"],
					desc = L["Show on allies"],
				},
				showOnNPC = {
					order = 15,
					type = "toggle",
					name = L["NPCs"],
					desc = L["Show on NPCs"],
				},
				blank3 = {
					order = 16,
					type = "description",
					name = "",
					width = "normal",
				},
				showOnNeutral = {
					order = 17,
					type = "toggle",
					name = L["Neutrals"],
					desc = L["Show on neutral characters"],
				},
			},
		},
		styleSettings = {
			order = 2,
			name = L["Style settings"],
			type = "group",
			args = {
				iconsSize = {
					order = 1,
					type = "header",
					name = L["Icons Size"],
				},
				baseWidth = {
					order = 2,
					type = "range",
					name = L["Base width"],
					min = minIconSize,
					max = maxIconSize,
					step = 1,
				},
				baseHeight = {
					order = 3,
					type = "range",
					name = L["Base height"],
					min = minIconSize,
					max = maxIconSize,
					step = 1,
				},
				myScale = {
					order = 4,
					type = "range",
					name = L["Larger self spells"],
					desc = L["Show self spells x% bigger."],
					min = 0,
					max = 1,
					step = 0.1,
					isPercent = true,
				},
				cropTexture = {
					order = 4.1,
					type = "toggle",
					name = L["Crop texture"],
					desc = L["Crop texture instead of stretching. You can see the difference on rectangular icons"],
				},
				headerStack = {
					order = 5,
					type = "header",
					name = L["Stacks & Duration"],
				},
				font = {
					order = 6,
					type = "select",
					name = L["Font"],
					values = fPB.LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					set = function(info, value)
						db.font = value
						fPB.font = fPB.LSM:Fetch("font", db.font)
						UpdateAllNameplates()
					end,
				},
				stackSize = {
					order = 7,
					type = "range",
					name = L["Stack font size"],
					min = minTextSize,
					max = maxTextSize,
					step = 1,
				},
				durationSize = {
					order = 8,
					type = "range",
					name = L["Duration font size"],
					min = minTextSize,
					max = maxTextSize,
					step = 1,
				},
				showDuration = {
					order = 9,
					type = "toggle",
					name = L["Duration under icon"],
					desc = L["Show remaining duration under icon"],
				},
				showStdCooldown = {
					order = 10,
					type = "toggle",
					name = L["Duration on icon"],
					desc = L["Support standart blizzard or OmniCC"],
				},
				showStdSwipe = {
					order = 11,
					type = "toggle",
					name = L["Show 'clock' animation"],
					desc = L["Also will show duration if OmniCC installed, regardless of the previous option"],
				},
				blinkTimeleft = {
					order	= 11.5,
					name = L["Blink when close to expiring"],
					desc = L["Blink spell if below x% time left (only if it's below 60 seconds)"],
					type = "range",
					min		= 0,
					max		= 0.5,
					step	= 0.05,
					isPercent = true,
				},
				headerBorder = {
					order = 12,
					type = "header",
					name = L["Border"],
				},
				borderStyle = {
					order = 13,
					type = "select",
					style = "dropdown",
					name = L["Border Style"],
					values = {
						L["Square"],
						"Blizzard",
						L["None"],
					},
				},
				colorizeBorder = {
					order = 14,
					type = "toggle",
					name = L["Color debuff border by type"],
					desc = L["If not checked - physical used for all debuff types"],
					width = "double",
					disabled = function() return db.borderStyle == 3 end,
				},

				colorsPhysical = {
					order = 15,
					type = "color",
					name = L["Physical"],
					get = function(info)
						return db.colorTypes.none[1], db.colorTypes.none[2], db.colorTypes.none[3], 1
					end,
					set = function(info, r, g, b)
						db.colorTypes.none = {r, g, b}
					end,
				},
				colorsMagic = {
					order = 16,
					type = "color",
					name = L["Magic"],
					get = function(info)
						return db.colorTypes.Magic[1], db.colorTypes.Magic[2], db.colorTypes.Magic[3], 1
					end,
					set = function(info, r, g, b)
						db.colorTypes.Magic = {r, g, b}
					end,
				},
				colorsCurse = {
					order = 17,
					type = "color",
					name = L["Curse"],
					get = function(info)
						return db.colorTypes.Curse[1], db.colorTypes.Curse[2], db.colorTypes.Curse[3], 1
					end,
					set = function(info, r, g, b)
						db.colorTypes.Curse = {r, g, b}
					end,
				},
				colorsDisease = {
					order = 18,
					type = "color",
					name = L["Disease"],
					get = function(info)
						return db.colorTypes.Disease[1], db.colorTypes.Disease[2], db.colorTypes.Disease[3], 1
					end,
					set = function(info, r, g, b)
						db.colorTypes.Disease = {r, g, b}
					end,
				},
				colorsPoison = {
					order = 19,
					type = "color",
					name = L["Poison"],
					get = function(info)
						return db.colorTypes.Poison[1], db.colorTypes.Poison[2], db.colorTypes.Poison[3], 1
					end,
					set = function(info, r, g, b)
						db.colorTypes.Poison = {r, g, b}
					end,
				},
				colorsBuff = {
					order = 20,
					type = "color",
					name = L["Buffs"],
					get = function(info)
						return db.colorTypes.Buff[1], db.colorTypes.Buff[2], db.colorTypes.Buff[3], 1
					end,
					set = function(info, r, g, b)
						db.colorTypes.Buff = {r, g, b}
					end,
				},
			},

		},
		positionSettings = {
			order = 3,
			name = L["Position Settings"],
			type = "group",
			args = {
				buffAnchorPoint = {
					order = 1,
					type = "select",
					style = "dropdown",
					name = L["Buff frame's Anchor point"],
					desc = L["It will be attached to the nameplate at this point"],
					values = {
						["BOTTOMLEFT"] = "BOTTOMLEFT",
						["BOTTOM"] = "BOTTOM",
						["BOTTOMRIGHT"] = "BOTTOMRIGHT",
					},
				},
				plateAnchorPoint = {
					order = 2,
					type = "select",
					style = "dropdown",
					name = L["Nameplate's Anchor point"],
					desc = L["Buff frame will be anchored to this point of the nameplate"],
					values = {
						["TOPLEFT"] = "TOPLEFT",
						["TOP"] = "TOP",
						["TOPRIGHT"] = "TOPRIGHT",
					},
				},
				blank1 = {
					order = 3,
					type = "description",
					name = "",
					width = "normal",
				},
				xOffset = {
					order = 4,
					type = "range",
					name = L["Offset X"],
					desc = L["Horizontal offset of buff frame"],
					min = -256,
					max = 256,
					step = 1,
				},
				yOffset = {
					order = 5,
					type = "range",
					name = L["Offset Y"],
					desc = L["Vertical offset of buff frame"],
					min = -256,
					max = 256,
					step = 1,
				},
				blank2 = {
					order = 6,
					type = "description",
					name = "",
					width = "normal",
				},
				buffPerLine = {
					order = 7,
					type = "range",
					name = L["Icons per row"],
					desc = L["If more icons they will be moved to a new row"],
					min = 1,
					max = 20,
					step = 1,
				},
				numLines = {
					order = 8,
					type = "range",
					name = L["Max rows"],
					desc = L["Excess buffs will not be displayed"],
					min = 1,
					max = 10,
					step = 1,
				},
				blank3 = {
					order = 9,
					type = "description",
					name = "",
					width = "normal",
				},
				xInterval = {
					order = 10,
					type = "range",
					name = L["Interval X"],
					desc = L["Horizontal spacing between icons"],
					min = minInterval,
					max = maxInterval,
					step = 1,
				},
				yInterval = {
					order = 11,
					type = "range",
					name = L["Interval Y"],
					desc = L["Vertical spacing between icons"],
					min = minInterval,
					max = maxInterval,
					step = 1,
				},
				break1 = {
					order = 12,
					type = "header",
					name = "",
				},
				parentWorldFrame = {
					order = 13,
					type = "toggle",
					name = L["Always show icons with full opacity and size"],
					desc = L["Icons will not change on nontargeted nameplates.\n\n|cFFFF0000REALLY NOT RECOMMEND|r\nWhen icons overlay there will be mess of textures, digits etc."],
					width = "full",
					set = function(info, value)
						db[info[#info]] = value
						for n, frame in ipairs(C_NamePlate.GetNamePlates()) do
							if frame.fPBiconsFrame and frame.fPBiconsFrame.iconsFrame then
								frame.fPBiconsFrame:SetParent(value and WorldFrame or frame)
							end
						end
					end,
				},
			},
		},
		sortSettings = {
			order = 4,
			name = L["Sorting"],
			type = "group",
			args = {
				disableSort = {
					order = 0.1,
					type = "toggle",
					name = L["Disable sorting"],
					width = "full",
					set = function(info, value)
						db[info[#info]] = value
						UpdateAllNameplates()
						if value == false and not CheckSort() then
							db.sortMode[1] = "my"
							db.sortMode[2] = "expiration"
						end
					end,
					},
				header = {
					order = 0.2,
					type = "header",
					name = L["Priority"],
				},
				sort1 = {
					order = 1,
					type = "select",
					style = "dropdown",
					disabled = function() return db.disableSort end,
					name = "",
					width = "double",
					values = {
						["type"] = L["Debuff > Buff"],
						["expiration"] = L["Remaining duration"],
						["my"] = L["My spell"],
						["scale"] = L["Icon scale (Importance)"],
						["disable"] = DISABLE,
					},
					set = function(info,val)
						db.sortMode[1] = val
						if not CheckSort() then
							db.disableSort = true
						end
						UpdateAllNameplates()
					end,
					get = function(info) return db.sortMode[1] end,
				},
				reverse1 = {
					order = 1.5,
					type = "toggle",
					disabled = function() return db.disableSort end,
					name = L["Reverse"],
					set = function(info,val) db.sortMode[1.5] = val;UpdateAllNameplates() end,
					get = function(info) return db.sortMode[1.5] end,
				},
				sort2 = {
					order = 2,
					type = "select",
					style = "dropdown",
					disabled = function() return db.disableSort end,
					name = "",
					width = "double",
					values = {
						["type"] = L["Debuff > Buff"],
						["expiration"] = L["Remaining duration"],
						["my"] = L["My spell"],
						["scale"] = L["Icon scale (Importance)"],
						["disable"] = DISABLE,
					},
					set = function(info,val)
						db.sortMode[2] = val
						if not CheckSort() then
							db.disableSort = true
						end
						UpdateAllNameplates()
					end,
					get = function(info) return db.sortMode[2] end,
				},
				reverse2 = {
					order = 2.5,
					type = "toggle",
					disabled = function() return db.disableSort end,
					name = L["Reverse"],
					set = function(info,val) db.sortMode[2.5] = val;UpdateAllNameplates() end,
					get = function(info) return db.sortMode[2.5] end,
				},
				sort3 = {
					order = 3,
					type = "select",
					style = "dropdown",
					disabled = function() return db.disableSort end,
					name = "",
					width = "double",
					values = {
						["type"] = L["Debuff > Buff"],
						["expiration"] = L["Remaining duration"],
						["my"] = L["My spell"],
						["scale"] = L["Icon scale (Importance)"],
						["disable"] = DISABLE,
					},
					set = function(info,val)
						db.sortMode[3] = val
						if not CheckSort() then
							db.disableSort = true
						end
						UpdateAllNameplates()
					end,
					get = function(info) return db.sortMode[3] end,
				},
				reverse3 = {
					order = 3.5,
					type = "toggle",
					disabled = function() return db.disableSort end,
					name = L["Reverse"],
					set = function(info,val) db.sortMode[3.5] = val;UpdateAllNameplates() end,
					get = function(info) return db.sortMode[3.5] end,
				},
				sort4 = {
					order = 4,
					type = "select",
					style = "dropdown",
					disabled = function() return db.disableSort end,
					name = "",
					width = "double",
					values = {
						["type"] = L["Debuff > Buff"],
						["expiration"] = L["Remaining duration"],
						["my"] = L["My spell"],
						["scale"] = L["Icon scale (Importance)"],
						["disable"] = DISABLE,
					},
					set = function(info,val)
						db.sortMode[4] = val
						if not CheckSort() then
							db.disableSort = true
						end
						UpdateAllNameplates()
					end,
					get = function(info) return db.sortMode[4] end,
				},
				reverse4 = {
					order = 4.5,
					type = "toggle",
					disabled = function() return db.disableSort end,
					name = L["Reverse"],
					set = function(info,val) db.sortMode[4.5] = val;UpdateAllNameplates() end,
					get = function(info) return db.sortMode[4.5] end,
				},
			},
		},
		CVarSettings = {
			order = 5,
			name = L["CVars & Other"],
			desc = L["Some nameplate related Console Variables"],
			type = "group",
			args = {
				nameplateMaxDistance = {
					order = 1,
					type = "range",
					name = L["Nameplate visible distance"],
					desc = L["Changes CVar \"nameplateMaxDistance\".\nLegion default = 60. Old default = 40."],
					min = 20,
					max = 100,
					step = 5,
					get = function(info)
						return db.nameplateMaxDistance and db.nameplateMaxDistance or tonumber(GetCVar("nameplateMaxDistance"))
					end,
					set = function(info, value)
						db.nameplateMaxDistance = value
						SetCVar("nameplateMaxDistance", value)
					end,
				},
				resetMaxDistance = {
					order = 2,
					type = "execute",
					name = L["Reset to default"],
					desc = L["Addon will no longer control this CVar on login"],
					func = function(info)
						db.nameplateMaxDistance = false
						SetCVar("nameplateMaxDistance", GetCVarDefault("nameplateMaxDistance"))
					end,
				},
				blank1 = {
					order = 3,
					type = "description",
					name = "",
					width = "normal",
				},
				nameplateInset = {
					order = 4,
					type = "toggle",
					name = L["Stops nameplates from clamping to the screen"],
					desc = L["Sets CVars \"nameplateOtherTopInset\" and \"nameplateOtherBottomInset\" to -1"],
					width = "full",
					get = function(info)
						return db.nameplateInset or ((GetCVar("nameplateOtherTopInset") == "-1") and (GetCVar("nameplateOtherBottomInset") == "-1"))
					end,
					set = function(info, value)
						if value then
							db.nameplateInset = true
							SetCVar("nameplateOtherTopInset", -1)
							SetCVar("nameplateOtherBottomInset", -1)
						else
							db.nameplateInset = false
							for _, v in pairs({"nameplateOtherTopInset", "nameplateOtherBottomInset"}) do
								SetCVar(v, GetCVarDefault(v))
							end
						end
					end,
				},
				fixNames = {
					order = 5,
					type = "toggle",
					name = L["Fix nameplates without names"],
					width = "full",
				},
				save = {
					order = 6,
					type = "execute",
					name = L["Save CVars"],
					desc = L["ReloadUI"],
					confirm = true,
					func = function()
						ReloadUI()
					end,
				},
			},
		},
	},
}

local newSpellName

fPB.SpellsTable = {
	name = L["Specific spells"],
	type = "group",
	childGroups = "tree",
	args = {
		addSpell = {
			order = 1,
			type = "input",
			name = L["Add new spell to list"],
			desc = L["Enter spell ID or name (case sensitive)\nand press OK"],
			set = function(info, value)
				if value then
					local spellID = tonumber(value)
					if spellID then
						local spellName = GetSpellInfo(spellID)
						if spellName then
							newSpellName = spellName
							fPB.AddNewSpell(spellID)
						end
					else
						newSpellName = value
						fPB.AddNewSpell(newSpellName)
					end
				end
			end,
			get = function(info)
				return newSpellName
			end,
		},
		blank = {
			order = 2,
			type = "description",
			name = "",
			width = "normal",
		},
		showSpellID = {
			type = "toggle",
			order = 3,
			name = L["Show spell ID in tooltips"],
			desc = L["Usefull for configuring spell list.\nRequires ReloadUI to turn off."],
			get = function(info)
				return db[info[#info]]
			end,
			set = function(info,value)
				db.showSpellID = value
				if value then
					fPB.ShowSpellID()
				end
			end,
		},

		-- fills up with BuildSpellList()
	},
}

local color
local iconTexture
local TextureStringCache = {}
local description
local function TextureString(spellID)
	if not tonumber(spellID) then
		return "\124TInterface\\Icons\\Inv_misc_questionmark:0\124t"
	elseif TextureStringCache[spellID] then
		return TextureStringCache[spellID]
	else
		_,_,iconTexture = GetSpellInfo(spellID)
		if iconTexture then
			iconTexture = "\124T"..iconTexture..":0\124t"
			TextureStringCache[spellID] = iconTexture
			return iconTexture
		else
			return "\124TInterface\\Icons\\Inv_misc_questionmark:0\124t"
		end
	end
end
local function SortSpellList(a,b)
	if (a and b) then
		local Spells = db.Spells
		a = tostring(Spells[a].name or a)
		b = tostring(Spells[b].name or b)
		if a ~= b then
			return a < b
		end
	end
end
function fPB.BuildSpellList()
	local spellTable = fPB.SpellsTable.args
	for item in pairs(spellTable) do
		if item ~= "addSpell" and item ~= "blank" and item ~= "showSpellID" then
			spellTable[item] = nil
		end
	end
	local Spells = db.Spells
	local Ignored = db.ignoredDefaultSpells
	local spellList = {}
	for spell in pairs(Spells) do
		if not Ignored[spell] then
			table_insert(spellList, spell)
		end
	end
	table_sort(spellList,SortSpellList)

	for i = 1, #spellList do
		local s = spellList[i]
		local Spell = Spells[s]
		local name = Spell.name
		local SpellID = Spell.spellID
		if Spell.show == 1 then
			color = "|cFF00FF00" --green
		elseif Spell.show == 3 then
			color = "|cFFFF0000" --red
		else
			color = "|cFFFFFF00" --yellow
		end

		iconTexture = TextureString(SpellID)

		if tonumber(SpellID) then
			tooltip:SetHyperlink("spell:"..SpellID)
			local lines = tooltip:NumLines()
			if lines > 0 then
				spellDesc = _G[AddonName.."TooltipTextLeft"..lines] and _G[AddonName.."TooltipTextLeft"..lines]:GetText() or "??"
			end
		else
			spellDesc = L["No spell ID"]
		end

		local buildName = iconTexture.." "..color..name.." (x"..(Spell.scale and Spell.scale or "1")..")"
		if tonumber(SpellID) then
			buildName = buildName.."  id:"..SpellID.."|r"
		else
			buildName = buildName.."|r"
		end

		spellTable[tostring(s)] = {
			name = buildName,
			desc = spellDesc,
			type = "group",
			order = 10 + i,
			get = function(info)
				return Spell[info[2]]
			end,
			set = function(info, value)
				Spell[info[2]] = value
				fPB.BuildSpellList()
				UpdateAllNameplates()
			end,
			args = {
				show = {
					order = 1,
					name = L["Show"],
					type = "select",
					style = "dropdown",
					values = {
						L["Always"],
						L["Only mine"],
						L["Never"],
						L["On ally only"],
						L["On enemy only"],
					},
				},
				scale = {
					order = 2,
					name = L["Icon scale"],
					type = "range",
					min = 0.1,
					max = 5,
					softMin = 0.5,
					softMax  = 3,
					step = 0.01,
					bigStep = 0.1,
				},
				stackSize = {
					order = 3,
					name = L["Stack font size"],
					type = "range",
					min = minTextSize,
					max = maxTextSize,
					step = 1,
				},
				durationSize = {
					order = 4,
					name = L["Duration font size"],
					type = "range",
					min = minTextSize,
					max = maxTextSize,
					step = 1,
				},
				spellID = {
					order = 5,
					type = "input",
					name = L["Spell ID"],
					get = function(info)
						return Spell.spellID and tostring(Spell.spellID) or L["No spell ID"]
					end,
					set = function(info, value)
						if value then
							local spellID = tonumber(value)
							if spellID then
								local spellName = GetSpellInfo(spellID)
								if spellName then
									if spellID ~= Spell.spellID and spellName == Spell.name then	-- correcting or adding the id
										fPB.ChangeSpellID(s, spellID)
									elseif spellID ~= Spell.spellID and spellName ~= Spell.name then
										DEFAULT_CHAT_FRAME:AddMessage(spellID..chatColor..L[" It is ID of completely different spell "]..linkColor.."|Hspell:"..spellID.."|h["..GetSpellInfo(spellID).."]|h"..chatColor..L[". You can add it by using top editbox."])
									end
								else
									DEFAULT_CHAT_FRAME:AddMessage(tostring(spellID)..chatColor..L[" Incorrect ID"])
								end
							else
								DEFAULT_CHAT_FRAME:AddMessage(tostring(spellID)..chatColor..L[" Incorrect ID"])
							end
						fPB.BuildSpellList()
						UpdateAllNameplates()
						end
					end,
				},
				checkID = {
					order = 6,
					type = "toggle",
					name = L["Check spell ID"],
					set = function(info, value)
						if value and not Spell.spellID then
							Spell.checkID = nil
							DEFAULT_CHAT_FRAME:AddMessage(tostring(spellID)..chatColor..L[" Incorrect ID"])
						else
							Spell.checkID = value
						end
						fPB.CacheSpells()
						UpdateAllNameplates()
					end,
				},
				removeSpell = {
					order = 7,
					type = "execute",
					name = L["Remove spell"],
					confirm = true,
					func = function(info)
						fPB.RemoveSpell(s)
					end,
				},
			},
		}
	end
end

