local data = {
	-- Mage

  [    66] = { default = true, cooldown = 300, class = "MAGE", defensive = 0.1, duration = 20 }, -- Invisibility
  [  1953] = { default = true, cooldown = 15, class = "MAGE", blink = true }, -- Blink
  [212653] = { parent = 1953, charges = 2 }, -- Shimmer
  [  2139] = { default = true, cooldown = 24, class = "MAGE", interrupt = true }, -- Counterspell
  [ 11426] = { default = true, cooldown = 25, class = "MAGE", defensive = 0.1, duration = 60, dispellable = true }, -- Ice Barrier
  [ 45438] = { default = true, cooldown = 300, class = "MAGE", charges = 2, defensive = 1, duration = 10, immune = "all" }, -- Ice Block
  [ 55342] = { default = true, cooldown = 120, class = "MAGE", offensive = true, talent = {} }, -- Mirror Image
  [ 80353] = { default = true, cooldown = 300, class = "MAGE", offensive = 0.3, duration = 40, dispellable = true }, -- Time Warp
  [108839] = { default = true, cooldown = 20, class = "MAGE", charges = 3, sprint = true, dispellable = true }, -- Ice Floes
  [113724] = { default = true, cooldown = 45, class = "MAGE", cc = true , talent = {108839} }, -- Ring of Frost
  -- [116011] = { default = true, cooldown = 40, class = "MAGE", charges = 2 }, -- Rune of Power
  [   118] = { default = true, class = "MAGE", cc = "incapacitate", cast = 1.7, duration = 8}, -- Polymorph
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
  [198111] = { default = true, cooldown = 45, class = "MAGE", duration = 6, dispellable = true, defensive = 0.5}, -- Temporal Shield
  -- Arcane TBD

  [ 12042] = { default = true, cooldown = 90, class = "MAGE", specID = { 62 }, offensive = 0.3, duration = 10, dispellable = true }, -- Arcane Power
  [ 12051] = { default = true, cooldown = 90, class = "MAGE", specID = { 62 }, offensive = 0.1, duration = 6 }, -- Evocation
  [153626] = { default = true, cooldown = 20, class = "MAGE", specID = { 62 } }, -- Arcane Orb
  [157980] = { default = true, cooldown = 25, class = "MAGE", specID = { 62 } }, -- Supernova
  [195676] = { default = true, cooldown = 24, class = "MAGE", specID = { 62 } }, -- Displacement
  [198158] = { default = true, cooldown = 60, class = "MAGE", specID = { 62 }, offensive = 0.1, duration = 5 }, -- Mass Invisibility
  [205025] = { default = true, cooldown = 60, class = "MAGE", specID = { 62 }, offensive = true }, -- Presence of Mind
  [224968] = { default = true, cooldown = 60, class = "MAGE", specID = { 62 } }, -- Mark of Aluneth
  [110959] = { parent = 66, cooldown = 75, specID = { 62 }, offensive = 0.6 }, -- Greater Invisibility

  -- Fire TBD

  [ 31661] = { default = true, cooldown = 20, class = "MAGE", specID = { 63 }, cc = "disorient", duration = 4 }, -- Dragon's Breath
  [108853] = { default = true, cooldown = 12, class = "MAGE", specID = { 63 }, charges = 2 }, -- Fire Blast
  [153561] = { default = true, cooldown = 45, class = "MAGE", specID = { 63 } }, -- Meteor
  [157981] = { default = true, cooldown = 25, class = "MAGE", specID = { 63 } }, -- Blast Wave
  [190319] = { default = true, cooldown = 115, class = "MAGE", specID = { 63 }, duration = 10, offensive = 0.5, dispellable = true }, -- Combustion
  [194466] = { default = true, cooldown = 45, class = "MAGE", specID = { 63 }, charges = 3 }, -- Phoenix's Flames
  [205029] = { default = true, cooldown = 45, class = "MAGE", specID = { 63 } }, -- Flame On
  [203286] = { default = true, class = "MAGE", specID = { 63 }, cast = 4.5, offensive = true }, -- Greater Pyroblast

  -- Frost

  [   122] = { default = true, cooldown = 30, class = "MAGE", specID = { 64 }, cc = "root", duration = 8}, -- Frost Nova
  [ 12472] = { default = true, cooldown = 180, class = "MAGE", specID = { 64 }, offensive = 0.5, dispellable = true, duration = 20, talent = {198144} }, -- Icy Veins
  [198144] = { default = true, cooldown = 60, class = "MAGE", specID = { 64 }, offensive = 0.5, dispellable = true, duration = 12, replaces = {12472} }, -- Ice Form
  -- [31687] = { default = true, cooldown = 60, class = "MAGE", specID = { 64 } }, -- Summon Water Elemental
  -- [84714] = { default = true, cooldown = 60, class = "MAGE", specID = { 64 } }, -- Frozen Orb
  -- [153595] = { default = true, cooldown = 30, class = "MAGE", specID = { 64 } }, -- Comet Storm
  [157997] = { default = true, cooldown = 25, class = "MAGE", specID = { 64 }, offensive = true, cc = "root", duration = 2 }, -- Ice Nova
  [205021] = { default = true, cooldown = 60, class = "MAGE", specID = { 64 }, offensive = true, talent = {} }, -- Ray of Frost
  [199786] = { default = true, class = "MAGE", specID = { 64 }, cast = 3, offensive = true}, -- Glacial Spike
  -- [214634] = { default = true, cooldown = 45, class = "MAGE", specID = { 64 } }, -- Ebonbolt

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end

dispellable
