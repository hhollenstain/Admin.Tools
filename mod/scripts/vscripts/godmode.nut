global function GodModeCommand

void function GodModeCommand()
{
	#if SERVER
	AddClientCommandCallback("godmode", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use godmode, but they are not an admin.")
		return true
	}

    array<entity> players = [player]

    if (args.len() > 0)
    {
        switch (args[0].tolower())
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
                players = FindPlayersByName(args)
            break
        }
    }

    Health(players, 524287)

	return true
}
