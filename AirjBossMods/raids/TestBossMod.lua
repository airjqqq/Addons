local addonsname,modulename = "AirjBossMods","TestBossMod"
local Core = LibStub("AceAddon-3.0"):GetAddon(addonsname)
local R = Core:NewModule(modulename,"AceEvent-3.0")

function R:OnEnable()
  local bossmod = Core:NewBoss({encounterID = 0})
  function bossmod:COMBAT_LOG_EVENT_UNFILTERED(aceEvent,timeStamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId,spellName,spellSchool,...)
    local now = GetTime()
    if event == "SPELL_AURA_APPLIED" then
    end
  end
  function bossmod:UNIT_SPELLCAST_SUCCEEDED(aceEvent,uId, spellName, _, spellGUID)
    local now = GetTime()
    local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10)
      -- print("UNIT_SPELLCAST_SUCCEEDED",uId,spellName)
    if spellId == 167105 then--Infernal Spike
      -- Core:SetText("|cffffff00尖刺出现：{number}|r","",now+3,now+3)
      -- Core:SetVoice("watchstep")
    elseif spellId == 6552 then--Rain of Brimston
      -- Core:SetText("|cffff00ff帮忙分担：{number}|r","|cff00ff00分担结束|r",now+9,now+10.5)
      -- Core:SetVoice("helpsoak")
      -- Core:SetVoice("safenow",now+9)
    elseif spellId == 232249 then
    end
  end
  function bossmod:Timer10ms()
    local now = GetTime()
    -- local hasDebuff, _, _, _, _, _, _, _, _, _, spellId = UnitDebuff("target", GetSpellInfo(208086))
    -- if hasDebuff and spellId == 208086 and (not lastCometTime or now - lastCometTime > 10) then
    --   lastCometTime = now
    --   Core:SetIcon(10,GetSpellTexture(spellId),1,5,nil,nil,nil)
    --   Core:SetText("|cffff0000小圈点你：{number}|r","|cff00ff00返回人群|r",now+5,now+7)
    --   Core:SetVoice("runout")
    --   Core:SetVoice("safenow",now+5)
    --   Core:SetScreen(1,0,0,0.5)
    --   for i = 2,5 do
    --     Core:SetSay(""..(5-i),now + i)
    --   end
    -- end
  end
  local timeline = {
    {
      phase = 1,
      text = "Phase: 1",
      timepoints = {
        {
          text = "Point: 1",
          time = 10,
        },
        {
          text = "Point: 2",
          time = 25,
        },
      },
    },
    {
      phase = 2,
      text = "Phase: 2",
      timepoints = {
        {
          text = "Point: 4",
          time = 10,
        },
        {
          text = "Point: 5",
          time = 25,
        },
      },
    },
    {
      phase = 3,
      text = "Phase: 3",
      timepoints = {
        {
          text = "Point: 7",
          time = 10,
        },
        {
          text = "Point: 8",
          time = 25,
        },
      },
    },
  }
  -- local timeline = {
  --   {
  --     phase = 1,
  --     text = "阶段1",
  --     timepoints = {
  --       {
  --         text = "分担 - 1",
  --         time = 12,
  --       },
  --       {
  --         text = "火球 - 1",
  --         time = 34,
  --       },
  --       {
  --         text = "AOE - 1",
  --         time = 55,
  --       },
  --       {
  --         text = "分担 - 2",
  --         time = 72,
  --       },
  --       {
  --         text = "火球 - 2",
  --         time = 95,
  --       },
  --       {
  --         text = "AOE - 2",
  --         time = 116,
  --       },
  --       {
  --         text = "分担 - 3",
  --         time = 133,
  --       },
  --       {
  --         text = "火球 - 3",
  --         time = 156,
  --       },
  --       {
  --         text = "AOE - 3",
  --         time = 177,
  --       },
  --       {
  --         text = "分担 - 4",
  --         time = 192,
  --       },
  --       {
  --         text = "火球 - 4",
  --         time = 217,
  --       },
  --       {
  --         text = "AOE - 4",
  --         time = 237,
  --       },
  --       {
  --         text = "火球 - 5",
  --         time = 250,
  --       },
  --       {
  --         text = "分担 - 5",
  --         time = 262,
  --       },
  --       {
  --         text = "火球 - 6",
  --         time = 280,
  --       },
  --       {
  --         text = "AOE - 5",
  --         time = 297,
  --       },
  --       {
  --         text = "火球 - 7",
  --         time = 311,
  --       },
  --       {
  --         text = "分担 - 6",
  --         time = 323,
  --       },
  --       {
  --         text = "火球 - 8",
  --         time = 341,
  --       },
  --       {
  --         text = "AOE - 6",
  --         time = 358,
  --       },
  --       {
  --         text = "火球 - 9",
  --         time = 372,
  --       },
  --       {
  --         text = "分担 - 7",
  --         time = 384,
  --       },
  --       {
  --         text = "火球 - 10",
  --         time = 402,
  --       },
  --       {
  --         text = "AOE - 7",
  --         time = 419,
  --       },
  --       {
  --         text = "火球 - 11",
  --         time = 433,
  --       },
  --       {
  --         text = "分担 - 8",
  --         time = 444,
  --       },
  --       {
  --         text = "火球 - 12",
  --         time = 462,
  --       },
  --       {
  --         text = "AOE - 8",
  --         time = 479,
  --       },
  --       {
  --         text = "火球 - 13",
  --         time = 494,
  --       },
  --       {
  --         text = "分担 - 9",
  --         time = 505,
  --       },
  --       {
  --         text = "火球 - 14",
  --         time = 522,
  --       },
  --       {
  --         text = "AOE - 9",
  --         time = 540,
  --       },
  --       {
  --         text = "火球 - 15",
  --         time = 555,
  --       },
  --     },
  --   },
  -- }
  function bossmod:GetTimeline(difficulty)
    return timeline
  end
end
