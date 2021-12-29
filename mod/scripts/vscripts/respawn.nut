untyped

global function RespawnCommand

void function RespawnCommand()
{
	#if SERVER
	AddClientCommandCallback("respawn", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use respawn, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		Respawn([player])
		return true
	}

	switch (args[0].tolower())
	{
		case ("all"):
			Respawn(GetPlayerArray())
		break

		case ("us"):
			Respawn(GetTeamPlayers(player))
		break

		case ("them"):
			Respawn(GetEnemyPlayers(player))
		break

		default:
			Respawn(FindPlayersByName(args))
		break
	}

	return true
}

void function Respawn(array<entity> players)
{
	foreach (entity player in players)
	{
		if (player == null)
			continue

		try
		{
			player.RespawnPlayer(null)
		}
		catch (e)
		{
			print("Failed to respawn player " + player.GetPlayerName() + ".")
		}
	}
}
