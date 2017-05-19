local data = {
  -- Druid

  [  1850] = { default = false, cooldown = 180, class = "DRUID", sprint = true, duration = 15 }, -- Dash
  [  5211] = { default = true, cooldown = 50, class = "DRUID", cc = "stun", duration = 5 }, -- Mighty Bash
  -- [20484] = { default = false, cooldown = 600, class = "DRUID", revival = true }, -- Rebirth
  [102280] = { default = true, cooldown = 30, class = "DRUID", blink = true, replaces = {102401,108238}, aura = {137452} }, -- Displacer Beast
  [102359] = { default = false, cooldown = 30, class = "DRUID", talent = {5211,132469} , cc = "root", duration = 8}, -- Mass Entanglement
  [102401] = { default = false, cooldown = 15, class = "DRUID", talent = {102280,108238}, blink = true, cc = "root", aura = {16979}, duration = 4 }, -- Wild Charge
  [132469] = { default = false, cooldown = 30, class = "DRUID", talent = {5211,102359}, cc = true }, -- Typhoon
  [   339] = { default = false, class = "DRUID", cast = 1.7, cc = "root", duration = 8}, -- Entangling Roots
  -- Balance

  [ 22812] = { default = false, cooldown = { default = 60, [104] = 35 }, class = "DRUID", specID = { 102, 104, 105 }, defensive = 0.2, duration = 12 }, -- Barkskin
  [ 29166] = { default = false, cooldown = 180, class = "DRUID", specID = { 102, 105 }, offensive = 0.2, duration = 10 }, -- Innervate
  [ 78675] = { default = true, cooldown = 60, class = "DRUID", specID = { 102 }, interrupt = true, duration = 8, aura = {81261}, cc = "silence" }, -- Solar Beam
  [102560] = { default = true, cooldown = 180, class = "DRUID", specID = { 102 }, offensive = 0.5, duration = 30, replaces = {194223} }, -- Incarnation: Chosen of Elune
  [108238] = { default = false, cooldown = 120, class = "DRUID", specID = { 102, 103, 105 }, defensive = 0.2, talent = {102280,102401} }, -- Renewal
  [194223] = { default = true, cooldown = 180, class = "DRUID", specID = { 102 }, offensive = 0.5, duration = 15, talent = {102560} }, -- Celestial Alignment
  [202425] = { default = false, cooldown = 45, class = "DRUID", specID = { 102 }, offensive = true, cooldown_starts_on_aura_fade = true, }, -- Warrior of Elune
  [202770] = { default = false, cooldown = 90, class = "DRUID", specID = { 102 }, offensive = true }, -- Fury of Elune
  [205636] = { default = false, cooldown = 60, class = "DRUID", specID = { 102 }, offensive = true, talent = {202425} }, -- Force of Nature
  [209749] = { default = false, cooldown = 30, class = "DRUID", specID = { 102 }, talent = {} }, -- Faerie Swarm
  [  2782] = { default = false, cooldown = 8, class = "DRUID", specID = {102, 103,104}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption
  [209753] = { default = false, class = "DRUID", specID = { 102}, cast = 2, cc = "disorient", duration = 6}, -- Cyclone
  [202771] = { default = false, cooldown = 45, class = "DRUID", specID = { 102}, cast = 3, offensive = true}, -- Full Moon
  -- Feral

  [  5217] = { default = false, cooldown = 30, class = "DRUID", specID = { 103 }, offensive = 0.15, duration = 8 }, -- Tiger's Fury
  [ 22570] = { default = false, cooldown = 10, class = "DRUID", specID = { 103 }, cc = true }, -- Maim
  [ 61336] = { default = true, cooldown = { default = 180, [104] = 120 }, class = "DRUID", specID = { 103, 104 }, charges = 2, defensive= 0.5, duration=6 }, -- Survival Instincts
  [102543] = { default = true, cooldown = 180, class = "DRUID", specID = { 103 }, duration = 30, offensive = 0.5, replaces = {102543} }, -- Incarnation: King of the Jungle
  [106839] = { default = true, cooldown = 15, class = "DRUID", specID = { 103, 104 }, interrupt = true }, -- Skull Bash
  [106898] = { default = false, cooldown = 60, class = "DRUID", specID = { 104 }, sprint = true, duration =8, talent = {77764} }, -- Stampeding Roar
  [ 77764] = { default = false, cooldown = 120, class = "DRUID", specID = { 103, 104 }, sprint = true, duration =8 }, -- Stampeding Roar
  [106951] = { default = false, cooldown = 180, class = "DRUID", specID = { 103 }, duration = 15, offensive = 0.4, talent = {102543} }, -- Berserk
  [202060] = { default = false, cooldown = 45, class = "DRUID", specID = { 103 }, talent = {}, offensive = 0.2, duration = 5 }, -- Elune's Guidance
  [203242] = { default = false, cooldown = 60, class = "DRUID", specID = { 103 }, talent = {} }, -- Rip and Tear
  [210722] = { default = false, cooldown = 75, class = "DRUID", specID = { 103 }, offensive = true }, -- Ashamane's Frenzy
  [  1822] = { default = false, class = "DRUID", specID = { 103 }, cc = "stun", duration = 4, aura = {163505} }, -- Ashamane's Frenzy
  [210655] = { default = false, cooldown = 30, class = "DRUID", specID = { 103 }, defensive = 0.5, immune = "evasion", duration = 5 }, -- Ashamane's Frenzy

  -- Guardian TBD

  [    99] = { default = false, cooldown = 30, class = "DRUID", specID = { 104 }, cc = "incapacitate", duration = 3 }, -- Incapacitating Roar
  [ 22842] = { default = false, cooldown = 24, class = "DRUID", specID = { 104 }, charges = 2, defensive = 0.1, duration = 3 }, -- Frenzied Regeneration
  [102558] = { default = false, cooldown = 180, class = "DRUID", specID = { 104 }, offensive = 0.5, duration = 30 }, -- Incarnation: Guardian of Ursoc
  [200851] = { default = false, cooldown = 90, class = "DRUID", specID = { 104 }, defensive = 0.25, duration = 10 }, -- Rage of the Sleeper
  [202246] = { default = false, cooldown = 15, class = "DRUID", specID = { 104 } }, -- Overrun
  [204066] = { default = false, cooldown = 90, class = "DRUID", specID = { 104 } }, -- Lunar Beam

  -- Restoration

  [   740] = { default = false, cooldown = 120, class = "DRUID", specID = { 105}, offensive = 0.5, duration = 8 }, -- Tranquility
  [ 18562] = { default = false, cooldown = 30, class = "DRUID", specID = { 105}, charges = 2, defensive = 0.1 }, -- Swiftmend
  [ 33891] = { default = true, cooldown = 180, class = "DRUID", specID = { 105}, talent = {}, offensive = 0.5, defensive = 0.5, duration = 30 }, -- Incarnation: Tree of Life
  [102342] = { default = true, cooldown = 60, class = "DRUID", specID = { 105}, defensive = 0.4, duration = 12 }, -- Ironbark
  [102351] = { default = false, cooldown = 30, class = "DRUID", specID = { 105}, defensive = 0.1, duration = 8, talent ={} }, -- Cenarion Ward
  [102793] = { default = false, cooldown = 60, class = "DRUID", specID = { 105}, cc = "knockback", duration = 10 }, -- Ursol's Vortex
  [197721] = { default = false, cooldown = 60, class = "DRUID", specID = { 105}, talent = {} }, -- Flourish
  -- [201664] = { default = false, cooldown = 60, class = "DRUID", specID = { 105} }, -- Demoralizing Roar
  [203651] = { default = false, cooldown = 45, class = "DRUID", specID = { 105}, offensive = true }, -- Overgrowth
  [203727] = { default = false, cooldown = 45, class = "DRUID", specID = { 105}, defensive = 0.2, duration = 12 }, -- Thorns
  [208253] = { default = false, cooldown = 90, class = "DRUID", specID = { 105}, offensive = true, duration = 8 }, -- Essence of G'Hanir
  [ 88423] = { default = true, cooldown = 8, class = "DRUID", specID = { 105}, dispel = true, cooldown_starts_on_dispel = true }, -- Nature's Cure
  [  5185] = { default = false, class = "DRUID", specID = { 105}, cast = 2.5, heal = true}, -- Healing Touch
  [  8936] = { default = false, class = "DRUID", cast = 1.5, heal = true}, -- Reg
  [ 33786] = { default = false, class = "DRUID", specID = { 105}, cast = 2, cc = "disorient", duration = 6}, -- Cyclone

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
