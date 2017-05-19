local H = LibStub("AceAddon-3.0"):NewAddon("AirjRaidHud", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
local Cache = AirjCache
AirjRaidHud = H


function H:OnInitialize()
  AirjRaidHudDB = AirjRaidHudDB or {}
  self.db = AirjRaidHudDB
  -- self.position = {}
  self.position = setmetatable({},{__index=function(t,k)
    if AirjHack and AirjHack:HasHacked() then
      local x,y,_,f = AirjHack:Position(k)
      return {x,y,f}
    end
  end})
  self.activities = {}
  self.buffer = {}
  self.pointcache = {}
  self.linecache = {}
  self.dbmtimers = {}
  self.showLayers = {}
end

function H:OnEnable()
  self.range = 45
  H:RegisterComm("AIRJRH_COMM")
  if self.db.autohide == nil then
    self.db.autohide = true
  end

	self:RegisterChatCommand("arh", function(str,...)
    local key, value, nextposition = self:GetArgs(str, 2)
    local frame = H:GetMainFrame()
    if key == "background" then
      self.db.nobg = not self.db.nobg
      if self.db.nobg then
        self:Print("背景隐藏")
        frame.back:Hide()
      else
        self:Print("背景显示")
        frame.back:Show()
      end
    elseif key == "autohide" then
      self.db.autohide = not self.db.autohide
      self:Print("自动隐藏 "..(self.db.autohide and "开启" or "关闭")..".")
      self:UpdateMainFrame()
    elseif key == "lock" then
      self.db.lock = true
      self:Print("已锁定!")
      frame:EnableMouse(not self.db.lock)
    elseif key == "unlock" then
      self.db.lock = nil
      self:Print("已解锁!")
      frame:EnableMouse(not self.db.lock)
    elseif key == "scale" then
      local s = tonumber(value)
      if s then
        self.db.scale = s
        frame:SetScale(s)
        self:Print("放缩比例为"..s)
      end
    elseif key == "range" then
      local s = tonumber(value)
      if s then
        self:SetRange(s)
        self:Print("Ranger = "..s)
      end
    elseif key == "enable" then
      self.db.disable = not self.db.disable
      self:Print("插件已"..(self.db.disable and "禁用" or "启用")..".")
      self:UpdateMainFrame()
    elseif key == "test" then
      local expire = GetTime() + 6
      self:SetRange(20)
      self:New("Point",{color={0,0.5,0,0.5},radius=6,expire=expire,position={unit="player"}})
      self:SetBar(expire)
      for i=1,20 do
        local u = "raid"..i
        if not UnitIsUnit("player",u) then
          local _,class = UnitClass(u)
          if class then
            local c = RAID_CLASS_COLORS[class]
            self:New("Point",{color={c.r,c.g,c.b,1},radius=2,expire=expire,position={unit=u}})
          end
        end
      end
      self:UpdateMainFrame()
    else
      self:Print("/arh - 显示帮助.")
      self:Print("/arh enable - 启动/禁用.")
      self:Print("/arh lock - 锁定 (鼠标禁用).")
      self:Print("/arh unlock - 解锁 (鼠标启用).")
      self:Print("/arh scale <数字> - 设置放缩比例.")
      self:Print("/arh background - 显示/隐藏背景.")
      self:Print("/arh autohide - 无内容时自动隐藏.")
    end

    -- self:New("Line",{from={x=-518.5,y=2428.7},to={x=-528.5,y=2428.7}})
    -- self:New("Point",{expire=GetTime()+10,position={x=-528.5,y=2428.7}})
  end)


  if self.db.disable then
    H:GetMainFrame():Hide()
  end
  if DBM then
    DBM:RegisterCallback("DBM_TimerStart", function(event, id, msg, time, icon, type, spellId, colorId, modId)
      self.dbmtimers[id] = {
        spellId = spellId,
        msg = msg,
        expire = GetTime() + time,
        type = type,
      }
      -- print(event, id, msg, time, icon, type, spellId, colorId, modId)
    end)
    DBM:RegisterCallback("DBM_TimerStop", function(event, id)
      self.dbmtimers[id] = nil
    end)
  end
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

    -- self:Print("Received")
    -- if AirjHack and AirjHack:HasHacked() then
    -- else
    -- end

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
          local guid
          if i>40 then
            guid = UnitGUID("boss"..(i-40))
          elseif i > 50 then
            guid = UnitGUID("ex"..(i-50))
          else
            guid = UnitGUID("raid"..i) --may sync
          end
          self.position[guid] = {x,y,f}
        end
      end
    end
    self:UpdateMainFrame()
  end
end

function H:GetMainFrame()
  self.mainFrame = self.mainFrame or self:CreateFrame()
  -- self.mainFrame:Show()
  return self.mainFrame
end

function H:SetRange(range)
  self.range = range
  local size = 1000/self.range
  self:GetMainFrame().player:SetSize(size,size)
end

function H:SetBar(expire,start,color)
  self.barstart = start or GetTime()
  self.barexpire = expire
  color = color or {.1,.7,.1,.8}
  self:GetMainFrame().bar:SetColorTexture(unpack(color))
end

function H:CreateFrame()
  local frame = CreateFrame("Frame")
  local x,y = self.db.x,self.db.y
  local size = self.db.size or 160
  if x and y then
    frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",x,y)
  else
    frame:SetPoint("CENTER",UIParent,"CENTER",120,80)
  end
  frame:SetSize(size,size)
  frame:SetScale(self.db.scale or 1)
  frame:EnableMouse(not self.db.lock)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		H.db.x = self:GetLeft()
		H.db.y = self:GetTop()
	end)
	frame.back = frame:CreateTexture(nil, "BACKGROUND")
	frame.back:SetColorTexture(.7,.7,.7,.4)
	frame.back:SetAllPoints()
  if self.db.nobg then
    frame.back:Hide()
  else
    frame.back:Show()
  end
	frame.player = frame:CreateTexture(nil, "OVERLAY")
	frame.player:SetSize(size/8,size/8)
	frame.player:SetPoint("CENTER",0,0)
	frame.player:SetTexture("Interface\\MINIMAP\\MinimapArrow")
	frame.barbg = frame:CreateTexture(nil, "BACKGROUND")
	frame.barbg:SetColorTexture(.2,.2,.2,.6)
	frame.barbg:SetPoint("BOTTOMLEFT")
	frame.barbg:SetPoint("BOTTOMRIGHT")
  frame.barbg:SetHeight(size/16)
	frame.bar = frame:CreateTexture(nil, "OVERLAY")
	frame.bar:SetColorTexture(.1,.7,.7,.8)
	frame.bar:SetPoint("BOTTOMLEFT")
  frame.bar:SetHeight(size/16)
  frame.bar:SetWidth(size)
  return frame
end

function H:UpdateMainFrame()
  local frame = H:GetMainFrame()
  if self.db.disable then
    frame:Hide()
    return
  end
  local time = GetTime()
  local guid = UnitGUID("player")
  local position = self.position[guid]
  local show = not self.db.autohide
  if position then
    self.playerPosition = position
    for i,activity in pairs(self.activities) do
      local t = activity.type
      if activity.remove or activity.expire and time>activity.expire then
        tremove(self.activities,i)
        if t then
          self["Remove"..t](self,activity)
        else
          wipe(activity)
        end
      else
        if t then
          if self:IsLayerShown(activity.layer) then
            self["Update"..t](self,activity)
            show = true
          else
            for k,v in pairs(activity.texture) do
              v:Hide()
            end
          end
        end
      end
    end
  end
  if self.barstart and self.barexpire and time < self.barexpire then
    local started = time-self.barstart
    started = math.max(started,0)
    local width = frame.barbg:GetWidth()
    frame.bar:SetWidth(width*started/(self.barexpire-self.barstart))
    frame.barbg:Show()
    frame.bar:Show()
  else
    frame.barbg:Hide()
    frame.bar:Hide()
  end
  if show then
    -- local size = 1000/self.range
    -- frame.player:SetSize(size,size)
    frame:Show()
  else
    frame:Hide()
  end
end

function H:IsLayerShown(layer)
  return self.showLayers[layer] and self.showLayers[layer]>GetTime() and true or false
end

local layerReason = {}

function H:ShowLayer(reason,layer,expire)
  expire = expire or GetTime()+600
  if reason then
    layerReason[layer] = layerReason[layer] or {}
    layerReason[layer][reason] = expire
  end
  if self.showLayers[layer] then
    expire = math.max(self.showLayers[layer],expire)
  end
  self.showLayers[layer] = expire
end

function H:HideLayer(reason,layer)
  if self.showLayers[layer] then
    local expire
    if reason then
      if layerReason[layer] then
        layerReason[layer][reason] = nil
        for k,v in pairs(layerReason[layer]) do
          if not expire or v>expire then
            expire = v
          end
        end
      end
    end
    if not expire then
      self.showLayers[layer] = nil
      layerReason[layer] = nil
    else
      self.showLayers[layer] = expire
    end
  end
end

do --util
  function H:DeepCopy(table)
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

  function H:GetDistance(guid1,guid2)
    local x1,y1 = unpack(self.position[guid1] or {})
    local x2,y2 = unpack(self.position[guid2] or {})
    if x1 and x2 then
      return sqrt((x1-x2)^2 + (y1-y2)^2)
    end
  end

  function H:Freeze (data)
    local x,y,f = self:GetPosition(data)
    if x then
      wipe(data)
      data.x,data.y,data.f = x,y,f
    end
    -- body...
  end

  function H:Real2Hud(x,y,f,r)
    local px,py,pf = unpack(self.playerPosition)
    local dx,dy = x-px,y-py
    local s,c = math.sin(pf+math.pi/2),math.cos(pf+math.pi/2)
    local r2h = 1/self.range/2
    local hx = (dx*s-dy*c)*r2h
    local hy = (dx*c+dy*s)*r2h
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
  function H:PlayYike(name)
    PlaySoundFile("Interface\\AddOns\\DBM-VPYike\\"..name..".ogg", "Master")
  end
end

 --util end

function H:New(t,data)
  if self["New"..t] then
    local a = self["New"..t](self,data)
    a.expire = data.expire
    a.layer = data.layer or 0
    for k,v in pairs(a.texture) do
      v:SetDrawLayer("ARTWORK",a.layer-8)
    end
    tinsert(self.activities,a)
    return a
  end
end

do -- point
  function H:NewPoint(data)
    local frame = self:GetMainFrame()
    local texture = tremove(self.pointcache)
    if not texture then
    	texture = frame:CreateTexture(nil, "ARTWORK")
    	texture:SetAllPoints()
    	texture:SetTexture("Interface\\Addons\\AirjRaidHud\\textures\\circle.tga")
    end
    texture:Hide()
    texture:SetVertexColor(unpack(data.color or {1,0,0,1}))
    local point = {}
    point.position = self:DeepCopy(data.position)
    point.texture = {texture}
    point.radius = data.radius
    point.type = "Point"
    return point
  end

  function H:RemovePoint(point)
    point.texture[1]:Hide()
    tinsert(self.pointcache,point.texture[1])
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
    local r = point.radius or 5
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
    	texture = frame:CreateTexture(nil, "ARTWORK")
    	texture:SetAllPoints()
    	texture:SetTexture("Interface\\Addons\\AirjRaidHud\\textures\\line.tga")
    end
    texture:Hide()
    texture:SetVertexColor(unpack(data.color or {1,0,0,1}))
    local line = {}
    line.from = self:DeepCopy(data.from)
    line.to = self:DeepCopy(data.to)
    line.texture = {texture}
    line.width = data.width
    line.length = data.length
    line.ray = data.ray
    line.type = "Line"
    return line
  end
  function H:RemoveLine(line)
    line.texture[1]:Hide()
    tinsert(self.linecache,line.texture[1])
    wipe(line)
    return line
  end
  function H:Distance (x1,y1,x2,y2)
    local dx,dy = x1-x2,y1-y2
    return sqrt(dx*dx+dy*dy)
  end
  function H:UpdateLine(line)
    local fx,fy,ff = self:GetPosition(line.from)
    local tx,ty,tf = self:GetPosition(line.to)
    if not line.to and ff then
      local s,c = math.sin(ff),math.cos(ff)
      tx,ty = fx-100*s,fy+100*c
    end
    if not fx or not tx then
      for k,v in pairs(line.texture) do
        v:Hide()
      end
      return
    end
    local w = line.width or 3
    local rl = self:Distance(fx,fy,tx,ty)
    local l = max(line.length or 0,rl)
    if rl > 1 then
      local hfx,hfy,hff,hw = self:Real2Hud(fx,fy,ff,w)
      local htx,hty,htf,hl = self:Real2Hud(tx,ty,tf,l)
      local hx,hy = (hfx+htx)/2,(hfy+hty)/2
      local r2h = 1/self.range/2
      local hrl = rl*r2h
      local s,c = -(hty-hfy)/hrl,(htx-hfx)/hrl
      if line.ray then
        hx = hfx + hl/hrl/2*(htx-hfx)
        hy = hfy + hl/hrl/2*(hty-hfy)
      end
      hw = hw*8 -- for img
      local a1,a2,a3,a4,a5,a6 = 1/hl*c,-1/hl*s,-1/hl*c*hx+1/hl*s*hy+0.5,1/hw*s,1/hw*c,-1/hw*s*hx-1/hw*c*hy+0.5
      local ULx, ULy = a1*-0.5+a2*0.5+a3*1,a4*-0.5+a5*0.5+a6*1
      local LLx, LLy = a1*-0.5+a2*-0.5+a3*1,a4*-0.5+a5*-0.5+a6*1
      local URx, URy = a1*0.5+a2*0.5+a3*1,a4*0.5+a5*0.5+a6*1
      local LRx, LRy = a1*0.5+a2*-0.5+a3*1,a4*0.5+a5*-0.5+a6*1

      -- print(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
      local lineTexture = line.texture[1]
      lineTexture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
      -- local left,right,top,bottom = -(hx-hr+0.5)/2/hr,(0.5-(hx-hr))/2/hr,(0.5-(hy-hr))/2/hr,-(hy-hr+0.5)/2/hr
      -- circleTexture:SetTexCoord(left,right,top,bottom)
      for k,v in pairs(line.texture) do
        v:Show()
      end
    else
      for k,v in pairs(line.texture) do
        v:Hide()
      end
    end
  end
end

do
  local playerPoints={}
  local playerReason={}
  function H:ShowAllPlayers(reason,expire)
    for i=1,20 do
      local u = "raid"..i
      if UnitExists(u) then
        self:ShowPlayer(reason,u,expire)
      end
    end
  end

  function H:HideAllPlayers()
    for guid,point in pairs(playerPoints) do
      point.remove = true
    end
    wipe(playerPoints)
  end

  function H:ShowPlayer(reason,unit,expire)
    -- self:Print("ShowPlayer",reason,unit,expire)
    local guid = UnitGUID(unit)
    local _,class = UnitClass(unit)
    self:ShowPlayerByGUID(reason,guid,class,expire)
  end

  function H:ShowPlayerByGUID(reason,guid,class,expire)
    -- self:Print("ShowPlayerByGUID",reason,guid,class,expire)
    expire = expire or (GetTime() + 600)
    if guid then
      playerReason[guid] = playerReason[guid] or {}
      playerReason[guid][reason] = expire
      local point = playerPoints[guid]
      if point and point.expire then
        point.expire = math.max(expire,point.expire)
      else
        if guid ~= UnitGUID("player") then
          if class then
            local c = RAID_CLASS_COLORS[class]
            local p = self:New("Point",{color={c.r,c.g,c.b,1},radius=2,expire=expire,position={guid=guid},layer=15})
            playerPoints[guid] = p
          end
        end
      end
    end
  end

  function H:HidePlayerByGUID(reason,guid,class,expire)
    local point = playerPoints[guid]
    if point and point.expire then
      local expire
      if playerReason[guid] then
        playerReason[guid][reason] = nil
        for k,v in pairs(playerReason[guid]) do
          if not expire or v>expire then
            expire = v
          end
        end
      end
      if not expire then
        point.remove = true
        playerPoints[guid] = nil
        playerReason[guid] = nil
      else
        point.expire = expire
      end
    end
  end

  local buffPoints = {}
  function H:NewBuffPoint(data,expire,layer)
    local spellId,guid,color,radius = unpack(data,1,4)
    local key = guid.."-"..spellId
    local p = buffPoints[key]
    if p then
      p.remove = true
    end
    if color then
      radius = radius or 8
      expire = expire or GetTime() + 600
      p = self:New("Point",{color=color,radius=radius,expire=expire,position={guid=guid},layer=layer})
      buffPoints[key] = p
    end
  end
  function H:RemoveBuffPoint(data)
    local spellId,guid,color,radius = unpack(data,1,4)
    local key = guid.."-"..spellId
    local p = buffPoints[key]
    if p then
      p.remove = true
    end
  end
end
