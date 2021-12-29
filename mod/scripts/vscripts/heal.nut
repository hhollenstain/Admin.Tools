global function HealCommand

void function HealCommand()
{
    #if SERVER
    AddClientCommandCallback("heal", Command)
    #endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use heal, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
    {
        thread Heal([player])
        return true
    }

    switch (args[0].tolower())
	{
		case ("all"):
			thread Heal(GetPlayerArray())
		break

		case ("us"):
			thread Heal(GetTeamPlayers(player))
		break

		case ("them"):
			thread Heal(GetEnemyPlayers(player))
		break

		default:
			thread Heal(FindPlayersByName(args))
		break
	}

    return true
}

void function Heal(array<entity> players)
{
    foreach (entity player in players)
	{
        if (player == null)
            continue

        player.SetHealth(player.GetMaxHealth())
    }
}
