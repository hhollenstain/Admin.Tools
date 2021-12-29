global function SwitchTeamsCommand

void function SwitchTeamsCommand()
{
	#if SERVER
	AddClientCommandCallback("switch", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use switch, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		SwitchTeams([player])
		return true
	}

	switch (args[0].tolower())
	{
		case ("all"):
			SwitchTeams(GetPlayerArray())
		break

		default:
			SwitchTeams(FindPlayersByName(args))
		break
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
			switch (player.GetTeam())
			{
				case (TEAM_IMC):
					SetTeam(player, TEAM_MILITIA)
				break

				case (TEAM_MILITIA):
					SetTeam(player, TEAM_IMC)
				break
			}
		}
		catch (e)
		{
			print("Failed to switch player " + player.GetPlayerName() + "'s team.")
		}
	}
}
