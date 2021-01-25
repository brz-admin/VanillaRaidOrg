

local dbug = true;
local dbuglvl = 2;
local assignatedPlayers = {};
local CurrentRoster = {};
local CurrentSetup = nil;

VRO = VRO;
VRO_SETS = VRO_SETS;
if (VRO_SETS == nil) then VRO_SETS = {} end
VRO_Members = VRO_Members;
strlow = string.lower;
strfor = string.format;
tinsert = table.insert;
GetRaidRosterInfo = GetRaidRosterInfo;
SwapRaidSubgroup = SwapRaidSubgroup;

VRO_gui = {};
VRO_gui.selected = nil;

---------- UTIL ----------
local function dLog(msg, lvl, force)
	force = force or false;
	lvl = lvl or 3;
	if (dbug and lvl <= dbuglvl) or force then
		DEFAULT_CHAT_FRAME:AddMessage("VRO_DEBUG: "..msg, 1,1,0.5)
	end
end

local function has_value (tab, val)
    for key, value in pairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function tprint(tab)
	for key, value in pairs(tab) do
		dLog(key.."="..value, true);
	end
end

local function print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("Vanilla Raid Organiser: "..msg, 1,0,1)
end

local function getKeyName(tab, key)
	for k,_ in pairs(tab) do
		if k == key then return k end
	end
end

local function StripTextures(frame, hide, layer)
	for _,v in ipairs({frame:GetRegions()}) do
		if v.SetTexture then
			local check = true
			if layer and v:GetDrawLayer() ~= layer then check = false end

			if check then
				if hide then
					v:Hide()
				else
					v:SetTexture(nil)
				end
			end
		end
	end
end
--------------------------

-- mettre les signes auto !

--------- FRAMES ---------

VRO_MainFrame = CreateFrame("Frame", "VRO_MainFrame")
VRO_MainFrame:SetWidth(250)
VRO_MainFrame:SetHeight(340)
VRO_MainFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
VRO_MainFrame:SetBackdropColor(0,0,0,0.7);
VRO_MainFrame:EnableMouse(true);
VRO_MainFrame:ClearAllPoints();
VRO_MainFrame:Show();
VRO_MainFrame:SetMovable(true);
VRO_MainFrame:RegisterForDrag("LeftButton");
VRO_MainFrame:SetScript("OnDragStart", function() this:StartMoving() end);
VRO_MainFrame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end);
VRO_MainFrame:SetPoint("CENTER", "UIParent")

VRO_MainFrame_Title = CreateFrame("Frame", "VRO_MainFrame_Title", VRO_MainFrame);
VRO_MainFrame_Title:SetPoint("TOP", "VRO_MainFrame", 0, -0);
VRO_MainFrame_Title:SetPoint("LEFT", "VRO_MainFrame", 0, -0);
VRO_MainFrame_Title:SetPoint("RIGHT", "VRO_MainFrame", 0, -0);
VRO_MainFrame_Title:SetHeight(20);

VRO_MainFrame_Title_text = VRO_MainFrame_Title:CreateFontString("VRO_MainFrame_Title", "ARTWORK", "GameFontWhite")
VRO_MainFrame_Title_text:SetPoint("TOP", "VRO_MainFrame_Title", 0, -5);
VRO_MainFrame_Title_text:SetText("Raid Organiser");
VRO_MainFrame_Title_text:SetFont("Fonts\\FRIZQT__.TTF", 10)
VRO_MainFrame_Title_text:SetTextColor(0.5, 1, 1, 1);

VRO_MainFrame_Menu = CreateFrame("Frame", "VRO_MainFrame_Menu", VRO_MainFrame);
VRO_MainFrame_Menu:SetPoint("TOP", "VRO_MainFrame_Title", "BOTTOM", 0, 0);
VRO_MainFrame_Menu:SetPoint("LEFT", "VRO_MainFrame", 0, -0);
VRO_MainFrame_Menu:SetPoint("RIGHT", "VRO_MainFrame", 0, -0);
VRO_MainFrame_Menu:SetHeight(30)
VRO_MainFrame_Menu:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
VRO_MainFrame_Menu:SetBackdropColor(0,0,0,0.7);



-- for icons : Interface\\TargetingFrame\\UI-RaidTargetingIcon_X UIDropDownMenu_SetSelectedName

VRO_MainFrame_Menu_SetsDD = CreateFrame("Frame", "VRO_MainFrame_Menu_SetsDD", nil, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(VRO_MainFrame_Menu_SetsDD, function()
	UIDropDownMenu_AddButton({
		text="Current",
		checked=VRO_gui.selected == "Current",
		func = function ()
			VRO_gui.selected = "Current"
			loadSetInGUI("Current")
			UIDropDownMenu_SetSelectedName(VRO_MainFrame_Menu_SetsDD, "Current", "Current")
		end
	})
	for set,_ in pairs(VRO_SETS) do
		UIDropDownMenu_AddButton({
			text=set,
			checked=VRO_gui.selected == set,
			arg1 = set,
			func = function (set)
				VRO_gui.selected = set
				loadSetInGUI(set)
				UIDropDownMenu_SetSelectedName(VRO_MainFrame_Menu_SetsDD, set, set)
			end
		})
	end
	UIDropDownMenu_SetWidth(30, VRO_MainFrame_Menu_SetsDD)
	UIDropDownMenu_SetButtonWidth(30, VRO_MainFrame_Menu_SetsDD)
	UIDropDownMenu_SetText("Sets", VRO_MainFrame_Menu_SetsDD)
	VRO_MainFrame_Menu_SetsDD:SetPoint("LEFT", VRO_MainFrame_Menu, "LEFT", 10,0);
	VRO_MainFrame_Menu_SetsDD:SetHeight(20)
	VRO_MainFrame_Menu_SetsDD:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
	VRO_MainFrame_Menu_SetsDD:SetBackdropColor(0,0,0,0.5);
	VRO_MainFrame_Menu_SetsDD:SetBackdropBorderColor(1, 1, 1, 1)
	VRO_MainFrame_Menu_SetsDDButton:SetAllPoints(VRO_MainFrame_Menu_SetsDD)
	VRO_MainFrame_Menu_SetsDDText:SetPoint("LEFT", VRO_MainFrame_Menu_SetsDD, "LEFT", 5, 0)
end, "MENU"
)

VRO_MainFrame_Menu_Loadbutton = CreateFrame("Button", "VRO_MainFrame_Menu_Loadbutton", VRO_MainFrame_Menu);
VRO_MainFrame_Menu_Loadbutton:SetText("Apply Set");
VRO_MainFrame_Menu_Loadbutton:SetFont("Fonts\\FRIZQT__.TTF", 8)
VRO_MainFrame_Menu_Loadbutton:SetTextColor(1, 1, 1, 1);
VRO_MainFrame_Menu_Loadbutton:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
VRO_MainFrame_Menu_Loadbutton:SetBackdropColor(0,0,0,0.7);
VRO_MainFrame_Menu_Loadbutton:SetPoint("LEFT", VRO_MainFrame_Menu_SetsDD, "RIGHT", 10,0);
VRO_MainFrame_Menu_Loadbutton:SetWidth(75)
VRO_MainFrame_Menu_Loadbutton:SetHeight(20)
VRO_MainFrame_Menu_Loadbutton:SetFrameStrata("DIALOG")
VRO_MainFrame_Menu_Loadbutton:RegisterForClicks("LeftButtonUp", "RightButtonUp");
VRO_MainFrame_Menu_Loadbutton:SetScript("OnClick", function () 
	if (VRO_gui.selected and VRO_gui.selected ~= "Current") then
		sortRaid(VRO_gui.selected);
	end
end)

VRO_MainFrame_Menu_CurrSetup_Text = VRO_MainFrame_Menu:CreateFontString("VRO_MainFrame_Menu", "ARTWORK", "GameFontWhite");
VRO_MainFrame_Menu_CurrSetup_Text:SetPoint("RIGHT", VRO_MainFrame_Menu,"RIGHT",-10,0);
VRO_MainFrame_Menu_CurrSetup_Text:SetText("No Raid setup")
VRO_MainFrame_Menu_CurrSetup_Text:SetFont("Fonts\\FRIZQT__.TTF", 8)
VRO_MainFrame_Menu_CurrSetup_Text:SetTextColor(1, 1, 1, 1);

VRO_MainFrame_Content_LEFT = CreateFrame("Frame", "VRO_MainFrame_Content_LEFT", VRO_MainFrame);
VRO_MainFrame_Content_LEFT:SetPoint("TOP",VRO_MainFrame_Menu,"BOTTOM", -10, 0)
VRO_MainFrame_Content_LEFT:SetPoint("BOTTOM", VRO_MainFrame, "BOTTOM", 0, 0);
VRO_MainFrame_Content_LEFT:SetPoint("LEFT", VRO_MainFrame, "LEFT", 0, 0);
VRO_MainFrame_Content_LEFT:SetWidth(VRO_MainFrame:GetWidth()/2)
VRO_MainFrame_Content_LEFT:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
VRO_MainFrame_Content_LEFT:SetBackdropColor(0,0,0,0.25);

VRO_MainFrame_Content_RIGHT = CreateFrame("Frame", "VRO_MainFrame_Content_RIGHT", VRO_MainFrame);
VRO_MainFrame_Content_RIGHT:SetPoint("TOP",VRO_MainFrame_Menu,"BOTTOM", -10, 0)
VRO_MainFrame_Content_RIGHT:SetPoint("BOTTOM", VRO_MainFrame, "BOTTOM", 0, 0);
VRO_MainFrame_Content_RIGHT:SetPoint("LEFT", VRO_MainFrame_Content_LEFT, "RIGHT", 0, 0);
VRO_MainFrame_Content_RIGHT:SetWidth(VRO_MainFrame:GetWidth()/2)
VRO_MainFrame_Content_RIGHT:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
VRO_MainFrame_Content_RIGHT:SetBackdropColor(0,0,0,0.25);

VRO_MainFrame_Content_group = {};
for group = 1, 8 do
	local side = group <= 4 and "LEFT" or "RIGHT"
	local parent = group <= 4 and VRO_MainFrame_Content_LEFT or VRO_MainFrame_Content_RIGHT
	local pheight = 290 --parent:GetHeight()
	local cheight = (pheight/4)-5
	local offst = (group <= 4 and (2.5+(2.5*(group-1))+((group-1)*cheight))) or (2.5+(2.5*(group-5))+((group-5)*cheight))
	VRO_MainFrame_Content_group[group] = CreateFrame("Frame", "VRO_MainFrame_Content_G"..group, parent)
	VRO_MainFrame_Content_group[group]:SetPoint("TOPLEFT",parent,"TOPLEFT", 2.5, -offst)
	VRO_MainFrame_Content_group[group]:SetPoint("RIGHT",parent,"RIGHT", -2.5, 0)
	VRO_MainFrame_Content_group[group]:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
	VRO_MainFrame_Content_group[group]:SetBackdropColor(0,0,0,0.25);
	VRO_MainFrame_Content_group[group]:SetHeight(cheight)
	VRO_MainFrame_Content_group[group].name = VRO_MainFrame_Content_group[group]:CreateFontString("VRO_MainFrame_Content_G"..group, "ARTWORK", "GameFontWhite")
	VRO_MainFrame_Content_group[group].name:SetPoint("TOP", VRO_MainFrame_Content_group[group],"TOP",0,0);
	VRO_MainFrame_Content_group[group].name:SetText("Group "..group)
	VRO_MainFrame_Content_group[group].name:SetFont("Fonts\\FRIZQT__.TTF", 8)
	VRO_MainFrame_Content_group[group].name:SetTextColor(1, 1, 1, 1);
	VRO_MainFrame_Content_group[group].player = {}
	for plyr = 1,5 do
		local poffst = plyr*(VRO_MainFrame_Content_group[group]:GetHeight()/6)

		VRO_MainFrame_Content_group[group].player[plyr] = CreateFrame("Frame", "VRO_MainFrame_Content_G"..group.."_P"..plyr, VRO_MainFrame_Content_group[group])
		VRO_MainFrame_Content_group[group].player[plyr]:SetPoint("TOPLEFT",VRO_MainFrame_Content_group[group],"TOPLEFT", 0, -poffst)
		VRO_MainFrame_Content_group[group].player[plyr]:SetPoint("RIGHT",VRO_MainFrame_Content_group[group],"RIGHT", 0, 0)
		VRO_MainFrame_Content_group[group].player[plyr]:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
		VRO_MainFrame_Content_group[group].player[plyr]:SetBackdropColor(1,1,1,0.25);
		VRO_MainFrame_Content_group[group].player[plyr]:SetHeight(VRO_MainFrame_Content_group[group]:GetHeight()/6)

		VRO_MainFrame_Content_group[group].player[plyr].sign = CreateFrame("Button", "VRO_MainFrame_Content_G"..group.."_P"..plyr.."_SIGN", VRO_MainFrame_Content_group[group].player[plyr]);
		VRO_MainFrame_Content_group[group].player[plyr].sign:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
		VRO_MainFrame_Content_group[group].player[plyr].sign:SetBackdropColor(0,0,0,0);
		VRO_MainFrame_Content_group[group].player[plyr].sign:SetNormalTexture("Interface/TargetingFrame/UI-RaidTargetingIcons")
		VRO_MainFrame_Content_group[group].player[plyr].sign:SetPoint("LEFT", VRO_MainFrame_Content_group[group].player[plyr], "LEFT", 0,0);
		VRO_MainFrame_Content_group[group].player[plyr].sign:SetWidth(VRO_MainFrame_Content_group[group]:GetHeight()/6)
		VRO_MainFrame_Content_group[group].player[plyr].sign:SetHeight(VRO_MainFrame_Content_group[group]:GetHeight()/6)
		VRO_MainFrame_Content_group[group].player[plyr].sign:SetFrameStrata("DIALOG")
		VRO_MainFrame_Content_group[group].player[plyr].sign:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		VRO_MainFrame_Content_group[group].player[plyr].sign:SetScript("OnClick", function () 
			print("VRO_MainFrame_Content_G"..group.."_P"..player.."_SIGN")
		end)
		
	end
end


function loadSetInGUI(set)
	print(set)
end
--------------------------
local function getCurrentRaid()
    local roster = {};
    
    local groupIndex = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
        [7] = 0,
        [8] = 0
	}
	
    if VRO_Members == nil then
		VRO_Members = {}
	end

    for raidIndex=1, MAX_RAID_MEMBERS do
    	name, rank,subgroup, _, _, class, _, _, _ = GetRaidRosterInfo(raidIndex);
		if name and rank and subgroup and class then 
			roster[subgroup] = {
				[groupIndex[subgroup]] = {
					["raidIndex"] = raidIndex,
					["name"] = name,
					["class"] = strlow(class),
					["rank"] = rank,
				}
			}
			
			-- role assignement
			-- tank, heal, melee, caster, not sure if I should put equi/feral and co...
			if (VRO_Members and VRO_Members[name] ~= nil) then
				-- take last assigned role, usualy doesn't change
				roster[subgroup][groupIndex[subgroup]].role = VRO_Members[name].role
			else
				-- We are assuming basic roles
				if class == "PRIEST" or class == "PALADIN" or class == "DRUID" or class == "SHAMAN" then
					roster[subgroup][groupIndex[subgroup]].role = "heal";
				elseif class == "WARRIOR" or class == "ROGUE" then
					roster[subgroup][groupIndex[subgroup]].role = "melee";
				elseif class == "HUNTER" then 
				    roster[subgroup][groupIndex[subgroup]].role = "ranged";
				else
					roster[subgroup][groupIndex[subgroup]].role = "caster";
				end

				VRO_Members[name] = {
					["class"] = strlow(class),
					["role"] = roster[subgroup][groupIndex[subgroup]].role,
				}
			end
			
			groupIndex[subgroup] = groupIndex[subgroup] +1;
			if groupIndex[subgroup] == 5 then
				roster[subgroup].full = true;
				dLog(strfor("%d is full", subgroup));
			end
		end
    end
    return roster;
end

local function getPlayerByName(roster, pName)
	dLog("getPlayerByName : "..pName)
	for group,members in pairs(roster) do 
		for member,datas in pairs(members) do
			if type(datas) == "table" then
				if strlow(datas.name) == strlow(pName) then
					dLog(strfor("%s found as raidIndex %d", pName, datas.raidIndex))
					return datas.raidIndex
				end
			end
		end

	end
	dLog(strfor("%s was not found", pName))
	return nil
end

local function getUnAssignedPlayerInGroup(group)
	dLog("getUnassignedPlayerInGroup")
	for member, datas in pairs(CurrentRoster[group]) do
		if type(datas) == "table" then
			if not (has_value(assignatedPlayers, datas.raidIndex)) then
				dLog(strfor("%s(%d) not assigned",datas.name, datas.raidIndex))
				return datas.raidIndex; 
			end
		end
	end
	dLog("no unassigned player in group, skip")
	return nil;
end

local function getUAPlayerWithRoleAndClass(role, class, raid)
	dLog(strfor("getUAPlayerWithRoleAndClass(%s, %s)", role, class))
	local correctRoleidx = nil;
	for groupe,members in pairs(raid) do
		for member,data in pairs(members) do
			if type(data) == "table" then
				if not (has_value(assignatedPlayers, data.raidIndex)) and data.role == role then 
					if class and data.class == class then
						-- if he is not assignated, has the correct role and the correct class we can stop here
						dLog(strfor("%s(%d) is not assigned and has correct role and class", data.name, data.raidIndex))
						return data.raidIndex 
					else
						-- else we can just store his index if there is none storred, so we can return it if we found nobody with the correct class with that role that is free
						correctRoleidx = nil and data.raidIndex or correctRoleidx
						dLog(strfor("%s(%d) has the correct role but not class so we store it", data.name, data.raidIndex))
					end
				end
			end
		end
	end
	if (correctRoleIdx ~= nil) then
		dLog(strfor("returning %d as correct role ( but not correct class )"));
	else
		dLog("no unassigned player with role and class");
	end
	return correctRoleidx;
end

local function assignPlayer(player, currGroup, full)
	dLog(strfor("assignPlayer %d", player))
	-- the player normally assigned is in the raid, we now want to know his group
	local _, _, thisPlayerGroup = GetRaidRosterInfo(player);
	if thisPlayerGroup == currGroup then
		dLog("Player already in the group")
		-- yay he is already here, we assign him and pass to the next
		tinsert(assignatedPlayers, player);
		--tprint(assignatedPlayers);
		return player;
	else
		dLog("Player not in the group")
		-- he is not in this group so if the group is full we need to find a player in this group that we can swap out
		if(full) then
			local UAplayer = getUnAssignedPlayerInGroup(currGroup)
			if UAplayer then
				-- we got one so here we go and we can assign him
				dLog(strfor("swapping %d with %d", UAplayer, player))
				SwapRaidSubgroup(UAplayer, player)
				tinsert(assignatedPlayers, player);
				--tprint(assignatedPlayers);
				return player;
			end
		else
			-- not full, just get him in here
			dLog(strfor("getting %d into %d", player, currGroup))
			SetRaidSubgroup(player, currGroup)
			tinsert(assignatedPlayers, player);
			--tprint(assignatedPlayers);
			return player;
		end

	end
	dLog("Nobody to swap, skip")
	return nil
end



function sortRaid(org)
	for i=1,15 do --Should be enough iteration to get things right ?
		-- reset CurrentRoster
		for k in pairs(CurrentRoster) do
			CurrentRoster[k] = nil
		end
		CurrentRoster = getCurrentRaid()

		-- empty the assignated players list
		for k in pairs (assignatedPlayers) do
			assignatedPlayers[k] = nil
		end

		for group,members in pairs(VRO_SETS[org]) do
			for member,datas in pairs(members) do
				-- if a name is precised we look into the raid if the player is there
				if (datas.name) then
					local thisPlayer = getPlayerByName(CurrentRoster, datas.name);
					if (thisPlayer) then 
						local full = CurrentRoster[group] and CurrentRoster[group].full or fasle;
						datas.raidIndex = assignPlayer(thisPlayer, group, full)
					else
						-- the player is not here so we are looking for another player with the role and class (if precised) we are looking for
						thisPlayer = getUAPlayerWithRoleAndClass(datas.role, datas.class, CurrentRoster)
						if (thisPlayer) then
							local full = CurrentRoster[group] and CurrentRoster[group].full or fasle;
						datas.raidIndex = assignPlayer(thisPlayer, group, full)
						end
					end
				else
					-- no name assigned so we use the role and class
				
					local thisPlayer = getUAPlayerWithRoleAndClass(datas.role, datas.class, CurrentRoster)
					if (thisPlayer) then
						local full = CurrentRoster[group] and CurrentRoster[group].full or fasle;
						datas.raidIndex = assignPlayer(thisPlayer, group, full)
					end
				end

				if datas.role == "tank" and datas.name then
					PromoteToAssistant(datas.name);
				end
			end
		end
	end
	CurrentSetup = org;
	VRO_MainFrame_Menu_CurrSetup_Text:SetText(org)
end

function saveCurrentSet(setName)
	local newOrg = {}
	if VRO_SETS == nil then
		VRO_SETS = {}
	elseif VRO_SETS[setName] ~= nil then
		return print(strfor("%s is already taken, pick another name", setName));
	end

	VRO_SETS[setName] = {
		[1] = {},
		[2] = {},
		[3] = {},
		[4] = {},
		[5] = {},
		[6] = {},
		[7] = {},
		[8] = {}
	}

	local groupIndex = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
        [7] = 0,
        [8] = 0
	}

	for raidIndex=1, MAX_RAID_MEMBERS do
    	name, _,subgroup, _, _, class, _, _, _ = GetRaidRosterInfo(raidIndex);
		if name and subgroup and class then 
			VRO_SETS[setName][subgroup][groupIndex[subgroup]] = {
				name = name,
				role = VRO_Members[name].role,
				class = strlow(class),
				raidIndex = nil
			}
			groupIndex[subgroup] = groupIndex[subgroup] +1;
		end
	end
end

fakeOrg = {
	[1] = {
		[1] = {
			name = "Faismoimal",
			role = "tank",
			class = "warrior",
			raidIndex = nil;
		},
		[2] = {
			name = "Hellfeim",
			role = "tank",
			class = "warrior",
			raidIndex = nil;
		},
		[3] = {
			name = "Lolotiste",
			role = "tank",
			class = "warrior",
			raidIndex = nil;
		},
		[4] = {
			name = "Axoni",
			role = "tank",
			class = "warrior",
			raidIndex = nil;
		},
		[5] = {
			name = "Serge",
			role = "heal",
			class = "paladin",
			raidIndex = nil;
		}
	},
	[2] = {
		[1] = {
			name = "Entitane",
			role = "melee",
			class = "warrior",
			raidIndex = nil;
		},
		[2] = {
			name = "Olgrym",
			role = "melee",
			class = "warrior",
			raidIndex = nil;
		},
		[3] = {
			name = "Raggsockan",
			role = "melee",
			class = "rogue",
			raidIndex = nil;
		},
		[4] = {
			name = "Lrox",
			role = "melee",
			class = "rogue",
			raidIndex = nil;
		},
		[5] = {
			name = "Oeildetaupe",
			role = "melee",
			class = "hunter",
			raidIndex = nil;
		}
	},
	[3] = {
		[1] = {
			name = "Edleweiss",
			role = "melee",
			class = "warrior",
			raidIndex = nil;
		},
		[2] = {
			name = "Ravengath",
			role = "melee",
			class = "rogue",
			raidIndex = nil;
		},
		[3] = {
			name = "Triana",
			role = "melee",
			class = "rogue",
			raidIndex = nil;
		},
		[4] = {
			name = "Durïll",
			role = "melee",
			class = "warrior",
			raidIndex = nil;
		},
		[5] = {
			name = "Kaulder",
			role = "melee",
			class = "hunter",
			raidIndex = nil;
		}
	},
	[4] = {
		[1] = {
			name = "Pøløx",
			role = "melee",
			class = "warrior",
			raidIndex = nil;
		},
		[2] = {
			name = "Agaria",
			role = "melee",
			class = "rogue",
			raidIndex = nil;
		},
		[3] = {
			name = "Fabibi",
			role = "melee",
			class = "warrior",
			raidIndex = nil;
		},
		[4] = {
			name = "Velocity",
			role = "melee",
			class = "hunter",
			raidIndex = nil;
		},
		[5] = {
			name = "Krider",
			role = "melee",
			class = "hunter",
			raidIndex = nil;
		}
	},
	[5] = {
		[1] = {
			name = "Kheldrill",
			role = "caster",
			class = "mage",
			raidIndex = nil;
		},
		[2] = {
			name = "Zaerah",
			role = "caster",
			class = "mage",
			raidIndex = nil;
		},
		[3] = {
			name = "Gigaleau",
			role = "caster",
			class = "mage",
			raidIndex = nil;
		},
		[4] = {
			name = "Sanplo",
			role = "caster",
			class = "mage",
			raidIndex = nil;
		},
		[5] = {
			name = "Patamilka",
			role = "caster",
			class = "druid",
			raidIndex = nil;
		}
	},
	[6] = {
		[1] = {
			name = "Uriah",
			role = "caster",
			class = "warlock",
			raidIndex = nil;
		},
		[2] = {
			name = "Peems",
			role = "caster",
			class = "warlock",
			raidIndex = nil;
		},
		[3] = {
			name = "Mèlba",
			role = "caster",
			class = "warlock",
			raidIndex = nil;
		},
		[4] = {
			name = "Poldark",
			role = "caster",
			class = "priest",
			raidIndex = nil;
		},
		[5] = {
			name = nil,
			role = "caster",
			class = "warlock",
			raidIndex = nil;
		}
	},
	[7] = {
		[1] = {
			name = "Azyzz",
			role = "heal",
			class = "paladin",
			raidIndex = nil;
		},
		[2] = {
			name = "Alhealce",
			role = "heal",
			class = "priest",
			raidIndex = nil;
		},
		[3] = {
			name = "Nawa",
			role = "heal",
			class = "druid",
			raidIndex = nil;
		},
		[4] = {
			name = "Barbiboule",
			role = "heal",
			class = "priest",
			raidIndex = nil;
		},
		[5] = {
			name = "Parsifalor",
			role = "heal",
			class = "paladin",
			raidIndex = nil;
		}
	},
	[8] = {
		[1] = {
			name = "Æthereal",
			role = "heal",
			class = "druid",
			raidIndex = nil;
		},
		[2] = {
			name = "Healkill",
			role = "heal",
			class = "priest",
			raidIndex = nil;
		},
		[3] = {
			name = "Aééris",
			role = "heal",
			class = "druid",
			raidIndex = nil;
		},
		[4] = {
			name = "Rahjan",
			role = "heal",
			class = "priest",
			raidIndex = nil;
		},
		[5] = {
			name = "Heqat",
			role = "healer",
			class = "paladin",
			raidIndex = nil;
		}
	}
}