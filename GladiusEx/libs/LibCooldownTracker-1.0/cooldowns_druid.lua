local data = {
  -- Druid

  [  1850] = { default = false, cooldown = 180, class = "DRUID", sprint = true, duration = 15 }, -- Dash
  [  5211] = { default = true, cooldown = 50, class = "DRUID", cc = true }, -- Mighty Bash
  -- [20484] = { default = false, cooldown = 600, class = "DRUID", revival = true }, -- Rebirth
  [102280] = { default = true, cooldown = 30, class = "DRUID", blink = true, talent = {102401,108238} }, -- Displacer Beast
  [102359] = { default = false, cooldown = 30, class = "DRUID", talent = {5211,132469} , cc = true}, -- Mass Entanglement
  [102401] = { default = true, cooldown = 15, class = "DRUID", talent = {102280,108238}, blink = true }, -- Wild Charge
  [132469] = { default = false, cooldown = 30, class = "DRUID", talent = {5211,102359}, cc = true }, -- Typhoon
  [   339] = { default = true, class = "DRUID", cast = 1.7, cc = true}, -- Entangling Roots
  -- Balance

  [ 22812] = { default = true, cooldown = { default = 60, [104] = 35 }, class = "DRUID", specID = { 102, 104, 105 }, defensive = 0.2, duration = 12 }, -- Barkskin
  [ 29166] = { default = false, cooldown = 180, class = "DRUID", specID = { 102, 105 } }, -- Innervate
  [ 78675] = { default = true, cooldown = 60, class = "DRUID", specID = { 102 }, interrupt = true }, -- Solar Beam
  [102560] = { default = true, cooldown = 180, class = "DRUID", specID = { 102 }, offensive = 0.5, duration = 30, replaces = {194223} }, -- Incarnation: Chosen of Elune
  [108238] = { default = false, cooldown = 120, class = "DRUID", specID = { 102, 103, 105 }, defensive = true, talent = {102280,102401} }, -- Renewal
  [194223] = { default = true, cooldown = 180, class = "DRUID", specID = { 102 }, offensive = 0.5, duration = 15, talent = {102560} }, -- Celestial Alignment
  [202425] = { default = true, cooldown = 45, class = "DRUID", specID = { 102 }, offensive = true, cooldown_starts_on_aura_fade = true, }, -- Warrior of Elune
  [202770] = { default = false, cooldown = 90, class = "DRUID", specID = { 102 }, offensive = true }, -- Fury of Elune
  [205636] = { default = false, cooldown = 60, class = "DRUID", specID = { 102 }, offensive = true, talent = {202425} }, -- Force of Nature
  [209749] = { default = false, cooldown = 30, class = "DRUID", specID = { 102 }, talent = {} }, -- Faerie Swarm
  [  2782] = { default = true, cooldown = 8, class = "DRUID", specID = {102, 103,104}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption
  [209753] = { default = true, class = "DRUID", specID = { 102}, cast = 2, cc = true}, -- Cyclone
  [202771] = { default = true, cooldown = 45, class = "DRUID", specID = { 102}, cast = 3, offensive = true}, -- Full Moon
  -- Feral

  [  5217] = { default = false, cooldown = 30, class = "DRUID", specID = { 103 }, offensive = true }, -- Tiger's Fury
  [ 22570] = { default = false, cooldown = 10, class = "DRUID", specID = { 103 }, cc = true }, -- Maim
  [ 61336] = { default = true, cooldown = { default = 180, [104] = 120 }, class = "DRUID", specID = { 103, 104 }, charges = 2, defensive= 0.5, duration=6 }, -- Survival Instincts
  [102543] = { default = true, cooldown = 180, class = "DRUID", specID = { 103 }, duration = 30, offensive = 0.5 }, -- Incarnation: King of the Jungle
  [106839] = { default = true, cooldown = 15, class = "DRUID", specID = { 103, 104 }, interrupt = true }, -- Skull Bash
  [106898] = { default = false, cooldown = 120, class = "DRUID", specID = { 103, 104 }, sprint = true, duration =8 }, -- Stampeding Roar
  [106951] = { default = true, cooldown = 180, class = "DRUID", specID = { 103 }, duration = 15, offensive = 0.4 }, -- Berserk
  [202060] = { default = false, cooldown = 45, class = "DRUID", specID = { 103 }, talent = {}, offensive = 0.2, duration = 5 }, -- Elune's Guidance
  [203242] = { default = false, cooldown = 60, class = "DRUID", specID = { 103 }, talent = {} }, -- Rip and Tear
  [210722] = { default = false, cooldown = 75, class = "DRUID", specID = { 103 }, offensive = true }, -- Ashamane's Frenzy

  -- Guardian TBD

  [    99] = { default = false, cooldown = 30, class = "DRUID", specID = { 104 } }, -- Incapacitating Roar
  [ 22842] = { default = false, cooldown = 24, class = "DRUID", specID = { 104 }, charges = 2 }, -- Frenzied Regeneration
  [102558] = { default = false, cooldown = 180, class = "DRUID", specID = { 104 }, offensive = 0.5, duration = 30 }, -- Incarnation: Guardian of Ursoc
  [200851] = { default = false, cooldown = 90, class = "DRUID", specID = { 104 } }, -- Rage of the Sleeper
  [202246] = { default = false, cooldown = 15, class = "DRUID", specID = { 104 } }, -- Overrun
  [204066] = { default = false, cooldown = 90, class = "DRUID", specID = { 104 } }, -- Lunar Beam

  -- Restoration

  [   740] = { default = true, cooldown = 120, class = "DRUID", specID = { 105}, offensive = true }, -- Tranquility
  [ 18562] = { default = false, cooldown = 30, class = "DRUID", specID = { 105}, charges = 2, defensive = true }, -- Swiftmend
  [ 33891] = { default = false, cooldown = 180, class = "DRUID", specID = { 105}, talent = {}, offensive = 0.5, defensive = 0.5, duration = 30 }, -- Incarnation: Tree of Life
  [102342] = { default = true, cooldown = 60, class = "DRUID", specID = { 105}, defensive = 0.4, duration = 12 }, -- Ironbark
  [102351] = { default = false, cooldown = 30, class = "DRUID", specID = { 105}, defensive = true, duration = 8, talent ={} }, -- Cenarion Ward
  [102793] = { default = true, cooldown = 60, class = "DRUID", specID = { 105}, cc = true, duration = 10 }, -- Ursol's Vortex
  [197721] = { default = false, cooldown = 60, class = "DRUID", specID = { 105}, talent = {} }, -- Flourish
  -- [201664] = { default = false, cooldown = 60, class = "DRUID", specID = { 105} }, -- Demoralizing Roar
  [203651] = { default = true, cooldown = 45, class = "DRUID", specID = { 105}, defensive = true }, -- Overgrowth
  [203727] = { default = false, cooldown = 45, class = "DRUID", specID = { 105}, defensive = true, duration = 12 }, -- Thorns
  [208253] = { default = false, cooldown = 90, class = "DRUID", specID = { 105}, offensive = true, duration = 8 }, -- Essence of G'Hanir
  [ 88423] = { default = true, cooldown = 8, class = "DRUID", specID = { 105}, dispel = true, cooldown_starts_on_dispel = true }, -- Nature's Cure
  [  5185] = { default = true, class = "DRUID", specID = { 105}, cast = 2.5, heal = true}, -- Healing Touch
  [ 33786] = { default = true, class = "DRUID", specID = { 105}, cast = 2, cc = true}, -- Cyclone

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
