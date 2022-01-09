global function TellCommand

void function TellCommand()
{
    #if SERVER
    AddClientCommandCallback("tell", Command)
    #endif
}

bool function Command(entity player, array <string> args)
{
	if (!PlayerIsAdmin(player))
	{
		return true
	}

	if (args.len() < 2)
	{
		print("Usage: tell <player> <message>")
		return true
	}

	array<entity> players = GetSelectedPlayers(player, [args[0]])

	string message = ""
	foreach (string word in args.slice(1))
		message += word + " "

	thread Tell(players, message)

    return true
}

void function Tell(array<entity> players, string message)
{
    foreach (entity player in players)
	{
		if (player == null)
			continue

        SendHudMessage(player, message, -1, 0.4, 255, 255, 0, 0, 0.15, 4, 0.15)
	}
}
