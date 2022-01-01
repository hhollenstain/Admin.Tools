global function HealthCommand
global function Health

void function HealthCommand()
{
	#if SERVER
	AddClientCommandCallback("health", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use health, but they are not an admin.")
		return true
	}

	if (args.len() < 2)
	{
		print("Usage: health <value> <playerName>")
		return true
	}

	int value = args[0].tointeger()

	switch (args[1].tolower())
	{
		case ("all"):
			Health(GetPlayerArray(), value)
		break

		case ("us"):
			Health(GetTeamPlayers(player), value)
		break

		case ("them"):
			Health(GetEnemyPlayers(player), value)
		break

		default:
			Health(FindPlayersByName(args.slice(1)), value)
		break
	}

	return true
}

void function Health(array<entity> players, int value)
{
	foreach (entity player in players)
	{
		if (player == null || !IsAlive(player))
            continue

		if (value < 1)
			value = 1

		if (player.IsTitan() && value < 2500)
			value = 2500

		if (value > 524287)
            value = 524287

        player.SetMaxHealth(value)
        player.SetHealth(value)
	}
}
