local H = LibStub("AceAddon-3.0"):NewAddon("AirjRaidHud", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
local Cache = AirjCache


function H:OnInitialize()
  AirjRaidHudDB = AirjRaidHudDB or {}
  self.db = AirjRaidHudDB
  self.postion = {}
  self.activities = {}
  self.pointcache = {}
  self.linecache = {}
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
          local guid = UnitGUID("raid"..i) --may sync
          self.position[guid] = {x,y,f}
        end
      end
    end
  end
end

function H:GetMainFrame()
  local self.mainFrame = self.mainFrame or self:CreateFrame()
  self.mainFrame:Show()
  return self.mainFrame
end

function H:CreateFrame()
  local frame = CreateFrame("Frame")
  local x,y = self.db.x or 80,self.db.y or 80
  local size = self.db.size or 100
  frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",x,y)
  frame:SetSize(size,size)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		self.db.x = self:GetLeft()
		self.db.y = self:GetTop()
	end)
	frame.back = frame:CreateTexture(nil, "BACKGROUND")
	frame.back:SetColorTexture(.7,.7,.7,.4)
	frame.back:SetAllPoints()
	frame.player = frame:CreateTexture(nil, "OVERLAY")
	frame.player:SetSize(32,32)
	frame.player:SetPoint("CENTER",0,0)
	frame.player:SetTexture("Interface\\MINIMAP\\MinimapArrow")
  return frame
end

function Core:DeepCopy(table)
  if type(table) == "table" then
    local toRet = {}
    for k,v in pairs(table) do
      toRet[k] = self:DeepCopy(v)
    end
    return toRet
  else
    return table
  end
end

function H:GetPosition(data)
  local x,y,f
  if not data then return end
  if data.guid then
    x,y,f = unpack(self.position[data.guid] or {})
  elseif data.unit then
    local guid = UnitGUID(data.unit)
    if guid then
      x,y,f = unpack(self.position[guid] or {})
    end
  elseif data.x and data.y then
    x,y,f = data.x,data.y,data.f
  end
  if not x then return end
  return x,y,f
end

function H:Real2Hud(x,y,f,r)
  local px,py,pf = unpack(self.playerPosition)
  local dx,dy = x-px,y-py
  local s,c = math.sin(pf),math.cos(pf)
  local r2h = 1/self.range/2
  local hx = (dx*s+dy*c)*r2h
  local hy = (-dx*c+dy*s)*r2h
  local hf
  if f then
    hf = f+pf
  end
  local hr
  if r then
    hr = r*r2h
  end
  return hx,hy,hf,hr
end

function H:New(t,data)
  if self["New"..t] then
    local a = self["New"..t](self,data)
    a.expire = data.expire
    tinsert(self.activities,a)
    return a
  end
end

do -- point
  function H:NewPoint(data)
    local frame = self:GetMainFrame()
    local texture = tremove(self.pointcache)
    if not texture then
    	texture = frame:CreateTexture(nil, "OVERLAY")
    	texture:SetAllPoints()
    	texture:SetTexture("Interface\\Addons\\AirjRaidHud\\textures\\circle.tga")
      texture:Show()
    end
    texture:SetVertexColor(unpack(data.color or {1,0,0,1}))
    local point = {}
    point.position = self:DeepCopy(data.position)
    point.texture = {texture}
    point.radius = data.radius
    point.type = "Point"
    return point
  end

  function H:RemovePoint(point)
    tinsert(self.pointcache,point.texture)
    wipe(point)
    return point
  end

  function H:UpdatePoint(point)
    local x,y,f = self:GetPosition(point.position)
    if not x then
      for k,v in pairs(point.texture) do
        v:Hide()
      end
      return
    end
    local r = point.radius
    local hx,hy,hf,hr = self:Real2Hud(x,y,f,r)
    local circleTexture = point.texture[1]
    local left,right,top,bottom = -(hx-hr+0.5)/2/hr,(0.5-(hx-hr))/2/hr,(0.5-(hy-hr))/2/hr,-(hy-hr+0.5)/2/hr
    circleTexture:SetTexCoord(left,right,top,bottom)
    for k,v in pairs(point.texture) do
      v:Show()
    end
  end
end

do --line
  function H:NewLine(data)
    local frame = self:GetMainFrame()
    local texture = tremove(self.linecache)
    if not texture then
    	texture = frame:CreateTexture(nil, "OVERLAY")
    	texture:SetAllPoints()
    	texture:SetTexture("Interface\\Addons\\AirjRaidHud\\textures\\line.tga")
      texture:Show()
    end
    texture:SetVertexColor(unpack(data.color or {1,0,0,1}))
    local line = {}
    line.from = self:DeepCopy(data.from)
    line.to = self:DeepCopy(data.to)
    line.texture = {texture}
    line.width = data.width
    line.lenght = data.lenght
    line.type = "Line"
    return line
  end
  function H:RemoveLine(line)
    tinsert(self.linecache,line.texture)
    wipe(line)
    return line
  end
  function H:Distance (x1,y1,x2,y2)
    local dx,dy = x1-x2,y1-y2
    return sqrt(dx*dx+dy*dy)
  end
  function H:UpdateLine(line)
    local fx,fy,ff = self:GetPosition(point.from)
    local tx,ty,tf = self:GetPosition(point.to)
    if not fx or not tx then
      for k,v in pairs(point.texture) do
        v:Hide()
      end
      return
    end
    local w = line.width or 2
    local l = line.lenght or self:Distance(fx,fy,tx,ty)
    if l ~= 0 then
      local hfx,hfy,hff,hw = self:Real2Hud(fx,fy,ff,w)
      local htx,hty,htf,hl = self:Real2Hud(tx,ty,tf,l)
      local hx,hy = (hfx+htx)/2,(hfy+hty)/2
      local s,c = (hty-hfy)/l,(htx-hfx)/l
      hw = hw*8 -- for img
      local a1,a2,a3,a4,a5,a6 = l*c,-l*s,-l*c*hx+l*s*hy+0.5,w*s,w*c,-w*s*hx-w*c*hy+0.5
      local ULx, ULy = a1*-0.5+a2*0.5+a3*1,a4*-0.5+a5*0.5+a6*1
      local LLx, LLy = a1*-0.5+a2*-0.5+a3*1,a4*-0.5+a5*-0.5+a6*1
      local URx, URy = a1*0.5+a2*0.5+a3*1,a4*0.5+a5*0.5+a6*1
      local LRx, LRy = a1*0.5+a2*-0.5+a3*1,a4*0.5+a5*-0.5+a6*1

      local lineTexture = point.texture[1]
      lineTexture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
      -- local left,right,top,bottom = -(hx-hr+0.5)/2/hr,(0.5-(hx-hr))/2/hr,(0.5-(hy-hr))/2/hr,-(hy-hr+0.5)/2/hr
      -- circleTexture:SetTexCoord(left,right,top,bottom)
      for k,v in pairs(point.texture) do
        v:Show()
      end
    else
      for k,v in pairs(point.texture) do
        v:Hide()
      end
    end
  end
end

function H:UpdateMainFrame()
  local t = GetTime()
  local guid = UnitGUID("player")
  local position = self.position(guid)
  if position then
    self.playerPosition = position
    self.range = 40
    for i,activity in pairs(self.activities) do
      local t = activity.type
      if activity.remove or activity.expire and activity.expire>t then
        tremove(self.activities,i)
        if t then
          self["Remove"..t](self,activity)
        else
          wipe(activity)
        end
      else
        if t then
          self["Update"..t](self,activity)
        end
      end
    end
  end
end
