
local ADDON_NAME="AVR"
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME, true)

local _G = _G

local Core=AVR

local unpackDouble=AVRUnpackDouble
local packDouble=AVRPackDouble

AVRTextMesh={Embed=Core.Embed}
AVRTextMesh.meshInfo={
	class="AVRTextMesh",
	derived=false,
	guiCreateNew=true,
	guiName=L["Text"],
	receivable=true
}
function AVRTextMesh:New(text,size)
	if self ~= AVRTextMesh then return end
	local s=AVRMesh:New()
	AVRTextMesh:Embed(s)
	s.class=AVRTextMesh.meshInfo.class
	s.vertices=nil
	s.name=L["Text"]
	s.text = text or "test"
	s.size = size or 1
	s.duration=10
	return s
end

function AVRTextMesh:Pack()
	local s=AVRMesh.Pack(self)
	return s
end

function AVRTextMesh:Unpack(s)
	AVRMesh.Unpack(self,s)
	self.vertices=nil
end

function AVRTextMesh:SetText(text)
	self.text=text
	self.vertices=nil
	return self
end
function AVRTextMesh:SetSize(size)
	self.size=size
	self.vertices=nil
	return self
end


function AVRTextMesh:GetOptions()
	local o=AVRMesh.GetOptions(self)
	o.args.unit = {
		type = "group",
		name = L["Text"],
		inline = true,
		order = 80,
		args = {
			text = {
				type = "input",
				name = L["Text"],
				order = 10,
				width = "full",
			},
			size = {
				type = "range",
				name = L["Size"],
				order = 50,
				width = "full",
				min = 0, max=10, bigStep=0.1
			},
		}
	}
	return o
end


function AVRTextMesh:GenerateMesh()
	--(x1,y1,z1,text,size,ox,oy,a,r,g,b)
	self:AddText(0,0,0,self.text,self.size*600,0,0,1,self.r,self.g,self.b)
	AVRMesh.GenerateMesh(self)
end

AVR:RegisterMeshClass(AVRTextMesh)
