local addonname = ...
local P = LibStub("AceAddon-3.0"):NewAddon(addonname,"AceComm-3.0","AceTimer-3.0","AceConsole-3.0","AceSerializer-3.0","AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")
_G[addonname] = P

--[[

db
  tactics
    mapId:number
    conners:array
      conner:{x,y}
    objects:array
      object:table -- frame
        id:string
        type:string
          player:
            guid:string
            class:string
            role:string[tank,melee,healer,range]
            show:string[class,role,mix]
          npc:
            uid:string
            radius:number
            color:number - rgba
          circle:
            radius:number
            color:number - rgba
          polygon:
            points:array
              point:
                x,y,z - offset
            color:number - rgba
        position:table
          type:string
            abs:
              x,y,z,a
        frames:array
          frame:object
            time:number
            data:table
              key:value
    time:number
]]

function P:OnInitialize()
  self.frameCache = {}
	self.db = LibStub("AceDB-3.0"):New(addonname.."DB",{},true)
end

function P:OnEnable()
  local mainFrame = AceGUI:Create("Frame")
	mainFrame:SetTitle("Airj's Raid Pad")
	mainFrame:SetWidth(850)
	mainFrame:SetHeight(700)
  mainFrame:SetLayout("Fill")
  self.mainFrame = mainFrame

  self.canvas = self:CreateCanvas(mainFrame.frame)
  
  local treeGroup = AceGUI:Create("TreeGroup")
  treeGroup:SetTreeWidth(240,true)
  treeGroup:SetLayout("Flow")
  treeGroup:SetCallback("OnGroupSelected",function(widget,event,uniquevalue)
    self.viewIndex = uniquevalue
  end)

  mainFrame:AddChild(treeGroup)
  self.treeGroup = treeGroup

  if not self:GetTactics("test") then
    local px,py = AirjHack:Position(UnitGUID("player"))
    self:NewTactics("test",{
      mapId = GetCurrentMapAreaID(),
      conners = {{px-40,py+40},{px-40,py-40},{px+40,py+40},{px+40,py-40},},
      objects = {},
    })
  end

end

-- util
local random = math.random
local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end
local Color = {
  parse = function (c)
    if type(c) == "string" then
      return tonumber(c,16)
    elseif type(c) == "table" then
      local ci = 0
      if c.r then
        for i,k in ipairs({"a","r","g","b"}) do
          local v = c[k] or 1
          ci = ci + v/255*256^(i-1)
        end
      elseif c[1] then
        for i,k in ipairs({4,1,2,3}) do
          local v = c[k] or 1
          ci = ci + v/255*256^(i-1)
        end
      end
      return ci
    end
  end,
  tostring = function(ci)
    return string.format("%08x",ci)
  end,
  torgba = function(ci)
    local t = {}
    for i,k in ipairs({4,1,2,3}) do
      t[k] = (floor(ci/256^(i-1))/255)%1
    end
    return unpack(t)
  end,
  class = function(class)
    return tonumber(RAID_CLASS_COLORS[class].colorStr,16)
  end,
  WHITE = 0xffffffff,
}


-- model

function P:GetTactics(name)
  return self.db.tacticses and self.db.tacticses[name]
end

function P:NewTactics(name,data)
  self.db.tacticses = self.db.tacticses or {}
  self.db.tacticses[name] = data
end

function P:GetDataList()
  local s,v = pcall(function() return self.db.tacticses[self.tacticsesId] end)
  if s then
    return v
  else
    return {}
  end
end

function P:FindDataById(id)
  for i,v in ipairs(self:GetDataList()) do
    if (v.id == id) then
      return v,i
    end
  end
end

function P:GetColorByData(data)
  if data.type == "player" then
    if data.show == "role" then
      return Color.WHITE
    else
      return Color.class(data.class)
    end
  else
    return data.color
  end
end

--views
function P:CreateCanvas(frame)
  local canvas = CreateFrame("Frame",frame)
  canvas:SetAllPoints()
  return canvas
end


function P:GetFrameFromCache()
  return tremove(self.frameCache)
end


function P:FindFrameById(id)
  return self:GetFrames()[id]
end


--controller
function P:CreateObject(id)
  local frame = self:GetFrameFromCache()
  if not fram then
    frame = CreateFrame("Frame",self.canvas)
    local texture = frame.texture or frame:CreateTexture()
    texture:SetAllPoints()
    frame.texture = texture
    --tooltip
    frame:SetScript("OnEnter",function(self, motion)
      local data = P:FindDataById(id)
      if data then
        GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
        GameTooltip:AddLine(desc, 1, 1, 1, 1);
        GameTooltip:Show();
        GameTooltip:SetFrameLevel(50);
      end
    end)
    frame:SetScript("OnLeave", function(widget)
      GameTooltip:Hide()
    end)
    --drag
    frame:RegisterForDrag("LeftButton")
    frame:SetMovable(true)
    frame:SetScript("OnDragStart",function(self, button)
      self:StartMoving()
      frame:SetScript("OnUpdate", function(self,e)
        local data = P:FindDataById(id)
        P:SaveDataPositionByCursor(data)
      end)
    end)
    frame:SetScript("OnDragStop",function(self)
      self:StopMovingOrSizing()
    end)
    --
  end
  frame.id = id
  return frame
end
function P:UpdateObject (id)
  local frame = self:FindFrameById(id)
  local data = self:FindDataById(id)
  if not frame or not data then return end
  local color = self:GetColorByData(data)
  frame.texture:SetColorTexture(Color.torgba(color))
  -- body...
end

function P:SaveDataPositionByCursor(data)
end
