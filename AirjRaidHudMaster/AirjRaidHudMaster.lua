local M = LibStub("AceAddon-3.0"):NewAddon("AirjRaidHudMaster", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
AirjRaidHudMaster = M
-- AirjRaidHudMaster.testing = 1

function M:OnInitialize()
end

local function ser(i,x,y,f)
  i=i+20
  x = math.max(math.min(x, 50), -50)*2.5 +128
  y = math.max(math.min(y, 50), -50)*2.5 +128
  if f<0 then f= f + math.pi end
  f = f*40+1
  return strchar(i)..strchar(x)..strchar(y)..strchar(f)
end

function M:OnEnable()
  local function send()
    local _,currentZoneType = IsInInstance()
    if AirjHack and AirjHack:HasHacked() and (IsInRaid() and currentZoneType == "raid" and not IsInLFGDungeon() or self.testing) then
      local px,py = AirjHack:Position(UnitGUID("player"))
      -- print("Sending")
      if px then
        local toSend = string.format("%06d%06d",px*10,py*10)
        for i=1,20 do
          local guid = UnitGUID("raid"..i)
          if guid then
            local x,y,_,f = AirjHack:Position(guid)
            if x then
              toSend = toSend..ser(i,x-px,y-py,f)
            end
          end
        end
        for i=1,4 do
          local guid = UnitGUID("boss"..i)
          if guid then
            local x,y,_,f = AirjHack:Position(guid)
            if x then
              toSend = toSend..ser(i+40,x-px,y-py,f)
            end
          end
        end
        self:SendCommMessage("AIRJRH_COMM",toSend,"raid",nil,"ALERT",function(arg1,current,totle)
          if (current>=totle) then
            self:ScheduleTimer(send,0.01)
          end
        end)
      end
    else
      self:ScheduleTimer(send,0.1)
    end
  end
  send()
  -- self:ScheduleRepeatingTimer(send,0.01)
  -- self:ScheduleRepeatingTimer(function()
  --   if AirjRaidHud and AirjHack and AirjHack:HasHacked() then
  --     do
  --       local guid = UnitGUID("player")
  --       local x,y,_,f = AirjHack:Position(guid)
  --       AirjRaidHud.position[guid] = {x,y,f}
  --     end
  --     for i=1,20 do
  --       local guid = UnitGUID("raid"..i)
  --       if guid then
  --         local x,y,_,f = AirjHack:Position(guid)
  --         AirjRaidHud.position[guid] = {x,y,f}
  --       end
  --     end
  --     for i=1,4 do
  --       local guid = UnitGUID("boss"..i)
  --       if guid then
  --         local x,y,_,f = AirjHack:Position(guid)
  --         AirjRaidHud.position[guid] = {x,y,f}
  --       end
  --     end
  --   end
  --   self:UpdateMainFrame()
  -- end,0.02)
end
