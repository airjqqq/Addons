local data = {
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
  [152173] = { default = true, cooldown = 90, class = "MONK", specID = { 269 }, offensive = true}, -- Serenity
  -- [115176] = { default = false, cooldown = 150, class = "MONK", specID = { 269 } }, -- Zen Meditation
  -- [201325] = { parent = 115176, 180 }, -- Zen Meditation (Windwalker)
  [115288] = { default = true, cooldown = 60, class = "MONK", specID = { 269 }, offensive = true }, -- Energizing Elixir
  [122470] = { default = true, cooldown = 90, class = "MONK", specID = { 269 }, defensive = true }, -- Touch of Karma
  -- [123904] = { default = false, cooldown = 180, class = "MONK", specID = { 269 } }, -- Invoke Xuen, the White Tiger
  [137639] = { default = true, cooldown = 90, class = "MONK", specID = { 269 }, charges = 2 , offensive = true, talent={152173} }, -- Storm, Earth, and Fire
  -- [152175] = { default = false, cooldown = 24, class = "MONK", specID = { 269 } }, -- Whirling Dragon Punch
  [201318] = { default = true, cooldown = 90, class = "MONK", specID = { 269 }, defensive = true }, -- Fortifying Elixir
  [218164] = { default = true, cooldown = 8, class = "MONK", specID = {268,269}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption

  -- Mistweaver

  [115310] = { default = false, cooldown = 180, class = "MONK", specID = { 270 }, defensive = true }, -- Revival
  -- [116680] = { default = false, cooldown = 30, class = "MONK", specID = { 270 } }, -- Thunder Focus Tea
  [116849] = { default = false, cooldown = 90, class = "MONK", specID = { 270 }, defensive = 0.4, duration = 12 }, -- Life Cocoon
  -- [197908] = { default = false, cooldown = 90, class = "MONK", specID = { 270 } }, -- Mana Tea
  [197945] = { default = false, cooldown = 20, class = "MONK", specID = { 270 }, charges = 2 , blink = true}, -- Mistwalk
  [198664] = { default = false, cooldown = 180, class = "MONK", specID = { 270 }, defensive = true }, -- Invoke Chi-Ji, the Red Crane
  -- [198898] = { default = false, cooldown = 30, class = "MONK", specID = { 270 } }, -- Song of Chi-Ji
  -- [216113] = { default = false, cooldown = 45, class = "MONK", specID = { 270 } }, -- Way of the Crane
  [115450] = { default = true, cooldown = 8, class = "MONK", specID = {270}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption
  [116670] = { default = true, class = "MONK", specID = {270}, heal = true, cast = 1.5 },  -- Vivify
  [205406] = { default = true, class = "MONK", specID = {270}, heal = true, cast = 2 },  -- Vivify


}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
