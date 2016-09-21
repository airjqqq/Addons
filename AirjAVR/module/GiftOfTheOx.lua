local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("GiftOfTheOx")

function mod:OnInitialize()
  local data = {
    color={0.0,0.7,0,0.2},
    color2={0.0,0.9,0,0.3},
    radius=1,
    duration=30,
    updateCallbacks = {
      function(m,t)
        if m.expiration == nil then
          -- self:Print("updateCallbacks","expires")
          return
        end
        local health = UnitHealth("player")
        local max = UnitHealthMax("player")
        local highlight
        if not health then
          highlight = false
        else
          highlight = health/max <0.35
        end
        if m.highlight ==nil or m.highlight ~= highlight then
          m.highlight=highlight
          if highlight then
            m.spellId = 124503
            m:SetColor(0.0,0.7,0,0.5)
            m:SetColor2(0.0,0.9,0,0.7)
          else
            m.spellId = nil
            m:SetColor(0.7,0.7,0,0.1)
            m:SetColor2(0.9,0.9,0,0.2)
          end
        end
        local px,py,pz = t.playerPosX,t.playerPosY,t.playerPosZ
        local x,y,z = AirjHack:Position(m.followUnit)
        if not x then
          m.vertices = nil
          m.expiration = nil
          return
        end
        local dx,dy,dz =x-px,y-py,z-pz
        local d = math.sqrt(dx*dx+dy*dy+dz*dz)
        if d <1 then
          m.vertices = nil
          m.expiration = nil
        end
      end,
    },
  }
  Core:RegisterObjectOnCreated("AreaTrigger",124503,data)
  Core:RegisterObjectOnCreated("AreaTrigger",124506,data)
end
