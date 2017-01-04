-- Note: this global is removed after the library is loaded
-- LCT_SpellData = {}

LCT_SpellData = {

  -- Death Knight

  [51052] = { default = true, cooldown = 120, class = "DEATHKNIGHT",duration = 10,talent = {77606},defensive = true}, -- Anti-Magic Zone
  [77606] = { default = false, cooldown = 30, class = "DEATHKNIGHT",talent = {51052}}, -- Dark Simulacrum
  [212552] = { default = true, cooldown = 45, class = "DEATHKNIGHT",duration = 3,sprint = true}, -- Wraith Walk
  [47528] = { default = true, cooldown = 15, class = "DEATHKNIGHT", interrupt = true,}, -- Mind Freeze
  [49576] = { default = true, cooldown = 25, class = "DEATHKNIGHT", blink = true}, -- Death Grip
  [48707] = { default = true, cooldown = 60, class = "DEATHKNIGHT", duration = 5, defensive = true}, -- Anti-Magic Shell
  [61999] = { default = false, cooldown = 600, class = "DEATHKNIGHT", revival = true }, -- Raise Ally

  -- Blood TBD

  [43265] = { default = false, cooldown = 30, class = "DEATHKNIGHT", specID = { 250, 252 } }, -- Death and Decay
  [47476] = { default = false, cooldown = 60, class = "DEATHKNIGHT", specID = { 250 } }, -- Strangulate
  [49028] = { default = false, cooldown = 180, class = "DEATHKNIGHT", specID = { 250 } }, -- Dancing Rune Weapon
  [55233] = { default = false, cooldown = 90, class = "DEATHKNIGHT", specID = { 250 } }, -- Vampiric Blood
  [108199] = { default = false, cooldown = 180, class = "DEATHKNIGHT", specID = { 250 } }, -- Gorefiend's Grasp
  [194679] = { default = false, cooldown = 25, class = "DEATHKNIGHT", specID = { 250 }, charges = 2 }, -- Rune Tap
  [194844] = { default = false, cooldown = 60, class = "DEATHKNIGHT", specID = { 250 } }, -- Bonestorm
  [203173] = { default = false, cooldown = 15, class = "DEATHKNIGHT", specID = { 250 } }, -- Death Chain
  [205223] = { default = false, cooldown = 45, class = "DEATHKNIGHT", specID = { 250 } }, -- Consumption
  [206931] = { default = false, cooldown = 30, class = "DEATHKNIGHT", specID = { 250 } }, -- Blooddrinker
  [206977] = { default = false, cooldown = 120, class = "DEATHKNIGHT", specID = { 250 } }, -- Blood Mirror
  [219809] = { default = false, cooldown = 60, class = "DEATHKNIGHT", specID = { 250 } }, -- Tombstone
  [221562] = { default = false, cooldown = 45, class = "DEATHKNIGHT", specID = { 250, 252 } }, -- Asphyxiate (Blood)
  [108194] = { parent = 221562 }, -- Asphyxiate (Unholy)
  [221699] = { default = false, cooldown = 60, class = "DEATHKNIGHT", specID = { 250 }, charges = 2 }, -- Blood Tap

  -- Frost

  [47568] = { default = true, cooldown = 180, class = "DEATHKNIGHT", specID = { 251 }, offensive = true}, -- Empower Rune Weapon
  [207127] = { parent = 47568, default = false, duration = 12 , talent = {47568}}, -- Hungering Rune Weapon
  [48792] = { default = true, cooldown = 180, class = "DEATHKNIGHT", specID = { 251, 252 }, defensive = true, duration = 8 }, -- Icebound Fortitude
  [51271] = { default = true, cooldown = 60, class = "DEATHKNIGHT", specID = { 251 }, offensive = true, duration = 20 }, -- Pillar of Frost
  [152279] = { default = false, cooldown = 120, class = "DEATHKNIGHT", specID = { 251}, offensive = true, duration = 12, talent = {207256}}, -- Breath of Sindragosa
  [190778] = { default = true, cooldown = 300, class = "DEATHKNIGHT", specID = { 251}, offensive=true }, -- Sindragosa's Fury
  [196770] = { default = false, cooldown = 20, class = "DEATHKNIGHT", specID = { 251 }, cc = true }, -- Remorseless Winter
  -- [204143] = { default = false, cooldown = 45, class = "DEATHKNIGHT", specID = { 251 } }, -- Killing Machine
  [204160] = { default = false, cooldown = 45, class = "DEATHKNIGHT", specID = { 251 }, offensive = true }, -- Chill Streak
  [207167] = { default = false, cooldown = 60, class = "DEATHKNIGHT", specID = { 251}, talent = {}, cc = true }, -- Blinding Sleet
  [207256] = { default = false, cooldown = 90, class = "DEATHKNIGHT", specID = { 251}, talent = {152279}, offensive = true }, -- Obliteration

  -- Unholy TBD

  [42650] = { default = false, cooldown = 600, class = "DEATHKNIGHT", specID = { 252 } }, -- Army of the Dead
  [63560] = { default = false, cooldown = 60, class = "DEATHKNIGHT", specID = { 252 } }, -- Dark Transformation
  [49206] = { default = false, cooldown = 180, class = "DEATHKNIGHT", specID = { 252 } }, -- Summon Gargoyle
  [207349] = { parent = 49206 }, -- Dark Arbiter
  [43265] = { default = false, cooldown = 30, class = "DEATHKNIGHT", specID = { 252 } }, -- Death and Decay
  [152280] = { parent = 43265 }, -- Defile
  [130736] = { default = false, cooldown = 45, class = "DEATHKNIGHT", specID = { 252 } }, -- Soul Reaper
  [220143] = { default = false, cooldown = 90, class = "DEATHKNIGHT", specID = { 252 } }, -- Apocalypse
  [47481] = { default = false, cooldown = 90, class = "DEATHKNIGHT", specID = { 252 } }, -- Gnaw (Ghoul)
  [47482] = { default = false, cooldown = 30, class = "DEATHKNIGHT", specID = { 252 } }, -- Leap (Ghoul)
  [91802] = { default = false, cooldown = 30, class = "DEATHKNIGHT", specID = { 252 } }, -- Shambling Rush (Ghoul)
  [207319] = { default = false, cooldown = 60, class = "DEATHKNIGHT", specID = { 252 } }, -- Corpse Shield

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

  -- Priest

  -- [586] = { default = false, cooldown = 30, class = "PRIEST" }, -- Fade
  -- [213602] = { parent = 586 }, -- Greater Fade
  [32375] = { default = true, cooldown = 15, class = "PRIEST" }, -- Mass Dispel

  -- Discipline

  [8122] = { default = true, cooldown = 30, class = "PRIEST", specID = { 256, 258 }, cc = true, talent = {205369} }, -- Psychic Scream
  [10060] = { default = true, cooldown = 120, class = "PRIEST", specID = { 256, 258 }, offensive = true, duration = 20 }, -- Power Infusion
  [33206] = { default = true, cooldown = 210, class = "PRIEST", specID = { 256 }, defensive = true, duration = 8 }, -- Pain Suppression
  [34433] = { default = false, cooldown = 180, class = "PRIEST", specID = { 256, 258 }, offensive = true, duration = 12 }, -- Shadowfiend
  [123040] = { parent = 34433, cooldown = 60 }, -- Mindbender (Discipline)
  [200174] = { parent = 34433, cooldown = 60 }, -- Mindbender (Shadow)
  [47536] = { default = true, cooldown = 120, class = "PRIEST", specID = { 256 }, offensive = true, duration = 8, dispelable = true }, -- Rapture
  [62618] = { default = true, cooldown = 180, class = "PRIEST", specID = { 256 }, defensive = true, duration = 10}, -- Power Word: Barrier
  [73325] = { default = true, cooldown = 90, class = "PRIEST", specID = { 256, 257 }, blink = true }, -- Leap of Faith
  [197862] = { default = true, cooldown = 60, class = "PRIEST", specID = { 256 }, offensive = true, duration = 15}, -- Archangel
  [204263] = { default = false, cooldown = 60, class = "PRIEST", specID = { 256, 257 }, cc = true, talent = {} }, -- Shining Force
  [207946] = { default = true, cooldown = 90, class = "PRIEST", specID = { 256 }, offensive = true, cast = 2.5 }, -- Light's Wrath
  -- [208065] = { default = false, cooldown = 45, class = "PRIEST", specID = { 256 }, charges = 2 }, -- Light of T'uure
  [209780] = { default = true, cooldown = 12, class = "PRIEST", specID = { 256}, dispel = true}, -- Premonition

  -- Holy TBD

  [47788] = { default = false, cooldown = 96, class = "PRIEST", specID = { 257 } }, -- Guardian Spirit
  [64843] = { default = false, cooldown = 180, class = "PRIEST", specID = { 257 } }, -- Divine Hymn
  [64901] = { default = false, cooldown = 360, class = "PRIEST", specID = { 257 } }, -- Symbol of Hope
  [19236] = { default = false, cooldown = 90, class = "PRIEST", specID = { 257 } }, -- Desperate Prayer
  [196762] = { default = false, cooldown = 30, class = "PRIEST", specID = { 257 } }, -- Inner Focus
  [197268] = { default = false, cooldown = 60, class = "PRIEST", specID = { 257 } }, -- Ray of Hope
  [200183] = { default = false, cooldown = 180, class = "PRIEST", specID = { 257 } }, -- Apotheosis
  [213610] = { default = false, cooldown = 45, class = "PRIEST", specID = { 257 } }, -- Holy Ward
  [215769] = { default = false, cooldown = 300, class = "PRIEST", specID = { 257 } }, -- Spirit of Redemption

  -- Shadow

  [15286] = { default = true, cooldown = 180, class = "PRIEST", specID = { 258 }, defensive = true, duration = 15}, -- Vampiric Embrace
  [15487] = { default = true, cooldown = 45, class = "PRIEST", specID = { 258 }, cc = true }, -- Silence
  [32379] = { default = false, cooldown = 9, class = "PRIEST", specID = { 258 }, charges = 2 }, -- Shadow Word: Death
  [47585] = { default = true, cooldown = 90, class = "PRIEST", specID = { 258 }, defensive = true, duration = 6 }, -- Dispersion
  [108968] = { default = false, cooldown = 300, class = "PRIEST", specID = { 258 }, defensive = true, talent = {211522} }, -- Void Shift
  -- [193223] = { default = false, cooldown = 600, class = "PRIEST", specID = { 258 } }, -- Surrender to Madness
  -- [197871] = { default = false, cooldown = 60, class = "PRIEST", specID = { 258 } }, -- Dark Archangel
  [205065] = { default = false, cooldown = 60, class = "PRIEST", specID = { 258 }, offensive = true }, -- Void Torrent
  [205369] = { default = true, cooldown = 30, class = "PRIEST", specID = { 258 }, talent = {8122}, cc = true }, -- Mind Bomb
  [211522] = { default = false, cooldown = 45, class = "PRIEST", specID = { 258 }, talent = {108968}, offensive = true}, -- Psyfiend

  -- Paladin

  -- [633] = { default = false, cooldown = 600, class = "PALADIN" }, -- Lay on Hands
  [642] = { default = true, cooldown = 300, class = "PALADIN", defensive = true, duration = 8 }, -- Divine Shield
  [853] = { default = true, cooldown = 60, class = "PALADIN", cc= true }, -- Hammer of Justice
  [1022] = { default = true, cooldown = 300, class = "PALADIN", charges = 2, defensive = true, dispelable = true, duration = 10 }, -- Blessing of Protection
  [1044] = { default = true, cooldown = 25, class = "PALADIN", charges = 2, sprint = true, dispelable = true, duration = 8 }, -- Blessing of Freedom
  [20066] = { default = false, cooldown = 15, class = "PALADIN", cc=true, talent = {115750} }, -- Repentance
  [31884] = { default = true, cooldown = 120, class = "PALADIN", offensive = true, duration = 20 }, -- Avenging Wrath
  [31842] = { parent = 31884 , specID = { 65 }}, -- Avenging Wrath (Holy)
  [216331] = { parent = 31884, cooldown = 60 , specID = { 65 }}, -- Avenging Crusader
  [224668] = { parent = 31884 , specID = { 70 }}, -- Crusade
  [115750] = { default = false, cooldown = 90, class = "PALADIN", cc = true, talent = {20066} }, -- Blinding Light

  -- Holy

  [498] = { default = true, cooldown = 60, class = "PALADIN", specID = { 65, 66 }, defensive = true, duration = 8}, -- Divine Protection
  [6940] = { default = true, cooldown = 150, class = "PALADIN", specID = { 65, 66 }, charges = 2, defensive, duration=10 }, -- Blessing of Sacrifice
  [31821] = { default = true, cooldown = 180, class = "PALADIN", specID = { 65 }, defensive = true, duration = 6 }, -- Aura Mastery
  [105809] = { default = true, cooldown = 90, class = "PALADIN", specID = { 65 }, offensive = true, duration = 20 }, -- Holy Avenger
  [114158] = { default = false, cooldown = 60, class = "PALADIN", specID = { 65 } }, -- Light's Hammer
  [183415] = { default = false, cooldown = 180, class = "PALADIN", specID = { 65 } }, -- Aura of Mercy
  [200652] = { default = false, cooldown = 90, class = "PALADIN", specID = { 65 }, cast = 2 }, -- Tyr's Deliverance
  [210294] = { default = true, cooldown = 45, class = "PALADIN", specID = { 65 }, dispelable = true, offensive = true }, -- Divine Favor
  [214202] = { default = false, cooldown = 30, class = "PALADIN", specID = { 65 }, charges = 2 }, -- Rule of Law

  -- Protection TBD

  [204018] = { parent = 1022, cooldown = 180, class = "PALADIN", specID = { 66 }, talent = {1022} }, -- Blessing of Spellwarding
  [31850] = { default = false, cooldown = 120, class = "PALADIN", specID = { 66 } }, -- Ardent Defender
  [31935] = { default = true, cooldown = 15, class = "PALADIN", specID = { 66 } }, -- Avenger's Shield
  [86659] = { default = false, cooldown = 300, class = "PALADIN", specID = { 66 } }, -- Guardian of Ancient Kings
  [228049] = { parent = 86659 }, -- Guardian of the Forgotten Queen
  [96231] = { default = true, cooldown = 15, class = "PALADIN", specID = { 66, 70 } }, -- Rebuke
  [152262] = { default = false, cooldown = 30, class = "PALADIN", specID = { 66 } }, -- Seraphim
  [190784] = { default = false, cooldown = 45, class = "PALADIN", specID = { 66 } }, -- Divine Steed
  [204035] = { default = false, cooldown = 180, class = "PALADIN", specID = { 66 } }, -- Bastion of Light
  [204150] = { default = false, cooldown = 300, class = "PALADIN", specID = { 66 } }, -- Aegis of Light
  [209202] = { default = false, cooldown = 60, class = "PALADIN", specID = { 66 } }, -- Eye of Tyr
  [215652] = { default = false, cooldown = 25, class = "PALADIN", specID = { 66 } }, -- Shield of Virtue

  -- Retribution

  [184662] = { default = true, cooldown = 120, class = "PALADIN", specID = { 70 }, defensive = true, dispelable = true, duration = 15 }, -- Shield of Vengeance
  [204939] = { default = false, cooldown = 60, class = "PALADIN", specID = { 70 } }, -- Hammer of Reckoning
  [205191] = { default = false, cooldown = 60, class = "PALADIN", specID = { 70 }, talent = {}, defensive = true, duration = 10 }, -- Eye for an Eye
  [205273] = { default = true, cooldown = 30, class = "PALADIN", specID = { 70 }, offensive = true }, -- Wake of Ashes
  [210191] = { default = false, cooldown = 60, class = "PALADIN", specID = { 70 }, defensive = true }, -- Word of Glory
  [210220] = { default = false, cooldown = 180, class = "PALADIN", specID = { 70 }, offensive = true }, -- Holy Wrath
  [210256] = { default = false, cooldown = 25, class = "PALADIN", specID = { 70 }, dispel = true }, -- Blessing of Sanctuary

  -- Druid

  [1850] = { default = false, cooldown = 180, class = "DRUID", sprint = true, duration = 15 }, -- Dash
  [5211] = { default = true, cooldown = 50, class = "DRUID", cc = true }, -- Mighty Bash
  -- [20484] = { default = false, cooldown = 600, class = "DRUID", revival = true }, -- Rebirth
  [102280] = { default = true, cooldown = 30, class = "DRUID", blink = true, talent = {102401,108238} }, -- Displacer Beast
  [102359] = { default = false, cooldown = 30, class = "DRUID", talent = {5211,132469} , cc = true}, -- Mass Entanglement
  [102401] = { default = true, cooldown = 15, class = "DRUID", talent = {102280,108238}, blink = true }, -- Wild Charge
  [132469] = { default = false, cooldown = 30, class = "DRUID", talent = {5211,102359}, cc = true }, -- Typhoon

  -- Balance

  [22812] = { default = true, cooldown = { default = 60, [104] = 35 }, class = "DRUID", specID = { 102, 104, 105 }, defensive = true, duration = 12 }, -- Barkskin
  [29166] = { default = false, cooldown = 180, class = "DRUID", specID = { 102, 105 } }, -- Innervate
  [78675] = { default = true, cooldown = 60, class = "DRUID", specID = { 102 }, interrupt = true }, -- Solar Beam
  [102560] = { parent = 194223, default = true, duration = 30 }, -- Incarnation: Chosen of Elune
  [108238] = { default = false, cooldown = 120, class = "DRUID", specID = { 102, 103, 105 }, defensive = true, talent = {102280,102401} }, -- Renewal
  [194223] = { default = true, cooldown = 180, class = "DRUID", specID = { 102 }, offensive = true, duration = 15 }, -- Celestial Alignment
  [202425] = { default = true, cooldown = 45, class = "DRUID", specID = { 102 }, offensive = true }, -- Warrior of Elune
  [202770] = { default = false, cooldown = 90, class = "DRUID", specID = { 102 }, offensive = true }, -- Fury of Elune
  [205636] = { default = false, cooldown = 60, class = "DRUID", specID = { 102 }, offensive = true, talent = {202425} }, -- Force of Nature
  [209749] = { default = false, cooldown = 30, class = "DRUID", specID = { 102 }, talent = {} }, -- Faerie Swarm

  -- Feral

  [5217] = { default = false, cooldown = 30, class = "DRUID", specID = { 103 }, offensive = true }, -- Tiger's Fury
  [22570] = { default = false, cooldown = 10, class = "DRUID", specID = { 103 }, cc = true }, -- Maim
  [61336] = { default = true, cooldown = { default = 180, [104] = 120 }, class = "DRUID", specID = { 103, 104 }, charges = 2, defensive= true, duration=6 }, -- Survival Instincts
  [102543] = { parent = 106951, duration = 30}, -- Incarnation: King of the Jungle
  [106839] = { default = true, cooldown = 15, class = "DRUID", specID = { 103, 104 }, interrupt = true }, -- Skull Bash
  [106898] = { default = false, cooldown = 120, class = "DRUID", specID = { 103, 104 }, sprint = true, duration =8 }, -- Stampeding Roar
  [106951] = { default = true, cooldown = 180, class = "DRUID", specID = { 103 }, duration = 15, offensive = true }, -- Berserk
  [202060] = { default = false, cooldown = 45, class = "DRUID", specID = { 103 }, talent = {} }, -- Elune's Guidance
  [203242] = { default = false, cooldown = 60, class = "DRUID", specID = { 103 }, talent = {} }, -- Rip and Tear
  [210722] = { default = false, cooldown = 75, class = "DRUID", specID = { 103 }, offensive = true }, -- Ashamane's Frenzy

  -- Guardian TBD

  [99] = { default = false, cooldown = 30, class = "DRUID", specID = { 104 } }, -- Incapacitating Roar
  [22842] = { default = false, cooldown = 24, class = "DRUID", specID = { 104 }, charges = 2 }, -- Frenzied Regeneration
  [102558] = { default = false, cooldown = 180, class = "DRUID", specID = { 104 } }, -- Incarnation: Guardian of Ursoc
  [200851] = { default = false, cooldown = 90, class = "DRUID", specID = { 104 } }, -- Rage of the Sleeper
  [202246] = { default = false, cooldown = 15, class = "DRUID", specID = { 104 } }, -- Overrun
  [204066] = { default = false, cooldown = 90, class = "DRUID", specID = { 104 } }, -- Lunar Beam

  -- Restoration

  [740] = { default = true, cooldown = 120, class = "DRUID", specID = { 105}, offensive = true }, -- Tranquility
  [18562] = { default = false, cooldown = 30, class = "DRUID", specID = { 105}, charges = 2, defensive = true }, -- Swiftmend
  [33891] = { default = false, cooldown = 180, class = "DRUID", specID = { 105}, talent = {}, offensive = true, defensive = true }, -- Incarnation: Tree of Life
  [102342] = { default = true, cooldown = 60, class = "DRUID", specID = { 105}, defensive = true, duration = 12 }, -- Ironbark
  [102351] = { default = false, cooldown = 30, class = "DRUID", specID = { 105}, defensive = true, duration = 8, talent ={} }, -- Cenarion Ward
  [102793] = { default = true, cooldown = 60, class = "DRUID", specID = { 105}, cc = true, duration = 10 }, -- Ursol's Vortex
  [197721] = { default = false, cooldown = 60, class = "DRUID", specID = { 105}, talent = {} }, -- Flourish
  -- [201664] = { default = false, cooldown = 60, class = "DRUID", specID = { 105} }, -- Demoralizing Roar
  [203651] = { default = true, cooldown = 45, class = "DRUID", specID = { 105}, defensive = true }, -- Overgrowth
  [203727] = { default = false, cooldown = 45, class = "DRUID", specID = { 105}, defensive = true, duration = 12 }, -- Thorns
  [208253] = { default = false, cooldown = 90, class = "DRUID", specID = { 105}, offensive = true, duration = 8 }, -- Essence of G'Hanir

  -- Warrior

  [100] = { default = true, cooldown = 17, class = "WARRIOR", charges = 2, blink = true }, -- Charge
  [198758] = { parent = 100 }, -- Intercept
  [1719] = { default = true, cooldown = 45, class = "WARRIOR", offensive = true, duration = 5 }, -- Battle Cry
  [6544] = { default = true, cooldown = 45, class = "WARRIOR", blink = true }, -- Heroic Leap
  [6552] = { default = true, cooldown = 15, class = "WARRIOR", interrupt = true}, -- Pummel
  [18499] = { default = false, cooldown = 60, class = "WARRIOR", dispel = true }, -- Berserker Rage
  [23920] = { default = true, cooldown = 25, class = "WARRIOR", defensive = true, talent = {}, duration = 3 }, -- Spell Reflection
  [213915] = { parent = 23920, cooldown = 30 }, -- Mass Spell Reflection
  [216890] = { parent = 23920 }, -- Spell Reflection (Arms, Fury)
  [46968] = { default = true, cooldown = 40, class = "WARRIOR", talent = {107570}, cc = true }, -- Shockwave
  [107570] = { default = true, cooldown = 30, class = "WARRIOR", talent = {46968}, cc = true }, -- Storm Bolt
  [107574] = { default = true, cooldown = 90, class = "WARRIOR", offensive = true, duration = 20 }, -- Avatar

  -- Arms

  [5246] = { default = false, cooldown = 90, class = "WARRIOR", specID = { 71, 72 }, cc = true }, -- Intimidating Shout
  [97462] = { default = false, cooldown = 180, class = "WARRIOR", specID = { 71, 72 }, defensive = true, duration = 10 }, -- Commanding Shout
  [118038] = { default = false, cooldown = 180, class = "WARRIOR", specID = { 71 }, defensive = true, duration = 8 }, -- Die by the Sword
  -- [167105] = { default = false, cooldown = 45, class = "WARRIOR", specID = { 71 } }, -- Colossus Smash
  -- [197690] = { default = false, cooldown = 10, class = "WARRIOR", specID = { 71 }, }, -- Defensive Stance
  [198817] = { default = true, cooldown = 45, class = "WARRIOR", specID = { 71 }, talent = {}, offensive = true }, -- Sharpen Blade
  -- [209577] = { default = false, cooldown = 60, class = "WARRIOR", specID = { 71 }, offensive = true }, -- Warbreaker
  [227847] = { default = true, cooldown = 90, class = "WARRIOR", specID = { 71, 72 }, offensive = true, duration = 6 }, -- Bladestorm (Arms)
  [46924] = { parent = 227847 }, -- Bladestorm (Fury)
  -- [152277] = { parent = 227847, cooldown = 60 }, -- Ravager

  -- Fury TBD

  [118000] = { default = false, cooldown = 25, class = "WARRIOR", specID = { 72 } }, -- Dragon Roar
  [184364] = { default = false, cooldown = 120, class = "WARRIOR", specID = { 72 } }, -- Enraged Regeneration
  [205545] = { default = false, cooldown = 45, class = "WARRIOR", specID = { 72 } }, -- Odyn's Fury

  -- Protection TBD

  [871] = { default = false, cooldown = 240, class = "WARRIOR", specID = { 73 } }, -- Shield Wall
  [1160] = { default = false, cooldown = 60, class = "WARRIOR", specID = { 73 } }, -- Demoralizing Shout
  [12975] = { default = false, cooldown = 180, class = "WARRIOR", specID = { 73 } }, -- Last Stand
  [198304] = { default = false, cooldown = 20, class = "WARRIOR", specID = { 73 }, charges = 2 }, -- Intercept
  [206572] = { default = false, cooldown = 20, class = "WARRIOR", specID = { 73 } }, -- Dragon Charge
  [213871] = { default = false, cooldown = 15, class = "WARRIOR", specID = { 73 } }, -- Bodyguard
  [228920] = { default = false, cooldown = 60, class = "WARRIOR", specID = { 73 } }, -- Ravager

  -- Warlock

  [1122] = { default = false, cooldown = 180, class = "WARLOCK", cc = true, offensive = true }, -- Summon Infernal
  -- [6358] = { default = false, cooldown = 30, class = "WARLOCK" }, -- Seduction
  -- [6360] = { default = false, cooldown = 25, class = "WARLOCK" }, -- Whiplash
  -- [115770] = { parent = 6360 }, -- Fellash
  [6789] = { default = false, cooldown = 45, class = "WARLOCK", talent = {}, cc = true }, -- Mortal Coil
  -- [18540] = { default = false, cooldown = 180, class = "WARLOCK" }, -- Summon Doomguard
  -- [20707] = { default = false, cooldown = 600, class = "WARLOCK" }, -- Soulstone
  [104773] = { default = false, cooldown = {default = 180, [267] = 60}, class = "WARLOCK", defensive = true, duration = 8 }, -- Unending Resolve
  [108416] = { default = false, cooldown = 60, class = "WARLOCK", talent = {}, defensive = true }, -- Dark Pact
  [108501] = { default = false, cooldown = 90, class = "WARLOCK", cc = true }, -- Grimoire of Service
  -- [115268] = { default = false, cooldown = 6358, class = "WARLOCK", }, -- Mesmerize
  -- [115284] = { default = false, cooldown = 15, class = "WARLOCK" }, -- Clone Magic
  [119910] = { default = true, cooldown = 24, class = "WARLOCK", interrupt = true }, -- Spell Lock (Command Demon)
  [19647] = { parent = 119910 }, -- Spell Lock (Felhunter)
  [119911] = { parent = 119910 }, -- Optical Blast (Command Demon)
  [115781] = { parent = 119910 }, -- Optical Blast (Observer)
  [132409] = { parent = 119910 }, -- Spell Lock (Grimoire of Sacrifice)
  [171138] = { parent = 119910 }, -- Shadow Lock (Doomguard)
  [171139] = { parent = 119910 }, -- Shadow Lock (Grimoire of Sacrifice)
  [171140] = { parent = 119910 }, -- Shadow Lock (Command Demon)
  -- [171152] = { default = false, cooldown = 60, class = "WARLOCK" }, -- Meteor Strike
  [196098] = { default = true, cooldown = 120, class = "WARLOCK", offensive = true, talent = {}, dispelable = true }, -- Soul Harvest
  -- [199890] = { default = false, cooldown = 15, class = "WARLOCK" }, -- Curse of Tongues
  -- [199892] = { default = false, cooldown = 20, class = "WARLOCK" }, -- Curse of Weakness
  -- [199954] = { default = false, cooldown = 45, class = "WARLOCK" }, -- Curse of Fragility
  [212295] = { default = true, cooldown = 45, class = "WARLOCK", talent = {221703}, offensive = true, duration = 5, dispelable = true }, -- Nether Ward
  [221703] = { default = false, cooldown = 30, class = "WARLOCK", talent = {212295}, offensive = true, duration = 10 }, -- Casting Circle
  -- [48018] = { default = false, cooldown = 30, class = "WARLOCK", talent = {5484}, blink = true, duration = 10 }, -- Demonic Circle

  -- Affliction

  [5484] = { default = false, cooldown = 40, class = "WARLOCK", specID = { 265 }, talent = {48018}, cc = true }, -- Howl of Terror
  -- [48181] = { default = false, cooldown = 15, class = "WARLOCK", specID = { 265 } }, -- Haunt
  -- [86121] = { default = false, cooldown = 20, class = "WARLOCK", specID = { 265 } }, -- Soul Swap
  [205179] = { default = false, cooldown = 60, class = "WARLOCK", specID = { 265 }, offensive = true, duration = 15 }, -- Phantom Singularity

  -- Demonology TBD

  [30283] = { default = false, cooldown = 30, class = "WARLOCK", specID = { 266, 267 } }, -- Shadowfury
  [89751] = { default = false, cooldown = 45, class = "WARLOCK", specID = { 266 } }, -- Felstorm
  [115831] = { parent = 89751 }, -- Wrathstorm
  [89766] = { default = false, cooldown = 30, class = "WARLOCK", specID = { 266 } }, -- Axe Toss
  [201996] = { default = false, cooldown = 90, class = "WARLOCK", specID = { 266 } }, -- Call Observer
  [205180] = { default = false, cooldown = 24, class = "WARLOCK", specID = { 266 } }, -- Summon Darkglare
  [205181] = { default = false, cooldown = 14, class = "WARLOCK", specID = { 266 }, charges = 2 }, -- Shadowflame
  [211714] = { default = false, cooldown = 45, class = "WARLOCK", specID = { 266 } }, -- Thal'kiel's Consumption
  [212459] = { default = false, cooldown = 90, class = "WARLOCK", specID = { 266 } }, -- Call Fel Lord
  [212623] = { default = false, cooldown = 15, class = "WARLOCK", specID = { 266 } }, -- Singe Magic

  --  Destruction TBD

  [17962] = { default = false, cooldown = 12, class = "WARLOCK", specID = { 267 }, charges = 2 }, -- Conflagrate
  [80240] = { default = false, cooldown = 20, class = "WARLOCK", specID = { 267 } }, -- Havoc
  [152108] = { default = false, cooldown = 45, class = "WARLOCK", specID = { 267 } }, -- Cataclysm
  [196447] = { default = false, cooldown = 15, class = "WARLOCK", specID = { 267 } }, -- Channel Demonfire
  [196586] = { default = false, cooldown = 45, class = "WARLOCK", specID = { 267 }, charges = 3 }, -- Dimensional Rift
  [212284] = { default = false, cooldown = 45, class = "WARLOCK", specID = { 267 } }, -- Firestone

  -- Shaman

  -- [2825] = { default = false, cooldown = 45, class = "SHAMAN" }, -- Bloodlust
  -- [32182] = { parent = 2825 }, -- Heroism
  -- [20608] = { default = false, cooldown = 1800, class = "SHAMAN" }, -- Reincarnation
  [51514] = { default = false, cooldown = 30, class = "SHAMAN", cc = true }, -- Hex
  [196932] = { parent = 51514, cc = true, talent = {192058,51485}, cooldown = 30 }, -- Voodoo Totem
  [210873] = { parent = 51514 }, -- Hex (Compy)
  [211004] = { parent = 51514 }, -- Hex (Spider)
  [211010] = { parent = 51514 }, -- Hex (Snake)
  [211015] = { parent = 51514 }, -- Hex (Cockroach)
  [57994] = { default = true, cooldown = 12, class = "SHAMAN", interrupt = true }, -- Wind Shear
  [108271] = { default = false, cooldown = 90, class = "SHAMAN", defensive = true, duration = 8 }, -- Astral Shift
  [210918] = { parent = 108271, cooldown = 45 }, -- Ethereal Form
  [114049] = { default = false, cooldown = 180, class = "SHAMAN", offensive = true, talent = {} }, -- Ascendance
  [114050] = { parent = 114049 }, -- Ascendance (Elemental)
  [114051] = { parent = 114049 }, -- Ascendance (Enhancement)
  [114052] = { parent = 114049 }, -- Ascendance (Restoration)
  [192058] = { default = false, cooldown = 45, class = "SHAMAN", cc = true, talent = {196932,51485} }, -- Lightning Surge Totem
  [51485] = { default = false, cooldown = 30, class = "SHAMAN", cc = true, talent = {196932,192058} }, -- Earthgrab Totem
  -- [192077] = { default = false, cooldown = 120, class = "SHAMAN" }, -- Wind Rush Totem
  [204330] = { default = false, cooldown = 45, class = "SHAMAN", talent = {204331,204332}, offensive = true }, -- Skyfury Totem
  [204331] = { default = false, cooldown = 45, class = "SHAMAN", talent = {204330,204332}, offensive = true }, -- Counterstrike Totem
  [204332] = { default = false, cooldown = 30, class = "SHAMAN", talent = {204331,204330}, offensive = true }, -- Windfury Totem

  -- Elemental

  [51490] = { default = false, cooldown = 45, class = "SHAMAN", specID = { 262 }, defensive = true }, -- Thunderstorm
  -- [108281] = { default = false, cooldown = 120, class = "SHAMAN", specID = { 262, 264 },  }, -- Ancestral Guidance
  -- [16166] = { default = false, cooldown = 120, class = "SHAMAN", specID = { 262 } }, -- Elemental Mastery
  [192063] = { default = false, cooldown = 15, class = "SHAMAN", specID = { 262, 264 },blink = true }, -- Gust of Wind
  -- [192222] = { default = false, cooldown = 60, class = "SHAMAN", specID = { 262 } }, -- Liquid Magma Totem
  [198067] = { default = false, cooldown = 300, class = "SHAMAN", specID = { 262 }, offensive = true }, -- Fire Elemental
  [192249] = { parent = 198067 }, -- Storm Elemental
  -- [198103] = { default = false, cooldown = 120, class = "SHAMAN", specID = { 262 } }, -- Earth Elemental
  [204437] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 262 }, talent = {} }, -- Lightning Lasso
  [205495] = { default = false, cooldown = 60, class = "SHAMAN", specID = { 262 }, offensive = true, cast = 1.5 }, -- Stormkeeper
  [210714] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 262 }, offensive = true, cast = 2 }, -- Icefury

  -- Enhancement

  [58875] = { default = false, cooldown = 60, class = "SHAMAN", specID = { 263 }, sprint = true, duration = 8 }, -- Spirit Walk
  [196884] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 263 }, blink = true }, -- Feral Lunge
  -- [197214] = { default = false, cooldown = 40, class = "SHAMAN", specID = { 263 } }, -- Sundering
  -- [201898] = { default = false, cooldown = 45, class = "SHAMAN", specID = { 263 } }, -- Windsong
  -- [204366] = { default = false, cooldown = 45, class = "SHAMAN", specID = { 263 } }, -- Thundercharge
  [204945] = { default = false, cooldown = 60, class = "SHAMAN", specID = { 263 },offensive = true, duration = 6 }, -- Doom Winds
  [204945] = { default = false, cooldown = 60, class = "SHAMAN", specID = { 263 },offensive = true, duration = 6 }, -- Doom Winds
  [2825] = { default = false, cooldown = 45, class = "SHAMAN", specID = { 263 }, offensive = true, duration = 10 }, -- Bloodlust
  [32182] = { parent = 2825 }, -- Heroism

  -- Restoration

  -- [5394] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 264 }, charges = 30 }, -- Healing Stream Totem
  [79206] = { default = false, cooldown = 120, class = "SHAMAN", specID = { 264 }, dispelable = true, defensive = true,duration=15 }, -- Spiritwalker's Grace
  [98008] = { default = false, cooldown = 180, class = "SHAMAN", specID = { 264 }, defensive = true }, -- Spirit Link Totem
  [204293] = { parent = 98008, cooldown = 30, duration = 20 }, -- Spirit Link
  [108280] = { default = false, cooldown = 180, class = "SHAMAN", specID = { 264 }, defensive = true }, -- Healing Tide Totem
  [157153] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 264 }, defensive = true }, -- Cloudburst Totem
  [198838] = { default = false, cooldown = 60, class = "SHAMAN", specID = { 264 }, defensive = true, talent = {207399} }, -- Earthen Shield Totem
  [204336] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 264 }, defensive = true }, -- Grounding Totem
  [207399] = { default = false, cooldown = 300, class = "SHAMAN", specID = { 264 }, defensive = true, talent = {198838} }, -- Ancestral Protection Totem
  -- [207778] = { default = false, cooldown = 45, class = "SHAMAN", specID = { 264 } }, -- Gift of the Queen

  -- Hunter

  -- [136] = { default = false, cooldown = 10, class = "HUNTER" }, -- Mend Pet
  [1543] = { default = false, cooldown = 20, class = "HUNTER" }, -- Flare
  [5384] = { default = false, cooldown = 30, class = "HUNTER", defensive = true }, -- Feign Death
  [109304] = { default = false, cooldown = 120, class = "HUNTER", defensive = true }, -- Exhilaration (Beast Mastery, Survival)
  [194291] = { parent = 109304 }, -- Exhilaration (Marksmanship)
  [131894] = { default = false, cooldown = 60, class = "HUNTER", offensive = true }, -- A Murder of Crows (Beast Mastery, Marksmanship)
  [206505] = { parent = 131894 }, -- A Murder of Crows (Survival)
  [186257] = { default = false, cooldown = { default = 180, [253] = 120, [255] = 144 }, class = "HUNTER", sprint = true, duration = 12 }, -- Aspect of the Cheetah
  [186265] = { default = false, cooldown = { default = 180, [255] = 144 }, class = "HUNTER", defensive = true, duration = 8 }, -- Aspect of the Turtle
  [202914] = { default = false, cooldown = 60, class = "HUNTER", cc = true, talent = {} }, -- Spider Sting
  [209997] = { default = false, cooldown = 30, class = "HUNTER", defensive = true  }, -- Play Dead

  -- Beast Mastery

  [781] = { default = false, cooldown = 20, class = "HUNTER", specID = { 253, 254 }, blink = true }, -- Disengage
  [19386] = { default = false, cooldown = 45, class = "HUNTER", specID = { 253, 254 }, cc = true }, -- Wyvern Sting
  [19574] = { default = false, cooldown = 75, class = "HUNTER", specID = { 253 }, offensive = true, duration = 20 }, -- Bestial Wrath
  [19577] = { default = false, cooldown = 60, class = "HUNTER", specID = { 253 }, cc = true }, -- Intimidation
  [109248] = { default = false, cooldown = 45, class = "HUNTER", specID = { 253, 254 }, cc = true }, -- Binding Shot
  [147362] = { default = true, cooldown = 24, class = "HUNTER", specID = { 253, 254 }, interrupt = true }, -- Counter Shot
  [193530] = { default = false, cooldown = 120, class = "HUNTER", specID = { 253 },offensive = true, duration = 10 }, -- Aspect of the Wild
  -- [194386] = { default = false, cooldown = 90, class = "HUNTER", specID = { 253, 254 } }, -- Volley
  [201430] = { default = false, cooldown = 180, class = "HUNTER", specID = { 253 }, offensive = true }, -- Stampede
  [207068] = { default = false, cooldown = 60, class = "HUNTER", specID = { 253 }, offensive = true }, -- Titan's Thunder
  [208652] = { default = false, cooldown = 30, class = "HUNTER", specID = { 253 }, offensive = true }, -- Dire Beast: Hawk

  -- Marksmanship TBD

  [34477] = { default = false, cooldown = 30, class = "HUNTER", specID = { 254 } }, -- Misdirection
  [186387] = { default = false, cooldown = 20, class = "HUNTER", specID = { 254 } }, -- Bursting Shot
  [193526] = { default = false, cooldown = 140, class = "HUNTER", specID = { 254 } }, -- Trueshot
  [199483] = { default = false, cooldown = 60, class = "HUNTER", specID = { 254, 255 } }, -- Camouflage
  [204147] = { default = false, cooldown = 20, class = "HUNTER", specID = { 254 } }, -- Windburst
  [206817] = { default = false, cooldown = 30, class = "HUNTER", specID = { 254 } }, -- Sentinel
  [209789] = { default = false, cooldown = 30, class = "HUNTER", specID = { 254 } }, -- Freezing Arrow
  [213691] = { default = false, cooldown = 20, class = "HUNTER", specID = { 254 } }, -- Scatter Shot

  -- Survival

  [53271] = { default = false, cooldown = 45, class = "HUNTER", specID = { 255 }, sprint = true, duration = 4, dispelable = true }, -- Master's Call
  [186289] = { default = false, cooldown = 96, class = "HUNTER", specID = { 255 }, offensive = true, duration = 10 }, -- Aspect of the Eagle
  [187650] = { default = false, cooldown = 20, class = "HUNTER", specID = { 255 }, cc = true }, -- Freezing Trap
  -- [187698] = { default = false, cooldown = 20, class = "HUNTER", specID = { 255 } }, -- Tar Trap
  [187707] = { default = true, cooldown = 15, class = "HUNTER", specID = { 255 }, interrupt = true }, -- Muzzle
  [190925] = { default = false, cooldown = 20, class = "HUNTER", specID = { 255 }, blink = true }, -- Harpoon
  -- [191241] = { default = false, cooldown = 30, class = "HUNTER", specID = { 255 } }, -- Sticky Bomb
  -- [191433] = { default = false, cooldown = 20, class = "HUNTER", specID = { 255 } }, -- Explosive Trap
  -- [194407] = { default = false, cooldown = 60, class = "HUNTER", specID = { 255 } }, -- Spitting Cobra
  [201078] = { default = false, cooldown = 90, class = "HUNTER", specID = { 255 }, offensive = true }, -- Snake Hunter
  -- [203415] = { default = false, cooldown = 45, class = "HUNTER", specID = { 255 } }, -- Fury of the Eagle
  -- [205691] = { default = false, cooldown = 120, class = "HUNTER", specID = { 255 } }, -- Dire Beast: Basilisk
  [212640] = { default = false, cooldown = 25, class = "HUNTER", specID = { 255 }, defensive= true }, -- Mending Bandage

  -- Mage

  [66] = { default = false, cooldown = 300, class = "MAGE", defensive = true }, -- Invisibility
  [110959] = { parent = 66, cooldown = 75 }, -- Greater Invisibility
  [1953] = { default = false, cooldown = 15, class = "MAGE", blink = true }, -- Blink
  [212653] = { parent = 1953, charges = 2 }, -- Shimmer
  [2139] = { default = true, cooldown = 24, class = "MAGE", interrupt = true }, -- Counterspell
  [11426] = { default = false, cooldown = 25, class = "MAGE", defensive = true }, -- Ice Barrier
  [45438] = { default = false, cooldown = 300, class = "MAGE", charges = 2, defensive = true, duration = 10 }, -- Ice Block
  [55342] = { default = false, cooldown = 120, class = "MAGE", offensive = true, talent = {} }, -- Mirror Image
  -- [80353] = { default = false, cooldown = 300, class = "MAGE", }, -- Time Warp
  [108839] = { default = false, cooldown = 20, class = "MAGE", charges = 3, sprint = true }, -- Ice Floes
  [113724] = { default = false, cooldown = 45, class = "MAGE", cc = true , talent = {108839} }, -- Ring of Frost
  -- [116011] = { default = false, cooldown = 40, class = "MAGE", charges = 2 }, -- Rune of Power

  -- Arcane TBD

  [12042] = { default = false, cooldown = 90, class = "MAGE", specID = { 62 } }, -- Arcane Power
  [12051] = { default = false, cooldown = 90, class = "MAGE", specID = { 62 } }, -- Evocation
  [153626] = { default = false, cooldown = 20, class = "MAGE", specID = { 62 } }, -- Arcane Orb
  [157980] = { default = false, cooldown = 25, class = "MAGE", specID = { 62 } }, -- Supernova
  [195676] = { default = false, cooldown = 24, class = "MAGE", specID = { 62 } }, -- Displacement
  [198158] = { default = false, cooldown = 60, class = "MAGE", specID = { 62 } }, -- Mass Invisibility
  [205025] = { default = false, cooldown = 60, class = "MAGE", specID = { 62 } }, -- Presence of Mind
  [224968] = { default = false, cooldown = 60, class = "MAGE", specID = { 62 } }, -- Mark of Aluneth

  -- Fire TBD

  [31661] = { default = false, cooldown = 20, class = "MAGE", specID = { 63 } }, -- Dragon's Breath
  [108853] = { default = false, cooldown = 12, class = "MAGE", specID = { 63 }, charges = 2 }, -- Fire Blast
  [153561] = { default = false, cooldown = 45, class = "MAGE", specID = { 63 } }, -- Meteor
  [157981] = { default = false, cooldown = 25, class = "MAGE", specID = { 63 } }, -- Blast Wave
  [190319] = { default = false, cooldown = 115, class = "MAGE", specID = { 63 } }, -- Combustion
  [194466] = { default = false, cooldown = 45, class = "MAGE", specID = { 63 }, charges = 3 }, -- Phoenix's Flames
  [205029] = { default = false, cooldown = 45, class = "MAGE", specID = { 63 } }, -- Flame On

  -- Frost

  [122] = { default = false, cooldown = 30, class = "MAGE", specID = { 64 }, cc = true}, -- Frost Nova
  [12472] = { default = false, cooldown = 180, class = "MAGE", specID = { 64 }, offensive = true, dispelable = true, duration = 20 }, -- Icy Veins
  [198144] = { parent = 12472, cooldown = 60, duration = 12 }, -- Ice Form
  -- [31687] = { default = false, cooldown = 60, class = "MAGE", specID = { 64 } }, -- Summon Water Elemental
  -- [84714] = { default = false, cooldown = 60, class = "MAGE", specID = { 64 } }, -- Frozen Orb
  -- [153595] = { default = false, cooldown = 30, class = "MAGE", specID = { 64 } }, -- Comet Storm
  [157997] = { default = false, cooldown = 25, class = "MAGE", specID = { 64 }, offensive = true }, -- Ice Nova
  [205021] = { default = false, cooldown = 60, class = "MAGE", specID = { 64 }, offensive = true, talent = {} }, -- Ray of Frost
  -- [214634] = { default = false, cooldown = 45, class = "MAGE", specID = { 64 } }, -- Ebonbolt

  -- Rogue

  -- [1725] = { default = false, cooldown = 30, class = "ROGUE" }, -- Distract
  [1766] = { default = true, cooldown = 15, class = "ROGUE", interrupt = true }, -- Kick
  [1856] = { default = false, cooldown = { default = 120, [259] = 100 }, class = "ROGUE", defensive = true, duration = 3 }, -- Vanish
  [2983] = { default = false, cooldown = { default = 60, [259] = 51 }, class = "ROGUE", sprint = true, duration = 8 }, -- Sprint
  [31224] = { default = false, cooldown = { default = 90, [259] = 81 }, class = "ROGUE", defensive = true, duration = 5 }, -- Cloak of Shadows
  -- [57934] = { default = false, cooldown = 30, class = "ROGUE" }, -- Tricks of the Trade
  -- [137619] = { default = false, cooldown = 60, class = "ROGUE" }, -- Marked for Death
  -- [152150] = { default = false, cooldown = 20, class = "ROGUE" }, -- Death from Above

  -- Assassination

  [408] = { default = false, cooldown = 20, class = "ROGUE", specID = { 259, 261 }, cc= true }, -- Kidney Shot
  [703] = { default = false, cooldown = 15, class = "ROGUE", specID = { 259 }, cc= true }, -- Garrote
  [5277] = { default = false, cooldown = 120, class = "ROGUE", specID = { 259, 261 }, defensive = true, duration = 10 }, -- Evasion
  [36554] = { default = false, cooldown = 30, class = "ROGUE", specID = { 259, 261 }, blink = true }, -- Shadowstep
  [79140] = { default = false, cooldown = 90, class = "ROGUE", specID = { 259 }, offensive = true }, -- Vendetta
  [192759] = { default = false, cooldown = 45, class = "ROGUE", specID = { 259 }, offensive = true }, -- Kingsbane
  [200806] = { default = false, cooldown = 45, class = "ROGUE", specID = { 259 }, offensive = true }, -- Exsanguinate
  -- [206328] = { default = false, cooldown = 25, class = "ROGUE", specID = { 259 } }, -- Shiv

  -- Outlaw TBD

  [1776] = { default = false, cooldown = 10, class = "ROGUE", specID = { 260 } }, -- Gouge
  [2094] = { default = false, cooldown = 120, class = "ROGUE", specID = { 260, 261 } }, -- Blind
  [199743] = { parent = 2094, cooldown = 20 }, -- Parley
  [13750] = { default = false, cooldown = 150, class = "ROGUE", specID = { 260 } }, -- Adrenaline Rush
  [51690] = { default = false, cooldown = 120, class = "ROGUE", specID = { 260 } }, -- Killing Spree
  [185767] = { default = false, cooldown = 60, class = "ROGUE", specID = { 260 } }, -- Cannonball Barrage
  [195457] = { default = false, cooldown = 30, class = "ROGUE", specID = { 260 } }, -- Grappling Hook
  [198529] = { default = false, cooldown = 120, class = "ROGUE", specID = { 260 } }, -- Plunder Armor
  [199754] = { default = false, cooldown = 120, class = "ROGUE", specID = { 260 } }, -- Riposte
  [199804] = { default = false, cooldown = 20, class = "ROGUE", specID = { 260 } }, -- Between the Eyes
  [202665] = { default = false, cooldown = 90, class = "ROGUE", specID = { 260 } }, -- Curse of the Dreadblades
  [207777] = { default = false, cooldown = 45, class = "ROGUE", specID = { 260 } }, -- Dismantle

  -- Subtlety

  [121471] = { default = false, cooldown = 180, class = "ROGUE", specID = { 261 }, offensive = true }, -- Shadow Blades
  [185313] = { default = false, cooldown = 20, class = "ROGUE", specID = { 261 }, charges = 3, offensive = true }, -- Shadow Dance
  -- [207736] = { default = false, cooldown = 120, class = "ROGUE", specID = { 261 } }, -- Shadowy Duel
  -- [209782] = { default = false, cooldown = 60, class = "ROGUE", specID = { 261 } }, -- Goremaw's Bite
  -- [212182] = { default = false, cooldown = 180, class = "ROGUE", specID = { 261 } }, -- Smoke Bomb
  [213981] = { default = false, cooldown = 45, class = "ROGUE", specID = { 261 }, offensive = true }, -- Cold Blood

  -- Monk

  [109132] = { default = true, cooldown = 20, class = "MONK", charges = 2, blink = true }, -- Roll
  [115008] = { parent = 109132 }, -- Chi Torpedo
  [115078] = { default = true, cooldown = 15, class = "MONK", cc = true }, -- Paralysis
  [116841] = { default = true, cooldown = 30, class = "MONK", sprint = true }, -- Tiger's Lust
  [116844] = { default = true, cooldown = 45, class = "MONK", talent = {119381}, defensive = true, duration = 8}, -- Ring of Peace
  [119381] = { default = true, cooldown = 45, class = "MONK", talent = {116844}, cc = true }, -- Leg Sweep
  [119996] = { default = true, cooldown = 25, class = "MONK", blink = true }, -- Transcendence: Transfer
  -- [122278] = { default = false, cooldown = 120, class = "MONK", }, -- Dampen Harm
  -- [122783] = { default = false, cooldown = 120, class = "MONK" }, -- Diffuse Magic
  -- [123986] = { default = false, cooldown = 30, class = "MONK" }, -- Chi Burst
  -- [137648] = { default = false, cooldown = 120, class = "MONK" }, -- Nimble Brew

  -- Brewmaster TBD

  [115203] = { default = false, cooldown = 105, class = "MONK", specID = { 268 } }, -- Fortifying Brew
  [115399] = { default = false, cooldown = 90, class = "MONK", specID = { 268 } }, -- Black Ox Brew
  [116705] = { default = true, cooldown = 15, class = "MONK", specID = { 268, 269 }, interrupt = true }, -- Spear Hand Strike
  [132578] = { default = false, cooldown = 180, class = "MONK", specID = { 268 } }, -- Invoke Niuzao, the Black Ox
  [202162] = { default = false, cooldown = 45, class = "MONK", specID = { 268 } }, -- Guard
  [202272] = { default = false, cooldown = 45, class = "MONK", specID = { 268 } }, -- Incendiary Brew
  [202370] = { default = false, cooldown = 60, class = "MONK", specID = { 268 } }, -- Mighty Ox Kick


  -- Windwalker

  [101545] = { default = true, cooldown = 25, class = "MONK", specID = { 269 }, blink = true}, -- Flying Serpent Kick
  [113656] = { default = true, cooldown = 22, class = "MONK", specID = { 269 }, offensive = true }, -- Fists of Fury
  [115080] = { default = true, cooldown = 120, class = "MONK", specID = { 269 }, offensive = true }, -- Touch of Death
  [152173] = { parent = 137639, charges = 1 }, -- Serenity
  -- [115176] = { default = false, cooldown = 150, class = "MONK", specID = { 269 } }, -- Zen Meditation
  -- [201325] = { parent = 115176, 180 }, -- Zen Meditation (Windwalker)
  [115288] = { default = true, cooldown = 60, class = "MONK", specID = { 269 }, offensive = true }, -- Energizing Elixir
  [122470] = { default = true, cooldown = 90, class = "MONK", specID = { 269 }, defensive = true }, -- Touch of Karma
  -- [123904] = { default = false, cooldown = 180, class = "MONK", specID = { 269 } }, -- Invoke Xuen, the White Tiger
  [137639] = { default = true, cooldown = 90, class = "MONK", specID = { 269 }, charges = 2 , offensive = true }, -- Storm, Earth, and Fire
  -- [152175] = { default = false, cooldown = 24, class = "MONK", specID = { 269 } }, -- Whirling Dragon Punch
  [201318] = { default = true, cooldown = 90, class = "MONK", specID = { 269 }, defensive = true }, -- Fortifying Elixir

  -- Mistweaver

  [115310] = { default = false, cooldown = 180, class = "MONK", specID = { 270 }, defensive = true }, -- Revival
  -- [116680] = { default = false, cooldown = 30, class = "MONK", specID = { 270 } }, -- Thunder Focus Tea
  [116849] = { default = false, cooldown = 90, class = "MONK", specID = { 270 }, defensive = true }, -- Life Cocoon
  -- [197908] = { default = false, cooldown = 90, class = "MONK", specID = { 270 } }, -- Mana Tea
  [197945] = { default = false, cooldown = 20, class = "MONK", specID = { 270 }, charges = 2 , blink = true}, -- Mistwalk
  [198664] = { default = false, cooldown = 180, class = "MONK", specID = { 270 }, defensive = true }, -- Invoke Chi-Ji, the Red Crane
  -- [198898] = { default = false, cooldown = 30, class = "MONK", specID = { 270 } }, -- Song of Chi-Ji
  -- [216113] = { default = false, cooldown = 45, class = "MONK", specID = { 270 } }, -- Way of the Crane


  --Racials
  [208683] = { default = true, cooldown = 120, pvp_trinket = true, item = true }, -- Gladiator's Medallion
  [59752 ] = { default = true, cooldown = 120, pvp_trinket = true, race = "Human", }, -- Every Man
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
  [50613] = { parent = 28730},
  [80483] = { parent = 28730},
  [25046] = { parent = 28730},
  [69179] = { parent = 28730},
  [129597] = { parent = 28730},
  [155145] = { parent = 28730},
  [107079] = { parent = 28730},
  [20549] = { parent = 28730},
  [20589 ] = { default = true, cooldown = 60, cc = true, race = "Gnome" },
  [69070 ] = { default = true, cooldown = 120, sprint = true, race = "Goblin" },
  [7744 ] = { default = true, cooldown = 120, pvp_trinket = true, race = "Scourge" },
}
