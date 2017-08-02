-- ---------------------------------------------------------------------------------------
-- HOW TO FILL THE DATA TABLE
--   Key is the spell ID whose tooltip will be modified
--   First value is the position of numeric param(s) within the English spell description
--   Second value is the PVP multiplier
--   Third value is an optional spec filter, if modifier only applies for a spec
--   Fourth value is an optional spell ID, whose name will appear next to the PVP modifier
-- ---------------------------------------------------------------------------------------

PVPTooltips_Data = {
	--            position, multiplier, specfilter, details
	-- @DK
	[205223] = {         2,       1.00,        nil,     nil }, -- Consumption
	[192567] = {    {1, 2},       0.60,        nil,     nil }, -- Unending Thirst
	[206930] = {         2,       1.00,        nil,     nil }, -- Heart Strike
	[50842]  = {         1,       1.00,        nil,     nil }, -- Blood Boil
	[190778] = {         2,       0.40,        nil,     nil }, -- Sindragosa's Fury
	[207311] = {         1,       1.00,        nil,     nil }, -- Clawing Shadows
	[191587] = {    {1, 3},       0.45,        nil,     nil }, -- Virulent Plague (UNUSED)
	[77575]  = {        {},       0.45,        nil,  191587 }, -- Outbreak (Virulent Plague)						                                    (FIXME: -25% on 3, 5)
	[207349] = {        {},       0.60,        nil,     nil }, -- Dark Arbiter (affects "Val'kyr Strike" but document the main spell)
	[207317] = {    {2, 3},       0.85,        nil,     nil }, -- Epidemic
	[220143] = {         1,       1.00,        nil,     nil }, -- Apocalypse
	[191637] = {         1,       0.80,        nil,     nil }, -- Dragged to Helheim (related to "Portal to the Underworld" artifact trait) 			(FIXME: verify this one)
	[49998]  = {         2,       0.50,        nil,     nil }, -- Death Strike
	[206931] = {         1,       1.00,        nil,     nil }, -- Blooddrinker
	[152279] = {         1,       0.60,        nil,     nil }, -- Breath of Sindragosa
	[49206]  = {        {},    0.66666,        nil,     nil }, -- Summon Gargoyle (affects "Gargoyle Strike" but document the main spell)

	-- @DH
	[204254] = {         2,       0.80,        nil,     nil }, -- Shattered Souls (Vengeance)
	[228477] = {         2,       1.00,        nil,     nil }, -- Soul Cleave
	[227225] = { {2, 3, 4},       1.00,        nil,     nil }, -- Soul Barrier
	[204909] = {         1,       0.40,        nil,     nil }, -- Soul Rending (Metamorphosis leech)
	[201467] = {         1,       0.70,        nil,     nil }, -- Fury of the Illidari
	[206416] = {         2,    0.66666,        nil,     nil }, -- First Blood
	[211048] = {         3,       0.75,        nil,    6603 }, -- Chaos Blades (auto-attacks)
	[191427] = {         6,       0.40,        nil,     nil }, -- Metamorphosis (Leech)
	[206491] = {         2,       0.50,        nil,  141582 }, -- Nemesis (duration)
	[162794] = {         1,       0.95,        nil,     nil }, -- Chaos Strike
	[201427] = {         1,       0.95,        nil,     nil }, -- Annihilation
	[211053] = {         1,       0.70,        nil,     nil }, -- Fel Barrage
	
	-- @Druid
	[200851] = {         3,       0.10,        nil,     nil }, -- Rage of the Sleeper
	[210722] = {    {3, 4},       0.50,        nil,     nil }, -- Ashamane's Frenzy
	[33763]  = {         3,       1.50,        nil,     nil }, -- Lifebloom
	[22842]  = {         1,       0.50,        nil,     nil }, -- Frenzied Regeneration
	[740]    = {         2,       2.00,        nil,     nil }, -- Tranquility
	[1822]   = {    {1, 2},       0.80,        nil,     nil }, -- Rake
	[6807]   = {         1,    0.53333,        nil,     nil }, -- Maul
	[214508] = {         1,       0.75,        nil,     nil }, -- Echoing Stars
	[191034] = {         1,       0.50,        nil,     nil }, -- Starfall
	[48484]  = {         1,       0.60,        nil,  157582 }, -- Infected Wounds (snare)
	[8921]   = {         2,       0.50,        102,     nil }, -- Moonfire (DoT)
	[93402]  = {         2,       0.50,        102,     nil }, -- Sunfire (DoT)
	[202342] = {         3,       0.50,        nil,     nil }, -- Shooting Stars
	[190984] = {         1,       1.40,        nil,     nil }, -- Solar Wrath
	[238120] = {         1,       0.50,        nil,     nil }, -- Bloodletter's Frailty
	[202768] = {         1,       0.90,        nil,     nil }, -- Half Moon
	[202771] = {         1,       0.90,        nil,     nil }, -- Full Moon
	[5487]   = {         2,     0.7272,       -104,    7850 }, -- Bear Form (health)
	[238122] = {         1,    0.57143,        nil,     nil }, -- Deep Rooted
	[18562]  = {         1,       1.40,        nil,     nil }, -- Swiftmend
	[202302] = {         1,       0.50,        nil,     nil }, -- Bladed Feathers
	[24858]  = {         2,      0.625,        nil,   58453 }, -- Moonkin Form (armor)

	-- @Hunter
	[131894] = {         1,       0.65,        nil,     nil }, -- Murder of Crows (Beast Mastery, Marksmanship)
	[206505] = {        {},       0.65,        nil,     nil }, -- Murder of Crows (Survival)
	[120360] = {    {2, 3},       0.80,        nil,     nil }, -- Barrage
	[193455] = {         1,       0.75,        nil,     nil }, -- Cobra Shot
	[34026]  = {         1,       0.80,        nil,     nil }, -- Kill Command
	[19434]  = {         1,       1.05,        nil,     nil }, -- Aimed Shot
	[185901] = {         1,       0.70,        nil,     nil }, -- Marked Shot
	[198670] = {    {1, 2},       0.50,        nil,     nil }, -- Piercing Shot
	[109304] = {    {1, 2},       1.00,        nil,     nil }, -- Exhilaration
	[194291] = {         1,       0.60,        nil,     nil }, -- Exhilaration (REMOVED)
	[190503] = {         1,       1.00,        nil,     nil }, -- Healing Shell
	[190928] = {         2,       0.70,        nil,     nil }, -- Mongoose Bite (Mongoose Fury stack)
	[162488] = {         7,       0.30,        nil,     nil }, -- Steel Trap (Waylay bonus)
	[194277] = {         2,       0.80,        nil,  106550 }, -- Caltrops (damage)
	[214579] = {         1,       0.90,        nil,     nil }, -- Sidewinders
	[191339] = {         1,       0.60,        nil,     nil }, -- Rapid Killing

	-- @Mage
	[116011] = {         2,       0.70,        nil,     nil }, -- Rune of Power
	[194318] = {         1,       0.50,        nil,     nil }, -- Cauterizing Blink
	[133]    = {         1,       1.75,        nil,     nil }, -- Fireball
	[11366]  = {         1,       0.70,        nil,     nil }, -- Pyroblast
	[199786] = {         1,       0.90,        nil,     nil }, -- Glacial Spike
	[30451]  = {         1,       1.00,        nil,     nil }, -- Arcane Blast
	[30455]  = {         1,       1.20,        nil,     nil }, -- Ice Lance					(FIXME: incomplete / problem if Splitting Ice talent is taken + ru language)
	[116]    = {         1,       1.00,        nil,     nil }, -- Frost Bolt
	[155147] = {         1,    0.64286,        nil,     nil }, -- Overpowered
	[157976] = {         2,       0.60,         62,     nil }, -- Unstable Magic (Arcane only)
	[2120]   = {         1,       0.90,        nil,     nil }, -- Flamestrike
	[153561] = {    {2, 4},       0.70,        nil,     nil }, -- Meteor
	[214634] = {         1,       0.90,        nil,     nil }, -- Ebonbolt
	[44614]  = {         2,       0.95,        nil,     nil }, -- Flurry
	[235224] = {         1,    0.66666,        nil,     nil }, -- Frigid Winds
	[205708] = {         1,       0.80,        nil,     nil }, -- Chilled

	-- @Monk
	[113656] = {         1,       0.85,        nil,     nil }, -- Fists of Fury
	[205320] = {         1,       0.60,        nil,     nil }, -- Strike of the Windlord
	[115310] = {         2,       2.00,        nil,     nil }, -- Revival
	[152173] = {         2,       0.55,        nil,     nil }, -- Serenity
	[137639] = {         3,       0.90,        nil,     nil }, -- Storm, Earth, and Fire
	[195300] = {         1,       0.60,        nil,     nil }, -- Transfer the Power
	[193884] = {         1,       0.80,        nil,     nil }, -- Soothing Mist (passive)
	[115313] = {        {},       0.80,        nil,  193884 }, -- Summon Jade Statue
	[123904] = {         5,       0.60,        nil,     nil }, -- Invoke Xuen, the White Tiger
	[196740] = {         1,       0.50,        nil,     nil }, -- Hit Combo

	-- @Paladin
	[20473]  = {         1,       0.50,        nil,  106550 }, -- Holy Shock (damage)
	[31935]  = {         1,       0.50,        nil,     nil }, -- Avenger's Shield
	[53600]  = {         1,       0.50,        nil,     nil }, -- Shield of the Righteous
	[184092] = {         1,       0.40,        nil,     nil }, -- Light of the Protector
	[213652] = {         1,       0.40,        nil,     nil }, -- Hand of the Protector
	[213757] = {         1,       0.80,        nil,     nil }, -- Execution Sentence
	[85256]  = {         1,       1.00,        nil,     nil }, -- Templar's Verdict
	[215661] = {         2,       0.50,        nil,     nil }, -- Justicar's Vengeance (stun bonus)
	[19750]  = {         1,       1.50,        nil,     nil }, -- Flash of Light
	[82326]  = {         1,       1.60,        nil,     nil }, -- Holy Light
	[184575] = {         1,    0.90909,        nil,     nil }, -- Blade of Justice
	
	-- @Priest
	[17]     = {         2,       1.10,        256,     nil }, -- Power Word: Shield
	[81749]  = {         2,       1.25,        nil,     nil }, -- Atonement
	[2060]   = {         1,       2.00,        nil,     nil }, -- Heal
	[33076]  = {         1,       1.50,        nil,     nil }, -- Prayer of Mending
	[34914]  = {         1,       0.85,        nil,     nil }, -- Vampiric Touch
	[2061]   = {         1,       1.60,        nil,     nil }, -- Flash Heal
	[207946] = {        {},       0.50,        nil,  223166 }, -- Light's Wrath (Overloaded with Light)
	[139]    = {         2,       1.75,        nil,     nil }, -- Renew
	[8092]   = {         1,       1.30,        nil,     nil }, -- Mind Blast
	[15407]  = {         1,       1.40,        nil,     nil }, -- Mind Flay
	[589]    = {    {1, 2},       0.80,        258,     nil }, -- Shadow Word: Pain
	[205351] = {         1,       1.20,        nil,     nil }, -- Shadow Word: Void
	[232698] = {         2,       2.00,        nil,     nil }, -- Shadowform (physical damage taken reduction)
	
	-- @Rogue
	[185311] = {                     1,       0.50,        nil,     nil }, -- Crimson Vial
	[152150] = {                     3,       0.50,        nil,     nil }, -- Death from Above
	[14062]  = {                     2,       0.50,        nil,     nil }, -- Nightstalker
	[1943]   = { {2, 5, 8, 11, 14, 17},       0.75,        nil,     nil }, -- Rupture
	[192923] = {                     1,       0.30,        nil,     nil }, -- Blood of the Assassinated
	[196819] = {  {2, 4, 6, 8, 10, 12},       0.85,        nil,     nil }, -- Eviscerate
	[185438] = {                     1,       0.70,        nil,     nil }, -- Shadowstrike
	[197406] = {                    {},       0.60,        nil,     nil }, -- Finality
	[199804] = {                    {},       0.50,        nil,   37443 }, -- Between the Eyes (crit damage multiplier)
	[195452] = { {4, 6, 8, 10, 12, 14},       0.85,        nil,  106550 }, -- Nightblade (damage)
	[1966]   = {                     1,       0.60,        nil,     nil }, -- Feint
	[3408]   = {                     3,       0.60,        nil,  157582 }, -- Crippling Poison (snare)
	[185763] = {                     2,       0.60,        nil,  157582 }, -- Pistol Shot (snare)
	[206760] = {                     1,       0.60,        nil,  157582 }, -- Night Terrors (snare)
	[192657] = {                     1,       0.60,        nil,     nil }, -- Poison Bomb (related to "Bag of Tricks" artifact trait)
	[8679]   = {                    {},       0.80,        nil,    2060 }, -- Wound Poison (healing debuff)
	
	-- @Shaman
	[204945] = {         1,       0.60,        nil,     nil }, -- Doom Winds
	[188070] = {         1,       1.00,        nil,     nil }, -- Healing Surge (Enhancement)
	[168534] = {        {},       0.80,        nil,   51505 }, -- Elemental Overload (only applies to Lava Burst)
	[8042]   = {         1,      0.625,        nil,     nil }, -- Earth Shock
	[51505]  = {         1,       1.00,        nil,     nil }, -- Lava Burst
	[8004]   = {         1,       1.20,        264,     nil }, -- Healing Surge (Elemental, Restoration), buff limited to Resto
	[77472]  = {         1,       1.50,        nil,     nil }, -- Healing Wave
	[5394]   = {         3,       1.40,        nil,     nil }, -- Healing Stream Totem
	[17364]  = {         1,       0.75,        nil,     nil }, -- Stormstrike
	[115356] = {         1,       0.75,        nil,     nil }, -- Windstrike
	[205495] = {         2,       0.50,        nil,     nil }, -- Stormkeeper
	[210714] = {         1,       0.65,        nil,     nil }, -- Icefury
	[196840] = {        {},       0.80,        nil,  210714 }, -- Frost Shock (Icefury bonus)
	[117014] = {         1,       0.85,        nil,     nil }, -- Elemental Blast
	[61295]  = {    {1, 2},       1.15,        nil,     nil }, -- Riptide
	[114051] = {         2,      0.625,        nil,     nil }, -- Ascendance
	[188089] = {         2,    0.66666,        nil,     nil }, -- Earthen Spike

	-- @Warlock
	[211714] = {        {},       0.66,        nil,     nil }, -- Thal'kiel's Consumption
	[219272] = {         1,       0.50,        nil,     nil }, -- Demon Skin (passive recharge effect)
	[116858] = {         1,       1.25,        nil,     nil }, -- Chaos Bolt
	[218572] = {        {},       0.33,        nil,     nil }, -- Doom, Doubled
	[171975] = {         1,       0.75,        nil,     nil }, -- Grimoire of Synergy
	[196277] = {         1,       0.80,        nil,     nil }, -- Implosion
	[17877]  = {         1,       0.80,        nil,     nil }, -- Shadowburn
	[205148] = {         2,       0.50,        nil,     nil }, -- Reverse Entropy (Chaos Bolt cast time reduction)
	[196406] = {         1,       0.50,        nil,     nil }, -- Backdraft (Chaos Bolt and Incinerate cast time reduction)
	[603]    = {         1,       0.85,        nil,     nil }, -- Doom
	[218567] = {         2,       0.75,        nil,     nil }, -- Soul Skin
	[172]    = {         1,       0.85,        nil,     nil }, -- Corruption
	[980]    = {         1,       0.85,        nil,     nil }, -- Agony
	[30108]  = {         1,       1.10,        nil,     nil }, -- Unstable Affliction
	[198590] = {         1,       1.15,        nil,     nil }, -- Drain Soul
	
	-- @Warrior
	[227847] = {         2,       1.00,        nil,     nil }, -- Bladestorm
	[207982] = {         1,       0.40,        nil,     nil }, -- Focused Rage (Mortal Strike)
	[23881]  = {         2,       0.75,        nil,     nil }, -- Bloodthirst
	[204488] = {         1,       0.40,        nil,     nil }, -- Focused Rage (Shield Slam)
	[190456] = {         2,       0.80,        nil,     nil }, -- Ignore Pain
	[2565]   = {         2,       0.40,        nil,     nil }, -- Shield Block
	[5308]   = {         1,       1.15,        nil,     nil }, -- Execute (Fury)
	[163201] = {    {1, 3},       1.15,        nil,     nil }, -- Execute (Arms)
	[184361] = {         2,       0.50,        nil,  183239 }, -- Enrage (damage vulnerability)
	[238111] = {         2,       0.70,        nil,     nil }, -- Soul of the Slaughter
	[12294]  = {         1,       0.70,        nil,     nil }, -- Mortal Strike
	[772]    = {    {1, 2},       0.85,        nil,     nil }, -- Rend
	[197690] = {         2,      -2.00,        nil,     nil }, -- Defensive Stance
	
	-- @General
	[239042] = {         1,       0.50,        nil,     nil }, -- Concordance of the Legionfall
};

-- -----------------------------------------------------------------------
-- Secondary data table, when a spell has a secondary PVP multiplier on it
-- -----------------------------------------------------------------------

PVPTooltips_SecondaryData = {
	--            position, multiplier, specfilter, details
	-- @DK
	-- n/a
	
	-- @DH
	[211048] = {         1,    0.66666,        nil,  223740 }, -- Chaos Blades (damage multiplier)
	[206491] = {         1,       0.60,        nil,  223740 }, -- Nemesis (damage multiplier)
	
	-- @Druid
	[5487]   = {         1,      0.625,       -104,   58453 }, -- Bear Form (armor)
	
	-- @Hunter
	[194277] = {         4,     0.7142,        nil,  157582 }, -- Caltrops (snare)
	
	-- @Mage
	-- n/a
	
	-- @Monk
	-- n/a
	
	-- @Paladin
	[20473]  = {         2,       1.10,        nil,    2060 }, -- Holy Shock (healing)
	
	-- @Priest
	-- n/a
	
	-- @Rogue
	[195452] = {         1,       0.60,        nil,  157582 }, -- Nightblade (snare)
	
	-- @Shaman
	-- n/a
	
	-- @Warlock
	-- n/a
	
	-- @Warrior
	-- n/a
};