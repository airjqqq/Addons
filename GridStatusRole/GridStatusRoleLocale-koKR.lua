if GetLocale() ~= "koKR" then return end
local _, ns = ...
ns.L = {
	["Specialization Role"] = "전문화 역할",

	["Healer"] = "힐러",
	["Melee"] = "근접",
	["Ranged"] = "원거리",
	["Tank"] = "탱커",

	["Role colors"] = "역할 색상",

	["Healer color"] = "힐러 색상",
	["Color for Healers."] = "힐러 색상입니다.",

	["Melee color"] = "근접 색상",
	["Color for Melee."] = "근접 색상입니다.",

	["Ranged color"] = "원거리 색상",
	["Color for Ranged."] = "원거리 색상입니다.",

	["Tank color"] = "탱커 색상",
	["Color for Tanks."] = "탱커 색상입니다.",

	["Role filter"] = "역할 필터",
	["Show status for the selected roles."] = "선택된 역할을 상태 창에 표시합니다.",

	["Show on Healers."] = "힐러 계열을 표시합니다.",
	["Show on Melee."] = "근접 계열을 표시합니다.",
	["Show on Ranged."] = "원거리 계열을 표시합니다.",
	["Show on Tanks."] = "탱커 계열을 표시합니다.",

	["Assigned roles"] = "할당된 역할",
	["Use assigned roles"] = "할당된 역할 사용",
	["Use assigned roles while talent info is unknown."] = "특성 정보를 알 수 없으면 할당된 역할을 사용합니다.",

	["Assigned opacity"] = "할당 투명도",
	["Opacity for assigned roles."] = "할당된 역할의 투명도입니다.",

	["Hide in combat"] = "전투 중 숨기기",
	["Hide roles while in combat."] = "전투 중에는 역할을 숨깁니다.",
}
