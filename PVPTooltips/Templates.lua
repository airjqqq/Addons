-- ---------------------------------------------------------------------------------------
-- SECONDARY DATA TABLE FOR STAT TEMPLATES
--   Key is the specialization ID whose stat template is described
--   Value is a table containing stats and flags
--   Valid table keys: role, caster, stat, primary, stamina, armor, damage,
-- 					   mastery, haste, crit, versatility, regen, vulnerability
--   Valid roles: tank, damager, healer
--   Default stat value is 1.00, except for caster primary stat where it is 1.35
-- ---------------------------------------------------------------------------------------

local STR = LE_UNIT_STAT_STRENGTH;
local AGI = LE_UNIT_STAT_AGILITY;
local INT = LE_UNIT_STAT_INTELLECT;

PVPTooltips_Templates = {
	-- Death Knight
	[250] = { role = "tank", caster = false, stat = STR, vulnerability = 1.25, damage = 0.90, primary = 0.90, stamina = 0.80, mastery = 0.25, versatility = 0.00 }, -- Blood
	[251] = { role = "damager", caster = false, stat = STR, primary = 0.80, stamina = 1.20, mastery = 0.25, haste = 1.50, crit = 1.25 }, -- Frost
	[252] = { role = "damager", caster = false, stat = STR, primary = 0.95, mastery = 0.75, haste = 1.25, stamina = 1.20 }, -- Unholy

	-- Demon Hunter
	[577] = { role = "damager", caster = false, stat = AGI, primary = 0.88, stamina = 1.10, versatility = 1.25, mastery = 0.40, haste = 1.10, crit = 1.30 }, -- Havoc
	[581] = { role = "tank", caster = false, stat = AGI, vulnerability = 1.25, stamina = 0.80, mastery = 0.25, versatility = 0.00 }, -- Vengeance
	
	-- Druid
	[102] = { role = "damager", caster = true, stat = INT, mastery = 0.25, versatility = 1.20, haste = 1.00, crit = 1.25 }, -- Balance
	[103] = { role = "damager", caster = false, stat = AGI, primary = 0.87 }, -- Feral
	[104] = { role = "tank", caster = false, stat = AGI, vulnerability = 1.10, primary = 0.90, stamina = 0.75, mastery = 0.25, versatility = 0.00 }, -- Guardian
	[105] = { role = "healer", caster = true, stat = INT, damage = 0.70, primary = 1.45, haste = 1.50, crit = 0.50, regen = 0.70 }, -- Restoration

	-- Hunter
	[253] = { role = "damager", caster = false, stat = AGI, primary = 0.70, armor = 1.00, versatility = 1.25, mastery = 0.45, haste = 1.30, crit = 1.00 }, -- Beast Mastery
	[254] = { role = "damager", caster = false, stat = AGI, armor = 1.20, haste = 1.20, crit = 0.80 }, -- Marksmanship
	[255] = { role = "damager", caster = false, stat = AGI, primary = 0.90, armor = 1.25, stamina = 1.15, mastery = 0.25, haste = 1.00, crit = 0.75, versatility = 1.50 }, -- Survival

	-- Mage
	[62] = { role = "damager", caster = true, stat = INT, primary = 1.20, mastery = 0.25, haste = 1.50, crit = 1.00 }, -- Arcane
	[63] = { role = "damager", caster = true, stat = INT, primary = 1.04, stamina = 0.90, crit = 1.50, mastery = 0.50 }, -- Fire
	[64] = { role = "damager", caster = true, stat = INT, primary = 1.18, stamina = 0.90, haste = 1.50, mastery = 0.50 }, -- Frost

	-- Monk
	[268] = { role = "tank", caster = false, stat = AGI, vulnerability = 1.25, stamina = 0.80, mastery = 0.25, versatility = 0.30, haste = 1.25 }, -- Brewmaster
	[270] = { role = "healer", caster = true, stat = INT, damage = 0.70, primary = 1.32, regen = 1.05, versatility = 1.30 }, -- Mistweaver
	[269] = { role = "damager", caster = false, stat = AGI, primary = 0.90, versatility = 1.20, haste = 2.00, mastery = 0.25, crit = 1.00 }, -- Windwalker

	-- Paladin
	[65] = { role = "healer", caster = true, stat = INT, damage = 0.70, primary = 1.52, regen = 0.80, versatility = 0.75, mastery = 0.50, crit = 1.50, haste = 1.25 }, -- Holy
	[66] = { role = "tank", caster = false, stat = STR, vulnerability = 1.25, damage = 0.95, primary = 0.80, stamina = 0.85, regen = 0.75, versatility = 0.50, mastery = 0.25, crit = 1.25, haste = 2.00 }, -- Protection
	[70] = { role = "damager", caster = false, stat = STR, primary = 0.80, mastery = 0.25, haste = 1.50, versatility = 1.00, crit = 1.35 }, -- Retribution

	-- Priest
	[256] = { role = "healer", caster = true, stat = INT, damage = 0.82, primary = 1.40, mastery = 0.50, versatility = 1.50 }, -- Discipline
	[257] = { role = "healer", caster = true, stat = INT, damage = 0.60, primary = 1.50, haste = 1.25, mastery = 0.75 }, -- Holy
	[258] = { role = "damager", caster = true, stat = INT, primary = 1.28, mastery = 0.75, versatility = 1.60, crit = 0.75 }, -- Shadow

	-- Rogue
	[259] = { role = "damager", caster = false, stat = AGI, primary = 0.65 }, -- Assassination
	[260] = { role = "damager", caster = false, stat = AGI, primary = 0.75 }, -- Outlaw
	[261] = { role = "damager", caster = false, stat = AGI, primary = 0.80, haste = 1.25, versatility = 0.50, crit = 2.00, mastery = 0.25 }, -- Subtlety

	-- Shaman
	[262] = { role = "damager", caster = true, stat = INT, armor = 1.20, stamina = 1.10, versatility = 1.75, mastery = 0.75, crit = 0.75, haste = 0.75 }, -- Elemental
	[263] = { role = "damager", caster = false, stat = AGI, armor = 1.25, primary = 0.95, stamina = 1.10, versatility = 1.75, mastery = 0.25 }, -- Enhancement
	[264] = { role = "healer", caster = true, stat = INT, damage = 0.75, primary = 1.37, armor = 1.30, crit = 1.20, versatility = 1.40, mastery = 1.60, regen = 0.80 }, -- Restoration

	-- Warlock
	[265] = { role = "damager", caster = true, stat = INT, primary = 1.10, stamina = 1.20, mastery = 1.25, versatility = 0.35, haste = 1.50 }, -- Affliction
	[266] = { role = "damager", caster = true, stat = INT, stamina = 1.05, mastery = 0.75, versatility = 0.75, haste = 1.50 }, -- Demonology
	[267] = { role = "damager", caster = true, stat = INT, primary = 1.30, crit = 1.75, mastery = 0.25, stamina = 1.20 }, -- Destruction
	
	-- Warrior
	[71] = { role = "damager", caster = false, stat = STR, primary = 1.06, stamina = 1.15, armor = 1.10, mastery = 0.25, haste = 1.25, versatility = 1.22, crit = 1.25 }, -- Arms
	[72] = { role = "damager", caster = false, stat = STR, stamina = 0.95, mastery = 0.75, haste = 1.50, crit = 0.75 }, -- Fury
	[73] = { role = "tank", caster = false, stat = STR, vulnerability = 1.15, damage = 0.90, primary = 0.95, stamina = 0.95, versatility = 0.50, mastery = 0.25, haste = 1.75, crit = 1.50 }, -- Protection
}