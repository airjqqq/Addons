local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("EmeraldNightmare")

function mod:OnInitialize()
  local data
  do --test
  end
  do -- Nythendra
    --202977
    data = {
      color={0.0,0.7,0,0.1},
      color2={0.0,0.7,0,0.2},
      line={{0,10,0},{50,60,0},{-50,60,0}},
      duration=8,
    }
    Core:RegisterBreath(202977,data) --Infested Breath
    data = {
      color={0.2,0.5,0,0.2},
      color2={0.3,0.7,0,0.3},
      radius=8,
      duration=9,
    }
    Core:RegisterAuraOnApplied(203096,data) --溃烂
    data = {
      color={0.4,0.0,0,0.2},
      color2={0.7,0.0,0,0.3},
      radius=15,
      duration=8,
    }
    Core:RegisterAuraOnApplied(204463,data) --爆裂溃烂
    -- data = {
    --   color={0.2,0.1,0.5,0.2},
    --   color2={0.4,0.0,0.8,0.3},
    --   radius=8,
    --   duration=10,
    --   spellId = 203646,
    -- }
    -- Core:RegisterObjectOnCreated("Creature",102998,data) --腐化的害虫
  end
  do --Il'gynoth
    -- data = {
    --   color={0.7,0.1,0.7,0.2},
    --   radius=8,
    --   duration=30,
    -- }
    -- Core:RegisterObjectOnCreated("Creature",105383,data) --小触手
    data = {
      color={0.2,0.5,0,0.2},
      color2={0.3,0.7,0,0.3},
      radius=5,
      duration=10,
    }
    Core:RegisterAuraOnApplied(208929,data) --Spew Corruption
    data = {
      width = 0.2,
      alpha = 0.3,
    }
    Core:RegisterLink(210099,data) --Ichor Fixate
    data = {
      color={0.5,0.0,0,0.2},
      color2={0.8,0.0,0,0.3},
      radius=11,
      duration=8,
    }
    Core:RegisterAuraOnApplied(215128,data) --Spew Corruption
  end
  do
    data = {
      color={0.0,0.5,0,0.2},
      color2={0.0,0.8,0,0.3},
      radius=8,
      duration=6,
    }
    Core:RegisterAuraOnApplied(215460,data) --Necrotic Venom
    data = {
      color={0.0,0.7,0,0.2},
      color2={0.0,0.5,0,0.3},
      radius=8,
      duration=6,
    }
    Core:RegisterAuraOnApplied(215460,data) --Necrotic Venom
  end
end
