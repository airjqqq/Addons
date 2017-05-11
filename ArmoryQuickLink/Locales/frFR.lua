if GetLocale() ~= "frFR" then return end

select( 2, ... ).L = setmetatable( {
  ARMORYQUICKLINK = "Armory QuickLink",
  AQLCOLORLABEL = "|CFFCC33FFArmory QuickLink|r: ",
  REALMERROR = "Couldn't find realm list!",
  SERVERERROR = "Couldn't find server!",
  NOTSUPPORTEDLIST = " is not a supported Realm List.",
  LANGUAGE = "fr",
}, { __index = select( 2, ... ).L })