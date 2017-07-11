local L = LibStub("AceLocale-3.0"):NewLocale("Details", "zhTW") 
if not L then return end 

L["ABILITY_ID"] = "技能id"
--Translation missing 
-- L["STRING_"] = ""
L["STRING_ABSORBED"] = "吸收"
L["STRING_ACTORFRAME_NOTHING"] = "沒有資料可報告"
L["STRING_ACTORFRAME_REPORTAT"] = "在"
L["STRING_ACTORFRAME_REPORTOF"] = "的"
L["STRING_ACTORFRAME_REPORTTARGETS"] = "報告的對象"
L["STRING_ACTORFRAME_REPORTTO"] = "報告給"
L["STRING_ACTORFRAME_SPELLDETAILS"] = "法術細節"
L["STRING_ACTORFRAME_SPELLSOF"] = "技能的"
L["STRING_ACTORFRAME_SPELLUSED"] = "所有使用的法術"
L["STRING_AGAINST"] = "相反"
L["STRING_ALIVE"] = "存活"
L["STRING_ALPHA"] = "Alpha"
L["STRING_ANCHOR_BOTTOM"] = "下"
L["STRING_ANCHOR_BOTTOMLEFT"] = "左下"
L["STRING_ANCHOR_BOTTOMRIGHT"] = "右下"
L["STRING_ANCHOR_LEFT"] = "左"
L["STRING_ANCHOR_RIGHT"] = "右"
L["STRING_ANCHOR_TOP"] = "上"
L["STRING_ANCHOR_TOPLEFT"] = "左上"
L["STRING_ANCHOR_TOPRIGHT"] = "右上"
L["STRING_ASCENDING"] = "遞增"
L["STRING_ATACH_DESC"] = "視窗#%d與視窗#%d成為群組。"
L["STRING_ATTRIBUTE_CUSTOM"] = "自訂"
L["STRING_ATTRIBUTE_DAMAGE"] = "傷害"
L["STRING_ATTRIBUTE_DAMAGE_BYSPELL"] = "承受到的技能傷害"
L["STRING_ATTRIBUTE_DAMAGE_DEBUFFS"] = "光環 & 虛空領域"
L["STRING_ATTRIBUTE_DAMAGE_DEBUFFS_REPORT"] = "減益傷害與持續時間"
L["STRING_ATTRIBUTE_DAMAGE_DONE"] = "造成傷害"
L["STRING_ATTRIBUTE_DAMAGE_DPS"] = "每秒傷害"
L["STRING_ATTRIBUTE_DAMAGE_ENEMIES"] = "敵方承受傷害"
L["STRING_ATTRIBUTE_DAMAGE_ENEMIES_DONE"] = "敵方造成傷害"
L["STRING_ATTRIBUTE_DAMAGE_FRAGS"] = "擊殺"
L["STRING_ATTRIBUTE_DAMAGE_FRIENDLYFIRE"] = "隊友誤傷"
L["STRING_ATTRIBUTE_DAMAGE_TAKEN"] = "承受傷害"
L["STRING_ATTRIBUTE_ENERGY"] = "能量"
L["STRING_ATTRIBUTE_ENERGY_ALTERNATEPOWER"] = "次要能量"
L["STRING_ATTRIBUTE_ENERGY_ENERGY"] = "能量生成"
L["STRING_ATTRIBUTE_ENERGY_MANA"] = "法力恢復"
L["STRING_ATTRIBUTE_ENERGY_RAGE"] = "怒氣生成"
L["STRING_ATTRIBUTE_ENERGY_RESOURCES"] = "其他資源"
L["STRING_ATTRIBUTE_ENERGY_RUNEPOWER"] = "符能生成"
L["STRING_ATTRIBUTE_HEAL"] = "治療"
L["STRING_ATTRIBUTE_HEAL_ABSORBED"] = "吸收的治療"
L["STRING_ATTRIBUTE_HEAL_DONE"] = "造成治療"
L["STRING_ATTRIBUTE_HEAL_ENEMY"] = "敵方造成治療"
L["STRING_ATTRIBUTE_HEAL_HPS"] = "每秒治療"
L["STRING_ATTRIBUTE_HEAL_OVERHEAL"] = "過量治療"
L["STRING_ATTRIBUTE_HEAL_PREVENT"] = "減傷"
L["STRING_ATTRIBUTE_HEAL_TAKEN"] = "承受治療"
L["STRING_ATTRIBUTE_MISC"] = "雜項"
L["STRING_ATTRIBUTE_MISC_BUFF_UPTIME"] = "增益覆蓋時間"
L["STRING_ATTRIBUTE_MISC_CCBREAK"] = "控場破除"
L["STRING_ATTRIBUTE_MISC_DEAD"] = "死亡"
L["STRING_ATTRIBUTE_MISC_DEBUFF_UPTIME"] = "減益覆蓋時間"
L["STRING_ATTRIBUTE_MISC_DEFENSIVE_COOLDOWNS"] = "冷卻"
L["STRING_ATTRIBUTE_MISC_DISPELL"] = "驅散"
L["STRING_ATTRIBUTE_MISC_INTERRUPT"] = "打斷"
L["STRING_ATTRIBUTE_MISC_RESS"] = "復活"
L["STRING_AUTO"] = "自動"
L["STRING_AUTOSHOT"] = "自動射擊"
L["STRING_AVERAGE"] = "平均"
L["STRING_BLOCKED"] = "格檔"
L["STRING_BOTTOM"] = "底部"
L["STRING_BOTTOM_TO_TOP"] = "底部到頂部"
L["STRING_CAST"] = "施放"
L["STRING_CAUGHT"] = "捕捉"
L["STRING_CCBROKE"] = "控場移除"
L["STRING_CENTER"] = "中央"
L["STRING_CENTER_UPPER"] = "中間"
L["STRING_CHANGED_TO_CURRENT"] = "片段已改變:  |cFFFFFF00目前|r"
L["STRING_CHANNEL_PRINT"] = "觀察者"
L["STRING_CHANNEL_RAID"] = "團隊"
L["STRING_CHANNEL_SAY"] = "說"
L["STRING_CHANNEL_WHISPER"] = "密語"
L["STRING_CHANNEL_WHISPER_TARGET_COOLDOWN"] = "密語冷卻目標"
L["STRING_CHANNEL_YELL"] = "大喊"
L["STRING_CLICK_REPORT_LINE1"] = "|cFFFFCC22點擊|r: |cFFFFEE00報告|r"
L["STRING_CLICK_REPORT_LINE2"] = "|cFFFFCC22Shift+點擊|r: |cFFFFEE00視窗模式|r"
L["STRING_CLOSEALL"] = "所有視窗已關閉，你可以輸入'/details show'重新開啟。"
L["STRING_COLOR"] = "顏色"
L["STRING_COMMAND_LIST"] = "指令列表"
L["STRING_COOLTIP_NOOPTIONS"] = "無選項"
L["STRING_CRITICAL_HITS"] = "致命一擊"
L["STRING_CRITICAL_ONLY"] = "致命"
L["STRING_CURRENT"] = "當前"
L["STRING_CURRENTFIGHT"] = "當前片段"
L["STRING_CUSTOM_ACTIVITY_ALL"] = "活躍時間"
L["STRING_CUSTOM_ACTIVITY_ALL_DESC"] = "顯示此團隊中每個玩家的活躍度報告。"
L["STRING_CUSTOM_ACTIVITY_DPS"] = "傷害活耀時間"
L["STRING_CUSTOM_ACTIVITY_DPS_DESC"] = "報告每個腳色花了多少時間造成傷害。"
L["STRING_CUSTOM_ACTIVITY_HPS"] = "治療活耀時間"
L["STRING_CUSTOM_ACTIVITY_HPS_DESC"] = "報告每個腳色花了多少時間製造治療。"
L["STRING_CUSTOM_ATTRIBUTE_DAMAGE"] = "傷害"
L["STRING_CUSTOM_ATTRIBUTE_HEAL"] = "治療"
L["STRING_CUSTOM_ATTRIBUTE_SCRIPT"] = "自訂腳本"
L["STRING_CUSTOM_AUTHOR"] = "作者:"
L["STRING_CUSTOM_AUTHOR_DESC"] = "是誰創造此展列。"
L["STRING_CUSTOM_CANCEL"] = "取消"
L["STRING_CUSTOM_CC_DONE"] = "控場完成"
L["STRING_CUSTOM_CC_RECEIVED"] = "接收到的控場"
L["STRING_CUSTOM_CREATE"] = "建立"
L["STRING_CUSTOM_CREATED"] = "新視窗已建立"
L["STRING_CUSTOM_DAMAGEONANYMARKEDTARGET"] = "被其他標記的目標的傷害"
L["STRING_CUSTOM_DAMAGEONANYMARKEDTARGET_DESC"] = "顯示被其他標記的目標的傷害量。"
L["STRING_CUSTOM_DAMAGEONSHIELDS"] = "護盾的傷害"
L["STRING_CUSTOM_DAMAGEONSKULL"] = "被骷髏標記的目標的傷害"
L["STRING_CUSTOM_DAMAGEONSKULL_DESC"] = "顯示被骷髏標記的目標的傷害量。"
L["STRING_CUSTOM_DESCRIPTION"] = "說明:"
L["STRING_CUSTOM_DESCRIPTION_DESC"] = "視窗描述"
L["STRING_CUSTOM_DONE"] = "完畢"
L["STRING_CUSTOM_DTBS"] = "承受到的技能傷害"
L["STRING_CUSTOM_DTBS_DESC"] = "顯示敵方對你隊伍造成的技能傷害。"
--Translation missing 
-- L["STRING_CUSTOM_DYNAMICOVERAL"] = ""
L["STRING_CUSTOM_EDIT"] = "編輯"
L["STRING_CUSTOM_EDIT_SEARCH_CODE"] = "編輯搜尋代碼"
L["STRING_CUSTOM_EDIT_TOOLTIP_CODE"] = "編輯提示代碼"
L["STRING_CUSTOM_EDITCODE_DESC"] = "這是個進階功能，其中用戶可以創建自己的顯示用代碼。"
L["STRING_CUSTOM_EDITTOOLTIP_DESC"] = "這是提示代碼，運作在使用者懸停在計量條上。"
L["STRING_CUSTOM_ENEMY_DT"] = "承受傷害"
L["STRING_CUSTOM_EXPORT"] = "匯出"
L["STRING_CUSTOM_FUNC_INVALID"] = "無效的自訂腳本並無法刷新視窗。"
L["STRING_CUSTOM_HEALTHSTONE_DEFAULT"] = "治療藥水與治療石"
L["STRING_CUSTOM_HEALTHSTONE_DEFAULT_DESC"] = "顯示誰在你的團隊中使用了治療石或治療藥水。"
L["STRING_CUSTOM_ICON"] = "圖示:"
L["STRING_CUSTOM_IMPORT"] = "匯入"
L["STRING_CUSTOM_IMPORT_ALERT"] = "視窗已載入，點擊匯入來確認。"
L["STRING_CUSTOM_IMPORT_BUTTON"] = "匯入"
L["STRING_CUSTOM_IMPORT_ERROR"] = "匯入失敗，無效的字串。"
L["STRING_CUSTOM_IMPORTED"] = "此視窗已成功匯入。"
L["STRING_CUSTOM_LONGNAME"] = "名稱太長，最大允許32字元(換算中文16字元)。"
L["STRING_CUSTOM_MYSPELLS"] = "我的技能"
L["STRING_CUSTOM_MYSPELLS_DESC"] = "在視窗中顯示你的技能。"
L["STRING_CUSTOM_NAME"] = "名稱:"
L["STRING_CUSTOM_NAME_DESC"] = "在你新的自訂視窗中插入名稱。"
L["STRING_CUSTOM_NEW"] = "管理自訂視窗"
L["STRING_CUSTOM_PASTE"] = "這裡貼上:"
L["STRING_CUSTOM_POT_DEFAULT"] = "有使用藥水"
L["STRING_CUSTOM_POT_DEFAULT_DESC"] = "顯示在你的團隊中誰在戰鬥中使用了藥水。"
L["STRING_CUSTOM_REMOVE"] = "移除"
L["STRING_CUSTOM_REPORT"] = "(自訂)"
L["STRING_CUSTOM_SAVE"] = "儲存變更"
L["STRING_CUSTOM_SAVED"] = "此視窗已被儲存。"
L["STRING_CUSTOM_SHORTNAME"] = "名稱需要至少5個字元。"
L["STRING_CUSTOM_SKIN_TEXTURE"] = "自訂外觀檔"
L["STRING_CUSTOM_SKIN_TEXTURE_DESC"] = [=[副檔名為.tga。

檔案必須置放在資料夾:

|cFFFFFF00WoW/Interface/|r

|cFFFFFF00重要:|r 在建立此檔之前。關閉你的遊戲。之後，使用/reload指令會套用已儲存的材質檔。]=]
L["STRING_CUSTOM_SOURCE"] = "來源:"
L["STRING_CUSTOM_SOURCE_DESC"] = [=[是誰觸發的效果。
在右側的按鈕顯示團隊會遭遇的NPC名單。]=]
L["STRING_CUSTOM_SPELLID"] = "技能id:"
L["STRING_CUSTOM_SPELLID_DESC"] = [=[選用，是由來源在目標上應用效果使用的技能。
在右側的按鈕顯示團隊中的技能名單。]=]
L["STRING_CUSTOM_TARGET"] = "目標:"
L["STRING_CUSTOM_TARGET_DESC"] = [=[這是來源的目標。
右側的按鈕顯示團隊會遭遇的NPC名單。]=]
L["STRING_CUSTOM_TEMPORARILY"] = "(|cFFFFC000暫時|r)"
L["STRING_DAMAGE"] = "傷害"
L["STRING_DAMAGE_DPS_IN"] = "接收的DPS來自"
L["STRING_DAMAGE_FROM"] = "取得傷害來自"
L["STRING_DAMAGE_TAKEN_FROM"] = "承受傷害來自"
L["STRING_DAMAGE_TAKEN_FROM2"] = "施加傷害在"
L["STRING_DEFENSES"] = "防禦"
L["STRING_DESCENDING"] = "遞減"
L["STRING_DETACH_DESC"] = "分離視窗群組"
L["STRING_DISPELLED"] = "移除的增益/減益"
L["STRING_DODGE"] = "閃避"
L["STRING_DOT"] = "(DoT)"
L["STRING_DPS"] = "每秒傷害"
L["STRING_EMPTY_SEGMENT"] = "空的片段"
L["STRING_ENABLED"] = "啟用"
L["STRING_ENVIRONMENTAL_DROWNING"] = "環境(溺水)"
L["STRING_ENVIRONMENTAL_FALLING"] = "環境(掉落)"
L["STRING_ENVIRONMENTAL_FATIGUE"] = "環境(疲勞)"
L["STRING_ENVIRONMENTAL_FIRE"] = "環境(火焰)"
L["STRING_ENVIRONMENTAL_LAVA"] = "環境(岩漿)"
L["STRING_ENVIRONMENTAL_SLIME"] = "環境(史萊姆)"
L["STRING_EQUILIZING"] = "分享首領戰數據"
L["STRING_ERASE"] = "刪除"
L["STRING_ERASE_DATA"] = "重置所有數據"
L["STRING_ERASE_DATA_OVERALL"] = "重置總體數據"
L["STRING_ERASE_IN_COMBAT"] = "當前戰鬥結束後重置數據"
L["STRING_EXAMPLE"] = "舉例"
L["STRING_EXPLOSION"] = "爆炸"
L["STRING_FAIL_ATTACKS"] = "攻擊失敗"
L["STRING_FEEDBACK_CURSE_DESC"] = "在Details!的網頁回報問題或是留下訊息。"
L["STRING_FEEDBACK_MMOC_DESC"] = "發布在我們在mmo-champion論壇上的討論文章。"
L["STRING_FEEDBACK_PREFERED_SITE"] = "選擇你比較喜歡的社群網站:"
L["STRING_FEEDBACK_SEND_FEEDBACK"] = "送出回饋"
L["STRING_FEEDBACK_WOWI_DESC"] = "在Details!的專案頁面留下一個感想。"
L["STRING_FIGHTNUMBER"] = "戰鬥 #"
L["STRING_FORGE_BUTTON_ALLSPELLS"] = "所有技能"
L["STRING_FORGE_BUTTON_ALLSPELLS_DESC"] = "列出所有玩家和NPC的技能"
L["STRING_FORGE_BUTTON_BWTIMERS"] = "BigWigs時間條"
L["STRING_FORGE_BUTTON_BWTIMERS_DESC"] = "列出BigWigs的時間條"
L["STRING_FORGE_BUTTON_DBMTIMERS"] = "DBM時間條"
L["STRING_FORGE_BUTTON_DBMTIMERS_DESC"] = "列出DBM的時間條"
L["STRING_FORGE_BUTTON_ENCOUNTERSPELLS"] = "首領技能"
L["STRING_FORGE_BUTTON_ENCOUNTERSPELLS_DESC"] = "只有列出在團隊或是副本的技能"
L["STRING_FORGE_BUTTON_ENEMIES"] = "敵人"
L["STRING_FORGE_BUTTON_ENEMIES_DESC"] = "列出目前戰鬥的敵人"
L["STRING_FORGE_BUTTON_PETS"] = "寵物"
L["STRING_FORGE_BUTTON_PETS_DESC"] = "列出目前戰鬥的寵物"
L["STRING_FORGE_BUTTON_PLAYERS"] = "玩家"
L["STRING_FORGE_BUTTON_PLAYERS_DESC"] = "列出目前戰鬥的玩家"
L["STRING_FORGE_ENABLEPLUGINS"] = "請從遊戲選單>插件啟用Details!的團隊副本插件，比如: Details: Tomb of Sargeras。"
L["STRING_FORGE_FILTER_BARTEXT"] = "計量條名稱"
L["STRING_FORGE_FILTER_CASTERNAME"] = "施放者名稱"
L["STRING_FORGE_FILTER_ENCOUNTERNAME"] = "副本名稱"
L["STRING_FORGE_FILTER_ENEMYNAME"] = "敵人名稱"
L["STRING_FORGE_FILTER_OWNERNAME"] = "擁有者名稱"
L["STRING_FORGE_FILTER_PETNAME"] = "寵物名稱"
L["STRING_FORGE_FILTER_PLAYERNAME"] = "玩家名稱"
L["STRING_FORGE_FILTER_SPELLNAME"] = "技能名稱"
L["STRING_FORGE_HEADER_BARTEXT"] = "計量條文字"
L["STRING_FORGE_HEADER_CASTER"] = "施放者"
L["STRING_FORGE_HEADER_CLASS"] = "職業"
L["STRING_FORGE_HEADER_CREATEAURA"] = "建立光環"
L["STRING_FORGE_HEADER_ENCOUNTERID"] = "副本ID"
L["STRING_FORGE_HEADER_ENCOUNTERNAME"] = "副本名稱"
L["STRING_FORGE_HEADER_EVENT"] = "事件"
L["STRING_FORGE_HEADER_FLAG"] = "Flag"
L["STRING_FORGE_HEADER_GUID"] = "GUID"
L["STRING_FORGE_HEADER_ICON"] = "圖示"
L["STRING_FORGE_HEADER_ID"] = "ID"
L["STRING_FORGE_HEADER_INDEX"] = "編號"
L["STRING_FORGE_HEADER_NAME"] = "名稱"
L["STRING_FORGE_HEADER_NPCID"] = "NpcID"
L["STRING_FORGE_HEADER_OWNER"] = "擁有者"
L["STRING_FORGE_HEADER_SCHOOL"] = "屬性"
L["STRING_FORGE_HEADER_SPELLID"] = "技能ID"
L["STRING_FORGE_HEADER_TIMER"] = "時間條"
--Translation missing 
-- L["STRING_FORGE_TUTORIAL_DESC"] = ""
--Translation missing 
-- L["STRING_FORGE_TUTORIAL_TITLE"] = ""
--Translation missing 
-- L["STRING_FORGE_TUTORIAL_VIDEO"] = ""
L["STRING_FREEZE"] = "這個階段此片段不可用"
L["STRING_FROM"] = "從"
L["STRING_GERAL"] = "一般"
L["STRING_GLANCING"] = "擦過"
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_BOSS"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_DATABASEERROR"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_DIFF"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_GUILD"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_PLAYERBASE"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_PLAYERBASE_INDIVIDUAL"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_PLAYERBASE_PLAYER"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_PLAYERBASE_RAID"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_RAID"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_ROLE"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_SHOWHISTORY"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_SHOWRANK"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_SYNCBUTTONTEXT"] = ""
--Translation missing 
-- L["STRING_GUILDDAMAGERANK_TUTORIAL_DESC"] = ""
L["STRING_HEAL"] = "治療"
L["STRING_HEAL_ABSORBED"] = "吸收"
L["STRING_HEAL_CRIT"] = "治療暴擊"
L["STRING_HEALING_FROM"] = "受到治療來自"
L["STRING_HEALING_HPS_FROM"] = "每秒治療來自"
L["STRING_HITS"] = "命中"
L["STRING_HPS"] = "每秒治療量"
L["STRING_IMAGEEDIT_ALPHA"] = "透明度"
L["STRING_IMAGEEDIT_CROPBOTTOM"] = "修剪底部"
L["STRING_IMAGEEDIT_CROPLEFT"] = "修剪左邊"
L["STRING_IMAGEEDIT_CROPRIGHT"] = "修剪右邊"
L["STRING_IMAGEEDIT_CROPTOP"] = "修剪頂部"
L["STRING_IMAGEEDIT_DONE"] = "完成"
L["STRING_IMAGEEDIT_FLIPH"] = "水平翻轉"
L["STRING_IMAGEEDIT_FLIPV"] = "垂直翻轉"
L["STRING_INFO_TAB_AVOIDANCE"] = "閃避"
L["STRING_INFO_TAB_COMPARISON"] = "比較"
L["STRING_INFO_TAB_SUMMARY"] = "總結"
L["STRING_INFO_TUTORIAL_COMPARISON1"] = "點擊|cFFFFDD00比較|r標籤同職業的玩家來對照。"
L["STRING_INSTANCE_CHAT"] = "副本頻道"
L["STRING_INSTANCE_LIMIT"] = "已達視窗數量上限，你可以在選單修改上限數量或重啟視窗選單"
L["STRING_INTERFACE_OPENOPTIONS"] = "打開選項面板"
L["STRING_ISA_PET"] = "這是一隻寵物"
L["STRING_KEYBIND_BOOKMARK"] = "加到書籤"
L["STRING_KEYBIND_BOOKMARK_NUMBER"] = "書籤#%s"
L["STRING_KEYBIND_RESET_SEGMENTS"] = "重設分段"
L["STRING_KEYBIND_SCROLL_DOWN"] = "向下滾動所有視窗"
L["STRING_KEYBIND_SCROLL_UP"] = "向上滾動所有視窗"
L["STRING_KEYBIND_SCROLLING"] = "滾動"
L["STRING_KEYBIND_SEGMENTCONTROL"] = "片段"
L["STRING_KEYBIND_TOGGLE_WINDOW"] = "切換視窗#%s"
L["STRING_KEYBIND_TOGGLE_WINDOWS"] = "切換全部"
L["STRING_KEYBIND_WINDOW_CONTROL"] = "視窗"
L["STRING_KEYBIND_WINDOW_REPORT"] = "報告顯示在window#%s的數據。"
L["STRING_KEYBIND_WINDOW_REPORT_HEADER"] = "報告數據"
L["STRING_KILLED"] = "擊殺"
L["STRING_LAST_COOLDOWN"] = "最後使用的冷卻技能"
L["STRING_LEFT"] = "左"
L["STRING_LEFT_CLICK_SHARE"] = "左鍵點擊報告"
L["STRING_LEFT_TO_RIGHT"] = "左到右"
L["STRING_LOCK_DESC"] = "鎖定或解鎖視窗"
L["STRING_LOCK_WINDOW"] = "鎖定"
L["STRING_MASTERY"] = "精通"
L["STRING_MAXIMUM"] = "最大化"
L["STRING_MAXIMUM_SHORT"] = "最大"
L["STRING_MEDIA"] = "媒體"
L["STRING_MELEE"] = "近戰"
L["STRING_MEMORY_ALERT_BUTTON"] = "我了解"
L["STRING_MEMORY_ALERT_TEXT1"] = "Details!使用了大量的記憶體，|cFFFF8800但是與常見的說法相反|r，插件記憶體使用率|cFFFF8800不影響|r遊戲的效能或是FPS。。"
L["STRING_MEMORY_ALERT_TEXT2"] = "所以，如果你看到 Details!使用大量記憶體，不要緊張！|cFFFF8800這是正常的|r，甚至這種記憶體的一部分|cFFFF8800是用來當作快取|r使插件變得更快。"
L["STRING_MEMORY_ALERT_TEXT3"] = "然而，如果你想知道|cFFFF8800什麼插件使用更多的記憶體|r或是什麼插件導致FPS降低，安裝插件：“|cFFFFFF00AddOns Cpu Usage|r”。"
L["STRING_MEMORY_ALERT_TITLE"] = "請仔細閱讀！"
L["STRING_MENU_CLOSE_INSTANCE"] = "關閉這個視窗"
L["STRING_MENU_CLOSE_INSTANCE_DESC"] = "關閉視窗只是被當作閒置，可以隨時從控制選單重開。"
L["STRING_MENU_CLOSE_INSTANCE_DESC2"] = "想完全刪除視窗，尋找選單內的雜項設定。"
L["STRING_MENU_INSTANCE_CONTROL"] = "視窗控制"
L["STRING_MINIMAP_TOOLTIP1"] = "|cFFCFCFCF左鍵點擊|r: 打開選單面板"
L["STRING_MINIMAP_TOOLTIP11"] = "|cFFCFCFCF左鍵點擊|r: 清除所有階段資料"
L["STRING_MINIMAP_TOOLTIP12"] = "|cFFCFCFCF左鍵點擊|r: 顯示/隱藏視窗"
L["STRING_MINIMAP_TOOLTIP2"] = "|cFFCFCFCF左鍵點擊|r: 快速選單"
L["STRING_MINIMAPMENU_CLOSEALL"] = "關閉全部"
L["STRING_MINIMAPMENU_HIDEICON"] = "隱藏小地圖圖示"
L["STRING_MINIMAPMENU_LOCK"] = "鎖定"
L["STRING_MINIMAPMENU_NEWWINDOW"] = "新增視窗"
L["STRING_MINIMAPMENU_REOPENALL"] = "全部重開"
L["STRING_MINIMAPMENU_UNLOCK"] = "解鎖"
L["STRING_MINIMUM"] = "最小化"
L["STRING_MINIMUM_SHORT"] = "最小"
L["STRING_MINITUTORIAL_BOOKMARK1"] = "右鍵點擊視窗任何區域中打開書籤！"
L["STRING_MINITUTORIAL_BOOKMARK2"] = "書籤是快速訪問最喜歡頁面的捷徑。"
L["STRING_MINITUTORIAL_BOOKMARK3"] = "右鍵點擊關閉書籤面板。"
L["STRING_MINITUTORIAL_BOOKMARK4"] = "不再顯示"
L["STRING_MINITUTORIAL_CLOSECTRL1"] = "|cFFFFFF00Ctrl + 右鍵點擊|r 關閉視窗！"
L["STRING_MINITUTORIAL_CLOSECTRL2"] = "如果你想重新打開它，去模式選單->視窗控制或選項面板。\""
L["STRING_MINITUTORIAL_OPTIONS_PANEL1"] = "哪個視窗正在編輯。"
L["STRING_MINITUTORIAL_OPTIONS_PANEL2"] = "勾選後，該組中的所有視窗也將改變。"
L["STRING_MINITUTORIAL_OPTIONS_PANEL3"] = [=[要創建一個群組，拖動視窗＃2到視窗＃1附近。

點擊 |cFFFFFF00取消|r 按钮拆分群组]=]
L["STRING_MINITUTORIAL_OPTIONS_PANEL4"] = "創建測試計量條來測試你的配置。"
L["STRING_MINITUTORIAL_OPTIONS_PANEL5"] = "當編輯組啟用時，群組中的所有視窗都改變了。"
L["STRING_MINITUTORIAL_OPTIONS_PANEL6"] = "在此選擇你想改變哪個視窗的外觀。"
L["STRING_MINITUTORIAL_WINDOWS1"] = [=[你剛建立了一組視窗群組。
點擊鎖頭圖示去分開它。]=]
L["STRING_MINITUTORIAL_WINDOWS2"] = [=[視窗已被鎖定。
點擊標題列去向上拖拉。]=]
L["STRING_MIRROR_IMAGE"] = "鏡像"
L["STRING_MISS"] = "未命中"
L["STRING_MODE_ALL"] = "所有的"
L["STRING_MODE_GROUP"] = "一般"
--Translation missing 
-- L["STRING_MODE_OPENFORGE"] = ""
--Translation missing 
-- L["STRING_MODE_OPENGUILDDAMAGERANK"] = ""
L["STRING_MODE_PLUGINS"] = "插件"
L["STRING_MODE_RAID"] = "插件: 團隊"
L["STRING_MODE_SELF"] = "插件: 單人"
L["STRING_MORE_INFO"] = "查看右邊方框檢視更多資訊"
L["STRING_MULTISTRIKE"] = "雙擊"
L["STRING_MULTISTRIKE_HITS"] = "雙擊命中"
L["STRING_MUSIC_DETAILS_ROBERTOCARLOS"] = [=[你無法試著遺忘
我將與你同在
Details只是渺小的我們]=]
L["STRING_NEWROW"] = "正在等待更新..."
L["STRING_NEWS_REINSTALL"] = "在更新之後發現問題。試著輸入'/details reinstall'指令"
L["STRING_NEWS_TITLE"] = "此版更新事項"
L["STRING_NO"] = "沒有"
L["STRING_NO_DATA"] = "數據已被清除"
L["STRING_NO_SPELL"] = "沒有已使用的技能"
L["STRING_NO_TARGET"] = "沒有發現目標"
L["STRING_NO_TARGET_BOX"] = "沒有可用目標"
L["STRING_NOCLOSED_INSTANCES"] = [=[沒有可關閉視窗，
請建立一個新視窗。]=]
L["STRING_NOLAST_COOLDOWN"] = "沒有使用冷卻技能"
L["STRING_NOMORE_INSTANCES"] = [=[已達最大視窗上限。
在選項面板改變上限。]=]
L["STRING_NORMAL_HITS"] = "普攻命中"
L["STRING_NUMERALSYSTEM"] = "數字符號系統"
L["STRING_NUMERALSYSTEM_ARABIC_MYRIAD_EASTASIA"] = "使用在東方亞洲國家，分成千和萬。"
L["STRING_NUMERALSYSTEM_ARABIC_WESTERN"] = "西方"
L["STRING_NUMERALSYSTEM_ARABIC_WESTERN_DESC"] = "常見的系統，分成千和百萬。"
L["STRING_NUMERALSYSTEM_DESC"] = "選擇使用何種數字符號系統"
L["STRING_NUMERALSYSTEM_MYRIAD_EASTASIA"] = "東方亞洲"
L["STRING_OFFHAND_HITS"] = "副手"
L["STRING_OPTIONS_3D_LALPHA_DESC"] = [=[調整低階模型的透明度。
|cFFFFFF00重要|r: 某些模型無視透明度。]=]
L["STRING_OPTIONS_3D_LANCHOR"] = "低階3D模型:"
L["STRING_OPTIONS_3D_LENABLED_DESC"] = "啟用或是禁用在計量條的後方的3D模型框架使用率。"
L["STRING_OPTIONS_3D_LSELECT_DESC"] = "選擇哪個模型可以被使用在低階模型計量條。"
L["STRING_OPTIONS_3D_SELECT"] = "選擇模型"
L["STRING_OPTIONS_3D_UALPHA_DESC"] = [=[調整高階模型的透明度。
|cFFFFFF00重要|r: 某些模型無視透明度。]=]
L["STRING_OPTIONS_3D_UANCHOR"] = "高階3D模型:"
L["STRING_OPTIONS_3D_UENABLED_DESC"] = "啟用或是禁用在計量條的上方的3D模型框架使用率。"
L["STRING_OPTIONS_3D_USELECT_DESC"] = "選擇哪個模型可以被使用在高階模型計量條。"
L["STRING_OPTIONS_ADVANCED"] = "進階"
L["STRING_OPTIONS_ALPHAMOD_ANCHOR"] = "自動隱藏:"
L["STRING_OPTIONS_ALWAYS_USE"] = "使用在所有角色"
L["STRING_OPTIONS_ALWAYS_USE_DESC"] = "當啟用後，所有角色會使用此選擇的設定檔，否則，會顯示一個詢問要使用哪個設定檔的面板。"
L["STRING_OPTIONS_ANCHOR"] = "側"
L["STRING_OPTIONS_ANIMATEBARS"] = "動畫計量條"
L["STRING_OPTIONS_ANIMATEBARS_DESC"] = "套用動畫到所有計量條"
L["STRING_OPTIONS_ANIMATESCROLL"] = "滾動條動畫化"
L["STRING_OPTIONS_ANIMATESCROLL_DESC"] = "當啟用時，當出現或隱藏滾動條時使用動畫效果"
L["STRING_OPTIONS_APPEARANCE"] = "外觀"
L["STRING_OPTIONS_ATTRIBUTE_TEXT"] = "標題列文字設定"
L["STRING_OPTIONS_ATTRIBUTE_TEXT_DESC"] = "這些選項為視窗標題列的設定"
L["STRING_OPTIONS_AUTO_SWITCH"] = "所有角色 |cFFFFAA00(戰鬥中)|r"
L["STRING_OPTIONS_AUTO_SWITCH_COMBAT"] = "|cFFFFAA00(戰鬥中)|r"
L["STRING_OPTIONS_AUTO_SWITCH_DAMAGER_DESC"] = "當為傷害專精時，這視窗顯示選定的屬性或插件"
L["STRING_OPTIONS_AUTO_SWITCH_DESC"] = [=[當你進入戰鬥時，這視窗顯示選定的屬性或插件
|cFFFFFF00重要|r: 選定的個別角色屬性將會覆蓋已選擇的屬性]=]
L["STRING_OPTIONS_AUTO_SWITCH_HEALER_DESC"] = "當為治療專精時，這視窗顯示選定的屬性或插件"
L["STRING_OPTIONS_AUTO_SWITCH_TANK_DESC"] = "當為坦克專精時，這視窗顯示選定的屬性或插件"
L["STRING_OPTIONS_AUTO_SWITCH_WIPE"] = "清除後"
L["STRING_OPTIONS_AUTO_SWITCH_WIPE_DESC"] = "在團隊首領戰鬥後，這視窗會自動顯示該屬性"
L["STRING_OPTIONS_AVATAR"] = "選擇頭像"
L["STRING_OPTIONS_AVATAR_ANCHOR"] = "身分:"
L["STRING_OPTIONS_AVATAR_DESC"] = "頭像也傳給公會成員，並顯示在玩家視窗的工具提示上"
L["STRING_OPTIONS_BAR_BACKDROP_ANCHOR"] = "邊框:"
L["STRING_OPTIONS_BAR_BACKDROP_COLOR_DESC"] = "改變邊框顏色"
L["STRING_OPTIONS_BAR_BACKDROP_ENABLED_DESC"] = "啟用或禁用行的邊框"
L["STRING_OPTIONS_BAR_BACKDROP_SIZE_DESC"] = "調整邊框大小"
L["STRING_OPTIONS_BAR_BACKDROP_TEXTURE_DESC"] = "改變邊框外觀"
L["STRING_OPTIONS_BAR_BCOLOR"] = "背景顏色"
L["STRING_OPTIONS_BAR_BTEXTURE_DESC"] = "在頂部材質下方的材質總是和視窗寬度一樣"
L["STRING_OPTIONS_BAR_COLOR_DESC"] = [=[該材質的顏色和透明度
|cFFFFFF00重要|r: 當使用職業顏色時，顏色選擇將被忽略。]=]
L["STRING_OPTIONS_BAR_COLORBYCLASS"] = "使用職業顏色"
L["STRING_OPTIONS_BAR_COLORBYCLASS_DESC"] = "當啟用時，總是使用玩家職業顏色的紋理"
L["STRING_OPTIONS_BAR_FOLLOWING"] = "總是顯示我"
L["STRING_OPTIONS_BAR_FOLLOWING_ANCHOR"] = "玩家計量條:"
L["STRING_OPTIONS_BAR_FOLLOWING_DESC"] = "當啟用時，你的計量條永遠會顯示即使你不是在排名前頭的玩家。"
L["STRING_OPTIONS_BAR_GROW"] = "計量條增長方向"
L["STRING_OPTIONS_BAR_GROW_DESC"] = "計量條從視窗的上方或是下方開始增長。"
L["STRING_OPTIONS_BAR_HEIGHT"] = "高度"
L["STRING_OPTIONS_BAR_HEIGHT_DESC"] = "增加或減少計量條高度"
L["STRING_OPTIONS_BAR_ICONFILE"] = "圖標檔案"
L["STRING_OPTIONS_BAR_ICONFILE_DESC"] = [=[自定義圖標路徑
圖檔副檔名需要是.tag，256*256畫素與alpha通道。]=]
L["STRING_OPTIONS_BAR_ICONFILE_DESC2"] = "選擇圖示包使用。"
L["STRING_OPTIONS_BAR_ICONFILE1"] = "沒有圖示"
L["STRING_OPTIONS_BAR_ICONFILE2"] = "預設"
L["STRING_OPTIONS_BAR_ICONFILE3"] = "預設(黑白)"
L["STRING_OPTIONS_BAR_ICONFILE4"] = "預設(透明)"
L["STRING_OPTIONS_BAR_ICONFILE5"] = "圓形圖示"
L["STRING_OPTIONS_BAR_ICONFILE6"] = "預設(透明黑白)"
L["STRING_OPTIONS_BAR_SPACING"] = "間距"
L["STRING_OPTIONS_BAR_SPACING_DESC"] = "每個計量條的間距"
L["STRING_OPTIONS_BAR_TEXTURE_DESC"] = "使用在頂部計量條的材質"
L["STRING_OPTIONS_BARLEFTTEXTCUSTOM"] = "可自定文字"
L["STRING_OPTIONS_BARLEFTTEXTCUSTOM_DESC"] = "當啟用時，以方框中的規則格式化左邊的文字"
--Translation missing 
-- L["STRING_OPTIONS_BARLEFTTEXTCUSTOM2"] = ""
L["STRING_OPTIONS_BARLEFTTEXTCUSTOM2_DESC"] = [=[|cFFFFFF00{資料1}|r: 通常代表了玩家的位置編號。

|cFFFFFF00{資料2}|r: 總是玩家名字。

|cFFFFFF00{資料3}|r: 在某些情況下，此值代表玩家的聲望或角色標誌。

|cFFFFFF00{func}|r: 執行一個自定義的Lua函數來增加回傳值到語法中。
例如: 
{func return 'hello azeroth'}

|cFFFFFF00跳脫序列|r: 用它來改變顏色或加入材質。搜尋“UI跳脫序列”以獲取更多資訊。]=]
L["STRING_OPTIONS_BARORIENTATION"] = "計量條方向"
L["STRING_OPTIONS_BARORIENTATION_DESC"] = "計量條往哪個方向填滿。"
L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM"] = "啟用自定義文字"
L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM_DESC"] = "當啟用時，以方框中的規則格式化右邊的文字"
--Translation missing 
-- L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM2"] = ""
L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM2_DESC"] = [=[|cFFFFFF00{資料1}|r: 第一次數據測試，通常表示此數據已完成。

|cFFFFFF00{資料2}|r: 第二次數據測試，大多時候通常代表每秒平均。

|cFFFFFF00{資料3}|r: 第三次數據測試，正常就是百分比。 

|cFFFFFF00{func}|r: 執行一個自定義的Lua函數來增加回傳值到語法中。
Example: 
{func return 'hello azeroth'}

|cFFFFFF00跳脫序列|r: 用它來改變顏色或加入材質。搜尋“UI跳脫序列”以獲取更多資訊。]=]
L["STRING_OPTIONS_BARS"] = "一般計量條設定"
L["STRING_OPTIONS_BARS_CUSTOM_TEXTURE"] = "自訂材質檔案"
L["STRING_OPTIONS_BARS_CUSTOM_TEXTURE_DESC"] = "|cFFFFFF00Important|r: 圖片必須為256x32像素。"
L["STRING_OPTIONS_BARS_DESC"] = "這些選項設定計量條外觀"
L["STRING_OPTIONS_BARSORT"] = "計量條排序"
L["STRING_OPTIONS_BARSORT_DESC"] = "遞增或是遞減計量條排序。"
L["STRING_OPTIONS_BARSTART"] = "計量條在圖示之後"
L["STRING_OPTIONS_BARSTART_DESC"] = [=[讓頂部材質一開始出現在圖標的左邊而不是右邊
使用帶有透明區域的圖標集時，這是非常有用的]=]
L["STRING_OPTIONS_BARUR_ANCHOR"] = "快速更新:"
L["STRING_OPTIONS_BARUR_DESC"] = "當啟用以後，DPS與HPS值會更新的比一般要快一點。"
L["STRING_OPTIONS_BG_ALL_ALLY"] = "顯示全部"
L["STRING_OPTIONS_BG_ALL_ALLY_DESC"] = [=[當啟用時，敵方玩家也會顯示在隊伍模式中。
|cFFFFFF00重要|r: 改變會在下次進入戰鬥時套用。]=]
L["STRING_OPTIONS_BG_ANCHOR"] = "戰場:"
L["STRING_OPTIONS_BG_REMOTE_PARSER"] = "智慧計分"
L["STRING_OPTIONS_BG_REMOTE_PARSER_DESC"] = "當啟用時，傷害和治療會同步在計分板。"
L["STRING_OPTIONS_CAURAS"] = "獲得光環"
L["STRING_OPTIONS_CAURAS_DESC"] = [=[啟用獲得:

- |cFFFFFF00增益持續時間|r
- |cFFFFFF00减益持續時間|r
- |cFFFFFF00空白區|r
-|cFFFFFF00 冷卻|r]=]
L["STRING_OPTIONS_CDAMAGE"] = "獲得傷害"
L["STRING_OPTIONS_CDAMAGE_DESC"] = [=[啟用獲得:

- |cFFFFFF00造成傷害|r
- |cFFFFFF00每秒傷害|r
- |cFFFFFF00隊友誤傷|r
- |cFFFFFF00承受傷害|r]=]
L["STRING_OPTIONS_CENERGY"] = "獲得能源"
L["STRING_OPTIONS_CENERGY_DESC"] = [=[啟用獲得:

- |cFFFFFF00法力恢復|r
- |cFFFFFF00怒氣生成|r
- |cFFFFFF00能量生成|r
- |cFFFFFF00符文能量生成|r]=]
L["STRING_OPTIONS_CHANGE_CLASSCOLORS"] = "修改職業顏色"
L["STRING_OPTIONS_CHANGE_CLASSCOLORS_DESC"] = "選擇職業的新顏色。"
L["STRING_OPTIONS_CHANGELOG"] = "版本註釋"
L["STRING_OPTIONS_CHART_ADD"] = "增加數據"
L["STRING_OPTIONS_CHART_ADD2"] = "增加"
L["STRING_OPTIONS_CHART_ADDAUTHOR"] = "作者:"
L["STRING_OPTIONS_CHART_ADDCODE"] = "編碼:"
L["STRING_OPTIONS_CHART_ADDICON"] = "圖標:"
L["STRING_OPTIONS_CHART_ADDNAME"] = "名子:"
L["STRING_OPTIONS_CHART_ADDVERSION"] = "版本:"
L["STRING_OPTIONS_CHART_AUTHOR"] = "作者"
L["STRING_OPTIONS_CHART_AUTHORERROR"] = "作者名稱無效"
L["STRING_OPTIONS_CHART_CANCEL"] = "刪除"
L["STRING_OPTIONS_CHART_CLOSE"] = "關閉"
L["STRING_OPTIONS_CHART_CODELOADED"] = "編碼已被載入但無法顯示"
L["STRING_OPTIONS_CHART_EDIT"] = "編輯編碼"
L["STRING_OPTIONS_CHART_EXPORT"] = "匯出"
L["STRING_OPTIONS_CHART_FUNCERROR"] = "無效的功能"
L["STRING_OPTIONS_CHART_ICON"] = "圖標"
L["STRING_OPTIONS_CHART_IMPORT"] = "匯入"
L["STRING_OPTIONS_CHART_IMPORTERROR"] = "無效的匯入字串"
L["STRING_OPTIONS_CHART_NAME"] = "名稱"
L["STRING_OPTIONS_CHART_NAMEERROR"] = "無效的名稱"
L["STRING_OPTIONS_CHART_PLUGINWARNING"] = "載入圖表視窗顯示自訂圖表"
L["STRING_OPTIONS_CHART_REMOVE"] = "移除"
L["STRING_OPTIONS_CHART_SAVE"] = "儲存"
L["STRING_OPTIONS_CHART_VERSION"] = "版本"
L["STRING_OPTIONS_CHART_VERSIONERROR"] = "版本無效"
L["STRING_OPTIONS_CHEAL"] = "獲得治療"
L["STRING_OPTIONS_CHEAL_DESC"] = [=[啟用獲得:

- |cFFFFFF00造成治療|r
- |cFFFFFF00吸收|r
- |cFFFFFF00每秒治療|r
- |cFFFFFF00過量治療|r
- |cFFFFFF00承受治療|r
- |cFFFFFF00敵方治療|r
- |cFFFFFF00減傷|r]=]
L["STRING_OPTIONS_CLASSCOLOR_MODIFY"] = "修改職業顏色"
L["STRING_OPTIONS_CLASSCOLOR_RESET"] = "右點擊重置"
L["STRING_OPTIONS_CLEANUP"] = "自動刪除垃圾片段"
L["STRING_OPTIONS_CLEANUP_DESC"] = "當啟用時，超出兩個片段後，垃圾片段會被自動移除"
L["STRING_OPTIONS_CLICK_TO_OPEN_MENUS"] = "點擊開啟選單"
L["STRING_OPTIONS_CLICK_TO_OPEN_MENUS_DESC"] = [=[當懸停在標題條按鈕不會顯示他們的選單。
反而你需要點擊按鈕去開啟。]=]
L["STRING_OPTIONS_CLOUD"] = "雲端捕獲"
L["STRING_OPTIONS_CLOUD_DESC"] = "當啟用時，停用收集者的資料而收集其他團隊成員。"
L["STRING_OPTIONS_CMISC"] = "收集雜項"
L["STRING_OPTIONS_CMISC_DESC"] = [=[啟用捕獲：

- |cFFFFFF00打破控場|r
- |cFFFFFF00驅散|r
- |cFFFFFF00中斷|r
- |cFFFFFF00復生|r
- |cFFFFFF00死亡|r]=]
L["STRING_OPTIONS_COLORANDALPHA"] = "顏色和透明度"
L["STRING_OPTIONS_COLORFIXED"] = "固定顏色"
L["STRING_OPTIONS_COMBAT_ALPHA"] = "當"
L["STRING_OPTIONS_COMBAT_ALPHA_1"] = "None"
L["STRING_OPTIONS_COMBAT_ALPHA_2"] = "戰鬥中"
L["STRING_OPTIONS_COMBAT_ALPHA_3"] = "脫離戰鬥"
L["STRING_OPTIONS_COMBAT_ALPHA_4"] = "不在隊伍"
L["STRING_OPTIONS_COMBAT_ALPHA_5"] = "當不在副本時"
L["STRING_OPTIONS_COMBAT_ALPHA_6"] = "當在副本時"
L["STRING_OPTIONS_COMBAT_ALPHA_7"] = "團隊除錯"
L["STRING_OPTIONS_COMBAT_ALPHA_DESC"] = [=[選擇戰鬥時的視窗透明度

|cFFFFFF00不變|r: 不修改透明度。

|cFFFFFF00戰鬥中|r: 當進入戰鬥時，顯示在視窗上的效果

|cFFFFFF00脫離戰鬥|r: 只要是在非戰鬥中的視窗效果

|cFFFFFF00離開隊伍|r: 當不在團隊或隊伍中,所顯示的視窗效果

|cFFFFFF00重要|r: 自動透明度功能會覆蓋目前的設定]=]
L["STRING_OPTIONS_COMBATTWEEKS"] = "戰鬥微調"
L["STRING_OPTIONS_COMBATTWEEKS_DESC"] = "設定Details!如何調整一些戰鬥數據的細節。"
L["STRING_OPTIONS_CONFIRM_ERASE"] = "您想要刪除數據嗎？"
L["STRING_OPTIONS_CUSTOMSPELL_ADD"] = "增加技能"
L["STRING_OPTIONS_CUSTOMSPELLTITLE"] = "編輯技能設定"
L["STRING_OPTIONS_CUSTOMSPELLTITLE_DESC"] = "這面板允許你修改技能名稱跟圖示"
L["STRING_OPTIONS_DATABROKER"] = "Data Broker:"
L["STRING_OPTIONS_DATABROKER_TEXT"] = "文字"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD1"] = "玩家造成傷害"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD2"] = "玩家造成每秒傷害"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD3"] = "傷害位置"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD4"] = "傷害差距"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD5"] = "玩家造成治療"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD6"] = "玩家造成每秒治療"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD7"] = "治療位置"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD8"] = "治療差距"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD9"] = "經過戰鬥時間"
L["STRING_OPTIONS_DATABROKER_TEXT1_DESC"] = [=[|cFFFFFF00{dmg}|r: 玩家造成傷害。

|cFFFFFF00{dps}|r: 玩家造成每秒傷害。

|cFFFFFF00{dpos}|r: 排序團隊或隊伍成員的傷害排名。

|cFFFFFF00{ddiff}|r: 你和第一名的傷害差距。

|cFFFFFF00{heal}|r: 玩家造成治療。

|cFFFFFF00{hps}|r: 玩家造成每秒治療。

|cFFFFFF00{hpos}|r: 排序團隊或隊伍成員的治療排名。

|cFFFFFF00{hdiff}|r: 你和第一名的治療差距。

|cFFFFFF00{time}|r: 經過戰鬥時間。]=]
L["STRING_OPTIONS_DATACHARTTITLE"] = "建立定時數據的圖表"
L["STRING_OPTIONS_DATACHARTTITLE_DESC"] = "這面板允許你增加創建圖表的自訂資料"
L["STRING_OPTIONS_DATACOLLECT_ANCHOR"] = "資料形式:"
L["STRING_OPTIONS_DEATHLIMIT"] = "死亡事件數量"
L["STRING_OPTIONS_DEATHLIMIT_DESC"] = [=[設定死亡顯示的事件數量。

|cFFFFFF00重要|r: 只套用在變更過後新的死亡。]=]
L["STRING_OPTIONS_DESATURATE_MENU"] = "降低飽和度"
L["STRING_OPTIONS_DESATURATE_MENU_DESC"] = "啟用這個選項，所有工具列上的選單圖標會變成黑跟白"
L["STRING_OPTIONS_DISABLE_ALLDISPLAYSWINDOW"] = [=[關閉'全部顯示'選單
選單面板->標題列:一般->關閉全部顯示選單且打開書籤]=]
--Translation missing 
-- L["STRING_OPTIONS_DISABLE_ALLDISPLAYSWINDOW_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DISABLE_BARHIGHLIGHT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DISABLE_BARHIGHLIGHT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DISABLE_GROUPS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DISABLE_GROUPS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DISABLE_LOCK_RESIZE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DISABLE_LOCK_RESIZE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DISABLE_RESET"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DISABLE_RESET_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DISABLE_STRETCH_BUTTON"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DISABLE_STRETCH_BUTTON_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DISABLED_RESET"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DTAKEN_EVERYTHING"] = ""
--Translation missing 
-- L["STRING_OPTIONS_DTAKEN_EVERYTHING_DESC"] = ""
L["STRING_OPTIONS_ED"] = "刪除數據"
L["STRING_OPTIONS_ED_DESC"] = [=[|cFFFFFF00手動|r: 使用者需要點擊重置按鈕。

|cFFFFFF00提示|r: 進入新副本時詢問是否重置。

|cFFFFFF00自動|r: 進入新副本時清除數據。]=]
L["STRING_OPTIONS_ED1"] = "手動"
L["STRING_OPTIONS_ED2"] = "提示"
L["STRING_OPTIONS_ED3"] = "自動"
L["STRING_OPTIONS_EDITIMAGE"] = "編輯圖片"
L["STRING_OPTIONS_EDITINSTANCE"] = "編輯視窗:"
L["STRING_OPTIONS_ERASECHARTDATA"] = "刪除圖表"
L["STRING_OPTIONS_ERASECHARTDATA_DESC"] = "登出時，所有戰鬥中收集的圖表資料會被刪除"
L["STRING_OPTIONS_EXTERNALS_TITLE"] = "外部小工具"
L["STRING_OPTIONS_EXTERNALS_TITLE2"] = "這些選項控制許多外部小工具的作用"
L["STRING_OPTIONS_GENERAL"] = "一般設定"
L["STRING_OPTIONS_GENERAL_ANCHOR"] = "一般:"
L["STRING_OPTIONS_HIDE_ICON"] = "隱藏圖標"
L["STRING_OPTIONS_HIDE_ICON_DESC"] = [=[當啟用時，不顯示目前所選擇的圖標

|cFFFFFF00重要|r: 啟用圖標後，强烈建議調整標題文字的位置]=]
L["STRING_OPTIONS_HIDECOMBATALPHA_DESC"] = [=[你的角色符合對應的規則時改變透明度

|cFFFFFF00無|r: 完全隱藏，無法在視窗內動作。

|cFFFFFF001 - 100|r: 不隐藏，您可以在視窗內改變透明度]=]
L["STRING_OPTIONS_HOTCORNER"] = "顯示按鈕"
L["STRING_OPTIONS_HOTCORNER_ACTION"] = "左鍵點擊"
L["STRING_OPTIONS_HOTCORNER_ACTION_DESC"] = "當左鍵點擊後選擇Hotcorner bar要做甚麼"
L["STRING_OPTIONS_HOTCORNER_ANCHOR"] = "Hotcorner:"
L["STRING_OPTIONS_HOTCORNER_DESC"] = "顯示或隱藏Hotcorner面板的按鈕"
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK"] = "啟用快速點擊"
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK_DESC"] = [=[啟用或禁用Hotcorners快速點擊功能

Quick button is localized at the further top left pixel，並從任一處移動你的滑鼠到這, 點擊後設定左上角的動作將可被執行]=]
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK_FUNC"] = "Quick Click On Click"
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK_FUNC_DESC"] = "當Hotcorner的快速按钮被點擊時選擇做甚麼"
--Translation missing 
-- L["STRING_OPTIONS_IGNORENICKNAME"] = ""
--Translation missing 
-- L["STRING_OPTIONS_IGNORENICKNAME_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_ILVL_TRACKER"] = ""
--Translation missing 
-- L["STRING_OPTIONS_ILVL_TRACKER_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_ILVL_TRACKER_TEXT"] = ""
L["STRING_OPTIONS_INSTANCE_ALPHA2"] = "背景顏色"
L["STRING_OPTIONS_INSTANCE_ALPHA2_DESC"] = "這選項可讓你改變時窗背景顏色"
L["STRING_OPTIONS_INSTANCE_BACKDROP"] = "背景紋理"
L["STRING_OPTIONS_INSTANCE_BACKDROP_DESC"] = "選擇這個視窗使用的背景紋理"
L["STRING_OPTIONS_INSTANCE_COLOR"] = "視窗顏色"
L["STRING_OPTIONS_INSTANCE_COLOR_DESC"] = [=[變更視窗的顏色和透明度

|cFFFFFF00重要|r: 這裡選擇的透明值會被複寫，當|cFFFFFF00Auto Transparency|r 值啟用時

|cFFFFFF00重要|r:  選擇的窗口颜色會覆盖任何自訂的狀態欄]=]
L["STRING_OPTIONS_INSTANCE_CURRENT"] = "自動轉換到目前"
L["STRING_OPTIONS_INSTANCE_CURRENT_DESC"] = "不管何時進入戰鬥，這個視窗會自動切換到目前的片段"
--Translation missing 
-- L["STRING_OPTIONS_INSTANCE_DELETE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_INSTANCE_DELETE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_INSTANCE_SKIN"] = ""
--Translation missing 
-- L["STRING_OPTIONS_INSTANCE_SKIN_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_INSTANCE_STATUSBAR_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_INSTANCE_STATUSBARCOLOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_INSTANCE_STATUSBARCOLOR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_INSTANCE_STRATA"] = ""
--Translation missing 
-- L["STRING_OPTIONS_INSTANCE_STRATA_DESC"] = ""
L["STRING_OPTIONS_INSTANCES"] = "視窗:"
--Translation missing 
-- L["STRING_OPTIONS_INTERFACEDIT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_LEFT_MENU_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_LOCKSEGMENTS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_LOCKSEGMENTS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MANAGE_BOOKMARKS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MAXINSTANCES"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MAXINSTANCES_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MAXSEGMENTS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MAXSEGMENTS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ALPHA"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ALPHAENABLED_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ALPHAENTER"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ALPHAENTER_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ALPHALEAVE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ALPHALEAVE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ALPHAWARNING"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ANCHOR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORX"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORX_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORY"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORY_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_ENABLED_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_ENCOUNTERTIMER"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_ENCOUNTERTIMER_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_FONT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_FONT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_SHADOW_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_SIDE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_SIDE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTCOLOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTCOLOR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTSIZE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTSIZE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_ATTRIBUTESETTINGS_ANCHOR"] = ""
L["STRING_OPTIONS_MENU_AUTOHIDE_DESC"] = "當滑鼠經過或離開視窗時會自動顯現或隱藏按鈕"
--Translation missing 
-- L["STRING_OPTIONS_MENU_AUTOHIDE_LEFT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_BUTTONSSIZE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_FONT_FACE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_FONT_FACE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_FONT_SIZE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_FONT_SIZE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_IGNOREBARS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_IGNOREBARS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_SHOWBUTTONS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_SHOWBUTTONS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_X"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_X_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_Y"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENU_Y_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENUS_SHADOW"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENUS_SHADOW_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENUS_SPACEMENT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MENUS_SPACEMENT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MICRODISPLAY_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MICRODISPLAY_LOCK"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MICRODISPLAY_LOCK_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MICRODISPLAYS_DROPDOWN_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MICRODISPLAYS_OPTION_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MICRODISPLAYS_SHOWHIDE_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MICRODISPLAYS_WARNING"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MICRODISPLAYSSIDE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MICRODISPLAYSSIDE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MICRODISPLAYWARNING"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MINIMAP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MINIMAP_ACTION"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MINIMAP_ACTION_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MINIMAP_ACTION1"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MINIMAP_ACTION2"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MINIMAP_ACTION3"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MINIMAP_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MINIMAP_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MISCTITLE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_MISCTITLE2"] = ""
--Translation missing 
-- L["STRING_OPTIONS_NICKNAME"] = ""
--Translation missing 
-- L["STRING_OPTIONS_NICKNAME_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OPEN_ROWTEXT_EDITOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OPEN_TEXT_EDITOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_ALL"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_ALL_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_CHALLENGE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_CHALLENGE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_DUNGEONBOSS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_DUNGEONBOSS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_DUNGEONCLEAN"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_DUNGEONCLEAN_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_LOGOFF"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_LOGOFF_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_NEWBOSS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_NEWBOSS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_RAIDBOSS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_RAIDBOSS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_RAIDCLEAN"] = ""
--Translation missing 
-- L["STRING_OPTIONS_OVERALL_RAIDCLEAN_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PANIMODE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PANIMODE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PDW_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PDW_SKIN_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERCENT_TYPE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERCENT_TYPE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_ARENA"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_BG15"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_BG40"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_DUNGEON"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_ENABLE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_ERASEWORLD"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_ERASEWORLD_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_MYTHIC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_PROFILE_LOAD"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_RAID15"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_RAID30"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_RF"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_TYPES"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE_TYPES_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE1"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCE1_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCECAPTURES"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCECAPTURES_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PERFORMANCEPROFILES_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PICONS_DIRECTION"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PICONS_DIRECTION_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PLUGINS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PLUGINS_AUTHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PLUGINS_NAME"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PLUGINS_OPTIONS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PLUGINS_RAID_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PLUGINS_SOLO_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PLUGINS_TOOLBAR_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PLUGINS_VERSION"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PRESETNONAME"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PRESETTOOLD"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_COPYOKEY"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_FIELDEMPTY"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_GLOBAL"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_LOADED"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_NOTCREATED"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_OVERWRITTEN"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_POSSIZE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_POSSIZE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_REMOVEOKEY"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_SELECT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_SELECTEXISTING"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILE_USENEW"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_COPY"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_COPY_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_CREATE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_CREATE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_CURRENT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_CURRENT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_ERASE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_ERASE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_RESET"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_RESET_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_SELECT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_SELECT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_TITLE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PROFILES_TITLE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PS_ABBREVIATE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PS_ABBREVIATE_COMMA"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PS_ABBREVIATE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PS_ABBREVIATE_NONE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PS_ABBREVIATE_TOK"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PS_ABBREVIATE_TOK0"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PS_ABBREVIATE_TOK0MIN"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PS_ABBREVIATE_TOK2"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PS_ABBREVIATE_TOK2MIN"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PS_ABBREVIATE_TOKMIN"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PVPFRAGS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_PVPFRAGS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_REALMNAME"] = ""
--Translation missing 
-- L["STRING_OPTIONS_REALMNAME_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_REPORT_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_REPORT_HEALLINKS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_REPORT_HEALLINKS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_REPORT_SCHEMA"] = ""
--Translation missing 
-- L["STRING_OPTIONS_REPORT_SCHEMA_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_REPORT_SCHEMA1"] = ""
--Translation missing 
-- L["STRING_OPTIONS_REPORT_SCHEMA2"] = ""
--Translation missing 
-- L["STRING_OPTIONS_REPORT_SCHEMA3"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RESET_TO_DEFAULT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_ROW_SETTING_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_ROWADV_TITLE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_ROWADV_TITLE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_COOLDOWN1"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_COOLDOWN2"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_COOLDOWNS_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_COOLDOWNS_CHANNEL"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_COOLDOWNS_CHANNEL_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_COOLDOWNS_CUSTOM"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_COOLDOWNS_CUSTOM_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_COOLDOWNS_ONOFF_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_COOLDOWNS_SELECT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_COOLDOWNS_SELECT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATH_MSG"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATHS_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATHS_FIRST"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATHS_FIRST_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATHS_HITS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATHS_HITS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATHS_ONOFF_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATHS_WHERE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATHS_WHERE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATHS_WHERE1"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATHS_WHERE2"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_DEATHS_WHERE3"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_FIRST_HIT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_FIRST_HIT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_IGNORE_TITLE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INFOS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INFOS_PREPOTION"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INFOS_PREPOTION_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INTERRUPT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INTERRUPT_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INTERRUPT_NEXT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INTERRUPTS_CHANNEL"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INTERRUPTS_CHANNEL_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INTERRUPTS_CUSTOM"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INTERRUPTS_CUSTOM_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INTERRUPTS_NEXT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INTERRUPTS_NEXT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INTERRUPTS_ONOFF_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_INTERRUPTS_WHISPER"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_OTHER_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_TITLE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_RT_TITLE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_APPLYALL"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_APPLYALL_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_APPLYTOALL"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_CREATE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_ERASE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_EXPORT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_EXPORT_COPY"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_EXPORT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_IMPORT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_IMPORT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_IMPORT_OKEY"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_LOAD"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_LOAD_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_MAKEDEFAULT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_PNAME"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_REMOVE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_RESET"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_SAVE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_SKINCREATED"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_STD_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SAVELOAD_STDSAVE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SCROLLBAR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SCROLLBAR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SEGMENTSSAVE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SEGMENTSSAVE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SENDFEEDBACK"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SHOW_SIDEBARS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SHOW_SIDEBARS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SHOW_STATUSBAR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SHOW_STATUSBAR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SHOW_TOTALBAR_COLOR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SHOW_TOTALBAR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SHOW_TOTALBAR_ICON"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SHOW_TOTALBAR_ICON_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SHOW_TOTALBAR_INGROUP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SHOW_TOTALBAR_INGROUP_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SIZE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_A"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_A_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_ELVUI_BUTTON1"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_ELVUI_BUTTON1_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_ELVUI_BUTTON2"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_ELVUI_BUTTON2_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_EXTRA_OPTIONS_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_LOADED"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_PRESETS_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_REMOVED"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_RESET_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_RESET_TOOLTIP_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_SELECT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SKIN_SELECT_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SOCIAL"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SOCIAL_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_ADD"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_ADDICON"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_ADDNAME"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_ADDSPELL"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_ADDSPELLID"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_CLOSE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_ICON"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_IDERROR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_INDEX"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_NAME"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_NAMEERROR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_NOTFOUND"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_REMOVE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_RESET"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_SPELLID"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SPELL_SPELLID_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_STRETCH"] = ""
--Translation missing 
-- L["STRING_OPTIONS_STRETCH_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_STRETCHTOP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_STRETCHTOP_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SWITCH_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_SWITCHINFO"] = ""
L["STRING_OPTIONS_TABEMB_ANCHOR"] = "嵌入對話標籤"
L["STRING_OPTIONS_TABEMB_ENABLED_DESC"] = "當勾選時，一個或多數視窗會附著於聊天標籤"
L["STRING_OPTIONS_TABEMB_SINGLE"] = "單一視窗"
L["STRING_OPTIONS_TABEMB_SINGLE_DESC"] = "當勾選，僅會附著一個視窗"
L["STRING_OPTIONS_TABEMB_TABNAME"] = "標籤名稱"
L["STRING_OPTIONS_TABEMB_TABNAME_DESC"] = "視窗將會附著於這個標籤名稱"
--Translation missing 
-- L["STRING_OPTIONS_TESTBARS"] = ""
L["STRING_OPTIONS_TEXT"] = "列文字設定"
--Translation missing 
-- L["STRING_OPTIONS_TEXT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_FIXEDCOLOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_FIXEDCOLOR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_FONT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_FONT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_LCLASSCOLOR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_LEFT_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_LOUTILINE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_LOUTILINE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_LPOSITION"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_LPOSITION_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_RIGHT_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_ROUTILINE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_ROWICONS_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SHOW_BRACKET"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SHOW_BRACKET_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SHOW_PERCENT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SHOW_PERCENT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SHOW_PS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SHOW_PS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SHOW_SEPARATOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SHOW_SEPARATOR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SHOW_TOTAL"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SHOW_TOTAL_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SIZE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_SIZE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_TEXTUREL_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXT_TEXTUREU_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_CANCEL"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_CANCEL_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_COLOR_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_COMMA"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_COMMA_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_DATA"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_DATA_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_DONE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_DONE_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_FUNC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_FUNC_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_RESET"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_RESET_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_TOK"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TEXTEDITOR_TOK_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TIMEMEASURE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TIMEMEASURE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLBAR_SETTINGS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLBAR_SETTINGS_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLBARSIDE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLBARSIDE_DESC"] = ""
L["STRING_OPTIONS_TOOLS_ANCHOR"] = "工具:"
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIP_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIP_ANCHORTEXTS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ABBREVIATION"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ABBREVIATION_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_ATTACH"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_ATTACH_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_BORDER"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_POINT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_RELATIVE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_RELATIVE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TEXT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TEXT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_CHOOSE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_CHOOSE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO1"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO2"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_ANCHORCOLOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_BACKGROUNDCOLOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_BACKGROUNDCOLOR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_BORDER_COLOR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_BORDER_SIZE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_BORDER_TEXTURE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_FONTCOLOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_FONTCOLOR_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_FONTFACE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_FONTFACE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_FONTSHADOW_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_FONTSIZE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_FONTSIZE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_IGNORESUBWALLPAPER"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_IGNORESUBWALLPAPER_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE1"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE2"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE3"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE4"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE5"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_MENU_WALLP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_MENU_WALLP_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_OFFSETX"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_OFFSETX_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_OFFSETY"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_OFFSETY_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_SHOWAMT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_SHOWAMT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_TITLE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOOLTIPS_TITLE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TOTALBAR_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TRASH_SUPPRESSION"] = ""
--Translation missing 
-- L["STRING_OPTIONS_TRASH_SUPPRESSION_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_ALPHA"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_BLUE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_CBOTTOM"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_CLEFT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_CRIGHT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_CTOP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_FILE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_GREEN"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_LOAD"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_LOAD_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_LOAD_EXCLAMATION"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_LOAD_FILENAME"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_LOAD_FILENAME_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_LOAD_OKEY"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_LOAD_TITLE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_LOAD_TROUBLESHOOT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_LOAD_TROUBLESHOOT_TEXT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WALLPAPER_RED"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_ANCHOR"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_BOOKMARK"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_BOOKMARK_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_CLOSE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_CLOSE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_CREATE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_CREATE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_LOCK"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_LOCK_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_REOPEN"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_UNLOCK"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_UNSNAP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WC_UNSNAP_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WHEEL_SPEED"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WHEEL_SPEED_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WINDOW"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WINDOW_ANCHOR_ANCHORS"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WINDOW_IGNOREMASSTOGGLE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WINDOW_IGNOREMASSTOGGLE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WINDOW_SCALE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WINDOW_SCALE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WINDOW_TITLE"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WINDOW_TITLE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WINDOWSPEED"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WINDOWSPEED_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WP_ALIGN"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WP_ALIGN_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WP_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WP_EDIT"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WP_EDIT_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WP_ENABLE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WP_GROUP"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WP_GROUP_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WP_GROUP2"] = ""
--Translation missing 
-- L["STRING_OPTIONS_WP_GROUP2_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_AUTOMATIC"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_AUTOMATIC_TITLE"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_AUTOMATIC_TITLE_DESC"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_COMBAT"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_DATACHART"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_DATACOLLECT"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_DATAFEED"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_DISPLAY"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_DISPLAY_DESC"] = ""
L["STRING_OPTIONSMENU_LEFTMENU"] = "標題列:一般"
--Translation missing 
-- L["STRING_OPTIONSMENU_MISC"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_PERFORMANCE"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_PLUGINS"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_PROFILES"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_RAIDTOOLS"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_RIGHTMENU"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_ROWMODELS"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_ROWSETTINGS"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_ROWTEXTS"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_SKIN"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_SPELLS"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_SPELLS_CONSOLIDATE"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_TITLETEXT"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_WALLPAPER"] = ""
--Translation missing 
-- L["STRING_OPTIONSMENU_WINDOW"] = ""
--Translation missing 
-- L["STRING_OVERALL"] = ""
--Translation missing 
-- L["STRING_OVERHEAL"] = ""
--Translation missing 
-- L["STRING_OVERHEALED"] = ""
--Translation missing 
-- L["STRING_PARRY"] = ""
--Translation missing 
-- L["STRING_PERCENTAGE"] = ""
--Translation missing 
-- L["STRING_PET"] = ""
--Translation missing 
-- L["STRING_PETS"] = ""
--Translation missing 
-- L["STRING_PLAYER_DETAILS"] = ""
--Translation missing 
-- L["STRING_PLAYERS"] = ""
--Translation missing 
-- L["STRING_PLEASE_WAIT"] = ""
--Translation missing 
-- L["STRING_PLUGIN_CLEAN"] = ""
--Translation missing 
-- L["STRING_PLUGIN_CLOCKNAME"] = ""
--Translation missing 
-- L["STRING_PLUGIN_CLOCKTYPE"] = ""
--Translation missing 
-- L["STRING_PLUGIN_DURABILITY"] = ""
--Translation missing 
-- L["STRING_PLUGIN_FPS"] = ""
--Translation missing 
-- L["STRING_PLUGIN_GOLD"] = ""
--Translation missing 
-- L["STRING_PLUGIN_LATENCY"] = ""
--Translation missing 
-- L["STRING_PLUGIN_MINSEC"] = ""
--Translation missing 
-- L["STRING_PLUGIN_NAMEALREADYTAKEN"] = ""
--Translation missing 
-- L["STRING_PLUGIN_PATTRIBUTENAME"] = ""
--Translation missing 
-- L["STRING_PLUGIN_PDPSNAME"] = ""
--Translation missing 
-- L["STRING_PLUGIN_PSEGMENTNAME"] = ""
--Translation missing 
-- L["STRING_PLUGIN_SECONLY"] = ""
--Translation missing 
-- L["STRING_PLUGIN_SEGMENTTYPE"] = ""
--Translation missing 
-- L["STRING_PLUGIN_SEGMENTTYPE_1"] = ""
--Translation missing 
-- L["STRING_PLUGIN_SEGMENTTYPE_2"] = ""
--Translation missing 
-- L["STRING_PLUGIN_SEGMENTTYPE_3"] = ""
--Translation missing 
-- L["STRING_PLUGIN_THREATNAME"] = ""
--Translation missing 
-- L["STRING_PLUGIN_TIME"] = ""
--Translation missing 
-- L["STRING_PLUGIN_TIMEDIFF"] = ""
--Translation missing 
-- L["STRING_PLUGIN_TOOLTIP_LEFTBUTTON"] = ""
--Translation missing 
-- L["STRING_PLUGIN_TOOLTIP_RIGHTBUTTON"] = ""
--Translation missing 
-- L["STRING_PLUGINOPTIONS_ABBREVIATE"] = ""
--Translation missing 
-- L["STRING_PLUGINOPTIONS_COMMA"] = ""
--Translation missing 
-- L["STRING_PLUGINOPTIONS_FONTFACE"] = ""
--Translation missing 
-- L["STRING_PLUGINOPTIONS_NOFORMAT"] = ""
--Translation missing 
-- L["STRING_PLUGINOPTIONS_TEXTALIGN"] = ""
--Translation missing 
-- L["STRING_PLUGINOPTIONS_TEXTALIGN_X"] = ""
--Translation missing 
-- L["STRING_PLUGINOPTIONS_TEXTALIGN_Y"] = ""
--Translation missing 
-- L["STRING_PLUGINOPTIONS_TEXTCOLOR"] = ""
--Translation missing 
-- L["STRING_PLUGINOPTIONS_TEXTSIZE"] = ""
--Translation missing 
-- L["STRING_PLUGINOPTIONS_TEXTSTYLE"] = ""
--Translation missing 
-- L["STRING_QUERY_INSPECT"] = ""
--Translation missing 
-- L["STRING_QUERY_INSPECT_FAIL1"] = ""
--Translation missing 
-- L["STRING_QUERY_INSPECT_TALENTS"] = ""
--Translation missing 
-- L["STRING_RAID_WIDE"] = ""
L["STRING_RAIDCHECK_PLUGIN_DESC"] = "當進入團隊副本時，在Details!的標題列顯示一個圖示表示精練、食物、預用藥水的使用狀態。"
L["STRING_RAIDCHECK_PLUGIN_NAME"] = "團隊確認"
--Translation missing 
-- L["STRING_REPORT"] = ""
--Translation missing 
-- L["STRING_REPORT_BUTTON_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_REPORT_FIGHT"] = ""
--Translation missing 
-- L["STRING_REPORT_FIGHTS"] = ""
--Translation missing 
-- L["STRING_REPORT_INVALIDTARGET"] = ""
--Translation missing 
-- L["STRING_REPORT_LAST"] = ""
--Translation missing 
-- L["STRING_REPORT_LASTFIGHT"] = ""
--Translation missing 
-- L["STRING_REPORT_LEFTCLICK"] = ""
--Translation missing 
-- L["STRING_REPORT_PREVIOUSFIGHTS"] = ""
--Translation missing 
-- L["STRING_REPORT_SINGLE_BUFFUPTIME"] = ""
--Translation missing 
-- L["STRING_REPORT_SINGLE_COOLDOWN"] = ""
--Translation missing 
-- L["STRING_REPORT_SINGLE_DEATH"] = ""
--Translation missing 
-- L["STRING_REPORT_SINGLE_DEBUFFUPTIME"] = ""
--Translation missing 
-- L["STRING_REPORT_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_COPY"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_CURRENT"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_CURRENTINFO"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_GUILD"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_INSERTNAME"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_LINES"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_OFFICERS"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_PARTY"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_RAID"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_REVERT"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_REVERTED"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_REVERTINFO"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_SAY"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_SEND"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_WHISPER"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_WHISPERTARGET"] = ""
--Translation missing 
-- L["STRING_REPORTFRAME_WINDOW_TITLE"] = ""
--Translation missing 
-- L["STRING_REPORTHISTORY"] = ""
--Translation missing 
-- L["STRING_RESISTED"] = ""
--Translation missing 
-- L["STRING_RESIZE_ALL"] = ""
--Translation missing 
-- L["STRING_RESIZE_COMMON"] = ""
--Translation missing 
-- L["STRING_RESIZE_HORIZONTAL"] = ""
--Translation missing 
-- L["STRING_RESIZE_VERTICAL"] = ""
--Translation missing 
-- L["STRING_RIGHT"] = ""
--Translation missing 
-- L["STRING_RIGHT_TO_LEFT"] = ""
--Translation missing 
-- L["STRING_RIGHTCLICK_CLOSE_LARGE"] = ""
--Translation missing 
-- L["STRING_RIGHTCLICK_CLOSE_MEDIUM"] = ""
--Translation missing 
-- L["STRING_RIGHTCLICK_CLOSE_SHORT"] = ""
--Translation missing 
-- L["STRING_RIGHTCLICK_TYPEVALUE"] = ""
--Translation missing 
-- L["STRING_SCORE_BEST"] = ""
--Translation missing 
-- L["STRING_SCORE_NOTBEST"] = ""
--Translation missing 
-- L["STRING_SEE_BELOW"] = ""
--Translation missing 
-- L["STRING_SEGMENT"] = ""
--Translation missing 
-- L["STRING_SEGMENT_EMPTY"] = ""
--Translation missing 
-- L["STRING_SEGMENT_END"] = ""
--Translation missing 
-- L["STRING_SEGMENT_ENEMY"] = ""
--Translation missing 
-- L["STRING_SEGMENT_LOWER"] = ""
--Translation missing 
-- L["STRING_SEGMENT_OVERALL"] = ""
--Translation missing 
-- L["STRING_SEGMENT_START"] = ""
--Translation missing 
-- L["STRING_SEGMENT_TIME"] = ""
--Translation missing 
-- L["STRING_SEGMENT_TRASH"] = ""
--Translation missing 
-- L["STRING_SEGMENTS"] = ""
--Translation missing 
-- L["STRING_SHIELD_HEAL"] = ""
--Translation missing 
-- L["STRING_SHIELD_OVERHEAL"] = ""
--Translation missing 
-- L["STRING_SHORTCUT_RIGHTCLICK"] = ""
--Translation missing 
-- L["STRING_SLASH_API_DESC"] = ""
--Translation missing 
-- L["STRING_SLASH_CAPTURE_DESC"] = ""
L["STRING_SLASH_CAPTUREOFF"] = "已關閉所有捕捉。"
--Translation missing 
-- L["STRING_SLASH_CAPTUREON"] = ""
--Translation missing 
-- L["STRING_SLASH_CHANGES"] = ""
--Translation missing 
-- L["STRING_SLASH_CHANGES_ALIAS1"] = ""
--Translation missing 
-- L["STRING_SLASH_CHANGES_ALIAS2"] = ""
--Translation missing 
-- L["STRING_SLASH_CHANGES_DESC"] = ""
--Translation missing 
-- L["STRING_SLASH_DISABLE"] = ""
--Translation missing 
-- L["STRING_SLASH_ENABLE"] = ""
--Translation missing 
-- L["STRING_SLASH_HIDE"] = ""
--Translation missing 
-- L["STRING_SLASH_HIDE_ALIAS1"] = ""
--Translation missing 
-- L["STRING_SLASH_HISTORY"] = ""
--Translation missing 
-- L["STRING_SLASH_NEW"] = ""
--Translation missing 
-- L["STRING_SLASH_NEW_DESC"] = ""
--Translation missing 
-- L["STRING_SLASH_OPTIONS"] = ""
--Translation missing 
-- L["STRING_SLASH_OPTIONS_DESC"] = ""
L["STRING_SLASH_RESET"] = "重置"
L["STRING_SLASH_RESET_ALIAS1"] = "清除"
L["STRING_SLASH_RESET_DESC"] = "清除所有片段"
--Translation missing 
-- L["STRING_SLASH_SHOW"] = ""
--Translation missing 
-- L["STRING_SLASH_SHOW_ALIAS1"] = ""
--Translation missing 
-- L["STRING_SLASH_SHOWHIDETOGGLE_DESC"] = ""
--Translation missing 
-- L["STRING_SLASH_TOGGLE"] = ""
--Translation missing 
-- L["STRING_SLASH_WIPE"] = ""
--Translation missing 
-- L["STRING_SLASH_WIPECONFIG"] = ""
--Translation missing 
-- L["STRING_SLASH_WIPECONFIG_CONFIRM"] = ""
--Translation missing 
-- L["STRING_SLASH_WIPECONFIG_DESC"] = ""
--Translation missing 
-- L["STRING_SLASH_WORLDBOSS"] = ""
--Translation missing 
-- L["STRING_SLASH_WORLDBOSS_DESC"] = ""
--Translation missing 
-- L["STRING_SPELL_INTERRUPTED"] = ""
--Translation missing 
-- L["STRING_SPELLS"] = ""
--Translation missing 
-- L["STRING_SPIRIT_LINK_TOTEM"] = ""
--Translation missing 
-- L["STRING_SPIRIT_LINK_TOTEM_DESC"] = ""
--Translation missing 
-- L["STRING_STATUSBAR_NOOPTIONS"] = ""
--Translation missing 
-- L["STRING_SWITCH_CLICKME"] = ""
--Translation missing 
-- L["STRING_SWITCH_SELECTMSG"] = ""
--Translation missing 
-- L["STRING_SWITCH_TO"] = ""
--Translation missing 
-- L["STRING_SWITCH_WARNING"] = ""
--Translation missing 
-- L["STRING_TARGET"] = ""
--Translation missing 
-- L["STRING_TARGETS"] = ""
--Translation missing 
-- L["STRING_TARGETS_OTHER1"] = ""
--Translation missing 
-- L["STRING_TEXTURE"] = ""
--Translation missing 
-- L["STRING_TIME_OF_DEATH"] = ""
--Translation missing 
-- L["STRING_TOOOLD"] = ""
--Translation missing 
-- L["STRING_TOP"] = ""
--Translation missing 
-- L["STRING_TOP_TO_BOTTOM"] = ""
--Translation missing 
-- L["STRING_TOTAL"] = ""
L["STRING_TRANSLATE_LANGUAGE"] = "幫助翻譯Details!"
--Translation missing 
-- L["STRING_TUTORIAL_FULLY_DELETE_WINDOW"] = ""
--Translation missing 
-- L["STRING_TUTORIAL_OVERALL1"] = ""
--Translation missing 
-- L["STRING_UNKNOW"] = ""
--Translation missing 
-- L["STRING_UNKNOWSPELL"] = ""
--Translation missing 
-- L["STRING_UNLOCK"] = ""
--Translation missing 
-- L["STRING_UNLOCK_WINDOW"] = ""
--Translation missing 
-- L["STRING_UPTADING"] = ""
--Translation missing 
-- L["STRING_VERSION_UPDATE"] = ""
--Translation missing 
-- L["STRING_VOIDZONE_TOOLTIP"] = ""
--Translation missing 
-- L["STRING_WAITPLUGIN"] = ""
L["STRING_WAVE"] = "波"
--Translation missing 
-- L["STRING_WELCOME_1"] = ""
--Translation missing 
-- L["STRING_WELCOME_11"] = ""
--Translation missing 
-- L["STRING_WELCOME_12"] = ""
--Translation missing 
-- L["STRING_WELCOME_13"] = ""
--Translation missing 
-- L["STRING_WELCOME_14"] = ""
--Translation missing 
-- L["STRING_WELCOME_15"] = ""
--Translation missing 
-- L["STRING_WELCOME_16"] = ""
--Translation missing 
-- L["STRING_WELCOME_17"] = ""
--Translation missing 
-- L["STRING_WELCOME_2"] = ""
--Translation missing 
-- L["STRING_WELCOME_26"] = ""
--Translation missing 
-- L["STRING_WELCOME_27"] = ""
--Translation missing 
-- L["STRING_WELCOME_28"] = ""
--Translation missing 
-- L["STRING_WELCOME_29"] = ""
--Translation missing 
-- L["STRING_WELCOME_3"] = ""
--Translation missing 
-- L["STRING_WELCOME_30"] = ""
--Translation missing 
-- L["STRING_WELCOME_31"] = ""
--Translation missing 
-- L["STRING_WELCOME_32"] = ""
--Translation missing 
-- L["STRING_WELCOME_34"] = ""
--Translation missing 
-- L["STRING_WELCOME_36"] = ""
--Translation missing 
-- L["STRING_WELCOME_38"] = ""
--Translation missing 
-- L["STRING_WELCOME_39"] = ""
--Translation missing 
-- L["STRING_WELCOME_4"] = ""
--Translation missing 
-- L["STRING_WELCOME_41"] = ""
--Translation missing 
-- L["STRING_WELCOME_42"] = ""
--Translation missing 
-- L["STRING_WELCOME_43"] = ""
--Translation missing 
-- L["STRING_WELCOME_44"] = ""
--Translation missing 
-- L["STRING_WELCOME_45"] = ""
--Translation missing 
-- L["STRING_WELCOME_46"] = ""
--Translation missing 
-- L["STRING_WELCOME_5"] = ""
--Translation missing 
-- L["STRING_WELCOME_57"] = ""
--Translation missing 
-- L["STRING_WELCOME_58"] = ""
--Translation missing 
-- L["STRING_WELCOME_59"] = ""
--Translation missing 
-- L["STRING_WELCOME_6"] = ""
--Translation missing 
-- L["STRING_WELCOME_60"] = ""
--Translation missing 
-- L["STRING_WELCOME_61"] = ""
--Translation missing 
-- L["STRING_WELCOME_62"] = ""
--Translation missing 
-- L["STRING_WELCOME_63"] = ""
--Translation missing 
-- L["STRING_WELCOME_64"] = ""
--Translation missing 
-- L["STRING_WELCOME_65"] = ""
--Translation missing 
-- L["STRING_WELCOME_66"] = ""
--Translation missing 
-- L["STRING_WELCOME_67"] = ""
--Translation missing 
-- L["STRING_WELCOME_68"] = ""
--Translation missing 
-- L["STRING_WELCOME_69"] = ""
--Translation missing 
-- L["STRING_WELCOME_7"] = ""
--Translation missing 
-- L["STRING_WELCOME_70"] = ""
--Translation missing 
-- L["STRING_WELCOME_71"] = ""
--Translation missing 
-- L["STRING_WELCOME_72"] = ""
--Translation missing 
-- L["STRING_WINDOW_NOTFOUND"] = ""
--Translation missing 
-- L["STRING_WINDOW_NUMBER"] = ""
--Translation missing 
-- L["STRING_WINDOW1ATACH_DESC"] = ""
--Translation missing 
-- L["STRING_WIPE_ALERT"] = ""
--Translation missing 
-- L["STRING_WIPE_ERROR1"] = ""
--Translation missing 
-- L["STRING_WIPE_ERROR2"] = ""
--Translation missing 
-- L["STRING_WIPE_ERROR3"] = ""
--Translation missing 
-- L["STRING_YES"] = ""

