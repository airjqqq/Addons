local ADDON_NAME="AVR"
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME, true)

local _G = _G
local sin = math.sin
local cos = math.cos
local pi = math.pi

local Core=AVR

local unpackDouble=AVRUnpackDouble
local packDouble=AVRPackDouble

AVRUnitMesh={Embed=Core.Embed}
AVRUnitMesh.meshInfo={
	class="AVRUnitMesh",
	derived=false,
	guiCreateNew=true,
	guiName=L["Unit"],
	receivable=true
}
function AVRUnitMesh:New(unit,spellId,radius)
	if self ~= AVRUnitMesh then return end
	local s=AVRMesh:New()
	AVRUnitMesh:Embed(s)
	s.class=AVRUnitMesh.meshInfo.class
	s.followUnit=unit or "player"
	s.followRotation = true
	s.spellId=spellId
	s.radius=radius or 5
	s.vertices=nil
	s.name=L["Unit"]
	s.duration=10
	s.expiration=GetTime()+10
	s.removeOnExpire=true
	s.r,s.g,s.b,s.a=1,1,1,0.1
	s.r2,s.g2,s.b2,s.a2=1,1,1,0.2
	return s
end

function AVRUnitMesh:Pack()
	local s=AVRMesh.Pack(self)
	-- s.uni=self.unit
	s.sid=self.spellId
	s.rad=self.radius
	s.dur=packDouble(self.duration)
	s.exp=packDouble(self.expiration)
	s.roe=self.removeOnExpire
	s.r2=packDouble(self.r2)
	s.g2=packDouble(self.g2)
	s.b2=packDouble(self.b2)
	s.a2=packDouble(self.a2)
	return s
end

function AVRUnitMesh:Unpack(s)
	AVRMesh.Unpack(self,s)
	-- self.unit=s.uni
	self.spellId=s.sid
	self.radius=s.rad

	self.duration=unpackDouble(s.dur) or 10
	self.expiration=unpackDouble(s.exp) or GetTime()+self.duration
	if s.roe~=nil then self.removeOnExpire=s.roe
	else self.removeOnExpire=false end
	self.r2=unpackDouble(s.r2) or 1.0
	self.g2=unpackDouble(s.g2) or 1.0
	self.b2=unpackDouble(s.b2) or 1.0
	self.a2=unpackDouble(s.a2) or 0.5

	self.vertices=nil
end

function AVRUnitMesh:SetTimer(duration, expiration)
	self.duration=duration
	self.expiration=expiration or GetTime()+duration
	self.vertices=nil
end

function AVRUnitMesh:SetColor2(r,g,b,a)
	if r~=nil then self.r2=r end
	if g~=nil then self.g2=g end
	if b~=nil then self.b2=b end
	if a~=nil then self.a2=a end
	self.vertices=nil
	return self
end

function AVRUnitMesh:SetRemoveOnExpire(value)
	self.removeOnExpire=value
	if value and self.expiration==nil then
		self:Remove()
	end
end

function AVRUnitMesh:SetRadius(radius)
	self.radius=radius
	self.vertices=nil
	return self
end

function AVRUnitMesh:SetSpellId(spellId)
	self.spellId=spellId
	self.vertices=nil
	return self
end

function AVRUnitMesh:GetOptions()
	local o=AVRMesh.GetOptions(self)
	o.args.unit = {
		type = "group",
		name = L["Unit"],
		inline = true,
		order = 80,
		args = {
			spellId = {
				type = "input",
				name = L["SpellId"],
				order = 10,
				width = "full",
			},
			radius = {
				type = "range",
				name = L["Radius"],
				order = 20,
				width = "full",
				min = 1, max=40, bigStep=0.5
			},
			removeOnExpire = {
				type = "toggle",
				name = L["RemoveOnExpire"],
				order = 30,
				width = "full",
			},
			color2 = {
				type = "color",
				name = L["Color"],
				order = 40,
				hasAlpha = true,
				width = "full",
				get = 	function(info)
							return self.r2,self.g2,self.b2,self.a2
						end,
				set =	function(info,r,g,b,a)
							self:SetColor2(r,g,b,a)
						end,
			},
			duration = {
				type = "range",
				name = L["Duration"],
				order = 50,
				width = "full",
				min = 1, max=40, bigStep=0.5
			},
		}
	}
	return o
end


function AVRUnitMesh:GenerateMesh()
	self.sectors = {}
	local radius = self.radius
	local lx,ly = 0,radius
	local snumber = 40
	for i=1,snumber do
		local x,y = radius*sin(i*pi*2/snumber),radius*cos(i*pi*2/snumber)
		self.sectors[i] = self:AddTriangle(0,0,0,lx,ly,0,x,y,0)
		lx,ly = x,y
	end

	self.timeV=self:AddVertex(0,0,0)
	self.timeT1=AVRTriangle:New(1,0,self.timeV)
	self.timeT2=AVRTriangle:New(1,self.timeV,0)
	self.timeV=self.vertices[self.timeV]
	self.timeT2.r=self.r2
	self.timeT2.g=self.g2
	self.timeT2.b=self.b2
	self.timeT2.a=self.a2
	self.timeT1.visible=false
	self.timeT2.visible=false
	self:AddTriangle(self.timeT1)
	self:AddTriangle(self.timeT2)

	local ca=cos(self.meshRotateZ)
	local sa=sin(self.meshRotateZ)
	self.MA,self.MB,self.MC,self.MD=
		ca*self.meshScaleX,-sa*self.meshScaleY,
		sa*self.meshScaleX, ca*self.meshScaleY



	local spellName,_,texture = GetSpellInfo(self.spellId)
	if texture then
		local t=self:AddIcon( 0,0,5,texture,1200,nil,nil,0.8,1,1,1)
	end
	local guid = self.followUnit and UnitGUID(self.followUnit) or self.followUnit or self.followPlayer and UnitGUID("player")
	local class, classFilename, race, raceFilename, sex, name, realm
	if guid then
		class, classFilename, race, raceFilename, sex, name, realm = GetPlayerInfoByGUID(guid)
	end
	local textc = {1,1,1}
	if classFilename then
		textc=RAID_CLASS_COLORS[classFilename]
	end
	local text1 = self:AddText(0,0,5,name or spellName,600,nil,-400,0.8,textc.r,textc.g,textc.b)


	self.expiration=GetTime()+10
	self.duration=10
	AVRMesh.GenerateMesh(self)
end

function AVRUnitMesh:OnUpdate(threed)
	if self.expiration~=nil or self.vertices==nil then
		if self.vertices==nil or self.lines==nil or self.triangles==nil or self.textures==nil then
			self.vertices={}
			self.lines={}
			self.triangles={}
			self.textures={}
			self.icons={}
			self.texts={}
			self:GenerateMesh()
		end

		local t=GetTime()
		local tri

		local sectors = self.sectors
		if self.expiration==nil or t>=self.expiration then
			if self.removeOnExpire then
				self.visible=false
				self:Remove()
				return
			end
			for i=1,#sectors do
				tri=sectors[i]
				tri.r=nil
				tri.g=nil
				tri.b=nil
				tri.a=nil
				tri.visible=true
			end
			self.timeT1.visible=false
			self.timeT2.visible=false
			self.expiration=nil
		elseif t>=self.expiration-self.duration then
			local d=(t-self.expiration+self.duration)/self.duration

			local s=floor(d*#sectors+1)
			for i=1,#sectors do
				tri=sectors[i]
				if i<s then
					tri.r=nil
					tri.g=nil
					tri.b=nil
					tri.a=nil
					tri.visible=true
				elseif i==s then
					tri.visible=false
				else
					tri.r=self.r2
					tri.g=self.g2
					tri.b=self.b2
					tri.a=self.a2
					tri.visible=true
				end
			end

			local x=sin(d*2*pi)*self.radius
			local y=cos(d*2*pi)*self.radius

			local v=self.timeV

			v[1],v[2]=self.MA*x+self.MB*y+self.meshTranslateX,
					self.MC*x+self.MD*y+self.meshTranslateY
			tri=sectors[s]
			self.timeT1.v2=tri.v2
			self.timeT2.v3=tri.v3
			self.timeT1.visible=true
			self.timeT2.visible=true

		end
	end

	AVRMesh.OnUpdate(self,threed)
end

AVR:RegisterMeshClass(AVRUnitMesh)