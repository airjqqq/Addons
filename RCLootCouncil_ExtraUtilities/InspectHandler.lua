--[[--- InspectHandler.lua by Potdisc
   Handles inspects based on unitIDs and provides callback when data is available.

   Supported inspects:
      gear     Returns a table containing itemlinks of the player's gear
      spec     Returns the specID
]]
local addon = LibStub("AceAddon-3.0"):GetAddon("RCLootCouncil")
local module = addon:GetModule("RCExtraUtilities")

module.InspectHandler = {}

local callback -- The callback function
local pool = { size = 0} -- Inspect pool
local isInspecting = false
local inspectIndex = 1
local cache = {}

--[[
]]

-- Local functions:
local function FireCallback(data, guid, unit, get)
   if not (unit and get) and guid then
      unit, get = pool[guid].unit, pool[guid].type
   end
   if type(callback) == "function" then
      callback(unit, get, data)
   else
      module[callback](module, unit, get, data)
   end
   return true
end

local function addToPool(guid, unit, name, type)
   pool[guid] = {unit = unit, name = name, type = type}
   pool.size = pool.size + 1
end

local function removeFromPool(guid)
   if guid then
      pool[guid] = nil
      pool.size = pool.size - 1
   end
end

local function AddToCache(unit, type, data)
   if not cache[unit] then cache[unit] = {} end
   cache[unit][type] = {
      data = data,
      time = time()
   }
end

local function CheckCache(unit, type)
   if cache[unit] and cache[unit][type] then
      if time() - cache[unit][type].time > 600 then -- Data outdates after 10 mins
         addon:DebugLog("InspectHandler()", "Outdated:", unit, type) -- TODO Not really needed
         cache[unit][type] = nil
         return nil
      else
         return cache[unit][type].data
      end
   end
end

--- Pools next inspect
-- arg guid The guid of the unit we just InspectReady
local function PoolNextInspect(guid)
   -- Stop inspecting
   ClearInspectPlayer()
   -- Setup the next inspect, if any
   --tremove(pool, inspectIndex)
   --inspectIndex = #pool
   removeFromPool(guid)
   if pool.size > 0 then -- We have more
      for k in pairs(pool) do
         if k ~= "size" then
            return NotifyInspect(pool[k].name)
         end
      end
   else
      isInspecting = false
   end
end

--- Sets the callback function
-- Acts like the init for the InspectHandler
-- func is called whenever the inspect data is available - can be either funcref or a method of the module
-- The callback is called with args: unit, type, data
function module.InspectHandler:SetCallback(func)
   if not func or (type(func) ~= "function" and type(func) ~= "string") then error("InspectHandler:SetCallback(func): func wasn't a function reference.") end
   module:RegisterEvent("INSPECT_READY", module.InspectHandler.INSPECT_READY)
   callback = func
end

--- Queues an inspect
-- The provided callback function (@see InspectHandler:SetCallback()) is called once the data is available
-- @param unit The unitid to inspect. Function will just return false if invalid
-- @param inspectType The type of the requested inspect. See top of file for supported types
-- @param forceUpdate boolean, true to ignore cached data.
-- @return True if the inspect was pooled i.e. it's currently possible, otherwise false.
function module.InspectHandler:InspectUnit(unit, inspectType, forceUpdate)
   if not callback then error("InspectHandler:InspectUnit(unit,inspectType): Callback not set.") end
   if not unit or type(unit) ~= "string" then error("InspectHandler:InspectUnit(unit,inspectType): unit is invalid.") end
   inspectType = inspectType and inspectType or "spec" -- default to spec

   local name = Ambiguate(unit, "none")
   local guid = UnitGUID(name)
   addon:Debug("Inspect!", unit, name, guid, CanInspect(name), CheckInteractDistance(name, 1))
   if CanInspect(name) and CheckInteractDistance(name, 1) then
      if inspectType == "gear" then
         -- REVIEW: Should we verify the gear is actually here?
         local check = not forceUpdate and CheckCache(unit, "gear")
         if check then return FireCallback(check, guid, unit, "gear") end
         addToPool(guid, unit, name, inspectType)
         -- Should be able to pull it immediately
         local data = {}
         for i = 1, 17 do
            if i ~= 4 then -- skip the shirt
               local link = GetInventoryItemLink(unit, i)
               tinsert(data, link)
            end
         end
         AddToCache(unit, "gear", data)
         FireCallback(data, guid)
         PoolNextInspect(guid) -- Somewhat of a hack, but should work

      elseif inspectType == "spec" then--[[
         if UnitIsUnit(name, "player") then
            local spec = (GetSpecializationInfo(GetSpecialization()))
            AddToCache(unit, "spec", spec)
            FireCallback(spec, unit, "spec")
            return true
         end]]
         --tinsert(pool, {unit = unit, type = inspectType})
         local check = not forceUpdate and CheckCache(unit, "spec")
         if check then return FireCallback(check, guid, unit, "spec") end
         -- Should be available after "INSPECT_READY" event
         addToPool(guid, unit, name, inspectType)
         if not isInspecting then -- Only inspect one unit at a time
            isInspecting = true
            --inspectIndex = #pool
            NotifyInspect(name)
         end
      else
         return error("InspectHandler:InspectUnit(unit,type): type ("..tostring(inspectType)..") isn't handled (yet).")
      end
      return true
   end
   return false -- We can't inspect unit right now
end

function module.InspectHandler.INSPECT_READY(event, guid, ...)
   if isInspecting then
      addon:Debug("InspectHandler()", event, guid, ...)

      if pool[guid] and pool[guid].type == "spec" then
         local spec = GetInspectSpecialization(pool[guid].name)
         if spec ~= 0 then -- It might be 0
            AddToCache(pool[guid].unit, "spec", spec)
         end
         FireCallback(spec, guid) -- It's not our problem if we received nil
         PoolNextInspect(guid)

      else
         -- We're trying to inspect something we're not handling/prepared for
         isInspecting = false
         if not pool[guid] then -- Silently log this
            addon:Debug("InspectHandler() tried to inspect a non pooled guid:", guid)
         else
            error("InspectHandler: Trying to handle non handled event for type: "..pool[guid].type..", for guid: "..guid)
         end
      end
   end
end
