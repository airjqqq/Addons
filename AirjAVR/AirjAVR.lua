local mod = LibStub("AceAddon-3.0"):NewAddon("AirjAVR", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"
AirjAVR = mod
mod.debug = true
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")

function mod:OnInitialize()
  self.onCreatedRegisteredIds={}
  self.activeMeshs={}
end

function mod:OnEnable()
  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectCreated,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectDestroyed,self)
  self:RegisterEvent("MODIFIER_STATE_CHANGED",self.OnModifierStateChanged,self)
  local oxgift = {
    color={0.0,0.7,0,0.2},
    color2={0.0,0.9,0,0.3},
    radius=1,
    duration=30,
    updateCallbacks = {
      function(m,t)
        if m.expiration == nil then
          -- self:Print("updateCallbacks","expires")
          return
        end
        local health, max = Cache:GetHealth(Cache:PlayerGUID())
        local highlight = health/max <0.35
        if m.highlight ==nil or m.highlight ~= highlight then
          m.highlight=highlight
          if highlight then
            m.spellId = 124503
            m:SetColor(0.0,0.7,0,0.5)
            m:SetColor2(0.0,0.9,0,0.7)
          else
            m.spellId = nil
            m:SetColor(0.7,0.7,0,0.1)
            m:SetColor2(0.9,0.9,0,0.2)
          end
        end
        local px,py,pz = t.playerPosX,t.playerPosY,t.playerPosZ
        local x,y,z = AirjHack:Position(m.followUnit)
        if not x then
          m.vertices = nil
          m.expiration = nil
          return
        end
        local dx,dy,dz =x-px,y-py,z-pz
        local d = math.sqrt(dx*dx+dy*dy+dz*dz)
        if d <1 then
          m.vertices = nil
          m.expiration = nil
        end
      end,
    },
  }
  self:RegisterObjectOnCreated("AreaTrigger",132950,{color={0.4,0,0,0.2},color2={0.6,0,0,0.3},radius=10,duration=20})
  self:RegisterObjectOnCreated("AreaTrigger",124503,oxgift)
  self:RegisterObjectOnCreated("AreaTrigger",124506,oxgift)
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
