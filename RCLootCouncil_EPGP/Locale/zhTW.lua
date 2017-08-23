-- Translate RCLootCouncil - EPGP to your language at:
-- http://wow.curseforge.com/addons/rclootcouncil-epgp/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("RCEPGP", "zhTW")
if not L then return end

L["gp_value_help"] = "例:\r\n100%: 使用100%GP值\r\n50%: 使用50%GP值\r\n25: 所有物品價值25GP"
L["enable_custom_gp"] = "啟用自定義GP"
L["formula_syntax_error"] = "公式有語法錯誤. 將使用默認公式."
L["restore_default"] = "恢復為預設"
L["slot_weights"] = "欄位權重"
L["formula_help"] = "在下面的輸入框輸入返回GP值的LUA代碼. 以下是代碼中可用的變量"
L["variable_ilvl_help"] = "整數.物品的裝備等級或者是套裝代幣的基礎裝等"
L["variable_isToken_help"] = "整數. 1如果物品是套裝代幣,否則為0."
L["variable_slotWeights_help"] = "數字. 物品的欄位權重."
L["variable_numSocket_help"] = "整數. 物品裡插槽的數量."
L["variable_hasAvoid_help"] = "整數. 1如果物品帶有迴避,否則為0."
L["variable_hasSpeed_help"] = "整數. 1如果物品帶有速度,否則為0."
L["variable_hasLeech_help"] = "整數. 1如果物品帶有汲取,否則為0."
L["variable_hasIndes_help"] = "整數. 1如果物品永不磨損,否則為0."
L["variable_rarity_help"] = "整數. 物品的稀有度. 3-精良,4-史詩,5-傳說."
L["variable_itemID_help"] = "整數. 物品的ID."
L["variable_equipLoc_help"] = "字符串. 代表欄位的非本地化字符串. 如果可能,建議使用變量slotWeights代替."
L["gp_formula"] = "GP公式"
L["Input must be a number."] = "輸入必須為數字."
L["disable_gp_popup"] = "GP彈窗被RCLootCouncil - EPGP自動禁用."
L["GP Bid"] = "GP出價"
L["Enable Bidding"] = "啟用拍賣"
L["Custom GP"] = "自定義GP"
L["bidding_desc"] = "玩家可以在RCLootCouncil彈窗中向戰利品分配者發送以整數開始的筆記以告知競標出價."
L["Bidding"] = "拍賣"