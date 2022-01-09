global function FlyCommand

void function FlyCommand()
{
	#if SERVER
	AddClientCommandCallback("fly", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
	{
		thread Fly(GetSelectedPlayers(player, args))
	}

	return true
}

void function Fly(array<entity> players)
{
	foreach (entity player in players)
	{
		if (player == null)
		{
			continue
		}
		else if (player.IsNoclipping())
		{
			player.SetPhysics(MOVETYPE_WALK)
		}
		else
		{
			player.SetPhysics(MOVETYPE_NOCLIP)
		}
	}
}
