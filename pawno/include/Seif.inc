/*
								seif_walk - Walking styles by Seif
*/
#if defined walk_inc
 #endscript
#endif
#define walk_inc

/*x---------------------------------Important-------------------------------------x*/
//**INCLUDES**//
#include <a_samp>
#tryinclude num_players
/*x---------------------------------Defining-------------------------------------x*/
//**DEFINES**//
#define WALK_DEFAULT    0
#define WALK_NORMAL     1
#define WALK_PED        2
#define WALK_GANGSTA    3
#define WALK_GANGSTA2   4
#define WALK_OLD        5
#define WALK_FAT_OLD    6
#define WALK_FAT        7
#define WALK_LADY      	8
#define WALK_LADY2      9
#define WALK_WHORE      10
#define WALK_WHORE2     11
#define WALK_SHOP     	12
#define WALK_BLIND     	13
#define WALK_DRUNK     	14
#define WALK_MAX		15

#define WALK_TIMEOUT 270
//**VARIABLES**//
static walktime[MAX_PLAYERS];
static WalkStyle[MAX_PLAYERS];
//**NATIVES**//
/*
	native SetPlayerWalkingStyle(playerid, style)
	native GetPlayerWalkingStyle(playerid)
*/
forward WalkAnim(playerid);

/*x---------------------------------CallBacks-------------------------------------x*/
walk_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (
			((newkeys & KEY_WALK && newkeys & KEY_UP) || (newkeys & KEY_WALK && newkeys & KEY_DOWN) || (newkeys & KEY_WALK && newkeys & KEY_LEFT) || (newkeys & KEY_WALK && newkeys & KEY_RIGHT))
		|| 	((oldkeys & KEY_WALK && newkeys & KEY_UP) || (oldkeys & KEY_WALK && newkeys & KEY_DOWN) || (oldkeys & KEY_WALK && newkeys & KEY_LEFT) || (oldkeys & KEY_WALK && newkeys & KEY_RIGHT))
		|| 	((newkeys & KEY_WALK && oldkeys & KEY_UP) || (newkeys & KEY_WALK && oldkeys & KEY_DOWN) || (newkeys & KEY_WALK && oldkeys & KEY_LEFT) || (newkeys & KEY_WALK && oldkeys & KEY_RIGHT)))
			walktime[playerid] = SetTimerEx("WalkAnim", WALK_TIMEOUT, false, "i", playerid);
	return 1;
}


static const animname[][] =
{
	"WALK_player",
	"WALK_civi",
	"WALK_gang1",
	"WALK_gang2",
	"WALK_old",
	"WALK_fatold",
	"WALK_fat",
	"WOMAN_walknorm",
	"WOMAN_walkbusy",
	"WOMAN_walkpro",
	"WOMAN_walksexy",
	"WOMAN_walkshop",
	"Walk_Woozie",
	"Walk_Drunk"
};

#define animlib "PED"


public WalkAnim(playerid)
{
	new keys, updown, leftright, style;
	GetPlayerKeys(playerid,keys,updown,leftright);
	style = GetPlayerWalkingStyle(playerid) - 1;
	if(style < 0 || style > WALK_MAX+1)
		return false;
	if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT))
	{
		KillTimer(walktime[playerid]);
		ApplyAnimation(playerid, animlib, animname[style], 4.07, 1, 1, 1, 1, 1);
		walktime[playerid] = SetTimerEx("WalkAnim", WALK_TIMEOUT, false, "i", playerid);
	}
	else ApplyAnimation(playerid, animlib, animname[style], 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
	return true;
}

stock SetPlayerWalkingStyle(playerid, style)
{
	WalkStyle[playerid] = style;
}

stock GetPlayerWalkingStyle(playerid)
{
	return WalkStyle[playerid];
}