

local dbug = true;

local function getCurrentRaid()
    local CurrentRoster = {};
    
    local groupIndex = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
        [5] = 1,
        [6] = 1,
        [7] = 1,
        [8] = 1
    }
    
    for raidIndex=1, MAX_RAID_MEMBERS do
    	name, rank,subgroup, _, _, class, _, _, _ = GetRaidRosterInfo(raidIndex);
    	
    	CurrentRoster[subgroup][groupIndex[subgroup]] = {
    	    ["raidIndex"] = raidIndex,
    	    ["name"] = name,
    	    ["class"] = class,
    	    ["rank"] = rank,
    	}
    	
    	
    	-- role assignement
    	-- tank, heal, melee, caster, not sure if I should put equi/feral and co...
    	if (VRO_Members[name] ~= nil) then
    	    -- take last assigned role, usualy doesn't change
    	    CurrentRoster[subgroup][groupIndex[subgroup]].role = VRO_Members[name].role
    	else
        	-- We are assuming basic roles
        	if CurrentRoster[subgroup][groupIndex[subgroup]].class == "PRIEST" or CurrentRoster[subgroup][groupIndex[subgroup]].class == "PALADIN" or CurrentRoster[subgroup][groupIndex[subgroup]].class == "DRUID" or CurrentRoster[subgroup][groupIndex[subgroup]].class == "SHAMAN" then
    	    	CurrentRoster[subgroup][groupIndex[subgroup]].role = "heal";
        	elseif CurrentRoster[subgroup][groupIndex[subgroup]].class == "WARRIOR" or CurrentRoster[subgroup][groupIndex[subgroup]].class == "ROGUE" or CurrentRoster[subgroup][groupIndex[subgroup]].class == "HUNTER" then
        		CurrentRoster[subgroup][groupIndex[subgroup]].role = "melee";
        	else
        		CurrentRoster[subgroup][groupIndex[subgroup]].role = "caster";
        	end
    	end
    	
    	groupIndex[subgroup] = groupIndex[subgroup] +1;
    	if dbug and groupIndex[subgroup] == 5 then
    	    print(subgroup.." is full");
    	end
    end
    return CurrentRoster;
end

local function sortRaid(org)
    local CurrentRoster = getCurrentRaid()
    for group,members in pairs(CurrentRoster) do
    -- something    
    end
end

-- 

