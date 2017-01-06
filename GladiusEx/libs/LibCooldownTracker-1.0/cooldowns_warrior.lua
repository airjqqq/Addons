local data = {
	-- Warrior

	  [   100] = { default = true, cooldown = 17, class = "WARRIOR", charges = 2, blink = true }, -- Charge
	  [198758] = { parent = 100 }, -- Intercept
	  [  1719] = { default = true, cooldown = 45, class = "WARRIOR", offensive = 1, duration = 5 }, -- Battle Cry
	  [  6544] = { default = true, cooldown = 45, class = "WARRIOR", blink = true }, -- Heroic Leap
	  [  6552] = { default = true, cooldown = 15, class = "WARRIOR", interrupt = true}, -- Pummel
	  [ 18499] = { default = true, cooldown = 60, class = "WARRIOR", dispel = true, duration = 6, defensive = 0 }, -- Berserker Rage
	  [ 23920] = { default = true, cooldown = 25, class = "WARRIOR", defensive = 0.5, talent = {}, duration = 3, immune = "spell" }, -- Spell Reflection
	  [213915] = { parent = 23920, cooldown = 30 }, -- Mass Spell Reflection
	  [216890] = { parent = 23920 }, -- Spell Reflection (Arms, Fury)
	  [ 46968] = { default = true, cooldown = 40, class = "WARRIOR", talent = {107570}, cc = "stun", duration = 4 }, -- Shockwave
	  [107570] = { default = true, cooldown = 30, class = "WARRIOR", talent = {46968}, cc = true , aura = {132169}}, -- Storm Bolt
	  [107574] = { default = true, cooldown = 90, class = "WARRIOR", offensive = 0.2, duration = 20 }, -- Avatar

	  -- Arms

	  [  5246] = { default = true, cooldown = 90, class = "WARRIOR", specID = { 71, 72 }, cc = "disorient", duration = 8 }, -- Intimidating Shout
	  [ 97462] = { default = true, cooldown = 180, class = "WARRIOR", specID = { 71, 72 }, defensive = true, duration = 10, aura = {97462} }, -- Commanding Shout
	  [118038] = { default = true, cooldown = 180, class = "WARRIOR", specID = { 71 }, defensive = 0.6, duration = 8, immune = "evasion" }, -- Die by the Sword
	  -- [167105] = { default = true, cooldown = 45, class = "WARRIOR", specID = { 71 } }, -- Colossus Smash
	  [197690] = { default = true, cooldown = 10, class = "WARRIOR", specID = { 71 }, defensive = 0.2, cooldown_starts_on_aura_fade = true, duration = 0 }, -- Defensive Stance
	  [198817] = { default = true, cooldown = 45, class = "WARRIOR", specID = { 71 }, talent = {}, offensive = true }, -- Sharpen Blade
	  -- [209577] = { default = true, cooldown = 60, class = "WARRIOR", specID = { 71 }, offensive = true }, -- Warbreaker
	  [227847] = { default = true, cooldown = 90, class = "WARRIOR", specID = { 71, 72 }, offensive = 0, duration = 6, defensive = 0, immune = "cc" }, -- Bladestorm (Arms)
	  [ 46924] = { parent = 227847 }, -- Bladestorm (Fury)
	  -- [152277] = { parent = 227847, cooldown = 60 }, -- Ravager

	  -- Fury TBD

	  [118000] = { default = true, cooldown = 25, class = "WARRIOR", specID = { 72 } }, -- Dragon Roar
	  [184364] = { default = true, cooldown = 120, class = "WARRIOR", specID = { 72 }, defensive = 0.3, duration = 8 }, -- Enraged Regeneration
	  [205545] = { default = true, cooldown = 45, class = "WARRIOR", specID = { 72 } }, -- Odyn's Fury

	  -- Protection TBD

	  [   871] = { default = true, cooldown = 240, class = "WARRIOR", specID = { 73 }, duration = 8, defensive = 0.4 }, -- Shield Wall
	  [  1160] = { default = true, cooldown = 60, class = "WARRIOR", specID = { 73 } }, -- Demoralizing Shout
	  [ 12975] = { default = true, cooldown = 180, class = "WARRIOR", specID = { 73 }, defensive = 0.2, duration = 15 }, -- Last Stand
	  [198304] = { default = true, cooldown = 20, class = "WARRIOR", specID = { 73 }, charges = 2 }, -- Intercept
	  [206572] = { default = true, cooldown = 20, class = "WARRIOR", specID = { 73 } }, -- Dragon Charge
	  [213871] = { default = true, cooldown = 15, class = "WARRIOR", specID = { 73 }, defensive = 0.2, duration = 60 }, -- Bodyguard
	  [228920] = { default = true, cooldown = 60, class = "WARRIOR", specID = { 73 }, defensive = 0.15, duration = 12, talent = true }, -- Ravager

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
