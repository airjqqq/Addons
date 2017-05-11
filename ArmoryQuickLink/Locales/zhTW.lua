if GetLocale() ~= "zhTW" then return end

select( 2, ... ).L = setmetatable( {
	AQLCOLORLABEL = "|CFFCC33FF英雄榜快速連結|r: ",
	ARMORYQUICKLINK = "英雄榜快速連結",
	LANGUAGE = "zh",
	NOTSUPPORTEDLIST = "不是支援的伺服器列表。",
	REALMERROR = "找不到伺服器列表",
	SERVERERROR = "找不到伺服器！",
}, { __index = select( 2, ... ).L })