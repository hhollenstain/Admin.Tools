global function SpawnTitanCommand

global const titan_list = [
	"npc_titan_atlas_stickybomb_boss_fd",
	"npc_titan_atlas_stickybomb",
	"npc_titan_atlas_tracker_boss_fd",
	"npc_titan_atlas_tracker_fd_sniper",
	"npc_titan_atlas_tracker_mortar",
	"npc_titan_atlas_tracker",
	"npc_titan_atlas_vanguard_boss_fd",
	"npc_titan_atlas_vanguard",
	"npc_titan_ogre_meteor_boss_fd",
	"npc_titan_ogre_meteor",
	"npc_titan_ogre_minigun_boss_fd",
	"npc_titan_ogre_minigun_nuke",
	"npc_titan_ogre_minigun",
	"npc_titan_stryder_leadwall_arc",
	"npc_titan_stryder_leadwall_boss_fd",
	"npc_titan_stryder_leadwall_shift_core",
	"npc_titan_stryder_leadwall",
	"npc_titan_stryder_rocketeer_dash_core",
	"npc_titan_stryder_rocketeer",
	"npc_titan_stryder_sniper_boss_fd",
	"npc_titan_stryder_sniper_fd",
	"npc_titan_stryder_sniper"
]

void function SpawnTitanCommand()
{
	#if SERVER
	AddClientCommandCallback("spawntitan", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	string titanId = titan_list[RandomInt(titan_list.len())]

	if (args.len() > 0)
	{
		string targetId = args[0].tolower()

		if (targetId == "viper")
			return SpawnViper(player, args)

		if (titan_list.find(targetId) > -1)
			titanId = targetId
	}

	vector origin = GetPlayerCrosshairOrigin(player)
	vector angles = player.EyeAngles()

	angles.x = 0
	angles.z = 0

	entity titan = CreateNPCTitan("npc_titan", player.GetTeam(), origin, angles, [])

	SetSpawnOption_NPCTitan(titan, TITAN_HENCH)
	SetSpawnOption_AISettings(titan, titanId)

	DispatchSpawn(titan)

	return true
}

bool function SpawnViper(entity player, array<string> args)
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

	DispatchSpawn(npc)

	return true
}
