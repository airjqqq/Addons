local F = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyPVPFilter", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
function F:IsMeleeSpell(spell)
	local meleeList = {
		--武器
		["致死打击"] = true,
		["巨人打击"] = true,
		["旋风斩"] = true,
		["剑刃风暴"] = true,
		["斩杀"] = true,
		--狂暴
		["狂风打击"] = true,
		["嗜血"] = true,
		--冰
		["冰霜打击"] = true,
		["湮灭"] = true,
		--邪
		["天谴打击"] = true,
		--血
		["灵界打击"] = true,
		--惩戒
		["十字军打击"] = true,
		["圣殿骑士的裁决"] = true,
		["最终审判"] = true,
		["神圣风暴"] = true,
		--增强
		["风暴打击"] = true,
		["熔岩猛击"] = true,
		--刺杀
		["毒伤"] = true,
		["斩击"] = true,
		["毁伤"] = true,
		--敏锐
		["伏击"] = true,
		["背刺"] = true,
		["刺骨"] = true,
		--战斗
		["影袭"] = true,
		["要害打击"] = true,
		--野
		["撕碎"] = true,
		["斜掠"] = true,
		["凶猛撕咬"] = true,
		["割碎"] = true,
	}
	return meleeList[spell]
end


function F:GetCooldown(spell)
	local spellList = {
		["深度冻结"] = true,
		["冰冻陷阱"] = true,
	}
end
