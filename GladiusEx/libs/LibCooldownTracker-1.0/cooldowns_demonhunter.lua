local data = {
  -- Demon Hunter TBD

  [179057] = { default = false, cooldown = 60, class = "DEMONHUNTER" }, -- Chaos Nova
  [183752] = { default = true, cooldown = 15, class = "DEMONHUNTER" }, -- Consume Magic
  [188499] = { default = false, cooldown = 10, class = "DEMONHUNTER" }, -- Blade Dance
  [188501] = { default = false, cooldown = 30, class = "DEMONHUNTER" }, -- Spectral Sight
  [191427] = { default = false, cooldown = 300, class = "DEMONHUNTER" }, -- Metamorphosis
  [187827] = { parent = 191427, cooldown = 180 }, -- Metamorphosis (Vengeance)
  [196718] = { default = false, cooldown = 180, class = "DEMONHUNTER" }, -- Darkness
  [198013] = { default = false, cooldown = 45, class = "DEMONHUNTER" }, -- Eye Beam
  [198793] = { default = false, cooldown = 25, class = "DEMONHUNTER" }, -- Vengeful Retreat
  [203704] = { default = false, cooldown = 90, class = "DEMONHUNTER" }, -- Mana Break
  [205604] = { default = false, cooldown = 60, class = "DEMONHUNTER" }, -- Reverse Magic
  [206649] = { default = false, cooldown = 45, class = "DEMONHUNTER" }, -- Eye of Leotheras
  [206803] = { default = false, cooldown = 60, class = "DEMONHUNTER" }, -- Rain from Above
  [212800] = { default = false, cooldown = 60, class = "DEMONHUNTER" }, -- Blur
  [196555] = { parent = 212800, cooldown = 90 }, -- Netherwalk
  [214743] = { default = false, cooldown = 60, class = "DEMONHUNTER" }, -- Soul Carver
  [207407] = { parent = 214743 }, -- Soul Carver (Vengeance)
  [221527] = { default = false, cooldown = 10, class = "DEMONHUNTER" }, -- Imprison

  -- Havoc TBD

  [201467] = { default = false, cooldown = 60, class = "DEMONHUNTER", specID = { 577 } }, -- Fury of the Illidari
  [206491] = { default = false, cooldown = 120, class = "DEMONHUNTER", specID = { 577 } }, -- Nemesis
  [211048] = { default = false, cooldown = 120, class = "DEMONHUNTER", specID = { 577 } }, -- Chaos Blades
  [211881] = { default = false, cooldown = 35, class = "DEMONHUNTER", specID = { 577, 581 } }, -- Fel Eruption

  -- Vengeance TBD

  [202137] = { default = false, cooldown = 60, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Silence
  [202138] = { default = false, cooldown = 120, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Chains
  [204021] = { default = false, cooldown = 60, class = "DEMONHUNTER", specID = { 581 } }, -- Fiery Brand
  [204596] = { default = false, cooldown = 30, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Flame
  [205629] = { default = false, cooldown = 30,  class = "DEMONHUNTER", specID = { 581 } }, -- Demonic Trample
  [205630] = { default = false, cooldown = 90, class = "DEMONHUNTER", specID = { 581 } }, -- Illidan's Grasp
  [207684] = { default = false, cooldown = 60, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Misery
  [207810] = { default = false, cooldown = 120, class = "DEMONHUNTER", specID = { 581 } }, -- Nether Bond
  [218256] = { default = false, cooldown = 20, class = "DEMONHUNTER", specID = { 581 } }, -- Empower Wards
  [227225] = { default = false, cooldown = 20, class = "DEMONHUNTER", specID = { 581 } }, -- Soul Barrier

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
