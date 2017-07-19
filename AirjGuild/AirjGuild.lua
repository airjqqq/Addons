local Core = LibStub("AceAddon-3.0"):NewAddon("AirjGuild", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"
local AceGUI = LibStub("AceGUI-3.0")
AirjGuild = Core
-- local GS = LibStub("LibGuildStorage-1.2")

local RAID1DETAIL = "一团 时间:星期四/一/二/三,晚上8:30-11:30.CL分配.装等要求910,当前9/9H,主打M,招:qs/sm/dz/dh/ss/fs"
local RAID2DETAIL = "二团 时间:星期五(/六/日),晚上8:30-11:30.CL分配.当前普通全通,以后主打H模式,小号提升团,装等要求880+"
-- local WORLDMESSAGE = "上班族公会<Hand Of Justice> H9/9 招人,M我查详情"
local WORLDMESSAGE = "<Hand Of Justice>公会,上班族,H9/9,晚上活动.M我查看招人详情"
local GAMESSAGE = "要参加公会活动请m我装等,专精,经验等信息,团队列表如下:"

function Core:OnInitialize()
  --DoReadyCheck
  self:RegisterChatCommand("rc", function(str)
    DoReadyCheck()
  end)
  self:RegisterChatCommand("rcc", function(str)
    DoReadyCheck()
  end)
end


function Core:OnEnable()
  self:ScheduleRepeatingTimer(function()
    -- self:UpdateGuildRosterInfo()
    self:UpdateParticipation()
    -- self:UpdateGuildRosterOfficerNote()
  end,60)
  SetCVar("profanityFilter", 0)
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  self:RegisterEvent("CHAT_MSG_WHISPER")
  self:RegisterEvent("PLAYER_LEAVE_COMBAT")
  self:RegisterEvent("PARTY_MEMBERS_CHANGED")
  self:RegisterEvent("CHAT_MSG_SYSTEM")
  self:RegisterEvent("PARTY_LEADER_CHANGED",self.CheckAndTogglePointIndexSelector,self)
  -- self:RegisterEvent("PARTY_CONVERTED_TO_RAID",self.CheckAndTogglePointIndexSelector,self)
  self:CheckAndTogglePointIndexSelector("OnEnable")
  AirjGuildDB = AirjGuildDB or {}
  self.db = AirjGuildDB
  self.db.standbyList = {}
  self.worldTimer = self:ScheduleRepeatingTimer(self.WorldTimer,10,self)
  self.gaTimer = self:ScheduleRepeatingTimer(self.GuildAnnouncementTimer,10,self)
  self:RegisterEvent("CHAT_MSG_CHANNEL")
  self:RegisterEvent("CHAT_MSG_OFFICER")
  self.worldLastTime = GetTime()
  self.gaLastTime = GetTime() - 10*60
  self:World(600,"综合",WORLDMESSAGE)
  self:GuildAnnouncement(15*60,GAMESSAGE)
  self:RegisterChatCommand("ag", function(str)
    self:CheckAndTogglePointIndexSelector("ChatCommand")
  end)
  self:UpdateGuildRosterInfo()
end

function Core:OnDisable()

end

local function findChannelByName(name)
  local channels = {GetChannelList()}
  for i = 1,#channels/2 do
    local j,n = channels[i*2-1],channels[i*2]
    if n == name then
      return j
    end
  end
end

function Core:WorldTimer()
  if not self.worldMessage then return end
  if GetTime()>self.worldLastTime + self.worldInterval +(UnitIsGroupLeader("player") and 0 or 20) then
    self.worldLastTime = GetTime()
    local channel, message  = self.worldChannel, self.worldMessage
    local c = findChannelByName(channel)
    if not c then JoinPermanentChannel(channel,nil,3) end
    c = findChannelByName(channel)
    if c then
      print(c,message)
      SendChatMessage(message,"CHANNEL",nil,c)
    end
  end
end

function Core:GuildAnnouncementTimer()
  if not self.gaMessage then return end
  if GetTime()>self.gaLastTime + self.gaInterval +(UnitIsGroupLeader("player") and 0 or 20) then
    self.gaLastTime = GetTime()
    local message = self.gaMessage
    SendChatMessage("{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}","OFFICER")
    SendChatMessage(message,"OFFICER")
    SendChatMessage(RAID1DETAIL,"OFFICER")
    SendChatMessage(RAID2DETAIL,"OFFICER")
    SendChatMessage("{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}{rt2}","OFFICER")
  end
end

function Core:CHAT_MSG_CHANNEL(event,...)
  local message = ...
  local channel = select(9,...)
  if self.worldChannel == channel and self.worldMessage == message then
    self.worldLastTime = GetTime()
  end
end

function Core:CHAT_MSG_OFFICER(event,...)
  local message = ...
  if self.gaMessage == message then
    self.gaLastTime = GetTime()
  end
end

function Core:PARTY_MEMBERS_CHANGED(event,...)
  if UnitAffectingCombat("player") then return end
  local groupMember = GetNumGroupMembers()
  if self.groupMember and groupMember < self.groupMember then
    if self.leaveCombatTime and GetTime() - self.leaveCombatTime > 120 then
      self:CheckAndTogglePointIndexSelector("PARTY_MEMBERS_CHANGED")
    end
  end
  self.groupMember = groupMember
  -- self:Print(event,...)
end

function Core:CHAT_MSG_SYSTEM(event,message)
  if message == ERR_PARTY_CONVERTED_TO_RAID then
    self:CheckAndTogglePointIndexSelector("ERR_PARTY_CONVERTED_TO_RAID")
  end
end

function Core:PLAYER_LEAVE_COMBAT(event,...)
  self.leaveCombatTime = GetTime()
  -- if self.leaveCombatTimer then
  --   self:CancelTimer(self.leaveCombatTimer)
  --   self.leaveCombatTimer = nil
  -- end
  -- self.leaveCombatTimer = self:ScheduleTimer(CheckAndTogglePointIndexSelector,300)
end

function Core:CheckAndTogglePointIndexSelector(...)
  self:Print("CheckAndTogglePointIndexSelector",...)
  local selector = self.pointIndexSelector
  if not UnitIsGroupLeader("player") or not IsInRaid("player") then
    self.pointIndex = nil
    if selector then selector:Hide() end
    return
  end
  if not selector then
    local group = AceGUI:Create("Frame")
    group:SetWidth(400)
    group:SetHeight(300)
    group:SetTitle("出勤统计")
    group:SetLayout("Flow")
    local names = {
      "一团",
      "二团",
      "三团",
      "四团",
      "停止"
    }
    for i = 1,5 do
      local button = AceGUI:Create("Button")
      button:SetWidth(370)
      button:SetHeight(40)
      button:SetText(names[i])
      button:SetCallback("OnClick", function(widget,event)
        if i~= 5 then
          self.pointIndex = i
        else
          self.pointIndex = nil
        end
        group:Hide()
      end)
      group:AddChild(button)
      group["button"..i] = button
    end
    self.pointIndexSelector = group
    selector = group
  end
  local highlight = self.pointIndex or 5
  for i = 1,5 do
    local button = selector["button"..i]
    button:SetDisabled(i==highlight)
  end
  selector:Show()
end

function Core:World(interval,channel,message)
  -- dump(self)
  self.worldInterval,self.worldChannel,self.worldMessage = interval,channel,message
end
function Core:GuildAnnouncement(interval,message)
  self.gaInterval,self.gaMessage = interval,message
end

local nextAutoGuildInfo = {}
Core.next = nextAutoGuildInfo
local guildRosterInfo={}
local nameToFullName = {}
function Core:CHAT_MSG_WHISPER(event,message, sender, language, channelString, target, flags, unknown, channelNumber, channelName, unknown, counter, guid)
  local playerRealm = GetRealmName()
  local senderRealm = select(2,strsplit("-",sender))
  if not senderRealm or senderRealm == playerRealm then
    if message:upper() == "TB" or message:upper() == "STANDBY" or message == "替补" then
      self.db.standbyList[sender] = GetTime()+15*60
      SendChatMessage("替补状态生效,15分钟后失效","WHISPER",nil,sender)
    elseif AirjHack and AirjHack:HasHacked() and (message:upper() == "JRGH" or message == "加入公会" or message == "加入工会") then
      if AirjHack and AirjHack:HasHacked() then
        RunMacroText("/ginvite "..sender)
        SendChatMessage("要参加活动入会后M我天赋/装等/神器等级.详细阅读公会今日信息","WHISPER",nil,sender)
      end
    else
      self:UpdateGuildRosterInfo()
      if not guildRosterInfo[sender] and not nameToFullName[sender] then
        if not nextAutoGuildInfo[sender] or nextAutoGuildInfo[sender]<GetTime() then
          self:ScheduleTimer(function()
            self:ScheduleTimer(function()
              SendChatMessage(RAID1DETAIL,"WHISPER",nil,sender)
            end,1)
            self:ScheduleTimer(function()
              SendChatMessage(RAID2DETAIL,"WHISPER",nil,sender)
            end,2)
            self:ScheduleTimer(function()
              if AirjHack and AirjHack:HasHacked() then
                SendChatMessage("你好,回“JRGH”或“加入公会”自动邀请.","WHISPER",nil,sender)
                RunMacroText("/ginvite "..sender)
              end
            end,3)
          end,3)
          nextAutoGuildInfo[sender] = GetTime()+900
        end
      end
    end
  end
end


--[[
活动时间:星期四/一/二/三,晚上8:30-11:30.CallLoot分配.装等要求875+.

进度:M4/7

时间可以游戏m我或加战网:

airjqqq@qq.com
]]

local lastUpdate

function Core:IsUnitPresent(name)
  local realName = string.split("-",name)
  if UnitInRaid(name) or UnitInRaid(realName) then
    return true
  end
  local standbyTime = self.db.standbyList[name] or self.db.standbyList[realName]
  if standbyTime then
    if GetTime()<standbyTime then
      return true
    end
  end
  return false
end

function Core:GetGuildTable()
  local guildInfoText = GetGuildInfoText()
  local info = {}
  for k, v in string.gmatch(guildInfoText, "([^\n]+)=([^\n]+)") do
    info[k] = v
  end
  return info
end

function Core:GetGuildTableNumber(key)
  local info = Core:GetGuildTable()
  local value = info[key]
  return value and tonumber(value)
end

function Core:SetGuildTable(key,value)
  local guildInfoText = GetGuildInfoText()
  local info = {}
  local pattern = key.."=([^\n]+)"
  if string.find(guildInfoText,pattern) then
    guildInfoText = string.gsub(guildInfoText,pattern,key.."="..value)
  else
    guildInfoText = guildInfoText.."\n"..key.."="..value.."\n"
  end
  SetGuildInfoText(guildInfoText)
end

function Core:UpdateGuildRosterInfo()
  if lastUpdate == GetTime() then return end
  lastUpdate = GetTime()
  wipe(guildRosterInfo)
  wipe(nameToFullName)
  self.guildRosterInfo = guildRosterInfo
  self.nameToFullName = nameToFullName
  for i=1,GetNumGuildMembers() do
    local fullName, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(i)
    local name = Ambiguate(fullName, "mail")
    local sn = Ambiguate(fullName,"none")
    nameToFullName[sn] = name
    local data = guildRosterInfo[fullName] or {}
    if online then data.lastOnline = GetTime() end
    data.note = officernote
    guildRosterInfo[fullName] = data
  end
end

function Core:UpdateParticipation()
  local pointIndex = self.pointIndex
  if pointIndex then
    local totalPresent = self:GetGuildTableNumber("TOTALPRESENT"..pointIndex)
    if not totalPresent then
      message("totalPresent pointIndex Raid "..pointIndex.." is missing" )
      return
    end
    self:UpdateGuildRosterInfo()
    local added = {}
    do
      local a,b = IsInInstance()
      if b=="none" then
        SendChatMessage(pointIndex.."团 开组,m我123自动进组","GUILD")
      else
        if not UnitAffectingCombat("player") then
          SendChatMessage(pointIndex.."团 开组,m我123自动进组","GUILD")
          -- SendChatMessage(pointIndex.."团 出勤率更新中...","RAID")
        end
      end
    end
    local function add(name,cp)
      local data = guildRosterInfo[name]
      if data then
        -- print("add for ",name)
        added[name] = true
        local officernote = data.note
        local array = {string.split(";",officernote)}
        local point = 0
        local vector
        if totalPresent <0 then
        else
          if array[pointIndex] then
            local note = array[pointIndex]
            note = strtrim(note)
            local vectorName = note
            if nameToFullName[note] then
              vectorName = nameToFullName[note]
            end
            if guildRosterInfo[vectorName] and vectorName~=name then
              add(vectorName,cp)
              return
            end
            point = tonumber(note) or 0
          end
          point = (point*totalPresent + cp)/(totalPresent+1)
        end
        array[pointIndex] = string.format("%.5f",point)
        for i = 1,pointIndex do
          if array[i] == nil then
            array[i] = ""
          end
        end
        local newnote = table.concat(array,";")
        data.newnote = newnote
      end
    end
    for name, data in pairs(guildRosterInfo) do
      if not added[name] then
        local cp = 0
        if data.lastOnline and GetTime() - data.lastOnline <600 then
          if self:IsUnitPresent(name) then
            cp = 1
          end
        end
        add(name,cp)
      end
    end
    if totalPresent <0 then
      self:Print("Clear for Raid "..pointIndex)
    else
      self:Print("Increasing for Raid "..pointIndex)
      self:SetGuildTable("TOTALPRESENT"..pointIndex,(totalPresent+1)*0.999)
    end
    self:UpdateGuildRosterOfficerNote()
  end
end

function Core:UpdateGuildRosterOfficerNote()
  for i=1,GetNumGuildMembers() do
    local fullName, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(i)
    local data = guildRosterInfo[fullName]
    if data then
      local newofficernote = data.newnote
      if newofficernote and newofficernote ~= officernote then
        GuildRosterSetOfficerNote(i, newofficernote)
      end
    end
  end
end

function Core:SetEPGPNote(name,note)
  self:UpdateGuildRosterInfo()
  local data = guildRosterInfo[name]
  local officernote = data.note
  local array = {string.split(";",officernote)}
  array[5] = note
  for i = 1,5 do
    if array[i] == nil then
      array[i] = ""
    end
  end
  local newnote = table.concat(array,";")
  data.note = newnote
  self:UpdateGuildRosterOfficerNote()
end


function Core:GetEPGPNote(name)
  self:UpdateGuildRosterInfo()
  local data = guildRosterInfo[name]
  local officernote = data.note
  local array = {string.split(";",officernote)}
  return array[5] or ""
end

function Core:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)

  if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event =="SPELL_AURA_APPLIED_DOSE" then
    if spellId == 213166 then
      self:NewSearing(destGUID)
    end
    -- test
    -- if spellId == 774 then
    --   self:NewSearing(destGUID)
    -- end
  end
end

do
  function Core:GetUnitList()
    if self.unitListCache then return self.unitListCache end
    local subUnit = {"","target","pet","pettarget"}
    local list = {"player","target","targettarget","pet","pettarget","focus","focustarget","mouseover","mouseovertarget"}
    for i = 1,5 do
      tinsert(list,"arena"..i)
    end
    for i = 1,4 do
      tinsert(list,"boss"..i)
      tinsert(list,"boss"..i.."target")
    end
    for _,sub in pairs(subUnit) do
      for i = 1,4 do
        tinsert(list,"party"..i..sub)
      end
    end
    for i = 1,40 do
      for _,sub in pairs(subUnit) do
        tinsert(list,"raid"..i..sub)
      end
    end
    for i = 1,20 do
      -- tinsert(list,"nameplate"..i)
    end
    self.unitListCache=list
    return list
  end

  local guid2unit = {}
  function Core:FindUnitByGUID(guid)
    if not guid then return end
    local unit = guid2unit[guid]
    if unit and UnitGUID(unit)==guid then
      return unit
    end
    for _,u in pairs(self:GetUnitList()) do
      local g = UnitGUID(u)
      if g then
        guid2unit[g] = u
        if g == guid then
          return u
        end
      end
    end
  end
  local index = 1
  function Core:NewSearing(guid)
    local unit = self:FindUnitByGUID(guid)
    SetRaidTarget(unit,index)
    index = index + 1
    if index > 6 then index = 1 end
  end
end
