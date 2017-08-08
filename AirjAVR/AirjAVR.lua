local Core = LibStub("AceAddon-3.0"):NewAddon("AirjAVR", "AceConsole-3.0", "AceTimer-3.0","AceEvent-3.0")  --, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0"
AirjAVR = Core
Core.debug = true
-- local Cache = LibStub("AceAddon-3.0"):GetAddon("AirjCache")
local db
function Core:OnInitialize()

	self.toBeCreateData = {}
	self.createdMeshs = {}
	self.registerCreateMeshs = {}

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
  self:RegisterChatCommand("avrt", function(str)
		local guids = AirjHack:GetObjects()
		local duration = tonumber(str) or 15
		for guid,type in pairs(guids) do
	    local objectType,serverId,instanceId,zone,cid,spawn = self:GetGUIDInfo(guid)
			local key = "Create - Cooldown - " .. guid
			self:RemoveCreatedMeshByKey(key)
			if duration > 0 then
				local id = self:CreateCooldown({
					guid = guid,
					radius = 3,
					duration = duration,
					color = {0,1,0},
					alpha = 0.1,
					text = guid,
				})
				self.registerCreateMeshs[key] = id
			end
			-- print(guid)
		end
  end)
end

function Core:OnEnable()
	AirjAVRDB = AirjAVRDB or {}
	db = AirjAVRDB
	if AirjUtil then
		self.objectHistory = AirjUtil:NewFIFO(1000)
		if db.history then
			for i,v in ipairs(db.history) do
				self.objectHistory:push(v)
			end
		end
	end

  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED")
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED")
  -- self:RegisterEvent("MODIFIER_STATE_CHANGED")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  self:RegisterEvent("PLAYER_LOGOUT")

	self:ScheduleRepeatingTimer(function()
		self:ScanToBeCreate()
		self:ScanCreatedMesh()
	end,0.01)

	self:CreateInitMeshs()
end

function Core:CreateInitMeshs()
  local scene = AVR:GetTempScene(100)
	m=AVRLinkMesh:New("target")
	m:SetClassColor(true)
	scene:AddMesh(m,false,false)
end

function Core:PLAYER_LOGOUT()
	db.history = {}
	if objectHistory then
		for v,k,i in self.objectHistory:iterator() do
			db.history[i] = v
		end
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
  end -- chatCommands
end
function Core:GetGUIDInfo(guid)
	return AirjHack:GetGUIDInfo(guid)
end

function Core:FindUnitByGUID(guid)
	local units = self:GetUnitList()
	self.guid2unit = self.guid2unit or {}
	local guid2unit = self.guid2unit
	if guid2unit[guid] then
		local unit = guid2unit[guid]
		if UnitGUID(unit) == guid then
			return unit
		else
			guid2unit[guid] = nil
		end
	end
	local unitlist = self:GetUnitList()
	for i,u in pairs(unitlist) do
		local g = UnitGUID(u)
		if g then
			guid2unit[g] = u
			if guid == g then
				return u
			end
		end
	end
end

function Core:GetUnitList()
	if self.unitListCache then return self.unitListCache end
	local subUnit = {"","target","pet","pettarget"}
	local list = {}
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
	local exunits = {"player","target","targettarget","pet","pettarget","focus","focustarget","mouseover","mouseovertarget"}
	for i,u in pairs(exunits) do
		tinsert(list,u)
	end
	self.unitListCache=list
	return list
end
local hlti = 0
local hltc = {
	{1,0,0},
	{1,1,0},
	{0,1,0},
	{0,1,1},
	{0,0,1},
	{1,0,1},
	{1,1,1},
	{0,0,0},
}
function Core:AIRJ_HACK_OBJECT_CREATED(event,guid,type)
  if bit.band(type,0x2)==0 then
    local objectType,serverId,instanceId,zone,cid,spawn = self:GetGUIDInfo(guid)
		local history = {
			guid = guid,
			objectType = objectType,
			id = cid,
			t = GetTime(),
		}
		-- self:Print(guid)
    if objectType == "AreaTrigger" then
      local spellId = AirjHack:ObjectInt(guid,0x88)
      local radius = AirjHack:ObjectFloat(guid,0x94)
      local duration = AirjHack:ObjectInt(guid,0x78)
			local mine = true
			do
				local gs = {AirjHack:ObjectGUID4(UnitGUID("player"))}
				local oi = {}
				for i=1,4 do
					oi[i] = AirjHack:ObjectInt(guid,0x64+i*4)
				end
				for i=1,4 do
					if gs[i] ~= oi[i] then
						mine = false
						break
					end
				end
			end
      local data = self.register.onCreateAreaTriggers[spellId]
			if data then
				if not data.mine or data.mine and mine then
					local id = self:CreateCooldown({
						guid = guid,
						spellId = spellId,
						radius = radius,
						duration = duration and duration/1000,
						color = data.color,
						alpha = data.color and data.color[4],
						text = data.text,
					})
					local key = "Create - Cooldown - " .. guid
					self.registerCreateMeshs[key] = id
					if data.updateCallbacks then
						self:ScheduleTimer(function()
							local m = self.createdMeshs[id]
							if m then
								m.updateCallbacks = m.updateCallbacks or {}
								tinsert(m.updateCallbacks,data.updateCallbacks)
							end
						end,0.02)
					end
				end
			end
			history.spellId = spellId
			history.radius = radius
			history.duration = duration
			history.mine = mine
    end
    if objectType == "Creature" or objectType == "GameObject" or objectType == "Vehicle" then
			if self.register.onCreateBeams[cid] then
				local data = self.register.onCreateBeams[cid]
				local id = self:CreateBeam({
					toGUID = guid,
					width = data.width,
					length = data.length,
					color = data.color,
					alpha = data.color and data.color[4],
				})
				local key = "Create - Beam - " .. guid
				self.registerCreateMeshs[key] = id
			end
			if self.register.onCreateCooldowns[cid] then
				local data = self.register.onCreateCooldowns[cid]
				local id = self:CreateCooldown({
					guid = guid,
					spellId = data.spellId,
					radius = data.radius,
					duration = data.duration,
					color = data.color,
					alpha = data.color and data.color[4],
				})
				local key = "Create - Cooldown - " .. guid
				self.registerCreateMeshs[key] = id
			end
    end
		local position = {AirjHack:Position(guid)}
		history.position = position
		if objectHistory then
			self.objectHistory:push(history)
		end
		if 1 then
	    local objectType,serverId,instanceId,zone,cid,spawn = self:GetGUIDInfo(guid)
			if cid == 115947 then
				hlti = hlti + 1

				local id = self:CreateCooldown({
					guid = guid,
					radius = 2,
					duration = 3600,
					color = hltc[hlti%8],
					alpha = 0.2,
					text = "",
				})
				-- print(guid)
				local key = "Create - Cooldown - " .. guid
				self.registerCreateMeshs[key] = id
			end
		end
  end

	-- if self.debug then
  --   local objectType,serverId,instanceId,zone,cid,spawn = self:GetGUIDInfo(guid)
	-- 	local id = self:CreateCooldown({
	-- 		guid = guid,
	-- 		radius = 3,
	-- 		duration = 15,
	-- 		color = {0,1,0},
	-- 		alpha = 0.1,
	-- 		text = guid,
	-- 	})
	-- 	-- print(guid)
	-- 	local key = "Create - Cooldown - " .. guid
	-- 	self.registerCreateMeshs[key] = id
	-- end
end

function Core:AIRJ_HACK_OBJECT_DESTROYED(event,guid,type)
  if bit.band(type,0x2)==0 then
		self:RemoveCreatedMeshByKey("Create - Cooldown - " .. guid)
		self:RemoveCreatedMeshByKey("Create - Beam - " .. guid)
  end
end


function Core:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
  if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event =="SPELL_AURA_APPLIED_DOSE" then
		if event == "SPELL_AURA_REFRESH" or event =="SPELL_AURA_APPLIED_DOSE" then
			self:RemoveCreatedMeshByKey("Aura - Cooldown - " .. sourceGUID .. " - " .. destGUID .. " - " .. spellId)
		end
		local data = self.register.onAuraCooldowns[spellId]
		if data then
			local btype,count = ...
			local suffix
			if count then suffix = " - "..count end
			local unit = self:FindUnitByGUID(destGUID)
			local buffDuration
			if unit and not data.duration then
				local fcn = btype == "BUFF" and UnitBuff or UnitDebuff
				local name, rank, icon, count, dispelType, duration, expires = fcn(unit,spellName)
				if name then
					buffDuration = duration
					if buffDuration == 0 then
						buffDuration = 5
					end
				end
			end
			local id = self:CreateCooldown({
				guid = destGUID,
				spellId = spellId,
				radius = data.radius,
				duration = data.duration or buffDuration,
				color = data.color,
				alpha = data.color[4],
				suffix = suffix,
			})
			local key = "Aura - Cooldown - " .. sourceGUID .. " - " .. destGUID .. " - " .. spellId
			self.registerCreateMeshs[key] = id
		end
		data = self.register.onAuraBeams[spellId]
		if data then
			local id = self:CreateBeam({
				fromGUID = sourceGUID,
				toGUID = destGUID,
				width = data.width,
				length = data.length,
				color = data.color,
				alpha = data.color[4],
			})
			local key = "Aura - Beam - " .. sourceGUID .. " - " .. destGUID .. " - " .. spellId
			self.registerCreateMeshs[key] = id
		end

  end
  if event == "SPELL_AURA_REMOVED" or event == "SPELL_AURA_BROKEN" or event =="SPELL_AURA_BROKEN_SPELL" then
		self:RemoveCreatedMeshByKey("Aura - Cooldown - " .. sourceGUID .. " - " .. destGUID .. " - " .. spellId)
		self:RemoveCreatedMeshByKey("Aura - Beam - " .. sourceGUID .. " - " .. destGUID .. " - " .. spellId)
  end
  if event == "SPELL_CAST_START" then
    local data = self.register.onStartCastPolygon[spellId]
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

local idGernerator = 0
function Core:GererateId()
  idGernerator = idGernerator + 1
  return idGernerator
end
function Core:AddData(data)
  local now = GetTime()
  local id = self:GererateId()
  data.color = data.color or {1,0,0}
  data.alpha = data.alpha or 0.5
  data.start = data.start or now
  data.removes = data.removes or now + 5
  self.toBeCreateData[id] = data
  return id
end

local function o2t(value)
	return value * 0.2
end
function Core:ScanToBeCreate()
  local now = GetTime()
  local scene = AVR:GetTempScene(100)
  for id,data in pairs(self.toBeCreateData) do
		-- print(now,data.start,data.removes)
    if (now > data.start) and not (now > data.removes) then
      self.toBeCreateData[id] = nil
      local m
      local t = data.type
      if t == "Beam" then
				m=AVRLinkMesh:New(data.toGUID or data.toUnit,data.width,data.alpha)
				m.blank = 0
				m.showNumber = false
				m:SetFollowPlayer(nil)
				m:SetFollowUnit(data.fromGUID or data.fromUnit)
				m:SetClassColor(data.classColor)
				m:SetColor(unpack(data.color or {}))
				m.length = data.length
      elseif t == "Cooldown" then
        m=AVRUnitMesh:New(data.guid or data.unit, data.spellId, data.radius)
        m:SetTimer(data.duration)
				do -- colors
	        local r,g,b,a
	        if data.color then
	          r,g,b = unpack(data.color)
	        end
	        a = data.alpha
					if data.reverse then
		        m:SetColor2(r,g,b,a)
		        m:SetColor(o2t(r),o2t(g),o2t(b),a)
					else
		        m:SetColor(r,g,b,a)
		        m:SetColor2(o2t(r),o2t(g),o2t(b),a)
					end
				end
        m.text = data.text
        m.suffix = data.suffix
      end
			scene:AddMesh(m)
			if m then m.removes = data.removes end
      self.createdMeshs[id] = m
    end
  end
end

function Core:ScanCreatedMesh ()
  local now = GetTime()
  for id, m in pairs(self.createdMeshs) do
		if now > m.removes then
      m.visible=false
      m:Remove()
    elseif m.removed then
      self.createdMeshs[id] = nil
    end
  end
end

function Core:RemoveCreatedMeshByKey(key)
	local id = self.registerCreateMeshs[key]
	if id then
		local m = self.createdMeshs[id]
		if m then
			m.visible=false
			m:Remove()
		end
	end
end

do --Registers
  function Core:RegisterCreatureBeam(cid,data)
    self.register.onCreateBeams[cid]=data
  end
  function Core:RegisterCreatureCooldown(cid,data)
    self.register.onCreateCooldowns[cid]=data
  end

  function Core:RegisterCreateAreaTrigger(spellId,data)
    self.register.onCreateAreaTriggers[spellId]=data
  end

  function Core:RegisterAuraCooldown(spellId,data)
    self.register.onAuraCooldowns[spellId]=data
  end

  function Core:RegisterStartCastPolygon(spellId,data)
    self.register.onStartCastPolygon[spellId]=data
  end

  function Core:RegisterAuraBeam(spellId,data)
    self.register.onAuraBeams[spellId]=data
  end
end
