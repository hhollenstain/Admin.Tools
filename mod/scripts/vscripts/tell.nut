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
		print("Player " + player.GetPlayerName() + " tried to use tell, but they are not an admin.")
		return true
	}

	if (args.len() < 2)
	{
		print("Usage: tell <player> <message>")
        return true
	}

    string target = args[0].tolower()

    string message = ""
	foreach (string word in args.slice(1))
		message += word + " "

    array<entity> players = []

    switch (target)
	{
		case ("all"):
			players = GetPlayerArray()
		break

		case ("us"):
			players = GetTeamPlayers(player)
		break

		case ("them"):
			players = GetEnemyPlayers(player)
		break

		default:
			players = [FindPlayerByName(target)]
		break
	}

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
