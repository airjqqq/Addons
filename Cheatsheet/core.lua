-- Author: maliciousplant (EU)
-- License: Public Domain

local addonName, SPELLDB = ...

--------------------------------------------------------------------------------------------------------------------------------------
-- Initialize upvalues
--------------------------------------------------------------------------------------------------------------------------------------

local forWowVersion = "for patch 7.2"

local specIndex = nil
local selectedClass = nil
local currentPage = nil

local pageButton = nil
local pageButton2 = nil
local specTitle = nil
local specButton1 = nil
local specButton2 = nil
local specButton3 = nil
local specButton4 = nil

local UIConfig = nil
local contentAnchor = nil

local separatorTexture = {}

local spellBtn = {}
spellBtn.Hitbox = {} 
spellBtn.Bg = {}
spellBtn.BgTexture = {}
spellBtn.Icon = {}			
spellBtn.IconBg = {}  	
spellBtn.IconFrame = {}	
spellBtn.skillname = {}
spellBtn.skillrank = {}

local artifact = {}
artifact.Hitbox = {}
artifact.Bg = {}
artifact.BgTexture = {}
artifact.IconFrame = {}
artifact.IconBg = {}
artifact.Icon = {}
artifact.skillname = {}
artifact.skillrank = {}


--------------------------------------------------------------------------------------------------------------------------------------
-- clear all addon content (since all content is set as child of contentAnchor frame we simply clear all its children)
--------------------------------------------------------------------------------------------------------------------------------------

local function clearContent()
	local ab = {contentAnchor:GetChildren()}		
	for i = 1, #ab do ab[i]:Hide() end
	local ac = {contentAnchor:GetRegions()}
	for i = 1, #ac do ac[i]:Hide() end
	SetPortraitToTexture("cheatsheet_SpellbookFramePortrait","Interface\\ICONS\\INV_Scroll_14.blp")
	--local children = {contentAnchor:GetChildren()} for i=1, #children do print(i, children[i]) end 
end


--------------------------------------------------------------------------------------------------------------------------------------
-- return chosen spec, determines specialization based on specIndex and selectedClass variables
---------------------------------------------------------------------------------------------------------------------------------------

local function getSpec(a)
	local selectedSpec = nil
	if 		((selectedClass == "MAGE") 			and (a == 1)) then  selectedSpec = "ARCANE" 		
	elseif	((selectedClass == "MAGE") 			and (a == 2)) then  selectedSpec = "FIRE"			
	elseif	((selectedClass == "MAGE")			and (a == 3)) then  selectedSpec = "FROST"			
	elseif	((selectedClass == "PALADIN") 		and (a == 1)) then  selectedSpec = "HOLY"			
	elseif	((selectedClass == "PALADIN") 		and (a == 2)) then  selectedSpec = "PROTECTION"		
	elseif	((selectedClass == "PALADIN") 		and (a == 3)) then  selectedSpec = "RETRIBUTION"	
	elseif	((selectedClass == "WARRIOR") 		and (a == 1)) then  selectedSpec = "ARMS"			
	elseif	((selectedClass == "WARRIOR") 		and (a == 2)) then  selectedSpec = "FURY"			
	elseif	((selectedClass == "WARRIOR") 		and (a == 3)) then  selectedSpec = "PROTECTION"		
	elseif	((selectedClass == "DRUID") 		and (a == 1)) then  selectedSpec = "BALANCE"		
	elseif	((selectedClass == "DRUID") 		and (a == 2)) then  selectedSpec = "FERAL"			
	elseif	((selectedClass == "DRUID") 		and (a == 3)) then  selectedSpec = "GUARDIAN"		
	elseif	((selectedClass == "DRUID") 		and (a == 4)) then  selectedSpec = "RESTORATION"	
	elseif	((selectedClass == "DEATHKNIGHT") 	and (a == 1)) then  selectedSpec = "BLOOD"			
	elseif	((selectedClass == "DEATHKNIGHT") 	and (a == 2)) then  selectedSpec = "FROST"			
	elseif	((selectedClass == "DEATHKNIGHT") 	and (a == 3)) then  selectedSpec = "UNHOLY"			
	elseif	((selectedClass == "HUNTER") 		and (a == 1)) then  selectedSpec = "BEASTMASTERY"	
	elseif	((selectedClass == "HUNTER") 		and (a == 2)) then  selectedSpec = "MARKSMANSHIP"	
	elseif	((selectedClass == "HUNTER") 		and (a == 3)) then  selectedSpec = "SURVIVAL"		
	elseif	((selectedClass == "PRIEST") 		and (a == 1)) then  selectedSpec = "DISCIPLINE"		
	elseif	((selectedClass == "PRIEST") 		and (a == 2)) then  selectedSpec = "HOLY"			
	elseif	((selectedClass == "PRIEST") 		and (a == 3)) then  selectedSpec = "SHADOW"			
	elseif	((selectedClass == "ROGUE") 		and (a == 1)) then  selectedSpec = "ASSASSINATION"	
	elseif	((selectedClass == "ROGUE") 		and (a == 2)) then  selectedSpec = "OUTLAW"			
	elseif	((selectedClass == "ROGUE") 		and (a == 3)) then  selectedSpec = "SUBTLETY"		
	elseif	((selectedClass == "SHAMAN") 		and (a == 1)) then  selectedSpec = "ELEMENTAL"		
	elseif	((selectedClass == "SHAMAN") 		and (a == 2)) then  selectedSpec = "ENHANCEMENT"	
	elseif	((selectedClass == "SHAMAN") 		and (a == 3)) then  selectedSpec = "RESTORATION"	
	elseif	((selectedClass == "WARLOCK") 		and (a == 1)) then  selectedSpec = "AFFLICTION"		
	elseif	((selectedClass == "WARLOCK") 		and (a == 2)) then  selectedSpec = "DEMONOLOGY"		
	elseif	((selectedClass == "WARLOCK") 		and (a == 3)) then  selectedSpec = "DESTRUCTION"	
	elseif	((selectedClass == "MONK") 			and (a == 1)) then  selectedSpec = "BREWMASTER"		
	elseif	((selectedClass == "MONK") 			and (a == 2)) then  selectedSpec = "WINDWALKER"		
	elseif	((selectedClass == "MONK") 			and (a == 3)) then  selectedSpec = "MISTWEAVER"		
	elseif	((selectedClass == "DEMONHUNTER") 	and (a == 1)) then  selectedSpec = "HAVOC"			
	elseif	((selectedClass == "DEMONHUNTER") 	and (a == 2)) then  selectedSpec = "VENGEANCE"   	
	end
	return selectedSpec
end


------------------------------------------------------------------------------------------------------------------
-- Spelldb data fetch function, receives spell-category and spell-index as arguments ( for shorthand access )
-------------------------------------------------------------------------------------------------------------------

local function getSpell(a,b)
	return SPELLDB[selectedClass][getSpec(specIndex)][a][b]
end

------------------------------------------------------------------------------------------------------------------
-- function to check if value is already inside table (used to prevent same spell being saved multiple times)
-------------------------------------------------------------------------------------------------------------------

local function alreadyListed(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end


------------------------------------------------------------------------------------------------------------------
-- Search string value from compiled database
-------------------------------------------------------------------------------------------------------------------

local function stringSearch(lookFor)
	local found = {}
	if string.len(lookFor) > 0 then
		lookFor = string.lower(lookFor)
		for _, value in pairs(SPELLDB.compiled) do
		  	local name = GetSpellInfo(value)
		  	name = string.lower(name)

		    if string.find(name, lookFor) then
		    	table.insert(found, value)
		    end
	  	end
	end
	return found
end



--------------------------------------------------------------------------------------------------------------------
-- create button frames used in addon content (for reducing code repetition)
--------------------------------------------------------------------------------------------------------------------

local function makeSpellButton(obj, i, xCoord, yCoord)

	obj.Hitbox[i] = CreateFrame("Button", nil, contentAnchor)
	obj.Hitbox[i]:SetFrameLevel(40)
	obj.Hitbox[i]:SetFrameStrata("HIGH")
	obj.Hitbox[i]:SetWidth(160)
	obj.Hitbox[i]:SetHeight(52)
	obj.Hitbox[i]:SetPoint("TOPLEFT", UIConfig, "TOPLEFT", xCoord, yCoord) 
	obj.Hitbox[i]:RegisterForClicks("AnyDown")
	obj.Hitbox[i]:Hide()

	obj.Bg[i] = CreateFrame("Button", nil, obj.Hitbox[i])
	obj.Bg[i]:SetFrameLevel(2)
	obj.Bg[i]:SetFrameStrata("MEDIUM")
	obj.Bg[i]:SetWidth(160)
	obj.Bg[i]:SetHeight(52)
	obj.Bg[i]:SetPoint("TOPLEFT", UIConfig, "TOPLEFT", xCoord, yCoord) 

	obj.BgTexture[i] = obj.Bg[i]:CreateTexture(nil,"ARTWORK")
	obj.BgTexture[i]:SetColorTexture(0,0,0,0.5)
	obj.BgTexture[i]:SetAllPoints(obj.Bg[i])

	obj.IconFrame[i] = CreateFrame("Button", nil, obj.Bg[i])
	obj.IconFrame[i]:SetFrameLevel(30)
	obj.IconFrame[i]:SetFrameStrata("MEDIUM")
	obj.IconFrame[i]:SetWidth(52) 
	obj.IconFrame[i]:SetHeight(52) 
	obj.IconFrame[i]:SetPoint("TOPLEFT", obj.Bg[i], "TOPLEFT")
	obj.IconFrame[i]:Hide()

	obj.IconBg[i] = obj.IconFrame[i]:CreateTexture(nil,"ARTWORK")
	obj.IconBg[i]:SetColorTexture(0,0,0,0.5)
	obj.IconBg[i]:SetAllPoints(obj.IconFrame[i])

	obj.Icon[i] = obj.IconFrame[i]:CreateTexture(nil,"OVERLAY")
	obj.Icon[i]:SetWidth(46) 
	obj.Icon[i]:SetHeight(46) 
	obj.Icon[i]:SetPoint("TOPLEFT", obj.IconFrame[i], "TOPLEFT", 3, -3)

	obj.skillname[i] = contentAnchor:CreateFontString(nil, "OVERLAY")
	obj.skillname[i]:SetFontObject("GameFontHighlight")
	obj.skillname[i]:SetTextColor(1,1,0,1)
	obj.skillname[i]:SetJustifyH("LEFT")
	obj.skillname[i]:SetWidth(100)
	obj.skillname[i]:SetPoint("LEFT", obj.IconFrame[i],"RIGHT", 6, 6)

	obj.skillrank[i] = contentAnchor:CreateFontString(nil, "OVERLAY")
	obj.skillrank[i]:SetFontObject("GameFontHighlight")
	obj.skillrank[i]:SetTextColor(1,1,1,0.8)
	obj.skillrank[i]:SetPoint("LEFT", obj.IconFrame[i],"RIGHT", 6, -8)	
end

--------------------------------------------------------------------------------------------------------------------
-- Returns color values for currently selected class
--------------------------------------------------------------------------------------------------------------------

local function returnClassColor()
	if 		(selectedClass == "MAGE") 			then	return 	0.41,0.80,0.94,1
	elseif	(selectedClass == "PALADIN") 		then 	return	0.96,0.55,0.73,1
	elseif	(selectedClass == "WARRIOR") 		then  	return	0.78,0.61,0.43,1		
	elseif	(selectedClass == "DRUID") 			then  	return 	1.00,0.49,0.04,1
	elseif	(selectedClass == "DEATHKNIGHT") 	then 	return 	0.77,0.12,0.23,1	
	elseif	(selectedClass == "HUNTER") 		then 	return	0.67,0.83,0.45,1
	elseif	(selectedClass == "PRIEST") 		then  	return 	1.00,1.00,1.00,1
	elseif	(selectedClass == "ROGUE") 			then 	return	1.00,0.96,0.41,1
	elseif	(selectedClass == "SHAMAN") 		then 	return 	0.0,0.44,0.87,1
	elseif	(selectedClass == "WARLOCK") 		then  	return 	0.58,0.51,0.79,1
	elseif	(selectedClass == "MONK") 			then 	return	0.33,0.54,0.52,1
	elseif	(selectedClass == "DEMONHUNTER") 	then 	return 	0.64,0.19,0.79,1
	else return 0.1,1,0.1,1 end
end


--------------------------------------------------------------------------------------------------------------------
-- Check if spellid is from artifact spell, return boolean
--------------------------------------------------------------------------------------------------------------------

local function isArtifactSpell(spellid)
	for key, value in pairs(SPELLDB.artifactRankList) do
		if (spellid == value[1])then
			return true
		end
	end
	return false
end


--------------------------------------------------------------------------------------------------------------------
-- Return hyperlink for artifact spell based on spellID
--------------------------------------------------------------------------------------------------------------------

local function getArtifactLink(spellid)
	for key, value in pairs(SPELLDB.artifactRankList) do
		if (spellid == value[1])then
			local name = GetSpellInfo(spellid)
			if (#value > 1) then
				return "|cff71d5ff|Hapower:"..key..":3:4|h["..name.."]|h|r"
			elseif (#value == 1) then
				return "|cff71d5ff|Hapower:"..key..":1:1|h["..name.."]|h|r"
			end
		end
	end
end


--------------------------------------------------------------------------------------------------------------------
-- Tooltip functions
--------------------------------------------------------------------------------------------------------------------

local function showSpellTooltip(self, i, spellid)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	if (isArtifactSpell(spellid)) then
		GameTooltip:SetHyperlink(getArtifactLink(spellid))
	else
		GameTooltip:SetSpellByID(spellid)
	end
	GameTooltip:Show()
	if (currentPage == "traits") then
		artifact.IconBg[i]:SetColorTexture(1,1,0,0.5)
		artifact.BgTexture[i]:SetColorTexture(1,1,0,0.2)
	else
		spellBtn.IconBg[i]:SetColorTexture(1,1,0,0.5)
		spellBtn.BgTexture[i]:SetColorTexture(1,1,0,0.2)
	end
end


local function hideSpellTooltip(self, i, spellid)
	GameTooltip:Hide()
	if (currentPage == "traits") then
		artifact.IconBg[i]:SetColorTexture(0,0,0,0.5)
	else
		spellBtn.IconBg[i]:SetColorTexture(0,0,0,0.5)
	end
	if (not alreadyListed(cheatsheetDB.highlightList, spellid)) then
		if currentPage == "traits" then
			artifact.BgTexture[i]:SetColorTexture(0,0,0,0.4)
		else
			spellBtn.BgTexture[i]:SetColorTexture(0,0,0,0.4)
		end
	end
end

local function getHyperlinkForChat(self, button, spellid)
	if (button == "LeftButton" and IsShiftKeyDown()) then 
		local idToChat = nil
		if (isArtifactSpell(spellid)) then
			idToChat = getArtifactLink(spellid)
		else
			idToChat = GetSpellLink(spellid) 
			if idToChat == nil or idToChat == "" then
				--print("debug: used GetSpellInfo due to nil hyperlink value")
	  			idToChat = string.format("|cff71d5ff|Hspell:%d:|h[%s]|h|r", spellid, (GetSpellInfo(spellid)))
	  		end
		end
		ChatFrame1EditBox:SetFocus()  
		ChatFrame1EditBox:Insert(idToChat)
	elseif (button == "LeftButton" and IsControlKeyDown()) then
		print("spellID: "..spellid)
	end
end

local function toggleState(self, button, i, spellid)
	local favorited = cheatsheetDB.highlightList
	if button == "RightButton" and (not IsShiftKeyDown()) then 
		for a = 1, #favorited do
			if(favorited[a] == spellid) then
				table.remove(favorited,a)
				if currentPage == "traits" then
					artifact.BgTexture[i]:SetColorTexture(0,0,0,0.4)
				else
					spellBtn.BgTexture[i]:SetColorTexture(0,0,0,0.4)
				end
			end
		end
	elseif button == "LeftButton" and (not IsShiftKeyDown()) then 
		if (not alreadyListed(favorited, spellid)) then
			table.insert(favorited, spellid)
			if currentPage == "traits" then
				artifact.BgTexture[i]:SetColorTexture(1,1,0,0.2)
			else
				spellBtn.BgTexture[i]:SetColorTexture(1,1,0,0.2)
			end
		end
	end
end


--------------------------------------------------------------------------------------------------------------------
-- content update for spellbook (spells, talent and honor tabs use this function)
--------------------------------------------------------------------------------------------------------------------

local function getSpellbookContent(spellbookID, isSecondPage)

	--this part is simple numerical sorting for "spells" lib based on spell ID
	if (spellbookID == "spells") then table.sort(SPELLDB[selectedClass][getSpec(specIndex)][spellbookID], function(a,b) return a<b end) end
	local spells = SPELLDB[selectedClass][getSpec(specIndex)][spellbookID]
	local ii = 0
	local rounds = nil

	if (#spells>21) then 
		pageButton:Show() 
		pageButton2:Show()
		if (isSecondPage) then 
			ii = 21
			rounds = #spells - 21 
		else
			rounds = 21
		end
	else 
		rounds = #spells 
	end

	for i = 1, rounds do

		local name, rank, icon = GetSpellInfo(getSpell(spellbookID,i+ii))
		local spellid = getSpell(spellbookID,i+ii)

		spellBtn.Icon[i]:SetTexture(icon)
		spellBtn.skillname[i]:SetText(name)
		spellBtn.skillrank[i]:SetText(rank)

		spellBtn.Hitbox[i]:Show()
		spellBtn.Bg[i]:Show()
		spellBtn.IconFrame[i]:Show()	
		spellBtn.skillname[i]:Show()
		spellBtn.skillrank[i]:Show()

		if spellBtn.skillname[i]:GetHeight()> 13 and spellBtn.skillrank[i]:GetText() ~= nil then
			spellBtn.skillname[i]:SetPoint("LEFT", spellBtn.IconFrame[i],"RIGHT", 6, 9)
			spellBtn.skillrank[i]:SetPoint("LEFT", spellBtn.IconFrame[i],"RIGHT", 6, -9)
		else
			spellBtn.skillname[i]:SetPoint("LEFT", spellBtn.IconFrame[i],"RIGHT", 6, 6)
			spellBtn.skillrank[i]:SetPoint("LEFT", spellBtn.IconFrame[i],"RIGHT", 6, -8)
		end

		spellBtn.BgTexture[i]:SetColorTexture(0,0,0,0.4) 

		local favorited = cheatsheetDB.highlightList
		for a = 1, #favorited do
			if(favorited[a] == spellid) then
				spellBtn.BgTexture[i]:SetColorTexture(1,1,0,0.2)
			end
		end

		spellBtn.Hitbox[i]:SetScript("OnEnter", function(self)				showSpellTooltip(self, i, spellid)  end)
		spellBtn.Hitbox[i]:SetScript("OnLeave", function(self)				hideSpellTooltip(self, i, spellid) 	end)
		spellBtn.Hitbox[i]:SetScript("OnClick", function(self, button) 		toggleState(self, button, i, spellid) getHyperlinkForChat(self, button, spellid) end)
	end
	specButton1:Show() specButton2:Show() specButton3:Show() specButton4:Show()
end



--------------------------------------------------------------------------------------------------------------------
-- Content update for search window
--------------------------------------------------------------------------------------------------------------------


local function getSearchResults(lookFor, isUserInput)

	if isUserInput then
		clearContent()
		currentPage = "spells"
		local found = stringSearch(lookFor)

		for i = 1, 21 do

			if found[i] ~= nil then

				local name, rank, icon = GetSpellInfo(found[i])
				local spellid = found[i]

				spellBtn.Icon[i]:SetTexture(icon)
				spellBtn.skillname[i]:SetText(name)
				spellBtn.skillrank[i]:SetText(rank)

				spellBtn.Hitbox[i]:Show()
				spellBtn.Bg[i]:Show()
				spellBtn.IconFrame[i]:Show()	
				spellBtn.skillname[i]:Show()
				spellBtn.skillrank[i]:Show()

				if spellBtn.skillname[i]:GetHeight()> 13 and spellBtn.skillrank[i]:GetText() ~= nil then
					spellBtn.skillname[i]:SetPoint("LEFT", spellBtn.IconFrame[i],"RIGHT", 6, 9)
					spellBtn.skillrank[i]:SetPoint("LEFT", spellBtn.IconFrame[i],"RIGHT", 6, -9)
				else
					spellBtn.skillname[i]:SetPoint("LEFT", spellBtn.IconFrame[i],"RIGHT", 6, 6)
					spellBtn.skillrank[i]:SetPoint("LEFT", spellBtn.IconFrame[i],"RIGHT", 6, -8)
				end

				spellBtn.BgTexture[i]:SetColorTexture(0,0,0,0.4) 

				local favorited = cheatsheetDB.highlightList
				for a = 1, #favorited do
					if favorited[a] == found[i] then
						spellBtn.BgTexture[i]:SetColorTexture(1,1,0,0.2)
					end
				end

				spellBtn.Hitbox[i]:SetScript("OnEnter", function(self)	showSpellTooltip(self, i, spellid) end)
				spellBtn.Hitbox[i]:SetScript("OnLeave", function(self)	hideSpellTooltip(self, i, spellid) end)
				spellBtn.Hitbox[i]:SetScript("OnClick", function(self, button) 	toggleState(self, button, i, spellid) getHyperlinkForChat(self, button, spellid) end)
			end
		end
	end
end




--------------------------------------------------------------------------------------------------------------------
-- artifact content update
--------------------------------------------------------------------------------------------------------------------

local function getArtifactContent()

	for i = 1, 20 do

		local name, rank, icon = GetSpellInfo(getSpell("artifact", i))
		local spellid = getSpell("artifact",i)

		artifact.Hitbox[i]:Show()artifact.Bg[i]:Show()artifact.IconFrame[i]:Show() artifact.skillname[i]:Show() artifact.skillrank[i]:Show() 
		artifact.Icon[i]:SetTexture(icon) artifact.skillname[i]:SetText(name) artifact.skillrank[i]:SetText(rank)

		if (artifact.skillname[i]:GetHeight()> 13) then
			artifact.skillname[i]:SetPoint("LEFT", artifact.Icon[i],"RIGHT", 6, 9)
			artifact.skillrank[i]:SetPoint("LEFT", artifact.Icon[i],"RIGHT", 6, -9)
		else
			artifact.skillname[i]:SetPoint("LEFT", artifact.Icon[i],"RIGHT", 6, 6)
			artifact.skillrank[i]:SetPoint("LEFT", artifact.Icon[i],"RIGHT", 6, -8)
		end

		artifact.BgTexture[i]:SetColorTexture(0,0,0,0.4)

		local favorited = cheatsheetDB.highlightList
		for a = 1, #favorited do
			if(favorited[a] == getSpell("artifact",i)) then
				--print("highlight exists "..getSpell("artifact",i)..", setting it up")
				artifact.BgTexture[i]:SetColorTexture(1,1,0,0.2)
			end
		end

		artifact.Hitbox[i]:SetScript("OnEnter", function(self)			showSpellTooltip(self, i, spellid) end)
		artifact.Hitbox[i]:SetScript("OnLeave", function(self) 			hideSpellTooltip(self, i, spellid) end)
		artifact.Hitbox[i]:SetScript("OnClick", function(self, button) 	toggleState(self, button, i, spellid) getHyperlinkForChat(self,button, spellid)  end)	
	end

	specButton1:Show() specButton2:Show() specButton3:Show() specButton4:Show()

	artifact.skillrank[2]:SetText("Major")
	artifact.skillrank[3]:SetText("Major")
	artifact.skillrank[4]:SetText("Major")
	artifact.skillrank[5]:SetText("Major")
end


-------------------------------------------------------------------------------------------------------------------------------------
-- Reload function to be called every time user changes selected class/spec/tab in main addon frame, refreshes all content
-------------------------------------------------------------------------------------------------------------------------------------

local function refresPage(isSecondPage)

	local function refreshPortait()

		local function setPortaitToSpec(a,b,c,d)
			if (specIndex == 1) then SetPortraitToTexture("cheatsheet_SpellbookFramePortrait", a) end
			if (specIndex == 2) then SetPortraitToTexture("cheatsheet_SpellbookFramePortrait", b) end
			if (specIndex == 3) then SetPortraitToTexture("cheatsheet_SpellbookFramePortrait", c) end
			if (specIndex == 4) then SetPortraitToTexture("cheatsheet_SpellbookFramePortrait", d) end
		end
		if 		(selectedClass == "MAGE") 		then 
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(62) 	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(63)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(64) 	
			setPortaitToSpec (icon1,icon2,icon3)
		elseif 	(selectedClass == "PALADIN") 	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(65)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(66)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(70)	
			setPortaitToSpec (icon1,icon2,icon3)
		elseif 	(selectedClass == "WARRIOR")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(71)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(72)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(73)	
			setPortaitToSpec (icon1,icon2,icon3)
		elseif 	(selectedClass == "DRUID")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(102)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(103)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(104)	
			local id4,name4,desc4,icon4 = GetSpecializationInfoByID(105)
			setPortaitToSpec (icon1,icon2,icon3,icon4)
		elseif 	(selectedClass == "DEATHKNIGHT")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(250)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(251)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(252)	
			setPortaitToSpec (icon1,icon2,icon3)
		elseif 	(selectedClass == "HUNTER")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(253)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(254)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(255)	
			setPortaitToSpec (icon1,icon2,icon3)
		elseif 	(selectedClass == "PRIEST")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(256)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(257)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(258)	
			setPortaitToSpec (icon1,icon2,icon3)
		elseif 	(selectedClass == "ROGUE")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(259)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(260)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(261)	
			setPortaitToSpec (icon1,icon2,icon3)
		elseif	(selectedClass == "SHAMAN")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(262)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(263)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(264)	
			setPortaitToSpec (icon1,icon2,icon3)
		elseif	(selectedClass == "WARLOCK")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(265)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(266)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(267)	
			setPortaitToSpec (icon1,icon2,icon3)
		elseif	(selectedClass == "MONK")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(268)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(269)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(270)	
			setPortaitToSpec (icon1,icon2,icon3)
		elseif	(selectedClass == "DEMONHUNTER")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(577)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(581)
			setPortaitToSpec (icon1,icon2)
		end
	end

	local function refreshSpecButtons()

		local function setSpecButtonTextures(a,b,c,d)
			specBtnTexture1:SetTexture(a)	
			specBtnTexture2:SetTexture(b)
			specBtnTexture3:SetTexture(c)	
			specBtnTexture4:SetTexture(d)
		end

		if 		(selectedClass == "MAGE") 		then 
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(62)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(63)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(64)	
			setSpecButtonTextures (icon1,icon2,icon3)
		elseif 	(selectedClass == "PALADIN") 	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(65) 	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(66)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(70)	
			setSpecButtonTextures (icon1,icon2,icon3)
		elseif 	(selectedClass == "WARRIOR")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(71)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(72)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(73)	
			setSpecButtonTextures (icon1,icon2,icon3)
		elseif 	(selectedClass == "DRUID")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(102)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(103)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(104)	
			local id4,name4,desc4,icon4 = GetSpecializationInfoByID(105)
			setSpecButtonTextures (icon1,icon2,icon3,icon4)
		elseif 	(selectedClass == "DEATHKNIGHT")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(250)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(251)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(252)	
			setSpecButtonTextures (icon1,icon2,icon3)
		elseif 	(selectedClass == "HUNTER")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(253)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(254)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(255)	
			setSpecButtonTextures (icon1,icon2,icon3)
		elseif 	(selectedClass == "PRIEST")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(256)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(257)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(258)	
			setSpecButtonTextures (icon1,icon2,icon3)
		elseif 	(selectedClass == "ROGUE")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(259)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(260)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(261)	
			setSpecButtonTextures (icon1,icon2,icon3)
		elseif	(selectedClass == "SHAMAN")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(262)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(263)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(264)	
			setSpecButtonTextures (icon1,icon2,icon3)
		elseif	(selectedClass == "WARLOCK")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(265)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(266)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(267)	
			setSpecButtonTextures (icon1,icon2,icon3)
		elseif	(selectedClass == "MONK")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(268)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(269)
			local id3,name3,desc3,icon3 = GetSpecializationInfoByID(270)	
			setSpecButtonTextures (icon1,icon2,icon3)
		elseif	(selectedClass == "DEMONHUNTER")  	then
			local id1,name1,desc1,icon1 = GetSpecializationInfoByID(577)	
			local id2,name2,desc2,icon2 = GetSpecializationInfoByID(581)
			setSpecButtonTextures (icon1,icon2) 
		end
	end

	local function refreshSpecTitle()
		specTitle:SetText(getSpec(specIndex))
		specTitle:SetTextColor(returnClassColor())
		specTitle:Show()
	end

	clearContent()

	if (currentPage == "traits") then
		getArtifactContent()
	elseif (isSecondPage) then
		getSpellbookContent("spells",1)
	else
		getSpellbookContent(currentPage)
	end

	refreshPortait()
	refreshSpecButtons()
	refreshSpecTitle()

	if (currentPage ~= "spells" and currentPage ~= "traits") then
		for i=1, 6 do separatorTexture[i]:Show() end
	elseif (currentPage == "traits") then
		separatorTexture[7]:Show()
	end
end



--------------------------------------------------------------------------------------------------------------------------
-- Main addon frame initialization / button scripts 
--------------------------------------------------------------------------------------------------------------------------

local function cheatsheet_SpellbookFrameOpen()

	PlaySound("igQuestListOpen")

	if UIConfig == nil then 
		UIConfig = CreateFrame("Frame","cheatsheet_SpellbookFrame", UIParent, "PortraitFrameTemplate")
		UIConfig:SetSize(560,600) --width height
		UIConfig:SetAlpha(1.0)
		UIConfig:SetPoint("CENTER", UIParent, "CENTER") -- point, relativeframe, relativepoint, xoffset yffset
		UIConfig:SetMovable(true)
		UIConfig:EnableMouse(true)
		UIConfig.Bg:SetAlpha(0.8)
		UIConfig.Bg:SetColorTexture(0,0,0,0.8)
		UIConfig:SetScale(cheatsheetDB["scale"])
		UIConfig:RegisterForDrag("LeftButton")
		UIConfig:SetScript("OnDragStart", UIConfig.StartMoving)
		UIConfig:SetScript("OnDragStop", UIConfig.StopMovingOrSizing)


		----------------------------------------------------------------------------------------------------------------------
		--Setup content anchor for positioning and hiding content 
		---------------------------------------------------------------------------------------------------------------------

		contentAnchor = CreateFrame("Frame", nil, UIConfig)
		contentAnchor:SetAlpha(1.0)
		contentAnchor:SetPoint("TOPLEFT", UIConfig, "TOPLEFT")


		----------------------------------------------------------------------------------------------------------------------
		-- Title frame 
		---------------------------------------------------------------------------------------------------------------------

		local title = UIConfig:CreateFontString(nil, "OVERLAY")
		title:SetFontObject("GameFontHighlight")
		title:SetTextColor(1,1,0,1)
		title:SetPoint("CENTER", UIConfig,"TOP", 0, -12)
		title:SetText(addonName.." "..forWowVersion)


		----------------------------------------------------------------------------------------------------------------------
		-- Content initialize, spellbook
		---------------------------------------------------------------------------------------------------------------------

		local x = 25
		local x2 = 25
		local y = -85
		local y2 = -225
		local rowCounter = 1
		local columnCounter = 1

		for i = 1, 21 do 
			makeSpellButton(spellBtn, i, x, y)

			if (columnCounter>=3) then columnCounter = 1 y = y-63
			else columnCounter = columnCounter + 1 end

			if (rowCounter>=3) then rowCounter = 1 x = 25
			else x = x + 175 rowCounter = rowCounter + 1 end
		end 

		----------------------------------------------------------------------------------------------------------------------
		-- content initialize, artifact
		---------------------------------------------------------------------------------------------------------------------

		makeSpellButton(artifact, 1, 25, -85) 

		for i = 2, 5 do
			makeSpellButton(artifact, i, x2, -155)
			x2 = x2 + 175
		end

		for i = 6, 20 do
			makeSpellButton(artifact, i, x, y2) 

			if (columnCounter>=3) then columnCounter = 1 y2 = y2 - 59
	 		else columnCounter = columnCounter + 1 end

			if (rowCounter>=3) then rowCounter = 1 x = 25
			else x = x + 175 rowCounter = rowCounter + 1 end
		end

		artifact.Hitbox[1]:SetWidth(335) 
		artifact.Hitbox[1]:SetHeight(50)
		artifact.Bg[1]:SetWidth(335) 
		artifact.Bg[1]:SetHeight(50) 
		artifact.skillname[1]:SetWidth(200)

		artifact.Hitbox[5]:SetPoint("TOPLEFT", UIConfig, "TOPLEFT", 375, -85) 
		artifact.Bg[5]:SetPoint("TOPLEFT", UIConfig, "TOPLEFT", 375, -85)


		----------------------------------------------------------------------------------------------------------------------
		-- Tier Separator initialize
		---------------------------------------------------------------------------------------------------------------------
		
		local yGap = -142
		for i=1, 7 do
			separatorTexture[i] = contentAnchor:CreateTexture(nil,"ARTWORK")
			separatorTexture[i]:SetColorTexture(0,0.6,0.6,0.7)
			separatorTexture[i]:SetWidth(510)
			separatorTexture[i]:SetHeight(1)
			separatorTexture[i]:SetPoint("TOPLEFT", UIConfig, "TOPLEFT", 25, yGap) 
			yGap = yGap - 63
		end
		separatorTexture[7]:SetPoint("TOPLEFT", UIConfig, "TOPLEFT", 25, -215)


		----------------------------------------------------------------------------------------------------------------------
		-- Initialize tab buttons "Spells" "Talents" "Honor" "Artifact"   
		---------------------------------------------------------------------------------------------------------------------

		local SpellbookButton = CreateFrame("Button", nil, UIConfig, "UIGoldBorderButtonTemplate")
		SpellbookButton:SetPoint("BOTTOMLEFT", UIConfig, "BOTTOMLEFT", 60, 20)
		SpellbookButton:SetSize(100,29)
		SpellbookButton:SetText("Spellbook")
		SpellbookButton:SetNormalFontObject("GameFontNormalLarge")
		SpellbookButton:SetHighlightFontObject("GameFontHighlightLarge")

		local talentButton = CreateFrame("Button", nil, UIConfig, "UIGoldBorderButtonTemplate")
		talentButton:SetPoint("BOTTOMLEFT", SpellbookButton, "BOTTOMLEFT", 110, 0)
		talentButton:SetSize(100,29)
		talentButton:SetText("Talents")
		talentButton:SetNormalFontObject("GameFontNormalLarge")
		talentButton:SetHighlightFontObject("GameFontHighlightLarge")

		local pvpTalentButton = CreateFrame("Button", nil, UIConfig, "UIGoldBorderButtonTemplate")
		pvpTalentButton:SetPoint("BOTTOMLEFT", talentButton, "BOTTOMLEFT", 110, 0)
		pvpTalentButton:SetSize(100,29)
		pvpTalentButton:SetText("Honor")
		pvpTalentButton:SetNormalFontObject("GameFontNormalLarge")
		pvpTalentButton:SetHighlightFontObject("GameFontHighlightLarge")

		local traitButton = CreateFrame("Button", nil, UIConfig, "UIGoldBorderButtonTemplate")
		traitButton:SetPoint("BOTTOMLEFT", pvpTalentButton, "BOTTOMLEFT", 110, 0)
		traitButton:SetSize(100,29)
		traitButton:SetText("Artifact")
		traitButton:SetNormalFontObject("GameFontNormalLarge")
		traitButton:SetHighlightFontObject("GameFontHighlightLarge")

		local searchBox = CreateFrame("EditBox", "SearchBox", UIConfig, "SearchBoxTemplate")
		searchBox:SetPoint("BOTTOMLEFT", SpellbookButton, "BOTTOMLEFT", 60, 35)
		searchBox:SetSize(330,30)
		searchBox:SetFontObject("GameFontNormalLarge")
		searchBox:SetMaxLetters(25)
		


		----------------------------------------------------------------------------------------------------------------------
		-- Initialize specialization index buttons		
		---------------------------------------------------------------------------------------------------------------------

		specButton4 = CreateFrame("Button", nil, contentAnchor)
		specButton4:SetPoint("TOPRIGHT", UIConfig, "TOPRIGHT", -25, -35)
		specButton4:SetSize(36,36)
		specBtnTexture4 = specButton4:CreateTexture(nil,"CENTER")
		specBtnTexture4:SetAllPoints(specButton4)
		highlightTex4 = specButton4:CreateTexture(nil, "HIGHLIGHT")
		highlightTex4:SetAllPoints(true)
		highlightTex4:SetColorTexture(1, 1, 0, 0.4)

		specButton3 = CreateFrame("Button", nil, contentAnchor)
		specButton3:SetPoint("RIGHT", specButton4, "LEFT", -5, 0)
		specButton3:SetSize(36,36)
		specBtnTexture3 = specButton3:CreateTexture(nil,"CENTER")
		specBtnTexture3:SetAllPoints(specButton3)
		highlightTex3 = specButton3:CreateTexture(nil, "HIGHLIGHT")
		highlightTex3:SetAllPoints(true)
		highlightTex3:SetColorTexture(1, 1, 0, 0.4)

		specButton2 = CreateFrame("Button", nil, contentAnchor)
		specButton2:SetPoint("RIGHT", specButton3, "LEFT", -5, 0)
		specButton2:SetSize(36,36)
		specBtnTexture2 = specButton2:CreateTexture(nil,"CENTER")
		specBtnTexture2:SetAllPoints(specButton2)
		highlightTex2 = specButton2:CreateTexture(nil, "HIGHLIGHT")
		highlightTex2:SetAllPoints(true)
		highlightTex2:SetColorTexture(1, 1, 0, 0.4)

		specButton1 = CreateFrame("Button", nil, contentAnchor)
		specButton1:SetPoint("RIGHT", specButton2, "LEFT", -5, 0)
		specButton1:SetSize(36,36)
		specBtnTexture1 = specButton1:CreateTexture(nil,"CENTER")
		specBtnTexture1:SetAllPoints(specButton1)
		highlightTex1 = specButton1:CreateTexture(nil, "HIGHLIGHT")
		highlightTex1:SetAllPoints(true)
		highlightTex1:SetColorTexture(1, 1, 0, 0.4)


		----------------------------------------------------------------------------------------------------------------------
		-- Initialize page buttons for spells tab 
		---------------------------------------------------------------------------------------------------------------------

		pageButton = CreateFrame("Button", nil, contentAnchor, "UIGoldBorderButtonTemplate")
		pageButton:SetPoint("TOPLEFT", UIConfig, "TOPLEFT", 65, -40)
		pageButton:SetSize(40,30)
		pageButton:SetText(" 1 ")
		pageButton:SetNormalFontObject("GameFontNormalLarge")
		pageButton:SetHighlightFontObject("GameFontHighlightLarge")

		pageButton2 = CreateFrame("Button", nil, contentAnchor, "UIGoldBorderButtonTemplate")
		pageButton2:SetPoint("LEFT", pageButton, "RIGHT", 5, 0)
		pageButton2:SetSize(40,30)
		pageButton2:SetText(" 2 ")
		pageButton2:SetNormalFontObject("GameFontNormalLarge")
		pageButton2:SetHighlightFontObject("GameFontHighlightLarge")


		----------------------------------------------------------------------------------------------------------------------
		-- Initialize specialication title text
		---------------------------------------------------------------------------------------------------------------------	

		specTitle = contentAnchor:CreateFontString(nil, "OVERLAY")
		specTitle:SetFont("Fonts\\FRIZQT__.TTF", 25, "THICKOUTLINE")
		specTitle:SetFontObject("GameFontHighlight")
		specTitle:SetPoint("CENTER", UIConfig,"CENTER", 0, 240)


		----------------------------------------------------------------------------------------------------------------------
		-- Initialize welcome text
		---------------------------------------------------------------------------------------------------------------------	

		--welcomeText = contentAnchor:CreateFontString(nil, "OVERLAY")
		--welcomeText:SetFont("Fonts\\FRIZQT__.TTF", 25, "THICKOUTLINE")
		--welcomeText:SetFontObject("GameFontHighlight")
		--welcomeText:SetPoint("CENTER", UIConfig,"CENTER", 0, 100)
		--welcomeText:SetText("Seach library by using search window or browse with")
		--welcomeText:SetWidth(200)


		----------------------------------------------------------------------------------------------------------------------
		-- Initialize class selection frame and buttons
		---------------------------------------------------------------------------------------------------------------------
		
		local classSelct = CreateFrame("Frame","PvPManual_ClassFrame", UIConfig, "TranslucentFrameTemplate")
		classSelct:SetSize(510,62) 
		classSelct:SetPoint("TOP", UIConfig, "BOTTOM", 0, 20)

		local classIcon = {}
		local classIconGet = nil
		local xValueClassIcon = 17
		local yValueClassIcon = 0

		for i = 1, 12 do

			classIcon[i] = CreateFrame("Button", nil, classSelct)
			classIcon[i]:SetFrameStrata("MEDIUM")
			classIcon[i]:SetWidth(36) 
			classIcon[i]:SetHeight(36) 
			classIcon[i]:SetPoint("LEFT", classSelct, "LEFT", xValueClassIcon, yValueClassIcon)
			classIcon[i]:Show()

			local classIconTexture = classIcon[i]:CreateTexture(nil,"CENTER")
			classIconTexture:SetAllPoints(classIcon[i])
			classIconTexture:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")

			if 		(i == 1) then classIconGet = "MAGE"  		elseif 	(i == 2) then classIconGet = "PALADIN" 
			elseif 	(i == 3) then classIconGet = "WARRIOR"		elseif 	(i == 4) then classIconGet = "DRUID"
			elseif 	(i == 5) then classIconGet = "DEATHKNIGHT"	elseif 	(i == 6) then classIconGet = "HUNTER"
			elseif 	(i == 7) then classIconGet = "PRIEST"		elseif 	(i == 8) then classIconGet = "ROGUE"
			elseif 	(i == 9) then classIconGet = "SHAMAN"		elseif 	(i == 10) then classIconGet = "WARLOCK"
			elseif 	(i == 11)then classIconGet = "MONK"			elseif 	(i == 12) then classIconGet = "DEMONHUNTER"
			end
			
			local coords = CLASS_ICON_TCOORDS[classIconGet]
			classIconTexture:SetTexCoord(unpack(coords))

			local highlightTexture = classIcon[i]:CreateTexture(nil, "HIGHLIGHT")
			highlightTexture:SetAllPoints(true)
			highlightTexture:SetColorTexture(1, 1, 0, 0.4)

			xValueClassIcon = xValueClassIcon+40
		end


		----------------------------------------------------------------------------------------------------------------------
		-- Button highlight lock 
		---------------------------------------------------------------------------------------------------------------------

		local function lockHL(a,b)
			if (b == "class") then
				for i = 1, 12 do classIcon[i]:UnlockHighlight() end
			elseif (b == "spec") then
				specButton1:UnlockHighlight()
				specButton2:UnlockHighlight()
				specButton3:UnlockHighlight()
				specButton4:UnlockHighlight()
			elseif (b == "tab") then 
				SpellbookButton:UnlockHighlight()
				talentButton:UnlockHighlight()
				traitButton:UnlockHighlight()
				pvpTalentButton:UnlockHighlight()
			 end
			 a:LockHighlight()
		end


		----------------------------------------------------------------------------------------------------------------------
		-- Preventing some bugs with specindex and uneven specialization numbers (druid/demonhunter)
		---------------------------------------------------------------------------------------------------------------------

		local function confineSpec()

			if 	selectedClass == "DRUID" then	
				specButton3:Enable() 	
				specButton4:Enable() 	
				specButton4:SetPoint("TOPRIGHT", UIConfig, "TOPRIGHT", -25, -35) 
			elseif 	selectedClass == "DEMONHUNTER" 	then
				if specIndex > 2 then 
					specIndex = 2
					lockHL(specButton2,"spec")	
				end
				specButton3:Disable() 	
				specButton4:Disable() 	
				specButton4:SetPoint("TOPRIGHT", UIConfig, "TOPRIGHT", 57, -35) 
			else
				if specIndex > 3 then 
					specIndex = 3
					lockHL(specButton3,"spec")
				end 											
				specButton3:Enable() 	
				specButton4:Disable() 	
				specButton4:SetPoint("TOPRIGHT", UIConfig, "TOPRIGHT", 16, -35) 
			end
		end


		----------------------------------------------------------------------------------------------------------------------
		-- Setup default values for initial shown window (spells / playerclass / playerspec)
		---------------------------------------------------------------------------------------------------------------------

		specIndex = GetSpecialization()
		if (specIndex == nil) then specIndex = 1 end

		nonLocalised, selectedClass = UnitClass("player")
		currentPage  = "spells"

		confineSpec()

		----------------------------------------------------------------------------------------------------------------------
		--Load locked higlight for initial tab-button / spec-button / class-selection / initial confine spec
		---------------------------------------------------------------------------------------------------------------------
		

		
		
		lockHL(SpellbookButton,"tab") --ALWAYS DEFAULT

		if 		specIndex == 1 then lockHL(specButton1,"spec") 
		elseif 	specIndex == 2 then lockHL(specButton2,"spec")
		elseif 	specIndex == 3 then lockHL(specButton3,"spec")
		elseif	specIndex == 4 then lockHL(specButton4,"spec")
		end
		
		if 		selectedClass == "MAGE" 		then lockHL(classIcon[1],"class")
		elseif 	selectedClass == "PALADIN" 		then lockHL(classIcon[2],"class")
		elseif 	selectedClass == "WARRIOR"	 	then lockHL(classIcon[3],"class")
		elseif 	selectedClass == "DRUID" 		then lockHL(classIcon[4],"class")
		elseif 	selectedClass == "DEATHKNIGHT" 	then lockHL(classIcon[5],"class")
		elseif 	selectedClass == "HUNTER" 		then lockHL(classIcon[6],"class")
		elseif 	selectedClass == "PRIEST" 		then lockHL(classIcon[7],"class")
		elseif 	selectedClass == "ROGUE"		then lockHL(classIcon[8],"class")
		elseif 	selectedClass == "SHAMAN" 		then lockHL(classIcon[9],"class")
		elseif 	selectedClass == "WARLOCK" 		then lockHL(classIcon[10],"class")
		elseif 	selectedClass == "MONK" 		then lockHL(classIcon[11],"class")
		elseif 	selectedClass == "DEMONHUNTER" 	then lockHL(classIcon[12],"class") 
		end


		----------------------------------------------------------------------------------------------------------------------
		--- Add button functionality to all main buttons
		---------------------------------------------------------------------------------------------------------------------

		SpellbookButton:SetScript("OnClick", function(self) currentPage = "spells" 		lockHL(self,"tab") refresPage() end)
		talentButton:SetScript("OnClick", 	 function(self) currentPage = "talents" 	lockHL(self,"tab") refresPage() end)
		pvpTalentButton:SetScript("OnClick", function(self) currentPage = "pvpTalents"	lockHL(self,"tab") refresPage() end)
		traitButton:SetScript("OnClick",  	 function(self) currentPage = "traits"		lockHL(self,"tab") refresPage() end)

		searchBox:SetScript("OnTextChanged",	function(self, i)	getSearchResults(searchBox:GetText(), i) end)
		searchBox:SetScript("OnEnterPressed",	function(self) 		getSearchResults(searchBox:GetText(), true) end)
		searchBox:SetScript("OnEscapePressed",	function(self) 		searchBox:ClearFocus() end)
		searchBox:SetScript("OnEditFocusGained",function(self) 		SearchBox.Instructions:SetText("") end)
		searchBox:SetScript("OnEditFocusLost",	function(self) 		if string.len(searchBox:GetText()) < 1 then SearchBox.Instructions:SetText("Search") end end)

		specButton1:SetScript("OnClick", function(self) specIndex = 1 refresPage() lockHL(self,"spec") end)
		specButton2:SetScript("OnClick", function(self) specIndex = 2 refresPage() lockHL(self,"spec") end)
		specButton3:SetScript("OnClick", function(self) specIndex = 3 refresPage() lockHL(self,"spec") end)
		specButton4:SetScript("OnClick", function(self) specIndex = 4 refresPage() lockHL(self,"spec") end)

		classIcon[1]:SetScript("OnClick", function(self)  lockHL(self,"class")  selectedClass = ("MAGE") 		confineSpec() 	refresPage() end)
		classIcon[2]:SetScript("OnClick", function(self)  lockHL(self,"class")	selectedClass = ("PALADIN")		confineSpec()	refresPage() end)
		classIcon[3]:SetScript("OnClick", function(self)  lockHL(self,"class")	selectedClass = ("WARRIOR")		confineSpec()	refresPage() end)
		classIcon[4]:SetScript("OnClick", function(self)  lockHL(self,"class") 	selectedClass = ("DRUID")		confineSpec()	refresPage() end)
		classIcon[5]:SetScript("OnClick", function(self)  lockHL(self,"class")	selectedClass = ("DEATHKNIGHT")	confineSpec()	refresPage() end)
		classIcon[6]:SetScript("OnClick", function(self)  lockHL(self,"class") 	selectedClass = ("HUNTER") 		confineSpec()	refresPage() end)
		classIcon[7]:SetScript("OnClick", function(self)  lockHL(self,"class")	selectedClass = ("PRIEST") 		confineSpec()	refresPage() end)
		classIcon[8]:SetScript("OnClick", function(self)  lockHL(self,"class")	selectedClass = ("ROGUE") 		confineSpec()	refresPage() end)
		classIcon[9]:SetScript("OnClick", function(self)  lockHL(self,"class")	selectedClass = ("SHAMAN") 		confineSpec()	refresPage() end)
		classIcon[10]:SetScript("OnClick", function(self) lockHL(self,"class")	selectedClass = ("WARLOCK")		confineSpec()	refresPage() end)
		classIcon[11]:SetScript("OnClick", function(self) lockHL(self,"class")	selectedClass = ("MONK") 		confineSpec()	refresPage() end)
		classIcon[12]:SetScript("OnClick", function(self) lockHL(self,"class")	selectedClass = ("DEMONHUNTER") confineSpec()	refresPage() end)

		pageButton:SetScript("OnClick", function(self) 	refresPage()	end)
		pageButton2:SetScript("OnClick", function(self)	refresPage(1)	end)	
	else 
		UIConfig:Show()
	end																				
end


--------------------------------------------------------------------------------------------------------------------------------------
-- Minimap button libraries, setup minimap button (register in init)
--------------------------------------------------------------------------------------------------------------------------------------

local LDB = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LDB and LibStub("LibDBIcon-1.0", true)

local cheatsheet_Launcher = LDB:NewDataObject("Cheatsheet", {
	type = "launcher",
	text = "Cheatsheet",
	icon = "Interface\\ICONS\\INV_Scroll_14.blp",
	OnClick = function(clickedframe, button)
	    if button == "LeftButton" then 
	    	if (UIConfig and UIConfig:IsShown()) then 
	    		UIConfig:Hide()
	    	else 
	    		cheatsheet_SpellbookFrameOpen()
	    		refresPage()
	    	end
	    elseif button == "RightButton" then 
	    	if (InterfaceOptionsFrame:IsShown()) then
	    		return
	    	else
	    		InterfaceOptionsFrame_OpenToCategory(addonName)
				InterfaceOptionsFrame_OpenToCategory(addonName)
			end
	    end  
	end,
	OnTooltipShow = function(tt)
		tt:AddLine("Cheatsheet")
		tt:AddLine("LeftcLick to toggle addon",1,1,1)
		tt:AddLine("Rightclick to open config",1,1,1)
	end	
})


--------------------------------------------------------------------------------------------------------------------------------------
-- Interface options, setup (register in init)
--------------------------------------------------------------------------------------------------------------------------------------

local cheatsheetConfig = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
cheatsheetConfig:SetAllPoints()
cheatsheetConfig:Hide();
cheatsheetConfig.name = addonName

local cheatsheetConfigTitle = cheatsheetConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
cheatsheetConfigTitle:SetPoint("TOPLEFT", 16, -16)
cheatsheetConfigTitle:SetText(cheatsheetConfig.name)

local subText = cheatsheetConfig:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
subText:SetMaxLines(3)
subText:SetNonSpaceWrap(true)
subText:SetJustifyV('TOP')
subText:SetJustifyH('LEFT')
subText:SetPoint('TOPLEFT', cheatsheetConfigTitle, 'BOTTOMLEFT', 0, -8)
subText:SetPoint('RIGHT', -32, 0)
subText:SetText("Extremely extensive config of Cheatsheet Addon")

local function checkboxClick(self)
	if cheatsheetDB.minimap.hide then
		LDBIcon:Show("Cheatsheet")
		cheatsheetDB.minimap["hide"] = false
	else
		LDBIcon:Hide("Cheatsheet")
		cheatsheetDB.minimap["hide"] = true
	end
end

local function checkboxShow(self)
	if cheatsheetDB.minimap.hide then		        
		self:SetChecked(false)
	else
		self:SetChecked(true)
	end
end

local check = CreateFrame("CheckButton", nil, cheatsheetConfig, "InterfaceOptionsCheckButtonTemplate")
check:ClearAllPoints()
check:SetPoint("TOPLEFT", subText, "BOTTOMLEFT", 0, -26)
check:SetScript("OnClick", checkboxClick)
check:SetScript("OnShow", checkboxShow)

local title2 = cheatsheetConfig:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
title2:SetPoint("TOPLEFT", subText, "BOTTOMLEFT", 25, -34)
title2:SetText("Show minimap button")

local scaleSlider = CreateFrame("Slider", nil , cheatsheetConfig)
scaleSlider:SetPoint("TOPLEFT", check, "BOTTOMLEFT", 0, -50)
scaleSlider:SetWidth(150)
scaleSlider:SetHeight(20)
scaleSlider:SetOrientation("HORIZONTAL")
scaleSlider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
scaleSlider:SetMinMaxValues(70,100)
scaleSlider:SetValueStep(1)
scaleSlider:SetObeyStepOnDrag(true)
scaleSlider:SetBackdrop({
bgFile = "Interface\\Buttons\\UI-SliderBar-Background", 
edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
tile = true, tileSize = 8, edgeSize = 8, 
insets = { left = 3, right = 3, top = 6, bottom = 6 }})

local scaleText = cheatsheetConfig:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
scaleText:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 35, 35)
scaleText:SetText("Frame scale")

local scaleNumberDisp = cheatsheetConfig:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
scaleNumberDisp:SetPoint("LEFT", scaleSlider, "RIGHT", 0, 0)


--------------------------------------------------------------------------------------------------------------------------------------
-- Initialise (addon savedvariables, default values, register minimap button)
--------------------------------------------------------------------------------------------------------------------------------------

local initFrame = CreateFrame("FRAME"); -- Need a frame to respond to events
initFrame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
initFrame:SetScript("OnEvent", function(self, event, loadedAddon)

	if event == "ADDON_LOADED" and loadedAddon == addonName then

		if cheatsheetDB == nil then -- if savedVariables not initialized 
			cheatsheetDB = {} 
			cheatsheetDB["scale"] = 0.95
			cheatsheetDB["positionX"] = "1" 
			cheatsheetDB["positionY"] = "1"
			cheatsheetDB["bgAlpha"] = "1"
			cheatsheetDB["Alpha"] = "1"
			cheatsheetDB["favouritePage"] = "1"
			cheatsheetDB["lastPage"] = "1"
			cheatsheetDB.highlightList = {}
			cheatsheetDB.minimap = {} 
			cheatsheetDB.minimap["hide"] = false
		end

	    scaleSlider:SetValue(cheatsheetDB["scale"]*100) 
	    scaleSlider:SetScript("OnValueChanged", function(self, value)
			cheatsheetDB["scale"] = scaleSlider:GetValue()/100
		    scaleNumberDisp:SetText(scaleSlider:GetValue() .."%")
		    if UIConfig then
		    	UIConfig:SetScale(cheatsheetDB["scale"])
		   	end
		end)

	    LDBIcon:Register("Cheatsheet", cheatsheet_Launcher, cheatsheetDB.minimap)
	    InterfaceOptions_AddCategory(cheatsheetConfig, addonName)

	    if cheatsheetDB.minimap.hide then 
			LDBIcon:Hide("Cheatsheet")
		else
			LDBIcon:Show("Cheatsheet")
		end

		SLASH_OPENCHEATSHEET1, SLASH_OPENCHEATSHEET2 = "/cheat", "/cheatsheet"
		
		function SlashCmdList.OPENCHEATSHEET(msg)
			if msg == "config" then
				InterfaceOptionsFrame_OpenToCategory(addonName)
				InterfaceOptionsFrame_OpenToCategory(addonName)	
			else
			    if (UIConfig and UIConfig:IsShown()) then 
			        UIConfig:Hide()
			    else 
			        cheatsheet_SpellbookFrameOpen()
			        refresPage()
			    end	
			end
		end
	end
end)

