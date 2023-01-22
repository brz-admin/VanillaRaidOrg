

strlow = string.lower;
local playerName = UnitName("player");

BRH = {};
BRH.syncPrefix = "BRH_Sync"
BRH.build = "300"

BRH.BS = AceLibrary("Babble-Spell-2.2")

function BRH.print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("BRH: "..msg, 0.50,0.5,1)
end

-- [ BRH.strsplit ]
-- Splits a string using a delimiter.
-- 'delimiter'  [string]        characters that will be interpreted as delimiter
--                              characters (bytes) in the string.
-- 'subject'    [string]        String to split.
-- return:      [list]         s array.
function BRH.strsplit(delimiter, subject)
	if not subject then return nil end
	local delimiter, fields = delimiter or ":", {}
	local pattern = string.format("([^%s]+)", delimiter)
	string.gsub(subject, pattern, function(c) fields[table.getn(fields)+1] = c end)
	return fields
  end

function getTableLength(table)
	for index, val in ipairs(table) do

	end
end

function STC_MIN(seconds)
    local seconds = tonumber(seconds)
    local str;
    if seconds <= 0 then
        return "0";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        str = secs.."s";
        if (math.floor(seconds/60) > 0) then
            str = mins..":"..secs
        elseif (math.floor(seconds/3600) > 0) then
            str = hours..":"..mins..":"..secs;
        end
        
        return str;
    end
end
  
local function unregAddons()
	if (DPSMate ~= nil) then
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_PET_HITS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_PET_MISSES")
		--DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PET_BUFF")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PET_DAMAGE")

		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE") --
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE") --
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_PARTY_HITS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_PARTY_MISSES")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES")

		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES")

		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE") 

		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PARTY_BUFF")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS")

		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_BREAK_AURA")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY")

		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
		DPSMate.Parser:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
		DPSMate.Parser:UnregisterEvent("PLAYER_AURAS_CHANGED")

		DPSMate.Parser:UnregisterEvent("PLAYER_LOGOUT")
		DPSMate.Parser:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end

	if (klhtm ~= nil) then
		-- register events. Strictly after all modules have been loaded.
		for key, subtable in klhtm do
			if type(subtable) == "table" and subtable.myevents then
				
				klhtm.events[key] = { }
				for _, event in subtable.myevents do
					klhtm.frame:UnregisterEvent(event)
					klhtm.events[key][event] = false 
				end
			end
		end
	end
end

local function regAddons()
	if (DPSMate ~= nil) then
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_PET_HITS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_PET_MISSES")
		--DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PET_BUFF")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE")

		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE") --
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE") --
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_PARTY_HITS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_PARTY_MISSES")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES")

		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES")

		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE") 

		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS")

		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_BREAK_AURA")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY")

		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
		DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
		DPSMate.Parser:RegisterEvent("PLAYER_AURAS_CHANGED")

		DPSMate.Parser:RegisterEvent("PLAYER_LOGOUT")
		DPSMate.Parser:RegisterEvent("PLAYER_ENTERING_WORLD")
	end

	if (klhtm ~= nil) then
		-- register events. Strictly after all modules have been loaded.
		for key, subtable in klhtm do
			if type(subtable) == "table" and subtable.myevents then
				
				klhtm.events[key] = { }
				for _, event in subtable.myevents do
					klhtm.frame:RegisterEvent(event)
					klhtm.events[key][event] = true 
				end
			end
		end
	end
end

-- TODO : 
-- Autre fichier avec SpellName TO Icon, devrait correspondre anyway mais faut supprimer les temp
-- Commande pour track spell avec class ( ou all ), vérifier si ça marche bien

-------- SAPPER COUNT DOWN -----------
SCD_canCast = false;
local startCountDown = false;
local countDown = 0;
BRH_SAPPER = {
	["bag"] = nil,
	["slot"] = nil,
};
---------- CHECK ----------
local hasAddon = 0;
local checkStop = 0;
local checking = false;
local raidMembers = {};
---------- LIP ROTA ----------
local LIPRota_CanTaunt = true;
local LIPRota_Timer = nil;
---------- LOOT VACUME ----------
local vacumeName = nil;
local vacumeAttribs = {};
---------- PLSINFU ----------
local askedInfu = nil;
local infuUpTimer = nil;
---------- PLSBOP ----------
local askedBOP = nil;
local BOPUpTimer = nil;
-------------- CD Tracker ----------------
if (BRH_CDTrackerConfig == nil) then
	BRH_CDTrackerConfig = {
		["show"] = true
	}
end

if (BRH_spellsToTrack == nil) then
	BRH_spellsToTrack = {}
end

spellOnCDCheck = {
	["spell"] = {},
	["item"] = {}
};

if BRH_SpellCastCount == nil then
	BRH_SpellCastCount = {}
end

function BRH.trackSpell(class, icon)

	class = strlow(class)
	if (BRH_spellsToTrack[class] == nil) then
		BRH_spellsToTrack[class] = {}
	end

	icon = strlow(icon);
	if (BRH_spellsToTrack[class][icon] == nil) then
		BRH_spellsToTrack[class][icon] = {
			["tracked"] = true, -- If the player using the addon track it ?
			["onCD"] = {}, -- players in cd fromated [playerName] = time when it's up or false.
		}
	end

	BRH_spellsToTrack[class][icon].tracked = true;

	BRH.buildTrackedSpellsGUI()
end

function BRH.unTrackSpell(class, icon)
	class = strlow(class)
	if (BRH_spellsToTrack[class] == nil) then
		BRH_spellsToTrack[class] = {}
	end

	icon = strlow(icon);
	if (BRH_spellsToTrack[class][icon] == nil) then
		BRH_spellsToTrack[class][icon] = {
			["tracked"] = true, -- If the player using the addon track it ?
			["onCD"] = {}, -- players in cd fromated [playerName] = time when it's up or false.
		}
	end
	BRH_spellsToTrack[class][icon].tracked = false;

	BRH.buildTrackedSpellsGUI()
end

BRH_CDTracker = {}
BRH_CDTracker.main = CreateFrame("Frame", "BRH_CDTracker_main")
--BRH_CDTracker.main:ClearAllPoints();
BRH_CDTracker.main:SetPoint("CENTER", "UIParent", "CENTER")
BRH_CDTracker.main:SetWidth(55)
BRH_CDTracker.main:SetHeight(5)
BRH_CDTracker.main:RegisterEvent("RAID_ROSTER_UPDATE")
BRH_CDTracker.main:RegisterEvent("ADDON_LOADED")
BRH_CDTracker.main:SetMovable(true);
BRH_CDTracker.main:EnableMouse(true);
BRH_CDTracker.main:RegisterForDrag("LeftButton");
BRH_CDTracker.main:SetScript("OnDragStart", function() this:StartMoving() end);
BRH_CDTracker.main:SetScript("OnDragStop", function() this:StopMovingOrSizing() end);
function BRH.buildTrackedSpellsGUI()
	local precedentFrame = nil;
	if (BRH_CDTrackerConfig.show) then
		for class, spells in pairs(BRH_spellsToTrack) do
			for spell, datas in pairs(spells) do
				if datas.tracked then
					if (BRH_CDTracker[spell] ~= nil) then
						BRH_CDTracker[spell]:Hide()
						BRH_CDTracker[spell] = nil;
					end
					BRH_CDTracker[spell] = CreateFrame("Frame", "BRH_CDTracker_"..spell, BRH_CDTracker.main);
					if (precedentFrame == nil) then
						BRH_CDTracker[spell]:SetPoint("BOTTOMLEFT", "BRH_CDTracker_main", "BOTTOMLEFT", 2, 2)
					else 
						BRH_CDTracker[spell]:SetPoint("BOTTOMLEFT", precedentFrame, "TOPLEFT")
					end
					precedentFrame = "BRH_CDTracker_"..spell;
					BRH_CDTracker[spell]:SetWidth(50)
					BRH_CDTracker[spell]:SetHeight(20)
					BRH_CDTracker.main:SetHeight(BRH_CDTracker.main:GetHeight() + 20)
					BRH_CDTracker[spell]:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
					BRH_CDTracker[spell]:SetBackdropColor(0,0,0,0.5);
					BRH_CDTracker[spell]:EnableMouse();
					BRH_CDTracker[spell].icon = CreateFrame("Frame", "BRH_CDTracker_"..spell.."icon", BRH_CDTracker[spell]);
					BRH_CDTracker[spell].icon:SetPoint("LEFT", "BRH_CDTracker_"..spell, "LEFT")
					BRH_CDTracker[spell].icon:SetWidth(20)
					BRH_CDTracker[spell].icon:SetHeight(20)
					BRH_CDTracker[spell].icontex = BRH_CDTracker[spell]:CreateTexture("BRH_CDTracker_"..spell.."_icon_texture", "OVERLAY")
					BRH_CDTracker[spell].icontex:SetAllPoints(BRH_CDTracker[spell].icon );
					BRH_CDTracker[spell].icontex:SetTexture(spell)
					BRH_CDTracker[spell].icontex:SetTexCoord(0.1,0.9,0.1,0.9)
					BRH_CDTracker[spell].textZone = CreateFrame("Frame", "BRH_CDTracker_"..spell.."textZone", BRH_CDTracker[spell]);
					BRH_CDTracker[spell].textZone:SetPoint("RIGHT", "BRH_CDTracker_"..spell, "RIGHT", -2, 0)
					BRH_CDTracker[spell].textZone:SetWidth(30)
					BRH_CDTracker[spell].textZone:SetHeight(20)
					BRH_CDTracker[spell].text = BRH_CDTracker[spell]:CreateFontString("BRH_CDTracker_"..spell.."count", "ARTWORK", "GameFontWhite")
					BRH_CDTracker[spell].text:SetAllPoints("BRH_CDTracker_"..spell.."textZone");
					BRH_CDTracker[spell].text:SetText("/");
					BRH_CDTracker[spell].text:SetFont("Fonts\\FRIZQT__.TTF", 8)
					BRH_CDTracker[spell].text:SetTextColor(1, 1, 1, 1);
					BRH_CDTracker[spell].playersFrame = CreateFrame("Frame", "BRH_CDTracker_"..spell.."_PlayerFrame", BRH_CDTracker[spell]);
					BRH_CDTracker[spell].playersFrame:SetPoint("TOPLEFT", "BRH_CDTracker_"..spell, "TOPRIGHT", 5, 0);
					BRH_CDTracker[spell].playersFrame:SetWidth(80) 
					BRH_CDTracker[spell].playersFrame:SetHeight(10)
					BRH_CDTracker[spell].playersFrame:Hide();
					BRH_CDTracker[spell].playersFrames = {}
					BRH_CDTracker[spell]:SetScript("OnEnter", function() this.playersFrame:Show() end)
					BRH_CDTracker[spell]:SetScript("OnLeave", function() this.playersFrame:Hide() end)
				else
					if (BRH_CDTracker[spell] ~= nil) then
						BRH_CDTracker[spell]:Hide();
					end
				end
			end
		end
		BRH.updateGUI();
	end
end

function BRH.getTrackedSpellsInRaid()
	-- not in raid, nothing to do here
	if (not UnitInRaid("Player")) then
		return
	end
	--BRH.addonCom("getTrackedSpells", "")
end

function BRH.updateGUI()
	for class, spells in pairs(BRH_spellsToTrack) do
		for spell, datas in pairs(spells) do
			if datas.tracked then
				local up, max = 0, 0;
				precedentpFrame = nil;
				for player, cd in pairs(datas.onCD) do
					if (BRH_CDTracker[spell].playersFrames[player] == nil) then
						BRH_CDTracker[spell].playersFrames[player] = {}; 
						BRH_CDTracker[spell].playersFrames[player].textZone = CreateFrame("Frame", "BRH_CDTracker_"..spell.."_playersFrames_"..player.."_textZone", BRH_CDTracker[spell].playersFrame);
						if (precedentpFrame == nil) then
							BRH_CDTracker[spell].playersFrames[player].textZone:SetPoint("TOPLEFT", "BRH_CDTracker_"..spell.."_PlayerFrame", "TOPLEFT", 0, 0)
						else
							BRH_CDTracker[spell].playersFrames[player].textZone:SetPoint("TOPLEFT", precedentpFrame, "BOTTOMLEFT", 0, 0)
						end
						precedentpFrame = BRH_CDTracker[spell].playersFrames[player].textZone;
						BRH_CDTracker[spell].playersFrames[player].textZone:SetWidth(80)
						BRH_CDTracker[spell].playersFrames[player].textZone:SetHeight(10)
						BRH_CDTracker[spell].playersFrames[player].textZone:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
						BRH_CDTracker[spell].playersFrames[player].textZone:SetBackdropColor(0,0,0,0.5);
						BRH_CDTracker[spell].playersFrames[player].playerName = BRH_CDTracker[spell].playersFrames[player].textZone:CreateFontString("BRH_CDTracker_"..spell.."_playersFrames_"..player.."_Name", "ARTWORK", "GameFontWhite")
						BRH_CDTracker[spell].playersFrames[player].playerName:SetPoint("LEFT", "BRH_CDTracker_"..spell.."_playersFrames_"..player.."_textZone", "LEFT", 2, 0);
						BRH_CDTracker[spell].playersFrames[player].playerName:SetText(player);
						BRH_CDTracker[spell].playersFrames[player].playerName:SetFont("Fonts\\FRIZQT__.TTF", 6)
						BRH_CDTracker[spell].playersFrames[player].playerName:SetTextColor(1, 1, 1, 1);
						BRH_CDTracker[spell].playersFrames[player].cd = BRH_CDTracker[spell].playersFrames[player].textZone:CreateFontString("BRH_CDTracker_"..spell.."_playersFrames_"..player.."_cd", "ARTWORK", "GameFontWhite")
						BRH_CDTracker[spell].playersFrames[player].cd:SetPoint("RIGHT", "BRH_CDTracker_"..spell.."_playersFrames_"..player.."_textZone", "RIGHT", -2, 0);
						BRH_CDTracker[spell].playersFrames[player].cd:SetText("Up !");
						BRH_CDTracker[spell].playersFrames[player].cd:SetFont("Fonts\\FRIZQT__.TTF", 6)
						BRH_CDTracker[spell].playersFrames[player].cd:SetTextColor(1, 1, 1, 1);
					end
					if (not cd) then 
						up = up+1 
					elseif (cd ~= "-1" and cd <= GetTime()) then 
						BRH_spellsToTrack[class][spell].onCD[player] = false;
						BRH_CDTracker[spell].playersFrames[player].cd:SetText("Up !");
						up = up+1 
					else
						BRH_CDTracker[spell].playersFrames[player].cd:SetText(STC_MIN(cd-GetTime()));
					end
					max = max +1
				end
				if (BRH_CDTracker[spell] ~= nil and BRH_CDTracker[spell].text ~= nil ) then 
					BRH_CDTracker[spell].text:SetText(up.."/"..max);
				end
			end
		end
	end
end

--[[
function BRH.getMyTrackedSpells()
	local playerName = UnitName("player")

	-- check action bars
	for actionindex = 1, 120 do
		-- avoid macros
		if (GetActionText(actionindex) == nil and GetActionTexture(actionindex) ~= nil and IsConsumableAction(actionindex)) then 
			-- Check for CD
			local _, cd = GetActionCooldown(actionindex)
			local icon = strlow(GetActionTexture(actionindex));

			if (cd and cd > 0) then
				BRH.setTrackedSpellOnCD("all", playerName, icon, cd);
				spellOnCDCheck.item[icon] = false;
			else
				BRH.setTrackedSpellUp("all", playerName, icon);
			end
		end
	end

	-- bag items 
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				local _, cd = GetContainerItemCooldown(bag, slot)
				local icon = GetContainerItemInfo(bag, slot);
				
				if (cd and cd > 0) then
					BRH.setTrackedSpellOnCD("all", playerName, icon, cd);
					spellOnCDCheck.item[icon] = false;
				else
					BRH.setTrackedSpellUp("all", playerName, icon);
				end
			end
		end
	end

	-- Inventory Items
	for slotId = 0, 19 do
		local icon = GetInventoryItemTexture("Player", slotId)
		if (icon) then
			local _, cd = GetInventoryItemCooldown("Player", slotId)
			if (cd and cd > 0) then
				BRH.setTrackedSpellOnCD("all", playerName, icon, cd);
				spellOnCDCheck.item[icon] = false;
			else
				BRH.setTrackedSpellUp("all", playerName, icon);
			end
		end
	end

	-- check spells
	local _, myclass = UnitClass("player")
	myclass = strlow(myclass);

	-- getting total number of spells
	local numspells = 0;
	for i = 1, GetNumSpellTabs() do
		_, _, _, temp = GetSpellTabInfo(i)
		numspells = numspells + temp
	end
	
	for i = 1, numspells do
		local icon = strlow(GetSpellTexture(i, BOOKTYPE_SPELL))
		local cd = BRH.getSpellCDByIcon(icon)

		if (cd and cd > 0) then
			BRH.setTrackedSpellOnCD(myclass, playerName, icon, cd);
			spellOnCDCheck.spell[icon] = false;
		else
			BRH.setTrackedSpellUp(myclass, playerName, icon);
		end
	end
end
]]
function BRH.setTrackedSpellOnCD(class, sender, spell, duration)
	spell = strlow(spell);

	local sentBySelf = strlow(UnitName("Player")) == strlow(sender);
	local type = "spell";
	if (class == "all") then
		type = "item"
	end

	if (BRH_spellsToTrack[class] ~= nil and BRH_spellsToTrack[class][spell] ~= nil) then
		if duration == "-1" then
			BRH_spellsToTrack[class][spell]["onCD"][sender] = duration;
		elseif (BRH_spellsToTrack[class][spell]["onCD"][sender] == "-1") then
			BRH_spellsToTrack[class][spell]["onCD"][sender] = GetTime() + duration;
		end
	end

	if BRH_SpellCastCount[sender] == nil then
		BRH_SpellCastCount[sender] = {}
	end

	if (BRH_SpellCastCount[sender][spell] == nil) then
		BRH_SpellCastCount[sender][spell] = 1
	else
		BRH_SpellCastCount[sender][spell] = BRH_SpellCastCount[sender][spell] + 1
	end
	
	if (sentBySelf and duration == "-1" and not spellOnCDCheck[type][spell]) then
		spellOnCDCheck[type][spell] = true;
		BRH_CDTracker.nextTick = GetTime() + BRH_CDTracker.tickRate;
		BRH.addonCom("trackedSpellUsed", class..":"..spell..":"..duration)
	elseif (sentBySelf and spellOnCDCheck[type][spell] and duration ~= "-1") then
		spellOnCDCheck[type][spell] = false;
		BRH.addonCom("trackedSpellUsed", class..":"..spell..":"..duration)
	end

end

function BRH.setTrackedSpellUp(class, sender, spell)
	spell = strlow(spell);

	if (strlow(UnitName("Player")) == strlow(sender) 
		and ((BRH_spellsToTrack["all"] ~= nil and BRH_spellsToTrack["all"][spell]["onCD"][sender] ~= nil and BRH_spellsToTrack["all"][spell]["onCD"][sender]) 
		or (BRH_spellsToTrack[class] ~= nil and BRH_spellsToTrack[class][spell]["onCD"][sender] ~= nil and BRH_spellsToTrack[class][spell]["onCD"][sender]))) then

		BRH.addonCom("trackedSpellUp", class..":"..spell);
	end

	if (BRH_spellsToTrack[class] == nil) then
		return
	end

	if (BRH_spellsToTrack[class][spell] == nil) then
		if (BRH_spellsToTrack["all"][spell] ~= nil) then
			BRH_spellsToTrack["all"][spell]["onCD"][sender] = false;
		end
		return
	end

	BRH_spellsToTrack[class][spell]["onCD"][sender] = false;
end

local function handleTrackedSpellUsed(sender, datas)
	-- we don't wanna get our own updates as we already handled them
	if (strlow(sender) == UnitName("Player")) then
		return
	end

	local split = BRH.strsplit(":", datas)
	local senderClass = split[1];
	local spell = split[2];
	local duration = split[3];
	BRH.setTrackedSpellOnCD(senderClass, sender, spell, duration);
end

local function handleTrackedSpellUp(sender, datas)
	-- we don't wanna get our own updates as we already handled them
	if (strlow(sender) == UnitName("Player")) then
		return
	end

	local split = BRH.strsplit(":", datas)
	local senderClass = split[1];
	local spell = split[2];

	BRH.setTrackedSpellUp(senderClass, sender, spell);
end

function BRH.updateSpellsOnCD()

	for spell, doCheck in pairs(spellOnCDCheck.spell) do
		local playerName = UnitName("player")
		local _, myclass = UnitClass("player")
		myclass = strlow(myclass);
		local cd = BRH.getSpellCDByIcon(spell)

		if (cd and cd > 0) then
			BRH.setTrackedSpellOnCD(myclass, playerName, spell, cd);
		else
			BRH.setTrackedSpellUp(myclass, playerName, spell);
		end
	end

	for spell, doCheck in pairs(spellOnCDCheck.item) do
		for actionindex = 1, 120 do
			-- avoid macros and check if it's our item
			if (GetActionText(actionindex) == nil and GetActionTexture(actionindex) and IsConsumableAction(actionindex) and strlow(GetActionTexture(actionindex)) == spell) then 
				_, cd = GetActionCooldown(actionindex)

				if (cd and cd > 0) then
					BRH.setTrackedSpellOnCD("all", playerName, spell, cd);
				else
					BRH.setTrackedSpellUp("all", playerName, spell);
				end
			end
		end
	end

end
--[[
This code hooks UseAction
]]
savedUseAction = UseAction

newUseAction = function(actionindex, x, y)
	local _, myclass = UnitClass("player")

	if (strlow(myclass) == "priest") then
		infuIfCan("");
	elseif (strlow(myclass) == "paladin") then
		BOPIfCan("");
	end

	-- macro, we don't track it here
	if (GetActionText(actionindex) ~= nil) then 
		savedUseAction(actionindex, x, y)   
		return;
	end

	-- first we check for cost
	local isUsable, notEnoughMana = IsUsableAction(actionindex)
	if (not isUsable or notEnoughMana) then
		-- action is not usable for x reason or player doesn't have enough mana so stop here
		savedUseAction(actionindex, x, y)   
		return;
	end

	-- Check for CD
	local _, duration = GetActionCooldown(actionindex)
	if (duration > 0) then
		-- action is on CD so ...
		savedUseAction(actionindex, x, y)   
		return;
	end

	local actionTexture = GetActionTexture(actionindex);
	if (actionTexture) then
		local playerName = UnitName("Player")
		
		myclass = strlow(myclass);
		-- if it has count is a
		if (IsConsumableAction(actionindex)) then myclass = "all" end;
		BRH.setTrackedSpellOnCD(myclass, playerName, actionTexture, "-1");
	end

   savedUseAction(actionindex, x, y)   

end
UseAction = newUseAction

--[[
This code hooks CastSpellByName()
]]
savedCastSpellByName = CastSpellByName
newCastSpellByName = function(name, onself)

	local _, myclass = UnitClass("player")

	if (strlow(myclass) == "priest") then
		infuIfCan("");
	elseif (strlow(myclass) == "paladin") then
		BOPIfCan("");
	end

	-- pretty much the same as before
	local spellSlot = getSpellSlot(name);
	if (spellSlot == nil) then
		-- spell not in spellbook
		-- Call the original function then
		savedCastSpellByName(name, onself)
		return
	end

	-- then for CD
	local _, duration = GetSpellCooldown(spellSlot, BOOKTYPE_SPELL)
	if (duration > 0) then
		-- spell is on CD so ...
		savedCastSpellByName(name, onself)
		return;
	end

	local spellTexture = strlow(GetSpellTexture(spellSlot, BOOKTYPE_SPELL));
	if (spellTexture) then
		-- ok so, is usable, have enough mana, is in range. It's pretty sure we are gonna be able to use it. Only server can say no then but we are not gonna check that
		local playerName = UnitName("Player")
		local _, myclass = UnitClass("player")
		myclass = strlow(myclass);
		BRH.setTrackedSpellOnCD(myclass, playerName, spellTexture, "-1");
	end
	
    -- Call the original function then
	savedCastSpellByName(name, onself)
end
CastSpellByName = newCastSpellByName

--[[
This code hooks UseInventoryItem()
]]
savedUseInventoryItem = UseInventoryItem
newUseInventoryItem = function(slot)

	local _, myclass = UnitClass("player")

	if (strlow(myclass) == "priest") then
		infuIfCan("");
	elseif (strlow(myclass) == "paladin") then
		BOPIfCan("");
	end

	-- Check for CD
	local _, duration = GetInventoryItemCooldown("Player", slot)
	if (duration > 0) then
		-- action is on CD so ...
		savedUseInventoryItem(slot)   
		return;
	end

	local texture = GetInventoryItemTexture("Player", slot);
	if (texture) then
		local playerName = UnitName("Player");
		local myclass = "all";
		BRH.setTrackedSpellOnCD(myclass, playerName, texture, "-1");
	end

	savedUseInventoryItem(slot) 

end
UseInventoryItem = newUseInventoryItem

--[[GetContainerItemCooldown
This code hooks UseContainerItem()
]]
savedUseContainerItem = UseContainerItem
newUseContainerItem = function(bag, slot, onSelf)

	local _, myclass = UnitClass("player")

	if (strlow(myclass) == "priest") then
		infuIfCan("");
	elseif (strlow(myclass) == "paladin") then
		BOPIfCan("");
	end

	-- Check for CD
	local _, duration = GetContainerItemCooldown(bag, slot)
	if (duration > 0) then
		-- action is on CD so ...
		savedUseContainerItem(bag, slot, onSelf)   
		return;
	end

	local texture = GetContainerItemInfo(bag, slot);
	if (texture) then
		local playerName = UnitName("Player");
		local myclass = "all";
		BRH.setTrackedSpellOnCD(myclass, playerName, texture, "-1");
	end

	savedUseContainerItem(bag, slot, onSelf) 

end
UseContainerItem = newUseContainerItem

-- We save here our tickrate, then initialise nextTick.
BRH_CDTracker.tickRate = 2;
BRH_CDTracker.nextTick = GetTime() + BRH_CDTracker.tickRate;

BRH_CDTracker.main:SetScript("OnUpdate", function() 
	if (BRH_CDTracker.nextTick and BRH_CDTracker.nextTick <= GetTime()) then
		BRH.updateSpellsOnCD()
		if (BRH_CDTrackerConfig.show) then
			BRH.updateGUI()
		end
		BRH_CDTracker.nextTick = GetTime() + BRH_CDTracker.tickRate;
	end
end)

BRH_CDTracker.main:SetScript("OnEvent", function()
	if (event == "ADDON_LOADED" and arg1 ~= "BlastRaidHelper") then return end;

	if (event == "ADDON_LOADED" and arg1 == "BlastRaidHelper" and BRH_CDTrackerConfig.show) then 
		for class, spells in pairs(BRH_spellsToTrack) do
			for spell, data in pairs(spells) do
				BRH_spellsToTrack[class][spell].onCD = nil;
				BRH_spellsToTrack[class][spell].onCD = {};
			end
		end
		BRH.buildTrackedSpellsGUI();
	end;
end)

local spellsSlot = {};
function getSpellSlot(spellName)
	if (spellsSlot[spellName] == nil) then
		local numspells = 0
		-- getting total number of spells
		for i = 1, GetNumSpellTabs() do
			_, _, _, temp = GetSpellTabInfo(i)
			numspells = numspells + temp
		end
		-- for each spell check if it's the one we are looking for
		for i = 1, numspells do
			if strlow(GetSpellName(i, BOOKTYPE_SPELL)) == strlow(spellName) then
				-- it is the one, we store it's slotId
				spellsSlot[spellName] = i;
			end
		end

		return spellsSlot[spellName];
	else
		return spellsSlot[spellName];
	end
end

local function getSpellCD(spellName)
	-- we need to get the slotID
	local spellSlot = getSpellSlot(spellName);
	-- we don't have spell, so let's just stop here
	if (spellSlot == nil) then return nil end;
	-- we got it's slot ID so we return the data we look for
	local start, spellCD = GetSpellCooldown(spellSlot, BOOKTYPE_SPELL)
	spellCD = (start + spellCD) - GetTime()
	return spellCD;
end

BRH.spellSlotByIcon = {}
function BRH.getSpellCDByIcon(icon)
	-- Careful with this one as it's not realy a good one tbh.
	-- Some spells have multiple rank.
	-- logic wants that the last one is the biggest rank so we are gonna loop and save the last one.
	if (BRH.spellSlotByIcon[icon] == nil) then
		local numspells = 0
		-- getting total number of spells
		for i = 1, GetNumSpellTabs() do
			_, _, _, temp = GetSpellTabInfo(i)
			numspells = numspells + temp
		end
	
		-- for each spell check if it's the one we are looking for
		for i = 1, numspells do
			if (strlow(GetSpellTexture(i, BOOKTYPE_SPELL)) == strlow(icon)) then
				BRH.spellSlotByIcon[icon] = i;
				-- we don't break cos we want to get lastrank
			end
		end
	end

	if BRH.spellSlotByIcon[icon] == nil then return nil end;

	local start, spellCD = GetSpellCooldown(BRH.spellSlotByIcon[icon], BOOKTYPE_SPELL)
	spellCD = (start + spellCD) - GetTime()

	if (spellCD < 0) then return 0 end;
	return spellCD;
end

local function hasBuff(buffTexture)
	for i=0, 32 do
		if (GetPlayerBuffTexture(GetPlayerBuff(i, "HELPFUL")) == "Interface\\Icons\\"..buffTexture) then
			return i;
		end
	end
	return false;
end

function GetItemInBag(textEN,textFR)
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				if (string.find(GetContainerItemLink(bag,slot), textEN)) or (string.find(GetContainerItemLink(bag,slot), textFR)) then
					return bag, slot;
				end
			end
		end
	end
end

function GetSapper()
	BRH_SAPPER.bag, BRH_SAPPER.slot = GetItemInBag("Sapper", "sapeur")
end
GetSapper();

local function doStartCountdown(timeInSec)
	GetSapper();
	startCountDown = true;
	countDown = GetTime() + timeInSec;
	unregAddons()
end

--------- FRAMES ---------
BRH_RaidInfo = CreateFrame("Frame", "BRH_RaidInfo")
BRH_RaidInfo:ClearAllPoints();
BRH_RaidInfo:SetPoint("CENTER", "UIParent", "CENTER")
BRH_RaidInfo:RegisterEvent("CHAT_MSG_ADDON");
BRH_RaidInfo:RegisterEvent("START_LOOT_ROLL");
BRH_RaidInfo:RegisterEvent("CONFIRM_LOOT_ROLL");
--------- SCRIPTS ---------
local vacumeTick = GetTime() + 60;
BRH_RaidInfo:SetScript("OnUpdate", function() 

	if (infuUpTimer ~= nil and infuUpTimer <= GetTime()) then
		BRH.msgToAll("Infu de "..playerName.." Up !")
		infuUpTimer = nil;
	end

	if (BOPUpTimer ~= nil and BOPUpTimer <= GetTime()) then
		BRH.msgToAll("BOP de "..playerName.." Up !")
		BOPUpTimer = nil;
	end

	if (IsRaidLeader()) then
		if (vacumeTick <= GetTime()) then
			BRH.addonCom("vacume", vacumeName or "");
			vacumeTick = GetTime() + 60;
			for itemId, playername in pairs(vacumeAttribs) do
				BRH.addonCom("vacumeLootAttrib", itemId.." "..playername);
			end
		end
	end

	if (startCountDown) then
		if (countDown + 3 <= GetTime() ) then
			BRH_canCast = false;
			regAddons()
			startCountDown = false;
		elseif (countDown <= GetTime()) then
			BRH_canCast = true;
		end
	end

	if (checking) then 
		if (checkStop <= GetTime()) then
			checking = false;
			local noAddon = "";
			for name, hasAddon in pairs(raidMembers) do
				if not hasAddon then
					noAddon = noAddon..name..", ";
				end
			end
			BRH.print(hasAddon.." Players in raid have the addon.")
			if (noAddon ~= "") then
				BRH.print("Players without it : "..noAddon);
			end
		end
	end

	if (engineerCheckTimer ~= nil) then
		if (engineerCheckTimer <= GetTime()) then
			engineerCheckTimer = nil;
			BRH.print("There is "..engineerNumber.." Engineers in the raid")
		end
	end

	if (not LIPRota_CanTaunt) then
		if (LIPROTA_Timer ~= nil and LIPROTA_Timer <= GetTime()) then
			LIPRota_CanTaunt = true;
		end
	end

end)

BRH_RaidInfo:SetScript("OnEvent", function() 
	if (event == "CHAT_MSG_ADDON" and arg1 == BRH.syncPrefix) then
		BRH.HandleAddonMSG(arg4, arg2);
	elseif (event == "START_LOOT_ROLL") then
		if (vacumeName ~= nil) then
			local _, _, _, quality = GetLootRollItemInfo(arg1);
			local itemLink = GetLootRollItemLink(arg1);
			local linkSplit = BRH.strsplit(":", itemLink);
			local itemId = linkSplit[2];

			-- If player has attrib or is vacume cleaner
			if ((vacumeAttribs[itemId] ~= nil and strlow(vacumeAttribs[itemId]) == strlow(UnitName("Player"))) 
				or (strlow(UnitName("Player")) == strlow(vacumeName) and quality < 5 and vacumeAttribs[itemId] == nil)) then
				RollOnLoot(arg1, 1);
			else
				RollOnLoot(arg1, 0);
			end
		end
	elseif (event == "CONFIRM_LOOT_ROLL") then
		if (vacumeName ~= nil) then
			local _, _, _, quality = GetLootRollItemInfo(arg1);
			local itemLink = GetLootRollItemLink(arg1);
			local linkSplit = BRH.strsplit(":", itemLink);
			local itemId = linkSplit[2];
			if ((vacumeAttribs[itemId] ~= nil and strlow(vacumeAttribs[itemId]) == strlow(UnitName("Player"))) 
				or (strlow(UnitName("Player")) == strlow(vacumeName) and quality < 5 and vacumeAttribs[itemId] == nil)) then
				ConfirmLootRoll(arg1, 1)
			end
		end
	end
end)
---------------------

-----FUNCTIONS-------

function BRH.addonCom(comType, content)
	SendAddonMessage(BRH.syncPrefix, comType..";;;"..content, "RAID")
end

function BRH.msgToAll(msg)
	BRH.addonCom("msgToAll", msg);
end

function BRH.printAttribs()
	for itemId, player in pairs(vacumeAttribs) do
		BRH.print(itemId.." attrib to "..player);
	end
end

outDated = {}

function BRH.HandleAddonMSG(sender, data)
	local split = BRH.strsplit(";;;", data)
	local cmd = split[1]
	local datas = split[2]

	BRH.print(data);

	if (cmd == "LIPROTA" and UnitName("Player") ~= sender) then
		LIPRota_CanTaunt = false;
		LIPROTA_Timer = GetTime() + 6;
		return;
	elseif (checking and cmd == "okCheck") then
		raidMembers[sender] = true;
		if (datas ~= BRH.build) then
			outDated[sender] = datas;
			BRH.print(sender.." has outdated version "..datas)
		end
		hasAddon = hasAddon + 1;
		return;
	elseif (engineerCheckTimer ~= nil and cmd == "IamEngineer") then
		engineerNumber = engineerNumber + 1;
	elseif (cmd == "plsInfu" and datas == UnitName("Player")) then
		askedInfu = sender
		BRH.print(sender.." a demandé une infu !");
	elseif (cmd == "plsBOP" and datas == UnitName("Player")) then
		askedBOP = sender
		BRH.print(sender.." a demandé une BOP !")
	elseif (cmd == "msgToAll") then
		BRH.print(datas);
	elseif (cmd == "trackedSpellUsed") then
		handleTrackedSpellUsed(sender, datas);
	elseif (cmd == "trackedSpellUp" and UnitName("Player") ~= sender) then
		handleTrackedSpellUp(sender, datas)
	--elseif (cmd == "getTrackedSpells") then
		--BRH.getMyTrackedSpells();
	end

	-- commands below that can only be sent by officiers
	if (not BRH.PlayerIsPromoted(sender)) then return end

	if (cmd == "start") then
		doStartCountdown(datas);
	elseif (cmd == "Check") then
		BRH.addonCom("okCheck", BRH.build)
	elseif (cmd == "vacume") then
		if (datas == "") then
			vacumeName = nil
		else
			vacumeName = datas;
		end
	elseif (cmd == "vacumeLootAttrib") then
		local dataSplit = BRH.strsplit(" ", datas);
		vacumeAttribs[dataSplit[1]] = dataSplit[2];
	elseif (cmd == "stopvacume") then
		vacumeName = nil
	elseif (cmd == "checkEngineer") then
		for skillIndex = 1, GetNumSkillLines() do 
			if (GetSkillLineInfo(skillIndex) == "Engineering" or GetSkillLineInfo(skillIndex) == "Ingénierie") then
				BRH.addonCom("IamEngineer", "")
				return;
			end
		end
	end

end

function BRH.PlayerIsPromoted(name)
	if not name then return false end

	for raidIndex=1, MAX_RAID_MEMBERS do
		tarName, rank = GetRaidRosterInfo(raidIndex);
		if (tarName and tarName == name and rank and rank > 0 ) then return true end
	end
	return false;
end

local function SCDcmdHandle(msg)
	BRH.strsplit(" ", msg)
	local cmd = BRH.strsplit(" ", msg)[1]
	local arg = BRH.strsplit(" ", msg)[2]

	if cmd then
		if (strlow(cmd) == "start") then
			if (not arg) then
				BRH.print("You have to set a timer");
				return;
			end
			doStartCountdown(arg);
			BRH.addonCom("start", arg);
			if (BigWigsPulltimer ~= nil) then
				BigWigsPulltimer:BigWigs_PullCommand(arg)
			end
		elseif (strlow(cmd) == "sapper") then
			if (BRH_canCast) then
				UseContainerItem(BRH_SAPPER.bag, BRH_SAPPER.slot);
			end
		else
			BRH.print("Commands :\n/SCD start TIME\n/SCD sapper");
		end
	else
		BRH.print("Commands :\n/SCD start TIME\n/SCD sapper");
	end
end

local function BRHcmdHandle(msg)
	BRH.strsplit(" ", msg)
	local cmd = BRH.strsplit(" ", msg)[1]
	local arg = BRH.strsplit(" ", msg)[2]
	if cmd then
		if (IsRaidOfficer() or IsRaidLeader()) then
			if (strlow(cmd) == "check") then
				if UnitInRaid("Player") then
					BRH.print("Checking who doesn't have the addon...")
					BRH.addonCom("Check", "");
					checkStop = GetTime() + 10;
					checking = true;
					hasAddon = 0;
					for raidIndex=1, MAX_RAID_MEMBERS do
						name, _, _, _, _, _, _, online = GetRaidRosterInfo(raidIndex);
						if (name and online ~= nil) then
							raidMembers[name] = false;
						end
					end
				end
			elseif (strlow(cmd) == "vacume" and strlow(arg) ~= nil) then
				vacumeName = arg;
				BRH.addonCom(cmd, arg);
				SetLootMethod("group", 1);
				BRH.print(arg.." est maintenant l'aspirateur à loots !")
			elseif (strlow(cmd) == "vacumelootattrib") then
				vacumeAttribs[arg] = BRH.strsplit(" ", msg)[3];
				BRH.addonCom("vacumeLootAttrib", arg.." "..vacumeAttribs[arg]);
			elseif (strlow(cmd) == "stopvacume") then
				vacumeName = nil;
				BRH.addonCom(cmd, "");
				SetLootMethod("freeforall");
				BRH.print("Aspirateur à loot arrêté !")
			elseif (strlow(cmd) == "checkinge") then
				BRH.print("Checking Engineer number...")
				BRH.addonCom("checkEngineer", "")
				engineerCheckTimer = GetTime() + 10;
				engineerNumber = 0;
			end
		end
	end
end

local function LipAOEHandle(msg)
	local lipBag, lipSlot = GetItemInBag("Limited Invulnerability", "invulnérabilité limité")
	
	if (LIPRota_CanTaunt) then

		if (lipBag ~= nil and lipSlot ~= nil) then
			UseContainerItem(lipBag, lipSlot);
		end

		if (GetLocale() == "frFR") then
			CastSpellByName("Cri de défi")
		else
			CastSpellByName("Challenging Shout")
		end

		BRH.addonCom("LIPROTA", "");
	end
end
--
function doTaunt()
	if (GetLocale() == "frFR") then
		CastSpellByName("Provocation")
	else
		CastSpellByName("Taunt")
	end
end

local function TauntIfCan(msg)

	-- if no target just stop here
	if (UnitName("target") == nil) then return end;

	local TargetOfTarget = UnitName("playertargettarget");
	-- no ToT so we can taunt anyway
	if (TargetOfTarget == nil) then doTaunt() return end;

	local isTaunted = false;
	for i=1,16 do
		debuffTexture, debuffApplications = UnitDebuff("target", i);
		if (debuffTexture ~= nil and strlow(debuffTexture) == strlow("interface\\icons\\spell_nature_reincarnation")) then
			isTaunted = true;
		end
	end
	-- not taunted so it's ok
	if (not isTaunted) then
		doTaunt();
		return;
	else
		for raidIndex=1, MAX_RAID_MEMBERS do
			name, _, subgroup, _, _, class = GetRaidRosterInfo(raidIndex);
			if (name ~= nil) then
				-- if Taunted and ToT is Tank ( warrior from G1 ) do not taunt
				if (name == TargetOfTarget and subroup == 1 and strlow(class) == "warrior") then
					return;
				end
			end
		end
	end
	-- it's taunted but ToT isn't tank, we just do taunt
	doTaunt();
end

local function plsInfuHandle(msg)
	BRH.addonCom("plsInfu", msg)
end

local infu = "Power Infusion"
if GetLocale() == "frFR" then
	infu = "Infusion de puissance"	
end

local function infuIfCan(msg)
	if (askedInfu ~= nil) then
		local infuCD = getSpellCD(infu)

		-- don't try to cast if it's on CD
		if (infuCD == nil) then return end;

		TargetByName(askedInfu, true);
		CastSpellByName(infu)
		TargetLastTarget();
		BRH.print("Infu envoyée sur "..askedInfu)
		askedInfu = nil;
		infuUpTimer = GetTime() + 180
	end
end


local function plsBOPHandle(msg)
	BRH.addonCom("plsBOP", msg)
end

local bop = "Blessing of Protection"
if GetLocale() == "frFR" then
	bop = "Bénédiction de protection"	
end

local function BOPIfCan(msg)
	if (askedBOP ~= nil) then
		local bopCD = getSpellCD(bop)

		-- don't try to cast if it's on CD
		if (bopCD == nil) then return end;

		TargetByName(askedBOP, true);
		CastSpellByName(bop)
		TargetLastTarget();
		askedBOP = nil;
		BOPUpTimer = GetTime() + 180
	end
end

local function spamPetri(msg)
	local petribuff = hasBuff("INV_Potion_26")
	local petriBag, petriSlot = GetItemInBag("Flask of Petrification", "Flacon de pétrification")
	if (not petribuff) then
		UseContainerItem(petriBag, petriSlot);
	end
end

local function CDTrackerHandle(msg)
	
	local split = BRH.strsplit(" ", msg)
	local cmd = split[1]
	tremove(split, 1)
	local arg = table.concat(split, " ");

	if (cmd == "track" or cmd == "untrack") then
		if (not arg or arg == "") then
			BRH.print("/cdtracker (un)track Classe Nom du sort");
			return
		end

		local split2 = BRH.strsplit(" ", arg)
		local class = split2[1]
		tremove(split2, 1)
		local spellName = table.concat(split2, " ");

		if (not spellName or spellName == "" or not class or class == "") then
			BRH.print("/cdtracker (un)track Classe Nom du sort");
			return
		end 

		class = strlow(class)

		-- user might be dumb
		if (class == "guerrier") then class = "warrior"
		elseif (class == "voleur") then class = "roguer"
		elseif (class == "druide") then class = "druid"
		elseif (class == "chasseur") then class = "hunter"
		elseif (class == "démoniste" or class == "demoniste") then class = "warlock"
		elseif (class == "prêtre" or class == "pretre") then class = "priest"
		elseif (class == "chaman") then class = "shaman"
		end

		spellName = strlow(spellName)
		
		-- and we work for him...
		local icon = BRH.BS:GetSpellIcon(spellName);
		if not icon then
			BRH.print("Le Nom du sort doit être Exacte et dans la langue de votre jeu !");
			BRH.print("/cdtracker (un)track Classe Nom du sort");
			return;
		end

		if (cmd == "track") then
			BRH.trackSpell(class, icon)
		elseif (cmd == "untrack") then
			BRH.unTrackSpell(class, icon)
		end
	elseif (cmd == "show") then
		BRH_CDTrackerConfig.show = true
		for class, spells in pairs(BRH_spellsToTrack) do
			for spell, datas in pairs(spells) do
				if datas.tracked and BRH_CDTracker[spell] ~= nil then
					BRH_CDTracker[spell]:Show();
				end
			end
		end
	elseif (cmd == "hide") then
		BRH_CDTrackerConfig.show = false
		for class, spells in pairs(BRH_spellsToTrack) do
			for spell, datas in pairs(spells) do
				if BRH_CDTracker[spell] ~= nil then
					BRH_CDTracker[spell]:Hide();
				end
			end
		end
	end
end

SLASH_LIPAOE1  = "/LipAOE"
SLASH_SCD1 = "/SCD"
SLASH_BRH1 = "/BRH"
SLASH_TAUNTIFCAN1 = "/TauntIfCan"
SLASH_PLSINFU1 = "/plsInfu"
SLASH_INFUIFCAN1 = "/infuIfCan"
SLASH_PLSBOP1 = "/plsbop"
SLASH_BOPIFCAN1 = "/BOPIfCan"
SLASH_SPAMPETRI1 = "/petri"
SLASH_CDTRACK1 = "/cdtracker"

SlashCmdList["LIPAOE"] = LipAOEHandle
SlashCmdList["SCD"] = SCDcmdHandle
SlashCmdList["BRH"] = BRHcmdHandle
SlashCmdList["TAUNTIFCAN"] = TauntIfCan
SlashCmdList["PLSINFU"] = plsInfuHandle
SlashCmdList["INFUIFCAN"] = infuIfCan
SlashCmdList["PLSBOP"] = plsBOPHandle
SlashCmdList["BOPIFCAN"] = BOPIfCan
SlashCmdList["SPAMPETRI"] = spamPetri
SlashCmdList["CDTRACK"] = CDTrackerHandle