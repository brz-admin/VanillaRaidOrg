

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
--------------------------

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
VRO_MainFrame_Title:SetPoint("TOP", "VSR_MAIN_FRAME", 0, -0);
VRO_MainFrame_Title:SetPoint("LEFT", "VSR_MAIN_FRAME", 0, -0);
VRO_MainFrame_Title:SetPoint("RIGHT", "VSR_MAIN_FRAME", 0, -0);
VRO_MainFrame_Title:SetWidth(20);

VRO_MainFrame_Title_text = VRO_MainFrame_Title:CreateFontString("VRO_MainFrame_Title", "ARTWORK", "GameFontWhite")
VRO_MainFrame_Title_text:SetPoint("TOP", "VRO_MainFrame_Title", 0, -5);
VRO_MainFrame_Title_text:SetText("Raid Organiser");
VRO_MainFrame_Title_text:SetFont("Fonts\\FRIZQT__.TTF", 10)
VRO_MainFrame_Title_text:SetTextColor(0.5, 1, 1, 1);


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
				elseif class == "WARRIOR" or class == "ROGUE" or class == "HUNTER" then
					roster[subgroup][groupIndex[subgroup]].role = "melee";
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