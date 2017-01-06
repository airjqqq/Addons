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
  [59752 ] = { default = true, cooldown = 120, pvp_trinket = true, race = "Human", sets_cooldown = {
    { spellid =208683, cooldown = 30},
  } }, -- Every Man
  [20594 ] = { default = truetrue, cooldown = 120, defensive = true, race = "Dwarf" }, -- Stoneform
  [26297 ] = { default = true, cooldown = 180, offensive = true, race = "Troll" }, --Berserking (Troll)
  [20572 ] = { default = true, cooldown = 120, offensive = true, race = "Orc" },
  [33702 ] = { parent = 20572},
  [33697 ] = { parent = 20572},
  [58984 ] = { default = true, cooldown = 120, offensive = true, race = "NightElf" },
  [68992 ] = { default = true, cooldown = 120, sprint = true, race = "Worgen" },
  [59545 ] = { default = true, cooldown = 180, heal = true, race = "Draenei" },
  [59543 ] = { parent = 59545},
  [59548 ] = { parent = 59545},
  [59542 ] = { parent = 59545},
  [59544 ] = { parent = 59545},
  [59547 ] = { parent = 59545},
  [28880 ] = { parent = 59545},
  [121093] = { parent = 59545},
  [28730 ] = { default = true, cooldown = 120, cc = true, race = "BloodElf" },
  [ 50613] = { parent = 28730},
  [ 80483] = { parent = 28730},
  [ 25046] = { parent = 28730},
  [ 69179] = { parent = 28730},
  [129597] = { parent = 28730},
  [155145] = { parent = 28730},
  [107079] = { parent = 28730},
  [ 20549] = { parent = 28730},
  [20589 ] = { default = true, cooldown = 60, cc = true, race = "Gnome" },
  [69070 ] = { default = true, cooldown = 120, sprint = true, race = "Goblin" },
  [ 7744 ] = { default = true, cooldown = 120, pvp_trinket = true, race = "Scourge" },
}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
