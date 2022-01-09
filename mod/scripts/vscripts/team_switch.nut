global function SwitchTeamsCommand

void function SwitchTeamsCommand()
{
	#if SERVER
	AddClientCommandCallback("switch", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
	{
		thread SwitchTeams(GetSelectedPlayers(player, args))
	}

	return true
}

void function SwitchTeams(array<entity> players)
{
	foreach (entity player in players)
	{
		if (player == null)
			continue

		try
		{
			int team = (player.GetTeam() == TEAM_IMC) ? TEAM_MILITIA : TEAM_IMC
			SetTeam(player, team)
		}
		catch (e)
		{
			print("Failed to switch player " + player.GetPlayerName() + "'s team.")
		}
	}
}
