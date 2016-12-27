local M = LibStub("AceAddon-3.0"):NewAddon("AirjRaidHudMaster", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
local Cache = AirjCache

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
    local data = Cache.cache.position or {}
    local guid = UnitGUID("player")
    local px,py = unpack(data[guid] or {})
    if px then
      local toSend = string.format("%06d%06d",px*10,py*10)
      for i=1,20 do
        local guid = UnitGUID("raid"..i)
        if guid then
          -- dump(data[guid])
          local x,y,_,f = unpack(data[guid] or {})
          if x then
            toSend = toSend..ser(i,x-px,y-py,f)
          end
        end
      end
      self:SendCommMessage("AIRJRH_COMM",toSend,"raid",nil,"ALERT",function(arg1,current,totle)
        -- print(current,totle)
        if (current>=totle) then
          self:ScheduleTimer(send,0.1)
        end
      end)
    else
      self:ScheduleTimer(send,0.1)
    end
    -- self.sending = 20
    -- for i=1,20 do
    --   local guid = UnitGUID("player")
    --   local toSend = data[guid]
    --   self:SendCommMessage("AIRJRH_COMM",self:Serialize(toSend),"raid",nil,"ALERT",function(arg1,current,totle)
    --     print(i,arg1,current,totle)
    --     if (current>=totle) then
    --       self.sending = self.sending - 1
    --       if self.sending == 0 then
    --         self:ScheduleTimer(send,0.1)
    --       end
    --     end
    --   end)
    -- end
  end
  send()
end
