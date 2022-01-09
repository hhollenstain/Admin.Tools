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
    if (PlayerIsAdmin(player))
    {
        array<entity> players = GetSelectedPlayers(player, args)
        thread SetVisibility(players, 0)
    }

    return true
}

bool function Command2(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
    {
        array<entity> players = GetSelectedPlayers(player, args)
        thread SetVisibility(players, ENTITY_VISIBLE_TO_EVERYONE)
    }

    return true
}

void function SetVisibility(array<entity> players, int visibilityLevel)
{
    foreach (entity player in players)
	{
        if (player == null)
            continue

        try
        {
			player.kv.VisibilityFlags = visibilityLevel
        }
        catch (e)
        {
            print("Failed to set visibility for player " + player.GetPlayerName() + ".")
        }
    }
}
