global function RemoveWeaponCommand

void function RemoveWeaponCommand()
{
	#if SERVER
	AddClientCommandCallback("unarm", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (PlayerIsAdmin(player))
	{
		thread RemoveWeapon(GetSelectedPlayers(player, args))
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
