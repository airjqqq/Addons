local filterName = "PVPFilter"
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local Filter = Core:GetModule("Filter")
local F = Filter:NewModule(filterName, "AceEvent-3.0")
local color = "00FF33"
local L = setmetatable({},{__index = function(t,k) return k end})

function F:OnInitialize()
  -- self:RegisterFilter("PVPDOTATTACK",L["[PVP] Don't Attack"])
  self:RegisterFilter("RATE",L["PVP Rate"],{name= {},greater= {},value= {}})
  self:RegisterFilter("CANKICKME",L["PVP Kick Me"],{unit= {}})
  self:RegisterFilter("PVPINTERRUPTED",L["PVP Interrupted"],{unit= {},greater= {},value= {}})
  self:RegisterFilter("DEATHED",L["PVP Deathed"],{unit= {},greater= {},value= {}})
  self:RegisterFilter("PVPBUFF",L["PVP Buff"],{unit= {},name= {},greater= {},value= {}})
  self:RegisterFilter("PVPIMMUNITY",L["PVP Immunity"],{unit= {},name= {},greater= {},value= {}})
  self:RegisterFilter("PVPEVASION",L["PVP Evasioning"],{unit= {}})
  self:RegisterFilter("PVPDEBUFF",L["PVP Debuff"],{unit= {},name= {},greater= {},value= {}},{
    MAGIC = L["Magic"],
    CURSE = L["Curse"],
  })
  self:RegisterFilter("PVPBREAKDEBUFF",L["PVP Breaks"],{unit= {},greater= {},value= {}})
  self:RegisterFilter("PVPDR",L["PVP DR"],{unit= {},greater= {},value= {}},{
    INCAPACITATE = L["Poly"],
    DISORIENT = L["Fear"],
    STUN = L["Stun"],
    SILENCE = L["Silence"],
    ROOT = L["Root"],
  })
  self:RegisterFilter("PVPDRCOUNT",L["PVP DR Count"],{unit= {},greater= {},value= {}},{
    INCAPACITATE = L["Poly"],
    DISORIENT = L["Fear"],
    STUN = L["Stun"],
    SILENCE = L["Silence"],
    ROOT = L["Root"],
  })
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
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
		[ 33891] = "IPOLY", --
		[   768] = "IPOLY", --
		[   783] = "IPOLY", --
		[197625] = "IPOLY", --
		[ 24858] = "IPOLY", --
		[  5487] = "IPOLY", --
		[  5487] = "IPOLY", --

  },

  hunter = {
		[186265] = "IPDAMAGE IPDEBUFF IMDAMAGE IMDEBUFF", -- Aspect of the Turtle
  },
  mage = {
    [ 32612] = "STEALTH",
    [198144] = "ISTUN",
    [ 11426] = "SHEILD",
    [198111] = "SHEILD",
  	[ 45438] = "IPDAMAGE IPDEBUFF IMDAMAGE IMDEBUFF", -- Ice Block
  	[198065] = "IMDAMAGE", --
  },
  monk = {
	  [125174] = "IPDAMAGE IMDAMAGE", -- Touch of Karma
	  [122470] = "IPDAMAGE IMDAMAGE", -- Touch of Karma
	  [124682] = "BIGHOT", -- Enveloping Mist
		[119611] = "HOT", -- Renewing Mist
  },
  pally = {
    [  1044] = "ISLOW IROOT", -- Blessing of Freedom
    [184662] = "SHEILD",
    HOT = {
      200652, -- Tyr's Deliverance (HoT) (Holy artifact)
      200654, -- Tyr's Deliverance (Holy artifact)
    },
    [204018] = "IMDAMAGE IMDEBUFF", -- Blessing of Spellwarding
		[  1022] = "IPDAMAGE IPDEBUFF", -- Blessing of Protection
		[   642] = "IPDAMAGE IPDEBUFF IMDAMAGE IMDEBUFF", -- Divine Shield
  },
  priest = {
    SHEILD = {
      17, -- Power Word: Shield
			 152118, -- Clarity of Will
    },
    [ 47585] = "ISLOW IROOT", -- Dispersion
    IMPORTANT = {
			10060, -- Power Infusion
    },
    HOT = {
  	    139, -- Renew
  	  41635, -- Prayer of Mending

    },
  },
  rouge = {
    [ 31224] = "IMDEBUFF IMDAMAGE", -- Cload of Shadows
  },
  shaman = {
    HOT = {

				 61295, -- Riptide
    },
    [23920] = "IMDEBUFF ICAST", -- Grounding
  },
  warrior = {
    [ 46924] = "ISLOW IROOT ICONTROL", -- Bladestorm (Fury)
    [227847] = "ISLOW IROOT ICONTROL", -- Bladestorm (Arms)
    [23920] = "ICAST", -- S R
    [216890] = "ICAST", -- S R
    [213915] = "ICAST", -- S R

  },
  warlock = {
    [212295] = "ICAST",
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
			204206, -- pvp talent 6/3
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
      33786, -- Cyclone
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
      195645,
      194279,
      135299,
    },
		STUN = {
				 24394, -- Intimidation (stun)
				117526, -- Binding Shot (stun)
		},
    SILENCE = {
				202933, -- Spider Sting (Silenced debuff) (PvP)
				1330, -- Grose
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
		[232055] = "STUN", -- Fists of Fury
		DISORIENT = {
		},
		ROOT = {
			116706,  -- Disable (root)
		},
		STUN = {
		},
  },
  pally = {
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
  priest = {
    SLOW = {
				204263, -- Shininig Force (slow)
    },
		[  8122] = "DISORIENT", -- Psychic Scream (disorient)
		[200196] = "INCAPACITATE", -- Holy Word: Chastise (incapacitate)
		STUN = {
			200200, -- Holy Word: Chastise (with Censure) (stun)
			226943, -- Mind Bomb (stun)
		},
    SILENCE = {
				 15487, -- Silence -- NOTE: non-players only INTERRUPT, special case
    },
    NEEDDISP = {
  				205369, -- Mind Bomb
    },
  },
  racial = {
    SILENCE = {
			 28730, -- Arcane Torrent (Blood elf mana)
			 50613, -- Arcane Torrent (Blood elf runic power)
			 80483, -- Arcane Torrent (Blood elf focus)
			 25046, -- Arcane Torrent (Blood elf energy)
			 69179, -- Arcane Torrent (Blood elf rage)
			129597, -- Arcane Torrent (Blood elf chi)
			155145, -- Arcane Torrent (Blood elf holy power)
		},
    INCAPACITATE = {
      107079, -- Quaking Palm (Monk)
    },
		STUN = {
     20549, -- War Stomp (Tauren)
		},
  },
  rouge = {
    SLOW = {
			185763, -- Pistol Shot (slow)
			185778, -- Shellshocked (slow)
			206760, -- Night Terrors (slow)
			222775, -- Strike from the Shadows (slow)
			209786, -- Goremaw's Bite (Subtlety artifact) (slow)
			  3409, -- Poto
    },
    [2094] = "DISORIENT", -- Blind (disorient)
		INCAPACITATE = {
			  1776, -- Gouge (incapacitate)
			199743, -- Parley (incapacitate)
		},
		[6770] = "INCAPACITATE", -- Sap (incapacitate)
		STUN = {
			   408, -- Kidney Shot (stun)
			199804, -- Between the Eyes (stun)
			  1833, -- Cheap Shot (stun)
			196958, -- Strike from the Shadows (stun)
		},
  },
  shaman = {
    SLOW = {
  		 51490, -- Thunderstorm (slow) (knockback)
  		 3600, -- Totem
  		116947, -- Earthbind (slow)
			224126, -- Frozen Bite (Enhancement artifact) (slow)
			 197385, -- Fury of Air (slow)
			 196840, -- Frost Shock (slow)
     },
    INCAPACITATE = {
			 51514, -- Hex (incapacitate)
			 211015, -- Hex (incapacitate)
			 211004, -- Hex (incapacitate)
			 211010, -- Hex (incapacitate)
			 210873, -- Hex (incapacitate)
			196942, -- Hex (Voodoo Totem) (incapacitate)
		},
		ROOT = {
			64695, -- Earthgrab (root)
			197214, -- Sundering (root)
		},
		STUN = {
			118345, -- Pulverize (Primal Earth Elemental) (stun)
			118905, -- Static Charge (stun)
		},
  },
  warlock = {
    SLOW = {
			170995, -- Criple (Doomguard with Grimoire of Supremacy) (slow)
    },
		[6789] = "INCAPACITATE", -- Mortal Coil (incapacitate)
		DISORIENT = {
			5484, -- Howl of Terror (disorient)
			6358, -- Seduction (Succubus) (disorient)
		},
		STUN = {
			 22703, -- Infernal Awakening (Infernal) (stun)
			 30283, -- Shadowfury (stun)
			 89766, -- Axe Toss (Felguard) (stun)
			171017, -- Meteor Strike (Infernal with Grimoire of Supremacy) (stun)
		},
		[   710] = "INCAPACITATE", -- Banish (incapacitate)
		[118699] = "DISORIENT", -- Fear (disorient)
  },
  warrior = {
    SLOW = {
			6343, -- Thunder Clap (slow)
		  1715, -- Hamstring (slow)
		 12323, -- Piercing Howl (slow)
		236027, -- Charge (slow)
    },
		[5246] = "DISORIENT", -- Intimidating Shout (disorient)
		STUN = {
			  7922, -- Warbringer Stun (stun)
			132168, -- Shockwave (stun)
			132169, -- Storm Bolt (stun)
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
    -- rouge
		[  1766] = "INTERRUPT", -- Kick
    -- shaman
		[ 57994] = "INTERRUPT", -- Wind Shear
    -- warlock
		INTERRUPT = {
			 19647, -- Spell Lock (Felhunter)
			111897, -- Grimoire: Felhunter
			119910, -- Spell Lock (Comand Demon with Felhunter)
			171138, -- Shadow Lock (Doomguard with Grimoire of Supremacy)
			171140, -- Shadow Lock (Command Demon with Doomguard)
		},
    --warrior
		[  6552] = "INTERRUPT", -- Pummel
}

local kicks = {

    --dk
  [ 47528] = {15,15,3,250,251,252},
  --warrior
  [  6552] = {2,15,4,71,72,73}, -- Pummel
  -- paly
  [ 96231] = {2,15,4,66,70}, -- Rebuke
  -- hunter
	[147362] = {40,24,3,253,254}, -- Counter Shot
	[187707] = {2,15,3,255}, -- Muzzle
  -- shaman
  [ 57994] = {25,12,3,262,263,264}, -- Wind Shear
  --dh
	[183752] = {15,15,3,577,581}, -- Consume Magic
  --druid
	[106839] = {13,15,4,103,104}, -- Skull Bash
  -- monk
	[116705] = {2,15,4,268,269}, -- Spear Hand Strike
  -- rouge
	[  1766] = {2,15,5,259,260,261}, -- Kick
  -- mage
	[  2139] = {40,24,6,62,63,64}, -- Counterspell
  -- warlock
	[ 19647] = {40,24,6,"417"}, -- Spell Lock (Felhunter)
  -- [119910] = {40,24,265,266,267}, -- Spell Lock (Comand Demon with Felhunter)
  [171138] = {40,24,6,"78215"}, -- Shadow Lock (Doomguard with Grimoire of Supremacy)
  -- [171140] = {40,24,265,266,267}, -- Shadow Lock (Command Demon with Doomguard)
	-- [111897] = {40,90,265,266,267}, -- Grimoire: Felhunter
}

local castings = {

}

local kicked = {}

local function getSpellIs(ids, keys)
  local toRet = {}
  for cls, data in pairs(ids) do
    for k,v in pairs(data) do
      if type(v) == "table" then
        for i,id in ipairs(v) do
          if keys[k] then
            toRet[id] = true
          end
        end
      else
        local vs = {strsplit(" ",v)}
        local id = k
        for i,t in ipairs(vs) do
          if keys[t] then
            toRet[id] = true
            break
          end
        end
      end
    end
  end
  return toRet
end


local drdebuffs = {}

do
  drdebuffs.INCAPACITATE = getSpellIs(debuffs,{INCAPACITATE=true})
  drdebuffs.DISORIENT = getSpellIs(debuffs,{DISORIENT=true})
  drdebuffs.STUN = getSpellIs(debuffs,{STUN=true})
  drdebuffs.SILENCE = getSpellIs(debuffs,{SILENCE=true})
  drdebuffs.ROOT = getSpellIs(debuffs,{ROOT=true})
end

local drtimes = {}
do
  drtimes.INCAPACITATE = {}
  drtimes.DISORIENT = {}
  drtimes.STUN = {}
  drtimes.SILENCE = {}
  drtimes.ROOT = {}
end

function Core:GetDrData(type,guid)
  if drtimes[type] then
    return drtimes[type][guid]
  end
end

function F:COMBAT_LOG_EVENT_UNFILTERED (event, t, realEvent, ...)
  local spellId = select(10,...)
  local guid = select(6,...)
  local sourceGUID = select(2,...)
  local time = GetTime()
  local spelltype = select(13,...)
	if realEvent == "SPELL_DISPEL" then
		-- print(realEvent, select(3,...), select(7,...), spellId and GetSpellLink(spellId))
	end
  if spelltype == "DEBUFF" then -- DR
    if realEvent == "SPELL_AURA_APPLIED" or realEvent == "SPELL_AURA_REFRESH" then
      for t,d in pairs(drdebuffs) do
        if d[spellId] then
          local data = drtimes[t][guid]
          if not data or time>data.t then
            data = {c=1}
          else
            data.c = data.c + 1
          end
          data.spellId = spellId
          data.t = time + 18.5 + 8
          drtimes[t][guid] = data
          -- Core:Print("DR_SPELL_AURA_APPLIED",GetSpellLink(spellId))
        end
      end
    elseif realEvent == "SPELL_AURA_REMOVED" or realEvent == "SPELL_DISPEL" then
      for t,d in pairs(drdebuffs) do
        if d[spellId] then
          local data = drtimes[t][guid]
          if not data or time>data.t then
            data = {c=1}
          end
          data.spellId = spellId
          data.t = time + 18.5
          drtimes[t][guid] = data
          -- Core:Print("DR_SPELL_AURA_REMOVED",GetSpellLink(spellId))
        end
      end
    end
  end
  if realEvent == "SPELL_CAST_SUCCESS" or realEvent == "SPELL_CAST_FAILED" then
    local data = kicks[spellId]
    if data then
      local range,cooldowns = data[1],data[2]
      kicked[sourceGUID] = GetTime()+cooldowns
    end
  end
end

function F:RATE(filter)
  local index = filter.name[1]
  if not index then return end
  local r = GetPersonalRatedInfo(index)
  return r
end
function F:DEATHED(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local data = Cache.cache.castSuccess:find({sourceGUID=guid,spellId=209780})
  return data and GetTime() - data.t
end

function F:PVPKICK(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local exists,harm,help = Cache:GetExists(guid,filter.unit)
  if not harm then return false end
  if F:PVPDEBUFF({unit=filter.unit,greater=true,name={"DISORIENT","INCAPACITATE","STUN"}}) then return false end
  if kicked[guid] and kicked[guid] >GetTime() then return false end
  local specId = Cache:GetSpecInfo(guid)
  if not specId then
    local objectType,serverId,instanceId,zone,id,spawn = AirjHack:GetGUIDInfo(guid)
    specId = id
  end
  if not specId then return false end
  local _,_,_,_,distance = Cache:GetPosition(guid)
  for _,data in pairs(kicks) do
    local range,cooldowns = data[1],data[2]
    local specs = {unpack(data,4)}
    if distance<range+3 then
      for _,s in pairs(specs) do
        if s == specId then
          return true
        end
      end
    end
  end
  return false
end

function F:PVPINTERRUPTED(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  local t = GetTime()
  for v,k,i in Cache.cache.interrupt:iterator({destGUID=guid}) do
    if t-v.t>120 then
      break
    end
    local data = kicks[v.spellId]
    if data then
      local value = v.t+data[3] - GetTime()
      if value > 0 then
        return value
      else
        return
      end
    end
  end
end

function F:CANKICKME(filter)
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local exists,harm,help = Cache:GetExists(guid,filter.unit)
  if not harm then return false end
  if F:PVPDEBUFF({unit=filter.unit,greater=true,name={"DISORIENT","INCAPACITATE","STUN"}}) then return false end
  if kicked[guid] and kicked[guid] >GetTime() then return false end
  local specId = Cache:GetSpecInfo(guid)
  if not specId then
    local objectType,serverId,instanceId,zone,id,spawn = AirjHack:GetGUIDInfo(guid)
    specId = id
  end
  if not specId then return false end
  local _,_,_,_,distance = Cache:GetPosition(guid)
  local speed = Cache:Call("GetUnitSpeed",filter.unit)
  if speed > 6 then
    distance = distance - 2
  elseif speed > 3 then
    distance = distance - 1
  end
  for _,data in pairs(kicks) do
    local range,cooldowns = data[1],data[2]
    local specs = {unpack(data,3)}
    if distance<range+3 then
      for _,s in pairs(specs) do
        if s == specId then
          return true
        end
      end
    end
  end
  return false
end


function F:PVPDR(filter)
  assert(filter.subtype)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local datas = drtimes[filter.subtype]
  local data = datas[guid]
  if not data then return 0 end
  local value = data.t-GetTime()
  return math.max(value,0)
end

function F:PVPDRCOUNT(filter)
  assert(filter.subtype)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local datas = drtimes[filter.subtype]
  local data = datas[guid]
  if not data then return 0 end
  local value = data.t-GetTime()
  if value > 0 then
    return data.c
  else
    return 0
  end
end


function F:PVPBUFF(filter)
  filter.name = filter.name or {"IMPORT","TARGET","BIGHOT","SHEILD","HOT"}
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local types = Core:ToKeyTable(filter.name)
  local spells = getSpellIs(buffs,types)
  local buffs = Cache:GetBuffs(guid,filter.unit,spells)
  local t = GetTime()
  for i,v in pairs(buffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local value
    if filter.subtype == "COUNT" then
      value = count
    elseif filter.subtype == "START" then
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (t-expires+duration)/timeMod
      end
    elseif filter.subtype == "OBSERV" then
      value = value2
    else
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (expires - t)/timeMod
      end
    end
    if Core:MatchValue(value,filter) then
      return true
    end
  end
  return false
end


function F:PVPEVASION(filter)
  local pi = math.pi
  local buffids = {
    [118038] = true, -- [1]
    [226364] = true, -- [2]
    [  5277] = true, -- [3]
    [192422] = true, -- [4]
    [199754] = true, -- [5]
    [212800] = true, -- [6]
  }
  filter.unit = filter.unit or "target"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local buffs = Cache:GetBuffs(guid,filter.unit,buffids)
  if #buffs == 0 then return false end
  local pguid = Cache:PlayerGUID()
  local px,py,pz = Cache:GetPosition(pguid)
  local x,y,z,f = Cache:GetPosition(guid)
  if not x then return false end
  local dx,dy,dz = x-px, y-py, z-pz
  local angle = math.atan2(dy,dx)
  angle = angle - (f + pi/2)
  if angle < -pi then
    angle = angle + 2*pi
  elseif angle > pi then
    angle = angle - 2*pi
  end
  if 180-math.abs(angle*180/pi)>90 then return false end
  local types = Core:ToKeyTable({"DISORIENT","INCAPACITATE","STUN"})
  local spells = getSpellIs(debuffs,types)
  local debuffs = Cache:GetDebuffs(guid,filter.unit,spells)
  if #debuffs>0 then return false end
  return true
end


function F:PVPIMMUNITY(filter)
  filter.name = filter.name or {"IPDAMAGE","IPDEBUFF","IMDAMAGE","IMDEBUFF","ISLOW","IROOT"}
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local types = Core:ToKeyTable(filter.name)
  local spells = getSpellIs(buffs,types)
  local buffs = Cache:GetBuffs(guid,filter.unit,spells)
  local t = GetTime()
  for i,v in pairs(buffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local value
    if filter.subtype == "COUNT" then
      value = count
    elseif filter.subtype == "START" then
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (t-expires+duration)/timeMod
      end
    elseif filter.subtype == "OBSERV" then
      value = value2
    else
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (expires - t)/timeMod
      end
    end
    if Core:MatchValue(value,filter) then
      return true
    end
  end
  local debuffs = Cache:GetDebuffs(guid,filter.unit,{[33786]=true,[209753]=true,[203337]=true})
  for i,v in pairs(debuffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local value
    if filter.subtype == "COUNT" then
      value = count
    elseif filter.subtype == "START" then
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (t-expires+duration)/timeMod
      end
    elseif filter.subtype == "NUMBER" then
      value = value2
    else
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (expires - t)/timeMod
      end
    end
    if Core:MatchValue(value,filter) then
      return true
    end
  end
  return false
end
function F:PVPDEBUFF(filter)
  filter.name = filter.name or {"DISORIENT","INCAPACITATE","STUN","ROOT","SLOW","SILENCE"}
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local types = Core:ToKeyTable(filter.name)
  local spells = getSpellIs(debuffs,types)
  local debuffs = Cache:GetDebuffs(guid,filter.unit,spells)
  local t = GetTime()
  for i,v in pairs(debuffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local value
    if filter.subtype == "CURSE" and dispelType == "Curse" or filter.subtype == "MAGIC" and dispelType == "Magic" or filter.subtype ~= "MAGIC" and filter.subtype ~= "CURSE"  then
      if duration == 0 and expires ==0 then
        value = 10
      else
        value = (expires - t)/timeMod
      end
      if Core:MatchValue(value,filter) then
        return true
      end
    end
  end
  return false
end

function F:PVPBREAKDEBUFF(filter)
  filter.unit = filter.unit or "player"
  local guid = Cache:UnitGUID(filter.unit)
  if not guid then return false end
  local health, max, prediction, absorb, healAbsorb, isdead = Cache:GetHealth(guid)
  if health and health/max < 0.4 then
    return false
  end
  local types = Core:ToKeyTable({"DISORIENT","INCAPACITATE"})
  local spells = getSpellIs(debuffs,types)
  spells[6789] = nil
  spells[33786] = nil
  spells[207167] = nil
  spells[8122] = nil
  spells[5246] = nil
  spells[212638] = true
  local debuffs = Cache:GetDebuffs(guid,filter.unit,spells)
  local t = GetTime()
  for i,v in pairs(debuffs) do
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = unpack(v)
    local value
    if duration == 0 and expires ==0 then
      value = 10
    else
      value = (expires - t)/timeMod
    end
    if Core:MatchValue(value,filter) then
      return true
    end
  end
  local data = Cache.cache.casting:find({guid=guid,spellId=118})
  if data and GetTime() - data.endTime/1000 < 0.5 then
    return 8
  end
  return false
end
