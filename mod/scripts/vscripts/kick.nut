global function KickCommand

void function KickCommand()
{
	#if SERVER
	AddClientCommandCallback("kickplayer", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use kick, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		print("Usage: kickplayer <all/us/them/player>")
		return true
	}

    switch (args[0].tolower())
	{
		case ("all"):
			Kick(GetPlayerArray())
		break

		case ("us"):
			Kick(GetTeamPlayers(player))
		break

		case ("them"):
			Kick(GetEnemyPlayers(player))
		break

		default:
			Kick(FindPlayersByName(args))
		break
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
