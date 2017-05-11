
local Core = LibStub("AceAddon-3.0"):GetAddon("AirjAutoKey")
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local GUI = Core:NewModule("GUI","AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")
--local L = LibStub("AceLocale-3.0"):GetLocale("AirjAutoKey_GUI", true)
local meta = {
__index = function(t,k) return k end
}
local L = setmetatable({}, meta)
local AceGUI = LibStub("AceGUI-3.0")

function GUI:OnInitialize()
	self:CreateFrames()
end

function GUI:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	-- self.updateTimer=self:ScheduleRepeatingTimer(self.Update,0.1,self)
	self.container:SetScript("OnUpdate",self.Update)
end

function GUI:OnDisable()
	-- Called when the addon is disabled
end

local gcd
-- castedIcons
local ignores = {
	[196771] = true,
	[211793] = true,
	[194279] = true,
	[198137] = true,
	[44949] = true,
	[199667] = true,
	[182387] = true,
	[228597] = true,
	[147193] = true,
}
do
  local caststart = {}
  local spellTime = {}
  function GUI:COMBAT_LOG_EVENT_UNFILTERED(realEvent,timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool)
		local localtime = GetTime()
  	if (event == "SPELL_CAST_SUCCESS" or event == "SPELL_CAST_START") and Cache:PlayerGUID() == sourceGUID then
      local guid, dontCreate
      if event == "SPELL_CAST_START" then
        caststart[spellId] = true
				local data = Cache.cache.castSend:find({spellId = spellId})
        if data and data.t and localtime-data.t<1 then
          guid = data.guid
        end
        guid = guid or destGUID
      else
        if caststart[spellId] then
          dontCreate = true
          caststart[spellId] = nil
        end
        guid = destGUID
      end
      if not dontCreate and not ignores[spellId] then
        local t = GetTime()
        local unit = Cache:FindUnitByGUID(guid)
        local _,_,class = pcall(GetPlayerInfoByGUID,guid)
        local lastT = spellId and spellTime[spellId]
        local interval = 0
        if lastT then
          interval = t-lastT
        end
        self:CreateCastedIcon(spellId,unit,class,interval)
        spellTime[spellId] = t
      end
  	end
  end
  local iconLevel = 0
  local rows = {}

  local u2t = {
    {
      u="targettarget",
      t="target-T",
    },
    {
      u="target",
      t="-T",
    },
    {
      u="focus",
      t="F-",
    },
    {
      u="pet",
      t="P",
    },
    {
      u="mouseover",
      t="mouse",
    },
    {
      u="party",
      t="P-",
    },
    {
      u="raid",
      t="R-",
    },
    {
      u="mouse",
      t="M-",
    },
    {
      u="nameplate",
      t="NP-",
    },
  }
  function GUI:CreateCastedIcon(spellId,unit,class,interval)
    local name,_,textureID = GetSpellInfo(spellId)
    local duration = Cache.cache.gcd.duration or 1
  	local container = self.container
  	local castIcon = self.castIcon
  	local icon = CreateFrame("Frame",nil,container)
  	icon:Raise()
    local t = GetTime()
    local row = 1
    for i=1,5 do
      if not rows[i] or t+0.1>rows[i] then
        row = i
        break
      end
    end
    rows[row] = t+duration
  	icon:SetSize(duration*32,32)
    local height = castIcon:GetHeight()
  	icon:SetPoint("RIGHT",castIcon,"RIGHT",32*1.5,(row-1)*32-height/4)
    icon:SetScript("OnEnter",function()
      local link = GetSpellLink(spellId)
      self:Print(link)
    end)

  	local texture = icon:CreateTexture(nil,"BACKGROUND")
  	texture:SetAllPoints()
  	texture:SetTexture(textureID)
    if unit then
      local text = unit
      for i,v in ipairs(u2t) do
        if strlen(text) <=6 then
          break
        end
        text = string.gsub(text,v.u,v.t)
        -- self:Print(text,v.u,v.t,string.gsub(text,v.u,v.t))
      end

    	local unitFontString = icon:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    	-- local f,s = unitFontString:GetFont()
    	unitFontString:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
    	unitFontString:SetSize(duration*32,16)
      unitFontString:SetPoint("BOTTOM")
    	unitFontString:SetText(text)
    	local color = RAID_CLASS_COLORS[class or ""] or {r=0.8,g=0.8,b=0.8}
    	if color then
    		unitFontString:SetTextColor(color.r,color.g,color.b)
    	end
    end
    if interval and interval ~= 0 then
      local text
			if interval>14 then
				text = string.format("%0.1f",interval)
			else
				text = string.format("x%0.1f",interval/duration)
			end
    	local intervalFontString = icon:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    	-- local f,s = unitFontString:GetFont()
    	intervalFontString:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
    	intervalFontString:SetSize(duration*32,16)
    	intervalFontString:SetJustifyH("RIGHT")
      intervalFontString:SetPoint("TOP")
    	intervalFontString:SetText(text)
    	intervalFontString:SetTextColor(0,0.5,0)
    end

    -- local unitFontString = icon:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    -- local f,s = unitFontString:GetFont()
    -- unitFontString:SetFont(f,12)
    -- unitFontString:SetSize(duration*32,12)
    -- unitFontString:SetText(unit)
    -- local color = RAID_CLASS_COLORS[class or ""]
    -- if color then
    --   unitFontString:SetTextColor(color.r,color.g,color.b)
    -- end

  	local animationGroup = icon:CreateAnimationGroup()
  	local animation = animationGroup:CreateAnimation("Translation")
  	animation:SetOffset(32*5, 0)
  	animation:SetDuration(1*5)
  	animation:SetOrder(1)
  	animation:SetSmoothing("NONE")
  	animationGroup:Play()
  	animationGroup:SetScript("OnUpdate",function(self)
      local elapsed = animation:GetElapsed()
      local offset = elapsed*32
      -- GUI:Print(name,offset)
  		icon:SetHitRectInsets(offset, -offset, 0, 0)
  	end)
  	animationGroup:SetScript("OnFinished",function(self)
  		icon:Hide()
  	end)
  end
end

local widgets = {
	{
		name = L["Move"],
		update = function(widget)
			widget:SetValue(GUI.anchor:IsShown())
		end,
		onclick = function(widget,value)
			if value then
				GUI.anchor:Show()
			else
				GUI.anchor:Hide()
			end
		end,
	},
  {
    name = L["Auto"],
    update = function(widget)
      widget:SetValue(Core:GetParam("auto") ~= 0)
    end,
    onclick = function(widget,value)
      Core:SetParam("auto",value and 1 or 0)
    end,
  },
  {
    name = L["CD"],
    update = function(widget,data)
      local cd = Core:GetParam("cd")
      widget:SetValue(cd > 60)
    	widget:SetLabel(data.name..": "..cd)
    end,
    onclick = function(widget,value)
      Core:SetParam("cd",value and 300 or 60)
    end,
  },
  {
    name = L["Tar"],
    update = function(widget,data)
      local target = Core:GetParam("target")
      widget:SetValue(target > 1)
    	widget:SetLabel(data.name..": "..target)
    end,
    onclick = function(widget,value)
      Core:SetParam("target",value and 3 or 1)
    end,
  },
  -- {
  --   name = L["Burst"],
  --   update = function(widget)
  --     widget:SetValue(Core:GetParamNotExpired("burst"))
  --   end,
  --   onclick = function(widget,value)
  --     Core:SetParamExpire("burst",value and 15 or 0)
  --   end,
  -- },
}
function GUI:UpdateOverlay()
	local burstMask = self.burstMask
	if Core:GetParamNotExpired("burst") then
		if burstMask.animOut:IsPlaying() and not burstMask.animIn:IsPlaying() then
			burstMask.animIn:Play()
			burstMask.animOut:Stop()
		end
	else
		burstMask.animIn:Stop()
		burstMask.animOut:Play()
	end
end

function GUI:UpdateCooldown()
  local castIconCooldown = self.castIconCooldown
  if self.castIconTexture:GetTexture() then
    local start,duration = Cache.cache.gcd.start,Cache.cache.gcd.duration
    if start and start~= 0 then
      castIconCooldown:SetCooldown(start, duration)
    end
    castIconCooldown:Show()
  else
    castIconCooldown:Hide()
  end
end

function GUI:SetMainIcon(spellId,unit)
  local texture = spellId and GetSpellTexture(spellId)
  self.castIconTexture:SetTexture(texture)
end

function GUI:UpdateMainIcon()
  local spellId,unit = Core:GetLastCachePassed()
  self:SetMainIcon(spellId,unit)
end

function GUI:Update()
	-- do return end
	-- self:UpdateOverlay()
  for i,data in ipairs(widgets) do
    data.update(data.widget,data)
  end
  GUI:UpdateMainIcon()
  GUI:UpdateCooldown()
	local background = GUI.background
	if Core.needbarcast and GetTime() - Core.needbarcast < 1 then
		background:SetColorTexture(0,1,0,0.4)
	else
		if Core:GetParam("auto") == 0 then
			background:SetColorTexture(1,0,0,0.6)
		elseif Core:GetParam("cd") > 60 then
			background:SetColorTexture(0,0,0,0.4)
		else
			background:SetColorTexture(0,0.4,1,0.4)
		end
	end
end


function GUI:CreateFrames()
  local width =300
	local anchor = CreateFrame("Frame","AirjAutoKey_GUI_anchor",UIParent)
  do
  	anchor:SetSize(width,20)
    if not anchor:GetPoint(1) then
    	-- AirjAutoKey_GUI_anchor:SetPoint("CENTER",UIParent,"Center",0,-120)
    end
  	anchor:EnableMouse(true)
  	anchor:SetMovable(true)
    anchor:SetUserPlaced(true)
  	anchor:RegisterForDrag("LeftButton")
  	anchor:SetScript("OnDragStart", function(self,button)
  		self:StartMoving()
  	end)
  	anchor:SetScript("OnDragStop", function(self,button)
  		self:StopMovingOrSizing()
  	end)
  	anchor:SetScript("OnMouseDown", function(self,button)
  		if IsShiftKeyDown() then
  			self:Hide()
  		end
  	end)
  	anchor:Hide()
  	self.anchor = anchor

  	local anchorbackground = anchor:CreateTexture(nil,"BACKGROUND")
  	anchorbackground:SetAllPoints()
  	anchorbackground:SetColorTexture(0,0,0)

  	local fontString = anchor:CreateFontString(nil,"OVERLAY","GameFontHighlight")
  	fontString:SetAllPoints()
  	fontString:SetText(L["Drag to Move"])
  end

	local container = CreateFrame("Frame",nil,UIParent)
  do
  	container:SetSize(width,72)
  	container:SetPoint("TOPLEFT",anchor,"BOTTOMLEFT")
  	self.container = container

  	local background = container:CreateTexture(nil,"BACKGROUND")
  	background:SetAllPoints()
  	background:SetColorTexture(0,0,0,0.4)
		self.background = background
  end

	local castIcon = CreateFrame("Frame",nil, container)
  do
  	castIcon:SetPoint("TOPLEFT",container,"TOPLEFT",2,-2)
  	castIcon:SetSize(68,68)
  	self.castIcon = castIcon

  	local castIconCooldown = CreateFrame("Cooldown",nil,castIcon,"CooldownFrameTemplate")
  	castIconCooldown:SetAllPoints()
  	castIconCooldown:SetScript("OnUpdate",function()
  	end)
  	self.castIconCooldown = castIconCooldown

  	local castIconTexture = castIcon:CreateTexture(nil,"BACKGROUND")
  	castIconTexture:SetAllPoints()
  	castIconTexture:SetColorTexture(0,0,0)
  	self.castIconTexture = castIconTexture

  	-- local	burstMask = CreateFrame("Frame", "AirjAutoKey_GUI_burstMask", container, "ActionBarButtonSpellActivationAlert")
    -- local anchorTo =castIcon
    -- local w,h =anchorTo:GetSize()
  	-- burstMask:SetSize(32+w,32+h)
    -- burstMask:ClearAllPoints()
    -- burstMask:SetPoint("CENTER",anchorTo,"CENTER")
    -- burstMask.animOut:SetScript("OnFinished",function(animGroup)
    -- 	local overlay = animGroup:GetParent()
    -- 	overlay:Hide()
    -- end)
  	-- burstMask.animOut:Play()
  	-- self.burstMask = burstMask
  end

  -- self.widgets = {}
  for i,data in ipairs(widgets) do
    local widget = AceGUI:Create("CheckBox")
    data.widget = widget
  	-- widget:SetPoint("TOPLEFT",castIcon,"BOTTOMLEFT",(i-1)*width,0)
    -- local x,y = -75,-(i-1)*24
    -- if i > 3 then
    --   x = 0
    --   y = y + 24*3
    -- end

    local x,y = (i-1)*75, 0
    widget:SetPoint("TOPLEFT",container,"BOTTOMLEFT",x,y)
  	widget:SetWidth(75)
  	widget:SetHeight(24)
  	widget:SetLabel(data.name)
  	widget:SetCallback("OnValueChanged", function(widget, event, value)
      data.onclick(widget,value)
    end)
  	widget.frame:SetParent(container);
  	widget.frame:Show();
    -- tinsert(self.widgets,widget)
  end
end
