/*===================================================================================================*\
||===================================================================================================||
||	              ________    ________    ___    _    ______     ______     ________                 ||
||	        \    |   _____|  |  ____  |  |   \  | |  |   _  \   |  _   \   |  ____  |    /           ||
||	======== \   |  |_____   | |____| |  | |\ \ | |  |  | |  |  | |_|  /   | |____| |   / ========   ||
||	          |  | _____  |  |  ____  |  | | \ \| |  |  | |  |  |  _  \    |  ____  |  |             ||
||	======== /    ______| |  | |    | |  | |  \ \ |  |  |_|  |  | |  \ \   | |    | |   \ ========   ||
||	        /    |________|  |_|    |_|  |_|   \__|  |______/   |_|   \_|  |_|    |_|    \           ||
||                                                                                                   ||
||                                                                                                   ||
||                                        Property-Filterscript                                      ||
||                                                                                                   ||
||===================================================================================================||
||                           Created on the 5st of June 2008 by =>Sandra<=                    	     ||
||                                    Do NOT remove any credits!!                                    ||
||					             Mejorado y traducido en el 19/03/2016                               ||
||												=>Razor<=			                  				 ||					
\*===================================================================================================

*/

#include <a_samp>
#include <dini>

#define MAX_PROPERTIES 100
#define MAX_PROPERTIES_PER_PLAYER 4

#define ENABLE_LOGIN_SYSTEM 1
#define ENABLE_MAP_ICON_STREAMER 1

#define REGISTER_COMMAND "/register"
#define LOGIN_COMMAND "/login"


main() { }


new PropertiesAmount;
new MP;
enum propinfo
{
	PropName[64],
	Float:PropX,
	Float:PropY,
	Float:PropZ,
	PropIsBought,
	PropOwner[MAX_PLAYER_NAME],
	PropValue,
	PropEarning,
	PickupNr,
}
new PropInfo[MAX_PROPERTIES][propinfo];
new PlayerProps[MAX_PLAYERS];
new EarningsForPlayer[MAX_PLAYERS];
new Logged[MAX_PLAYERS];

public OnFilterScriptInit()
{
    LoadProperties();
    MP = GetMaxPlayers();
	for(new i; i<MP; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new pName[MAX_PLAYER_NAME];
			GetPlayerName(i, pName, MAX_PLAYER_NAME);
			for(new propid; propid < PropertiesAmount; propid++)
			{
				if(PropInfo[propid][PropIsBought] == 1)
				{
				    if(strcmp(PropInfo[propid][PropOwner], pName, true)==0)
					{
					    EarningsForPlayer[i] += PropInfo[propid][PropEarning];
					    PlayerProps[i]++;
					}
				}
			}
		}
	}
	#if ENABLE_MAP_ICON_STREAMER == 1
	SetTimer("MapIconStreamer", 500, 1);
	#endif
	SetTimer("PropertyPayout", 60000, 1);
	print("-------------------------------------------------");
	print("Sistema de propiedades cargado.");
	print("-------------------------------------------------");
	return 1;
}

public OnFilterScriptExit()
{
    SaveProperties();
	print("Properties Saved!!");
	return 1;
}

public OnPlayerConnect(playerid)
{
    PlayerProps[playerid] = 0;
    Logged[playerid] = 0;
    EarningsForPlayer[playerid] = 0;
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	for(new propid; propid < PropertiesAmount; propid++)
	{
		if(PropInfo[propid][PropIsBought] == 1)
		{
		    if(strcmp(PropInfo[propid][PropOwner], pName, true)==0)
			{
			    EarningsForPlayer[playerid] += PropInfo[propid][PropEarning];
			    PlayerProps[playerid]++;
			}
		}
	}
	#if ENABLE_LOGIN_SYSTEM == 0
	if(PlayerProps[playerid] > 0)
	{
	    new str[128];
	    format(str, 128, "Tú tienes actualmente {0000FF}%d{FFFFFF} propiedades en tu nombre.", PlayerProps[playerid]);
	    SendClientMessage(playerid, 0x99FF66AA, str);
	}
	#endif
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[256], idx, tmp[256];
	cmd = strtok(cmdtext, idx);
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/ayuda casas", true)==0 || strcmp(cmd, "/acasas", true)==0)
	{
	
	    return 1;
	}
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/comprar casa", true)==0 || strcmp(cmd, "/comprar propiedad", true)==0)
	{
	 	new propid = IsPlayerNearProperty(playerid);
	 	new str[260];
		if(propid == -1)
		{
			SendClientMessage(playerid, 0xFF0000AA, "No estás cerca de ninguna casa a la venta.");
			return 1;
		}
		if(PlayerProps[playerid] == MAX_PROPERTIES_PER_PLAYER)
	    {
			format(str, 128, "Ya tienes {00FF00}%d{FFFFFF} casas, no puedes tener más.", PlayerProps[playerid]);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		if(PropInfo[propid][PropIsBought] == 1)
		{
			new ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
			if(ownerid == playerid)
			{
			    SendClientMessage(playerid, 0xFF0000AA, "Esta propiedad ya está comprada!");
			    return 1;
			}
 		}
		if(GetPlayerMoney(playerid) < PropInfo[propid][PropValue] + PropInfo[propid][PropValue]/3)
		{
		    format(str, 128, "Necesitas $%d para comprar esta propiedad.", PropInfo[propid][PropValue]);
		    SendClientMessage(playerid, 0xFF0000AA, str);
		    return 1;
		}
		new pName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pName, sizeof(pName));
		if(PropInfo[propid][PropIsBought] == 0)
		{
			new ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
		    format(str, 128, "Nombre de propietario: %s. El costo de mantención de la casa es de {00FF00}$%d{FFFFFF}.", pName,(PropInfo[propid][PropValue]/3));
			GivePlayerMoney(ownerid, (0-PropInfo[propid][PropValue]/3));
			SendClientMessage(ownerid, 0xFFFF00AA, str);
			PlayerProps[ownerid]--;
		}
		PropInfo[propid][PropOwner] = pName;
		PropInfo[propid][PropIsBought] = 1;
		format(str,128,"Se te quitó {00FF00}$%d{FFFFFF} por el valor de la casa más la primera mantención de {00FF00}$%d{FFFFFF}.",PropInfo[propid][PropValue],(PropInfo[propid][PropValue]/3));
		SendClientMessage(playerid,-1,str);
		format(str,128,"El costo total cobrado fue de {FF0000}$%d{FFFFFF}.",PropInfo[propid][PropValue]+(PropInfo[propid][PropValue]/3));
		SendClientMessage(playerid,-1,str);
		EarningsForPlayer[playerid] += PropInfo[propid][PropEarning];
        GivePlayerMoney(playerid, (0-PropInfo[propid][PropValue]));
        PlayerProps[playerid]++;
		return 1;
	}
    //================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/vender propiedad", true) == 0 || strcmp(cmd, "/vender casa", true) == 0)
	{
	    new str[128];
 		new propid = IsPlayerNearProperty(playerid);
		if(propid == -1)
		{
			SendClientMessage(playerid, 0xFF0000AA, "Tú no estás cerca de tu casa.");
			return 1;
		}
		if(PropInfo[propid][PropIsBought] == 1)
		{
			new ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
			if(ownerid != playerid)
			{
			    SendClientMessage(playerid, 0xFF0000AA, "Tú no eres el dueño de la propiedad!");
			    return 1;
			}
		}
		new pName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pName, sizeof(pName));
		format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, "En venta");
		PropInfo[propid][PropIsBought] = 0;
		GivePlayerMoney(playerid, (PropInfo[propid][PropValue]/2));
		format(str, 128, "Se te devolvió el 50% del valor: {00FF00}$%d", PropInfo[propid][PropValue]/2);
		GivePlayerMoney(playerid,(PropInfo[propid][PropValue]/2));
        SendClientMessage(playerid, 0xFFFF00AA, str);
        PlayerProps[playerid]--;
        EarningsForPlayer[playerid] -= PropInfo[propid][PropEarning];
		return 1;
	}
    //================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
    if(strcmp(cmd, "/myproperties", true) == 0 || strcmp(cmd, "/myprops", true) == 0)
	{
	    new str[128], ownerid;
	    #if ENABLE_LOGIN_SYSTEM == 1
		if(Logged[playerid] == 0)
		{
		    format(str, 128, "You have to login before you can buy or sell properties! Use: %s", LOGIN_COMMAND);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		#endif
	    if(PlayerProps[playerid] == 0)
	    {
	        SendClientMessage(playerid, 0xFF0000AA, "You don't own a property!");
	        return 1;
		}
		format(str, 128, "|============ Your %d Properties: =============|", PlayerProps[playerid]);
	    SendClientMessage(playerid, 0x99FF66AA, str);
		for(new propid; propid < PropertiesAmount; propid++)
		{
			if(PropInfo[propid][PropIsBought] == 1)
			{
                ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
				if(ownerid == playerid)
				{
 					format(str, 128, ">> \"%s\"   Value: $%d,-   Earnings: $%d,-", PropInfo[propid][PropName], PropInfo[propid][PropValue], PropInfo[propid][PropEarning]);
 					SendClientMessage(playerid, 0x99FF66AA, str);
				}
			}
		}
		SendClientMessage(playerid, 0x99FF66AA, "|============================================|");
		return 1;
	}
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	#if ENABLE_LOGIN_SYSTEM == 1
	if(strcmp(cmd, REGISTER_COMMAND, true) == 0)
	{
	    new str[128];
	    if(Logged[playerid] == 1) return SendClientMessage(playerid, 0xFF0000AA, "You're already logged in!");
	    tmp = strtok(cmdtext, idx);
	    if(!strlen(tmp))
		{
		    format(str, 128, "Use: %s 'Your Password'", REGISTER_COMMAND);
			SendClientMessage(playerid, 0xFF9966AA, str);
			return 1;
		}
	    if(strlen(tmp) < 5) return SendClientMessage(playerid, 0xFF9966AA, "Password too short! At least 5 characters.");
	    if(strlen(tmp) > 20) return SendClientMessage(playerid, 0xFF9966AA, "Password too long! Max 20 characters.");
	    new pName[MAX_PLAYER_NAME], pass;
	    GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
		pass = dini_Int("PropertySystem/PlayerAccounts.txt", pName);
		if(pass == 0)
		{
		    dini_IntSet("PropertySystem/PlayerAccounts.txt", pName, encodepass(tmp));
		    Logged[playerid] = 1;
			format(str, 128, "Your name is now registered in our property-database. Next time use \"%s %s\" to login", LOGIN_COMMAND, tmp);
			SendClientMessage(playerid, 0x99FF66AA, str);
		}
		else
		{
			format(str, 128, "This name is already registered! Use %s to login!", LOGIN_COMMAND);
            SendClientMessage(playerid, 0xFF9966AA, str);
	    }
	    return 1;
	}
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, LOGIN_COMMAND, true) == 0)
	{
	    new str[128];
	    if(Logged[playerid] == 1) return SendClientMessage(playerid, 0xFF0000AA, "You're already logged in!");
	    tmp = strtok(cmdtext, idx);
	    if(!strlen(tmp))
		{
		    format(str, 128, "Use: %s 'Your Password'", LOGIN_COMMAND);
			SendClientMessage(playerid, 0xFF9966AA, str);
			return 1;
		}
	    new pName[MAX_PLAYER_NAME], pass;
	    GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
		pass = dini_Int("PropertySystem/PlayerAccounts.txt", pName);
		if(pass == 0)
		{
		    format(str, 128, "This name is not registered yet! Use %s to register this name!", REGISTER_COMMAND);
            SendClientMessage(playerid, 0xFF9966AA, str);
		}
		else
		{
			if(pass == encodepass(tmp))
			{
			    Logged[playerid] = 1;
			    SendClientMessage(playerid, 0x99FF66AA, "You're now logged in! You can now buy and sell properties!");
			}
			else
			{
			    SendClientMessage(playerid, 0xFF0000AA, "Wrong Password");
			}
	    }
	    #if ENABLE_LOGIN_SYSTEM == 1
	    if(PlayerProps[playerid] > 0)
		{
		    format(str, 128, "You currently own %d properties. Type /myproperties for more info about them.", PlayerProps[playerid]);
		    SendClientMessage(playerid, 0x99FF66AA, str);
		}
		#endif
	    return 1;
	}
	#endif
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/sellallproperties", true)==0)
	{
	    if(IsPlayerAdmin(playerid))
	    {
	        for(new propid; propid<PropertiesAmount; propid++)
	        {
	            format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, "En venta");
	            PropInfo[propid][PropIsBought] = 0;
			}
			for(new i; i<MAX_PLAYERS; i++)
			{
			    if(IsPlayerConnected(i))
			    {
			        PlayerProps[i] = 0;
				}
			}
			new str[128], pName[24];
			GetPlayerName(playerid, pName, 24);
			format(str, 128, "Admin %s has reset all properties!", pName);
			SendClientMessageToAll(0xFFCC66AA, str);
		}
		return 1;
	}
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	return 0;
}


public OnPlayerPickUpPickup(playerid, pickupid)
{
	new propid = -1;
	for(new id; id<MAX_PROPERTIES; id++)
	{
		if(PropInfo[id][PickupNr] == pickupid)
		{
			propid = id;
            break;
		}
	}
	if(propid != -1)
	{
	    new str[128];
    	format(str, 128, "~y~\"%s\"~n~~r~Value: ~y~$%d~n~~r~Earning: ~y~$%d~n~~r~Owner: ~y~%s", PropInfo[propid][PropName], PropInfo[propid][PropValue], PropInfo[propid][PropEarning], PropInfo[propid][PropOwner]);
		GameTextForPlayer(playerid, str, 6000, 3);
	}
	return 1;
}

stock LoadProperties()
{
	if(fexist("PropertySystem/PropertyInfo.txt"))
	{
	    CountProperties();
		new Argument[9][70];
		new entry[256], BoughtProps;
		new File: propfile = fopen("PropertySystem/PropertyInfo.txt", io_read);
	    if (propfile)
		{
		    for(new id; id<PropertiesAmount; id++)
			{
			    new string[160];
				fread(propfile, entry);
				split(entry, Argument, ',');
				format(PropInfo[id][PropName], 64, "%s", Argument[0]);
				PropInfo[id][PropX] = floatstr(Argument[1]);
				PropInfo[id][PropY] = floatstr(Argument[2]);
				PropInfo[id][PropZ] = floatstr(Argument[3]);
				PropInfo[id][PropValue] = strval(Argument[4]);
				PropInfo[id][PropEarning] = strval(Argument[5]);
				format(PropInfo[id][PropOwner], MAX_PLAYER_NAME, "%s", Argument[6]);
				PropInfo[id][PropIsBought] = strval(Argument[7]);
				PropInfo[id][PickupNr] = CreatePickup(1273, 1, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ]);
   				if(PropInfo[id][PropIsBought] == 1)
				{
				format(string,sizeof(string),"Casa [{FF0000}COMPRADA{FFFFFF}]\nDueño: {00FF00}%s{FFFFFF}.\nValor: {00FF00}$%d",PropInfo[id][PropOwner],PropInfo[id][PropValue]);
				}
   				if(PropInfo[id][PropIsBought] == 0)
				{
				format(string,sizeof(string),"Casa [{00FF00}EN VENTA{FFFFFF}]\nDueño: {00FF00}N/A{FFFFFF}.\nValor: {00FF00}$%d{FFFFFF}\nGastos: {00FF00}$%d{FFFFFF}\nUsa {00FF00}/comprar casa{FFFFFF} para adquirirla.",PropInfo[id][PropOwner],PropInfo[id][PropValue],(PropInfo[id][PropValue]/3));
				}
				Create3DTextLabel(string,0xFFFFFFFF,PropInfo[id][PropX],PropInfo[id][PropY],PropInfo[id][PropZ],0,0);
				if(PropInfo[id][PropIsBought] == 1)
				{
				    BoughtProps++;
				}
			}
			fclose(propfile);
			printf("===================================");
			printf("||    Created %d Properties     ||", PropertiesAmount);
			printf("||%d of the properties are bought||", BoughtProps);
			printf("===================================");
		}
	}
}

public OnPlayerSpawn(playerid)
{
SetPlayerVirtualWorld(playerid,0);
SetPlayerPos(playerid,2024.56,1007.65,10.81);
return 1;
}

stock SaveProperties()
{
	new entry[256];
	new File: propfile = fopen("PropertySystem/PropertyInfo.txt", io_write);
	for(new id; id<PropertiesAmount; id++)
	{
	    format(entry, 128, "%s,%.2f,%.2f,%.2f,%d,%d,%s,%d\r\n",PropInfo[id][PropName], PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ], PropInfo[id][PropValue], PropInfo[id][PropEarning], PropInfo[id][PropOwner], PropInfo[id][PropIsBought]);
		fwrite(propfile, entry);
	}
	printf("Saved %d Properties!", PropertiesAmount);
	fclose(propfile);
}

forward split(const strsrc[], strdest[][], delimiter);
public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}

stock CountProperties()
{
    new entry[256];
	new File: propfile = fopen("PropertySystem/PropertyInfo.txt", io_read);
	while(fread(propfile, entry, 256))
	{
		PropertiesAmount++;
  	}
  	fclose(propfile);
}

forward IsPlayerNearProperty(playerid);
public IsPlayerNearProperty(playerid)
{
	new Float:Distance;
	for(new prop; prop<PropertiesAmount; prop++)
	{
	    Distance = GetDistanceToProperty(playerid, prop);
	    if(Distance < 1.0)
	    {
	        return prop;
		}
	}
	return -1;
}

forward Float:GetDistanceToProperty(playerid, Property);
public Float:GetDistanceToProperty(playerid, Property)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	GetPlayerPos(playerid,x1,y1,z1);
	x2 = PropInfo[Property][PropX];
	y2 = PropInfo[Property][PropY];
	z2 = PropInfo[Property][PropZ];
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

stock GetPlayerID(const Name[])
{
	for(new i; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new pName[MAX_PLAYER_NAME];
			GetPlayerName(i, pName, sizeof(pName));
	        if(strcmp(Name, pName, true)==0)
	        {
	            return i;
			}
		}
	}
	return -1;
}

stock SendClientMessageToAllEx(exeption, color, const message[])
{
	for(new i; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(i != exeption)
		    {
		        SendClientMessage(i, color, message);
			}
		}
	}
}

stock encodepass(buf[]) {
	new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

forward MapIconStreamer();
public MapIconStreamer()
{
	for(new i; i<MP; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new Float:SmallestDistance = 99999.9;
	        new CP, Float:OldDistance;
	        for(new propid; propid<PropertiesAmount; propid++)
	        {
	            OldDistance = GetDistanceToProperty(i, propid);
	            if(OldDistance < SmallestDistance)
	            {
	                SmallestDistance = OldDistance;
	                CP = propid;
				}
			}
			RemovePlayerMapIcon(i, 31);
			if(PropInfo[CP][PropIsBought] == 1)
			{
                SetPlayerMapIcon(i, 31, PropInfo[CP][PropX], PropInfo[CP][PropY], PropInfo[CP][PropZ], 32, 0);
			}
			else
			{
			    SetPlayerMapIcon(i, 31, PropInfo[CP][PropX], PropInfo[CP][PropY], PropInfo[CP][PropZ], 31, 0);
			}
		}
	}
}

forward PropertyPayout();
public PropertyPayout()
{
	new str[64];
	for(new i; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PlayerProps[i] > 0)
	        {
	            GivePlayerMoney(i, EarningsForPlayer[i]);
				format(str, 64, "Se te quitó {00FF00}$%d{FFFFFF} por los servicios de tu casa.", EarningsForPlayer[i]);
				SendClientMessage(i, 0xFFFF00AA, str);
			}
		}
	}
}


