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
function Core:UpdateGuildRosterInfo()
  for i=1,GetNumGuildMembers() do
    local fullName, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(i)
    local data = guildRosterInfo[fullName] or {}
    if online then data.lastOnline = GetTime() end
    data.note = officernote
    guildRosterInfo[fullName] = data
  end
end

function Core:IsUnitPresent(unit)
  if UnitInRaid(name) or standbyUnit[name] then
    return true
  end
  return false
end

function Core:UpdateParticipation()
  local hour, minute = GetGameTime()
  hour = hour+minute/30
  local weekday, month, day, year = CalendarGetDate()
  local inRaid = IsInRaid("player")
  if weekday>=2 and weekday<=5 and hour>=8.5 and hour<=11.5 and inRaid then
    for name, data in pairs(guildRosterInfo) do
      if GetTime() - data.lastOnline <600 then
      end
    end
  end
end

-- LOOT iLVL Save

-- POINT
