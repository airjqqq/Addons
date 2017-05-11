local name, SPELLDB = ...
SPELLDB.SHAMAN = {}
SPELLDB.SHAMAN.ELEMENTAL = {}
SPELLDB.SHAMAN.ENHANCEMENT = {}
SPELLDB.SHAMAN.RESTORATION = {}

SPELLDB.SHAMAN.ELEMENTAL.spells = {
	2008 --[[Ancestral Spirit--]],        
	556 --[[Astral Recall--]],        
	108271 --[[Astral Shift--]],        
	2825 --[[Bloodlust--]],        
	188443 --[[Chain Lightning--]],        
	51886 --[[Cleanse Spirit--]],        
	198103 --[[Earth Elemental--]],        
	8042 --[[Earth Shock--]],        
	2484 --[[Earthbind Totem--]],        
	61882 --[[Earthquake--]],        
	6196 --[[Far Sight--]],        
	188389 --[[Flame Shock--]],        
	196840 --[[Frost Shock--]],        
	2645 --[[Ghost Wolf--]],        
	8004 --[[Healing Surge--]],        
	51514 --[[Hex--]],        
	51505 --[[Lava Burst--]],        
	188196 --[[Lightning Bolt--]],        
	51490 --[[Thunderstorm--]],        
	546 --[[Water Walking--]],        
	57994 --[[Wind Shear--]],        
	60188 --[[Elemental Fury--]],        
	77756 --[[Lava Surge--]],        
	20608 --[[Reincarnation--]],        
	198067 --[[Fire Elemental--]],        
	370 --[[Purge--]],        
	231722 --[[Chain Lightning--]],        
	168534 --[[Mastery: Elemental Overload--]],        
	16164 --[[Elemental Focus--]],  
};
SPELLDB.SHAMAN.ENHANCEMENT.spells = {
	2008 --[[Ancestral Spirit--]],        
	556 --[[Astral Recall--]],        
	108271 --[[Astral Shift--]],        
	2825 --[[Bloodlust--]],        
	51886 --[[Cleanse Spirit--]],        
	187874 --[[Crash Lightning--]],        
	2484 --[[Earthbind Totem--]],        
	6196 --[[Far Sight--]],        
	51533 --[[Feral Spirit--]],        
	193796 --[[Flametongue--]],        
	196834 --[[Frostbrand--]],        
	2645 --[[Ghost Wolf--]],        
	188070 --[[Healing Surge--]],        
	51514 --[[Hex--]],        
	60103 --[[Lava Lash--]],        
	187837 --[[Lightning Bolt--]],        
	193786 --[[Rockbiter--]],        
	17364 --[[Stormstrike--]],        
	546 --[[Water Walking--]],        
	57994 --[[Wind Shear--]],        
	187880 --[[Maelstrom Weapon--]],        
	20608 --[[Reincarnation--]],        
	201845 --[[Stormbringer--]],        
	33757 --[[Windfury--]],        
	231723 --[[Feral Spirit--]],        
	370 --[[Purge--]],        
	190899 --[[Healing Surge--]],        
	195255 --[[Stormlash--]],        
	77223 --[[Mastery: Enhanced Elements--]],        
	58875 --[[Spirit Walk--]],     
};

SPELLDB.SHAMAN.RESTORATION.spells = {
	2008 --[[Ancestral Spirit--]],        
	556 --[[Astral Recall--]],        
	108271 --[[Astral Shift--]],        
	2825 --[[Bloodlust--]],        
	1064 --[[Chain Heal--]],        
	421 --[[Chain Lightning--]],        
	2484 --[[Earthbind Totem--]],        
	6196 --[[Far Sight--]],        
	188838 --[[Flame Shock--]],        
	2645 --[[Ghost Wolf--]],        
	73920 --[[Healing Rain--]],        
	5394 --[[Healing Stream Totem--]],        
	8004 --[[Healing Surge--]],        
	77472 --[[Healing Wave--]],        
	51514 --[[Hex--]],        
	51505 --[[Lava Burst--]],        
	403 --[[Lightning Bolt--]],        
	77130 --[[Purify Spirit--]],        
	61295 --[[Riptide--]],        
	79206 --[[Spiritwalker's Grace--]],        
	546 --[[Water Walking--]],        
	57994 --[[Wind Shear--]],        
	77756 --[[Lava Surge--]],        
	20608 --[[Reincarnation--]],        
	16196 --[[Resurgence--]],        
	51564 --[[Tidal Waves--]],        
	231780 --[[Chain Heal--]],        
	98008 --[[Spirit Link Totem--]],        
	370 --[[Purge--]],        
	212048 --[[Ancestral Vision--]],        
	231785 --[[Tidal Waves--]],        
	77226 --[[Mastery: Deep Healing--]],        
	108280 --[[Healing Tide Totem--]],   
};

SPELLDB.SHAMAN.ELEMENTAL.talents = {
	201909 --[[Path of Flame--]],        
	170374 --[[Earthen Rage--]],        
	210643 --[[Totem Mastery--]],        
	192063 --[[Gust of Wind--]],        
	108281 --[[Ancestral Guidance--]],        
	192077 --[[Wind Rush Totem--]],        
	192058 --[[Lightning Surge Totem--]],        
	51485 --[[Earthgrab Totem--]],        
	196932 --[[Voodoo Totem--]],        
	210707 --[[Aftershock--]],        
	192087 --[[Ancestral Swiftness--]],        
	16166 --[[Elemental Mastery--]],        
	192235 --[[Elemental Fusion--]],        
	117013 --[[Primal Elementalist--]],        
	117014 --[[Elemental Blast--]],        
	192222 --[[Liquid Magma Totem--]],        
	192249 --[[Storm Elemental--]],        
	108283 --[[Echo of the Elements--]],        
	114050 --[[Ascendance--]],        
	210689 --[[Lightning Rod--]],        
	210714 --[[Icefury--]],        
};
SPELLDB.SHAMAN.ENHANCEMENT.talents = {
	201898 --[[Windsong--]],        
	201900 --[[Hot Hand--]],        
	201897 --[[Boulderfist--]],        
	215864 --[[Rainfall--]],        
	196884 --[[Feral Lunge--]],        
	192077 --[[Wind Rush Totem--]],        
	192058 --[[Lightning Surge Totem--]],        
	51485 --[[Earthgrab Totem--]],        
	196932 --[[Voodoo Totem--]],        
	192106 --[[Lightning Shield--]],        
	192087 --[[Ancestral Swiftness--]],        
	210853 --[[Hailstorm--]],        
	192234 --[[Tempest--]],        
	210727 --[[Overcharge--]],        
	210731 --[[Empowered Stormlash--]],        
	192246 --[[Crashing Storm--]],        
	197211 --[[Fury of Air--]],        
	197214 --[[Sundering--]],        
	114051 --[[Ascendance--]],        
	197992 --[[Landslide--]],        
	188089 --[[Earthen Spike--]],   
};
SPELLDB.SHAMAN.RESTORATION.talents = {
	200071 --[[Undulation--]],        
	73685 --[[Unleash Life--]],        
	200072 --[[Torrent--]],        
	192063 --[[Gust of Wind--]],        
	192088 --[[Graceful Spirit--]],        
	192077 --[[Wind Rush Totem--]],        
	192058 --[[Lightning Surge Totem--]],        
	51485 --[[Earthgrab Totem--]],        
	196932 --[[Voodoo Totem--]],        
	197464 --[[Crashing Waves--]],        
	108281 --[[Ancestral Guidance--]],        
	200076 --[[Deluge--]],        
	207399 --[[Ancestral Protection Totem--]],        
	198838 --[[Earthen Shield Totem--]],        
	207401 --[[Ancestral Vigor--]],        
	197467 --[[Bottomless Depths--]],        
	157153 --[[Cloudburst Totem--]],        
	108283 --[[Echo of the Elements--]],        
	114052 --[[Ascendance--]],        
	197995 --[[Wellspring--]],        
	157154 --[[High Tide--]],      
};

SPELLDB.SHAMAN.ELEMENTAL.pvpTalents = {	
	208683 --[[Gladiator's Medallion--]],   
	214027 --[[Adaptation--]],   
	196029 --[[Relentless--]],  

	213545 --[[Train of Thought--]],   
	213546 --[[Mind Quickness--]],   
	213547 --[[Initiation--]],  

	204330,
	204331,
	204332,

	204247,
	204261,
	204264,

	204389,
	204385,
	204393,

	204398,
	204403,
	204437,};

SPELLDB.SHAMAN.ENHANCEMENT.pvpTalents = {	
	208683 --[[Gladiator's Medallion--]],   
	214027 --[[Adaptation--]],   
	196029 --[[Relentless--]],   

	195416 --[[Hardiness--]],   
	195282 --[[Reinforced Armor--]],   
	195425 --[[Sparring--]], 

	204330,
	204331,
	204332,

	204247,
	204261,
	210918,

	204349,
	211062,
	204357,

	193876,
	204365,
	204366,
	};

SPELLDB.SHAMAN.RESTORATION.pvpTalents = {
	208683 --[[Gladiator's Medallion--]],   
	214027 --[[Adaptation--]],   
	196029 --[[Relentless--]],   

	195330 --[[Defender of the Weak--]],   
	195483 --[[Vim and Vigor--]],   
	195606,

	204330,
	204331,
	204332,

	204247,
	236501 --[[Tidebringer--]],
	204264,

	204268,
	206642,
	204336,

	204269,
	204288,
	204293,
};

SPELLDB.SHAMAN.ELEMENTAL.artifact = {205495,191861,191717,192630,238141,238105,238069,215414,191740,191512,191569,191499,191598,191602,191572,191493,191504,191582,191647,191577,};
SPELLDB.SHAMAN.ENHANCEMENT.artifact = {204945,198736,199107,198505,238142,238106,238070,198228,198349,198299,198292,198247,215381,198434,198238,198361,198248,198296,198367,198236,};
SPELLDB.SHAMAN.RESTORATION.artifact = {207778,207360,207362,207358,238143,242652,238071,224841,207088,207118,207255,207351,207355,207348,207357,207354,207356,207285,207206,207092,};













