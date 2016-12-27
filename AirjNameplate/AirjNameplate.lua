local NP = LibStub("AceAddon-3.0"):NewAddon("AirjNameplate","AceTimer-3.0")

function NP:OnInitialize()
end

function NP:OnEnable ()
  self:ScheduleRepeatingTimer(function()
    self:Update()
  end,0.1)
end

local drtypes = {"STUN","INCAPACITATE","DISORIENT","SILENCE"}

function NP:Update ()
  local frames = C_NamePlate.GetNamePlates()
  for _,frame in ipairs(frames) do
    local unit = frame.namePlateUnitToken
    local parent = frame.UnitFrame.healthBar
    local combat = frame.outofcombat
    if not combat then
      combat = CreateFrame("Frame",nil,parent)
      combat:SetPoint("TOPLEFT",parent,"TOPLEFT",-4,4)
      combat:SetPoint("BOTTOMRIGHT",parent,"BOTTOMRIGHT",4,-4)
      combat:SetFrameStrata("BACKGROUND")
      -- combat:SetFrameLevel
      local texture = combat:CreateTexture()
      texture:SetAllPoints()
      texture:SetColorTexture(0,1,0,0.5)
      frame.outofcombat = combat
    end
    if not UnitAffectingCombat(unit) and UnitCanAttack("player",unit) then
      combat:Show()
    else
      combat:Hide()
    end
    local dricons = frame.dricons
    if not dricons then
      dricons = {}
      for i,v in ipairs(drtypes) do
        local icon = CreateFrame("Cooldown",nil,parent,"CooldownFrameTemplate")
        icon:ClearAllPoints()
        icon:SetPoint("LEFT",parent,"RIGHT",(i-1)*30+5,0)
        icon:SetSize(30,30)
        local texture = icon:CreateTexture()
        texture:SetDrawLayer("BACKGROUND", 0)
        texture:SetPoint("TOPLEFT",icon,"TOPLEFT",3,-3)
        texture:SetPoint("BOTTOMRIGHT",icon,"BOTTOMRIGHT",-3,3)
        texture:SetTexCoord(0.07,0.93,0.07,0.93)
        local border = icon:CreateTexture()
        border:SetDrawLayer("BACKGROUND", -8)
        border:SetAllPoints()
        border:SetColorTexture(0,0,0,1)
        icon.SetDR = function(_,spellId,time,count)
          texture:SetTexture(GetSpellTexture(spellId))
          icon:SetCooldown(time-18.5, 18.5)
          if count == 1 then
            border:SetColorTexture(0,1,0,1)
          elseif count == 2 then
            border:SetColorTexture(1,1,0,1)
          else
            border:SetColorTexture(1,0,0,1)
          end
        end
        dricons[i] = icon
      end
      frame.dricons = dricons
    end
    local guid = UnitGUID(unit)
    for i,v in ipairs(drtypes) do
      local icon = dricons[i]
      local data = AirjAutoKey:GetDrData(v,guid)
      if data and data.t>GetTime() then
        icon:SetDR(data.spellId,data.t,data.c)
        icon:Show()
      else
        icon:Hide()
      end
    end
  end
end
