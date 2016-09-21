local Core = LibStub("AceAddon-3.0"):NewAddon("AirjAVR", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"
AirjAVR = Core
Core.debug = true
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")

function Core:OnInitialize()
  self.onCreatedRegisteredIds={}
  self.onAuraLinkIds={}
  self.onAuraIds={}
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
  if not self.lockVirtual then
    if IsAltKeyDown() and IsControlKeyDown() then
      AVR3D:VirtualCamera(120,math.pi/2,2)
    else
      AVR3D:VirtualCamera(nil,nil,nil)
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
    if objectType == "AreaTrigger" then
      id = AirjHack:ObjectInt(guid,0x88)
    end
  end
  return objectType,serverId,instanceId,zone,id,spawn
end

function Core:OnObjectCreated(event,guid,type)
  if bit.band(type,0x2)==0 then
    local scene = AVR:GetTempScene(100)
    local objectType,serverId,instanceId,zone,id,spawn = self:GetGUIDInfo(guid)

    if id then
      if self.debug or true then
        if objectType == "AreaTrigger" then
          local link = GetSpellLink(id)
          self:Print(AirjHack:GetDebugChatFrame(),guid,link,AirjHack:ObjectFloat(guid,0x90))
        end
      end

      local data = self.onCreatedRegisteredIds[objectType.."-"..id]
      --self:Print(objectType,id,data)
      if data then
        local key = objectType.."-"..id
        if spawn then
          key=key.."-"..spawn
        end
        local m=AVRUnitMesh:New(guid,data.spellId or objectType == "AreaTrigger" and id,data.radius or AirjHack:ObjectFloat(guid,0x90),function(...)
          self.activeMeshs[key]=nil
        end)
        m:SetTimer(data.duration or 20)
        m:SetColor(unpack(data.color or {}))
        m:SetColor2(unpack(data.color2 or {}))
        m.updateCallbacks = data.updateCallbacks
        scene:AddMesh(m,false,false)
        self.activeMeshs[key]=m
      end
    end
  end
end

function Core:OnObjectDestroyed(event,guid,type)
end

function Core:RegisterObjectOnCreated(objectType,id,data)
  self.onCreatedRegisteredIds[objectType.."-"..id]=data or {}
end

function Core:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
  local scene = AVR:GetTempScene(100)
  if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event =="SPELL_AURA_APPLIED_DOSE" then
    local data = self.onAuraIds[spellId]
    --self:Print(objectType,id,data)
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
    data = self.onAuraLinkIds[spellId]
    --self:Print(objectType,id,data)
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
  if event == "SPELL_AURA_REMOVED" or event == "SPELL_AURA_BROKEN" or event =="SPELL_AURA_BROKEN_SPELL" then
    local data = self.onAuraIds[spellId]
    --self:Print(objectType,id,data)
    if data then
      local key = spellId.."-"..destGUID
      local m = self.activeMeshs[key]
      if m then
        m.vertices = nil
        m.expiration = nil
        self.activeMeshs[key] = nil
      end
    end
    data = self.onAuraLinkIds[spellId]
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
  if event == "SPELL_CAST_START" then
    local data = self.onBreathIds[spellId]
    if data then
      local key = spellId.."-"..sourceGUID.."-caststart"
      local m = self.activeMeshs[key]
      if not m then
        m=AVRPolygonMesh:New(data.line,data.inalpha,data.outalpha)
      end
      m:SetColor(unpack(data.color or {}))
      m:SetFollowUnit(sourceGUID)
      Core:ScheduleTimer(function()
        m.visible=false
				m:Remove()
        self.activeMeshs[key] = nil
      end,data.duration or 8)
      scene:AddMesh(m,false,false)
      self.activeMeshs[key]=m
    end
  end
end

function Core:RegisterAuraOnApplied(spellId,data)
  self.onAuraIds[spellId]=data or {}
end

function Core:RegisterBreath(spellId,data)
  self.onBreathIds[spellId]=data or {}
end

function Core:RegisterLink(spellId,data)
  self.onAuraLinkIds[spellId]=data or {}
end
