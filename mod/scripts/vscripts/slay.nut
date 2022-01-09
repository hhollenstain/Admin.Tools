global function SlayCommand

void function SlayCommand()
{
	#if SERVER
	AddClientCommandCallback("slay", Command)
	AddClientCommandCallback("kill", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
	{
		thread Slay(GetSelectedPlayers(player, args))
	}

	return true
}

void function Slay(array<entity> players)
{
	foreach (entity player in players)
	{
		if (player == null)
			continue

		try
		{
			if (player != null && IsAlive(player))
				player.Die()
		}
		catch (e)
		{
			print("Failed to slay player " + player.GetPlayerName() + ".")
		}
	}
}
