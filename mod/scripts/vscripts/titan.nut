global function TitanCommand

void function TitanCommand()
{
	#if SERVER
	AddClientCommandCallback("titan", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		return true
	}

	string titanId = titan_npc_list[RandomInt(titan_npc_list.len())]

	if (args.len() > 0)
	{
		string targetId = args[0].tolower()

		if (targetId == "viper")
			return SpawnViper(player)

		if (titan_npc_list.find(targetId) > -1)
			titanId = targetId
	}

	vector origin = GetPlayerCrosshairOrigin(player)
	vector angles = player.EyeAngles()

	angles.x = 0
	angles.z = 0

	entity titan = CreateNPCTitan("npc_titan", player.GetTeam(), origin, angles, [])

	SetSpawnOption_NPCTitan(titan, TITAN_HENCH)
	SetSpawnOption_AISettings(titan, titanId)

	thread DispatchSpawn(titan)

	return true
}

bool function SpawnViper(entity player)
{
	TitanLoadoutDef ornull loadout = GetTitanLoadoutForBossCharacter("Viper")

	if (loadout == null)
		return true

	expect TitanLoadoutDef(loadout)

	string baseClass = "npc_titan"
	string aiSettings = GetNPCSettingsFileForTitanPlayerSetFile(loadout.setFile)

	vector origin = GetPlayerCrosshairOrigin(player)
	vector angles = Vector(0, 0, 0)

	entity npc = CreateNPC(baseClass, player.GetTeam(), origin, angles)

	if (IsTurret(npc))
		npc.kv.origin -= Vector(0, 0, 32)

	SetSpawnOption_AISettings(npc, aiSettings)

	if (npc.GetClassName() == "npc_titan")
	{
		string builtInLoadout = expect string(Dev_GetAISettingByKeyField_Global(aiSettings, "npc_titan_player_settings"))
		SetTitanSettings(npc.ai.titanSettings, builtInLoadout)
		npc.ai.titanSpawnLoadout.setFile = builtInLoadout
		OverwriteLoadoutWithDefaultsForSetFile(npc.ai.titanSpawnLoadout) // get the entire loadout, including defensive and tactical
	}

	SetSpawnOption_NPCTitan(npc, TITAN_MERC)
	SetSpawnOption_TitanLoadout(npc, loadout)

	npc.ai.bossTitanPlayIntro = false

	thread DispatchSpawn(npc)

	return true
}
