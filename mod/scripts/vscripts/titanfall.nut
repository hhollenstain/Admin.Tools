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
	if (PlayerIsAdmin(player))
	{
		thread Titanfall(GetSelectedPlayers(player, args))
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
