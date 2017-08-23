local L = LibStub("AceLocale-3.0"):NewLocale("GatherMate_Sharing","zhTW")
if not L then return end

-- Addon name
L["Gathermate_Sharing"] = "Gathermate_Sharing"
L["MODULE_DESC"] = "GatherMate_Sharing可以讓你與你的公會中的其他玩家分享資料，自動增加/刪除紀錄點和廣播他們。"

-- Configuration
L["Enable GatherMate_Sharing"] = "啟用GatherMate_Sharing"
L["Enable or disable syncing of GatherMate data with other players."] = "啟用或停用與其他玩家同步GatherMate資料"
L["Gathermate_Sharing Options"] = "Gathermate_Sharing 選項"
L["Sync node additions"] = "紀錄點同步增加"
L["When other players add nodes to their GatherMate, automatically add the same node to your database too."] = "當其他玩家在他的GatherMate增加記錄點時，也自動增加紀錄點到在你資料庫中。"
L["Sync node deletions"] = "紀錄點同步刪除"
L["When other players delete nodes from their GatherMate, automatically delete the same node from your database too."] = "當其他玩家從他的GatherMate刪除記錄點時，也自動刪除在你資料庫中一樣的紀錄點。"
L["Sync Channel"] = "同步頻道"
L["Communication channel to send sync messages."] = "連絡頻道發送同步訊息。"
L["GUILD"] = "公會"
L["NONE"] = "無"
L["PARTY"] = "隊伍"
L["RAID"] = "團隊 (包含隊伍)"