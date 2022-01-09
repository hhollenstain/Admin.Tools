global function JumpCommand

void function JumpCommand()
{
	#if SERVER
	AddClientCommandCallback("jump", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
	{
        array<entity> targets = GetSelectedPlayers(player, args)
		thread Jump(player, targets)
	}

	return true
}

void function Jump(entity player, array<entity> targets)
{
	if (player == null || !IsAlive(player))
		return

    foreach (entity target in targets)
    {
        if (target == null || !IsAlive(target))
		    continue

        target.SetOrigin(GetPlayerCrosshairOrigin(player))
    }
}
