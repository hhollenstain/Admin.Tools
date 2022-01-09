global function HealCommand

void function HealCommand()
{
    #if SERVER
    AddClientCommandCallback("heal", Command)
    #endif
}

bool function Command(entity player, array<string> args)
{
    if (PlayerIsAdmin(player))
    {
        thread Heal(GetSelectedPlayers(player, args))
    }

    return true
}

void function Heal(array<entity> players)
{
    foreach (entity player in players)
	{
        if (player == null || !IsAlive(player))
            continue

        if (player.IsTitan())
        {
            entity soul = player.GetTitanSoul()

            if (soul.IsDoomed())
                UndoomTitan(player, 1)

            soul.SetShieldHealth(soul.GetShieldHealthMax())
        }

        player.SetHealth(player.GetMaxHealth())
    }
}
