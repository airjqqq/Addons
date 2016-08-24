local M = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyMove", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local start = {MoveForwardStart,MoveBackwardStart,StrafeLeftStart,StrafeRightStart,TurnLeftStart,TurnRightStart,JumpOrAscendStart ,SitStandOrDescendStart,PitchUpStart,PitchDownStart}
local stop  = {MoveForwardStop ,MoveBackwardStop ,StrafeLeftStop ,StrafeRightStop ,TurnLeftStop ,TurnRightStop ,AscendStop ,DescendStop ,PitchUpStop ,PitchDownStop }

local stopAllMoves = {0,0,0,0,0,0,0,0,0,0}

function M:OnInitialize()

	self.goto = {}
	self.moveTimer = self:ScheduleRepeatingTimer(function()
		self:MoveTimer()
	end,0.01)

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

function M:MoveTimer()
	local moves = {}
	local targetAngle
	local targetDistance
	do
		local type,data,minDistance = self.goto.targetType,self.goto.targetData,self.goto.targetMinDistance
		if type then
			local x, y, z = self:GetPositionForType(type,data)
			if x then
				minDistance = minDistance or 0.2
				local distance = self:GetDistance(x,y)
				targetDistance = distance
				targetAngle = self:GetAngle(x,y)
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
			local x,y = self:GetPositionForType(type,data)
			if x then
				minAngle = minAngle or 90
				local distance = self:GetDistance(x,y)
				local angle = self:GetAngle(x,y)
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
	angle = angle - facing + 360
	if (angle > 180) then angle = angle - 360 end
	return angle,theta
end

function M:GetGoToMoves (x, y, z)
	local distance = self:GetDistance(x,y)
	local angle = self:GetAngle(x,y)
	local dir
	local absAngle = abs(angle)
	if absAngle>157.5 then
		dir = {0,1,0,0}
	elseif absAngle>135 then
		dir = {0,1,1,0}
	elseif absAngle>112.5 then
		dir = {0,0,1,0}
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