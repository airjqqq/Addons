local Core = LibStub("AceAddon-3.0"):NewAddon("AirjGuild", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"

function Core:OnInitialize()
  --DoReadyCheck
  self:RegisterChatCommand("rc", function(str)
    DoReadyCheck()
  end)
end


function Core:OnEnable()
  self:ScheduleRepeatingTimer(function()
    self:GetGuildRosterInfo()
    self:UpdateParticipation()
    self:UpdateGuildRosterOfficerNote()
  end,60)
  SetCVar("profanityFilter", 0)
  self:RegisterEvent("CHAT_MSG_WHISPER")
  AirjGuildDB = AirjGuildDB or {}
  self.db = AirjGuildDB
  self.db.standbyList = {}
end

function Core:OnDisable()

end
function Core:CHAT_MSG_WHISPER(event,message, sender, language, channelString, target, flags, unknown, channelNumber, channelName, unknown, counter, guid)
  if message:upper() == "TB" or message:upper() == "STANDBY" or message == "替补" then
    self.db.standbyList[sender] = GetTime()+15*60
    SendChatMessage("替补状态生效,15分钟后失效","WHISPER",nil,sender)
  end
end


local guildRosterInfo={}
function Core:GetGuildRosterInfo()
  wipe(guildRosterInfo)
  for i=1,GetNumGuildMembers() do
    local fullName, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(i)
    local data = guildRosterInfo[fullName] or {}
    if online then data.lastOnline = GetTime() end
    data.note = officernote
    local array = {string.split(",",officernote)}
    data.point = tonumber(array[1]) or 0
    tremove(array,1)
    data.rest = table.concat(array,",")
    guildRosterInfo[fullName] = data
  end
end

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


function Core:UpdateParticipation()
  local hour, minute = GetGameTime()
  hour = hour+minute/30
  local weekday, month, day, year = CalendarGetDate()
  local info = self:GetGuildTable()

  local totalPresent = info.TOTALPRESENT
  totalPresent = tonumber(totalPresent)
  if totalPresent and UnitIsGroupLeader("player") then
    local inRaid = IsInRaid("player")
    local externTime = tonumber(info.EXTERNTIME)
    if ((weekday>=2 and weekday<=5 and hour>=8.5 and hour<=11.5) or (externTime and externTime>0)) and inRaid then
      for name, data in pairs(guildRosterInfo) do
        local point = 0
        if data.lastOnline and GetTime() - data.lastOnline <600 then
          if self:IsUnitPresent(name) then
            point = 1
          end
        end
        data.point = (data.point*totalPresent + point)/(totalPresent+1)
      end
      if externTime then
        externTime = max(0,externTime-1)
        self:SetGuildTable("EXTERNTIME",externTime)
      end
      self:SetGuildTable("TOTALPRESENT",(totalPresent+1)*0.998)
    end
  end
end

function Core:UpdateGuildRosterOfficerNote()
  for i=1,GetNumGuildMembers() do
    local fullName, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(i)
    local data = guildRosterInfo[fullName]
    if data then
      local note = data.point
      if data.rest and data.rest~="" then
        note = note.. ","..data.rest
      end
      GuildRosterSetOfficerNote(i, note)
    end
  end
end

-- LOOT iLVL Save

-- POINT
