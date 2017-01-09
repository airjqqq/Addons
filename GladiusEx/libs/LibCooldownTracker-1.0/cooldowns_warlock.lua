local data = {
	-- Warlock

  [  1122] = { default = true, cooldown = 180, class = "WARLOCK", cc = "stun", offensive = true, aura = {22703}, duration = 2 }, -- Summon Infernal
  [  6358] = { default = true, cooldown = 30, class = "WARLOCK", cast = 1.7, cc= "disorient", duration = 8, talent = {} }, -- Seduction
  -- [6360] = { default = true, cooldown = 25, class = "WARLOCK" }, -- Whiplash
  -- [115770] = { parent = 6360 }, -- Fellash
  [  6789] = { default = true, cooldown = 45, class = "WARLOCK", talent = {5484}, cc = "disorient", cantbreak = true, duration = 3 }, -- Mortal Coil
  -- [18540] = { default = true, cooldown = 180, class = "WARLOCK" }, -- Summon Doomguard
  -- [20707] = { default = true, cooldown = 600, class = "WARLOCK" }, -- Soulstone
  [104773] = { default = true, cooldown = {default = 180, [267] = 60}, class = "WARLOCK", defensive = 0.4, duration = 8, immune = "interrupt" }, -- Unending Resolve
  [108416] = { default = true, cooldown = 60, class = "WARLOCK", talent = {}, defensive = 0.2, duration = 10 }, -- Dark Pact
  [111897] = { default = true, cooldown = 90, class = "WARLOCK", cc = true }, -- Grimoire of Service
  [115268] = { parent = 6358 }, -- Mesmerize
  [ 19505] = { default = true, cooldown = 15, class = "WARLOCK", dispel = true}, -- Dispel
  -- [115284] = { default = true, cooldown = 15, class = "WARLOCK" }, -- Clone Magic
  [119910] = { default = true, cooldown = 24, class = "WARLOCK", interrupt = true, talent = {19647} }, -- Spell Lock (Command Demon)
  [ 19647] = { default = true, cooldown = 24, class = "WARLOCK", interrupt = true }, -- Spell Lock (Felhunter)
  [119911] = { parent = 119910 }, -- Optical Blast (Command Demon)
  [115781] = { parent = 119910 }, -- Optical Blast (Observer)
  [132409] = { parent = 119910 }, -- Spell Lock (Grimoire of Sacrifice)
  [171138] = { parent = 119910 }, -- Shadow Lock (Doomguard)
  [171139] = { parent = 119910 }, -- Shadow Lock (Grimoire of Sacrifice)
  [171140] = { parent = 119910 }, -- Shadow Lock (Command Demon)
  [171152] = { default = true, cooldown = 60, class = "WARLOCK" , talent = {}, cc = "stun", duration = 2}, -- Meteor Strike
  [196098] = { default = true, cooldown = 120, class = "WARLOCK", offensive = 0.2, talent = {}, dispellable = true, duration = 16 }, -- Soul Harvest
  -- [199890] = { default = true, cooldown = 15, class = "WARLOCK" }, -- Curse of Tongues
  -- [199892] = { default = true, cooldown = 20, class = "WARLOCK" }, -- Curse of Weakness
  -- [199954] = { default = true, cooldown = 45, class = "WARLOCK" }, -- Curse of Fragility
  [212295] = { default = true, cooldown = 45, class = "WARLOCK", talent = {221703}, offensive = 0.5, immune = "spell", duration = 5, dispellable = true }, -- Nether Ward
  [221703] = { default = true, cooldown = 30, class = "WARLOCK", talent = {212295}, offensive = true, duration = 10 }, -- Casting Circle
  -- [48018] = { default = true, cooldown = 30, class = "WARLOCK", talent = {5484}, blink = true, duration = 10 }, -- Demonic Circle
  [  5782] = { default = true, class = "WARLOCK", cc = "disorient", cast = 1.7, duration = 6, aura = {118699} }, -- Fear

  -- Affliction

  [  5484] = { default = true, cooldown = 40, class = "WARLOCK", specID = { 265 }, talent = {48018,6789}, cc = "disorient", duration = 6 }, -- Howl of Terror
  -- [48181] = { default = true, cooldown = 15, class = "WARLOCK", specID = { 265 } }, -- Haunt
  -- [86121] = { default = true, cooldown = 20, class = "WARLOCK", specID = { 265 } }, -- Soul Swap
  [205179] = { default = true, cooldown = 60, class = "WARLOCK", specID = { 265 }, important = true, offensive = true, duration = 15, aura = {} }, -- Phantom Singularity
  [ 30108] = { default = true, class = "WARLOCK", specID = { 265 }, important = true, cast = 1.5, aura = {233490, 233496, 233497, 233498, 233499} }, -- Unstable Affliction
  [196364] = { default = true, class = "WARLOCK", specID = { 265 }, cc = "silence", duration = 4 }, -- Unstable Affliction (Silence)

  -- Demonology TBD

  [ 30283] = { default = true, cooldown = 30, class = "WARLOCK", specID = { 266, 267 }, cc = "stun", duration = 4, cast = 1.5, talent = {48018,6789} }, -- Shadowfury
  [ 89751] = { default = true, cooldown = 45, class = "WARLOCK", specID = { 266 }, offensive = 0.1, duration = 6 }, -- Felstorm
  [115831] = { parent = 89751 }, -- Wrathstorm
  [ 89766] = { default = true, cooldown = 30, class = "WARLOCK", specID = { 266 }, cc= "stun", duration = 4 }, -- Axe Toss
  [201996] = { default = true, cooldown = 90, class = "WARLOCK", specID = { 266 } }, -- Call Observer
  [205180] = { default = true, cooldown = 24, class = "WARLOCK", specID = { 266 } }, -- Summon Darkglare
  [205181] = { default = true, cooldown = 14, class = "WARLOCK", specID = { 266 }, charges = 2 }, -- Shadowflame
  [211714] = { default = true, cooldown = 45, class = "WARLOCK", specID = { 266 } }, -- Thal'kiel's Consumption
  [212459] = { default = true, cooldown = 90, class = "WARLOCK", specID = { 266 } }, -- Call Fel Lord
  [212623] = { default = true, cooldown = 15, class = "WARLOCK", specID = { 266 } }, -- Singe Magic

  --  Destruction TBD

  [ 17962] = { default = true, cooldown = 12, class = "WARLOCK", specID = { 267 }, charges = 2 }, -- Conflagrate
  [ 80240] = { default = true, cooldown = 20, class = "WARLOCK", specID = { 267 } }, -- Havoc
  [152108] = { default = true, cooldown = 45, class = "WARLOCK", specID = { 267 } }, -- Cataclysm
  [196447] = { default = true, cooldown = 15, class = "WARLOCK", specID = { 267 } }, -- Channel Demonfire
  [196586] = { default = true, cooldown = 45, class = "WARLOCK", specID = { 267 }, charges = 3 }, -- Dimensional Rift
  [212284] = { default = true, cooldown = 45, class = "WARLOCK", specID = { 267 }, offensive = 0.8, duration = 7 }, -- Firestone
  [116858] = { default = true, class = "WARLOCK", specID = { 267 }, offensive = true, cast = 3 }, -- Chaos Bolt

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
