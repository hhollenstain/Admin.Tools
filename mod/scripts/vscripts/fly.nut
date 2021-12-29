global function FlyCommand

void function FlyCommand()
{
	#if SERVER
	AddClientCommandCallback("fly", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use fly, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		Fly([player])
		return true
	}

	switch (args[0].tolower())
	{
		case ("all"):
			Fly(GetPlayerArray())
		break

		case ("us"):
			Fly(GetTeamPlayers(player))
		break

		case ("them"):
			Fly(GetEnemyPlayers(player))
		break

		default:
			Fly(FindPlayersByName(args))
		break
	}

	return true
}

void function Fly(array<entity> players)
{
	foreach (entity player in players)
	{
		if (player == null)
		{
			continue
		}
		else if (player.IsNoclipping())
		{
			player.SetPhysics(MOVETYPE_WALK)
		}
		else
		{
			player.SetPhysics(MOVETYPE_NOCLIP)
		}
	}
}
