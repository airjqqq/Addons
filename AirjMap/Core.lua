local ADDON_NAME = ...
local Core = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
_G[ADDON_NAME] = Core


--utils
local function rotate(x,y,a)
  local s,c = math.sin(a),math.cos(a)
  return x*c - y*s, x*s+y*c
end

local function real2map(x,y,D)
  local cx,cy,r,d = unpack(Core.origin)
  local dx,dy = (x-cx)/d, (y-cy)/d
  dx,dy = rotate(dx,dy,r)
  return dx,dy, D and D/d
end

local function map2real(x,y,D)
  local cx,cy,r,d = unpack(Core.origin)
  local dx,dy = rotate(x,y,-r)
  return cx+dx*d,cy+dy*d, D and D*d
end

local function getRotation ()
  local cx,cy,r,d = unpack(Core.origin)
  return r
end

local function round(x,p)
	p = p or 1
	return math.floor(x/p+0.5)*p
end

local function getClassColor(class)
	local d = RAID_CLASS_COLORS[class]
	if d then
		return d.r,d.g,d.b,1
	end
end

--

function Core:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New(ADDON_NAME.."DB",self.defaultOptions)
	self.drawables = {}
end

function Core:OnEnable()
  self:CreateMap()
  self:ScheduleRepeatingTimer(self.MapTracker,1,self)
  self:ScheduleRepeatingTimer(self.Draw,0.01,self)

	self.origin = self:GetOrigin()

	-- Core.test1 = Core.HarmPlayer({position={type="unit",data="player"}})
	-- Core.test2 = Core.HarmPlayer({position={type="unit",data="target"}})
end

function Core:CreateMap()
  local frame = CreateFrame("Frame")
  do
    local point,parent,anchorPoint,offsetX,offsetY,width,height = unpack(self.db.profile.mapPoint)
    if not point then
      point,parent,anchorPoint,offsetX,offsetY,width,height = "BOTTOMLEFT","UIParent","BOTTOMLEFT",0,180,200,200
    end
    frame:SetPoint(point,parent,anchorPoint,offsetX,offsetY)
    frame:SetSize(width,height)
  end
  local bgTexture = frame:CreateTexture()
  bgTexture:SetAllPoints()
  bgTexture:SetColorTexture(0.2,0.2,0.2,1)
  bgTexture:SetDrawLayer("BACKGROUND",-2)
  frame:RegisterForDrag("LeftButton","RightButton")
  frame:EnableMouse(true)
  frame:SetScript("OnDragStart",function(self, button)
		if not IsShiftKeyDown() then
			local origin,key = Core:GetOrigin()
			local sx,sy = GetCursorPosition()
			self:SetScript("OnUpdate",function()
				local cx,cy = GetCursorPosition()
				local s = Core:GetSize()
				local rx,ry = (cx-sx)/s*origin[4],(cy-sy)/s*origin[4]
				Core.db.profile.origins[key] = {origin[1]-rx,origin[2]-ry,0,origin[4]}
				Core:RefreshMap()
			end)
		else
	    if button == "LeftButton" then
	      self:SetMovable(true)
	      self:StartMoving()
	    else
	      self:SetResizable(true)
	      self:StartSizing()
				self:SetScript("OnUpdate",function () Core:RefreshMap() end)
	    end
		end
  end)
  frame:SetScript("OnDragStop",function(self)
    self:StopMovingOrSizing()
		self:SetScript("OnUpdate",nil)
		Core:RefreshMap()
  end)
	frame:SetScript("OnMouseWheel",function (self, delta)
		local origin,key = Core:GetOrigin()
		if delta<0 then
			origin[4] = origin[4]*1.05
		else
			origin[4] = origin[4]/1.05
		end
		Core.db.profile.origins[key] = origin
		Core:RefreshMap()
	end)
  frame:SetScript("OnMouseDown",function(self,...)
    if IsAltKeyDown() and IsShiftKeyDown() then
  		local origin,key = Core:GetOrigin()
  		Core.db.profile.origins[key] = nil
    end
  end)
  frame.overlays = {}
  for i = 1,12 do
    frame.overlays[i] = frame:CreateTexture(ADDON_NAME.."BGT"..i)
    frame.overlays[i]:SetDrawLayer("BACKGROUND",-1)
  end
  frame:SetMinResize(100, 100)
  self.mapFrame = frame
end

function Core:GetSize()
  local width,height = self.mapFrame:GetSize()
  local size = min(width,height)
	return size, width, height
end

function Core:GetMapPath()
	local mapFileName, textureHeight, _, isMicroDungeon, microDungeonMapName = GetMapInfo()
	if (isMicroDungeon and (not microDungeonMapName or microDungeonMapName == "")) then
		return
	end
  if ( not mapFileName ) then
		if ( GetCurrentMapContinent() == WORLDMAP_COSMIC_ID ) then
			mapFileName = "Cosmic";
		else
			-- Temporary Hack (copy of a "temporary" 6 year hack)
			mapFileName = "World";
		end
	end
  local dungeonLevel = GetCurrentMapDungeonLevel();
  if (DungeonUsesTerrainMap()) then
    dungeonLevel = dungeonLevel - 1;
  end

  local path;
  if (not isMicroDungeon) then
    path = "Interface\\WorldMap\\"..mapFileName.."\\"..mapFileName;
  else
    path = "Interface\\WorldMap\\MicroDungeon\\"..mapFileName.."\\"..microDungeonMapName.."\\"..microDungeonMapName;
  end

  if ( dungeonLevel > 0 ) then
    path = path..dungeonLevel.."_";
  end
	return path
end

function Core:GetOrigin()
	self.db.profile.origins = self.db.profile.origins or {}
	local origins = self.db.profile.origins
	local mapId = GetCurrentMapAreaID()
	local dungeonLevel = GetCurrentMapDungeonLevel()
	local key = mapId..":"..dungeonLevel
	local origin = origins[key]
	if origin then
		return origin,key
	end
	local centerX,centerY = AirjHack:Position(UnitGUID("player"))
	return {centerX,centerY,0,120},key
end

function Core:GetBound()
	local _,_,_,l,r,t,b = GetAreaMapInfo(GetCurrentMapAreaID())
	local _,dr,db,dl,dt = GetCurrentMapDungeonLevel()
	if dl then
		l,r,t,b = -dl,-dr,dt,db
	elseif l then
		l,r = -l,-r
	end
	return {l,r,t,b}
end

function Core:MapTracker()
	local path = self:GetMapPath()
	if self.path ~= path then
		self.path = path
		self.mapBound = self:GetBound()
		self:RefreshMap()
	end
  -- local _,_,_,l,r,t,b = GetAreaMapInfo(mapId)
  -- l = -l
  -- r = -r
end

function Core:RefreshMap()
	self.origin = self:GetOrigin()
	local size, width, height = self:GetSize()
	local l,r,t,b = unpack(self.mapBound)
	if not r then
    for i = 1,12 do
      local texture = self.mapFrame.overlays[i]
    	texture:Hide()
    end
    return
  end
	local path = self.path
  for i = 1,12 do
    local texture = self.mapFrame.overlays[i]
    -- self.mapFrame.overlays[i]:SetColorTexture(i/12,0,0,0.2);
		local x, y = (i-1)%4,math.floor((i-1)/4)
    local rd = 0.256*(r-l)
    local rx,ry = l+(x+0.5)*rd,t-(y+0.5)*rd
    local mx,my,md = real2map(rx,ry,rd)
    local cl,cr,ct,cb
    cl,ct = map2real(-0.5*width/size,0.5*height/size,1)
    cl = (cl-rx)/rd+0.5
    ct = -(ct-ry)/rd+0.5
    cr,cb = map2real(0.5*width/size,-0.5*height/size,1)
    cr = (cr-rx)/rd+0.5
    cb = -(cb-ry)/rd+0.5
		-- print(i,rx,ry,mx,my)
    if cl>1 or cr<0 or ct>1 or cb<0 then
    	texture:Hide()
    else
      cl,cr,ct,cb = max(cl,0),min(cr,1),max(ct,0),min(cb,1)
			-- cl,cr,ct,cb = round(cl,1/256),round(cr,1/256),round(ct,1/256),round(cb,1/256)
      local w,h = cr-cl,cb-ct
      -- local pl,pr,pt,pb=mx+(cl-0.5)*md,mx+(cr-0.5)*md,my-(ct-0.5)*md,my-(cb-0.5)*md
      local px,py = mx + (cl+cr-1)*md/2,my - (ct+cb-1)*md/2
      -- texture:SetPoint("TOPLEFT",self.mapFrame,"CENTER",size*pl,size*pt)
      -- texture:SetPoint("BOTTOMRIGHT",self.mapFrame,"CENTER",size*pr,size*pb)
      texture:SetTexture(path..i);
      texture:ClearAllPoints()
      texture:SetPoint("CENTER",size*px,size*py)
      texture:SetSize(w*size*md,h*size*md)
      -- texture:SetTexCoord(cl,ct,cl,cb,cr,ct,cr,cb)
      texture:SetTexCoord(cl,cr,ct,cb)
			-- print(i,cl,cr,ct,cb)
      texture:Show()

    end
  end
end

Core.defaultOptions = {
	profile = {
    mapPoint = {},
		origins = {},
	}
}

function Core:Draw()
	Core.Mesh:ResetTextures()
	for id,drawable in pairs(self.drawables) do
		drawable:PreUpdate()
		drawable:Update()
		drawable:PostUpdate()
	end
end


local Listenable = AirjUtil:Class("Listenable")

function Listenable:New(...)
	-- print(self._supperI)
	local o = self:Supper("New",...)
	o.listeners = {}
	return o
end
function Listenable:AddListener(when,fcn)
	self.listeners[when] = self.listeners[when] or {}
	local id = AirjUtil:UUID()
	self.listeners[when][id] = fcn
	return id
end
function Listenable:RemoveListener(when,id)
	if self.listeners[when] then
		if self.listeners[when][id] then
			self.listeners[when][id] = nil
		end
	end
end
function Listenable:RemoveAllListeners(when,id)
	if self.listeners[when] then
		wipe(self.listeners[when])
	end
end
function Listenable:ScanListeners(when)
	local l = self.listeners[when]
	if l then
		for i,f in pairs(l) do
      local r, m = pcall(f,self)
      if not r then
        self:Print("ERROR:"..m)
      end
		end
	end
end

local Mesh = AirjUtil:Class("Mesh")
Core.Mesh = Mesh
-- static
function Mesh:Texture()
	if self._id then error("static can only called by CLASS") end
	self.cache = self.cache or {}
	self.cacheI = self.cacheI or 0
	self.cacheI = self.cacheI + 1
	local texture = self.cache[self.cacheI]
	if not texture then
		texture=Core.mapFrame:CreateTexture("AIRJMAP_"..self._class:upper().."_"..self.cacheI,"ARTWORK")
		texture:SetTexture("Interface\\AddOns\\AirjMap\\Textures\\triangle")
		self.cache[self.cacheI] = texture
	end
	return texture
end
-- static
function Mesh:ResetTextures()
	if self._id then error("static can only called by CLASS") end
	self.cacheI = nil
	if self.cache then
		for k,v in pairs(self.cache) do
			v:Hide()
		end
	end
end

function Mesh:New(t1,t2,t3,c)
	local o = self:Supper("New")
	o.map = {}
	o.real = {}
	o:SetTs(t1,t2,t3)
	if c then o:SetColor(c) end
	return o
end

function Mesh:SetTs(t1,t2,t3)
	self.real[1] = t1 or {}
	self.real[2] = t2 or {}
	self.real[3] = t3 or {}
end

function Mesh:SetColor(...)
	self.color = {...}
end

function Mesh:GetColor()
	if self.color and self.color[3] then
		return unpack(self.color)
	else
		return 0,0,0,1
	end
end

function Mesh:GetLevel()
	return self.level or 0
end
function Mesh:SetLevel(level)
	self.level = level
end
function Mesh:IsShow()
	return not self.hiden
end

function Mesh:SetShow(show)
	self.hiden = not show
end

function Mesh:Real2Map(bx,by,bz,bf)
	for i = 1,3 do
		local x,y,z = unpack(self.real[i])
		if x then
			bf = bf or 0
			x,y = rotate(x,y,bf)
			x,y = bx+x,by+y
			x,y = real2map(x,y)
			self.map[i] = {x,y}
		end
	end
end

function Mesh:Draw()
	if not self.map[1] then return end
	local x1,y1 = unpack(self.map[1])
	local x2,y2 = unpack(self.map[2])
	local x3,y3 = unpack(self.map[3])
	local size, width, height = Core:GetSize()

	local minx=min(x1,x2,x3)
	local miny=min(y1,y2,y3)
	local maxx=max(x1,x2,x3)
	local maxy=max(y1,y2,y3)

	if maxx*size<-width/2 then return
	elseif minx*size>width/2 then return
	elseif maxy*size<-height/2 then return
	elseif miny*size>height/2 then return
	end

	local dx=maxx-minx
	local dy=maxy-miny
	if dx==0 or dy==0 then return end

	local tx3,ty1,ty2,ty3
	if x1==minx then
		if x2==maxx then
			tx3,ty1,ty2,ty3=(x3-minx)/dx,(maxy-y1),(maxy-y2),(maxy-y3)
		else
			tx3,ty1,ty2,ty3=(x2-minx)/dx,(maxy-y1),(maxy-y3),(maxy-y2)
		end
	elseif x2==minx then
		if x1==maxx then
			tx3,ty1,ty2,ty3=(x3-minx)/dx,(maxy-y2),(maxy-y1),(maxy-y3)
		else
			tx3,ty1,ty2,ty3=(x1-minx)/dx,(maxy-y2),(maxy-y3),(maxy-y1)
		end
	else -- x3==minx
		if x2==maxx then
			tx3,ty1,ty2,ty3=(x1-minx)/dx,(maxy-y3),(maxy-y2),(maxy-y1)
		else
			tx3,ty1,ty2,ty3=(x2-minx)/dx,(maxy-y3),(maxy-y1),(maxy-y2)
		end
	end

	local t1=-0.99609375/(ty3-tx3*ty2+(tx3-1)*ty1) -- 0.99609375==510/512
	local t2=dy*t1
	x1=0.001953125-t1*tx3*ty1 -- 0.001953125=1/512
	x2=0.001953125+t1*ty1
	x3=t2*tx3+x1
	y1=t1*(ty2-ty1)
	y2=t1*(ty1-ty3)
	y3=-t2+x2

	if abs(t2)>=9000 then return end

	local texture = Mesh:Texture()
	texture:Hide()


	texture:ClearAllPoints()
	texture:SetPoint("BOTTOMLEFT",Core.mapFrame,"CENTER",minx*size,miny*size)
	texture:SetPoint("TOPRIGHT",Core.mapFrame,"CENTER",maxx*size,maxy*size)

	-- print(minx,miny)

	texture:SetTexCoord(x1,x2,x3,y3,x1+y2,x2+y1,y2+x3,y1+y3)

	texture:SetVertexColor(self:GetColor())
	texture:SetDrawLayer("ARTWORK",self:GetLevel())
	texture:Show()
end

local Drawable = AirjUtil:Class("Drawable",Listenable)

Core.Drawable = Drawable

function Drawable:New(...)
	local o = self:Supper("New",...)
	Core.drawables[o._id] = o
	o.meshs = {}
	o.rebuild = true
	return o
end

function Drawable:AddMesh(mesh)
	tinsert(self.meshs,mesh)
	return #self.meshs
end

function Drawable:GetMesh(i)
	return self.meshs[i]
end

function Drawable:Show()
	self:ScanListeners("show")
end

function Drawable:PreUpdate()
	if self.rebuild then
		self.rebuild = nil
		self:Rebuild()
	end
	self:ScanListeners("preUpdate")
end

function Drawable:Update()
	self:ScanListeners("update")
	for i,mesh in ipairs(self.meshs) do
		if mesh:IsShow() then
			mesh:Draw()
		end
	end
end

function Drawable:PostUpdate()
	self:ScanListeners("postUpdate")
	if self.remove then
		self:Remove()
	end
end

function Drawable:Rebuild()
	self:ScanListeners("rebuild")
end

function Drawable:Remove()
	Core.drawables[self._id] = nil
	self:ScanListeners("remove")
  wipe(self)
end

local Aura = AirjUtil:Class("Aura")
Core.Aura = Aura

function Aura:New(...)
	local o = self:Supper("New",...)
	return o
end

local Unit = AirjUtil:Class("Unit",Drawable)
Core.Unit = Unit

function Unit:New(...)
	local o = self:Supper("New",...)
	o.auraMeshs = {}
	for i = 1,14 do
		local mesh = Mesh()
		mesh:SetLevel(-2)
		o:AddMesh(mesh)
		o.auraMeshs[i] = mesh
	end
  o.auras = {}
	return o
end

function Unit:Update()
	local x,y,z,f,s = self:GetBasePosition()
	if x then
		for i,mesh in ipairs(self.meshs) do
			if mesh:IsShow() then
				mesh:Real2Map(x,y,z,f)
			end
		end
  	self:Supper("Update")
	end
end

function Unit:GetBasePosition()
	local position = self:Get("position")
	if not position then return end
	if position.type == "absolute" then
		return unpack(position.data)
	elseif position.type == "guid" then
		return AirjHack:Position(position.data)
	elseif position.type == "unit" then
		local guid = UnitGUID(position.data)
		if guid then
			return AirjHack:Position(guid)
		end
	end
end
function Unit:GetColor()
	if self._data.color then
		return unpack(self._data.color)
	end
end

function Unit:GetSize()
	return self:Get("size") or 2
end

function Unit:GetBorderColor()
	if self._data.borderColor then
		return unpack(self._data.borderColor)
	end
end

function Unit:Rebuild()
	self:Supper("Rebuild")
  -- local duration, expires, c1, c2,size = self:GetAuraInfo()
  -- size = size * self:GetSize()
  -- for i = 1,12 do
  --   local mesh = self.auraMeshs[i]
	-- 	local x1,y1 = rotate(0,size,i/6*math.pi)
	-- 	local x2,y2 = rotate(0,size,(i-1)/6*math.pi)
	-- 	mesh:SetTs({0,0,0},{x1,y1,0},{x2,y2,0})
	-- end
end

function Unit:PreUpdate()
	self:Supper("PreUpdate")
  local mesh1,mesh2 = self.auraMeshs[13],self.auraMeshs[14]
  local size = self:GetSize()*3
  local duration, expires, c1, c2,size = self:GetAuraInfo()
  local si = duration and math.ceil((expires-GetTime())*12/duration)
  if not si or si <= 0 then
    for i = 1,14 do
      local mesh = self.auraMeshs[i]
      mesh:SetShow(false)
    end
  else
    size = size * self:GetSize()
    local remain = expires-GetTime()
    if si > 12 then
      mesh1:SetShow(false)
      mesh2:SetShow(false)
    else
      local x1,y1 = rotate(0,size,si/6*math.pi)
      local x2,y2 = rotate(0,size,(si-1)/6*math.pi)
      local xs,ys = rotate(0,size,(remain*12/duration)/6*math.pi)
      mesh1:SetTs({0,0,0},{xs,ys,0},{x2,y2,0})
      mesh2:SetTs({0,0,0},{x1,y1,0},{xs,ys,0})
      mesh1:SetColor(unpack(c1))
      mesh2:SetColor(unpack(c2))
      mesh1:SetShow(true)
      mesh2:SetShow(true)
    end
    for i = 1,12 do
      local mesh = self.auraMeshs[i]
  		local x1,y1 = rotate(0,size,i/6*math.pi)
  		local x2,y2 = rotate(0,size,(i-1)/6*math.pi)
  		mesh:SetTs({0,0,0},{x1,y1,0},{x2,y2,0})
      if i < si then
        mesh:SetShow(true)
        mesh:SetColor(unpack(c1))
      elseif i == si then
        mesh:SetShow(false)
      else
        mesh:SetShow(true)
        mesh:SetColor(unpack(c2))
      end
    end
  end
end
local e = GetTime()+25
function Unit:GetAuraInfo()
  local priority, data
  local now = GetTime()
  for i,aura in ipairs(self.auras) do
    if now > aura.data[2] then
      tremove(self.auras,i)
    else
      if not priority or priority<aura.priority then
        priority = aura.priority
        data = aura.data
      elseif priority == aura.priority then
        if aura.data[2] > data[2] then
          priority = aura.priority
          data = aura.data
        end
      end
    end
  end
  if data then
    return unpack(data)
  end
end

function Unit:RemoveAura(id)
  for i,aura in ipairs(self.auras) do
    if aura._id == id then
      tremove(self.auras,i)
      self.rebuild = true
      return
    end
  end
end

function Unit:AddAura(priority,duration, expires, c1, c2,size)
  local aura = Aura()
  aura.data = {duration, expires, c1, c2,size}
  aura.priority = priority
  tinsert(self.auras,aura)
  self.rebuild = true
  return aura._id
end

local HelpUnit = AirjUtil:Class("HelpUnit",Unit)
Core.HelpUnit = HelpUnit

function HelpUnit:New(...)
	local o = self:Supper("New",...)
	o.fills = {}
	o.borders = {}
	for i = 1,12 do
		local mesh = Mesh()
		mesh:SetLevel(1)
		o:AddMesh(mesh)
		o.fills[i] = mesh
	end
	for i = 1,12 do
		local mesh = Mesh()
		mesh:SetLevel(-1)
		o:AddMesh(mesh)
		o.borders[i] = mesh
	end
	return o
end
function HelpUnit:Rebuild()
	self:Supper("Rebuild")
	for i,mesh in ipairs(self.fills) do
		local size = self:GetSize()
		local x1,y1 = rotate(0,size,i/6*math.pi)
		local x2,y2 = rotate(0,size,(i-1)/6*math.pi)
		mesh:SetTs({0,0,0},{x1,y1,0},{x2,y2,0})
		mesh:SetColor(self:GetColor())
	end
	for i,mesh in ipairs(self.borders) do
		local size = self:GetSize()
		local a1, a2 = i/6*math.pi,(i-1)/6*math.pi
		local pi3 = math.pi/3
		local function a2r(a)
			if a == 0 or a > 6*pi3-0.01 then
				r = size*2.5
			elseif a< pi3 then
				r = size*1.5 + (pi3 - a)/pi3 * size*0.25
			elseif a>5*pi3 then
				r = size*1.5 + (a-5*pi3)/pi3 * size*0.25
			else
				r = size*1.5
			end
			return r
		end
		local x1,y1 = rotate(0,a2r(a1),a1)
		local x2,y2 = rotate(0,a2r(a2),a2)
		mesh:SetTs({0,0,0},{x1,y1,0},{x2,y2,0})
		mesh:SetColor(self:GetBorderColor())
	end
end

local HelpPlayer = AirjUtil:Class("HelpPlayer",HelpUnit)
Core.HelpPlayer = HelpPlayer

function HelpPlayer:GetColor()
	local position = self:Get("position")
	if position then
		if position.type == "guid" then
			local _,class = GetPlayerInfoByGUID(position.data)
			return getClassColor(class)
		elseif position.type == "unit" then
			local _,class = UnitClass(position.data)
			return getClassColor(class)
		end
	end
	return self:Supper(GetColor)
end

local HarmPlayer = AirjUtil:Class("HarmPlayer",Unit)
Core.HarmPlayer = HarmPlayer

local function getArrow(aw2,alf,alb,als,abs,size)
  abs = abs or 0
  local arrow = {
  	{{0,-alb-abs*1.5},{aw2+abs,-(alb-aw2)-abs*0.5},{-aw2-abs,-(alb-aw2)-abs*0.5},{aw2+abs,alf-aw2+abs*0.5},{-aw2-abs,alf-aw2+abs*0.5},{0,alf+abs*1.5}},
    {{aw2+abs,alf-aw2+abs*0.5},{aw2+abs,alf-aw2*3-abs*2.5},{als+abs,alf-als+abs*0.5},{als+abs,alf-als-aw2*2-abs*2.5}},
    {{-aw2-abs,alf-aw2+abs*0.5},{-aw2-abs,alf-aw2*3-abs*2.5},{-als-abs,alf-als+abs*0.5},{-als-abs,alf-als-aw2*2-abs*2.5}},
  }
  local toRet = {}
  local function multi(t,p)
    return {t[1]*p,t[2]*p,0}
  end
  for _,p in ipairs(arrow) do
    for j = 3, #p do
      tinsert(toRet,{multi(p[j-2],size),multi(p[j-1],size),multi(p[j],size)})
    end
  end
  return toRet
end

function HarmPlayer:New(...)
	local o = self:Supper("New",...)
  o.fills = {}
	o.borders = {}
	for i = 1,8 do
		local mesh = Mesh()
		mesh:SetLevel(1)
		o:AddMesh(mesh)
    o.fills[i] = mesh
	end
	for i = 1,8 do
		local mesh = Mesh()
		mesh:SetLevel(-1)
		o:AddMesh(mesh)
    o.borders[i] = mesh
	end
	return o
end

function HarmPlayer:Rebuild()
	self:Supper("Rebuild")
  local size = self:GetSize()
  local function multi(t,p)
    return {t[1]*p,t[2]*p,0}
  end
  local arrow = getArrow(0.4,2.3,1.3,1.3,0,size)
  for i,p in ipairs(arrow) do
    local mesh = self.fills[i]
		mesh:SetTs(unpack(p))
		mesh:SetColor(self:GetColor())
  end
  local borderArrow = getArrow(0.4,2.3,1.3,1.3,0.2,size)
  for i,p in ipairs(borderArrow) do
    local mesh = self.borders[i]
		mesh:SetTs(unpack(p))
		mesh:SetColor(self:GetBorderColor())
  end
end

HarmPlayer.GetColor = HelpPlayer.GetColor
