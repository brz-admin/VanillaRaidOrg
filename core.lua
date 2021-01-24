

local dbug = true;
local dbuglvl = 2;
local assignatedPlayers = {};
local CurrentRoster = {};
local CurrentSetup = nil;

VRO = VRO;
VRO_SETS = VRO_SETS;
VRO_Members = VRO_Members;
strlow = string.lower;
strfor = string.format;
tinsert = table.insert;
GetRaidRosterInfo = GetRaidRosterInfo;
SwapRaidSubgroup = SwapRaidSubgroup;

local VRO_gui = {};
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

--- Opts:
---     name (string): Name of the dropdown (lowercase)
---     parent (Frame): Parent frame of the dropdown.
---     items (Table): String table of the dropdown options.
---     defaultVal (String): String value for the dropdown to default to (empty otherwise).
---     changeFunc (Function): A custom function to be called, after selecting a dropdown option.
local function createDropdown(opts)
    local dropdown_name = '$parent_' .. opts['name'] .. '_dropdown'
    local menu_items = opts['items'] or {}
    local title_text = opts['title'] or ''
    local dropdown_width = 0
    local default_val = opts['defaultVal'] or ''
    local change_func = opts['changeFunc'] or function (dropdown_val) end

    local dropdown = CreateFrame("Frame", dropdown_name, opts['parent'], 'UIDropDownMenuTemplate')
    local dd_title = dropdown:CreateFontString(dropdown, 'OVERLAY', 'GameFontNormal')
    dd_title:SetPoint("TOPLEFT", 20, 10)

    for _, item in pairs(menu_items) do -- Sets the dropdown width to the largest item string width.
        dd_title:SetText(item)
        local text_width = dd_title:GetStringWidth() + 20
        if text_width > dropdown_width then
            dropdown_width = text_width
        end
    end

    UIDropDownMenu_SetWidth(dropdown, dropdown_width)
    UIDropDownMenu_SetText(dropdown, default_val)
    dd_title:SetText(title_text)

    UIDropDownMenu_Initialize(dropdown, function(self, level, _)
        local info = UIDropDownMenu_CreateInfo()
        for key, val in pairs(menu_items) do
            info.text = val[0]
            info.icon = val[1]
            info.checked = false
            info.menuList= key
            info.hasArrow = false
            info.func = function(b)
                UIDropDownMenu_SetSelectedValue(dropdown, b.value, b.value)
                UIDropDownMenu_SetText(dropdown, b.value)
                b.checked = true
                change_func(dropdown, b.value)
            end
            UIDropDownMenu_AddButton(info)
        end
    end)

    return dropdown
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

VRO_MainFrame_Title = CreateFrame("Frame", "VRO_MainFrame_Title", VRO_MainFrame);
VRO_MainFrame_Title:SetPoint("TOP", "VRO_MainFrame", 0, -0);
VRO_MainFrame_Title:SetPoint("LEFT", "VRO_MainFrame", 0, -0);
VRO_MainFrame_Title:SetPoint("RIGHT", "VRO_MainFrame", 0, -0);
VRO_MainFrame_Title:SetWidth(20);

VRO_MainFrame_Title_text = VRO_MainFrame_Title:CreateFontString("VRO_MainFrame_Title", "ARTWORK", "GameFontWhite")
VRO_MainFrame_Title_text:SetPoint("TOP", "VRO_MainFrame_Title", 0, -5);
VRO_MainFrame_Title_text:SetText("Raid Organiser");
VRO_MainFrame_Title_text:SetFont("Fonts\\FRIZQT__.TTF", 10)
VRO_MainFrame_Title_text:SetTextColor(0.5, 1, 1, 1);

VRO_MainFrame_Menu = CreateFrame("Frame", "VRO_MainFrame_Menu", VRO_MainFrame);
VRO_MainFrame_Menu:SetPoint("TOP", "VRO_MainFrame_Title", "BOTTOM", 0, 0);
local items = {};
for set,_ in pairs(VSR_SETS) do
    tinsert(items,{set,nil})
end
-- for icons : Interface\\TargetingFrame\\UI-RaidTargetingIcon_X UIDropDownMenu_SetSelectedName
local setOpt = {
    ['name']='sets',
    ['parent']=VRO_MainFrame,
    ['title']='Sets',
    ['items']= items,
    ['defaultVal']='', 
    ['changeFunc']=function(dropdown_frame, dropdown_val)
        VRO_gui.selected = dropdown_val;
        loadSetInGUI(dropdown_val)
        -- Custom logic goes here, when you change your dropdown option.
    end
}
SetsDD = createDropdown(setOpt)
-- Don't forget to set your dropdown's points, we don't do this in the creation method for simplicities sake.
SetsDD:SetPoint("TOP", VRO_MainFrame_Menu, "TOP", -20, 0);
SetsDD:SetPoint("LEFT", VRO_MainFrame_Menu, "LEFT", -20, 0);

VRO_MainFrame_Menu_Loadbutton = CreateFrame("Button", "VRO_MainFrame_Menu_Loadbutton", VRO_MainFrame_Menu);
VRO_MainFrame_Menu_Loadbutton:SetText("Apply Set");
VRO_MainFrame_Menu_Loadbutton:SetPoint("LEFT", SetsDD, "RIGHT", 10, 0);
VRO_MainFrame_Menu_Loadbutton:RegisterForClick("AnyUp");
VRO_MainFrame_Menu_Loadbutton:SetScript("OnClick", function () 
        sortRaid(VRO_gui.selected);o
end)

VRO_MainFrame_Menu_CurrSetup_Text = VRO_MainFrame_Menu:CreateFontString("VRO_MainFrame_Menu", "ARTWORK", "GameFontWhite");
VRO_MainFrame_Menu_CurrSetup_Text:SetPoint("RIGHT", VRO_MainFrame_Menu,"RIGHT",0,0);
VRO_MainFrame_Menu_CurrSetup_Text:SetText("No Raid setup")

VRO_MainFrame_Content = CreateFrame("Frame", "VRO_MainFrame_Content", VRO_MainFrame);
VRO_MainFrame_Content:SetPoint("TOP",VRO_MainFrame_Menu,"BOTTOM", -10, 0)
VRO_MainFrame_Content:SetPoint("BOTTOM", VRO_MainFrame, "BOTTOM", 0, 0);


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

		for group,members in pairs(VSR_SETS[org]) do
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