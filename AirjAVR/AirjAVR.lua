local Core = LibStub("AceAddon-3.0"):NewAddon("AirjAVR", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"
AirjAVR = Core
Core.debug = true
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")

function Core:OnInitialize()
  self.onCreatedIds={}
  self.onAuraLinkIds={}
  self.onAuraUnitIds={}
  self.onBreathIds={}
  self.activeMeshs={}
  self:RegisterChatCommand("aavr", function(str)
    local key, value, nextposition = self:GetArgs(str, 2)
    local subString
    if nextposition~=1e9 then
      subString = strsub(str,nextposition)
    end
    self:OnChatCommmand(key,value,subString)
  end)
end

function Core:OnEnable()
  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectCreated,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectDestroyed,self)
  self:RegisterEvent("MODIFIER_STATE_CHANGED",self.OnModifierStateChanged,self)
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function Core:OnDisable()
  self:UnregisterMessage("AIRJ_HACK_OBJECT_CREATED")
  self:UnregisterMessage("AIRJ_HACK_OBJECT_DESTROYED")
  self:UnregisterEvent("MODIFIER_STATE_CHANGED")
end


do
  local self = Core
  local chatCommands = {
    vir = function(value)
      if not value then
        self.lockVirtual = not self.lockVirtual
      else
        self.lockVirtual = value ~= "0"
      end
      if self.lockVirtual then
        AVR3D:VirtualCamera(120,math.pi/2,2)
      else
        AVR3D:VirtualCamera(nil,nil,1)
      end
    end,
  }
  function Core:OnChatCommmand(key,value,nextString)
    if chatCommands[key] then
      chatCommands[key](value,nextString)
    else
      self:SetParam(key,value)
    end
  end
end

function Core:OnModifierStateChanged(event,key,state)
  -- if not self.lockVirtual then
  --   if IsAltKeyDown() and IsControlKeyDown() then
  --     AVR3D:VirtualCamera(120,math.pi/2,2)
  --   else
  --     AVR3D:VirtualCamera(nil,nil,nil)
  --   end
  -- end
end


function Core:ShowUnitMesh(data,spellId,sourceGUID,destGUID)
  local scene = AVR:GetTempScene(100)
  if data then
    local key = spellId.."-"..destGUID
    local m = self.activeMeshs[key]
    if not m then
      m=AVRUnitMesh:New(destGUID,data.spellId or spellId, data.radius or 8,function(...)
        self.activeMeshs[key]=nil
      end)
    end
    m:SetTimer(data.duration or 9)
    m:SetColor(unpack(data.color or {}))
    m:SetColor2(unpack(data.color2 or {}))
    m.updateCallbacks = data.updateCallbacks
    scene:AddMesh(m,false,false)
    self.activeMeshs[key]=m
  end
end

function Core:HideUnitMesh(data,spellId,sourceGUID,destGUID)
  if data then
    local key = spellId.."-"..destGUID
    local m = self.activeMeshs[key]
    if m then
      m.vertices = nil
      m.expiration = nil
      self.activeMeshs[key] = nil
    end
  end
end

function Core:ShowLinkMesh(data,spellId,sourceGUID,destGUID)
  local scene = AVR:GetTempScene(100)
  if data then
    local key = spellId.."-"..destGUID.."-link"
    local m = self.activeMeshs[key]
    if not m then
      m=AVRLinkMesh:New(destGUID,data.width,data.alpha)
      m:SetClassColor(true)
      m.blank = 0
      m.showNumber = false
    end
    m:SetColor(unpack(data.color or {}))
    m:SetFollowPlayer(nil)
    m:SetFollowUnit(sourceGUID)
    scene:AddMesh(m,false,false)
    self.activeMeshs[key]=m
  end
end

function Core:HideLinkMesh(data,spellId,sourceGUID,destGUID)
  if data then
    local key = spellId.."-"..destGUID.."-link"
    local m = self.activeMeshs[key]
    if m then
      m.visible=false
      m:Remove()
      self.activeMeshs[key] = nil
    end
  end
end


function Core:GetGUIDInfo(guid)
  if not guid then return end
  local guids = {string.split("-",guid)}
  local objectType,serverId,instanceId,zone,id,spawn
  objectType = guids[1]
  if objectType == "Player" then
    _,serverId,id = unpack(guids)
  elseif objectType == "Creature" or objectType == "GameObject" or objectType == "AreaTrigger" then
    objectType,_,serverId,instanceId,zone,id,spawn = unpack(guids)
  end
  id = tonumber(id)
  return objectType,serverId,instanceId,zone,id,spawn
end

function Core:OnObjectCreated(event,guid,type)
  if bit.band(type,0x2)==0 then
    local objectType,serverId,instanceId,zone,cid,spawn = self:GetGUIDInfo(guid)
    if objectType == "AreaTrigger" then
      local spellId = AirjHack:ObjectInt(guid,0x88)
      local radius = AirjHack:ObjectFloat(guid,0x90)
      local data = self.onAreaTriggerCircleIds[spellId]
      data.radius = radius
      self:ShowUnitMesh(data,spellId,nil,guid)
    end
    if objectType == "Creature" then
      self:ShowLinkMesh(self.onCreatureLinkIds[cid],0,UnitGUID("player"),guid)
    end
    if self.debug or true then
      if objectType == "AreaTrigger" then
        local link = GetSpellLink(id)
        self:Print(AirjHack:GetDebugChatFrame(),guid,link,AirjHack:ObjectFloat(guid,0x90))
      end
    end
  end
end

function Core:OnObjectDestroyed(event,guid,type)
  if bit.band(type,0x2)==0 then
    local objectType,serverId,instanceId,zone,cid,spawn = self:GetGUIDInfo(guid)
    if objectType == "AreaTrigger" then
      local spellId = AirjHack:ObjectInt(guid,0x88)
      self:HideUnitMesh(self.onAreaTriggerCircleIds[spellId],spellId,nil,guid)
    end
    if objectType == "Creature" then
      self:HideLinkMesh(self.onCreatureLinkIds[cid],0,UnitGUID("player"),guid)
    end
  end
end

function Core:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
  if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event =="SPELL_AURA_APPLIED_DOSE" then
    self:ShowUnitMesh(self.onAuraUnitIds[spellId],spellId,sourceGUID,destGUID)
    self:ShowLinkMesh(self.onAuraLinkIds[spellId],spellId,sourceGUID,destGUID)
  end
  if event == "SPELL_AURA_REMOVED" or event == "SPELL_AURA_BROKEN" or event =="SPELL_AURA_BROKEN_SPELL" then
    local data = self.onAuraUnitIds[spellId]
    --self:Print(objectType,id,data)
    self:HideUnitMesh(self.onAuraUnitIds[spellId],spellId,sourceGUID,destGUID)
    self:HideLinkMesh(self.onAuraLinkIds[spellId],spellId,sourceGUID,destGUID)
  end
  -- if event == "SPELL_CAST_START" then
  --   local data = self.onBreathIds[spellId]
  --   if data then
  --     local key = spellId.."-"..sourceGUID.."-caststart"
  --     local m = self.activeMeshs[key]
  --     if not m then
  --       m=AVRPolygonMesh:New(data.line,data.inalpha,data.outalpha)
  --     end
  --     m:SetColor(unpack(data.color or {}))
  --     m:SetFollowUnit(sourceGUID)
  --     Core:ScheduleTimer(function()
  --       m.visible=false
	-- 			m:Remove()
  --       self.activeMeshs[key] = nil
  --     end,data.duration or 8)
  --     scene:AddMesh(m,false,false)
  --     self.activeMeshs[key]=m
  --   end
  -- end
end


do --Registers
  function Core:RegisterObjectOnCreated(cid,data)
    self.onCreatureLinkIds[cid]=data or {}
  end

  function Core:RegisterAreaTriggerCircle(spellId,data)
    self.onAreaTriggerCircleIds[spellId]=data or {}
  end

  function Core:RegisterAuraUnit(spellId,data)
    self.onAuraUnitIds[spellId]=data or {}
  end

  function Core:RegisterBreath(spellId,data)
    self.onBreathIds[spellId]=data or {}
  end

  function Core:RegisterAuraLink(spellId,data)
    self.onAuraLinkIds[spellId]=data or {}
  end
end
