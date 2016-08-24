local Core = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyCore", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

function Core:OnInitialize()
end

function Core:OnEnable()
  self.mainTimerProtectorTimer = self:ScheduleRepeatingTimer(function()
    if GetTime() - (self.lastScanTime or 0) > 0.5 then
      self:RestartTimer()
    end
  end,0.1)
end

function Core:OnDisable()

end


function Core:RestartTimer()
	self:CancelTimer(self.mainTimer,true)
	self.mainTimer = self:ScheduleRepeatingTimer(function()
    self:Scan()
	end,0.01)
end

function self:Scan()
  local t=GetTime()
  self.lastScanTime=t
end
