local mod = LibStub("AceAddon-3.0"):NewAddon("AirjAVR", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"
AirjAVR = mod

function mod:OnInitialize()
end

function mod:OnEnable()
  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectCreated,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectDestroyed,self)
end

function mod:OnDisable()
  self:UnregisterMessage("AIRJ_HACK_OBJECT_CREATED")
  self:UnregisterMessage("AIRJ_HACK_OBJECT_DESTROYED")
end

function mod:OnObjectCreated(event,guid,type)
  if bit.band(type,0x100)~=0 or true then
    mod:Print("+++ ", guid)
    local spellId = AirjGetObjectDataInt(guid,0x88)
    print(spellId)
    mod:Test4(guid,spellId)
  end
end

function mod:OnObjectDestroyed(event,guid,type)
  if bit.band(type,0x100)~=0 or true then
    mod:Print("---- ", guid)
  end
end

function mod:Test(follow)

  local data = {
    color = {
      0,1,0,0.2,
    },
    duration = 20,
    expiration = GetTime()+10,
    radius = 8,
    removeOnExpire = true,
    follow = follow,
    stopOnCreate = false,
  }
  local scene = AVR:GetTempScene(100)
  local r,g,b,a = unpack(data.color)

  local mesh = AVRTimerCircleMesh
  local m=mesh:New(data.radius,90)

  m:SetColor(r,g,b,a)
  if data.stopOnCreate then
    local x,y,z,f = AirjHack:Position(data.follow)
    m:SetMeshTranslate(x,y,z)
    m:SetMeshRotation(f)
  else
  	m:SetFollowUnit(data.follow)
    m.OnUpdate = function(self,threed)
      mesh.OnUpdate(self,threed)
      local x,y,z,f = AirjHack:Position(data.follow)
      self.rotateZ = f
    end
  end

  m:SetTimer(data.duration, data.expiration)
  m:SetColor2(r/2,g/2,b/2,a)
  m:SetRemoveOnExpire(data.removeOnExpire)


	--

  scene:AddMesh(m,false,false)
  return m
end


function mod:Test2(follow)

  local data = {
    color = {
      0,1,0,0.2,
    },
    duration = 20,
    expiration = GetTime()+10,
    radius = 8,
    removeOnExpire = true,
    follow = follow,
    stopOnCreate = false,
  }
  local scene
	if not scene then
		scene=AVR.sceneManager:GetSelectedScene()
		if not scene then return end
	end
  local mesh = AVRCircleMesh

  local m=mesh:New(8,60,false,32)
  m:SetColor(r,g,b,a)
  if data.stopOnCreate then
    local x,y,z,f = AirjHack:Position(data.follow)
    m:SetMeshTranslate(x,y,z)
    m:SetMeshRotation(f)
  else
  	m:SetFollowUnit(data.follow)
    m.OnUpdate = function(self,threed)
      local fcn = mesh.OnUpdate or AVRMesh.OnUpdate
      fcn(self,threed)
      local x,y,z,f = AirjHack:Position(data.follow)
      self.rotateZ = f
    end
  end
  scene:AddMesh(m,false,false)
end

local cps={}
local sin = math.sin
local cos = math.cos
local pi = math.pi
for i=1,5 do
	cps[i*2-1]=-cos(2*pi/5*(i-1))
	cps[i*2]=sin(2*pi/5*(i-1))
end
function mod:Test3(follow)
  local scene
	if not scene then
		scene=AVR.sceneManager:GetSelectedScene()
		if not scene then return end
	end
  local m=AVRFilledCircleMesh:New(8,60)


    m:SetFollowUnit(follow)
--  m:SetMeshRotation(f)

  m:SetUseTexture(true)

  m.GenerateMesh = function(self)
    local texture=GetSpellTexture(1543)
    local t=self:AddIcon( 0,0,4,texture,1000,0.6)
  --  t.rotateTexture=false
  	AVRMesh.GenerateMesh(self)
  end

  scene:AddMesh(m,false,false)
end

function mod:Test4(follow,spellId)
  local scene = AVR:GetTempScene(100)
  local m=AVRUnitMesh:New(follow,spellId)
  scene:AddMesh(m,false,false)
end
