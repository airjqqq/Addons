if GetLocale() ~= "ptBR" then return end

select( 2, ... ).L = setmetatable( {
	AQLCOLORLABEL = "|CFFCC33FFLink da Armaria|r:",
	ARMORYQUICKLINK = "Link da Armaria",
	LANGUAGE = "pt",
	NOTSUPPORTEDLIST = "nao e uma Lista de Reinos suportada",
	REALMERROR = "Lista de Reinos nao encontrada!",
	SERVERERROR = "Servidor nao encontrado!",
}, { __index = select( 2, ... ).L })