local Core = AceAddon:GetAddon("AirjAutoKey")
local Filter = Core:NewModule("AirjAutoKeyFilter")
Filter:SetDefaultModulePrototype({OnEnable=function(self) self:Print("enabled!") })
