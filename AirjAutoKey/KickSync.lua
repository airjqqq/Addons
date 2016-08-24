local KickSync = LibStub("AceAddon-3.0"):NewAddon("AirjAutoKeyKickSync", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0","AceSerializer-3.0","AceComm-3.0")
function KickSync:OnCommReceived(prefix,data,channel,sender)
	local match, tab = self:Deserialize(data)
	if not match then return end
	local guid = tab.guid
	local list = tab.type=="harm" and self.harmCasting or self.helpCasting
	list[guid] = list[guid] or {}
	list[guid][tab.spell] = GetTime()
end

function KickSync:SendCast(unit,spell,isHelp)
	local type = isHelp and "help" or "harm"
	local tab = {
		type = type,
		guid = UnitGUID(unit) or "",
		spell = spell,
	}
  local channel = IsInRaid() and "RAID" or "PARTY"
	self:SendCommMessage("AAK_CASTING",self:Serialize(tab),channel,nil,"ALERT")
	self:OnCommReceived("AAK_CASTING",self:Serialize(tab))
end


KickSync.kickCooldown = {
	["脚踢"] = 15,
	["拳击"] = 15,
	["责难"] = 15,
	["心灵冰冻"] = 15,
	["锁喉手"] = 15,
	["迎头痛击"] = 15,
	["法术反制"] = 24,
	["法术封锁"] = 24,
	["眼棱爆炸"] = 24,
	["反制射击"] = 24,
	["风剪"] = 12,
}

KickSync.castProperty = {
	["脚踢"] = 10,
	["拳击"] = 20,
	["责难"] = 30,
	["心灵冰冻"] = 40,
	["锁喉手"] = 50,
	["迎头痛击"] = 60,
	["法术反制"] = 70,
	["法术封锁"] = 80,
	["风剪"] = 90,
	["反制射击"] = 100,
	["群体反射"] = 110,
	["根基图腾"] = 120,
	["法术反射"] = 130,
	["奥术洪流"] = 140,
	["深度冻结"] = 150,
}
