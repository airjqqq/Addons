local data = {
	-- Shaman

  -- [2825] = { default = false, cooldown = 45, class = "SHAMAN" }, -- Bloodlust
  -- [32182] = { parent = 2825 }, -- Heroism
  -- [20608] = { default = false, cooldown = 1800, class = "SHAMAN" }, -- Reincarnation
  [ 51514] = { default = true, cooldown = 30, class = "SHAMAN", cc = "incapacitate", duration = 8, cast = 1.7 }, -- Hex
  [210873] = { parent = 51514, talent = {51514} }, -- Hex (Compy)
  [211004] = { parent = 51514, talent = {51514} }, -- Hex (Spider)
  [211010] = { parent = 51514, talent = {51514} }, -- Hex (Snake)
  [211015] = { parent = 51514, talent = {51514} }, -- Hex (Cockroach)
  [ 57994] = { default = true, cooldown = 12, class = "SHAMAN", interrupt = true }, -- Wind Shear
  [108271] = { default = true, cooldown = 90, class = "SHAMAN", defensive = 0.4, duration = 8 }, -- Astral Shift
  [210918] = { default = false, cooldown = 45, class = "SHAMAN", defensive = 0.5, duration = 15, immune = "melee", talent = {108271} }, -- Ethereal Form
  [114049] = { default = true, cooldown = 180, class = "SHAMAN", offensive = 1, talent = {}, duration = 15 }, -- Ascendance
  [114050] = { default = false, cooldown = 180, class = "SHAMAN", offensive = 1, talent = {}, duration = 15 }, -- Ascendance
  [114051] = { default = false, cooldown = 180, class = "SHAMAN", offensive = 1, talent = {}, duration = 15 }, -- Ascendance
  [192058] = { default = true, cooldown = 45, class = "SHAMAN", cc = "stun", talent = {196932,51485}, aura = {118905}, duration = 5 }, -- Lightning Surge Totem
  [ 51485] = { default = false, cooldown = 30, class = "SHAMAN", cc = "root", replaces = {196932,192058}, duration = 5, aura = {64695} }, -- Earthgrab Totem
  [196932] = { default = false, cooldown = 30, class = "SHAMAN",cc = "incapacitate", duration = 5, talent = {192058,51485,51514,211004,211010,210873,211015}, cooldown = 30 }, -- Voodoo Totem
  -- [192077] = { default = false, cooldown = 120, class = "SHAMAN" }, -- Wind Rush Totem
  [204330] = { default = true, cooldown = 45, class = "SHAMAN", talent = {204331,204332}, offensive = 0.3 }, -- Skyfury Totem
  -- [204331] = { default = false, cooldown = 45, class = "SHAMAN", replaces = {204330,204332}, defensive = true }, -- Counterstrike Totem
  [204331] = { default = false, cooldown = 45, class = "SHAMAN", replaces = {204330,204332}, defensive = true }, -- Counterstrike Totem
  [204332] = { default = false, cooldown = 30, class = "SHAMAN", talent = {204331,204330}, offensive = true }, -- Windfury Totem

  -- Elemental

  [ 51490] = { default = true, cooldown = 45, class = "SHAMAN", specID = { 262 }, defensive = true }, -- Thunderstorm
  [108281] = { default = false, cooldown = 120, class = "SHAMAN", specID = { 262, 264 }, talent = {}, defensive = 0.1, duration = 10 }, -- Ancestral Guidance
  [ 16166] = { default = false, cooldown = 120, class = "SHAMAN", specID = { 262 }, offensive = 0.2, duration = 20, talent = {} }, -- Elemental Mastery
  [192063] = { default = false, cooldown = 15, class = "SHAMAN", specID = { 262, 264 },blink = true }, -- Gust of Wind
  -- [192222] = { default = false, cooldown = 60, class = "SHAMAN", specID = { 262 } }, -- Liquid Magma Totem
  [198067] = { default = false, cooldown = 300, class = "SHAMAN", specID = { 262 }, offensive = 0.1, duration = 60 }, -- Fire Elemental
  [192249] = { parent = 198067, talent = {198067} }, -- Storm Elemental
  -- [198103] = { default = false, cooldown = 120, class = "SHAMAN", specID = { 262 } }, -- Earth Elemental
  [204437] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 262 }, talent = {} }, -- Lightning Lasso
  [205495] = { default = true, cooldown = 60, class = "SHAMAN", specID = { 262 }, offensive = 0.5, cast = 1.5, duration = 15 }, -- Stormkeeper
  [210714] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 262 }, offensive = 0.5, cast = 2, duration = 15 }, -- Icefury
  [ 51886] = { default = false, cooldown = 8, class = "SHAMAN", specID = {262,263}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption
  [ 77505] = { default = false, class = "SHAMAN", specID = {262}, cc = "stun", duration = 1.5 },  -- Earthquake

  -- Enhancement

  [ 58875] = { default = false, cooldown = 60, class = "SHAMAN", specID = { 263 }, sprint = true, duration = 8 }, -- Spirit Walk
  [196884] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 263 }, blink = true }, -- Feral Lunge
  [197214] = { default = false, cooldown = 40, class = "SHAMAN", specID = { 263 }, cc = "stun", duration = 2 }, -- Sundering
  -- [201898] = { default = false, cooldown = 45, class = "SHAMAN", specID = { 263 } }, -- Windsong
  [204366] = { default = false, cooldown = 45, class = "SHAMAN", specID = { 263 }, offensive = 0.2, duration = 10, talent = {} }, -- Thundercharge
  [204945] = { default = true, cooldown = 60, class = "SHAMAN", specID = { 263 }, offensive = 0.5, duration = 6 }, -- Doom Winds
  [  2825] = { default = true, cooldown = 60, class = "SHAMAN", specID = { 263 }, offensive = 0.3, duration = 10, dispellable = true }, -- Bloodlust
  [ 32182] = { parent = 2825, talent = {2825} }, -- Heroism

  -- Restoration

  -- [5394] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 264 }, charges = 30 }, -- Healing Stream Totem
  [ 79206] = { default = false, cooldown = 120, class = "SHAMAN", specID = { 264 }, dispellable = true, sprint = true, duration=15 }, -- Spiritwalker's Grace
  [ 98008] = { default = true, cooldown = 180, class = "SHAMAN", specID = { 264 }, defensive = 0.5, duration = 6 }, -- Spirit Link Totem
  [204293] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 264 }, defensive = 0.5, talent = {98008}, duration = 20 }, -- Spirit Link
  [108280] = { default = false, cooldown = 180, class = "SHAMAN", specID = { 264 }, offensive = 0.2, duration = 6 }, -- Healing Tide Totem
  [157153] = { default = false, cooldown = 30, class = "SHAMAN", specID = { 264 }, defensive = 0.1, talent = {} }, -- Cloudburst Totem
  [198838] = { default = true, cooldown = 60, class = "SHAMAN", specID = { 264 }, defensive = 0.4, duration = 15, replaces = {207399} }, -- Earthen Shield Totem
  [207399] = { default = false, cooldown = 300, class = "SHAMAN", specID = { 264 }, defensive = 1, duration = 30, talent = {198838} }, -- Ancestral Protection Totem
  [ 77130] = { default = true, cooldown = 8, class = "SHAMAN", specID = {264}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption
  [ 77472] = { default = false, class = "SHAMAN", specID = {264}, cast = 2.5, heal = true},  --Healing Wave (Shaman)
  [207778] = { default = false, cooldown = 45, class = "SHAMAN", specID = { 264 }, heal = true, cast = 2 }, -- Gift of the Queen
  [204336] = { default = true, cooldown = 30, class = "SHAMAN", specID = { 264 }, immune = "spell", aura ={8178}, duration = 3 }, -- Grounding Totem Effect
  [114052] = { default = false, cooldown = 180, class = "SHAMAN", specID = { 264 }, offensive = 1, duration = 15 }, -- Ascendance (Restoration)

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
