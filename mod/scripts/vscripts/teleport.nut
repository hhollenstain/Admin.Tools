global function TeleportCommand

void function TeleportCommand()
{
	#if SERVER
	AddClientCommandCallback("teleport", Command)
	AddClientCommandCallback("tp", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use teleport, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		print("Usage: teleport <toThisPlayer>")
		print("Usage: teleport <thisPlayer> <toThatPlayer>")
		return true
	}

	entity player1 = null
	entity player2 = null

	if (args.len() == 1)
	{
		player1 = player
		player2 = FindPlayerByName(args[0])
	}
	else
	{
		player1 = FindPlayerByName(args[0])
		player2 = FindPlayerByName(args[1])
	}

	Teleport(player1, player2)

	return true
}

void function Teleport(entity player1, entity player2)
{
	if (player1 == null || player2 == null)
		return

	if (IsAlive(player1) && IsAlive(player2))
	{
		player1.SetOrigin(player2.GetOrigin())
		player1.SetAngles(player2.EyeAngles())
	}
}
