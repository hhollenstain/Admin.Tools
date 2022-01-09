global function GiveWeaponCommand

void function GiveWeaponCommand()
{
	#if SERVER
	AddClientCommandCallback("weapon", Command)
	#endif
}

bool function Command(entity player, array<string> args)
{
	if (!PlayerIsAdmin(player))
	{
	}
	else if (args.len() == 0)
	{
		print("Usage: weapon <weaponId>")
		print("Usage: weapon <weaponId> <all/us/them/player>")
	}
	else
	{
		array<entity> players = GetSelectedPlayers(player, args.slice(1))
		thread GiveWeaponToPlayers(players, args[0].tolower())
	}

	return true
}

void function GiveWeaponToPlayers(array<entity> players, string weaponId)
{
	bool isPilotTactical = pilot_tacticals.find(weaponId) > -1
	bool isPilotOrdnance = pilot_ordnances.find(weaponId) > -1
	bool isPilotMelee = pilot_melees.find(weaponId) > -1
	bool isTitanOffensive = titan_offensives.find(weaponId) > -1
	bool isTitanDefensive = titan_defensives.find(weaponId) > -1
	bool isTitanUtility = titan_utilities.find(weaponId) > -1
	bool isTitanCore = titan_cores.find(weaponId) > -1
	bool isTitanMelee = titan_melees.find(weaponId) > -1

	foreach (entity player in players)
	{
		if (player == null)
		{
			continue
		}
		else if (isPilotTactical || isTitanDefensive)
		{
			GiveSpecial(player, weaponId)
		}
		else if (isPilotOrdnance || isTitanOffensive)
		{
			GiveOrdnance(player, weaponId)
		}
		else if (isPilotMelee || isTitanMelee)
		{
			GiveMelee(player, weaponId)
		}
		else if (isTitanCore)
		{
			GiveTitanCore(player, weaponId)
		}
		else if (isTitanUtility)
		{
			GiveTitanUtility(player, weaponId)
		}
		else
		{
			GiveWeapon(player, weaponId)
		}
	}
}

void function GiveMelee(entity player, string weaponId)
{
	entity weapon = player.GetOffhandWeapon(OFFHAND_MELEE)

	if (weapon != null)
		player.TakeWeaponNow(weapon.GetWeaponClassName())

	player.GiveOffhandWeapon(weaponId, OFFHAND_MELEE)
}

void function GiveOrdnance(entity player, string weaponId)
{
	entity weapon = player.GetOffhandWeapon(OFFHAND_ORDNANCE)

	if (weapon != null)
	{
		if (weapon.GetWeaponClassName() != weaponId)
		{
			player.TakeWeaponNow(weapon.GetWeaponClassName())
			player.GiveOffhandWeapon(weaponId, OFFHAND_ORDNANCE)
		}
		else if (weapon.GetWeaponPrimaryClipCount() < weapon.GetWeaponPrimaryClipCountMax())
		{
			weapon.SetWeaponPrimaryClipCount(weapon.GetWeaponPrimaryClipCount() + 1)
		}
	}
}

void function GiveSpecial(entity player, string weaponId)
{
	entity weapon = player.GetOffhandWeapon(OFFHAND_SPECIAL)

	if (weapon != null)
		player.TakeWeaponNow(weapon.GetWeaponClassName())

	player.GiveOffhandWeapon(weaponId, OFFHAND_SPECIAL)
}

void function GiveTitanCore(entity player, string weaponId)
{
	entity titan = null

	if (player.IsTitan())
		titan = player
	else
		titan = player.GetPetTitan()

	if (titan == null)
		return

	entity weapon = titan.GetOffhandWeapon(OFFHAND_EQUIPMENT)

	if (weapon != null)
		titan.TakeWeaponNow(weapon.GetWeaponClassName())

	titan.GiveOffhandWeapon(weaponId, OFFHAND_EQUIPMENT)

	SoulTitanCore_SetNextAvailableTime(titan.GetTitanSoul(), 100.0)
}

void function GiveTitanUtility(entity player, string weaponId)
{
	if (!player.IsTitan())
	{
		GiveOrdnance(player, weaponId)
		return
	}

	entity weapon = player.GetOffhandWeapon(OFFHAND_TITAN_CENTER)

	if (weapon != null)
		player.TakeWeaponNow(weapon.GetWeaponClassName())

	player.GiveOffhandWeapon(weaponId, OFFHAND_TITAN_CENTER)
}

void function GiveWeapon(entity player, string weaponId)
{
	string weaponToSwitch = ""
	bool hasWeapon = false

	if (player.GetLatestPrimaryWeapon() != null)
	{
		weaponToSwitch = player.GetLatestPrimaryWeapon().GetWeaponClassName()

		if (player.GetActiveWeapon() != player.GetAntiTitanWeapon())
		{
			foreach (entity weapon in player.GetMainWeapons())
			{
				if (weapon == null)
					return

				string weaponClassName = weapon.GetWeaponClassName()
				if (weaponClassName == weaponId)
				{
					weaponToSwitch = weaponClassName
					hasWeapon = true
					break
				}
			}
		}
	}

	if (hasWeapon || weaponToSwitch != "")
		player.TakeWeaponNow(weaponToSwitch)

	try
	{
		player.GiveWeapon(weaponId)
		player.SetActiveWeaponByName(weaponId)
	}
	catch (e)
	{
		print("Weapon " + weaponId + " is not a valid weapon.")
	}
}
