-- Implemented by MrCool (EU, FR, Hyjal, main character: Eilylune)

local data = PVPTooltips_Data;
local secondaryData = PVPTooltips_SecondaryData;
local patch = PVPTooltips_Patch[GetLocale():sub(1, 2)] or {};
local templates = PVPTooltips_Templates;
local history = PVPTooltips_History;
local version = GetAddOnMetadata("PVPTooltips", "Version");

-- PART 1 - Tooltips

local TEMPLATE_SPELL_ID1 = 197912;
local TEMPLATE_SPELL_ID2 = 228696;
local TEMPLATE_DEFAULT = 1.00;
local TEMPLATE_CASTER_DEFAULT = 1.35;
local TEMPLATE_STATS = { "primary", "stamina", "crit", "haste", "versatility", "mastery", "damage", "armor", "regen", "vulnerability" };
local TEMPLATE_TRANSLATIONS = {
	damage = DAMAGE,
	primary1 = ITEM_MOD_STRENGTH_SHORT,
	primary2 = ITEM_MOD_AGILITY_SHORT,
	primary4 = ITEM_MOD_INTELLECT_SHORT,
	stamina = ITEM_MOD_STAMINA_SHORT,
	armor = ARMOR,
	regen = ITEM_MOD_MANA_REGENERATION_SHORT,
	versatility = ITEM_MOD_VERSATILITY,
	mastery = ITEM_MOD_MASTERY_RATING_SHORT,
	crit = ITEM_MOD_CRIT_RATING_SHORT,
	haste = ITEM_MOD_HASTE_RATING_SHORT,
	vulnerability = GetSpellInfo(170967)
};

-- Create array of specialization IDs

local SPECIALIZATIONS = { };
local MATCHES = { };
do
	for k in pairs(templates) do
		tinsert(SPECIALIZATIONS, k);
	end
	table.sort(SPECIALIZATIONS);
end

local function EvaluateSpecFilter(spec)
	local isMatch, filterText = true, "";
	if spec then
		-- Compute filter text
		wipe(MATCHES);
		local id, name, _, _, _, class = GetSpecializationInfoByID(abs(spec));
		if spec > 0 then
			tinsert(MATCHES, name);
		else
			for _, otherId in ipairs(SPECIALIZATIONS) do
				local _, otherName, _, _, _, otherClass = GetSpecializationInfoByID(otherId);
				if otherId ~= id and class == otherClass then
					tinsert(MATCHES, otherName);
				end
			end
		end
		filterText = " (" .. table.concat(MATCHES, ", ") .. ")";
		
		-- Evaluate if current spec is matching
		local currentIndex = GetSpecialization();
		local currentId = GetSpecializationInfo(currentIndex or 1);
		isMatch = (spec > 0 and currentId == spec) or (spec < 0 and currentId ~= -spec);
	end
	return isMatch, filterText;
end

-- Spell modifiers access 

local MODIFIERS = { };

local function GetModifier(id, dataset)
	if dataset == 1 then
		return data[id or 0];
	elseif dataset == 2 then
		return secondaryData[id or 0];
	else
		return nil;
	end
end

local function GetModifiers(id)
	wipe(MODIFIERS);
	local info = GetModifier(id, 1);
	if info then
		tinsert(MODIFIERS, info);
	end
	info = GetModifier(id, 2);
	if info then
		tinsert(MODIFIERS, info);
	end
	return MODIFIERS;
end

-- We need to do some annoying things to properly handle tooltip modification:
--	  Remove color text from the tooltip (occurs for artifacts) then restore it
--    Remove % and thousand separator
--    Preserve decimal separator and replace it by a dot "." so we can parse decimal numbers
--    Calculate the modified value and replace it in the original text by the localized number
--    We also need to handle small values with a decimal part and rounding errors

local TRANSFORM = { };
local KEYS = {"__a__", "__b__", "__c__", "__d__", "__e__"}; -- Should be more than enough
local PATCH = { }; -- For efficiency

local function Escape(text)
	wipe(TRANSFORM);
	text = text:gsub("|c%x%x%x%x%x%x%x%x.+|r", function(x)
		tinsert(TRANSFORM, x);
		return KEYS[#TRANSFORM];
	end);
	return text;
end

local function Unescape(text)
	for i=1, #TRANSFORM do
		text = text:gsub(KEYS[i], TRANSFORM[i]);
	end
	wipe(TRANSFORM);
	return text;
end

local function GetDecimalSeparator()
	 -- Contains no-break space (right blank)
	if IsEuropeanNumbers() then
		return "%,", "[  %%]"; -- NOTE: dot is sometimes used as decimal on some tooltips
	else
		return "%.", "[  ,%%]";
	end
end

local function Round(value, decimal)
	local d = 10 ^ decimal;
	return floor((value * d) + 0.5) / d;
end

local function WrapColor(text, multiplier)
	if multiplier >= 0 then
		if multiplier == 1 then
			return text;
		elseif multiplier < 1 then
			return "|cffff0000" .. text .. "|r";
		else
			return "|cff00ff00" .. text .. "|r";
		end
	else
		if multiplier == -1 then
			return text;
		elseif multiplier < -1 then
			return "|cffff0000" .. text .. "|r";
		else
			return "|cff00ff00" .. text .. "|r";
		end
	end
end

local function ReplaceNumber(x, value)
	local s, e;
	for i=1, #x do
		local code = x:byte(i);
		if code >= 48 and code <= 57 then
			s = s or i;
			e = i;
		end
	end
	local decimal = 0;
	if value < 1000 then decimal = 2; end
	return x:sub(1, s-1) .. BreakUpLargeNumbers(Round(value, decimal)) .. x:sub(e+1);
end

local function TransformValueText(x, multiplier)
	local decimal, pattern = GetDecimalSeparator();
	local value = x:gsub(pattern, ""):gsub(decimal, ".");
	local replacement = ReplaceNumber(x, tonumber(value) * abs(multiplier));
	--print(x, value, replacement);
	return WrapColor(replacement, multiplier);
end

local function ApplyMultiplier(patch)
	local current = 0
	return function(x)
		current = current + 1
		--print(x, current)
		for i=1, #patch, 2 do
			local position = patch[i];
			local multiplier = patch[i+1];
			
			if type(position) == "table" then
				if tContains(position, current) then
					return TransformValueText(x, multiplier);
				end
			else
				if current == position then
					return TransformValueText(x, multiplier);
				end
			end
		end
		return x
	end
end

local function PatchTooltip(patch)
	for i=1, select("#", GameTooltip:GetRegions()) do
		local region = select(i, GameTooltip:GetRegions());
		if region and region:GetObjectType() == "FontString" then
			local text = region:GetText();
			local r, g, b = region:GetTextColor();
			
			-- Identify spell description text
			if text and abs(r - 1.00) < 0.01 and abs(g - 0.82) < 0.01 and abs(b - 0.00) < 0.01 then
				--print(text);
				text = Escape(text);
				text = text:gsub("(%d[%d  ,.]*%%?)", ApplyMultiplier(patch)); -- Contains no-break space (right blank)
				text = Unescape(text);
				region:SetText(text);
			end
		end
	end
end

local function GetSuffix(filterText, details)
	local suffix = "";
	if details then suffix = " |cffffff00[" .. GetSpellInfo(details) .. "]|r"; end
	if filterText then suffix = suffix .. filterText; end
	return suffix;
end

local function UpdateTooltip(id)
	wipe(PATCH);
	
	-- If spell is unspecified, use current spell on tooltip
	if not id then
		local _, _, spellId = GameTooltip:GetSpell();
		id = spellId;
	end

	-- Append PVP multipliers
	for _, info in ipairs(GetModifiers(id)) do
		local position = patch[id] or info[1];
		local multiplier = info[2];
		local isMatch, filterText = EvaluateSpecFilter(info[3]);

		-- Verify we are in the correct specialization for a PVP modifier to take effect
		if isMatch and multiplier ~= 1.00 then
			if IsAltKeyDown() and not UnitIsPVP("player") and not UnitIsPVPFreeForAll("player") then
				tinsert(PATCH, position);
				tinsert(PATCH, multiplier);
			end
			GameTooltip:AddLine(PVP .. HEADER_COLON .. WrapColor((" %d%%"):format((abs(multiplier) * 100) + 0.5), multiplier) .. GetSuffix(filterText, info[4]), 1, 1, 1);
			GameTooltip:AddTexture("Interface\\ICONS\\Ability_DualWield");
		end
	end
	
	if #PATCH > 0 then
		-- Patch the tooltip values
		PatchTooltip(PATCH);
	end
	
	-- Refresh tooltip
	GameTooltip:Show();
end

local function UpdateArtifact(powerID)
	local data = C_ArtifactUI.GetPowerInfo(powerID);

	if data then
		UpdateTooltip(data.spellID);
	end
end

local function UpdateAura(unit, index, filter)
	local _, _, _, _, _, _, _, _, _, _, id = UnitAura(unit, index, filter);

	-- Document Principle of War aura with template values
	if id == TEMPLATE_SPELL_ID1 or id == TEMPLATE_SPELL_ID2 then
		if UnitIsUnit(unit, "player") then
			local index = GetSpecialization();
			local id, name = GetSpecializationInfo(index or 1);
			local template = templates[id or 0];
			
			if template then
				local localizedClass, englishClass = UnitClass(unit);
				local classColor = RAID_CLASS_COLORS[englishClass];
				
				GameTooltip:AddLine(" ");
				GameTooltip:AddDoubleLine(localizedClass, name, classColor.r, classColor.g, classColor.b, classColor.r, classColor.g, classColor.b);
				--GameTooltip:AddTexture(icon);
				for _, key in ipairs(TEMPLATE_STATS) do
					local label = TEMPLATE_TRANSLATIONS[(key == "primary" and "primary"..template.stat) or key] or "?";
					local default = (key == "primary" and template.caster and TEMPLATE_CASTER_DEFAULT) or TEMPLATE_DEFAULT;
					local multiplier = template[key] or default;
					local r, g, b = 1, 1, 1;
					if multiplier > default then r, g, b = 0, 1, 0;
					elseif multiplier < default then r, g, b = 1, 0, 0; end
					if key == "vulnerability" then r, g, b = g, r, b; end
					
					if not ((key == "damage" or key == "armor" or key == "regen" or key == "vulnerability") and multiplier == default) then
						GameTooltip:AddDoubleLine(label .. HEADER_COLON, ("%d%%"):format((multiplier * 100) + 0.5), r, g, b, r, g, b);
					end
				end
				GameTooltip:Show();
			end
		else
			-- Should not occur as you can't see this aura on other players
		end
	end
end

do
	-- Setup required hooks
	hooksecurefunc(GameTooltip, "SetAction", function() UpdateTooltip(); end);
	hooksecurefunc(GameTooltip, "SetSpellBookItem", function() UpdateTooltip(); end);
	hooksecurefunc(GameTooltip, "SetSpellByID", function() UpdateTooltip(); end);
	hooksecurefunc(GameTooltip, "SetTalent", function() UpdateTooltip(); end);
	hooksecurefunc(GameTooltip, "SetShapeshift", function() UpdateTooltip(); end);
	hooksecurefunc(GameTooltip, "SetArtifactPowerByID", function(self, powerID) UpdateArtifact(powerID); end);
	hooksecurefunc(GameTooltip, "SetUnitAura", function(self, unit, index, filter) UpdateAura(unit, index, filter); end);
	hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, unit, index, filter) UpdateAura(unit, index, filter); end);
end

-- PART 2 - History

local function Write(msg)
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	else
		print(msg);
	end
end

local function GetDeltaString(old, new)
	local newStr = ("%d%%"):format(abs(new * 100) + 0.5);
	if new == old then
		return newStr;
	else
		local oldStr = ("%d%%"):format(abs(old * 100) + 0.5);
		return WrapColor(oldStr .. " → " .. newStr, abs(new) / abs(old) * (new < 0 and -1 or 1));
	end
end

local function WriteDiff(version, filter)
	local spellChanges = history.Spells[version];
	local templateChanges = history.Templates[version];
	
	if spellChanges then
		if not filter then
			Write("▪ " .. (GetSpellInfo(37197) or "Spell Changes"));
		end
	
		for _, change in ipairs(spellChanges) do
			local class = change[1];
			local spell = change[2];
			local old = change[3];
			local new = change[4];
			local dataset = change[5] or 1;
			
			-- Special case for general changes
			if class == "GENERAL" then
				class = select(2, UnitClass("player"));
			end
			
			if (not filter) or (filter == class) then
				local info = GetModifier(spell, dataset);
				local _, filterText = EvaluateSpecFilter(info[3]);
				local name, _, icon = GetSpellInfo(spell);
				local color = RAID_CLASS_COLORS[class];
				local spellIcon = ("|T%s.blp:0|t"):format(icon);
				local spellLink = (" |Hspell:%d|h|cff%02x%02x%02x[%s]|r|h"):format(spell, floor(color.r * 255), floor(color.g * 255), floor(color.b * 255), name);
				
				Write(spellIcon .. spellLink .. HEADER_COLON .. " " .. GetDeltaString(old, new) .. GetSuffix(filterText, info[4]));
			end
		end
	end
	
	if templateChanges then
		if not filter then
			Write("▪ " .. (GetSpellInfo(13824) or "Stat Changes"));
		end
	
		for _, change in ipairs(templateChanges) do
			local spec = change[1];
			local old = change[2];
			local new = change[3];
			local template = templates[spec];
			
			local _, name, _, icon, _, class = GetSpecializationInfoByID(spec);
			if (not filter) or (filter == class) then
				local color = RAID_CLASS_COLORS[class];
				local specIcon = ("|T%s.blp:0|t |cff%02x%02x%02x%s|r"):format(icon, floor(color.r * 255), floor(color.g * 255), floor(color.b * 255), name);

				local details = "";
				for _, key in ipairs(TEMPLATE_STATS) do
					if new[key] then
						local label = TEMPLATE_TRANSLATIONS[(key == "primary" and "primary"..template.stat) or key] or "?";
						if details ~= "" then details = details .. ", "; end
						details = details .. label .. HEADER_COLON .. " " .. GetDeltaString(old[key], new[key]);
					end
				end
				Write(specIcon .. " ►" .. details);
			end
		end
	end
end

function PVPTooltips_ShowChanges(v)
	WriteDiff(v or version, nil);
end

do
	local _, class = UnitClass("player");
	
	Write("|cffffff20PVP Tooltips (" .. version .. ")|r");
	WriteDiff(version, class);
end