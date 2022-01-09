untyped

global function RespawnCommand

void function RespawnCommand()
{
	#if SERVER
	AddClientCommandCallback("respawn", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
	{
		thread Respawn(GetSelectedPlayers(player, args))
	}

	return true
}

void function Respawn(array<entity> players)
{
	foreach (entity player in players)
	{
		if (player == null)
			continue

		try
		{
			player.RespawnPlayer(null)
		}
		catch (e)
		{
			print("Failed to respawn player " + player.GetPlayerName() + ".")
		}
	}
}
