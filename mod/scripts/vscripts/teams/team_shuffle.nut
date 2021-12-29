global function ShuffleTeamsCommand

void function ShuffleTeamsCommand()
{
	#if SERVER
	AddClientCommandCallback("shuffle", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use shuffle, but they are not an admin.")
		return true
	}

    array<entity> players = GetShuffledPlayers()

    int team = TEAM_IMC

    foreach (entity p in players)
    {
        SetTeam(p, team)

        if (team == TEAM_IMC)
            team = TEAM_MILITIA
        else
            team = TEAM_IMC
    }

	return true
}

array<entity> function GetShuffledPlayers()
{
    array<entity> players = GetPlayerArray()

	for (int i = players.len() - 1; i > 0; i--)
    {
        int index = RandomInt(i + 1)
        entity temp = players[index]

        players[index] = players[i]
        players[i] = temp
    }

    return players
}
