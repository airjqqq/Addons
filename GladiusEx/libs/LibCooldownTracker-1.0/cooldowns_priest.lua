local data = {
	-- Priest

  -- [586] = { default = true, cooldown = 30, class = "PRIEST" }, -- Fade
  -- [213602] = { parent = 586 }, -- Greater Fade
  [ 32375] = { default = true, cooldown = 15, class = "PRIEST", cast = 1.5, offensive = true }, -- Mass Dispel
  [   605] = { default = true, class = "PRIEST", cc = "disorient", duration = 8, cast = 1.8 }, -- Mind Control

  -- Discipline

  [  8122] = { default = true, cooldown = 30, class = "PRIEST", specID = { 256, 258 }, cc = "disorient", duration = 8, replaces = {205369} }, -- Psychic Scream
  [ 10060] = { default = true, cooldown = 120, class = "PRIEST", specID = { 256, 258 }, offensive = 0.3, duration = 20 }, -- Power Infusion
  [ 33206] = { default = true, cooldown = 210, class = "PRIEST", specID = { 256 }, defensive = 0.4, duration = 8 }, -- Pain Suppression
  [ 34433] = { default = true, cooldown = 180, class = "PRIEST", specID = { 256, 258 }, offensive = true, duration = 12 }, -- Shadowfiend
  [123040] = { parent = 34433, cooldown = 60 }, -- Mindbender (Discipline)
  [200174] = { parent = 34433, cooldown = 60 }, -- Mindbender (Shadow)
  [ 47536] = { default = true, cooldown = 120, class = "PRIEST", specID = { 256 }, offensive = 0.4, duration = 8, dispellable = true }, -- Rapture
  [ 62618] = { default = true, cooldown = 180, class = "PRIEST", specID = { 256 }, defensive = true, duration = 10}, -- Power Word: Barrier
  [ 73325] = { default = true, cooldown = 90, class = "PRIEST", specID = { 256, 257 }, blink = true }, -- Leap of Faith
  [197862] = { default = true, cooldown = 60, class = "PRIEST", specID = { 256 }, offensive = 0.3, duration = 15}, -- Archangel
  [197871] = { default = true, cooldown = 60, class = "PRIEST", specID = { 258 }, offensive = 0.15, duration = 8 }, -- Dark Archangel
  [204263] = { default = true, cooldown = 60, class = "PRIEST", specID = { 256, 257 }, cc = true, talent = {} }, -- Shining Force
  [207946] = { default = true, cooldown = 90, class = "PRIEST", specID = { 256 }, offensive = true, cast = 2.5 }, -- Light's Wrath
  -- [208065] = { default = true, cooldown = 45, class = "PRIEST", specID = { 256 }, charges = 2 }, -- Light of T'uure
  [209780] = { default = true, cooldown = 12, class = "PRIEST", specID = { 256}, dispel = true}, -- Premonition
  [194509] = { default = true, class = "PRIEST", specID = { 256}, heal = true, cast = 2.5}, -- Power Word: Radiance
  [204065] = { default = true, class = "PRIEST", specID = { 256}, heal = true, cast = 1.5}, -- Shadow Covenant
  [   527] = { default = true, cooldown = 8, class = "PRIEST", specID = {256,257}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption

  -- Holy FIXME

  [ 47788] = { default = true, cooldown = 96, class = "PRIEST", specID = { 257 }, defensive = 0.3, duration=10 }, -- Guardian Spirit
  [ 64843] = { default = true, cooldown = 180, class = "PRIEST", specID = { 257 }, offensive = true, duration = 8 }, -- Divine Hymn
  [ 64901] = { default = true, cooldown = 360, class = "PRIEST", specID = { 257 } }, -- Symbol of Hope
  [ 19236] = { default = true, cooldown = 90, class = "PRIEST", specID = { 257 } }, -- Desperate Prayer
  [196762] = { default = true, cooldown = 30, class = "PRIEST", specID = { 257 }, offensive = 1, immune = "interrupt", duration = 5 }, -- Inner Focus
  [197268] = { default = true, cooldown = 60, class = "PRIEST", specID = { 257 }, defensive = 1, duration = 6 }, -- Ray of Hope
  [200183] = { default = true, cooldown = 180, class = "PRIEST", specID = { 257 }, offensive = 0.2, duration = 30 }, -- Apotheosis
  [213610] = { default = true, cooldown = 45, class = "PRIEST", specID = { 257 }, defensive = 0, immune = "cc", duration = 0, cooldown_starts_on_aura_fade = true, dispellable = true }, -- Holy Ward
  [215769] = { default = true, cooldown = 300, class = "PRIEST", specID = { 257 } , defensive = 1, duration = 10}, -- Spirit of Redemption
  [  2060] = { default = true, class = "PRIEST", specID = { 257 }, cast = 2.5, heal = true }, -- Heal
	[200196] = { default = true, cooldown = 60, class = "PRIEST", specID = { 257 }, cc = "incapacitate", duration = 5 }, -- Holy Word: Chastise
	[200200] = { default = true, cooldown = 60, class = "PRIEST", specID = { 257 }, cc = "stun", duration = 5, talent = {200196} }, -- Holy Word: Chastise (Stun)
	[221660] = { default = true, class = "PRIEST", specID = { 257 }, defensive = 0, immune = "shotinterrupt"}, -- Holy Word: Chastise (Stun)

  -- Shadow

  [ 15286] = { default = true, cooldown = 180, class = "PRIEST", specID = { 258 }, defensive = true, duration = 15}, -- Vampiric Embrace
  [ 15487] = { default = true, cooldown = 45, class = "PRIEST", specID = { 258 }, cc = "silence", duration = 5 }, -- Silence
  [199683] = { default = true, class = "PRIEST", specID = { 258 }, cc = "silence", duration = 3 }, -- Last Word
  [ 32379] = { default = true, cooldown = 9, class = "PRIEST", specID = { 258 }, charges = 2 }, -- Shadow Word: Death
  [ 47585] = { default = true, cooldown = 90, class = "PRIEST", specID = { 258 }, defensive = 0.6, duration = 6 }, -- Dispersion
  [108968] = { default = true, cooldown = 300, class = "PRIEST", specID = { 258 }, defensive = true, talent = {211522} }, -- Void Shift
  -- [193223] = { default = true, cooldown = 600, class = "PRIEST", specID = { 258 } }, -- Surrender to Madness
  [205065] = { default = true, cooldown = 60, class = "PRIEST", specID = { 258 }, offensive = true, cast = 4 }, -- Void Torrent
  [205369] = { default = true, cooldown = 30, class = "PRIEST", specID = { 258 }, talent = {8122}, cc = "stun", duration = 2 }, -- Mind Bomb
  [226943] = { default = true, class = "PRIEST", specID = { 258 }, cc = "stun", duration = 4 }, -- Mind Bomb (Stun)
  [211522] = { default = true, cooldown = 45, class = "PRIEST", specID = { 258 }, talent = {108968}, offensive = true}, -- Psyfiend
  [213634] = { default = true, cooldown = 8, class = "PRIEST", specID = {258}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption
  [ 87204] = { default = true, class = "PRIEST", specID = {258}, cc = "disorient", duration = 3},  -- Sin and Punishment
  [194249] = { default = true, class = "PRIEST", specID = {258}, offensive = 0.3, duration = 20},  -- Voidform

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
