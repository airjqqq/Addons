
local QuestNotifier = LibStub("AceAddon-3.0"):GetAddon("QuestNotifier")
local L = LibStub("AceLocale-3.0"):GetLocale("QuestNotifier")

local options, configOptions = nil, {}
--[[ This options table is used in the GUI config. ]]--
local function getOptions()
	if not options then
		options = {
			type = "group",
			name = "QuestNotifier",
			args = {
				general = {
					order = 1,
					type = "group",
					name = "General",
					args = {
						settings = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Settings"],
							get = function(info)
								local key = info.arg or info[#info]
								QuestNotifier:SendDebugMsg("getSettings: "..key.." :: "..tostring(QuestNotifier.db.profile.settings[key]))
								return QuestNotifier.db.profile.settings[key]
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								QuestNotifier.db.profile.settings[key] = value
								QuestNotifier:SendDebugMsg("setSettings: "..key.." :: "..tostring(QuestNotifier.db.profile.settings[key]))
							end,
							args = {
								enabledesc = {
									order = 1,
									type = "description",
									fontSize = "medium",
									name = L["Enable/Disable QuestNotifier"]
								},
								enable = {
									order = 2,
									type = "toggle",
									name = L["Enable"]
								},
								everydesc = {
									order = 3,
									type = "description",
									fontSize = "medium",
									name = L["Announce progression every x number of steps (0 will announce on quest objective completion only)"]
								},
								every = {
									order = 4,
									type = "range",
									name = L["Announce Every"],
									min = 0,
									max = 10,
									step = 1
								},
								sounddesc = {
									order = 5,
									type = "description",
									fontSize = "medium",
									name = L["Enable/Disable QuestNotifier Sounds"]
								},
								sound = {
									order = 6,
									type = "toggle",
									name = L["Sound"]
								},
								detaildesc = {
									order = 7,
									type = "description",
									fontSize = "medium",
									name = L["Enable/Disable Detail Quest Notifier"]
								},
								detail = {
									order = 8,
									type = "toggle",
									name = L["Detail Notifier"]
								},
								completexdesc = {
									order = 9,
									type = "description",
									fontSize = "medium",
									name = L["Enable/Disable Quest Complete Notifier"]
								},
								completex = {
									order = 10,
									type = "toggle",
									name = L["Quest Complete Notifier"]
								},
								debugdesc = {
									order = 100,
									type = "description",
									fontSize = "medium",
									name = L["Enable/Disable QuestNotifier Debug Mode"]
								},
								debug = {
									order = 101,
									type = "toggle",
									name = L["Debug"]
								},
								test = {
									order = 102,
									type = "execute",
									name = "Test Frame Messages",
									func = function() QuestNotifier:SendMsg(L["QuestNotifier Test Message"]) end
								}
							}
						},
						announceTo = {
							order = 6,
							type = "group",
							inline = true,
							name = L["Where do you want to make the announcements?"],
							get = function(info)
								local key = info.arg or info[#info]
								QuestNotifier:SendDebugMsg("getAnnounceTo: "..key.." :: "..tostring(QuestNotifier.db.profile.announceTo[key]))
								return QuestNotifier.db.profile.announceTo[key]
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								QuestNotifier.db.profile.announceTo[key] = value
								QuestNotifier:SendDebugMsg("setAnnounceTo: "..key.." :: "..tostring(QuestNotifier.db.profile.announceTo[key]))
							end,
							args = {
								chatFrame = {
									order = 1,
									type = "toggle",
									name = L["Chat Frame"]
								},
								raidWarningFrame = {
									order = 2,
									type = "toggle",
									name = L["Raid Warning Frame"]
								},
								uiErrorsFrame = {
									order = 3,
									type = "toggle",
									name = L["UI Errors Frame"]
								}
							}
						},
						announceIn = {
							order = 7,
							type = "group",
							inline = true,
							name = L["What channels do you want to make the announcements?"],
							get = function(info)
								local key = info.arg or info[#info]
								QuestNotifier:SendDebugMsg("getAnnounceIn: "..key.." :: "..tostring(QuestNotifier.db.profile.announceIn[key]))
								return QuestNotifier.db.profile.announceIn[key]
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								QuestNotifier.db.profile.announceIn[key] = value
								QuestNotifier:SendDebugMsg("setAnnounceIn: "..key.." :: "..tostring(QuestNotifier.db.profile.announceIn[key]))
							end,
							args = {
								say = {
									order = 1,
									type = "toggle",
									name = L["Say"]
								},
								party = {
									order = 2,
									type = "toggle",
									name = L["Party"]
								},
								instance = {
									order = 3,
									type = "toggle",
									name = L["Instance"],
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end
								},
								guild = {
									order = 4,
									type = "toggle",
									name = L["Guild"],
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end
								},
								officer = {
									order = 5,
									type = "toggle",
									name = L["Officer"],
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end
								},
								whisper = {
									order = 6,
									type = "toggle",
									name = L["Whisper"],
									width = 'half',
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end
								},
								whisperWho = {
									order = 7,
									type = "input",
									width = 'half',
									name = L["Whisper Who"]
								}
							}
						}
					}
				}
			}
		}
		for k,v in pairs(configOptions) do
			options.args[k] = (type(v) == "function") and v() or v
		end
	end

	return options
end

local function openConfig()
	InterfaceOptionsFrame_OpenToCategory(QuestNotifier.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(QuestNotifier.optionsFrames.QuestNotifier)
	InterfaceOptionsFrame:Raise()
end

function QuestNotifier:SetupOptions()
	self.optionsFrames = {}

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("QuestNotifier", getOptions)
	self.optionsFrames.QuestNotifier = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("QuestNotifier", nil, nil, "general")

	configOptions["Profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	self.optionsFrames["Profiles"] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("QuestNotifier", "Profiles", "QuestNotifier", "Profiles")

	LibStub("AceConsole-3.0"):RegisterChatCommand("qn", openConfig)
end
