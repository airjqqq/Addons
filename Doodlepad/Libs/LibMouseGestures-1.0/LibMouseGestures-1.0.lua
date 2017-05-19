--- **LibMouseGestures-1.0** Is a library for tracking and using mouse gestures
-- @class file
-- @name LibMouseGestures-1.0

--[[ LibMouseGestures-1.0

Revision: $Rev: 32 $
Author(s): Humbedooh
Description: Mouse gesture tracker
Dependencies: LibStub
License: MIT License

]]

local tinsert,tremove,pow,sqrt,atan2,abs,floor,min,max,deg = table.insert, table.remove,math.pow,math.sqrt,math.atan2,math.abs,math.floor,math.min,math.max,math.deg;
local LIBMG = "LibMouseGestures-1.0"
local LIBMG_MINOR = tonumber(("$Rev: 32 $"):match("(%d+)")) or 10001;
if not LibStub then error(LIBMG .. " requires LibStub.") end
local LibMouseGestures = LibStub:NewLibrary(LIBMG, LIBMG_MINOR)
if not LibMouseGestures then return end

local tableCache = setmetatable({}, {__mode = "k"})
local function newTable(...)
	local tbl = table.remove(tableCache)
	if type(tbl) == "table" then
		wipe(tbl)
	else
		tbl = {}
	end
	for i = 1, select("#", ...) do
		tbl[i] = select(i, ...)
	end
	return tbl
end

local function delTable(tbl)
	if type(tbl) ~= "table" then return end
	tableCache[tbl] = true
end

local movementsCache = setmetatable({}, {__mode="k"})
local function newMovements()
	local tbl = table.remove(movementsCache)
	if type(tbl) == "table" then
		wipe(tbl)
	else
		tbl = newTable()
	end
	return tbl
end

local function delMovements(tbl)
	if type(tbl) ~= "table" then return end
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			for k2, v2 in pairs(v) do
				delTable(v2)
			end
			delTable(v)
		end
	end
	movementsCache[tbl] = true
end

local function delMG(mg)
	if type(mg) ~= "table" then return end
	delTable(mg.mouseStart)
	delTable(mg.mouseEnd)
	delMovements(mg.movements)
end

local frameCache = {}
local function newFrame(frame)
	if type(frame) == "table" and frame.Show then
		local MGframe = frameCache[frame] and tremove(frameCache[frame]) or CreateFrame("Frame", frame)
		MGframe.MGdrawFrame = frame
		return MGframe
	end
end

local function delFrame(MGFrame)
	if not MGFrame or not MGFrame.MGdrawFrame then return end
	frameCache[MGFrame.MGdrawFrame] = frameCache[MGFrame.MGdrawFrame] or {}
	tinsert(frameCache[MGFrame.MGdrawFrame], MGFrame)
end

function LibMouseGestures:Setup(object)
	object.Update = LibMouseGestures.Update;
	object.UserInputReceived = LibMouseGestures.UserInputReceived;
	object.StartCapture = LibMouseGestures.StartCapture;
	object.Stop = LibMouseGestures.Stop
	object.GetBounds = LibMouseGestures.GetBounds;
	object.GetGist = LibMouseGestures.GetGist;
	object.GetMovementBounds = LibMouseGestures.GetMovementBounds;
	object.DrawTrail = LibMouseGestures.DrawTrail;
	object.isRecording = false;
	object.mouseStart = newTable(0,0);
	object.mouseEnd = newTable(0,0);
	object.movements = newMovements();
	object.lastGist = 0;
	return object;
end

function LibMouseGestures:New(frame, optMG)
	if ( type(frame) == "table" and frame.Show ) then
		optMG = optMG or newTable()
		delMG(optMG)
		wipe(optMG)
		local MG = LibMouseGestures:Setup(optMG);
		MG.drawLayer = newFrame(frame) --CreateFrame("Frame", frame);
		MG.drawLayer:SetParent(frame);
		MG.drawLayer:SetAllPoints(frame);
		MG.drawLayer:EnableMouse();
		MG.drawLayer:SetScript("OnMouseDown", function(caller,event) MG:UserInputReceived(event,"Down") end);
		MG.drawLayer:SetScript("OnMouseUp", function(caller,event) MG:UserInputReceived(event,"Up") end);
		MG.drawLayer:SetScript("OnUpdate", function(caller,event) MG:Update() end);
		MG.drawLayer:Hide(); -- Initially hidden
		MG.drawLayer.trails = {};
		return MG;
	else
		error(LIBMG .. ": Usage: LibMG:New(target_frame).");
	end
end

function LibMouseGestures:StartCapture(script)
	local MG = self;
	if ( type(script) ~= "table" ) then return; end
	MG.CaptureScript = script;
	for n = 1, #(MG.drawLayer.trails) do
		MG.drawLayer.trails[n]:Hide();
	end
	delMovements(MG.movements)
	MG.movements = newMovements();
	if ( not (script.startButton == "Freehand") ) then
		MG.isRecording = false;
		MG.drawLayer:SetFrameLevel(9999);
		MG.drawLayer:Raise();
		MG.drawLayer:Show();
		MG.drawLayer:SetAllPoints();
		MG.drawLayer:EnableMouse(true);
	else
		MG.drawLayer:SetPoint("TOPLEFT",UIParent, "TOPLEFT", 1,1);
		MG.drawLayer:SetPoint("BOTTOMRIGHT",UIParent, "TOPLEFT", 1,1);
		MG.isRecording = true;
		MG.numGestures = 0;
		MG.drawLayer:Show();
	end
end

function LibMouseGestures:Stop()
	self.drawLayer:SetScript("OnMouseDown", nil)
	self.drawLayer:SetScript("OnMouseUp", nil)
	self.drawLayer:SetScript("OnUpdate", nil)
	self.drawLayer:EnableMouse(false)
	self.drawLayer:ClearAllPoints()
	self.drawLayer:SetParent(nil)
	self.drawLayer:Hide()
end

function LibMouseGestures:Update()
	if ( type(self.CaptureScript) ~= "table" ) then return; end
	local MG = self;
	local script = MG.CaptureScript;
	local scale = UIParent:GetEffectiveScale();
	local cursorX, cursorY = GetCursorPosition();
	delTable(MG.mouseEnd)
	MG.mouseEnd = newTable( (cursorX - (MG.drawLayer:GetLeft()*scale))/scale, ((MG.drawLayer:GetTop()*scale) - cursorY)/scale );
	if ( MG.isRecording ) then
		if ( script.startButton == "Freehand" ) then
			local last = MG.movements[#MG.movements] or newTable(0,0);
			if ( last[1] ~= MG.mouseEnd[1] and last[2] ~= MG.mouseEnd[2] ) then
				if (sqrt( pow(last[1]-MG.mouseEnd[1],2) + pow(last[2]-MG.mouseEnd[2],2)) > 2) then
					tinsert(MG.movements, MG.mouseEnd );
					local gists = self:GetGist();
					if ( #gists ~= MG.numGestures ) then MG.numGestures = #gists; MG.lastGesture = GetTime(); end
					if ( script.maxGestures and #gists >= script.maxGestures ) then
						self:UserInputReceived("STOP", "");
					end
				end
			end
			if ( not script.maxGestures and MG.lastGesture and (GetTime() - MG.lastGesture) > 0.67 ) then
				self:UserInputReceived("STOP", "");
			end
			if ( script.showTrail ) then
				self:DrawTrail();
			end
		else
			if ( MG.drawLayer:IsMouseOver() ) then
				local last = MG.movements[#MG.movements] or newTable(-1,-1);
				if ( last[1] ~= MG.mouseEnd[1] and last[2] ~= MG.mouseEnd[2] ) then
					local d = sqrt( pow(last[1]-MG.mouseEnd[1],2) + pow(last[2]-MG.mouseEnd[2],2));
					if (d > 3) then tinsert(MG.movements, MG.mouseEnd ); end
				end
				if ( type(script.updateFunc) == "function" ) then
					script.updateFunc(MG, MG.mouseStart[1], MG.mouseStart[2], MG.mouseEnd[1], MG.mouseEnd[2]);
				end
				if ( script.showTrail ) then
					self:DrawTrail();
				end
			end
		end
	end
	if ( script.tooltip ) then
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(MG.drawLayer, "ANCHOR_TOPLEFT", MG.mouseEnd[1]+32, -MG.mouseEnd[2]-48);
		if ( type(script.tooltip) == "string" ) then
			GameTooltip:SetText(script.tooltip);
		elseif (type(script.tooltip) == "table") then
			GameTooltip:SetText(script.tooltip[1]);
			for n = 2, #script.tooltip do
				GameTooltip:AddLine(script.tooltip[n]);
			end
		end
		GameTooltip:Show();
	end
end


function LibMouseGestures:UserInputReceived(button,action)
	local MG = self;
	local script = MG.CaptureScript or {}; -- user provided; don't recycle
	if ( type(script) ~= "table" ) then return; end
	if ( not MG.isRecording ) then
		if ( script.startButton == (button .. action) ) then
			MG.isRecording = true;
			MG.mouseStart =  {MG.mouseEnd[1], MG.mouseEnd[2] };
			if ( type(script.startFunc) == "function" ) then
				script.startFunc(MG, MG.mouseStart[1], MG.mouseStart[2], MG.mouseEnd[1], MG.mouseEnd[2]);
			end
		elseif ( script.cancelButton == (button .. action) ) then
			MG.isRecording = false;
			MG.CaptureScript = nil;
			if ( script.tooltip ) then GameTooltip:Hide(); end
			MG.drawLayer:Hide();
			if ( type(script.cancelFunc) == "function" ) then
				script.cancelFunc(MG, MG.mouseStart[1], MG.mouseStart[2], MG.mouseEnd[1], MG.mouseEnd[2]);
			end
			script = nil;
			delMovements(MG.movements)
			MG.movements = newMovements()
		end
	else
		if ( script.stopButton == (button .. action) or button == "STOP" ) then
			MG.isRecording = false;
			MG._CaptureScript = MG.CaptureScript;
			MG.CaptureScript = nil;
			if ( script.tooltip ) then GameTooltip:Hide(); end
			MG.drawLayer:Hide();
			if ( type(script.stopFunc) == "function" ) then
				script.stopFunc(MG, MG.mouseStart[1], MG.mouseStart[2], MG.mouseEnd[1], MG.mouseEnd[2]);
			end
			delMovements(MG.movements)
			MG.movements = newMovements();
			script = nil;
		elseif ( script.cancelButton == (button .. action) ) then
			MG.isRecording = false;
			MG.CaptureScript = nil;
			if ( script.tooltip ) then GameTooltip:Hide(); end
			MG.drawLayer:Hide();
			if ( type(script.cancelFunc) == "function" ) then
				script.cancelFunc(MG, MG.mouseStart[1], MG.mouseStart[2], MG.mouseEnd[1], MG.mouseEnd[2]);
			end
			delMovements(MG.movements)
			MG.movements = newMovements();
			script = nil;
		elseif ( script.nextButton == (button .. action) ) then
			MG.mouseStart = { MG.mouseEnd[1], MG.mouseEnd[2]};
			if ( type(script.nextFunc) == "function" ) then
				script.nextFunc(MG, MG.mouseStart[1], MG.mouseStart[2], MG.mouseEnd[1], MG.mouseEnd[2]);
			end
			delMovements(MG.movements);
			MG.movements = newMovements();
		end
	end
end


function LibMouseGestures:GetBounds(shiftModifier)
	local MG = self;
	local sx,sy,ex,ey = MG.mouseStart[1], MG.mouseStart[2], MG.mouseEnd[1], MG.mouseEnd[2];
	local dx,dy = abs(sx-ex), abs(sy-ey);
	if ( dx < 5 ) then dx = 5; end
	if ( dy < 5 ) then dy = 5; end
	local a,b = min(sx,ex), min(sy,ey);
	if (shiftModifier and IsShiftKeyDown() ) then
		dx,dy = min(dx,dy), min(dx,dy);
	end
	return a,b,dx,dy;
end

function LibMouseGestures:GetMovementBounds()
	local MG = self;
	local mov = MG.movements;
	local a,b,c,d = nil,nil,nil,nil;
	for n = 1, #mov do
		local pos = mov[n];
		if ( a == nil ) then
			a,b,c,d = pos[1],pos[2],pos[1],pos[2];
		end
		if ( a > pos[1] ) then a = pos[1]; end
		if ( c < pos[1] ) then c = pos[1]; end
		if ( b > pos[2] ) then b = pos[2]; end
		if ( d < pos[2] ) then d = pos[2]; end
	end
	return a,b,c,d;
end

local dirs = {
	{'right', 0},
	{'left', 180},
	{'up', 90},
	{'down',  270},
	{'right-up', 45},
	{'left-up', 135},
	{'right-down', 315},
	{'left-down', 225}
}

function LibMouseGestures:GetGist(tbl)
	local gists = tbl or {};
	wipe(gists)
	local clockdir = 0;
	local md = 40; -- minimum travel distance before we consider a direction as being a gesture.
	local MG = self;
	local mov = MG.movements;
	local sx,sy,ex,ey = MG.mouseStart[1], MG.mouseStart[2], MG.mouseEnd[1], MG.mouseEnd[2];
	local pangle = nil;
	local diff = {};
	if ( #mov > 1 ) then
		local ppos = mov[1];
		local pin = 1;
		for n = 2, #mov do
			local cpos = mov[n];
			local dist = sqrt(pow(ppos[1] - cpos[1],2) + pow(ppos[2]-cpos[2], 2));
			if ( dist > md ) then
				local mpos = mov[pin + floor(((n-pin) / 2) + 0.5)]; -- half the distance
				local angle = floor( (deg(atan2(ppos[2] - cpos[2], cpos[1] - ppos[1])) / 45) + 0.5 ) * 45;     -- total arc angle
				local fh_angle = floor( (deg(atan2(mpos[2] - ppos[2], mpos[1] - ppos[1])) / 45) + 0.5 ) * 45;  -- first half-angle
				local sh_angle = floor( (deg(atan2(cpos[2] - mpos[2], cpos[1] - mpos[1])) / 45) + 0.5 ) * 45;  -- second half angle
				if ( angle < 0 ) then angle = angle + 360; end
				if ( mpos == cpos or mpos == ppos ) then sh_angle = fh_angle; end -- hack for tracking very fast circular movements
				-- if the current direction differs from the previous and it's consistent (fh==sh), then...
				if ( pangle == nil or ( math.abs(pangle-angle) > 40 and ( fh_angle == sh_angle) ) ) then
					tdir = nil;
					for i = 1, #dirs do if ( angle == dirs[i][2] ) then tdir = dirs[i][1]; break; end end
					if ( tdir ) then tinsert(gists, {"line", tdir}); end
					local tangle = angle;
					if ( pangle and (pangle > tangle) ) then clockdir = clockdir + 2; elseif (pangle) then clockdir = clockdir - 1; end
					local found = false;
					for i = 1, #diff do if ( diff[i] == tangle ) then found = true; break; end end
					if ( not found ) then tinsert(diff, tangle); end
					--print("Moved in angle:", tdir, tangle, cpos[2] - ppos[2], cpos[1] - ppos[1]);
					pangle = angle;
				end
				delTable(ppos)
				ppos = newTable(cpos[1],cpos[2]);
				pin = n;
			end
		end
	end
	if ( #diff > 4 ) then -- If the mouse moves in move than 4 uniquely different directions, we'll assume it's a circle.
		if ( clockdir > 0 ) then gists = { {'circle', 'clockwise'} } else gists = {{'circle', 'counterclockwise'}} end
	end
	return gists;
end

function LibMouseGestures:DrawTrail()
	local MG = self;
	local C = MG.drawLayer;
	local mov = MG.movements;
	for n = 1, 15 do
		local pos = mov[#mov-15+n];
		if ( pos ) then
			MG.drawLayer.trails[n] = C.trails[n] or C:CreateTexture();
			local T = C.trails[n];
			T:SetParent(C);
			T:SetTexture(0,1,0,0.65);
			local size = 1 + (n/3);
			T:SetPoint("TOPLEFT", pos[1] - size, -pos[2] + size);
			T:SetWidth(size);
			T:SetHeight(size);
			T:Show();
		end
	end
end

_G.SLASH_MGTEST1 = '/mgtest';
(SlashCmdList or {})['MGTEST'] = function()
	print("LibMouseGestures recording test is active. Make a gesture by moving your mouse.");
	local rec = LibMouseGestures:New(UIParent);
	rec:StartCapture({
	startButton		= "Freehand",
	stopButton		= "LeftButtonUp",
	cancelButton    = "RightButtonDown",
	showTrail 		= true,
	stopFunc		= function(rec)
		local g = rec:GetGist();
		print("The results are in:");
		if ( #g ) then
			for n = 1, #g do
				local t = ("You drew a %s (%s)"):format(g[n][1], g[n][2]);
				print(t);
				UIErrorsFrame:AddMessage(t)
			end
		else
			print("You didn't make any recognizable gestures.");
		end
	end,
});
end
