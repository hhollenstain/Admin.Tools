global function KickCommand

void function KickCommand()
{
	#if SERVER
	AddClientCommandCallback("kickplayer", Command)
	AddClientCommandCallback("kickp", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
	{
		thread Kick(GetSelectedPlayers(player, args))
	}

	return true
}

void function Kick(array<entity> players)
{
    foreach (entity player in players)
	{
		if (player == null)
			continue

		ServerCommand("kickid "+ player.GetUID())
	}
}
