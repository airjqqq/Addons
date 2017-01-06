local data = {

  -- Death Knight

  [ 51052] = { default = true, cooldown = 120, class = "DEATHKNIGHT", duration = 10,replaces = {77606},defensive = true}, -- Anti-Magic Zone
  [ 77606] = { default = true, cooldown = 30, class = "DEATHKNIGHT", talent = {51052}, important = true, duration = 12}, -- Dark Simulacrum
  [212552] = { default = true, cooldown = 45, class = "DEATHKNIGHT", duration = 3, sprint = true, dispellable = true}, -- Wraith Walk
  [ 47528] = { default = true, cooldown = 15, class = "DEATHKNIGHT", interrupt = true,}, -- Mind Freeze
  [ 49576] = { default = true, cooldown = 25, class = "DEATHKNIGHT", blink = true}, -- Death Grip
  [ 48707] = { default = true, cooldown = 60, class = "DEATHKNIGHT", duration = 5, defensive = 0.5}, -- Anti-Magic Shell
  [ 61999] = { default = true, cooldown = 600, class = "DEATHKNIGHT", revival = true }, -- Raise Ally

  -- Blood TBD

  [ 43265] = { default = true, cooldown = 30, class = "DEATHKNIGHT", specID = { 250, 252 } }, -- Death and Decay
  [ 47476] = { default = true, cooldown = 60, class = "DEATHKNIGHT", specID = { 250 }, cc = "silence", duration = 5 }, -- Strangulate
  [ 49028] = { default = true, cooldown = 180, class = "DEATHKNIGHT", specID = { 250 } }, -- Dancing Rune Weapon
  [ 55233] = { default = true, cooldown = 90, class = "DEATHKNIGHT", specID = { 250 }, defensive = 0.25, duration = 10 }, -- Vampiric Blood
  [108199] = { default = true, cooldown = 180, class = "DEATHKNIGHT", specID = { 250 } }, -- Gorefiend's Grasp
  [194679] = { default = true, cooldown = 25, class = "DEATHKNIGHT", specID = { 250 }, charges = 2, defensive = 0.25, duration = 3, talent = {} }, -- Rune Tap
  [194844] = { default = true, cooldown = 60, class = "DEATHKNIGHT", specID = { 250 } }, -- Bonestorm
  [203173] = { default = true, cooldown = 15, class = "DEATHKNIGHT", specID = { 250 } }, -- Death Chain
  [205223] = { default = true, cooldown = 45, class = "DEATHKNIGHT", specID = { 250 } }, -- Consumption
  [206931] = { default = true, cooldown = 30, class = "DEATHKNIGHT", specID = { 250 } }, -- Blooddrinker
  [206977] = { default = true, cooldown = 120, class = "DEATHKNIGHT", specID = { 250 } }, -- Blood Mirror
  [219809] = { default = true, cooldown = 60, class = "DEATHKNIGHT", specID = { 250 } }, -- Tombstone
  [221562] = { default = true, cooldown = 45, class = "DEATHKNIGHT", specID = { 250, 252 }, cc = "stun", duration = 5 }, -- Asphyxiate (Blood)
  [108194] = { parent = 221562 }, -- Asphyxiate (Unholy)
  [221699] = { default = true, cooldown = 60, class = "DEATHKNIGHT", specID = { 250 }, charges = 2 }, -- Blood Tap

  -- Frost

  [ 47568] = { default = true, cooldown = 180, class = "DEATHKNIGHT", specID = { 251 }, offensive = true}, -- Empower Rune Weapon
  [207127] = { parent = 47568, default = true, duration = 12 , talent = {47568}}, -- Hungering Rune Weapon
  [ 48792] = { default = true, cooldown = 180, class = "DEATHKNIGHT", specID = { 251, 252 }, defensive = 0.2, duration = 8 }, -- Icebound Fortitude
  [ 51271] = { default = true, cooldown = 60, class = "DEATHKNIGHT", specID = { 251 }, offensive = 0.3, duration = 20 }, -- Pillar of Frost
  [152279] = { default = true, cooldown = 120, class = "DEATHKNIGHT", specID = { 251}, offensive = 0.2, duration = 12, talent = {207256}}, -- Breath of Sindragosa
  [190778] = { default = true, cooldown = 300, class = "DEATHKNIGHT", specID = { 251}, offensive=true }, -- Sindragosa's Fury
  [196770] = { default = true, cooldown = 20, class = "DEATHKNIGHT", specID = { 251 }, cc = true }, -- Remorseless Winter
  -- [204143] = { default = true, cooldown = 45, class = "DEATHKNIGHT", specID = { 251 } }, -- Killing Machine
  [204160] = { default = true, cooldown = 45, class = "DEATHKNIGHT", specID = { 251 }, offensive = true }, -- Chill Streak
  [207167] = { default = true, cooldown = 60, class = "DEATHKNIGHT", specID = { 251}, talent = {}, cc = "disorient", duration = 4 }, -- Blinding Sleet
  [207256] = { default = true, cooldown = 90, class = "DEATHKNIGHT", specID = { 251}, replaces = {152279}, offensive = 0.2, duration = 8 }, -- Obliteration

  -- Unholy TBD

  [ 42650] = { default = true, cooldown = 600, class = "DEATHKNIGHT", specID = { 252 } }, -- Army of the Dead
  [ 63560] = { default = true, cooldown = 60, class = "DEATHKNIGHT", specID = { 252 } }, -- Dark Transformation
  [ 49206] = { default = true, cooldown = 180, class = "DEATHKNIGHT", specID = { 252 } }, -- Summon Gargoyle
  [207349] = { parent = 49206 }, -- Dark Arbiter
  [ 43265] = { default = true, cooldown = 30, class = "DEATHKNIGHT", specID = { 252 } }, -- Death and Decay
  [152280] = { parent = 43265 }, -- Defile
  [130736] = { default = true, cooldown = 45, class = "DEATHKNIGHT", specID = { 252 } }, -- Soul Reaper
  [220143] = { default = true, cooldown = 90, class = "DEATHKNIGHT", specID = { 252 } }, -- Apocalypse
  [ 47481] = { default = true, cooldown = 90, class = "DEATHKNIGHT", specID = { 252 } }, -- Gnaw (Ghoul)
  [ 47482] = { default = true, cooldown = 30, class = "DEATHKNIGHT", specID = { 252 } }, -- Leap (Ghoul)
  [ 91802] = { default = true, cooldown = 30, class = "DEATHKNIGHT", specID = { 252 } }, -- Shambling Rush (Ghoul)
  [207319] = { default = true, cooldown = 60, class = "DEATHKNIGHT", specID = { 252 }, defensive = 0.9, duration = 10}, -- Corpse Shield
	[ 91797] = { default = true, cooldown = 90, class = "DEATHKNIGHT", specID = { 252 }, cc = "stun", duration = 2 },, -- Monstrous Blow
	[ 91800] = { default = true, cooldown = 90, class = "DEATHKNIGHT", specID = { 252 }, cc = "stun", duration = 1 },, -- Monstrous Blow
	[223929] = { default = true, class = "DEATHKNIGHT", specID = { 252 }, important = true, duration = 10 },, -- Monstrous Blow
}

for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
