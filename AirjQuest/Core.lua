local Core = LibStub("AceAddon-3.0"):NewAddon("AirjQuest", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
AirjQuest = Core

function Core:OnEnable()

  -- Quest

  self:SecureHook(QUEST_TRACKER_MODULE,"SetBlockHeader", function(frame,block, text, questLogIndex, isQuestComplete, questID)
    local partyMembersOnQuest = 0;
    for j=1, GetNumSubgroupMembers() do
      if ( IsUnitOnQuestByQuestID(questID, "party"..j) ) then
        partyMembersOnQuest = partyMembersOnQuest + 1;
      end
    end

    if ( partyMembersOnQuest > 0 ) then
      text = "|cff00ff00["..partyMembersOnQuest.."] |r"..text;
    end
  	local height = QUEST_TRACKER_MODULE:SetStringText(block.HeaderText, text, nil, OBJECTIVE_TRACKER_COLOR["Header"]);
  	block.height = height;
    -- print("SetBlockHeader",...)
	end)

  -- self:RegisterEvent("QUESTTASK_UPDATE")
  -- self:RegisterEvent("QUEST_WATCH_UPDATE")
  -- self:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
  -- self:RegisterEvent("QUEST_WATCH_OBJECTIVES_CHANGED")
	self:RegisterComm("AIRJQUEST_COMM")
  self:RegisterChatCommand("aqt", function(str)
    local data = GetMouseFocus().taxiNodeData
    if data then
      local data = {object="AirjQuest",method="TakeTaxiByNoteId",args={data.nodeID}}
      dump(data)
      self:SetComm(data)
    end
  end)
  self:RegisterChatCommand("aqc", function(str)
    local name = GetMouseFocus():GetName()
    if name then
      local data = {object="AirjHack",method="RunMacroText",args={"/click "..name}}
      -- dump(data)
      self:SetComm(data)
    end
  end)
  self:RegisterChatCommand("aqa", function(str)
    local data = {object=nil,method="CompleteLFGRoleCheck",args={true}}
    self:SetComm(data)
    data = {object=nil,method="AcceptProposal",args={}}
    self:SetComm(data)
  end)
  self:RegisterChatCommand("aqs", function(str)
    local data
    data = {object="AirjHack",method="RunMacroText",args={str}}
    self:SetComm(data)
  end)
  self:RegisterChatCommand("aqsellall", function(str)
    self:SellAllItem()
  end)
  self:RegisterChatCommand("aqaball", function(str)
    self:AbandonAllQuest()
  end)

  RepopMe()
end

function Core:TakeTaxiByNoteId(id)
  local nodes = GetAllTaxiNodes()
  for k,v in pairs(nodes) do
    if v.nodeID == id then
      TakeTaxiNode(k)
      return
    end
  end
end
function Core:AbandonAllQuest()
  local timer
  local i = 30
  timer = self:ScheduleRepeatingTimer(function()
    SelectQuestLogEntry(i)
    SetAbandonQuest()
    AbandonQuest()
    -- dump(GetNumQuestLogEntries())
    i = i - 1
    if i == 0 then
      self:CancelTimer(timer)
    end
  end,0.1)
  -- GetNumQuestLogEntries()
end
function Core:SellAllItem()

  -- Variables
  local SoldCount, Rarity, ItemPrice = 0, 0, 0
  local CurrentItemLink, void

  -- Traverse bags and sell grey items
  for BagID = 0, 4 do
    for BagSlot = 1, GetContainerNumSlots(BagID) do
      CurrentItemLink = GetContainerItemLink(BagID, BagSlot)
      if CurrentItemLink then
        void, void, Rarity, void, void, void, void, void, void, void, ItemPrice = GetItemInfo(CurrentItemLink)
        local void, itemCount = GetContainerItemInfo(BagID, BagSlot)
        if Rarity < 4 and ItemPrice ~= 0 then
          SoldCount = SoldCount + 1
          if SoldCount > 11 then
            self:ScheduleTimer(function()
              self:SellAllItem()
            end,1)
            return
          end
          if MerchantFrame:IsShown() then
            UseContainerItem(BagID, BagSlot)
          else
            -- If merchant frame is not open, stop selling
            -- StopSelling()
            return
          end
        end
      end
    end
  end
end

function Core:QUESTTASK_UPDATE(...)
  self:Print(...)
end
function Core:QUEST_WATCH_UPDATE(...)
  self:Print(...)
end
function Core:UNIT_QUEST_LOG_CHANGED(...)
  self:Print(...)
end
function Core:QUEST_WATCH_OBJECTIVES_CHANGED(...)
  self:Print(...)
end
function Core:SetComm(data)
  self:SendCommMessage("AIRJQUEST_COMM",self:Serialize(data),IsInRaid() and "RAID" or IsInGroup() and "PARTY" or "GUILD",nil,"BULK")
end
function Core:OnCommReceived(prefix,str,channel,sender)
  if prefix == "AIRJQUEST_COMM" then
  	local match, data = self:Deserialize(str)
    if match then
      local object = data.object and _G[data.object]
      local method = data.method
      local args = data.args or {}
      -- print(method,object[method])
      if object and method and object[method] then
        object[method](object,unpack(args))
        -- print(method,args)
      elseif method and _G[method] then
        _G[method](unpack(args))
      end
    end
  end
end
