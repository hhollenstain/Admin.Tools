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
	}
	else if (args.len() == 0)
	{
		print("Usage: rcon <command>")
	}
	else
	{
		thread RCON(args)
	}

	return true
}

void function RCON(array<string> args)
{
    string command = ""

    foreach (string arg in args)
        command += arg + " "

    ServerCommand(command)
}
