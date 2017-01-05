local data = {
	-- Warlock

  [  1122] = { default = false, cooldown = 180, class = "WARLOCK", cc = true, offensive = true }, -- Summon Infernal
  [  6358] = { default = false, cooldown = 30, class = "WARLOCK", cast = 1.7, cc= true }, -- Seduction
  -- [6360] = { default = false, cooldown = 25, class = "WARLOCK" }, -- Whiplash
  -- [115770] = { parent = 6360 }, -- Fellash
  [  6789] = { default = false, cooldown = 45, class = "WARLOCK", talent = {}, cc = true }, -- Mortal Coil
  -- [18540] = { default = false, cooldown = 180, class = "WARLOCK" }, -- Summon Doomguard
  -- [20707] = { default = false, cooldown = 600, class = "WARLOCK" }, -- Soulstone
  [104773] = { default = false, cooldown = {default = 180, [267] = 60}, class = "WARLOCK", defensive = true, duration = 8 }, -- Unending Resolve
  [108416] = { default = false, cooldown = 60, class = "WARLOCK", talent = {}, defensive = true }, -- Dark Pact
  [108501] = { default = false, cooldown = 90, class = "WARLOCK", cc = true }, -- Grimoire of Service
  [115268] = { parent = 6358 }, -- Mesmerize
  -- [115284] = { default = false, cooldown = 15, class = "WARLOCK" }, -- Clone Magic
  [119910] = { default = true, cooldown = 24, class = "WARLOCK", interrupt = true }, -- Spell Lock (Command Demon)
  [ 19647] = { parent = 119910 }, -- Spell Lock (Felhunter)
  [119911] = { parent = 119910 }, -- Optical Blast (Command Demon)
  [115781] = { parent = 119910 }, -- Optical Blast (Observer)
  [132409] = { parent = 119910 }, -- Spell Lock (Grimoire of Sacrifice)
  [171138] = { parent = 119910 }, -- Shadow Lock (Doomguard)
  [171139] = { parent = 119910 }, -- Shadow Lock (Grimoire of Sacrifice)
  [171140] = { parent = 119910 }, -- Shadow Lock (Command Demon)
  -- [171152] = { default = false, cooldown = 60, class = "WARLOCK" }, -- Meteor Strike
  [196098] = { default = true, cooldown = 120, class = "WARLOCK", offensive = 0.2, talent = {}, dispelable = true, duration = 16 }, -- Soul Harvest
  -- [199890] = { default = false, cooldown = 15, class = "WARLOCK" }, -- Curse of Tongues
  -- [199892] = { default = false, cooldown = 20, class = "WARLOCK" }, -- Curse of Weakness
  -- [199954] = { default = false, cooldown = 45, class = "WARLOCK" }, -- Curse of Fragility
  [212295] = { default = true, cooldown = 45, class = "WARLOCK", talent = {221703}, offensive = true, duration = 5, dispelable = true }, -- Nether Ward
  [221703] = { default = false, cooldown = 30, class = "WARLOCK", talent = {212295}, offensive = true, duration = 10 }, -- Casting Circle
  -- [48018] = { default = false, cooldown = 30, class = "WARLOCK", talent = {5484}, blink = true, duration = 10 }, -- Demonic Circle
  [  5782] = { default = false, class = "WARLOCK", cc = true, cast = 1.7 }, -- Fear

  -- Affliction

  [  5484] = { default = false, cooldown = 40, class = "WARLOCK", specID = { 265 }, talent = {48018}, cc = true }, -- Howl of Terror
  -- [48181] = { default = false, cooldown = 15, class = "WARLOCK", specID = { 265 } }, -- Haunt
  -- [86121] = { default = false, cooldown = 20, class = "WARLOCK", specID = { 265 } }, -- Soul Swap
  [205179] = { default = false, cooldown = 60, class = "WARLOCK", specID = { 265 }, offensive = true, duration = 15 }, -- Phantom Singularity
  [ 30108] = { default = false, class = "WARLOCK", specID = { 265 }, offensive = true, cast = 1.5 }, -- Unstable Affliction

  -- Demonology TBD

  [ 30283] = { default = false, cooldown = 30, class = "WARLOCK", specID = { 266, 267 }, cc = true, cast = 1.5 }, -- Shadowfury
  [ 89751] = { default = false, cooldown = 45, class = "WARLOCK", specID = { 266 } }, -- Felstorm
  [115831] = { parent = 89751 }, -- Wrathstorm
  [ 89766] = { default = false, cooldown = 30, class = "WARLOCK", specID = { 266 } }, -- Axe Toss
  [201996] = { default = false, cooldown = 90, class = "WARLOCK", specID = { 266 } }, -- Call Observer
  [205180] = { default = false, cooldown = 24, class = "WARLOCK", specID = { 266 } }, -- Summon Darkglare
  [205181] = { default = false, cooldown = 14, class = "WARLOCK", specID = { 266 }, charges = 2 }, -- Shadowflame
  [211714] = { default = false, cooldown = 45, class = "WARLOCK", specID = { 266 } }, -- Thal'kiel's Consumption
  [212459] = { default = false, cooldown = 90, class = "WARLOCK", specID = { 266 } }, -- Call Fel Lord
  [212623] = { default = false, cooldown = 15, class = "WARLOCK", specID = { 266 } }, -- Singe Magic

  --  Destruction TBD

  [ 17962] = { default = false, cooldown = 12, class = "WARLOCK", specID = { 267 }, charges = 2 }, -- Conflagrate
  [ 80240] = { default = false, cooldown = 20, class = "WARLOCK", specID = { 267 } }, -- Havoc
  [152108] = { default = false, cooldown = 45, class = "WARLOCK", specID = { 267 } }, -- Cataclysm
  [196447] = { default = false, cooldown = 15, class = "WARLOCK", specID = { 267 } }, -- Channel Demonfire
  [196586] = { default = false, cooldown = 45, class = "WARLOCK", specID = { 267 }, charges = 3 }, -- Dimensional Rift
  [212284] = { default = false, cooldown = 45, class = "WARLOCK", specID = { 267 } }, -- Firestone
  [116858] = { default = false, class = "WARLOCK", specID = { 267 }, offensive = true, cast = 3 }, -- Chaos Bolt

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
