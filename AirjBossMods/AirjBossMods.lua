local addonsname = "AirjBossMods"
local Core = LibStub("AceAddon-3.0"):NewAddon(addonsname,"AceConsole-3.0","AceTimer-3.0","AceEvent-3.0","AceSerializer-3.0","AceComm-3.0")
_G[addonsname] = Core
local Util = AirjUtil
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
ABM = Core
local db

Core.version = "v0.0.1"

local options
do-- Options
  options = {
    type = "group",
    handler = Core,
    get = "GetOption",
    set = "SetOption",
    func = "ExecuteOption",
    disabled = "DisabledOption",
    args = {
      enable = {
        type = "execute",
        order = 10,
        name = "模拟测试 /abm test",
        width = "full",
        func = "Test",
      },
      icon={
        name = "图标",
        type = "group",
        order = 10,
        args={
          test = {
            type = "execute",
            order = 5,
            name = "测试",
            desc = "测试此功能",
            descStyle = "inline",
            width = "full",
            -- disable = true,
          },
          lock = {
            type = "toggle",
            order = 10,
            name = "锁定",
            desc = "显示/隐藏锚点,用于拖动/放缩",
            descStyle = "inline",
            width = "full",
          },
          disable = {
            type = "toggle",
            order = 20,
            name = "禁用",
            desc = "启用/禁用功能",
            descStyle = "inline",
            width = "full",
          },
          reset = {
            type = "execute",
            order = 30,
            name = "重置位置",
            width = "full",
          },
          center = {
            type = "execute",
            order = 40,
            name = "放置于中间",
            descStyle = "inline",
            width = "full",
          },
        },
      },
      text={
        name = "文字",
        type = "group",
        order = 20,
        args={
          test = {
            type = "execute",
            order = 5,
            name = "测试",
            desc = "测试此功能",
            descStyle = "inline",
            width = "full",
            -- disable = true,
          },
          lock = {
            type = "toggle",
            order = 10,
            name = "锁定",
            desc = "显示/隐藏锚点,用于拖动/放缩",
            descStyle = "inline",
            width = "full",
          },
          disable = {
            type = "toggle",
            order = 20,
            name = "禁用",
            desc = "启用/禁用功能",
            descStyle = "inline",
            width = "full",
          },
          reset = {
            type = "execute",
            order = 30,
            name = "重置位置",
            width = "full",
          },
          center = {
            type = "execute",
            order = 40,
            name = "放置于中间",
            descStyle = "inline",
            width = "full",
          },
        },
      },
      timeline={
        name = "时间轴",
        type = "group",
        order = 30,
        args={
          test = {
            type = "execute",
            order = 5,
            name = "测试",
            desc = "测试此功能",
            descStyle = "inline",
            width = "full",
            -- disable = true,
          },
          lock = {
            type = "toggle",
            order = 10,
            name = "锁定",
            desc = "显示/隐藏锚点,用于拖动/放缩",
            descStyle = "inline",
            width = "full",
          },
          disable = {
            type = "toggle",
            order = 20,
            name = "禁用",
            desc = "启用/禁用功能",
            descStyle = "inline",
            width = "full",
          },
          reset = {
            type = "execute",
            order = 30,
            name = "重置位置",
            width = "full",
          },
          center = {
            type = "execute",
            order = 40,
            name = "放置于中间",
            descStyle = "inline",
            width = "full",
          },
        },
      },
      say={
        name = "喊话(/s)",
        type = "group",
        order = 40,
        args={
          test = {
            type = "execute",
            order = 5,
            name = "测试",
            desc = "测试此功能",
            descStyle = "inline",
            width = "full",
            -- disable = true,
          },
          disable = {
            type = "toggle",
            order = 20,
            name = "禁用",
            desc = "启用/禁用功能",
            descStyle = "inline",
            width = "full",
          },
        },
      },
      voice={
        name = "语音",
        type = "group",
        order = 50,
        args={
          test = {
            type = "execute",
            order = 5,
            name = "测试",
            desc = "测试此功能",
            descStyle = "inline",
            width = "full",
            -- disable = true,
          },
          disable = {
            type = "toggle",
            order = 20,
            name = "禁用",
            desc = "启用/禁用功能",
            descStyle = "inline",
            width = "full",
          },
        },
      },
      screen={
        name = "全屏警报",
        type = "group",
        order = 60,
        args={
          test = {
            type = "execute",
            order = 5,
            name = "测试",
            desc = "测试此功能",
            descStyle = "inline",
            width = "full",
            -- disable = true,
          },
          disable = {
            type = "toggle",
            order = 20,
            name = "禁用",
            desc = "启用/禁用功能",
            descStyle = "inline",
            width = "full",
          },
        },
      },
      avr={
        name = "增强现实",
        type = "group",
        order = 60,
        disabled = function() return not (AirjHack and AirjAVR and AirjHack:HasHacked()) end,
        args={
          test = {
            type = "execute",
            order = 5,
            name = "测试",
            desc = "测试此功能",
            descStyle = "inline",
            disabled = "DisabledOption",
            width = "full",
            -- disable = true,
          },
          disable = {
            type = "toggle",
            order = 20,
            name = "禁用",
            desc = "启用/禁用功能",
            descStyle = "inline",
            width = "full",
          },
        },
      },
    },
  }
  function Core:DisabledOption(info)
    if #info == 2 then
      local anchorName, key = info[1], info[2]
      if key == "test" then
        return db.anchorDisables and db.anchorDisables[anchorName]
      end
    elseif #info == 1 then
    end
  end
  function Core:GetOption(info)
    if #info == 2 then
      local anchorName, key = info[1], info[2]
      if key == "lock" then
        return db.anchorHides and db.anchorHides[anchorName]
      elseif key == "disable" then
        return db.anchorDisables and db.anchorDisables[anchorName]
      end
    elseif #info == 1 then
    end
  end
  function Core:SetOption(info,value,...)
    if #info == 2 then
      local anchorName, key = info[1], info[2]
      if key == "lock" then
        db.anchorHides = db.anchorHides or {}
        db.anchorHides[anchorName] = value
        self:ResetAnchor(anchorName)
      elseif key == "disable" then
        db.anchorDisables = db.anchorDisables or {}
        db.anchorDisables[anchorName] = value
        self:ResetAnchor(anchorName)
      end
    elseif #info == 1 then
    end
  end
  function Core:ExecuteOption(info)
    if #info == 2 then
      local anchorName, key = info[1], info[2]
      if key == "reset" then
        if db.anchorPoints then
          db.anchorPoints[anchorName] = nil
        end
        self:ResetAnchor(anchorName)
      elseif key == "center" then
        db.anchorPoints = db.anchorPoints or {}
        local d = defaultAnchors[anchorName]
        db.anchorPoints[anchorName] = {"CENTER","UIParent","CENTER",0,0,d[6],d[7]}
        self:ResetAnchor(anchorName)
      elseif key == "test" then
        self:ResetDatas()
        local now = GetTime()
        if anchorName == "icon" then
          local is = {0,3,10,13}
          for i = 1,4 do
            local _, spellId = GetSpellBookItemInfo(25+i,"player")
            local texture = GetSpellTexture(spellId)
            local name = GetSpellInfo(spellId)
            self:SetIconT({index = is[i], texture = texture, duration = 20+i*5, name = name, scale = false, reverse = (i%2==0)})
          end
          local _, spellId = GetSpellBookItemInfo(30,"player")
          local texture = GetSpellTexture(spellId)
          local name = GetSpellInfo(spellId)
          self:SetIconT({index = 1, texture = texture, duration = 5, size = 2, name = name, reverse = false})
        elseif anchorName == "text" then
          self:SetTextT({text1 = "|cffff0000测试警报: |cff00ffff{number}|r", text2 = "|cff00ff00警报结束|r",expires = now+9})
        elseif anchorName == "timeline" then
          self.testing = true
          local bossMod = self:GetTestBossMod()
          bossMod.basetime = now
          bossMod.phase = 1
        elseif anchorName == "say" then
          for i = 0,3 do
            self:SetSay(""..i,now + 3 - i)
          end
        elseif anchorName == "voice" then
          self:SetVoice("stepring")
          self:SetVoice("bombrun", now+1)
        elseif anchorName == "screen" then
          self:SetScreenT({r=0.5,g=0,b=1,time = now + 0})
          self:SetScreenT({r=1,g=1,b=0,time = now + 1})
        elseif anchorName == "avr" then
          local _, spellId = GetSpellBookItemInfo(36,"player")
          self:CreateBeam({fromUnit= "player",toUnit = "target",width = 6,length = 100,color = {1,0,0},alpha = 0.2,removes = now + 4,start = now + 2})
          self:CreateCooldown({unit = "player",spellId = spellId,radius = 8,duration = 5,color = {0,1,0},alpha = 0.2})
          self:SetPlayerAlpha({alpha = 0.5, removes = now + 8})

        end
      end
    elseif #info == 1 then
    end
  end
end
function Core:ResetDatas()
  self.iconDatas = {}
  self.voiceDatas = {}
  self.sayDatas = {}
  self.screenDatas = {}
  self.playerAlphaDatas = {}
  self.textDatas = {}
  self.timelineDatas = {}
  self.futureDamageDatas = {}
  self.testing = nil
end

local anchors = {
  "icon",
  "text",
  "timeline",
  -- "board",
  -- "map",
}
local anchorNames = {
  icon = "图标锚点",
  text = "文字锚点",
  timeline = "时间轴锚点",
}
local defaultAnchors = {
  icon = {"TOP","UIParent","TOP",0,-20,400,20},
  text = {"CENTER","UIParent","CENTER",0,150,400,20},
  timeline = {"CENTER","UIParent","CENTER",-280,0,300,20},
}

function Core:OnInitialize()
  _G[addonsname.."DB"] = _G[addonsname.."DB"] or {}
  db = _G[addonsname.."DB"]
  self.anchors = {}
  self.icons = {}
  self.timelineRows = {}
  self:ResetDatas()
  self:RegisterChatCommand("abm", function(str)
    local key,value = string.split(" ",str,2)
    if key == "reset" then
      db.anchorPoints = nil
      db.anchorHides = nil
      db.anchorDisables = nil
      for _, name in pairs(anchors) do
        self:ResetAnchor(name)
      end
    elseif key == "test" then
      if value and tonumber(value) then
        self:ENCOUNTER_START("ENCOUNTER_START",tonumber(value), "Test", 16, 20)
      else
        self:Test()
      end
    elseif key == "version" or key == "ver" then
      self:CheckVersion()
    elseif key == "pull" then
      -- self:StartPull(value and tonumber(value) or 10)
      self:SendComm({type="pull",time=value and tonumber(value) or 10})
    else
      AceConfigRegistry:NotifyChange(addonsname)
      AceConfigDialog:Open(addonsname)
    end
  end)

  self.bossMods = {}

  AceConfigRegistry:RegisterOptionsTable(addonsname, options)
  AceConfigDialog:AddToBlizOptions(addonsname)
end

function Core:Test()
  self:ResetDatas()
  local now = GetTime()
  self.testing = true
  self:ENCOUNTER_START("ENCOUNTER_START",0, "Test", 16, 10)
  self:SetIconT({index = 3, texture = GetSpellTexture(234310), duration = 60, expires = now + 40, name = "末日之雨", count = "2", scale = false})
  self:SetIconT({index = 10, texture = GetSpellTexture(240910), duration = 9, size = 1, name = "末日决战", reverse = false})
  self:SetIconT({index = 1, texture = GetSpellTexture(238430), duration = 5, start = now+15, expires = now + 20, size = 2, name = "大圈爆炸", reverse = false})
  self:SetIconT({index = 0, texture = GetSpellTexture(235059), duration = 10, expires = now + 35, start = now+25, name = "奇点", reverse = false})
  self:SetTextT({text1 = "|cffff0000末日决战: |cff00ffff{number}|r", text2 = "|cff00ff00决战结束|r",expires = now+9})
  self:SetTextT({text1 = "|cffff0000大圈点你: |cff00ffff{number}|r", text2 = "|cff00ff00大圈结束|r",start = now + 15,expires = now+20})
  self:SetTextT({text1 = "|cffffff00奇点出现|r", text2 = "",start = now + 25,expires = now+28})
  self:SetTextT({text1 = "|cffffff00准备击飞: |cff00ffff{number}|r", text2 = "|cff00ff00击飞中...|r",expires = now+35,start = now + 32})
  self:SetVoice("stepring")
  self:SetVoice("safenow", now+9)
  self:SetVoice("bombrun", now+15)
  for i = 0,3 do
    -- self:SetSay(""..i,now + 20 - i)
  end
  self:SetVoice("movecenter", now+25)
  self:SetVoice("carefly", now+32)
  self:SetScreenT({r=0.5,g=0,b=1,time = now + 32})
  self:SetScreenT({r=1,g=1,b=0,time = now + 15})

  self:CreateCooldown({unit = "player",spellId = spellId,radius = 15,duration = 5,color = {1,1,0},alpha = 0.2,start=now+15,expires=now+20})
  self:SetPlayerAlpha({alpha = 0.5,start=now+0,removes=now+9})
end

function Core:GetTimeString(value)
  return string.format(value<3 and "%0.1f" or "%0.0f",value)
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
  if not anchor then return end
  local data = db.anchorPoints and db.anchorPoints[name] or defaultAnchors[name] or {"CENTER",UIParent,"CENTER",0,0,200,20}
  local a,b,c,x,y,w,h = unpack(data)
  anchor:ClearAllPoints()
  anchor:SetPoint(a,b,c,x,y)
  anchor:SetSize(w,h)
  local hide = db.anchorHides and db.anchorHides[name] or false
  if hide then anchor:Hide() else anchor:Show() end
  local disable = db.anchorDisables and db.anchorDisables[name] or false
  if disable then
    -- anchor.disable = true
    anchor.texture:SetColorTexture(1,0,0,0.5)
  else
    -- anchor.disable = nil
    anchor.texture:SetColorTexture(0,0,0,0.5)
  end
end

function Core:CreateAnchors()
  for i,name in pairs(anchors) do
    local anchor = CreateFrame("Frame",addonsname .. "_"..name.."Anchor")
    self.anchors[name] = anchor
    anchor.name = name
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
      db.anchorPoints = db.anchorPoints or {}
      db.anchorPoints[name] = {"BOTTOMLEFT","UIParent","BOTTOMLEFT",offsetX,offsetY,width,height }
      self.resizing = true
      self:SetScript("OnUpdate",nil)
  	end)

    anchor:SetScript("OnEnter", function(self)
  		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
      GameTooltip:AddLine("左键拖动 - 移动\n右键拖动 - 放缩\nCtrl 点击 - 锁定\nAlt 点击 - 禁用\nShift 点击 - 重置\n\n/abm test - 测试", 1, 1, 1, 1)
      GameTooltip:Show()
  		GameTooltip:SetFrameLevel(50);
    end)
    anchor:SetScript("OnLeave",function(self)
      GameTooltip:Hide()
    end)
    anchor:SetScript("OnMouseDown", function(self)
      if IsControlKeyDown() then
        db.anchorHides = db.anchorHides or {}
        db.anchorHides[name] = true
        Core:ResetAnchor(name)
      elseif IsAltKeyDown() then
        db.anchorDisables = db.anchorDisables or {}
        db.anchorDisables[name] = not db.anchorDisables[name]
        Core:ResetAnchor(name)
      elseif IsShiftKeyDown() then
        db.anchorDisables = db.anchorDisables or {}
        db.anchorDisables[name] = nil
        db.anchorHides = db.anchorHides or {}
        db.anchorHides[name] = nil
        db.anchorPoints = db.anchorPoints or {}
        db.anchorPoints[name] = nil
        Core:ResetAnchor(name)
        self.resizing = true
      end
    end)
    local texture = anchor:CreateTexture()
    texture:SetColorTexture(0,0,0,0.5)
    texture:SetAllPoints()
    anchor.texture = texture
    local fontstring = anchor:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    fontstring:SetFont("Fonts\\ARKai_C.TTF",16,"MONOCHROME")
    -- fontstring:SetTextHeight(16)
    fontstring:SetText(anchorNames[name])
  	fontstring:SetAllPoints()

    self:ResetAnchor(name)
  end
end
function Core:OnEnable()
  self:CreateAnchors()
  local updateFrame = CreateFrame("Frame")
  updateFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT")
  updateFrame:SetSize(1,1)
  updateFrame:SetScript("OnUpdate",function()
    self:Update()
  end)
  -- self:ScheduleRepeatingTimer(self.Update,0.01,self)
  -- self:ScheduleRepeatingTimer(self.Timer10ms,0.01,self)
  self:ScheduleRepeatingTimer(self.Timer10ms,0.1,self)

  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED","CallBacks")
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED","CallBacks")
  self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE","CallBacks")
  self:RegisterEvent("ENCOUNTER_START")
  self:RegisterEvent("ENCOUNTER_END")
	self:RegisterComm("AIRJ_BM_COMM")

  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED","CallBacks")
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED","CallBacks")

  self.timelineMayChanged = true

  local avrFunctions = {
    "RegisterCreatureBeam",
    "RegisterAuraCooldown",
    "RegisterAuraBeam",
    "CreateCooldown",
    "CreateBeam",
  }
  for i, key in pairs(avrFunctions) do
    self[key] = function(self,...)
      local disable = db.anchorDisables and db.anchorDisables.avr
      if not disable and AirjAVR then
        AirjAVR[key](AirjAVR,...)
      end
    end
  end
end

--version
function Core:CheckVersion()
  self.checkversion = {}
  Core:SendComm({type="checkversion"})
  Core:ScheduleTimer(function()
    for name,data in pairs(self.checkversion) do
      self:Print(name.." - "..data.version.." - ".. (data.hacked and "|cff00ff00HACKED|r" or "|cffffff00NOT HACKED|r"))
    end
    for i = 1,40 do
      local name = UnitName("raid"..i)
      if name then
        name = Ambiguate(name,"none")
        if not self.checkversion[name] then
          self:Print(name.." - |cffff0000NOT INSTALLED|r")
        end
      end
    end
  end,1)
end
--pulling
function Core:StartPull(time)
  local now = GetTime()
  if not self.pulling or now > self.pulling then
    self:ResetDatas()
    time = time or 10
    self:SetTextT({text1="|cffffff00准备开怪: |r|cff00ffff{number}|r",text2="|cff00ff00开怪|r",expires = now+time})
    self:SetVoiceT({str="kai1             guai4           dao4     shu3"})
    -- local count = {,"yi1","er4","san1","si4","wu3"}
    for i = 1,5 do
      self:SetVoiceT({file="count\\"..i,time = now+time-i-0.2})
    end
    self:SetVoiceT({str="kai1             guai4",time = now+time-0.2})
    self.pulling = now + time
  else
    self.pulling = nil
    self:ResetDatas()
    self:SetTextT({text1="|cffff0000取消开怪|r",expires = now+2})
    self:SetVoiceT({str="qu3         xiao1            kai1             guai4"})
  end
end

--utils
function Core:SendComm(data,target)
  self:SendCommMessage("AIRJ_BM_COMM",self:Serialize(data),target and "WHISPER" or IsInRaid() and "RAID" or "PARTY",target,"ALERT")
end
function Core:OnCommReceived(prefix,message,channel,sender)
	local match, data = self:Deserialize(message)
	if not match then return end
  if data.type == "checkversion" then
    self:SendComm({type = "version",version = self.version,hacked = AirjHack and AirjHack:HasHacked()},sender)
  elseif data.type == "version" then
    self.checkversion = self.checkversion or {}
    self.checkversion[sender] = data
  elseif data.type == "pull" then
    self:StartPull(data.time)
  end
end
function Core:FindHelpUnitByName(name)
  self.hn2u = self.hn2u or {}
  local n2u = self.hn2u
  name = Ambiguate(name,"none")
  local unit = n2u[name]
  if unit then
    if UnitName(unit) == name then
      return unit
    else
      n2u[name] = nil
    end
  end
  local groupNumber = GetNumGroupMembers()
  local pre
  if IsInRaid() then
    pre = "raid"
  else
    pre = "party"
    groupNumber = groupNumber - 1
  end
  local units = {}
  for i = 1,groupNumber do
    local u = pre..i
    tinsert(units,u)
  end
  tinsert(units,"player")
  for i,u in ipairs(units) do
    local n = UnitName(u)
    if n then
      n2u[n] = u
      if n == name then
        return u
      end
    end
  end
end

function Core:FindHarmUnitByName(name)
  self.an2u = self.an2u or {}
  local n2u = self.an2u
  local unit = n2u[name]
  if unit then
    if UnitName(unit) == name then
      return unit
    else
      n2u[name] = nil
    end
  end
  local units = {}
  for i = 1,5 do
    local u = "boss"..i
    tinsert(units,u)
  end
  tinsert(units,"player")
  for i,u in ipairs(units) do
    local n = UnitName(u)
    if n then
      n2u[n] = u
      if n == name then
        return u
      end
    end
  end
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

function Core:GetCid(guid)
  if not guid then return end
  local guids = {string.split("-",guid)}
  local objectType,serverId,instanceId,zone,id,spawn
  objectType = guids[1]
  if objectType == "Player" then
  elseif objectType == "Creature" or objectType == "GameObject" or objectType == "AreaTrigger" or objectType == "Pet" then
    objectType,_,serverId,instanceId,zone,id,spawn = unpack(guids)
		id = tonumber(id)
  end
  return id,objectType
end

local idg = 0
local function getId ()
  idg = idg + 1
  return idg
end

function Core:GetTestBossMod()
  return self.bossMods[0]
end

function Core:GetCurrentBossMod()
  if self.currentBoss then
    bossMod = self.currentBoss.bossMod
  else
    bossMod = self.testing and self:GetTestBossMod()
  end
  return bossMod
end

function Core:NewBoss(data)
  assert(data and data.encounterID)
  self.bossMods[data.encounterID] = data
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

  local bossMod = self.bossMods[encounterID]
  self.currentBoss = {
    encounterID = encounterID,
    name = name,
    difficulty = difficulty,
    size = size,
    bossMod = bossMod,
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
  -- print("ENCOUNTER_END",event,encounterID, name, difficulty, size, success)
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
  self:ResetDatas()
end


function Core:Update()
  self:UpdateIcons()
  self:UpdateText()
  self:UpdateTimeline()
  self:UpdateScreen()
  self:UpdateVoice()
  self:UpdateSay()
  self:UpdatePlayerAlpha()
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
  name = "",
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
  local removes = data.removes or expires + 0.5
  local reverse = data.reverse == nil and true or data.reverse
  local size = data.size or 1
  local name = data.name or ""
  local count = data.count or ""
  local scale = data.scale == nil and 10/size or data.scale
  self.iconDatas[index] = {
    texture = texture,
    duration = duration,
    expires = expires,
    start = start,
    removes = removes,
    reverse = reverse,
    size = size,
    name = name,
    count = count,
    scale = scale,
    justSetUp = true,
  }
  return self.iconDatas[index]
end
function Core:ClearIcon(index)
  self.iconDatas[index] = nil
end

function Core:SetIcon(index,texture,size,duration,expires,removes,reverse,count)
  index = index or 0
  texture = texture or 458972
  duration = duration or 10
  expires = expires or GetTime() + duration
  removes = removes or expires + 0.5
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

function Core:ClearIcon(index)
  self.iconDatas[index] = nil
end

local scaleDuration = 0.3

function Core:UpdateIcons()
  local disable = db.anchorDisables and db.anchorDisables.icon
  if disable then
    wipe(self.iconDatas)
  else
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
        castIconCooldown:SetHideCountdownNumbers(true)
        castIconCooldown.noCooldownCount = true
        castIconCooldown:SetAllPoints()
        icon.castIconCooldown = castIconCooldown

        local castIconTexture = icon:CreateTexture(nil,"BACKGROUND")
        castIconTexture:SetAllPoints()
        castIconTexture:SetColorTexture(0,0,0)
        icon.castIconTexture = castIconTexture

        local iconText = CreateFrame("Frame")
        iconText:SetFrameStrata("HIGH")
        iconText:SetParent(icon)
        iconText:SetPoint("CENTER")
        icon.iconText = iconText

        local count = iconText:CreateFontString()
        count:SetAllPoints()
        count:SetFont("Fonts\\ARKai_C.TTF",72,"OUTLINE")
        count:SetJustifyH("RIGHT")
        count:SetJustifyV("BOTTOM")
        count:SetWordWrap(false)
        count:SetDrawLayer("OVERLAY",7)
        icon.count = count

        local name = iconText:CreateFontString()
        name:SetAllPoints()
        name:SetFont("Fonts\\ARKai_C.TTF",72,"OUTLINE")
        name:SetJustifyH("LEFT")
        name:SetJustifyV("TOP")
        name:SetWordWrap(false)
        icon.name = name

        local cd = iconText:CreateFontString()
        cd:SetAllPoints()
        cd:SetFont("Fonts\\ARKai_C.TTF",72,"OUTLINE")
        cd:SetJustifyH("CENTER")
        cd:SetJustifyV("MIDDLE")
        cd:SetWordWrap(false)
        icon.cd = cd

        self.icons[k] = icon
      end
      if now > v.removes then
        icon:Hide()
        self.iconDatas[k] = nil
      elseif not v.start or now > v.start then
        if not v.scaling and v.scale and v.scale ~= false then
          v.scaling = now + scaleDuration
        end
        if resized or v.justSetUp or v.scaling then
          -- if v.scaled then
          --   v.scaled = nil
          --   print("scaled")
          -- end
          local isize = size*(v.size or 1)
          local x,y = ((k)%10)*size + isize/2, -math.floor(k/10)*size - isize/2
          if v.scaling  then
            if v.scaling > now then
              local p = (v.scaling - now)/scaleDuration
              local scale = ((v.scale-1)*p + 1)
              isize = scale * isize

              local ax, ay = anchor:GetLeft(),anchor:GetBottom()
              local w,h = UIParent:GetSize()
              local s = UIParent:GetScale()
              w = w*s
              h = h*s
              local dx = ax + x - w/2
              local dy = ay + y - h/2
              -- print(dx,dy,p)
              x = x - dx * p
              y = y - dy * p
            else
              v.scaling = nil
              v.scale = nil
            end
          end
          icon:ClearAllPoints()
          icon:SetPoint("CENTER",anchor,"BOTTOMLEFT",x,y)
          icon:SetSize(isize, isize)
          icon.iconText:SetSize(isize*0.9, isize*0.9)
          local countText = v.count or ""
          local countLen = string.len(countText)
          local countSize = min(isize*0.4,2*isize/countLen)
          icon.count:SetFont("Fonts\\ARKai_C.TTF",countSize,"OUTLINE")
          icon.count:SetText(countText)
          local nameText = v.name or ""
          local nameLen = string.len(nameText)
          local nameSize = min(isize*0.4,2*isize/nameLen)
          icon.name:SetFont("Fonts\\ARKai_C.TTF",nameSize,"OUTLINE")
          icon.name:SetText(nameText)
          icon.count:SetText(countText)

          icon.cd:SetFont("Fonts\\ARKai_C.TTF",isize*0.5,"OUTLINE")
        end
        if v.justSetUp then
          icon.castIconTexture:SetTexture(v.texture)
          icon.castIconCooldown:SetCooldown(v.expires - v.duration, v.duration)
          icon.castIconCooldown:SetReverse(v.reverse)
          icon:Show()
        end
        local formatCD = function(value)
          return string.format(value<0 and "" or value<3 and "|cffff0000%0.1f|r" or value<5 and "|cffff0000%0.0f|r" or "|cffffff00%0.0f|r",value)
        end
        local cd = formatCD(v.expires - now)
        icon.cd:SetText(cd)
        v.justSetUp = false
        icon.show = true
      end
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
  local removes = data.removes or expires + 1
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
  local disable = db.anchorDisables and db.anchorDisables.text
  if disable then
    wipe(self.textDatas)
    if self.text then
      self.text:Hide()
    end
    return
  end
  local anchor = self.anchors.text
  local resized = anchor.resizing
  if resized then anchor.resizing = nil end
  local size = anchor:GetWidth()/5
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
  local earlyExpires, earlyExpiresData
  for i, data in pairs(self.textDatas) do
    if now > data.removes then
      tremove(self.textDatas,i)
    elseif now > data.start then
      if not earlyExpires or data.expires<earlyExpires then
        earlyExpires = data.expires
        earlyExpiresData = data
      end
    end
  end
  if earlyExpiresData then
    local data = earlyExpiresData
    local ftext
    if now > data.expires then
      ftext = data.text2
    else
      ftext = data.text1
    end
    local num = self:GetTimeString(data.expires-now)
    ftext = string.gsub(ftext,"{number}",num)
    text.fontstring:SetText(ftext)
    if resized or data.justSetUp then
      text:ClearAllPoints()
      text:SetPoint("CENTER",anchor,"BOTTOM", 0, -size*0.6)
      text.fontstring:SetFont("Fonts\\ARKai_C.TTF",size,"THICKOUTLINE")
      text:SetSize(20*size,size)
    end
    if data.justSetUp then
      -- TODO play scale animation
    end
    data.justSetUp = false
    text:Show()
  else
    text:Hide()
  end
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
  local a = data.a or 1
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
  a = a or 1
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
  local disable = db.anchorDisables and db.anchorDisables.screen
  if disable then
    wipe(self.screenDatas)
    if self.screen then
      self.screen:Hide()
    end
    return
  end
  local now = GetTime()
  for i,v in ipairs(self.screenDatas) do
    if now>v.time then
      local screen = self.screen
      if not screen then
        screen = CreateFrame("Frame")
        screen:SetFrameStrata("TOOLTIP")
        screen:SetAllPoints(UIParent)
        local texture = screen:CreateTexture()
        texture:SetAllPoints()
        texture:SetBlendMode("ADD")
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
        return
      end
    end
  end
  if self.screen then
    self.screen:Hide()
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
  local disable = db.anchorDisables and db.anchorDisables.say
  if disable then
    wipe(self.sayDatas)
    return
  end
  local now = GetTime()
  for i,v in ipairs(self.sayDatas) do
    if now>v.time then
      SendChatMessage(v.text,"SAY")
      tremove(self.sayDatas,i)
    end
  end
end

--voice
function Core:SetVoiceT(data)
  local time = data.time or GetTime()
  local str = data.str
  local interval = data.interval
  local file = data.file or str == nil and "runaway"
  tinsert(self.voiceDatas,{time=time,file=file,str=str,interval=interval})
end
function Core:SetVoice(file,time,interval)
  file = file or "runaway"
  time = time or GetTime()
  tinsert(self.voiceDatas,{time=time,file=file,interval=interval})
end

function Core:PlayDBMYike(name)
  PlaySoundFile("Interface\\AddOns\\DBM-VPYike\\"..name..".ogg", "Master")
end

function Core:PlayChar(c)
  -- print("play",c)
  PlaySoundFile("Interface\\AddOns\\AirjBossMods\\sounds\\pinyin\\"..c..".gsm", "Master")
end

function Core:PlayString(str,interval)
  local cs = {strsplit(" ",str)}
  if #cs<1 then
    return
  end
  local played = 0
  interval = interval or 0.1
  for i,c in ipairs(cs) do
    if c ~= "" then
      local delay = (played*0.8 + (i-1)*0.2) * interval
      if delay > 0 then
        self:ScheduleTimer(function()
          Core:PlayChar(c)
        end,delay)
      else
        Core:PlayChar(c)
      end
      played = played + 1
    end
  end
end

function Core:PlayStringB(str,interval)
  local cs = {strsplit(" ",str)}
  if #cs<1 then
    return
  end
  local index = 1
  local next = GetTime()
  interval = interval or 0.1
  local timer
  timer = self:ScheduleRepeatingTimer(function()
    local c = cs[index]
    if c then
      local now = GetTime()
      if now>=next then
        index = index + 1
        if c ~= "" then
          Core:PlayChar(c)
        end
        local t = 1
        if c == "" then
          t = 0.2
        elseif strsub(c,-1) == "3" then
          t = 1.2
        end
        -- next = now + interval * t
        next = next + interval * t
      end
    else
      self:CancelTimer(timer)
    end
  end,0.01)
end
function Core:UpdateVoice()
  local disable = db.anchorDisables and db.anchorDisables.voice
  if disable then
    wipe(self.voiceDatas)
    return
  end
  local now = GetTime()
  for i,v in ipairs(self.voiceDatas) do
    if now>v.time then
      if v.str then
        self:PlayString(v.str,v.interval)
      elseif v.file then
        self:PlayDBMYike(v.file)
      end
      tremove(self.voiceDatas,i)
    end
  end
end

-- player alpha
function Core:SetPlayerAlpha(data)
  local now = GetTime()
  local alpha = data.alpha or 0.4
  local removes = data.removes or now + 5
  local start = start or now
  tinsert(self.playerAlphaDatas, 1, {
    alpha = alpha,
    removes = removes,
    start = start,
    justSetUp = true,
  })
end
local justset
function Core:UpdatePlayerAlpha()
  if not AirjAVR then return end
  local disable = db.anchorDisables and db.anchorDisables.avr
  if disable then
    AirjAVR.playerAlpha =0
  else
    local now = GetTime()
    for i,data in ipairs(self.playerAlphaDatas) do
      if now >data.removes then
        self.playerAlphaDatas[i] = nil
      elseif now > data.start then
        AirjAVR.playerAlpha = data.alpha
        justset = true
        return
      end
    end
    if justset then
      AirjAVR.playerAlpha =0
      justset = nil
    end
  end
end

-- timeline
function Core:SetTimeline(data)
  local now = GetTime()
  local datas = self.timelineDatas
  local text = data.text or ""
  local expires = data.expires or now + 15
  local removes = data.removes or expires + 10
  local start = data.start or expires - 15
  local preshow = data.pershow or expires - 60
  local color = data.color or {1,0,0,1}
  local color2 = data.color2 or {0,1,0,0.2}
  local phase = data.phase
  local key
  if not data.key and data.text then
    key = strsplit(" ",data.text)
  else
    key = data.key or getId()
  end
  datas[key] = {text = text, expires = expires, removes = removes, start = start, preshow = preshow,
   color = color, color2 = color2, phase = phase}
end

function Core:ClearTimeline(key)
  self.timelineDatas[key] = nil
end

function Core:UpdateTimeline()
  local disable = db.anchorDisables and db.anchorDisables.timeline
  if disable then
    for i = 1,#self.timelineRows do
      self.timelineRows[i]:Hide()
    end
    return
  end
  local now = GetTime()
  local anchor = self.anchors.timeline
  local resized = anchor.resizing
  if resized then anchor.resizing = nil end

  local bossMod = self:GetCurrentBossMod()
  local phase = bossMod and bossMod.phase
  local basetime = bossMod and bossMod.basetime

  local rowdata = {}
  local rownum = 0
  local width = anchor:GetWidth()
  local height = width/12
  for k,v in pairs(self.timelineDatas) do
    if now > v.removes then
      self.timelineDatas[k] = nil
    elseif not v.phase or v.phase == phase then
      -- tinsert(datas,v)
      if now > v.preshow then
        rownum = rownum + 1
        rowdata[rownum] = v
      end
    end
  end
  sort(rowdata,function(a,b)
    if a == nil or b == nil then
      return false
    end
    if a == b then
      return false
    end
    return a.expires < b.expires
  end)
  -- dump(rowdata)

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
      fontstring:SetFont("Fonts\\ARKai_C.TTF",72,"MONOCHROME")
    	fontstring:SetAllPoints()
      fontstring:SetJustifyH("LEFT")
      row.name = fontstring
      fontstring = bar:CreateFontString(nil,"OVERLAY","GameFontHighlight")
      fontstring:SetFont("Fonts\\ARKai_C.TTF",72,"MONOCHROME")
    	fontstring:SetAllPoints()
      fontstring:SetJustifyH("RIGHT")
      row.time = fontstring
      self.timelineRows[i] = row
      row:Hide()
    end
    if resized or not row:IsShown() then
      row:SetSize(width,height)
      row:SetPoint("TOP",anchor,"BOTTOM",0,-(i-1)*height)
      row.name:SetFont("Fonts\\ARKai_C.TTF",height*0.5,"OUTLINE")
      row.time:SetFont("Fonts\\ARKai_C.TTF",height*0.8,"OUTLINE")
    end
    local color, percent, alpha, timeString
    if now <data.start then
      percent = 0
      color = data.color
      alpha = color[4] or 1
    elseif now < data.expires then
      local duration = data.expires - data.start
      percent = (now - data.start)/duration
      color = data.color
      alpha = color[4] or 1
    elseif now < data.expires + 10 then
      percent = 1
      color = data.color2
      local p = (now - data.expires)/10
      local a1 = data.color[4] or 1
      local a2 = data.color2[4] or 0.2
      alpha = p * a2 + (1-p) * a1
    else
      percent = 1
      color = data.color2
      alpha = color[4] or 0.2
    end
    if now < data.expires then
      timeString = "|cffffff00 -"..self:GetTimeString(data.expires - now).."|r"
    else
      timeString = "|cffffffff -"..self:GetTimeString(-(data.expires - now)).."|r"
    end
    local text = data.text or ""
    text = self:FormatString(text)
    row.name:SetText(text)
    row.time:SetText(timeString or "")
    row.bar:SetValue(percent)
    row.bar:SetAlpha(alpha or 1)
    row.bar:SetStatusBarColor(unpack(color or {1,1,0.5},1,3))
    row:Show()
    -- print(text,percent,alpha,now - data.expires)
  end
  for i = rownum+1,#self.timelineRows do
    self.timelineRows[i]:Hide()
  end
end

function Core:UpdateTimelineB()
  local bossMod = self:GetCurrentBossMod()

  local disable = db.anchorDisables and db.anchorDisables.timeline
  if not bossMod or disable then
    for i = 1,#self.timelineRows do
      self.timelineRows[i]:Hide()
    end
    return
  end
  local anchor = self.anchors.timeline
  local resized = anchor.resizing
  if resized then anchor.resizing = nil end
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
          if not vv.disabled then
            rownum = rownum + 1
            rowdata[rownum] = vv
          end
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
      fontstring:SetFont("Fonts\\ARKai_C.TTF",72,"MONOCHROME")
    	fontstring:SetAllPoints()
      fontstring:SetJustifyH("LEFT")
      row.name = fontstring
      fontstring = bar:CreateFontString(nil,"OVERLAY","GameFontHighlight")
      fontstring:SetFont("Fonts\\ARKai_C.TTF",72,"MONOCHROME")
    	fontstring:SetAllPoints()
      fontstring:SetJustifyH("RIGHT")
      row.time = fontstring
      self.timelineRows[i] = row
    end
    if resized or timelineChanged then
      row:SetSize(width,height)
      row:SetPoint("TOP",anchor,"BOTTOM",0,-(i-1)*height)
      row.name:SetFont("Fonts\\ARKai_C.TTF",height*0.5,"OUTLINE")
      row.time:SetFont("Fonts\\ARKai_C.TTF",height*0.8,"OUTLINE")
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
          timeString = "|cffff3000 -"..self:GetTimeString(-(basetime+data.time-now)).."|r"
        elseif now>basetime+data.time-10 then
          percent = (now - (basetime+data.time-10))/10
          timeString = "|cffffff00"..self:GetTimeString(basetime+data.time-now).."|r"
          alpha = 1
        else
          percent = 0
          timeString = basetime+data.time-now<60 and self:GetTimeString(basetime+data.time-now) or "-"
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


-- furture damage

function Core:SetFutureDamage(data)
  local now = GetTime()
  local key = data.key or getId()
  data.damage = data.damage or 0
  if data.damage == 0 then
    self.futureDamageDatas[key] = nil
  else
    data.start = data.start or now
    data.guid = data.guid or "all"
    data.duration = data.duration or 1
    data.removes = data.removes or data.start + data.duration
    self.futureDamageDatas[key] = data
  end
end

function Core:ClearFutureDamage(key)
  self.futureDamageDatas[key] = nil
end

function Core:GetFutureDamage(guid,time)
  local damage = 0
  local now = GetTime()
  for key, data in pairs(self.futureDamageDatas) do
    if now > data.removes then
      self.futureDamageDatas[key] = nil
    elseif data.guid == "all" or data.guid == guid then
      local s, e = data.start
      local d = data.duration
      e = s + d
      local t
      if now + time < s then
        t = 0
      elseif now + time < e then
        if now < s then
          t = now + time - s
        else
          t = time
        end
      else
        if now > e  then
          t = 0
        else
          t = e - now
        end
      end
      damage = damage + data.damage*t/data.duration
    end
  end
  return damage
end

function Core:GetFutureDamageFrames(guid,time)
  local frames = {}
  local now = GetTime()
  for key, data in pairs(self.futureDamageDatas) do
    if now > data.removes then
      self.futureDamageDatas[key] = nil
    elseif data.guid == "all" or data.guid == guid then
      if now+time > data.start and now < data.start + data.duration then
        local dps=data.damage/data.duration
        local s = max(data.start, now)
        local e = min(data.start+data.duration, now+time)
        tinsert(frames,{time=s,dps=dps})
        tinsert(frames,{time=e,dps=-dps})
      end
    end
  end
  sort(frames, function(a,b) return a.time < b.time end)
  return frames
end

function Core:GetDifficultyDamage(difficulty,mythic,heroic,normal,raidfinder)
  if difficulty == 16 then
    return mythic
  elseif difficulty == 14 then
    return normal or mythic and mythic*0.45
  elseif difficulty == 17 then
    return  raidfinder or mythic and mythic*0.25
  else
    return heroic or mythic and mythic*0.75
  end
end
