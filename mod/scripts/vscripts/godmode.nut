global function GodModeCommand

void function GodModeCommand()
{
	#if SERVER
	AddClientCommandCallback("godmode", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
	{
		array<entity> players = GetSelectedPlayers(player, args)
		thread Health(players, 524287)
	}

	return true
}
