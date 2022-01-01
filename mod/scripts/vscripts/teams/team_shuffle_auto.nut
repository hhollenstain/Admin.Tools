global function AutoShuffleTeamsHook

array<string> disabledMaps = ["mp_lobby"]
array<string> disabledModes = ["private_match", "inf", "hs", "ffa"]

void function AutoShuffleTeamsHook()
{
    // Shuffle teams at the end of the match
	AddCallback_GameStateEnter(eGameState.Postmatch, AutoShuffleTeams)
}

void function AutoShuffleTeams()
{
	// Check if the gamemode or map are on the blacklist
    bool skipForThisMap = disabledMaps.find(GetMapName()) > -1
	bool skipForThisMode = disabledModes.find(GAMETYPE) > -1

    if (skipForThisMap || skipForThisMode)
        return

	if (GetConVarInt("auto_shuffle_teams") > 0)
        ShuffleTeams()
}
