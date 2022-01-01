global function FindPlayerByName
global function FindPlayersByName
global function GetEnemyPlayers
global function GetTeamPlayers

entity function FindPlayerByName(string playerName)
{
	foreach (entity player in GetPlayerArray())
	{
		if (player == null)
			continue

		string thisPlayerName = player.GetPlayerName().tolower()
		string thatPlayerName = playerName.tolower()

		if (thisPlayerName == thatPlayerName)
			return player

		// Partial match
		if (thisPlayerName.find(thatPlayerName) > -1)
			return player
	}

	print("Player " + playerName + " could not be found.")

	return null
}

array<entity> function FindPlayersByName(array<string> playerNames)
{
	array<entity> players = []

	foreach (string playerName in playerNames)
	{
		entity player = FindPlayerByName(playerName)

		if (player != null && players.find(player) < 0)
			players.append(player)
	}

	return players
}

array<entity> function GetEnemyPlayers(entity player)
{
    int team = player.GetTeam() == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC
	return GetPlayerArrayOfTeam(team)
}

array<entity> function GetTeamPlayers(entity player)
{
	return GetPlayerArrayOfTeam(player.GetTeam())
}
