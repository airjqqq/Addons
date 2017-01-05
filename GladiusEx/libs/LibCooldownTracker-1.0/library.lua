--[[
	Callbacks:
		LCT_CooldownUsed(unitid, spellid)
		LCT_CooldownsReset(unit)

	Functions:
		lib:RegisterUnit(unitid)
		lib:UnregisterUnit(unitid)
		tpu = lib:GetUnitCooldownInfo(unitid, spellid, used_start, used_end, cooldown_start)
		for spellid, spell_data in lib:IterateCooldowns(class, specID, race) do
		spell_data = lib:GetCooldownData(spellid)
		spells_data = lib:GetCooldownsData()
]]

local version = 10
local lib = LibStub:NewLibrary("LibCooldownTracker-1.0", version)
local fn = LibStub("LibFunctional-1.0")

if not lib then return end

-- upvalues
local pairs, type, next, select, assert, unpack = pairs, type, next, select, assert, unpack
local tinsert, tremove = table.insert, table.remove
local GetTime, UnitGUID, IsInInstance = GetTime, UnitGUID, IsInInstance

lib.frame = lib.frame or CreateFrame("Frame")
lib.callbacks = lib.callbacks or LibStub("CallbackHandler-1.0"):New(lib)

-- init event handler
local events = {}
do
	lib.frame:SetScript("OnEvent",
		function(self, event, ...)
			return events[event](lib, event, ...)
		end)
end

-- lookup tables
local class_spelldata = {}
local item_spelldata = {}
local race_spelldata = {}

-- generate lookup tables
do
	for spellid, spelldata in pairs(LCT_SpellData) do
		if type(spelldata) == "table" then
			local name, _, icon = GetSpellInfo(spellid)
			if not name then
				DEFAULT_CHAT_FRAME:AddMessage("LibCooldownTracker-1.0: bad spellid for " .. (spelldata.class or spelldata.race or "ITEM") .. ": " .. spellid)
				LCT_SpellData[spellid] = nil
			else
				-- add name and icon
				spelldata.name = name
				spelldata.icon = icon

				-- add required aura name
				if spelldata.requires_aura then
					spelldata.requires_aura_name = GetSpellInfo(spelldata.requires_aura)
					if not spelldata.requires_aura_name then
						DEFAULT_CHAT_FRAME:AddMessage("LibCooldownTracker-1.0: bad aura spellid: " .. spelldata.requires_aura)
					end
				end

				-- convert specID list into lookups table
				if spelldata.specID then
					local specs = {}
					for i = 1, #spelldata.specID do
						specs[spelldata.specID[i]] = true
					end
					spelldata.specID_table = specs
				end

				-- insert into lookup tables
				if spelldata.class then
					class_spelldata[spelldata.class] = class_spelldata[spelldata.class] or {}
					class_spelldata[spelldata.class][spellid] = spelldata
				end
				if spelldata.race then
					race_spelldata[spelldata.race] = race_spelldata[spelldata.race] or {}
					race_spelldata[spelldata.race][spellid] = spelldata
				end
				if spelldata.item then
					item_spelldata[spellid] = spelldata
				end
			end
		end
	end
end

local SpellData = LCT_SpellData
LCT_SpellData = nil

-- state
lib.guid_to_unitid = lib.guid_to_unitid or {} -- [guid] = unitid
lib.tracked_players = lib.tracked_players or {} --[[
	[unitid][spellid] = {
		["cooldown_start"] = time,
		["cooldown_end"] = time,
		["used_start"] = time,
		["used_end"] = time,
		["detected"] = boolean,
		[EVENT] = time
	}
]]
lib.registered_units = lib.registered_units or {} -- [unitid] = count

local function RemoveGUID(unit)
	-- find and delete old references to that unit
	for guid, unitid in pairs(lib.guid_to_unitid) do
		if unitid == unit then
			lib.guid_to_unitid[guid] = nil
		end
	end
end

local function UpdateGUID(unit)
	RemoveGUID(unit)

	local guid = UnitGUID(unit)
	if guid then lib.guid_to_unitid[guid] = unit end

	local pet_guid = UnitGUID(unit .. "pet")
	if pet_guid then lib.guid_to_unitid[pet_guid] = unit end
end

-- simple timer used for updating number of charges
-- timers are stored ordered by their firing time so only the first
-- timer on the list is checked in the OnUpdate
local timers = {}
local timer_frame

local function Timer_OnUpdate()
	local t1 = timers[1]
	if GetTime() >= t1.time then
		tremove(timers, 1)
		t1.func(unpack(t1.args))
		if #timers == 0 then
			lib.frame:SetScript("OnUpdate", nil)
		end
	end
end

local function SetTimer(time, func, ...)
	local pos = 1
	while pos <= #timers do
		if timers[pos].time >= time then
			break
		end
		pos = pos + 1
	end

	tinsert(timers, pos, { time = time, func = func, args = { ... } })

	if #timers == 1 then
		lib.frame:SetScript("OnUpdate", Timer_OnUpdate)
	end

	return pos
end

local function ClearTimers()
	lib.frame:SetScript("OnUpdate", nil)
	timers = {}
end

local function GetSpellData(spellid)
	local data = SpellData[spellid]
	if not data then return end
	if data.parent then
		spellid = data.parent
		local parentData = SpellData[spellid]
		data = fn:merge(parentData,data)
		data.parent = parentData.parent
	end
	return data
end

local function AddCharge(unit, spellid)
	local tps = lib.tracked_players[unit][spellid]
	tps.charges = tps.charges + 1
	lib.callbacks:Fire("LCT_CooldownUsed", unit, spellid)

	-- schedule another timer if there are more charges in cooldown
	if tps.charges < tps.max_charges then
		local now = GetTime()
		local spelldata = GetSpellData(spellid)
		tps.cooldown_start = now
		tps.cooldown_end = now + type(spelldata.cooldown) == "table" and spelldata.cooldown.default or spelldata.cooldown
		tps.charge_timer = SetTimer(tps.cooldown_end, AddCharge, unit, spellid)
	else
		tps.charge_timer = false
	end
end


local function CooldownEvent(event, unit, spellid)
	local spelldata = GetSpellData(spellid)
	if not spelldata then return end

	-- if spelldata.parent then
	-- 	spellid = spelldata.parent
	-- 	spelldata = SpellData[spellid]
	-- end

	-- if type(spelldata) == "number" then
	-- 	spellid = spelldata
	-- 	spelldata = SpellData[spelldata]
	-- end

	if lib:IsUnitRegistered(unit) then
		local now = GetTime()

		if not lib.tracked_players[unit] then
			lib.tracked_players[unit] = {}
		end

		local tpu = lib.tracked_players[unit]

		if tpu[spellid] then
			-- check if the same spell cast was detected recently
			-- if so, we assume that the first detection time is more accurate and ignore this one
			-- this can happen because we listen to both UNIT_SPELLCAST_SUCCEEDED and SPELL_CAST_SUCCESS from COMBAT_LOG_EVENT_UNFILTERED
			-- and because both SPELL_CAST_SUCCESS and SPELL_AURA_APPLIED are considered events for cooldown uses
			local margin = 1
			if event == "UNIT_SPELLCAST_SUCCEEDED" or event == "SPELL_CAST_SUCCESS" or event == "SPELL_AURA_APPLIED" then
				if (event ~= "UNIT_SPELLCAST_SUCCEEDED" and tpu[spellid]["UNIT_SPELLCAST_SUCCEEDED"] and (tpu[spellid]["UNIT_SPELLCAST_SUCCEEDED"] + margin) > now) or
				   (event ~= "SPELL_AURA_APPLIED"       and tpu[spellid]["SPELL_AURA_APPLIED"]       and (tpu[spellid]["SPELL_AURA_APPLIED"]       + margin) > now) or
				   (event ~= "SPELL_CAST_SUCCESS"       and tpu[spellid]["SPELL_CAST_SUCCESS"]       and (tpu[spellid]["SPELL_CAST_SUCCESS"]       + margin) > now) then
					return
				end
			end

			-- register event time
			tpu[spellid][event] = now
		else
			tpu[spellid] = {
				charges = spelldata.charges or spelldata.opt_charges,
				max_charges = spelldata.charges or spelldata.opt_charges,
				charges_detected = spelldata.charges and true or false,
				[event] = now,
			}
		end
		local tps = tpu[spellid]
		tps.detected = true

		-- find what actions are needed
		local used_start, used_end, cooldown_start

		if spelldata.cooldown_starts_on_dispel then
			if event == "SPELL_DISPEL" then
				used_start = true
				cooldown_start = true
			end
		elseif spelldata.cooldown_starts_on_aura_fade then
			if event == "UNIT_SPELLCAST_SUCCEEDED" or event == "SPELL_CAST_SUCCESS" or event == "SPELL_AURA_APPLIED" then
				used_start = true
			elseif event == "SPELL_AURA_REMOVED" then
				cooldown_start = true
			end
		else
			if event == "UNIT_SPELLCAST_SUCCEEDED" or event == "SPELL_CAST_SUCCESS" or event == "SPELL_AURA_APPLIED" then
				used_start = true
				cooldown_start = true
			elseif event == "SPELL_AURA_REMOVED" then
				used_end = true
			end
		end

		-- apply actions
		if used_start then
			tps.used_start = now
			tps.used_end = spelldata.duration and (now + spelldata.duration)

			-- remove charge
			if tps.charges then
				tps.charges = tps.charges - 1
				-- if cooldown is still in progress and the spell can optionally have charges (with a glyph or talent),
				--  then it must have charges
				if not tps.charges_detected and tps.cooldown_end and (tps.cooldown_end - 2) > now then
					tps.charges_detected = true
					if spelldata.opt_charges_linked then
						for i = 1, #spelldata.opt_charges_linked do
							local lspellid = spelldata.opt_charges_linked[i]
							local lspelldata = SpellData[lspellid]
							if not tpu[lspellid] then
								tpu[lspellid] = {
									charges = lspelldata.opt_charges,
									max_charges = lspelldata.opt_charges,
								}
							end
							tpu[lspellid].charges_detected = true
						end
					end
				end
			end

			-- reset other cooldowns (Cold Snap, Preparation)
			if spelldata.resets then
				for i = 1, #spelldata.resets do
					local rspellid = spelldata.resets[i]
					if tpu[rspellid] then
						tpu[rspellid].cooldown_start = 0
						tpu[rspellid].cooldown_end = 0
					end
				end
			end

			-- replaces or talent to diable others detected
			if (spelldata.replaces or spelldata.talent) then
				-- remove replaced spell if detected
				for i,v in ipairs(fn:merge(spelldata.talent or {},spelldata.replaces or {})) do
					if tpu[v] then
						tpu[v].detected = false
					end
				end
			end
		end

		if used_end then
			tps.used_end = now
		end

		if cooldown_start then
			-- if the spell has charges and the cooldown is already in progress, it does not need to be reset
			if not tps.charges or not tps.cooldown_end or tps.cooldown_end <= now then
				local cooldown = type(spelldata.cooldown) == "table" and spelldata.cooldown.default or spelldata.cooldown
				tps.cooldown_start = cooldown and now
				tps.cooldown_end = cooldown and (now + cooldown)

				-- set charge timer
				if tps.charges and not tps.charge_timer then
					tps.charge_timer = SetTimer(tps.cooldown_end, AddCharge, unit, spellid)
				end

				-- set other cooldowns
				if spelldata.sets_cooldown then
					for i,v in ipairs(spelldata.sets_cooldown) do
						local cspellid = v.spellid
						local cspelldata = GetSpellData(cspellid)
						if (tpu[cspellid] and tpu[cspellid].detected) or (not cspelldata.talent and not cspelldata.glyph) then
							if not tpu[cspellid] then
								tpu[cspellid] = {}
							end
							if not tpu[cspellid].cooldown_end or (tpu[cspellid].cooldown_end < (now + v.cooldown)) then
								tpu[cspellid].cooldown_start = now
								tpu[cspellid].cooldown_end = now + v.cooldown
								tpu[cspellid].used_start = tpu[cspellid].used_start or 0
								tpu[cspellid].used_end = tpu[cspellid].used_end or 0
							end
						end
					end
				end
			end
		end

		lib.callbacks:Fire("LCT_CooldownUsed", unit, spellid, used_start, used_end, cooldown_start)
	end
end

local function enable()
	lib.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	lib.frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	lib.frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	lib.frame:RegisterEvent("UNIT_NAME_UPDATE")

	lib.tracked_players = {}
	lib.guid_to_unitid = {}

	for unitid in pairs(lib.registered_units) do
		UpdateGUID(unitid)
	end
end

local function disable()
	lib.frame:UnregisterAllEvents()
end

function lib.callbacks:OnUsed(target, event)
	if event == "LCT_CooldownUsed" then
		enable()
	end
end

function lib.callbacks:OnUnused(target, event)
	if event == "LCT_CooldownUsed" then
		disable()
	end
end

--- Registers an unit to be tracked by the library.
-- @param unitid The unitid to register.
function lib:RegisterUnit(unitid)
	local count = (lib.registered_units[unitid] or 0) + 1
	if count == 1 then
		UpdateGUID(unitid)
	end
	lib.registered_units[unitid] = count
	return count
end

--- Unregisters an unit.
-- While the same unit may be registered more than once, it is important that
-- UnregisterUnit is called exactly once for each call to RegisterUnit.
-- @param unitid The unitid to unregister.
function lib:UnregisterUnit(unitid)
	assert(lib.registered_units[unitid] ~= nil, "Attempting to unregister a unit not registered")

	local count = lib.registered_units[unitid] - 1
	if count == 0 then
		lib.registered_units[unitid] = nil
		RemoveGUID(unitid)
	else
		lib.registered_units[unitid] = count
	end
	return count
end

function lib:IsUnitRegistered(unitid)
	return lib.registered_units[unitid]
end

--- Returns a table with the state of a unit's cooldown, or nil if there is no state stored about it.
-- @param unitid The unit unitid.
-- @param spellid The cooldown spellid.
-- @usage
-- local tracked = lib:GetUnitCooldownInfo(unitid, spellid)
-- if tracked then
--     print(tracked.cooldown_start) -- times are based on GetTime()
--     print(tracked.cooldown_end)
--     print(tracked.used_start)
--     print(tracked.used_end)
--     print(tracked.detected) -- use this to check if the unit has used this spell before (useful for detecting talents/glyphs)
-- end
function lib:GetUnitCooldownInfo(unitid, spellid)
	local tpu = lib.tracked_players[unitid]
	return tpu and tpu[spellid]
end

--- Returns the raw data of all the cooldowns. See the cooldowns_*.lua data files for more details about its structure.
function lib:GetCooldownsData()
	return SpellData
end

--- Returns the raw data of a specified cooldown spellid.
-- @param spellid The cooldown spellid.
function lib:GetCooldownData(spellid)
	return GetSpellData(spellid)
end

local function CooldownIterator(state, spellid)
	while true do
		spellid = next(state.data_source, spellid)
		if spellid == nil then
			return
		end
		local spelldata = state.data_source[spellid]
		-- ignore references to other spells
		if type(spelldata) ~= "number" then
			if state.class and state.class == spelldata.class then
				if state.specID and spelldata.specID_table and spelldata.specID_table[state.specID] then
					-- add spec
					return spellid, spelldata
				elseif not spelldata.specID then
					-- add base
					return spellid, spelldata
				end
			end

			if state.race and state.race == spelldata.race then
				-- return racial
				return spellid, spelldata
			end

			if spelldata.item then
				-- return item
				return spellid, spelldata
			end
		end
	end
end

-- uses lookup tables
local function FastCooldownIterator(state, spellid)
	local spelldata
	-- class
	if state.class then
		if state.data_source then
			spellid, spelldata = CooldownIterator(state, spellid)
		end

		if spellid then
			return spellid, spelldata
		else
			-- do race next
			state.data_source = race_spelldata[state.race]
			state.class = nil
			spellid = nil
		end
	end

	-- race
	if state.race then
		if state.data_source then
			spellid, spelldata = CooldownIterator(state, spellid)
		end

		if spellid then
			return spellid, spelldata
		else
			-- do items next
			state.data_source = item_spelldata
			state.race = nil
			spellid = nil
		end
	end

	-- item
	if state.item and state.data_source then
		spellid, spelldata = CooldownIterator(state, spellid)
		return spellid, spelldata
	end
end

--- Iterates over the cooldowns that apply to a unit of the specified //class//, //specID// and //race//.
-- @param class The unit class. Can be nil.
-- @param specID The unit talent spec ID. Can be nil.
-- @param race The unit race. Can be nil.
function lib:IterateCooldowns(class, specID, race)
	local state = {}
	state.class = class
	state.specID = specID
	state.race = race or ""
	state.item = true

	if class then
		state.data_source = class_spelldata[state.class]
		return FastCooldownIterator, state
	else
		state.data_source = SpellData
		return CooldownIterator, state
	end
end

function events:PLAYER_ENTERING_WORLD()
	local instanceType = select(2, IsInInstance())

	-- reset cooldowns when joining an arena
	if instanceType == "arena" then
		ClearTimers()
		for unit in pairs(lib.tracked_players) do
			lib.tracked_players[unit] = nil
			lib.callbacks:Fire("LCT_CooldownsReset", unit)
		end
	end
end

function events:UNIT_SPELLCAST_SUCCEEDED(event, unit, spellName, rank, lineID, spellId)
	CooldownEvent(event, unit, spellId)
end


local ccauraids = {
	[ 64695] = 5,	-- Earthgrab
	--[113770] = 5,	-- Entangling Roots (Force of Nature)
	[ 33395] = 8,	-- Freeze (Water Elemental)
	[   122] = 8,	-- Frost Nova
	--[102051] = 5,	-- Frostjaw
	[102359] = 8,	-- Mass Entanglement
	[136634] = 8,	-- Narrow Escape
	[105771] = 1.5,	-- Warbringer

	-- Silence Auras (8)
	[  1330] = 3,	-- Garrote (Silence)
	[ 15487] = 5,	-- Silence
	[ 47476] = 5,	-- Strangulate
	[ 28730] = 2,	-- Arcane Torrent (Mana version)
	[ 80483] = 2,	-- Arcane Torrent (Focus version)
	[ 25046] = 2,	-- Arcane Torrent (Energy version)
	[ 50613] = 2,	-- Arcane Torrent (Runic Power version)
	[ 69179] = 2,	-- Arcane Torrent (Rage version)
	-- Disorients & Stuns Auras (9)
	[108194] = 5,	-- Asphyxiate
	[ 91800] = 1,	-- Gnaw (Ghoul)
	[ 91797] = 2,	-- Monstrous Blow (Dark Transformation Ghoul)
	[ 89766] = 4,	-- Axe Toss (Felguard)
	[117526] = 3,	-- Binding Shot
	[224729] = 4,	-- Bursting Shot
	[213691] = 4,	-- Scatter Shot
	[ 24394] = 5,	-- Intimidation
	[105421] = 6,	-- Blinding Light
	--[119392] = 9,	-- Charging Ox Wave
	[  1833] = 4,	-- Cheap Shot
	--[118895] = 9,	-- Dragon Roar
	[ 77505] = 1.5,	-- Earthquake
	[120086] = 4,	-- Fist of Fury
	--[44572] = 9,	-- Deep Freeze
	[    99] = 3,	-- Disorienting Roar
	[ 31661] = 4,	-- Dragon's Breath
	--[123393] = 9,	-- Breath of Fire (Glyphed)
	--[105593] = 9,	-- Fist of Justice
	[ 47481] = 1,	-- Gnaw
	[  1776] = 4,	-- Gouge
	[   853] = 6,	-- Hammer of Justice
	--[119072] = 9,	-- Holy Wrath
	[ 88625] = 5,	-- Holy Word: Chastise
	[ 19577] = 5,	-- Intimidation
	-- [408] = 9,	-- Kidney Shot
	[119381] = 5,	-- Leg Sweep
	-- [22570] = 9,	-- Maim
	[  5211] = 5,	-- Mighty Bash
	--[113801] = 9,	-- Bash (Treants)
	[118345] = 4,	-- Pulverize (Primal Earth Elemental)
	--[115001] = 9,	-- Remorseless Winter
	[ 30283] = 4,	-- Shadowfury
	[ 22703] = 2,	-- Summon Infernal
	[ 46968] = 4,	-- Shockwave
	[118905] = 5,	-- Static Charge (Capacitor Totem Stun)
	[132169] = 4,	-- Storm Bolt
	[ 20549] = 2,	-- War Stomp
	[ 16979] = 4,	-- Wild Charge
	[117526] = 3,    -- Binding Shot
	[163505] = 4,    -- Rake
	-- Crowd Controls Auras (10)
	-- [710] = 10,	-- Banish
	[  2094] = 8,	-- Blind
	--[137143] = 10,	-- Blood Horror
	[ 33786] = 6,	-- Cyclone
	[   605] = 8,	-- Dominate Mind
	[118699] = 6,	-- Fear
	[  3355] = 8,	-- Freezing Trap
	[ 51514] = 8,	-- Hex
	[  5484] = 6,	-- Howl of Terror
	[  5246] = 8,	-- Intimidating Shout
	[115268] = 8,	-- Mesmerize (Shivarra)
	[  6789] = 3,	-- Mortal Coil
	[115078] = 4,	-- Paralysis
	[   118] = 8,	-- Polymorph
	[  8122] = 8,	-- Psychic Scream
	[ 64044] = 4,	-- Psychic Horror
	[ 20066] = 6,	-- Repentance
	[ 82691] = 8,	-- Ring of Frost
	[  6770] = 8,	-- Sap
	[107079] = 4,	-- Quaking Palm
	--[10326] = 10,	-- Turn Evil
	[ 19386] = 8,	-- Wyvern Sting
}
local ccauranames = {}
for id,v in pairs (ccauraids) do
	local name = GetSpellInfo(id)
	if name then
		ccauranames[name] = v
	end
end
function events:COMBAT_LOG_EVENT_UNFILTERED(_, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool)

	do --rellss
		local unit = lib.guid_to_unitid[destGUID]
		if unit and event == "SPELL_AURA_APPLIED" then
			if ccauranames[spellName] then
				local maxD = ccauranames[spellName]
				local duration = select(6,UnitDebuff(unit,spellName))
				if duration then
					if duration/0.8 == maxD or duration*2/0.8 == maxD or duration*4/0.8 == maxD then
	 					CooldownEvent("SPELL_CAST_SUCCESS", unit, 196029)
					end
				end
			end
			if spellId == 195901 then
				CooldownEvent("SPELL_CAST_SUCCESS", unit, 214027)
			end
		end
	end


	-- check unit
	local unit = lib.guid_to_unitid[sourceGUID]
	if not unit then return end

	-- check spell
	local spelldata = SpellData[spellId]
	if not spelldata then return end

	if event == "SPELL_DISPEL" or
	   event == "SPELL_AURA_REMOVED" or
	   event == "SPELL_AURA_APPLIED" or
	   event == "SPELL_CAST_SUCCESS" then
		CooldownEvent(event, unit, spellId)
	end
end

function events:UNIT_NAME_UPDATE(event, unit)
	UpdateGUID(unit)
end
