global function FindPlayerByName
global function FindPlayersByName
global function GetEnemyPlayers
global function GetTeamPlayers

entity function FindPlayerByName(string playerName)
{
	foreach (entity player in GetPlayerArray())
		if (player != null && player.GetPlayerName().tolower() == playerName.tolower())
			return player

	print("Player " + playerName + " could not be found.")

	return null
}

array<entity> function FindPlayersByName(array<string> playerNames)
{
	array<entity> players = []

	foreach (string playerName in playerNames)
	{
		entity player = FindPlayerByName(playerName)

		if (player != null)
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
