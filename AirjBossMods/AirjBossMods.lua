local addonsname = "AirjBossMods"
local Core = LibStub("AceAddon-3.0"):NewAddon(addonsname,"AceConsole-3.0","AceTimer-3.0","AceEvent-3.0")
local Util = AirjUtil

_G[addonsname] = Core
ABM = Core
local db
function Core:RestDatas()
  self.iconDatas = {}
  self.voiceDatas = {}
  self.sayDatas = {}
  self.screenDatas = {}
  self.textDatas = {}
end

local anchors = {
  "icon",
  "text",
  "timeline",
  -- "board",
  -- "map",
}
local defaultAnchors = {
  icon = {"TOP",UIParent,"TOP",0,-100,400,20},
  text = {"CENTER",UIParent,"CENTER",0,20,400,20},
  timeline = {"CENTER",UIParent,"CENTER",-300,100,300,20},
}
function Core:OnInitialize()
  _G[addonsname.."DB"] = _G[addonsname.."DB"] or {}
  db = _G[addonsname.."DB"]
  self.anchors = {}
  self.icons = {}
  self.timelineRows = {}
  self:RestDatas()
  self:RegisterChatCommand("abm", function(str)
    -- db.hideAnchor = not db.hideAnchor
    -- for n,anchor in pairs(self.anchors) do
    --   if db.hideAnchor then
    --     anchor:Hide()
    --   else
    --     anchor:Show()
    --   end
    -- end
    if str == "reset" then
      db.anchors = nil
      for _, name in pairs(anchors) do
        self:ResetAnchor(name)
      end
    elseif str == "test" then
      self.testing = true
      local bossMod = self:GetTestBossMod()
      bossMod.basetime = GetTime()
      bossMod.phase = 1
      self:SetIcon(0,nil,1,25,nil,nil,nil,"一般BUFF")
      self:SetIconT({index = 0, duration = 25, count = "一般BUFF"})
      self:SetIconT({index = 1, duration = 5, size = 2, count = "关键BUFF"})
      self:SetIconT({index = 3, duration = 15, count = "一般BUFF"})
      self:SetTextT({text1 = "|cff00ffff先来的: {number}|r",expires = GetTime()+5})
      self:SetTextT({text1 = "|cffffff00后来的: {number}|r",expires = GetTime()+3,start = GetTime() + 1})
    end
  end)

  self.bossMods = Util:NewFIFO(1000)
end

local function getTimeString(value)
  return string.format(value<2 and "%0.1f" or "%0.0f",value)
end

local k2s = {
  mr = "|cff00ffff减伤",
  sb = "|cffff7f00加速",
}

function Core:GetParam(key)
  local head = string.sub(key,1,2)
  local number = tonumber(string.sub(key,3))
  if k2s[head] then
    return k2s[head]..number.."|r"
  end
end

function Core:FormatString(text)
  while true do
    local key1,key2 = string.match(text,"({(%w+)})")
    if not key1 then break end
    local str = self:GetParam(key2) or ""
    text = text:gsub(key1,str)
  end
  return text
end

function Core:ResetAnchor(name)
  local anchor = self.anchors[name]
  local data = db.anchors and db.anchors[name] or defaultAnchors[name] or {"CENTER",UIParent,"CENTER",0,0,200,20}
  local a,b,c,x,y,w,h,hide = unpack(data)
  anchor:ClearAllPoints()
  anchor:SetPoint(a,b,c,x,y)
  anchor:SetSize(w,h)
  if hide then anchor:Hide() else anchor:Show() end
end

function Core:UpdateAnchors()
end
function Core:OnEnable()
  -- Create Anchors
  for i,name in pairs(anchors) do
    local anchor = CreateFrame("Frame",addonsname .. "_"..name.."Anchor")
    self.anchors[name] = anchor
    anchor.name = name
    self:ResetAnchor(name)
    -- local data = db.anchors and db.anchors[name] or {"CENTER",UIParent,"CENTER",0,0,200,20}
    -- local a,b,c,x,y,w,h = unpack(data)
    -- anchor:SetPoint(a,b,c,x,y)
    -- anchor:SetSize(w,h)
  	anchor:EnableMouse(true)
  	anchor:SetMovable(true)
    anchor:RegisterForDrag("LeftButton","RightButton")
    anchor:SetMinResize(50, 20)
    anchor:SetMaxResize(600, 20)
  	anchor:SetScript("OnDragStart", function(self,button)
      if button == "LeftButton" then
        self:SetMovable(true)
        self:StartMoving()
      else
        self:SetResizable(true)
        self:StartSizing()
        self:SetScript("OnUpdate",function()
          self.resizing = true
        end)
      end
  	end)
  	anchor:SetScript("OnDragStop", function(self,button)
      self:StopMovingOrSizing()
      local offsetX,offsetY = self:GetLeft(),self:GetBottom()
      local width,height = self:GetSize()
      db.anchors = db.anchors or {}
      db.anchors[name] = {"BOTTOMLEFT","UIParent","BOTTOMLEFT",offsetX,offsetY,width,height }
      self:SetScript("OnUpdate",nil)
  	end)
    local texture = anchor:CreateTexture()
    texture:SetColorTexture(0,0,0,0.5)
    texture:SetAllPoints()
    anchor.texture = texture
    local fontstring = anchor:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    fontstring:SetFont("Fonts\\FRIZQT__.TTF",16,"MONOCHROME")
    -- fontstring:SetTextHeight(16)
    fontstring:SetText(name)
  	fontstring:SetAllPoints()

    if db.hideAnchor then
      anchor:Hide()
    else
      anchor:Show()
    end
  end
  self:ScheduleRepeatingTimer(self.Update,0.02,self)
  self:ScheduleRepeatingTimer(self.Timer10ms,0.01,self)

  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED","CallBacks")
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED","CallBacks")
  self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE","CallBacks")
  self:RegisterEvent("ENCOUNTER_START")
  self:RegisterEvent("ENCOUNTER_END")

  self.timelineMayChanged = true
end

function Core:GetPlayerGUID()
  if self.playerGUID then
    return self.playerGUID
  else
    self.playerGUID = UnitGUID("player")
    return self.playerGUID
  end
end

function Core:GetPlayerRole()
  local i = GetSpecialization()
  return i and GetSpecializationRole(i)
end

function Core:GetTestBossMod()
  return self.bossMods:find({encounterID = 0})
end

function Core:GetCurrentBossMod()
  local currentBossId = self.currentBoss and self.currentBoss.encounterID
  local bossMod
  if currentBossId then
    bossMod = self.bossMods:find({encounterID = currentBossId})
  else
    bossMod = self.testing and self:GetTestBossMod()
  end
  if bossMod then
    bossMod.basetime = bossMod.basetime or GetTime()
    bossMod.phase = bossMod.phase or 1
  end
  return bossMod
end

function Core:NewBoss(data)
  assert(data and data.encounterID)
  self.bossMods:push(data,data.encounterID)
  return data
end

function Core:CallBacks(event,...)
  local bossMod = self:GetCurrentBossMod()
  if bossMod and bossMod[event] then
    bossMod[event](bossMod,event,...)
  end
end

function Core:Timer10ms()
  local bossMod = self:GetCurrentBossMod()
  if bossMod and bossMod.Timer10ms then
    -- bossMod.Timer10ms(bossMod)
    pcall(bossMod.Timer10ms,bossMod)
  end
end

function Core:ENCOUNTER_START(event,encounterID, name, difficulty, size)
  print("ENCOUNTER_START",event,encounterID, name, difficulty, size)
  self.currentBoss = {
    encounterID = encounterID,
    name = name,
    difficulty = difficulty,
    size = size,
  }
  local bossMod = self:GetCurrentBossMod()
  if bossMod then
    bossMod.difficulty = difficulty
    bossMod.phase = 1
    bossMod.basetime = GetTime()
  end
  if bossMod and bossMod.ENCOUNTER_START then
    bossMod.ENCOUNTER_START(bossMod,event,encounterID, name, difficulty, size)
  end
  self.timelineMayChanged = true
end

function Core:ENCOUNTER_END(event,encounterID, name, difficulty, size, success)
  print("ENCOUNTER_END",event,encounterID, name, difficulty, size, success)
  local bossMod = self:GetCurrentBossMod()
  if bossMod then
    bossMod.difficulty = nil
    bossMod.phase = nil
    bossMod.basetime = nil
  end
  if bossMod and bossMod.ENCOUNTER_END then
    bossMod.ENCOUNTER_END(bossMod,event,encounterID, name, difficulty, size, success)
  end
  self.currentBoss = nil
  self.timelineMayChanged = true
  self:RestDatas()
end


function Core:Update()
  self:UpdateIcons()
  self:UpdateText()
  self:UpdateTimeline()
  self:UpdateScreen()
  self:UpdateVoice()
  self:UpdateSay()
end
-- icons
--[[
{
  index = 0,
  texture = 135940,
  duration = 10,
  expires = now + 10,
  start = now,
  removes = now + 10,
  reverse = true,
  size = 1,
  count = "",
}
]]
function Core:SetIconT(data)
  data = data or {}
  local index = data.index or 0
  local texture = data.texture or 135940
  local duration = data.duration or 10
  local expires = data.expires or GetTime() + duration
  local start = data.start or GetTime()
  local removes = data.removes or expires
  local reverse = data.reverse == nil and true or reverse
  local size = data.size or 1
  local count = data.count or ""
  self.iconDatas[index] = {
    texture = texture,
    duration = duration,
    expires = expires,
    start = start,
    removes = removes,
    reverse = reverse,
    size = size,
    count = count,
    justSetUp = true,
  }
  return self.iconDatas[index]
end
function Core:SetIcon(index,texture,size,duration,expires,removes,reverse,count)
  index = index or 0
  texture = texture or 458972
  duration = duration or 10
  expires = expires or GetTime() + duration
  removes = removes or expires
  reverse = reverse == nil and true or reverse
  self.iconDatas[index] = {
    texture = texture,
    duration = duration,
    expires = expires,
    removes = removes,
    reverse = reverse,
    size = size,
    count = count,
    justSetUp = true,
  }
  return self.iconDatas[index]
end
function Core:UpdateIcons()
  local anchor = self.anchors.icon
  local resized = anchor.resizing
  if resized then anchor.resizing = nil end
  local size = anchor:GetWidth()/4
  local now = GetTime()
  for k,v in pairs(self.iconDatas) do
    local icon = self.icons[k]
    if not icon then
      icon = CreateFrame("Frame")
      local castIconCooldown = CreateFrame("Cooldown",nil,icon,"CooldownFrameTemplate")
      castIconCooldown:SetAllPoints()
      icon.castIconCooldown = castIconCooldown

      local castIconTexture = icon:CreateTexture(nil,"BACKGROUND")
      castIconTexture:SetAllPoints()
      castIconTexture:SetColorTexture(0,0,0)
      icon.castIconTexture = castIconTexture

      local count = icon:CreateFontString()
      count:SetAllPoints()
      count:SetFont("Fonts\\ARKai_C.TTF",72,"OUTLINE")
      count:SetJustifyH("RIGHT")
      count:SetJustifyV("BOTTOM")
      icon.count = count

      self.icons[k] = icon
    end
    if now > v.removes then
      icon:Hide()
      self.iconDatas[k] = nil
    else
      if resized or v.justSetUp then
        local isize = size*(v.size or 1)
        icon:SetSize(isize, isize)
        local x,y = (k)%10,-math.floor(k/10)
        icon:SetPoint("TOPLEFT",anchor,"BOTTOMLEFT",x*size,y*size)
        icon.count:SetFont("Fonts\\ARKai_C.TTF",isize*0.4,"OUTLINE")
      end
      if v.justSetUp then
        icon.castIconTexture:SetTexture(v.texture)
        icon.castIconCooldown:SetCooldown(v.expires - v.duration, v.duration)
        icon.castIconCooldown:SetReverse(v.reverse)
        icon.count:SetText(v.count or "")
        icon:Show()
      end
      icon.show = true
    end
  end
  for i, icon in pairs(self.icons) do
    if icon.show then
      icon.show = nil
    else
      icon:Hide()
    end
  end
end
--texts
--[[
{
  text1 = "|cffff0000测试:|r|cff00ff00{number}|r",
  text2 = text1,
  expires = now + 10,
  start = now,
  removes = now + 10,
}
]]
function Core:SetTextT(data)
  local text1 = data.text1 or "|cffff0000测试:|r|cff00ff00{number}|r"
  local text2 = data.text2 or text1
  local expires = data.expires or GetTime() + 10
  local start = data.start or GetTime()
  local removes = data.removes or expires + 2
  tinsert(self.textDatas, 1, {
    text1 = text1,
    text2 = text2,
    expires = expires,
    removes = removes,
    start = start,
    justSetUp = true,
  })
end

function Core:SetText(text1,text2,expires,removes,start)
  text1 = text1 or "|cffff0000测试:|r|cff00ff00{number}|r"
  text2 = text2 or text1
  expires = expires or GetTime() + 10
  removes = removes or expires + 1
  start = start or GetTime()
  tinsert(self.textDatas, 1, {
    text1 = text1,
    text2 = text2,
    expires = expires,
    removes = removes,
    start = start,
    justSetUp = true,
  })
end
function Core:UpdateText()
  local anchor = self.anchors.text
  local resized = anchor.resizing
  if resized then anchor.resizing = nil end
  local size = anchor:GetWidth()/8
  local now = GetTime()
  local text = self.text
  if not text then
    text = CreateFrame("Frame")
    text:SetPoint("CENTER",anchor,"CENTER")
    local fontstring = text:CreateFontString()
    fontstring:SetAllPoints()
    fontstring:SetFont("Fonts\\ARKai_C.TTF",72,"OUTLINE")
    text.fontstring = fontstring
    self.text = text
  end

  for i, data in pairs(self.textDatas) do
    if now > data.removes then
      tremove(self.textDatas,i)
    elseif now > data.start then
      local ftext
      if now > data.expires then
        ftext = data.text2
      else
        ftext = data.text1
      end
      local num = getTimeString(data.expires-now)
      ftext = string.gsub(ftext,"{number}",num)
      text.fontstring:SetText(ftext)
      if resized or data.justSetUp then
        text.fontstring:SetFont("Fonts\\ARKai_C.TTF",size,"THICKOUTLINE")
        text:SetSize(20*size,size)
      end
      text:Show()
      return
    end
  end
  text:Hide()
end
--screen
--[[
{
  r = 1,
  g = 0,
  b = 0,
  a = 0.5,
  time = now,
  duration = 0.3,
}
]]
function Core:SetScreenT(data)
  local r = data.r or 1
  local g = data.g or 0
  local b = data.b or 0
  local a = data.a or 0.5
  local time = data.time or GetTime()
  local duration = data.duration or 0.3
  tinsert(self.screenDatas, {
    r=r,g=g,b=b,a=a,
    duration=duration,
    time=time,
    justSetUp = true,
  })
end

function Core:SetScreen(r,g,b,a,time,duration)
  r = r or 1
  g = g or 0
  b = b or 0
  a = a or 0.4
  time = time or GetTime()
  duration = duration or 0.3
  tinsert(self.screenDatas, {
    r=r,g=g,b=b,a=a,
    duration=duration,
    time=time,
    justSetUp = true,
  })
end

function Core:UpdateScreen()
  local now = GetTime()
  for i,v in ipairs(self.screenDatas) do
    if now>v.time then
      local screen = self.screen
      if not screen then
        screen = CreateFrame("Frame")
        screen:SetAllPoints(UIParent)
        local texture = screen:CreateTexture()
        texture:SetAllPoints()
        screen.texture = texture
        self.screen = screen
      end
      if now > v.time + v.duration * 2 then
        tremove(self.screenDatas,i)
        screen:Hide()
      elseif now < v.time then
        screen:Hide()
      else
        if v.justSetUp then
          screen.texture:SetColorTexture(v.r,v.g,v.b,v.a)
        end
        local a = (1-abs(now-(v.time + v.duration))/v.duration)
        screen:SetAlpha(a)
        screen:Show()
        break
      end
    end
  end
end

--say
function Core:SetSay(text,time)
  text = text or "1"
  time = time or GetTime()
  tinsert(self.sayDatas,{
    time=time,
    text=text,
  })
end

function Core:UpdateSay()
  local now = GetTime()
  for i,v in ipairs(self.sayDatas) do
    if now>v.time then
      SendChatMessage(v.text,"SAY")
      tremove(self.sayDatas,i)
    end
  end
end

--voice
function Core:SetVoice(file,time,custom)
  file = file or "runaway"
  time = time or GetTime()
  tinsert(self.voiceDatas,{time=time,file=file,custom=custom})
end

function Core:PlayDBMYike(name)
  PlaySoundFile("Interface\\AddOns\\DBM-VPYike\\"..name..".ogg", "Master")
end
function Core:UpdateVoice()
  local now = GetTime()
  for i,v in ipairs(self.voiceDatas) do
    if now>v.time then
      self:PlayDBMYike(v.file)
      tremove(self.voiceDatas,i)
    end
  end
end

-- timeline
function Core:UpdateTimeline()
  local anchor = self.anchors.timeline
  local resized = anchor.resizing
  if resized then anchor.resizing = nil end
  local bossMod = self:GetCurrentBossMod()
  if not bossMod then
    for i = 1,#self.timelineRows do
      self.timelineRows[i]:Hide()
    end
    return
  end
  local phase = bossMod.phase
  local basetime = bossMod.basetime
  local nativedata, timelineChanged
  if not self.timelineMayChanged and not bossMod.timelineChanged then
    nativedata = self.timelineNativedata
  end
  if not nativedata then
    nativedata = bossMod and bossMod:GetTimeline() or {}
    self.timelineNativedata = nativedata
    self.timelineMayChanged = nil
    timelineChanged = true
    bossMod.timelineChanged = nil
  end
  local rowdata = {}
  local rownum = 0
  local width = anchor:GetWidth()
  local height = width/12
  local now = GetTime()
  for i,v in ipairs(nativedata) do
    if v.phase == phase then
      local maxrow = 8
      for j,vv in ipairs(v.timepoints) do
        local d = vv.time and ((basetime+vv.time) - now)
        if not d or (d>-20 and (d<20 or rownum < maxrow)) then
          rownum = rownum + 1
          rowdata[rownum] = vv
        end
      end
    else
      -- if v.phase<phase then
      --   if rownum == 0 then
      --     rownum = rownum + 1
      --   end
      --   rowdata[rownum] = v
      -- else
      --   if rownum == 0 or not rowdata[rownum].phase then
      --     rownum = rownum + 1
      --     rowdata[rownum] = v
      --   end
      -- end
    end
  end

  for i = 1,rownum do
    local row = self.timelineRows[i]
    local data = rowdata[i]
    if not row then
      row = CreateFrame("Frame")
      local texture = row:CreateTexture()
      texture:SetAllPoints()
      texture:SetColorTexture(0,0,0,1)
      local bar = CreateFrame("StatusBar",nil,row)
      bar:SetPoint("TOPLEFT",row,"TOPLEFT",2,-2)
      bar:SetPoint("BOTTOMRIGHT",row,"BOTTOMRIGHT",-2,2)
      bar:SetMinMaxValues(0,1)
      bar:SetStatusBarTexture([[Interface\Buttons\WHITE8X8]])
      row.bar = bar
      local fontstring = bar:CreateFontString(nil,"OVERLAY","GameFontHighlight")
      fontstring:SetFont("Fonts\\FRIZQT__.TTF",72,"MONOCHROME")
    	fontstring:SetAllPoints()
      fontstring:SetJustifyH("LEFT")
      row.name = fontstring
      fontstring = bar:CreateFontString(nil,"OVERLAY","GameFontHighlight")
      fontstring:SetFont("Fonts\\FRIZQT__.TTF",72,"MONOCHROME")
    	fontstring:SetAllPoints()
      fontstring:SetJustifyH("RIGHT")
      row.time = fontstring
      self.timelineRows[i] = row
    end
    if resized or timelineChanged then
      row:SetSize(width,height)
      row:SetPoint("TOP",anchor,"BOTTOM",0,-(i-1)*height)
      row.name:SetFont("Fonts\\FRIZQT__.TTF",height*0.5,"OUTLINE")
      row.time:SetFont("Fonts\\FRIZQT__.TTF",height*0.8,"OUTLINE")
    end
    local percent,alpha
    local timeString
    if data.phase and data.phase<phase then
      percent = 1
      alpha = 0.2
    elseif data.phase and data.phase>phase then
      percent = 0
      alpha = 1
      timeString = data.note
    else
      if data.time then
        if now>basetime+data.time+10 then
          percent = 1
          alpha = 0.2
        elseif  now>basetime+data.time then
          percent = 1
          alpha = 1-0.8*(now-(basetime+data.time))/10
          timeString = "|cffff3000 -"..getTimeString(-(basetime+data.time-now)).."|r"
        elseif now>basetime+data.time-10 then
          percent = (now - (basetime+data.time-10))/10
          timeString = "|cffffff00"..getTimeString(basetime+data.time-now).."|r"
          alpha = 1
        else
          percent = 0
          timeString = basetime+data.time-now<60 and getTimeString(basetime+data.time-now) or "-"
          alpha = 1
        end
      else
        percent = 0
        alpha = 1
      end
    end
    local text = data.text or ""
    text = self:FormatString(text)
    row.name:SetText(text)
    row.time:SetText(timeString or "")
    row.bar:SetValue(percent)
    row.bar:SetAlpha(alpha or 0)
    row.bar:SetStatusBarColor(unpack(data.color or {1,1,0.5}))
    row:Show()
  end
  for i = rownum+1,#self.timelineRows do
    self.timelineRows[i]:Hide()
  end
end
