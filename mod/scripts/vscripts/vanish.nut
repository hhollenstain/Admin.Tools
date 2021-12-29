global function VanishCommand

void function VanishCommand()
{
    #if SERVER
    AddClientCommandCallback("vanish", Command1)
	AddClientCommandCallback("reveal", Command2)
    #endif
}

bool function Command1(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use vanish, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		Vanish([player])
		return true
	}

    switch (args[0].tolower())
	{
		case ("all"):
			Vanish(GetPlayerArray())
		break

		case ("us"):
			Vanish(GetTeamPlayers(player))
		break

		case ("them"):
			Vanish(GetEnemyPlayers(player))
		break

		default:
			Vanish(FindPlayersByName(args))
		break
	}

    return true
}

bool function Command2(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use reveal, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		Reveal([player])
		return true
	}

    switch (args[0].tolower())
	{
		case ("all"):
			Reveal(GetPlayerArray())
		break

		case ("us"):
			Reveal(GetTeamPlayers(player))
		break

		case ("them"):
			Reveal(GetEnemyPlayers(player))
		break

		default:
			Reveal(FindPlayersByName(args))
		break
	}

    return true
}

void function Vanish(array<entity> players)
{
    foreach (entity player in players)
	{
        if (player == null)
            continue

        try
        {
			player.kv.VisibilityFlags = 0
        }
        catch (e)
        {
            print("Failed to vanish player " + player.GetPlayerName() + ".")
        }
    }
}

void function Reveal(array<entity> players)
{
    foreach (entity player in players)
	{
        if (player == null)
            continue

        try
        {
			player.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
        }
        catch (e)
        {
            print("Failed to reveal player " + player.GetPlayerName() + ".")
        }
    }
}
