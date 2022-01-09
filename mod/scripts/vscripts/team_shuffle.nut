global function ShuffleTeamsCommand
global function ShuffleTeams

void function ShuffleTeamsCommand()
{
	#if SERVER
	AddClientCommandCallback("shuffle", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
    {
        thread ShuffleTeams()
    }

	return true
}

void function ShuffleTeams()
{
    int team = TEAM_IMC

    foreach (entity player in GetShuffledPlayers())
    {
        SetTeam(player, team)

        if (team == TEAM_IMC)
            team = TEAM_MILITIA
        else
            team = TEAM_IMC
    }
}

array<entity> function GetShuffledPlayers()
{
    array<entity> players = GetPlayerArray()

	for (int i = players.len() - 1; i > 0; i--)
    {
        int randomIndex = RandomInt(i + 1)
        entity temp = players[randomIndex]

        players[randomIndex] = players[i]
        players[i] = temp
    }

    return players
}
