local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local M = Core:NewModule("ModKeyPressing", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

function M:OnInitialize()
end
function M:OnEnable()
  self:RegisterEvent("MODIFIER_STATE_CHANGED",self.CheckAndPrint,self)
	self.updateTimer = self:ScheduleRepeatingTimer(self.CheckAndPrint,0.2,self)
end

do
  local lastStatus = {}
  local pressTime = {}
  local globalFunctions = {
    "LeftAlt",
    "LeftControl",
    "LeftShift",
    "RightAlt",
    "RightControl",
    "RightShift"
  }
  function M:CheckAndPrint()
    local t = GetTime()
    for _,name in ipairs(globalFunctions) do
      local fcn = _G["Is"..name.."KeyDown"]
      local current = fcn()
      local last = lastStatus[name]
      lastStatus[name] = current
      if not last and current then
        pressTime[name] = t
      end
      if not current then pressTime[name] = nil end
      if pressTime[name] and t - pressTime[name] >= 1 then
        self:Print(""..name.." is pressing!")
        pressTime[name] = t
      end
    end
  end
end
