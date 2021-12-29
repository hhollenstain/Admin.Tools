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
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use freeze, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		thread Freeze([player])
		return true
	}

    switch (args[0].tolower())
	{
		case ("all"):
			thread Freeze(GetPlayerArray())
		break

		case ("us"):
			thread Freeze(GetTeamPlayers(player))
		break

		case ("them"):
			thread Freeze(GetEnemyPlayers(player))
		break

		default:
			thread Freeze(FindPlayersByName(args))
		break
	}

    return true
}

bool function Command2(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use unfreeze, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		thread UnFreeze([player])
		return true
	}

    switch (args[0].tolower())
	{
		case ("all"):
			thread UnFreeze(GetPlayerArray())
		break

		case ("us"):
			thread UnFreeze(GetTeamPlayers(player))
		break

		case ("them"):
			thread UnFreeze(GetEnemyPlayers(player))
		break

		default:
			thread UnFreeze(FindPlayersByName(args))
		break
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
