global function TitanfallCommand

void function TitanfallCommand()
{
	#if SERVER
	AddClientCommandCallback("titanfall", Command)
	AddClientCommandCallback("tf", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use titanfall, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		Titanfall([player])
		return true
	}

	switch (args[0].tolower())
	{
		case ("all"):
			Titanfall(GetPlayerArray())
		break

		case ("us"):
			Titanfall(GetTeamPlayers(player))
		break

		case ("them"):
			Titanfall(GetEnemyPlayers(player))
		break

		default:
			Titanfall(FindPlayersByName(args))
		break
	}

	return true
}

void function Titanfall(array<entity> players)
{
	foreach (entity player in players)
	{
		if (player == null)
			continue

		try
		{
			if (!player.IsTitan() && SpawnPoints_GetTitan().len() > 0)
				thread CreateTitanForPlayerAndHotdrop(player, GetTitanReplacementPoint(player, false))
		}
		catch (e)
		{
			print("Failed to drop player " + player.GetPlayerName() + "'s titan.")
		}
	}
}
