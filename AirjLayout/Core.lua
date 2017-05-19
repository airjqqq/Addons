local Core = LibStub("AceAddon-3.0"):NewAddon("AirjLayout", "AceConsole-3.0","AceTimer-3.0")

function Core:OnInitialize()

  self:RegisterChatCommand("al", function(str)
      if strfind(str,"ltp") then
        setLTPDB()
        ReloadUI()
      else
        self:SetCVars()
        self:SetBinding()
        self:SetLayout()
        self:SetMiniMapButtons()
      end
      -- action bars
    -- MultiBarRight:ClearAllPoints()
    -- MultiBarRight:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT")
  end)
end



function Core:OnEnable()
  self:SetLayout()
  self:SetCVars()
  self:SetBinding()
  self:ScheduleTimer(function()
    if not InCombatLockdown() then
      self:SetLayout()
      self:SetMiniMapButtons()
    end
  end,5)
end

function Core:OnDisable()
end

function Core:SetBinding()
  -- key binding
  SetBinding("BUTTON3","STARTAUTORUN")
  for i = 1,12 do
    if i<6 then
      SetBinding("ALT-"..i,"ACTIONBUTTON"..i)
    end
  end
  SetBinding("Y","EXTRAACTIONBUTTON1")
  function clearBinding (name)
    local key1, key2 = GetBindingKey(name)
    if key1 then
      SetBinding(key1)
    end
    if key2 then
      SetBinding(key2)
    end
  end
  for i = 1,12 do
    clearBinding("SHAPESHIFTBUTTON"..i)
    clearBinding("BONUSACTIONBUTTON"..i)
    for j = 1, 4 do
      clearBinding("MULTIACTIONBAR"..j.."BUTTON"..i)
    end
  end

  for i = 1,6 do
    clearBinding("ACTIONPAGE"..i)
  end
  SetBinding("ALT-V","NAMEPLATES")
  SetBinding("CTRL-V","FRIENDNAMEPLATES")
  SetBinding("CTRL-ALT-V","ALLNAMEPLATES")

  SetBinding("CTRL-B","TOGGLECHARACTER0")
  SetBinding("SHIFT-B","OPENALLBAGS")

  SetBinding("A","STRAFELEFT")
  SetBinding("D","STRAFERIGHT")
end

function Core:SetCVars()

  if GetCVar("SpellQueueWindow") == "400" then
    SetCVar("SpellQueueWindow", 50)
  end

  SetCVar("autoLootDefault", 1)

  SetCVar("synchronizeConfig", 0)
  SetCVar("synchronizeSettings", 0)
  SetCVar("synchronizeChatFrames", 0)
  SetCVar("synchronizeBindings", 0)
  SetCVar("synchronizeMacros", 0)

  SetCVar("useUiScale",1)
  SetCVar("uiScale",0.6)
  -- nameplate
  SetCVar("nameplateLargerScale",1)
  SetCVar("nameplatePersonalShowAlways",1)
  SetCVar("nameplateShowAll",1)
  SetCVar("nameplateShowEnemyGuardians",1)
  SetCVar("nameplateShowEnemyMinions",1)
  SetCVar("nameplateShowEnemyMinus",1)
  SetCVar("nameplateShowEnemyPets",1)
  SetCVar("nameplateShowEnemyTotems",1)


  SetCVar("NamePlateHorizontalScale",1.4)
  SetCVar("NamePlateVerticalScale",2.7)


  NamePlateDriverFrame:UpdateNamePlateOptions()
end

function Core:SetMiniMapButtons()
  local shows = {
    Cheatsheet = true,
  }
  local LibDBIcon = LibStub("LibDBIcon-1.0", true)
  if LibDBIcon then
    for name,data in pairs(LibDBIcon.objects) do
      if not shows[name] then
        self:Print("Hide minimap "..name)
        LibDBIcon:Hide(name)
      end
    end
  end
end
function Core:SetLayout()
  --frames
  FocusFrame:ClearAllPoints()
  FocusFrame:SetPoint("CENTER",-350,200)

	FCF_SetLocked(ChatFrame1, false);
  ChatFrame1:SetSize(450,150)
  ChatFrame1:ClearAllPoints()
  ChatFrame1:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0,0)
  FCF_SetChatWindowFontSize(nil, ChatFrame1, 14)
  FCF_SetLocked(ChatFrame1, true);

  if DetailsBaseFrame1 then
    DetailsBaseFrame1:SetSize(250,100)
    DetailsBaseFrame1:ClearAllPoints()
    DetailsBaseFrame1:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",0,0)
  end
  if DetailsBaseFrame2 then
    DetailsBaseFrame2:SetSize(250,100)
    DetailsBaseFrame2:ClearAllPoints()
    DetailsBaseFrame2:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-250,0)
  end
  if ExRT_MarksBar_WorldMarkers_Kind2_1 then
    local ExRTWorldMarker = ExRT_MarksBar_WorldMarkers_Kind2_1:GetParent()
    ExRTWorldMarker:ClearAllPoints()
    ExRTWorldMarker:SetPoint("TOP",UIParent,"TOP")
  end



  if AirjAutoKey_GUI_anchor then
    AirjAutoKey_GUI_anchor:SetPoint("CENTER",UIParent,"CENTER",0,-240)
  end





end

local leaPlusDB = {
	["HotkeyMenu"] = 1,
	["ViewPortBottom"] = 0,
	["BuffFrameX"] = -172.855102539063,
	["BuffFrameY"] = -11.3106126785278,
	["ManageBuffFrame"] = "On",
	["NoEncounterAlerts"] = "On",
	["MusicContinent"] = "Eastern Kingdoms",
	["ClassColPlayer"] = "Off",
	["ShowMinimapIcon"] = "On",
	["ViewPortTop"] = 0,
	["InvKey"] = "plus",
	["NoGryphons"] = "Off",
	["FrmEnabled"] = "Off",
	["MinimapMouseZoom"] = "Off",
	["LeaStartPage"] = 3,
	["CooldownTips"] = "On",
	["MainPanelR"] = "CENTER",
	["ShowRevealBox"] = "On",
	["InviteFromWhisper"] = "Off",
	["MinimapScale"] = 1,
	["AutoReleasePvP"] = "On",
	["HideBossBanner"] = "Off",
	["AhBuyoutOnly"] = "Off",
	["AutoRepairOwnFunds"] = "On",
	["BuffFrameScale"] = 1.3,
	["UseArrowKeysInChat"] = "On",
	["ShowDressTab"] = "On",
	["AcceptPartyFriends"] = "Off",
	["NoCooldownDuration"] = "On",
	["NoChatFade"] = "Off",
	["AutoRelAshran"] = "On",
	["StaticCoordsEn"] = "Off",
	["NoAchieveAlerts"] = "On",
	["NoPartyInvites"] = "Off",
	["CombatPlates"] = "Off",
	["TipBackSimple"] = "Off",
	["HideZoneText"] = "Off",
	["MergeTrackBtn"] = "Off",
	["UseEasyChatResizing"] = "On",
	["NoAlerts"] = "Off",
	["MusicKeyMenu"] = 1,
	["LeaPlusQuestFontSize"] = 18,
	["TipShowTarget"] = "On",
	["BuffFrameA"] = "TOPRIGHT",
	["StaticCoordsScale"] = 1,
	["NoPetDuels"] = "Off",
	["NoDuelRequests"] = "Off",
	["StaticCoords"] = "On",
	["AhExtras"] = "On",
	["CoordsR"] = "CENTER",
	["QuestFontChange"] = "Off",
	["NoRaidRestrictions"] = "Off",
	["TipOffsetX"] = -13,
	["HideCleanupBtns"] = "Off",
	["AutoRepairGuildFunds"] = "On",
	["AutoRelTolBarad"] = "On",
	["Manageclasscolors"] = "On",
	["MaxCameraZoom"] = "Off",
	["ShowRaidToggle"] = "On",
	["NoMapEmote"] = "Off",
	["HideBodyguard"] = "Off",
	["NoShaders"] = "On",
	["AutoRelBGs"] = "On",
	["ResThankYouEmote"] = "On",
	["ViewPortAlpha"] = 0,
	["CoordsX"] = 0,
	["UnclampChat"] = "On",
	["AutoRepairSummary"] = "On",
	["FadeMap"] = "Off",
	["HideMinimapZone"] = "Off",
	["ClassColFrames"] = "On",
	["ShowMapMod"] = "Off",
	["NoStickyChat"] = "Off",
	["LeaPlusMailFontSize"] = 22,
	["NoFriendRequests"] = "Off",
	["HideCraftedNames"] = "Off",
	["MusicPanelY"] = 0,
	["ShowVolumeInFrame"] = "Off",
	["WorldMapCoords"] = "On",
	["DurabilityStatus"] = "On",
	["NoChatButtons"] = "On",
	["ViewPortRight"] = 0,
	["NoCombatLogTab"] = "Off",
	["PlusPanelAlpha"] = 0,
	["MoveChatEditBoxToTop"] = "On",
	["PlayerChainMenu"] = 2,
	["MusicZone"] = "Arathi Highlands",
	["AutoGossipMenu"] = 1,
	["HideErrorFrameText"] = "Off",
	["ShowVolume"] = "On",
	["MusicPanelX"] = 0,
	["ShowImportantErrors"] = "On",
	["SkipCinematics"] = "Off",
	["StaticCoordsTop"] = "Off",
	["MusicPanelR"] = "CENTER",
	["MusicPanelA"] = "CENTER",
	["NoAutoResInCombat"] = "Off",
	["AutoAcceptSummon"] = "Off",
	["NoSocialButton"] = "On",
	["PlusPanelScale"] = 1,
	["ShowQuestUpdates"] = "On",
	["CoordsA"] = "CENTER",
	["NoBagAutomation"] = "Off",
	["FasterLooting"] = "On",
	["ShowCooldowns"] = "Off",
	["ClassColTarget"] = "On",
	["MailFontChange"] = "Off",
	["MaxChatHstory"] = "On",
	["MinimapMod"] = "Off",
	["MainPanelA"] = "CENTER",
	["NoCharControls"] = "Off",
	["AutoConfirmRole"] = "Off",
	["TipHideInCombat"] = "Off",
	["StaticCoordsLock"] = "Off",
	["TipModEnable"] = "Off",
	["BuffFrameR"] = "TOPRIGHT",
	["ViewPortLeft"] = 0,
	["MinimapIconPos"] = -158.1,
	["EnableHotkey"] = "On",
	["SellJunkSummary"] = "On",
	["AcceptPremades"] = "Off",
	["AutoSellJunk"] = "On",
	["NoClassBar"] = "Off",
	["ViewPortEnable"] = "Off",
	["ViewPortResize"] = "Off",
	["AutoAcceptRes"] = "On",
	["NoCommandBar"] = "Off",
	["HideTalkingFrame"] = "Off",
	["TipOffsetY"] = 94,
	["AutomateQuests"] = "On",
	["HideLevelUpDisplay"] = "Off",
	["NoProfessionAlerts"] = "On",
	["AutoRelWintergrasp"] = "On",
	["NoLootAlerts"] = "On",
	["RevealWorldMap"] = "On",
	["LeaPlusTipSize"] = 1,
	["NoGarrisonAlerts"] = "On",
	["AutomateGossip"] = "On",
	["UnivGroupColor"] = "Off",
	["AhGoldOnly"] = "Off",
	["HideSubzoneText"] = "Off",
	["StaticCoordsBack"] = "Off",
	["ShowPlayerChain"] = "Off",
	["MainPanelY"] = 0,
	["NoConfirmLoot"] = "Off",
	["ShowCooldownID"] = "On",
	["NoHitIndicators"] = "On",
	["NoRestedEmotes"] = "Off",
	["ShowPetSaveBtn"] = "Off",
	["CharAddonList"] = "Off",
	["NoPetAutomation"] = "Off",
	["CoordsY"] = 200,
	["CooldownsOnPlayer"] = "Off",
	["LockoutSharing"] = "Off",
	["TipShowRank"] = "On",
	["MainPanelX"] = 0,
	["HideMinimapTime"] = "Off",
}

function setLTPDB()
  LeaPlusDB = leaPlusDB
  SlashCmdList["Leatrix_Plus"]("nosave")
end
