local M = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyMove", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local start = {MoveForwardStart,MoveBackwardStart,StrafeLeftStart,StrafeRightStart,TurnLeftStart,TurnRightStart,JumpOrAscendStart ,SitStandOrDescendStart,PitchUpStart,PitchDownStart}
local stop  = {MoveForwardStop ,MoveBackwardStop ,StrafeLeftStop ,StrafeRightStop ,TurnLeftStop ,TurnRightStop ,AscendStop ,DescendStop ,PitchUpStop ,PitchDownStop }
local startName={"MoveForwardStart","MoveBackwardStart","StrafeLeftStart","StrafeRightStart","TurnLeftStart","TurnRightStart","JumpOrAscendStart","SitStandOrDescendStart","PitchUpStart","PitchDownStart"}
local stopName={"MoveForwardStop","MoveBackwardStop","StrafeLeftStop","StrafeRightStop","TurnLeftStop","TurnRightStop","AscendStop","DescendStop","PitchUpStop","PitchDownStop"}
AirjMove = M
local stopAllMoves = {0,0,0,0,0,0,0,0,0,0}

function M:OnInitialize()

	self.goto = {}

	self:RegisterChatCommand("aakm", function(str,...)
		local args = {strsplit(" ",str)}
		if args[1] and UnitExists(args[1]) then
			self:KeepFollowUnit(args[1])
			if args[2] then
				self:KeepFacingUnit(args[2])
			end
		else
			self:KeepGoToStop()
		end
	end)
end

local hardMoving = {0,0,0,0,0,0,0,0,0,0}

function M:OnEnable()
	self.moveTimer = self:ScheduleRepeatingTimer(self.MoveTimer,0.01,self)
	self:ScheduleRepeatingTimer(self.CheckGiftTrigged,0.01,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectCreated,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectDestroyed,self)
	for i = 1,10 do
		hooksecurefunc(startName[i],function(...)
			hardMoving[i] = 1
			-- self:Print(startName[i])
		end)
		hooksecurefunc(stopName[i],function(...)
			hardMoving[i] = 0
			-- self:Print(stopName[i])
		end)
	end
end

function M:MoveTimer()
	local moves = {}
	local targetAngle
	local targetDistance
	if self:IsHardMoving() then
		self:MoveAsHard()
		self:ClearGoToTarget()
		self:ClearMoveFacing()
		return
	end
	do
		local type,data,minDistance = self.goto.targetType,self.goto.targetData,self.goto.targetMinDistance
		if type then
			local x, y, z = self:GetPositionForType(type,data)
			if x then
				minDistance = minDistance or 0.2
				local distance = self:GetDistance(x,y,z)
				targetDistance = distance
				targetAngle = self:GetAngle(x,y,z)
				if (distance>minDistance) then
					moves = self:GetGoToMoves(x,y,z)
				else
					moves = {0,0,0,0,0,0,0,0,0,0}
					if not self.goto.targetFollow then
						self:ClearGoToTarget()
					end
				end
			else
				moves = {0,0,0,0,0,0,0,0,0,0}
			end
		end
	end

	do
		local type,data,minAngle = self.goto.facingType,self.goto.facingData,self.goto.facingMinAngle
		if type then
			local x,y,z = self:GetPositionForType(type,data)
			if x then
				minAngle = minAngle or 90
				local distance = self:GetDistance(x,y,z)
				local angle = self:GetAngle(x,y,z)
				if (GetUnitSpeed("player")==0) then
					if distance<1 then
						moves[5] = moves[5] or 0
						moves[6] = moves[6] or 0
					elseif abs(angle)<45 then
						moves[5] = 0
						moves[6] = 0
					elseif angle>0 then
						moves[5] = 1
						moves[6] = 0
					else
						moves[5] = 0
						moves[6] = 1
					end
				else
					local turnFacing
					if targetAngle then
						if abs(targetAngle-angle) > 185 then
							if targetDistance >5 then
								turnFacing = true
								if (abs(targetAngle)<120) then
									if GetUnitSpeed("player")>=3 then
										JumpOrAscendStart()
									end
								end
							end
						end
						if abs(targetAngle-angle) < 90+45/2 then

						end
					end
					if not turnFacing and (abs(angle)<minAngle-4 or distance<1) then
						moves[5] = moves[5] or 0
						moves[6] = moves[6] or 0
					elseif not turnFacing and abs(angle)<minAngle then
						if angle>0 then
							moves[6] = 0
						else
							moves[5] = 0
						end
					elseif angle>0 then
						moves[5] = 1
						moves[6] = 0
					else
						moves[5] = 0
						moves[6] = 1
					end
				end
			end
		end
	end
	self:DoMove(moves)
end

function M:DoMove (moves)
	for i=1,8 do
		local n = moves[i]
		if n then
			if n ==1 then
				start[i]()
			else
				stop[i]()
			end
		end
	end
end

function M:GetPositionForType(type,data)
	if (type == "point") then
		return unpack(data)
	elseif (type == "unit") then
		return AirjHack:Position(data)
	elseif (type == "guid") then
		return AirjHack:Position(data)
	end
end

function M:SetMoveTarget (type,data,follow,minDistance)
	self.goto.targetType = type
	self.goto.targetData = data
	self.goto.targetFollow= follow
	if (minDistance and minDistance<0.1) then minDistance = 0.1 end
	self.goto.targetMinDistance = minDistance
end
function M:ClearGoToTarget ()
	self:SetMoveTarget()
end

function M:SetMoveFacing (type,data,follow,minAngle)
	self.goto.facingType = type
	self.goto.facingData = data
	self.goto.facingFollow= follow
	if (minAngle and minAngle<0.1) then minAngle = 0.1 end
	self.goto.facingMinAngle = minAngle
end

function M:ClearMoveFacing ()
	self:SetMoveFacing()
end

function M:KeepGoToUnit(unit,...)
	local x, y, z = AirjHack:Position(unit)
	if x then
		self:SetMoveTarget("point",{x,y,z},nil,...)
	end
end

function M:KeepFollowUnit(unit,...)
	self:SetMoveTarget("unit",unit,true,...)
end

function M:KeepFollowGUID(guid,...)
	--local guid = UnitGUID(unit)
	if guid and guid~=UnitGUID("player") then
		self:SetMoveTarget("guid",guid,true,...)
	end
end
function M:KeepFacingUnit(unit,...)
	self:SetMoveFacing("unit",unit,true,...)
end
function M:KeepFacingGUID(guid,...)
	--local guid = UnitGUID(unit)
	if guid and guid~=UnitGUID("player") then
		self:SetMoveFacing("guid",guid,true,...)
	end
end

function M:KeepGoToStop()
	self:ClearGoToTarget()
	self:ClearMoveFacing()
	self:StopMoving()
end

function M:StopMoving()
	self:DoMove({0,0,0,0,0,0,0,0,0,0})
end

-- function M:GoToUnit (unit, ...)
-- 	local x, y, z = AirjHack:Position(unit)
-- 	if x then
-- 		local moves = self:GetGoToMoves(x,y,z)
-- 		self.DoMove(moves)
-- 	end
-- end

function M:GetPlayPosition()
	return AirjHack:Position("player")
end

function M:GetDistance (x,y,z)
	local px, py, pz = self:GetPlayPosition()
	local distance = sqrt((x-px)*(x-px) + (y-py)*(y-py) + (z-pz)*(z-pz))
	return distance
end

function M:GetAngle(x,y,z)
	local px, py, pz, pf = self:GetPlayPosition()
	local facing = pf*180/math.pi
	local angle = atan2(y-py, x-px)
  local theta = atan2(z-pz, sqrt((x-px)*(x-px) + (y-py)*(y-py)))
	angle = angle - 90 - facing + 360
	if (angle > 180) then angle = angle - 360 end
	return angle,theta
end

function M:GetGoToMoves (x, y, z)
	local distance = self:GetDistance(x,y,z)
	local angle = self:GetAngle(x,y,z)
	local dir
	local absAngle = abs(angle)
	if absAngle>157.5 then
		dir = {0,1,0,0}
	elseif absAngle>112.5 then
		dir = {0,1,1,0}
	-- elseif absAngle>112.5 then
	-- 	dir = {0,0,1,0}
	elseif absAngle>67.5 then
		dir = {0,0,1,0}
	elseif absAngle>22.5 then
		dir = {1,0,1,0}
	else
		dir = {1,0,0,0}
	end
	if angle <0 then
		dir[4] = dir[3]
		dir[3] = 0
	end

	local minAngle = 1
	if distance<40 then
		minAngle = minAngle + (40-distance)/20
	end
	local noTurnAngle= {-90,-45,0,45,90}
	local noTurn = false
	local min = 90
	local to = 0
	for i,v in ipairs(noTurnAngle) do
		if abs(angle-v)<minAngle then
			noTurn = true
		end
		if abs(angle-v) < min then
			min = abs(angle-v)
			to = v
		end
	end
	if noTurn then
		dir[5] = 0
		dir[6] = 0
	elseif (angle>to) then
		dir[5] = 1
		dir[6] = 0
	else
		dir[5] = 0
		dir[6] = 1
	end

	return dir
end

function M:GetGUIDInfo(guid)
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

local gifts = {}

function M:CheckGiftTrigged()
	local px,py,pz,pf = AirjHack:Position("player")
	for guid,position in pairs(gifts) do
		local x,y,z = unpack(position)
		local d = math.sqrt((px-x)*(px-x)+(py-y)*(py-y)+(pz-z)*(pz-z))
		if d<1 then
			gifts[guid] = nil
		end
	end
end

function M:OnObjectCreated(event,guid,type)
  if bit.band(type,0x2)==0 then
    local objectType,serverId,instanceId,zone,id,spawn = self:GetGUIDInfo(guid)

    if objectType == "AreaTrigger" and (id == 124503 or id == 124506) then
			local x,y,z = AirjHack:Position(guid)
			gifts[guid] = {x,y,z}
    end
  end
end
function M:OnObjectDestroyed(event,guid)
	gifts[guid] = nil
end

function M:IsHardMoving()
	for i=1,4 do
		if hardMoving[i] == 1 then
			return true
		end
	end
	return false
end

function M:MoveAsHard()
	for i=1,4 do
		M:Move(i,hardMoving[i])
	end
end

function M:Move(index,sos)
	if sos == 1 then
		start[index]()
	else
		stop[index]()
	end
end

local gifting
function M:GoToGift()
	local distance = 5
	local px,py,pz,pf = AirjHack:Position("player")
	local tx,ty,tz
	for guid,position in pairs(gifts) do
		local x,y,z = unpack(position)
		local d = math.sqrt((px-x)*(px-x)+(py-y)*(py-y)+(pz-z)*(pz-z))
		if d<distance then
			tx,ty,tz = x,y,z
			distance = d
		end
	end
	if tx and not gifting then
		if self:IsHardMoving() then
			self:MoveAsHard()
			gifting = nil
			return
		end
		gifting = true
		local dirs = M:GetGoToMoves (tx,ty,tz)
		for i=1,4 do
			self:Move(i,dirs[i])
		end
		local _,speed = GetUnitSpeed("player")
		if dirs[2] == 1 then
			speed = 4.5
		end
		local time = (distance-0.5)/speed
		time = max(0.05,time)
		self:ScheduleTimer(function()
			if self:IsHardMoving() then
				self:MoveAsHard()
				gifting = nil
				return
			end
			local backdirs = M:GetGoToMoves(px,py,pz)
			for i=1,4 do
				self:Move(i,backdirs[i])
			end
			local _,speed = GetUnitSpeed("player")
			if backdirs[2] == 1 then
				speed = 4.5
			end
			local time = (distance-0.5)/speed
			time = max(0.05,time)
			self:ScheduleTimer(function()
				if self:IsHardMoving() then
					self:MoveAsHard()
					gifting = nil
					return
				end
				for i=1,4 do
					self:Move(i,0)
				end
				gifting = nil
			end,time)
		end,time)
	end
end
