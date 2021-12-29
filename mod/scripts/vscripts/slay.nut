global function SlayCommand

void function SlayCommand()
{
	#if SERVER
	AddClientCommandCallback("slay", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use slay, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		Slay([player])
		return true
	}

	switch (args[0].tolower())
	{
		case ("all"):
			Slay(GetPlayerArray())
		break

		case ("us"):
			Slay(GetTeamPlayers(player))
		break

		case ("them"):
			Slay(GetEnemyPlayers(player))
		break

		default:
			Slay(FindPlayersByName(args))
		break
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
