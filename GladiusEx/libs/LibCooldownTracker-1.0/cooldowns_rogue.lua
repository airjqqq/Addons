local data = {
  -- Rogue

  -- [1725] = { default = false, cooldown = 30, class = "ROGUE" }, -- Distract
  [  1766] = { default = true, cooldown = 15, class = "ROGUE", interrupt = true }, -- Kick
  [  1856] = { default = false, cooldown = { default = 120, [259] = 100 }, class = "ROGUE", defensive = true, duration = 3 }, -- Vanish
  [  2983] = { default = false, cooldown = { default = 60, [259] = 51 }, class = "ROGUE", sprint = true, duration = 8 }, -- Sprint
  [ 31224] = { default = false, cooldown = { default = 90, [259] = 81 }, class = "ROGUE", defensive = 0.5, duration = 5 }, -- Cloak of Shadows
  -- [57934] = { default = false, cooldown = 30, class = "ROGUE" }, -- Tricks of the Trade
  -- [137619] = { default = false, cooldown = 60, class = "ROGUE" }, -- Marked for Death
  -- [152150] = { default = false, cooldown = 20, class = "ROGUE" }, -- Death from Above

  -- Assassination

  [   408] = { default = false, cooldown = 20, class = "ROGUE", specID = { 259, 261 }, cc= true }, -- Kidney Shot
  [   703] = { default = false, cooldown = 15, class = "ROGUE", specID = { 259 }, cc= true }, -- Garrote
  [  5277] = { default = false, cooldown = 120, class = "ROGUE", specID = { 259, 261 }, defensive = 0.5, duration = 10 }, -- Evasion
  [ 36554] = { default = false, cooldown = 30, class = "ROGUE", specID = { 259, 261 }, blink = true }, -- Shadowstep
  [ 79140] = { default = false, cooldown = 90, class = "ROGUE", specID = { 259 }, offensive = true }, -- Vendetta
  [192759] = { default = false, cooldown = 45, class = "ROGUE", specID = { 259 }, offensive = true }, -- Kingsbane
  [200806] = { default = false, cooldown = 45, class = "ROGUE", specID = { 259 }, offensive = true }, -- Exsanguinate
  -- [206328] = { default = false, cooldown = 25, class = "ROGUE", specID = { 259 } }, -- Shiv

  -- Outlaw TBD

  [  1776] = { default = false, cooldown = 10, class = "ROGUE", specID = { 260 } }, -- Gouge
  [  2094] = { default = false, cooldown = 120, class = "ROGUE", specID = { 260, 261 } }, -- Blind
  [199743] = { parent = 2094, cooldown = 20 }, -- Parley
  [ 13750] = { default = false, cooldown = 150, class = "ROGUE", specID = { 260 } }, -- Adrenaline Rush
  [ 51690] = { default = false, cooldown = 120, class = "ROGUE", specID = { 260 } }, -- Killing Spree
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


}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
