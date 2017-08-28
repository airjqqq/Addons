local M = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyMove", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
local start = {MoveForwardStart,MoveBackwardStart,StrafeLeftStart,StrafeRightStart,TurnLeftStart,TurnRightStart,JumpOrAscendStart ,SitStandOrDescendStart,PitchUpStart,PitchDownStart}
local stop  = {MoveForwardStop ,MoveBackwardStop ,StrafeLeftStop ,StrafeRightStop ,TurnLeftStop ,TurnRightStop ,AscendStop ,DescendStop ,PitchUpStop ,PitchDownStop }
local startName={"MoveForwardStart","MoveBackwardStart","StrafeLeftStart","StrafeRightStart","TurnLeftStart","TurnRightStart","JumpOrAscendStart","SitStandOrDescendStart","PitchUpStart","PitchDownStart"}
local stopName={"MoveForwardStop","MoveBackwardStop","StrafeLeftStop","StrafeRightStop","TurnLeftStop","TurnRightStop","AscendStop","DescendStop","PitchUpStop","PitchDownStop"}
AirjMove = M
local stopAllMoves = {0,0,0,0,0,0,0,0,0,0}

local PATHTOEDGE = 1

local turning

function M:OnInitialize()
	self.ignores = setmetatable({},{__index = function(t,k) t[k] = {} return t[k] end})
	self.ignoreGuids = {}
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
				M:GetCruiseDB()[self.cruiseName] = {}
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
			-- local x,y = GetPlayerMapPosition(unit)
			-- -- print(x,y)
			-- if x and x>0 then
		  --   local mapId = GetCurrentMapAreaID()
		  --   local _,_,_,l,r,t,b = GetAreaMapInfo(mapId)
		  --   l = -l
		  --   r = -r
		  --   local px = l+(r-l)*x
		  --   local py = t-(t-b)*y
			-- 	local z = select(3,self:GetPlayPosition())
			-- 	print(px,py)
		  --   AirjMove:MoveTo({px,py,z})
			-- end
			local y,x = UnitPosition(unit)
			if x then
				x = -x
				local z = select(3,self:GetPlayPosition())
		    AirjMove:MoveTo({x,y,z})
			end
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

function M:RestartMoveTimer()
  if self.moveTimer then
    self:CancelTimer(self.moveTimer,true)
    self.moveTimer = nil
  end
	self.moveTimer = self:ScheduleRepeatingTimer(self.MoveTimer,0.01,self)
end

function M:OnEnable()

	self.mainTimerProtectorTimer = self:ScheduleRepeatingTimer(function()
		if GetTime() - (self.lastMoveTime or 0) > 0.21 then
			if self.lastMoveTime then
			else
				self:Print("Restart Move Timer")
			end
			self.lastMoveTime = GetTime()
			self:RestartMoveTimer()
		end
	end,0.01)
	self.cruiseTimer = self:ScheduleRepeatingTimer(self.CruiseTimer,0.01,self)

	self.stuckHistory = AirjUtil:NewFIFO(1000)

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
local historySize = 10000
local lastMoves
local lastWayTime
local function saveHistory()
	local px,py,pz,pf = M:GetPlayPosition()
	local speed = GetUnitSpeed("player")
	local lastData = history[hindex]
	hindex = hindex + 1
	if hindex > historySize then
		hindex = 1
	end
	history[hindex] = {px,py,pz,pf,speed,lastMoves,GetTime()}
	lastMoves = nil
end

local function getHistory(offset)
	offset = offset or 0
	local i = hindex - offset
	if i <= 0 then i = i + historySize end
	return unpack(history[i] or {})
end

local lastFollowGUID

function M:CheckAndResetStuck()
	local t,d = self.goto.targetType,self.goto.targetData
	local guid
	if t == "unit" then
		guid = UnitGUID(d)
	elseif t == "guid" then
		guid = d
	end
	if guid then
		if guid ~= lastFollowGUID then
			lastFollowGUID = guid
			movinglast = 0
		end
	end
end

function M:MoveTimer()
	self.lastMoveTime = GetTime()
	if not AirjHack:HasHacked() then
		return
	end
  local now = GetTime()
	saveHistory()
	self:CheckAndResetStuck()
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
	local minDistance,is
	local playFacing = GetPlayerFacing()
	local speed = select(IsFlying() and 3 or IsSwimming() and 4 or 2 ,GetUnitSpeed("player"))

	local moves = {0,0,0,0,0,0,0,0,0,0}
	do
    local isTemplate
		local _,type,data
		_,type,data,minDistance,is = self:GetTemplatePoint()
		if not type then
			type,data,minDistance,is = self.goto.targetType,self.goto.targetData,self.goto.targetMinDistance,self.goto.incluedTargetSize
			if minDistance then
				minDistance = max(0.02*speed,minDistance)
			end
    else
      isTemplate = true
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
							if a then
								x = x + ox*cos(a) - oy*sin(a)
								y = y + oy*cos(a) + ox*sin(a)
							end
						end
					end
				end

				local way = self:GetNavigate({x,y,z},GetMinimapZoneText())
				local useWay = way and #way>2 and not isTemplate
				if useWay then
					minDistance = max(0.02*speed,0.1)
					is = nil
					local wx,wy,wz = unpack(way[2])
					if minDistance>self:GetDistanceFromPlayer(wx,wy,wz,true) then
						if way[3] then
							wx,wy,wz = unpack(way[3])
						end
					end
					x,y,z = wx,wy,wz
          local range = self:GetDistanceFromPlayer(x,y,z,true)
          if range < PATHTOEDGE*3 + 0.5 and (not lastWayTime or now - lastWayTime > 0.2) then
            lastWayTime = now+range/speed*0.98
            self:AddTemplatePoint(lastWayTime,speed,"point",{x,y,z},nil,nil,"way")
          end
				end
				if way and way.jump then
					if way.jump<speed*0.3 + 1 then
						if GetUnitSpeed("player") > 0 then
							moves[7] = 1
						end
					end
				end
				local px, py, pz = self:GetPlayPosition()
				targetDistanceXY = self:GetDistanceFromPlayer(x,y,pz)
				targetDistanceZ = z - pz
				targetDistance = self:GetDistanceFromPlayer(x,y,z)
				targetAngle = self:GetAngle(x,y,z)
				targetPitch = math.asin(targetDistanceZ/targetDistance)
				self.targetAngle = targetAngle
				targetSize = s
				if useWay then
					targetDistanceXY = way.distance
					targetDistance = way.distance
				end
			end
		end
	end
	do
		local _,type,data = self:GetTemplateFacing()

		if not type or not data then
			type,data = self.goto.facingType,self.goto.facingData
		else
			-- dump(type,data)
		end
		if type == "facing" then
			facingDistance = 40
			facingAngle = self:GetAngleFacing(data)
		elseif type then
			local x,y,z = self:GetPositionForType(type,data)
			local nofacing
			if type == "unit" and UnitIsDead(data) then
				nofacing = true
			end
			if x and not nofacing then
				facingDistance = self:GetDistanceFromPlayer(x,y,z)
				facingAngle = self:GetAngle(x,y,z)
			end
		end
	end
	local turnAngle = 0
	local stop
	local moveDistanceXY,moveDistance
	if minDistance then
		if GetUnitSpeed("player") > 0 then
			minDistance = max(minDistance-1,0)
		end
	end
	if targetDistanceXY then
		moveDistanceXY = targetDistanceXY - (minDistance or 0.2) - (self.goto.incluedTargetSize and targetSize or 0)
		-- dump({minDistance,moveDistanceXY})
		moveDistance = targetDistance - (minDistance or 0.2) - (self.goto.incluedTargetSize and targetSize or 0)
	else
		moveDistanceXY = 0
		moveDistance = 0
	end
	if moveDistanceXY>0 then
		self.targetDistance = moveDistanceXY
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
		else
			turnAngle = facingAngle
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
	if self.goto.targetType == "unit" and UnitCanAssist("player",self.goto.targetData) and targetDistanceXY and moveDistanceXY<5 and targetDistanceZ>1 and (self.goto.targetType == "point" or moveDistanceXY>0.2) or targetDistanceZ and targetDistanceZ>10 then
		moves[7] = 1
	end
	if stop  and moveDistance < 15 then
		movinglast = 0
	else
		movinglast = movinglast + 1
	end
	local stucked, stuckedDistance = self:CheckStuckedTime(0.05)
	if stucked > 1 and (stucked+0.5)%1.5 <0.05 then
		moves[7] = 1
		if (stucked+0.5)%1.5 >0.02 then
			moves[1] = 1
		end
		print("jump",stucked)
	end
	-- local speed = GetUnitSpeed("player")

	if not stop then
		local wa,da = self:GetWallAngle(4)
		local wa2,da2 = self:GetWallAngle(2)
		-- print(wa)
		if true and da and math.abs(da)>0.1*math.pi and da2 and math.abs(da2)>0.1*math.pi then
			local range = min(5,math.abs(2/ math.cos(da)))
			if not self.lastWallTime or now - self.lastWallTime > 1 then
				self:AddTemplatePoint(now+range/speed*0.95,speed,"point",{self:GetOffsetPointAbs(range,0,0,wa)},nil,nil,"wall")
				self.lastWallTime = now
				self.lastWallDirection = da>0 and 1 or -1
			end
		elseif not da then
			if not AirjAutoKey or not AirjAutoKey:GetParam("nowalkaround") then
				local now = GetTime()
				if (not self.lastAroundTime or now - self.lastAroundTime > 1) and (not self.lastWallTime or now - self.lastWallTime > 1) then
					local radius = 3
					local minTime = radius/speed
					stucked, stuckedDistance = self:CheckStuckedTime(radius)
					local stucked2 = self:CheckStuckedTime(1)
					if targetDistanceXY and stucked >(IsFlying() and 3 or 1) + minTime and stuckedDistance>radius and stucked2 > 0.4 then
						local lastStuckedData
					  for v,k,i in self.stuckHistory:iterator() do
							if now - v.t > 30 then
								break
							end
							local x,y,z = unpack(v.point,1,3)
							local distance = self:GetDistanceFromPlayer(x,y,z,not IsFlying() and not IsSwimming() and not IsFalling())
							if distance < 1 then
								lastStuckedData = v
								break
							end
						end
						local stuckedTimes = lastStuckedData and lastStuckedData.stuckedTimes or 0
						stuckedTimes = stuckedTimes + 1
						local direction = lastStuckedData and lastStuckedData.direction or self.lastWallDirection and -self.lastWallDirection or 1
						direction = - direction
						local range = math.floor(stuckedTimes/2+0.5)*3
						local datas = {
							{range*0.25/speed*1,{self:GetOffsetPointFacing(0,-range*0.25,0,self.targetAngle)}},
							{range*0.36/speed*1,{self:GetOffsetPointFacing(direction*range*0.25,-range*0.5,0,self.targetAngle)}},
							{range*0.5/speed*1,{self:GetOffsetPointFacing(direction*range*0.75,-range*0.5,0,self.targetAngle)}},
							{range*0.36/speed*1,{self:GetOffsetPointFacing(direction*range,-range*0.25,0,self.targetAngle)}},
							{range*0.75/speed*1,{self:GetOffsetPointFacing(direction*range, range*0.5,0,self.targetAngle)}},
						}
						local time = now
						for i,data in ipairs(datas) do
							time = time + data[1]
							self:AddTemplatePoint(time,speed,"point",data[2])
						end
						self.lastAroundTime = time
						self.stuckHistory:push({t=now,point={self:GetPlayPosition()},direction=direction,stuckedTimes=stuckedTimes})
					end
				end
			end
		end
	end
	local nt
	if stop then
		nt = abs(turnAngle) > 30
	elseif targetDistanceXY then
		nt = abs(turnAngle) > max((15 - targetDistanceXY)*1,5)
	else
		nt = abs(turnAngle) > 15
	end
	if nt and not turning then
		-- if turnAngle > 0 then
		-- 	turnAngle = turnAngle
		-- 	self:Move(5,0)
		-- 	moves[5] = 1
		-- else
		-- 	turnAngle= turnAngle
		-- 	self:Move(6,0)
		-- 	moves[6] = 1
		-- end
		local facing = playFacing + turnAngle/180*math.pi
		facing = (facing)%(math.pi*2)
		AirjHack:SetFacing(facing)
		-- print(facing)
	else
		moves[5] = 0
		moves[6] = 0
	end
	self:DoMove(moves)
	lastMoves = moves
end

function M:AddTemplatePoint(time,speed,type,data,minDistance,is,text)
	self.goto.templatePoints = self.goto.templatePoints or {}
	tinsert(self.goto.templatePoints,{time,type,data,minDistance,is})
	if AVR then
		local now = GetTime()
		local scene = AVR:GetTempScene(200)
		local m=AVRUnitMesh:New()
		m:SetFollowUnit(false)
		m:SetFollowRotation(false)
		m:SetRadius(1.5)
		m:SetMeshTranslate(unpack(data))
    text = text or "stuck"
		m:SetText(text)
		m:SetTimer(time-now)
		scene:AddMesh(m,false,false)
	end
end

function M:AddTemplateFacing(time,type,data)
	self.goto.templateFacings = self.goto.templateFacings or {}
	tinsert(self.goto.templateFacings,{time,type,data})

end

function M:GetTemplateFacing()
	local facings = self.goto.templateFacings
	local now = GetTime()
	local mintime,minfacing
	if facings then
		for i,facing in ipairs(facings) do
			local time,type,data = unpack(facing)
			if time<now then
				tremove(facings,i)
			else
				if not mintime or time<mintime then
					mintime = time
					minfacing = facing
				end
			end
		end
	end
	if minfacing then
		return unpack(minfacing)
	end
end

function M:GetTemplatePoint()
	local points = self.goto.templatePoints
	local now = GetTime()
	local mintime,minpoint
	if points then
		for i,point in ipairs(points) do
			local time,type,data,minDistance,is = unpack(point)
			if time<now then
				tremove(points,i)
			else
				if not mintime or time<mintime then
					mintime = time
					minpoint = point
				end
			end
		end
	end
	if minpoint then
		return unpack(minpoint)
	end
end

function M:NeedBarCast()

end

function M:CheckStuckedTime(d)
	d = d or 1
	local now = GetTime()
	local earliest = now
	local sumdistance = 0
	for i = 10,movinglast,10 do
		local x,y,z,f,speed,lm,t = getHistory(i)
		if not x then
			break
		end
		local duration = earliest - t
		sumdistance = sumdistance + duration * speed
		earliest = t
		local distance = self:GetDistanceFromPlayer(x,y,z,not IsFlying() and not IsSwimming() and not IsFalling())
		if distance>d then
			break
		end
	end
	return now - earliest,sumdistance-d
end

function M:GetWallAngle(count)
	count = count or 1
	local now = {getHistory(0)}
	local history = {getHistory(count)}
	if not now[1] or not history[1] then
		return
	end
	local mx,my,mz,mt = now[1]-history[1], now[2] - history[2], now[3] - history[3], now[7] - history[7]
	if not (mx == 0 and my == 0) then
		local ma = math.atan2(my, mx)
		local md = math.sqrt(mx^2+my^2)
		local ms = history[6] or {}
		local sa = 0
		if ms[1]==1 and ms[2]==0 and ms[3]==0 and ms[4]==0 then
			sa = 0
		elseif ms[1]==1 and ms[2]==0 and ms[3]==1 and ms[4]==0 then
			sa = math.pi/4
		elseif ms[1]==0 and ms[2]==0 and ms[3]==1 and ms[4]==0 then
			sa = 2*math.pi/4
		elseif ms[1]==0 and ms[2]==1 and ms[3]==1 and ms[4]==0 then
			sa = 3*math.pi/4
		elseif ms[1]==0 and ms[2]==1 and ms[3]==0 and ms[4]==0 then
			sa = 4*math.pi/4
		elseif ms[1]==0 and ms[2]==1 and ms[3]==0 and ms[4]==1 then
			sa = 5*math.pi/4
		elseif ms[1]==0 and ms[2]==0 and ms[3]==0 and ms[4]==1 then
			sa = 6*math.pi/4
		elseif ms[1]==1 and ms[2]==0 and ms[3]==0 and ms[4]==1 then
			sa = 7*math.pi/4
		end
		sa = sa + history[4] + math.pi/2
		sa = sa%(2*math.pi)
		local sd = history[5]*mt
		local da = (ma - sa)%(2*math.pi)
		if da > math.pi then
			da = da - 2*math.pi
		end
		local mdp = sd * math.cos(da)
		if math.abs((mdp-md)/md)<0.02 then
			return ma,da
		end
	end
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
	if self.goto.templatePoints then
		wipe(self.goto.templatePoints)
	end
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

function M:KeepFollowUnit(unit,...)
	self:SetMoveTarget("unit",unit,nil,...)
end

function M:KeepFollowGUID(guid,...)
	if guid and guid~=UnitGUID("player") then
		self:SetMoveTarget("guid",guid,nil,...)
	end
end
function M:KeepFacingUnit(unit,...)
	self:SetMoveFacing("unit",unit,true,...)
end
function M:KeepFacingGUID(guid,...)
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
					local nignore = (not mignore or not mignore[guid]) and not AirjMove.ignoreGuids[guid]
          if nignore then
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
			local a,b = pd[1]-point[1],pd[2]-point[2]
			local s = math.sqrt(a^2+b^2)
			a,b = a/s,b/s
			self:SetMoveTarget("point",{point[1]+a*2,point[2]+b*2,point[3]},nil,3)
		elseif pd[3] < parachute then
			self:SetMoveTarget("point",{pd[1],pd[2],parachute + 5})
		else
			self:SetMoveTarget("point",{point[1],point[2],pd[3]},nil,3)
		end
	else
		self:SetMoveTarget("point",point)
	end
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
function M:GetCruiseDB()
	AirjAutoKey.db.cruiseData = AirjAutoKey.db.cruiseData or {}
	return  AirjAutoKey.db.cruiseData
end
local cruiseTestData
function M:GetCruiseDate()
	if not self.cruiseName then return end
	local db = M:GetCruiseDB()
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
		if cruiseTestData then return cruiseTestData end
		cruiseTestData = {}
		for i=1,5 do
			tinsert(cruiseTestData,{x+(math.random()-0.5)*500,y+(math.random()-0.5)*500,z+(math.random()-0.5)*50})
		end
		return cruiseTestData
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
    m:SetRadius(2)
		local text = i..""
		if data[i].wait then
			text = text.." - w("..data[i].wait..")"
		end
		m:SetText(text)
		if data[i].stop then
			m:SetColor(1,0,0,0.2)
			m:SetColor2(1,0,0,0.4)
		end
		m:SetTimer(3600)
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
	local minDistance,minDistanceT,minDistanceI,minDistanceJ,minDistanceData,minDistance2,minDistanceXY,minDistanceZ,minDistanceL
	-- local dd={}
	for i = 1,#data do
		if i ~= 1 or not data.noloop then
			local d,t,d2,dz = self:GetDistanceToLine(data[i],data[j],nil,true)
			local l = self:GetDistance(data[i],data[j])
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
				minDistanceL = l
				minDistanceData = data[i]
			end
		end
		j = i
	end
	-- print(minDistanceI,lastI,minDistanceT)
	-- dump (dd)
	-- print()
	if minDistance then
		local lastD = self.lastMinDistance or 1000
		local mind = IsFlying() and 5 or IsMounted() and 2 or 0.5
		local D2E = minDistanceT*minDistanceL
		if (minDistance < mind and lastD<mind*0.5 or minDistance<mind*0.5) or (minDistanceXY and minDistanceXY<mind*0.5 and not IsFlying() and minDistanceZ and minDistanceZ < 2) or D2E<mind then
			-- print("")
			self.lastMinDistance = minDistance
			local i = minDistanceI
			if lastI then
				local lastData = data[lastI]
				if lastData then
					local toTdistance = self:GetDistanceFromPlayer(unpack(lastData))
					if toTdistance<mind or D2E<mind then
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

function M:GetVector(f,t)
	local vector = {}
	for i,v in ipairs(f) do
		if i<=3 then
			vector[i] = t[i] - f[i]
		end
	end
	return vector
end
function M:GetMetaVector(f,t)
	local vector = {}
	local l = self:GetDistance(f,t)
	for i,v in ipairs(f) do
		if i<=3 then
			vector[i] = (t[i] - f[i])/l
		end
	end
	return vector
end
function M:RotateVector(v,a)
  local s,c = math.sin(a),math.cos(a)
  return {v[1]*c - v[2]*s, v[1]*s+v[2]*c,v[3]}
end

function M:Cross(v1,v2)
	return v1[1]*v2[2]-v1[2]*v2[1]
end

function M:Intersect(l1,l2)
	local p,q = l1[1],l2[1]
	local r,s = self:GetVector(l1[2],l1[1]),self:GetVector(l2[2],l2[1])
	local rxs = self:Cross(r,s)
	local pqxr = self:Cross(self:GetVector(p,q),r)
	if rxs == 0 then
		if pqxr == 0 then
			return true
		else
			return false
		end
	else
		local pqxs = self:Cross(self:GetVector(p,q),s)
		local t = -pqxs/rxs
		local u = -pqxr/rxs
		if t>=0 and t<=1 and u>=0 and u<=1 then
			return true,t,u
		else
			return false,t,u
		end
	end
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

function M:GetOffsetPointFacing(x,y,z,a)
	local px, py, pz, pf = self:GetPlayPosition()
	a = a or 0
	local facing = pf*180/math.pi+a
	return px-x*cos(facing)-y*sin(facing),py+y*cos(facing)-x*sin(facing),pz+z
end

function M:GetOffsetPointAbs(x,y,z,a)
	a = a or 0
	local px, py, pz, pf = self:GetPlayPosition()
	local sin,cos = math.sin,math.cos
	return px+x*cos(a)-y*sin(a),py+y*cos(a)+x*sin(a),pz+z
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
		-- self:MoveToTemplate({tx,ty,tz,distance/speed,tr-0.1})
	end
	return distance
end

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

function M:TurnToCast(spellId,unit,offset,prejump,delay,movef)
	offset = offset or 0
	if not AirjHack:HasHacked() then
		return
	end
	local spellName = GetSpellInfo(spellId)
	local rerc,relc
	if not spellName then return end
	if not turning and (GetSpellCooldown(spellName) == 0 or 1) then
		local f = GetPlayerFacing()
		local fx,fy,fz = AirjHack:Position(UnitGUID(unit))
		if not fx then
			return
		end
		local fu = self:GetAngle(fx,fy,fz)
		local f2 = (f + (fu+offset)/180*math.pi)%(2*math.pi)
 		local d = not (self.leftDown==1 or self.rightDown==1)
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
				if d then FlipCameraYaw(fu+offset) end
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
				if movef then
					self:DoMove({1,0,0,0,0,0,0,0,0,0})
				end
			else
				AirjHack:SetFacing(f)
			end
			if i == 10 then
				RunMacroText("/cast [@"..unit.."]"..spellName)
			end
			if i == 10 then
				if d then
					FlipCameraYaw(360-(fu+offset))
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
				if prejump then
					AscendStop()
				end
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
			if prejump then
				JumpOrAscendStart()
			end
		turning = 1
	end
end

function M:RaidPillar(index,x,y,z)
	index = index or 1
	local timer
	local fucn = function()
		if UnitCastingInfo("player") or UnitChannelInfo("player") then
		else
			AirjHack:RunMacroText("/wm "..index)
			AirjHack:TerrainClick(x,y,z)
			self:CancelTimer(timer)
		end
	end
	timer = self:ScheduleRepeatingTimer(fucn,0.2)
	fucn()
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

function M:GreenCast2(...)
	local ld = self.leftDown==1
	local rd = self.rightDown==1
	AirjHack:GreenCast2(...)
	if rd then
		TurnOrActionStart()
	end
	if ld then
		CameraOrSelectOrMoveStart()
	end
end

function M:GreenCast3(...)
	local ld = self.leftDown==1
	local rd = self.rightDown==1
	AirjHack:GreenCast3(...)
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

-- Navigate

local function getCircleDatas(data,from,count)
	local d = {}
	for i = 1,count do
		local index = (from+i-2)%(#data)+1
		d[i] = data[index]
	end
	return d
end
local navigateTestData
function M:GenerateTestNavigateData()
	local test = {}
	local IMAX,JMAX = 6,6
	local function getid(i,j)
		return i*(JMAX+1) + j
	end
	local recta = 0.5
	for i = 0,IMAX do
		for j = 0,JMAX do
			-- if i == 0 or i==IMAX or j==0 or j==JMAX or ((i == 2 or i==IMAX-2) and j>=2 and j<=JMAX-2) or j==3 and i~=3 then
			if i%2==0 or j%2==0 then
				local points = {
					{i-(recta+(math.random()-0.5)*0.2),j-(recta+(math.random()-0.5)*0.2),0},
					{i+(recta+(math.random()-0.5)*0.2),j-(recta+(math.random()-0.5)*0.2),0},
					{i+(recta+(math.random()-0.5)*0.2),j+(recta+(math.random()-0.5)*0.2),0},
					{i-(recta+(math.random()-0.5)*0.2),j+(recta+(math.random()-0.5)*0.2),0},
				}
				test[getid(i,j)] = {points = points}
			end
		end
	end
	local function getEid(i,j)
		local id = getid(i,j)
		if test[id] then
			return id
		end
	end
	for i = 0,IMAX do
		for j = 0,JMAX do
			local id = getid(i,j)
			if test[id] then
				local edges = {}
				edges[1] = j == 0 and {} or {to=getEid(i,j-1)}
				edges[2] = i == IMAX and {} or {to=getEid(i+1,j)}
				edges[3] = j == JMAX and {} or {to=getEid(i,j+1)}
				edges[4] = i == 0 and {} or {to=getEid(i-1,j)}
				test[id].edges = edges
			end
		end
	end
	local pp = {AirjHack:Position(UnitGUID("player"))}
	for _,p in pairs(test) do
		for _,point in pairs(p.points) do
			for i = 1,3 do
				point[i] = point[i]*7 + pp[i]
			end
		end
	end
	navigateTestData = test
	return test
end

function M:GetNavigateDB()
	AirjAutoKey.db.navigateData = AirjAutoKey.db.navigateData or {}
	return  AirjAutoKey.db.navigateData
end
function M:CreateNavigateData()
	local db = self:GetNavigateDB()
	local zone = GetMinimapZoneText()
	if not db[zone] then
		db[zone] = {}
	end
	return db[zone]
end
function M:GetNavigateData(zone)
	zone = zone or self.navigateZone
	zone = zone or GetMinimapZoneText()
	self.navigateZone = zone
	if zone == "test" then
		if not navigateTestData then self:GenerateTestNavigateData() end
		return navigateTestData
	end
	if self.defaultPolys[zone] then
		-- db[zone] = self.defaultPolys[zone]
		return self.defaultPolys[zone]
	end
	local db = self:GetNavigateDB()
	if db[zone] then
		return db[zone]
	end
end

function M:NewPolyByCruiseData(ids,id)
	local cruiseData = self:GetCruiseDate()
	local navigateData = self:CreateNavigateData()
	local px, py, pz = self:GetPlayPosition()
	local points = {}
	local edges = {}
	if ids then
		for i,id in ipairs(ids) do
			local p = {cruiseData[id][1],cruiseData[id][2],pz}
			points[i] = p
			edges[i] = {}
		end
	else
		for i,point in ipairs(cruiseData) do
			local p = {point[1],point[2],pz}
			points[i] = p
			edges[i] = {}
		end
	end
	local cd = {points=points,edges=edges}
	if id then
		navigateData[id] = cd
	else
		tinsert(navigateData,cd)
	end
	self:DrawPolyDatas()
end
function M:InsertPoint(id,index,distance)
	local navigateData = self:CreateNavigateData()
	local p = getCircleDatas(navigateData[id].points,index,2)
	local v = self:GetMetaVector(p[1],p[2])
	local ip = {}
	local ei
	if distance > 0 then
		for i=1,3 do
			ip[i] = p[1][i] + v[i]*distance
		end
		ei = index
	else
		for i=1,3 do
			ip[i] = p[2][i] + v[i]*distance
		end
		ei = index+1
	end
	tinsert(navigateData[id].points,index+1,ip)
	tinsert(navigateData[id].edges,ei,{})
	self:DrawPolyDatas()
end
function M:RotatePoint(id,index,deg,usenext)
	local navigateData = self:CreateNavigateData()
	local p = getCircleDatas(navigateData[id].points,index-1,3)
	if usenext then
		local v = self:GetVector(p[3],p[2])
		v = self:RotateVector(v,deg*math.pi/180)
		for i=1,3 do
			p[2][i] = p[3][i] + v[i]
		end
	else
		local v = self:GetVector(p[1],p[2])
		v = self:RotateVector(v,deg*math.pi/180)
		for i=1,3 do
			p[2][i] = p[1][i] + v[i]
		end
	end
	self:DrawPolyDatas()
end
function M:SetPolyEdgeTo(id,index,to)
	local navigateData = self:CreateNavigateData()
	navigateData[id].edges[index].to = to
	self:DrawPolyDatas()
end
function M:SetPolyEdgeJump(id,index,jump)
	local navigateData = self:CreateNavigateData()
	navigateData[id].edges[index].jump = jump
	self:DrawPolyDatas()
end
function M:SetPolyMaxZ(id,maxz)
	local navigateData = self:CreateNavigateData()
	navigateData[id].maxz=maxz
	self:DrawPolyDatas()
end
function M:SetPolyAllEdges(zone)

	zone = zone or GetMinimapZoneText()
	local datas = M:GetNavigateData(zone)
	if not datas then return end
	for id,poly in pairs(datas) do
		local a = poly.center
		for ei,ed in ipairs(poly.edges) do
			if true then
				local ni = ei+1
				if ni > #poly.points then ni = ni - #poly.points  end
				local sp,ep = poly.points[ei],poly.points[ni]
				local ec = {}
				for i = 1,3 do
					ec[i] = (sp[i]+ep[i])/2
				end
				local vm = self:RotateVector(self:GetMetaVector(sp,ep),-math.pi/2)
				local tp = {}
				for i = 1,3 do
					tp[i] = ec[i] + vm[i]*0.1
				end
				local z = poly.points[1][3]
				local toId
				for id2,poly2 in pairs(datas) do
					local z2 = poly.points[1][3]
					if self:IsPointInPoly(tp,poly2) and z>z2-0.5 then
						toId = id2
						break
					end
				end
				if toId then
					ed.to = toId
				end
			end
		end
	end
	self:DrawPolyDatas(zone)
end

function M:SetPolyZ(id)
	local navigateData = self:CreateNavigateData()
	local data = navigateData[id].points
	local px, py, pz = self:GetPlayPosition()
  for i,p in ipairs(data) do
    p[3] = pz
  end
	self:DrawPolyDatas()
end

function M:OffsetPolyEdge(id,offset,iStart,iCount)
  iCount = iCount or 1
	local navigateData = self:CreateNavigateData()
	local data = navigateData[id]
  local count = 3+iCount
  local p = getCircleDatas(data.points,iStart-1,count)
  local vr,vl,ve = self:GetMetaVector(p[1],p[2]),self:GetMetaVector(p[#p],p[#p-1]),self:GetMetaVector(p[2],p[#p-1])
  local lr,ll = self:Cross(vr,ve),self:Cross(vl,ve)
  if lr>0 then lr = 1/lr else lr = 0 end
  if ll>0 then ll = 1/ll else ll = 0 end
  local vm = self:RotateVector(ve,-math.pi/2)
  -- dump(lr,ll,p)
  for i = 2,#p-1 do
    for j=1,2 do
      if i == 2 then
        p[i][j] = p[i][j] + vr[j]*lr*offset
      elseif i == #p-1 then
        p[i][j] = p[i][j] + vl[j]*ll*offset
      else
        p[i][j] = p[i][j] + vm[j]*offset
      end
    end
  end
  -- dump(p)
	self:DrawPolyDatas()
end

function M:CopyPoint(id1,i1,id2,i2)
  local navigateData = self:CreateNavigateData()
  local data1 = navigateData[id1]
  local data2 = navigateData[id2]
  data1.points[i1] = data2.points[i2]
	self:DrawPolyDatas()
end

local polymeshs = {}
local id2range = {}

function M:ClearPolyDatas()
	for _,v in pairs (polymeshs) do
    v.visible=false
		if v.Remove then
    	v:Remove()
		end
	end
	wipe(polymeshs)
end
function M:DrawPolyDatas(zone,aid)
	zone = zone or GetMinimapZoneText()
	for _,v in pairs (polymeshs) do
    v.visible=false
		if v.Remove then
    	v:Remove()
		end
	end
	wipe(polymeshs)
	local datas = M:GetNavigateData(zone)
	if not datas then return end
	local scene = AVR:GetTempScene(200)
	for id,poly in pairs(datas) do
		local m = AVRPolygonMesh:New({poly.points})
		m:SetColor(math.random(),math.random(),math.random(),0.2)
    scene:AddMesh(m,false,false)
		tinsert(polymeshs,m)
		local scene = AVR:GetTempScene(200)

		if not poly.center then
			local a={0,0,0}
			local c={0,0,0}
			for i,p in ipairs(poly.points) do
				for j=1,3 do
					a[j] = a[j] + p[j]
					c[j] = c[j] + 1
				end
			end
			for j=1,3 do
				a[j] = a[j]/c[j]
			end
			poly.center = a
		end
		local text = id..""
		if poly.maxz then
			text = text .. " maxz(" .. poly.maxz..")"
		end
		if id2range then
			local d = id2range[id]
			local r = d and d.range
			if r then
				text = text .. " - " .. r
			end
		end
		m=AVRTextMesh:New(text,2)
		m:SetMeshTranslate(unpack(poly.center))
    scene:AddMesh(m,false,false)
		tinsert(polymeshs,m)
	end

	for id,poly in pairs(datas) do
		local a = poly.center
		for ei,ed in ipairs(poly.edges) do
			if not aid or id==aid then
				local ni = ei+1
				if ni > #poly.points then ni = ni - #poly.points  end
				local sp,ep = poly.points[ei],poly.points[ni]
				local ec = {}
				for i = 1,3 do
					ec[i] = (sp[i]+ep[i])/2
				end
				local ac = {}
				local ec2c = self:GetDistance(ec,a)
				for i = 1,3 do
					ac[i] = ec[i] - (ec[i]-a[i])*1/ec2c
				end
				local text = ei..""
				if ed.to then
					text = text.." ("..ed.to..")"
					if ed.jump then
						text = text.." - jump"
					end
					if id == aid then
						m=AVRArrowMesh:New(0,1,2)
						local tc = datas[ed.to].center
						m.length = self:GetDistance(ac,tc)
						local acc = {}
						for i = 1,3 do
							acc[i] = ac[i] - (ac[i]-tc[i])*0.5
						end
						m:SetMeshTranslate(unpack(acc))
						local aa = math.atan2(tc[2]-ac[2],tc[1]-ac[1]) - math.pi/2
						-- aa = 180*aa/math.pi
						m:SetMeshRotation(aa)
				    scene:AddMesh(m,false,false)
						tinsert(polymeshs,m)
					end
				end
				m=AVRTextMesh:New(text,1)
				if ed.to then
					m:SetColor(0,1,0)
				else
					m:SetColor(1,0,0)
				end
				m:SetMeshTranslate(unpack(ac))
		    scene:AddMesh(m,false,false)
				tinsert(polymeshs,m)
			end
		end
	end
end

function M:DrawArrow(id)

end

function M:IsPointInPoly(point,poly)
  local z = poly.points[1][3]
  if point[3]<z-1 then
    return false
  end
	if poly.maxz then
		if point[3]>z+poly.maxz then return false end
	end
	local j = #poly.points
	local inside=false
	local px,py = point[1],point[2]
	for i = 1,#poly.points do
		local s,e = poly.points[i],poly.points[j]
		if py>s[2] and py<=e[2] or py>e[2] and py<=s[2] then
			local l,r = (px-s[1])*(e[2]-s[2]),(py-s[2])*(e[1]-s[1])
			if e[2]>s[2] and l>r or e[2]<s[2] and l<r then
				inside = not inside
			end
		end
		j = i
	end
	return inside
end
local MAXRANGEINCREASE = 2
function M:GetPolyRoutes(from,to,datas)
	from = from or {AirjHack:Position(UnitGUID("player"))}
	to = to or {AirjHack:Position(UnitGUID("target"))}
	if not from[1] or not to[1] then
		return
	end
	datas = datas or self:GetNavigateData()
	if not datas then return end
	local fromId, toId
	for id,v in pairs(datas) do
		if not fromId and self:IsPointInPoly(from,v) then
			fromId = id
		end
		if not toId and self:IsPointInPoly(to,v) then
			toId = id
		end
		if fromId and toId then
			break
		end
	end
	if not fromId or not toId then
		return
	end
	if fromId == toId then
		return
	end
	wipe(id2range)
	local i = 1
	local range
	id2range[fromId] = {range=1,from={}}
	local debug
	debug = 0
	while true do
		local i2r = {}
		for id,rd in pairs(id2range) do
			if rd.range == i then
				local data = datas[id]
				if data then
					for ei,ed in ipairs(data.edges) do
						if ed.to then
							local tid = ed.to
							if not id2range[tid] and not i2r[tid] then
								i2r[tid] = {range = i+1,from={}}
							end
							local data = id2range[tid] or i2r[tid]
							if data.range+MAXRANGEINCREASE>i then
								-- for j,r in ipairs(rd.from) do
								-- 	local route = {unpack(r)}
								-- 	tinsert(route,id)
								-- 	-- dump(route)
								-- 	tinsert(data.from,route)
								-- end
								tinsert(data.from,id)
							end
							if not range and tid == toId then
								range = i+1
							end
						end
					end
				end
			end
		end
		for id,v in pairs(i2r) do
			id2range[id] = v
		end
		if range and i+1>=range + MAXRANGEINCREASE then
			break
		end
		i = i + 1
		debug = debug + 1
		if debug > 100 then
			print("debug id2range")
			break
		end
	end
	if not range then
		return
	end
	local routes = {}
	local checknext
	local chosen = setmetatable({},{__index=function(t,k) t[k] = {} return t[k] end})
	local route = {toId}
	local been = {[toId] = true}
	local back = function()
		local cid = route[#route]
		tremove(route)
		been[cid] = nil
		chosen[#route + 1] = nil
	end
	local save = function()
		local r ={}
		for i = #route,1,-1 do
			tinsert(r,route[i])
		end
		tinsert(routes,r)
	end
	checknext = function()
		-- print(table.concat(route,","))
		-- dump(chosen)
		local cid = route[#route]
		if cid == fromId then
			save()
			back()
			return true
		end
		if #route + id2range[cid].range - 1> range + MAXRANGEINCREASE then
			-- print("out of range",#route,range,MAXRANGEINCREASE)
			back()
			return true
		end
		for i,fid in ipairs(id2range[cid].from) do
			if not been[fid] and not chosen[#route][fid] then
				chosen[#route][fid] = true
				tinsert(route,fid)
				been[fid] = true
				return true
			end
		end
		if cid == toId then
			return false
		else
			back()
			return true
		end
	end
	debug = 0
	while checknext() do
		debug = debug + 1
		if debug > 200 then
			print("debug get routes")
			break
		end
	end
  -- dump(routes)
	return routes
end

function M:ParseWaysFromRoutes(routes,datas,from,to)
	datas = datas or self:GetNavigateData()
	local allways = {}
	local ways = {}
	for _,route in ipairs(routes) do
		local pointpairs = {}
		for i,id in ipairs(route) do
			local data = datas[id]
			if data then
				if i ~= #route then
					local toid = route[i+1]
					local pp
					local ignore
					for ei,ed in ipairs(data.edges) do
						if ed.to == toid then
							local c = 1
							for j = ei+1,#data.edges do
								if data.edges[j].to == toid then
									c = c + 1
								else
									break
								end
							end
							local p = getCircleDatas(data.points,ei-1,3+c)
							local e = getCircleDatas(data.edges,ei-1,2+c)
							local v1 = self:GetMetaVector(p[1],p[2])
							local v2 = self:GetMetaVector(p[c+3],p[c+2])
							local ve = self:GetMetaVector(p[2],p[c+2])
							local lp,rp = {},{}
							if not e[1].to then
								local va = self:RotateVector(v1,math.pi/4)
								if i == 1 and self:Cross(ve,va) > 0 then
                  local vp = self:GetMetaVector(p[2],{self:GetPlayPosition()})
                  if self:Cross(vp,va) > 0 then
									  va = self:RotateVector(v1,-math.pi/4)
                  end
								end
								for j = 1,3 do
									rp[j] = p[2][j] + va[j]*PATHTOEDGE
								end
							else
								for j = 1,3 do
									rp[j] = p[2][j]
								end
							end
							if not e[2+c].to then
								local va = self:RotateVector(v2,-math.pi/4)
								if i == 1 and self:Cross(ve,va) > 0 then
                  local vp = self:GetMetaVector(p[c+2],{self:GetPlayPosition()})
                  if self:Cross(vp,va) < 0 then
									  va = self:RotateVector(v2,math.pi/4)
                  end
								end
								for j = 1,3 do
									lp[j] = p[c+2][j] + va[j]*PATHTOEDGE
								end
							else
								for j = 1,3 do
									lp[j] = p[c+2][j]
								end
							end
							pp = {lp,rp}
							if i == 1 and ed.jump then
								local d = self:GetDistanceToLine(lp,rp,from,true)
								-- print(d)
								if d<10 then
									pp.jump = d
								end
							end
							if i == #route - 1 then
								local newPoly = {p[2],rp,lp,p[c+2]}
								-- dump(newPoly)
								if self:IsPointInPoly(to,{points=newPoly}) then
									ignore = true
								end
							end
							break
						end
					end
					if not ignore then
						pointpairs[i] = pp or {}
					end
				end
			end
		end
		for i = 1,2^(#pointpairs) do
			local way = {from}
			for j = 1,#pointpairs do
				local pp = pointpairs[j]
				way[j+1] = bit.band(i-1,bit.lshift(1,j-1)) == 0 and pp[1] or pp[2]
			end
			way.route = route
			way.divides = pointpairs
			tinsert(way,to)
			tinsert(ways,way)
		end
	end
	return ways
end

function M:ParseWaysByRemoveUnnecessaryPoints(way)
	-- datas = datas or self:GetNavigateData()
	local divides = way.divides
	local	ways = {}
	for i = 1,2^#divides do
		local tw = {unpack(way)}
		local faild
		for j = 1,#divides do
			if bit.band(i-1,bit.lshift(1,j-1)) == 0 then
				tw[j+1] = nil
			end
		end
		for di,pp in ipairs(divides) do
			if not tw[di+1] then
				local prepoint,nextpoint
				for m = di,1,-1 do
					if tw[m] then
						prepoint = tw[m]
						break
					end
				end
				for m = di+2,#way do
					if tw[m] then
						nextpoint = tw[m]
						break
					end
				end
				local intersect,t,u = self:Intersect({prepoint,nextpoint},pp)
				if not intersect then
					faild = true
					break
				end
			end
		end

		if not faild then
			local rw = {}
			for j = 1,#way do
				if tw[j] then
					tinsert(rw,tw[j])
				end
			end
			if divides[1] and divides[1].jump then
				rw.jump = divides[1].jump
			end
			tinsert(ways,rw)
		end
	end
	return ways
end

function M:SortWays(ways)
	local minDistance, minDistanceWay
	local wayDatas = {}
	for i,way in ipairs(ways) do
		if not way.distance then
			local distance = 0
			for j = 2,#way do
				distance = distance + self:GetDistance(way[j],way[j-1])
			end
			way.distance = distance
		end
	end
	table.sort(ways,function(a,b)
		if a == nil or b == nil then
			return false
		end
		if a == b then
			return false
		end
		if a.distance == b.distance then
			if a.route and b.route then
				return #a.route<#b.route
			end
		end
		return a.distance<b.distance
	end)
	return ways
end

function M:GetNavigate(to,zone)
	local from = {AirjHack:Position(UnitGUID("player"))}
	to = to or {AirjHack:Position(UnitGUID("target"))}
	local datas = self:GetNavigateData(zone)
	local routes = self:GetPolyRoutes(from,to,datas)
	local way
	if routes then
		local ways = self:ParseWaysFromRoutes(routes,datas,from,to)
		self:SortWays(ways)
		local aws = {}
		for i,w in ipairs(ways) do
			if i > 6 then
				break
			end
			local ws = self:ParseWaysByRemoveUnnecessaryPoints(w)
			-- self:SortWays(ws)
			for i,v in ipairs(ws) do
				tinsert(aws,v)
			end
		end
		self:SortWays(aws)
		way = aws[1]
		-- if way.jump then
		-- 	print("jumping")
		-- end
		return way
		-- dump(ways)
	end

end

function M:Test()
	local zone -- = "test"
	local way = self:GetNavigate({AirjHack:Position(UnitGUID("target"))},zone)
	if way then
		self.cruiseName = "polyway"
		self:GetCruiseDB()[self.cruiseName] = way
		way.noloop = true
		self:DrawCruiseData()
		-- self.isCruise = true
	end
	self:DrawPolyDatas(zone)
	return way
end
