local filterName = "PVPFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName)
local color = "00FF33"
local L = setmetatable({},{__index = function(t,k) return k end})

function F:OnInitialize()
  -- self:RegisterFilter("PVPDOTATTACK",L["[PVP] Don't Attack"])
end

function F:RegisterFilter(key,name,keys,subtypes,c)
  assert(self[key])
  Core:RegisterFilter(key,{
    name = name,
    fcn = self[key],
    color = c or color,
    keys = keys or {unit= {}},
    subtypes = subtypes,
  })
end

local buffs = {
  --dk
	dk = {
    [ 48707] = "IMDEBUFF", -- Anti-Magic Shield
		[ 48792] = "ISTUN", -- Icebound Fortitude

  },
  dh = {
    [196555] = "IPDAMAGE IMDAMAGE"
  },
  druid = {
		[102351] = "BIGHOT", -- Cenarion Ward
		[  5215] = "STEALTH", -- Cenarion Ward
		[   774] = "HOT", -- Rejuvenation
		[  8936] = "HOT", -- Regrowth
		[ 33763] = "HOT", -- Lifebloom
		[155777] = "HOT", -- Rejuvenation (Germination)

  },

  hunter = {
		[186265] = "IPDAMAGE IPDEBUFF IMDAMAGE IMDEBUFF", -- Aspect of the Turtle
  },
  mage = {
    [ 32612] = "STEALTH",
    [ 11426] = "SHEILD",
    [ 11426] = "SHEILD",
  	[ 45438] = "IPDAMAGE IPDEBUFF IMDAMAGE IMDEBUFF", -- Ice Block
  },
  monk = {
	  [125174] = "IPDAMAGE IMDAMAGE", -- Touch of Karma
	  [124682] = "BIGHOT", -- Enveloping Mist
		[119611] = "HOT", -- Renewing Mist
  },
  paly = {
    [  1044] = "ISLOW IROOT", -- Blessing of Freedom
    HOT = {
      200652, -- Tyr's Deliverance (HoT) (Holy artifact)
      200654, -- Tyr's Deliverance (Holy artifact)
    },
    [204018] = "IMDAMAGE IMDEBUFF", -- Blessing of Spellwarding
		[  1022] = "IPDAMAGE IPDEBUFF", -- Blessing of Protection
		[  6940] = "DDAMAGE", -- Blessing of Sacrifice
		[   642] = "IPDAMAGE IPDEBUFF IMDAMAGE IMDEBUFF", -- Divine Shield
  },

}

local debuffs = {
  --dk
  dk = {
    SLOW = {
      190780, -- Frost Breath (Frost artifact) (slow)
      191719, -- Gravitational Pull (Unholy artifact) (slow)
      211793, -- Remorseless Winter (slow)
      212764, -- White Walker (slow)
      206930, -- Hearth Strike (slow)
			211831, -- Abomination's Might (slow)
			 45524, -- Chains of Ice (slow)
    },
		DISORIENT = {
			206961, -- Tremble Before Me (disorient)
			207167, -- Blinding Sleet (disorient)
		},
		ROOT = {
			 91807, -- Shambling Rush (ghoul) (root)
			212540, -- Flesh Hook (abomination) (root)
		},
		STUN = {
			 91797, -- Monstrous Blow (ghoul) (stun)
			 91800, -- Gnaw (ghoul) (stun)
			108194, -- Asphyxiate (Unholy talent) (stun)
			212332, -- Smash (abomination) (stun)
			212337, -- Powerful Smash (abomination) (stun)
			221562, -- Asphyxiate (Blood) (stun)
			207165, -- Abomination's Might (stun)
			207171, -- Winter is Coming (stun)
		},
  },
  dh = {
    SLOW = {
				 198813, -- Vengeful Retreat (slow)
				 204843, -- Sigil of Chains (slow)
				 210003, -- Razor Spikes (slow)
    },
    INCAPACITATE = {
      217832, -- Imprison (incapacitate)
    },
		DISORIENT = {
      207685, -- Sigil of Misery (disorient)
		},
		ROOT = {
		},
		STUN = {
      179057, -- Chaos Nova (stun)
      200166, -- Metamorphosis (Havoc) (stun)
      211881, -- Fel Eruption (stun)
		},
  },
  druid = {
    SLOW = {
		  50259, -- Dazed
		  61391, -- Typhoon (slow) (knockback)
		 127797, -- Ursol's Vortex (slow) (knockback)
			58180, -- Infected Wounds (slow)
    },
		DISORIENT = {
		},
		[339] = "ROOT", -- Entagling Roots (root)
		ROOT = {
			 45334, -- Immobilized (root)
			102359, -- Mass Entaglement (root)
		},
		[  99] = "INCAPACITATE", -- Incapacitating Roar (incapacitate)
		[5211] = "STUN", -- Mighty Bash (stun)
		STUN = {
			163505, -- Rake (stun)
			203123, -- Maim (stun)
		},
    SILENCE = {
			 81261, -- Solar Beam

    },
  },
  hunter = {
    SLOW = {
       35346, -- Warp Time (Warp Stalker) (slow)
       50433, -- Ankle Crack (Crocolisk) (slow)
       54644, -- Frost Breath (Chimaera) (slow)
      160065, -- Tendon Rip (Silithid) (exotic) (slow)
      160067, -- Web Spray (Spider)
			206755, -- Ranger's Net (slow)
    },
		STUN = {
				 24394, -- Intimidation (stun)
				117526, -- Binding Shot (stun)
		},
    SILENCE = {
				202933, -- Spider Sting (Silenced debuff) (PvP)
    },
		DISORIENT = {
			213691, -- Scatter Shot (disorient) (PvP)
			224729, -- Bursting Shot (disorient)
		},
		INCAPACITATE = {
			  3355, -- Freezing Trap (incapacitate)
			 19386, -- Wyvern Sting (incapacitate)
			209790, -- Freezing Arrow (incapacitate) (PvP)
		},
		ROOT = {
			162480, -- Steel Trap (root)
			201158, -- Super Sticky Tar (root)
			212638, -- Tracker's Net (root) (PvP)
			162487, -- Steel Trap (bleed)
			200108, --- Ranger's Net (root)
		},
  },
  mage = {
    SLOW = {
				157981, -- Blast Wave (slow)
				205021, -- Ray of Frost (slow)
				212792, -- Cone of Cold (slow)
			  2120, -- Flamestrike (slow)
			 31589, -- Slow (slow)
			205708, -- Chilled (slow)
			228354, -- Flurry (slow)
    },
		[31661] = "DISORIENT", -- Dragon's Breath (disorient)
		[82691] = "INCAPACITATE", -- Ring of Frost (incapacitate)
		[228600] = "ROOT", -- Glacial Spike (root) -- TODO: check category
		ROOT = {
			  122, -- Frost Nova (root)
			33395, -- Freeze (Water Elemental) (root)
  	 157997, -- Ice Nova (root) -- TODO: check category
		},
		DISORIENT = {
		},
		INCAPACITATE = {
			   118, -- Polymorph (incapacitate)
			 28271, -- Polymorph: Turtle (incapacitate)
			 28272, -- Polymorph: Pig (incapacitate)
			 61305, -- Polymorph: Black Cat (incapacitate)
			 61721, -- Polymorph: Rabbit (incapacitate)
			 61780, -- Polymorph: Turkey (incapacitate)
			126819, -- Polymorph: Pig (porcupine) (incapacitate)
			161353, -- Polymorph: Polar Bear Cub (incapacitate)
			161354, -- Polymorph: Monkey (incapacitate)
			161355, -- Polymorph: Penguin (incapacitate)
			161372, -- Polymorph: Monkey (incapacitate)
		},
		STUN = {
		},
  },
  monk = {
    SLOW = {
			121253, -- Keg Smash (slow)
			123586, -- Flying Serpent Kick (slow)
      196733, -- Special Delivery (slow)
      205320, -- Strike of the Windlord (WW artifact) (slow)
      116095, -- Disable (slow)
			196723, -- Dizzying Kicks
    },
		[115078] = "INCAPACITATE", -- Paralysis (Incapacitate)
		[119381] = "STUN", -- Leg Sweep (stun)
		[198909] = "DISORIENT", -- Song of Chi-Ji (Disorient)
		[120086] = "STUN", -- Fists of Fury
		DISORIENT = {
		},
		ROOT = {
			116706,  -- Disable (root)
		},
		STUN = {
		},
  },
  paly = {
    SLOW = {
    },
		DISORIENT = {
		},
		ROOT = {
		},
		STUN = {
		},
  },
  dh = {
    SLOW = {
				183218, -- Hand of Hindrance (slow)
				204242, -- Consecration
				205273, -- Wake of Ashes (Retribution artifact) (slow)
    },
		[ 20066] = "INCAPACITATE", -- Repentance (incapacitate)
		[ 62124] = "TAUNT", -- Hand of Reckoning (taunt)
		[105421] = "DISORIENT", -- Blinding Light (disorient)
		STUN = {
			   853, -- Hammer of Justice (stun)
			205290, -- Wake of Ashes (Retribution artifact) (stun)
		},
		DISORIENT = {
		},
		ROOT = {
		},
  },
}

local cooldowns = {
  --dk
  [ 47528] = "INTERRUPT",
  --dh
	[183752] = "INTERRUPT", -- Consume Magic
  --druid
	[106839] = "INTERRUPT", -- Skull Bash
  -- hunter

		INTERRUPT = {
			147362, -- Counter Shot
			187707, -- Muzzle
		},
  -- mage
		[  2139] = "INTERRUPT", -- Counterspell
    -- monk
		[116705] = "INTERRUPT", -- Spear Hand Strike
    -- paly
		[ 96231] = "INTERRUPT", -- Rebuke
}
