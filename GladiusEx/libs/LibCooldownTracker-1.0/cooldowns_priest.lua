local data = {
	-- Priest

  -- [586] = { default = false, cooldown = 30, class = "PRIEST" }, -- Fade
  -- [213602] = { parent = 586 }, -- Greater Fade
  [ 32375] = { default = true, cooldown = 15, class = "PRIEST", cast = 1.5, offensive = true }, -- Mass Dispel
  [   605] = { default = true, class = "PRIEST", cc = true, cast = 1.8 }, -- Mind Control

  -- Discipline

  [  8122] = { default = true, cooldown = 30, class = "PRIEST", specID = { 256, 258 }, cc = true, talent = {205369} }, -- Psychic Scream
  [ 10060] = { default = true, cooldown = 120, class = "PRIEST", specID = { 256, 258 }, offensive = 0.3, duration = 20 }, -- Power Infusion
  [ 33206] = { default = true, cooldown = 210, class = "PRIEST", specID = { 256 }, defensive = 0.4, duration = 8 }, -- Pain Suppression
  [ 34433] = { default = false, cooldown = 180, class = "PRIEST", specID = { 256, 258 }, offensive = true, duration = 12 }, -- Shadowfiend
  [123040] = { parent = 34433, cooldown = 60 }, -- Mindbender (Discipline)
  [200174] = { parent = 34433, cooldown = 60 }, -- Mindbender (Shadow)
  [ 47536] = { default = true, cooldown = 120, class = "PRIEST", specID = { 256 }, offensive = 0.4, duration = 8, dispelable = true }, -- Rapture
  [ 62618] = { default = true, cooldown = 180, class = "PRIEST", specID = { 256 }, defensive = true, duration = 10}, -- Power Word: Barrier
  [ 73325] = { default = true, cooldown = 90, class = "PRIEST", specID = { 256, 257 }, blink = true }, -- Leap of Faith
  [197862] = { default = true, cooldown = 60, class = "PRIEST", specID = { 256 }, offensive = true, duration = 15}, -- Archangel
  [204263] = { default = false, cooldown = 60, class = "PRIEST", specID = { 256, 257 }, cc = true, talent = {} }, -- Shining Force
  [207946] = { default = true, cooldown = 90, class = "PRIEST", specID = { 256 }, offensive = true, cast = 2.5 }, -- Light's Wrath
  -- [208065] = { default = false, cooldown = 45, class = "PRIEST", specID = { 256 }, charges = 2 }, -- Light of T'uure
  [209780] = { default = true, cooldown = 12, class = "PRIEST", specID = { 256}, dispel = true}, -- Premonition
  [194509] = { default = true, class = "PRIEST", specID = { 256}, heal = true, cast = 2.5}, -- Power Word: Radiance
  [204065] = { default = true, class = "PRIEST", specID = { 256}, heal = true, cast = 1.5}, -- Shadow Covenant
  [   527] = { default = true, cooldown = 8, class = "PRIEST", specID = {256,257}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption

  -- Holy FIXME

  [ 47788] = { default = false, cooldown = 96, class = "PRIEST", specID = { 257 }, defensive = 0.3, duration=10 }, -- Guardian Spirit
  [ 64843] = { default = false, cooldown = 180, class = "PRIEST", specID = { 257 } }, -- Divine Hymn
  [ 64901] = { default = false, cooldown = 360, class = "PRIEST", specID = { 257 } }, -- Symbol of Hope
  [ 19236] = { default = false, cooldown = 90, class = "PRIEST", specID = { 257 } }, -- Desperate Prayer
  [196762] = { default = false, cooldown = 30, class = "PRIEST", specID = { 257 } }, -- Inner Focus
  [197268] = { default = false, cooldown = 60, class = "PRIEST", specID = { 257 } }, -- Ray of Hope
  [200183] = { default = false, cooldown = 180, class = "PRIEST", specID = { 257 } }, -- Apotheosis
  [213610] = { default = false, cooldown = 45, class = "PRIEST", specID = { 257 } }, -- Holy Ward
  [215769] = { default = false, cooldown = 300, class = "PRIEST", specID = { 257 } }, -- Spirit of Redemption
  [  2060] = { default = false, class = "PRIEST", specID = { 257 }, cast = 2.5, heal = true }, -- Heal

  -- Shadow

  [ 15286] = { default = true, cooldown = 180, class = "PRIEST", specID = { 258 }, defensive = true, duration = 15}, -- Vampiric Embrace
  [ 15487] = { default = true, cooldown = 45, class = "PRIEST", specID = { 258 }, cc = true }, -- Silence
  [ 32379] = { default = false, cooldown = 9, class = "PRIEST", specID = { 258 }, charges = 2 }, -- Shadow Word: Death
  [ 47585] = { default = true, cooldown = 90, class = "PRIEST", specID = { 258 }, defensive = 0.6, duration = 6 }, -- Dispersion
  [108968] = { default = false, cooldown = 300, class = "PRIEST", specID = { 258 }, defensive = true, talent = {211522} }, -- Void Shift
  -- [193223] = { default = false, cooldown = 600, class = "PRIEST", specID = { 258 } }, -- Surrender to Madness
  -- [197871] = { default = false, cooldown = 60, class = "PRIEST", specID = { 258 } }, -- Dark Archangel
  [205065] = { default = false, cooldown = 60, class = "PRIEST", specID = { 258 }, offensive = true, cast = 4 }, -- Void Torrent
  [205369] = { default = true, cooldown = 30, class = "PRIEST", specID = { 258 }, talent = {8122}, cc = true }, -- Mind Bomb
  [211522] = { default = false, cooldown = 45, class = "PRIEST", specID = { 258 }, talent = {108968}, offensive = true}, -- Psyfiend
  [213634] = { default = true, cooldown = 8, class = "PRIEST", specID = {258}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
