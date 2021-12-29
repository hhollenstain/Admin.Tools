global function RemoveWeaponCommand

void function RemoveWeaponCommand()
{
	#if SERVER
	AddClientCommandCallback("unarm", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
		print("Player " + player.GetPlayerName() + " tried to use unarm, but they are not an admin.")
		return true
	}

	if (args.len() == 0)
	{
		RemoveWeapon([player])
		return true
	}

	switch (args[0].tolower())
	{
		case ("all"):
			RemoveWeapon(GetPlayerArray())
		break

		case ("us"):
			RemoveWeapon(GetTeamPlayers(player))
		break

		case ("them"):
			RemoveWeapon(GetEnemyPlayers(player))
		break

		default:
			RemoveWeapon(FindPlayersByName(args))
		break
	}

	return true
}

void function RemoveWeapon(array<entity> players)
{
	foreach (entity player in players)
	{
		if (player == null)
			continue

		foreach (entity weapon in player.GetMainWeapons())
		{
			if (weapon == null)
				continue

			string weaponId = weapon.GetWeaponClassName()

			if (weapon != player.GetOffhandWeapon(OFFHAND_MELEE))
			{
				try
				{
					player.TakeWeaponNow(weaponId)
				}
				catch (e)
				{
					print("Failed to unarm player " + player.GetPlayerName() + ".")
				}
			}
		}
	}
}
