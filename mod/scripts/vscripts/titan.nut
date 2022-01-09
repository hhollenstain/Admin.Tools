global function TitanCommand

// Health of NPC titans (2500 per bar)
int titanHealth = 25000

void function TitanCommand()
{
	#if SERVER
	AddClientCommandCallback("titan", Command1)
	AddClientCommandCallback("wingman", Command2)
	#endif
}

bool function Command1(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
		return true

	string type = args.len() > 0 ? args[0].tolower() : titan_npc_list[RandomInt(titan_npc_list.len())]

	thread SpawnTitan(player, type, GetPlayerCrosshairOrigin(player))

	return true
}

bool function Command2(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
		return true

	string type = args.len() > 0 ? args[0].tolower() : titan_npc_list[RandomInt(titan_npc_list.len())]

	thread SpawnTitan(player, type, player.GetOrigin())

	return true
}

void function SpawnTitan(entity player, string type, vector location)
{
	switch (type)
	{
		case ("ion"):
			type = "npc_titan_atlas_stickybomb_boss_fd"
		break

		case ("scorch"):
			type = "npc_titan_ogre_meteor_boss_fd"
		break

		case ("northstar"):
			type = "npc_titan_stryder_sniper_boss_fd"
		break

		case ("ronin"):
			type = "npc_titan_stryder_leadwall_boss_fd"
		break

		case ("tone"):
			type = "npc_titan_atlas_tracker_boss_fd"
		break

		case ("legion"):
			type = "npc_titan_ogre_minigun_boss_fd"
		break

		case ("monarch"):
			type = "npc_titan_atlas_vanguard_boss_fd"
		break
	}

	vector angles = Vector(0, player.EyeAngles().y, 0)

	entity titan = CreateNPCTitan("npc_titan", player.GetTeam(), location, angles)

	SetSpawnOption_NPCTitan(titan, TITAN_HENCH)
	SetSpawnOption_AISettings(titan, type)

	DispatchSpawn(titan)

	titan.SetMaxHealth(titanHealth)
	titan.SetHealth(titanHealth)
	titan.GetTitanSoul().SetShieldHealth(titan.GetTitanSoul().GetShieldHealthMax())
	SoulTitanCore_SetNextAvailableTime(titan.GetTitanSoul(), 100.0)
}
