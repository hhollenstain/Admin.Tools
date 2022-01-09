global function FreezeCommand

void function FreezeCommand()
{
    #if SERVER
    AddClientCommandCallback("freeze", Command1)
    AddClientCommandCallback("unfreeze", Command2)
    #endif
}

bool function Command1(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
    {
        thread Freeze(GetSelectedPlayers(player, args))
    }

    return true
}

bool function Command2(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
    {
        thread UnFreeze(GetSelectedPlayers(player, args))
    }

    return true
}

void function Freeze(array<entity> players)
{
    foreach (entity player in players)
	{
		if (player == null)
			continue

        player.MovementDisable()
		player.ConsumeDoubleJump()
		player.DisableWeaponViewModel()
    }
}

void function UnFreeze(array<entity> players)
{
    foreach (entity player in players)
	{
		if (player == null)
			continue

        player.MovementEnable()
        player.EnableWeaponViewModel()
    }
}
