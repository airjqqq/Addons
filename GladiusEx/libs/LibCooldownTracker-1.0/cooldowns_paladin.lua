local data = {

	  -- Paladin

	  -- [633] = { default = true, cooldown = 600, class = "PALADIN" }, -- Lay on Hands
	  [   642] = { default = true, cooldown = 300, class = "PALADIN", defensive = 1, duration = 8 }, -- Divine Shield
	  [   853] = { default = true, cooldown = 60, class = "PALADIN", cc= true }, -- Hammer of Justice
	  [  1022] = { default = true, cooldown = 300, class = "PALADIN", charges = 2, defensive = 0.5, dispellable = true, duration = 10 }, -- Blessing of Protection
	  [  1044] = { default = true, cooldown = 25, class = "PALADIN", charges = 2, sprint = true, dispellable = true, duration = 8 }, -- Blessing of Freedom
	  [ 20066] = { default = true, cooldown = 15, class = "PALADIN", cc=true, talent = {115750}, cast = 1.7 }, -- Repentance
	  [115750] = { default = true, cooldown = 90, class = "PALADIN", cc = true, talent = {20066}, aura = {105421} }, -- Blinding Light

	  -- Holy

	  [   498] = { default = true, cooldown = 60, class = "PALADIN", specID = { 65, 66 }, defensive = 0.2, duration = 8}, -- Divine Protection
	  [  6940] = { default = true, cooldown = 150, class = "PALADIN", specID = { 65, 66 }, charges = 2, defensive = 1, duration=10 }, -- Blessing of Sacrifice
	  [ 31821] = { default = true, cooldown = 180, class = "PALADIN", specID = { 65 }, defensive = 0.2, duration = 6 }, -- Aura Mastery
	  [105809] = { default = true, cooldown = 90, class = "PALADIN", specID = { 65 }, offensive = 0.4, duration = 20 }, -- Holy Avenger
	  [114158] = { default = true, cooldown = 60, class = "PALADIN", specID = { 65 } }, -- Light's Hammer
	  [183415] = { default = true, cooldown = 180, class = "PALADIN", specID = { 65 } }, -- Aura of Mercy
	  [200652] = { default = true, cooldown = 90, class = "PALADIN", specID = { 65 }, cast = 2, heal = true }, -- Tyr's Deliverance
	  [210294] = { default = true, cooldown = 45, class = "PALADIN", specID = { 65 }, dispellable = true, offensive = true, cooldown_starts_on_aura_fade = true, talent = {} }, -- Divine Favor
	  [214202] = { default = true, cooldown = 30, class = "PALADIN", specID = { 65 }, charges = 2 }, -- Rule of Law
	  [  4987] = { default = true, cooldown = 8, class = "PALADIN", specID = {65}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption
	  [ 82326] = { default = true, class = "PALADIN", specID = {65}, cast = 2.5, heal = true },  -- Holy Light
	  [ 31842] = { default = true, cooldown = 120, class = "PALADIN", offensive = 0.5, duration = 25, specID = { 65 }}, -- Avenging Wrath (Holy)
	  [216331] = { parent = 31842, cooldown = 60 , specID = { 65 }, talent = {31842}}, -- Avenging Crusader

	  -- Protection TBD

		[ 31884] = { default = true, cooldown = 120, class = "PALADIN", specID = { 66,70 }, offensive = 0.35, duration = 20 }, -- Avenging Wrath
	  [204018] = { parent = 1022, cooldown = 180, class = "PALADIN", specID = { 66 }, talent = {1022} }, -- Blessing of Spellwarding
	  [ 31850] = { default = true, cooldown = 120, class = "PALADIN", specID = { 66 } }, -- Ardent Defender
	  [ 31935] = { default = true, cooldown = 15, class = "PALADIN", specID = { 66 } }, -- Avenger's Shield
	  [ 86659] = { default = true, cooldown = 300, class = "PALADIN", specID = { 66 } }, -- Guardian of Ancient Kings
	  [228049] = { parent = 86659 }, -- Guardian of the Forgotten Queen
	  [ 96231] = { default = true, cooldown = 15, class = "PALADIN", specID = { 66, 70 }, interrupt = true }, -- Rebuke
	  [152262] = { default = true, cooldown = 30, class = "PALADIN", specID = { 66 } }, -- Seraphim
	  [190784] = { default = true, cooldown = 45, class = "PALADIN", specID = { 66 } }, -- Divine Steed
	  [204035] = { default = true, cooldown = 180, class = "PALADIN", specID = { 66 } }, -- Bastion of Light
	  [204150] = { default = true, cooldown = 300, class = "PALADIN", specID = { 66 } }, -- Aegis of Light
	  [209202] = { default = true, cooldown = 60, class = "PALADIN", specID = { 66 } }, -- Eye of Tyr
	  [215652] = { default = true, cooldown = 25, class = "PALADIN", specID = { 66 } }, -- Shield of Virtue
	  [213644] = { default = true, cooldown = 8, class = "PALADIN", specID = {66,70}, dispel = true, cooldown_starts_on_dispel = true },  -- Remove Corruption

	  -- Retribution

	  [184662] = { default = true, cooldown = 120, class = "PALADIN", specID = { 70 }, defensive = 0.2, dispellable = true, duration = 15 }, -- Shield of Vengeance
	  [204939] = { default = true, cooldown = 60, class = "PALADIN", specID = { 70 } }, -- Hammer of Reckoning
	  [205191] = { default = true, cooldown = 60, class = "PALADIN", specID = { 70 }, talent = {}, defensive = 0.2, duration = 10 }, -- Eye for an Eye
	  [205273] = { default = true, cooldown = 30, class = "PALADIN", specID = { 70 }, offensive = true }, -- Wake of Ashes
	  [210191] = { default = true, cooldown = 60, class = "PALADIN", specID = { 70 }, defensive = 0.1, talent = {} }, -- Word of Glory
	  [210220] = { default = true, cooldown = 180, class = "PALADIN", specID = { 70 }, offensive = true, talent = {} }, -- Holy Wrath
	  [210256] = { default = true, cooldown = 25, class = "PALADIN", specID = { 70 }, dispel = true, talent = {} }, -- Blessing of Sanctuary
	  [231895] = { default = true, cooldown = 120, class = "PALADIN", offensive = 0.5, duration = 20, specID = { 66 }, talent = {31884}}, -- Crusade

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
