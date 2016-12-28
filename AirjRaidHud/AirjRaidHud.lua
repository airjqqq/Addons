local H = LibStub("AceAddon-3.0"):NewAddon("AirjRaidHud", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
local Cache = AirjCache


function H:OnInitialize()
  AirjRaidHudDB = AirjRaidHudDB or {}
  self.db = AirjRaidHudDB
  self.position = {}
  self.activities = {}
  self.buffer = {}
  self.pointcache = {}
  self.linecache = {}
end

function H:OnEnable()
  self.range = 45
  H:RegisterComm("AIRJRH_COMM")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	self:RegisterChatCommand("arh", function(str,...)
    local key, value, nextposition = self:GetArgs(str, 2)
    local frame = H:GetMainFrame()
    if key == "background" then
      self.db.nobg = not self.db.nobg
      if self.db.nobg then
        self:Print("Background hide.")
        frame.back:Hide()
      else
        self:Print("Background show.")
        frame.back:Show()
      end
    if key == "autohide" then
      self.db.autohide = not self.db.autohide
      self:Print("Autohide "..(self.db.autohide and "enabled" or "disabled")..".")
      self:UpdateMainFrame()
    elseif key == "lock" then
      self.db.lock = true
      self:Print("Frame Locked!")
      frame:EnableMouse(not self.db.lock)
    elseif key == "unlock" then
      self.db.lock = nil
      self:Print("Frame Unlocked!")
      frame:EnableMouse(not self.db.lock)
    elseif key == "scale" then
      local s = tonumber(value)
      if s then
        self.db.scale = s
        frame:SetScale(s)
        self:Print("Frame Scale = "..s)
      end
    elseif key == "range" then
      local s = tonumber(value)
      if s then
        self:SetRange(range)
        self:Print("Ranger = "..s)
      end
    elseif key == "enable"
      self.db.disable = not self.db.disable
      self:Print("Addons "..(self.db.disable and "enabled" or "disabled")..".")
      self:UpdateMainFrame()
    else
      self:Print("enable - nable/disable the addon.")
      self:Print("lock - lock the frame (mouse disable).")
      self:Print("unlock - unlock the frame (mouse enable).")
      self:Print("scale <number> - set frame scale.")
      self:Print("range <number> - set display range.")
      self:Print("background - hide/show background.")
      self:Print("autohide - enable/disable auto hide on nothing to show.")
    end

    -- self:New("Line",{from={x=-518.5,y=2428.7},to={x=-528.5,y=2428.7}})
    -- self:New("Point",{expire=GetTime()+10,position={x=-528.5,y=2428.7}})
  end)
  -- self:ScheduleRepeatingTimer(self.UpdateMainFrame,0.1,self)

  if self.db.disable then
    H:GetMainFrame():Hide()
    return
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
  frame.player:SetSize(size,size)
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
          self["Update"..t](self,activity)
          show = true
        end
      end
    end
    if show then
      -- local size = 1000/self.range
      -- frame.player:SetSize(size,size)
      frame:Show()
    else
      frame:Hide()
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
end --util end

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

do -- odyn
  local markerindex = {2,3,6,5,1}
  local cx,cy,cz = -528.5,2428.7,749
  local r = 32
  local left = {
    {-552.2,2497.5},
    {-533.5,2480.0},
    {-549.2,2458.5},
    {-574.3,2447.7},
    {-573.0,2473.1},
  }
  local right = {}
  for i,v in pairs(left) do
    local x,y = v[1],v[2]
    local j = i
    if j >1 then j = 7-i end
    x = cx*2-x
    right[j] = {x,y}
  end
  local center = {}
  local center2 = {}
  local a = math.pi/2.5
  for i=1,5 do
    local b = math.pi/2 - a*(i-1)
    center[i] = {cx+22*math.cos(b),cy+22*math.sin(b)}
    center2[i] = {cx+33*math.cos(b),cy+33*math.sin(b)}
  end
  local markercolor = {
    {0,1,0,0.8},
    {1,0,0.8,0.8},
    {1,0.5,0,0.8},
    {1,1,0,0.8},
    {0,0.7,1,0.8},
  }
  function H:OdynP3(index)
    local guid = UnitGUID("player")
    local position = self.position[guid]
    if position then
      local x,y = unpack(position)
      if x then
        -- print(x,y)
        local tx,ty
        if self:Distance(x,y,cx,cy)<r then
          tx,ty = unpack(center[index])
        elseif x<cx then
          tx,ty = unpack(left[index])
        else
          tx,ty = unpack(right[index])
        end
        local color = markercolor[index]
        self:New("Line",{color=color,expire=GetTime()+10,from={unit="player"},to={x=tx,y=ty}})
        self:New("Point",{color=color,expire=GetTime()+10,position={x=tx,y=ty}})
      end
    end
  end
  local lp1,lp2
  function H:OdynP1(index)
    local tx,ty = unpack(center2[index])
    local color = markercolor[index]
    lp1 = self:New("Line",{color=color,expire=GetTime()+20,from={unit="player"},to={x=tx,y=ty}})
    lp2 = self:New("Point",{color=color,expire=GetTime()+20,position={x=tx,y=ty}})
  end

  function H:OdynP1Clear()
    if lp1 and type(lp1) == "table" and lp1.type then
      lp1.remove = true
      lp1 = nil
    end
    if lp2 and type(lp2) == "table" and lp2.type then
      lp2.remove = true
      lp2 = nil
    end
  end
end

do --Guarm
  local constids = {
    228758,
    228768,
    228769,
  }
  local constNames = {}
  for i,v in ipairs(constids) do
    constNames[i] = GetSpellInfo(v)
  end
  local colors = {
    {1,0.5,0,1},
    {0,1,0.5,1},
    {0.8,0,1,1},
  }
  local messages = {
    "{circle}",
    "{square}",
    "{diamond}",
  }
  function H:GuarmFoam(index)
    if UnitDebuff("player",constNames[index]) then return end
    self.buffer.foam = self.buffer.foam or {}
    self.buffer.foamtimer = self:ScheduleRepeatingTimer(function()
      SendChatMessage(messages[index],"SAY")
    end,0.5)
    for i=1,20 do
      local u = "raid"..i
      if not UnitIsUnit("player",u) then
        local color
        if UnitDebuff(u,constNames[index]) then
          color = colors[index]
        else
          color = {0.3,0.3,0.3,0.5}
        end
        self.buffer.foam[i] = self:New("Point",{color=color,radius=1.5,expire=GetTime()+9,position={unit=u}})
      end
    end
  end

  function H:GuarmFoamClear()
    self.buffer.foam = self.buffer.foam or {}
    for k,v in pairs(self.buffer.foam) do
      v.remove = true
      self.buffer.foam[k] = nil
    end
  end
end


function H:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
  local playerGuid = UnitGUID("player")
  --test
  -- if spellId==116694 and event == "SPELL_CAST_START" then
  --   self:OdynP1Clear()
  --   self:OdynP1(2)
  -- end
  -- if spellId==116694 and event == "SPELL_CAST_SUCCESS" then
  --   self:OdynP1Clear()
  -- end
  --tes end

  --Xavius
  do
    if spellId==211802 and event == "SPELL_AURA_APPLIED" then  -- blade
      if self.buffer.lastblade then
        self:SetRange(30)
        local a = self:New("Line",{length = 200,width = 3, color={1,0.3,0,0.5},expire=GetTime()+6,from={guid=self.buffer.lastblade},to={guid=destGUID}})
        self:ScheduleTimer(function() self:Freeze(a.from) self:Freeze(a.to) end,4)
        self.buffer.lastblade = nil
      else
        self.buffer.lastblade = destGUID
        self:ScheduleTimer(function() self.buffer.lastblade = nil end,4)
      end
    end
    if (spellId==209034 or spellId == 210451) and event == "SPELL_AURA_APPLIED" then  -- Terror
      if self.buffer.lastterror then
        if self.buffer.lastterror == playerGuid or destGUID == playerGuid then
          self:SetRange(20)
          self.buffer.lastterrorAct = self:New("Line",{width = 1, color={1,0.3,0,0.5},expire=GetTime()+20,from={guid=self.buffer.lastterror},to={guid=destGUID}})
          local targetGuid
          if self.buffer.lastterror == playerGuid then
            targetGuid = destGUID
          else
            targetGuid = self.buffer.lastterror
          end
          self.buffer.lastterrorAct2 = self:New("Point",{radius = 2, color={1,0.3,0,0.5},expire=GetTime()+20,position={guid=targetGuid}})
        end
        self.buffer.lastterror = nil
      else
        self.buffer.lastterror = destGUID
        self:ScheduleTimer(function() self.buffer.lastterror = nil end,4)
      end
    end
    if (spellId==209034 or spellId == 210451) and event == "SPELL_AURA_REMOVED" and destGUID == playerGuid then  -- Terror
      if self.buffer.lastterrorAct then
        self.buffer.lastterrorAct.remove = true
        self.buffer.lastterrorAct = nil
      end
      if self.buffer.lastterrorAct2 then
        self.buffer.lastterrorAct2.remove = true
        self.buffer.lastterrorAct2 = nil
      end
    end
    if spellId==206651 and event == "SPELL_AURA_APPLIED_DOSE" then  -- tank debuff
      local _,amount = ...
      if amount==3 then
        self:SetRange(40)
        self.buffer.soul = self.buffer.soul or {}
        self.buffer.soul[destGUID.."1"] = self:New("Point",{radius = 25, color={0,0.5,1,0.1},expire=GetTime()+60,position={guid=destGUID}})
      	local	_, class = GetPlayerInfoByGUID(destGUID)
        if class then
          local c = RAID_CLASS_COLORS[class]
          self.buffer.soul[destGUID.."2"] = self:New("Point",{radius = 2, color={c.r,c.g,c.b,1},expire=GetTime()+60,position={guid=destGUID}})
        end
      end
    end
    if spellId==206651 and event == "SPELL_AURA_REMOVED" then  -- tank debuff
      if self.buffer.soul[destGUID.."1"] then
        self.buffer.soul[destGUID.."1"].remove = true
        self.buffer.soul[destGUID.."1"] = nil
      end
      if self.buffer.soul[destGUID.."2"] then
        self.buffer.soul[destGUID.."2"].remove = true
        self.buffer.soul[destGUID.."2"] = nil
      end
    end

  end

  --Odyn
  do
    local odynp3 = {
      [231346] = 1,
      [231311] = 2,
      [231342] = 3,
      [231344] = 4,
      [231345] = 5,
    }
    local odynp1 = {
      [229583] = 1,
      [229579] = 2,
      [229580] = 3,
      [229581] = 4,
      [229582] = 5,
    }
    if destGUID == playerGuid and odynp3[spellId] and event == "SPELL_AURA_APPLIED" then  -- p3
      self:SetRange(30)
      self:OdynP3(odynp3[spellId])
    end

    if destGUID == playerGuid and odynp1[spellId] and event == "SPELL_AURA_APPLIED" then -- p1
      self:SetRange(30)
      self:OdynP1Clear()
      self:OdynP1(odynp3[spellId])
    end

    if destGUID == playerGuid and spellId == 229584 and event == "SPELL_AURA_APPLIED" then -- p1
      self:OdynP1Clear()
    end

    if spellId == 228162 and event == "SPELL_CAST_START" then  -- sheild of holy
      self:SetRange(20)
      local unit
      for i = 1,4 do
        if sourceGUID== UnitGUID("boss"..i) then
          unit = "boss"..i
          break
        end
      end
      -- if not unit then
      --   if sourceGUID== playerGuid then
      --     unit = "player" --test
      --   end
      -- end
      if unit then
        self:New("Line",{length = 200,width = 5, color={1,1,0,0.5},expire=GetTime()+4,from={unit=unit},to={unit=unit.."target"}})
        for i=1,20 do
          local u = "raid"..i
          if not UnitIsUnit("player",u) then
            local _,class = UnitClass(u)
            if class then
              local c = RAID_CLASS_COLORS[class]
              self:New("Point",{color={c.r,c.g,c.b,1},radius=1.5,expire=GetTime()+4,position={unit=u}})
            end
          end
        end
      end
    end
    if spellId == 228012 and event == "SPELL_CAST_START" then  --
      self:SetRange(20)
      self:New("Point",{color={0,0.5,0,0.2},radius=6,expire=GetTime()+4.5,position={unit="player"}})
      for i=1,20 do
        local u = "raid"..i
        if not UnitIsUnit("player",u) then
          local _,class = UnitClass(u)
          if class then
            local c = RAID_CLASS_COLORS[class]
            self:New("Point",{color={c.r,c.g,c.b,1},radius=1.5,expire=GetTime()+4.5,position={unit=u}})
          end
        end
      end
    end
  end
  do -- Guarm
    local debuffs = {
      [228744] = 1,
      [228810] = 2,
      [228818] = 3,
      [228794] = 1,
      [228811] = 2,
      [228819] = 3,
    }

    if destGUID == playerGuid and debuffs[spellId] and event == "SPELL_AURA_APPLIED" then -- foam
      self:SetRange(30)
      self:GuarmFoamClear()
      self:GuarmFoam(debuffs[spellId])
    end

    if destGUID == playerGuid and debuffs[spellId] and event == "SPELL_AURA_REMOVED" then -- foam
      self:GuarmFoamClear()
    end
  end




















































end
