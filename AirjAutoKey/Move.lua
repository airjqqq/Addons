local M = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyMove", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
local start = {MoveForwardStart,MoveBackwardStart,StrafeLeftStart,StrafeRightStart,TurnLeftStart,TurnRightStart,JumpOrAscendStart ,SitStandOrDescendStart,PitchUpStart,PitchDownStart}
local stop  = {MoveForwardStop ,MoveBackwardStop ,StrafeLeftStop ,StrafeRightStop ,TurnLeftStop ,TurnRightStop ,AscendStop ,DescendStop ,PitchUpStop ,PitchDownStop }
local startName={"MoveForwardStart","MoveBackwardStart","StrafeLeftStart","StrafeRightStart","TurnLeftStart","TurnRightStart","JumpOrAscendStart","SitStandOrDescendStart","PitchUpStart","PitchDownStart"}
local stopName={"MoveForwardStop","MoveBackwardStop","StrafeLeftStop","StrafeRightStop","TurnLeftStop","TurnRightStop","AscendStop","DescendStop","PitchUpStop","PitchDownStop"}
AirjMove = M
local stopAllMoves = {0,0,0,0,0,0,0,0,0,0}

function M:OnInitialize()
	self.ignores = setmetatable({},{__index = function(t,k) t[k] = {} return t[k] end})
	self.goto = {}

	self:RegisterChatCommand("aakm", function(str,...)
		self.isCruise = nil
		local args = {strsplit(" ",str)}
		if args[1] and UnitExists(args[1]) then
			local md
			if args[3] then
				md = tonumber(args[3])
			end
			self:KeepFollowUnit(args[1],md,md and true)
			if args[2] then
				self:KeepFacingUnit(args[2])
			end
		else
			self:KeepGoToStop()
		end
	end)
	self:RegisterChatCommand("aakp", function(str,...)
		local args = {strsplit(" ",str)}
		if args[1] and args[2] then
			self.isCruise = nil
			AirjMove:SetMoveTarget("point",{args[1],args[2],args[3] or -1000000},nil,1)
		end
	end)
	self:RegisterChatCommand("aakc", function(str,...)
		local args = {strsplit(" ",str)}
		if args[1] and args[1] ~= "" then
			self.cruiseName = args[1]
			self.isCruise = true
		else
			self.isCruise = false
		end
	end)
	self:RegisterChatCommand("aakn", function(str,...)
		local args = {strsplit(" ",str)}
		if args[1] and args[1] ~= "" then
			local uid = tonumber(args[1])
			if uid then
				AirjMove:MoveToNearest({[uid]=1},not args[2],self.ignores[uid])
			end
		else
			self.isCruise = false
		end
	end)

	self:RegisterChatCommand("aakignore", function(str,...)
		local args = {strsplit(" ",str)}
		if args[1] and args[1] ~= "" then
			local uid = tonumber(args[1])
			if uid then
				local guid = self.ignores[uid].guid
				if guid then
					self.ignores[uid][guid] = true
				end
			end
		else
			self.isCruise = false
		end
	end)
	self:RegisterChatCommand("aakt", function(str,...)
		local args = {strsplit(" ",str)}
		if args[1] and args[1] ~= "" then
			self.cruiseName = args[1]
			local data = self:GetCruiseDate()
			if not data then
				M:GetDB()[self.cruiseName] = {}
			end
		end
		self:DrawCruiseData()
	end)
	self:RegisterChatCommand("aakmap", function(str,...)
		if WorldMapDetailFrame:IsMouseOver() then
			local z = select(3,self:GetPlayPosition())
			local l,b,w,h = WorldMapDetailFrame:GetRect()
			local s = WorldMapDetailFrame:GetScale()*UIParent:GetScale()
			local cx,cy = GetCursorPosition()
			cx,cy = cx/s,cy/s
			local x,y = (cx-l)/w, (cy-b)/h
			-- print(x,y)
	    local mapId = GetCurrentMapAreaID()
	    local _,_,_,l,r,t,b = GetAreaMapInfo(mapId)
	    l = -l
	    r = -r
	    local px = l+(r-l)*x
	    local py = b+(t-b)*y
			local pitch = AirjHack:GetPitch()
			local d = self:GetDistanceFromPlayer(px,py,z)
			z = z + d*math.tan(pitch)
	    AirjMove:MoveTo({px,py,z})
		end
	end)
	self:RegisterChatCommand("aakmu", function(str,...)
		local args = {strsplit(" ",str)}
		if args[1] and args[1] ~= "" then
			local unit = args[1]
			local x,y = GetPlayerMapPosition(unit)
			-- print(x,y)
	    local mapId = GetCurrentMapAreaID()
	    local _,_,_,l,r,t,b = GetAreaMapInfo(mapId)
	    l = -l
	    r = -r
	    local px = l+(r-l)*x
	    local py = t-(t-b)*y
			local z = select(3,self:GetPlayPosition())
	    AirjMove:MoveTo({px,py,z})
		end
	end)
	self:RegisterChatCommand("aakw", function(str,...)
		local args = {strsplit(" ",str)}
		if args[1] then
			local data = self:GetCruiseDate()
			if args[1] == "a" then
				local i = tonumber(args[2] or (#data+1))
				tinsert(data,i,{self:GetPlayPosition()})
			elseif args[1] == "r" then
				local i = tonumber(args[2] or #data)
				tremove(data,i)
			elseif args[1] == "rall" then
				while data[1] do
					tremove(data,1)
				end
			elseif args[1] == "x" then
				local i = tonumber(args[2] or #data)
				local v = tonumber(args[3] or 10)
				data[i][1] = data[i][1] + v
			elseif args[1] == "y" then
				local i = tonumber(args[2] or #data)
				local v = tonumber(args[3] or 10)
				data[i][2] = data[i][2] + v
			elseif args[1] == "z" then
				local i = tonumber(args[2] or #data)
				local v = tonumber(args[3] or 10)
				data[i][3] = data[i][3] + v
			elseif args[1] == "s" then
				local i = tonumber(args[2] or #data)
				local v = tonumber(args[3] or 1)
				data[i].stop = v == 1 or nil
			elseif args[1] == "w" then
				local i = tonumber(args[2] or #data)
				local v = tonumber(args[3] or 5)
				data[i].wait = v > 0 and v or nil
				data[i].stop = v == 1 or nil
			elseif args[1] == "noloop" then
				local v = tonumber(args[2] or 1)
				data.noloop = v > 0 and v or nil
			elseif args[1] == "am" then
				if WorldMapDetailFrame:IsMouseOver() then
					local z = select(3,self:GetPlayPosition())
					local l,b,w,h = WorldMapDetailFrame:GetRect()
					local s = WorldMapDetailFrame:GetScale()*UIParent:GetScale()
					local cx,cy = GetCursorPosition()
					cx,cy = cx/s,cy/s
					local x,y = (cx-l)/w, (cy-b)/h
					-- print(x,y)
			    local mapId = GetCurrentMapAreaID()
			    local _,_,_,l,r,t,b = GetAreaMapInfo(mapId)
			    l = -l
			    r = -r
			    local px = l+(r-l)*x
			    local py = b+(t-b)*y
					local i = tonumber(args[2] or (#data+1))
					tinsert(data,i,{px,py,z})
				end
			end
		end
		self:DrawCruiseData()
	end)
end

local hardMoving = {0,0,0,0,0,0,0,0,0,0}

function M:OnEnable()
	self.moveTimer = self:ScheduleRepeatingTimer(self.MoveTimer,0.01,self)
	self.cruiseTimer = self:ScheduleRepeatingTimer(self.CruiseTimer,0.01,self)

	self:ScheduleRepeatingTimer(self.CheckGiftTrigged,0.01,self)
	self:ScheduleRepeatingTimer(self.CheckATTrigged,0.01,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_CREATED",self.OnObjectCreated,self)
  self:RegisterMessage("AIRJ_HACK_OBJECT_DESTROYED",self.OnObjectDestroyed,self)
	for i = 1,10 do
		hooksecurefunc(startName[i],function(...)
			hardMoving[i] = 1
			if i==7 then
				self:ScheduleTimer(function()
					if IsFalling() then
						hardMoving[i] = 0
					end
				end,0.1)
			end
			-- self:Print(startName[i])
		end)
		hooksecurefunc(stopName[i],function(...)
			hardMoving[i] = 0
			-- self:Print(stopName[i])
		end)
	end

	self:HookScript(WorldFrame,"OnMouseDown",function(widget,button) self:WorldFrameButton(button,1) end)
	self:HookScript(WorldFrame,"OnMouseUp",function(widget,button) self:WorldFrameButton(button,0) end)
end

function M:WorldFrameButton(button,state)
	if button=="LeftButton" then self.leftDown=state
	elseif button=="RightButton" then self.rightDown=state end
end

local history = {}
local hindex = 0
local movinglast = 0
local jumped
local lefted
local stuckedTimes = 0
local lastStuckedPoint
local historySize = 10000
local function saveHistory()
	local px,py,pz,pf = M:GetPlayPosition()
	local speed = GetUnitSpeed("player")
	local lastData = history[hindex]
	hindex = hindex + 1
	if hindex > historySize then
		hindex = 1
	end
	history[hindex] = {px,py,pz,GetTime()}
end

local function getHistory(offset)
	offset = offset or 0
	local i = hindex - offset
	if i <= 0 then i = i + historySize end
	return unpack(history[i] or {})
end

function M:MoveTimer()
	if not AirjHack:HasHacked() then
		return
	end
	saveHistory()
	self.moveAngle = nil
	self.targetDistance = nil
	self.targetAngle = nil
	if self.gifting then
		return
	end
	if self:IsHardMoving() then
		if self.goto.targetType or self.goto.facingType or self.goto.templateTime then
			self:MoveAsHard()
			self:ClearGoToTarget()
			self:ClearMoveFacing()
			self:ClearGoToTemplate()
		end
		movinglast = 0
		return
	end

	if UnitIsDead("player") then
		self:MoveAsHard()
		movinglast = 0
		return
	end
	-- if jumped and GetTime() - jumped < 1 then
	-- 	self:StopMoving()
	-- 	return
	-- end
	local targetAngle,targetDistance,facingAngle,facingDistance,targetDistanceXY,targetDistanceZ,targetSize,targetPitch
	local playFacing = GetPlayerFacing()
	local speed = select(IsFlying() and 3 or IsSwimming() and 4 or 2 ,GetUnitSpeed("player"))
	do
		local type,data,minDistance,is
		if self.goto.templateTime and self.goto.templateTime>GetTime() then
			for i,v in ipairs(self.goto.targetTimeT) do
				if GetTime()< v+self.goto.templateTime then
					-- print(i)
					type,data,minDistance = self.goto.targetTypeT[i],self.goto.targetDataT[i],self.goto.targetMinDistanceT and self.goto.targetMinDistanceT[i]
					break
				end
			end
		else

		end
		if not type then
			type,data,minDistance,is = self.goto.targetType,self.goto.targetData,self.goto.targetMinDistance,self.goto.incluedTargetSize
			if minDistance then
				minDistance = max(0.02*speed,minDistance)
			end
		end
		if type then
			local x, y, z, f, s = self:GetPositionForType(type,data)
			if x and y and z then

				local offset = AirjAutoKey:GetParam("fof")
				if offset then
					local ox,oy = strsplit(":",offset)
					-- print(offset,ox,oy)
					if ox and oy then
						ox,oy = tonumber(ox), tonumber(oy)
						if ox and oy then
							local a = f
							local sin,cos = math.sin,math.cos
							x = x + ox*cos(a) - oy*sin(a)
							y = y + oy*cos(a) + ox*sin(a)
						end
					end
				end
				local px, py, pz = self:GetPlayPosition()
				targetDistanceXY = self:GetDistanceFromPlayer(x,y,pz)
				targetDistanceZ = z - pz
				targetDistance = self:GetDistanceFromPlayer(x,y,z)
				targetAngle = self:GetAngle(x,y,z)
				targetPitch = math.asin(targetDistanceZ/targetDistance)
				self.targetDistance = targetDistanceXY
				self.targetAngle = targetAngle
				targetSize = s
			end
		end
	end
	do
		local type,data,minAngle = self.goto.facingType,self.goto.facingData,self.goto.facingMinAngle
		if type == "facing" then
			facingDistance = 40
			facingAngle = self:GetAngleFacing(data)
		elseif type then
			local x,y,z = self:GetPositionForType(type,data)
			if x then
				facingDistance = self:GetDistanceFromPlayer(x,y,z)
				facingAngle = self:GetAngle(x,y,z)
			end
		end
	end
	local moves = {0,0,0,0,0,0,0,0,0,0}
	local turnAngle = 0
	local stop
	local moveDistanceXY,moveDistance
	if targetDistanceXY then
		moveDistanceXY = targetDistanceXY - (minDistance or 0.2) - (self.goto.incluedTargetSize and targetSize or 0)
		moveDistance = targetDistance - (minDistance or 0.2) - (self.goto.incluedTargetSize and targetSize or 0)
	else
		moveDistanceXY = 0
		moveDistance = 0
	end
	local moveAngle
	local castDontMoveRange = AirjAutoKey:GetParam("cdm") and tonumber(AirjAutoKey:GetParam("cdm")) or 1
	-- local iscasting = UnitChannelInfo("player") or (UnitCastingInfo("player") and (select(6,UnitCastingInfo("player"))/1000 - 0.05 > GetTime()))
	local iscasting = UnitChannelInfo("player") or UnitCastingInfo("player")
	local castRemain = AirjAutoKey:GetMoveCastBuffRemain() or 0
	if not targetDistance or moveDistanceXY<0 or (moveDistanceXY < castDontMoveRange and iscasting and castRemain<0.2) or
	(moveDistanceXY < castDontMoveRange -1 and (AirjAutoKey.needbarcast and GetTime() - AirjAutoKey.needbarcast < 1) and castRemain<0.2) or
	(moveDistanceXY < castDontMoveRange -1 and (AirjAutoKey.maybarcast and GetTime() - AirjAutoKey.maybarcast < 1) and castRemain<0.2)
	then
		stop = true
		if not facingAngle then
		elseif facingAngle < 2 then
			turnAngle = facingAngle or 0
		else
			turnAngle = facingAngle + 1
			moves[6] = 1
		end
		if self.goto.targetStopAfterReach then
			self:SetMoveTarget()
		end
	else
		if facingAngle and facingDistance > 2.5 and not IsMounted() then
			local difAngle = abs(targetAngle-facingAngle)
			local pon = targetAngle > facingAngle and -1 or 1
			if difAngle > 180 then difAngle = 360 - difAngle end
			local toAngle, style
			if difAngle < 30 then
				style = 1
			elseif difAngle < 60 then
				if abs(targetAngle) < 22.5 then
					style = 1
				else
					style = 2
				end
			elseif difAngle < 90 then
				style = 2
			elseif difAngle < 120 then
				if abs(targetAngle) < 67.5 then
					style = 2
				else
					style = 3
				end
			else
				style = 3
			end
			if style == 1 then
				toAngle = targetAngle
				moves[1] = 1
				moveAngle = 0
			elseif style == 2 then
				toAngle = targetAngle + 45 * pon
				moves[1] = 1
				if targetAngle > facingAngle then
					moves[3] = 1
					moveAngle = -45
				else
					moves[4] = 1
					moveAngle = 45
				end
			elseif style == 3 then
				toAngle = targetAngle + 90 * pon
				if targetAngle > facingAngle then
					moves[3] = 1
					moveAngle = -90
				else
					moves[4] = 1
					moveAngle = 90
				end
			end
			turnAngle = toAngle
		else
			turnAngle =  targetAngle or 0
			moves[1] = 1
			moveAngle = 0
		end
	end
	if (IsSwimming() or IsFlying()) then
		if targetPitch and (moveDistanceXY>1 or targetDistanceZ>1 or targetDistanceZ < -1) then
			local pitch = AirjHack:GetPitch()
				-- print(targetPitch,pitch)
			if targetPitch - pitch> 0.05 then
				moves[9] = 1
				-- print("UP")
			elseif targetPitch - pitch < -0.05 then
				moves[10] = 1
				-- print("DOWN")
			end
			if moveDistance > 0 then
				moves[1] = 1
				stop = false
			end
			-- if pitch - targetPitch > 0.5 then
			-- 	moves[7] = 1
			-- elseif pitch - targetPitch < -0.5 then
			-- 	moves[8] = 1
			-- end
		end
		-- if targetDistanceZ then
		-- 	if targetDistanceZ > 1 then
		-- 		moves[7] = 1
		-- 	elseif targetDistanceZ < -1 then
		-- 		moves[8] = 1
		-- 	end
		-- end
	end
	-- print(moveDistanceXY,targetDistanceZ)
	if targetDistanceXY and moveDistanceXY<5 and targetDistanceZ>1 and (self.goto.targetType == "point" or moveDistanceXY>1) or targetDistanceZ and targetDistanceZ>10 then
		moves[7] = 1
	end
	if stop  and moveDistance < 15 then
		movinglast = 0
	else
		movinglast = movinglast + 1
	end
	local stucked = self:CheckStuckedTime(1)
	if stucked > 1 and (stucked-2)%3 <0.05 then
		moves[7] = 1
		-- jumped = GetTime()
		print("jump")
	end
	-- local speed = GetUnitSpeed("player")
	stucked = self:CheckStuckedTime(5)
	local minTime = 5/speed
	if targetDistanceXY and stucked >(IsFlying() and 3 or 0.5) + minTime and not (self.goto.templateTime and self.goto.templateTime + 1>GetTime()) then

		if not (self.goto.templateTime and self.goto.templateTime+5+stuckedTimes>GetTime()) then
			stuckedTimes = 0
		end
		if lastStuckedPoint then
			local x,y,z = unpack(lastStuckedPoint)
			local d = self:GetDistanceFromPlayer(x,y,z)
			local a = self:GetAngle(x,y,z)
			if d>10 then
				if a >0 then
					stuckedTimes = 0
				else
					stuckedTimes = 1
				end
			end
		end
		local sc = min(stuckedTimes*0.5 + 0.5,4)
		if stucked > sc + minTime then
			stuckedTimes = stuckedTimes + 1
			local time = math.floor(stuckedTimes/2+0.5)
			self.goto.targetTypeT = {"point","point","point"}

			local direction = stuckedTimes%2 == 0 and 1 or -1
			self.goto.targetDataT = {
				{self:GetOffsetPoint(0,-2,0,self.targetAngle)},
				{self:GetOffsetPoint(direction*time*5,-2,0,self.targetAngle)},
				{self:GetOffsetPoint(direction*time*5,time*2+1,0,self.targetAngle)}
			}
			local duration = 0
			local durations = {0.4,time,time*0.4+0.6}
			for i,v in ipairs(durations) do
				duration = duration + v
			end
			self.goto.targetTimeT = {}
			local started = 0
			for i,v in ipairs(durations) do
				self.goto.targetTimeT[i] = -duration + v + started
				started = started + v
			end
			self.goto.templateTime = GetTime()+duration
			lastStuckedPoint = {self:GetPlayPosition()}
			if AVR then
				local scene = AVR:GetTempScene(200)
				for i,v in ipairs(self.goto.targetDataT) do
					local m=AVRUnitMesh:New()
					m:SetFollowUnit(false)
					m:SetFollowRotation(false)
					m:SetRadius(1.5)
					m:SetMeshTranslate(unpack(v))
					m:SetText("stuck "..i)
					m:SetTimer(duration + self.goto.targetTimeT[i])
			    scene:AddMesh(m,false,false)
				end
			end
			-- print(stuckedTimes,floor(direction*time*20))
		end
	end
	-- if stucked > 2 then
	-- 	if lefted then
	-- 		moves[3] = 1
	-- 	else
	-- 		moves[4] = 1
	-- 	end
	-- end

	local nt
	if stop then
		nt = abs(turnAngle) > 30
	elseif targetDistanceXY then
		nt = abs(turnAngle) > max((15 - targetDistanceXY)*1,5)
	else
		nt = abs(turnAngle) > 15
	end
	if nt then
		if turnAngle > 0 then
			turnAngle = turnAngle
			self:Move(5,0)
			moves[5] = 1
		else
			turnAngle= turnAngle
			self:Move(6,0)
			moves[6] = 1
		end
		local facing = playFacing + turnAngle/180*math.pi
		facing = (facing)%(math.pi*2)
		AirjHack:SetFacing(facing)
	else
		moves[5] = 0
		moves[6] = 0
	end
	self:DoMove(moves)
end

function M:NeedBarCast()

end

function M:CheckStuckedTime2(d)
	d = d or 1
	for i = 10,movinglast,10 do
		local x,y,z = getHistory(i)
		if not x then
			break
		end
		local distance = self:GetDistanceFromPlayer(x,y,z,not IsFlying() and not IsSwimming())
		if distance>d then
			return i/100
		end
	end
	return movinglast/100
end

function M:CheckStuckedTime(d)
	d = d or 1
	for i = 10,movinglast,10 do
		local x,y,z = getHistory(i)
		if not x then
			break
		end
		local distance = self:GetDistanceFromPlayer(x,y,z,not IsFlying() and not IsSwimming())
		if distance>d then
			return i/100
		end
	end
	return movinglast/100
end

function M:DoMove (moves)
	for i=1,10 do
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
		local guid = UnitGUID(data)
		return AirjHack:Position(guid)
	elseif (type == "guid") then
		return AirjHack:Position(data)
	end
end

function M:ClearGoToTemplate()
	self.goto.templateTime = GetTime()
end

function M:SetMoveTarget (type,data,sar,minDistance,incluedTargetSize)
	self.goto.targetType = type
	self.goto.targetData = data
	self.goto.targetStopAfterReach= sar
	if (minDistance and minDistance<0.1) then minDistance = 0.1 end
	self.goto.targetMinDistance = minDistance
	self.goto.incluedTargetSize = incluedTargetSize
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
	local x, y, z = AirjHack:Position(UnitGUID(unit))
	if x then
		self:SetMoveTarget("point",{x,y,z},nil,...)
	end
end

function M:KeepFollowUnit(unit,...)
	self:SetMoveTarget("unit",unit,nil,...)
end

function M:KeepFollowGUID(guid,...)
	--local guid = UnitGUID(unit)
	if guid and guid~=UnitGUID("player") then
		self:SetMoveTarget("guid",guid,nil,...)
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
	self:MoveAsHard()
end

function M:StopMoving()
	self:DoMove({0,0,0,0,0,0,0,0,0,0})
end

function M:MoveToNearest(uid,parachute,ignore)
  if not AirjHack:HasHacked() then return end
	local guids = AirjHack:GetObjects()
	local targetguid=UnitGUID("target")
	local playerGUID = UnitGUID("player")
	local minDistance,minDistanceGUID,minDistancePoint,minDistanceUID
	for guid,t in pairs(guids) do
		if not ignore or not ignore[guid] then
			local ot,_,_,_,oid = AirjHack:GetGUIDInfo(guid)
			if ot == "Creature" or ot == "GameObject" or ot == "AreaTrigger" then
				if uid and uid[oid] then
          local mignore = AirjMove.ignores[oid]
          if not mignore or not mignore[guid] then
						local x1,y1,z1,_,distance = AirjCache:GetPosition(guid)
						if distance then
							if not minDistance or distance<minDistance then
								minDistance = distance
								minDistanceGUID = guid
								minDistanceUID = oid
								minDistancePoint = {x1,y1,z1}
							end
						end
					end
				end
			end
		end
	end
	if minDistanceGUID then
		self:MoveTo(minDistancePoint,parachute)
		self.lastNearestGuid = minDistanceGUID
		self.lastNearestUid = minDistanceUID
		self.lastNearestDistance = minDistance
		self.lastNearestTime = GetTime()
		self.ignores[minDistanceUID].guid = minDistanceGUID
		return minDistanceGUID,minDistanceUID,minDistance
	end
end

function M:MoveTo(point,parachute)
	if parachute and (IsFlying() or IsSwimming() or IsFlyableArea() and IsMounted()) then
		local pd = {self:GetPlayPosition()}
		if type(parachute) ~= "number" then
			parachute = point[3] + 20
		end
		if self:GetDistance(point,{pd[1],pd[2],point[3]}) < 5 then
			self:SetMoveTarget("point",point)
		elseif pd[3] < parachute then
			self:SetMoveTarget("point",{pd[1],pd[2],parachute + 5})
		else
			self:SetMoveTarget("point",{point[1],point[2],pd[3]})
		end
	else
		self:SetMoveTarget("point",point)
	end
end

function M:MoveToTemplate(...)
	local data,durations,duration = {},{},0
	local typeT,minDistance = {},{}
	for i,d in ipairs({...}) do
		local x,y,z,t,md = unpack(d)
		typeT[i] = "point"
		data[i] = {x,y,z}
		minDistance[i] = md-0.1
		durations[i] = t
		duration = duration + t
	end
	self.goto.targetDataT = data
	self.goto.targetTypeT = typeT
	self.goto.targetMinDistanceT = minDistance
	self.goto.targetTimeT = {}
	local started = 0
	for i,v in ipairs(durations) do
		self.goto.targetTimeT[i] = -duration + v + started
		started = started + v
	end
	self.goto.templateTime = GetTime()+duration
end

local defaultDB = {
	["bwd"] = {
	{
		-3081.02880859375, -- [1]
		-1853.51904296875, -- [2]
		89.8387222290039, -- [3]
		5.1521053314209, -- [4]
		1.5, -- [5]
	}, -- [1]
	{
		-3218.091796875, -- [1]
		-1941.5078125, -- [2]
		96.9859924316406, -- [3]
		0.985560417175293, -- [4]
		1.5, -- [5]
	}, -- [2]
	{
		-3463.33642578125, -- [1]
		-1773.2099609375, -- [2]
		112.541709899902, -- [3]
		0.78528094291687, -- [4]
		1.5, -- [5]
	}, -- [3]
	{
		-3551.31274414063, -- [1]
		-1522.3974609375, -- [2]
		85.1822814941406, -- [3]
		0.16481614112854, -- [4]
		1.5, -- [5]
	}, -- [4]
	{
		-3486.67138671875, -- [1]
		-1234.27978515625, -- [2]
		87.4831390380859, -- [3]
		5.98462677001953, -- [4]
		1.5, -- [5]
	}, -- [5]
	{
		-3344.228515625, -- [1]
		-956.174682617188, -- [2]
		165.626647949219, -- [3]
		5.80397987365723, -- [4]
		1.5, -- [5]
	}, -- [6]
	{
		-3219.18359375, -- [1]
		-752.619506835938, -- [2]
		175.943572998047, -- [3]
		6.01603507995606, -- [4]
		1.5, -- [5]
	}, -- [7]
	{
		-3274.33862304688, -- [1]
		-440.619689941406, -- [2]
		147.029800415039, -- [3]
		0.361163377761841, -- [4]
		1.5, -- [5]
	}, -- [8]
	{
		-2877.08935546875, -- [1]
		-425.656555175781, -- [2]
		133.18962097168, -- [3]
		4.7750883102417, -- [4]
		1.5, -- [5]
	}, -- [9]
	{
		-2777.55102539063, -- [1]
		-672.516479492188, -- [2]
		134.51545715332, -- [3]
		4.59443330764771, -- [4]
		1.5, -- [5]
	}, -- [10]
	{
		-2408.78466796875, -- [1]
		-740.125671386719, -- [2]
		170.976776123047, -- [3]
		4.47662448883057, -- [4]
		1.5, -- [5]
	}, -- [11]
	{
		-2217.96142578125, -- [1]
		-712.13720703125, -- [2]
		123.801368713379, -- [3]
		0.0351943820714951, -- [4]
		1.5, -- [5]
	}, -- [12]
	{
		-2008.08532714844, -- [1]
		-739.298400878906, -- [2]
		97.4978790283203, -- [3]
		4.78292322158814, -- [4]
		1.5, -- [5]
	}, -- [13]
	{
		-1654.45446777344, -- [1]
		-696.827880859375, -- [2]
		41.2684173583984, -- [3]
		4.70438003540039, -- [4]
		1.5, -- [5]
	}, -- [14]
	{
		-1754.07739257813, -- [1]
		-885.12841796875, -- [2]
		145.654541015625, -- [3]
		2.56809711456299, -- [4]
		1.5, -- [5]
	}, -- [15]
	{
		-1955.75805664063, -- [1]
		-985.432678222656, -- [2]
		181.560211181641, -- [3]
		1.15045285224915, -- [4]
		1.5, -- [5]
	}, -- [16]
	{
		-1771.87841796875, -- [1]
		-1186.23156738281, -- [2]
		139.754531860352, -- [3]
		3.9268364906311, -- [4]
		1.5, -- [5]
	}, -- [17]
	{
		-1641.05847167969, -- [1]
		-1393.60925292969, -- [2]
		45.2211494445801, -- [3]
		4.00930213928223, -- [4]
		1.5, -- [5]
	}, -- [18]
	{
		-2045.3779296875, -- [1]
		-1294.50561523438, -- [2]
		131.096633911133, -- [3]
		4.75150108337402, -- [4]
		1.5, -- [5]
	}, -- [19]
	{
		-2284.97338867188, -- [1]
		-1203.49108886719, -- [2]
		63.5874671936035, -- [3]
		1.26040291786194, -- [4]
		1.5, -- [5]
	}, -- [20]
	{
		-2361.53393554688, -- [1]
		-1066.31652832031, -- [2]
		68.5908279418945, -- [3]
		3.30243873596191, -- [4]
		1.5, -- [5]
	}, -- [21]
	{
		-2529.447265625, -- [1]
		-1059.59558105469, -- [2]
		140.443771362305, -- [3]
		1.44889831542969, -- [4]
		1.5, -- [5]
	}, -- [22]
	{
		-2761.037109375, -- [1]
		-1004.74145507813, -- [2]
		135.226257324219, -- [3]
		1.39391994476318, -- [4]
		1.5, -- [5]
	}, -- [23]
	{
		-2973.19775390625, -- [1]
		-1061.90087890625, -- [2]
		96.526252746582, -- [3]
		1.69629836082459, -- [4]
		1.5, -- [5]
	}, -- [24]
	{
		-2943.66528320313, -- [1]
		-1320.8515625, -- [2]
		114.503120422363, -- [3]
		3.3142192363739, -- [4]
		1.5, -- [5]
	}, -- [25]
	{
		-2842.46997070313, -- [1]
		-1555.61279296875, -- [2]
		128.365783691406, -- [3]
		3.63230967521668, -- [4]
		1.5, -- [5]
	}, -- [26]
	{
		-2831.91259765625, -- [1]
		-1752.84973144531, -- [2]
		81.9350891113281, -- [3]
		2.0575852394104, -- [4]
		1.5, -- [5]
	}, -- [27]
	{
		-3186.80151367188, -- [1]
		-1663.20288085938, -- [2]
		204.913238525391, -- [3]
		0.694913148880005, -- [4]
		1.5, -- [5]
	}, -- [28]
}
}
function M:GetDB()
	AirjAutoKey.db.cruiseData = AirjAutoKey.db.cruiseData or {}
	return  AirjAutoKey.db.cruiseData
end
local testData
function M:GetCruiseDate()
	if not self.cruiseName then return end
	local db = M:GetDB()
	if self.cruiseName~="test" then

		if db[self.cruiseName] then
			return db[self.cruiseName]
		end

		if defaultDB[self.cruiseName] then
			db[self.cruiseName] = defaultDB[self.cruiseName]
			return db[self.cruiseName]
		end
	else
		local x,y,z = self:GetPlayPosition()
		if testData then return testData end
		testData = {}
		for i=1,5 do
			tinsert(testData,{x+(math.random()-0.5)*500,y+(math.random()-0.5)*500,z+(math.random()-0.5)*50})
		end
		return testData
	end
end


local meshs = {}
function M:DrawCruiseData()
	for i,v in pairs(meshs) do
    v.visible=false
		if v.Remove then
    	v:Remove()
		end
	end
	wipe(meshs)
	local data = self:GetCruiseDate()
	if not data then return end
	local j = #data
	for i = 1,#data do

		local scene = AVR:GetTempScene(200)
		local m=AVRUnitMesh:New()
		m:SetFollowUnit(false)
		m:SetFollowRotation(false)
		m:SetMeshTranslate(unpack(data[i]))
		local text = i..""
		if data[i].wait then
			text = text.." - w("..data[i].wait..")"
		end
		m:SetText(text)
		if data[i].stop then
			m:SetColor(1,0,0,0.2)
			m:SetColor2(1,0,0,0.4)
		end
		m:SetTimer(120)
    scene:AddMesh(m,false,false)
		if i ~= 1 or not data.noloop then
			local l = AVRPolygonMesh:New({{
				{data[i][1],data[i][2],data[i][3]-1},
				{data[i][1],data[i][2],data[i][3]+1},
				{data[j][1],data[j][2],data[j][3]+1},
				{data[j][1],data[j][2],data[j][3]-1},
			}})

			l:SetColor(1,1,1,0.2)
	    scene:AddMesh(l,false,false)
			tinsert(meshs,l)
		end
		j = i
		tinsert(meshs,m)
	end
end

local lastI
local waitTo
function M:CruiseTimer()
	if self:IsHardMoving() then
		lastI = nil
		self.isCruise = nil
	end
	if not self.isCruise then
		return
	end
	local data = self:GetCruiseDate()
	if not data then return end
	local j = #data
	local minDistance,minDistanceT,minDistanceI,minDistanceJ,minDistanceData,minDistance2,minDistanceXY,minDistanceZ
	-- local dd={}
	for i = 1,#data do
		if i ~= 1 or not data.noloop then
			local d,t,d2,dz = self:GetDistanceToLine(data[i],data[j],nil,true)
			-- dd[i] = d
			local continueOffset = 0
			if lastI then
				if i == lastI then
					continueOffset = 4
				elseif i == lastI + 1 then
					continueOffset = 2
				end
			end
			if not minDistance2 or (d - continueOffset<minDistance2) then
				minDistance = d
				minDistanceXY = d2
				minDistanceZ = dz
				minDistance2 = d - continueOffset
				minDistanceT = t
				minDistanceI = i
				minDistanceJ = j
				minDistanceData = data[i]
			end
		end
		j = i
	end
	-- print(minDistanceI,lastI,minDistance)
	-- dump (dd)
	-- print()
	if minDistance then
		local lastD = self.lastMinDistance or 1000
		if (minDistance < 5 and lastD<4 or minDistance<2) or (minDistanceXY and minDistanceXY<2 and not IsFlying() and minDistanceZ and minDistanceZ < 2) then
			self.lastMinDistance = minDistance
			local i = minDistanceI
			if lastI then
				local lastData = data[lastI]
				if lastData then
					local toTdistance = self:GetDistanceFromPlayer(unpack(lastData))
					if toTdistance<2 then
						i = minDistanceI + 1
					end
				end
			end
			if i ~= lastI then
				local lastData = lastI and data[lastI]
				local checkWait = lastData and lastI == i - 1
				if checkWait then
					if lastData.wait then
						-- print(GetTime() - (lastData.waitTriggered or 0))
						if not lastData.waitTriggered or GetTime() - lastData.waitTriggered > lastData.wait + 10 or GetTime() - lastData.waitTriggered <0 then
							waitTo = lastData.wait + GetTime()
							lastData.waitTriggered = GetTime()
							-- print("wait "..lastData.wait)
						end
					end
				end
				if self.cruiseName == "wq" and lastI and lastI == i - 1 then
					data[lastI] = nil
				end
				if i>#data then
					if not data.noloop then
						i = 1
					else
						i = nil
					end
				end
				lastI = i
			end

			local	targetPoint = data[i]
			if self.isCruise and targetPoint then
				-- print(i,waitTo and GetTime()-waitTo or "nowait")
				if not waitTo or GetTime()>waitTo then
					self:SetMoveTarget("point",targetPoint)
				end
			end
			-- self.lastCruisePoint = {self:GetPlayPosition()}
		else
			self.lastMinDistance = nil
			local pi,pj = data[minDistanceI],data[minDistanceJ]
			local p ={}
			for k=1,3 do
				p[k] = pj[k]+(pi[k]-pj[k])*(1-minDistanceT)
			end
			if self.isCruise then
				local px,py,pz = self:GetPlayPosition()
				if p[3]> pz + 5 then
					p[1] = px
					p[2] = py
				end
					self:SetMoveTarget("point",p)
					-- print(p[1],p[2],p[3])
			end
			-- out of cruise
		end
	end
end

function M:GetPlayPosition()
	return AirjHack:Position(UnitGUID("player"))
end

function M:GetDistance(p1,p2)
	return sqrt((p1[1]-p2[1])^2 + (p1[2]-p2[2])^2 + (p1[3]-p2[3])^2)
end

function M:GetDistanceToLine(p1,p2,p,inline)
	local t = 0
	local dis = self:GetDistance(p1,p2)
	p = p or {self:GetPlayPosition()}
	if dis == 0 then
		return self:GetDistance(p,p1),0.5
	end
	for i=1,3 do
		t = t + (p1[i]-p[i])*(p2[i]-p1[i])
	end
	t = -t/dis^2
	if inline then
		t = math.max(0,math.min(1,t))
	end
	local d = 0
	for i=1,3 do
		d = d + ((p1[i]-p[i])+(p2[i]-p1[i])*t)^2
	end
	d = sqrt(d)
	local d2 = 0
	for i=1,2 do
		d2 = d2 + ((p1[i]-p[i])+(p2[i]-p1[i])*t)^2
	end
	d2 = sqrt(d2)
	return d,t,d2,(p1[3]-p[3])+(p2[3]-p1[3])*t
end





function M:GetDistanceFromPlayer (x,y,z,xy)
	local px, py, pz = self:GetPlayPosition()
	return self:GetDistance({x,y,xy and pz or z},{px, py, pz})
end

function M:GetAngleFacing(angle)
	local px, py, pz, pf = self:GetPlayPosition()
	local facing = pf*180/math.pi
	angle = angle*180/math.pi
	angle = angle - 90 - facing + 360
	if (angle > 180) then angle = angle - 360 end
	return angle
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

function M:GetOffsetPoint(x,y,z,a)
	local px, py, pz, pf = self:GetPlayPosition()
	a = a or 0
	local facing = pf*180/math.pi+a
	return px-x*cos(facing)-y*sin(facing),py+y*cos(facing)-x*sin(facing),pz+z
end

function M:GetGoToMoves (x, y, z)
	local distance = self:GetDistanceFromPlayer(x,y,z)
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
  end
  return objectType,serverId,instanceId,zone,id,spawn
end

local gifts = {}
local areaTriggers = {}
M.areaTriggers = areaTriggers
local areaTriggerSpellIds = {
	[242613] = true,
}

function M:CheckATTrigged()
	local px,py,pz,pf = self:GetPlayPosition()
	for guid,position in pairs(areaTriggers) do
		local x,y,z,r = unpack(position)
		local d = math.sqrt((px-x)*(px-x)+(py-y)*(py-y)+(pz-z)*(pz-z))
		if d< (r or 1) then
			areaTriggers[guid] = nil
		end
	end
end

function M:CheckGiftTrigged()
	local px,py,pz,pf = self:GetPlayPosition()
	for guid,position in pairs(gifts) do
		local x,y,z = unpack(position)
		local d = math.sqrt((px-x)*(px-x)+(py-y)*(py-y)+(pz-z)*(pz-z))
		if d<1 then
			gifts[guid] = nil
		end
	end
end

function M:OnObjectCreated(event,guid,type)
  if bit.band(type,0x100)~=0 then
    local objectType,serverId,instanceId,zone,id,spawn = self:GetGUIDInfo(guid)
    if objectType == "AreaTrigger" then
      local spellId = AirjHack:ObjectInt(guid,0x88)
		 	if (spellId == 124503 or spellId == 124506) then
				-- print(id)
				local gs = {AirjHack:ObjectGUID4(UnitGUID("player"))}
				local match = true
				for i=1,4 do
					if not gs[i] == AirjHack:ObjectInt(guid,0x64+i*4) then
						match = false
						break
					end
				end
				if match then
					local x,y,z = AirjHack:Position(guid)
		      local radius = AirjHack:ObjectFloat(guid,0x94)
					gifts[guid] = {x,y,z,radius}
				end
			end
			if areaTriggerSpellIds[spellId] then
				local gs = {AirjHack:ObjectGUID4(UnitGUID("player"))}
				local match = true
				local oi = {}
				for i=1,4 do
					oi[i] = AirjHack:ObjectInt(guid,0x64+i*4)
				end
				for i=1,4 do
					if gs[i] ~= oi[i] then
						match = false
						break
					end
				end
					-- dump({id,oi,gs,match})
				if match then
					local x,y,z = AirjHack:Position(guid)
		      local radius = AirjHack:ObjectFloat(guid,0x94)
					areaTriggers[guid] = {x,y,z,radius,spellId}
				end
			end
    end
  end
end
function M:OnObjectDestroyed(event,guid)
	gifts[guid] = nil
	areaTriggers[guid] = nil
end

function M:IsHardMoving()
	for i=1,10 do
		if hardMoving[i] == 1 then
			return true
		end
	end
	return false
end

function M:MoveAsHard()
	for i=1,10 do
		M:Move(i,hardMoving[i])
	end
end

function M:Move(index,sos)
	if not AirjHack:HasHacked() then
		return
	end
	if sos == 1 then
		start[index]()
	else
		stop[index]()
	end
end

function M:GoToGift()
	local distance = 5
	local px,py,pz,pf = self:GetPlayPosition()
	local tx,ty,tz
	for guid,position in pairs(gifts) do
		local x,y,z = unpack(position)
		local d = math.sqrt((px-x)*(px-x)+(py-y)*(py-y)+(pz-z)*(pz-z))
		if d<distance then
			tx,ty,tz = x,y,z
			distance = d
		end
	end
	if distance < 0.9 then
		return
	end
	if tx and not self.gifting then
		if self:IsHardMoving() then
			self:MoveAsHard()
			self.gifting = nil
			return
		end
		self.gifting = true
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
				self.gifting = nil
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
					self.gifting = nil
					return
				end
				for i=1,4 do
					self:Move(i,0)
				end
				self.gifting = nil
			end,time)
		end,time)
	end
end
function M:GoToAreaTriggers(ids,maxDistance)
	maxDistance = maxDistance or 5
	local px,py,pz,pf = self:GetPlayPosition()
	local tx,ty,tz,tr
	local distance
	for guid,position in pairs(areaTriggers) do
		local x,y,z,r,sid = unpack(position)
		local d = math.sqrt((px-x)*(px-x)+(py-y)*(py-y)+(pz-z)*(pz-z))
		if (not distance or d<distance) and ids[sid] then
			tx,ty,tz,tr = x,y,z,r
			distance = d
		end
	end
	if distance and distance < tr-0.1 then
		return
	end
	if tx and not self.gifting then
		if self:IsHardMoving() then
			self:MoveAsHard()
			return
		end
		local speed = select(IsFlying() and 3 or IsSwimming() and 4 or 2 ,GetUnitSpeed("player"))
		self:MoveToTemplate({tx,ty,tz,distance/speed,tr-0.1})
	end
	return distance
end
local turning

function M:TurnAndCast(spellId,prejump,delay)
	if not AirjHack:HasHacked() then
		return
	end
	local spellName = GetSpellInfo(spellId)
	local rerc,relc
	if not spellName then return end
	if not turning and (GetSpellCooldown(spellName) == 0 or 1) then
		local f = GetPlayerFacing()
		local f2 = (f+math.pi)%(2*math.pi)
 	-- 	local d = not (self.leftDown==1 or self.rightDown==1)
 		local d = true
 		local ld = self.leftDown==1
 		local rd = self.rightDown==1
		local i = 0
		local timer
		delay = delay or 0.2
		delay = math.floor(delay*100)
		delay = math.max(delay,15)
		local turn = function()
			if i == 0 then
				if d then FlipCameraYaw(180) end
				if ld then
					CameraOrSelectOrMoveStop()
				end
				if rd then
					TurnOrActionStop()
					-- CameraOrSelectOrMoveStart()
					-- print("r->l start")
					rerc = true
				end
			end
			if i<10 then
				AirjHack:SetFacing(f2)
			else
				AirjHack:SetFacing(f)
			end
			if i == 10 then
				RunMacroText("/cast "..spellName)
			end
			if i == 10 then
				if d then
					FlipCameraYaw(180)
				end
			end
			if i == delay then
				-- print("done")
				turning = nil
				if rerc then
					-- CameraOrSelectOrMoveStop()
					TurnOrActionStart()
					-- print("r->l stop")
				end
				if relc then
					CameraOrSelectOrMoveStart()
				end
				self:MoveAsHard()
				self:CancelTimer(timer)
			end
			if i>2 and i<delay-2 then

				if self.leftDown == 1 then
					CameraOrSelectOrMoveStop()
					relc = true
				end
				if self.rightDown ==1 then
					TurnOrActionStop()
					rerc = true
					-- CameraOrSelectOrMoveStart()
				end
				if i%2==0 then
					self:Move(5,1)
					self:Move(6,0)
				else
					self:Move(5,0)
					self:Move(6,1)
				end
				-- if self.rightDown ==1 then
				-- 	CameraOrSelectOrMoveStop()
				-- 	TurnOrActionStart()
				-- end
			end
			i = i + 1
		end
		timer = self:ScheduleRepeatingTimer(turn,0.01)
		turning = 1
		if prejump then
			JumpOrAscendStart()
		end
	end
end

function M:GreenCast(...)

	local ld = self.leftDown==1
	local rd = self.rightDown==1
	AirjHack:GreenCast(...)
	if rd then
		TurnOrActionStart()
	end
	if ld then
		CameraOrSelectOrMoveStart()
	end
end

function M:StepStun(unit)
	local t = unit or "target"
	local gcd=AirjCache:GetSpellCooldown(61304)
	if gcd<0.2 then
		local c = UnitPower("player",4)
		local e = UnitPower("player",3)
		local can,canks
		local s=GetShapeshiftForm()
		local cd=AirjCache:GetSpellCooldown(408)
		local m = "/cast [@"..t.."] "
		local modcd,_,modknow=AirjCache:GetSpellCooldown(137619)
		local data = AirjCache.cache.castSuccess:find({spellId=1856,sourceGUID=UnitGUID("player")},nil,nil,{t=GetTime()-10})
		local vs = data and GetTime() - data.t or 10
		if not UnitBuff("player","潜行") or vs<3 then
			if not can and c>3 and e>24 and cd<0.2 then
				m = m.."肾击"
				can=1
				canks = 1
			end
			if not can and modknow and modcd<0.2 and c<=3 and e>24 and cd<0.2 then
				m = "/cast 死亡标记\n"..m.."肾击"
				can=1
				canks = 1
			end
			if not can and s~=0 and e>39 then
				m = m.."偷袭"
				can=1
			end
			if not can and s==0 and e>39 then
				if AirjCache:GetSpellCooldown(186313)<0.2 then
					m = "/cast 暗影之舞\n"..m.."偷袭"
					can=1
				end
			end
			if not can and s==0 and e>39 then
				if AirjCache:GetSpellCooldown(1856)<0.2 then
					m = "/cast 消失\n"..m.."偷袭"
					can=1
				end
			end
			if can then
				local guid = UnitGUID(t)
				local p={AirjCache:GetPosition(guid)}
				local d = p[5]
				local scd = AirjCache:GetSpellCooldown(36554)
				local data = AirjCache.cache.castSuccess:find({spellId=36554,destGUID=guid,sourceGUID=UnitGUID("player")},nil,nil,{t=GetTime()-1})
				local cs = data and GetTime() - data.t or 10
				if cs > 1 then
					if d >5 and scd<1 then
						m="/cast [@"..t.."] 暗影步\n"
					elseif d>5 and IsStealthed() then
						m="/cast [@"..t.."] 暗影打击\n"
					elseif d>5 and d<25 and AirjCache:GetSpellCooldown(1856)<0.2 then
						m="/cast 消失\n/cast [@"..t.."] 暗影打击\n"
					elseif d>8 then
						m = nil
					end
					print(d)
				end
			end
		else
			m = m.."偷袭"
		end
		print(m)
		if m then
			AirjHack:RunMacroText(m)
		end
	end
end
--
-- function M:TurnAndCast(spellId,prejump,delay)
-- 	local spellName = GetSpellInfo(spellId)
-- 	if not spellName then return end
-- 	if not turning and (GetSpellCooldown(spellName) == 0 or 1) then
-- 		local f = GetPlayerFacing()
-- 		local f2 = (f+math.pi*(1+1/180))%(2*math.pi)
--  		local d = not (self.leftDown==1 or self.rightDown==1)
-- 		local turn = function(f)
-- 			self:ScheduleTimer(function()
-- 				AirjHack:SetFacing(f)
-- 				self:Move(6,1)
-- 			end,0.01)
-- 			self:ScheduleTimer(function()
-- 				self:Move(6,0)
-- 				self:Move(5,1)
-- 			end,0.02)
-- 			self:ScheduleTimer(function()
-- 				self:Move(5,0)
-- 			end,0.03)
-- 		end
-- 		-- local ret = function()
-- 		-- 	self:ScheduleTimer(function()
-- 		-- 		AirjHack:SetFacing(f)
-- 		-- 		self:Move(5,1)
-- 		-- 	end,0.01)
-- 		-- 	self:ScheduleTimer(function()
-- 		-- 		self:Move(5,0)
-- 		-- 		self:Move(6,1)
-- 		-- 	end,0.02)
-- 		-- 	self:ScheduleTimer(function()
-- 		-- 		self:Move(6,0)
-- 		-- 	end,0.03)
-- 		-- end
-- 		self:ScheduleTimer(function()
-- 			if d then FlipCameraYaw(180) end
-- 		end,0.01)
-- 		local turntimer = self:ScheduleRepeatingTimer(turn,0.03,f2)
-- 		local rettimer
-- 		self:ScheduleTimer(function()
-- 			RunMacroText("/cast "..spellName)
-- 		end,0.1)
-- 		self:ScheduleTimer(function()
-- 			self:CancelTimer(turntimer)
-- 			rettimer = self:ScheduleRepeatingTimer(turn,0.03,f)
-- 			self:ScheduleTimer(function()
-- 				if d then FlipCameraYaw(180) end
-- 			end,0.01)
-- 			turn(f)
-- 		end,0.2)
-- 		turn(f2)
-- 		delay = delay or 0.3
-- 		self:ScheduleTimer(function()
-- 			self:CancelTimer(rettimer)
-- 			turning = nil
-- 			self:MoveAsHard()
-- 		end,delay)
-- 		turning = 1
-- 		if prejump then
-- 			JumpOrAscendStart()
-- 		end
-- 	end
-- end
