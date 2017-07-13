local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("PVE","AceEvent-3.0","AceTimer-3.0")
-- local Cache
function mod:OnInitialize()
  -- Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
end


function mod:OnEnable()
  self.drawables = {}
  self.timers = {}
  self:RegisterEvent("GROUP_ROSTER_UPDATE",self.UpdateUnits,self)
  self:UpdateUnits()

  self:ScheduleRepeatingTimer(function()
    if Core.playerAlpha then
      local a = Core.playerAlpha
      Core.playerAlpha = nil
      for guid,data in pairs(self.drawables) do
        local m = data.drawable
        m.a = a
      end
    end
  end,0.01)


  -- local data = {
  --   color={0.0,0.7,0,0.2},
  --   color2={0.0,0.9,0,0.3},
  --   radius=2.5,
  --   duration=11,
  -- }
  -- Core:RegisterCreateAreaTrigger(242613,data)

end
local function getClassColor(class)
	local d = RAID_CLASS_COLORS[class]
	if d then
		return d.r,d.g,d.b,1
	end
end

local function rotate(x,y,a)
  local s,c = math.sin(a),math.cos(a)
  return x*c - y*s, x*s+y*c
end
local helpLine = {}
do
  local number = 36
  local t = {}
  for i = 1,number do
    local a = i*math.pi*2/number
    local b = a
    if b > math.pi then
      b = 2*math.pi-b
    end
    local size = 1
    if math.abs(b)<math.pi/3 then
      size = size*(1+1/math.cos(math.abs(b)-math.pi/3))/2
    end
    local x,y = rotate(0,size,a)
    t[i] = {x,y,0}
  end
  helpLine = {t}
end
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

local harmLine = getArrow(0.4,2.3,1.3,1.3,0,1.5)

local petLine = {}
do
  local number = 36
  local t = {}
  for i = 1,number do
    local a = i*math.pi*2/number
    local b = a
    if b > math.pi then
      b = 2*math.pi-b
    end
    local size = 1
    if math.abs(b)<math.pi/3 then
      -- size = size*(1+1/math.cos(math.abs(b)-math.pi/3))/2
    end
    local x,y = rotate(0,size,a)
    t[i] = {x,y,0}
  end
  petLine = {t}
end
function mod:GenerateMesh(guid,unit,lines)

  local scene = AVR:GetTempScene(100)
  local m = AVRPolygonMesh:New(lines)
  -- local m = AVRPolygonMesh:New(helpLine)
  scene:AddMesh(m,false,false)
  m:SetFollowUnit(guid)
  -- m:SetFollowUnit(unit)
  local _,class = UnitClass(unit)
  local r,g,b = getClassColor(class)
  m:SetColor(r,g,b,0)
  if unit == "player" then
    m.isplayer = true
  end
  -- local pm = AVRPolygonMesh:New(petLine)
  -- scene:AddMesh(pm,false,false)
  -- pm:SetFollowUnit(unit.."pet")
  -- pm:SetColor(r,g,b,0.5)
  self.drawables[guid] = {
    unit = unit,
    drawable = m,
    -- drawablePet = pm,
  }
end

function mod:UpdateUnits()
  for u,timer in pairs(self.timers) do
    self:CancelTimer(timer)
  end
  wipe(self.timers)
  for guid,data in pairs(self.drawables) do
    data.mayremove = true
  end
  if IsInInstance() ~= "arena" then
    local units
    if IsInRaid() then
      units = {}
      for i=1,40 do
        units[i] = "raid"..i
      end
    elseif IsInGroup() then
      units = {}
      for i=1,4 do
        units[i] = "party"..i
      end
      units[5] = "player"
    end
    if units then
      for i,unit in ipairs(units) do
        local guid = UnitGUID(unit)
        if guid and UnitClass(unit) then
          if not self.drawables[guid] then
            self:GenerateMesh(guid,unit,helpLine)
          else
            self.drawables[guid].mayremove = nil
            -- self.drawables[guid].drawable.rebuild = true
          end
        else
          local timer
          timer = self:ScheduleRepeatingTimer(function()
            local guid = UnitGUID(unit)
            if guid and UnitClass(unit) then
              if not self.drawables[guid] then
                self:GenerateMesh(guid,unit,helpLine)
              end
              self:CancelTimer(timer)
              self.timers[unit] = nil
            end
          end,0.1)
          self.timers[unit] = timer
        end
      end
    end

    -- for i,unit in ipairs({"boss1","boss2","boss3","boss4"}) do
    --   local guid = UnitGUID(unit)
    --   if guid then
    --     if not self.drawables[guid] then
    --       self:GenerateMesh(guid,unit,getArrow(0.4,2.3,1.3,1.3,0,4))
    --     else
    --       self.drawables[guid].mayremove = nil
    --       -- self.drawables[guid].drawable.rebuild = true
    --     end
    --   else
    --     local timer
    --     timer = self:ScheduleRepeatingTimer(function()
    --       local guid = UnitGUID(unit)
    --       if guid and UnitClass(unit) then
    --         if not self.drawables[guid] then
    --           self:GenerateMesh(guid,unit,getArrow(0.4,2.3,1.3,1.3,0,4))
    --         end
    --         self:CancelTimer(timer)
    --         self.timers[unit] = nil
    --       end
    --     end,0.1)
    --     self.timers[unit] = timer
    --   end
    -- end
  end

  for guid,data in pairs(self.drawables) do
    if data.mayremove then
      data.drawable:Remove()
      if drawablePet then data.drawablePet:Remove() end
      self.drawables[guid] = nil
    end
  end
end
