local data = {
  -- Rogue

  -- [1725] = { default = true, cooldown = 30, class = "ROGUE" }, -- Distract
  [  1766] = { default = true, cooldown = 15, class = "ROGUE", interrupt = true }, -- Kick
  [  1856] = { default = true, cooldown = { default = 120, [259] = 100 }, class = "ROGUE", defensive = true, duration = 3 }, -- Vanish
  [  2983] = { default = true, cooldown = { default = 60, [259] = 51 }, class = "ROGUE", sprint = true, duration = 8 }, -- Sprint
  [ 31224] = { default = true, cooldown = { default = 90, [259] = 81 }, class = "ROGUE", defensive = 0.5, duration = 5, immune = "magic" }, -- Cloak of Shadows
  -- [57934] = { default = true, cooldown = 30, class = "ROGUE" }, -- Tricks of the Trade
  -- [137619] = { default = true, cooldown = 60, class = "ROGUE" }, -- Marked for Death
  -- [152150] = { default = true, cooldown = 20, class = "ROGUE" }, -- Death from Above
  [  1833] = { default = true, class = "ROGUE", cc = "stun", duration = 4 }, -- Cheap Shot
  [  6770] = { default = true, class = "ROGUE", cc = "incapacitate", duration = 8 }, -- Cheap Shot

  -- Assassination

  [   408] = { default = true, cooldown = 20, class = "ROGUE", specID = { 259, 261 }, cc= "stun", duration = 6 }, -- Kidney Shot
  [   703] = { default = true, cooldown = 15, class = "ROGUE", specID = { 259 }, cc= "silence", duration = 3, aura = {1330} }, -- Garrote
  [  5277] = { default = true, cooldown = 120, class = "ROGUE", specID = { 259, 261 }, defensive = 0.5, duration = 10, immune = "evasion" }, -- Evasion
  [ 36554] = { default = true, cooldown = 30, class = "ROGUE", specID = { 259, 261 }, blink = true }, -- Shadowstep
  [ 79140] = { default = true, cooldown = 90, class = "ROGUE", specID = { 259 }, offensive = 0.3, duration = 20, aura = {} }, -- Vendetta
  [192759] = { default = true, cooldown = 45, class = "ROGUE", specID = { 259 }, offensive = true }, -- Kingsbane
  [200806] = { default = true, cooldown = 45, class = "ROGUE", specID = { 259 }, offensive = true }, -- Exsanguinate
  -- [206328] = { default = true, cooldown = 25, class = "ROGUE", specID = { 259 } }, -- Shiv

  -- Outlaw TBD

  [  1776] = { default = true, cooldown = 10, class = "ROGUE", specID = { 260 }, cc = "incapacitate", duration = 4 }, -- Gouge
  [  2094] = { default = true, cooldown = 120, class = "ROGUE", specID = { 261 }, cc = "disorient", duration = 8 }, -- Blind
  [199743] = { parent = 2094, cooldown = 20, specID = { 260 } }, -- Parley
  [ 13750] = { default = true, cooldown = 150, class = "ROGUE", specID = { 260 }, offensive = 1, duration = 15 }, -- Adrenaline Rush
  [ 51690] = { default = true, cooldown = 120, class = "ROGUE", specID = { 260 }, offensive = 0.5, duration = 3 }, -- Killing Spree
  [185767] = { default = true, cooldown = 60, class = "ROGUE", specID = { 260 } }, -- Cannonball Barrage
  [195457] = { default = true, cooldown = 30, class = "ROGUE", specID = { 260 } }, -- Grappling Hook
  [198529] = { default = true, cooldown = 120, class = "ROGUE", specID = { 260 } }, -- Plunder Armor
  [199754] = { default = true, cooldown = 120, class = "ROGUE", specID = { 260 }, defensive = 0.5, duration = 10, immune = "evasion" }, -- Riposte
  [199804] = { default = true, cooldown = 20, class = "ROGUE", specID = { 260 }, cc = "stun", duration = 5 }, -- Between the Eyes
  [202665] = { default = true, cooldown = 90, class = "ROGUE", specID = { 260 } }, -- Curse of the Dreadblades
  [207777] = { default = true, cooldown = 45, class = "ROGUE", specID = { 260 } }, -- Dismantle

  -- Subtlety

  [121471] = { default = true, cooldown = 180, class = "ROGUE", specID = { 261 }, offensive = 0.5, duration = 25 }, -- Shadow Blades
  [185313] = { default = true, cooldown = 20, class = "ROGUE", specID = { 261 }, charges = 3, offensive = 0.2, duration = 8 }, -- Shadow Dance
  [207736] = { default = true, cooldown = 120, class = "ROGUE", specID = { 261 }, talent = {}, offensive = 0.2, duration = 6 }, -- Shadowy Duel
  -- [209782] = { default = true, cooldown = 60, class = "ROGUE", specID = { 261 } }, -- Goremaw's Bite
  -- [212182] = { default = true, cooldown = 180, class = "ROGUE", specID = { 261 } }, -- Smoke Bomb
  [213981] = { default = true, cooldown = 45, class = "ROGUE", specID = { 261 }, offensive = true }, -- Cold Blood
  [212183] = { default = true, cooldown = 180, class = "ROGUE", specID = { 261 }, important = true, duration = 5 }, -- Cold Blood


}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
