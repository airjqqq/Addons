local data = {
  -- Demon Hunter TBD

  [179057] = { default = true, cooldown = 60, class = "DEMONHUNTER", cc = "stun", duration = 5 }, -- Chaos Nova
  [183752] = { default = true, cooldown = 15, class = "DEMONHUNTER" }, -- Consume Magic
  [188499] = { default = true, cooldown = 10, class = "DEMONHUNTER", defensive = 0.5, immune = "evasion", duration = 1 }, -- Blade Dance
  [188501] = { default = true, cooldown = 30, class = "DEMONHUNTER", offensive = 0, duration = 10 }, -- Spectral Sight
  [191427] = { default = true, cooldown = 300, class = "DEMONHUNTER", duration = 30, offensive = 1, buffs = {162264} }, -- Metamorphosis
  [187827] = { parent = 191427, cooldown = 180, defensive = 0.3, offensive = 0.2, duration = 15 }, -- Metamorphosis (Vengeance)
  [196718] = { default = true, cooldown = 180, class = "DEMONHUNTER" }, -- Darkness
  [198013] = { default = true, cooldown = 45, class = "DEMONHUNTER" }, -- Eye Beam
  [198793] = { default = true, cooldown = 25, class = "DEMONHUNTER" }, -- Vengeful Retreat
  [203704] = { default = true, cooldown = 90, class = "DEMONHUNTER" }, -- Mana Break
  [205604] = { default = true, cooldown = 60, class = "DEMONHUNTER" }, -- Reverse Magic
  [206649] = { default = true, cooldown = 45, class = "DEMONHUNTER", important = true, duration = 6 }, -- Eye of Leotheras
  [206803] = { default = true, cooldown = 60, class = "DEMONHUNTER" }, -- Rain from Above
  [212800] = { default = true, cooldown = 60, class = "DEMONHUNTER", defensive = 0.6, duration = 10, immune = "evasion" }, -- Blur
  [196555] = { default = true, cooldown = 90, class = "DEMONHUNTER", defensive = 1, duration = 5, talent = {212800} }, -- Netherwalk
  [214743] = { default = true, cooldown = 60, class = "DEMONHUNTER" }, -- Soul Carver
  [207407] = { parent = 214743 }, -- Soul Carver (Vengeance)
  [221527] = { default = true, cooldown = 60, class = "DEMONHUNTER", cc = "incapacitate", duration =5, immune = "all" }, -- Imprison

  -- Havoc TBD

  [201467] = { default = true, cooldown = 60, class = "DEMONHUNTER", specID = { 577 } }, -- Fury of the Illidari
  [206491] = { default = true, cooldown = 120, class = "DEMONHUNTER", specID = { 577 } }, -- Nemesis
  [211048] = { default = true, cooldown = 120, class = "DEMONHUNTER", specID = { 577 }, offensive = 0.5, duration = 12 }, -- Chaos Blades
  [211881] = { default = true, cooldown = 35, class = "DEMONHUNTER", specID = { 577, 581 }, cc = "stun", duration = 2 }, -- Fel Eruption

  -- Vengeance TBD

  [202137] = { default = true, cooldown = 60, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Silence
  [202138] = { default = true, cooldown = 120, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Chains
  [204021] = { default = true, cooldown = 60, class = "DEMONHUNTER", specID = { 581 } }, -- Fiery Brand
  [204596] = { default = true, cooldown = 30, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Flame
  [205629] = { default = true, cooldown = 30,  class = "DEMONHUNTER", specID = { 581 }, talent = {}, offensive = 0, duration = 8 }, -- Demonic Trample
  [205630] = { default = true, cooldown = 90, class = "DEMONHUNTER", specID = { 581 }, talent = {}, cc = "stun", duration = 3 }, -- Illidan's Grasp
  [207684] = { default = true, cooldown = 60, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Misery
  [207810] = { default = true, cooldown = 120, class = "DEMONHUNTER", specID = { 581 }, defensive = 0.5, duration = 15 }, -- Nether Bond
  [218256] = { default = true, cooldown = 20, class = "DEMONHUNTER", specID = { 581 }, defensive = 0.15, duration = 6 }, -- Empower Wards
  [227225] = { default = true, cooldown = 20, class = "DEMONHUNTER", specID = { 581 },defensive = 0.2, duration = 8, talent = {} }, -- Soul Barrier

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
