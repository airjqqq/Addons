AirjUtil = LibStub("AceAddon-3.0"):NewAddon("AirjUtil")

AirjUtil.FIFO = {
	flush = function(self)
		local maxsize = self._maxSize
		wipe(self)
		self._currentindex = 1
		self._size = 0
		self._maxSize = maxsize
		self._index = {}
	end,
	set = function(self,value,key)
		assert(key)
		local index = self._index[key]
		if not index then
			self:push(value,key)
		else
			local data = {key = key, value = value }
			rawset(self,index,data)
		end
	end,
	push = function(self,value,key)
		local data = {key = key, value = value }
		local old = rawget(self,self._currentindex)
		if old then
			local ok = old.key
			if ok then
				self._index[ok] = nil
			end
		end
		rawset(self,self._currentindex,data)
		if key ~= nil then
			local oi = self._index[key]
			if oi then
				rawset(self,oi,nil)
			end
			self._index[key] = self._currentindex
		end
		self._currentindex = self._currentindex + 1
		if self._currentindex>self._maxSize then
			self._currentindex = 1
		end
		if self._size < self._maxSize  then
			self._size = self._size+1
		end
	end,
	geti = function(self,key)
		-- assert(type(key)=="number" and key>0 and key<=self._maxSize)
		key = key or 1
		if key<=0 or key>self._size then return end
		local key = self._currentindex - key
		while key<=0 do
			key = key + self._maxSize
		end
		local value = rawget(self,key)
		if not value then return end
		return value.value, value.key, key
	end,
	get = function(self,key)
		local i = self._index[key]
		if i then
			local data = self[i]
			if data then
				return data.value,key,i
			end
		end
	end,
	find = function(self,key,start)
		start = start or 1
		for i = start,self._size do
			local dv,dk = self:geti(i)
			if dv then
				local match = true
				for k,v in pairs(key) do
					if dv[k] == v or v=="nil" and dv[k] == nil then
					elseif type(v) == "table" then
						local vmatch
						for i,vv in ipairs(v) do
							if dv[k] == vv or vv == "nil" and dv[k] == nil then
								vmatch = true
								break
							end
						end
						if not vmatch then
							match = false
							break
						end
					else
						match = false
						break
					end
				end
				if match then
					return dv,dk,i
				end
			end
		end
	end,
	iterator = function(self,key,start)
		key = key or {}
		start = start or 1
		return function()
			local v,k,i = self:find(key,start)
			if i then
				start = i + 1
				return v,k,i
			end
		end
	end
}
local fifoMetatable = {
	__index = function(t,k)
		return AirjUtil.FIFO[k] or t:find(k)
	end,
	__len = function(t)
		return rawget(t,"_size")
	end,
}

function AirjUtil:NewFIFO(size)
	assert(size>0)
	return setmetatable({_currentindex = 1, _size = 0, _maxSize = size, _index = {}},fifoMetatable)
end

function AirjUtil:IsFIFO (t)
	return getmetatable(t) == fifoMetatable
end

function AirjUtil:DeepCopy(table)
	if type(table) == "table" then
		local toRet = {}
		for k,v in pairs(table) do
			toRet[k] = self:DeepCopy(v)
		end
		return toRet
	else
		return table
	end
end
-- supper support
local random = math.random
function AirjUtil:UUID()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end


local function supper(t,k)
	if t._suppers then
		local key = "_supperTimes" .. k
		local start = (rawget(t,key) or 0)+1
		for i = start,#t._suppers do
			local v = t._suppers[i]
			if v[k] then
				return v[k],i
			end
		end
	end
end

local classMetaTable = {
	__index = supper,
	__call = function(t,...)
		return t:New(...)
	end,
}
local classes = {}
local Object = {
	New = function(self,data)
		if self._id then
			error("Instance Can't Call New")
		end
		obj = setmetatable({},self)
		if data then
			obj._data = AirjUtil:DeepCopy(data)
		end
		obj._id = AirjUtil:UUID()
		obj._class = self._class
		return obj
	end,
	GetClass = function(self)
		local name = self._class
		return classes[name]
	end,
	Supper = function(self,k,...)
		local s,i = supper(self,k)
		if type(s) == "function" then
			local key = "_supperTimes" .. k
			rawset(self,key,i)
			local r = {s(self,...)}
			rawset(self,key,nil)
			return unpack(r,1,10)
		end
		return s
	end,
	Set = function(self,k,v)
		if self._data then
			self._data[k] = v
		end
	end,
	Get = function(self,k)
		local v = self._data and self._data[k]
		return v
	end,
}
function AirjUtil:Class(name,parent)
	if classes[name] then
		-- error("Already Exists")
		return classes[name]
	end
	local obj = setmetatable({},classMetaTable)
	if parent then
		obj._suppers = {parent,unpack(parent._suppers)}
	else
		obj._suppers = {Object}
	end
	obj.__index = obj
	obj._class = name
	classes[name] = obj
	return obj
end
