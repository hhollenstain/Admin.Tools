global function RCONCommand

void function RCONCommand()
{
	#if SERVER
	AddClientCommandCallback("rcon", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use rcon, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		print("Usage: rcon <command>")
		return true
	}

    RCON(args)

	return true
}

void function RCON(array<string> args)
{
    string command = ""

    foreach (string arg in args)
        command += arg + " "

    ServerCommand(command)
}
