local Core =  LibStub("AceAddon-3.0"):GetAddon("AirjAVR")
local mod = Core:NewModule("PVP")
local LibPlayerSpells = LibStub('LibPlayerSpells-1.0')

function mod:OnInitialize()
  --constants
  local stun = {
    color={0.4,0.0,0,0.05},
    color2={1,0.0,0,0.2},
    radius=3,
  }
  local cc = {
    color={0.5,0.5,0,0.05},
    color2={0.8,0.8,0,0.1},
    radius=5,
  }
  local root = {
    color={0.0,0.2,0.5,0.05},
    color2={0.0,0.4,0.8,0.1},
    radius=3,
  }
  local survival = {
    color={0.5,0.2,0.0,0.05},
    color2={0.8,0.4,0.0,0.1},
    isbuff=true,
    radius=3,
  }
  local burst = {
    color={0.0,0.5,0.0,0.05},
    color2={0.0,0.8,0.0,0.1},
    isbuff=true,
    radius=3,
  }
  local isStun = LibPlayerSpells:GetFlagTester("STUN")
  local isCC = LibPlayerSpells:GetFlagTester("DISORIENT INCAPACITATE")
  local isRoot = LibPlayerSpells:GetFlagTester("ROOT")

  for spellId, flags, providers, modifiedSpells, moreFlags in LibPlayerSpells:IterateSpells("CROWD_CTRL") do
    local data
    if isStun(moreFlags) then
      data = stun
    elseif isCC(moreFlags) then
      data = cc
    elseif isRoot(moreFlags) then
      -- data = root
    end
    if data then
      Core:RegisterAuraUnit(spellId,data)
    end
  end
  -- for spellId, flags, providers, modifiedSpells, moreFlags in LibPlayerSpells:IterateSpells("SURVIVAL") do
  --   local data = survival
  --   Core:RegisterAuraUnit(spellId,data)
  -- end
  -- for spellId, flags, providers, modifiedSpells, moreFlags in LibPlayerSpells:IterateSpells("BURST") do
  --   local data = burst
  --   Core:RegisterAuraUnit(spellId,data)
  -- end
end
