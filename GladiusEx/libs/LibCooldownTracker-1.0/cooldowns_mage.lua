local data = {
	-- Mage

  [    66] = { default = false, cooldown = 300, class = "MAGE", defensive = true }, -- Invisibility
  [110959] = { parent = 66, cooldown = 75 }, -- Greater Invisibility
  [  1953] = { default = false, cooldown = 15, class = "MAGE", blink = true }, -- Blink
  [212653] = { parent = 1953, charges = 2 }, -- Shimmer
  [  2139] = { default = true, cooldown = 24, class = "MAGE", interrupt = true }, -- Counterspell
  [ 11426] = { default = false, cooldown = 25, class = "MAGE", defensive = true }, -- Ice Barrier
  [ 45438] = { default = false, cooldown = 300, class = "MAGE", charges = 2, defensive = 1, duration = 10 }, -- Ice Block
  [ 55342] = { default = false, cooldown = 120, class = "MAGE", offensive = true, talent = {} }, -- Mirror Image
  -- [80353] = { default = false, cooldown = 300, class = "MAGE", }, -- Time Warp
  [108839] = { default = false, cooldown = 20, class = "MAGE", charges = 3, sprint = true }, -- Ice Floes
  [113724] = { default = false, cooldown = 45, class = "MAGE", cc = true , talent = {108839} }, -- Ring of Frost
  -- [116011] = { default = false, cooldown = 40, class = "MAGE", charges = 2 }, -- Rune of Power
  [   118] = { default = false, class = "MAGE", cc = true, cast = 1.7}, -- Polymorph
	[ 28271] = { parent = 118 }, -- Turtle
	[ 28272] = { parent = 118 }, -- Pig
	[ 61305] = { parent = 118 }, -- Black Cat
	[ 61721] = { parent = 118 }, -- Rabbit
	[ 61025] = { parent = 118 }, -- Serpent
	[ 61780] = { parent = 118 }, -- Turkey
	[161372] = { parent = 118 }, -- Peacock
	[161355] = { parent = 118 }, -- Penguin
	[161353] = { parent = 118 }, -- Polar Bear Cub
	[161354] = { parent = 118 }, -- Monkey
	[126819] = { parent = 118 }, -- Porcupine
  -- Arcane TBD

  [ 12042] = { default = false, cooldown = 90, class = "MAGE", specID = { 62 }, offensive = 0.3, duration = 10 }, -- Arcane Power
  [ 12051] = { default = false, cooldown = 90, class = "MAGE", specID = { 62 } }, -- Evocation
  [153626] = { default = false, cooldown = 20, class = "MAGE", specID = { 62 } }, -- Arcane Orb
  [157980] = { default = false, cooldown = 25, class = "MAGE", specID = { 62 } }, -- Supernova
  [195676] = { default = false, cooldown = 24, class = "MAGE", specID = { 62 } }, -- Displacement
  [198158] = { default = false, cooldown = 60, class = "MAGE", specID = { 62 } }, -- Mass Invisibility
  [205025] = { default = false, cooldown = 60, class = "MAGE", specID = { 62 } }, -- Presence of Mind
  [224968] = { default = false, cooldown = 60, class = "MAGE", specID = { 62 } }, -- Mark of Aluneth

  -- Fire TBD

  [ 31661] = { default = false, cooldown = 20, class = "MAGE", specID = { 63 } }, -- Dragon's Breath
  [108853] = { default = false, cooldown = 12, class = "MAGE", specID = { 63 }, charges = 2 }, -- Fire Blast
  [153561] = { default = false, cooldown = 45, class = "MAGE", specID = { 63 } }, -- Meteor
  [157981] = { default = false, cooldown = 25, class = "MAGE", specID = { 63 } }, -- Blast Wave
  [190319] = { default = false, cooldown = 115, class = "MAGE", specID = { 63 }, duration = 10, offensive = 0.5 }, -- Combustion
  [194466] = { default = false, cooldown = 45, class = "MAGE", specID = { 63 }, charges = 3 }, -- Phoenix's Flames
  [205029] = { default = false, cooldown = 45, class = "MAGE", specID = { 63 } }, -- Flame On
  [203286] = { default = false, class = "MAGE", specID = { 63 }, cast = 4.5, offensive = true }, -- Greater Pyroblast

  -- Frost

  [   122] = { default = false, cooldown = 30, class = "MAGE", specID = { 64 }, cc = true}, -- Frost Nova
  [ 12472] = { default = false, cooldown = 180, class = "MAGE", specID = { 64 }, offensive = 0.5, dispelable = true, duration = 20, talent = {198144} }, -- Icy Veins
  [198144] = { default = false, cooldown = 60, class = "MAGE", specID = { 64 }, offensive = 0.5, dispelable = true, duration = 12, replaces = {12472} }, -- Ice Form
  -- [31687] = { default = false, cooldown = 60, class = "MAGE", specID = { 64 } }, -- Summon Water Elemental
  -- [84714] = { default = false, cooldown = 60, class = "MAGE", specID = { 64 } }, -- Frozen Orb
  -- [153595] = { default = false, cooldown = 30, class = "MAGE", specID = { 64 } }, -- Comet Storm
  [157997] = { default = false, cooldown = 25, class = "MAGE", specID = { 64 }, offensive = true }, -- Ice Nova
  [205021] = { default = false, cooldown = 60, class = "MAGE", specID = { 64 }, offensive = true, talent = {} }, -- Ray of Frost
  [199786] = { default = false, class = "MAGE", specID = { 64 }, cast = 3, offensive = true}, -- Glacial Spike
  -- [214634] = { default = false, cooldown = 45, class = "MAGE", specID = { 64 } }, -- Ebonbolt

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
