local addon = LibStub("AceAddon-3.0"):GetAddon("RCLootCouncil")
local RCEPGP = addon:NewModule("RCEPGP", "AceComm-3.0", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local EPGP = LibStub("AceAddon-3.0"):GetAddon("EPGP")
local GS = LibStub("LibGuildStorage-1.2")
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")
local LEP = LibStub("AceLocale-3.0"):GetLocale("RCEPGP")
local GP = LibStub("LibGearPoints-1.2")
local LibDialog = LibStub("LibDialog-1.0")
local RCLootCouncilML = addon:GetModule("RCLootCouncilML")

local ExtraUtilities = addon:GetModule("RCExtraUtilities", true) -- nil if ExtraUtilites not enabled.
local RCVotingFrame = addon:GetModule("RCVotingFrame")
local originalCols = {unpack(RCVotingFrame.scrollCols)}

local session = 1

function RCEPGP:OnInitialize()
   self.version = GetAddOnMetadata("RCLootCouncil_EPGP", "Version")
   self:Enable()
end

function RCEPGP.UpdateVotingFrame()
  RCVotingFrame:Update()
end

function RCEPGP:OnEnable()
   EPGP.RegisterCallback(self, "StandingsChanged",
                        RCEPGP.UpdateVotingFrame)

   addon:SecureHook(RCVotingFrame, "OnEnable", self.AddGPEditBox)
   addon:SecureHook(RCVotingFrame, "SwitchSession", function(_, s) session = s; RCEPGP:UpdateGPEditbox() end)
   Lib_UIDropDownMenu_Initialize(_G["RCLootCouncil_VotingFrame_RightclickMenu"], self.RightClickMenu, "MENU")
   if ExtraUtilities then
      addon:SecureHook(ExtraUtilities, "SetupColumns", function() self:SetupColumns() end)
      addon:SecureHook(ExtraUtilities, "UpdateColumn", function() self:SetupColumns() end)
   end
   self.DisableEPGPPopup()
   self:SecureHook(EPGP:GetModule("loot"), "OnEnable", self.DisableEPGPPopup)
   self:OptionsTable()
   self:AddGPOptions()
   self:RegisterMessage("RCGPRuleChanged", "UpdateGPEditbox")
   self:SetupColumns()
end

function RCEPGP:UpdateGPEditbox()
  local lootTable = RCVotingFrame:GetLootTable()
  if lootTable then
    local t = lootTable[session]
    if t then
      local gp = GP:GetValue(t.link) or 0
      RCVotingFrame.frame.editbox:SetNumber(gp)
    end
  end
end


function RCEPGP:OnDisable()
   -- Reset cols
   RCVotingFrame.scrollCols = originalCols
end

function RCEPGP.DisableEPGPPopup()
    if EPGP and EPGP.GetModule then
        local loot = EPGP:GetModule("loot")
        if loot and loot.db.profile.enabled then
        	RCEPGP:Print(LEP["disable_gp_popup"])
        end
        if loot and loot.db then
        	loot.db.profile.enabled = false
        end
        if loot and loot.Disable then
            loot:Disable()
        end
    end
end

local function RemoveColumn(t, column)
  for i=1, #t do
    if t[i] and t[i].colName == column.colName then
      table.remove(t, i)
    end
  end
end

local function ReinsertColumnAtTheEnd(t, column)
  RemoveColumn(t, column)
  table.insert(t, column)
end

function RCEPGP:SetupColumns()
   local ep =
   { name = "EP", DoCellUpdate = self.SetCellEP, colName = "ep", sortnext = self:GetScrollColIndexFromName("response"), width = 60, align = "CENTER", defaultsort = "dsc" }
   local gp =
   { name = "GP", DoCellUpdate = self.SetCellGP, colName = "gp", sortnext = self:GetScrollColIndexFromName("response"), width = 50, align = "CENTER", defaultsort = "dsc" }
   local pr =
   { name = "PR", DoCellUpdate = self.SetCellPR, colName = "pr", width = 50, align = "CENTER", comparesort = self.PRSort, defaultsort = "dsc" }
   local bid =
   { name = "Bid", DoCellUpdate = self.SetCellBid, colName = "bid", sortnext = self:GetScrollColIndexFromName("response"), width = 50, align = "CENTER",
     defaultsort = "dsc" }

   ReinsertColumnAtTheEnd(RCVotingFrame.scrollCols, ep)
   ReinsertColumnAtTheEnd(RCVotingFrame.scrollCols, gp)
   ReinsertColumnAtTheEnd(RCVotingFrame.scrollCols, pr)

   if addon:Getdb().epgp.biddingEnabled then
   	ReinsertColumnAtTheEnd(RCVotingFrame.scrollCols, bid)
   else
   	RemoveColumn(RCVotingFrame.scrollCols, bid)
   end

   RCEPGP:ResponseSortPRNext()

   if RCVotingFrame.frame then
      RCVotingFrame.frame.UpdateSt()
   end
end

function RCEPGP:GetScrollColIndexFromName(colName)
   for i,v in ipairs(RCVotingFrame.scrollCols) do
      if v.colName == colName then
         return i
      end
   end
end

function RCEPGP:ResponseSortPRNext()
  local responseIdx = self:GetScrollColIndexFromName("response")
  local prIdx = self:GetScrollColIndexFromName("pr")
  if responseIdx then
    RCVotingFrame.scrollCols[responseIdx].sortnext = prIdx
  end
end

---------------------------------------------
-- Lib-st UI functions
---------------------------------------------
-- Trying to fix some issue where RCLootCouncil handles some names differently with EPGP
-- EPGP requires fullname (name-realm) with the correct capitialization,
-- and realm name cannot contain space.
local function GetEPGPName(inputName)
  if not inputName then return nil end

  local name = Ambiguate(inputName, "short") -- Convert to short name to be used as the argument to UnitFullName
  local _, ourRealmName = UnitFullName("player") -- Get the name of our realm WITHOUT SPACE.

  local name, realm = UnitFullName(name)         -- In order to return a name with correct capitialization, and the realm name WITHOUT SPACE.
  if not name then
    return inputName
  else
    if realm and realm ~= "" then
      return name.."-"..realm
    else
      return name.."-"..ourRealmName
    end
  end
end

local COLOR_RED  = "|cFFFF0000"
local COLOR_GREY = "|cFF808080"

function RCEPGP.SetCellEP(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...)
    local name = data[realrow].name
    name = GetEPGPName(name)
    local ep, gp, main = EPGP:GetEPGP(name)
    if not ep then
      frame.text:SetText(COLOR_RED.."?")
    elseif ep >= EPGP.db.profile.min_ep then
      frame.text:SetText(COLOR_GREY..ep)
    else
      frame.text:SetText(COLOR_RED..ep)
    end
    data[realrow].cols[column].value = ep or 0
end

function RCEPGP.SetCellGP(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...)
    local name = data[realrow].name
    name = GetEPGPName(name)
    local ep, gp, main = EPGP:GetEPGP(name)
    if not gp then
      frame.text:SetText(COLOR_GREY.."?")
    else
      frame.text:SetText(COLOR_GREY..gp)
    end
    data[realrow].cols[column].value = gp or 0
end

function RCEPGP.SetCellPR(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...)
    local name = data[realrow].name
    name = GetEPGPName(name)
    local ep, gp, main = EPGP:GetEPGP(name)
    local pr
    if ep and gp then
        pr = ep / gp
    end

    if not pr then
      frame.text:SetText("?")
    else
      frame.text:SetText(string.format("%.4g", pr))
    end

    data[realrow].cols[column].value = pr or 0
end

function RCEPGP:GetBid(name)
	local lootTable = RCVotingFrame:GetLootTable()
	local note = lootTable[session].candidates[name].note
	if note then
		local bid = tonumber(string.match(note, "[0-9]+"))
		return bid
	end
end

function RCEPGP.SetCellBid(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...)
	local name = data[realrow].name
	local bid = RCEPGP:GetBid(name)
	if bid then
		frame.text:SetText(tostring(bid))
		data[realrow].cols[column].value = bid
	else
		data[realrow].cols[column].value = 0
		frame.text:SetText("")
	end
end

function RCEPGP.PRSort(table, rowa, rowb, sortbycol)
  local column = table.cols[sortbycol]
  local a, b = table:GetRow(rowa), table:GetRow(rowb);
  -- Extract the rank index from the name, fallback to 100 if not found

  local nameA = GetEPGPName(a.name)
  local nameB = GetEPGPName(b.name)

  local a_ep, a_gp = EPGP:GetEPGP(nameA)
  local b_ep, b_gp = EPGP:GetEPGP(nameB)

  if (not a_ep) or (not a_gp) then
    return false
  elseif (not b_ep) or (not b_gp) then
    return true
  end

  local a_pr = a_ep/a_gp
  local b_pr = b_ep/b_gp

  local a_qualifies = a_ep >= EPGP.db.profile.min_ep
  local b_qualifies = b_ep >= EPGP.db.profile.min_ep

  if a_qualifies == b_qualifies and a_pr == b_pr then
    if column.sortnext then
      local nextcol = table.cols[column.sortnext];
      if nextcol and not(nextcol.sort) then
        if nextcol.comparesort then
          return nextcol.comparesort(table, rowa, rowb, column.sortnext);
        else
          return table:CompareSort(rowa, rowb, column.sortnext);
        end
      end
    end
    return false
  else
    local direction = column.sort or column.defaultsort or "dsc";
    if direction:lower() == "asc" then
      if a_qualifies == b_qualifies then
        return a_pr < b_pr
      else
        return b_qualifies
      end
    else
      if a_qualifies == b_qualifies then
        return a_pr > b_pr
      else
        return a_qualifies
      end
    end
  end
end

----------------------------------------------------------------
function RCEPGP:AddGPEditBox()
  if not RCVotingFrame.frame.gpString then
      local gpstr = RCVotingFrame.frame.content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      gpstr:SetPoint("CENTER", RCVotingFrame.frame.content, "TOPLEFT", 300, -60)
      gpstr:SetText("GP: ")
      gpstr:Show()
      gpstr:SetTextColor(1, 1, 0, 1) -- Yellow
      RCVotingFrame.frame.gpString = gpstr
  end


  local editbox_name = "RCLootCouncil_GP_EditBox"
  if not RCVotingFrame.frame.editbox then
      local editbox = _G.CreateFrame("EditBox", editbox_name, RCVotingFrame.frame.content, "AutoCompleteEditBoxTemplate")
      editbox:SetWidth(32)
      editbox:SetHeight(32)
      editbox:SetFontObject("ChatFontNormal")
      editbox:SetNumeric(true)
      editbox:SetMaxLetters(4)
      editbox:SetAutoFocus(false)

      local left = editbox:CreateTexture(("%sLeft"):format(editbox_name), "BACKGROUND")
      left:SetTexture([[Interface\ChatFrame\UI-ChatInputBorder-Left2]])
      left:SetWidth(8)
      left:SetHeight(32)
      left:SetPoint("LEFT", -5, 0)

      local right = editbox:CreateTexture(("%sRight"):format(editbox_name), "BACKGROUND")
      right:SetTexture([[Interface\ChatFrame\UI-ChatInputBorder-Right2]])
      right:SetWidth(8)
      right:SetHeight(32)
      right:SetPoint("RIGHT", 5, 0)

      local mid = editbox:CreateTexture(("%sMid"):format(editbox_name), "BACKGROUND")
      mid:SetTexture([[Interface\ChatFrame\UI-ChatInputBorder-Mid2]])
      mid:SetHeight(32)
      mid:SetPoint("TOPLEFT", left, "TOPRIGHT", 0, 0)
      mid:SetPoint("TOPRIGHT", right, "TOPLEFT", 0, 0)

      --local label = editbox:CreateFontString(editbox_name, "ARTWORK", "GameFontNormalSmall")
      --label:SetPoint("RIGHT", editbox, "LEFT", - 15, 0)
      --label:Show()
      editbox.left = left
      editbox.right = right
      editbox.mid = mid
      --editbox.label = label

      editbox:SetPoint("LEFT", RCVotingFrame.frame.gpString, "RIGHT", 10, 0)
      editbox:Show()

      -- Auto release Focus after 3s editbox is not used
      local loseFocusTime = 3
      editbox:SetScript("OnEditFocusGained", function(self, userInput) self.lastUsedTime = GetTime() end)
      editbox:SetScript("OnTextChanged", function(self, userInput) RCVotingFrame:Update(); self.lastUsedTime = GetTime() end)
      editbox:SetScript("OnUpdate", function(self, elapsed) 
        if self.lastUsedTime and GetTime() - self.lastUsedTime > loseFocusTime then
          self.lastUsedTime = nil
          if editbox:HasFocus() then
            editbox:ClearFocus()
          end
        end
      end)
      RCVotingFrame.frame.editbox = editbox
  end
end

function RCEPGP:GetResponseGP(response, isTier)
  if response == "PASS" or response == "AUTOPASS" then
    return "0%"
  end
  local responseGP = "100%"

  local index = addon:GetResponseSort(response, isTier)
  if isTier and addon.mldb.tierButtonsEnabled then
    for k, v in pairs(addon.db.profile.tierButtons) do 
      if v.text == response then
        responseGP = v.gp or responseGP
        break
      elseif k == response then
        responseGP = v.gp or responseGP
        break
      end
    end
  else
    for k, v in pairs(addon.db.profile.responses) do 
      if v.text == response then
        responseGP = v.gp or responseGP
        break
      elseif k == response then
        responseGP = v.gp or responseGP
        break
      end
    end
  end
  return responseGP
end

function RCEPGP.RightClickMenu(menu, level)
  if not addon.isMasterLooter then return end
  local lootTable = RCVotingFrame:GetLootTable()
  local candidateName = menu.name
  local data = lootTable[session].candidates[candidateName]
  local responseGP = RCEPGP:GetResponseGP(data.response, data.isTier)

  local editboxGP = RCVotingFrame.frame.editbox:GetNumber()
  local gp
  if string.match(responseGP, "^%d+$") then
    gp = tonumber(responseGP)
  else -- responseGP is percentage like 55%
    local coeff = tonumber(string.match(responseGP, "%d+"))/100
    gp = math.floor(coeff * editboxGP)
  end

  if level == 1 then

  	if addon:Getdb().epgp.biddingEnabled and RCEPGP:GetBid(candidateName) then
	  	info = Lib_UIDropDownMenu_CreateInfo()
	  	local gp = RCEPGP:GetBid(candidateName)
	    info.text = L["Award"].." ("..gp.." "..LEP["GP Bid"]..")"
	    info.func = function()
	      LibDialog:Spawn("RCEPGP_CONFIRM_AWARD", {
	        session,
	        candidateName,
	        data.response,
	        nil,
	        data.votes,
	        data.gear1,
	        data.gear2,
	        data.isTier,
	        gp,
	        responseGP
	    }) end
	    info.notCheckable = true
	    info.disabled = false
	    local item = RCLootCouncilML.lootTable[session].link
	    if (not EPGP:CanIncGPBy(item, gp)) and gp and (gp ~= 0) then
	      info.disabled = true
	    end
	    Lib_UIDropDownMenu_AddButton(info, level)
  	end

    info = Lib_UIDropDownMenu_CreateInfo()
    info.text = L["Award"].." ("..gp.." GP)"
    if string.match(responseGP, "^%d+%%") then
      info.text = L["Award"].." ("..gp.." GP, "..responseGP..")"
    end
    info.func = function()
      LibDialog:Spawn("RCEPGP_CONFIRM_AWARD", {
        session,
        candidateName,
        data.response,
        nil,
        data.votes,
        data.gear1,
        data.gear2,
        data.isTier,
        gp,
        responseGP
    }) end
    info.notCheckable = true
    info.disabled = false
    local item = RCLootCouncilML.lootTable[session].link
    if (not EPGP:CanIncGPBy(item, gp)) and gp and (gp ~= 0) then
      info.disabled = true
    end
    Lib_UIDropDownMenu_AddButton(info, level)

    if RCVotingFrame.frame.editbox and RCVotingFrame.frame.editbox:HasFocus() then
      RCVotingFrame.frame.editbox:ClearFocus()
    end
  end
  RCVotingFrame.RightClickMenu(menu, level)
end


LibDialog:Register("RCEPGP_CONFIRM_AWARD", {
  text = "something_went_wrong",
  icon = "",
  on_show = function(self, data)
    local session, player, response, reason, votes, item1, item2, isTierRoll, gp, responseGP = unpack(data,1,10)
    self:SetFrameStrata("FULLSCREEN")
    local session, player = unpack(data)
    self.text:SetText(format(L["Are you sure you want to give #item to #player?"].." ("..gp.." GP)", RCLootCouncilML.lootTable[session].link, addon.Ambiguate(player)))
    if string.match(responseGP, "^%d+%%") then
        self.text:SetText(format(L["Are you sure you want to give #item to #player?"].." ("..gp.." GP, "..responseGP.."%"..")", RCLootCouncilML.lootTable[session].link, addon.Ambiguate(player)))
    end
    self.icon:SetTexture(RCLootCouncilML.lootTable[session].texture)
  end,
  buttons = {
    { text = L["Yes"],
      on_click = function(self, data)
        -- IDEA Perhaps come up with a better way of handling this
        local session, player, response, reason, votes, item1, item2, isTierRoll, gp,responseGP = unpack(data,1,9)
        local item = RCLootCouncilML.lootTable[session].link -- Store it now as we wipe lootTable after Award()
        local isToken = RCLootCouncilML.lootTable[session].token
        local awarded = RCLootCouncilML:Award(session, player, response, reason, isTierRoll)
        if awarded then -- log it
          RCLootCouncilML:TrackAndLogLoot(player, item, response, addon.target, votes, item1, item2, reason, isToken, isTierRoll)
          if gp and gp ~= 0 then
          	EPGP:IncGPBy(GetEPGPName(player), item, gp)
      	  end
        end
        -- We need to delay the test mode disabling so comms have a chance to be send first!
        if addon.testMode and RCLootCouncilML:HasAllItemsBeenAwarded() then RCLootCouncilML:EndSession() end
      end,
    },
    { text = L["No"],
    },
  },
  hide_on_escape = true,
  show_while_dead = true,
})

