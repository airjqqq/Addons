if GetLocale() ~= "koKR" then return end

select( 2, ... ).L = setmetatable( {
	AQLCOLORLABEL = "|CFFCC33FF전투정보실|r:",
	ARMORYQUICKLINK = "|CFF11CCFF[전투정보실]|r",
	LANGUAGE = "ko",
	NOTSUPPORTEDLIST = "영역 리스트가 지원되지 않습니다",
	REALMERROR = "영역 리스트를 찾을 수 없습니다!",
	SERVERERROR = "서버를 찾을 수 없습니다!",
}, { __index = select( 2, ... ).L })
