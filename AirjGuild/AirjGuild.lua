local Core = LibStub("AceAddon-3.0"):NewAddon("AirjGuild", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"

function Core:OnInitialize()
  --DoReadyCheck
  self:RegisterChatCommand("rc", function(str)
    DoReadyCheck()
  end)
end

function Core:OnEnable()

end

function Core:OnDisable()

end

local guildRosterInfo={}
function Core:GetGuildRosterInfo()
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

function Core:IsUnitPresent(unit)
  if UnitInRaid(name) then
    return true
  end
  if standbyUnit[name] then
    if GetTime()<standbyUnit[name] then
      return true
    end
  end
  return false
end

function Core:GetGuildTable()
  local guildInfoText = GetGuildInfoText()
  local info = {}
  for k, v in string.gmatch(guildInfoText, "(%w+)=(%w+)") do
    info[k] = v
  end
  return info
end
function Core:SetGuildTable(key,value)
  local guildInfoText = GetGuildInfoText()
  local info = {}
  local pattern = key.."=(%w+)"
  if string.find(guildInfoText,pattern) then
    guildInfoText = string.gsub(guildInfoText,pattern,value)
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
  if totalPresent then
    local inRaid = IsInRaid("player")
    if weekday>=2 and weekday<=5 and hour>=8.5 and hour<=11.5 and inRaid then
      for name, data in pairs(guildRosterInfo) do
        local point = 0
        if GetTime() - data.lastOnline <600 then
          if IsUnitPresent(name) then
            point = 1
          end
        end
        data.point = (data.point*totalPresent + point)/(totalPresent+1)
      end
    end
    self:SetGuildTable("TOTALPRESENT",(totalPresent+1)*0.998)
  end
end

function Core:UpdateGuildRosterOfficerNote()
  for i=1,GetNumGuildMembers() do
    local fullName, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(i)
    local data = guildRosterInfo[fullName]
    if data then
      local note = data.point .. ","..data.rest
      GuildRosterSetOfficerNote(i, note)
    end
  end
end

-- LOOT iLVL Save

-- POINT
