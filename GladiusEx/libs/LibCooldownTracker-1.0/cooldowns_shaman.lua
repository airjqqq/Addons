local data = {
	-- Shaman

  -- [2825] = { default = true, cooldown = 45, class = "SHAMAN" }, -- Bloodlust
  -- [32182] = { parent = 2825 }, -- Heroism
  -- [20608] = { default = true, cooldown = 1800, class = "SHAMAN" }, -- Reincarnation
  [ 51514] = { default = true, cooldown = 30, class = "SHAMAN", cc = "incapacitate", duration = 8, cast = 1.7 }, -- Hex
  [210873] = { parent = 51514 }, -- Hex (Compy)
  [211004] = { parent = 51514 }, -- Hex (Spider)
  [211010] = { parent = 51514 }, -- Hex (Snake)
  [211015] = { parent = 51514 }, -- Hex (Cockroach)
  [ 57994] = { default = true, cooldown = 12, class = "SHAMAN", interrupt = true }, -- Wind Shear
  [108271] = { default = true, cooldown = 90, class = "SHAMAN", defensive = 0.4, duration = 8 }, -- Astral Shift
  [210918] = { default = true, cooldown = 45, class = "SHAMAN", defensive = 0.5, duration = 15, immune = "melee", talent = {108271} }, -- Ethereal Form
  [114049] = { default = true, cooldown = 180, class = "SHAMAN", offensive = 1, talent = {}, duration = 15 }, -- Ascendance
  [114050] = { parent = 114049 }, -- Ascendance (Elemental)
  [114051] = { parent = 114049 }, -- Ascendance (Enhancement)
  [114052] = { parent = 114049 }, -- Ascendance (Restoration)
  [192058] = { default = true, cooldown = 45, class = "SHAMAN", cc = "stun", talent = {196932,51485}, aura = {118905}, duration = 5 }, -- Lightning Surge Totem
  [ 51485] = { default = true, cooldown = 30, class = "SHAMAN", cc = "root", talent = {196932,192058}, duration = 5 }, -- Earthgrab Totem
  [196932] = { default = true, cooldown = 30, class = "SHAMAN",cc = "incapacitate", duration = 5, talent = {192058,51485,51514,211004,211010,210873,211015}, cooldown = 30 }, -- Voodoo Totem
  -- [192077] = { default = true, cooldown = 120, class = "SHAMAN" }, -- Wind Rush Totem
  [204330] = { default = true, cooldown = 45, class = "SHAMAN", talent = {204331,204332}, offensive = true }, -- Skyfury Totem
  [204331] = { default = true, cooldown = 45, class = "SHAMAN", talent = {204330,204332}, offensive = true }, -- Counterstrike Totem
  [204332] = { default = true, cooldown = 30, class = "SHAMAN", talent = {204331,204330}, offensive = true }, -- Windfury Totem

  -- Elemental

  [ 51490] = { default = true, cooldown = 45, class = "SHAMAN", specID = { 262 }, defensive = true }, -- Thunderstorm
  [108281] = { default = true, cooldown = 120, class = "SHAMAN", specID = { 262, 264 }, talent = {}, defensive = 0.1, duration = 10 }, -- Ancestral Guidance
  [ 16166] = { default = true, cooldown = 120, class = "SHAMAN", specID = { 262 }, offensive = 0.2, duration = 20 }, -- Elemental Mastery
  [192063] = { default = true, cooldown = 15, class = "SHAMAN", specID = { 262, 264 },blink = true }, -- Gust of Wind
  -- [192222] = { default = true, cooldown = 60, class = "SHAMAN", specID = { 262 } }, -- Liquid Magma Totem
  [198067] = { default = true, cooldown = 300, class = "SHAMAN", specID = { 262 }, offensive = true }, -- Fire Elemental
  [192249] = { parent = 198067 }, -- Storm Elemental
  -- [198103] = { default = true, cooldown = 120, class = "SHAMAN", specID = { 262 } }, -- Earth Elemental
  [204437] = { default = true, cooldown = 30, class = "SHAMAN", specID = { 262 }, talent = {} }, -- Lightning Lasso
  [205495] = { default = true, cooldown = 60, class = "SHAMAN", specID = { 262 }, offensive = 0.5, cast = 1.5 }, -- Stormkeeper
  [210714] = { default = true, cooldown = 30, class = "SHAMAN", specID = { 262 }, offensive = 0.5, cast = 2 }, -- Icefury
  [ 51886] = { default = true, cooldown = 8, class = "SHAMAN", specID = {262,263}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption

  -- Enhancement

  [ 58875] = { default = true, cooldown = 60, class = "SHAMAN", specID = { 263 }, sprint = true, duration = 8 }, -- Spirit Walk
  [196884] = { default = true, cooldown = 30, class = "SHAMAN", specID = { 263 }, blink = true }, -- Feral Lunge
  [197214] = { default = true, cooldown = 40, class = "SHAMAN", specID = { 263 }, cc = "stun", duration = 2 }, -- Sundering
  -- [201898] = { default = true, cooldown = 45, class = "SHAMAN", specID = { 263 } }, -- Windsong
  [204366] = { default = true, cooldown = 45, class = "SHAMAN", specID = { 263 }, offensive = 0.2, duration = 10, talent = {} }, -- Thundercharge
  [204945] = { default = true, cooldown = 60, class = "SHAMAN", specID = { 263 }, offensive = 0.5, duration = 6 }, -- Doom Winds
  [  2825] = { default = true, cooldown = 45, class = "SHAMAN", specID = { 263 }, offensive = 0.3, duration = 10, dispellable = true }, -- Bloodlust
  [ 32182] = { parent = 2825 }, -- Heroism

  -- Restoration

  -- [5394] = { default = true, cooldown = 30, class = "SHAMAN", specID = { 264 }, charges = 30 }, -- Healing Stream Totem
  [ 79206] = { default = true, cooldown = 120, class = "SHAMAN", specID = { 264 }, dispellable = true, sprint = true, duration=15 }, -- Spiritwalker's Grace
  [ 98008] = { default = true, cooldown = 180, class = "SHAMAN", specID = { 264 }, defensive = true }, -- Spirit Link Totem
  [204293] = { default = true, cooldown = 30, class = "SHAMAN", specID = { 264 }, defensive = 0.5, talent = {98008}, duration = 20 }, -- Spirit Link
  [108280] = { default = true, cooldown = 180, class = "SHAMAN", specID = { 264 }, defensive = true }, -- Healing Tide Totem
  [157153] = { default = true, cooldown = 30, class = "SHAMAN", specID = { 264 }, defensive = true }, -- Cloudburst Totem
  [198838] = { default = true, cooldown = 60, class = "SHAMAN", specID = { 264 }, defensive = true, talent = {207399} }, -- Earthen Shield Totem
  [204336] = { default = true, cooldown = 30, class = "SHAMAN", specID = { 264 }, defensive = true }, -- Grounding Totem
  [207399] = { default = true, cooldown = 300, class = "SHAMAN", specID = { 264 }, defensive = true, talent = {198838} }, -- Ancestral Protection Totem
  [ 77130] = { default = true, cooldown = 8, class = "SHAMAN", specID = {264}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption
  [ 77472] = { default = true, class = "SHAMAN", specID = {264}, cast = 2.5, heal = true},  --Healing Wave (Shaman)
  [207778] = { default = true, cooldown = 45, class = "SHAMAN", specID = { 264 }, heal = true, cast = 2 }, -- Gift of the Queen

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
