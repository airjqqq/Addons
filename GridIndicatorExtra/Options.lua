local Grid = Grid
local GridFrame = Grid:GetModule("GridFrame")
local Media = LibStub("LibSharedMedia-3.0")
local db = Grid.db:RegisterNamespace("GridIndicatorExtra", {
	profile = {
		icon = {
			iconSize = 12,
			iconBorderSize = 0,
			enableIconTextures = true,
			enableIconStackText = true,
			enableIconCooldown = true,
			stackFontSize = 7,
			stackOffsetX = 4,
			stackOffsetY = -2,
			margin = 1,
			spacing = 1,
			more1 = true,
			more2 = false,
		},
		text = {
			font = "Friz Quadrata TT",
			fontSize = 8,
			fontOutline = "OUTLINE",
			fontShadow = false,
			margin = 2,
			textlength = 6,
		}
	}
})

GridFrame.options.args["GridIndicatorExtra"] = {
	name = "Extra Indicators",
	type = "group",
	set = function(info, value)
		db.profile[info[#info - 1]][info[#info]] = value
		GridFrame:UpdateAllFrames()
	end,
	get = function(info)
		return db.profile[info[#info - 1]][info[#info]]
	end,
	args = {
		icon = {
			name = "Icon Indicators Options",
			desc = "Options related to icon indicators.",
			order = 300, width = "double",
			type = "group",
			args = {
				iconSize = {
					name = "Icon Size",
					desc = "Adjust the size of the icons.",
					order = 10, width = "double",
					type = "range", min = 1, max = 50, step = 1,
				},
				iconBorderSize = {
					name = "Icon Border Size",
					desc = "Adjust the size of the icon's borders.",
					order = 20, width = "double",
					type = "range", min = 0, max = 9, step = 1,
				},
				margin = {
					name = "Margin",
					desc = "Adjust the margin from the frame borders.",
					order = 25, width = "double",
					type = "range", softMin = 0, softMax = 20, step = 1,
				},
				spacing = {
					name = "Spacing",
					desc = "Adjust the spacing between the icon indicators.",
					order = 26, width = "double",
					type = "range", softMin = 0, softMax = 20, step = 1,
				},
				enableIconTextures = {
					name = "Enable Icon Textures",
					desc = "Toggle icon's textures. If disabled, only the color is shown.",
					order = 27, width = "double",
					type = "toggle",
				},
				enableIconCooldown = {
					name = "Enable Icon Cooldown Frame",
					desc = "Toggle icon's cooldown frame.",
					order = 30, width = "double",
					type = "toggle",
				},
				enableIconStackText = {
					name = "Enable Icon Stack Text",
					desc = "Toggle icon's stack count text.",
					order = 40, width = "double",
					type = "toggle",
				},
				stackFontSize = {
					name = "Icon Stack Text Font Size",
					desc = "Adjust the font size of the icon stack text.",
					order = 50, width = "double",
					type = "range", min = 4, max = 24, step = 1,
				},
				stackOffsetX = {
					name = "Icon Stack Text Offset X",
					desc = "Adjust the position of the icon stack text.",
					order = 60, width = "normal",
					type = "range", softMin = -20, softMax = 20, step = 1,
				},
				stackOffsetY = {
					name = "Icon Stack Text Offset Y",
					desc = "Adjust the position of the icon stack text.",
					order = 70, width = "normal",
					type = "range", softMin = -20, softMax = 20, step = 1,
				},
				more1 = {
					name = "Add More Icons (Requires UI Reload)",
					desc = "Toggle icon 2.",
					order = 80, width = "double",
					type = "toggle",
				},
				more2 = {
					name = "Add Even More Icons (Requires UI Reload)",
					desc = "Toggle icons 3 and 4.",
					order = 90, width = "double",
					type = "toggle",
				},
			},
		},
		text = {
			name = "Text Indicators Options",
			desc = "Options related to text indicators.",
			order = 400,
			type = "group",
			args = {
				font = {
					name = "Font",
					desc = "Adjust the font settings",
					order = 10, width = "double",
					type = "select",
					values = Media:HashTable("font"),
					dialogControl = "LSM30_Font",
				},
				fontSize = {
					name = "Font Size",
					desc = "Adjust the font size.",
					order = 20, width = "double",
					type = "range", min = 6, max = 24, step = 1,
				},
				fontOutline = {
					name = "Font Outline",
					desc = "Adjust the font outline.",
					order = 30, width = "double",
					type = "select",
					values = {
						NONE = "None",
						OUTLINE = "Thin",
						THICKOUTLINE = "Thick",
					},
				},
				fontShadow = {
					name = "Font Shadow",
					desc = "Toggle the font drop shadow effect.",
					order = 40, width = "double",
					type = "toggle",
				},
				margin = {
					name = "Margin",
					desc = "Adjust the margin from the frame borders.",
					order = 45, width = "double",
					type = "range", softMin = 0, softMax = 20, step = 1,
				},
				textlength = {
					name = "Text Length",
					desc = "Number of characters to show on the text indicators.",
					order = 50, width = "double",
					type = "range", min = 1, max = 12, step = 1,
				},
			},
		}
	}
}
