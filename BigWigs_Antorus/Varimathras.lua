if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Varmathras", nil, 1983, 1712)
if not mod then return end
--mod:RegisterEnableMob(000000)
mod.engageId = 2069
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"berserk",
	}
end

function mod:OnBossEnable()
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--
