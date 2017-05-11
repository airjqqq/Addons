if GetLocale() ~= "zhCN" then return end

select( 2, ... ).L = setmetatable( {
  ARMORYQUICKLINK = "英雄榜便捷链接",
  AQLCOLORLABEL = "英雄榜链接: ",
  REALMERROR = "找不到服务器列表！",
  SERVERERROR = "找不到服务器！",
  NOTSUPPORTEDLIST = " 是不被支持的服务器列表。",
  LANGUAGE = "zh",
}, { __index = select( 2, ... ).L })