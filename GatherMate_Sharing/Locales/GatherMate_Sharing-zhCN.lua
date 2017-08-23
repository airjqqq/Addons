local L = LibStub("AceLocale-3.0"):NewLocale("GatherMate_Sharing","zhCN")
if not L then return end

-- Addon name
L["Gathermate_Sharing"] = "Gathermate_Sharing"
L["MODULE_DESC"] = "GatherMate_Sharing可以让你与你的公会中的其它玩家分享数据，自动增加/删除纪录点和广播他们。"

-- Configuration
L["Enable GatherMate_Sharing"] = "启用GatherMate_Sharing"
L["Enable or disable syncing of GatherMate data with other players."] = "启用或停用与其它玩家同步GatherMate数据"
L["Gathermate_Sharing Options"] = "Gathermate_Sharing 选项"
L["Sync node additions"] = "纪录点同步增加"
L["When other players add nodes to their GatherMate, automatically add the same node to your database too."] = "当其它玩家在他的GatherMate增加记录点时，也自动增加纪录点到在你数据库中。"
L["Sync node deletions"] = "纪录点同步删除"
L["When other players delete nodes from their GatherMate, automatically delete the same node from your database too."] = "当其它玩家从他的GatherMate删除记录点时，也自动删除在你数据库中一样的纪录点。"
L["Sync Channel"] = "同步频道"
L["Communication channel to send sync messages."] = "连络频道发送同步讯息。"
L["GUILD"] = "公会"
L["NONE"] = "无"
L["PARTY"] = "队伍"
L["RAID"] = "团队 (包含队伍)"
