//VERSION 2.1

#define ACCURACY 500 //Lowering this it will make it more accurate, but it could use more CPU. (Do not lower it above 500 MS)

forward C_Paused(playerid);
forward OnPlayerPause(playerid);
forward OnPlayerUnPause(playerid);

new g_Paused[MAX_PLAYERS];
new bool:g_Requesting[MAX_PLAYERS];
new bool:g_IsPaused[MAX_PLAYERS];



public C_Paused(playerid)
{
    if(GetTickCount()-g_Paused[playerid] > ACCURACY && g_Requesting[playerid] != true && g_IsPaused[playerid] != true && InvalidStates(playerid) != 1)
	{
		OnPlayerPause(playerid);
		g_IsPaused[playerid] = true;
	}
	else if(GetTickCount()-g_Paused[playerid] < ACCURACY && g_Requesting[playerid] != true && g_IsPaused[playerid] != false && InvalidStates(playerid) != 1)
	{
	    OnPlayerUnPause(playerid);
	    g_IsPaused[playerid] = false;
	}
	return 1;
}

stock IsPlayerPaused(playerid)
{
	return g_IsPaused[playerid];
}

stock InvalidStates(playerid)
{
	new pState = GetPlayerState(playerid);
    if(pState == 0 || pState == 7)
    {
		return 1;
	}
	else
	{
		return 0;
	}
}
