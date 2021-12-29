global function ReloadWeaponCommand

void function ReloadWeaponCommand()
{
	#if SERVER
	AddClientCommandCallback("rearm", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use rearm, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		ReloadWeapon([player])
		return true
	}

	switch (args[0].tolower())
	{
		case ("all"):
			ReloadWeapon(GetPlayerArray())
		break

		case ("us"):
			ReloadWeapon(GetTeamPlayers(player))
		break

		case ("them"):
			ReloadWeapon(GetEnemyPlayers(player))
		break

		default:
			ReloadWeapon(FindPlayersByName(args))
		break
	}

	return true
}

void function ReloadWeapon(array<entity> players)
{
	foreach (entity player in players)
	{
		if (player == null)
			continue

		try
		{
			foreach (weapon in player.GetOffhandWeapons())
			{
				if (weapon == null)
					continue

				weapon.SetWeaponPrimaryClipCount(weapon.GetWeaponPrimaryClipCountMax())

				if (player.IsTitan())
				{
					player.Server_SetDodgePower(100.0)
					SoulTitanCore_SetNextAvailableTime(player.GetTitanSoul(), 100.0)
				}
			}
		}
		catch (e)
		{
			print("Failed to rearm player " + player.GetPlayerName() + ".")
		}
	}
}
