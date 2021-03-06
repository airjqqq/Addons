local ADDON_NAME="AVR"
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME, true)

local _G = _G
local sin = math.sin
local cos = math.cos
local pi = math.pi

local Core=AVR

local unpackDouble=AVRUnpackDouble
local packDouble=AVRPackDouble

AVRPolygonMesh={Embed=Core.Embed}
AVRPolygonMesh.meshInfo={
	class="AVRPolygonMesh",
	derived=false,
	guiCreateNew=true,
	guiName=L["Polygon"],
	receivable=true
}
function AVRPolygonMesh:New(line,outalpha,inalpha)
	if self ~= AVRPolygonMesh then return end
	local s=AVRMesh:New()
	AVRPolygonMesh:Embed(s)
	s.class=AVRPolygonMesh.meshInfo.class
	s.line=line or {{{-10,0,0},{10,0,0},{30,50,0},{0,60,0},{-30,50,0}}}
	s.oa=outalpha
	s.ia=inalpha
	s.vertices=nil
	s.name=L["Polygon"]
	return s
end

function AVRPolygonMesh:Pack()
	local s=AVRMesh.Pack(self)
	s.lin=self.line
	s.oa=self.oa
	s.ia=self.ia
	return s
end

function AVRPolygonMesh:Unpack(s)
	AVRMesh.Unpack(self,s)
	self.line=s.lin
	self.oa=s.oa
	self.ia=s.ia

	self.vertices=nil
end

function AVRPolygonMesh:SetLine(line)
	self.line=line
	self.vertices=nil
	return self
end
-- function AVRPolygonMesh:AddPoint(point)
-- 	tinsert(self.line,point)
-- 	self.vertices=nil
-- 	return self
-- end

function AVRPolygonMesh:GetOptions()
	local o=AVRMesh.GetOptions(self)
	o.args.polygon = {
		type = "group",
		name = L["Polygon"],
		inline = true,
		order = 80,
		args = {
			oa = {
				type = "range",
				name = L["Alpha"],
				order = 10,
				width = "full",
				min = 0, max=1, bigStep=0.02
			},
			ia = {
				type = "range",
				name = L["InsideAlpha"],
				order = 20,
				width = "full",
				min = 0, max=1, bigStep=0.02
			},
		}
	}
	return o
end


function AVRPolygonMesh:GenerateMesh()
	local lines=self.line
	for i,line in ipairs(lines) do
		if #line>=3 then
			if #line == 3 then
				self:AddTriangle(line[1][1],line[1][2],line[1][3],line[2][1],line[2][2],line[2][3],line[3][1],line[3][2],line[3][3])
			else
				local o = {0,0,0}
				for i,v in ipairs(line) do
					for j = 1,3 do
						o[j] = o[j]+v[j]
					end
				end
				for j = 1,3 do
					o[j] = o[j]/#line
				end
				local s = line[#line]
				for i=1,#line do
					local n = line[i]
					self:AddTriangle(o[1],o[2],o[3],s[1],s[2],s[3],n[1],n[2],n[3])
					s=n
				end
			end
		end
	end
	AVRMesh.GenerateMesh(self)
end

function AVRPolygonMesh:OnUpdate(threed)
	if self.vertices==nil or self.lines==nil or self.triangles==nil or self.textures==nil then
		self.vertices={}
		self.lines={}
		self.triangles={}
		self.textures={}
		self.icons={}
		self:GenerateMesh()
	end
	if self.oa or self.ia then
		local px,py,pz=threed.playerPosX,threed.playerPosY,threed.playerPosZ
		for i,line in pairs(self.line) do
			local s=line[#vs]
			local inside=false
			for i=1,#line do
				local e = line[i]
				if py>s[2] and py<=e[2] or py>e[2] and py<=s[2] then
					local l,r = (px-s[1])*(e[2]-s[2]),(py-s[2])*(e[1]-s[1])
					if e[2]>s[2] and l>r or e[2]<s[2] and l<r then
						inside = not inside
					end
				end
				s=e
			end
		end
		if inside then
			self.a=self.ia
		else
			self.a=self.oa
		end
	end
	local ux,uy,uz,uf
	self.visible=true
	if self.followPlayer then
		self.translateX,self.translateY,self.translateZ=threed.playerPosX,threed.playerPosY,threed.playerPosZ
		if not self.nofacing then
			self.rotateZ=threed.playerDirection
		else
			self.rotateZ = 0
		end
	elseif self.followUnit~=nil then
		ux,uy,uz,uf=threed:GetUnitPosition(self.followUnit)
		if not ux or ux==0.0 then
			self.visible=false
		else
			self.translateX,self.translateY,self.translateZ=ux,uy,uz--threed.playerPosZ
			if not self.nofacing then
				self.rotateZ=uf
			else
				self.rotateZ = 0
			end
		end
	else
		self.translateX,self.translateY,self.translateZ=0.0,0.0,0.0
	end
	self.scaleX,self.scaleY,self.scaleZ=1.0,1.0,1.0
end

AVR:RegisterMeshClass(AVRPolygonMesh)
