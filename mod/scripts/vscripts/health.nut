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
	}
	else if (args.len() < 1)
	{
		print("Usage: health <value>")
		print("Usage: health <value> <playerName>")
	}
	else
	{
		array<entity> players = GetSelectedPlayers(player, args.slice(1))
		thread Health(players, args[0].tointeger())
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
