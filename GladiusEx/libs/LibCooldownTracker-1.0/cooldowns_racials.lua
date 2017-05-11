local data = {
	--Racials
  [208683] = { default = true, cooldown = 120, pvp_trinket = true, item = true, replaces = {214027,196029}, sets_cooldown = {
    { spellid = 20594, cooldown = 30},
    { spellid = 59752, cooldown = 30},
    { spellid =  7744, cooldown = 30},
  }}, -- Gladiator's Medallion
  [214027] = { default = true, cooldown = 60, pvp_trinket = true, item = true, talent = {196029,208683}, sets_cooldown = {
    { spellid = 20594, cooldown = 30},
    { spellid = 59752, cooldown = 30},
    { spellid =  7744, cooldown = 30},
  }},
  [196029] = { default = true, cooldown = 0, pvp_trinket = true, item = true, talent = {214027,208683}},
  [59752 ] = { default = true, cooldown = 120, race = "Human", sets_cooldown = {
    { spellid =208683, cooldown = 30},
  } }, -- Every Man
  [20594 ] = { default = falsetrue, cooldown = 120, defensive = 0.1, race = "Dwarf" }, -- Stoneform
  [26297 ] = { default = false, cooldown = 180, offensive = true, race = "Troll" }, --Berserking (Troll)
  [20572 ] = { default = false, cooldown = 120, offensive = true, race = "Orc", talent = {33702,33697} },
  [33702 ] = { parent = 20572, talent = {20572,33697}},
  [33697 ] = { parent = 20572, talent = {20572,33702}},
  [58984 ] = { default = false, cooldown = 120, offensive = true, race = "NightElf" },
  [68992 ] = { default = false, cooldown = 120, sprint = true, race = "Worgen" },
  [59545 ] = { default = false, cooldown = 180, heal = true, race = "Draenei" },
  [59543 ] = { parent = 59545,talent = {59545}},
  [59548 ] = { parent = 59545,talent = {59545}},
  [59542 ] = { parent = 59545,talent = {59545}},
  [59544 ] = { parent = 59545,talent = {59545}},
  [59547 ] = { parent = 59545,talent = {59545}},
  [28880 ] = { parent = 59545,talent = {59545}},
  [121093] = { parent = 59545,talent = {59545}},
  [28730 ] = { default = false, cooldown = 120, cc = "silence", duration = 2, race = "BloodElf" },
  [ 50613] = { parent = 28730,talent = {28730}},
  [ 80483] = { parent = 28730,talent = {28730}},
  [ 25046] = { parent = 28730,talent = {28730}},
  [ 69179] = { parent = 28730,talent = {28730}},
  [129597] = { parent = 28730,talent = {28730}},
  [155145] = { parent = 28730,talent = {28730}},
  [107079] = { default = false, cooldown = 120, race = "Pandaren", cc = "incapacitate", duration = 4},
  [ 20549] = { default = false, cooldown = 120, race = "Tauren", cast = 0.5, cc = "stun", duration = 2},
  [20589 ] = { default = false, cooldown = 60, cc = true, race = "Gnome" },
  [69070 ] = { default = false, cooldown = 120, sprint = true, race = "Goblin" },
  [ 7744 ] = { default = false, cooldown = 120, race = "Scourge" },
  [118358] = { default = false, item = true, important = true },
}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
