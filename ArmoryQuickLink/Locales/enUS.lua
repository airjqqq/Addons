-- default
select( 2, ... ).L = setmetatable( {
  ARMORYQUICKLINK = "Armory QuickLink",
  AQLCOLORLABEL = "|CFFCC33FFArmory QuickLink|r: ",
  REALMERROR = "Couldn't find realm list!",
  SERVERERROR = "Couldn't find server!",
  NOTSUPPORTEDLIST = " is not a supported Realm List.",
  LANGUAGE = "en",
}, {
	__index = function ( self, Key )
		if ( Key ~= nil ) then
			rawset( self, Key, Key )
			return Key
		end
	end
} )