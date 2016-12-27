local H = LibStub("AceAddon-3.0"):NewAddon("AirjRaidHud", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
local Cache = AirjCache

function H:OnInitialize()
end

function H:OnEnable()
  H:RegisterComm("AIRJRH_COMM")
end

local function deser(str)
  if strlen(str)~=4 then return end
  i= strbyte(str,1)
  x= strbyte(str,2)
  y= strbyte(str,3)
  f= strbyte(str,4)
  i = i-20
  x = (x-128)/2.5
  y = (y-128)/2.5
  f = (f-1)/40
  return i,x,y,f
end

function H:OnCommReceived(prefix,data,channel,sender)
  if prefix == "AIRJRH_COMM" then
    local pxs = strsub(data,1,6)
    local pys = strsub(data,7,12)
    local px,py = tonumber(pxs),tonumber(pys)
    if px then
      px = px/10
      py = py/10

      local s = 13
      -- print(px,py)
      while s<strlen(data) do
        local i,x,y,f = deser(strsub(data,s,s+3))
        if i then
          x = x+px
          y = y+py
          s=s+4
          print(i,x,y,f)
        end
      end
    end
  end
end
