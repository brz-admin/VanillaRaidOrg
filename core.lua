local CurrentRoster = {};

for raidIndex=1, MAX_RAID_MEMBERS do
	CurrentRoster[raidIndex].name, CurrentRoster[raidIndex].rank, CurrentRoster[raidIndex].subgroup, _, _, CurrentRoster[raidIndex].class, _, _, _ = GetRaidRosterInfo(raidIndex);
	
	if (VRO_Members[name])
	-- We are assuming roles
	if CurrentRoster[raidIndex].class == "PRIEST" or CurrentRoster[raidIndex].class == "PALADIN" or CurrentRoster[raidIndex].class == "DRUID" or CurrentRoster[raidIndex].class == "SHAMAN" then
		CurrentRoster[raidIndex].role = "heal";
	elseif CurrentRoster[raidIndex].class == "WARRIOR" or CurrentRoster[raidIndex].class == "ROGUE" or CurrentRoster[raidIndex].class == "HUNTER" then
		CurrentRoster[raidIndex].role = "melee";
	else
		CurrentRoster[raidIndex].role = "caster";
	end
end