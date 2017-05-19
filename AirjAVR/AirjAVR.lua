local Core = LibStub("AceAddon-3.0"):NewAddon("AirjAVR", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"
AirjAVR = Core
Core.debug = true
local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local db
function Core:OnInitialize()

	self.register = setmetatable({},{
		__index=function(t,k)
			t[k]={}
			return t[k]
		end
	})
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

	self.objectHistory = AirjUtil:NewFIFO(1000)
	AirjAVRDB = AirjAVRDB or {}
	db = AirjAVRDB
	if db.history then
		for i,v in ipairs(db.history) do
			self.objectHistory:push(v)
		end
	end
	
  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectCreated,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectDestroyed,self)
  self:RegisterEvent("MODIFIER_STATE_CHANGED",self.OnModifierStateChanged,self)
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function Core:OnDisable()
  self:UnregisterMessage("AIRJ_HACK_OBJECT_CREATED")
  self:UnregisterMessage("AIRJ_HACK_OBJECT_DESTROYED")
  self:UnregisterEvent("MODIFIER_STATE_CHANGED")
	db.history = {}
	for v,k,i in self.objectHistory:iterator() do
		db.history[i] = v
	end
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


function Core:ShowUnitMesh(data,spellId,sourceGUID,destGUID,text)
  local scene = AVR:GetTempScene(100)
  if data then
    local key = spellId.."-"..destGUID
    local m = self.activeMeshs[key]
    if not m then
      m=AVRUnitMesh:New(destGUID,data.spellId or spellId, data.radius or 8,function(...)
        self.activeMeshs[key]=nil
      end)
		else
			m:Remove()
    end
		local meshduration
		local unit = Cache:FindUnitByGUID(destGUID)
		if unit then
			local spellName = GetSpellInfo(spellId)
			local fcn = data.isbuff and UnitBuff or UnitDebuff
			local name, rank, icon, count, dispelType, duration, expires = fcn(unit,spellName)
			if name then
				meshduration = duration
				if meshduration == 0 then
					meshduration = 5
				end
			end
		end
    m:SetTimer(data.duration or meshduration or 9)
    m:SetColor(unpack(data.color or {}))
		do
			local r,g,b,a
			if data.color2 then
				r,g,b,a = unpack(data.color2)
			elseif data.color then
				r,g,b,a = unpack(data.color)
				if a then
					a = math.min(a+0.1,1)
				end
			end
	    m:SetColor2(r,g,b,a)
		end
    m.updateCallbacks = data.updateCallbacks
		m.suffix = text
    scene:AddMesh(m,false,false)
    self.activeMeshs[key]=m
  end
end

function Core:HideUnitMesh(data,spellId,sourceGUID,destGUID)
  if data then
    local key = spellId.."-"..destGUID
    local m = self.activeMeshs[key]
    if m then
			m.visible=false
			m.vertices = nil
			m.expiration = nil
			-- m:Remove()
			self.activeMeshs[key] = nil
    end
		return m
  end
end

function Core:ShowLinkMesh(data,spellId,sourceGUID,destGUID)
  local scene = AVR:GetTempScene(100)
  if data then
    local key = sourceGUID .. "-" .. spellId.."-"..destGUID.."-link"
    local m = self.activeMeshs[key]
    if not m then
      m=AVRLinkMesh:New(destGUID,data.width,data.alpha)
      m.blank = 0
      m.showNumber = false
    end
    m:SetClassColor(data.classColor or false)
    m:SetColor(unpack(data.color or {}))
    m:SetFollowPlayer(nil)
    m:SetFollowUnit(sourceGUID)
		m.length = data.length
    scene:AddMesh(m,false,false)
    self.activeMeshs[key]=m
		m.key = key
		return m
  end
end

function Core:HideLinkMesh(data,spellId,sourceGUID,destGUID)
  if data then
    local key = sourceGUID .. "-" .. spellId.."-"..destGUID.."-link"
    local m = self.activeMeshs[key]
    if m then
      m.visible=false
      m:Remove()
      self.activeMeshs[key] = nil
    end
  end
end

function Core:HideLinkMeshM(m)
  if m then
    local key = m.key
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

local colorIndex = 1

function Core:OnObjectCreated(event,guid,type)
	-- print(guid,type)
  if bit.band(type,0x2)==0 then
    local objectType,serverId,instanceId,zone,cid,spawn = self:GetGUIDInfo(guid)
		local history = {}
		history.guid = guid
		-- self:Print(guid)
    if objectType == "AreaTrigger" then
      local spellId = AirjHack:ObjectInt(guid,0x88)
      local radius = AirjHack:ObjectFloat(guid,0x94)
      local duration = AirjHack:ObjectInt(guid,0x78)
      local data = self.register.onAreaTriggerCircleIds[spellId]
      if data and not data.radius and radius~=0 then
        data.radius = radius
      end
      self:ShowUnitMesh(data,spellId,nil,guid)
			history.spellId = spellId
			history.radius = radius
			history.duration = duration
    end
    if objectType == "Creature" or objectType == "GameObject" or objectType == "Vehicle" then
			local data = self.register.onCreatureLinkIds[cid]
			if data then
				local destUnit = data.destUnit or "player"
				local destuid = UnitGUID(destUnit)
				if guid then
      		self:ShowLinkMesh(data,0,guid,destuid)
				end
			end
    end
		local position = {AirjHack:Position(guid)}
		history.position = position
		self.objectHistory:push(history)
  end
end

function Core:OnObjectDestroyed(event,guid,type)
  if bit.band(type,0x2)==0 then
    local objectType,serverId,instanceId,zone,cid,spawn = self:GetGUIDInfo(guid)
    if objectType == "AreaTrigger" then
      local spellId = AirjHack:ObjectInt(guid,0x88)
      self:HideUnitMesh(self.register.onAreaTriggerCircleIds[spellId],spellId,nil,guid)
    end
    if objectType == "Creature" then
      self:HideLinkMesh(self.register.onCreatureLinkIds[cid],0,UnitGUID("player"),guid)
    end
  end
end


function Core:GetUnitList()
	if self.unitListCache then return self.unitListCache end
	local subUnit = {"","target","pet","pettarget"}
	local list = {"player","target","targettarget","pet","pettarget","focus","focustarget","mouseover","mouseovertarget"}
	for i = 1,5 do
		tinsert(list,"arena"..i)
	end
	for i = 1,4 do
		tinsert(list,"boss"..i)
		tinsert(list,"boss"..i.."target")
	end
	for _,sub in pairs(subUnit) do
		for i = 1,4 do
			tinsert(list,"party"..i..sub)
		end
	end
	for i = 1,40 do
		for _,sub in pairs(subUnit) do
			tinsert(list,"raid"..i..sub)
		end
	end
	for i = 1,40 do
		tinsert(list,"nameplate"..i)
	end
	self.unitListCache=list
	return list
end

function Core:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
  if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event =="SPELL_AURA_APPLIED_DOSE" then
		local _,count = ...
		local text
		if count then text = " - "..count end
    self:ShowUnitMesh(self.register.onAuraUnitIds[spellId],spellId,sourceGUID,destGUID,text)
    self:ShowLinkMesh(self.register.onAuraLinkIds[spellId],spellId,sourceGUID,destGUID)
  end
  if event == "SPELL_AURA_REMOVED" or event == "SPELL_AURA_BROKEN" or event =="SPELL_AURA_BROKEN_SPELL" then
    local data = self.register.onAuraUnitIds[spellId]
    --self:Print(objectType,id,data)
    self:HideUnitMesh(self.register.onAuraUnitIds[spellId],spellId,sourceGUID,destGUID)
    self:HideLinkMesh(self.register.onAuraLinkIds[spellId],spellId,sourceGUID,destGUID)
  end
  if event == "SPELL_CAST_START" then
    local data = self.register.onBreathIds[spellId]
		-- dump(data)
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
			local scene = AVR:GetTempScene(100)
      scene:AddMesh(m,false,false)
      self.activeMeshs[key]=m
    end
  end
end


do --Registers
  function Core:RegisterCreatureLink(cid,data)
    self.register.onCreatureLinkIds[cid]=data or {}
  end

  function Core:RegisterAreaTriggerCircle(spellId,data)
    self.register.onAreaTriggerCircleIds[spellId]=data or {}
  end

  function Core:RegisterAuraUnit(spellId,data)
    self.register.onAuraUnitIds[spellId]=data or {}
  end

  function Core:RegisterBreath(spellId,data)
    self.register.onBreathIds[spellId]=data or {}
  end

  function Core:RegisterAuraLink(spellId,data)
    self.register.onAuraLinkIds[spellId]=data or {}
  end
end
