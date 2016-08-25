local mod = LibStub("AceAddon-3.0"):NewAddon("AirjAVR", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"
AirjAVR = mod
mod.debug = true
function mod:OnInitialize()
  self.onCreatedRegisteredIds={}
  self.activeMeshs={}
end

function mod:OnEnable()
  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectCreated,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectDestroyed,self)
  self:RegisterEvent("MODIFIER_STATE_CHANGED",self.OnModifierStateChanged,self)

  self:RegisterObjectOnCreated("AreaTrigger",132950,{color={0.4,0,0,0.2},color2={0.6,0,0,0.3},radius=10,duration=20})
end

function mod:OnDisable()
  self:UnregisterMessage("AIRJ_HACK_OBJECT_CREATED")
  self:UnregisterMessage("AIRJ_HACK_OBJECT_DESTROYED")
  self:UnregisterEvent("MODIFIER_STATE_CHANGED")
end

function mod:OnModifierStateChanged(event,key,state)
  if IsAltKeyDown() and IsControlKeyDown() then
    AVR3D:VirtualCamera(120,math.pi/2)
  else
    AVR3D:VirtualCamera()
  end
end

function mod:GetGUIDInfo(guid)
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

function mod:OnObjectCreated(event,guid,type)
  if bit.band(type,0x2)==0 then
    local scene = AVR:GetTempScene(100)
    local objectType,serverId,instanceId,zone,id,spawn = self:GetGUIDInfo(guid)

    if id then
      if self.debug or true then
        if objectType == "AreaTrigger" then
          local link = GetSpellLink(id)
          self:Print(guid,link,id)
          self:Print(AirjHack:ObjectFloat(guid,0x90))
        end
      end

      local data = self.onCreatedRegisteredIds[objectType.."-"..id]
      --self:Print(objectType,id,data)
      if data then
        local key = objectType.."-"..id
        if spawn then
          key=key.."-"..spawn
        end
        local m=AVRUnitMesh:New(guid,data.spellId or objectType == "AreaTrigger" and id,data.radius,function(...)
          self.activeMeshs[key]=nil
        end)
        m:SetTimer(data.duration or 20)
        m:SetColor(unpack(data.color or {}))
        m:SetColor2(unpack(data.color2 or {}))
        scene:AddMesh(m,false,false)
        self.activeMeshs[key]=m
        self.test=m
      end
    end
  end
end

function mod:OnObjectDestroyed(event,guid,type)
end


function mod:RegisterObjectOnCreated(objectType,id,data)
  self.onCreatedRegisteredIds[objectType.."-"..id]=data or {}
end
