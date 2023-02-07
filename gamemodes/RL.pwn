/*=======================================================================*\
||	    			  ______     _                     					||
||	   				 |  _   \   | |                                     ||
||		             | |_|  /   | |                                     ||
||     				 |  _  \    | |                                     ||
||	   				 | |  \ \   | |____                                 ||
||	  				 |_|   \_|  |______|                                ||
||                                                                      ||
||                GameMode Original desde 0. 					        ||
||                                                                      ||
||======================================================================||
||                Creado el 29/03/2016                   				||
||                Programación:                              			||
||				  - Carlosxp (Carlos Orellano)			    			||
||                -[S]peed._ (Brian Farias)                             ||
||======================================================================||
||                GM BASE UTILIZADA: Bare.pwn                           ||
||                Agradecimientos:                                      ||
||                - Jesús Tipiani (Hosting/VPS)					        ||
||                - Samir Leal. (Hosting/VPS)                           ||
||======================================================================||*/

//==-Include's-==//
#include <a_samp>
#include <dini>
#include <zcmd>
#include <sscanf2>
#include <foreach>
#include <Colores>
#include <dudb>
#include <streamer>
#include <mSelection>
#include <dns>


//==-pragma-==//
#pragma tabsize 0
#pragma dynamic 999999

//==-Stock-==//
stock Usuarios()
{
	new OnLine;
	for(new i, g = GetMaxPlayers(); i < g; i++)
		if(IsPlayerConnected(i))
			OnLine++;
	return OnLine;
}

//==-Define's-==//
#define MAX_PROPERTIES 100
#define DIRECCION           "Propiedades/%d.ini"
#define Autos               300
#define Autos1              301
#define Autos2              302
#define Autos3              303
#define Autos4              304
#define Autos5              305
#define Autos6              306
#define Autos7              307
#define LOGUEO              100
#define REGISTRO            101
#define ENABLE_MAP_ICON_STREAMER 1
#define websitecount 14
#define ADMIN_SPEC_TYPE_NONE 0
#define ADMIN_SPEC_TYPE_PLAYER 1
#define ADMIN_SPEC_TYPE_VEHICLE 2
#define SCM SendClientMessage
#define COLOR_ROJO 	0xFF0000FF
#define MAX_GANG 	400
#define CFG 	    "Clanes/CFG.ini"
#define GANG_FILE 	"Clanes/%d.ini"
#define GREY        0xAFAFAFAA
#define MAX_USERS 99
#define PLAYERS 200
#define UpdateConfig1     500
#define INVITAR 	343


#define				DIALOG_EVENTO				950
#define				DIALOG_ABRIREVENTO			951
#define				DIALOG_NOMEEVENTO			952
#define				DIALOG_PREMIO1				953
#define				DIALOG_PREMIO2				954
#define				DIALOG_PREMIO3				955
#define				DIALOG_PREMIO4				976
#define				DIALOG_PREMIO5				977
#define				DIALOG_CARRO				956
#define				DIALOG_COR1					957
#define				DIALOG_COR2					958
#define				DIALOG_ARMA  				959
#define				DIALOG_MUNICAO				960
#define				DIALOG_VIDAVEICULOS			961
#define				DIALOG_KICK					962
#define				DIALOG_FIM1					963
#define				DIALOG_FIM2					964
#define				DIALOG_FIM3					965
#define				DIALOG_VIDA					966
#define				DIALOG_COLETE				967
#define				DIALOG_SKIN1				968
#define				DIALOG_DEFINIR				975
#define				COR_EVENTO					0xFF8000AA
#define				COR_ERRO					0xff0000ff
#define				COR_INFO					0xFFFF00AA
#define DIALOG_ATTACH_INDEX             13500
#define DIALOG_ATTACH_INDEX_SELECTION   DIALOG_ATTACH_INDEX+1
#define DIALOG_ATTACH_EDITREPLACE       DIALOG_ATTACH_INDEX+2
#define DIALOG_ATTACH_MODEL_SELECTION   DIALOG_ATTACH_INDEX+3
#define DIALOG_ATTACH_BONE_SELECTION    DIALOG_ATTACH_INDEX+4
#define DIALOG_ATTACH_OBJECT_SELECTION  DIALOG_ATTACH_INDEX+5
#define DIALOG_ATTACH_OBJECT2_SELECTION DIALOG_ATTACH_INDEX+6
#define MAX_OSLOTS  MAX_PLAYER_ATTACHED_OBJECTS
#define         COL_WHITE       "{FFFFFF}"
#define         COL_BLACK       "{0E0101}"
#define         COL_GREY        "{C3C3C3}"
#define         COL_GREEN       "{6EF83C}"
#define         COL_RED         "{F81414}"
#define         COL_YELLOW      "{F3FF02}"
#define         COL_ORANGE      "{FFAF00}"
#define         COL_LIME        "{B7FF00}"
#define         COL_CYAN        "{00FFEE}"
#define         COL_BLUE        "{0049FF}"
#define         COL_MAGENTA     "{F300FF}"
#define         COL_VIOLET      "{B700FF}"
#define         COL_PINK        "{FF00EA}"
#define         COL_MARONE      "{A90202}"
#define MAX_ZONE 	400
#define ZONE_FILE	"Zonas/%d.ini"
#define DATABASENAME	"IpToCountry.db.db"
#define ConvertTime(%0,%1,%2,%3,%4) \
	new \
	    Float: %0 = floatdiv(%1, 60000) \
	;\
	%2 = floatround(%0, floatround_tozero); \
	%3 = floatround(floatmul(%0 - %2, 60), floatround_tozero); \
	%4 = floatround(floatmul(floatmul(%0 - %2, 60) - %3, 1000), floatround_tozero)
	


//ANTICHEATS
#define MAXIMAS_CONEXIONES_POR_IP 2
#define Misma_IP_Conectada 4
#define Limite_De_Tiempo 3500
new Misma_IP=0,
Limite=0,
Join_Stamp,
Banear_IP[25];

new CMuertes[MAX_PLAYERS], Amuertes[MAX_PLAYERS];
new TSPAWN[MAX_PLAYERS];
new AM[MAX_PLAYERS], AM2[MAX_PLAYERS];

//============================Clanes============================================
forward JoinGang(playerid, gangid);
forward GangRadar(playerid);
forward LeaveGang(playerid, gangid);
new GANG_NUMBER;
new PlayerGang[MAX_PLAYERS];
new PlayerLider[MAX_PLAYERS];
new gradar[MAX_PLAYERS];
new gradartimer[MAX_PLAYERS];
new invited[MAX_PLAYERS];

new RandomColors[400] = {
0x4F5152D4,0xFF0000AA,0x7E49D7AA,0x20B2AAAA,0xDC143CAA,0xFFFF00AA,0x0BE472AA,0x4F5152AA,0xFF1493AA,
0xFFD720AA,0x8b4513AA,0x008000AA,0x148b8bAA,0x14ff7fAA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,
0x534081AA,0x0495CDAA,0xEF6CE8AA,0xFFFF00AA,0x247C1BAA,0x0C8E5DAA,0x635B03AA,0xCB7ED3AA,0x65ADEBAA,
0x5C1ACCAA,0xF2F853AA,0x11F891AA,0x7B39AAAA,0x53EB10AA,0x54137DAA,0x275222AA,0xF09F5BAA,0x3D0A4FAA,
0x22F767AA,0xD63034AA,0x9A6980AA,0xDFB935AA,0x3793FAAA,0x90239DAA,0xE9AB2FAA,0xAF2FF3AA,0x057F94AA,
0xB98519AA,0x388EEAAA,0x028151AA,0xA55043AA,0x0DE018AA,0x93AB1CAA,0x95BAF0AA,0x369976AA,0xf0e68cAA,
0x4B8987AA,0x491B9EAA,0x829DC7AA,0xBCE635AA,0x247C1BAA,0x20D4ADAA,0x2D74FDAA,0x3C1C0DAA,0x12D6D4AA,
0x48C000AA,0x2A51E2AA,0xE3AC12AA,0xFC42A8AA,0x2FC827AA,0x1A30BFAA,0xB740C2AA,0x42ACF5AA,0x2FD9DEAA,
0xFAFB71AA,0x05D1CDAA,0xC471BDAA,0x94436EAA,0xC1F7ECAA,0xCE79EEAA,0xBD1EF2AA,0x93B7E4AA,0x3214AAAA,
0x184D3BAA,0xAE4B99AA,0x7E49D7AA,0x4C436EAA,0xFA24CCAA,0xCE76BEAA,0xA04E0AAA,0x9F945CAA,0xDCDE3DAA,
0x10C9C5AA,0x70524DAA,0x0BE472AA,0x8A2CD7AA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,0xD8C762AA,
0xD8C762AA,0xFF8C13AA,0xC715FFAA,0x20B2AAAA,0xDC143CAA,0x6495EDAA,0xf0e68cAA,0x778899AA,0xFF1493AA,
0xF4A460AA,0xEE82EEAA,0xFFD720AA,0x8b4513AA,0x4949A0AA,0x148b8bAA,0x14ff7FAA,0x556b2fAA,0x0FD9FAAA,
0x10DC29AA,0x534081AA,0x0495CDAA,0xEF6CE8AA,0xBD34AAAA,0x247C1BAA,0x0C8E5DAA,0x635B03AA,0xCB7ED3AA,
0x65ADEBAA,0x5C1ACCAA,0xF2F853AA,0x11F891AA,0x7B39AAAA,0x53EB10AA,0x54137DAA,0x275222AA,0xF09F5BAA,
0x3D0A4FAA,0x22F767AA,0xD63034AA,0x9A6980AA,0xDFB935AA,0x3793FAAA,0x90239DAA,0xE9AB2FAA,0xAF2FF3AA,
0x057F94AA,0xB98519AA,0x388EEAAA,0x028151AA,0xA55043AA,0x0DE018AA,0x93AB1CAA,0x95BAF0AA,0x369976AA,
0x18F71FAA,0x4B8987AA,0x491B9EAA,0x829DC7AA,0xBCE635AA,0xCEA6DFAA,0x20D4ADAA,0x2D74FDAA,0x3C1C0DAA,
0x12D6D4AA,0x48C000AA,0x2A51E2AA,0xE3AC12AA,0xFC42A8AA,0x2FC827AA,0x1A30BFAA,0xB740C2AA,0x42ACF5AA,
0x2FD9DEAA,0xFAFB71AA,0x05D1CDAA,0xC471BDAA,0x94436EAA,0xC1F7ECAA,0xCE79EEAA,0xBD1EF2AA,0x93B7E4AA,
0x3214AAAA,0x184D3BAA,0xAE4B99AA,0x7E49D7AA,0x4C436EAA,0xFA24CCAA,0xCE76BEAA,0xA04E0AAA,0x9F945CAA,
0xDCDE3DAA,0x10C9C5AA,0x70524DAA,0x0BE472AA,0x8A2CD7AA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,
0xD8C762AA,0xD8C762AA,0x4F5152D4,0xFF8C13AA,0xC715FFAA,0x20B2AAAA,0xDC143CAA,0x6495EDAA,0xf0e68cAA,
0xFFD720AA,0x8b4513AA,0x4949A0AA,0x148b8bAA,0x14ff7fAA,0x556b2fAA,0x0FD9FAAA,0x10DC29AA,0xF4A460AA,
0x534081AA,0x0495CDAA,0xEF6CE8AA,0xBD34AAAA,0x247C1BAA,0x0C8E5DAA,0x635B03AA,0xCB7ED3AA,0x65ADEBAA,
0x5C1ACCAA,0xF2F853AA,0x11F891AA,0x7B39AAAA,0x53EB10AA,0x54137DAA,0x275222AA,0xF09F5BAA,0x3D0A4FAA,
0x22F767AA,0xD63034AA,0x9A6980AA,0xDFB935AA,0x3793FAAA,0x90239DAA,0xE9AB2FAA,0xAF2FF3AA,0x057F94AA,
0xB98519AA,0x388EEAAA,0x028151AA,0xA55043AA,0x0DE018AA,0x93AB1CAA,0x95BAF0AA,0x369976AA,0x18F71FAA,
0x4B8987AA,0x491B9EAA,0x829DC7AA,0xBCE635AA,0xCEA6DFAA,0x20D4ADAA,0x2D74FDAA,0x3C1C0DAA,0x12D6D4AA,
0x48C000AA,0x2A51E2AA,0xE3AC12AA,0xFC42A8AA,0x2FC827AA,0x1A30BFAA,0xB740C2AA,0x42ACF5AA,0x2FD9DEAA,
0xFAFB71AA,0x05D1CDAA,0xC471BDAA,0x94436EAA,0xC1F7ECAA,0xCE79EEAA,0xBD1EF2AA,0x93B7E4AA,0x3214AAAA,
0x184D3BAA,0xAE4B99AA,0x7E49D7AA,0x4C436EAA,0xFA24CCAA,0xCE76BEAA,0xA04E0AAA,0x9F945CAA,0xDCDE3DAA,
0x10C9C5AA,0x70524DAA,0x0BE472AA,0x8A2CD7AA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,0xD8C762AA,
0xD8C762AA,0xFF8C13AA,0xC715FFAA,0x20B2AAAA,0xDC143CAA,0x6495EDAA,0xf0e68cAA,0x778899AA,0xFF1493AA,
0xF4A460AA,0xEE82EEAA,0xFFD720AA,0x8b4513AA,0x4949A0AA,0x148b8bAA,0x14ff7fAA,0x556b2fAA,0x0FD9FAAA,
0x10DC29AA,0x534081AA,0x0495CDAA,0xEF6CE8AA,0xBD34AAAA,0x247C1BAA,0x0C8E5DAA,0x635B03AA,0xCB7ED3AA,
0x65ADEBAA,0x5C1ACCAA,0xF2F853AA,0x11F891AA,0x7B39AAAA,0x53EB10AA,0x54137DAA,0x275222AA,0xF09F5BAA,
0x3D0A4FAA,0x22F767AA,0xD63034AA,0x9A6980AA,0xDFB935AA,0x3793FAAA,0x90239DAA,0xE9AB2FAA,0xAF2FF3AA,
0x057F94AA,0xB98519AA,0x388EEAAA,0x028151AA,0xA55043AA,0x0DE018AA,0x93AB1CAA,0x95BAF0AA,0x369976AA,
0x18F71FAA,0x4B8987AA,0x491B9EAA,0x829DC7AA,0xBCE635AA,0xCEA6DFAA,0x20D4ADAA,0x2D74FDAA,0x3C1C0DAA,
0x12D6D4AA,0x48C000AA,0x2A51E2AA,0xE3AC12AA,0xFC42A8AA,0x2FC827AA,0x1A30BFAA,0xB740C2AA,0x42ACF5AA,
0x2FD9DEAA,0xFAFB71AA,0x05D1CDAA,0xC471BDAA,0x94436EAA,0xC1F7ECAA,0xCE79EEAA,0xBD1EF2AA,0x93B7E4AA,
0x3214AAAA,0x184D3BAA,0xAE4B99AA,0x7E49D7AA,0x4C436EAA,0xFA24CCAA,0xCE76BEAA,0xA04E0AAA,0x9F945CAA,
0xDCDE3DAA,0x10C9C5AA,0x70524DAA,0x0BE472AA,0x8A2CD7AA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,
0xD8C762AA,0xD8C762AA
};
enum GANG_MAIN {
GANG_ID,
GANG_NAME[20],
GANG_COLOR,
GANG_NZONE,
GANG_MEMBERS,
GANG_SCORE
}

new GangInfo[MAX_GANG][GANG_MAIN];

main()
{
print(INFORMACION);
print(INFORMACION2);
print(INFORMACION3);
}

//============================Zonas=============================================
enum pZona
{
Znombre[8],
Float:ZPosX,
Float:ZPosY,
Float:Pos2X,
Float:Pos2Y,
Zconquistada,
Zcolor[20],
Zcreada
}
new ZonaInfo[MAX_ZONE][pZona];
new Zonas;



//==-Variables & enum's-==//

//==-Concursos-==//
#define MINIMUM_VALUE 2000000
#define MAXIMUM_VALUE 8000000
#define PREMIO_CONCURSO 10000
new RespuestaConcurso = -1;


//==-Propiedades-==//
new PropiedadesC;
new MP;
new Info[MAX_PLAYERS];
enum propinfo
{
	PropName[64],
	Float:PropX,
	Float:PropY,
	Float:PropZ,
	Float:PropEX,
	Float:PropEY,
	Float:PropEZ,
	PropM,
	PropI,
	PropID,
	PropO,
	Text3D:Texto,
	Text3D:PropS,
	PropIsBought,
	PropOwner[MAX_PLAYER_NAME],
	PropValue,
	PropEarning,
	PickupNr,
}
new PropInfo[MAX_PROPERTIES][propinfo];


//==- Textdraw's -==//
new Text:Textdraw[35];
new Text:TextdrawM[MAX_PLAYERS];
new Text:FPSP[MAX_PLAYERS];
new Text:Stats[MAX_PLAYERS];

forward ChangeWebsite();
forward Cambia(text[]);
new TextWebsiteCount = 0;
//==-Jugador-==//
enum pInfo
{
	Dinero,
	Nivel,
	pAdmin,
	Modo,
	pVip,
	God,
	SniperK,
	Dia,
	Mes,
	Advs,
	Kicks,
	Ano,
	Encarcelado,
	Ctiempo,
	Mtiempo,
	Muteado,
	Invisible,
	Aduty,
	Eslider,
	SpecID,
	SpecType,
	Bann,
	GodCar,
	Cargos,
	Puntos,
	Fbaneo[25],
	Razon[30],
	Ammopacks,
	SGRANADA,
	Asesinatos,
	Muertes,
	Registro[19],
	Correo[100],
};

new Usuario[MAX_PLAYERS][pInfo];
new PlayerProps[MAX_PLAYERS];
new EarningsForPlayer[MAX_PLAYERS];
new GananciaJugador[MAX_PLAYERS];
new Spawneo[MAX_PLAYERS];
new Spawnc[MAX_PLAYERS];
new ColUsado[MAX_PLAYERS];
new TiempoMute[MAX_PLAYERS];
new IntentoL[MAX_PLAYERS];
new ADpm[MAX_PLAYERS];
new DPM[MAX_PLAYERS];
new MPP[MAX_PLAYERS];
new SaltosBici[MAX_PLAYERS];
new Tcarcel[MAX_PLAYERS];
new Float:Pos[MAX_PLAYERS][4];
new Temporal[MAX_PLAYERS];
new ColorChat[MAX_PLAYERS];
new DLlast[MAX_PLAYERS] = 0;
new FPS2[MAX_PLAYERS] = 0;
new ObjetoBomba[MAX_PLAYERS];
new Plantada[MAX_PLAYERS];
new PlayerAnimLib[MAX_PLAYERS][32],PlayerAnimName[MAX_PLAYERS][32];
new SuperSprint[MAX_PLAYERS];
new UsarCMD[MAX_PLAYERS];
new Reparar[MAX_PLAYERS];
new TieneAuto[MAX_PLAYERS];
new UsoVida[MAX_PLAYERS];
new UsoChaleco[MAX_PLAYERS];
new UsoJ[MAX_PLAYERS];
new Creando[MAX_PLAYERS];
new SaltosAuto[MAX_PLAYERS];
new OBengala[MAX_PLAYERS];
new EstaEnFly[MAX_PLAYERS];
new f1[15],f2[15],f3[15],f4[15],f5[15],f6[15],f7[15],f8[15],f9[15],f10[15],f11[15];
new Racha[MAX_PLAYERS];
new bool:AceleracionBrutal[MAX_PLAYERS];
new Sayayin[MAX_PLAYERS];
new Zona[MAX_PLAYERS];
new Desmadre[MAX_PLAYERS];
new Minigun[MAX_PLAYERS];
new Guerra[MAX_PLAYERS];
new GodE[MAX_PLAYERS];
new Gay[MAX_PLAYERS];
new Lol[MAX_PLAYERS];
new Skin[MAX_PLAYERS];
new SaludoH[MAX_PLAYERS];
new Bloqueado[MAX_PLAYERS];
new Minijuego[MAX_PLAYERS];
new Reporto[MAX_PLAYERS];
new ReparoA[MAX_PLAYERS];
new Dominando[MAX_PLAYERS];
new Capturando;
new tiempo;
enum rankingEnum
{
player_Score,
player_ID
}

//==========Parkour
new PickupFinParkour;
new PickupFinParkourArma;
new PickupParkourDinero;
static Float:ParkourPos[][] = {
{-2998.3147, 1791.5773,  171.8524},//pos1
{-2998.8179,1787.2552,171.8710},//pos2
{-2999.5374,1780.5507,171.8859},//pos3
{-3003.4021,1780.9996,171.8886},//pos4
{-3003.8262,1786.1011,171.8448},//pos5
{-3003.4841,1791.6819,171.8474},//pos6
{-3006.4626,1792.0282,171.8492},//pos7
{-3007.2986,1786.3641,171.8445},//pos8
{-3007.0088,1780.3077,171.8715},//pos9
{-3009.7683,1780.3922,171.8699},//pos10
{-3010.4009,1784.4329,171.8073},//pos11
{-3009.4333,1792.7030,171.8570}//pos12

};

new GANAPARKOUR1,GANAPARKOUR2,GANAPARKOUR3;
new Objeto0;
new Objeto1;
new Objeto2;
new Objeto3;
new Objeto4;
new Objeto5;
new Objeto6;
new Objeto7;
new Objeto8;
new Objeto9;


//====================Variables de minijuegos.==================================
new endesmadre;

//==============================================================================
// Anti Chat Flood
//==============================================================================
#define RATE_INC (500)
#define RATE_MAX (2500)
#define THRESOLD_ACTION 1

enum LISTA_ANTIFLOOD
{
UltimoUpd,
VelocidadFlood
}
new AntiFlood_Data[MAX_PLAYERS][LISTA_ANTIFLOOD];
new AntiFlood[MAX_PLAYERS];

// Anti Flood Conecciones.
new Flood_time[MAX_PLAYERS];
//====================Sistema de objetos por Excel.=============================
new AttachmentObjectsList[] = {
18632,
18633,
19319,
19065,
19078,
1371,
18634,
18635,
18636,
18637,
18638,
18639,
18640,
18975,
19136,
19274,
18641,
18642,
18643,
18644,
18645,
18865,
18866,
18867,
18868,
18869,
18870,
18871,
18872,
18873,
18874,
18875,
18890,
18891,
18892,
18893,
18894,
18895,
18896,
18897,
18898,
18899,
18900,
18901,
18902,
18903,
18904,
18905,
18906,
18907,
18908,
18909,
18910,
18911,
18912,
18913,
18914,
18915,
18916,
18917,
18918,
18919,
18920,
18921,
18922,
18923,
18924,
18925,
18926,
18927,
18928,
18929,
18930,
18931,
18932,
18933,
18934,
18935,
18936,
18937,
18938,
18939,
18940,
18941,
18942,
18943,
18944,
18945,
18946,
18947,
18948,
18949,
18950,
18951,
18952,
18953,
18954,
18955,
18956,
18957,
18958,
18959,
18960,
18961,
18962,
18963,
18964,
18965,
18966,
18967,
18968,
18969,
18970,
18971,
18972,
18973,
18974,
18976,
18977,
18978,
18979,
19006,
19007,
19008,
19009,
19010,
19011,
19012,
19013,
19014,
19015,
19016,
19017,
19018,
19019,
19020,
19021,
19022,
19023,
19024,
19025,
19026,
19027,
19028,
19029,
19030,
19031,
19032,
19033,
19034,
19035,
19036,
19037,
19038,
19039,
19040,
19041,
19042,
19043,
19044,
19045,
19046,
19047,
19048,
19049,
19050,
19051,
19052,
19053,
19085,
19086,
19090,
19091,
19092,
19093,
19094,
19095,
19096,
19097,
19098,
19099,
19100,
19101,
19102,
19103,
19104,
19105,
19106,
19107,
19108,
19109,
19110,
19111,
19112,
19113,
19114,
19115,
19116,
19117,
19118,
19119,
19120,
19137,
19138,
19139,
19140,
19141,
19142,
19160,
19161,
19162,
19163,
19317,
19318,
19319,
19330,
19331,
19346,
19347,
19348,
19349,
19350,
19351,
19352,
19487,
19488,
19513,
19515,
331,
333,
334,
335,
336,
337,
338,
339,
341,
321,
322,
323,
324,
325,
326,
343,
346,
347,
348,
349,
350,
351,
352,
353,
355,
356,
372,
357,
358,
361,
363,
364,
365,
366,
367,
368,
369,
371
};
//==============================================================================
new AttachmentBones[][24] = {
{"Espalda"},
{"Cabeza"},
{"Superior brazo Izq"},
{"Superior brazo Der"},
{"Mano izquierda"},
{"Mano derecha"},
{"Músculo izquierdo"},
{"Músculo derecho"},
{"Pie izquierdo"},
{"Pie derecho"},
{"Pantorrilla derecha"},
{"Pantorrilla izquierda"},
{"Antebrazo izquierdo"},
{"Antebrazo derecho"},
{"Clavícula izquierda"},
{"Clavícula derecha"},
{"Cuello"},
{"Mandíbula"}
};
//==============================================================================
new CountAmountEvento, CountTimerEvento, NomePlayer[MAX_PLAYER_NAME],
NameA[64],Format[400],Float:PosX,Float:PosY,Float:PosZ,Float:PosA;

enum eventInfo
{
Float:Xq,
Float:Yq,
Float:Zq,
Float:Aq,
VirtualWorld,
Interior,
Nome[64],
Criado,
Aberto,
Cerrado,
Premio1,
Premio2,
Premio3,
PremioS,
PremioN,
Carro,
Cor1,
Cor2,
Arma,
Admin[64],
Vida,
};

enum eInfo
{
	NoEvento,
	Carro,
};

new EventInfo[eventInfo], PlayerInfoE[MAX_PLAYERS][eInfo];
static SEVENTO;

//========================Sistema de carreras por Carlosxp======================
enum Carrera
{
Float:SCX,
Float:SCY,
Float:SCZ,
Float:SCX2,
Float:SCY2,
Float:SCZ2,
Float:SCX3,
Float:SCY3,
Float:SCZ3,
Float:SCX4,
Float:SCY4,
Float:SCZ4,
Float:SCX5,
Float:SCY5,
Float:SCZ5,
Float:SCX6,
Float:SCY6,
Float:SCZ6,
Float:SCX7,
Float:SCY7,
Float:SCZ7,
Float:SCX8,
Float:SCY8,
Float:SCZ8,
Float:SCX9,
Float:SCY9,
Float:SCZ9,
Float:CP1X,
Float:CP1Y,
Float:CP1Z,
Float:CP2X,
Float:CP2Y,
Float:CP2Z,
Float:CP3X,
Float:CP3Y,
Float:CP3Z,
Float:CP4X,
Float:CP4Y,
Float:CP4Z,
Float:CP5X,
Float:CP5Y,
Float:CP5Z,
Float:CP6X,
Float:CP6Y,
Float:CP6Z,
Float:CP7X,
Float:CP7Y,
Float:CP7Z,
Float:CP8X,
Float:CP8Y,
Float:CP8Z,
Float:CP9X,
Float:CP9Y,
Float:CP9Z,
Float:CP10X,
Float:CP10Y,
Float:CP10Z,
Float:CP11X,
Float:CP11Y,
Float:CP11Z,
Float:CP12X,
Float:CP12Y,
Float:CP12Z,
Float:CP13X,
Float:CP13Y,
Float:CP13Z,
Float:CP14X,
Float:CP14Y,
Float:CP14Z,
Float:CP15X,
Float:CP15Y,
Float:CP15Z,
Float:CpFinX,
Float:CpFinY,
Float:CpFinZ,
CPS,
CA,
CN[25]
}
new cp;
new carrerae;
new carreraon;
new Llegadas;
new CarreraT;
new posiciones;
new CPP[MAX_PLAYERS];
new ECarrera[MAX_PLAYERS];
new CarreraI[Carrera];
//==============================================================================
forward ChauBengala(playerid);
forward ChauBengala2(playerid);
forward ChauBengala3(playerid);
static bool:OnFly[MAX_PLAYERS];
forward InitFly(playerid);
forward bool:StartFly(playerid);
forward Fly(playerid);
forward bool:StopFly(playerid);
forward static SetPlayerLookAt(playerid,Float:x,Float:y);
new sconteo;
new conteo1;

new Float:DESMADRER[4][3] = {
{1417.3047,-47.5880,1000.9293},
{1361.1254,-47.5822,1000.9243},
{1365.4998,5.8164,1000.9221},
{1400.1423,3.8439,1000.9064}
};

new Float:MINIGUN[6][6] = {
{-972.9474,1077.2074,1344.9978},
{-982.8345,1021.3507,1343.4478},
{-1048.2075,1089.7498,1343.4789},
{-1083.1667,1047.2495,1344.0304},
{-1118.1058,1098.6251,1341.8438},
{-1132.0602,1041.5765,1345.7402}
};


new VehicleNames[212][] = {
	"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
	"Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
	"Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
	"Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
	"Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
	"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
	"Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B",
	"Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
	"Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
	"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
	"Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
	"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
	"Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};

//==============================================================================
public OnGameModeInit()
{
    UsePlayerPedAnims();
	endesmadre = 0;
	sconteo = 0;
	tiempo = 0;
	carrerae = 0;
	conteo1 = 0;
    DisableInteriorEnterExits();
    SendRconCommand("language Español Latino");
	PropiedadesC = 1;
	cp = 0;
	posiciones = 0;
	carreraon = 0;
	Llegadas = 0;
    CargarPropiedades();
    MP = GetMaxPlayers();
    SetTimer("SubeNivel",600000,true);
    SetTimer("NuevoConcurso",180000, true);
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
    SetGameModeText("|RL|FR|V0.8|ESPAÑOL|");
	SetTimer("ChangeWebsite",1000,1);
	SetTimer("FPSUP",1000,true);
	SetTimer("CarreraSA",120000,true);
	AddPlayerClass(299,0.0,0.0,0.0,0.0,0,0,0,0,0,0);
	for(new i;i<310;i++)
	{
	AddPlayerClass(i,0.0,0.0,0.0,0.0,-1,-1,-1,-1,-1,-1);
	}
	new	randomip[16];
	for(new i = 0; i < 5; i++)
	{
	format(randomip, sizeof randomip, "%d.%d.%d.%d", random(255) + 1, random(255) + 1, random(255) + 1, random(255) + 1);
	new	starttime = GetTickCount();
	printf("[GEOLOCATION]|Pruebas|: IP: %s | PAÍS: %s", randomip, IpToCountry_db(randomip));
	printf("Tiempo: %dmss", GetTickCount() - starttime);
	}

    CargarZonas();
	#if ENABLE_MAP_ICON_STREAMER == 1
	MapIconStreamer();
	#endif
	SetTimer("CobraCosto", 1200000, 1);
	
	EventInfo[Xq] = 0;
	EventInfo[Yq] = 0;
	EventInfo[Zq] = 0;
	EventInfo[Aq] = 0;
	EventInfo[VirtualWorld] = 0;
	EventInfo[Interior] = 0;
	EventInfo[Criado] = 0;
	EventInfo[Cerrado] = 0;
	EventInfo[Aberto] = 0;
	EventInfo[Premio1] = 0;
	EventInfo[Premio2] = 0;
	EventInfo[Premio3] = 0;
	EventInfo[PremioS] = 0;
	EventInfo[PremioN] = 0;
	EventInfo[Carro] = 0;
	EventInfo[Cor1] = 0;
	EventInfo[Cor2] = 0;
	EventInfo[Arma] = 0;
	EventInfo[Vida] = 0;

	if(!dini_Exists(CFG))
	{
	dini_Create(CFG);
	dini_IntSet(CFG,"GANG_NUMBER",0);
	}

	GANG_NUMBER = dini_Int(CFG,"GANG_NUMBER");

	for(new i = 0; i <= GANG_NUMBER; i++)
	{
	new file[60];
	format(file, sizeof(file), GANG_FILE, i);
	if(dini_Exists(file))
	{
	GangInfo[i][GANG_ID] = i;
	strcat(GangInfo[i][GANG_NAME], dini_Get(file, "GANG_NAME"),strlen(dini_Get(file, "GANG_NAME"))+1);
	GangInfo[i][GANG_MEMBERS] = dini_Int(file, "GANG_MEMBERS");
	GangInfo[i][GANG_COLOR] = RandomColors[i];
 	}
	}
PickupFinParkourArma = CreatePickup(349,3,-3630.2751,2081.6226,246.4077,7);
PickupFinParkour = CreatePickup(1277, 3, -3789.75146, 2130.42578, 254.59184,7);
PickupParkourDinero = CreatePickup(1274,3,-3346.7124,1799.7798,195.4425,7);

SetTimer("MiniGm1",2500,1);
Objeto0 = CreateObject(19128, -3062.55103, 1792.47119, 176.24059,   0.00000, 0.00000, 351.44241);
Objeto1 = CreateObject(18765, -3232.74219, 1779.52771, 200.02237,   0.00000, 0.00000, 0.00000);
Objeto2 = CreateObject(18765, -3251.51953, 1779.73401, 200.02237,   0.00000, 0.00000, 0.00000);
Objeto3 = CreateObject(18765, -3265.85938, 1779.79602, 200.02237,   0.00000, 0.00000, 0.00000);



Objeto4 = CreateObject(19128, -3411.35791, 1921.13452, 202.97330,   0.00000, 0.00000, 355.95740);
Objeto5 = CreateObject(19128, -3415.75854, 1921.37939, 202.97330,   0.00000, 0.00000, 355.95740);
Objeto6 = CreateObject(19128, -3420.13965, 1921.67639, 202.97330,   0.00000, 0.00000, 355.95740);
Objeto7 = CreateObject(19128, -3424.56616, 1922.15442, 202.97330,   0.00000, 0.00000, 355.95740);
Objeto8 = CreateObject(19128, -3513.78052, 1975.95789, 245.28682,   0.00000, 0.00000, 309.68015);
Objeto9 = CreateObject(19128, -3522.62183, 1968.65247, 245.18481,   0.00000, 0.00000, 309.27408);

GANAPARKOUR1 = CreatePickup(19133,3, -462.43, 461.55, 127.52,7);
GANAPARKOUR2 = CreatePickup(19133,3, -460.05, 461.46, 129.21,7);
GANAPARKOUR3 = CreatePickup(19133,3, -457.38, 461.56, 127.25,7);

    Textdraw[0] = TextDrawCreate(40.000000, 297.000000, "Revolucion");
	TextDrawBackgroundColor(Textdraw[0], 255);
	TextDrawFont(Textdraw[0], 3);
	TextDrawLetterSize(Textdraw[0], 0.509998, 1.399999);
	TextDrawColor(Textdraw[0], -1);
	TextDrawSetOutline(Textdraw[0], 1);
	TextDrawSetProportional(Textdraw[0], 1);
	TextDrawSetSelectable(Textdraw[0], 0);

	Textdraw[1] = TextDrawCreate(58.000000, 315.000000, "Latina");
	TextDrawBackgroundColor(Textdraw[1], 255);
	TextDrawFont(Textdraw[1], 3);
	TextDrawLetterSize(Textdraw[1], 0.539997, 1.700000);
	TextDrawColor(Textdraw[1], -217634817);
	TextDrawSetOutline(Textdraw[1], 1);
	TextDrawSetProportional(Textdraw[1], 1);
	TextDrawSetSelectable(Textdraw[1], 0);

	Textdraw[2] = TextDrawCreate(39.000000, 315.000000, "~y~]");
	TextDrawBackgroundColor(Textdraw[2], 255);
	TextDrawFont(Textdraw[2], 2);
	TextDrawLetterSize(Textdraw[2], 0.489998, 1.699999);
	TextDrawColor(Textdraw[2], -1);
	TextDrawSetOutline(Textdraw[2], 1);
	TextDrawSetProportional(Textdraw[2], 1);
	TextDrawSetSelectable(Textdraw[2], 0);

	Textdraw[3] = TextDrawCreate(118.000000, 315.000000, "~y~]");
	TextDrawBackgroundColor(Textdraw[3], 255);
	TextDrawFont(Textdraw[3], 2);
	TextDrawLetterSize(Textdraw[3], 0.489998, 1.699999);
	TextDrawColor(Textdraw[3], -1);
	TextDrawSetOutline(Textdraw[3], 1);
	TextDrawSetProportional(Textdraw[3], 1);
	TextDrawSetSelectable(Textdraw[3], 0);
	
	
	Textdraw[4] = TextDrawCreate(270.000000, 159.000000, "~>~~r~Eliminado~<~");
	TextDrawBackgroundColor(Textdraw[4], 255);
	TextDrawFont(Textdraw[4], 0);
	TextDrawLetterSize(Textdraw[4], 0.779999, 2.100000);
	TextDrawColor(Textdraw[4], -1);
	TextDrawSetOutline(Textdraw[4], 1);
	TextDrawSetProportional(Textdraw[4], 1);
	TextDrawSetSelectable(Textdraw[4], 0);

    /*Textdraw[5] = TextDrawCreate(498.000000, 101.000000, "~>~~y~/~b~c~g~o~p~l~r~o~g~r~y~e~b~s~<~");
	TextDrawBackgroundColor(Textdraw[5], 255);
	TextDrawFont(Textdraw[5], 2);
	TextDrawLetterSize(Textdraw[5], 0.340000, 1.300000);
	TextDrawColor(Textdraw[5], -1);
	TextDrawSetOutline(Textdraw[5], 0);
	TextDrawSetProportional(Textdraw[5], 1);
	TextDrawSetShadow(Textdraw[5], 1);
	TextDrawSetSelectable(Textdraw[5], 0);*/


	Textdraw[6] = TextDrawCreate(0.000000, 2.000000, "_");
	TextDrawBackgroundColor(Textdraw[6], 255);
	TextDrawFont(Textdraw[6], 1);
	TextDrawLetterSize(Textdraw[6], 0.500000, 15.499998);
	TextDrawColor(Textdraw[6], -1);
	TextDrawSetOutline(Textdraw[6], 0);
	TextDrawSetProportional(Textdraw[6], 1);
	TextDrawSetShadow(Textdraw[6], 1);
	TextDrawUseBox(Textdraw[6], 1);
	TextDrawBoxColor(Textdraw[6], -1694498761);
	TextDrawTextSize(Textdraw[6], 638.000000, 0.000000);
	TextDrawSetSelectable(Textdraw[6], 0);

	Textdraw[7] = TextDrawCreate(0.000000, 306.000000, "_");
	TextDrawBackgroundColor(Textdraw[7], 255);
	TextDrawFont(Textdraw[7], 1);
	TextDrawLetterSize(Textdraw[7], 0.500000, 15.499998);
	TextDrawColor(Textdraw[7], -1);
	TextDrawSetOutline(Textdraw[7], 0);
	TextDrawSetProportional(Textdraw[7], 1);
	TextDrawSetShadow(Textdraw[7], 1);
	TextDrawUseBox(Textdraw[7], 1);
	TextDrawBoxColor(Textdraw[7], 39735);
	TextDrawTextSize(Textdraw[7], 638.000000, 0.000000);
	TextDrawSetSelectable(Textdraw[7], 0);

	Textdraw[8] = TextDrawCreate(211.000000, 112.000000, "~>~~r~Revolucion ~b~Latina~<~");
	TextDrawBackgroundColor(Textdraw[8], 255);
	TextDrawFont(Textdraw[8], 0);
	TextDrawLetterSize(Textdraw[8], 0.880000, 2.899999);
	TextDrawColor(Textdraw[8], -1);
	TextDrawSetOutline(Textdraw[8], 1);
	TextDrawSetProportional(Textdraw[8], 1);
	TextDrawSetSelectable(Textdraw[8], 0);
	
	
	Textdraw[9] = TextDrawCreate(0.000000, 428.000000, "_");
	TextDrawBackgroundColor(Textdraw[9], 255);
	TextDrawFont(Textdraw[9], 1);
	TextDrawLetterSize(Textdraw[9], 0.500000, 1.099999);
	TextDrawColor(Textdraw[9], -1);
	TextDrawSetOutline(Textdraw[9], 0);
	TextDrawSetProportional(Textdraw[9], 1);
	TextDrawSetShadow(Textdraw[9], 1);
	TextDrawUseBox(Textdraw[9], 1);
	TextDrawBoxColor(Textdraw[9], 11555);
	TextDrawTextSize(Textdraw[9], 641.000000, 0.000000);
	TextDrawSetSelectable(Textdraw[9], 0);

    Textdraw[10] = TextDrawCreate(28.000000, 424.000000, "ld_chat:badchat");
	TextDrawBackgroundColor(Textdraw[10], 255);
	TextDrawFont(Textdraw[10], 4);
	TextDrawLetterSize(Textdraw[10], 0.500000, 0.200000);
	TextDrawColor(Textdraw[10], -1);
	TextDrawSetOutline(Textdraw[10], 0);
	TextDrawSetProportional(Textdraw[10], 1);
	TextDrawSetShadow(Textdraw[10], 1);
	TextDrawUseBox(Textdraw[10], 1);
	TextDrawBoxColor(Textdraw[10], 255);
	TextDrawSetSelectable(Textdraw[10], 0);
	TextDrawTextSize(Textdraw[10], -25.000000, 15.500000);
	
	
	Textdraw[12] = TextDrawCreate(1063.250000, -20.900026, "usebox");
	TextDrawLetterSize(Textdraw[12], 3.596874, 72.002151);
	TextDrawTextSize(Textdraw[12], -33.250000, 0.000000);
	TextDrawAlignment(Textdraw[12], 1);
	TextDrawColor(Textdraw[12], 0);
	TextDrawUseBox(Textdraw[12], true);
	TextDrawBoxColor(Textdraw[12], -138);
	TextDrawSetShadow(Textdraw[12], 0);
	TextDrawSetOutline(Textdraw[12], 0);
	TextDrawFont(Textdraw[12], 0);

	Textdraw[13] = TextDrawCreate(217.000000, 165.020004, "usebox");
	TextDrawLetterSize(Textdraw[13], 0.000000, 14.450739);
	TextDrawTextSize(Textdraw[13], 16.125000, 0.000000);
	TextDrawAlignment(Textdraw[13], 1);
	TextDrawColor(Textdraw[13], 0);
	TextDrawUseBox(Textdraw[13], true);
	TextDrawBoxColor(Textdraw[13], 6618998);
	TextDrawSetShadow(Textdraw[13], 0);
	TextDrawSetOutline(Textdraw[13], 0);
	TextDrawFont(Textdraw[13], 0);

	Textdraw[14] = TextDrawCreate(424.250000, 166.020004, "usebox");
	TextDrawLetterSize(Textdraw[14], 0.000000, 14.450739);
	TextDrawTextSize(Textdraw[14], 222.375000, 0.000000);
	TextDrawAlignment(Textdraw[14], 1);
	TextDrawColor(Textdraw[14], 0);
	TextDrawUseBox(Textdraw[14], true);
	TextDrawBoxColor(Textdraw[14], 6618998);
	TextDrawSetShadow(Textdraw[14], 0);
	TextDrawSetOutline(Textdraw[14], 0);
	TextDrawFont(Textdraw[14], 0);

	Textdraw[15] = TextDrawCreate(631.500000, 167.019973, "usebox");
	TextDrawLetterSize(Textdraw[15], 0.000000, 14.450739);
	TextDrawTextSize(Textdraw[15], 428.625000, 0.000000);
	TextDrawAlignment(Textdraw[15], 1);
	TextDrawColor(Textdraw[15], 0);
	TextDrawUseBox(Textdraw[15], true);
	TextDrawBoxColor(Textdraw[15], 6618998);
	TextDrawSetShadow(Textdraw[15], 0);
	TextDrawSetOutline(Textdraw[15], 0);
	TextDrawFont(Textdraw[15], 0);

	Textdraw[16] = TextDrawCreate(286.125000, 172.493270, "DeathMatch");
	TextDrawLetterSize(Textdraw[16], 0.362500, 1.637333);
	TextDrawAlignment(Textdraw[16], 1);
	TextDrawColor(Textdraw[16], -1);
	TextDrawSetShadow(Textdraw[16], 0);
	TextDrawSetOutline(Textdraw[16], 1);
	TextDrawBackgroundColor(Textdraw[16], 51);
	TextDrawFont(Textdraw[16], 3);
	TextDrawSetProportional(Textdraw[16], 1);

	Textdraw[17] = TextDrawCreate(80.875000, 169.759933, "Freeroam");
	TextDrawLetterSize(Textdraw[17], 0.362500, 1.637333);
	TextDrawAlignment(Textdraw[17], 1);
	TextDrawColor(Textdraw[17], -1);
	TextDrawSetShadow(Textdraw[17], 0);
	TextDrawSetOutline(Textdraw[17], 1);
	TextDrawBackgroundColor(Textdraw[17], 51);
	TextDrawFont(Textdraw[17], 3);
	TextDrawSetProportional(Textdraw[17], 1);

	Textdraw[18] = TextDrawCreate(500.750000, 171.493255, "Carreras");
	TextDrawLetterSize(Textdraw[18], 0.362500, 1.637333);
	TextDrawAlignment(Textdraw[18], 1);
	TextDrawColor(Textdraw[18], -1);
	TextDrawSetShadow(Textdraw[18], 0);
	TextDrawSetOutline(Textdraw[18], 1);
	TextDrawBackgroundColor(Textdraw[18], 51);
	TextDrawFont(Textdraw[18], 3);
	TextDrawSetProportional(Textdraw[18], 1);

	Textdraw[19] = TextDrawCreate(25.000000, 191.893264, "Modo de juego en el cual los usuarios~n~pueden hacer lo que quieran dentro..");
	TextDrawLetterSize(Textdraw[19], 0.198124, 1.278933);
	TextDrawAlignment(Textdraw[19], 1);
	TextDrawColor(Textdraw[19], -1);
	TextDrawSetShadow(Textdraw[19], 0);
	TextDrawSetOutline(Textdraw[19], 1);
	TextDrawBackgroundColor(Textdraw[19], 51);
	TextDrawFont(Textdraw[19], 2);
	TextDrawSetProportional(Textdraw[19], 1);

	Textdraw[20] = TextDrawCreate(229.125000, 193.639953, "Modo de juego en el cual los usuarios~n~pueden hacer matarse entre si o equipos..");
	TextDrawLetterSize(Textdraw[20], 0.191873, 1.219198);
	TextDrawAlignment(Textdraw[20], 1);
	TextDrawColor(Textdraw[20], -1);
	TextDrawSetShadow(Textdraw[20], 0);
	TextDrawSetOutline(Textdraw[20], 1);
	TextDrawBackgroundColor(Textdraw[20], 51);
	TextDrawFont(Textdraw[20], 2);
	TextDrawSetProportional(Textdraw[20], 1);

	Textdraw[21] = TextDrawCreate(436.375000, 193.893264, "Modo de juego en el cual los usuarios~n~tienen que tratar de conseguir el primer~n~puesto para ganar la carrera..");
	TextDrawLetterSize(Textdraw[21], 0.198124, 1.278933);
	TextDrawAlignment(Textdraw[21], 1);
	TextDrawColor(Textdraw[21], -1);
	TextDrawSetShadow(Textdraw[21], 0);
	TextDrawSetOutline(Textdraw[21], 1);
	TextDrawBackgroundColor(Textdraw[21], 51);
	TextDrawFont(Textdraw[21], 2);
	TextDrawSetProportional(Textdraw[21], 1);

	Textdraw[22] = TextDrawCreate(217.500000, 132.906661, "SELECCIONA TU MODO DE JUEGO:");
	TextDrawLetterSize(Textdraw[22], 0.318749, 2.234666);
	TextDrawAlignment(Textdraw[22], 1);
	TextDrawColor(Textdraw[22], -1);
	TextDrawSetShadow(Textdraw[22], 0);
	TextDrawSetOutline(Textdraw[22], 1);
	TextDrawBackgroundColor(Textdraw[22], 51);
	TextDrawFont(Textdraw[22], 2);
	TextDrawSetProportional(Textdraw[22], 1);

	Textdraw[23] = TextDrawCreate(263.750000, 77.653350, "]Revolucion]");
	TextDrawLetterSize(Textdraw[23], 0.625000, 2.831998);
	TextDrawAlignment(Textdraw[23], 1);
	TextDrawColor(Textdraw[23], -1);
	TextDrawSetShadow(Textdraw[23], 0);
	TextDrawSetOutline(Textdraw[23], 1);
	TextDrawBackgroundColor(Textdraw[23], 51);
	TextDrawFont(Textdraw[23], 0);
	TextDrawSetProportional(Textdraw[23], 1);

	Textdraw[24] = TextDrawCreate(505.625000, 245.653350, "hud:radar_flag");
	TextDrawLetterSize(Textdraw[24], 0.000000, 0.000000);
	TextDrawTextSize(Textdraw[24], 38.750000, 38.080001);
	TextDrawAlignment(Textdraw[24], 1);
	TextDrawColor(Textdraw[24], -1);
	TextDrawSetShadow(Textdraw[24], 0);
	TextDrawSetOutline(Textdraw[24], 0);
	TextDrawFont(Textdraw[24], 4);
	TextDrawSetSelectable(Textdraw[24],1);

	Textdraw[25] = TextDrawCreate(87.250000, 245.906692, "hud:radar_gangb");
	TextDrawLetterSize(Textdraw[25], 0.000000, 0.000000);
	TextDrawTextSize(Textdraw[25], 38.750000, 38.080001);
	TextDrawAlignment(Textdraw[25], 1);
	TextDrawColor(Textdraw[25], -1);
	TextDrawSetShadow(Textdraw[25], 0);
	TextDrawSetOutline(Textdraw[25], 0);
	TextDrawFont(Textdraw[25], 4);
	TextDrawSetSelectable(Textdraw[25],1);

	Textdraw[26] = TextDrawCreate(297.000000, 243.920074, "hud:radar_emmetgun");
	TextDrawLetterSize(Textdraw[26], -0.013748, -0.231465);
	TextDrawTextSize(Textdraw[26], 38.750000, 38.080001);
	TextDrawAlignment(Textdraw[26], 1);
	TextDrawColor(Textdraw[26], -1);
	TextDrawSetShadow(Textdraw[26], 0);
	TextDrawSetOutline(Textdraw[26], 0);
	TextDrawFont(Textdraw[26], 4);
	TextDrawSetSelectable(Textdraw[26],1);

	Textdraw[27] = TextDrawCreate(299.125000, 101.800018, "Latina");
	TextDrawLetterSize(Textdraw[27], 0.520623, 1.846400);
	TextDrawAlignment(Textdraw[27], 1);
	TextDrawColor(Textdraw[27], -16777026);
	TextDrawSetShadow(Textdraw[27], 0);
	TextDrawSetOutline(Textdraw[27], 1);
	TextDrawBackgroundColor(Textdraw[27], 51);
	TextDrawFont(Textdraw[27], 3);
	TextDrawSetProportional(Textdraw[27], 1);

	Textdraw[28] = TextDrawCreate(217.000000, 308.380004, "usebox");
	TextDrawLetterSize(Textdraw[28], 0.000000, 2.587035);
	TextDrawTextSize(Textdraw[28], 16.125000, 0.000000);
	TextDrawAlignment(Textdraw[28], 1);
	TextDrawColor(Textdraw[28], 0);
	TextDrawUseBox(Textdraw[28], true);
	TextDrawBoxColor(Textdraw[28], 102);
	TextDrawSetShadow(Textdraw[28], 0);
	TextDrawSetOutline(Textdraw[28], 0);
	TextDrawFont(Textdraw[28], 0);

	Textdraw[29] = TextDrawCreate(424.250000, 309.380004, "usebox");
	TextDrawLetterSize(Textdraw[29], 0.000000, 2.587035);
	TextDrawTextSize(Textdraw[29], 222.375000, 0.000000);
	TextDrawAlignment(Textdraw[29], 1);
	TextDrawColor(Textdraw[29], 0);
	TextDrawUseBox(Textdraw[29], true);
	TextDrawBoxColor(Textdraw[29], 102);
	TextDrawSetShadow(Textdraw[29], 0);
	TextDrawSetOutline(Textdraw[29], 0);
	TextDrawFont(Textdraw[29], 0);

	Textdraw[30] = TextDrawCreate(631.500000, 310.380004, "usebox");
	TextDrawLetterSize(Textdraw[30], 0.000000, 2.587035);
	TextDrawTextSize(Textdraw[30], 428.625000, 0.000000);
	TextDrawAlignment(Textdraw[30], 1);
	TextDrawColor(Textdraw[30], 0);
	TextDrawUseBox(Textdraw[30], true);
	TextDrawBoxColor(Textdraw[30], 102);
	TextDrawSetShadow(Textdraw[30], 0);
	TextDrawSetOutline(Textdraw[30], 0);
	TextDrawFont(Textdraw[30], 0);

	Textdraw[31] = TextDrawCreate(63.750000, 311.359985, "Jugadores: X");
	TextDrawLetterSize(Textdraw[31], 0.315623, 1.600000);
	TextDrawAlignment(Textdraw[31], 1);
	TextDrawColor(Textdraw[31], -1);
	TextDrawSetShadow(Textdraw[31], 0);
	TextDrawSetOutline(Textdraw[31], 1);
	TextDrawBackgroundColor(Textdraw[31], 51);
	TextDrawFont(Textdraw[31], 3);
	TextDrawSetProportional(Textdraw[31], 1);

	Textdraw[32] = TextDrawCreate(264.750000, 312.360015, "Jugadores: X");
	TextDrawLetterSize(Textdraw[32], 0.315623, 1.600000);
	TextDrawAlignment(Textdraw[32], 1);
	TextDrawColor(Textdraw[32], -1);
	TextDrawSetShadow(Textdraw[32], 0);
	TextDrawSetOutline(Textdraw[32], 1);
	TextDrawBackgroundColor(Textdraw[32], 51);
	TextDrawFont(Textdraw[32], 3);
	TextDrawSetProportional(Textdraw[32], 1);

	Textdraw[33] = TextDrawCreate(472.000000, 313.359893, "Jugadores: X");
	TextDrawLetterSize(Textdraw[33], 0.315623, 1.600000);
	TextDrawAlignment(Textdraw[33], 1);
	TextDrawColor(Textdraw[33], -1);
	TextDrawSetShadow(Textdraw[33], 0);
	TextDrawSetOutline(Textdraw[33], 1);
	TextDrawBackgroundColor(Textdraw[33], 51);
	TextDrawFont(Textdraw[33], 3);
	TextDrawSetProportional(Textdraw[33], 1);


	for(new i;i<MAX_PLAYERS;i++)
	{
	FPSP[i] = TextDrawCreate(535.000000, 426.000000, "~r~FPS~w~: Cargando - ~b~Ping~w~: Cargando");
	TextDrawBackgroundColor(FPSP[i], 255);
	TextDrawFont(FPSP[i], 3);
	TextDrawLetterSize(FPSP[i], 0.250000, 1.299999);
	TextDrawColor(FPSP[i], -1);
	TextDrawSetOutline(FPSP[i], 1);
	TextDrawSetProportional(FPSP[i], 1);
	TextDrawSetSelectable(FPSP[i], 0);
	
	TextdrawM[i] = TextDrawCreate(270.000000, 179.000000, "Por: ~g~Carlosxp");
	TextDrawBackgroundColor(TextdrawM[i], 255);
	TextDrawFont(TextdrawM[i], 0);
	TextDrawLetterSize(TextdrawM[i], 0.259999, 1.300000);
	TextDrawColor(TextdrawM[i], -1);
	TextDrawSetOutline(TextdrawM[i], 1);
	TextDrawSetProportional(TextdrawM[i], 1);
	TextDrawSetSelectable(TextdrawM[i], 0);
	
	Stats[i] = TextDrawCreate(27.000000, 427.000000, "~>~~b~Stats~w~~<~ ~r~Score~w~: Cargando ~y~Dinero~w~: $Cargando ~g~Clan~w~: Ninguno ~p~Nivel~w~: Cargando ~b~VIP~w~: Cargando ~r~Modo~w~: N/A");
	TextDrawBackgroundColor(Stats[i], 255);
	TextDrawFont(Stats[i], 3);
	TextDrawLetterSize(Stats[i], 0.290000, 1.199999);
	TextDrawColor(Stats[i], -1);
	TextDrawSetOutline(Stats[i], 1);
	TextDrawSetProportional(Stats[i], 1);
	TextDrawSetSelectable(Stats[i], 0);
	}
 	// SPAWNs
    Create3DTextLabel("Spawn de {00FF00}Los Santos{FFFFFF}.\n\nRecuerda que no está permitido matar acá. {FF0000}(SK)",0xFFFFFFFF,2507.9573,-1924.9025,13.5469,15.0,0,0);
    Create3DTextLabel("Spawn de {00FF00}Los Santos{FFFFFF}.\n\nRecuerda que no está permitido matar acá. {FF0000}(SK)",0xFFFFFFFF,2291.7930,-1083.0052,47.6686,15.0,0,0);
    Create3DTextLabel("Spawn de {00FF00}Las Venturas{FFFFFF}.\n\nRecuerda que no está permitido matar acá. {FF0000}(SK)",0xFFFFFFFF,2295.9983,626.5709,10.8203,15.0,0,0);
    Create3DTextLabel("Spawn de {00FF00}Las Venturas{FFFFFF}.\n\nRecuerda que no está permitido matar acá. {FF0000}(SK)",0xFFFFFFFF,2917.5547,2455.0981,11.0703,15.0,0,0);
    Create3DTextLabel("Spawn de {00FF00}San Fierro{FFFFFF}.\n\nRecuerda que no está permitido matar acá. {FF0000}(SK)",0xFFFFFFFF,-2077.0234,1430.8273,7.1016,15.0,0,0);
    Create3DTextLabel("Spawn de {00FF00}San Fierro{FFFFFF}.\n\nRecuerda que no está permitido matar acá. {FF0000}(SK)",0xFFFFFFFF,-2903.3372,-171.4756,3.5388,15.0,0,0);
    //
	CreateDynamicObject(14593, 2172.8, -945.70001, 911.20001, 0, 0, 270);
	CreateDynamicObject(14534, 2156.4004, -946.5, 913.5, 0, 0, 270.247);
	CreateDynamicObject(2007, 2166.19995, -951.59998, 908.79999, 0, 0, 0);
	CreateDynamicObject(2007, 2166.2, -951.59998, 910.20001, 0, 0, 0);
	CreateDynamicObject(2007, 2167.19995, -951.59998, 910.20001, 0, 0, 0);
	CreateDynamicObject(2007, 2167.2, -951.59998, 908.79999, 0, 0, 0);
	CreateDynamicObject(2007, 2168.2002, -951.59961, 908.79999, 0, 0, 0);
	CreateDynamicObject(2007, 2168.2, -951.59998, 910.20001, 0, 0, 0);
	CreateDynamicObject(2007, 2169.2, -951.59998, 910.20001, 0, 0, 0);
	CreateDynamicObject(2007, 2169.2, -951.59998, 908.79999, 0, 0, 0);
	CreateDynamicObject(2000, 2169.8999, -951.59998, 908.79999, 0, 0, 0);
	CreateDynamicObject(2000, 2169.8999, -951.59998, 910.20001, 0, 0, 0);
	CreateDynamicObject(2007, 2170.6001, -951.59998, 908.79999, 0, 0, 0);
	CreateDynamicObject(2007, 2170.6001, -951.59998, 910.20001, 0, 0, 0);
	CreateDynamicObject(2007, 2171.6001, -951.59998, 908.40002, 0, 0, 0);
	CreateDynamicObject(2003, 2171.5, -951.20001, 910.20001, 0, 0, 0);
	CreateDynamicObject(2005, 2171.5, -951.2002, 910.09998, 0, 0, 0);
	CreateDynamicObject(2007, 2172.4004, -951.59961, 909.79999, 0, 0, 0);
	CreateDynamicObject(2007, 2172.3999, -951.59998, 911.20001, 0, 0, 0);
	CreateDynamicObject(2003, 2172.5, -951.29999, 909.29999, 0, 0, 0); // 2003
	CreateDynamicObject(2003, 2171.5, -951.20001, 911.09998, 0, 0, 0);
	CreateDynamicObject(2007, 2173.3999, -951.59998, 908.79999, 0, 0, 0);
	CreateDynamicObject(2007, 2173.4004, -951.59961, 910.20001, 0, 0, 0);
	CreateDynamicObject(2007, 2174.3999, -951.59998, 910.20001, 0, 0, 0);
	CreateDynamicObject(2007, 2174.4004, -951.59961, 908.79999, 0, 0, 0);
	CreateDynamicObject(8356, 2259, -952.5, 908.90002, 0, 0, 91.5);
	CreateDynamicObject(8356, 2259, -952.5, 911.59998, 0, 179.995, 89.495);
	CreateDynamicObject(2007, 2175.2002, -952.2998, 908.79999, 0, 0, 269.247);
	CreateDynamicObject(2000, 2175, -951.7002, 908.79999, 0, 0, 317.75);
	CreateDynamicObject(2000, 2175, -951.7002, 910.20001, 0, 0, 317.747);
	CreateDynamicObject(2007, 2175.2, -952.29999, 910.20001, 0, 0, 269.247);
	CreateDynamicObject(2007, 2175.2002, -953.2998, 910.20001, 0, 0, 269.242);
	CreateDynamicObject(2007, 2175.2002, -953.2998, 908.79999, 0, 0, 269.242);
	CreateDynamicObject(2007, 2165.7998, -953.7998, 908.90002, 0, 0, 89.747);
	CreateDynamicObject(2007, 2165.8, -953.79999, 910.29999, 0, 0, 89.747);
	CreateDynamicObject(2007, 2166.2, -954.29999, 908.79999, 0, 0, 179.997);
	CreateDynamicObject(2007, 2166.2, -954.29999, 910.20001, 0, 0, 179.995);
	CreateDynamicObject(2007, 2167.2, -954.29999, 908.79999, 0, 0, 179.995);
	CreateDynamicObject(2007, 2167.2, -954.29999, 910.20001, 0, 0, 179.995);
	CreateDynamicObject(2007, 2168.2, -954.29999, 910.20001, 0, 0, 179.995);
	CreateDynamicObject(2007, 2168.2, -954.29999, 908.79999, 0, 0, 179.995);
	CreateDynamicObject(2007, 2169.2, -954.29999, 908.79999, 0, 0, 179.995);
	CreateDynamicObject(2007, 2169.2, -954.29999, 910.20001, 0, 0, 179.995);
	CreateDynamicObject(2000, 2169.8999, -954.29999, 908.79999, 0, 0, 178.75);
	CreateDynamicObject(2000, 2169.8999, -954.29999, 910.20001, 0, 0, 178.748);
	CreateDynamicObject(2007, 2170.6001, -954.29999, 908.79999, 0, 0, 179.995);
	CreateDynamicObject(2007, 2170.6006, -954.2998, 910.20001, 0, 0, 179.995);
	CreateDynamicObject(2007, 2171.6001, -954.29999, 910.20001, 0, 0, 179.995);
	CreateDynamicObject(2007, 2171.6006, -954.2998, 908.79999, 0, 0, 179.995);
	CreateDynamicObject(2007, 2172.6006, -954.2998, 908.79999, 0, 0, 179.995);
	CreateDynamicObject(2007, 2172.6001, -954.29999, 910.20001, 0, 0, 179.995);
	CreateDynamicObject(2007, 2173.6001, -954.29999, 910.20001, 0, 0, 179.997);
	CreateDynamicObject(2007, 2173.6006, -954.2998, 908.79999, 0, 0, 179.995);
	CreateDynamicObject(2007, 2174.6001, -954.29999, 910.20001, 0, 0, 179.997);
	CreateDynamicObject(2007, 2174.6001, -954.29999, 908.79999, 0, 0, 179.997);
	CreateDynamicObject(991, 2158.8999, -954.40002, 910.09998, 0, 270, 270);
	CreateDynamicObject(991, 2158.8999, -950.40002, 910.09998, 0, 270, 270);
	CreateDynamicObject(2007, 2175.1001, -954.20001, 908.79999, 0, 0, 256.742);
	CreateDynamicObject(2007, 2175.1001, -954.20001, 910.20001, 0, 0, 256.74);
	CreateDynamicObject(2924, 2155.2, -941.40002, 915.29999, 0, 0, 270.5);
	CreateDynamicObject(2924, 2155.2, -941.40002, 917.70001, 0, 0, 270.5);
	return 1;
}

public OnGameModeExit()
{
	for(new i;i<MAX_PLAYERS;i++)
	{
	if(IsPlayerConnected(i) && Spawneo[i] == 1){GuardarUsuario(i);}}
	GuardarPropiedades();
	GuardarZonas();
	return 1;
}

public OnIncomingConnection(playerid,ip_address[],port)
{
new EIP[16];
GetPlayerIp(playerid,EIP,16);
if(strcmp(ip_address,EIP,true)== 0)
{
if(GetTickCount()-Flood_time[playerid] < 1000)
{
printf("Posible ataque bloqueado: IP: %s | mss: %d | Tiempo: 1 hora|",ip_address,GetTickCount()-Flood_time[playerid]);
BlockIpAddress(ip_address,60*60*1000);
}
}
Flood_time[playerid] = GetTickCount();
return 1;
}


public OnRconLoginAttempt(ip[], password[], success)
{
    foreach(Player, i)
    {
		if(!success)
	    {
        	printf("FAILED RCON LOGIN: IP %s PASSWORd: %s",ip, password);
        	new pip[16];
            GetPlayerIp(i, pip, sizeof(pip));
            if(!strcmp(ip, pip, true))
            {
                new str[85];
                format(str,sizeof(str), "%s(%d) fue baneado por poner RCON INCORRECTA.", pName(i), i);
                SendClientMessageToAll(red,str);
  				BanA(i,"Rcon Incorrecta");
            }
        }
        if(success)
        {
        break;
        }
    }
	return 1;
}

public OnPlayerConnect(playerid)
{
GetPlayerHost(playerid);
PlayAudioStreamForPlayer(playerid,"http://k8.offliberty.com/kXYiU_JCYtU.mp3");AntiFlood_Hack(playerid);AntiFlood[playerid] = 0;
if(IsPlayerNPC(playerid)){printf("Un bot [%s] fue baneado!",pName(playerid));Ban(playerid);}
new IPConectada[16], CompararIP[16], NumeroDeIP = 0; GetPlayerIp(playerid,IPConectada,16);AM[playerid] = 0;AM2[playerid] = 0;
for(new i=0; i<MAX_PLAYERS; i++)
{
if(IsPlayerConnected(i)){
GetPlayerIp(i,CompararIP,16);
if(!strcmp(CompararIP,IPConectada)) NumeroDeIP++;}}
if((GetTickCount() - Join_Stamp) < Limite_De_Tiempo)
{Limite = 1;}else{Limite = 0;}if(strcmp(Banear_IP, IPConectada, false) == 0 && Limite == 1){Misma_IP++;if(Misma_IP > Misma_IP_Conectada)
{BanEx(playerid,"Posible BOT.");Misma_IP = 0;}}else{Misma_IP = 0;}
if(NumeroDeIP > MAXIMAS_CONEXIONES_POR_IP){
new string3[100];
format(string3,sizeof(string3),"[ANTICHEATS]: {FFFFFF}%s fue baneado automáticamente. {00FF00}[Razón: Bots]",pName(playerid));
SendClientMessageToAll(red, string3);
print(string3);
BanEx(playerid, "BOTS");
}
    if((GetTickCount()-GetPVarInt(playerid, "ConnectionTime")) < 200 && CountIP(PlayerIP(playerid)) >= 5){Ban(playerid);}SetPVarInt(playerid, "ConnectionTime", GetTickCount());new file[60];format(file,sizeof(file),"Player Objects/%s.ini",pName(playerid));
    if(!dini_Exists(file)){dini_Create(file);
	for(new x;x<MAX_OSLOTS;x++){
    if(IsPlayerAttachedObjectSlotUsed(playerid, x)){format(f1,15,"O_Model_%d",x);format(f2,15,"O_Bone_%d",x);format(f3,15,"O_OffX_%d",x);format(f4,15,"O_OffY_%d",x);format(f5,15,"O_OffZ_%d",x);format(f6,15,"O_RotX_%d",x);format(f7,15,"O_RotY_%d",x);format(f8,15,"O_RotZ_%d",x);format(f9,15,"O_ScaleX_%d",x);format(f10,15,"O_ScaleY_%d",x);
    format(f11,15,"O_ScaleZ_%d",x);dini_IntSet(file,f1,0);dini_IntSet(file,f2,0);dini_FloatSet(file,f3,0.0);dini_FloatSet(file,f4,0.0);dini_FloatSet(file,f5,0.0);dini_FloatSet(file,f6,0.0); dini_FloatSet(file,f7,0.0);dini_FloatSet(file,f8,0.0);dini_FloatSet(file,f9,0.0);dini_FloatSet(file,f10,0.0);dini_FloatSet(file,f11,0.0);
    }}}
    RemoveBuildingForPlayer(playerid, 3369, 349.8750, 2438.2500, 15.4766, 0.25);RemoveBuildingForPlayer(playerid, 16101, 321.6719, 2463.4922, 15.4766, 0.25);RemoveBuildingForPlayer(playerid, 16368, 321.6719, 2463.4922, 25.6641, 0.25);RemoveBuildingForPlayer(playerid, 3269, 349.8750, 2438.2500, 15.4766, 0.25);RemoveBuildingForPlayer(playerid, 3276, 122.4531, -92.8438, 1.3672, 0.25);RemoveBuildingForPlayer(playerid, 3276, -34.2969, 160.0156, 2.3203, 0.25);Amuertes[playerid] = 0;
	EstaEnFly[playerid] = 0;SetPlayerVirtualWorld(playerid,0);Bloqueado[playerid] = 1;GodE[playerid] = 0;PlayerProps[playerid] = 0;EarningsForPlayer[playerid] = 0;SaludoH[playerid] = 0;UsoChaleco[playerid] = 0;Reporto[playerid] = 0; SaltosBici[playerid] = 0;Info[playerid] = 0;TieneAuto[playerid] = 0;Desmadre[playerid] = 0;Sayayin[playerid] = 0;Gay[playerid] = 0;Lol[playerid] = 0;Skin[playerid] = 0;PlayerInfoE[playerid][NoEvento] = 0;ECarrera[playerid] = 0;CMuertes[playerid] = 0;
	Usuario[playerid][Encarcelado] = 0;Usuario[playerid][Ctiempo] = 0;Tcarcel[playerid] = 0;Usuario[playerid][Eslider] = 0;PlayerGang[playerid] = 0;PlayerLider[playerid] = 0;TiempoMute[playerid] = 0;AceleracionBrutal[playerid] = false;Racha[playerid] = 0;SaltosAuto[playerid] = 0;Reparar[playerid] = 0;InitFly(playerid);Temporal[playerid] = 0;UsoJ[playerid] = 0;Plantada[playerid] = 0;Creando[playerid] = 0;CPP[playerid] = 0;Usuario[playerid][pAdmin] = 0;Minigun[playerid] = 0;
	Minijuego[playerid] = 0;SuperSprint[playerid] = 0;UsarCMD[playerid] = 0;UsoVida[playerid] = 0;Tcarcel[playerid] = 0;IntentoL[playerid] = 0;MPP[playerid] = -1;Spawneo[playerid] = 0;ColorChat[playerid] = 0;Usuario[playerid][GodCar] = 0;Usuario[playerid][Ammopacks] = 0;Usuario[playerid][SGRANADA] = 0;TextDrawShowForPlayer(playerid,Textdraw[6]);TextDrawShowForPlayer(playerid,Textdraw[7]);TextDrawShowForPlayer(playerid,Textdraw[8]);Usuario[playerid][Invisible] = 0;Dominando[playerid] = 0;
    RemoveBuildingForPlayer(playerid, 4177, 1686.4375, -1570.1484, 18.0313, 0.25);RemoveBuildingForPlayer(playerid, 4176, 1686.4375, -1570.1484, 18.0313, 0.25);Usuario[playerid][Modo] = 0;Zona[playerid] = 0;ReparoA[playerid] = 0;RemoveBuildingForPlayer(playerid, 10948, -2076.6484, 436.2891, 96.4609, 0.25);RemoveBuildingForPlayer(playerid, 11021, -2076.6484, 436.2891, 96.4609, 0.25);RemoveBuildingForPlayer(playerid, 11412, -2023.9844, 434.1328, 67.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 792, -2051.3828, 492.5078, 34.2734, 0.25);RemoveBuildingForPlayer(playerid, 792, -2051.6797, 483.4375, 34.2734, 0.25);RemoveBuildingForPlayer(playerid, 792, -2051.8438, 473.8984, 34.2734, 0.25);RemoveBuildingForPlayer(playerid, 792, -2018.5547, 460.2031, 34.2734, 0.25);RemoveBuildingForPlayer(playerid, 792, -2027.0234, 460.3438, 34.2734, 0.25);RemoveBuildingForPlayer(playerid, 792, -2036.4844, 460.5078, 34.2734, 0.25);
	new colores = random(6);
	switch(colores)
	{
	case 0:	SetPlayerColor(playerid,green);
	case 1: SetPlayerColor(playerid,yellow);
	case 2: SetPlayerColor(playerid,red);
	case 3: SetPlayerColor(playerid,blue);
	case 4: SetPlayerColor(playerid,orange);
	case 5: SetPlayerColor(playerid,COLOR_PINK);
	}
	DPM[playerid] = 0; GananciaJugador[playerid] = 0;Usuario[playerid][Dinero] = 0;TSPAWN[playerid] = 0;Guerra[playerid] = 0;
	new string[135];format(string,sizeof(string),"[RL]: {FFFFFF}%s a ingresado al servidor. [País: {00FF00}%s{FFFFFF}] [Usuarios: {0000FF}%d/150{FFFFFF}]",pName(playerid),IpToCountry_db(PlayerIP(playerid)),Usuarios());SendClientMessageToAll(yellow,string);
	new string2[125];new Version[56];
	GetPlayerVersion(playerid,Version,56);format(string2,sizeof(string2),"[INFO-EXTRA-ADMIN]: %s | IP: %s | SA-MP: %s | ID: %d |",pName(playerid),PlayerIP(playerid),Version,playerid);MessageToAdmins(ColorAdmin,string2);
	for(new propid; propid < PropiedadesC; propid++)
	{
		if(PropInfo[propid][PropIsBought] == 1 && PropInfo[propid][PropO] == 0)
		{
		    if(strcmp(PropInfo[propid][PropOwner], pName(playerid), true)==0)
			{
   			    PlayerProps[playerid]++;
			}
		}
		if(PropInfo[propid][PropIsBought] == 1 && PropInfo[propid][PropO] == 1)
		{
		    if(strcmp(PropInfo[propid][PropOwner], pName(playerid), true)==0)
			{
			GananciaJugador[playerid] += PropInfo[propid][PropEarning];
			PlayerProps[playerid]++;
   		}
	}
	}
	Loguear(playerid);SendDeathMessage(INVALID_PLAYER_ID,playerid,200);
	return 1;
}


public OnPlayerDisconnect(playerid, reason)
{
    AntiFlood_Hack(playerid);AntiFlood[playerid] = 0;
	if(TieneAuto[playerid] > 0){DestroyVehicle(TieneAuto[playerid]);TieneAuto[playerid] = 0;}
	if(Desmadre[playerid] == 1){endesmadre--;}
	if(ECarrera[playerid] == 1){posiciones--;}
	TextDrawHideForPlayer(playerid,FPSP[playerid]);SendDeathMessage(INVALID_PLAYER_ID,playerid,201);
	if(PlayerInfoE[playerid][NoEvento] == 1){PlayerInfoE[playerid][NoEvento] = 0;}
    new Version[56];
    new string[150];
    GetPlayerVersion(playerid,Version,56);
    switch(reason)
    {
    case 0: {format(string,sizeof(string),"[PARTIDA]:{FFFFFF} %s [V: %s] salió del servidor. {0000FF}[Crash]",pName(playerid),Version);}
	case 1: {format(string,sizeof(string),"[PARTIDA]:{FFFFFF} %s [V: %s] salió del servidor. {0000FF}[Voluntario]",pName(playerid),Version);}
	case 2: {format(string,sizeof(string),"[PARTIDA]:{FFFFFF} %s [V: %s] salió del servidor. {0000FF}[Kick/Ban]",pName(playerid),Version);}
	case 3: {format(string,sizeof(string),"[PARTIDA]:{FFFFFF} %s [V: %s] relogueó del servidor. {0000FF}[Comando]",pName(playerid),Version);}
	}
	SendClientMessageToAll(red,string);
	if(Spawneo[playerid] == 1){GuardarUsuario(playerid);}
	for(new x=0; x<MAX_PLAYERS; x++)
	if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Usuario[x][SpecID] == playerid)
	AdvanceSpectate(x);
	return 1;
}

public OnPlayerText(playerid, text[])
{
    Antiflood(playerid);
	if(Usuario[playerid][Muteado] == 1){SendClientMessage(playerid,-1,"Estás muteado, no puedes hablar.");return 0;}
	
	static LastText[MAX_PLAYERS][128];
	if(strfind(LastText[playerid], text, false) != -1 && Usuario[playerid][pAdmin] <= 9) return SendClientMessage(playerid, red, "[ANTI-FLOOD]: {FFFFFF}No puedes repetir lo mismo."), 0;
	strmid(LastText[playerid], text, 0, strlen(text), sizeof(LastText[]));

    if(strfind(text, "www.", true) != -1 || strfind(text, ".com", true) != -1 || strfind(text, ":7777", true) != -1 || strfind(text, "fz", true) != -1 || strfind(text, "fenixzone", true) != -1 || strfind(text, "Fantasilandia", true) != -1)
	{
		new string[85];
		format(string,sizeof(string),"[Anti-Cheats]: {FFFFFF}%s fue kickeado automáticamente. {00FF00}[SPAM]",pName(playerid));
		SendClientMessageToAll(red,string);SetTimerEx("Kickear",500,false,"d",playerid);
		return 0;
	}

	if(strval(text) == RespuestaConcurso && RespuestaConcurso != -1)
	{
	if(Usuario[playerid][pAdmin] >= 1 && Usuario[playerid][pAdmin] < 10){SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Sólo los usuarios pueden responder!");return 0;}
	JugadorGanaConcurso(playerid);
    }
    
	if(text[0] == '#' && Usuario[playerid][pAdmin] >= 1)
	{
    new string2[160];
	format(string2,sizeof(string2),"[->Chat Admin<-] {FFFFFF}%s [%i]: {00FF00}%s",pName(playerid), playerid, text[1]);
	MessageToAdmins(blue,string2);
    return 0;
	}
	
	if (text[0] == '!' && PlayerGang[playerid] > 0)
 	{
   	    new gangid = PlayerGang[playerid];
 	    new string2[160];
		format(string2,sizeof(string2),".:|>>Clan %s<<|:. %s [%d]: %s",GangInfo[gangid][GANG_NAME], pName(playerid),playerid,text[1]);
		Message2Gang(PlayerGang[playerid], string2);
 		return 0;
     }
	
	if(text[0] == '&' && Usuario[playerid][pAdmin] >= 8)
	{
    new string2[160];
	format(string2,sizeof(string2),"[->Chat Alto<-] {FFFFFF}%s [%i]: {0000FF}%s",pName(playerid), playerid, text[1]);
	MessageToAdminsA(red,string2);
    return 0;
	}

	if(text[0] == '"' && Usuario[playerid][pAdmin] == 10)
	{
    new string2[160];
	format(string2,sizeof(string2),"[->Chat Dueños<-] %s [%i]: %s",pName(playerid), playerid, text[1]);
	MessageToDuenos(orange,string2);
    return 0;
	}
	
	if(text[0] == '$' && Usuario[playerid][pVip] >= 1)
	{
	new string2[125];
	if(Usuario[playerid][Muteado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes hablar porque estas Muteado!");
    GetPlayerName(playerid,string2,sizeof(string2));
	format(string2,sizeof(string2),".:|CHAT V.I.P|:. {FFFFFF}%s [%d]: %s",string2, playerid, text[1]);
	MessageToVips(yellow,string2);
	return 0;
    }
	
	if(ColorChat[playerid] == 1)
	{
	if(Usuario[playerid][pAdmin] == 9)
	{
	new string2[135];
 	format(string2, sizeof(string2), ".:|» Encargado «|:. {%06x}%s [%d]: {00FF00}%s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(red,string2);
	}
	if(Usuario[playerid][pAdmin] == 10){new string2[135];
 	format(string2, sizeof(string2), ".:|» Dueño «|:. {%06x}%s [%d]: {00FF00}%s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(red,string2);}
	return 0;
	}
	
	new string[450];
	if(Usuario[playerid][pAdmin] == 1){
	format(string,sizeof(string),"{00FF00}|@Ayudante|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
	}
	if(Usuario[playerid][pAdmin] == 2){
	format(string,sizeof(string),"{FF0000}|@Moderador|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
	}
	if(Usuario[playerid][pAdmin] == 3){
	format(string,sizeof(string),"{FF0000}|@Moderador|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
	}
	if(Usuario[playerid][pAdmin] == 4){
	format(string,sizeof(string),"{FF0000}|@Moderador|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
	}
    if(Usuario[playerid][pAdmin] == 5){
	format(string,sizeof(string),"{0000FF}|@Administrador|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
	}
	if(Usuario[playerid][pAdmin] == 6){
	format(string,sizeof(string),"{0000FF}|@Administrador|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
	}
	if(Usuario[playerid][pAdmin] == 7)
	{
	format(string,sizeof(string),"{0000FF}|@Administrador|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
	}
	if(Usuario[playerid][pAdmin] == 8){
	format(string,sizeof(string),"{0000FF}|@Administrador|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
	}
	if(Usuario[playerid][pAdmin] == 9){
	format(string,sizeof(string),"{FF0000}|@Encargado|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
	}
	if(Usuario[playerid][pAdmin] == 10){
	format(string,sizeof(string),"{FF0000}|@Dueño|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
	}
	if(Usuario[playerid][pVip] >= 1){
	format(string,sizeof(string),"{00FF00}|@Vip|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
	}
	format(string,sizeof(string),"{0000FF}|@N|{%06x} %s[%d]:{FFFFFF} %s",GetPlayerColor(playerid) >>> 8,pName(playerid),playerid,text);
	SendClientMessageToAll(-1,string);SetPlayerChatBubble(playerid, text, cian1, 100.0, 10000);
	return 0;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
Antiflood(playerid);
if (!success){new errorcmd[115];format(errorcmd,sizeof(errorcmd), "{FFFFFF}El comando {29FF0D}%s{FFFFFF} {FF0000}no existe{FFFFFF}, utilice /ayuda.",cmdtext);
return SendClientMessage(playerid, -1, errorcmd);
}
return 1;
}

CMD:dia(playerid,params[])
{SetPlayerTime(playerid,7,0);SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Pusiste el clima de día.");
return 1;
}

CMD:noche(playerid,params[])
{SetPlayerTime(playerid,24,0);SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Pusiste el clima de noche.");
return 1;
}

CMD:lluvia(playerid,params[])
{SetPlayerWeather(playerid,8);SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Pusiste el clima de lluvia.");
return 1;
}

CMD:soleado(playerid,params[])
{
SetPlayerWeather(playerid,1);
SetPlayerTime(playerid,12,0);
SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Pusiste el clima de sol.");
return 1;
}

CMD:niebla(playerid,params[])
{
SetPlayerWeather(playerid,9);
SetPlayerTime(playerid,20,0);
SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Pusiste el clima de niebla.");
return 1;
}

CMD:climas(playerid,params[])
{
ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Climas ||","{FFFFFF}Hay muchos climas y puedes cambiarlos.\n{00FF00}/dia: {FFFFFF}Ponés de día.\n{00FF00}/noche: {FFFFFF}Ponés de noche.\n{00FF00}/soleado: {FFFFFF}Ponés que haya mucho sol.\n{00FF00}/lluvia: {FFFFFF}Ponés el tiempo lluvioso.\n{00FF00}/niebla: {FFFFFF}Ponés clima con niebla.","Aceptar","");
return 1;
}

CMD:dararma(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 3)
{
new player1, weap, ammo, WeapName[32];
new string2[200];

if(sscanf(params, "ddd", player1, weap, ammo))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /dararma [jugador] [ID del arma/nombre del arma] [municiones]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
if(!IsValidWeapon(weap)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}ID de arma inválida");
CMDMessageToAdmins(playerid,"DARARMA");GetWeaponName(weap,WeapName,32);
format(string2, sizeof(string2), "Le diste a \"%s\" una %s [%d] con %d municiones.", pName(player1), WeapName, weap, ammo);
SendClientMessage(playerid,ColorAdmin,string2);
if(player1 != playerid){
format(string2,sizeof(string2),"[INFO]: {FFFFFF}\"%s\" te dió una %s [%d] con %d municiones.", pName(playerid), WeapName, weap, ammo);
SendClientMessage(player1,ColorAdmin,string2);
}
GivePlayerWeapon(player1, weap, ammo);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes utilizar el comando!");
return 1;
}


CMD:darallarmas(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 6)
{
new string2[150];
new ammo, weap, WeapName[32];
if(sscanf(params, "dd", weap, ammo))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /darallarmas [ID del ARMA] [ammo]");
return 1;
}
if(!IsValidWeapon(weap)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}ID del arma inválida");
CMDMessageToAdmins(playerid,"DARALLARMAS");
for(new i, g = GetMaxPlayers(); i < g; i++)
{
if(IsPlayerConnected(i) && Desmadre[i] == 0 || IsPlayerConnected(i) && Minijuego[i] == 0)
{
PlayerPlaySound(i,1057,0.0,0.0,0.0);GivePlayerWeapon(i,weap,ammo);
}
}
GetWeaponName(weap, WeapName, sizeof(WeapName));
format(string2,sizeof(string2),"[INFO]: {FFFFFF}\"%s\" regaló a todos los usuarios una %s [%d] con %d municiones.", pName(playerid), WeapName, weap, ammo);
SendClientMessageToAll(blue, string2);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:insertar(playerid,params[])
{
if(Usuario[playerid][pAdmin] < 9) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Sólo niveles 9 pueden poner música.");
ShowPlayerDialog(playerid,600,DIALOG_STYLE_INPUT,"|| Música ||","Inserta el link de la música.","Aceptar","Cancelar");
return 1;
}

CMD:mdetener(playerid,params[])
{
StopAudioStreamForPlayer(playerid);
SendClientMessage(playerid,green,".:|MÚSICA|:. {FFFFFF}Paraste toda la música.");
return 1;
}

CMD:fps(playerid,params[])
{
new id;
if(sscanf(params,"d",id)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Debes poner {00FF00}/fps [ID]{FFFFFF}.");
if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}La ID ingresada está {00FF00}desconectada{FFFFFF}.");
new string[135];
format(string,sizeof(string),"Datos de: {00FF00}%s{FFFFFF} [ID: {00FF00}%d{FFFFFF}] [Ping: {00FF00}%d{FFFFFF}] [FPS: {00FF00}%d{FFFFFF}]",pName(id),id,GetPlayerPing(id),FPS2[id]);
SendClientMessage(playerid,-1,string);
return 1;
}

CMD:cambiar(playerid,params[])
{
    if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
	if(strcmp(params,"contraseña",true) == 0)
	{
	ShowPlayerDialog(playerid,105,DIALOG_STYLE_INPUT,"|| Nueva contraseña ||","{FFFFFF}Escriba su correo electrónico por seguridad.\nSi no lo recuerdas contactar un dueño.","Aceptar","Cancelar");
	return 1;
	}
	if(strcmp(params,"nombre",true) == 0)
	{
	ShowPlayerDialog(playerid,107,DIALOG_STYLE_INPUT,"|| Nuevo nombre ||","{FFFFFF}Escriba su correo electrónico por seguridad.\nSi no lo recuerdas contactar un dueño.","Aceptar","Cancelar");
	return 1;
	}
	return 1;
}


CMD:decir(playerid, params[])
{
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
if(Usuario[playerid][pVip] == 0) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Debes ser VIP para usar el comando.");
if(sscanf(params, "s[80]", params))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /decir [texto]");
return 1;
}
if(strfind(params, "/q", true) != -1 || strfind(params, "/gay", true) != -1 || strfind(params, "/quit", true) != -1 || strfind(params, "/ q", true) != -1 && Usuario[playerid][pAdmin] == 0)
{
SendClientMessage(playerid, red, "[INFO]: {FFFFFF}No puedes poner eso!");
return 1;
}
new string2[250];
switch(Usuario[playerid][pVip])
{
case 1:
{
format(string2, sizeof(string2), "®||Vip Bronce||{FFFFFF} %s [%d]: %s", pName(playerid),playerid, params);
SendClientMessageToAll(COLOR_DARKRED,string2);
}
case 2:
{
format(string2, sizeof(string2), "®||Vip Plata||{FFFFFF} %s [%d]: %s", pName(playerid),playerid, params);
SendClientMessageToAll(COLOR_VERDECLARO,string2);
}
case 3:
{
format(string2, sizeof(string2), "®||Vip Oro||{FFFFFF} %s [%d]: %s", pName(playerid),playerid, params);
SendClientMessageToAll(yellow,string2);
}
case 4:
{
format(string2, sizeof(string2), "®||Vip Elite||{FFFFFF} %s [%d]: %s", pName(playerid),playerid, params);
SendClientMessageToAll(GRIS,string2);
}
case 5:
{
format(string2, sizeof(string2), "®||Vip Dios||{FFFFFF} %s [%d]: %s", pName(playerid),playerid, params);
SendClientMessageToAll(red,string2);
}
case 6:
{
format(string2, sizeof(string2), "®||Vip Supremo||{FFFFFF} %s [%d]: %s", pName(playerid),playerid, params);
SendClientMessageToAll(blue,string2);
}
}
return 1;
}

CMD:colores(playerid,params[])
{
      if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto en carrera! /acarrera");
      if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
      if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
      if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
      ShowPlayerDialog(playerid,60,DIALOG_STYLE_LIST,"{FFFFFF}Colores","{FF0000}Rojos\r\n{FF8000}Naranjas\r\n{964B00}Marrones\r\n{00FF00}Amarillos\r\n{00FF00}Verdes\r\n{00FFFF}Azules Claros\r\n{0000FF}Azules Oscuros\r\n{8B00FF}Violetas\r\n{FF00FF}Rosas\r\n{FFFFFF}Blanco\r\n{000000}Negro\r\n{808080}Grises","Elegir", "Cancelar");
      PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
      return 1;
}

CMD:autos(playerid, params[])
{
	if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto en carrera! /acarrera");
    if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
    if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
	ShowPlayerDialog(playerid,300,DIALOG_STYLE_LIST, "Vehículos del servidor.", ">>Autos generales\n>>Autos Deportivos\n>>Motos & Bicicletas\n>>Camiones\n>>Aviones\n>>Helicópteros\n>>Barcos", "Aceptar","Cancelar");
	return 1;
}

CMD:estadisticas(playerid,params[])
{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/est");
	return 1;
}

CMD:estadistica(playerid,params[])
{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/est");
	return 1;
}

CMD:stats(playerid,params[])
{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/est");
	return 1;
}

CMD:skills(playerid,params[])
{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/est");
	return 1;
}
CMD:est(playerid,params[])
{
    if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
    if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
	new TVIP[15], TxAdm[26];
	switch(Usuario[playerid][pVip])
   	{
   	case 0: TVIP = "N/A";
	case 1: TVIP = "Bronce";
	case 2: TVIP = "Plata";
	case 3: TVIP = "Oro";
	case 4: TVIP = "Elite";
	case 5: TVIP = "Dios";
	case 6: TVIP = "Supremo";
	}
	switch(Usuario[playerid][pAdmin])
	{
	case 0: TxAdm = "Normal";
	case 1: TxAdm = "Ayudante";
	case 2: TxAdm = "Moderador a Prueba";
	case 3: TxAdm = "Moderador";
	case 4: TxAdm = "Moderador Global";
	case 5: TxAdm = "Administrador a Prueba";
	case 6: TxAdm = "Co-administrador";
	case 7: TxAdm = "Administrador";
	case 8: TxAdm = "Administrador Global";
	case 9: TxAdm = "Encargado";
	case 10: TxAdm = "Dueño";
	}
	new TMODOS[12];
	switch(Usuario[playerid][Modo])
	{
	case 0: TMODOS = "N/A";
	case 1: TMODOS = "Freeroam";
	case 2: TMODOS = "DM";
	case 3: TMODOS = "Carreras";
	}
	new string2[325];
	format(string2,sizeof(string2),"{FFFFFF}Asesinatos:{00FF00} %d\n{FFFFFF}Muertes: {00FF00}%d\n{FFFFFF}Dinero: {00FF00}$%d\n{FFFFFF}Nivel Admin: {0000FF}%d [%s]\n{FFFFFF}VIP: {00FF00}%s\n{FFFFFF}Registro: {00FF00}%s\n{FFFFFF}Nivel: {00FF00}%d\n{FFFFFF}AmmoPacks: %d\nFPS: {00FF00}%d\n{FFFFFF}Modo: {00FF00}%s",
	Usuario[playerid][Asesinatos],Usuario[playerid][Muertes],GetPlayerMoney(playerid),Usuario[playerid][pAdmin],TxAdm,TVIP,Usuario[playerid][Registro],Usuario[playerid][Nivel],Usuario[playerid][Ammopacks],FPS2[playerid],TMODOS);
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"{00FF00}|| Estadísticas ||",string2,"Aceptar","");
	return 1;
}

CMD:cres(playerid,params[])
{
	if(Usuario[playerid][pAdmin] < 9) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos para usar el comando.");
	new p,interior,nombre[55], Float:x,Float:y,Float:z,string[255];
	if(sscanf(params, "is[55]d", p,nombre,interior))
	{
	SendClientMessage(playerid, -1, "Utilice: /cres [Precio] [Nombre] [Interior 1-2-3-4-5]");
	return 1;
	}
	if(interior <= 0 || interior >= 6) return SendClientMessage(playerid,-1,"Los interiores habilitados son desde el 1 al 6. Mira {00FF00}/ayuda restaurantes{FFFFFF}.");
	PropiedadesC++;
	PropInfo[PropiedadesC][PropID] = PropiedadesC;
	GetPlayerPos(playerid,x,y,z);
	PropInfo[PropiedadesC][PropX] = x;
	PropInfo[PropiedadesC][PropY] = y;
	PropInfo[PropiedadesC][PropZ] = z;
	PropInfo[PropiedadesC][PropValue] = p;
	PropInfo[PropiedadesC][PropEarning] = p/4;
	PropInfo[PropiedadesC][PropIsBought] = 0;
	PropInfo[PropiedadesC][PropM] = PropiedadesC;
	MapIconStreamer();
	PropInfo[PropiedadesC][PropO] = 1;
	PropInfo[PropiedadesC][PickupNr] = CreatePickup(1273, 1, PropInfo[PropiedadesC][PropX], PropInfo[PropiedadesC][PropY], PropInfo[PropiedadesC][PropZ]);
	format(string,sizeof(string),"Restaurante {FFFFFF}[{00FF00}EN VENTA{FFFFFF}]\nDueño: {00FF00}N/A{FFFFFF}.\nValor: {00FF00}$%d{FFFFFF}\nGanancia: {00FF00}$%d{FFFFFF}\nUsa {00FF00}/comprar restaurante{FFFFFF} para adquirirlo.",PropInfo[PropiedadesC][PropValue],(PropInfo[PropiedadesC][PropValue]/4));
	PropInfo[PropiedadesC][Texto] = Create3DTextLabel(string, 0x0000FFFF, PropInfo[PropiedadesC][PropX], PropInfo[PropiedadesC][PropY], PropInfo[PropiedadesC][PropZ], 15.0, 0, 0);
  	new gfile[100];
	format(gfile, sizeof(gfile), DIRECCION, PropiedadesC);
	dini_Create(gfile);
  	format(PropInfo[PropiedadesC][PropName], 64, "%s", nombre);
  	format(PropInfo[PropiedadesC][PropOwner], MAX_PLAYER_NAME, "En venta");
	dini_Set(gfile, "Propiedad", PropInfo[PropiedadesC][PropName]);
    dini_Set(gfile, "Propietario", PropInfo[PropiedadesC][PropOwner]);
	dini_FloatSet(gfile, "PosX", PropInfo[PropiedadesC][PropX]);
	dini_FloatSet(gfile, "PosY", PropInfo[PropiedadesC][PropY]);
	dini_FloatSet(gfile, "PosZ", PropInfo[PropiedadesC][PropZ]);
	dini_IntSet(gfile, "PropValor", PropInfo[PropiedadesC][PropValue]);
	dini_IntSet(gfile, "PropGastos", PropInfo[PropiedadesC][PropEarning]);
	dini_IntSet(gfile, "PropVenta", PropInfo[PropiedadesC][PropIsBought]);
    dini_IntSet(gfile, "PropMundo", PropInfo[PropiedadesC][PropM]);
    dini_IntSet(gfile, "PropO", PropInfo[PropiedadesC][PropO]);
    if(interior == 1)
    {
    PropInfo[PropiedadesC][PropEX] = 362.91;
	PropInfo[PropiedadesC][PropEY] = -75.06;
	PropInfo[PropiedadesC][PropEZ] = 1001.50;
	PropInfo[PropiedadesC][PropI] = 10;
    dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	if(interior == 2)
	{
	PropInfo[PropiedadesC][PropEX] = 364.98;
	PropInfo[PropiedadesC][PropEY] = -11.73;
	PropInfo[PropiedadesC][PropEZ] = 1001.85;
	PropInfo[PropiedadesC][PropI] = 9;
    dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	if(interior == 3)
	{
	PropInfo[PropiedadesC][PropEX] = 372.45;
	PropInfo[PropiedadesC][PropEY] = -133.41;
	PropInfo[PropiedadesC][PropEZ] = 1001.49;
	PropInfo[PropiedadesC][PropI] = 5;
    dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	if(interior == 4)
	{
	PropInfo[PropiedadesC][PropEX] = 377.14;
	PropInfo[PropiedadesC][PropEY] = -193.19;
	PropInfo[PropiedadesC][PropEZ] = 1000.64;
	PropInfo[PropiedadesC][PropI] = 17;
    dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	if(interior == 5)
	{
	PropInfo[PropiedadesC][PropEX] = 460.25;
	PropInfo[PropiedadesC][PropEY] = -88.24;
	PropInfo[PropiedadesC][PropEZ] = 999.55;
	PropInfo[PropiedadesC][PropI] = 4;
    dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
 	PropInfo[PropiedadesC][PropS] = Create3DTextLabel("Usa {0000FF}/salir{FFFFFF} para abandonar el restaurante.", 0xFFFFFFFF, PropInfo[PropiedadesC][PropEX], PropInfo[PropiedadesC][PropEY], PropInfo[PropiedadesC][PropEZ], 7.0, PropInfo[PropiedadesC][PropM], 0);
 	return 1;
}

CMD:ccp(playerid,params[])
{
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][pAdmin] < 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos para usar el comando.");
if(sscanf(params,"s[25]",params)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Usa /ccp [NOMBRE DE LA CARRERA].");
if(Spawnc[playerid] < 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Debes haber creado los 10 spawns!");
new file[50];
format(file,sizeof(file),"Carreras/%s.ini",params);
if(!dini_Exists(file)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}La carrera no existe.");
cp++;
new Float:cx,Float:cy,Float:cz;
GetPlayerPos(playerid,cx,cy,cz);
dini_IntSet(file,"CPS",cp);
SendClientMessage(playerid,green,"[CARRERA]: {FFFFFF}Create un CP, para crear el CP final usa {00FF00}/cpfin{FFFFFF}.");
switch(cp)
{
case 1:{dini_FloatSet(file,"CP1X",cx);dini_FloatSet(file,"CP1Y",cy);dini_FloatSet(file,"CP1Z",cz);}
case 2:{dini_FloatSet(file,"CP2X",cx);dini_FloatSet(file,"CP2Y",cy);dini_FloatSet(file,"CP2Z",cz);Creando[playerid] = 1;}
case 3:{dini_FloatSet(file,"CP3X",cx);dini_FloatSet(file,"CP3Y",cy);dini_FloatSet(file,"CP3Z",cz);}
case 4:{dini_FloatSet(file,"CP4X",cx);dini_FloatSet(file,"CP4Y",cy);dini_FloatSet(file,"CP4Z",cz);}
case 5:{dini_FloatSet(file,"CP5X",cx);dini_FloatSet(file,"CP5Y",cy);dini_FloatSet(file,"CP5Z",cz);}
case 6:{dini_FloatSet(file,"CP6X",cx);dini_FloatSet(file,"CP6Y",cy);dini_FloatSet(file,"CP6Z",cz);}
case 7:{dini_FloatSet(file,"CP7X",cx);dini_FloatSet(file,"CP7Y",cy);dini_FloatSet(file,"CP7Z",cz);}
case 8:{dini_FloatSet(file,"CP8X",cx);dini_FloatSet(file,"CP8Y",cy);dini_FloatSet(file,"CP8Z",cz);}
case 9:{dini_FloatSet(file,"CP9X",cx);dini_FloatSet(file,"CP9Y",cy);dini_FloatSet(file,"CP9Z",cz);}
case 10:{dini_FloatSet(file,"CP10X",cx);dini_FloatSet(file,"CP10Y",cy);dini_FloatSet(file,"CP10Z",cz);}
case 11:{dini_FloatSet(file,"CP11X",cx);dini_FloatSet(file,"CP11Y",cy);dini_FloatSet(file,"CP11Z",cz);}
case 12:{dini_FloatSet(file,"CP12X",cx);dini_FloatSet(file,"CP12Y",cy);dini_FloatSet(file,"CP12Z",cz);}
case 13:{dini_FloatSet(file,"CP13X",cx);dini_FloatSet(file,"CP13Y",cy);dini_FloatSet(file,"CP13Z",cz);}
case 14:{dini_FloatSet(file,"CP14X",cx);dini_FloatSet(file,"CP14Y",cy);dini_FloatSet(file,"CP14Z",cz);}
case 15:{dini_FloatSet(file,"CP15X",cx);dini_FloatSet(file,"CP15Y",cy);dini_FloatSet(file,"CP15Z",cz);}
case 16:{SCM(playerid,red,"[CARRERA]: {FFFFFF}Sólo hasta 15 CP'S, ahora busca donde terminar la carrera, /cpfin.");}
}
return 1;
}

CMD:ccar(playerid,params[])
{
new ca,Float:EX,Float:EY,Float:EZ;
if(Usuario[playerid][pAdmin] < 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Sólo dueños pueden crear carreras.");
if(sscanf(params,"s[25]d",params,ca)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Usa /ccar [NOMBRE DE LA CARRERA] [AUTO]");
new file[50];
GetPlayerPos(playerid,EX,EY,EZ);
format(file,sizeof(file),"Carreras/%s.ini",params);
dini_Create(file);
dini_IntSet(file,"Auto",ca);
dini_FloatSet(file,"SpawnX",EX);
Spawnc[playerid] = 1;
dini_FloatSet(file,"SpawnY",EY);
dini_FloatSet(file,"SpawnZ",EZ);
SendClientMessage(playerid,red,"[INFO]: {FFFFFF}Carrera creada, spawn 1 listo. Ahora /cspawn para los otros spawn's.");
cp = 0;
return 1;
}

CMD:cspawn(playerid,params[])
{
new Float:EX,Float:EY,Float:EZ;
if(Usuario[playerid][pAdmin] < 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Sólo dueños pueden crear carreras.");
if(sscanf(params,"s[25]",params)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Usa /cspawn [NOMBRE DE LA CARRERA]");
new file[50];
format(file,sizeof(file),"Carreras/%s.ini",params);
if(!dini_Exists(file)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}La carrera no existe.");
GetPlayerPos(playerid,EX,EY,EZ);
switch(Spawnc[playerid])
{
case 0:{SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No estás creando una carrera.");}
case 1:{Spawnc[playerid]++;dini_FloatSet(file,"SpawnX2",EX);dini_FloatSet(file,"SpawnY2",EY);dini_FloatSet(file,"SpawnZ2",EZ);}
case 2:{Spawnc[playerid]++;dini_FloatSet(file,"SpawnX3",EX);dini_FloatSet(file,"SpawnY3",EY);dini_FloatSet(file,"SpawnZ3",EZ);}
case 3:{Spawnc[playerid]++;dini_FloatSet(file,"SpawnX4",EX);dini_FloatSet(file,"SpawnY4",EY);dini_FloatSet(file,"SpawnZ4",EZ);}
case 4:{Spawnc[playerid]++;dini_FloatSet(file,"SpawnX5",EX);dini_FloatSet(file,"SpawnY5",EY);dini_FloatSet(file,"SpawnZ5",EZ);}
case 5:{Spawnc[playerid]++;dini_FloatSet(file,"SpawnX6",EX);dini_FloatSet(file,"SpawnY6",EY);dini_FloatSet(file,"SpawnZ6",EZ);}
case 6:{Spawnc[playerid]++;dini_FloatSet(file,"SpawnX7",EX);dini_FloatSet(file,"SpawnY7",EY);dini_FloatSet(file,"SpawnZ7",EZ);}
case 7:{Spawnc[playerid]++;dini_FloatSet(file,"SpawnX8",EX);dini_FloatSet(file,"SpawnY8",EY);dini_FloatSet(file,"SpawnZ8",EZ);}
case 8:{Spawnc[playerid]++;dini_FloatSet(file,"SpawnX9",EX);dini_FloatSet(file,"SpawnY9",EY);dini_FloatSet(file,"SpawnZ9",EZ);}
case 9:{Spawnc[playerid]++;dini_FloatSet(file,"SpawnX10",EX);dini_FloatSet(file,"SpawnY10",EY);dini_FloatSet(file,"SpawnZ10",EZ);SCM(playerid,green,"Spawns creados [10], ahora usa /cpp.");}
case 10:{SendClientMessage(playerid,red,"[ERROR]: {FFFFF}Ya creaste todos los spawns (10), ahora usa /ccp.");}
}
return 1;
}

CMD:cpfin(playerid,params[])
{
new Float:EX,Float:EY,Float:EZ;
if(Creando[playerid] == 0) return SCM(playerid,red,"[ERROR]: {FFFFFF}No estás haciendo ninguna carrera o llevas menos de dos CPS.");
if(sscanf(params,"s[25]",params)) return SCM(playerid,red,"[ERROR]: {FFFFFF}Usa /cpfin [NOMBRE DE LA CARRERA]");
new file[50];
GetPlayerPos(playerid,EX,EY,EZ);
format(file,sizeof(file),"Carreras/%s.ini",params);
dini_FloatSet(file,"CpFinX",EX);
dini_FloatSet(file,"CpFinY",EY);
dini_FloatSet(file,"CpFinZ",EZ);
Spawnc[playerid] = 0;
SendClientMessage(playerid,green,"[INFO]:{FFFFFF}Carrera terminada correctamente.");
Creando[playerid] = 0;
cp = 0;
return 1;
}

CMD:acarrera(playerid,params[])
{
if(ECarrera[playerid] == 0 || carreraon == 0) return SCM(playerid,red,"[ERROR]: {FFFFFF}No estás en la carrera o no hay ninguna creada!");
SetPlayerPos(playerid,0,0,0);
SpawnPlayer(playerid);
posiciones--;
ECarrera[playerid] = 0;
DestroyVehicle(TieneAuto[playerid]);
SCM(playerid,green,"[INFO]: {FFFFFF}Saliste de la carrera correctamente!");
if(posiciones <= 1 && carrerae == 1)
{
carreraon = 0;
SendClientMessageToAll(red,"[CARRERAS]: {FFFFFF}Carrera finalizada por falta de corredores.");
posiciones = 0;
Llegadas = 0;
carrerae = 0;
}
return 1;
}

CMD:carrera(playerid,params[])
{
if(carreraon == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Ya hay una carrera ONLINE.");
if(Usuario[playerid][pAdmin] < 2) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
if(sscanf(params,"s[25]",params)) return SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Usa /carrera [CARRERA] para cargarla.");
new file[40];
format(file,sizeof(file),"Carreras/%s.ini",params);
if(!dini_Exists(file)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No existe la carrera.");
format(CarreraI[CN],25,"%s",params);CarreraI[CPS] = dini_Int(file,"CPS");CarreraI[SCX] = dini_Float(file,"SpawnX");CarreraI[SCY] = dini_Float(file,"SpawnY");CarreraI[SCZ] = dini_Float(file,"SpawnZ");
CarreraI[SCX2] = dini_Float(file,"SpawnX2");CarreraI[SCY2] = dini_Float(file,"SpawnY2");CarreraI[SCZ2] = dini_Float(file,"SpawnZ2");CarreraI[SCX3] = dini_Float(file,"SpawnX3");CarreraI[SCY3] = dini_Float(file,"SpawnY3");CarreraI[SCZ3] = dini_Float(file,"SpawnZ3");CarreraI[SCX4] = dini_Float(file,"SpawnX4");CarreraI[SCY4] = dini_Float(file,"SpawnY4");CarreraI[SCZ4] = dini_Float(file,"SpawnZ4");
CarreraI[SCX5] = dini_Float(file,"SpawnX5");CarreraI[SCY5] = dini_Float(file,"SpawnY5");CarreraI[SCZ5] = dini_Float(file,"SpawnZ5");CarreraI[SCX6] = dini_Float(file,"SpawnX6");CarreraI[SCY6] = dini_Float(file,"SpawnY6");CarreraI[SCZ6] = dini_Float(file,"SpawnZ6");CarreraI[SCX7] = dini_Float(file,"SpawnX7");CarreraI[SCY7] = dini_Float(file,"SpawnY7");CarreraI[SCZ7] = dini_Float(file,"SpawnZ7");
CarreraI[SCX8] = dini_Float(file,"SpawnX8");CarreraI[SCY8] = dini_Float(file,"SpawnY8");CarreraI[SCZ8] = dini_Float(file,"SpawnZ8");CarreraI[SCX9] = dini_Float(file,"SpawnX9");CarreraI[SCY9] = dini_Float(file,"SpawnY9");CarreraI[SCZ9] = dini_Float(file,"SpawnZ9");CarreraI[CP1X] = dini_Float(file,"CP1X");CarreraI[CP1Y] = dini_Float(file,"CP1Y");CarreraI[CP1Z] = dini_Float(file,"CP1Z");
CarreraI[CP2X] = dini_Float(file,"CP2X");CarreraI[CP2Y] = dini_Float(file,"CP2Y");CarreraI[CP2Z] = dini_Float(file,"CP2Z");CarreraI[CP3X] = dini_Float(file,"CP3X");CarreraI[CP3Y] = dini_Float(file,"CP3Y");CarreraI[CP3Z] = dini_Float(file,"CP3Z");CarreraI[CP4X] = dini_Float(file,"CP4X");CarreraI[CP4Y] = dini_Float(file,"CP4Y");CarreraI[CP4Z] = dini_Float(file,"CP4Z");
CarreraI[CP5X] = dini_Float(file,"CP5X");CarreraI[CP5Y] = dini_Float(file,"CP5Y");CarreraI[CP5Z] = dini_Float(file,"CP5Z");CarreraI[CP6X] = dini_Float(file,"CP6X");CarreraI[CP6Y] = dini_Float(file,"CP6Y");CarreraI[CP6Z] = dini_Float(file,"CP6Z");CarreraI[CP7X] = dini_Float(file,"CP7X");CarreraI[CP7Y] = dini_Float(file,"CP7Y");CarreraI[CP7Z] = dini_Float(file,"CP7Z");
CarreraI[CP8X] = dini_Float(file,"CP8X");CarreraI[CP8Y] = dini_Float(file,"CP8Y");CarreraI[CP8Z] = dini_Float(file,"CP8Z");CarreraI[CP9X] = dini_Float(file,"CP9X");CarreraI[CP9Y] = dini_Float(file,"CP9Y");CarreraI[CP9Z] = dini_Float(file,"CP9Z");CarreraI[CP10X] = dini_Float(file,"CP10X");CarreraI[CP10Y] = dini_Float(file,"CP10Y");CarreraI[CP10Z] = dini_Float(file,"CP10Z");
CarreraI[CP11X] = dini_Float(file,"CP11X");CarreraI[CP11Y] = dini_Float(file,"CP11Y");CarreraI[CP11Z] = dini_Float(file,"CP11Z");CarreraI[CP12X] = dini_Float(file,"CP12X");CarreraI[CP12Y] = dini_Float(file,"CP12Y");CarreraI[CP12Z] = dini_Float(file,"CP12Z");CarreraI[CP13X] = dini_Float(file,"CP13X");CarreraI[CP13Y] = dini_Float(file,"CP13Y");CarreraI[CP13Z] = dini_Float(file,"CP13Z");
CarreraI[CP14X] = dini_Float(file,"CP14X");CarreraI[CP14Y] = dini_Float(file,"CP14Y");CarreraI[CP14Z] = dini_Float(file,"CP14Z");CarreraI[CP15X] = dini_Float(file,"CP15X");CarreraI[CP15Y] = dini_Float(file,"CP15Y");CarreraI[CP15Z] = dini_Float(file,"CP15Z");CarreraI[CA] = dini_Int(file,"Auto");CarreraI[CpFinX] = dini_Float(file,"CpFinX");CarreraI[CpFinY] = dini_Float(file,"CpFinY");CarreraI[CpFinZ] = dini_Float(file,"CpFinZ");
new string[120];
format(string,sizeof(string),"[CARRERA]: {FFFFFF}La carrera {0000FF}%s{FFFFFF} está por comenzar [30 SEGUNDOS]. {FF0000}[/unirme]",params);
SendClientMessageToAll(green,string);
CarreraT = SetTimer("CierraR",30000,false);
carreraon = 1;
carrerae = 0;
Llegadas = 0;
return 1;
}

CMD:fincarreras(playerid,params[])
{
posiciones = 0;Llegadas = 0;carreraon = 0;
for(new i, g = GetMaxPlayers(); i < g; i++)
{
if(ECarrera[i] == 1)
{
ECarrera[i] = 0;CPP[i] = 0;DisablePlayerRaceCheckpoint(i);SetPlayerPos(i,0.0,0.0,0.0);SpawnPlayer(i);
}
}
SendClientMessageToAll(green,"[CARRERA]: {FFFFFF}La carrera fue suspendida/finalizada por un admin!");
return 1;
}

CMD:sconteo(playerid,params[])
{
if(Usuario[playerid][pAdmin] < 5) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes utilizar el comando!");
if(sconteo == 0)
{
sconteo = 1;
new string[60];
format(string,sizeof(string),"[CONTEO]: {FFFFFF}%s desactivó el conteo!",pName(playerid));
SendClientMessageToAll(green,string);
return 1;
}
if(sconteo == 1)
{
new string[60];
sconteo = 0;
format(string,sizeof(string),"[CONTEO]: {FFFFFF}%s activó el conteo!",pName(playerid));
SendClientMessageToAll(green,string);
}
return 1;
}

CMD:conteo(playerid,params[])
{
if(sconteo == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}El comando fue desactivado por un administrador!");
if(Desmadre[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Minijuego[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(conteo1 == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}Ya hay un conteo activo!");
conteo1 = 1;new string[65];format(string,sizeof(string),"[CONTEO]: {FFFFFF}%s comenzó un conteo regresivo!",pName(playerid));
SendClientMessageToAll(yellow,string);
GameTextForAll("~y~5",1000,3);
SetTimer("c4",1000,false);
PlayerPlaySoundForAll(1056, 0.0, 0.0, 0.0);
return 1;
}


CMD:unirme(playerid,params[])
{
if(Desmadre[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá.");
if(Minijuego[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá.");
if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estándo invisible.");
if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,red,"[ERROR]: {FFFFFF}Bajate de tu auto.");
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}Ya estás en la carrera!");
if(carrerae == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}La carrera ya empezó!");
if(carreraon == 0) return SCM(playerid,red,"[ERROR]: {FFFFFF}No hay ninguna carrera activada!");
posiciones++;
SetPlayerVirtualWorld(playerid,15);
SetPlayerInterior(playerid,0);
switch(posiciones)
{
case 1:{SetPlayerPos(playerid,CarreraI[SCX],CarreraI[SCY],CarreraI[SCZ]);}
case 2:{SetPlayerPos(playerid,CarreraI[SCX2],CarreraI[SCY2],CarreraI[SCZ2]);}
case 3:{SetPlayerPos(playerid,CarreraI[SCX3],CarreraI[SCY3],CarreraI[SCZ3]);}
case 4:{SetPlayerPos(playerid,CarreraI[SCX4],CarreraI[SCY4],CarreraI[SCZ4]);}
case 5:{SetPlayerPos(playerid,CarreraI[SCX5],CarreraI[SCY5],CarreraI[SCZ5]);}
case 6:{SetPlayerPos(playerid,CarreraI[SCX6],CarreraI[SCY6],CarreraI[SCZ6]);}
case 7:{SetPlayerPos(playerid,CarreraI[SCX7],CarreraI[SCY7],CarreraI[SCZ7]);}
case 8:{SetPlayerPos(playerid,CarreraI[SCX8],CarreraI[SCY8],CarreraI[SCZ8]);}
case 9:{SetPlayerPos(playerid,CarreraI[SCX9],CarreraI[SCY9],CarreraI[SCZ9]);}
case 10..99:{SCM(playerid,red,"[ERROR]: {FFFFFF}La carrera está llena!");return 1;}
}
new string[100];
format(string,sizeof(string),"[CARRERA]: {FFFFFF}%s ingresó a la carrera %s. {00FF00}[%d/9]",pName(playerid),CarreraI[CA],posiciones);
SendClientMessageToAll(green,string);
ECarrera[playerid] = 1;
SetPlayerFacingAngle(playerid,90);
TogglePlayerControllable(playerid,false);
if(TieneAuto[playerid] > 0){DestroyVehicle(TieneAuto[playerid]);}
return 1;
}

CMD:ccasa(playerid,params[])
{
    if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    if(Usuario[playerid][pAdmin] < 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos para usar el comando.");
	new p,interior,nombre[55], Float:x,Float:y,Float:z,string[215];
	if(sscanf(params, "is[55]d", p,nombre,interior))
	{
	SendClientMessage(playerid, -1, "Utilice: /ccasa [Precio] [Nombre] [Interior]");
	return 1;
	}
	if(interior <= 0 || interior >= 9) return SendClientMessage(playerid,-1,"Los interiores disponibles son del 1 al 8. Mira {00FF00}/ayuda casas{FFFFFF}.");
	PropiedadesC++;
	PropInfo[PropiedadesC][PropID] = PropiedadesC;
	GetPlayerPos(playerid,x,y,z);
	PropInfo[PropiedadesC][PropX] = x;
	PropInfo[PropiedadesC][PropY] = y;
	PropInfo[PropiedadesC][PropZ] = z;
	PropInfo[PropiedadesC][PropValue] = p;
	PropInfo[PropiedadesC][PropEarning] = p/9;
	PropInfo[PropiedadesC][PropIsBought] = 0;
	PropInfo[PropiedadesC][PropM] = PropiedadesC;
	PropInfo[PropiedadesC][PropO] = 0;
	PropInfo[PropiedadesC][PickupNr] = CreatePickup(1273, 1, PropInfo[PropiedadesC][PropX], PropInfo[PropiedadesC][PropY], PropInfo[PropiedadesC][PropZ]);
	format(string,sizeof(string),"Casa [{00FF00}EN VENTA{FFFFFF}]\nDueño: {00FF00}N/A{FFFFFF}.\nValor: {00FF00}$%d{FFFFFF}\nGastos: {00FF00}$%d{FFFFFF}\nUsa {00FF00}/comprar casa{FFFFFF} para adquirirla.",PropInfo[PropiedadesC][PropValue],(PropInfo[PropiedadesC][PropValue]/10));
	PropInfo[PropiedadesC][Texto] = Create3DTextLabel(string, 0xFFFFFFFF, PropInfo[PropiedadesC][PropX], PropInfo[PropiedadesC][PropY], PropInfo[PropiedadesC][PropZ], 15.0, 0, 0);
  	new gfile[100];
	format(gfile, sizeof(gfile), DIRECCION, PropiedadesC);
	dini_Create(gfile);
  	format(PropInfo[PropiedadesC][PropName], 64, "%s", nombre);
  	format(PropInfo[PropiedadesC][PropOwner], MAX_PLAYER_NAME, "En venta");
	dini_Set(gfile, "Propiedad", PropInfo[PropiedadesC][PropName]);
    dini_Set(gfile, "Propietario", PropInfo[PropiedadesC][PropOwner]);
	dini_FloatSet(gfile, "PosX", PropInfo[PropiedadesC][PropX]);
	dini_FloatSet(gfile, "PosY", PropInfo[PropiedadesC][PropY]);
	dini_FloatSet(gfile, "PosZ", PropInfo[PropiedadesC][PropZ]);
	dini_IntSet(gfile, "PropValor", PropInfo[PropiedadesC][PropValue]);
	dini_IntSet(gfile, "PropGastos", PropInfo[PropiedadesC][PropEarning]);
	dini_IntSet(gfile, "PropVenta", PropInfo[PropiedadesC][PropIsBought]);
    dini_IntSet(gfile, "PropMundo", PropInfo[PropiedadesC][PropM]);
    dini_IntSet(gfile, "PropO", PropInfo[PropiedadesC][PropO]);
    MapIconStreamer();
	if(interior == 1)
	{
	PropInfo[PropiedadesC][PropEX] = 2495.95;
	PropInfo[PropiedadesC][PropEY] = -1692.19;
	PropInfo[PropiedadesC][PropEZ] = 1014.74;
	PropInfo[PropiedadesC][PropI] = 3;
	dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	if(interior == 2)
	{
	PropInfo[PropiedadesC][PropEX] = 1260.75;
	PropInfo[PropiedadesC][PropEY] = -785.21;
	PropInfo[PropiedadesC][PropEZ] = 1091.90;
	PropInfo[PropiedadesC][PropI] = 5;
	dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	if(interior == 3)
	{
	PropInfo[PropiedadesC][PropEX] = 2468.67;
	PropInfo[PropiedadesC][PropEY] = -1698.31;
	PropInfo[PropiedadesC][PropEZ] = 1013.50;
	PropInfo[PropiedadesC][PropI] = 2;
	dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	if(interior == 4)
	{
	PropInfo[PropiedadesC][PropEX] = 446.63;
	PropInfo[PropiedadesC][PropEY] = 506.42;
	PropInfo[PropiedadesC][PropEZ] = 1001.41;
	PropInfo[PropiedadesC][PropI] = 12;
	dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	if(interior == 5)
	{
	PropInfo[PropiedadesC][PropEX] = 2807.54;
	PropInfo[PropiedadesC][PropEY] = -1174.75;
	PropInfo[PropiedadesC][PropEZ] = 1025.57;
	PropInfo[PropiedadesC][PropI] = 8;
	dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	if(interior == 6)
	{
	PropInfo[PropiedadesC][PropEX] = 2352.93;
	PropInfo[PropiedadesC][PropEY] = -1180.92;
	PropInfo[PropiedadesC][PropEZ] = 1027.97;
	PropInfo[PropiedadesC][PropI] = 5;
	dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	if(interior == 7)
	{
	PropInfo[PropiedadesC][PropEX] = 318.58;
	PropInfo[PropiedadesC][PropEY] = 1114.48;
	PropInfo[PropiedadesC][PropEZ] = 1083.88;
	PropInfo[PropiedadesC][PropI] = 5;
	dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	if(interior == 8)
	{
	PropInfo[PropiedadesC][PropEX] = 2324.35;
	PropInfo[PropiedadesC][PropEY] = -1149.54;
	PropInfo[PropiedadesC][PropEZ] = 1050.71;
	PropInfo[PropiedadesC][PropI] = 12;
	dini_FloatSet(gfile, "PosEX",PropInfo[PropiedadesC][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[PropiedadesC][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[PropiedadesC][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[PropiedadesC][PropI]);
	}
	PropInfo[PropiedadesC][PropS] = Create3DTextLabel("Usa {0000FF}/salir{FFFFFF} para abandonar el lugar.", 0xFFFFFFFF, PropInfo[PropiedadesC][PropEX], PropInfo[PropiedadesC][PropEY], PropInfo[PropiedadesC][PropEZ], 7.0, PropInfo[PropiedadesC][PropM], 0);
 	return 1;
}

CMD:salir(playerid,params[])
{
new propid = Info[playerid];
if(IsPlayerInRangeOfPoint(playerid,8.0,PropInfo[propid][PropEX],PropInfo[propid][PropEY],PropInfo[propid][PropEZ]))
{
SetPlayerPos(playerid,PropInfo[propid][PropX],PropInfo[propid][PropY],PropInfo[propid][PropZ]);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid,0);
Info[playerid] = 0;
return 1;
} else SendClientMessage(playerid,0xFF0000AA,"[ERROR]: {FFFFFF}No estás cerca de ninguna salida.");
return 1;
}


CMD:comandos(playerid,params[])
{
    if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
    if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda");
    return 1;
}

CMD:reglas(playerid,params[])
{
new string[780];
strcat(string, "{00FF00}Reglas del servidor");
strcat(string, "\n{00FF00}* 1.{FFFFFF} No se permite la utilización de Cheats|Hacks que den ventaja.");
strcat(string, "\n{00FF00}* 2.{FFFFFF} No se permite pedir lvl administrativo y/o VIP.");
strcat(string, "\n{00FF00}* 3.{FFFFFF} No se permite nombrar servidores & páginas externas a RL.");
strcat(string, "\n{00FF00}* 4.{FFFFFF} No se permite la publicación y/o mención de IPS externas a RL.");
strcat(string, "\n{00FF00}* 5.{FFFFFF} No realizar SPAWNKILL|CARKILL.");
strcat(string, "\n{00FF00}* 6.{FFFFFF} No matar en eventos si un admin no lo autoriza.");
strcat(string, "\n{00FF00}* 7.{FFFFFF} No pedir dinero o nivel de usuario.");
ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{0000FF}|| Reglas ||",string,"Aceptar", "");
return 1;
}

CMD:cmdsvip(playerid,params[])
{
    if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
	ShowPlayerDialog(playerid,250,DIALOG_STYLE_LIST,"|| Comandos VIP ||","{FFFFFF}Bronce\nPlata\nOro\nElite\nDios\nSupremo","Aceptar","Cancelar");
	return 1;
}

CMD:desbloquear(playerid,params[])
{
    if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
	if(Bloqueado[playerid] == 0) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Ya estás desbloqueado!");
	Bloqueado[playerid] = 0;
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Te desbloqueaste con éxito.");
	return 1;
}

CMD:bloquear(playerid,params[])
{
    if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
	if(Bloqueado[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Ya estás bloqueado!");
	Bloqueado[playerid] = 1;
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Te bloqueaste con éxito.");
	return 1;
}

CMD:ir(playerid,params[])
{
new id;
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(sscanf(params,"d",id)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Debes usar /ir {00FF00}[ID]{FFFFFF}.");
if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El usuario no está conectado.");
if(ECarrera[id] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}El usuario está en una carrera!");
if(playerid == id) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}La ID ingresada es la tuya!");
if(Bloqueado[id] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El usuario está bloqueado.");
if(Minijuego[id] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El usuario está en un minijuego.");
if(Desmadre[id] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El usuario está en un minijuego.");
new Float:SX,Float:SY,Float:SZ,interior,mv;
GetPlayerPos(id,SX,SY,SZ);
interior = GetPlayerInterior(id);
mv = GetPlayerVirtualWorld(id);
SetPlayerPos(playerid,SX,SY,SZ);
SetPlayerInterior(playerid,interior);
SetPlayerVirtualWorld(playerid,mv);
return 1;
}


CMD:ayuda(playerid,params[])
{
	if(strcmp(params,"generales",true) == 0)
	{
	new string[880];
	strcat(string, "{FFFFFF}Las casas puedes encontrarlas por todo S.A:");
	strcat(string, "\n{00FF00}* /gay: {FFFFFF}Te declaras el más gay del sv.");
	strcat(string, "\n{00FF00}* /lol: {FFFFFF}Para reírte!");
	strcat(string, "\n{00FF00}* /cmdsvip: {FFFFFF}Mirás los comandos de los VIP.");
	strcat(string, "\n{00FF00}* /hola: {FFFFFF}Saludas a los usuarios del sv.");
	strcat(string, "\n{00FF00}* /adios: {FFFFFF}Te despides del servidor.");
	strcat(string, "\n{00FF00}* /aevento: {FFFFFF}Abandonas un evento.");
	strcat(string, "\n{00FF00}* /eusers: {FFFFFF}Miras los user's de un evento.");
	strcat(string, "\n{00FF00}* /top: {FFFFFF}TOP de usuarios.");
	strcat(string, "\n{00FF00}* /ricos: {FFFFFF}Lista de los ricos.");
    strcat(string, "\n{00FF00}* /bloquear: {FFFFFF}Para bloquearte y que no vayana  tu ID.");
    strcat(string, "\n{00FF00}* /desbloquear: {FFFFFF}Para que puedan ir a vos.");
    strcat(string, "\n{00FF00}* /ir: {FFFFFF}Vas a la ID de un usuario.");
    strcat(string, "\n{00FF00}* /reloguear: {FFFFFF}Relogueas en el servidor sin salir.");
    strcat(string, "\n{00FF00}* /reportar: {FFFFFF}Reportas a un cheater u otra cosa.");
    strcat(string, "\n{00FF00}* /dardinero: {FFFFFF}Das dinero a un usuario.");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| Generales ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}

	if(strcmp(params,"casas",true) == 0)
	{
	new string[780];
	strcat(string, "{FFFFFF}Información sobre las casas:");
	strcat(string, "\nLas casas te quitarán cada 20 minutos un proporcional que es así.");
	strcat(string, "\nTe quitará el precio de la casa dividido en {00FF00}10{FFFFFF}.");
	strcat(string, "\nSi la casa vale {00FF00}$1.000{FFFFFF}. Te quitará {00FF00}$100{FFFFFF} cada 20 minutos.");
	strcat(string, "\nUsa {00FF00}/entrar{FFFFFF} para poder ingresar a las casas y {00FF00}/salir{FFFFFF} para egresar de ella.");
	strcat(string, "\nTodas las casas tienen interiores diferentes, hay en total {00FF00}8{FFFFFF} interiores diferentes.");
	strcat(string, "\nPedidos de casas a dueños o admins rangos altos.");
	strcat(string, "\nTambién puedes pedir cambio de interior por si no te gusta la de tu casa actual.");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| Casas ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}
	
	if(strcmp(params,"teles",true) == 0)
	{
	ShowPlayerDialog(playerid,120,DIALOG_STYLE_LIST,"|| Teles ||","{FFFFFF}Los Santos\nLas Venturas\nSan Fierro\nPuente\nBosque\nVista\nTorre\nLiberty City\nDrift\nAero Abandonado\nChilliad\nAls\nAlv\nAsf\nStunt\n{00FF00}>>JUEGOS<<","Aceptar","Cancelar");
	return 1;
	}
	

	if(strcmp(params,"restaurantes",true) == 0)
	{
	new string[780];
	strcat(string, "{FFFFFF}Los restaurantes puedes encontrarlos por todo S.A:");
	strcat(string, "\nLos restaurantes te darán ganancia cada 20 minutos un proporcional que es así.");
	strcat(string, "\nTe dará el precio de él dividido en {00FF00}4{FFFFFF}.");
	strcat(string, "\nSi el restaurante vale {00FF00}$1.000{FFFFFF}. Te dará {00FF00}$250{FFFFFF} cada 20 minutos.");
	strcat(string, "\nUsa {00FF00}/entrar{FFFFFF} para poder ingresar a los restaurantes y {00FF00}/salir{FFFFFF} para egresar de ellos.");
	strcat(string, "\nTodos los restaurantes tienen interiores diferentes, hay en total {00FF00}5{FFFFFF} interiores diferentes.");
	strcat(string, "\nPedidos de restaurantes a dueños o admins rangos altos.");
	strcat(string, "\nTambién puedes pedir cambio de interior por si no te gusta la de tu restaurante actual.");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| Restaurantes ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}
	
	if(strcmp(params,"nivel",true) == 0)
	{
	new string[450];
	strcat(string, "{FFFFFF}El nivel subirá automáticamente cada 10 minutos de juego.");
	strcat(string, "\nSe te irá asignando +1 nivel y +$200 cada 10 minutos que juegues aparte de un extra random.");
	strcat(string, "\nEn los extras random entran: - $2000 - $1000 - $1500 - 15 AmmoPack's - +1 nivel extra - ");
	strcat(string, "\nRecuerda que también hay sorpresas si llegas a niveles altos como 100, 150, 200, etc.");
	strcat(string, "\nTambién al ser nivel mayor luego tendrás mayores accesos a cosas únicas como propiedades, etc.");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| Nivel ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}
	
	if(strcmp(params,"armas",true) == 0)
	{
	new string[446];
	strcat(string, "{FFFFFF}Las armas puedes conseguirlas con el comando {00FF00}/armas{FFFFFF}.");
	strcat(string, "\nEn armas sueltas encontrarás armas blancas y la bomba por control.");
	strcat(string, "\nAhí te da toda la información de cuanto vale cada arma, munición y demás.");
	strcat(string, "\nLos packs, al seleccionarlos, primero saltará un cuadro donde explicará sus armas, municiones y precio total.");
	strcat(string, "\nTe dará la opción de comprar el pack o simplemente salir. También puedes comprar las armas por separado.");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| Armas ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}
	

	if(strcmp(params,"ccasas",true) == 0)
	{
	if(Usuario[playerid][pAdmin] < 1) return CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda");
	new string[780];
	strcat(string, "{FFFFFF}Las casas al crearlas tiene diferentes interiores:");
	strcat(string, "\nInterior número {00FF00}1{FFFFFF}: Casa de CJ.");
	strcat(string, "\nInterior número {00FF00}2{FFFFFF}: Mansion Madd Dogg.");
	strcat(string, "\nInterior número {00FF00}3{FFFFFF}: Casa de Ryder.");
	strcat(string, "\nInterior número {00FF00}4{FFFFFF}: Departamento pequeño.");
	strcat(string, "\nInterior número {00FF00}5{FFFFFF}: Casa grande. [CORONEL]");
	strcat(string, "\nInterior número {00FF00}6{FFFFFF}: Casa grande.");
	strcat(string, "\nInterior número {00FF00}7{FFFFFF}: Departamento mediano.");
	strcat(string, "\nInterior número {00FF00}8{FFFFFF}: Departamento grande.");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| Casas ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}
	
	if(strcmp(params,"crestaurantes",true) == 0)
	{
	if(Usuario[playerid][pAdmin] < 1) return CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda");
	new string[380];
	strcat(string, "{FFFFFF}Lo restaurantes al crearlos tiene diferentes interiores:");
	strcat(string, "\nInterior número {00FF00}1{FFFFFF}: Burguer Shot.");
	strcat(string, "\nInterior número {00FF00}2{FFFFFF}: Cluckin Bell");
	strcat(string, "\nInterior número {00FF00}3{FFFFFF}: The Well Stacked Pizza.");
	strcat(string, "\nInterior número {00FF00}4{FFFFFF}: Ring Donuts.");
	strcat(string, "\nInterior número {00FF00}5{FFFFFF}: Restaurante grande.");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| Restaurantes ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}
	
	if(strcmp(params,"autos",true) == 0)
	{
	new string[380];
	strcat(string, "{FFFFFF}Los vehículos puedes encontrarlos o spawnearlos:");
	strcat(string, "\nUtiliza el comando {00FF00}/autos{FFFFFF} para abrir el diálogo de selección de autos.");
	strcat(string, "\nLuego elige la categoría como {00FF00}\"Autos Rápidos\"{FFFFFF}.");
	strcat(string, "\nSelecciona uno de los vehículos (por nombre) que aparecen en las opciones.");
	strcat(string, "\nUtiliza la tecla {00FF00}N{FFFFFF} para repararlo. {0000FF}($500)");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| Autos ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}
	
	if(strcmp(params,"Ammopacks",true) == 0)
	{
	new string[870];
	strcat(string, "{FFFFFF}Información sobre los AmmoPacks:");
	strcat(string, "\nLos AmmoPacks son 'puntos' o 'créditos' los cuales puedes utilizar para comprar armas únicas.");
	strcat(string, "\nSe consiguen haciendo/realizando/matando por HEADSHOT a los usuarios. cada matanza por HEADSHOT te subirá +1 AmmoPack.");
	strcat(string, "\nTipos de armas: {00FF00}C4 APOCALÍPTICO. [EXPLOSIÓN MASIVA]");
	strcat(string, "\n{FFFFFF}-{00FF00} HS ROCKET [5 DISPAROS]{FFFFFF}.");
	strcat(string, "\n{FFFFFF}-{00FF00} RapidSpeed [10 SEGUNDOS]{FFFFFF}. Te hará correr súper rápido por 10 segundos.");
	strcat(string, "\n{FFFFFF}-{00FF00} SniperKill [20 DISPAROS]{FFFFFF}. Sniper única del servidor para matar de un disparo.");
    strcat(string, "\n{FFFFFF}-{00FF00} MachineGun [85 DISPAROS]{FFFFFF}.");
    strcat(string, "\n{FFFFFF}-{00FF00} GRANADAS [5 DISPAROS]{FFFFFF}. Son las granadas normales.");
    strcat(string, "\n{FFFFFF}-{00FF00} CHALECO [100 ARMOUR]{FFFFFF}. Te llena tu chaleco.");
    strcat(string, "\n{FFFFFF}Utiliza {00FF00}/tienda{FFFFFF} para poder acceder al mercado de ventas de éstas armas.");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| AmmoPacks ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}
	
	
	if(strcmp(params,"modos",true) == 0)
	{
	new string[670];
	strcat(string, "{FFFFFF}Información sobre los modos del servidor:");
	strcat(string, "\n{00FF00}* Freeroam: {FFFFFF}Modo de juego libre por todo S.A, parkour, drift, etc.");
	strcat(string, "\n{00FF00}* DeathMatch: {FFFFFF}Se te llevará a una arena que desees con armas determinadas para sólo matar.");
	strcat(string, "\n{00FF00}* Carreras: {FFFFFF}Modo de juego único para poder ingresar a las automáticamente y poder practicar.");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| Modos ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}
	
	
	if(strcmp(params,"cuenta",true) == 0)
	{
	new string[670];
	strcat(string, "{FFFFFF}Información sobre las cuentas del servidor:");
	strcat(string, "\nAl ingresar al servidor automáticamente saltará el ingreso/registro.");
	strcat(string, "\nAl registrarte te pedirá un correo, debe ser real para no tener problemas al cambiar correo/nombre.");
	strcat(string, "\nLos comandos de las cuentas son:");
	strcat(string, "\n{00FF00}* /cambiar contraseña{FFFFFF}: Es para cambiar tu contraseña, recuerda tener cuidado de ver bien cual ponés.");
	strcat(string, "\n{00FF00}* /cambiar nombre{FFFFFF}: Es para cambiar tu nombre, recuerda que también debes tener cuidado con esta función.");
    strcat(string, "\n{00FF00}* /stats{FFFFFF}: Podrás mirar todas tus estadísticas de tu cuenta.");
    strcat(string, "\n{00FF00}* /panel{FFFFFF}: Podrás mirar el panel de tu cuenta y editarlo.");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| Cuenta ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}
	
	if(strcmp(params,"vip",true) == 0)
	{
	new string[370];
	strcat(string, "{FFFFFF}Información sobre los VIPS:");
	strcat(string, "\n* {3C3214}VIP BRONCE{FFFFFF}: Se obtiene con 1.000 de SCORE.");
	strcat(string, "\n* {C3D5DF}VIP PLATA{FFFFFF}: Se obtiene con 5.000 de SCORE.");
	strcat(string, "\n* {DFC418}VIP ORO{FFFFFF}: Se obtiene con 10.000 de SCORE.");
 	strcat(string, "\n* {209193}VIP ELITE{FFFFFF}: Se obtiene con 20.000 de SCORE.");
	strcat(string, "\n* {0C242E}VIP DIOS{FFFFFF}: No a la venta.");
    strcat(string, "\n* {00FF00}VIP SUPREMO{FFFFFF}: No a la venta.");
	ShowPlayerDialog(playerid, 110, DIALOG_STYLE_MSGBOX, "{FFFFFF}|| VIP'S ||",string,"Comandos", "Cerrar");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}

	if(strcmp(params,"musica",true) == 0)
	{
	new string[670];
	strcat(string, "{FFFFFF}Información sobre la música:");
	strcat(string, "\n{FFFFFF}La música se activa con {00FF00}/musica{FFFFFF}, el link que te pedirá debe ser mp3.");
	strcat(string, "\nPara obtener el link mp3 primero iremos al vídeo/música que querramos en youtube para copiar su URL.");
	strcat(string, "\nLuego vamos a offliberty.com y pegamos el URL del vídeo en el cuadro negro, apretaremos el botón que hay ahí.");
 	strcat(string, "\nDespués de convertirse aparecerá un cuadro amarillo, click derecho y copiar dirección de enlace.");
	strcat(string, "\nLuego al poner {00FF00}/musica{FFFFFF} pegan ese link con CTRL + V y la música empezará correctamente.");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{00FF00}|| Música ||",string,"Aceptar", "");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}

	if(strcmp(params,"colores",true) == 0)
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/colores");
	return 1;
	}
	
	if(strcmp(params,"admin",true) == 0)
	{
	if(Usuario[playerid][pAdmin] < 1) return CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda");
	ShowPlayerDialog(playerid, 55, DIALOG_STYLE_LIST, "{FFFFFF}|| Administración ||","{FFFFFF}Nivel 1\nNivel 2\nNivel 3\nNivel 4\nNivel 5\nNivel 6\nNivel 7\nNivel 8\nNivel 9\nNivel 10","Seleccionar", "Cancelar");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
	}
	
	ShowPlayerDialog(playerid,71,DIALOG_STYLE_LIST,"{FFFFFF}|| Ayuda ||","{0000FF}*{FFFFFF} AmmoPack's\n{0000FF}*{FFFFFF} Vehículos\n{0000FF}*{FFFFFF} Armas\n{0000FF}*{FFFFFF} Nivel\n{0000FF}*{FFFFFF} Casas\n{0000FF}*{FFFFFF} Restaurantes\n{0000FF}*{FFFFFF} Cuenta\n{0000FF}*{FFFFFF} Colores\n{0000FF}*{FFFFFF} VIP\n{0000FF}*{FFFFFF} Climas\n{0000FF}*{FFFFFF} General\n{0000FF}*{FFFFFF} Música\n{0000FF}* {FFFFFF}Minijuegos\n{0000FF}* {FFFFFF}Modos","Seleccionar","Cancelar");

	return 1;
}

CMD:teles(playerid,params[])
{
if(Usuario[playerid][Modo] == 3) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando en este modo!");
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
ShowPlayerDialog(playerid,120,DIALOG_STYLE_LIST,"|| Teles ||","{FFFFFF}Los Santos\nLas Venturas\nSan Fierro\nPuente\nBosque\nVista\nTorre\nLiberty City\nDrift\nAero Abandonado\nChilliad\nAls\nAlv\nAsf\nStunt\n{00FF00}>>JUEGOS<<","Aceptar","Cancelar");
return 1;
}


CMD:tienda(playerid,params[])
{
if(Usuario[playerid][Modo] == 3) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando en este modo!");
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
ShowPlayerDialog(playerid,56,DIALOG_STYLE_TABLIST_HEADERS,"Tienda",
"Tipo\n\
Armas normales\n\
Armas por AmmoPacks\n\
Canjear puntos",
"Seleccionar", "Cancelar");
return 1;
}


CMD:entrar(playerid,params[])
{
new propid = IsPlayerNearProperty(playerid);
if(propid == -1)
{
SendClientMessage(playerid, 0xFF0000AA, "[ERROR]: {FFFFFF}No estás en ninguna entrada.");
return 1;
}
TogglePlayerControllable(playerid,false);
SetTimerEx("Descongelar",3000,false,"d",playerid);
GameTextForPlayer(playerid, "~b~Cargando~n~~w~Espera un momento...", 3000, 3);
SetPlayerPos(playerid,PropInfo[propid][PropEX],PropInfo[propid][PropEY],PropInfo[propid][PropEZ]);
SetPlayerInterior(playerid,PropInfo[propid][PropI]);
SetPlayerVirtualWorld(playerid,PropInfo[propid][PropM]);
Info[playerid] = propid;
return 1;
}


CMD:objetos(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
        new string[128];
        new dialog[500];
        for(new x;x<MAX_OSLOTS;x++)
        {
        if(IsPlayerAttachedObjectSlotUsed(playerid, x)){format(string, sizeof(string), ""COL_WHITE"Slot:%d :: "COL_GREEN"Slot Usado\n", x);}
        else format(string, sizeof(string), ""COL_WHITE"Slot:%d\n", x);
        strcat(dialog,string);
        }
        ShowPlayerDialog(playerid, DIALOG_ATTACH_INDEX_SELECTION, DIALOG_STYLE_LIST,"Objetos de usuario:", dialog, "Aceptar", "Cerrar");
        return 1;
}
CMD:prendas(playerid,params[])
{
        return cmd_objetos(playerid,params);
}
CMD:items(playerid,params[])
{
        return cmd_objetos(playerid,params);
}


CMD:als(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
new Float:health;
GetPlayerHealth(playerid, health);
if(health > 70)
{
SetPlayerPos(playerid, 1543.5593,-2608.6963,13.5469);
SetPlayerInterior(playerid, 0);
EnviarComandoTele(playerid,"als");
SetPlayerVirtualWorld(playerid, 0);
}
else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}

CMD:alv(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
new Float:health;
GetPlayerHealth(playerid, health);
if(health > 70)
{
SetPlayerPos(playerid, 1315.3776,1263.9053,10.8203);
SetPlayerInterior(playerid, 0);
EnviarComandoTele(playerid,"alv");
SetPlayerVirtualWorld(playerid, 0);
}
else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}

CMD:asf(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
new Float:health;
GetPlayerHealth(playerid, health);
if(health > 70)
{
SetPlayerPos(playerid, -1439.9902,-117.8820,14.1484);
SetPlayerInterior(playerid, 0);
EnviarComandoTele(playerid,"asf");
SetPlayerVirtualWorld(playerid, 0);
} else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}

CMD:aerosf(playerid,params[])
{
    CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/asf");
    return 1;
}

CMD:aerols(playerid,params[])
{
    CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/als");
    return 1;
}

CMD:aerolv(playerid,params[])
{
    CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/alv");
    return 1;
}


CMD:lv(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
new Float:health;
		GetPlayerHealth(playerid, health);
		if(health > 70)
		{
		SetPlayerPos(playerid, 2021.1387,1342.9297,10.8130);
		EnviarComandoTele(playerid,"Lv");
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "Bienvenido a Las Venturas!");
		GameTextForPlayer(playerid,"~b~Bienvenido a ~n~~g~Las Venturas",4000,3);
		SetPlayerTime(playerid,12,0);
		}
		else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}



CMD:dominar(playerid,params[])
{
if(PlayerGang[playerid] == 0) return SCM(playerid,red,"[ERROR]: {FFFFFF}No eres miembro de un clan!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerLider[playerid] == 0 && Usuario[playerid][Eslider] == 0) return SCM(playerid,red,"[ERROR]: {FFFFFF}Necesitas ser líder o sub-líder.");
new id,id2;
if(sscanf(params,"dd",id,id2)) return SCM(playerid,red,"[ERROR]: {FFFFFF}Usa /dominar [ID MIEMBRO] [ID MIEMBRO 2]");
if(id == playerid || id == id2 || id2 == playerid || id2 == id) return SCM(playerid,red,"[ERROR]: {FFFFFF}Las ID's ingresadas son inválidas.");
if(IsPlayerConnected(id) && IsPlayerConnected(id2))
{
if(PlayerGang[id] != PlayerGang[playerid] || PlayerGang[id2] != PlayerGang[playerid] || PlayerGang[id] != PlayerGang[id2] || PlayerGang[id2] != PlayerGang[id]) return SCM(playerid,red,"[ERROR]: {FFFFFF}Una de las ID's ingresadas no son del mismo clan.");
for(new i;i<Zonas;i++)
{
if(IsPlayerInArea(playerid,ZonaInfo[i][ZPosX],ZonaInfo[i][ZPosY],ZonaInfo[i][Pos2X],ZonaInfo[i][Pos2Y]) && IsPlayerInArea(id,ZonaInfo[i][ZPosX],ZonaInfo[i][ZPosY],ZonaInfo[i][Pos2X],ZonaInfo[i][Pos2Y]) && IsPlayerInArea(id2,ZonaInfo[i][ZPosX],ZonaInfo[i][ZPosY],ZonaInfo[i][Pos2X],ZonaInfo[i][Pos2Y]))
{
GangZoneFlashForAll(i,GangInfo[PlayerGang[playerid]][GANG_COLOR]);
}
Capturando = SetTimerEx("Cuenta",1000,true,"ddd",playerid,id,id2);
new string[82];
format(string,sizeof(string),"[CLAN]: {FFFFFF}Estás atacando una zona junto al líder %s! [30 segundos]",pName(playerid));
SCM(id,orange,string);
SCM(id2,orange,string);
SCM(playerid,green,"[ATAQUE]: {FFFFFF}Recuerda mantenerte dentro de la zona [30 segundos] para capturarla junto a tus otros dos miembros.");
}
}
return 1;
}


CMD:clan(playerid, params[])
{
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
new chota1[470];
new tmp[256];
new tmp2[256];
new Index21;
tmp = strtok(params,Index21),
tmp2 = strtok(params,Index21);
strcat(chota1, "{0700D7}» {FFFFFF}/clan crear [Creas un clan].\n");
strcat(chota1, "{0700D7}» {FFFFFF}/clan darlider [Das líder a un usuario]\n");
strcat(chota1, "{0700D7}» {FFFFFF}/clan quitarlider [Quitas líder a un usuario]\n");
strcat(chota1, "{0700D7}» {FFFFFF}/csay [Hablas por el chat resaltado (Sólo para reclutar)]\n");
strcat(chota1, "{0700D7}» {FFFFFF}/clan expulsar [Expulsas a un usuario de tu clan]\n");
strcat(chota1, "{0700D7}» {FFFFFF}/clan invitar [Invitas a un usuario a tu clan]\n");
strcat(chota1, "{0700D7}» {FFFFFF}/clan stats [Miras los stats de tu clan]\n");
strcat(chota1, "{0700D7}» {FFFFFF}/clan salir [Sales de tu clan]\n");
strcat(chota1, "{0700D7}» {FFFFFF}/clan miembros [Miras los miembros conectados]\n");
strcat(chota1, "{0700D7}» {FFFFFF}/clan radar [Miras a los de tu clan en el radar]\n");
strcat(chota1, "{0700D7}» {FFFFFF}/clan color [Cambias el color del chat de tu clan]\n");
//strcat(chota1, "{0700D7}» {FFFFFF}/clanes [Miras la ligas de clanes]\n");
//strcat(chota1, "{0700D7}» {FFFFFF}/clanes info [Miras la info de ligas de clanes]");
if(!strlen(tmp)) return ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{0000FF}|| Comandos de Clanes ||",chota1,"Aceptar", "");
//---- Creazone Gang
if(strcmp(tmp, "crear", true) == 0)
{
if(!strlen(tmp2)) return SendClientMessage(playerid, red, "USE:{FFFFFF} /Clan Crear [NOMBRE]");
if(PlayerGang[playerid] == 1 || Usuario[playerid][Eslider] == 1) return SendClientMessage(playerid, red, "¡Error!: {FFFFFF}Ya Tienes Clan! Usa Para Salir /Clan Salir");
if(GetPlayerMoney(playerid) < 500000) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes el dinero necesario. ($500.000)");
if(GetPlayerScore(playerid) < 1000) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes el score necesario. (1000 de score)");
if(strlen(tmp2) < 2 || strlen(tmp2) > 5) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El nombre debe Ser De 2 a 5 Carácteres!");
if(!udb_Exists(pName(playerid))) return SendClientMessage(playerid, COLOR_GREEN, "[ERROR]: {FFFFFF}Usted debe estar registrado {0000FF}(/register)");
if(strfind(tmp2, "[", true) != -1 || strfind(tmp2, "]", true) != -1 || strfind(tmp2, "=", true) != -1 || strfind(tmp2, "(", true) != -1 || strfind(tmp2, ")", true) != -1 ) return SendClientMessage(playerid, red, "Sin '[' ']' (corchetes).");
if(IsValidName(tmp2))
{
new gangid = 0;
for(new i; i < GANG_NUMBER; i++)
{
new file[60];
format(file, sizeof(file), GANG_FILE, i);
if(dini_Exists(file))
{
new gname[15];
strcat(gname, dini_Get(file, "GANG_NAME"),15);
if(strfind(tmp2, gname, true) == 0)return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}¡Ya hay un clan con ese nombre!");
}
else if(!dini_Exists(file) && i != 0) gangid = i;
}
if(gangid == 0) {
		GANG_NUMBER++;
		gangid = GANG_NUMBER;
		}
		dini_IntSet(CFG,"GANG_NUMBER",GANG_NUMBER);
  		new gfile[100];
		format(gfile, sizeof(gfile), GANG_FILE, gangid);
		dini_Create(gfile);
  		format(GangInfo[gangid][GANG_NAME], sizeof(tmp2), "%s", tmp2);
		dini_Set(gfile, "GANG_NAME", GangInfo[gangid][GANG_NAME]);
		dini_IntSet(gfile, "GANG_ID", gangid);
		dini_IntSet(gfile,"GANG_MEMBERS",0);
		dini_IntSet(gfile,"GANG_SCORE",0);
		dini_IntSet(gfile,"COLOR",0xFFFFFFFF);
		GangInfo[gangid][GANG_ID] = gangid;
		GangInfo[gangid][GANG_MEMBERS] = 0;
		GangInfo[gangid][GANG_SCORE] = 0;
		GangInfo[gangid][GANG_COLOR] = 0xFFFFFFFF;
		new string2[100];
		format(string2, sizeof(string2), "[CLAN]: {FFFFFF}%s | ID: %d | ScoreClan %d |", GangInfo[gangid][GANG_NAME], GangInfo[gangid][GANG_ID], GangInfo[gangid][GANG_SCORE]);
  		SendClientMessage(playerid, red, string2);
		new name[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, name, sizeof(name));
	    dUserSetINT(pName(playerid)).("clan",gangid);
	    dUserSetINT(pName(playerid)).("lider",1);
	    PlayerLider[playerid] = 1;
        new stringeng[100];
	    PlayerGang[playerid] = gangid;
	    GangInfo[gangid][GANG_MEMBERS]++;
	    GangInfo[gangid][GANG_SCORE] = 0;
	    format(string2, sizeof(string2), "[CLAN]: %s | Miembros: %d", GangInfo[gangid][GANG_NAME], GangInfo[gangid][GANG_MEMBERS]);
	    SendClientMessage(playerid, COLOR_GREEN, string2);
	    format(stringeng, sizeof(stringeng), "[CLANES]:{FFFFFF} %s creó el clan %s.", name , GangInfo[gangid][GANG_NAME]);
	    SendClientMessageToAll(COLOR_GREEN, stringeng);
        SetPlayerColor(playerid, GangInfo[gangid][GANG_COLOR]);
	    SpawnPlayer(playerid);
     	dini_IntSet(gfile, "GANG_MEMBERS", GangInfo[gangid][GANG_MEMBERS]);
     	GuardarUsuario(playerid);
}
		return 1;
}
	//---- Invito
if(strcmp(tmp, "invitar", true) == 0)
	{
		if(!strlen(tmp2)) return SendClientMessage(playerid, red, "Usa /Clan Invitar [ID]");
		if(PlayerGang[playerid] == 0) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tú no tienes Clan!");
		if(PlayerLider[playerid] == 0 && Usuario[playerid][Eslider] == 0) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tú no eres el líder o Sublíder!");
		if(GangInfo[PlayerGang[playerid]][GANG_MEMBERS] > MAX_USERS)return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}El Clan Ya Está Lleno! (99 Users)");
		new id = strval(tmp2);
		if (id == playerid) return SendClientMessage(playerid,COLOR_ROJO,"[ERROR]: {FFFFFF}No puedes Invitarte a ti mismo al Clan.");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}ID Inválida");
		new name22[MAX_PLAYER_NAME];
		new name1[MAX_PLAYER_NAME];
        GetPlayerName(id, name22, sizeof(name22));
        GetPlayerName(playerid, name1, sizeof(name1));
		invited[id] = PlayerGang[playerid];
		new string2[120];
		if(PlayerGang[id] >= 1) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}El Player ya está en un Clan!");
		format(string2, sizeof(string2), "%s te invitó a su clan. Datos: Clan %s | ScoreClan %d | ID: %d |", name1, GangInfo[PlayerGang[playerid]][GANG_NAME],GangInfo[PlayerGang[playerid]][GANG_SCORE],GangInfo[PlayerGang[playerid]][GANG_ID]);
		ShowPlayerDialog(id, INVITAR, DIALOG_STYLE_MSGBOX, "{ffb800}|| Invitación de Clan ||", string2, "Aceptar", "Rechazar");
		format(string2, sizeof(string2), "[CLAN]: {FFFFFF}Invitaste a %s al clan.", name22);
		SendClientMessage(playerid, COLOR_ROJO, string2);
		return 1;
 }

	//---- Lasciare Gang
if(strcmp(tmp, "salir", true) == 0)
{
	new gangid = PlayerGang[playerid];
	if(PlayerGang[playerid] == 0) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}Tú No Tienes Clan!");
	dUserSetINT(pName(playerid)).("clan",0);
	dUserSetINT(pName(playerid)).("Lider2",0);
	dUserSetINT(pName(playerid)).("lider",0);
	PlayerGang[playerid] = 0;
	PlayerLider[playerid] = 0;
	Usuario[playerid][Eslider] = 0;
	invited[playerid] = 0;
	GangInfo[gangid][GANG_MEMBERS]--;
	LeaveGang(playerid, PlayerGang[playerid]);
	return 1;
}

if(strcmp(tmp, "darlider", true) == 0)
	{
		if(!strlen(tmp2)) return SendClientMessage(playerid, COLOR_ROJO, "Usa /Clan DarLider [ID]");
		if(PlayerGang[playerid] == 0) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}Tú No Tienes Clan!");
		if(PlayerLider[playerid] == 0) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}Tú No Eres el Lider!");
		if(GangInfo[PlayerGang[playerid]][GANG_MEMBERS] > MAX_USERS)return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}El Clan Ya Está Lleno! (500 Users)");
 		new id = strval(tmp2);
		if(id == playerid) return SendClientMessage(playerid,COLOR_ROJO,"[ERROR]: {FFFFFF}No puedes darte a ti mismo el Lider.");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}ID Inválida");
		if(PlayerGang[playerid] != PlayerGang[id]) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}El usuario no es de tu Clan!");
		if(Usuario[id][Eslider] == 1) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}El usuario ya tiene Lider!");
		if(PlayerLider[id] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}El usuario es líder creador del clan.");
	    Usuario[id][Eslider] = 1;
	    new string9[100];
        dUserSetINT(pName(id)).("Lider2",1);
        new string2[80];
		format(string2, sizeof(string2), "[CLAN]:{FFFFFF} %s te asignó líder del clan: %s.", pName(playerid), GangInfo[PlayerGang[playerid]][GANG_NAME]);
        SendClientMessage(id, COLOR_VERDE, "[CLAN]:{FFFFFF} Al ser lídes tendrás más poderes dentro del clan!");
		format(string9, sizeof(string9), "[CLAN]:{FFFFFF} Le diste líder del clan a: %s!", pName(id));
		SendClientMessage(id, COLOR_VERDE, string2);
		SendClientMessage(playerid, COLOR_VERDE, string9);
		GuardarUsuario(id);
		return 1;
	}

    if(strcmp(tmp, "quitarlider", true) == 0)
	{
 		if(PlayerLider[playerid] == 1)
 		{
		if(!strlen(tmp2)) return SendClientMessage(playerid, COLOR_ROJO, "Usa: /Clan quitarlider [ID]");
		if(PlayerGang[playerid] == 0)return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}Tú No Tienes Clan!");
		new id = strval(tmp2);
		if(PlayerLider[id] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes quitarle líder al creador!");
   		new string9[150];
		new name22[MAX_PLAYER_NAME];
		new name1[MAX_PLAYER_NAME];
        GetPlayerName(id, name22, sizeof(name22));
        GetPlayerName(playerid, name1, sizeof(name1));
   		if(id == playerid) return SendClientMessage(playerid,COLOR_ROJO,"[ERROR]: {FFFFFF}No puedes quitarte a ti mismo el Lider.");
		if(PlayerGang[playerid] != PlayerGang[id]) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}El usuario no es de tu Clan!");
		if(Usuario[id][Eslider] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes sacarle líder al creador del clan.");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}ID Inválida");
        new string2[80];
		format(string2, sizeof(string2), "[CLAN]: {FFFFFF}%s te removió de líder del clan %s!",name1, GangInfo[PlayerGang[playerid]][GANG_NAME]);
		SendClientMessage(id, COLOR_VERDE, string2);
		Usuario[id][Eslider] = 0;
		dUserSetINT(pName(id)).("Lider2",0);
		format(string9, sizeof(string9), "[CLAN]:{FFFFFF} Le has quitado el liderazgo del clan a %s!",  name22);
		SendClientMessage(playerid, COLOR_VERDE, string9);
		GuardarUsuario(id);
		} else return SendClientMessage(playerid, COLOR_RED, "[ERROR]: Tú No Eres el Lider!");
		return 1;
	}

if(strcmp(tmp, "expulsar", true) == 0)
	{
		if(!strlen(tmp2)) return SendClientMessage(playerid, COLOR_ROJO, "Usa /Clan Expulsar [ID]");
		if(PlayerGang[playerid] == 0)return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}Tú No Tienes Clan!");
		if(PlayerLider[playerid] == 0 && Usuario[playerid][Eslider] == 0) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}Tú No Eres el Lider!");
		new id = strval(tmp2);
		if(PlayerLider[id] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes expulsar al creador.");
		if(id == playerid) return SendClientMessage(playerid,COLOR_ROJO,"[ERROR]: {FFFFFF}No puedes expulsarte a ti mismo del clan!");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}ID Inválida");
		if(PlayerGang[playerid] != PlayerGang[id]) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}El usuario no es de tu Clan!");
		new name22[MAX_PLAYER_NAME];
		new name1[MAX_PLAYER_NAME];
        new gangid = PlayerGang[playerid];
        GetPlayerName(id, name22, sizeof(name22));
        GetPlayerName(playerid, name1, sizeof(name1));
		if(dUserINT(pName(id)).("clan") == gangid)
        {
        new string2[80];
  		format(string2, sizeof(string2), "[CLAN]:{FFFFFF} %s fue expulsado del clan %s", name22, GangInfo[PlayerGang[playerid]][GANG_NAME]);
		dUserSetINT(pName(id)).("clan",0);
		dUserSetINT(pName(id)).("Lider2",0);
		PlayerGang[id] = 0;
		Usuario[id][Eslider] = 0;
		invited[id] = 0;
		SetPlayerColor(id, RandomColors[id]);
		GangInfo[gangid][GANG_MEMBERS]--;
	    SpawnPlayer(id);
		format(string2, sizeof(string2), "[CLAN]: Tu expulsaste a %s de Tu Clan!", name22);
		SendClientMessage(playerid, COLOR_VERDE, string2);
		new gfile[100];
		format(gfile, sizeof(gfile), GANG_FILE, gangid);
		dini_IntSet(gfile, "GANG_MEMBERS", GangInfo[gangid][GANG_MEMBERS]);
		GuardarUsuario(id);
		}
		else return SendClientMessage(playerid, COLOR_ROJO,"[ERROR]: {FFFFFF}El player no esta en el Clan!");
		return 1;
	}

    if(strcmp(tmp, "color", true) == 0)
	{
        if(!strlen(tmp2))return SendClientMessage(playerid, red, "[USO]:{FFFFFF} /clan color [ID COLOR]") &&
	    SendClientMessage(playerid, yellow, "Colores: 0=blanco 1=negro 2=rojo 3=naranja 4=amarillo 5=verde 6=azul 7=purpura 8=marron 9=rosa");
		if(PlayerGang[playerid] == 0)return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}Tú no perteneces a ningún clan!");
		if(PlayerLider[playerid] == 0 && Usuario[playerid][Eslider] == 0) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}Tú No Eres el Lider!");
        new gangid = PlayerGang[playerid];
		new Colour = strval(tmp2);
		new colour2[50];
		if(Colour > 10) return SCM(playerid,red,"[ERROR]: {FFFFFF}Sólo colores del 0 al 10.");
        if(IsPlayerConnected(playerid) && PlayerLider[playerid] == 1)
		{
			for(new i = 0; i <= GANG_NUMBER; i++)
	        {
	        new file[60];
			format(file, sizeof(file), GANG_FILE, i);
			if(dini_Exists(file))
			{
			switch (Colour)
			{
			    case 0: { GangInfo[gangid][GANG_COLOR] = 0xFFFFFFFF; dini_IntSet(file, "COLOR", GangInfo[gangid][GANG_COLOR]); SetPlayerColor(playerid,0xFFFFFFFF); colour2 = "Blanco"; }
			    case 1: { GangInfo[gangid][GANG_COLOR] = 0x000000FF; dini_IntSet(file, "COLOR", GangInfo[gangid][GANG_COLOR]); SetPlayerColor(playerid,0x000000FF); colour2 = "Negro"; }
			    case 2: { GangInfo[gangid][GANG_COLOR] = 0xFF0000FF; dini_IntSet(file, "COLOR", GangInfo[gangid][GANG_COLOR]); SetPlayerColor(playerid,0xFF0000FF); colour2 = "Rojo"; }
			    case 3: { GangInfo[gangid][GANG_COLOR] = 0xFF7D00FF; dini_IntSet(file, "COLOR", GangInfo[gangid][GANG_COLOR]); SetPlayerColor(playerid,0xFF7D00FF); colour2 = "Naranja"; }
				case 4: { GangInfo[gangid][GANG_COLOR] = 0xFFFF00FF; dini_IntSet(file, "COLOR", GangInfo[gangid][GANG_COLOR]); SetPlayerColor(playerid,0xFFFF00FF); colour2 = "Amarillo"; }
				case 5: { GangInfo[gangid][GANG_COLOR] = 0x00CB38FF; dini_IntSet(file, "COLOR", GangInfo[gangid][GANG_COLOR]); SetPlayerColor(playerid,0x00CB38FF); colour2 = "Verde"; }
				case 6: { GangInfo[gangid][GANG_COLOR] = 0x0000FFFF; dini_IntSet(file, "COLOR", GangInfo[gangid][GANG_COLOR]); SetPlayerColor(playerid,0x0000FFFF); colour2 = "Azul"; }
				case 7: { GangInfo[gangid][GANG_COLOR] = 0x800080AA; dini_IntSet(file, "COLOR", GangInfo[gangid][GANG_COLOR]); SetPlayerColor(playerid,0x800080AA); colour2 = "Purpura"; }
				case 8: { GangInfo[gangid][GANG_COLOR] = 0xA52A2AAA; dini_IntSet(file, "COLOR", GangInfo[gangid][GANG_COLOR]); SetPlayerColor(playerid,0xA52A2AAA); colour2 = "Marron"; }
				case 9: { GangInfo[gangid][GANG_COLOR] = 0xFF00FFFF; dini_IntSet(file, "COLOR", GangInfo[gangid][GANG_COLOR]); SetPlayerColor(playerid,0xFF00FFFF); colour2 = "Rosa"; }
				case 10: { GangInfo[gangid][GANG_COLOR] = 0x00FFFFFF; dini_IntSet(file, "COLOR", GangInfo[gangid][GANG_COLOR]); SetPlayerColor(playerid,0x00FFFFFF); colour2 = "Cian"; }
			}
			}
			}
			new string2[80];
			format(string2, sizeof(string2), "[CLAN]: Has puesto el color del clan en '%s' ",colour2);
   			SendClientMessage(playerid,ColorAdmin,string2);
	    } else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
	    return 1;
    }

	//---- Stats
    if(strcmp(tmp, "stats", true) == 0)
	{
       	new player1;
	    if(!strlen(tmp2)) player1 = playerid;
	    else player1 = strval(tmp2);

	    if(IsPlayerConnected(player1)) {
		if(PlayerGang[player1] == 0) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}No Tiene Clan!");
		new gangid = PlayerGang[player1];
        new string2[120];
		format(string2, sizeof(string2), "Nick: %s \nClan ID: %d \nClan: %s \nMiembros: %d\nScore Clan: %d",pName(player1), gangid, GangInfo[gangid][GANG_NAME], GangInfo[gangid][GANG_MEMBERS], GangInfo[gangid][GANG_NZONE], GangInfo[gangid][GANG_SCORE]);
        ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{ffb800}|| Info del Clan ||", string2, "OK", "");
        } else return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}Jugador no conectado");
		return 1;

	}
	//---- Delete Inactive
	 if(strcmp(tmp, "di", true) == 0)
	{
	    if(Usuario[playerid][pAdmin] <= 9) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}No puedes usar este comando.");
		for(new i = 0; i <= GANG_NUMBER; i++)
		{
		    new file[60];
			format(file, sizeof(file), GANG_FILE, i);
			if(dini_Exists(file) && dini_Int(file,"GANG_MEMBERS") < 2)
			{
				dini_Remove(file);
				new string2[120];
				format(string2, sizeof(string2), "[INFO]: Clan Eliminado: ID:%d, Miembros: %d, Nombre: %s", i, GangInfo[i][GANG_MEMBERS], GangInfo[i][GANG_NAME]);
				SendClientMessage(playerid, COLOR_ROJO, string2);
				for(new p; p < MAX_PLAYERS; p++)
				{
        			if(PlayerGang[p] == i && IsPlayerConnected(p))
					{
		   				dUserSetINT(pName(playerid)).("clan",0);
		   				dUserSetINT(pName(playerid)).("lider",0);
 			 			dUserSetINT(pName(playerid)).("Lider2",0);
 						PlayerGang[p] = 0;
					}
				}
			}
		}
	return 1;
	}

     if(strcmp(tmp, "radar", true) == 0)
	{
	    if(PlayerGang[playerid] == 0) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}No perteneces a ningún clan!");
		if(gradar[playerid] == 0)
		{
   			for(new i; i < MAX_PLAYERS; i++)
			{

	     		if(PlayerGang[playerid] != PlayerGang[i] && IsPlayerConnected(i)) SetPlayerMarkerForPlayer(playerid, i, (GetPlayerColor(i) & 0xFFFFFF00));
			}
			gradar[playerid] = 1;
			gradartimer[playerid] = SetTimerEx("GangRadar", 1000, true, "i", playerid);
		}
		else
		{
        	for(new i; i < MAX_PLAYERS; i++) SetPlayerMarkerForPlayer(playerid, i, GetPlayerColor(i));
   			gradar[playerid] = 0;
   			KillTimer(gradartimer[playerid]);
		}
		return 1;
	}

     if(strcmp(tmp, "miembros", true) == 0)
	{
	new conteo, surviva[200],texto[200];
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i))
	{
		if(PlayerGang[playerid] == PlayerGang[i] && IsPlayerConnected(i))
		{
			conteo++;
		}
	}
	if(conteo == 0) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{ffb800}|| Miembros de tu clan ON ||", "No hay miembros de tu clan conectados.", "Salir", "");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(PlayerGang[playerid] == PlayerGang[i] && IsPlayerConnected(i))
		{
			format(texto,128,"{%06x}%s [ID: %d]\n",GetPlayerColor(i) >>> 8,pName(i),i);
			strcat(surviva,texto);
		}
	}
	ShowPlayerDialog(playerid,79,DIALOG_STYLE_MSGBOX,"{ffb800}|| Miembros de tu clan ON ||",surviva,"Salir","");
	return 1;
}

  	if(strcmp(tmp, "info", true) == 0)
	{
	new string2[290];
   	strcat(string2, "{06FF24}>> Info del Clan:\n\n");
	strcat(string2, "{FF0000}* {FF8801}Para crear un clan usa /clan crear.\n");
	strcat(string2, "{FF0000}* {FF8801}Para invitar a alguien al Clan usa /clan invitar.\n");
	strcat(string2, "{FF0000}* {FF8801}Para salir del Clan usa /clan salir.\n");
	strcat(string2, "{FF0000}* {FF8801}Para ver info de tu clan usa /clan stats.\n");
	strcat(string2, "{FF0000}* {FF8801}Sólo puedes tener hasta 300 miembros máximo.\n");
	strcat(string2, "{FF0000}* {FF8801}Para ver la ubicación de los otros de tu Clan usa /clan radar.\n\n");
	/*strcat(string2, "{06FF24}>> Info de LIGAS:\n\n");
	strcat(string2, "{FF0000}* {FF8801}Los clanes cuentan con score CLAN.\n");
	strcat(string2, "{FF0000}* {FF8801}Por matar a personas del clan contrario se sumará +1 SCORE CLAN.\n");
	strcat(string2, "{FF0000}* {FF8801}Para mirar la liga de clanes usa {FFFF00}/clanes.\n");
	strcat(string2, "{FF0000}* {FF8801}Para mirar info de liga de clanes usa {FFFF00}/clanes info\n");*/
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{ffb800}|| Info de Clanes ||", string2, "Aceptar", "");
	return 1;
	}
	return ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{0000FF}|| Comandos de Clanes ||",chota1,"Aceptar", "");
 }

CMD:modos(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFF0050, "[INFO]:{FFFFFF} Baja de tu auto e intentalo nuevamente!");
ShowPlayerDialog(playerid,278,DIALOG_STYLE_LIST,"{0000FF}|| Modos ||","{FFFFFF}Freeroam\nDeathMatch\nCarreras","Seleccionar","Cancelar");
return 1;
}

CMD:out(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(Desmadre[playerid] == 1 || Minijuego[playerid] == 1)
{
if(Desmadre[playerid] == 1){endesmadre--;}
if(GetPlayerTeam(playerid) >= 0 && GetPlayerTeam(playerid) <= 254){SetPlayerTeam(playerid,255);}
SetPlayerInterior(playerid,0);Minigun[playerid] = 0;SetPlayerVirtualWorld(playerid,0);Minijuego[playerid] = 0;Desmadre[playerid] = 0;Guerra[playerid] = 0;Zona[playerid] = 0;
SpawnPlayer(playerid);
Usuario[playerid][Modo] = 1;
SCM(playerid,green,"[MODOS]: {FFFFFF}Saliste del minijuego e ingresaste al MODO FREEROAM. [/modos]");
}
return 1;
}


CMD:kill(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
SetPlayerHealth(playerid,0);
return 1;
}


CMD:lugarese(playerid, params[])
{
{
	if(Usuario[playerid][pAdmin] >= 1)
	{
	new string2[200];
	strcat(string2, "Escondidas\n");
	strcat(string2, "Avión de la muerte\n");
	strcat(string2, "Avion tumbador\n");
	strcat(string2, "Rhino vs Kart\n");
	strcat(string2, "Peleas de borrachos\n");
	strcat(string2, "DM (Cancha libre)\n");
	strcat(string2, "DM a DK (En desmadre)\n");
	strcat(string2, "Rocket VS NRG-500\n");
	strcat(string2, "Torre Terrorista\n");
	strcat(string2, "Dm a Katanas\n");
	strcat(string2, "Carrera a pie\n");
	strcat(string2, "Autos chocadores");
	CMDMessageToAdmins(playerid,"LUGARESE");
	ShowPlayerDialog(playerid, 270, DIALOG_STYLE_LIST, "{FF0000}|| Eventos ||", string2, "Seleccionar", "Cancelar");
	} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes lvl para usar este comando.");
	}
return 1;
}


CMD:mievento(playerid, params[])
{
    if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
	if(Usuario[playerid][pAdmin] >= 2) {
	new Mensagem[520];
	strcat(Mensagem, "Crear Evento\nIr a la Posicion del Evento\n");
	strcat(Mensagem, "Dar Armas para todos los Jugadores del Evento\nDar un Carro para todos los Jugador del Evento\nDestruir/Finalizar Evento\nDefinir Vida a los Vehículos del Evento\nKickear un Jugador del Evento\n");
	strcat(Mensagem, "Definir Vida y Chaleco a los Jugadores del Evento\nDefinir Skin a los Jugadores del Evento\nCongelar a los Jugadores del Evento\nDescongelar a los Jugadores del Evento\nResetar Armas a los Jugadores del Evento\nTraer a todos los users del evento\nPosiciones para eventos.\nActivar/Desactivar GODMODE");
	if(EventInfo[Criado] == 0)
	{
		ShowPlayerDialog(playerid, DIALOG_EVENTO, DIALOG_STYLE_LIST, "{00FF00}Evento Propio: {FF0000}Cerrado", Mensagem, "Selecionar", "Cancelar");
	}
	else if(EventInfo[Criado] == 1)
	{
		new StrE[100];
		format(StrE,sizeof(StrE),"{00FF00}Evento Propio: {FFFFFF}Abierto por %s",EventInfo[Admin]);
		ShowPlayerDialog(playerid, DIALOG_EVENTO, DIALOG_STYLE_LIST, StrE, Mensagem, "Selecionar", "Cancelar");
	}
	} else return SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:lol(playerid,params[])
{
	new resultado = GetTickCount() - Lol[playerid];
	if(resultado < 30000) {new string[40];format(string,sizeof(string),"Faltan {00FF00}%d{FFFFFF} segundos para usar el comando.",30000 - resultado/60);SendClientMessage(playerid,-1,string);return 1;}
	new string[80];
	format(string,sizeof(string),"¡El jugador {00FF00}%s{FFFFFF} se ríe, {00FF00}LOL{FFFFFF}!",pName(playerid));
	SendClientMessageToAll(-1,string);
	Lol[playerid] = GetTickCount();
	return 1;
}

CMD:gay(playerid,params[])
{
    if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
	if(Gay[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Sólo puedes utilizar 1 vez el comando!");
	new string[80];
	format(string,sizeof(string),"El jugador %s se declaró la más gay del servidor o.O!",pName(playerid));
	SendClientMessageToAll(COLOR_PINK,string);
	Gay[playerid] = 1;
	SetPlayerSkin(playerid,63);
	SetPlayerHealth(playerid,5);
	SetPlayerColor(playerid,COLOR_PINK);
	return 1;
}

CMD:aevento(playerid,params[])
{
    if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
	if(PlayerInfoE[playerid][NoEvento] == 1)
	{
	SendClientMessage(playerid,green,"[EVENTO]: {FFFFFF}Saliste éxitosamente del evento.");
	PlayerInfoE[playerid][NoEvento] = 0;
	SpawnPlayer(playerid);
	}
	return 1;
}

CMD:eusers(playerid, params[])
{
new conteo, surviva[300],texto[50];
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i))
	{
		if(PlayerInfoE[i][NoEvento] == 1)
		{
			conteo++;
		}
	}
	if(conteo == 0) return ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{00FF00}|| Users en Evento ||", "{FFFFFF}No hay usuarios en el evento!", "Salir", "");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(PlayerInfoE[i][NoEvento] == 1)
		{
			format(texto,sizeof(texto),"{%06x}%s [ID: %d]\n",GetPlayerColor(i) >>> 8,pName(i),i);
			strcat(surviva,texto);
		}
	}
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"{ffb800}|| Users en Evento ||",surviva,"Salir","");
return 1;
}

CMD:hola(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(SaludoH[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Sólo puedes decir hola una vez.");
SaludoH[playerid] = 1;
new string[75];
format(string,sizeof(string),"~p~%s~w~ dice ~b~hola!",pName(playerid));
GameTextForAll(string,3500,1);
return 1;
}

CMD:adios(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
new string[75];
format(string,sizeof(string),"~b~%s~w~ dice ~r~adios!",pName(playerid));
GameTextForAll(string,3500,1);
SetTimerEx("Kickear",500,false,"d",playerid);
return 1;
}

CMD:irevento(playerid, params[])
{
    if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
    if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
    if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
	if(EventInfo[Cerrado] == 1) return SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}El evento ya está cerrado!");
	if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
	if(EventInfo[Aberto] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}El Evento está Fechado!");
	if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
	if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
	if(AceleracionBrutal[playerid] == true || EstaEnFly[playerid] == 1) {
	AceleracionBrutal[playerid] = false;EstaEnFly[playerid] = 0;
	SendClientMessage(playerid,red,"[AVISO]: {FFFFFF}Automáticamente se te han desactivado uno o más comandos vips para que pudieras entrar al evento."); }
	new string2[100];
	SetPlayerVirtualWorld(playerid, EventInfo[VirtualWorld]);
	SetPlayerInterior(playerid, EventInfo[Interior]);
	SetPlayerHealth(playerid, 100);
	Usuario[playerid][Modo] = 1;
	ResetPlayerWeapons(playerid);
	SetPlayerPos(playerid, EventInfo[Xq], EventInfo[Yq], EventInfo[Zq]);
	SetPlayerFacingAngle(playerid, EventInfo[Aq]);
	format(string2, sizeof(string2), "{FF0000}[Evento]: {FFFFFF}%s ingresó al evento '%s'!", pName(playerid),EventInfo[Nome]);
	SendClientMessageToAll(naranja,string2);
	PlayerInfoE[playerid][NoEvento] = 1;
return 1;
}



CMD:minigun(playerid, params[])
{
        if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
		if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
        if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
        if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
        if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
        if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFF0050, "[INFO]:{FFFFFF} Baja De Tu Vehiculo e Intentalo De Nuevo");
       	if(EstaEnFly[playerid] == 1) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Desactiva el /fly para Entrar a /desmadre!");
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Usuario[playerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes usar Teles mientras estás Spectando!");
		new Float:health;
		GetPlayerHealth(playerid,health);
	   	if(health >= 70)
		{
		new r = random(sizeof(MINIGUN));
		Minijuego[playerid] = 1;
		Minigun[playerid] = 1;
		if(IsPlayerInAnyVehicle(playerid)){RemovePlayerFromVehicle(playerid);}
	    ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid,38,9999);
	 	SetPlayerPos(playerid, MINIGUN[r][0], MINIGUN[r][1], MINIGUN[r][2]);
		SetPlayerFacingAngle(playerid,random(9000));
		Usuario[playerid][Modo] = 2;
		SetPlayerVirtualWorld(playerid, 12);
		SetPlayerInterior(playerid, 10);
		SetPlayerHealth(playerid, 100);
  		SetPlayerArmour(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "[MINIGUN]: {FFFFFF}Bienvenido a Minigun, usa /out para salir.");
        EnviarComandoTele(playerid,"Minigun");
}
    else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}


CMD:desmadre(playerid, params[])
{
		if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
        if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
        if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
        if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
        if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFF0050, "[INFO]:{FFFFFF} Baja De Tu Vehiculo e Intentalo De Nuevo");
       	if(EstaEnFly[playerid] == 1) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Desactiva el /fly para Entrar a /desmadre!");
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Usuario[playerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes usar Teles mientras estás Spectando!");
		if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
		new Float:health;
		GetPlayerHealth(playerid,health);
	   	if(health >= 70)
		{
		new r = random(sizeof(DESMADRER));
		Desmadre[playerid] = 1;
		if(IsPlayerInAnyVehicle(playerid)){RemovePlayerFromVehicle(playerid);}
	    ResetPlayerWeapons(playerid);
	    Usuario[playerid][Modo] = 2;
		GivePlayerWeapon(playerid, 24, 9999);
		GivePlayerWeapon(playerid, 25, 9999);
		GivePlayerWeapon(playerid, 34, 9999);
	 	SetPlayerPos(playerid, DESMADRER[r][0], DESMADRER[r][1], DESMADRER[r][2]);
		SetPlayerFacingAngle(playerid,random(9000));
		SetPlayerVirtualWorld(playerid, 3);
		SetPlayerInterior(playerid, 1);
		SetPlayerHealth(playerid, 100);
		endesmadre++;
		SetPlayerArmour(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "[DESMADRE]: {FFFFFF}Bienvenido a Desmadre, usa /out para salir.");
		RemovePlayerAttachedObject(playerid,2);
		RemovePlayerAttachedObject(playerid,0);
		RemovePlayerAttachedObject(playerid,1);
		RemovePlayerAttachedObject(playerid,3);
		RemovePlayerAttachedObject(playerid,4);
		RemovePlayerAttachedObject(playerid,5);
		RemovePlayerAttachedObject(playerid,6);
		RemovePlayerAttachedObject(playerid,7);
		RemovePlayerAttachedObject(playerid,8);
		RemovePlayerAttachedObject(playerid,9);
        EnviarComandoTele(playerid,"Desmadre");
}
    else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}


CMD:zona(playerid, params[])
{
        if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
        if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
        if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
        if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
        if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
        if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFF0050, "[INFO]:{FFFFFF} Baja De Tu Vehiculo e Intentalo De Nuevo");
       	if(EstaEnFly[playerid] == 1) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Desactiva el /fly para Entrar a /desmadre!");
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Usuario[playerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes usar Teles mientras estás Spectando!");
		new Float:health;
		GetPlayerHealth(playerid,health);
	   	if(health >= 70)
		{
		new casos = random(4);
		switch(casos)
		{
		case 0:{SetPlayerPos(playerid,2662.9497,2789.0850,10.8203);}
		case 1:{SetPlayerPos(playerid,2641.3906,2750.8149,23.8222);}
		case 2:{SetPlayerPos(playerid,2607.2820,2789.1260,23.4219);}
		case 3:{SetPlayerPos(playerid,2585.0920,2808.4495,10.8203);}}
		Minijuego[playerid] = 1;RemovePlayerFromVehicle(playerid);ResetPlayerWeapons(playerid);SetPlayerVirtualWorld(playerid,10);SetPlayerInterior(playerid, 0);Zona[playerid] = 1;
		SetPlayerHealth(playerid, 100);GivePlayerWeapon(playerid,26,999);GivePlayerWeapon(playerid,28,999);SendClientMessage(playerid, red, "[Zona abandonada]: {FFFFFF}Bienvenido a la zona abandonada, hora de matar.");
		RemovePlayerAttachedObject(playerid,2);RemovePlayerAttachedObject(playerid,0);RemovePlayerAttachedObject(playerid,1);RemovePlayerAttachedObject(playerid,3);RemovePlayerAttachedObject(playerid,4);RemovePlayerAttachedObject(playerid,5);RemovePlayerAttachedObject(playerid,6);RemovePlayerAttachedObject(playerid,7);RemovePlayerAttachedObject(playerid,8);RemovePlayerAttachedObject(playerid,9);
        EnviarComandoTele(playerid,"zona");
        Usuario[playerid][Modo] = 2;
}
    else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}


CMD:swat(playerid, params[])
{
        if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
        if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
        if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
        if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
        if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
        if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFF0050, "[INFO]:{FFFFFF} Baja De Tu Vehiculo e Intentalo De Nuevo");
       	if(EstaEnFly[playerid] == 1) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Desactiva el /fly para Entrar a /desmadre!");
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Usuario[playerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes usar Teles mientras estás Spectando!");
		ShowPlayerDialog(playerid,276,DIALOG_STYLE_LIST,"|| Equipo ||","{0000FF}Swat\n{FF0000}Terrorista","Aceptar","Cancelar");
		return 1;
}

CMD:deswat(playerid, params[])
{
        if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
        if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
        if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
        if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
        if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
        if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFF0050, "[INFO]:{FFFFFF} Baja De Tu Vehiculo e Intentalo De Nuevo");
       	if(EstaEnFly[playerid] == 1) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Desactiva el /fly para Entrar a /desmadre!");
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Usuario[playerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes usar Teles mientras estás Spectando!");
        Minijuego[playerid] = 1;RemovePlayerFromVehicle(playerid);ResetPlayerWeapons(playerid);SetPlayerVirtualWorld(playerid,10);SetPlayerInterior(playerid, 0);SetPlayerTeam(playerid, 10);SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 100);GivePlayerWeapon(playerid,24,999);GivePlayerWeapon(playerid,27,999);GivePlayerWeapon(playerid,31,999);GivePlayerWeapon(playerid,29,999);SetPlayerColor(playerid,blue);SetPlayerPos(playerid,2847.9656,-2362.8164,22.7987);SetPlayerSkin(playerid,285);SendClientMessage(playerid, blue, "[SWAT]: {FFFFFF}Bienvenido al equipo de SWAT, hora de matar.");
		RemovePlayerAttachedObject(playerid,2);RemovePlayerAttachedObject(playerid,0);RemovePlayerAttachedObject(playerid,1);RemovePlayerAttachedObject(playerid,3);
		RemovePlayerAttachedObject(playerid,4);RemovePlayerAttachedObject(playerid,5);RemovePlayerAttachedObject(playerid,6);RemovePlayerAttachedObject(playerid,7);RemovePlayerAttachedObject(playerid,8);RemovePlayerAttachedObject(playerid,9);EnviarComandoTele(playerid,"zona");
        Usuario[playerid][Modo] = 2;
		return 1;
}

CMD:deterro(playerid, params[])
{
        if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
        if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
        if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
        if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
        if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
        if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
    	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFF0050, "[INFO]:{FFFFFF} Baja De Tu Vehiculo e Intentalo De Nuevo");
       	if(EstaEnFly[playerid] == 1) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Desactiva el /fly para Entrar a /desmadre!");
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Usuario[playerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes usar Teles mientras estás Spectando!");
        Minijuego[playerid] = 1;RemovePlayerFromVehicle(playerid);ResetPlayerWeapons(playerid);SetPlayerVirtualWorld(playerid,10);SetPlayerInterior(playerid, 0);SetPlayerHealth(playerid, 100);SetPlayerTeam(playerid, 11);
		GivePlayerWeapon(playerid,24,999);GivePlayerWeapon(playerid,27,999);GivePlayerWeapon(playerid,31,999);GivePlayerWeapon(playerid,29,999);SetPlayerColor(playerid,red);SetPlayerSkin(playerid,174);SetPlayerPos(playerid,2838.2942,-2531.4246,17.9734);
		SendClientMessage(playerid, red, "[TERRORISTA]: {FFFFFF}Bienvenido al equipo de TERRORISTA, hora de matar.");RemovePlayerAttachedObject(playerid,2);RemovePlayerAttachedObject(playerid,0);RemovePlayerAttachedObject(playerid,1);RemovePlayerAttachedObject(playerid,3);
		RemovePlayerAttachedObject(playerid,4);RemovePlayerAttachedObject(playerid,5);RemovePlayerAttachedObject(playerid,6);RemovePlayerAttachedObject(playerid,7);RemovePlayerAttachedObject(playerid,8);RemovePlayerAttachedObject(playerid,9);
        Usuario[playerid][Modo] = 2;
		return 1;
}


CMD:skin(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes utilizar comandos, usa /out.");
new id;
if(sscanf(params,"d",id)) return SCM(playerid,red,"[ERROR]: {FFFFFF}Debes poner /skin ID.");
if(Skin[playerid] == id) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Ya tienes ese skin!");
Skin[playerid] = id;
SetPlayerSkin(playerid,id);
new string[60];
format(string,sizeof(string),"[SKIN]: {FFFFFF}Te pusiste el skin %d correctamente.",id);
SCM(playerid,green,string);
return 1;
}


CMD:ls(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
new Float:health;GetPlayerHealth(playerid, health);
if(health > 70){
SetPlayerPos(playerid, 2493.9609,-1685.3671, 13.5114);EnviarComandoTele(playerid,"Ls");SetPlayerTime(playerid,12,0);SetPlayerInterior(playerid, 0);
SetPlayerVirtualWorld(playerid, 0);SendClientMessage(playerid, COLOR_VERDE, "Bienvenido a Los Santos!");GameTextForPlayer(playerid,"~b~Bienvenido a ~n~~g~Los Santos",4000,3);}
else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}

CMD:stunt(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
new Float:health;GetPlayerHealth(playerid, health);
if(health > 70){
SetPlayerPos(playerid, 126.4355,-79.3535,1.5781);EnviarComandoTele(playerid,"stunt");SetPlayerTime(playerid,12,0);SetPlayerInterior(playerid, 0);Usuario[playerid][Modo] = 1;
SetPlayerVirtualWorld(playerid, 0);SendClientMessage(playerid, COLOR_VERDE, "Bienvenido al stunt!");GameTextForPlayer(playerid,"~b~Bienvenido al ~n~~g~stunt",4000,3);}
else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}

CMD:azona(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Usuario[playerid][pAdmin] < 2) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
SetPlayerPos(playerid, 1769.2838,-1583.0298,1742.4949);
SetPlayerVirtualWorld(playerid,16);
TogglePlayerControllable(playerid,false);
SetTimerEx("Descongelar",5000,false,"d",playerid);
CMDMessageToAdmins(playerid,"AZONA (Zona admin & cárcel)");
return 1;
}

CMD:rbug(playerid, params[])
{
new string2[100];
if(sscanf(params, "s[25]", params))
{
SendClientMessage(playerid, green, "USA:{FFFFFF} /Rbug {FFFF00}[BUG]");
return 1;
}
format(string2, sizeof(string2), "[REPORTES DE BUGS]: %s reportó el bug: %s", pName(playerid), params);
MessageToAdmins(green,string2);
SendClientMessage(playerid,yellow, "[INFO]: {FFFFFF}Tu reporte fue enviado con {29FF0D}éxito{FFFFFF}. Gracias por reportar y hacer mejor del servidor.");
return 1;
}

CMD:reportar(playerid,params[])
{
new id,razon[25];
if(sscanf(params,"ds[25]",id,razon)) return SendClientMessage(playerid,green,"[REPORTAR]: {FFFFFF}Usa /reportar {00FF00}[ID] [RAZÓN]");
new resultado = GetTickCount() - Reporto[playerid];
if(resultado < 30000) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando tan seguido.");
if(playerid == id) return SendClientMessage(playerid,green,"[INFO]: {FFFFFF}No te puedes autoreportar!");
if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"[INFO]: {FFFFFF}El usuario no está conectado!");
Reporto[playerid] = GetTickCount();
new string[100];
format(string,sizeof(string),"[REPORTE]: {FFFFFF}%s reportó a %s [ID: %d]. Razón: %s.",pName(playerid),pName(id),id,razon);
MessageToAdmins(orange,string);
SetTimerEx("Reportando",30000,false,"d",playerid);
return SendClientMessage(playerid,green,"Reporte enviado con éxito a la administración.");
}


CMD:reloguear(playerid,params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
SetPVarInt(playerid, "camara", 0);
new reason;
if(Desmadre[playerid] == 1 || Minijuego[playerid] == 1 || PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando en evento o minijuego!");
reason = 3;
new Float:x, Float:y, Float:z;GetPlayerPos(playerid,x,y,z);SetPlayerCameraPos(playerid,x+10,y,z+10);SetPlayerCameraLookAt(playerid,x,y,z);TogglePlayerControllable(playerid,false);SetPlayerVirtualWorld(playerid,10);TextDrawHideForPlayer(playerid,Textdraw[0]);TextDrawHideForPlayer(playerid,Textdraw[1]);
TextDrawHideForPlayer(playerid,Textdraw[2]);TextDrawHideForPlayer(playerid,Textdraw[3]);TextDrawHideForPlayer(playerid,Textdraw[4]);TextDrawHideForPlayer(playerid,Textdraw[5]);TextDrawHideForPlayer(playerid,TextdrawM[playerid]);TextDrawHideForPlayer(playerid,FPSP[playerid]);OnPlayerDisconnect(playerid,reason);SetTimerEx("Conectar",6500,false,"d",playerid);
SendClientMessage(playerid,green,"[RELOGUEANDO]: {FFFFFF}Te desconectaste del servidor, conectando en 6 segundos...");
return 1;}

CMD:sf(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
new Float:health;
		GetPlayerHealth(playerid, health);
		if(health > 70)
		{
		SetPlayerPos(playerid, -1979.7108,266.9334,35.1719);EnviarComandoTele(playerid,"Sf");SetPlayerInterior(playerid, 0);SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "Bienvenido a San Fierro!");
		GameTextForPlayer(playerid,"~b~Bienvenido a ~n~~g~San Fierro",4000,3);
		}
		else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}


CMD:aa(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
new Float:health;
		GetPlayerHealth(playerid, health);
		if(health > 70)
		{
		SetPlayerPos(playerid, 405.8488,2453.2803,17.1893);
		EnviarComandoTele(playerid,"Aa");
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "Bienvenido al Aereopuerto Abandonado!");
		}
		else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}

CMD:chilliad(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
new Float:health;
		GetPlayerHealth(playerid, health);
		if(health > 70)
		{
		SetPlayerPos(playerid, -2311.8855,-1651.2426,483.7031);
		EnviarComandoTele(playerid,"Chilliad");
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "Bienvenido a Chilliad!");
		}
		else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}

CMD:bosque(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
new Float:health;
		GetPlayerHealth(playerid, health);
		if(health > 70)
		{
		SetPlayerPos(playerid, -1647.8252,-2242.6750,30.6235);
	    EnviarComandoTele(playerid,"Bosque");
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "Bienvenido al Bosque!");
		}
		else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}


CMD:puente(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
new Float:health;
		GetPlayerHealth(playerid, health);
		if(health > 70)
		{
		SetPlayerPos(playerid, -1128.4757,865.4401,84.0078);
		EnviarComandoTele(playerid,"Puente");
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "Bienvenido al Puente!");
		}
		else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}

CMD:torre(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
new Float:health;
		GetPlayerHealth(playerid, health);
		if(health > 70)
		{
		SetPlayerPos(playerid, 1543.9288, -1353.6332, 329.5831);
		EnviarComandoTele(playerid,"Torre");
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "Bienvenido al Edificio mas Grande de SA!");
		}
		else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}

CMD:vista(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
new Float:health;
		GetPlayerHealth(playerid, health);
		if(health > 70)
		{
		SetPlayerPos(playerid, -2865.6858,2600.1230,271.1722);
		EnviarComandoTele(playerid,"Vista");
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "Bienvenido a Vista!");
		}
		else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}

CMD:lc(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
new Float:health;
		GetPlayerHealth(playerid, health);
		if(health > 70)
		{
        SetPlayerPos(playerid, -799.2450,493.0715,1367.2328);
        SetPlayerInterior(playerid, 1);
        SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "Bienvenido a la Liberty City!");
		GameTextForPlayer(playerid,"~b~Bienvenido a ~n~~g~Liberty City",4000,3);
		}
		else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}

CMD:drift(playerid, params[])
{
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la carrera!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos en la cárcel.");
		new Float:health;
		GetPlayerHealth(playerid, health);
		if(health > 70)
		{
		SetPlayerPos(playerid, 2265.6292,1398.5432,42.4766);
		EnviarComandoTele(playerid,"Drift");
		SetPlayerInterior(playerid, 0);
		Usuario[playerid][Modo] = 1;
		SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_VERDE, "Bienvenido a Drift!");
		}
		else SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
return 1;
}



CMD:spawn(playerid,params[]) {
	if(Usuario[playerid][pAdmin] >= 1) {
		new player1 = strval(params);
	    if(sscanf(params,"d",player1)) return SendClientMessage(playerid, red, "[USA]:{FFFFFF} /spawn [jugador]");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SPAWN");
			new string2[100];
			format(string2, sizeof(string2), "{FFFFFF}Has reiniciado a {FF0000}\"%s\" ", pName(player1));
			SendClientMessage(playerid,-1,string2);
			if(player1 != playerid)
			{
			format(string2,sizeof(string2),"[INFO]: {FFFFFF}El Administrador {FF0000}\"%s\"{FFFFFF} te ha reiniciado.", pName(playerid));
			SendClientMessage(player1,red,string2);
			}
			SetPlayerPos(player1, 0.0, 0.0, 0.0);
			return SpawnPlayer(player1);
	    } else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
	} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos para utilizar el comando!");
}

CMD:ip(playerid,params[]) {
	if(Usuario[playerid][pAdmin] >= 1) {
		new player1;
	    if(sscanf(params,"d",player1)) return SendClientMessage(playerid, red, "[USA]:{FFFFFF} /ip [jugador]");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
		CMDMessageToAdmins(playerid,"IP");
		new string2[125];
		new tmp3[100];
		GetPlayerIp(player1,tmp3,sizeof(tmp3));
		format(string2,sizeof(string2),"{FFFFFF}La IP de {FF0000}\"%s\"{FFFFFF} es {29FF0D}'%s'", pName(player1), tmp3);
		return SendClientMessage(playerid,-1,string2);
	    } else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
	} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos de usar el comando!");
}


CMD:mute(playerid,params[]) {
		if(Usuario[playerid][pAdmin] >= 1) {
		    new mtime,player1,reason[25],string2[140];
  		    if(sscanf(params,"dds[25]",player1,mtime,reason)) return SendClientMessage(playerid, red, "[USA]:{FFFFFF} /mute [ID] [minutos] [razón]");
  			player1 = strval(params);
  		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
  		 	    if(Usuario[player1][Muteado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El usuario ya está muteado.");
				if(Usuario[player1][Muteado] == 0)
				{
     				if(mtime == 0) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Debes poner un tiempom mayor a 0.");
			       	CMDMessageToAdmins(playerid,"MUTE");
					Usuario[player1][Mtiempo] = mtime*1000*60;
					SetTimerEx("Muteando",1000,0,"d",player1);
    				format(string2,sizeof(string2),"[INFO]:{FFFFFF} El Administrador %s ha muteado a %s por %d minutos. [Razón: {00FF00}%s{FFFFFF}]",pName(playerid), pName(player1), mtime,reason);
				}
	    			return SendClientMessageToAll(yellow,string2);
			} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El player no está conectado.");
		} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando!");
}

CMD:unmute(playerid,params[]) {
		if(Usuario[playerid][pAdmin] >= 1) {
		    new player1,string2[140];
  		    if(sscanf(params,"d",player1)) return SendClientMessage(playerid, red, "[USA]:{FFFFFF} /unmute [ID].");
  			player1 = strval(params);
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
		 	    if(Usuario[player1][Muteado] == 0) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El usuario ya está unmuteado.");
				if(Usuario[player1][Muteado] == 1)
				{
  			       	CMDMessageToAdmins(playerid,"UNMUTE");
					Usuario[player1][Mtiempo] = 0;
					Usuario[player1][Muteado] = 0;
					KillTimer(TiempoMute[playerid]);
					PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
					GameTextForPlayer(playerid,"~g~Ya puedes hablar por el chat!",3000,3);
    				format(string2,sizeof(string2),"[INFO]:{FFFFFF} El Administrador %s ha desmuteado a %s.",pName(playerid), pName(player1));
				}
	    			return SendClientMessageToAll(yellow,string2);
			} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El player no está conectado.");
		} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando!");
}

CMD:ira(playerid,params[]) {
    if(Usuario[playerid][pAdmin] >= 2) {
    	new player1, string2[70];
	    if(sscanf(params,"d",player1)) return SendClientMessage(playerid,red,"[USA]:{FFFFFF} /ira [jugador]");
	   	player1 = strval(params);
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"IRA");
			new Float:x, Float:y, Float:z;	GetPlayerPos(player1,x,y,z); SetPlayerInterior(playerid,GetPlayerInterior(player1));
			SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(player1));
			if(GetPlayerState(playerid) == 2)
			{
				SetVehiclePos(GetPlayerVehicleID(playerid),x+3,y,z);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(player1));
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(player1));
			} else SetPlayerPos(playerid,x+2,y,z);
			format(string2,sizeof(string2),"Te teletranportaste a \"%s\"", pName(player1));
			return SendClientMessage(playerid,-1,string2);
		} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El jugador no está conectado o eres tú mismo!");
	} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos para usar el comando!");
}

CMD:aduty(playerid,params)
{
	new string[80];
    if(Usuario[playerid][pAdmin] >= 2)
	{
	if(Usuario[playerid][Aduty] == 0)
	{
	Usuario[playerid][Aduty] = 1;
	SendClientMessage(playerid,yellow,"[DUTY]: {FFFFFF}Te pusiste DUTY en el sistema administrativo!");
	format(string,sizeof(string),"[Administración]: {FFFFFF}%s se pusó ON-DUTY y está administrando.",pName(playerid));
	SendClientMessageToAll(yellow,string);
	ResetPlayerWeapons(playerid);
	SetPlayerHealth(playerid,100000);
	SetPlayerHealth(playerid,100000);
	return 1;
	}
	if(Usuario[playerid][Aduty] == 1)
	{
	Usuario[playerid][Aduty] = 0;
	SendClientMessage(playerid,red,"[DUTY]: {FFFFFF}Te pusiste OFF-DUTY en el sistema administrativo!");
	format(string,sizeof(string),"[Administración]: {FFFFFF}%s se pusó OFF-DUTY y dejó de administrar.",pName(playerid));
	SendClientMessageToAll(red,string);
	ResetPlayerWeapons(playerid);
	SetPlayerHealth(playerid,100);
	return 1;
	}
	}
	return 1;
}
	

CMD:traer(playerid,params[]) {
    if(Usuario[playerid][pAdmin] >= 2) {
    	new player1, string2[70];
	    if(sscanf(params,"d",player1)) return SendClientMessage(playerid,red,"[USA]:{FFFFFF} /traer [jugador]");
	   	player1 = strval(params);
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"TRAER");
			new Float:x, Float:y, Float:z;	GetPlayerPos(playerid,x,y,z);
			SetPlayerInterior(player1,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(playerid));
			if(GetPlayerState(player1) == 2)
			{
				SetVehiclePos(GetPlayerVehicleID(player1),x+3,y,z);
				LinkVehicleToInterior(GetPlayerVehicleID(player1),GetPlayerInterior(playerid));
				SetVehicleVirtualWorld(GetPlayerVehicleID(player1),GetPlayerVirtualWorld(playerid));
			} else SetPlayerPos(player1,x+2,y,z);
			format(string2,sizeof(string2),"\"%s\" te llevó a su posición.", pName(playerid));
			return SendClientMessage(player1,-1,string2);
		} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El jugador no está conectado o eres tú mismo!");
	} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos para usar el comando!");
}


CMD:creditos(playerid,params[])
{
	SendClientMessage(playerid,-1,"+========================================={B9C9BF}CRÉDITOS{FFFFFF}=========================================+");
    SendClientMessage(playerid,-1,"Programación y códificación: {B9C9BF}Carlosxp{FFFFFF} junto a {B9C9BF}[S]peed_.");
    SendClientMessage(playerid,-1,"Mappeos: {B9C9BF}Jupite[R] {FFFFFF},{B9C9BF} [V]enom_. {FFFFFF}, {B9C9BF}XoenY{FFFFFF}, {B9C9BF}_Exotic_{FFFFFF} y {B9C9BF}[A]gente[A]gus{FFFFFF}.");
    SendClientMessage(playerid,-1,"Hosting/VPS: {B9C9BF}[S]asuke {FFFFFF}y{B9C9BF} [S]car[F]ace{FFFFFF}.");
    SendClientMessage(playerid,-1,"Sistema de objetos: {B9C9BF}Excel {FFFFFF}y traducido por {B9C9BF}Carlosxp.");
    SendClientMessage(playerid,-1,"+========================================={B9C9BF}CRÉDITOS{FFFFFF}=========================================+");
	return 1;
}


CMD:kick(playerid,params[])
{
new id, razon[70];
if(Usuario[playerid][pAdmin] >= 3)
{
if(sscanf(params,"ds[70]",id,razon)) return SendClientMessage(playerid,red,"[USA]:{FFFFFF} /kick [jugador] [razón]");
new year,month,day; getdate(year, month, day);
if(Usuario[id][pAdmin] >= 9) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes dar advertencia a este admin.");
if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
if(id != playerid) {
Usuario[id][Kicks]++;
if(Usuario[id][Kicks] == 3)
{
					new str[145];
					format(str, sizeof (str), "[INFO]: {FFFFFF}\"%s\" fue baneado del servidor por \"%s\". [Razón: {00FF00}%s{FFFFFF}] [Kicks: 3/3]", pName(id), pName(playerid), razon);
					SendClientMessageToAll(red, str);
					Usuario[id][Advs] = 0;
					Usuario[id][Kicks] = 0;
					Usuario[id][Bann] = 1;
					new ip[30];
					GetPlayerIp(id,ip,sizeof(ip));
					new msgd[300];
					new str1[85], str2[85], str3[85], str4[85], str5[85], str6[85];
					format(str1, sizeof(str1), "{00FF00}%s{FFFFFF} te ha Baneado del Servidor.\n\n", pName(playerid));
					strcat(msgd, str1);
					format(str2, sizeof(str2), "* {FFFFFF}Nick Admin: {00FF00}%s\n", pName(playerid));
					strcat(msgd, str2);
					format(str3, sizeof(str3), "* {FFFFFF}Tu Nick: {00FF00}%s\n", pName(id));
					strcat(msgd, str3);
					format(str4, sizeof(str4), "* {FFFFFF}Tu IP: {00FF00}%s\n", ip);
					strcat(msgd, str4);
					format(str5, sizeof(str5), "* {FFFFFF}Motivo: {00FF00}%s\n", razon);
					strcat(msgd, str5);
					format(str6, sizeof(str6), "* {FFFFFF}Fecha: {00FF00}%d/%d/%d \n\n", day, month, year);
					strcat(msgd, str6);
					strcat(msgd, "Envia una Foto de este Mensaje con F8 y Muestrasela a un Dueño\n");
					strcat(msgd, "o Encargado en caso de un Error!");
					ShowPlayerDialog(id, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Baneado - {FF0000}Revolucion {FFFFFF}Latina", msgd, "Aceptar", "");
 					dUserSetINT(pName(id)).("Baneo",1);
					new stringa[25];
					format(stringa,sizeof(stringa),"%d/%d/%d",day,month,year);
					dUserSet(pName(id)).("Fbaneo",stringa);
					dUserSet(pName(id)).("Razon",razon);
					SetTimerEx("Kickear",500,false,"d",id);
                    return 1;
}
new str[155];
format(str, sizeof (str), "[INFO]: {FFFFFF}\"%s\" fue kickeado del servidor por \"%s\". [Razón: {00FF00}%s{FFFFFF}] [Kicks: %d/3]", pName(id), pName(playerid), razon,Usuario[id][Kicks]);
SendClientMessageToAll(red, str);
return SetTimerEx("Kickear",500,false,"d",id);
} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes darte advertencias a ti mismo");
} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando.");
}




CMD:congelar(playerid, params[])
{
new player1;
if(Usuario[playerid][pAdmin] >= 3)
{
if(sscanf(params, "d", player1))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /congelar [ID]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
new string[70], string2[70];
CMDMessageToAdmins(playerid,"CONGELAR");
TogglePlayerControllable(player1,false);
format(string2,sizeof(string2),"[INFO]: {FFFFFF}El Administrador %s te congeló.",pName(playerid));
format(string,sizeof(string),"[INFO]: {FFFFFF}Congelaste a %s.",pName(player1));
SendClientMessage(playerid,-1,string);
SendClientMessage(player1,-1,string2);
Congelar(player1);
} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El player no está conectado.");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}



CMD:descongelar(playerid, params[])
{
new player1;
if(Usuario[playerid][pAdmin] >= 3)
{
if(sscanf(params, "d", player1))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /descongelar [ID]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
new string[70], string2[70];
CMDMessageToAdmins(playerid,"DESCONGELAR");
TogglePlayerControllable(player1,false);
format(string2,sizeof(string2),"[INFO]: {FFFFFF}El Administrador %s te descongeló.",pName(playerid));
format(string,sizeof(string),"[INFO]: {FFFFFF}Descongelaste a %s.",pName(player1));
SendClientMessage(playerid,-1,string);
SendClientMessage(player1,-1,string2);
Descongelar(player1);
} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El player no está conectado.");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}



CMD:setcolor(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 3)
{
new string2[115],player1,colour[25],Colour;
if(sscanf(params, "dd", player1, Colour))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /setcolor [jugador] [color]") &&
SendClientMessage(playerid, yellow, "Colores: 0=negro 1=blanco 2=rojo 3=naranja 4=amarillo 5=verde 6=azul 7=purpura 8=marron 9=rosa");
return 1;
}
if(Colour > 9) return SendClientMessage(playerid, red, "Colores: 0=negro, 1=blanco, 2=rojo, 3=naranja, 4=amarillo, 5=verde, 6=azul, 7=purpura, 8=marron, 9=rosa");
if(Usuario[player1][pAdmin] == 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando sobre un admin");
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"SETCOLOR");
switch(Colour)
{
case 0:
{
SetPlayerColor(player1,black);
colour = "Negro";
}
case 1: { SetPlayerColor(player1,COLOR_WHITE); colour = "Blanco"; }
case 2: { SetPlayerColor(player1,red); colour = "Rojo"; }
case 3: { SetPlayerColor(player1,orange); colour = "Naranja"; }
case 4: { SetPlayerColor(player1,orange); colour = "Amarillo"; }
case 5: { SetPlayerColor(player1,COLOR_GREEN); colour = "Verde"; }
case 6: { SetPlayerColor(player1,COLOR_BLUE); colour = "Azul"; }
case 7: { SetPlayerColor(player1,COLOR_PURPLE); colour = "Púrpura"; }
case 8: { SetPlayerColor(player1,COLOR_BROWN); colour = "Marrón"; }
case 9: { SetPlayerColor(player1,COLOR_PINK); colour = "Rosa"; }
}
if(player1 != playerid)
{
format(string2,sizeof(string2),"[INFO]: {FFFFFF}El Administrador \"%s\" ha puesto tu color en '%s'", pName(playerid), colour); SendClientMessage(player1,ColorAdmin,string2); }
format(string2, sizeof(string2), "Has puesto el color de \"%s\" en '%s' ", pName(player1), colour);
SendClientMessage(playerid,-1,string2);
SendClientMessage(player1,-1,string2);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:setmundo(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 4)
{
new string2[150],player1,time;
if(sscanf(params, "dd", player1, time))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /setmundo [jugador] [mundo]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"SETMUNDO");
format(string2, sizeof(string2), "Has puesto el mundo virtual de \"%s\" en '%d'", pName(player1), time);
SendClientMessage(playerid,-1,string2);
if(player1 != playerid)
{
format(string2,sizeof(string2),"[INFO]: {FFFFFF}El Administrador \"%s\" ha puesto tu mundo virtual en '%d'", pName(playerid), time);
SendClientMessage(player1,-1,string2);
}
SetPlayerVirtualWorld(player1, time);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos de usar el comando!");
return 1;
}

CMD:setinterior(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 4)
{
new string2[150],player1,time;
if(sscanf(params, "dd", player1, time))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /setinterior [jugador] [interior]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"SETINTERIOR");
format(string2, sizeof(string2), "Has puesto el interior de \"%s\" en '%d'", pName(player1), time);
SendClientMessage(playerid,-1,string2);
if(player1 != playerid)
{
format(string2,sizeof(string2),"[INFO]: {FFFFFF}El Administrador \"%s\" ha puesto tu interior en '%d'", pName(playerid), time);
SendClientMessage(player1,-1,string2);
}
SetPlayerInterior(player1, time);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos de usar el comando!");
return 1;
}


CMD:juegos(playerid,params[])
{
if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
ShowPlayerDialog(playerid,271,DIALOG_STYLE_LIST,"|| Juegos ||","{FFFFFF}Parkour's\nDrift\nStunt\nDeathMatch","Aceptar","Cancelar");
return 1;
}

CMD:guerra(playerid,params[])
{
if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFF0050, "[INFO]:{FFFFFF} Baja De Tu Vehiculo e Intentalo De Nuevo");
if(EstaEnFly[playerid] == 1) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Desactiva el /fly para entrar!");
if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Usuario[playerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes usar Teles mientras estás Spectando!");
Minijuego[playerid] = 1;
Guerra[playerid] = 1;
Usuario[playerid][Modo] = 2;
ResetPlayerWeapons(playerid);
GivePlayerWeapon(playerid,31,999);
GivePlayerWeapon(playerid,24,999);
GivePlayerWeapon(playerid,27,999);
new spawnea = random(6);
switch(spawnea)
{
case 0: SetPlayerPos(playerid,293.0795,1864.1844,17.6406);
case 1: SetPlayerPos(playerid,349.9177,2015.4403,22.6406);
case 2: SetPlayerPos(playerid,281.6288,2050.0801,18.0417);
case 3: SetPlayerPos(playerid,251.7110,1916.5933,17.6406);
case 4: SetPlayerPos(playerid,170.7848,1935.5001,18.3500);
case 5: SetPlayerPos(playerid,122.5128,1908.8268,18.7340);
}
SetPlayerVirtualWorld(playerid,25);
return 1;
}

CMD:parkour(playerid,params[])
{
if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
new Float:health;
GetPlayerHealth(playerid,health);
if(health >= 70)
{
ResetPlayerWeapons(playerid);
new r = random(sizeof(ParkourPos));
SetPlayerPos(playerid, ParkourPos[r][0], ParkourPos[r][1], ParkourPos[r][2]);
SetPlayerArmour(playerid, 100);
SetPlayerVirtualWorld(playerid,7);
Minijuego[playerid] = 1;
Usuario[playerid][Modo] = 1;
GameTextForPlayer(playerid,"Cargando, espera por favor.",3000,3);
TogglePlayerControllable(playerid,false);
SetTimerEx("Descongelar",3000,false,"d",playerid);
SendClientMessage(playerid, COLOR_VERDE, "[INFO]:{FFFFFF} Acá no se pueden utilizar comandos. Usa {00FF00}/out{FFFFFF} en caso de querer salir.");
}
else
{
SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
}
return 1;
}


CMD:parkour2(playerid,params[])
{
if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
new Float:health;
GetPlayerHealth(playerid,health);
if(health >= 70)
{
ResetPlayerWeapons(playerid);
GameTextForPlayer(playerid,"~y~Bienvenidos a parkour 2",6000,5);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid,7);
SetPlayerArmour(playerid, 100);
Minijuego[playerid] = 1;
Usuario[playerid][Modo] = 1;
GameTextForPlayer(playerid,"Cargando, espera por favor.",3000,3);
TogglePlayerControllable(playerid,false);
SetTimerEx("Descongelar",3000,false,"d",playerid);
SetPlayerPos(playerid,794.6296,-2204.0383,264.3498);
SendClientMessage(playerid, COLOR_VERDE, "[INFO]:{FFFFFF} Acá no se pueden utilizar comandos. Usa {00FF00}/out{FFFFFF} en caso de querer salir.");
}
else
{
SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
}
return 1;
}


CMD:parkour3(playerid,params[])
{
if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
new Float:health;
GetPlayerHealth(playerid,health);
if(health >= 70)
{
ResetPlayerWeapons(playerid);
GameTextForPlayer(playerid,"~y~Bienvenidos a parkour3",6000,5);
SetPlayerInterior(playerid,0);
SetPlayerArmour(playerid, 100);
Minijuego[playerid] = 1;
Usuario[playerid][Modo] = 1;
SetPlayerArmour(playerid, 100);
GameTextForPlayer(playerid,"Cargando, espera por favor.",3000,3);
TogglePlayerControllable(playerid,false);
SetTimerEx("Descongelar",3000,false,"d",playerid);
SetPlayerVirtualWorld(playerid,7);
Minijuego[playerid] = 1;
SetPlayerPos(playerid, 164.1947,664.0439,5.1700);
SendClientMessage(playerid, COLOR_VERDE, "[INFO]:{FFFFFF} Acá no se pueden utilizar comandos. Usa {00FF00}/out{FFFFFF} en caso de querer salir.");
}
else
{
SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Tienes menos de {00FF00}70{FFFFFF} de vida para usar los teleport's.");
}
return 1;
}

CMD:force(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 4)
{
new string2[125],player1;
if(sscanf(params, "d", player1))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /force [jugador]");
return 1;
}
if(Usuario[player1][pAdmin] == 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando sobre un admin de mayor.");
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"FORCE");
if(player1 != playerid)
{
format(string2,sizeof(string2),"[INFO]: {FFFFFF}El Administrador \"%s\" te ha forzado a elegir otro skin.", pName(playerid) ); SendClientMessage(player1,ColorAdmin,string2); }
format(string2,sizeof(string2),"Has forzado a \"%s\" a cambiar de skin", pName(player1));
SendClientMessage(playerid,-1,string2);
ForceClassSelection(player1);
SetPlayerHealth(player1,0.0);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}



CMD:lgoto(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 4)
{
new string2[128];
new Float:x, Float:y, Float:z;
if(sscanf(params, "fff", x, y, z))
{
SendClientMessage(playerid,red,"[USA]:{FFFFFF} /lgoto [x] [y] [z]");
return 1;
}
CMDMessageToAdmins(playerid,"LGOTO");
if(GetPlayerState(playerid) == 2) SetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
else SetPlayerPos(playerid,x,y,z);
format(string2,sizeof(string2),"Has sido teletransportado a %f, %f, %f", x,y,z);
SendClientMessage(playerid,-1,string2);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:setskin(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 5)
{
new string2[125],player1,skin;
if(sscanf(params, "dd", player1, skin))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /setskin [ID] [ID del skin]");
return 1;
}
if(skin >= 265 && skin <= 267 || skin >= 280 && skin <= 284 || skin == 288) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}ID de skin inválida");
if(Usuario[player1][pAdmin] == 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando sobre un admin");
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"SETSKIN");
format(string2, sizeof(string2), "Le has puesto a \"%s\" el skin '%d", pName(player1), skin);
SendClientMessage(playerid,-1,string2);
if(player1 != playerid)
{
format(string2,sizeof(string2),"[INFO]: {FFFFFF}\"%s\" te ha puesto el skin '%d'", pName(playerid), skin);
SendClientMessage(player1,-1,string2);
}
SetPlayerSkin(player1, skin);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes utilizar el comando!");
return 1;
}


CMD:ricos(playerid, params[])
{
new string2[50];
new Slot1 = -1, Slot2 = -1, Slot3 = -1, Slot4 = -1, HighestCash = -9999;
SendClientMessage(playerid,yellow,"[LISTA DE RICOS]:");

for(new x=0; x<MAX_PLAYERS; x++) if (IsPlayerConnected(x)) if (GetPlayerMoney(x) >= HighestCash) {
HighestCash = GetPlayerMoney(x);
Slot1 = x;
}
HighestCash = -9999;
for(new x=0; x<MAX_PLAYERS; x++) if (IsPlayerConnected(x) && x != Slot1) if (GetPlayerMoney(x) >= HighestCash) {
HighestCash = GetPlayerMoney(x);
Slot2 = x;
}
HighestCash = -9999;
for(new x=0; x<MAX_PLAYERS; x++) if (IsPlayerConnected(x) && x != Slot1 && x != Slot2) if (GetPlayerMoney(x) >= HighestCash) {
HighestCash = GetPlayerMoney(x);
Slot3 = x;
}
HighestCash = -9999;
for(new x=0; x<MAX_PLAYERS; x++) if (IsPlayerConnected(x) && x != Slot1 && x != Slot2 && x != Slot3) if (GetPlayerMoney(x) >= HighestCash) {
HighestCash = GetPlayerMoney(x);
Slot4 = x;
}
format(string2, sizeof(string2), "[%d] %s - $%d", Slot1,pName(Slot1),GetPlayerMoney(Slot1) );
SendClientMessage(playerid,green,string2);
if(Slot2 != -1)	{
format(string2, sizeof(string2), "[%d] %s - $%d", Slot2,pName(Slot2),GetPlayerMoney(Slot2) );
SendClientMessage(playerid,green,string2);
}
if(Slot3 != -1)
{
format(string2, sizeof(string2), "[%d] %s - $%d", Slot3,pName(Slot3),GetPlayerMoney(Slot3) );
SendClientMessage(playerid,green,string2);
}
if(Slot4 != -1)
{
format(string2, sizeof(string2), "[%d] %s - $%d", Slot4,pName(Slot4),GetPlayerMoney(Slot4) );
SendClientMessage(playerid,green,string2);
}
return 1;
}


CMD:top(playerid, params[])
{
new	playerScores[MAX_PLAYERS][rankingEnum],index;
		for(new i; i != MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i) && !IsPlayerNPC(i))
			{
				playerScores[index][player_Score] = GetPlayerScore(i);
				playerScores[index++][player_ID] = i;
			}
		}
		GetPlayerHighestScores(playerScores, 0, index);

		new
			score_Text[230] = "\n",
			player_Name[MAX_PLAYER_NAME]
		;
		for(new i; i < 10; ++i)
		{
			if(i < index)
			{
				GetPlayerName(playerScores[i][player_ID], player_Name, sizeof(player_Name));
				format(score_Text, sizeof(score_Text), "%s\n{0000FF}%d. {FFFFFF}%s - {FF0000}%d", score_Text, i + 1, player_Name, playerScores[i][player_Score]);
			}
			else
				format(score_Text, sizeof(score_Text), "%s\n{0000FF}%d. {FF0000}Ninguno", score_Text, i + 1);
		}
    	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "|| TOP ||", score_Text, "Aceptar", "");
return 1;
}



CMD:vidaall(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 6)
{
new string2[85];
CMDMessageToAdmins(playerid,"VIDAALL");
for(new i = 0; i < MAX_PLAYERS; i++)
{
if(IsPlayerConnected(i))
{
SetPlayerHealth(playerid,100);
}
}
format(string2,sizeof(string2),"[INFO]: {FFFFFF}\"%s\" ha restaurado la vida de todos los usuarios", pName(playerid));
SendClientMessageToAll(blue, string2);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:chalecoall(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 6)
{
new string2[85];
CMDMessageToAdmins(playerid,"CHALECOALL");
for(new i = 0; i < MAX_PLAYERS; i++)
{
if(IsPlayerConnected(i))
{
SetPlayerArmour(playerid,100);
}
}
format(string2,sizeof(string2),"[INFO]: {FFFFFF}\"%s\" ha restaurado la armadura de todos los usuarios.", pName(playerid) );
SendClientMessageToAll(blue, string2);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}


CMD:weaps(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 2)
{
new string2[128];
new player1, WeapName[24], slot, weap, ammo, Count, x;
if(sscanf(params, "d", player1))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /weaps [playerid]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
format(string2,sizeof(string2),"[>> %s [%d] <<]", pName(player1), player1);
SendClientMessage(playerid,yellow,string2);
for (slot = 0; slot < 14; slot++)
{
GetPlayerWeaponData(player1, slot, weap, ammo);
if( ammo != 0 && weap != 0)
Count++;
}
if(Count < 1) return SendClientMessage(playerid,ColorAdmin,"[ERROR]: El player no tiene armas.");
if(Count >= 1)
{
for (slot = 0; slot < 14; slot++)
{
GetPlayerWeaponData(player1, slot, weap, ammo);
if(ammo != 0 && weap != 0)
{
GetWeaponName(weap, WeapName, sizeof(WeapName) );
if(ammo == 65535 || ammo == 1) format(string2,sizeof(string2),"%s%s (1)",string2, WeapName );
else format(string2,sizeof(string2),"%s%s [%d]",string2, WeapName, ammo );
x++;
if(x >= 5)
{
SendClientMessage(playerid, blue, string2);
x = 0;
format(string2, sizeof(string2), "");
}
else format(string2, sizeof(string2), "%s,  ", string2);
}
}
if(x <= 4 && x > 0) {
string2[strlen(string2)-3] = '.';
SendClientMessage(playerid, blue, string2);
}
}
return 1;
} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El player no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes el nivel para usar este comando.");
}


CMD:announce(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 5)
{
if(sscanf(params, "s[25]", params))
{
SendClientMessage(playerid,red,"[USA]:{FFFFFF} /announce <texto>");
return 1;
}
if(strfind(params, "~z~", true) != -1 || strfind(params, "~x~", true) != -1 || strfind(params, "~c~", true) != -1 || strfind(params, "~v~", true) != -1 || strfind(params, "~m~", true) != -1 || strfind(params, "¿", true) != -1 || strfind(params, "{", true) != -1 || strfind(params, "}", true) != -1 || strfind(params, "~d~", true) != -1 || strfind(params, "~s~", true) != -1 || strfind(params, "~a~", true) != -1
|| strfind(params, "#", true) != -1 || strfind(params, "~q~", true) != -1 || strfind(params, "~e~", true) != -1 || strfind(params, "~t~", true) != -1 || strfind(params, "~u~", true) != -1 || strfind(params, "~i~", true) != -1 || strfind(params, "~ñ~", true) != -1 || strfind(params, "~l~", true) != -1 || strfind(params, "~k~", true) != -1 || strfind(params, "~j~", true) != -1 || strfind(params, "~f~", true) != -1
|| strfind(params, "=", true) != -1 || strfind(params, "¨", true) != -1 || strfind(params, "^", true) != -1 || strfind(params, "+", true) != -1 || strfind(params, "-", true) != -1 || strfind(params, ">", true) != -1 || strfind(params, "<", true) != -1 || strfind(params, "~~~", true) != -1 || strfind(params, ":", true) != -1 || strfind(params, "“", true) != -1 || strfind(params, "    ", true) != -1)
return SendClientMessage(playerid, Rojo, "[ERROR]: {FFFFFF}No uses signos raros & otras cosas así.");
CMDMessageToAdmins(playerid,"ANNOUNCE");
GameTextForAll(params,7000,3);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:darcash(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 4)
{
new string2[125],player1,cash;
if(sscanf(params, "dd", player1, cash))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /darcash [ID] [Cantidad]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"DARCASH");
format(string2, sizeof(string2), "Has añadido al dinero de \"%s\" con +'$%d' ", pName(player1), cash);
SendClientMessage(playerid,-1,string2);
if(player1 != playerid)
{
format(string2,sizeof(string2),"[Administración]: {FFFFFF}\"%s\" te ha añadido a tu dinero con +'$%d'", pName(playerid), cash);
SendClientMessage(player1,-1,string2);
}
DarDinero(player1,cash);
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:setnivel(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 7)
{
new string2[125],player1,nivel;
if(sscanf(params, "dd", player1, nivel))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /setnivel [ID] [Cantidad]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"SETNIVEL");
format(string2, sizeof(string2), "Pusiste el nivel de \"%s\" en %d.' ", pName(player1), nivel);
SendClientMessage(playerid,-1,string2);
if(player1 != playerid)
{
format(string2,sizeof(string2),"[Administración]: {FFFFFF}\"%s\" pusó tu nivel en %d.", pName(playerid), nivel);
SendClientMessage(player1,-1,string2);
}
Usuario[player1][Nivel] = nivel;
GuardarUsuario(player1);
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:darnivel(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 7)
{
new string2[125],player1,nivel;
if(sscanf(params, "dd", player1, nivel))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /darnivel [ID] [Cantidad]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"DARNIVEL");
format(string2, sizeof(string2), "Agregaste a \"%s\" %d niveles más.' ", pName(player1), nivel);
SendClientMessage(playerid,-1,string2);
if(player1 != playerid)
{
format(string2,sizeof(string2),"[Administración]: {FFFFFF}\"%s\" te regaló %d niveles más.", pName(playerid), nivel);
SendClientMessage(player1,-1,string2);
}
Usuario[player1][Nivel] += nivel;
GuardarUsuario(player1);
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:setcash(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 5)
{
new string2[125],player1,cash;
if(sscanf(params, "dd", player1, cash))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /setcash [jugador] [monto]");
return 1;
}
if(Usuario[player1][pAdmin] == 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando sobre un admin");
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"SETCASH");
format(string2, sizeof(string2), "Has puesto el dinero de \"%s\" en '$%d", pName(player1), cash);
SendClientMessage(playerid,-1,string2);
if(player1 != playerid)
{
format(string2,sizeof(string2),"[INFO]: {FFFFFF}El Administrador \"%s\" ha puesto tu dinero en '$%d'", pName(playerid), cash);
SendClientMessage(player1,-1,string2);
}
ResetPlayerMoney(player1);
Usuario[player1][Dinero] = 0;
DarDinero(player1, cash);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}




CMD:darscore(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 5)
{
new string2[125],player1,score;
if(sscanf(params, "dd", player1, score))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /darscore [ID] [Cantidad]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"DARSCORE");
format(string2, sizeof(string2), "Has añadido el puntaje de \"%s\" con '%d' ", pName(player1), score);
SendClientMessage(playerid,-1,string2);
if(player1 != playerid)
{
format(string2,sizeof(string2),"[Administración]: {FFFFFF}\"%s\" te ha añadido tu puntaje con '%d'", pName(playerid), score);
SendClientMessage(player1,-1,string2);
}
SetPlayerScore(player1, GetPlayerScore(player1)+ score);
Usuario[player1][Asesinatos] += score;
GuardarUsuario(player1);
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:etest(playerid,params[])
{
if(Usuario[playerid][pAdmin] < 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
RespuestaConcurso = MINIMUM_VALUE + random(MAXIMUM_VALUE-MINIMUM_VALUE);
new string2[120];
format(string2,sizeof string2,"[TEST DE REACCIÓN]: {FFFFFF}¡Vamos, rápido, escribe {00FF00}%d{FFFFFF} para ganar $%d y 3 de NIVEL!",RespuestaConcurso,PREMIO_CONCURSO);
SendClientMessageToAll(orange,string2);
return 1;}


CMD:admins(playerid, params[])
{
new conteo, admins[600],texto[600],titulo[55];
for(new i = 0; i < MAX_PLAYERS; i++)
{
if(IsPlayerAdmin(i))
{
conteo++;
}
else if(Usuario[i][pAdmin] >= 1)
{
conteo++;
}
}
if(conteo == 0) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}||{FF0000}No hay administradores ONLINE{FFFFFF}||", "{FFFFFF}AntiCheats[RL] {00FF00}[Level: 10]", "Salir", "");
format(titulo,sizeof(titulo),"Admins Conectados: {FFFFFF}|| {00FF00}%d {FFFFFF}||",conteo);
for(new i = 0; i < MAX_PLAYERS; i++)
{
if(IsPlayerAdmin(i) && IsPlayerConnected(i))
{
format(texto,60,"{FFFFFF}%s [ID: %d] {FF0000}[Nivel: Admin RCON]\n",pName(i),i);
strcat(admins,texto);
}
else if(Usuario[i][pAdmin] >= 1 && Usuario[i][Aduty] == 0 && IsPlayerConnected(i) && Temporal[i] == 0)
{
new TxAdm[256];
switch(Usuario[i][pAdmin])
{
case 1: TxAdm = "{00FF00}Ayudante {FF0000}|OFF|";
case 2: TxAdm = "{FF0000}Moderador a Prueba {FF0000}|OFF|";
case 3: TxAdm = "{FF0000}Moderador {FF0000}|OFF|";
case 4: TxAdm = "{FF0000}Moderador Global {FF0000}|OFF|";
case 5: TxAdm = "{0000FF}Administrador a Prueba {FF0000}|OFF|";
case 6: TxAdm = "{0000FF}Co-Administrador {FF0000}|OFF|";
case 7: TxAdm = "{0000FF}Administrador {FF0000}|OFF|";
case 8: TxAdm = "{0000FF}Administrador Global {FF0000}|OFF|";
case 9: TxAdm = "{FF0000}Encargado del servidor {FF0000}|OFF|";
case 10: TxAdm = "{FF0000}Dueño del servidor {FF0000}|OFF|";
}
format(texto,128,"{FFFFFF}%s [ID: %d] [Nivel: %d] %s \n",pName(i),i,Usuario[i][pAdmin],TxAdm);
strcat(admins,texto);
}
else if(Usuario[i][pAdmin] >= 1 && Usuario[i][Aduty] == 1 && IsPlayerConnected(i) && Temporal[i] == 0)
{
new TxAdm[256];
switch(Usuario[i][pAdmin])
{
case 1: TxAdm = "{00FF00}Ayudante {00FF00}|ON|";
case 2: TxAdm = "{FF0000}Moderador a Prueba {00FF00}|ON|";
case 3: TxAdm = "{FF0000}Moderador {00FF00}|ON|";
case 4: TxAdm = "{FF0000}Moderador Global {00FF00}|ON|";
case 5: TxAdm = "{0000FF}Administrador a Prueba {00FF00}|ON|";
case 6: TxAdm = "{0000FF}Co-Administrador {00FF00}|ON|";
case 7: TxAdm = "{0000FF}Administrador {00FF00}|ON|";
case 8: TxAdm = "{0000FF}Administrador Global {00FF00}|ON|";
case 9: TxAdm = "{FF0000}Encargado del servidor {00FF00}|ON|";
case 10: TxAdm = "{FF0000}Dueño del servidor {00FF00}|ON|";
}
//Si no es RCON pero si admin normal...
format(texto,128,"{FFFFFF}%s [ID: %d] [Nivel: %d] %s \n",pName(i),i,Usuario[i][pAdmin],TxAdm);
strcat(admins,texto);
}
else if(Usuario[i][pAdmin] >= 1 && Usuario[i][Aduty] == 1 && IsPlayerConnected(i) && Temporal[i] == 1)
{
new TxAdm[256];
switch(Usuario[i][pAdmin])
{
case 1: TxAdm = "{00FF00}Ayudante (Temporal) {00FF00}|ON|";
case 2: TxAdm = "{FF0000}Moderador a Prueba (Temporal) {00FF00}|ON|";
case 3: TxAdm = "{FF0000}Moderador (Temporal) {00FF00}|ON|";
case 4: TxAdm = "{FF0000}Moderador Global (Temporal) {00FF00}|ON|";
case 5: TxAdm = "{0000FF}Administrador a Prueba (Temporal) {00FF00}|ON|";
case 6: TxAdm = "{0000FF}Co-Administrador (Temporal) {00FF00}|ON|";
case 7: TxAdm = "{0000FF}Administrador (Temporal) {00FF00}|ON|";
case 8: TxAdm = "{0000FF}Administrador Global (Temporal){00FF00}|ON|";
}
//Si no es RCON pero si admin normal...
format(texto,128,"{FFFFFF}%s [ID: %d] [Nivel: %d] %s \n",pName(i),i,Usuario[i][pAdmin],TxAdm);
strcat(admins,texto);
}
else if(Usuario[i][pAdmin] >= 1 && Usuario[i][Aduty] == 0 && IsPlayerConnected(i) && Temporal[i] == 1)
{
new TxAdm[256];
switch(Usuario[i][pAdmin])
{
case 1: TxAdm = "{00FF00}Ayudante (Temporal) {FF0000}|OFF|";
case 2: TxAdm = "{FF0000}Moderador a Prueba (Temporal) {FF0000}|OFF|";
case 3: TxAdm = "{FF0000}Moderador (Temporal) {FF0000}|OFF|";
case 4: TxAdm = "{FF0000}Moderador Global (Temporal) {FF0000}|OFF|";
case 5: TxAdm = "{0000FF}Administrador a Prueba (Temporal) {FF0000}|OFF|";
case 6: TxAdm = "{0000FF}Co-Administrador (Temporal) {FF0000}|OFF|";
case 7: TxAdm = "{0000FF}Administrador (Temporal) {FF0000}|OFF|";
case 8: TxAdm = "{0000FF}Administrador Global (Temporal) {FF0000}|OFF|";
}
format(texto,128,"{FFFFFF}%s [ID: %d] [Nivel: %d] %s \n",pName(i),i,Usuario[i][pAdmin],TxAdm);
strcat(admins,texto);
}
}
ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,titulo,admins,"Salir","");
return 1;
}


CMD:vips(playerid, params[])
{
new conteo, admins[600],texto[600],titulo[55];
for(new i = 0; i < MAX_PLAYERS; i++)
{
if(Usuario[i][pVip] >= 1)
{
conteo++;
}
}
if(conteo == 0) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}||{FF0000}No hay VIPS ONLINE{FFFFFF}||", "{FFFFFF}No hay VIPS online.", "Salir", "");
format(titulo,sizeof(titulo),"Vips Conectados: {FFFFFF}|| {00FF00}%d {FFFFFF}||",conteo);
for(new i = 0; i < MAX_PLAYERS; i++)
{
if(Usuario[i][pVip] >= 1)
{
new TxAdm[256];
switch(Usuario[i][pVip])
{
case 1: TxAdm = "{FF0000}Bronce";
case 2: TxAdm = "{FFFFFF}Plata";
case 3: TxAdm = "{00FF00}Oro";
case 4: TxAdm = "{FF00FF}Elite";
case 5: TxAdm = "{0000FF}Dios";
case 6: TxAdm = "{FF0000}Supremo";
}
format(texto,128,"{FFFFFF}%s [ID: %d] [%s{FFFFFF}]\n",pName(i),i,TxAdm);
strcat(admins,texto);
}
}
ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,titulo,admins,"Salir","");
return 1;
}

CMD:zonavip(playerid,params[])
{
if(Usuario[playerid][pVip] < 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
if(Usuario[playerid][Invisible] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes entrar estando invisible!");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFF0050, "[INFO]:{FFFFFF} Baja De Tu Vehiculo e Intentalo De Nuevo");
if(EstaEnFly[playerid] == 1) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Desactiva el /fly para Entrar!");
if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Usuario[playerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes usar Teles mientras estás Spectando!");
CMDMessageToVips(playerid,"ZONAVIP");
GameTextForPlayer(playerid,"Bienvenido Vip",2000,3);
SetPlayerPos(playerid,957,-55,1001);
SetPlayerInterior(playerid,3);
return 1;
}

CMD:rendirse(playerid, params[])
{
SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);	// HANDSUP
return 1;
}

CMD:borracho(playerid, params[])
{
ApplyAnimation(playerid,"PED", "WALK_DRUNK",4.0,1,1,1,1,500);
SendClientMessage(playerid, 0x339900AA, "borrachin");
return 1;
}

CMD:bomba(playerid, params[])
{
ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 1, 1, 0,0);
return 1;
}

CMD:arrestar(playerid, params[])
{
ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1,500);
return 1;
}

CMD:reir(playerid, params[])
{
ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0,0);
return 1;
}

CMD:mirar(playerid, params[])
{
ApplyAnimation(playerid,"PED","roadcross_female",4.1,0,0,0,0,0);
return 1;
}

CMD:amenazar(playerid, params[])
{
ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 0, 0, 0, 1,500);
return 1;
}

CMD:paja(playerid, params[])
{
ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 1, 0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/irsecortao]");
return 1;
}

CMD:irsecortao(playerid, params[])
{
ApplyAnimation(playerid, "PAULNMAC", "wank_out", 4.0, 0, 0, 0, 0, 0);
return 1;
}

CMD:agredido(playerid, params[])
{
ApplyAnimation(playerid, "POLICE", "crm_drgbst_01", 4.0, 0, 0, 0, 1, 0);
return 1;
}

CMD:herido(playerid, params[])
{
ApplyAnimation(playerid, "SWEET", "LaFin_Sweet", 4.0, 0, 1, 1, 1, 0);
return 1;
}

CMD:encender(playerid, params[])
{
ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.000000, 0, 0, 1, 1, 0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/apagar {FFFFFF}o {00FF00}/inhalar]");
return 1;
}

CMD:inhalar(playerid, params[])
{
ApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.000000, 1, 0, 0, 0, -1);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/apagar]");
return 1;
}

CMD:apagar(playerid, params[])
{
ApplyAnimation(playerid, "SMOKING", "M_smk_out", 4.000000, 0, 1, 1, 0, 0);
return 1;
}

CMD:vigilar(playerid, params[])
{
ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 1, 1, 1, 0, 4000);
return 1;
}

CMD:recostarse(playerid, params[])
{
ApplyAnimation(playerid,"SUNBATHE", "Lay_Bac_in", 4.0, 0, 0, 0, 1, 0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/pararse]");
return 1;
}

CMD:pararse(playerid, params[])
{
ApplyAnimation(playerid,"SUNBATHE", "Lay_Bac_out", 4.0, 0, 0, 0, 0, 0);
return 1;
}

CMD:cubrirse(playerid, params[])
{
ApplyAnimation(playerid, "ped", "cower", 4.0, 1, 0, 0, 0, 0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/pararse]");
return 1;
}

CMD:vomitar(playerid, params[])
{
ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita.");
return 1;
}

CMD:comer(playerid, params[])
{
ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.00, 0, 0, 0, 0, 0);
return 1;
}

CMD:chao(playerid, params[])
{
ApplyAnimation(playerid, "KISSING", "BD_GF_Wave", 3.0, 0, 0, 0, 0, 0);
return 1;
}

CMD:palmada(playerid, params[])
{
ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0);
return 1;
}

CMD:agonizar(playerid, params[])
{
ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.0, 0, 0, 0, 1, 0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/levantarse]");
return 1;
}

CMD:levantarse(playerid, params[])
{
ApplyAnimation(playerid, "ped", "getup_front", 4.000000, 0, 0, 0, 0, 0);
return 1;
}

CMD:traficar(playerid, params[])
{
ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
return 1;
}

CMD:beso(playerid, params[])
{
ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 4.0, 0, 0, 0, 0, 0);
return 1;
}

CMD:crack(playerid, params[])
{
ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 0, 0, 0, 1, 0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/levantarse]");
return 1;
}

CMD:sentarse(playerid, params[])
{
ApplyAnimation(playerid, "SUNBATHE", "ParkSit_M_in", 4.000000, 0, 1, 1, 1, 0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/levantarse]");
return 1;
}

CMD:rap2(playerid, params[])
{
ApplyAnimation( playerid,"ped", "fucku", 4.0, 0, 1, 1, 1, 1 );
return 1;
}

CMD:si(playerid, params[])
{
ApplyAnimation(playerid, "GANGS", "Invite_Yes", 4.0, 0, 0, 0, 0, 0);
return 1;
}

CMD:no(playerid, params[])
{
ApplyAnimation(playerid, "GANGS", "Invite_No", 4.0, 0, 0, 0, 0, 0);
return 1;
}

CMD:llamar(playerid, params[])
{
ApplyAnimation(playerid, "ped", "phone_in", 4.000000, 0, 0, 0, 1, 4000);
SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/colgar]");
return 1;
}

CMD:contestar(playerid, params[])
{
ApplyAnimation(playerid, "ped", "phone_in", 4.000000, 0, 0, 0, 1, 4000);
SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/colgar]");
return 1;
}

CMD:colgar(playerid, params[])
{
ApplyAnimation(playerid, "ped", "phone_out", 4.000000, 0, 1, 1, 0, 0);
return 1;
}

CMD:piquero(playerid, params[])
{
ApplyAnimation(playerid, "DAM_JUMP", "DAM_Launch", 4.0, 0, 1, 1, 1, 1);
return 1;
}

CMD:taichi(playerid, params[])
{
ApplyAnimation(playerid, "PARK", "Tai_Chi_Loop",  4.1,7,5,1,1,1);
return 1;
}

CMD:beber(playerid, params[])
{
ApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.0, 0, 1, 1, 0, 4000);
return 1;
}

CMD:beber2(playerid, params[])
{
SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
return 1;
}

CMD:beber3(playerid, params[])
{
SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
return 1;
}

CMD:beber4(playerid, params[])
{
SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
return 1;
}

CMD:pagar(playerid, params[])
{
ApplyAnimation(playerid, "DEALER", "shop_pay", 4.000000, 0, 1, 1, 0, 0);
return 1;
}

CMD:boxear(playerid, params[])
{
ApplyAnimation(playerid, "GYMNASIUM", "gym_shadowbox",  4.1,7,5,1,1,1);
return 1;
}

CMD:pelea(playerid, params[])
{
ApplyAnimation(playerid, "ped", "FIGHTIDLE", 4.000000, 0, 1, 1, 1, 1);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/boxear]");
return 1;
}

CMD:recoger(playerid, params[])
{
ApplyAnimation(playerid, "BSKTBALL", "BBALL_pickup", 4.000000, 0, 1, 1, 1, 1);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/botear]");
return 1;
}

CMD:botear(playerid, params[])
{
ApplyAnimation(playerid, "BSKTBALL", "BBALL_walk", 4.000000, 1, 1, 1, 1, 500);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/lanzar]");
return 1;
}

CMD:clavarse(playerid, params[])
{
ApplyAnimation(playerid, "BSKTBALL", "BBALL_def_jump_shot", 4.0, 0, 1, 1, 1, 500);
return 1;
}

CMD:lanzar(playerid, params[])
{
ApplyAnimation(playerid, "BSKTBALL", "BBALL_Jump_Shot", 4.0, 0, 1, 1, 1, 500);
return 1;
}

CMD:asiento(playerid, params[])
{
ApplyAnimation(playerid, "ped", "SEAT_down", 4.000000, 0, 0, 0, 1, 0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/depie]");
return 1;
}

CMD:depie(playerid, params[])
{
ApplyAnimation(playerid, "ped", "SEAT_up", 4.000000, 0, 0, 1, 0, 0);
return 1;
}

CMD:servirse(playerid, params[])
{
ApplyAnimation(playerid,"BAR","Barcustom_get",4.1,0,0,0,0,0);
return 1;
}

CMD:servir(playerid, params[])
{
ApplyAnimation(playerid,"BAR","Barserve_give",4.1,0,0,0,0,0);
return 1;
}

CMD:asiento2(playerid, params[])
{
ApplyAnimation(playerid,"Attractors","Stepsit_in",4.1,0,0,0,1,0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/depie2]");
return 1;
}

CMD:depie2(playerid, params[])
{
ApplyAnimation(playerid,"Attractors","Stepsit_out",4.1,0,0,0,0,0);
return 1;
}

CMD:pensar(playerid, params[])
{
ApplyAnimation(playerid,"COP_AMBIENT","Coplook_think",4.1,0,0,0,0,0);
return 1;
}

CMD:rodar(playerid, params[])
{
ApplyAnimation(playerid,"MD_CHASE","MD_HANG_Lnd_Roll",4.1,0,1,1,1,0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/levantarse]");
return 1;
}

CMD:saludo1(playerid, params[])
{
ApplyAnimation(playerid,"GANGS","hndshkaa",4.1,0,0,0,0,0);
return 1;
}

CMD:saludo2(playerid, params[])
{
ApplyAnimation(playerid,"GANGS","hndshkba",4.1,0,0,0,0,0);
return 1;
}

CMD:saludo3(playerid, params[])
{
ApplyAnimation(playerid,"GANGS","hndshkca",4.1,0,0,0,0,0);
return 1;
}

CMD:saludo4(playerid, params[])
{
ApplyAnimation(playerid,"GANGS","hndshkfa_swt",4.1,0,0,0,0,0);
return 1;
}

CMD:curar(playerid, params[])
{
ApplyAnimation(playerid,"MEDIC","CPR",4.1,0,0,0,0,0);
return 1;
}

CMD:llorar(playerid, params[])
{
ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop",4.1,0,0,0,0,0);
return 1;
}

CMD:dormir(playerid, params[])
{
ApplyAnimation(playerid,"INT_HOUSE","BED_In_R",4.1,0,0,0,1,0);
return 1;
}

CMD:parar(playerid, params[])
{
ApplyAnimation(playerid,"POLICE","CopTraf_Stop",4.1,0,0,0,0,0);
return 1;
}

CMD:rap3(playerid, params[])
{
ApplyAnimation(playerid,"RAPPING","RAP_B_Loop",4.0,1,0,0,0,8000);
return 1;
}

CMD:strip(playerid, params[])
{
SendClientMessage(playerid, 0xAA3333AA, "/strip[1-20]");
return 1;
}

CMD:strip1(playerid, params[])
{
ApplyAnimation(playerid,"CAR","flag_drop",4.1,0,1,1,1,1);
return 1;
}

CMD:strip2(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","PUN_CASH",4.1,7,5,1,1,1);
return 1;
}

CMD:strip3(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","PUN_HOLLER",4.1,7,5,1,1,1);
return 1;
}

CMD:strip4(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","PUN_LOOP",4.1,7,5,1,1,1);
return 1;
}

CMD:strip5(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","strip_A",4.1,7,5,1,1,1);
return 1;
}

CMD:strip6(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","strip_B",4.1,7,5,1,1,1);
return 1;
}

CMD:strip7(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","strip_C",4.1,7,5,1,1,1);
return 1;
}

CMD:strip8(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","strip_D",4.1,7,5,1,1,1);
return 1;
}

CMD:strip9(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","strip_E",4.1,7,5,1,1,1);
return 1;
}

CMD:strip10(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","strip_F",4.1,7,5,1,1,1);
return 1;
}

CMD:strip11(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","strip_G",4.1,7,5,1,1,1);
return 1;
}

CMD:strip12(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","STR_B2A",4.1,0,1,1,1,1);
return 1;
}

CMD:strip13(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","strip_E",4.1,7,5,1,1,1);
return 1;
}

CMD:strip14(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","STR_B2C",4.000000, 0, 1, 1, 1, 0);
return 1;
}

CMD:strip15(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","STR_C1",4.000000, 0, 1, 1, 1, 0);
return 1;
}

CMD:strip16(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","STR_C2",4.000000, 0, 1, 1, 1, 0);
return 1;
}

CMD:strip17(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","STR_C2B",4.1,7,5,1,1,1);
return 1;
}

CMD:strip18(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","STR_Loop_A",4.1,7,5,1,1,1);
return 1;
}

CMD:strip19(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","STR_Loop_C",4.1,7,5,1,1,1);
return 1;
}

CMD:strip20(playerid, params[])
{
ApplyAnimation(playerid,"STRIP","STR_Loop_B",4.1,7,5,1,1,1);
return 1;
}

CMD:echarse(playerid, params[])
{
ApplyAnimation(playerid,"SUNBATHE","SitnWait_in_W",4.000000, 0, 0, 0, 1, 0);
return 1;
}

CMD:asientosexi(playerid, params[])
{
ApplyAnimation(playerid,"SUNBATHE","ParkSit_W_idleA",4.000000, 0, 1, 1, 1, 0);
SendClientMessage(playerid, 0x339900AA, ".:|INFO|:. {FFFFFF}Estás realizando la acción escrita. Luego usa {00FF00}[/pararse]");
return 1;
}

CMD:patinar(playerid, params[])
{
SendClientMessage(playerid, 0xAA3333AA, "/patinar1 || /patinar2 || /patinar3");
return 1;
}

CMD:patinar1(playerid, params[])
{
ApplyAnimation(playerid,"SKATE","skate_run",4.0,1,1,1,1,500);
return 1;
}

CMD:patinar2(playerid, params[])
{
ApplyAnimation(playerid,"SKATE","skate_sprint",4.0,1,1,1,1,500);
return 1;
}

CMD:patinar3(playerid, params[])
{
ApplyAnimation(playerid,"SKATE","skate_idle",4.0,1,1,1,1,500);
return 1;
}

CMD:patada(playerid, params[])
{
ApplyAnimation(playerid,"FIGHT_C","FightC_2",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar(playerid, params[])
{
SendClientMessage(playerid, 0xAA3333AA, "/danzar[0-12]");
return 1;
}

CMD:danzar0(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","bd_clap",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar1(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","bd_clap1",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar2(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","dance_loop",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar3(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","DAN_Down_A",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar4(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","DAN_Left_A",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar5(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","DAN_Loop_A",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar6(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","DAN_Right_A",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar7(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","DAN_Up_A",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar8(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","dnce_M_a",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar9(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","dnce_M_b",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar10(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","dnce_M_c",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar11(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","dnce_M_d",4.1,7,5,1,1,1);
return 1;
}

CMD:danzar12(playerid, params[])
{
ApplyAnimation(playerid,"DANCING","dnce_M_e",4.1,7,5,1,1,1);
return 1;
}

CMD:mear(playerid, params[])
{
SetPlayerSpecialAction(playerid, 68);
return 1;
}

CMD:arrestado(playerid, params[])
{
SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
return 1;
}

CMD:fumar(playerid, params[])
{
SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
return 1;
}

CMD:fumar2(playerid, params[])
{
ApplyAnimation(playerid,"SMOKING","F_smklean_loop", 4.0, 1, 0, 0, 0, 0);
return 1;
}

CMD:fumar3(playerid, params[])
{
ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop", 4.0, 1, 0, 0, 0, 0);
return 1;
}

CMD:asustado(playerid, params[])
{
ApplyAnimation(playerid,"PED","handscower",4.1,0,1,1,1,1);
return 1;
}

CMD:taxi(playerid, params[])
{
ApplyAnimation(playerid,"PED","IDLE_taxi",4.1,0,1,1,1,1);
return 1;
}

CMD:adolorido(playerid, params[])
{
ApplyAnimation(playerid,"PED","KO_shot_stom",4.1,0,1,1,1,1);
return 1;
}

CMD:nadar(playerid, params[])
{
ApplyAnimation(playerid,"PED","Shove_Partial",4.1,0,1,1,1,1);
return 1;
}

CMD:correr(playerid, params[])
{
ApplyAnimation(playerid,"PED","sprint_civi",4.0,1,1,1,1,500);
return 1;
}

CMD:fuerza(playerid, params[])
{
ApplyAnimation(playerid,"benchpress","gym_bp_celebrate",4.1,0,1,1,1,1);
return 1;
}

CMD:gangsta(playerid, params[])
{
ApplyAnimation(playerid,"PED","WALK_gang1",4.0,1,1,1,1,500);
return 1;
}

CMD:tullio(playerid, params[])
{
ApplyAnimation(playerid,"PED","WALK_old",4.0,1,1,1,1,500);
return 1;
}

CMD:mujer(playerid, params[])
{
ApplyAnimation(playerid,"PED","WOMAN_walkpro",4.0,1,1,1,1,500);
return 1;
}

CMD:asco(playerid, params[])
{
ApplyAnimation(playerid,"FOOD","EAT_Vomit_SK",4.1,0,1,1,1,1);
return 1;
}

CMD:festejar(playerid, params[])
{
ApplyAnimation(playerid,"GANGS","hndshkea",4.1,0,1,1,1,1);
return 1;
}

CMD:turndownforwhats(playerid, params[])
{
ApplyAnimation(playerid,"ON_LOOKERS","shout_02",4.1,7,5,1,1,1);
return 1;
}

CMD:rap(playerid, params[])
{
ApplyAnimation(playerid,"GHANDS","gsign1LH",4.1,0,1,1,1,1);
return 1;
}

CMD:insultar(playerid, params[])
{
ApplyAnimation(playerid,"GHANDS","gsign2LH",4.1,0,1,1,1,1);
return 1;
}

CMD:cansado(playerid, params[])
{
ApplyAnimation(playerid,"PED","WOMAN_runfatold",4.1,7,5,1,1,1);
return 1;
}

CMD:superpatada(playerid, params[])
{
ApplyAnimation(playerid,"FIGHT_C","FightC_3",4.1,0,1,1,1,1);
return 1;
}

CMD:comodo(playerid, params[])
{
ApplyAnimation(playerid,"INT_HOUSE","LOU_In",4.1,0,1,1,1,1);
return 1;
}

CMD:hablar(playerid, params[])
{
ApplyAnimation(playerid,"PED","IDLE_chat",4.1,7,5,1,1,1);
return 1;
}

CMD:chatpm(playerid,params[])
{
	if(DPM[playerid] == 0)
	{
	DPM[playerid] = 1;
	}
	else DPM[playerid] = 0;
	return 1;
}


CMD:musica(playerid,params[])
{
ShowPlayerDialog(playerid,282,DIALOG_STYLE_INPUT,"|| Música ||","{FFFFFF}Ingresa el link de la música que quieres escuchar. Si no sabes mira la {00FF00}/ayuda musica{FFFFFF}.","Reproducir","Cancelar");
return 1;
}
CMD:panel(playerid,params[])
{
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes utilizas comandos, usa /out.");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes utilizas comandos, usa /out.");
new T1[30],TVIP[30],T3[30];
switch(DPM[playerid])
{
case 0: {T1 = "Por chat";}
case 1: {T1 = "Por dialogo";}
}
switch(Bloqueado[playerid])
{
case 0:{T3 = "{00FF00}Desbloqueado";}
case 1:{T3 = "{FF0000}Bloqueado";}
}
switch(Usuario[playerid][pVip])
   	{
   	case 0: TVIP = "N/A";
	case 1: TVIP = "Bronce";
	case 2: TVIP = "Plata";
	case 3: TVIP = "Oro";
	case 4: TVIP = "Elite";
	case 5: TVIP = "Dios";
	case 6: TVIP = "Supremo";
	}
new string[300];
format(string,sizeof(string),"Opción\tEstado\n\
Mensajes privados\t[%s{FFFFFF}]\n\
Color\t[{%06x}Muestra{FFFFFF}]\n\
Propiedades\t[{0000FF}%d{FFFFFF}]\n\
VIP\t[%s]\n\
Cuenta\t%s\n\
Teletransportación\t[%s{FFFFFF}]\n\
Música\t[{00FF00}Activar{FFFFFF}]",T1,GetPlayerColor(playerid) >>> 8,PlayerProps[playerid],TVIP,pName(playerid),T3);
ShowPlayerDialog(playerid, 280, DIALOG_STYLE_TABLIST_HEADERS, "{00FF00}|| Panel de usuario ||",string,"Aceptar","Cancelar");
return 1;
}

CMD:acciones(playerid, params[])
{
{
new string2[4300];
    strcat(string2, "{00FF00}>> Sí {FFFFFF}[Haces una acción afirmando]\n");
    strcat(string2, "{00FF00}>> No {FFFFFF}[Haces una acción negando]\n");
    strcat(string2, "{00FF00}>> Rendirse {FFFFFF}[Haces una acción levantando los brazos]\n");
    strcat(string2, "{00FF00}>> Borracho {FFFFFF}[Haces una acción borracho]\n");
    strcat(string2, "{00FF00}>> Pensar {FFFFFF}[Haces una acción pensativa]\n");
    strcat(string2, "{00FF00}>> Servir {FFFFFF}[Haces una acción siviendo algo]\n");
    strcat(string2, "{00FF00}>> Servirse {FFFFFF}[Haces una acción sirviéndote algo]\n");
    strcat(string2, "{00FF00}>> Bomba {FFFFFF}[Haces una acción plantando una bomba]\n");
    strcat(string2, "{00FF00}>> Arrestar {FFFFFF}[Haces una acción arrestando a alguien]\n");
    strcat(string2, "{00FF00}>> Reír {FFFFFF}[Haces una acción riéndote]\n");
    strcat(string2, "{00FF00}>> Mirar {FFFFFF}[Haces una acción mirando hacia todos lados]\n");
    strcat(string2, "{00FF00}>> Asiento {FFFFFF}[Haces una acción para sentarte]\n");
    strcat(string2, "{00FF00}>> Asiento2 {FFFFFF}[Haces una acción para sentarte (secundaria)]\n");
    strcat(string2, "{00FF00}>> Amenazar {FFFFFF}[Haces una acción amenazando a alguien]\n");
    strcat(string2, "{00FF00}>> Agredido {FFFFFF}[Haces una acción como si estuvieras agredido]\n");
    strcat(string2, "{00FF00}>> Rodar {FFFFFF}[Haces una acción rodando]\n");
    strcat(string2, "{00FF00}>> Llorar {FFFFFF}[Haces una acción de llorar]\n");
    strcat(string2, "{00FF00}>> Festejo {FFFFFF}[Haces una acción de festejar]\n");
    strcat(string2, "{00FF00}>> Encender {FFFFFF}[Haces una acción de encender un porro]\n");
    strcat(string2, "{00FF00}>> Apagar {FFFFFF}[Haces una acción de apagar el porro]\n");
    strcat(string2, "{00FF00}>> Fumar {FFFFFF}[Haces una acción de fumar]\n");
    strcat(string2, "{00FF00}>> Inhalar {FFFFFF}[Haces una acción de drogarte]\n");
    strcat(string2, "{00FF00}>> Vigilar {FFFFFF}[Haces una acción de vigilancia]\n");
    strcat(string2, "{00FF00}>> Recostarse {FFFFFF}[Haces una acción para recostarte]\n");
    strcat(string2, "{00FF00}>> Saludo1 {FFFFFF}[Haces el saludo1]\n");
    strcat(string2, "{00FF00}>> Saludo2 {FFFFFF}[Haces el saludo2]\n");
    strcat(string2, "{00FF00}>> Saludo3 {FFFFFF}[Haces el saludo3]\n");
    strcat(string2, "{00FF00}>> Saludo4 {FFFFFF}[Haces el saludo4]\n");
    strcat(string2, "{00FF00}>> Palmada {FFFFFF}[Haces una palmadita]\n");
    strcat(string2, "{00FF00}>> Agonizar {FFFFFF}[Haces una acción para agonizar]\n");
    strcat(string2, "{00FF00}>> Traficar {FFFFFF}[Haces una acción que trafica drogas]\n");
    strcat(string2, "{00FF00}>> Beso {FFFFFF}[Para darle un beso a esa persona {FF0000}<3{FFFFFF}]\n");
    strcat(string2, "{00FF00}>> Crack {FFFFFF}[Haces una acción de un drogado en el suelo]\n");
    strcat(string2, "{00FF00}>> Parar {FFFFFF}[Haces una acción para detener a la gente]\n");
    strcat(string2, "{00FF00}>> Beber {FFFFFF}[Haces una acción para beber]\n");
    strcat(string2, "{00FF00}>> Hablar {FFFFFF}[Haces mimica con las manos]\n");
    strcat(string2, "{00FF00}>> Curar {FFFFFF}[Haces una acción para curar a una persona]\n");
    strcat(string2, "{00FF00}>> TurnDownForWhats {FFFFFF}[Haces una acción gritando {0000FF}¡OHHHHHHHH!{FFFFFF}]\n");
    strcat(string2, "{00FF00}>> Cubrirse {FFFFFF}[Haces una acción para cubrirte en un tiroteo]\n");
    strcat(string2, "{00FF00}>> Vomitar {FFFFFF}[Haces una acción de vomitar]\n");
    strcat(string2, "{00FF00}>> Comer {FFFFFF}[Haces una acción de comer]\n");
    strcat(string2, "{00FF00}>> Despedirse {FFFFFF}[Haces una acción para despedirte]\n");
    strcat(string2, "{00FF00}>> Insultar {FFFFFF}[Haces una acción como de insultar]\n");
	strcat(string2, "{00FF00}>> Strip's {FFFFFF}[Miras la lista de STRIP'S]\n");
	strcat(string2, "{00FF00}>> Echarse {FFFFFF}[Haces una acción para echarte]\n");
	strcat(string2, "{00FF00}>> AsientoSexi {FFFFFF}[Haces una acción para sentarte seximente]\n");
	strcat(string2, "{00FF00}>> Patinar1 {FFFFFF}[Haces una acción para Patinar (1)]\n");
	strcat(string2, "{00FF00}>> Patinar2 {FFFFFF}[Haces una acción para Patinar (2)]\n");
	strcat(string2, "{00FF00}>> Patinar3 {FFFFFF}[Haces una acción para Patinar (3)]\n");
	strcat(string2, "{00FF00}>> SuperPatada {FFFFFF}[Haces una acción de superpatada]\n");
	strcat(string2, "{00FF00}>> Patada {FFFFFF}[Haces una acción de una patada]\n");
	strcat(string2, "{00FF00}>> Danzas {FFFFFF}[Mira la lista de Danzas]\n");
	strcat(string2, "{00FF00}>> Fumar2 {FFFFFF}[Haces una acción de Fumar]\n");
	strcat(string2, "{00FF00}>> Fumar3 {FFFFFF}[Haces una acción de Fumar]\n");
	strcat(string2, "{00FF00}>> Llamar {FFFFFF}[Haces una acción de llamar con teléfono]\n");
	strcat(string2, "{00FF00}>> Colgar {FFFFFF}[Haces una acción de colgar el teléfono]\n");
    strcat(string2, "{00FF00}>> Recoger {FFFFFF}[Haces una acción de agarrar una pelota]\n");
    strcat(string2, "{00FF00}>> Botear {FFFFFF}[Haces una acción de picar la pelota]\n");
    strcat(string2, "{00FF00}>> Asustado {FFFFFF}[Haces una acción de estar asustado]\n");
    strcat(string2, "{00FF00}>> Taxi {FFFFFF}[Haces una acción de parar un taxi]\n");
    strcat(string2, "{00FF00}>> Adolorido {FFFFFF}[Haces una acción de estar adolorido]\n");
    strcat(string2, "{00FF00}>> Nadar {FFFFFF}[Haces una acción de una brazada de natación]\n");
    strcat(string2, "{00FF00}>> Rap {FFFFFF}[Haces una acción de rappear]\n");
    strcat(string2, "{00FF00}>> Fuerza {FFFFFF}[Haces una acción de estirar los músculos]\n");
    strcat(string2, "{00FF00}>> Fumar {FFFFFF}[Haces una acción de fumar]\n");
    strcat(string2, "{00FF00}>> Sentarse {FFFFFF}[Haces una acción de sentarte]\n");
    strcat(string2, "{0000FF}|---|Acciones 2|---|");
	ShowPlayerDialog(playerid, 1000, DIALOG_STYLE_LIST, "{FFFFFF}|| Acciones ||",string2,"Seleccionar", "Cancelar");
	}
	return 1;
}

COMMAND:acciones2(playerid, params[])
{
	new string2[550];
    strcat(string2, "{00FF00}>> Rap2 {FFFFFF}[Haces una acción de rappear (2)]\n");
    strcat(string2, "{00FF00}>> Rap3 {FFFFFF}[Haces una acción de rappear (3)]\n");
    strcat(string2, "{00FF00}>> Piquero {FFFFFF}[Haces una acción de supersalto]\n");
    strcat(string2, "{00FF00}>> Taichi {FFFFFF}[Haces una acción de hacer taichi]\n");
    strcat(string2, "{00FF00}>> Boxear {FFFFFF}[Haces una acción de Boxear]\n");
    strcat(string2, "{00FF00}>> Gangsta {FFFFFF}[Haces una acción de caminar como Gangasta]\n");
    strcat(string2, "{00FF00}>> Sexi {FFFFFF}[Haces una acción de caminar sexi]\n");
    strcat(string2, "{00FF00}>> Asco {FFFFFF}[Haces una acción de demostrar asco]\n");
    strcat(string2, "{00FF00}>> Comodo {FFFFFF}[Haces una acción de sentarse comodo]\n");
    ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "{FFFFFF}|| Acciones2 ||",string2,"Seleccionar","Cancelar");
 	return 1;
}

CMD:pm(playerid, params[])
{
new id, mensage[250];
if(sscanf(params, "ds[250]", id,mensage))
{
SendClientMessage(playerid,red,"[USA]:{FFFFFF} /pm [ID] [Mensaje]");
return 1;
}
if(id == playerid) return SendClientMessage(playerid, -1, "No puedes enviarte mensajes a tí mismo.");
if(ADpm[id] == 0)
{
if(IsPlayerConnected(id))
{
if(DetectarSpam(mensage) && Usuario[playerid][pAdmin] < 1)
{
new stringp[110];
SendClientMessage(playerid,red,"[ERROR]:{FFFFFF} No puedes escribir más de 8 dígitos numerales.");
format(stringp, sizeof(stringp), "[INFO]: {FFFFFF}%s [%d] escribió más de 7 dígitos numerales en PM. [Texto: %s]",pName(playerid),playerid,mensage);
MessageToAdmins(red,stringp);
return 1;
}
if(DPM[playerid] == 0)
{
new string[55], string2[350];
format(string, sizeof(string), "PM para: {00FF00}%s [ID: %d]{FFFFFF}.", pName(id), id);
format(string2, sizeof(string2), "Texto: %s",mensage);
SendClientMessage(playerid,-1,string);
SendClientMessage(playerid,green,string2);
GameTextForPlayer(playerid,"~w~PM ~b~enviado.",4000,3);
}
if(DPM[playerid] == 1)
{
new string5[155];
format(string5, sizeof(string5), "{FFFFFF}Para: {00FF00}%s [ID: %d]{FFFFFF}.\nMensaje: %s", pName(id), id,mensage);
ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"{00FF00}|| PM ENVIADO ||",string5,"Aceptar","");
GameTextForPlayer(playerid,"~w~PM enviado ~g~correctamente~w~.",4000,3);
}
if(DPM[id] == 0)
{
new string3[55], string4[150];
format(string3, sizeof(string3), "PM de: {00FF00}%s [ID: %d]{FFFFFF}.", pName(playerid), playerid);
format(string4, sizeof(string4), "Texto: %s",mensage);
SendClientMessage(id,-1,string3);
SendClientMessage(id,green,string4);
GameTextForPlayer(id,"~w~PM ~b~recibido~w~.",6000,3);
}
if(DPM[id] == 1)
{
new string6[145];
format(string6, sizeof(string6), "{FFFFFF}De: {00FF00}%s [ID: %d]{FFFFFF}.\nMensaje: %s", pName(playerid), playerid,mensage);
ShowPlayerDialog(id,1,DIALOG_STYLE_MSGBOX,"{00FF00}|| PM RECIBIDO ||",string6,"Aceptar","");
GameTextForPlayer(id,"~w~PM ~b~recibido~w~. Mira el ~y~Chat~w~!",6000,3);
}
}
else SendClientMessage(playerid, red, "¡Error!: {FFFFFF}El jugador no está conectado.");
}
else SendClientMessage(playerid, red, "¡Error!: {FFFFFF}El jugador tiene desactivado los PM's.");
return 1;
}


CMD:darallcash(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 6)
{
new string2[85];
new var;
if(sscanf(params, "d", var))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /darallcash [Cantidad]");
return 1;
}
CMDMessageToAdmins(playerid,"DARALLCASH");
for(new i, g = GetMaxPlayers(); i < g; i++)
{
if(IsPlayerConnected(i))
{
DarDinero(i,var);
}
}
format(string2,sizeof(string2),"[INFO]: {FFFFFF}\"%s\" le ha dado a todos los usuarios '$%d'.", pName(playerid), var );
SendClientMessageToAll(blue, string2);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}


CMD:announce2(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 6)
{
new estilo,tiempo1,texto[25];
if(sscanf(params, "dds[25]", estilo,tiempo1,texto))
{
SendClientMessage(playerid,red,"[USA]:{FFFFFF} /announce2 <estilo> <TIEMPO EN SEGUNDOS> <texto>");
return 1;
}
if(strfind(params, "~z~", true) != -1 || strfind(params, "~x~", true) != -1 || strfind(params, "~c~", true) != -1 || strfind(params, "~v~", true) != -1 || strfind(params, "~m~", true) != -1 || strfind(params, "¿", true) != -1 || strfind(params, "{", true) != -1 || strfind(params, "}", true) != -1 || strfind(params, "~d~", true) != -1 || strfind(params, "~s~", true) != -1 || strfind(params, "~a~", true) != -1
|| strfind(params, "#", true) != -1 || strfind(params, "~q~", true) != -1 || strfind(params, "~e~", true) != -1 || strfind(params, "~t~", true) != -1 || strfind(params, "~u~", true) != -1 || strfind(params, "~i~", true) != -1 || strfind(params, "~ñ~", true) != -1 || strfind(params, "~l~", true) != -1 || strfind(params, "~k~", true) != -1 || strfind(params, "~j~", true) != -1 || strfind(params, "~f~", true) != -1
|| strfind(params, "=", true) != -1 || strfind(params, "¨", true) != -1 || strfind(params, "^", true) != -1 || strfind(params, "+", true) != -1 || strfind(params, "-", true) != -1 || strfind(params, ">", true) != -1 || strfind(params, "<", true) != -1 || strfind(params, "~~~", true) != -1 || strfind(params, ":", true) != -1 || strfind(params, "“", true) != -1 || strfind(params, "    ", true) != -1)
return SendClientMessage(playerid, Rojo, "[ERROR]: {FFFFFF}No uses signos raros en el announce.");
if(estilo == 2 || estilo > 6)	return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estilo de texto inválido. Rangos: 0 - 6");
CMDMessageToAdmins(playerid,"ANNOUNCE2");
GameTextForAll(texto,tiempo1*1000,estilo);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}



CMD:ban(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 7)
{
new string2[128],player1,razon[25];
if(sscanf(params, "us[25]", player1, razon))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /ban [ID] [razón]");
return 1;
}
if(Usuario[player1][pAdmin] >= 7) return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}No puedes banear a un Admin! [Hasta lvl 6!]");
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)
{
new year,month,day;
getdate(year, month, day);
CMDMessageToAdmins(playerid,"BAN");
format(string2,sizeof(string2),"[Administración]: {FFFFFF}%s fue baneado por %s. [Razón: {00FF00}%s{FFFFFF}] [Fecha: %d/%d/%d]",pName(player1),pName(playerid),razon,day,month,year);
SendClientMessageToAll(red,string2);
Usuario[player1][Bann] = 1;
dUserSetINT(pName(player1)).("Baneo",1);
new stringa[25];
format(stringa,sizeof(stringa),"%d/%d/%d",day,month,year);
dUserSet(pName(player1)).("Fbaneo",stringa);
dUserSet(pName(player1)).("Razon",razon);
return SetTimerEx("Kickear", 500, 0, "i", player1);
} else return SendClientMessage(playerid, red, "¡Error!: {FFFFFF}El jugador no está conectado, o eres tú mismo!");
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}No puedes utilizar ese comando!");
}

CMD:rban(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 8) {
new string2[128],player1,razon[25];
if(sscanf(params, "us[25]", player1, razon))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /rban [ID] [razón]");
return 1;
}
if(Usuario[player1][pAdmin] >= 7) return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}No puedes banear a un Admin! [Hasta lvl 6!]");
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)
{
new year,month,day;
getdate(year, month, day);
CMDMessageToAdmins(playerid,"BAN");
format(string2,sizeof(string2),"[Administración]: {FFFFFF}%s fue baneado(Range Ban) por %s. [Razón: {00FF00}%s{FFFFFF}] [Fecha: %d/%d/%d]",pName(player1),pName(playerid),razon,day,month,year);
SendClientMessageToAll(red,string2);
Usuario[player1][Bann] = 1;
dUserSetINT(pName(player1)).("Baneo",1);
new stringa[25];
format(stringa,sizeof(stringa),"%d/%d/%d",day,month,year);
dUserSet(pName(player1)).("Fbaneo",stringa);
dUserSet(pName(player1)).("Razon",razon);
return SetTimerEx("Banear", 500, 0, "i", player1);
} else return SendClientMessage(playerid, red, "¡Error!: {FFFFFF}El jugador no está conectado, o eres tú mismo!");
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}No puedes utilizar ese comando!");
}

CMD:godcar(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 7)
{
if(IsPlayerInAnyVehicle(playerid))
{
if(Usuario[playerid][GodCar] == 0)
{
Usuario[playerid][GodCar] = 1;
DisableRemoteVehicleCollisions(playerid, 1);
SetVehicleHealth(GetPlayerVehicleID(playerid), 1000000);
SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Activaste el GODCAR.");
return CMDMessageToAdmins(playerid,"GODCAR (ON)");
}
else
{
Usuario[playerid][GodCar] = 0;
DisableRemoteVehicleCollisions(playerid, 0);
SetVehicleHealth(GetPlayerVehicleID(playerid), 1000);
RepairVehicle(GetPlayerVehicleID(playerid));
SendClientMessage(playerid,red,"[INFO]: {FFFFFF}Desactivaste el GODCAR.");
}
CMDMessageToAdmins(playerid,"GODCAR (OFF)");
}
else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No estás en un auto!");
}
else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes utilizar el comando!");
return 1;
}



CMD:warn(playerid,params[]) {
	if(Usuario[playerid][pAdmin] >= 2) {
	    new reason[35], warned;
	    if(sscanf(params,"ds[35]",warned,reason)) return SendClientMessage(playerid, red, "[USA]:{FFFFFF} /warn [ID] [Razón]");
    	new year,month,day; getdate(year, month, day);
		if(Usuario[warned][pAdmin] == 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes dar advertencia a este admin.");
	 	if(IsPlayerConnected(warned) && warned != INVALID_PLAYER_ID) {
 	   	if(warned != playerid) {
	    CMDMessageToAdmins(playerid,"WARN");
		Usuario[warned][Advs]++;
		if(Usuario[warned][Advs] == 3 && Usuario[warned][Kicks] == 3)
		{
		            new str[125];
					format(str, sizeof (str), "[INFO]: {FFFFFF}\"%s\" fue baneado del servidor por \"%s\". [Razón: {00FF00}%s{FFFFFF}] [Adv.: 3/3] [Kicks: 3/3]", pName(warned), pName(playerid), reason);
					SendClientMessageToAll(red, str);
					Usuario[warned][Advs] = 0;
					Usuario[warned][Kicks] = 0;
					new ip[30];
					GetPlayerIp(warned,ip,sizeof(ip));
					new msgd[100];
					new str1[85], str2[85], str3[85], str4[85], str5[85], str6[85];
					format(str1, sizeof(str1), "{00FF00}%s{FFFFFF} te ha Baneado del Servidor.\n\n", pName(playerid));
					strcat(msgd, str1);
					format(str2, sizeof(str2), "* {FFFFFF}Nick Admin: {00FF00}%s\n", pName(playerid));
					strcat(msgd, str2);
					format(str3, sizeof(str3), "* {FFFFFF}Tu Nick: {00FF00}%s\n", pName(warned));
					strcat(msgd, str3);
					format(str4, sizeof(str4), "* {FFFFFF}Tu IP: {00FF00}%s\n", ip);
					strcat(msgd, str4);
					format(str5, sizeof(str5), "* {FFFFFF}Motivo: {00FF00}%s\n", reason);
					strcat(msgd, str5);
					format(str6, sizeof(str6), "* {FFFFFF}Fecha: {00FF00}%d/%d/%d \n\n", day, month, year);
					strcat(msgd, str6);
					strcat(msgd, "Envia una Foto de este Mensaje con F8 y Muestrasela a un Dueño\n");
					strcat(msgd, "o Encargado en caso de un Error!");
					ShowPlayerDialog(warned, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Baneado - {FF0000}Revolucion {FFFFFF}Latina", msgd, "Aceptar", "");
 					dUserSetINT(pName(warned)).("Baneo",1);
					new stringa[25];
					format(stringa,sizeof(stringa),"%d/%d/%d",day,month,year);
					dUserSet(pName(warned)).("Fbaneo",stringa);
					dUserSet(pName(warned)).("Razon",reason);
					Kickear(warned);
                    return 1;
				}
				if(Usuario[warned][Advs] == 3)
				{
				    new str[136];
					Usuario[warned][Kicks]++;
					format(str, sizeof (str),"[INFO]: {FFFFFF}\"%s\" fue kickeado por \"%s\". [Razón: {00FF00}%s{FFFFFF}] [Adv.: %d/3] [Kicks: %d/3]", pName(warned), pName(playerid), reason, Usuario[warned][Advs], Usuario[warned][Kicks]);
					SendClientMessageToAll(red, str);
					Usuario[warned][Advs] = 0;
					new msgd[150];
					new str1[105], str2[105], str3[105], str4[105], str5[105];
					format(str1, sizeof(str1), "{00FF00}%s{FFFFFF} te ha Kickeado del Servidor.\n\n", pName(playerid));
					strcat(msgd, str1);
					format(str2, sizeof(str2), "{00FF00}* {FFFFFF}Nick Admin: {00FF00}%s\n", pName(playerid));
					strcat(msgd, str2);
					format(str3, sizeof(str3), "* {FFFFFF}Tu Nick: {00FF00}%s\n", pName(warned));
					strcat(msgd, str3);
					format(str4, sizeof(str4), "* {FFFFFF}Motivo: Acumulación de Warns + {00FF00}%s\n", reason);
					strcat(msgd, str4);
					format(str5, sizeof(str5), "* {FFFFFF}Fecha: {00FF00}%d/%d/%d \n\n", day, month, year);
					strcat(msgd, str5);
					strcat(msgd, "{FFFFFF}Envía una foto de este Mensaje con F8 y muéstrasela a un Dueño\n");
					strcat(msgd, "o Encargado en caso de un Error!");
					ShowPlayerDialog(warned, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Kickeado - {FF0000}Revolucion {FFFFFF}Latina", msgd, "Aceptar", "");
					Kick(warned);
                	dUserSetINT(pName(warned)).("Advs",Usuario[warned][Advs]);
   	                dUserSetINT(pName(warned)).("Kicks",Usuario[warned][Kicks]);
                    return 1;
				}
				else
				{
				    new str[125];
					format(str, sizeof (str), "[INFO]:{FFFFFF} \"%s\" advirtió a \"%s\". [Razón: {00FF00}%s{FFFFFF}] [Adv: %d/3]", pName(playerid), pName(warned), reason, Usuario[warned][Advs]);
					return SendClientMessageToAll(yellow, str);
				}
			} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes darte advertencias a ti mismo");
		} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El jugador no está conectado");
	} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando.");
}

COMMAND:slap(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 2) {
new string2[60];
new Float:x, Float:y, Float:z;
new player1;
if(sscanf(params, "d", player1))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /slap [playerid]");
return 1;
}
if(IsPlayerConnected(player1))
{
CMDMessageToAdmins(playerid,"SLAP");
GetPlayerPos(player1,x,y,z); SetPlayerPos(player1,x,y,z+20);
format(string2,sizeof(string2),"Tú has sido abofeteado por %s.",pName(playerid));
SendClientMessage(player1,red,string2);
format(string2,sizeof(string2),"Tú has abofeteado a %s.",pName(player1));
SendClientMessage(playerid,ColorAdmin,string2);
} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El player no está conectado o es usted mismo");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}


CMD:burn(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 2)
{
new player1,Float:x, Float:y, Float:z;
new string2[128];
if(sscanf(params, "d", player1))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /burn [ID]");
return 1;
}
if(Usuario[player1][pAdmin] == 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando sobre un admin de mayor lvl");
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"BURN");
format(string2, sizeof(string2), "Has quemado a \"%s\".", pName(player1));
SendClientMessage(playerid,-1,string2);
if(player1 != playerid)
{
format(string2,sizeof(string2),"[INFO]: {FFFFFF}El Administrador \"%s\" te ha quemado.", pName(playerid));
SendClientMessage(player1,-1,string2);
}
GetPlayerPos(player1, x, y, z);
CreateExplosion(x, y , z + 3, 1, 10);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:setallmundo(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 6) {
new string2[100];
new var;
if(sscanf(params, "d", var))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /setallmundo [MundoVirtual]");
return 1;
}
CMDMessageToAdmins(playerid,"SETALLMUNDO");
for(new i, g = GetMaxPlayers(); i < g; i++){
if(IsPlayerConnected(i)) {
PlayerPlaySound(i,1057,0.0,0.0,0.0);
SetPlayerVirtualWorld(i,var);
}
}
format(string2,sizeof(string2),"[INFO]: {FFFFFF}\"%s\" pusó el mundo virtual de todos a '%d'.", pName(playerid),var);
SendClientMessageToAll(blue, string2);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes utilizar el comando!");
return 1;
}


CMD:qwarn(playerid,params[]) {
    if(Usuario[playerid][pAdmin] >= 2) {
        new warned;
	    if(sscanf(params,"d",warned)) return SendClientMessage(playerid, red, "[USA]:{FFFFFF} /qwarn [ID]");
    	warned = strval(params);
		new str[105];
		if(Usuario[warned][pAdmin] == 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando con este usuario.");
	 	if(IsPlayerConnected(warned) && warned != INVALID_PLAYER_ID) {
 	    	if(warned != playerid)
			 {
				if(Usuario[warned][Advs] < 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No le puedes sacar mas advertencias al player!");
			    CMDMessageToAdmins(playerid,"QWARN");
				Usuario[warned][Advs]--;
				format(str, sizeof (str), "[Administración]:{FFFFFF} \"%s\" le quitó una advertencia a \"%s\". [Adv: %d/3]", pName(playerid), pName(warned), Usuario[warned][Advs]);
				return SendClientMessageToAll(yellow, str);
			} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes quitarte las advertencias a ti mismo");
		} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El jugador no está conectado");
	} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Necesitas ser Operador [Lvl 2] para Usar este Comando!");
}
CMD:respawncars(playerid,params[])
{
    CMDMessageToAdmins(playerid,"RESPAWNCARS");
	if(Usuario[playerid][pAdmin] < 3) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permiso para usar el comando");
	for(new i, g = GetMaxPlayers(); i < g; i++)
	{
	if(TieneAuto[i] > 0){DestroyVehicle(TieneAuto[i]);TieneAuto[i] = 0;}
	SetVehicleToRespawn(i);
	}
	SendClientMessageToAll(yellow,"[Administración]: {FFFFFF}Autos respawneados {00FF00}correctamente{FFFFFF}.");
	return 1;
}

CMD:borrarchat(playerid,params[])
{
	if(Usuario[playerid][pAdmin] < 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permiso para usar el comando");
	for(new i;i<100;i++)
	{
	SendClientMessageToAll(-1,"");
	}
	SendClientMessageToAll(yellow,"[Administración]: {FFFFFF}Chat borrado {00FF00}correctamente{FFFFFF}.");
	CMDMessageToAdmins(playerid,"BORRARCHAT");
	return 1;
}


CMD:spec(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 2)
{
new string2[128];
new specplayerid;
if(sscanf(params, "d", specplayerid))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /spec [ID]");
return 1;
}
if(Usuario[specplayerid][pAdmin] == 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando sobre un admin");
if(IsPlayerConnected(specplayerid) && specplayerid != INVALID_PLAYER_ID)
{
if(specplayerid == playerid) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}No puedes vigilarte a ti mismo");
if(GetPlayerState(specplayerid) == PLAYER_STATE_SPECTATING && Usuario[specplayerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El Player está Spectando");
if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Player no Spawneado");
StartSpectate(playerid, specplayerid);
CMDMessageToAdmins(playerid,"SPEC");
GetPlayerPos(playerid,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
GetPlayerFacingAngle(playerid,Pos[playerid][3]);
format(string2,sizeof(string2), "[INFO]: {FFFFFF}%s empezó a spectar al jugador %s [ID: %d]",pName(playerid),pName(specplayerid),specplayerid);
MessageToAdmins(green,string2);
SendClientMessage(playerid,ColorAdmin,"Vigilando...");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El player no está conectado.");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:specoff(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 2)
{
if(Usuario[playerid][SpecType] != ADMIN_SPEC_TYPE_NONE)
{
StopSpectate(playerid);
SetPlayerInterior(playerid, 0);
SetPlayerVirtualWorld(playerid, 0);
CMDMessageToAdmins(playerid,"SPECOFF");
SendClientMessage(playerid,ColorAdmin,"Ya no estás spectando.");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Usted no está spectando");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}


CMD:invisible(playerid, params[])
{
if(Usuario[playerid][pVip] >= 1)
{
for(new i = GetPlayerPoolSize(); i != -1; --i) ShowPlayerNameTagForPlayer(i, playerid, 0);
SetPlayerColor(playerid, 0xFFFFFF00);
CMDMessageToVips(playerid,"INVISIBLE");
GameTextForPlayer(playerid, "~n~~n~~n~~n~~g~Invisible!",2500,3);
Usuario[playerid][Invisible] = 1;
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
{
new int1 = GetPlayerInterior(playerid);
LinkVehicleToInterior(GetPlayerVehicleID(playerid),int1+1);
}
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No eres VIP!");
return 1;
}

CMD:visible(playerid, params[])
{
if(Usuario[playerid][pVip] >= 1)
	{
	for(new i = GetPlayerPoolSize(); i != -1; --i) ShowPlayerNameTagForPlayer(i, playerid, 1);
	SetPlayerColor(playerid, verde);
	CMDMessageToVips(playerid,"VISIBLE");
	Usuario[playerid][Invisible] = 0;
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~b~Visible!",2500,3);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	new int1 = GetPlayerInterior(playerid);
	LinkVehicleToInterior(GetPlayerVehicleID(playerid),int1);
	}
	} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No eres VIP!");
return 1;
}

CMD:ltune(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 1 || Usuario[playerid][pVip] >= 1)
{
new LVehicleID = GetPlayerVehicleID(playerid), LModel = GetVehicleModel(LVehicleID);
if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No estás en un vehículo!");
switch(LModel)
{
case 448,461,462,463,468,471,509,510,521,522,523,581,586,449:
return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes tunear este vehículo!");
}
CMDMessageToVips(playerid,"LTUNE");
SetVehicleHealth(LVehicleID,2000.0);
TuneLCar(LVehicleID);
} else SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Necesitas ser Administrador nivel 1 o VIP para usar este comando");
return 1;
}


CMD:vida(playerid,params[])
{
	if(Usuario[playerid][pVip] >= 2)
	{
	new resultado = GetTickCount() - UsoVida[playerid];
	if(resultado < 300000) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando tan seguido.");
	SetPlayerHealth(playerid,100);
	SendClientMessage(playerid,yellow,"[INFO]: {FFFFFF}Regeneraste tu vida, espera 5 minutos para volver a hacerlo.");
	UsoVida[playerid] = GetTickCount();
	} else SCM(playerid,red,"[ERROR]: {FFFFFF}Debes ser VIP para usar el comando!");
	return 1;
}

CMD:vjetpack(playerid, params[])
{
new resultado = GetTickCount() - UsoJ[playerid];
if(resultado < 60000) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando tan seguido.");
if(Usuario[playerid][pVip] >= 2)
{

SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
SendClientMessage(playerid,COLOR_YELLOW,".:|INFO|:. {FFFFFF}Apareciste un Jetpack correctamente.");
CMDMessageToVips(playerid,"VJETPACK");
UsoJ[playerid] = GetTickCount();
} else return  SendClientMessage(playerid,COLOR_red,"[ERROR]: {FFFFFF}No tienes el VIP necesario para usar el comando.");
return 1;
}

CMD:fly(playerid, params[])
{
 	if(Usuario[playerid][pVip] >= 2)
 	{
 	if(EstaEnFly[playerid] == 0)
	{
	StartFly(playerid);
	EstaEnFly[playerid] = 1;
	return 1;
  	}
 	if(EstaEnFly[playerid] == 1)
 	{
	StopFly(playerid);
	EstaEnFly[playerid] = 0;
	return 1;
  	}
  	}
  	else SendClientMessage(playerid, COLOR_YELLOW,"[ERROR]: {FFFFFF}No tienes el VIP necesario para usar el comando!");
return 1;
}

CMD:chaleco(playerid,params[])
{
	if(Usuario[playerid][pVip] >= 3)
	{
	new resultado = GetTickCount() - UsoChaleco[playerid];
	if(resultado < 300000) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando tan seguido.");
	SetPlayerArmour(playerid,100);
	SendClientMessage(playerid,yellow,"[INFO]: {FFFFFF}Regeneraste tu chaleco, espera 5 minutos para volver a hacerlo.");
	UsoChaleco[playerid] = GetTickCount();
	} else SCM(playerid,red,"[ERROR]: {FFFFFF}Debes ser VIP para usar el comando!");
	return 1;
}

CMD:bici(playerid, params[])
{
if(Usuario[playerid][pVip] >= 3)
{
if(SaltosBici[playerid] > 0)
{
SaltosBici[playerid] = 0;
CMDMessageToVips(playerid,"BICI (OFF)");
SendClientMessage(playerid,COLOR_YELLOW,"[INFO]: {FFFFFF}Super saltos en bici desactivado.");
}
else
{
SaltosBici[playerid] = 1;
CMDMessageToVips(playerid,"BICI (ON)");
SendClientMessage(playerid,COLOR_YELLOW,"[INFO]: {FFFFFF}Super saltos en bici activado. Usa /bici para desactivarlo.");
}
} else return SendClientMessage(playerid,COLOR_red,"[ERROR]: {FFFFFF}No puedes usar el comando!.");
return 1;
}

CMD:velocidad(playerid, params[])
{
if(Usuario[playerid][pVip] >= 3 && AceleracionBrutal[playerid] == false)
{
if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF0000AA, "[ERROR]: {FFFFFF}No estas en un vehiculo!");
if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, 0xFF0000AA, "[ERROR]: {FFFFFF}Debes ser el conductor del vehiculo!");
GameTextForPlayer(playerid, "~b~Velocidad ~w~On", 4000, 3);
AceleracionBrutal[playerid] = true;
CMDMessageToVips(playerid,"VELOCIDAD");
}
else if(AceleracionBrutal[playerid] == true && Usuario[playerid][pVip] >= 3)
{
GameTextForPlayer(playerid, "~b~Velocidad ~w~Off", 4000, 3);
AceleracionBrutal[playerid] = false;
CMDMessageToVips(playerid,"VELOCIDAD OFF");
} else return SendClientMessage(playerid, Rojo, "[ERROR]: {FFFFFF}No eres VIP!");
return 1;
}

CMD:sayayin(playerid, params[])
{
if(Sayayin[playerid] == 0 && Usuario[playerid][pVip] >= 3)
		{
  		   	SetPlayerAttachedObject(playerid, 0, 19270, 1, 0.456246, 0.024526, 0.000000, 356.979461, 89.247146, 4.475475, 1.000000, 1.000000, 1.000000); // MapMarkerFire1 - hombre fuego
			SetPlayerAttachedObject(playerid, 1, 19270, 1, 0.176541, 0.051910, -0.001506, 23.633422, 90.000000, 197.080627, 1.000000, 1.000000, 1.000000); // MapMarkerFire1 - hombre fuegi
			SetPlayerAttachedObject(playerid, 2, 19270, 1, -0.308661, 0.051910, -0.001506, 23.633422, 90.000000, 197.080627, 1.000000, 1.000000, 1.000000); // MapMarkerFire1 - hombre fuegi
			SetPlayerAttachedObject(playerid, 3, 19270, 1, -0.729163, 0.051910, -0.001506, 23.633422, 90.000000, 197.080627, 1.000000, 1.000000, 1.000000); // MapMarkerFire1 - hombre fuegi
		    GameTextForPlayer(playerid,"~w~~h~~h~PODER SAYAYIN ~>~~y~ON~<~",5000,5);
		    SendClientMessage(playerid, red,"[INFO]:{FFFFFF} Has Activado El Modo Sayayin.");
		    Sayayin[playerid] = 1;
		    CMDMessageToVips(playerid,"SAYAYIN (ON)");
		}
  		else
        if(Usuario[playerid][pVip] >= 3 && Sayayin[playerid] == 1)
		{
  		if(IsPlayerAttachedObjectSlotUsed(playerid, 0)) {RemovePlayerAttachedObject(playerid, 0);}
		if(IsPlayerAttachedObjectSlotUsed(playerid, 1)) {RemovePlayerAttachedObject(playerid, 1);}
		if(IsPlayerAttachedObjectSlotUsed(playerid, 2)) {RemovePlayerAttachedObject(playerid, 2);}
		if(IsPlayerAttachedObjectSlotUsed(playerid, 3)) {RemovePlayerAttachedObject(playerid, 3);}
        SendClientMessage(playerid, red,"[INFO]: {FFFFFF}Desactivaste el modo sayayin.");
        Sayayin[playerid] = 0;
        CMDMessageToVips(playerid,"SAYAYIN (OFF)");
        } else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}No puedes usar el comando!");
return 1;
}


CMD:vcar(playerid, params[])
{
if(Usuario[playerid][pVip] >= 3)
{
new string2[128];
new Vehicle[32], VehicleID, ColorOne, ColorTwo;
new Float:pX,Float:pY,Float:pZ, Float:pAngle;
if(sscanf(params, "s[15]dd", Vehicle, ColorOne, ColorTwo))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /vcar [ID o nombre del vehículo] [Color1] [Color2]");
return 1;
}
if(IsPlayerInAnyVehicle(playerid)) return  SendClientMessage(playerid, red, "¡Error!: {FFFFFF}Ya estas en un vehículo!");
if(TieneAuto[playerid] != 0)
{
DestroyVehicle(TieneAuto[playerid]);
TieneAuto[playerid] = 0;
}
VehicleID = GetVehicleModelIDFromName(Vehicle);
if(VehicleID != 425 && VehicleID != 432 && VehicleID != 447 &&
VehicleID != 430 && VehicleID != 417 && VehicleID != 435 &&
VehicleID != 446 && VehicleID != 449 && VehicleID != 450 &&
VehicleID != 452 && VehicleID != 453 && VehicleID != 454 &&
VehicleID != 460 && VehicleID != 464 && VehicleID != 465 &&
VehicleID != 469 && VehicleID != 472 && VehicleID != 473 &&
VehicleID != 476 && VehicleID != 484 && VehicleID != 487 &&
VehicleID != 488 && VehicleID != 493 && VehicleID != 497 &&
VehicleID != 501 && VehicleID != 511 && VehicleID != 512 &&
VehicleID != 513 && VehicleID != 519 && VehicleID != 520 &&
VehicleID != 537 && VehicleID != 538 && VehicleID != 548 &&
VehicleID != 553 && VehicleID != 563 && VehicleID != 564 &&
VehicleID != 569 && VehicleID != 570 && VehicleID != 577 &&
VehicleID != 584 && VehicleID != 590 && VehicleID != 591 &&
VehicleID != 592 && VehicleID != 593 && VehicleID != 594 &&
VehicleID != 595 && VehicleID != 606 && VehicleID != 607 &&
VehicleID != 608 && VehicleID != 610 && VehicleID != 611)
{
if(VehicleID < 400 || VehicleID > 611)
{
return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Modelo de vehículo inválido.");
}
}
GetPlayerPos(playerid, pX, pY, pZ);
GetPlayerFacingAngle(playerid, pAngle);
TieneAuto[playerid] = CreateVehicle(VehicleID, pX, pY, pZ+2.0, pAngle, ColorOne, ColorTwo, -1);
LinkVehicleToInterior(TieneAuto[playerid], GetPlayerInterior(playerid));
SetVehicleVirtualWorld(TieneAuto[playerid],GetPlayerVirtualWorld(playerid));
PutPlayerInVehicle(playerid, TieneAuto[playerid], 0);
CMDMessageToVips(playerid,"VCAR");
format(string2, sizeof(string2), "[INFO]: {FFFFFF}Auto spawneado: [Nombre: %s] (Modelo:%d) Colores: %d y %d", VehicleNames[VehicleID-400], VehicleID, ColorOne, ColorTwo);
SendClientMessage(playerid,lightblue, string2);
} else SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos de usar el comando!");
return 1;
}


CMD:bengala(playerid, params[])
{
if(Usuario[playerid][pVip] >= 2)
     {
     new Float:X,Float:Y,Float:Z;
     GetPlayerPos(playerid,X,Y,Z);
     OBengala[playerid] = CreateObject(354,X,Y,Z+2,0,0,0);
     MoveObject(OBengala[playerid],X,Y,Z+100,15);
     SetTimerEx("ChauBengala", 2700, 0,"d",playerid);
     SetTimerEx("ChauBengala3",2850, 0,"d",playerid);
	 SetTimerEx("ChauBengala2",2920, 0,"d",playerid);
     } else SCM(playerid,red,"[ERROR]: {FFFFFF}No tienes el VIP correspondiente para usar el comando.");
return 1;
}


CMD:saltarauto(playerid, params[])
{
if(Usuario[playerid][pVip] >= 2)
{
if(SaltosAuto[playerid] == 0)
{
SaltosAuto[playerid] = 1;
CMDMessageToVips(playerid,"SALTARAUTO (ON)");
SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Activaste los saltos en autos con {00FF00}CTRL{FFFFFF}.");
}
else
{
SaltosAuto[playerid] = 0;
CMDMessageToVips(playerid,"SALTARAUTO (OFF)");
SendClientMessage(playerid,red,"[INFO]: {FFFFFF}Desactivaste los saltos en autos.");
}
} else SendClientMessage(playerid, Rojo, "[ERROR]: {FFFFFF}No eres VIP para utilizar el comando!");
return 1;
}


CMD:vscreen(playerid, params[])
{
if(Usuario[playerid][pVip] >= 2)
{
new string2[138],texto[50],player1;
if(sscanf(params, "ds[50]", player1, texto))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /vscreen [ID] [texto]");
return 1;
}
if(IsPlayerConnected(player1))
{
CMDMessageToVips(playerid,"VSCREEN");
format(string2,sizeof(string2),".:|ATENCIÓN|:. {FFFFFF}El jugador VIP %s te envió un mensaje a la pantalla.",pName(playerid));
SendClientMessage(player1,green,string2);
format(string2,sizeof(string2),".:|INFO|:. {FFFFFF}Enviaste a %s un mensaje a la pantalla.", pName(player1));
SendClientMessage(playerid,green,string2);
if(Usuario[playerid][pAdmin] != 10)
{
format(string2, sizeof(string2), "|-%s[%d] envió a %s[%d] : %s-|", pName(playerid), playerid, pName(player1), player1, texto);
MessageToAdmins(lightblue, string2);
}
GameTextForPlayer(player1, texto,4000,3);
} else return SendClientMessage(playerid, red, "¡Error!: {FFFFFF}El player no está conectado");
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}No tienes permiso de usar el comando!.");
return 1;
}

CMD:vflip(playerid, params[])
{
if(Usuario[playerid][pVip] >= 1)
{
if(IsPlayerInAnyVehicle(playerid))
{
new VehicleID, Float:X, Float:Y, Float:Z, Float:Angle; GetPlayerPos(playerid, X, Y, Z); VehicleID = GetPlayerVehicleID(playerid);
GetVehicleZAngle(VehicleID, Angle);	SetVehiclePos(VehicleID, X, Y, Z); SetVehicleZAngle(VehicleID, Angle);
CMDMessageToVips(playerid,"VFLIP");
SendClientMessage(playerid, blue,"[INFO]: {FFFFFF}El vehículo se enderezó correctamente.");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No estás en un vehiculo.");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}


CMD:fix(playerid, params[])
{
if(Usuario[playerid][pVip] >= 1)
{
if(IsPlayerInAnyVehicle(playerid)) {
new LVehicleID = GetPlayerVehicleID(playerid), LModel = GetVehicleModel(LVehicleID);
switch(LModel)
{
case 425,432,447,520:
return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes Fixear vehículos de guerra!");
}
new resultado = GetTickCount() - Reparar[playerid];
if(resultado < 30000) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando tan seguido.");
SetVehicleHealth(GetPlayerVehicleID(playerid),1250.0);
RepairVehicle(GetPlayerVehicleID(playerid));
CMDMessageToVips(playerid,"FIX");
Reparar[playerid] = GetTickCount();
SendClientMessage(playerid,blue,".:|INFO|:. {FFFFFF}El auto fue reparado.");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No estás en un vehículo");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Debes ser administrador o player Vip para usar este comando");
return 1;
}


CMD:darvip(playerid,params[])
{
		new id,nivel,string[156],string2[156];
		new TVIP[150];
		if(sscanf(params,"dd",id,nivel)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Usa: {00FF00}/darvip [ID] [NIVEL]{FFFFFF}.");
		if(Usuario[playerid][pAdmin] >= 8)
		{
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID)
		{
		if(nivel > 6) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El nivel ingresado es incorrecto.");
		if(nivel == Usuario[id][pVip]) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador ya tiene ese nivel.");
   		CMDMessageToAdmins(playerid,"DARVIP");
   		switch(nivel)
   		{
   		case 0: TVIP = "N/A";
		case 1: TVIP = "Bronce";
		case 2: TVIP = "Plata";
		case 3: TVIP = "Oro";
		case 4: TVIP = "Elite";
		case 5: TVIP = "Dios";
		case 6: TVIP = "Supremo";
		}
       	new year,month,day;   getdate(year, month, day); new hour,minute,second; gettime(hour,minute,second);
		if(nivel > 0)
		{
		format(string,sizeof(string),"[Administración]:{FFFFFF} El Administrador{FF0000} %s{FFFFFF} modificó tu nivel VIP a {29FF0D}%s{FFFFFF}.",pName(playerid), TVIP);
		SendClientMessage(id,yellow,string);
		}
		if(nivel > Usuario[id][pVip])
		{
		GameTextForPlayer(id,"~w~Nivel VIP~g~ aumentado", 6000, 3);
		} else GameTextForPlayer(id,"~w~Nivel VIP~r~ degradado", 6000, 3);
        format(string2,sizeof(string2),"[Administración]: {FFFFFF}Le diste nivel VIP %s a %s. {00FF00}[Nivel: %d|Datos: %d/%d/%d]",TVIP,pName(id), nivel, day, month, year, hour, minute, second);
		dUserSetINT(pName(id)).("VIP",(nivel));
		Usuario[id][pVip] = nivel;
		SendClientMessage(playerid,yellow,string2);
		return PlayerPlaySound(id,1057,0.0,0.0,0.0);
		} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado.");
		} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos para usar el comando.");
}

CMD:jail(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 3)
{
new razon[25],player1,jtime;
if(sscanf(params, "dds[15]", player1, jtime,razon))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /jail [ID] [minutos] [razón]");
return 1;
}
if(IsPlayerConnected(player1))
{
if(Usuario[player1][Encarcelado] == 0)
{
if(jtime == 0) return SendClientMessage(playerid,-1,"Los minutos deben ser mayores a 0.");
new string2[135];
CMDMessageToAdmins(playerid,"JAIL");
Usuario[player1][Ctiempo] = jtime*1000*60;
SetTimerEx("Encarcelar",5000,0,"d",player1);
SetTimerEx("Jail1",1000,0,"d",player1);
Usuario[player1][Encarcelado] = 1;
format(string2,sizeof(string2),"[INFO]:{FFFFFF} %s encarceló a %s por %d minutos. [Razón: {00FF00}%s{FFFFFF}]",pName(playerid), pName(player1), jtime, razon);
SendClientMessageToAll(yellow,string2);
} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El player ya está encarcelado.");
} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El player no está conectado!");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permiso para usar el comando!");
return 1;
}

CMD:unjail(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 3) {
new player1,string2[100];
if(sscanf(params, "d", player1))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /unjail [playerid]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
if(Usuario[player1][Encarcelado] == 1)
{
format(string2,sizeof(string2),"[INFO]: {FFFFFF}El Administrador %s ha liberado a %s.",pName(playerid), pName(player1));
Encarcelar1(player1);
SendClientMessageToAll(yellow,string2);
} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}el player no está encarcelado!");
} else return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}El player no está conectado!");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes utilizar el comando!");
return 1;
}


CMD:setvida(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 4)
{
new string2[85],player1,health;
if(sscanf(params, "dd", player1, health))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /setvida [jugador] [cantidad]");
return 1;
}

if(health > 100) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Cantidad de vida inválida");
if(Usuario[player1][pAdmin] == 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando sobre un admin");
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"SETVIDA");
format(string2, sizeof(string2), "Has puesto la vida de \"%s\" en '%d", pName(player1), health);
SendClientMessage(playerid,-1,string2);
SendClientMessage(player1,-1,"Un administrador cambió tu vida.");
SetPlayerHealth(player1,health);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tenés permisos para usar el comando!");
return 1;
}

CMD:setchaleco(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 4)
{
new string2[85],player1,health;
if(sscanf(params, "dd", player1, health))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /setchaleco [jugador] [cantidad]");
return 1;
}

if(health > 100) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Cantidad de chaleco inválida");
if(Usuario[player1][pAdmin] == 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando sobre un admin");
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"SETCHALECO");
format(string2, sizeof(string2), "Has puesto el chaleco de \"%s\" en '%d", pName(player1), health);
SendClientMessage(playerid,-1,string2);
SendClientMessage(player1,-1,"Un administrador cambió tu chaleco.");
SetPlayerArmour(player1,health);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tenés permisos para usar el comando!");
return 1;
}


CMD:darlevel(playerid,params[])
{
		new id,nivel,string[156],string2[156];
		if(Usuario[playerid][pAdmin] >= 9 || !strcmp("Carlosxp",pName(playerid),true) || !strcmp("[PFP]Scarface(Jefe)",pName(playerid),true) || !strcmp("]LsP[D]4Rk$iD3[L]_",pName(playerid),true))
		{
		if(sscanf(params,"dd",id,nivel)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Usa: {00FF00}/darlevel [ID] [NIVEL]{FFFFFF}.");
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID)
		{
		if(nivel > 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El nivel ingresado es incorrecto.");
		if(nivel == Usuario[id][pAdmin]) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador ya tiene ese nivel.");
   		CMDMessageToAdmins(playerid,"DARLEVEL (Admin)");
       	new year,month,day;   getdate(year, month, day); new hour,minute,second; gettime(hour,minute,second);
		if(nivel > 0)
		{
		format(string,sizeof(string),"[Administración]:{FFFFFF} El Administrador{FF0000} %s{FFFFFF} modificó tu nivel ADMINISTRATIVO a {29FF0D}%d{FFFFFF}.",pName(playerid), nivel);
		SendClientMessage(id,yellow,string);
		}
		if(nivel > Usuario[id][pAdmin])
		{
		GameTextForPlayer(id,"~w~Nivel administrativo~n~permanente~g~ aumentado", 6000, 3);
		} else GameTextForPlayer(id,"~w~Nivel administrativo~n~permanente~r~ degradado", 6000, 3);
        format(string2,sizeof(string2),"[Administración]: {FFFFFF}%s le dió nivel administrativo PERMANENTE a %s. {00FF00}[Nivel: %d|Datos: %d/%d/%d]",pName(playerid), pName(id), nivel, day, month, year, hour, minute, second);
		dUserSetINT(pName(id)).("AdminNivel",(nivel));
		Usuario[id][pAdmin] = nivel;
		SendClientMessageToAll(red,string2);
		GuardarUsuario(playerid);
		return PlayerPlaySound(id,1057,0.0,0.0,0.0);
		} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado.");
		} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos para usar el comando.");
}


CMD:setkicks(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 9)
{
new string2[128],kicks,player1;
if(sscanf(params, "dd", player1, kicks))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /setkicks [jugador] [N° kicks]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
if(kicks > 3) return SendClientMessage(playerid,-1,"Los kicks no pueden ser mayores a 3.");
CMDMessageToAdmins(playerid,"SETKICKS");
format(string2, sizeof(string2), "Has puesto los kicks de \"%s\" en '%d", pName(player1), kicks);
SendClientMessage(playerid,-1,string2);
if(player1 != playerid)
{
format(string2,sizeof(string2),"[Administración]:{FFFFFF}\"%s\" pusó tus kicks en '%d'", pName(playerid), kicks);
SendClientMessage(player1,blue,string2);
}
Usuario[player1][Kicks] = kicks;
dUserSetINT(pName(player1)).("Kicks",Usuario[player1][Kicks]);
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"¡Error!: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:cadmin(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 9)
{
if(ColorChat[playerid] == 0) {
ColorChat[playerid] = 1;
return CMDMessageToAdmins(playerid,"CADMIN");
} else {
ColorChat[playerid] = 0;
} CMDMessageToAdmins(playerid,"CADMIN (Off)");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}


CMD:fakecmd(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 10)
{
new player1,tmp2[40];
if(sscanf(params, "us[40]", player1, tmp2))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /fakecmd [ID] [Comando]");
return 1;
}
if(Usuario[player1][pAdmin] == 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando sobre un admin");
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"FAKECMD");
CallRemoteFunction("OnPlayerCommandText", "is", player1, tmp2);
SendClientMessage(playerid,-1,"Comando fake enviado correctamente.");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El player no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando!");
return 1;
}



CMD:darleveltemp(playerid,params[])
{
		new id,nivel,string[156],string2[156];
		if(Usuario[playerid][pAdmin] >= 8)
		{
		if(sscanf(params,"dd",id,nivel)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Usa: {00FF00}/darleveltemp [ID] [NIVEL]{FFFFFF}.");
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID)
		{
		if(nivel > 8) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El nivel no puede ser mayor a 8.");
		if(nivel == Usuario[id][pAdmin]) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador ya tiene ese nivel.");
   		CMDMessageToAdmins(playerid,"DARLEVELTEMP");
       	new year,month,day;   getdate(year, month, day); new hour,minute,second; gettime(hour,minute,second);
		if(nivel > 0)
		{
		format(string,sizeof(string),"[Administración]:{FFFFFF} %s te hizo ADMINISTRADOR TEMPORAL nivel {29FF0D}%d{FFFFFF}.",pName(playerid), nivel);
		SendClientMessage(id,yellow,string);
		}
		if(nivel > Usuario[id][pAdmin])
		{
		GameTextForPlayer(id,"~w~Nivel administrativo~n~TEMPORAL~g~ aumentado", 6000, 3);
		} else GameTextForPlayer(id,"~w~Nivel administrativo~n~TEMPORAL~r~ degradado", 6000, 3);
        format(string2,sizeof(string2),"[Administración]: {FFFFFF}%s le dió nivel administrativo TEMPORAL a %s. {00FF00}[Nivel: %d|Datos: %d/%d/%d]",pName(playerid), pName(id), nivel, day, month, year, hour, minute, second);
		Temporal[id] = 1;
		Usuario[id][pAdmin] = nivel;
		SendClientMessageToAll(red,string2);
		return PlayerPlaySound(id,1057,0.0,0.0,0.0);
		} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado.");
		} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes permisos para usar el comando.");
}

CMD:darallnivel(playerid, params[])
{
if(Usuario[playerid][pAdmin] >= 8)
{
new string2[100];
new nivel;
if(sscanf(params, "d", nivel))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /darallnivel [Nivel]");
return 1;
}
CMDMessageToAdmins(playerid,"DARALLNIVEL");
for(new i, g = GetMaxPlayers(); i < g; i++)
{
if(IsPlayerConnected(i))
{
PlayerPlaySound(i,1057,0.0,0.0,0.0);
Usuario[i][Nivel] += nivel;
GuardarUsuario(i);
}
}
format(string2, sizeof(string2), "[INFO]: {FFFFFF}\"%s\" regaló a todos los usuarios '%d' de nivel!", pName(playerid), nivel);
SendClientMessageToAll(blue, string2);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:dardinero(playerid,params[])
{
new id,cantidad;
if(sscanf(params,"dd",id,cantidad)) return SCM(playerid,red,"[ERROR]: {FFFFFF}Utiliza /dardinero [ID] [CANTIDAD]");
if(!IsPlayerConnected(id)) return SCM(playerid,red,"[ERROR]: {FFFFFF}ID inválida.");
if(id == playerid) return SCM(playerid,red,"[ERROR]: {FFFFFF}Ingresaste tu ID!");
if(cantidad < Usuario[playerid][Dinero]) return SCM(playerid,red,"[ERROR]: {FFFFFF}No tienes ese dinero!");
if(cantidad < 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}Cantidad ingresada inválida.");
QuitarDinero(playerid,cantidad);
Usuario[id][Dinero] += cantidad;
GivePlayerMoney(id,cantidad);
new string[130];
format(string,sizeof(string),"Transferencia de dinero desde {00FF00}%s (%d){FFFFFF} hacia {00FF00}%s (%d){FFFFFF}. [$%d]",pName(playerid),playerid,pName(id),id,cantidad);
SCM(playerid,-1,string);
SCM(id,-1,string);
return 1;
}

CMD:darallscore(playerid, params[])
{
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(Usuario[playerid][pAdmin] >= 6)
{
new string2[100];
new score;
if(sscanf(params, "d", score))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /darallscore [Cantidad]");
return 1;
}
CMDMessageToAdmins(playerid,"DARALLSCORE");
for(new i, g = GetMaxPlayers(); i < g; i++)
{
if(IsPlayerConnected(i))
{
PlayerPlaySound(i,1057,0.0,0.0,0.0);
Usuario[i][Asesinatos] += score;
SetPlayerScore(i,Usuario[i][Asesinatos]);
GuardarUsuario(i);
}
}
format(string2, sizeof(string2), "[INFO]: {FFFFFF}\"%s\" regaló a todos los usuarios '%d' de score!", pName(playerid), score);
SendClientMessageToAll(blue, string2);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}

CMD:setscore(playerid, params[])
{
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(Usuario[playerid][pAdmin] >= 8)
{
new string2[100],player1,score;
if(sscanf(params, "dd", player1, score))
{
SendClientMessage(playerid, red, "[USA]:{FFFFFF} /setscore [ID] [puntaje]");
return 1;
}
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
CMDMessageToAdmins(playerid,"SETSCORE");
format(string2, sizeof(string2), "Has puesto el puntaje de \"%s\" en '%d' ", pName(player1), score);
SendClientMessage(playerid,-1,string2);
if(player1 != playerid)
{
format(string2,sizeof(string2),"[INFO]: {FFFFFF}E\"%s\" ha puesto tu puntaje en {00FF00}'%d'{FFFFFF}.", pName(playerid), score);
SendClientMessage(player1,red,string2);
}
SetPlayerScore(player1, score);
Usuario[player1][Asesinatos] = score;
GuardarUsuario(player1);
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El jugador no está conectado");
} else return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar el comando!");
return 1;
}


CMD:comprar(playerid,params[])
	{
	    if(strcmp(params,"casa",true) == 0)
	    {
	 	new id = IsPlayerNearProperty(playerid);
	 	new str[260];
		if(id == -1)
		{
			SendClientMessage(playerid, 0xFF0000AA, "No estás cerca de ninguna casa a la venta.");
			return 1;
		}
		if(PropInfo[id][PropO] == 1)
		{
		    SendClientMessage(playerid,-1,"Esta no es una casa, es otro tipo de propiedad.");
		    return 1;
  		}
		if(PlayerProps[playerid] == 2 && Usuario[playerid][pVip] == 0)
	    {
			format(str, 128, "{FFFFFF}Ya tienes {00FF00}%d{FFFFFF} propiedades, debes ser VIP para tener hasta 4.", PlayerProps[playerid]);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		if(PlayerProps[playerid] == 4)
	    {
			format(str, 128, "{FFFFFF}Ya tienes {00FF00}%d{FFFFFF} propiedades, no puedes tener más.", PlayerProps[playerid]);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		if(PropInfo[id][PropIsBought] == 1)
		{
			new ownerid = GetPlayerID(PropInfo[id][PropOwner]);
			if(ownerid == playerid)
			{
			    SendClientMessage(playerid, 0xFF0000AA, "Esta propiedad ya está comprada!");
			    return 1;
			}
 		}
		if(GetPlayerMoney(playerid) < PropInfo[id][PropValue] + PropInfo[id][PropValue]/10)
		{
		    format(str, 128, "Necesitas $%d para comprar esta propiedad.", PropInfo[id][PropValue] + PropInfo[id][PropValue]/10);
		    SendClientMessage(playerid, 0xFF0000AA, str);
		    return 1;
		}
		new string[100];
		PropInfo[id][PropOwner] = pName(playerid);
		PropInfo[id][PropIsBought] = 1;
		SendClientMessage(playerid,-1,"+====================================[NUEVA CASA]====================================+");
		format(str,128,"Se te quitó {00FF00}$%d{FFFFFF} por el valor de la casa.",PropInfo[id][PropValue]);
		SendClientMessage(playerid,-1,str);
		SendClientMessage(playerid,-1,"+====================================[NUEVA CASA]====================================+");
        QuitarDinero(playerid,PropInfo[id][PropValue]);
        format(string,sizeof(string),"Casa [{FF0000}COMPRADA{FFFFFF}]\nDueño: {00FF00}%s{FFFFFF}.\nValor: {00FF00}$%d",PropInfo[id][PropOwner],PropInfo[id][PropValue]);
 	    Update3DTextLabelText(PropInfo[id][Texto],0xFFFFFFFF,string);
 	    DestroyPickup(PropInfo[id][PickupNr]);
        PlayerProps[playerid]++;
        PropInfo[id][PickupNr] = CreatePickup(1272, 1, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ]);
        MapIconStreamer();
   		return 1;
		}
		
		if(strcmp(params,"restaurante",true) == 0)
	    {
	 	new id = IsPlayerNearProperty(playerid);
	 	new str[260];
		if(id == -1)
		{
			SendClientMessage(playerid, 0xFF0000AA, "No estás cerca de ningún restaurante a la venta.");
			return 1;
		}
		if(PropInfo[id][PropO] == 0)
		{
		    SendClientMessage(playerid,-1,"Esta no es un restaurante, es otro tipo de propiedad.");
		    return 1;
  		}
		if(PlayerProps[playerid] == 2 && Usuario[playerid][pVip] == 0)
	    {
			format(str, 128, "{FFFFFF}Ya tienes {00FF00}%d{FFFFFF} propiedades, debes ser VIP para tener hasta 4.", PlayerProps[playerid]);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		if(PlayerProps[playerid] == 4)
	    {
			format(str, 128, "{FFFFFF}Ya tienes {00FF00}%d{FFFFFF} propiedades, no puedes tener más.", PlayerProps[playerid]);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		if(PropInfo[id][PropIsBought] == 1)
		{
			new ownerid = GetPlayerID(PropInfo[id][PropOwner]);
			if(ownerid == playerid)
			{
			    SendClientMessage(playerid, 0xFF0000AA, "Esta propiedad ya está comprada!");
			    return 1;
			}
 		}
		if(GetPlayerMoney(playerid) < PropInfo[id][PropValue])
		{
		    format(str, 128, "Necesitas $%d para comprar esta propiedad.", PropInfo[id][PropValue]);
		    SendClientMessage(playerid, 0xFF0000AA, str);
		    return 1;
		}
		new string[368];
 		PropInfo[id][PropOwner] = pName(playerid);
		PropInfo[id][PropIsBought] = 1;
		SendClientMessage(playerid,-1,"------------------------------------------------------------------------------------------------------------------------------");
		format(str,128,"Se te quitó {00FF00}$%d{FFFFFF} por el valor de la propiedad.",PropInfo[id][PropValue]);
		SendClientMessage(playerid,-1,str);
		SendClientMessage(playerid,-1,"------------------------------------------------------------------------------------------------------------------------------");
		GananciaJugador[playerid] += PropInfo[id][PropValue]/10;
		PropInfo[id][PropEarning] = PropInfo[id][PropValue]/10;
        QuitarDinero(playerid, PropInfo[id][PropValue]);
        format(string,sizeof(string),"Restaurante\n{FFFFFF}Dueño: {00FF00}%s{FFFFFF}.\nValor: {00FF00}$%d{FFFFFF}\nGanancia: {00FF00}$%d",PropInfo[id][PropOwner],PropInfo[id][PropValue],PropInfo[id][PropValue]/10);
 	    Update3DTextLabelText(PropInfo[id][Texto],0x0000FFFF,string);
 	    DestroyPickup(PropInfo[id][PickupNr]);
        PlayerProps[playerid]++;
        PropInfo[id][PickupNr] = CreatePickup(1239, 1, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ]);
        MapIconStreamer();
        return 1;
		}
   		return SendClientMessage(playerid,-1,"Usa {00FF00}/comprar restaurante-casa{FFFFFF}.");
}
	
CMD:vender(playerid,params[])
	{
	    if(strcmp(params,"casa",true) == 0)
	    {
	    new str[128];
 		new propid = IsPlayerNearProperty(playerid);
		if(propid == -1)
		{
			SendClientMessage(playerid, 0xFF0000AA, "Tú no estás cerca de tu casa.");
			return 1;
		}
		if(PropInfo[propid][PropO] == 1)
		{
		SendClientMessage(playerid,-1,"Este es otro tipo de propiedad.");
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
		if(PropInfo[propid][PropIsBought] == 0)
		{
		    SendClientMessage(playerid,-1,"La propiedad no tiene dueño!");
		    return 1;
		}
		new string[190];
		format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, "En venta");
		PropInfo[propid][PropIsBought] = 0;
        format(string,sizeof(string),"Casa [{00FF00}EN VENTA{FFFFFF}]\nDueño: {00FF00}N/A{FFFFFF}.\nValor: {00FF00}$%d{FFFFFF}\nGastos: {00FF00}$%d{FFFFFF}\nUsa {00FF00}/comprar casa{FFFFFF} para adquirirla.",PropInfo[propid][PropValue],(PropInfo[propid][PropValue]/10));
		Update3DTextLabelText(PropInfo[propid][Texto],0xFFFFFFFF,string);
		format(str, 128, "Se te devolvió la mitad del valor de la casa: {00FF00}$%d", PropInfo[propid][PropValue]/2);
		DarDinero(playerid, PropInfo[propid][PropValue]/2);
        SendClientMessage(playerid, 0xFFFFFFFF, str);
        PlayerProps[playerid]--;
        EarningsForPlayer[playerid] -= PropInfo[propid][PropEarning];
		DestroyPickup(PropInfo[propid][PickupNr]);
		PropInfo[propid][PickupNr] = CreatePickup(1273, 1, PropInfo[propid][PropX], PropInfo[propid][PropY], PropInfo[propid][PropZ]);
        MapIconStreamer();
		return 1;
		}
		
		if(strcmp(params,"restaurante",true) == 0)
	    {
	    new str[128];
 		new propid = IsPlayerNearProperty(playerid);
		if(propid == -1)
		{
			SendClientMessage(playerid, 0xFF0000AA, "Tú no estás cerca de tu restaurante.");
			return 1;
		}
		if(PropInfo[propid][PropO] == 0)
		{
		SendClientMessage(playerid,-1,"Este es otro tipo de propiedad.");
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
		if(PropInfo[propid][PropIsBought] == 0)
		{
		    SendClientMessage(playerid,-1,"La propiedad no tiene dueño!");
		    return 1;
		}
		new string[200];
		format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, "En venta");
		PropInfo[propid][PropIsBought] = 0;
        format(string,sizeof(string),"Restaurante {FFFFFF}[{00FF00}EN VENTA{FFFFFF}]\nDueño: {00FF00}N/A{FFFFFF}.\nValor: {00FF00}$%d{FFFFFF}\nGanancia: {00FF00}$%d{FFFFFF}\nUsa {00FF00}/comprar restaurante{FFFFFF} para adquirirlo.",PropInfo[propid][PropValue],(PropInfo[propid][PropValue]/4));
		Update3DTextLabelText(PropInfo[propid][Texto],0x0000FFFF,string);
		format(str, 128, "Se te devolvió la mitad del valor del restaurante: {00FF00}$%d", PropInfo[propid][PropValue]/2);
		DarDinero(playerid, PropInfo[propid][PropValue]/2);
        SendClientMessage(playerid, 0xFFFFFFFF, str);
        PlayerProps[playerid]--;
        GananciaJugador[playerid] -= PropInfo[propid][PropEarning];
		DestroyPickup(PropInfo[propid][PickupNr]);
		PropInfo[propid][PickupNr] = CreatePickup(1273, 1, PropInfo[propid][PropX], PropInfo[propid][PropY], PropInfo[propid][PropZ]);
        MapIconStreamer();
		return 1;
		}
		return SendClientMessage(playerid,-1,"Usa {00FF00}/vender casa-restaurante");
	}
	

CMD:reloadbans(playerid,params[])
{
if(Usuario[playerid][pAdmin] < 10) return SendClientMessage(playerid,-1,"No puedes usar el comando!");
SendRconCommand("reloadbans");
SendClientMessage(playerid,-1,"Lista de bans re-cargada.");
return 1;
}


CMD:armas(playerid,params[])
{
if(Usuario[playerid][Modo] == 3) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar este comando en este modo!");
if(ECarrera[playerid] == 1) return SCM(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto en carrera! /acarrera");
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
ShowPlayerDialog(playerid,501,DIALOG_STYLE_TABLIST_HEADERS,"Tienda de armas",
"Tipo\n\
Armas blancas\n\
Armas Rw\n\
Armas Ww\n\
Armas Ww2\n\
Armas por AmmoPack's\n\
Listado de armas",
"Seleccionar", "Cancelar");
return 1;
}


CMD:plantar(playerid,params[])
{
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][SGRANADA] == 0) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes ningún C4.");
if(Usuario[playerid][SpecType] != ADMIN_SPEC_TYPE_NONE) return SendClientMessage(playerid,red, "[ERROR]: {FFFFFF}No puedes usar este comando cuando estás Spectando!");
if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, red, "[ERROR]: {FFFFFF}Primero bájate del vehículo.");
if(Plantada[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Ya tienes un C4 plantado.");
Usuario[playerid][SGRANADA]--;
ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0,0);
new Float:X, Float:Y, Float:Z;
GetPlayerPos(playerid,X,Y,Z);
GetXYInFrontOfPlayer(playerid, X,Y,0.7);
ObjetoBomba[playerid] = CreateObject(1252, X,Y,Z-1,0,0,0);
Plantada[playerid] = 1;
SendClientMessage(playerid,blue,"[C4]: {FFFFFF}Utiliza /detonar para hacer estallar la bomba.");
return 1;
}

CMD:detonar(playerid,params[])
{
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Plantada[playerid] == 0) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes ningún C4 plantado.");
new Float:X, Float:Y, Float:Z;
GetObjectPos(ObjetoBomba[playerid],X,Y,Z);
Plantada[playerid] = 0;
CreateExplosion(X,Y,Z,0,9999999);CreateExplosion(X,Y,Z,1,9999999);CreateExplosion(X,Y,Z,2,9999999);CreateExplosion(X,Y,Z,3,9999999);CreateExplosion(X,Y,Z,4,9999999);CreateExplosion(X,Y,Z,5,9999999);CreateExplosion(X,Y,Z,6,9999999);
CreateExplosion(X,Y,Z,7,9999999);CreateExplosion(X,Y,Z,8,9999999);CreateExplosion(X,Y,Z,9,9999999);CreateExplosion(X,Y,Z,10,9999999);CreateExplosion(X,Y,Z,11,9999999);CreateExplosion(X,Y,Z,12,9999999);CreateExplosion(X,Y,Z,13,9999999);CreateExplosion(X+5,Y,Z,1,9999999);CreateExplosion(X+5,Y,Z,2,9999999);
CreateExplosion(X+5,Y,Z,3,9999999);CreateExplosion(X+5,Y,Z,4,9999999);CreateExplosion(X+5,Y,Z,5,9999999);CreateExplosion(X+5,Y,Z,6,9999999);CreateExplosion(X+5,Y,Z,7,9999999);CreateExplosion(X+5,Y,Z,8,9999999);CreateExplosion(X+5,Y,Z,9,9999999);CreateExplosion(X+5,Y,Z,10,9999999);
DestroyObject(ObjetoBomba[playerid]);
return 1;
}
CMD:armaspack(playerid,params[])
{
if(PlayerInfoE[playerid][NoEvento] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Estás dentro de un evento!");
if(Minijuego[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
if(Usuario[playerid][Encarcelado] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar esto acá.");
if(Desmadre[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No puedes usar comandos acá, usa /out.");
ShowPlayerDialog(playerid,57,DIALOG_STYLE_TABLIST_HEADERS,"Armas por AmmoPacks",
"Tipo\tMunición\tPrecio\n\
C4 apocalíptico\t1\t22\n\
HS ROCKET\t5\t25\n\
RapidSpeed\t10 segundos\t17\n\
SniperKill\t20\t45\n\
MachineGun\t85\t10\n\
Granada\t5\t6\n\
Chaleco\t100 Armour\t18",
"Seleccionar", "Cancelar");
return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
AntiFlood_Hack(playerid);
if(killerid == INVALID_PLAYER_ID) return 0;
SendDeathMessage(killerid,playerid,reason);Usuario[playerid][Muertes]++;Usuario[killerid][Asesinatos]++;SetPlayerScore(killerid,Usuario[killerid][Asesinatos]);
DarDinero(killerid,350);SetPlayerChatBubble(playerid,"R{FF0000}L{FFFFFF}|{00FF00}Eliminado",blue,50,5000);new string5[30];format(string5,sizeof(string5),"Por: ~g~%s",pName(killerid));if(TieneAuto[playerid] > 0){DestroyVehicle(TieneAuto[playerid]);TieneAuto[playerid] = 0;}
TextDrawSetString(TextdrawM[playerid],string5);TextDrawShowForPlayer(playerid,Textdraw[4]);TextDrawShowForPlayer(playerid,TextdrawM[playerid]);SetTimerEx("SeVantd",3000,false,"d",playerid);
Racha[playerid] = 0;
if(CMuertes[killerid] == 0){
CMuertes[killerid]++;
Amuertes[killerid] = GetTickCount();
}
if(CMuertes[killerid] >= 1 && CMuertes[killerid] < 4)
{
CMuertes[killerid]++;
}
if(CMuertes[killerid] >= 4)
{
if(GetTickCount() - Amuertes[killerid] < 500)
{
new id;
id = killerid;
KickA(id,"FakeKill");
}
else
{
CMuertes[killerid] = 0;
Amuertes[killerid] = 0;
}
}
if(Racha[killerid] == 0){Racha[killerid]++;}
if(Desmadre[killerid] == 1){SetPlayerHealth(killerid,100);SendClientMessage(killerid,green,"[DESMADRE]: {FFFFFF}Vida regenerada por matar en desmadre.");Desmadre[playerid] = 1;}
if(Desmadre[playerid] == 1){Desmadre[playerid] = 1;}
if(PlayerGang[killerid] > 0 && PlayerGang[killerid] != PlayerGang[playerid]){new gangid = PlayerGang[killerid];
GangInfo[gangid][GANG_SCORE]++;}
switch(GetPlayerWantedLevel(playerid)){
case 1:{DarDinero(killerid,500);SendClientMessage(playerid,green,"[MATANZA]: {FFFFFF}Mataste a un usuario con {00FF00}1{FFFFFF} estrella.");}
case 2:{DarDinero(killerid,500);SendClientMessage(playerid,green,"[MATANZA]: {FFFFFF}Mataste a un usuario con {00FF00}2{FFFFFF} estrellas.");}
case 3:{DarDinero(killerid,1000);SendClientMessage(playerid,green,"[MATANZA]: {FFFFFF}Mataste a un usuario con {00FF00}3{FFFFFF} estrellas.");}
case 4:{DarDinero(killerid,1000);SendClientMessage(playerid,green,"[MATANZA]: {FFFFFF}Mataste a un usuario con {00FF00}4{FFFFFF} estrellas.");}
case 5:{DarDinero(killerid,1000);SendClientMessage(playerid,green,"[MATANZA]: {FFFFFF}Mataste a un usuario con {00FF00}5{FFFFFF} estrellas.");}
case 6:{DarDinero(killerid,1000);SendClientMessage(playerid,green,"[MATANZA]: {FFFFFF}Mataste a un usuario con {00FF00}6{FFFFFF} estrellas.");}}
switch(Racha[killerid]){
case 1:{GameTextForPlayer(killerid,"~>~~g~Era facil. ~r~x1~<~",2000,6);Racha[killerid]++;}
case 2:{GameTextForPlayer(killerid,"~>~~b~Boena esa! ~r~x2~<~",2000,6);Racha[killerid]++;}
case 3:{GameTextForPlayer(killerid,"~>~~r~Matalos! ~g~x3~<~",2000,6);Racha[killerid]++;}
case 4:{GameTextForPlayer(killerid,"~>~~b~Sigue asi! ~r~x4~<~",2000,6);Racha[killerid]++;}
case 5:{GameTextForPlayer(killerid,"~>~~b~Que proh. ~r~x5~<~",4000,6);Racha[killerid]++;}
case 6:{GameTextForPlayer(killerid,"~>~~b~AGUANTIAA ~r~x6~<~",4000,6);Racha[killerid]++;}
case 7:{GameTextForPlayer(killerid,"~>~~b~Chiteando. ~r~x7~<~",4000,6);Racha[killerid]++;}
case 8:{GameTextForPlayer(killerid,"~>~~b~Vas reportado ameoh ~r~x8~<~",4000,6);Racha[killerid]++;}
case 9:{GameTextForPlayer(killerid,"~>~~b~Me enseñas? ~r~x9~<~",4000,6);Racha[killerid]++;}
case 10:{GameTextForPlayer(killerid,"~>~~b~FANTASTIC! ~r~x10~<~",4000,6);Racha[killerid]++;
new string[100];
format(string,sizeof(string),"[RACHAS]: {FFFFFF}%s consiguió la racha de X10. {00FF00}[$1.000 & 5 score]",pName(killerid));
SendClientMessageToAll(green,string);DarDinero(killerid,1000);Usuario[killerid][Asesinatos] += 5;SetPlayerScore(killerid,Usuario[killerid][Asesinatos]);}
case 11:{GameTextForPlayer(killerid,"~>~~b~Ve por mas! ~r~x11~<~",4000,6);Racha[killerid]++;}
case 12:{GameTextForPlayer(killerid,"~>~~b~Mi pequeño saltamontes. ~r~x12~<~",4000,6);Racha[killerid]++;}
case 13:{GameTextForPlayer(killerid,"~>~~b~JAKER ~r~x13~<~",4000,6);Racha[killerid]++;}
case 14:{GameTextForPlayer(killerid,"~>~~b~Pues ya para. ~r~x14~<~",4000,6);Racha[killerid]++;}
case 15:{GameTextForPlayer(killerid,"~>~~b~Sos CJ :v ~r~x15~<~",4000,6);Racha[killerid]++;}
case 16:{GameTextForPlayer(killerid,"~>~~b~Vamos vamos! ~r~x16~<~",4000,6);Racha[killerid]++;}
case 17:{GameTextForPlayer(killerid,"~>~~b~Casi 20 :o ~r~x17~<~",4000,6);Racha[killerid]++;}
case 18:{GameTextForPlayer(killerid,"~>~~b~Prepara F8 ~r~x18~<~",4000,6);Racha[killerid]++;}
case 19:{GameTextForPlayer(killerid,"~>~~b~Esa punteria! ~r~x19~<~",4000,6);Racha[killerid]++;}
case 20:{GameTextForPlayer(killerid,"~>~~b~Que grande. ~r~x20~<~",4000,6);Racha[killerid]++;
new string[100];
format(string,sizeof(string),"[RACHAS]: {FFFFFF}%s consiguió la racha de X20. {00FF00}[$5.000 & 15 score]",pName(killerid));
SendClientMessageToAll(green,string);DarDinero(killerid,5000);Usuario[killerid][Asesinatos] += 15;SetPlayerScore(killerid,Usuario[killerid][Asesinatos]);}
case 21:{GameTextForPlayer(killerid,"~>~~b~Te hamo ~r~x21~<~",4000,6);Racha[killerid]++;}
case 22:{GameTextForPlayer(killerid,"~>~~b~A la mrd! ~r~x22~<~",4000,6);Racha[killerid]++;}
case 23:{GameTextForPlayer(killerid,"~>~~b~Muereee ~r~x23~<~",4000,6);Racha[killerid]++;}
case 24:{GameTextForPlayer(killerid,"~>~~b~Aimbot no? ~r~x24~<~",4000,6);Racha[killerid]++;}
case 25:{GameTextForPlayer(killerid,"~>~~b~Maton ~r~x25~<~",4000,6);Racha[killerid]++;}
case 26:{GameTextForPlayer(killerid,"~>~~b~Prepara F8 ~r~x26~<~",4000,6);Racha[killerid]++;}
case 27:{GameTextForPlayer(killerid,"~>~~b~Inparable! ~r~x27~<~",4000,6);Racha[killerid]++;}
case 28:{GameTextForPlayer(killerid,"~>~~b~Bye mouse. ~r~x28~<~",4000,6);Racha[killerid]++;}
case 29:{GameTextForPlayer(killerid,"~>~~b~TATATATA ~r~x29~<~",4000,6);Racha[killerid]++;}
case 30:{GameTextForPlayer(killerid,"~>~~b~F8 BB! ~r~x30~<~",4000,6);Racha[killerid] = 0;
new string[100];
format(string,sizeof(string),"[RACHAS]: {FFFFFF}%s consiguió la racha de X30. {00FF00}[$15.000 & 25 score]",pName(killerid));
SendClientMessageToAll(green,string);DarDinero(killerid,15000);Usuario[killerid][Asesinatos] += 25;SetPlayerScore(killerid,Usuario[killerid][Asesinatos]);SCM(playerid,red,"[RACHAS]: {FFFFFF}Por ser tan pro deberemos reiniciarte las rachas ameoh!");}}
if(PlayerInfoE[playerid][NoEvento] == 1){PlayerInfoE[playerid][NoEvento] = 0;SendClientMessage(playerid,green,"[EVENTO]: {FFFFFF}Moriste, por lo tanto, fuiste sacado del evento.");}
for(new x=0; x<MAX_PLAYERS; x++)
if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Usuario[x][SpecID] == playerid)
AdvanceSpectate(x);
return 1;
}


public OnPlayerUpdate(playerid)
{
    for(new i, g = GetMaxPlayers(); i < g; i++)
	{
	if(IsPlayerConnected(i))
	{
    new drunk2 = GetPlayerDrunkLevel(i);
    if(drunk2 < 100){SetPlayerDrunkLevel(i,2000);}
 	else
    {if(DLlast[i] != drunk2){new fps = DLlast[i] - drunk2;if((fps > 0) && (fps < 200))FPS2[i] = fps;DLlast[i] = drunk2;}}}}
    
    if(GetPlayerMoney(playerid) > Usuario[playerid][Dinero]){new resultado = GetPlayerMoney(playerid) - Usuario[playerid][Dinero];
	GivePlayerMoney(playerid, -resultado);
	}
   return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
    PlayerPlaySound(issuerid, 17802, 0.0, 0.0, 0.0);

	if(bodypart == 9 && Usuario[issuerid][SniperK] == 0)
	{
		new Silah = GetPlayerWeapon(issuerid);
		if(Usuario[playerid][God] == 0 && Usuario[issuerid][God] == 0)
		{
			if(Silah == 34)
			{
			SetPlayerHealth(playerid, 0);SendClientMessage(playerid, red, "[HEADSHOT]:{FFFFFF} Te dieron en la cabeza con SNIPER!");SendClientMessage(issuerid, green, "[HEADSHOT]:{FFFFFF} Mataste por HEADSHOT con SNIPER. +{00FF00}1{FFFFFF} Ammopack.");Usuario[issuerid][Ammopacks]++;
			}
		}
	}
	
	if(Usuario[issuerid][SniperK] >= 1)
	{
		new Silah = GetPlayerWeapon(issuerid);
		if(Usuario[playerid][God] == 0 && Usuario[issuerid][God] == 0)
		{
			if(Silah == 34)
			{
			SetPlayerHealth(playerid, 0);SendClientMessage(playerid, red, "[SniperKILL]:{FFFFFF} Te dieron con una SNIPERKILL!");SendClientMessage(issuerid, green, "[SniperKILL]:{FFFFFF} Mataste por SNIPERKILL.");Usuario[issuerid][SniperK]--;
			}
		}
	}
	return 1;
}


public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(SuperSprint[playerid] == 1)
	{
	new Float:X1, Float:Y1, Float:Z11,   Float:VX, Float:VY, Float:VZ,    Float:pAng;
 	GetPlayerCameraFrontVector(playerid, VX, VY, VZ);
    GetAnimationName(GetPlayerAnimationIndex(playerid), PlayerAnimLib[playerid], 32, PlayerAnimName[playerid], 32);
    if(strlen(PlayerAnimLib[playerid]) && !strcmp(PlayerAnimLib[playerid], "ped", true, 3))
    {
    if(newkeys & KEY_SPRINT)
    {
    GetPlayerFacingAngle(playerid, pAng);
    GetPlayerVelocity(playerid, X1, Y1, Z11);
    SetPlayerVelocity(playerid, floatsin(-pAng, degrees) * 0.6, floatcos(pAng, degrees) * 0.6 , (Z11*1)+0.001);
    }
    }
	}
	
	if(newkeys & KEY_NO)
	{
	if(IsPlayerInAnyVehicle(playerid))
	{
	if(GetTickCount() - ReparoA[playerid] < 30000) return SCM(playerid,red,"[ERROR]: {FFFFFF}Sólo cada 30 segundos puedes usar la tecla!");
	if(GetPlayerMoney(playerid) < 500) return SCM(playerid,red,"[ERROR]: {FFFFFF}Necesitas 500$ para reparar el auto!");
	ReparoA[playerid] = GetTickCount();
	QuitarDinero(playerid,500);
    SetVehicleHealth(GetPlayerVehicleID(playerid),1000.0);
	RepairVehicle(GetPlayerVehicleID(playerid));
	SendClientMessage(playerid,green,".:|INFO|:. {FFFFFF}Auto reparado con éxito!");
	}
	}
	
	if((oldkeys & (KEY_ACTION | KEY_ACTION)) == (KEY_ACTION | KEY_ACTION))
    {
	if(SaltosAuto[playerid] == 1 && IsPlayerInAnyVehicle(playerid))
    {
    new Float:x, Float:y, Float:z;
    GetVehicleVelocity(GetPlayerVehicleID(playerid), x, y, z);
    SetVehicleVelocity(GetPlayerVehicleID(playerid) ,x ,y ,z+0.1);
    }
	}
	
	if(SaltosBici[playerid] == 1 && JugadorEnBici(playerid))
	{
	new Float:x,Float:y,Float:z;
	GetVehicleVelocity(GetPlayerVehicleID(playerid),x,y,z);
	SetVehicleVelocity(GetPlayerVehicleID(playerid),x,y,z+(z*4));
	return 1;
	}

	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Usuario[playerid][SpecID] != INVALID_PLAYER_ID)
	{
		if(newkeys == KEY_JUMP) AdvanceSpectate(playerid);
		else if(newkeys == KEY_SPRINT) ReverseSpectate(playerid);
	}
	
	
	if(AceleracionBrutal[playerid] == true)
	{
	if(newkeys & KEY_FIRE && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
            new Float:X, Float:Y, Float:Z, Float:Velocidad;
            GetVehicleVelocity(GetPlayerVehicleID(playerid), X, Y, Z);
            Velocidad = floatmul(floatsqroot(floatadd(floatadd(floatpower(X, 2), floatpower(Y, 2)),  floatpower(Z, 2))), 100.0);
            if(Velocidad >= 100.0)
            {
                SetVehicleVelocity(GetPlayerVehicleID(playerid), X * 1.5, Y * 1.5, Z * 1.5);
    		} else
			  {
                SetVehicleVelocity(GetPlayerVehicleID(playerid), X * 3.0, Y * 3.0, Z * 3.0);
    		}
		}
    }
    
	if(IsPlayerInAnyVehicle(playerid) && Usuario[playerid][pVip] >= 2)
    {
		new nos = GetPlayerVehicleID(playerid);
		if(Nitro(nos) && (oldkeys & 1 || oldkeys & 4))
   		{
		RemoveVehicleComponent(nos, 1010);
		AddVehicleComponent(nos, 1010);
   		}
		if(newkeys == KEY_ACTION)
		{
	        switch(GetVehicleModel( GetPlayerVehicleID(playerid) ))
			{
			case 592,577,511,512,593,520,553,476,519,460,513,487,488,548,425,417,497,563,447,469:
			return 1;
			}

		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(DPM[playerid] == 1)
	{
	new string[120];
	format(string,sizeof(string),"{FFFFFF}Escribe el mensaje privado que deseas enviar a {00FF00}%s{FFFFFF} [ID: {00FF00}%d{FFFFFF}].",pName(clickedplayerid),clickedplayerid);
	ShowPlayerDialog(playerid,90,DIALOG_STYLE_INPUT,"|| PM ||",string,"Enviar","Cancelar");
	MPP[playerid] = clickedplayerid;
	return 1;
	}
	else
	{
	new TVIP[15], TxAdm[25];
	new TMODO[12];
	switch(Usuario[clickedplayerid][pVip])
   	{
   	case 0: TVIP = "N/A";
	case 1: TVIP = "Bronce";
	case 2: TVIP = "Plata";
	case 3: TVIP = "Oro";
	case 4: TVIP = "Elite";
	case 5: TVIP = "Dios";
	case 6: TVIP = "Supremo";
	}
	switch(Usuario[clickedplayerid][pAdmin])
	{
	case 0: TxAdm = "Normal";
	case 1: TxAdm = "Ayudante";
	case 2: TxAdm = "Moderador a Prueba";
	case 3: TxAdm = "Moderador";
	case 4: TxAdm = "Moderador Global";
	case 5: TxAdm = "Administrador a Prueba";
	case 6: TxAdm = "Co-administrador";
	case 7: TxAdm = "Administrador";
	case 8: TxAdm = "Administrador Global";
	case 9: TxAdm = "Encargado";
	case 10: TxAdm = "Dueño";
	}
	switch(Usuario[clickedplayerid][Modo])
	{
	case 0: TMODO = "N/A";
	case 1: TMODO = "Freeroam";
	case 2: TMODO = "DM";
	case 3: TMODO = "Carreras";
	}
	new string[325];
	format(string,sizeof(string),"{FFFFFF}Asesinatos:{00FF00} %d\n{FFFFFF}Muertes: {00FF00}%d\n{FFFFFF}Dinero: {00FF00}$%d\n{FFFFFF}Nivel Admin: {0000FF}%d [%s]\n{FFFFFF}VIP: {00FF00}%s\n{FFFFFF}Registro: {00FF00}%s\n{FFFFFF}Nivel: {00FF00}%d\n{FFFFFF}AmmoPacks: %d\nFPS: {00FF00}%d\n{FFFFFF}Modo: {00FF00}%s",
	Usuario[clickedplayerid][Asesinatos],Usuario[clickedplayerid][Muertes],GetPlayerMoney(clickedplayerid),Usuario[clickedplayerid][pAdmin],TxAdm,TVIP,Usuario[clickedplayerid][Registro],Usuario[clickedplayerid][Nivel],Usuario[clickedplayerid][Ammopacks],FPS2[clickedplayerid],TMODO);
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,pName(clickedplayerid),string,"Aceptar","");
	}
	return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
AntiFlood_Hack(playerid);
		if(dialogid == 1) return 1;
    	if(dialogid == DIALOG_ATTACH_INDEX_SELECTION)
        {
            if(response)
            {
                if(IsPlayerAttachedObjectSlotUsed(playerid, listitem))
                {
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_EDITREPLACE, DIALOG_STYLE_MSGBOX, \
                    "Objetos de usuario:", ""COL_WHITE"¿Quieres editar o borrar el objeto de este slot?", "Editar", "Borrar");
                }
                else
                {
                ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT_SELECTION,DIALOG_STYLE_LIST,"Objetos de usuario:","Opción:1 :: "COL_GREY"Menú de objetos\n"COL_WHITE"Opción:2 :: "COL_GREY"Objeto por ID","Siguiente(>>)","Atrás(<<)");
                }
                SetPVarInt(playerid, "AttachmentIndexSel", listitem);
            }
            return 1;
        }
        
		if(dialogid == 600)
        {
        if(response)
        {
        if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid,600,DIALOG_STYLE_INPUT,"|| Música ||","Inserta el link de la música.","Aceptar","Cancelar");
		PlayAudioStreamForAll(inputtext);
		SendClientMessageToAll(green,".:|ADMINISTRACIÓN|:. {FFFFFF}Un administrador púso música.");
		}
		return 1;
		}
        if(dialogid == DIALOG_ATTACH_OBJECT_SELECTION)
        {
            if(!response)
            {
                cmd_objetos(playerid,"");
            }
            if(response)
            {
                if(listitem==0) ShowModelSelectionMenuEx(playerid, AttachmentObjectsList, 228+38, "Objetos de usuario:", DIALOG_ATTACH_MODEL_SELECTION, 0.0, 0.0, 0.0, 1.0, 0x00000099, 0x000000EE, 0xACCBF1FF);
                if(listitem==1) ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT2_SELECTION,DIALOG_STYLE_INPUT,"Objeto de usuario: (Poner la ID del objeto)",""COL_WHITE"Para poner la ID de un objeto debes buscarla en ''http://wiki.sa-mp.com''.","Editar","Atrás(<<)");
                        }
                }
                
                
		if(dialogid == DIALOG_ATTACH_OBJECT2_SELECTION)
        {
            if(!response)
            {   ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT_SELECTION,DIALOG_STYLE_LIST,"Objetos: (Selecciona una opción)","Opción:1 :: "COL_GREY"Menú de objetos del servidor\n"COL_WHITE"Opción:2 :: "COL_GREY"Objeto por ID","Siguiente(>>)","Atrás(<<)");    }
                        if(response)
                        {
                                if(!strlen(inputtext))return SendClientMessage(playerid,-1,"ERROR: No puedes dejar esto en blanco."),ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT2_SELECTION,DIALOG_STYLE_INPUT,"Objetos de usuario: (Inserta la ID)",""COL_WHITE"Para poner la ID de un objeto mira ''http://wiki.sa-mp.com''.","Editar","Atrás(<<)");
                                if(!IsNumeric(inputtext)) return SendClientMessage(playerid,-1,"ER"),ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT2_SELECTION,DIALOG_STYLE_INPUT,"Objetos:",""COL_WHITE"Para poner la ID de un objeto mira ''http://wiki.sa-mp.com''.","Editar","Atrás(<<)");
                                new obj;
                            if(!sscanf(inputtext, "i", obj))
                                {
                                        if(GetPVarInt(playerid, "AttachmentUsed") == 1) EditAttachedObject(playerid, obj);
                                    else
                                    {
                                            SetPVarInt(playerid, "AttachmentModelSel", obj);
                                            new string[256+1];
                                            new dialog[500];
        for(new x;x<sizeof(AttachmentBones);x++)
        {
        format(string, sizeof(string), "Parte:%s\n", AttachmentBones[x]);
        strcat(dialog,string);
        }
        ShowPlayerDialog(playerid, DIALOG_ATTACH_BONE_SELECTION, DIALOG_STYLE_LIST, \
        "{FF0000}Modificación de objeto.", dialog, "Seleccionar", "Cancelar");
        }
        }
        }
        }
        if(dialogid == DIALOG_ATTACH_EDITREPLACE)
        {
            if(response) EditAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
            else
                        {
                            RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
                new file[256];
                            new name[24];
                            new x=GetPVarInt(playerid, "AttachmentIndexSel");
                            GetPlayerName(playerid,name,24);
                            format(file,sizeof(file),"Player Objects/%s.ini",name);
                            if(!dini_Exists(file)) return 1;
                            format(f1,15,"O_Model_%d",x);
                            format(f2,15,"O_Bone_%d",x);
                            format(f3,15,"O_OffX_%d",x);
                            format(f4,15,"O_OffY_%d",x);
                            format(f5,15,"O_OffZ_%d",x);
                            format(f6,15,"O_RotX_%d",x);
                            format(f7,15,"O_RotY_%d",x);
                            format(f8,15,"O_RotZ_%d",x);
                            format(f9,15,"O_ScaleX_%d",x);
                            format(f10,15,"O_ScaleY_%d",x);
                            format(f11,15,"O_ScaleZ_%d",x);
                            dini_Unset(file,f1);
                            dini_Unset(file,f2);
                            dini_Unset(file,f3);
                            dini_Unset(file,f4);
                            dini_Unset(file,f5);
                            dini_Unset(file,f6);
                            dini_Unset(file,f7);
                            dini_Unset(file,f8);
                            dini_Unset(file,f9);
                            dini_Unset(file,f10);
                            dini_Unset(file,f11);
                                DeletePVar(playerid, "AttachmentIndexSel");
            }
                        return 1;
        }
        
        if(dialogid == DIALOG_ATTACH_BONE_SELECTION)
        {
            if(response)
            {
                SetPlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"), GetPVarInt(playerid, "AttachmentModelSel"), listitem+1);
                EditAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
                SendClientMessage(playerid, 0xFFFFFFFF, "AVISO: También puede mantener ESPACIO y utilizar el ratón para ver desde ambos lados.");
            }
            DeletePVar(playerid, "AttachmentIndexSel");
            DeletePVar(playerid, "AttachmentModelSel");
            return 1;
        }

	if(dialogid == 271)
	{
	if(response)
	{
	switch(listitem)
	{
	case 0:
	{
	ShowPlayerDialog(playerid,272,DIALOG_STYLE_LIST,"|| Parkour's ||","{FFFFFF}Parkour {FF0000}[DIFÍCIL]\n{FFFFFF}Parkour {0000FF}[MEDIO]\n{FFFFFF}Parkour {00FF00}[FÁCIL]","Aceptar","Cancelar");
	}
	case 1:
	{
    ShowPlayerDialog(playerid,273,DIALOG_STYLE_LIST,"|| Drift ||","{FFFFFF}Drift N°1.","Aceptar","Cancelar");
    }
    case 2:
	{
    ShowPlayerDialog(playerid,274,DIALOG_STYLE_LIST,"|| Stunt ||","{FFFFFF}Stunt {00FF00}N°1{FFFFFF}.","Aceptar","Cancelar");
    }
    case 3:
	{
	new string4[165];
	format(string4,sizeof(string4),"{FFFFFF}Desmadre {00FF00}[Jugadores: %d]\n{FFFFFF}Swat vs Terroristas [DK|M4|MP5|EDC]\nZona abandonada [MicroUzi|ShawOff]\nMinigun\nGuerra [Tanques & más]",endesmadre);
    ShowPlayerDialog(playerid,275,DIALOG_STYLE_LIST,"|| DeathMatch ||",string4,"Aceptar","Cancelar");
    }
    }
    }
	return 1;
	}
	

if(dialogid == 1000){if(response){
switch(listitem)
{
case 0:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/si");}
case 1:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/no");}
case 2:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/rendirse");}
case 3:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/borracho");}
case 4:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/pensar");}
case 5:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/servir");}
case 6:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/servirse");}
case 7:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/bomba");}
case 8:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/arrestar");}
case 9:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/reir");}
case 10:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/mirar");}
case 11:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/asiento");}
case 12:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/asiento2");}
case 13:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/amenazar");}
case 14:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/agredido");}
case 15:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/rodar");}
case 16:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/llorar");}
case 17:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/festejar");}
case 18:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/encender");}
case 19:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/apagar");}
case 20:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/fumar");}
case 21:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/inhalar");}
case 22:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/vigilar");}
case 23:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/recostarse");}
case 24:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/saludo1");}
case 25:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/saludo2");}
case 26:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/saludo3");}
case 27:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/saludo4");}
case 28:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/palmada");}
case 29:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/agonizar");}
case 30:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/traficar");}
case 31:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/beso");}
case 32:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/crack");}
case 33:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/parar");}
case 34:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/beber");}
case 35:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/hablar");}
case 36:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/curar");}
case 37:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/turndownforwhats");}
case 38:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/cubrirse");}
case 39:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/vomitar");}
case 40:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/comer");}
case 41:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/despedirse");}
case 42:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/insultar");}
case 43:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/estreps");}
case 44:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/echarse");}
case 45:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/asientosexi");}
case 46:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/patinar1");}
case 47:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/patinar2");}
case 48:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/patinar3");}
case 49:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/superpatada");}
case 50:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/patada");}
case 51:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/dansas");}
case 52:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/fumar2");}
case 53:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/fumar3");}
case 54:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/llamar");}
case 55:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/colgar");}
case 56:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/recoger");}
case 57:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/botear");}
case 58:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/asustado");}
case 59:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/taxi");}
case 60:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/adolorido");}
case 61:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/nadar");}
case 62:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/rap");}
case 63:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/fuerza");}
case 64:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/fumar");}
case 65:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/sentarse");}
case 66:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/acciones2");}}}
return 1;}


if(dialogid == 1001){if(response){
switch(listitem)
{
case 1:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/rap2");}
case 2:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/rap3");}
case 3:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/piquero");}
case 4:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/taichi");}
case 5:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/boxear");}
case 6:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/gangsta");}
case 7:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/sexi");}
case 8:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/asco");}
case 9:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/comodo");}
}}return 1;}


	if(dialogid == 272){if(response){
	switch(listitem){
	case 0:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/parkour");}
	case 1:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/parkour2");}
	case 2:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/parkour3");}
	}}return 1;}
	
	
	if(dialogid == 273){if(response){
	switch(listitem)
	{
	case 0:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/drift");}}}
	return 1;}
	
	if(dialogid == 274){if(response){
	switch(listitem){
	case 0:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/stunt");}
	}}return 1;}
	
	if(dialogid == 275){if(response){
	switch(listitem){
	case 0:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/desmadre");}
	case 1:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/swat");}
	case 2:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/zona");}
	case 3:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/minigun");}
	case 4:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/guerra");}}}
	return 1;}
	
	if(dialogid == 276)
	{
	if(response){
	switch(listitem)
	{
	case 0:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/deswat");}
	case 1:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/deterro");}}}
	return 1;}
	
	if(dialogid == 275){if(response){
	switch(listitem)
	{
	case 0:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/stunt");}}}return 1;}
	
	if(dialogid == 277){if(!response){Kick(playerid);}if(response){
 	switch(listitem){
	case 0:{Minijuego[playerid] = 1;Desmadre[playerid] = 1;endesmadre++;SCM(playerid,blue,"[INFO]: {FFFFFF}Seleccionaste desmadre! sólo elige el skin y a jugar!");}
	case 1:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/swat");}
	case 2:{Zona[playerid] = 1;Minijuego[playerid] = 1;SCM(playerid,blue,"[INFO]: {FFFFFF}Seleccionaste la zona para matar! sólo elige el skin y a jugar!");}
	case 3:{Minigun[playerid] = 1;Minijuego[playerid] = 1;SCM(playerid,blue,"[INFO]: {FFFFFF}Seleccionaste el minijuego minigun! Sólo elige skin y a jugar!");}
	case 4:{Guerra[playerid] = 1;Minijuego[playerid] = 1;SCM(playerid,blue,"[INFO]: {FFFFFF}Seleccionaste el minijuego de guerra! Sólo elige skin y a jugar!");}}}
	return 1;}
	
	if(dialogid == 278){if(response){
	switch(listitem)
	{
	case 0:{Usuario[playerid][Modo] = 1;if(Desmadre[playerid] == 1){endesmadre--;}SpawnPlayer(playerid);Minigun[playerid] = 0;Minijuego[playerid] = 0;Desmadre[playerid] = 0;Guerra[playerid] = 0;Zona[playerid] = 0;if(GetPlayerTeam(playerid) > 0 && GetPlayerTeam(playerid) <= 254){SetPlayerTeam(playerid,255);}}
	case 1:{new string4[130];
	format(string4,sizeof(string4),"{FFFFFF}Desmadre {00FF00}[Jugadores: %d]\n{FFFFFF}Swat vs Terroristas [DK|M4|MP5|EDC]\nZona abandonada [MicroUzi|ShawOff]\nMinigun",endesmadre);
    ShowPlayerDialog(playerid,275,DIALOG_STYLE_LIST,"|| DeathMatch ||",string4,"Aceptar","Cancelar");}
    case 2:{SCM(playerid,green,"[MODOS]: {FFFFFF}Seleccionaste el modo de carreras, espera a que una se active. Serás llevado automáticamente.");Usuario[playerid][Modo] = 3;SpawnPlayer(playerid);}
	}
	}
	return 1;
	}
	
	if(dialogid == 270)
	{
	if(response){
	switch (listitem)
	{
	case 0:
	{
	SetPlayerPos(playerid,387.4625,171.7353,1008.3828);
	SetPlayerInterior(playerid,3);
	SetPlayerVirtualWorld(playerid,0);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}ESCONDIDAS{FFFFFF}'.");
	}
	case 1:
	{
	SetPlayerPos(playerid,1539.8459,-2579.8042,13.5469);
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid,0);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}Avión de la muerte{FFFFFF}'.");
	}
	case 2:
	{
	SetPlayerPos(playerid,296.2429,-1612.6998,114.4219);
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid,0);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}Avión tumbador{FFFFFF}'.");
	}
	case 3:
	{
	SetPlayerPos(playerid,-1399.1525, 1252.1205, 1040.1183);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 16);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}Rhino VS Kart{FFFFFF}'.");
	}
	case 4:
	{
	SetPlayerPos(playerid,509.2815,-72.9995,998.7578);
	SetPlayerInterior(playerid,11);
	SetPlayerVirtualWorld(playerid, 0);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}Pelea de borrachos{FFFFFF}'.");
	}
	case 5:
	{
	SetPlayerPos(playerid,1330.9161,2141.4485,11.0156);
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid, 0);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}DM{FFFFFF}'.");
	}
	case 6:
	{
	SetPlayerPos(playerid, 1417.3047,-47.5880,1000.9293);
	SetPlayerInterior(playerid,1);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}DM a DK{FFFFFF}'.");
	}
	case 7:
	{
	SetPlayerPos(playerid,-1399.1525, 1252.1205, 1040.1183);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 16);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}Rocket VS NRG-500{FFFFFF}'.");
	}
	case 8:
	{
	SetPlayerPos(playerid,1670.0000,-1266.0000,233.3750);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid,0);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}Torre Terrorista{FFFFFF}'.");
	}
	case 9:
	{
	SetPlayerPos(playerid,776.1259,-49.1077,1000.5859);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid,6);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}DM a Katanas{FFFFFF}'.");
	}
	case 10:
	{
	SetPlayerPos(playerid,-1004.4861,946.8848,34.5781);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid,0);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}Carrera a pie{FFFFFF}'.");
	}
	case 11:
	{
	SetPlayerPos(playerid,1106.8707,1529.8383,52.4007);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid,0);
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Bienvenido, acá puedes realizar el evento de '{FFFF00}Autos chocadores{FFFFFF}'.");
	}
	}
	}
	return 1;
	}

	if(dialogid == 280)
	{
	if(response)
	{
	switch(listitem)
	{
	case 0:
	{
	if(DPM[playerid] == 0)
	{
	DPM[playerid] = 1;
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Pusiste los PM's en diálogos.");
	}
	else
	{
	DPM[playerid] = 0;
	SendClientMessage(playerid,green,"[INFO]: {FFFFFF}Pusiste los PM's por chat.");
	}
	}
	case 1:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/colores");
	}
	case 2:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda casas");
	}
	case 3:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/cmdsvip");
	}
	case 4:
	{
	ShowPlayerDialog(playerid,281,DIALOG_STYLE_LIST,"|| Cuenta ||","Cambiar nombre\nCambiar contraseña\nCambiar correo","Aceptar","Aceptar");
	}
	case 5:
	{
	if(Bloqueado[playerid] == 1)
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/desbloquear");
	}
	else
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/bloquear");
	}
	}
	case 6:
	{
	ShowPlayerDialog(playerid,282,DIALOG_STYLE_INPUT,"|| Música ||","{FFFFFF}Ingresa el link de la música que quieres escuchar. Si no sabes mira la {00FF00}/ayuda musica{FFFFFF}.","Reproducir","Cancelar");
	}
	}
	}
	return 1;
	}

    if(dialogid == 282)
    {
    if(response)
    {
    if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid,282,DIALOG_STYLE_INPUT,"|| Música ||","{FFFFFF}Inserta el link de la música. Si no sabes mira la {00FF00/ayuda musica{FFFFFF}.","Aceptar","Cancelar");
	PlayAudioStreamForPlayer(playerid,inputtext);
	}
	return 1;
	}
		
		
	if(dialogid == 281)
	{
	if(response)
	{
	switch(listitem)
	{
	case 0:
	{
    CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/cambiar nombre");
    }
    case 1:
    {
    CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/cambiar contraseña");
    }
    case 2:
    {
    SendClientMessage(playerid,green,"[CUENTA]: {FFFFFF}Los cambios de correo se deben pedir a un dueño por privado.");
    }
    }
    }
    return 1;
    }
	if(dialogid == 55)
	{
	if(response)
	{
	switch(listitem)
	{
	case 0:
	{
	if(Usuario[playerid][pAdmin] >= 1)
	{
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Nivel 1 ||","{FFFFFF}Los comandos para ayudantes son:\n{00FF00}/mute{FFFFFF}: Muteas a un usuario.\n{00FF00}/unmute{FFFFFF}: Desmuteas un usuario.\n{00FF00}/borrarchat{FFFFFF}: Limpias el chat del servidor.\n{00FF00}/ip{FFFFFF}: Obtienes la IP de un jugador.\n{00FF00}/etest{FFFFFF}: Enciendes el test de reacción.\n{00FF00}/fincarreras{FFFFFF}: Terminas todas las carreras!","Aceptar","");
	}
	}
	case 1:
	{
	if(Usuario[playerid][pAdmin] >= 2)
	{
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Nivel 2 ||","{FFFFFF}Los comandos para Mod a Prueba son todos los anteriores más:\n{00FF00}/ira{FFFFFF}: Vas hacia un usuario.\n{00FF00}/traer{FFFFFF}: Traes a un usuario.\n{00FF00}/warn{FFFFFF}: Das una advertencia.\n{00FF00}/qwarn{FFFFFF}: Quitas una advertencia.\n{00FF00}/aduty{FFFFFF}: Activas y desactivas tu admin duty.\n{00FF00}/weaps{FFFFFF}: Miras las armas de un usuario.\n{00FF00}/burn{FFFFFF}: Quemas un usuario.","Aceptar","");
	}
	}
	case 2:
	{
	if(Usuario[playerid][pAdmin] >= 3)
	{
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Nivel 3 ||","{FFFFFF}Los comandos para Moderador son todos los anteriores más:\n{00FF00}/congelar{FFFFFF}: Congelas un usuario.\n{00FF00}/descongelar{FFFFFF}: Descongelas un usuario.\n{00FF00}/kick{FFFFFF}: Kickeas un usuario.\n{00FF00}/jail{FFFFFF}: Sancionas a un user.\n{00FF00}/unjail{FFFFFF}: Sacas a un user de jail.\n{00FF00}/respawncars{FFFFFF}: Re-apareces los autos.\n{00FF00}/dararma{FFFFFF}: Das un arma a un usuario.","Aceptar","");
	}
	}
	case 3:
	{
	if(Usuario[playerid][pAdmin] >= 4)
	{
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Nivel 4 ||","{FFFFFF}Los comandos para Moderador Global son todos los anteriores más:\n{00FF00}/setvida{FFFFFF}: Pones la vida de un usuario a X cantidad.\n{00FF00}/setchaleco{FFFFFF}: Ponés el chaleco de un usuario a X cantidad.\n{00FF00}/setmundo{FFFFFF}: Seteas el MV.\n{00FF00}/setinterior{FFFFFF}: Ponés en un interior a un usuario.\n{00FF00}/setcolor{FFFFFF}: Seteas el color de un usuario.\n{00FF00}/lgoto{FFFFFF}: Vas a X,Y,Z.","Aceptar","");
	}
	}
	case 4:
	{
	if(Usuario[playerid][pAdmin] >= 5)
	{
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Nivel 5 ||","{FFFFFF}Los comandos para Admin a Prueba son todos los anteriores más:\n{00FF00}/setcash{FFFFFF}: Ponés el dinero de un usuario a una cierta cantidad.\n{00FF00}/darscore{FFFFFF}: Agregas score a un usuario.\n{00FF00}/setskin{FFFFFF}: Le ponés un skin a un usuario.\n{00FF00}/setinterior{FFFFFF}: Ponés en un interior a un usuario.\n{00FF00}/announce{FFFFFF}: Un anuncio en pantalla a todo el sv.","Aceptar","");
	}
	}
	case 5:
	{
	if(Usuario[playerid][pAdmin] >= 6)
	{
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Nivel 6 ||","{FFFFFF}Los comandos para Co-administrador son todos los anteriores más:\n{00FF00}/vidaall{FFFFFF}: Restauras la vida de todos.\n{00FF00}/chalecoall{FFFFFF}: Das armadura a todos.\n{00FF00}/setallmundo{FFFFFF}: Ponés a todos los usuarios un MV.\n{00FF00}/darallcash{FFFFFF}: Das a todos los usuarios dinero.\n{00FF00}/announce2{FFFFFF}: Un anuncio a todos los usuarios.\n{00FF00}/darallscore{FFFFFF}: Das score a todos.","Aceptar","");
	}
	}
	case 6:
	{
	if(Usuario[playerid][pAdmin] >= 7)
	{
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Nivel 7 ||","{FFFFFF}Los comandos para Administrador son todos los anteriores más:\n{00FF00}/godcar{FFFFFF}: Activas/desactivas el god de tu auto.\n{00FF00}/ban{FFFFFF}: Baneas a un usuario del servidor.\n{00FF00}/setallmundo{FFFFFF}: Ponés a todos los usuarios un MV determinado.\n{00FF00}/setnivel{FFFFFF}: Seteas los niveles de una persona.\n{00FF00}/darnivel{FFFFFF}: Das X cantidad de niveles a un usuario.","Aceptar","");
	}
	}
	case 7:
	{
	if(Usuario[playerid][pAdmin] >= 8)
	{
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Nivel 8 ||","{FFFFFF}Los comandos para Administrador Global son todos los anteriores más:\n{00FF00}/rban{FFFFFF}: Le das ban IP a un usuario.\n{00FF00}/darvip{FFFFFF}: Das VIP a un usuario.\n{00FF00}/darleveltemp{FFFFFF}: Das admin TEMP.\n{00FF00}/setscore{FFFFFF}: Ponés X cantidad de score a un usuario.\n{00FF00}/darallnivel{FFFFFF}: Das X cantidad de nivel/es a los usuarios.\nUsa & para hablar en chat admin alto.","Aceptar","");
	}
	}
	case 8:
	{
	if(Usuario[playerid][pAdmin] >= 9)
	{
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Nivel 9 ||","{FFFFFF}Los comandos para Encargado son todos los anteriores más:\n{00FF00}/darlevel{FFFFFF}: Das admin PERM.\n{00FF00}/setkicks{FFFFFF}: Ponés los kicks de un usuario a X.\n{00FF00}/insertar{FFFFFF}: Ponés una música para todos los usuarios.\n{00FF00}/darallarmas{FFFFFF}: Das armas a todos los usuarios.","Aceptar","");
	}
	}
	case 9:
	{
	if(Usuario[playerid][pAdmin] >= 10)
	{
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Nivel 10 ||","{FFFFFF}Los comandos para Dueño son todos los anteriores más:\n{00FF00}/ccasa{FFFFFF}: Creas un casa.\n{00FF00}/cres{FFFFFF}: Creas un restaurante.\n{00FF00}/fakecmd{FFFFFF}: Haces que un usuario ponga un comando a la fuerza.\nUsa las comillas para hablar por chat de dueños.\nComando de consola: /reloadbans: Recarga la lista de bans.","Aceptar","");
	}
	}
	}
 	}
	return 1;
	}
 	if(dialogid == INVITAR)
	{
		if (response)
		{
            if(PlayerGang[playerid] == 1) return SendClientMessage(playerid, COLOR_ROJO, "¡Error!: {FFFFFF}Tú Debes Salir Primero De Tu Clan!");
            if(invited[playerid] == 0) return SendClientMessage(playerid, COLOR_ROJO, "¡Error!: {FFFFFF}No Has Sido Invitado a Ningún Clan!");
            JoinGang(playerid, invited[playerid]);
		}
		if (!response)
		{
            invited[playerid] = 0;
            SendClientMessage(playerid, COLOR_ROJO, "[INFO]: {FFFFFF}Rechazaste la invitación de clan!");
		}
        return 1;
	}
	
	if(dialogid == DIALOG_EVENTO)
	{
	    if(response)
		{
		    switch (listitem)
			{
				case 0:
				{
					if(EventInfo[Criado] == 1) return SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}Ya existe un evento Abierto, Finalíselo para crear otro!");
   					if(SEVENTO == 1) return SendClientMessage(playerid,red, "[ERROR]: {FFFFFF}Ya hay un Evento/Carrera. Espera a que termine!");
					ShowPlayerDialog(playerid, DIALOG_NOMEEVENTO, DIALOG_STYLE_INPUT, "{00FF00}Creación de Evento", "Digite el Nombre del Evento:", "Continuar", "");
					return 1;
				}
				case 1:
				{
					if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					SetPlayerPos(playerid, EventInfo[Xq], EventInfo[Yq], EventInfo[Zq]);
					SetPlayerVirtualWorld(playerid, EventInfo[VirtualWorld]);
					SetPlayerInterior(playerid, EventInfo[Interior]);
					SendClientMessage(playerid, COLOR_AMARILLO, "[EVENTO]: Fuiste llevado a la Ubicacion del Evento!");
					return 1;
				}
				case 2:
				{
					if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					ShowPlayerDialog(playerid, DIALOG_ARMA, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite la ID del Arma que darás a\ntodos los Jugadores del Evento:", "Continuar", "Cancelar");
					return 1;
				}
				case 3:
				{
					if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					ShowPlayerDialog(playerid, DIALOG_CARRO, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite la ID del Vehículo que darás a\ntodos los Jugadores del Evento:\n\n(0 = Nenhum)", "Continuar", "Cancelar");
					return 1;
				}
				case 4:
				{
					if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					ShowPlayerDialog(playerid, DIALOG_FIM1, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite la ID del Primer Lugar del Evento:", "Continuar", "Cancelar");
					return 1;
				}
				case 5:
				{
					if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					ShowPlayerDialog(playerid, DIALOG_VIDAVEICULOS, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite la Vida que deseas definir a los\nVehículos del Evento:", "Definir", "Cancelar");
					return 1;
				}
				case 6:
				{
					if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					ShowPlayerDialog(playerid, DIALOG_KICK, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite la ID del Jugador que deseas Kickear del Evento:", "Kickar", "Cancelar");
					return 1;
				}
				case 7:
				{
					if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					ShowPlayerDialog(playerid, DIALOG_VIDA, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite la Vida que deseas definir a los\nJugadores del Evento", "Definir", "Cancelar");
					return 1;
				}
				case 8:
				{
					if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					ShowPlayerDialog(playerid, DIALOG_SKIN1, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite la ID del Skin que deseas\naplicar a los Jugadores del Evento:", "Definir", "Cancelar");
					return 1;
				}
				case 9:
				{
					if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					for(new p = 0; p < MAX_PLAYERS; p++)
					{
						if(PlayerInfoE[p][NoEvento] == 1)
						{
							TogglePlayerControllable(p, 0);
						}
					}
					GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
					format(Format, sizeof(Format), "[EVENTO]: {FFFFFF}El administrador %s congeló a los usuarios del evento!", NomePlayer);
					SendEventMessage(COR_INFO, Format);
					return 1;
				}
				case 10:
				{
					if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					for(new p = 0; p < MAX_PLAYERS; p++)
					{
						if(PlayerInfoE[p][NoEvento] == 1)
						{
							TogglePlayerControllable(p, 1);
						}
					}
					GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
					format(Format, sizeof(Format), "[EVENTO]: El Administrador %s Descongeló a todos los Jugadores del Evento!", NomePlayer);
					SendEventMessage(COR_INFO, Format);
					return 1;
				}
				case 11:
				{
					if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					for(new p = 0; p < MAX_PLAYERS; p++)
					{
						if(PlayerInfoE[p][NoEvento] == 1)
						{
							ResetPlayerWeapons(p);
						}
					}
					EventInfo[Arma] = 0;
					GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
					format(Format, sizeof(Format), "[EVENTO]: El Administrador %s Reseteó las Armas a los Jugadores del Evento!", NomePlayer);
					SendEventMessage(COR_INFO, Format);
					return 1;
				}
				case 12:
				{
                    if(EventInfo[Criado] == 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No existe ningún Evento creado!");
					new Float:x,Float:y,Float:z, interior = GetPlayerInterior(playerid);
			    	GetPlayerPos(playerid,x,y,z);
				   	for(new i = 0; i < MAX_PLAYERS; i++)
		            {
						if(IsPlayerConnected(i) && (i != playerid) && PlayerInfoE[i][NoEvento] == 1)
						{
							SetPlayerPos(i, x+1, y, z);
							SetPlayerInterior(i,interior);
						}
					}
					GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
					format(Format, sizeof(Format), "[EVENTO]: {FFFFFF}%s teletransportó a los jugadores del evento!", NomePlayer);
					SendClientMessageToAll(COR_INFO, Format);
					return 1;
				}
				case 13:
				{
				CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/lugarese");
				}
				case 14:
				{
				if(GodE[playerid] == 0)
				{
				GodE[playerid] = 1;
				SetPlayerHealth(playerid,999999);
				} else {
				GodE[playerid] = 0;
				SetPlayerHealth(playerid,100);
				}
				}
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_DEFINIR)
	{
	    if(response)
		{
        GetPlayerPos(playerid, PosX, PosY, PosZ);
        GetPlayerFacingAngle(playerid, PosA);
		EventInfo[Xq] = PosX;
		EventInfo[Yq] = PosY;
		EventInfo[Zq] = PosZ;
		EventInfo[Aq] = PosA;
		EventInfo[Interior] = GetPlayerInterior(playerid);
		EventInfo[VirtualWorld] = (GetPlayerVirtualWorld(playerid) + 1);
		SendClientMessage(playerid, -1, "[INFO]: Posición del Evento Definida!");
		ShowPlayerDialog(playerid, DIALOG_PREMIO1, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite cual será el Premio para el 1º Lugar:", "Salvar", "");
		}
		return 1;
	}

	if(dialogid == DIALOG_NOMEEVENTO)
	{
	    if(response)
		{
            if(strlen(inputtext) < 5 || strlen(inputtext) > 19)	return	ShowPlayerDialog(playerid, DIALOG_NOMEEVENTO, DIALOG_STYLE_INPUT, "{00FF00}Creación de Evento", "{FF0000}[ERROR]: {FFFFFF}El Nombre debe ser de 5 a 19 Carácteres! \n{BCC3E1}Digite el Nombre del Evento:", "Continuar", "");
			format(NameA, sizeof(NameA), "%s", inputtext);
			EventInfo[Nome] = NameA;
			ShowPlayerDialog(playerid, DIALOG_DEFINIR, DIALOG_STYLE_MSGBOX, "Creación de Evento", "Elija La posición del Evento", "Aceptar", "");
			return 1;
		}
		return 1;
	}
	if(dialogid == DIALOG_PREMIO1)
	{
	    if(response)
		{
			if(strval(inputtext) < 1 || strval(inputtext) > 100000)	return	ShowPlayerDialog(playerid, DIALOG_PREMIO1, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}El Premio debe ser Minimo $1 y Máximo $100000 ! \n{BCC3E1}Digite cual será el Premio para el 1º Lugar:", "Salvar", "");
			EventInfo[Premio1] = strval(inputtext);
			SendClientMessage(playerid, -1, "[INFO]: Premio para el 1º Lugar Definido!");
			ShowPlayerDialog(playerid, DIALOG_PREMIO2, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite cual será el Premio para el 2º Lugar:", "Salvar", "");
			return 1;
		}
		return 1;
	}
	if(dialogid == DIALOG_PREMIO2)
	{
	    if(response)
		{
			if(strval(inputtext) < 1 || strval(inputtext) > 10000)	return	ShowPlayerDialog(playerid, DIALOG_PREMIO2, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}El Premio debe ser Minimo $1 y Máximo $10000 ! \n{BCC3E1}Digite cual será el Premio para el 2º Lugar:", "Salvar", "");
			EventInfo[Premio2] = strval(inputtext);
			SendClientMessage(playerid, -1, "[INFO]: Premio para el 2º Lugar Definido!");
			ShowPlayerDialog(playerid, DIALOG_PREMIO3, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite cual será el Premio para el 3º Lugar:", "Salvar", "");
			return 1;
		}
		return 1;
	}
	if(dialogid == DIALOG_PREMIO3)
	{
	    if(response)
		{
			if(strval(inputtext) < 1 || strval(inputtext) > 5000)	return	ShowPlayerDialog(playerid, DIALOG_PREMIO3, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}El Premio debe ser Minimo $1 y Máximo $5000 ! \n{BCC3E1}Digite cual será el Premio para el 3º Lugar:", "Salvar", "");
			EventInfo[Premio3] = strval(inputtext);
			SendClientMessage(playerid, -1, "[INFO]: Premio para el 3º Lugar Definido!");
			ShowPlayerDialog(playerid, DIALOG_PREMIO4, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite cual será la Cantidad de Score para el Ganador:", "Salvar", "");
		}
		return 1;
	}
	if(dialogid == DIALOG_PREMIO4)
	{
	    if(response)
		{
			if(strval(inputtext) < 0 || strval(inputtext) > 400)	return	ShowPlayerDialog(playerid, DIALOG_PREMIO4, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}El Premio debe ser Minimo 1 y Máximo 400 Score ! \n{BCC3E1}Digite cual será la Cantidad de Score para el Ganador:", "Salvar", "");
			EventInfo[PremioS] = strval(inputtext);
			SendClientMessage(playerid, -1, "[INFO]: Premio de Score para el Ganador Definido!");
			ShowPlayerDialog(playerid, DIALOG_PREMIO5, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite cual será la Cantidad de NivelxVip para el Ganador:", "Salvar", "");
		}
		return 1;
	}
	if(dialogid == DIALOG_PREMIO5)
	{
	    if(response)
		{
			if(strval(inputtext) < 0 || strval(inputtext) > 2500)	return	ShowPlayerDialog(playerid, DIALOG_PREMIO5, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}El Premio debe ser Minimo 0 y Máximo 2500 NivelxVip ! \n{BCC3E1}Digite cual será la Cantidad de NivelxVip para el Ganador:", "Salvar", "");
			EventInfo[PremioN] = strval(inputtext);
			SendClientMessage(playerid, -1, "[INFO]: Premio de Nivel para el Ganador Definido!");
			ShowPlayerDialog(playerid, DIALOG_ABRIREVENTO, DIALOG_STYLE_MSGBOX, "Creación de Evento", "Evento Creado, dale en Aceptar para Comenzar", "Aceptar", "");
		}
		return 1;
	}
	if(dialogid == DIALOG_ARMA)
	{
	    if(response)
		{
		    if(strval(inputtext) == 16 || strval(inputtext) == 18 || strval(inputtext) == 36 || strval(inputtext) == 37 || strval(inputtext) == 39 || strval(inputtext) == 44 || strval(inputtext) == 45) return  SendClientMessage(playerid,COR_ERRO, "[ERROR]: {FFFFFF}No Puedes dar esta Arma!");

			if(strval(inputtext) < 1 || strval(inputtext) > 46)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}ID Inválido!");
			EventInfo[Arma] = strval(inputtext);
			ShowPlayerDialog(playerid, DIALOG_MUNICAO, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite las Municiones que deseas dar a los Jugadores del Evento:", "Continuar", "");
		}
		return 1;
	}
	if(dialogid == DIALOG_MUNICAO)
	{
	    if(response)
		{
			if(strval(inputtext) < 1 || strval(inputtext) > 999) return	ShowPlayerDialog(playerid, DIALOG_MUNICAO, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}El Número Máximo de Balas es de 999 \n{BCC3E1}Digite las Municiones que deseas dar a los Jugadores del Evento:", "Continuar", "");
			for(new p = 0; p < MAX_PLAYERS; p++)
     		{
            	if(PlayerInfoE[p][NoEvento] == 1)
				{
					GivePlayerWeapon(p, EventInfo[Arma], strval(inputtext));
				}
     		}
			GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
			format(Format, sizeof(Format), "[EVENTO]: {FFFFFF}%s dió una Arma [%d] para todos los usuarios del evento!", NomePlayer, EventInfo[Arma]);
			SendEventMessage(COR_INFO, Format);
		}
		return 1;
	}
	if(dialogid == DIALOG_CARRO)
	{
	    if(response)
		{
			if(strval(inputtext) < 400 && strval(inputtext) != 0 || strval(inputtext) > 611 && strval(inputtext) != 0)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}ID Inválido!");
			EventInfo[Carro] = strval(inputtext);
			if(strval(inputtext) == 0)
			{
				for(new p = 0; p < MAX_PLAYERS; p++)
				{
					if(PlayerInfoE[p][NoEvento] == 1)
					{
						DestroyVehicle(PlayerInfoE[p][Carro]);
						PlayerInfoE[p][Carro] = 0;
					}
				}
				GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
				format(Format, sizeof(Format), "[EVENTO]: {FFFFFF}%s destruyó los vehículos del evento!", NomePlayer);
				SendEventMessage(COR_INFO, Format);
				return 1;
			}
			ShowPlayerDialog(playerid, DIALOG_COR1, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite el Primer Color que deseas para los Vehículos:", "Continuar", "");
		}
		return 1;
	}
	if(dialogid == DIALOG_COR1)
	{
	    if(response)
		{
			if(strval(inputtext) < 0 || strval(inputtext) > 255)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}ID informado invalido!");
			EventInfo[Cor1] = strval(inputtext);
			ShowPlayerDialog(playerid, DIALOG_COR2, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite el Segundo Color que deseas para los Vehículos:", "Continuar", "");
		}
		return 1;
	}
	if(dialogid == DIALOG_COR2)
	{
	    if(response)
		{
			if(strval(inputtext) < 0 || strval(inputtext) > 255)	return	SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}ID Inválido!");
			EventInfo[Cor2] = strval(inputtext);
			new CarID;
			for(new p = 0; p < MAX_PLAYERS; p++)
     		{
            	if(PlayerInfoE[p][NoEvento] == 1)
				{
					if(PlayerInfoE[p][Carro] >= 1)
					{
						DestroyVehicle(PlayerInfoE[p][Carro]);
						PlayerInfoE[p][Carro] = 0;
					}
					GetPlayerPos(p, PosX, PosY, PosZ);
					GetPlayerFacingAngle(p, PosA);
					CarID = CreateVehicle(EventInfo[Carro], PosX, PosY, PosZ, PosA, EventInfo[Cor1], EventInfo[Cor2], -1);
					SetVehicleNumberPlate(CarID, "RL 2016");
					LinkVehicleToInterior(CarID, EventInfo[Interior]);
					SetVehicleVirtualWorld(CarID, EventInfo[VirtualWorld]);
					PutPlayerInVehicle(p, CarID, 0);
					PlayerInfoE[p][Carro] = CarID;
				}
     		}
			GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
			format(Format, sizeof(Format), "[EVENTO]: {FFFFFF}%s dió un vehículo [%d] a los jugadores del evento!", NomePlayer, EventInfo[Carro]);
			SendEventMessage(COR_INFO, Format);
		}
		return 1;
	}
	if(dialogid == DIALOG_VIDAVEICULOS)
	{
	    if(response)
		{
			if(strval(inputtext) < 0 || strval(inputtext) > 5000) return ShowPlayerDialog(playerid, DIALOG_VIDAVEICULOS, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}Use de 0 a 100! \n{BCC3E1}Digite la Vida que deseas definir a los\nVehículos del Evento:", "Definir", "Cancelar");
			for(new p = 0; p < MAX_PLAYERS; p++)
     		{
            	if(PlayerInfoE[p][NoEvento] == 1)
				{
					if(PlayerInfoE[p][Carro] >= 1)
					{
						SetVehicleHealth(PlayerInfoE[p][Carro], strval(inputtext));
					}
				}
     		}
			GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
			format(Format, sizeof(Format), "[EVENTO]: {FFFFFF}%s puso la vida de los autos en %d.", NomePlayer, strval(inputtext));
			SendEventMessage(COR_INFO, Format);
		}
		return 1;
	}
	if(dialogid == DIALOG_KICK)
	{
	    if(response)
		{
            if (strval(inputtext) == playerid) return SendClientMessage(playerid, COR_ERRO,"[ERROR]: {FFFFFF}No puedes Kikearte a ti mismo.");
			if(!IsPlayerConnected(strval(inputtext))) return SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}Jugador no Conectado!");
			if(PlayerInfoE[strval(inputtext)][NoEvento] == 0) return SendClientMessage(playerid, COR_ERRO, "[ERROR]: {FFFFFF}No es posible Kickear un Jugador que no está en Evento!");
			new NomePlayer2[MAX_PLAYER_NAME];
			SetPlayerVirtualWorld(strval(inputtext), 0);
			SetPlayerInterior(strval(inputtext), 0);
			SpawnPlayer(strval(inputtext));
			PlayerInfoE[strval(inputtext)][NoEvento] = 0;
			if(PlayerInfoE[strval(inputtext)][Carro] >= 1)
			{
				DestroyVehicle(PlayerInfoE[strval(inputtext)][Carro]);
				PlayerInfoE[strval(inputtext)][Carro] = 0;
			}
			GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
			GetPlayerName(strval(inputtext), NomePlayer2, MAX_PLAYER_NAME);
			format(Format, sizeof(Format), "[EVENTO]: {FFFFFF}%s kickeó a %s del evento!", NomePlayer, NomePlayer2);
			SendEventMessage(COR_INFO, Format);
		}
		return 1;
	}
	if(dialogid == DIALOG_FIM1)
	{
		if(response)
		{
			if(!IsPlayerConnected(strval(inputtext))) return ShowPlayerDialog(playerid, DIALOG_FIM1, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}Jugador no Conectado! \n{BCC3E1}Digite la ID del Primer Lugar del Evento:", "Continuar", "");
			DarDinero(strval(inputtext), EventInfo[Premio1]);
			GetPlayerName(strval(inputtext), NomePlayer, MAX_PLAYER_NAME);
			SetPlayerScore(strval(inputtext), GetPlayerScore(strval(inputtext)) +EventInfo[PremioS]);
			Usuario[strval(inputtext)][Asesinatos] += EventInfo[PremioS];
			Usuario[strval(inputtext)][Nivel] += EventInfo[PremioN];
			for(new i = 0;i<7;i++) SendClientMessageToAll(-1,"");
			SendClientMessageToAll(yellow,"[Premios del evento]:");
			format(Format, sizeof(Format), "1º Lugar{FFFFFF}: %s | $%d | Score [%d] | Premio Nivel [%d]", NomePlayer, EventInfo[Premio1], EventInfo[PremioS], EventInfo[PremioN]);
			SendClientMessageToAll(COR_INFO, Format);
			ShowPlayerDialog(playerid, DIALOG_FIM2, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite la ID del Segundo Lugar del Evento:", "Continuar", "");
		}
		return 1;
	}
	if(dialogid == DIALOG_FIM2)
	{
		if(response)
		{
			if(!IsPlayerConnected(strval(inputtext))) return ShowPlayerDialog(playerid, DIALOG_FIM2, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}Jugador no Conectado! \n{BCC3E1}Digite la ID del Segundo Lugar del Evento:", "Continuar", "");
			DarDinero(strval(inputtext), EventInfo[Premio2]);
			GetPlayerName(strval(inputtext), NomePlayer, MAX_PLAYER_NAME);
			format(Format, sizeof(Format), "2º Lugar{FFFFFF}: %s | Dinero [$%d]", NomePlayer, EventInfo[Premio2]);
			SendClientMessageToAll(COR_INFO, Format);
			ShowPlayerDialog(playerid, DIALOG_FIM3, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite la ID del Tercer Lugar del Evento:", "Continuar", "");
		}
		return 1;
	}
	if(dialogid == DIALOG_FIM3)
	{
		if(response)
		{
			if(!IsPlayerConnected(strval(inputtext))) return ShowPlayerDialog(playerid, DIALOG_FIM3, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}Jugador no Conectado! \n{BCC3E1}Digite la ID del Tercer Lugar del Evento:", "Continuar", "");
			DarDinero(strval(inputtext), EventInfo[Premio3]);
			GetPlayerName(strval(inputtext), NomePlayer, MAX_PLAYER_NAME);
		    format(Format, sizeof(Format), "3º Lugar{FFFFFF}: %s | Dinero [$%d]", NomePlayer, EventInfo[Premio3]);
			SendClientMessageToAll(COR_INFO, Format);
			DestruirEvento(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_VIDA)
	{
	    if(response)
		{
			if(strval(inputtext) < 0 || strval(inputtext) > 2000) return	ShowPlayerDialog(playerid, DIALOG_VIDA, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}Use de 0 a 2000! \n{BCC3E1}Digite la Vida que deseas definir a los\nJugadores del Evento", "Definir", "Cancelar");
			EventInfo[Vida] = strval(inputtext);
			ShowPlayerDialog(playerid, DIALOG_COLETE, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "Digite el Chaleco que deseas definir a los\nJugadores del Evento", "Definir", "Cancelar");
		}
		return 1;
	}
	if(dialogid == DIALOG_COLETE)
	{
	    if(response)
		{
			if(strval(inputtext) < 0 || strval(inputtext) > 2000) return	ShowPlayerDialog(playerid, DIALOG_COLETE, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}Use de 0 a 2000! \n{BCC3E1}Digite el Chaleco que deseas definir a los\nJugadores del Evento", "Definir", "Cancelar");
			for(new p = 0; p < MAX_PLAYERS; p++)
     		{
            	if(PlayerInfoE[p][NoEvento] == 1)
				{
					SetPlayerHealth(p, EventInfo[Vida]);
					SetPlayerArmour(p, strval(inputtext));
				}
     		}
			GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
			format(Format, sizeof(Format), "[EVENTO]:{FFFFFF} %s definió la vida y chaleco de los jugadores del evento en %d y %d", NomePlayer, EventInfo[Vida], strval(inputtext));
			SendEventMessage(COR_INFO, Format);
		}
		return 1;
	}
	if(dialogid == DIALOG_SKIN1)
	{
		if(response)
		{
			if(strval(inputtext) < 0 || strval(inputtext) > 200) return	ShowPlayerDialog(playerid, DIALOG_SKIN1, DIALOG_STYLE_INPUT, "{00FF00}Definiciones de Evento", "{FF0000}[ERROR]: {FFFFFF}Use de 0 a 200! \n{BCC3E1}Digite la ID del Skin que deseas\naplicar a los Jugadores del Evento:", "Definir", "Cancelar");
			for(new p = 0; p < MAX_PLAYERS; p++)
     		{
            	if(PlayerInfoE[p][NoEvento] == 1)
				{
					SetPlayerSkin(p, strval(inputtext));
				}
     		}
			GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
			format(Format, sizeof(Format), "[EVENTO]: {FFFFFF}El administrador %s les pusó a los jugadores del evento el SKIN %d.", NomePlayer, strval(inputtext));
			SendEventMessage(COR_INFO, Format);
		}
		return 1;
	}

    if(dialogid == DIALOG_ABRIREVENTO)
	{
		if(response)
		{
			EventInfo[Criado] = 1;
			EventInfo[Aberto] = 1;
			EventInfo[Cerrado] = 0;
			SetPlayerVirtualWorld(playerid, EventInfo[VirtualWorld]);
			SetPlayerInterior(playerid, EventInfo[Interior]);
			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 100);
			SEVENTO = 1;
			GetPlayerName(playerid, NomePlayer, sizeof(NomePlayer));
			new StrA[64];
			format(StrA, sizeof(StrA), "%s", NomePlayer);
			EventInfo[Admin] = StrA;
			for(new i = 0;i<5;i++) SendClientMessageToAll(-1,"");
			format(Format, sizeof(Format), "[NUEVO EVENTO]: {FFFFFF}%s abró un nuevo evento! Usa {00FF00}/IREVENTO{FFFFFF}.", NomePlayer);
			SendClientMessageToAll(COR_EVENTO, Format);
			format(Format, sizeof(Format), "Nombre: {00FF00}%s {FFFFFF}| Premio para el 1º Lugar: {00FF00}$%d, %d {FFFFFF}de Score y {00FF00}%d{FFFFFF} de Nivel", EventInfo[Nome], EventInfo[Premio1], EventInfo[PremioS], EventInfo[PremioN]);
			SendClientMessageToAll(-1, Format);
			format(Format, sizeof(Format), "Premio para el 2º Lugar: {00FF00}$%d {FFFFFF}| Premio para el 3º Lugar: {00FF00}$%d",EventInfo[Premio2], EventInfo[Premio3]);
		    SendClientMessageToAll(-1, Format);
			CountAmountEvento = 60;
			CMDMessageToAdmins(playerid,"MIEVENTO");
			CountTimerEvento = SetTimer("CountTillEvento", 999, 1);
			}
			return 1;
		}

	if(dialogid == 120)
	{
	if(response)
	{
	switch(listitem)
	{
	case 0:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ls");
	}
	case 1:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/lv");
	}
	case 2:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/sf");
	}
	case 3:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/puente");
	}
	case 4:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/bosque");
	}
	case 5:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/vista");
	}
	case 6:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/torre");
	}
	case 7:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/lc");
	}
	case 8:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/drift");
	}
	case 9:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/aa");
	}
	case 10:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/chilliad");
	}
	case 11:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/als");
	}
	case 12:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/alv");
	}
	case 13:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/asf");
	}
	case 14:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/stunt");
	}
	case 15:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/juegos");
	}
	}
	}
	return 1;
	}
	
	if(dialogid == 56)
	{
	if(response)
	{
	switch(listitem)
	{
	case 0:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/armas");
	}
	case 1:
	{
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/armaspack");
	}
	case 2:
	{
	ShowPlayerDialog(playerid,58,DIALOG_STYLE_TABLIST_HEADERS,"|| Canjes ||",
	"Puntos\tAmmoPack's\n\
	10 puntos\t15 ammopacks\n\
	15 puntos\t15 ammopacks\n\
	20 puntos\t25 ammopacks\n\
	25 puntos\t25 ammopacks\n\
	30 puntos\t40 ammopacks\n\
	45 puntos\t45 ammopacks\n\
	50 puntos\t60 ammopacks",
	"Seleccionar", "Cancelar");
 	}
	}
	}
	return 1;
	}
	
	if(dialogid == 58)
	{
	if(response)
	{
	switch(listitem)
	{
	case 0:
	{
	if(Usuario[playerid][Puntos] < 10) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes los puntos suficientes.");
	Usuario[playerid][Puntos] -= 10;
	Usuario[playerid][Ammopacks] += 15;
	SendClientMessage(playerid,blue,"[CANJE]: {FFFFFF}Cambiaste {00FF00}10{FFFFFF} puntos por {00FF00}15{FFFFFF} Ammopacks.");
	}
	case 1:
	{
	if(Usuario[playerid][Puntos] < 15) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes los puntos suficientes.");
	Usuario[playerid][Puntos] -= 15;
	Usuario[playerid][Ammopacks] += 15;
	SendClientMessage(playerid,blue,"[CANJE]: {FFFFFF}Cambiaste {00FF00}15{FFFFFF} puntos por {00FF00}15{FFFFFF} Ammopacks.");
	}
	case 2:
	{
	if(Usuario[playerid][Puntos] < 20) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes los puntos suficientes.");
	Usuario[playerid][Puntos] -= 20;
	Usuario[playerid][Ammopacks] += 25;
	SendClientMessage(playerid,blue,"[CANJE]: {FFFFFF}Cambiaste {00FF00}20{FFFFFF} puntos por {00FF00}25{FFFFFF} Ammopacks.");
	}
	case 3:
	{
	if(Usuario[playerid][Puntos] < 25) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes los puntos suficientes.");
	Usuario[playerid][Puntos] -= 25;
	Usuario[playerid][Ammopacks] += 25;
	SendClientMessage(playerid,blue,"[CANJE]: {FFFFFF}Cambiaste {00FF00}25{FFFFFF} puntos por {00FF00}25{FFFFFF} Ammopacks.");
	}
	case 4:
	{
	if(Usuario[playerid][Puntos] < 30) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes los puntos suficientes.");
	Usuario[playerid][Puntos] -= 30;
	Usuario[playerid][Ammopacks] += 40;
	SendClientMessage(playerid,blue,"[CANJE]: {FFFFFF}Cambiaste {00FF00}30{FFFFFF} puntos por {00FF00}40{FFFFFF} Ammopacks.");
	}
	case 5:
	{
	if(Usuario[playerid][Puntos] < 45) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes los puntos suficientes.");
	Usuario[playerid][Puntos] -= 45;
	Usuario[playerid][Ammopacks] += 45;
	SendClientMessage(playerid,blue,"[CANJE]: {FFFFFF}Cambiaste {00FF00}45{FFFFFF} puntos por {00FF00}45{FFFFFF} Ammopacks.");
	}
	case 6:
	{
	if(Usuario[playerid][Puntos] < 50) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}No tienes los puntos suficientes.");
	Usuario[playerid][Puntos] -= 50;
	Usuario[playerid][Ammopacks] += 60;
	SendClientMessage(playerid,blue,"[CANJE]: {FFFFFF}Cambiaste {00FF00}50{FFFFFF} puntos por {00FF00}60{FFFFFF} Ammopacks.");
	}
	}
	}
	return 1;
	}

	if(dialogid == 57)
	{
	if(response)
	{
	switch(listitem)
	{
	case 0:
	{
	if(Usuario[playerid][Ammopacks] < 22) return SendClientMessage(playerid,red,"[TIENDA]: {FFFFFF}Necesitas al menos {00FF00}22{FFFFFF} AmmoPack's para comprar el arma.");
	Usuario[playerid][SGRANADA] = 1;
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Felicidades, compraste {00FF00}1{FFFFFF} C4 APOCALÍPTICO.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Se te descontaron {FF0000}22{FFFFFF} AmmoPack's de tu cuenta.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Recuerda usar {00FF00}/plantar{FFFFFF} para usar el C4.");
    Usuario[playerid][Ammopacks] = Usuario[playerid][Ammopacks]-22;
	}
	case 1:
	{
	if(Usuario[playerid][Ammopacks] < 25) return SendClientMessage(playerid,red,"[TIENDA]: {FFFFFF}Necesitas al menos {00FF00}25{FFFFFF} AmmoPack's para comprar el arma.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Felicidades, compraste una {00FF00}HS ROCKET [5 DISPAROS]{FFFFFF} con éxito.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Se te descontaron {FF0000}25{FFFFFF} AmmoPack's de tu cuenta.");
    Usuario[playerid][Ammopacks] = Usuario[playerid][Ammopacks]-25;
    GivePlayerWeapon(playerid, 35, 5);
	}
	case 2:
	{
	if(Usuario[playerid][Ammopacks] < 17) return SendClientMessage(playerid,red,"[TIENDA]: {FFFFFF}Necesitas al menos {00FF00}17{FFFFFF} AmmoPack's para comprar el arma.");
	if(SuperSprint[playerid] == 1) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}Ya tienes una jerigan de RAPIDSPEED.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Felicidades, compraste la jeringa {00FF00}RAPIDSPEED [60 segundos]{FFFFFF} con éxito.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Se te descontaron {FF0000}25{FFFFFF} AmmoPack's de tu cuenta.");
	SetTimerEx("Rapidoseva",60000,false,"d",playerid);
    Usuario[playerid][Ammopacks] = Usuario[playerid][Ammopacks]-17;
    SuperSprint[playerid] = 1;
	}
	case 3:
	{
	if(Usuario[playerid][Ammopacks] < 45) return SendClientMessage(playerid,red,"[TIENDA]: {FFFFFF}Necesitas al menos {00FF00}45{FFFFFF} AmmoPack's para comprar el arma.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Felicidades, compraste el {00FF00}SNIPERKILL [20 balas]{FFFFFF} con éxito.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Se te descontaron {FF0000}45{FFFFFF} AmmoPack's de tu cuenta.");
    Usuario[playerid][Ammopacks] = Usuario[playerid][Ammopacks]-45;
    Usuario[playerid][SniperK] = 25;
    GivePlayerWeapon(playerid,34,20);
    }
    case 4:
	{
	if(Usuario[playerid][Ammopacks] < 10) return SendClientMessage(playerid,red,"[TIENDA]: {FFFFFF}Necesitas al menos {00FF00}10{FFFFFF} AmmoPack's para comprar el arma.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Felicidades, compraste la {00FF00}MACHINEGUN [85 balas]{FFFFFF} con éxito.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Se te descontaron {FF0000}10{FFFFFF} AmmoPack's de tu cuenta.");
    Usuario[playerid][Ammopacks] = Usuario[playerid][Ammopacks]-10;
    GivePlayerWeapon(playerid,38,85);
    }
    case 5:
	{
	if(Usuario[playerid][Ammopacks] < 6) return SendClientMessage(playerid,red,"[TIENDA]: {FFFFFF}Necesitas al menos {00FF00}6{FFFFFF} AmmoPack's para comprar el arma.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Felicidades, compraste las {00FF00}GRANADAS [5]{FFFFFF} con éxito.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Se te descontaron {FF0000}6{FFFFFF} AmmoPack's de tu cuenta.");
    Usuario[playerid][Ammopacks] = Usuario[playerid][Ammopacks]-6;
    GivePlayerWeapon(playerid,16,5);
    }
    case 6:
	{
	if(Usuario[playerid][Ammopacks] < 18) return SendClientMessage(playerid,red,"[TIENDA]: {FFFFFF}Necesitas al menos {00FF00}18{FFFFFF} AmmoPack's para comprar el arma.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Felicidades, compraste el {00FF00}CHALECO [100]{FFFFFF} con éxito.");
	SendClientMessage(playerid,green,"[TIENDA]: {FFFFFF}Se te descontaron {FF0000}18{FFFFFF} AmmoPack's de tu cuenta.");
    Usuario[playerid][Ammopacks] = Usuario[playerid][Ammopacks]-18;
    SetPlayerArmour(playerid,100);
    }
	}
	}
	return 1;
	}
	
	if(dialogid == 60)
	{
	if(!response)return SendClientMessage(playerid, 0xFF0000FF, "[INFO]: {FFFFFF}Lista de colores cerrado.");
    switch(listitem)
    {
    case 0:
    {
    ShowPlayerDialog(playerid,61,DIALOG_STYLE_LIST,"{FF0000}Rojos", "{FF0000}Rojo\r\n{DC143C}Carmesí\r\n{E32636}Alizarina\r\n{E34234}Bermellón\r\n{FF2400}Escarlata\r\n{800000}Granate\r\n{960018}Carmín\r\n{E52B50}Amaranto\r\n{FF033E}Rosa Americana\r\n{800020}Borgoña","Ok","Cancelar");
    }
    case 1:
    {
    ShowPlayerDialog(playerid,62,DIALOG_STYLE_LIST,"{FF8000}Naranjas", "{FEC3AC}Salmón\r\n{FF7028}Naranja\r\n{FF7E00}Ámbar\r\n{FF7F50}Coral\r\n{FF8C69}Sésamo\r\n{FBCEB1}Albaricoque\r\n{F5DEB3}Beige\r\n{FFCC99}Piel","Ok","Cancelar");
    }
    case 2:
	{
    ShowPlayerDialog(playerid,63,DIALOG_STYLE_LIST,"{964B00}Marrones", "{964B00}Marrón\r\n{CC7722}Ocre\r\n{B87333}Siena\r\n{321414}Marrón Foca\r\n{483C32}Gris Pardo\r\n{3D2B1F}Bistre\r\n{98817B}Cinereous\r\n{674C47}Pardo medio\r\n{BC987E}Pardo Pálido","Ok","Cancelar");
    }
    case 3:
    {
    ShowPlayerDialog(playerid,64,DIALOG_STYLE_LIST,"{00FF00}Amarillos", "{00FF00}Amarillos\r\n{FDE910}Limón\r\n{FFD700}Dorado\r\n{FFBF00}Ámbar\r\n{E3A857}Amarillo indio\r\n{FFBA00}Amarillo selectivo","Ok","Cancelar");
	}
    case 4:
    {
    ShowPlayerDialog(playerid,65,DIALOG_STYLE_LIST,"{00FF00}Verdes", "{40826D}Verde Veronés\r\n{40826D}Xanadu\r\n{94812B}Kaki\r\n{00FF00}Verde\r\n{7FFF00}Verde Lima\r\n{8DB600}Verde Manzana\r\n{4D5D53}Feldgrau\r\n{4CBB17}Verde Kelly\r\n{008000}Ao Inglés\r\n{50C878}Esmeralda\r\n{00A86B}Jade\r\n{44944A}Arquelín\r\n{7BA05B}Esparrago\r\n{6B8E23}Verde Oliva\r\n{355E3B}Verde Cazador","Ok","Cancelar");
    }
    case 5:
    {
    ShowPlayerDialog(playerid,66,DIALOG_STYLE_LIST,"{00FFFF}Azules Claros", "{00FFFF}Cian\r\n{30D5C8}Turquesa\r\n{87CEFF}Celeste\r\n{9BC4E2}Cerúleo o Azul cielo\r\n{7FFFD4}Aguamarina","Ok","Cancelar");
    }
    case 6:
    {
    ShowPlayerDialog(playerid,67,DIALOG_STYLE_LIST,"{0000FF}Azules Oscuros", "{6082B6}Glauco\r\n{0000FF}Azul\r\n{0047AB}Azul Cobalto\r\n{120A8F}Azul Marino\r\n{5D8AA8}Azul de fuerza aérea\r\n{0000CD}Azur\r\n{0131B4}Zafiro\r\n{000080}Turquí\r\n{003153}Azul de Prusia\r\n{6050DC}Azul Majorelle","Ok","Cancelar");
    }
    case 7:
    {
    ShowPlayerDialog(playerid,68,DIALOG_STYLE_LIST,"{8B00FF}Violetas", "{AA98A9}Rosa Cuarzo\r\n{8B00FF}Violeta\r\n{B57EDC}Lavanda Floral\r\n{9966CC}Amatista\r\n{660099}Púrpura\r\n{66023C}Púrpura de Tiro\r\n{915C83}Fucsia Antiguo\r\n{4B0082}Añil o Indigo","Ok","Cancelar");
    }
    case 8:
	{
    ShowPlayerDialog(playerid,69,DIALOG_STYLE_LIST,"{FF00FF}Rosas", "{FF00FF}Magenta\r\n{F400A1}Fuscia\r\n{C54B8C}Morado\r\n{E0B0FF}Malva\r\n{C8A2C8}Lila\r\n{E6E6fA}Lavanda\r\n{FFCBDB}Rosa\r\n{CD9575}Bronze Antiguo\r\n{DA8A67}Siena Pálido", "Ok","Cancelar");
	}
	case 9:
	{
	SetPlayerColor(playerid, 0xFFFFFFFF);
	SendClientMessage(playerid, 0xFFFFFFFF, "[INFO]: Has seleccionado tu color a blanco");
	}
	case 10:
	{
	SetPlayerColor(playerid, 0x000000FF);
	SendClientMessage(playerid, 0xFFFFFFFF, "[INFO]: Has seleccionado tu color a {000000}negro");
	}
	case 11:
	{
	ShowPlayerDialog(playerid,70,DIALOG_STYLE_LIST,"{808080}Grises", "Gris\r\n{3B444B}Arsénico\r\n{B2BEB5}Ceniza\r\n{848482}Gris Acorazado\r\n{536872}Gris Cadete\r\n{36454F}Carbón Vegetal\r\n{8C92AC}Gris Fresco\r\n{555555}Gris de Davy\r\n{534B4F}Hígado\r\n{40404F}Gris de Payne\r\n{E5E4E2}Platino\r\n{C0C0C0}Plateado\r\n{708090}Gris Pizarra\r\n{50404D}Violeta Pardo","Ok","Cancelar");
	}
    }
    return 1;
    }

    if(dialogid == 61)
    {
    if(!response)return SendClientMessage(playerid, 0xFF0000FF, "[INFO]: Cancelado.");
    switch(listitem)
    {
    case 0:
    {
    SetPlayerColor(playerid, 0xFF0000FF);
    SendClientMessage(playerid, 0xFF0000FF, "[INFO]: Has seleccionado tu color a Rojo");
    }
    case 1:
	{
    SetPlayerColor(playerid, 0xDC143CFF);
    SendClientMessage(playerid, 0xDC143CFF, "[INFO]: Has seleccionado tu color a Carmesí");
	}
    case 2:
    {
    SetPlayerColor(playerid, 0xE32636FF);
    SendClientMessage(playerid, 0xE32636FF, "[INFO]: Has seleccionado tu color a Alizarina");
   	}
	case 3:
	{
	SetPlayerColor(playerid, 0xE34234FF);
	SendClientMessage(playerid, 0xE34234FF, "[INFO]: Has seleccionado tu color a Bermellón");
	}
	case 4:
	{
	SetPlayerColor(playerid, 0xFF2400FF);
	SendClientMessage(playerid, 0xFF2400FF, "[INFO]: Has seleccionado tu color a Escarlata");
	}
	case 5:
	{
	SetPlayerColor(playerid, 0x800000FF);
	SendClientMessage(playerid, 0x800000FF, "[INFO]: Has seleccionado tu color a Granate");
	}
	case 6:
	{
	SetPlayerColor(playerid, 0x960018FF);
    SendClientMessage(playerid, 0x960018FF, "[INFO]: Has seleccionado tu color a Carmín");
    }
    case 7:
    {
    SetPlayerColor(playerid, 0xE52B50FF);
    SendClientMessage(playerid, 0xE52B50FF, "[INFO]: Has seleccionado tu color a Amaranto");
    }
    case 8:
    {
    SetPlayerColor(playerid, 0xFF033EFF);
    SendClientMessage(playerid, 0xFF033EFF, "[INFO]: Has seleccionado tu color a Rosa Americana");
    }
    case 9:
    {
    SetPlayerColor(playerid, 0x800020FF);
    SendClientMessage(playerid, 0x800020FF, "[INFO]: Has seleccionado tu color a Borgoña");
    }
	}
    }

    if(dialogid == 62)
        {
            if(!response)return SendClientMessage(playerid, 0xFF0000FF, "[INFO]: Cancelado.");
            switch(listitem)
            {
                case 0:
                {
                SetPlayerColor(playerid, 0xFEC3ACFF);
                SendClientMessage(playerid, 0xFEC3ACFF,"[INFO]: Has seleccionado tu color a Salmón");
                }
                case 1:
                {
                SetPlayerColor(playerid, 0xFF7028FF);
                SendClientMessage(playerid, 0xFF7028FF,"[INFO]: Has seleccionado tu color a Naranja");
                }
                case 2:
                {
                SetPlayerColor(playerid, 0xFF7E00FF);
                SendClientMessage(playerid, 0xFF7E00FF,"[INFO]: Has seleccionado tu color a Ámbar");
                }
                case 3:
                {
                SetPlayerColor(playerid, 0xFF7F50FF);
                SendClientMessage(playerid, 0xFF7F50FF,"[INFO]: Has seleccionado tu color a Coral");
                }
                case 4:
                {
                SetPlayerColor(playerid, 0xFF8C69FF);
                SendClientMessage(playerid, 0xFF8C69FF,"[INFO]: Has seleccionado tu color a Sésamo");
                }
                case 5:
                {
                SetPlayerColor(playerid, 0xFBCEB1FF);
                SendClientMessage(playerid, 0xFBCEB1FF,"[INFO]: Has seleccionado tu color a Albaricoque");
                }
                case 6:
                {
                SetPlayerColor(playerid, 0xF5DEB3FF);
                SendClientMessage(playerid, 0xF5DEB3FF,"[INFO]: Has seleccionado tu color a Beige");
                }
                case 7:
                {
                SetPlayerColor(playerid, 0xFFCC99FF);
                SendClientMessage(playerid, 0xFFCC99FF,"[INFO]: Has seleccionado tu color a Piel");
                }
			}
			return 1;
	}
	if(dialogid == 63)
    {
    	if(!response)return SendClientMessage(playerid, 0xFF0000FF, "[INFO]: Cancelado.");
    	switch(listitem)
        {
        case 0:
        {
		SetPlayerColor(playerid, 0x964B00FF);
		SendClientMessage(playerid, 0x964B00FF, "[INFO]: Has seleccionado tu color a Marrón");
        ColUsado[playerid] = 1;
        }
        case 1:
        {
 		SetPlayerColor(playerid, 0xCC7722FF);
		SendClientMessage(playerid, 0xCC7722FF, "[INFO]: Has seleccionado tu color a Ocre");
        ColUsado[playerid] = 1;
        }
        case 2:
        {
		SetPlayerColor(playerid, 0xB87333FF);
		SendClientMessage(playerid, 0xB87333FF, "[INFO]: Has seleccionado tu color a Siena");
        ColUsado[playerid] = 1;
        }
        case 3:
        {
		SetPlayerColor(playerid, 0x321414FF);
		SendClientMessage(playerid, 0x321414FF, "[INFO]: Has seleccionado tu color a Marrón Foca");
        ColUsado[playerid] = 1;
        }
        case 4:
        {
		SetPlayerColor(playerid, 0x483C32FF);
		SendClientMessage(playerid, 0x483C32FF, "[INFO]: Has seleccionado tu color a Gris Pardo");
        ColUsado[playerid] = 1;
        }
        case 5:
        {
		SetPlayerColor(playerid, 0x3D2B1FFF);
		SendClientMessage(playerid, 0x3D2B1FFF, "[INFO]: Has seleccionado tu color a Bistre");
        ColUsado[playerid] = 1;
        }
        case 6:
        {
		SetPlayerColor(playerid, 0x98817BFF);
		SendClientMessage(playerid, 0x98817BFF, "[INFO]: Has seleccionado tu color a Cinereous");
        ColUsado[playerid] = 1;
        }
        case 7:
        {
		SetPlayerColor(playerid, 0x674C47FF);
		SendClientMessage(playerid, 0x674C47FF, "[INFO]: Has seleccionado tu color a Pardo Medio");
        ColUsado[playerid] = 1;
        }
        case 8:
        {
		SetPlayerColor(playerid, 0xBC987EFF);
		SendClientMessage(playerid, 0xBC987EFF, "[INFO]: Has seleccionado tu color a Pardo Pálido");
        ColUsado[playerid] = 1;
        }
		}
		return 1;
	 	}

	if(dialogid == 64)
        {
        if(!response)return SendClientMessage(playerid, 0xFF0000FF, "[INFO]: Cancelado.");
        switch(listitem)
        {
        case 0:
        {
		SetPlayerColor(playerid, 0xFFFF00FF);
		SendClientMessage(playerid, 0xFFFF00FF, "[INFO]: Has seleccionado tu color a Amarillo");
        ColUsado[playerid] = 1;
        }
    	case 1:
        {
		SetPlayerColor(playerid, 0xFDE910FF);
		SendClientMessage(playerid, 0xFDE910FF, "[INFO]: Has seleccionado tu color a Limón");
        ColUsado[playerid] = 1;
        }
        case 2:
        {
		SetPlayerColor(playerid, 0xFFD700FF);
		SendClientMessage(playerid, 0xFFD700FF, "[INFO]: Has seleccionado tu color a Dorado");
        ColUsado[playerid] = 1;
        }
        case 3:
        {
		SetPlayerColor(playerid, 0xFFBF00FF);
		SendClientMessage(playerid, 0xFFBF00FF, "[INFO]: Has seleccionado tu color a Ámbar");
        ColUsado[playerid] = 1;
        }
        case 4:
        {
		SetPlayerColor(playerid, 0xE3A857FF);
		SendClientMessage(playerid, 0xE3A857FF, "[INFO]: Has seleccionado tu color a Amarillo Indio");
        ColUsado[playerid] = 1;
        }
        case 5:
        {
		SetPlayerColor(playerid, 0xFFBA00FF);
		SendClientMessage(playerid, 0xFFBA00FF, "[INFO]: Has seleccionado tu color a Amarillo Selectivo");
        ColUsado[playerid] = 1;
        }
		}
		return 1;
	 	}

	if(dialogid == 65)
        {
            if(!response)return SendClientMessage(playerid, 0xFF0000FF, "[INFO]: Cancelado.");
            switch(listitem)
            {
                case 0:
                {
                SetPlayerColor(playerid, 0x40826DFF);
                SendClientMessage(playerid, 0x40826DFF, "[INFO]: Has seleccionado tu color a Verde Veronés");
                ColUsado[playerid] = 1;
                }
                case 1:
                {
                SetPlayerColor(playerid, 0x738678FF);
                SendClientMessage(playerid, 0x738678FF, "[INFO]: Has seleccionado tu color a Xanadu");
                ColUsado[playerid] = 1;
                }
                case 2:
                {
                SetPlayerColor(playerid, 0x94812BFF);
                SendClientMessage(playerid, 0x94812BFF, "[INFO]: Has seleccionado tu color a Kaki");
                ColUsado[playerid] = 1;
                }
                case 3:
                {
                SetPlayerColor(playerid, 0x00FF00FF);
                SendClientMessage(playerid, 0x00FF00FF, "[INFO]: Has seleccionado tu color a Verde");
                ColUsado[playerid] = 1;
                }
                case 4:
                {
                SetPlayerColor(playerid, 0x7FFF00FF);
                SendClientMessage(playerid, 0x7FFF00FF, "[INFO]: Has seleccionado tu color a Verde Lima");
                ColUsado[playerid] = 1;
                }
                case 5:
                {
                SetPlayerColor(playerid, 0x8DB600FF);
                SendClientMessage(playerid, 0x8DB600FF, "[INFO]: Has seleccionado tu color a Verde Manzana");
                ColUsado[playerid] = 1;
                }
                case 6:
                {
                SetPlayerColor(playerid, 0x4D5D53FF);
                SendClientMessage(playerid, 0x4D5D53FF, "[INFO]: Has seleccionado tu color a Fledgrau");
                ColUsado[playerid] = 1;
                }
                case 7:
                {
                SetPlayerColor(playerid, 0x4CBB17FF);
                SendClientMessage(playerid, 0x4CBB17FF, "[INFO]: Has seleccionado tu color a Verde Kelly");
                ColUsado[playerid] = 1;
                }
				case 8:
                {
                SetPlayerColor(playerid, 0x008000FF);
                SendClientMessage(playerid, 0x008000FF, "[INFO]: Has seleccionado tu color a Ao Inglés");
                ColUsado[playerid] = 1;
                }
				case 9:
                {
                SetPlayerColor(playerid, 0x50C878FF);
                SendClientMessage(playerid, 0x50C878FF, "[INFO]: Has seleccionado tu color a Esmeralda");
                ColUsado[playerid] = 1;
                }
                case 10:
                {
                SetPlayerColor(playerid, 0x00A86BFF);
                SendClientMessage(playerid, 0x00A86BFF, "[INFO]: Has seleccionado tu color a Jade");
                ColUsado[playerid] = 1;
                }
                case 11:
                {
                SetPlayerColor(playerid, 0x44944AFF);
                SendClientMessage(playerid, 0x44944AFF, "[INFO]: Has seleccionado tu color a Arquelín");
                ColUsado[playerid] = 1;
                }
                case 12:
                {
                SetPlayerColor(playerid, 0x7BA05BFF);
                SendClientMessage(playerid, 0x7BA05BFF, "[INFO]: Has seleccionado tu color a Espárrago");
                ColUsado[playerid] = 1;
                }
                case 13:
                {
                SetPlayerColor(playerid, 0x6B8E23FF);
                SendClientMessage(playerid, 0x6B8E23FF, "[INFO]: Has seleccionado tu color a Verde Oliva");
                ColUsado[playerid] = 1;
                }
                case 14:
                {
                SetPlayerColor(playerid, 0x355E3BFF);
                SendClientMessage(playerid, 0x355E3BFF, "[INFO]: Has seleccionado tu color a Verde Cazador");
                ColUsado[playerid] = 1;
                }

			}
		}
	if(dialogid == 66)
        {
            if(!response)return SendClientMessage(playerid, 0xFF0000FF, "[INFO]: Cancelado.");
            switch(listitem)
            {
                case 0:
                {
                SetPlayerColor(playerid, 0x00FFFFFF);
                SendClientMessage(playerid, 0x00FFFFFF, "[INFO]: Has seleccionado tu color a Cian");
                ColUsado[playerid] = 1;
                }
                case 1:
                {
                SetPlayerColor(playerid, 0x30D5C8FF);
                SendClientMessage(playerid, 0x30D5C8FF, "[INFO]: Has seleccionado tu color a Turquesa");
                ColUsado[playerid] = 1;
                }
                case 2:
                {
                SetPlayerColor(playerid, 0x87CEFFFF);
                SendClientMessage(playerid, 0x87CEFFFF, "[INFO]: Has seleccionado tu color a Celeste");
                ColUsado[playerid] = 1;
                }
                case 3:
                {
                SetPlayerColor(playerid, 0x9BC4E2FF);
                SendClientMessage(playerid, 0x9BC4E2FF, "[INFO]: Has seleccionado tu color a Cerúleo/Azul Cielo");
                ColUsado[playerid] = 1;
				}
				case 4:
                {
                SetPlayerColor(playerid, 0x7FFFD4FF);
                SendClientMessage(playerid, 0x7FFFD4FF, "[INFO]: Has seleccionado tu color a Aguamarina");
                ColUsado[playerid] = 1;
                }
			}
		}
	if(dialogid == 67)
        {
            if(!response)return SendClientMessage(playerid, 0xFF0000FF, "[INFO]: Cancelado.");
            switch(listitem)
            {
                case 0:
                {
                SetPlayerColor(playerid, 0x6082B6FF);
                SendClientMessage(playerid, 0x6082B6FF, "vHas seleccionado tu color a Glauco");
                ColUsado[playerid] = 1;
                }
                case 1:
                {
                SetPlayerColor(playerid, 0x0000FFFF);
                SendClientMessage(playerid, 0x0000FFFF, "[INFO]: Has seleccionado tu color a Azul");
                ColUsado[playerid] = 1;
                }
                case 2:
                {
                SetPlayerColor(playerid, 0x0047ABFF);
                SendClientMessage(playerid, 0x0047ABFF, "[INFO]: Has seleccionado tu color a Azul Cobalto");
                ColUsado[playerid] = 1;
                }
                case 3:
                {
                SetPlayerColor(playerid, 0x120A8FFF);
                SendClientMessage(playerid, 0x120A8FFF, "[INFO]: Has seleccionado tu color a Azul Marino");
                ColUsado[playerid] = 1;
                }
                case 4:
                {
                SetPlayerColor(playerid, 0x5D8AA8FF);
                SendClientMessage(playerid, 0x5D8AA8FF, "[INFO]: Has seleccionado tu color a Azul de Fuerza Aérea");
                ColUsado[playerid] = 1;
                }
                case 5:
                {
                SetPlayerColor(playerid, 0x0000CDFF);
                SendClientMessage(playerid, 0x0000CDFF, "[INFO]: Has seleccionado tu color a Azur");
                ColUsado[playerid] = 1;
                }
                case 6:
                {
                SetPlayerColor(playerid, 0x0131B4FF);
                SendClientMessage(playerid, 0x0131B4FF, "[INFO]: Has seleccionado tu color a Zafiro");
                ColUsado[playerid] = 1;
                }
                case 7:
                {
                SetPlayerColor(playerid, 0x000080FF);
                SendClientMessage(playerid, 0x000080FF, "[INFO]: Has seleccionado tu color a Turquí");
                ColUsado[playerid] = 1;
                }
                case 8:
                {
                SetPlayerColor(playerid, 0x003153FF);
                SendClientMessage(playerid, 0x003153FF, "[INFO]: Has seleccionado tu color a Azul de Prusa");
                ColUsado[playerid] = 1;
                }
                case 9:
                {
                SetPlayerColor(playerid, 0x6050DCFF);
                SendClientMessage(playerid, 0x6050DCFF, "[INFO]: Has seleccionado tu color a Azul Majorelle");
                ColUsado[playerid] = 1;
                }

			}
		}
	if(dialogid == 68)
        {
            if(!response)return SendClientMessage(playerid, 0xFF0000FF, "[INFO]: Cancelado.");
            switch(listitem)
            {
                case 0:
                {
                SetPlayerColor(playerid, 0xAA98A9FF);
                SendClientMessage(playerid, 0xAA98A9FF, "[INFO]: Has seleccionado tu color a Rosa Cuarzo");
                ColUsado[playerid] = 1;
                }
                case 1:
                {
                SetPlayerColor(playerid, 0x8B00FFFF);
                SendClientMessage(playerid, 0x8B00FFFF, "[INFO]: Has seleccionado tu color a Violeta");
                ColUsado[playerid] = 1;
                }
                case 2:
                {
                SetPlayerColor(playerid, 0xB57EDCFF);
                SendClientMessage(playerid, 0xB57EDCFF, "[INFO]: Has seleccionado tu color a Lavanda Floral");
                ColUsado[playerid] = 1;
                }
                case 3:
                {
                SetPlayerColor(playerid, 0x9966CFF);
                SendClientMessage(playerid, 0x9966CFF, "[INFO]: Has seleccionado tu color a Amatista");
                ColUsado[playerid] = 1;
                }
                case 4:
                {
                SetPlayerColor(playerid, 0x660099FF);
                SendClientMessage(playerid, 0x660099FF, "[INFO]: Has seleccionado tu color a Púrpura");
                ColUsado[playerid] = 1;
                }
                case 5:
                {
                SetPlayerColor(playerid, 0x66023CFF);
                SendClientMessage(playerid, 0x66023CFF, "[INFO]: Has seleccionado tu color a Púrpura de Tiro");
                ColUsado[playerid] = 1;
                }
                case 6:
                {
                SetPlayerColor(playerid, 0x915C83FF);
                SendClientMessage(playerid, 0x915C83FF, "[INFO]: Has seleccionado tu color a Fucsia Antiguo");
                ColUsado[playerid] = 1;
                }
                case 7:
                {
                SetPlayerColor(playerid, 0x4B0082FF);
                SendClientMessage(playerid, 0x4B0082FF, "[INFO]: Has seleccionado tu color a Añil Antiguo");
                ColUsado[playerid] = 1;
                }
			}
		}
	if(dialogid == 69)
        {
            if(!response)return SendClientMessage(playerid, 0xFF0000FF, "[INFO]: Cancelado.");
            switch(listitem)
            {
                case 0:
                {
                SetPlayerColor(playerid, 0xFF00FFFF);
                SendClientMessage(playerid, 0xFF00FFFF, "[INFO]: Has seleccionado tu color a Magenta");
                ColUsado[playerid] = 1;
                }
                case 1:
                {
                SetPlayerColor(playerid, 0xF400A1FF);
                SendClientMessage(playerid, 0xF400A1FF, "[INFO]: Has seleccionado tu color a Fucsia");
                }
                case 2:
                {
                SetPlayerColor(playerid, 0xC54B8CFF);
                SendClientMessage(playerid, 0xC54B8CFF, "[INFO]: Has seleccionado tu color a Morado");
                ColUsado[playerid] = 1;
                }
                case 3:
                {
                SetPlayerColor(playerid, 0xE0B0FFFF);
                SendClientMessage(playerid, 0xE0B0FFFF, "[INFO]: Has seleccionado tu color a Malva");
                ColUsado[playerid] = 1;
                }
                case 4:
                {
                SetPlayerColor(playerid, 0xC8A2C8FF);
                SendClientMessage(playerid, 0xC8A2C8FF, "[INFO]: Has seleccionado tu color a Lila");
                ColUsado[playerid] = 1;
                }
                case 5:
                {
                SetPlayerColor(playerid, 0xE6E6fAFF);
                SendClientMessage(playerid, 0xE6E6fAFF, "[INFO]: Has seleccionado tu color a Lavanda");
                ColUsado[playerid] = 1;
                }
                case 6:
                {
                SetPlayerColor(playerid, 0xFFCBDBFF);
                SendClientMessage(playerid, 0xFFCBDBFF, "[INFO]: Has seleccionado tu color a Rosa");
                ColUsado[playerid] = 1;
                }
                case 7:
                {
                SetPlayerColor(playerid, 0xCD9575FF);
                SendClientMessage(playerid, 0xCD9575FF, "[INFO]: Has seleccionado tu color a Bronce Antiguo");
                ColUsado[playerid] = 1;
                }
                case 8:
                {
                SetPlayerColor(playerid, 0xDA8A67FF);
                SendClientMessage(playerid, 0xDA8A67FF, "[INFO]: Has seleccionado tu color a Siena Pálido");
                ColUsado[playerid] = 1;
                }
			}
		}
	if(dialogid == 70)
        {
            if(!response)return SendClientMessage(playerid, 0xFF0000FF, "[INFO]: Cancelado.");
            switch(listitem)
            {
                case 0:
                {
                SetPlayerColor(playerid, 0x808080FF);
                SendClientMessage(playerid, 0x808080FF, "[INFO]: Has seleccionado tu color a Gris");
                ColUsado[playerid] = 1;
                }
                case 1:
                {
                SetPlayerColor(playerid, 0x3B444BFF);
                SendClientMessage(playerid, 0x3B444BFF, "[INFO]: Has seleccionado tu color a Arsénico");
                ColUsado[playerid] = 1;
                }
                case 2:
                {
                SetPlayerColor(playerid, 0xB2BEB5FF);
                SendClientMessage(playerid, 0xB2BEB5FF, "[INFO]: Has seleccionado tu color a Ceniza");
                ColUsado[playerid] = 1;
                }
                case 3:
                {
                SetPlayerColor(playerid, 0x848482FF);
                SendClientMessage(playerid, 0x848482FF, "[INFO]: Has seleccionado tu color a Gris Acorazado");
                ColUsado[playerid] = 1;
                }
                case 4:
                {
                SetPlayerColor(playerid, 0x536872FF);
                SendClientMessage(playerid, 0x536872FF, "[INFO]: Has seleccionado tu color a Gris Cadete");
                ColUsado[playerid] = 1;
                }
                case 5:
                {
                SetPlayerColor(playerid, 0x36454FFF);
                SendClientMessage(playerid, 0x36454FFF, "[INFO]: Has seleccionado tu color a Carbón Vegetal");
                ColUsado[playerid] = 1;
                }
                case 6:
                {
                SetPlayerColor(playerid, 0x8C92ACFF);
                SendClientMessage(playerid, 0x8C92ACFF, "[INFO]: Has seleccionado tu color a Gris Fresco");
                ColUsado[playerid] = 1;
                }
                case 7:
                {
                SetPlayerColor(playerid, 0x555555FF);
                SendClientMessage(playerid, 0x555555FF, "[INFO]: Has seleccionado tu color a Gris de Davy");
                ColUsado[playerid] = 1;
                }
                case 8:
                {
                SetPlayerColor(playerid, 0x534B4FFF);
                SendClientMessage(playerid, 0x534B4FFF, "[INFO]: Has seleccionado tu color a Hígado");
                ColUsado[playerid] = 1;
                }
                case 9:
                {
                SetPlayerColor(playerid, 0x40404FFF);
                SendClientMessage(playerid, 0x40404FFF, "[INFO]: Has seleccionado tu color a Gris de Payne");
                ColUsado[playerid] = 1;
                }
                case 10:
                {
                SetPlayerColor(playerid, 0xE5E4E2FF);
                SendClientMessage(playerid, 0xE5E4E2FF, "[INFO]: Has seleccionado tu color a Platino");
                ColUsado[playerid] = 1;
                }
                case 11:
                {
                SetPlayerColor(playerid, 0xC0C0C0FF);
                SendClientMessage(playerid, 0xC0C0C0FF, "[INFO]: Has seleccionado tu color a Plateado");
                ColUsado[playerid] = 1;
                }
                case 12:
                {
                SetPlayerColor(playerid, 0x708090FF);
                SendClientMessage(playerid, 0x708090FF, "[INFO]: Has seleccionado tu color a Gris Pizarra");
                ColUsado[playerid] = 1;
                }
                case 13:
                {
                SetPlayerColor(playerid, 0x50404DFF);
                SendClientMessage(playerid, 0x50404DFF, "[INFO]: Has seleccionado tu color a Violeta Pardo");
                ColUsado[playerid] = 1;
				}
			}
return 1;
}
       
	if(dialogid == 250)
	{
	if(response)
	{
	switch(listitem)
	{
	case 0:{ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Bronce ||","{0000FF}* /fix{FFFFFF}: Reparas tu vehículo.\n{0000FF}* /ltune{FFFFFF}: Se auto-tunea tu vehículo.\n{0000FF}* /decir{FFFFFF}: Dar un anuncio al chat.\n{0000FF}* /invisible{FFFFFF}: Te ponés invisible.\n{0000FF}* /visible{FFFFFF}: Vuelves a aparecer en el mapa.\n{0000FF}* /vflip{FFFFFF}: Enderezás tu auto.\n+ Podrás tener dos propiedades más a las normales.","Aceptar","");
	}
	case 1:{ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Plata ||","{0000FF}* /vida{FFFFFF}: Regeneras tu vida.\n{0000FF}* /vjetpack{FFFFFF}: Apareces un jetpack.\n{0000FF}* /saltarauto{FFFFFF}: Activas el salto de los vehículos.\n{0000FF}* /bengala{FFFFFF}: Lanzás una bengala.\n{0000FF}* /fly{FFFFFF}: Para poder volar por todos.\n{0000FF}* /vscreen{FFFFFF}: Mandarás un mensaje a la pantalla de un usuario.\n+ Nitro automático en todos los autos.","Aceptar","");
	}
	case 2:{ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"|| Oro ||","{0000FF}* /chaleco{FFFFFF}: Regeneras tu armadura.\n{0000FF}* /velocidad{FFFFFF}: Para obtener mayor velocidad en el auto.\n{0000FF}* /sayayin{FFFFFF}: Adquieres fuego en tu skin.\n{0000FF}* /bici{FFFFFF}: Súper saltos con BICICLETAS.\n{0000FF}* /vcar{FFFFFF}: Spawneas un auto por su nombre/ID.","Aceptar","");
	}}}return 1;}
	
	
  	if(dialogid == 71){
	if(response){
	switch(listitem)
	{
	case 0:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda ammopacks");}
	case 1:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda autos");}
	case 2:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda armas");}
	case 3:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda nivel");}
	case 4:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda casas");}
	case 5:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda restaurantes");}
	case 6:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda cuenta");}
	case 7:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/colores");}
    case 8:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda vip");}
    case 9:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/climas");}
    case 10:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda generales");}
    case 11:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda musica");}
    case 12:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/juegos");}
    case 13:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ayuda modos");}
	}
	}
	return 1;}

	if(dialogid == REGISTRO)
	{
	if(!response){SetTimerEx("Kickear",500,false,"d",playerid);}
	if(response)
	{
	if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid,REGISTRO,DIALOG_STYLE_INPUT,"|| Registro ||","{FFFFFF}La contraseña debe ser mayor a {00FF00}4{FFFFFF} cáracteres por seguridad.","Registrar","Cancelar");
	if (udb_Create(pName(playerid),inputtext))
	{
	new dia,mes,ano, string[15], file[156];
	getdate(ano,mes,dia);
	LimpiarConsola(playerid);
	format(file,sizeof(file),"/Usuarios/%s.ini",pName(playerid));
	format(string,sizeof(string),"%d/%d/%d",dia,mes,ano);
	dUserSet(pName(playerid)).("Registro",string);
	dUserSet(pName(playerid)).("Fbaneo","0/0/0");
	dUserSet(pName(playerid)).("Razon","N/A");
	dUserSet(pName(playerid)).("Contraseña",inputtext);
	dUserSetINT(pName(playerid)).("Baneo",0);
	dUserSetINT(pName(playerid)).("AdminNivel",0);
	dUserSetINT(pName(playerid)).("Asesinatos",0);
	dUserSetINT(pName(playerid)).("Muertes",0);
	dUserSetINT(pName(playerid)).("VIP",0);
    dUserSetINT(pName(playerid)).("Dia",dia);
    dUserSetINT(pName(playerid)).("Mes",mes);
    dUserSetINT(pName(playerid)).("Ano",ano);
    dUserSetINT(pName(playerid)).("Kicks",0);
    dUserSetINT(pName(playerid)).("Cargos",0);
    dUserSetINT(pName(playerid)).("Advs",0);
	dUserSetINT(pName(playerid)).("Dinero",900);
	dUserSetINT(pName(playerid)).("Nivel",1);
	dUserSetINT(pName(playerid)).("lider",0);
	dUserSetINT(pName(playerid)).("Lider2",0);
	dUserSetINT(pName(playerid)).("clan",0);
 	Usuario[playerid][Nivel] = 1;
 	Usuario[playerid][Bann] = 0;
 	Usuario[playerid][pAdmin] = 0;
 	Usuario[playerid][pVip] = 0;
 	Usuario[playerid][Dia] = dia;
 	Usuario[playerid][Mes] = mes;
 	Usuario[playerid][Ano] = ano;
 	Usuario[playerid][Puntos] = 0;
 	ShowPlayerDialog(playerid,50,DIALOG_STYLE_INPUT,"|| Correo ||","Ingresa tu correo para recuperar tu cuenta en caso de robo o pérdida.","Aceptar","");
 	return PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
   	}
   	}
   	return 1;
   	}

	if(dialogid == 50)
	{
	if(!response) return ShowPlayerDialog(playerid,50,DIALOG_STYLE_INPUT,"|| Correo ||","{FFFFFF}Ingresa tu correo para recuperar tu cuenta en caso de robo o pérdida.","Aceptar","");
	if(response)
	{
	new string[100];
	if(strlen(inputtext) < 7) return ShowPlayerDialog(playerid,50,DIALOG_STYLE_INPUT,"|| Correo ||","{FFFFFF}Ingresa tu correo para recuperar tu cuenta en caso de robo o pérdida.\nDebe ser mayor a 7 carácteres.","Aceptar","");
    if(strfind(inputtext, "@", true) != -1)
    {
    dUserSet(pName(playerid)).("Correo",inputtext);
	format(string,sizeof(string),"Correo configurado: {00FF00}%s",inputtext);
	SendClientMessage(playerid,-1,string);
	SendClientMessage(playerid,-1,"Recuerda que para pedir cambio de {00FF00}correo{FFFFFF} deberás hablar con un dueño.");
	CargarUsuario(playerid);
	} else ShowPlayerDialog(playerid,50,DIALOG_STYLE_INPUT,"|| Correo ||","{FFFFFF}Ingresa tu correo para recuperar tu cuenta en caso de robo o pérdida.\nDebe tener el carácter {00FF00}@{FFFFFF}.","Aceptar","");
	}
	return 1;
	}
	
	if(dialogid == 105)
	{
	if(response)
	{
	new file[80];
	format(file,sizeof(file),"/Usuarios/%s.ini",pName(playerid));
	if(strcmp(inputtext,dini_Get(file,"Correo"),true) == 0)
	{
	ShowPlayerDialog(playerid,106,DIALOG_STYLE_INPUT,"|| Correo éxitoso ||","{FFFFFF}Introduciste tu correo electrónico correctamente, ahora pon la nueva contraseña.","Aceptar","Cancelar");
	return 1;
	} else ShowPlayerDialog(playerid,105,DIALOG_STYLE_INPUT,"|| Nueva contraseña ||","{FFFFFF}CORREO INCORRECTO. Escriba su correo electrónico por seguridad.\nSi no lo recuerdas contactar un dueño.","Aceptar","Cancelar");
	}
	return 1;
	}
	
	if(dialogid == 106)
	{
	if(response)
	{
	if(strlen(inputtext) > 4)
	{
	dUserSet(pName(playerid)).("Contraseña",inputtext);
	new string[55];
	format(string,sizeof(string),"Cambiaste tu contraseña a: {00FF00}%s",inputtext);
	SendClientMessage(playerid,-1,string);
	return 1;
	} else ShowPlayerDialog(playerid,106,DIALOG_STYLE_INPUT,"|| Correo éxitoso ||","{FFFFFF}La contraseña debe ser mayor a 4 carácteres, re-intentalo.","Aceptar","Cancelar");
	}
	return 1;
	}
	
	if(dialogid == 107)
	{
	if(response)
	{
	new file[80];
	format(file,sizeof(file),"/Usuarios/%s.ini",pName(playerid));
	if(strcmp(inputtext,dini_Get(file,"Correo"),true) == 0)
	{
	ShowPlayerDialog(playerid,108,DIALOG_STYLE_INPUT,"|| Correo éxitoso ||","{FFFFFF}Introduciste tu correo electrónico correctamente, ahora pon tu nuevo nombre.","Aceptar","Cancelar");
	return 1;
	} else ShowPlayerDialog(playerid,107,DIALOG_STYLE_INPUT,"|| Nuevo nombre ||","{FFFFFF}CORREO INCORRECTO. Escriba su correo electrónico por seguridad.\nSi no lo recuerdas contactar un dueño.","Aceptar","Cancelar");
	}
	return 1;
	}
	
	if(dialogid == 108)
	{
	if(response)
	{
	if(strlen(inputtext) > 4 && strlen(inputtext) < 20)
	{
	if(strfind(inputtext, "!", true) != -1 || strfind(inputtext, "¡", true) != -1 || strfind(inputtext, "¡", true) != -1 || strfind(inputtext, "ñ", true) != -1 || strfind(inputtext, "?", true) != -1 || strfind(inputtext, "¿", true) != -1 || strfind(inputtext, "{", true) != -1 || strfind(inputtext, "}", true) != -1 || strfind(inputtext, "|", true) != -1 || strfind(inputtext, "¬", true) != -1 || strfind(inputtext, "®", true) != -1
	|| strfind(inputtext, "#", true) != -1 || strfind(inputtext, "@", true) != -1 || strfind(inputtext, "*", true) != -1 || strfind(inputtext, "Ç", true) != -1 || strfind(inputtext, "'", true) != -1 || strfind(inputtext, "´", true) != -1 || strfind(inputtext, ",", true) != -1 || strfind(inputtext, ";", true) != -1 || strfind(inputtext, "%", true) != -1 || strfind(inputtext, "&", true) != -1 || strfind(inputtext, "/", true) != -1
	|| strfind(inputtext, "=", true) != -1 || strfind(inputtext, "¨", true) != -1 || strfind(inputtext, "^", true) != -1 || strfind(inputtext, "+", true) != -1 || strfind(inputtext, "-", true) != -1 || strfind(inputtext, ">", true) != -1 || strfind(inputtext, "<", true) != -1 || strfind(inputtext, "~", true) != -1 || strfind(inputtext, ":", true) != -1 || strfind(inputtext, "“", true) != -1 || strfind(inputtext, " ", true) != -1)
	return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: {FFFFFF}No pongas signos raros en el nombre.");
	new file1[50];
	format(file1,sizeof(file1),"Usuarios/%s.ini",inputtext);
	if(dini_Exists(file1)) return SendClientMessage(playerid,red,"[ERROR]: {FFFFFF}El nombre ya existe!");
	new string[75];
	format(string,sizeof(string),"Cambiaste tu nombre a: {00FF00}%s",inputtext);
	SendClientMessage(playerid,-1,string);
	new ownerid;
	for(new propid; propid < PropiedadesC; propid++)
	{
	if(PropInfo[propid][PropIsBought] == 1)
	{
	ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
	if(ownerid == playerid)
	{
	format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, "%s", inputtext);
	Delete3DTextLabel(PropInfo[propid][Texto]);
	if(PropInfo[propid][PropO] == 0)
	{
	new string3[125];
	format(string3,sizeof(string3),"Casa [{FF0000}COMPRADA{FFFFFF}]\nDueño: {00FF00}%s{FFFFFF}.\nValor: {00FF00}$%d",PropInfo[propid][PropOwner],PropInfo[propid][PropValue]);
    PropInfo[propid][Texto] = Create3DTextLabel(string3, 0xFFFFFFFF, PropInfo[propid][PropX], PropInfo[propid][PropY], PropInfo[propid][PropZ], 15.0, 0, 0);
 	}
 	if(PropInfo[propid][PropO] == 1)
	{
	new string3[145];
	format(string,sizeof(string),"Restaurante\n{FFFFFF}Dueño: {00FF00}%s{FFFFFF}.\nValor: {00FF00}$%d\n{FFFFFF}Ganancia: {00FF00}$%d",PropInfo[propid][PropOwner],PropInfo[propid][PropValue],(PropInfo[propid][PropValue]/4));
    PropInfo[propid][Texto] = Create3DTextLabel(string3, 0x0000FFFF, PropInfo[propid][PropX], PropInfo[propid][PropY], PropInfo[propid][PropZ], 15.0, 0, 0);
 	}
 	}
	}
	}
	GuardarPropiedades();
	udb_RenameUser(pName(playerid), inputtext);
	new file[70];
	format(file,sizeof(file),"Player Objects/%s.ini",pName(playerid));
	dini_Remove(file);
	for(new i;i<10;i++)
	{
	RemovePlayerAttachedObject(playerid,i);
	}
	SetPlayerName(playerid,inputtext);
	dini_Create(file);
  	for(new x;x<MAX_OSLOTS;x++)
        {
        if(IsPlayerAttachedObjectSlotUsed(playerid, x))
        {
        format(f1,15,"O_Model_%d",x);
        format(f2,15,"O_Bone_%d",x);
        format(f3,15,"O_OffX_%d",x);
        format(f4,15,"O_OffY_%d",x);
        format(f5,15,"O_OffZ_%d",x);
        format(f6,15,"O_RotX_%d",x);
        format(f7,15,"O_RotY_%d",x);
        format(f8,15,"O_RotZ_%d",x);
        format(f9,15,"O_ScaleX_%d",x);
        format(f10,15,"O_ScaleY_%d",x);
        format(f11,15,"O_ScaleZ_%d",x);
        dini_IntSet(file,f1,0);
        dini_IntSet(file,f2,0);
        dini_FloatSet(file,f3,0.0);
        dini_FloatSet(file,f4,0.0);
        dini_FloatSet(file,f5,0.0);
        dini_FloatSet(file,f6,0.0);
        dini_FloatSet(file,f7,0.0);
        dini_FloatSet(file,f8,0.0);
        dini_FloatSet(file,f9,0.0);
        dini_FloatSet(file,f10,0.0);
        dini_FloatSet(file,f11,0.0);
        }
        }
	return 1;
	} else ShowPlayerDialog(playerid,108,DIALOG_STYLE_INPUT,"|| Correo éxitoso ||","{FFFFFF}El nombre debe ser mayor a 4 carácteres y menor a 20, re-intentalo.","Aceptar","Cancelar");
	}
	return 1;
	}
	
	if(dialogid == 110)
	{
	if(response)
	{
    CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/cmdsvip");
	}
	return 1;
	}
	
	if(dialogid == 90)
	{
	new id = MPP[playerid];
	if(response)
	{
	if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid,90,DIALOG_STYLE_INPUT,"|| PM ||","{FFFFFF}Debes escribir más de 4 carácteres.","Enviar","Cancelar");
	if(IsPlayerConnected(id))
	{
	if(DPM[id] == 0)
	{
	new string3[55], string4[60];
	SendClientMessage(id,-1,"+-------------------------------------------{00FF00}PM{FFFFFF}-------------------------------------------+");
	format(string3, sizeof(string3), "De: {00FF00}%s [ID: %d]{FFFFFF}.", pName(playerid), playerid);
	format(string4, sizeof(string4), "Mensaje: {00FF00}%s{FFFFFF}.",inputtext);
	SendClientMessage(id,-1,string3);
	SendClientMessage(id,-1,string4);
	SendClientMessage(id,-1,"+-------------------------------------------{00FF00}PM{FFFFFF}-------------------------------------------+");
	GameTextForPlayer(id,"~w~PM ~b~recibido~w~. Mira el ~y~Chat~w~!",6000,3);
	}
	if(DPM[id] == 1)
	{
	new string6[125];
	format(string6, sizeof(string6), "{FFFFFF}De: {00FF00}%s [ID: %d]{FFFFFF}.\nMensaje: {00FF00}%s{FFFFFF}.", pName(playerid), playerid,inputtext);
	ShowPlayerDialog(id,1,DIALOG_STYLE_MSGBOX,"{00FF00}|| PM RECIBIDO ||",string6,"Aceptar","");
	GameTextForPlayer(id,"~w~PM ~b~recibido~w~. Mira el ~y~Chat~w~!",6000,3);
	}
	if(DPM[playerid] == 0)
	{
	new string[55], string2[60];
	SendClientMessage(playerid,-1,"+-------------------------------------------{00FF00}PM{FFFFFF}-------------------------------------------+");
	format(string, sizeof(string), "Para: {00FF00}%s [ID: %d]{FFFFFF}.", pName(id), id);
	format(string2, sizeof(string2), "Mensaje: {00FF00}%s{FFFFFF}.",inputtext);
	SendClientMessage(playerid,-1,string);
	SendClientMessage(playerid,-1,string2);
	SendClientMessage(playerid,-1,"+-------------------------------------------{00FF00}PM{FFFFFF}-------------------------------------------+");
	GameTextForPlayer(playerid,"~w~PM enviado ~g~correctamente~w~.",4000,3);
	}
	if(DPM[playerid] == 1)
	{
	new string5[125];
	format(string5, sizeof(string5), "{FFFFFF}Para: {00FF00}%s [ID: %d]{FFFFFF}.\nMensaje: {00FF00}%s{FFFFFF}.", pName(id), id,inputtext);
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"{00FF00}|| PM ENVIADO ||",string5,"Aceptar","");
	GameTextForPlayer(playerid,"~w~PM enviado ~g~correctamente~w~.",4000,3);
	}
	} else
	{
	SendClientMessage(playerid,-1,"El jugador se desconectó.");
	MPP[playerid] = -1;
	}
 	}
	return 1;
	}
	
	
	if(dialogid == LOGUEO)
   	{
   	if(!response){Kickear(playerid);}
   	new file[35];
   	format(file,sizeof(file),"/Usuarios/%s.ini",pName(playerid));
   	if(strlen(inputtext) == 0)
	{
	IntentoL[playerid]++;
	new string[55];
	format(string,sizeof(string),"Contraseña incorrecta. ({FF0000}%d{FFFFFF}/3)",IntentoL[playerid]);
	SendClientMessage(playerid,-1,string);
	ShowPlayerDialog(playerid,LOGUEO,DIALOG_STYLE_PASSWORD,"|| Logueo ||","{FF0000}ERROR:{FFFFFF} Debes escribir una contraseña para loguearte.","Loguear","Cancelar");
	}
	if(strcmp(inputtext,dini_Get(file,"Contraseña"),true) == 0)
	{
	CargarUsuario(playerid);
	} else {
	IntentoL[playerid]++;
	new string[55];
	format(string,sizeof(string),"Contraseña incorrecta. ({FF0000}%d{FFFFFF}/3)",IntentoL[playerid]);
	SendClientMessage(playerid,-1,string);
	ShowPlayerDialog(playerid,LOGUEO,DIALOG_STYLE_PASSWORD,"|| Logueo ||","{FF0000}ERROR:{FFFFFF} La contraseña es incorrecta.","Loguear","Cancelar");
	}
	if(IntentoL[playerid] >= 3){Kickear(playerid);}return 1;}
	
	if(dialogid == 501){if(response){
	switch(listitem)
	{
	case 0:{
	ShowPlayerDialog(playerid,502,DIALOG_STYLE_TABLIST_HEADERS,"Tienda de Armas Blancas",
	"Tipo\tPrecio\n\
	Brass Knuclkes\t$65\n\
	Porra\t$180\n\
	Cuchillo\t$280\n\
	Bate\t$135\n\
	Pala\t$30\n\
	Katana\t$400\n\
	Dildo\t$15\n\
	Flores\t$5\n\
	Bombas a control\t$1000 [5 bombas]\n\
	Cámara\tGratis\n\
	Spray\t$600",
	"Seleccionar", "Cancelar");
	}
	case 1:{ShowPlayerDialog(playerid,503,DIALOG_STYLE_MSGBOX,"|| Compra de RW ||", "{FFFFFF}Pack RW:\n9mm: {FF0000}$120{FFFFFF} (Munición: {00FF00}50{FFFFFF}).\nShawOff: {FF0000}$200{FFFFFF} (Munición: {00FF00}30{FFFFFF}).\nMicro UZI: {FF0000}$110{FFFFFF} (Munición: {00FF00}125{FFFFFF}).\n\n¿Estás seguro de comprar éste pack por un total de {00FF00}$430{FFFFFF}?","Comprar", "Cancelar");}
	case 2:{ShowPlayerDialog(playerid,504,DIALOG_STYLE_MSGBOX,"|| Compra de WW ||", "{FFFFFF}Pack WW:\n9mm-Silenciada: {FF0000}$150{FFFFFF} (Munición: {00FF00}80{FFFFFF}).\nM4: {FF0000}$230{FFFFFF} (Munición: {00FF00}100{FFFFFF}).\nEscopeta de Combate: {FF0000}$300{FFFFFF} (Munición: {00FF00}70{FFFFFF}).\nMP5: {FF0000}$160{FFFFFF} (Munición: {00FF00}65{FFFFFF}).\nRifle campo: {FF0000}$100{FFFFFF} (Munición: {00FF00}50{FFFFFF}).\n\nTOT:{00FF00}$940","Comprar", "Cancelar");}
	case 3:{ShowPlayerDialog(playerid,505,DIALOG_STYLE_MSGBOX,"|| Compra de WW2 ||", "{FFFFFF}Pack WW2:\nDesert: {FF0000}$95{FFFFFF} (Munición: {00FF00}65{FFFFFF}).\nEscopeta: {FF0000}$100{FFFFFF} (Munición: {00FF00}40{FFFFFF}).\nSniper: {FF0000}$70{FFFFFF} (Munición: {00FF00}35{FFFFFF}).\n\n¿Estás seguro de comprar éste pack por un total de {00FF00}$265{FFFFFF}?","Comprar", "Cancelar");}
 	case 4:{CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/armaspack");}
 	case 5:{ShowPlayerDialog(playerid,506,DIALOG_STYLE_TABLIST_HEADERS,"Tienda de armas",
	"Tipo\tPrecios\n\
	Pistolas\t$500\n\
	Sub-fusiles\t$1000\n\
	Micro-fusiles\t$1000\n\
	Escopetas\t$2500\n\
	Rifles\t$4000\n\
	Asalto\t$4500",
	"Seleccionar", "Cancelar");}
	}}return 1;}

	if(dialogid == 506){if(response){
	switch(listitem){
	case 0:{ShowPlayerDialog(playerid,507,DIALOG_STYLE_TABLIST_HEADERS,"Pistolas {00FF00}[$500]",
	"Tipo\tMunición\n\
	9mm\t999\n\
	Silenciada\t999\n\
	Desert-Eagle\t999",
	"Seleccionar", "Cancelar");}
	case 1:{
	ShowPlayerDialog(playerid,508,DIALOG_STYLE_TABLIST_HEADERS,"SubFusiles {00FF00}[$1000]",
	"Tipo\tMunición\n\
	MP5\t999",
	"Seleccionar", "Cancelar");}
	case 2:{
	ShowPlayerDialog(playerid,509,DIALOG_STYLE_TABLIST_HEADERS,"MicroFusiles {00FF00}[$1000]",
	"Tipo\tMunición\n\
	Uzi\t999\n\
	Tec 9\t999",
	"Seleccionar", "Cancelar");}
	case 3:{
	ShowPlayerDialog(playerid,510,DIALOG_STYLE_TABLIST_HEADERS,"Escopetas {00FF00}[$2500]",
	"Tipo\tMunición\n\
	Shaw Off\t999\n\
	Escopeta de combate\t999\n\
	Shotgun\t999",
	"Seleccionar", "Cancelar");}
	case 4:{
	ShowPlayerDialog(playerid,511,DIALOG_STYLE_TABLIST_HEADERS,"Rifles {00FF00}[$4000]",
	"Tipo\tMunición\n\
	Rifle\t999\n\
	Sniper\t999",
	"Seleccionar", "Cancelar");}
	case 5:{
	ShowPlayerDialog(playerid,512,DIALOG_STYLE_TABLIST_HEADERS,"Asaltos {00FF00}[$4500]",
	"Tipo\tMunición\n\
	M4\t999\n\
	AK-47\t999",
	"Seleccionar", "Cancelar");}}}
	return 1;}
	
	
	if(dialogid == 507)
	{if(response){if(Usuario[playerid][Dinero] < 500) return SCM(playerid,red,"[ERROR]: {FFFFFF}No tienes el dinero suficiente!");
	QuitarDinero(playerid,500);
	switch(listitem)
	{case 0:{GivePlayerWeapon(playerid, 22, 999);}
	case 1:{GivePlayerWeapon(playerid, 23, 999);}
	case 2:{GivePlayerWeapon(playerid, 24, 999);}}}
	return 1;}

	if(dialogid == 508){if(response){if(Usuario[playerid][Dinero] < 1000) return SCM(playerid,red,"[ERROR]: {FFFFFF}No tienes el dinero suficiente!");
	QuitarDinero(playerid,1000);
	switch(listitem){
	case 0:{GivePlayerWeapon(playerid, 29, 999);}}}
 	return 1;}

 	if(dialogid == 509){if(response)if(Usuario[playerid][Dinero] < 1000) return SCM(playerid,red,"[ERROR]: {FFFFFF}No tienes el dinero suficiente!");
	QuitarDinero(playerid,1000);
 	{switch(listitem){
	case 0:{GivePlayerWeapon(playerid, 28, 999);}
	case 1:{GivePlayerWeapon(playerid, 32, 999);}}
	}return 1;}

	if(dialogid == 510){if(response){if(Usuario[playerid][Dinero] < 2500) return SCM(playerid,red,"[ERROR]: {FFFFFF}No tienes el dinero suficiente!");
	QuitarDinero(playerid,2500);
	switch(listitem){
	case 0:{GivePlayerWeapon(playerid, 26, 999);}
	case 1:{GivePlayerWeapon(playerid, 27, 999);}
	case 2:{GivePlayerWeapon(playerid, 25, 999);}
	}}return 1;}

	if(dialogid == 511){if(response){if(Usuario[playerid][Dinero] < 4000) return SCM(playerid,red,"[ERROR]: {FFFFFF}No tienes el dinero suficiente!");
	QuitarDinero(playerid,4000);
	switch(listitem){
	case 0:{GivePlayerWeapon(playerid, 33, 999);}
	case 1:{GivePlayerWeapon(playerid, 34, 999);}}}
	return 1;}

	if(dialogid == 512){if(response){if(Usuario[playerid][Dinero] < 4500) return SCM(playerid,red,"[ERROR]: {FFFFFF}No tienes el dinero suficiente!");
	QuitarDinero(playerid,4500);
	switch(listitem){
	case 0:{GivePlayerWeapon(playerid, 31, 999);}
	case 1:{GivePlayerWeapon(playerid, 30, 999);}
	}}return 1;}
	
	
	if(dialogid == 502){if(response){
	switch(listitem)
	{
	case 0:{if(GetPlayerMoney(playerid) < 65) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");GivePlayerWeapon(playerid, 1, 1);QuitarDinero(playerid,65);}
	case 1:{if(GetPlayerMoney(playerid) < 180) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");GivePlayerWeapon(playerid, 3, 1);QuitarDinero(playerid,180);}
	case 2:{if(GetPlayerMoney(playerid) < 280) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");GivePlayerWeapon(playerid, 4, 1);QuitarDinero(playerid,280);}
	case 3:{if(GetPlayerMoney(playerid) < 135) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");GivePlayerWeapon(playerid, 5, 1);QuitarDinero(playerid,135);}
	case 4:{if(GetPlayerMoney(playerid) < 30) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");GivePlayerWeapon(playerid, 6, 1);QuitarDinero(playerid,30);}
	case 5:{if(GetPlayerMoney(playerid) < 400) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");GivePlayerWeapon(playerid, 8, 1);QuitarDinero(playerid,400);}
	case 6:{if(GetPlayerMoney(playerid) < 15) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");GivePlayerWeapon(playerid, 10, 1);QuitarDinero(playerid,15);}
	case 7:{if(GetPlayerMoney(playerid) < 5) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");GivePlayerWeapon(playerid, 14, 1);QuitarDinero(playerid,5);}
	case 8:{if(GetPlayerMoney(playerid) < 280) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");GivePlayerWeapon(playerid, 39, 5);QuitarDinero(playerid,280);}
	case 9:{GivePlayerWeapon(playerid, 43, 999);}
	case 10:{if(GetPlayerMoney(playerid) < 600) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");
	GivePlayerWeapon(playerid, 41, 800);QuitarDinero(playerid,600);}}}return 1;}

	if(dialogid == 503)
	{if(response){if(GetPlayerMoney(playerid) < 430) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");
	GivePlayerWeapon(playerid, 22, 50);	GivePlayerWeapon(playerid, 26, 30);	GivePlayerWeapon(playerid, 28, 125);QuitarDinero(playerid,430);
    SendClientMessage(playerid,green,"[PACK RW]: {FFFFFF}Compraste éxitosamente el pack RW. Se te descontó el dinero correspondiente.");
	}return 1;}

 	if(dialogid == 504)
	{if(response){if(GetPlayerMoney(playerid) < 860) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");
	GivePlayerWeapon(playerid, 22, 80);GivePlayerWeapon(playerid, 31, 100);GivePlayerWeapon(playerid, 27, 70);GivePlayerWeapon(playerid, 29, 65);
	GivePlayerWeapon(playerid, 33, 50);QuitarDinero(playerid,860);SendClientMessage(playerid,green,"[PACK WW]: {FFFFFF}Compraste éxitosamente el pack WW. Se te descontó el dinero correspondiente.");
	}return 1;}
 	
 	if(dialogid == 505)
	{
	if(response)
	{
	if(GetPlayerMoney(playerid) < 265) return SendClientMessage(playerid,-1,"No tienes dinero suficiente.");
	GivePlayerWeapon(playerid, 24, 65);
	GivePlayerWeapon(playerid, 25, 40);
	GivePlayerWeapon(playerid, 34, 35);
    QuitarDinero(playerid,265);
    SendClientMessage(playerid,green,"[PACK WW2]: {FFFFFF}Compraste éxitosamente el pack WW2. Se te descontó el dinero correspondiente.");
	}
 	return 1;
 	}
 	
	if(dialogid == Autos)
	{
	if(response)
	{
	switch (listitem)
	{
	case 0: {ShowPlayerDialog(playerid, Autos1, DIALOG_STYLE_LIST, "Autos generales.",
	"Admiral\n\
 	Blade\n\
	Blistac\n\
	Bravura\n\
	Broadway\n\
	Buffalo\n\
	Cadrona\n\
	Cheetah\n\
	Clover\n\
	Comet\n\
	CopCarla\n\
	CopCarsf\n\
	Elegant\n\
	Elegy\n\
	Glendale\n\
	Manana\n\
	Premier\n\
	Sabre\n\
	Savanna\n\
	Taxi\n\
	Voodoo\n\
	Zr350\n\
	Kart\n\
	Mower\n\
	Sweeper","Aceptar","Atras");}
	case 1: {ShowPlayerDialog(playerid, Autos2, DIALOG_STYLE_LIST, "Autos deportivos.",
	"{FF0000}Alpha\n\
	{FF0000}Banshee\n\
	{FF0000}Bullet\n\
	{FF0000}Comet\n\
	{FF0000}Euros\n\
	{FF0000}Hotrina\n\
	{FF0000}Hotring\n\
	{FF0000}Infernus\n\
	{FF0000}Jester\n\
	{FF0000}Phonix\n\
	{FF0000}Sultan\n\
	{FF0000}Supergt\n\
	{FF0000}Turismo\n\
	{FF0000}Uranus","Seleccionar","Atras");}
	case 2: {ShowPlayerDialog(playerid, Autos3, DIALOG_STYLE_LIST, "Motos & bicicletas",
	"{00FF00}NRG-500\n\
	{00FF00}Faggio\n\
	{00FF00}FCR-900\n\
	{00FF00}PCJ-600\n\
	{00FF00}Freeway\n\
	{00FF00}BF-400\n\
	{00FF00}PizzaBoy\n\
	{00FF00}CopBike\n\
	{00FF00}Sanchez\n\
	{00FF00}Cuatrimoto\n\
	{00FF00}Bike\n\
	{00FF00}BMX\n\
	{00FF00}Mountain Bike\n\
	{00FF00}Wayfarer","Seleccionar","Atras");}
	case 3: {ShowPlayerDialog(playerid, Autos4, DIALOG_STYLE_LIST, "Camiones.",
	"{0000FF}Ambulance\n\
	{0000FF}Benson\n\
	{0000FF}BobCat\n\
	{0000FF}Burrito\n\
	{0000FF}Bus\n\
	{0000FF}Camper\n\
	{0000FF}Coach\n\
	{0000FF}FireTruck\n\
	{0000FF}Patriot\n\
	{0000FF}Rancher\n\
	{0000FF}Walton\n\
	{0000FF}Duneride\n\
	{0000FF}Monster\n\
	{0000FF}Verga Movil\n\
	{0000FF}Dumper","Seleccionar","Atras");}
	case 4: {ShowPlayerDialog(playerid, Autos5, DIALOG_STYLE_LIST, "Aviones.",
	"{FFFFFF}Rustler\n\
	{FFFFFF}Dodo\n\
	{FFFFFF}Nevada\n\
	{FFFFFF}StuntPlane\n\
	{FFFFFF}Beagle\n\
	{FFFFFF}Skimer\n\
	{FFFFFF}Shamal","Seleccionar","Atras");}
	case 5: {ShowPlayerDialog(playerid, Autos6, DIALOG_STYLE_LIST, "Helicópteros.",
	"{80FF00}Cargobob\n\
	{80FF00}Leviathn\n\
	{80FF00}Maverick\n\
	{80FF00}PolMav\n\
	{80FF00}RainDanc\n\
	{80FF00}VsnMav\n\
	{80FF00}Sparrow","Seleccionar","Atras");}
	case 6: {ShowPlayerDialog(playerid, Autos7, DIALOG_STYLE_LIST, "Barcos.",
	"{0000FF}CoastGuard\n\
	{0000FF}Dhingy\n\
	{0000FF}JetMax\n\
	{0000FF}Launch\n\
	{0000FF}Marquis\n\
	{0000FF}Predato\n\
	{0000FF}Speedr\n\
	{0000FF}Squalo\n\
	{0000FF}Vortex\n\
	{0000FF}Reefer","Seleccionar","Atras");
	}
	}
	}
	return 1;
	}

	if(dialogid == Autos1)
	{
	if(response == 0)
	{
	ShowPlayerDialog(playerid,Autos,DIALOG_STYLE_LIST, "Vehículos del servidor.", ">>Autos generales\n>>Autos Deportivos\n>>Motos & Bicicletas\n>>Camiones\n>>Aviones\n>>Helicópteros\n>>Barcos", "Aceptar","Cancelar");
	return 1;
	}
	if(response)
	{
	switch (listitem)
	{
	case 0: {CarSpawner1(playerid,445);}
	case 1: {CarSpawner1(playerid,536);}
	case 2: {CarSpawner1(playerid,496);}
	case 3: {CarSpawner1(playerid,401);}
	case 4: {CarSpawner1(playerid,575);}
	case 5: {CarSpawner1(playerid,402);}
	case 6: {CarSpawner1(playerid,527);}
	case 7: {CarSpawner1(playerid,415);}
	case 8: {CarSpawner1(playerid,542);}
	case 9: {CarSpawner1(playerid,480);}
	case 10: {CarSpawner1(playerid,596);}
	case 11: {CarSpawner1(playerid,597);}
	case 12: {CarSpawner1(playerid,507);}
	case 13: {CarSpawner1(playerid,562);}
	case 14: {CarSpawner1(playerid,466);}
	case 15: {CarSpawner1(playerid,410);}
	case 16: {CarSpawner1(playerid,426);}
	case 17: {CarSpawner1(playerid,475);}
	case 18: {CarSpawner1(playerid,467);}
	case 19: {CarSpawner1(playerid,420);}
	case 20: {CarSpawner1(playerid,412);}
	case 21: {CarSpawner1(playerid,477);}
	case 22: {CarSpawner1(playerid,571);}
	case 23: {CarSpawner1(playerid,572);}
	case 24: {CarSpawner1(playerid,574);}
	}
	}
	return 1;
	}

	if(dialogid == Autos2)
	{
	if(response == 0)
	{
	ShowPlayerDialog(playerid,Autos,DIALOG_STYLE_LIST, "Vehículos del servidor.", ">>Autos generales\n>>Autos Deportivos\n>>Motos & Bicicletas\n>>Camiones\n>>Aviones\n>>Helicópteros\n>>Barcos", "Aceptar","Cancelar");
	}
	if(response)
	{
	switch (listitem)
	{
	case 0: {CarSpawner1(playerid,602);}
	case 1: {CarSpawner1(playerid,429);}
	case 2: {CarSpawner1(playerid,541);}
	case 3: {CarSpawner1(playerid,480);}
	case 4: {CarSpawner1(playerid,587);}
	case 5: {CarSpawner1(playerid,502);}
	case 6: {CarSpawner1(playerid,494);}
	case 7: {CarSpawner1(playerid,411);}
	case 8: {CarSpawner1(playerid,559);}
	case 9: {CarSpawner1(playerid,603);}
	case 10: {CarSpawner1(playerid,560);}
	case 11: {CarSpawner1(playerid,506);}
	case 12: {CarSpawner1(playerid,451);}
	case 13: {CarSpawner1(playerid,558);}
	}
	}
	return 1;
	}

	if(dialogid == Autos3)
	{
	if(response == 0)
	{
	ShowPlayerDialog(playerid,Autos,DIALOG_STYLE_LIST, "Vehículos del servidor.", ">>Autos generales\n>>Autos Deportivos\n>>Motos & Bicicletas\n>>Camiones\n>>Aviones\n>>Helicópteros\n>>Barcos", "Aceptar","Cancelar");
	}
	if(response)
	{
	switch (listitem)
	{
	case 0: {CarSpawner1(playerid,522);}
	case 1: {CarSpawner1(playerid,462);}
	case 2: {CarSpawner1(playerid,521);}
	case 3: {CarSpawner1(playerid,461);}
	case 4: {CarSpawner1(playerid,463);}
	case 5: {CarSpawner1(playerid,581);}
	case 6: {CarSpawner1(playerid,448);}
	case 7: {CarSpawner1(playerid,523);}
	case 8: {CarSpawner1(playerid,468);}
	case 9: {CarSpawner1(playerid,471);}
	case 10: {CarSpawner1(playerid,509);}
	case 11: {CarSpawner1(playerid,481);}
	case 12: {CarSpawner1(playerid,510);}
	case 13: {CarSpawner1(playerid,586);}
	}
	}
	return 1;
	}

	if(dialogid == Autos4)
	{
	if(response == 0)
	{
	ShowPlayerDialog(playerid,Autos,DIALOG_STYLE_LIST, "Vehículos del servidor.", ">>Autos generales\n>>Autos Deportivos\n>>Motos & Bicicletas\n>>Camiones\n>>Aviones\n>>Helicópteros\n>>Barcos", "Aceptar","Cancelar");
	}
	if(response)
	{
	switch (listitem)
	{
	case 0: {CarSpawner1(playerid,416);}
	case 1: {CarSpawner1(playerid,499);}
	case 2: {CarSpawner1(playerid,422);}
	case 3: {CarSpawner1(playerid,482);}
	case 4: {CarSpawner1(playerid,431);}
	case 5: {CarSpawner1(playerid,483);}
	case 6: {CarSpawner1(playerid,437);}
	case 7: {CarSpawner1(playerid,407);}
	case 8: {CarSpawner1(playerid,470);}
	case 9: {CarSpawner1(playerid,489);}
	case 10: {CarSpawner1(playerid,578);}
	case 11: {CarSpawner1(playerid,573);}
	case 12: {CarSpawner1(playerid,444);}
	case 13: {CarSpawner1(playerid,423);}
	case 14: {CarSpawner1(playerid,406);}
	}
	}
	return 1;
	}

	if(dialogid == Autos5)
	{
	if(response == 0)
	{
	ShowPlayerDialog(playerid,Autos,DIALOG_STYLE_LIST, "Vehículos del servidor.", ">>Autos generales\n>>Autos Deportivos\n>>Motos & Bicicletas\n>>Camiones\n>>Aviones\n>>Helicópteros\n>>Barcos", "Aceptar","Cancelar");
	}
	if(response)
	{
	switch (listitem)
	{
	case 0: {CarSpawner1(playerid,476);}
	case 1: {CarSpawner1(playerid,593);}
	case 2: {CarSpawner1(playerid,553);}
	case 3: {CarSpawner1(playerid,513);}
	case 4: {CarSpawner1(playerid,511);}
	case 5: {CarSpawner1(playerid,460);}
	case 6: {CarSpawner1(playerid,519);}
	}
	}
	return 1;
	}

	if(dialogid == Autos6)
	{
	if(response == 0)
	{
	ShowPlayerDialog(playerid,Autos,DIALOG_STYLE_LIST, "Vehículos del servidor.", ">>Autos generales\n>>Autos Deportivos\n>>Motos & Bicicletas\n>>Camiones\n>>Aviones\n>>Helicópteros\n>>Barcos", "Aceptar","Cancelar");
	}
	if(response)
	{
	switch (listitem)
	{
	case 0: {CarSpawner1(playerid,548);}
	case 1: {CarSpawner1(playerid,417);}
	case 2: {CarSpawner1(playerid,487);}
	case 3: {CarSpawner1(playerid,497);}
	case 4: {CarSpawner1(playerid,563);}
	case 5: {CarSpawner1(playerid,488);}
	case 6: {CarSpawner1(playerid,469);}
	}
	}
	return 1;
	}

	if(dialogid == Autos7)
	{
	if(response == 0)ShowPlayerDialog(playerid,Autos,DIALOG_STYLE_LIST, "Vehículos del servidor.", ">>Autos generales\n>>Autos Deportivos\n>>Motos & Bicicletas\n>>Camiones\n>>Aviones\n>>Helicópteros\n>>Barcos", "Aceptar","Cancelar");
	if(response)
	{
	switch (listitem)
	{
	case 0: {CarSpawner1(playerid,472);}
	case 1: {CarSpawner1(playerid,473);}
	case 2: {CarSpawner1(playerid,493);}
	case 3: {CarSpawner1(playerid,595);}
	case 4: {CarSpawner1(playerid,484);}
	case 5: {CarSpawner1(playerid,430);}
	case 6: {CarSpawner1(playerid,452);}
	case 7: {CarSpawner1(playerid,446);}
	case 8: {CarSpawner1(playerid,539);}
	case 9: {CarSpawner1(playerid,453);}
	}
	}
	return 1;
	}
	return 1;
	}


public OnPlayerPickUpPickup(playerid, pickupid)
{
    new propid = -1;
	for(new id = 0; id<PropiedadesC+1; id++)
	{
		if(PropInfo[id][PickupNr] == pickupid)
		{
			propid = id;
            break;
		}
	}
	if(propid != -1 && PropInfo[propid][PropO] == 0)
	{
	    new str[128];
    	format(str, 128, "~w~Valor: ~b~$%d~n~~w~Gastos: ~b~$%d~n~~w~Propietario: ~b~%s",PropInfo[propid][PropValue], PropInfo[propid][PropValue]/10, PropInfo[propid][PropOwner]);
		GameTextForPlayer(playerid, str, 6000, 3);
	}
	
	if(pickupid == GANAPARKOUR1)
	{
	SetPlayerScore(playerid,GetPlayerScore(playerid) +20);
	SpawnPlayer(playerid);
	Minijuego[playerid] = 0;
	SendClientMessage(playerid,red, "[Felicidades]: {FFFFFF}Ganaste Parkour Premio 20 Score + 1000$");
	DarDinero(playerid,10000);
	}

	if(pickupid == GANAPARKOUR2)
	{
	SetPlayerScore(playerid,GetPlayerScore(playerid) +20);
	SpawnPlayer(playerid);
	Minijuego[playerid] = 0;
	SendClientMessage(playerid,red, "[Felicidades]: {FFFFFF}Ganaste Parkour Premio 20 Score + 1000$");
	QuitarDinero(playerid,10000);
	}

	if(pickupid == GANAPARKOUR3)
	{
	SetPlayerScore(playerid,GetPlayerScore(playerid) +20);
	SpawnPlayer(playerid);
	Minijuego[playerid] = 0;
	SendClientMessage(playerid,red, "[Felicidades]: {FFFFFF}Ganaste Parkour Premio 20 Score + 1000$");
	DarDinero(playerid,10000);
	}

	if(pickupid == PickupParkourDinero)
	{
	DarDinero(playerid,1000);
	SendClientMessage(playerid,red,"[INFO]: {FFFFFF}Encontraste 1000$ en el parkour!");
	DestroyPickup(PickupParkourDinero);
	}


	if(pickupid == PickupFinParkourArma)
	{
	GivePlayerWeapon(playerid,25,500);
	SendClientMessage(playerid,red,"[INFO]: {FFFFFF}Usa el arma para romper los obstáculos.");
	}


	if(pickupid == PickupFinParkour)
	{
	DarDinero(playerid,5000);
	new FinParkour[110];
	format(FinParkour,sizeof(FinParkour),"[MINIJUEGOS]: {00FF00}%s {FFFFFF}completó el más difícil. {0000FF}[Premio: $5000]",pName(playerid));
	SendClientMessageToAll(yellow,FinParkour);
	SpawnPlayer(playerid);
	}
	return 1;
}


stock Borrarlas()
{
    for(new i;i<100;i++)
	{
	DestroyPickup(PropInfo[i][PickupNr]);
	Delete3DTextLabel(PropInfo[i][Texto]);
	}
}

stock CargarPropiedades()
{
	ContarPropiedades();
   	new string[250];
	new BoughtProps;
    for(new id = 0; id < PropiedadesC; id++)
	{
	new file[30];
	format(file, sizeof(file), DIRECCION, id);
	PropInfo[id][PropX] = dini_Float(file, "PosX");
	PropInfo[id][PropY] = dini_Float(file, "PosY");
	PropInfo[id][PropZ] = dini_Float(file, "PosZ");
	PropInfo[id][PropValue] = dini_Int(file, "PropValor");
	PropInfo[id][PropEarning] = dini_Int(file, "PropGastos");
	PropInfo[id][PropIsBought] = dini_Int(file, "PropVenta");
	PropInfo[id][PropM] = dini_Int(file, "PropMundo");
	PropInfo[id][PropI] = dini_Int(file, "Interior");
	PropInfo[id][PropEX] = dini_Float(file, "PosEX");
	PropInfo[id][PropEY] = dini_Float(file, "PosEY");
	PropInfo[id][PropEZ] = dini_Float(file, "PosEZ");
	PropInfo[id][PropO] = dini_Int(file, "PropO");
    format(PropInfo[id][PropName], 64, "%s", dini_Get(file, "Propiedad"));
  	format(PropInfo[id][PropOwner], MAX_PLAYER_NAME,dini_Get(file, "Propietario"));
	if(PropInfo[id][PropIsBought] == 1 && PropInfo[id][PropO] == 0)
	{
	format(string,sizeof(string),"Casa [{FF0000}COMPRADA{FFFFFF}]\nDueño: {00FF00}%s{FFFFFF}.\nValor: {00FF00}$%d",PropInfo[id][PropOwner],PropInfo[id][PropValue]);
    PropInfo[id][Texto] = Create3DTextLabel(string, 0xFFFFFFFF, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ], 15.0, 0, 0);
    PropInfo[id][PickupNr] = CreatePickup(1272, 1, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ]);
	PropInfo[id][PropS] = Create3DTextLabel("Usa {0000FF}/salir{FFFFFF} para abandonar el lugar.", 0xFFFFFFFF, PropInfo[id][PropEX], PropInfo[id][PropEY], PropInfo[id][PropEZ], 7.0, PropInfo[id][PropM], 0);
	}
	if(PropInfo[id][PropIsBought] == 0 && PropInfo[id][PropO] == 0)
	{
	format(string,sizeof(string),"Casa [{00FF00}EN VENTA{FFFFFF}]\nDueño: {00FF00}N/A{FFFFFF}.\nValor: {00FF00}$%d{FFFFFF}\nGastos: {00FF00}$%d{FFFFFF}\nUsa {00FF00}/comprar casa{FFFFFF} para adquirirla.",PropInfo[id][PropValue],(PropInfo[id][PropValue]/10));
    PropInfo[id][Texto] = Create3DTextLabel(string, 0xFFFFFFFF, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ], 15.0, 0, 0);
    PropInfo[id][PickupNr] = CreatePickup(1273, 1, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ]);
    PropInfo[id][PropS] = Create3DTextLabel("Usa {0000FF}/salir{FFFFFF} para abandonar el lugar.", 0xFFFFFFFF, PropInfo[id][PropEX], PropInfo[id][PropEY], PropInfo[id][PropEZ], 7.0, PropInfo[id][PropM], 0);
	}
	if(PropInfo[id][PropIsBought] == 1 && PropInfo[id][PropO] == 1)
	{
	format(string,sizeof(string),"Restaurante\n{FFFFFF}Dueño: {00FF00}%s{FFFFFF}.\nValor: {00FF00}$%d\n{FFFFFF}Ganancia: {00FF00}$%d",PropInfo[id][PropOwner],PropInfo[id][PropValue],(PropInfo[id][PropValue]/4));
    PropInfo[id][Texto] = Create3DTextLabel(string, 0x0000FFFF, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ], 15.0, 0, 0);
    PropInfo[id][PickupNr] = CreatePickup(1239, 1, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ]);
    PropInfo[id][PropS] = Create3DTextLabel("Usa {0000FF}/salir{FFFFFF} para abandonar el restaurante.", 0xFFFFFFFF, PropInfo[PropiedadesC][PropEX], PropInfo[id][PropEY], PropInfo[id][PropEZ], 7.0, PropInfo[id][PropM], 0);
	}
	if(PropInfo[id][PropIsBought] == 0 && PropInfo[id][PropO] == 1)
	{
	format(string,sizeof(string),"Restaurante {FFFFFF}[{00FF00}EN VENTA{FFFFFF}]\nDueño: {00FF00}N/A{FFFFFF}.\nValor: {00FF00}$%d{FFFFFF}\nGanancias: {00FF00}$%d{FFFFFF}\nUsa {00FF00}/comprar restaurante{FFFFFF} para adquirirlo.",PropInfo[id][PropValue],(PropInfo[id][PropValue]/4));
    PropInfo[id][Texto] = Create3DTextLabel(string, 0x0000FFFF, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ], 15.0, 0, 0);
    PropInfo[id][PickupNr] = CreatePickup(1273, 1, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ]);
    PropInfo[id][PropS] = Create3DTextLabel("Usa {0000FF}/salir{FFFFFF} para abandonar el restaurante.", 0xFFFFFFFF, PropInfo[id][PropEX], PropInfo[id][PropEY], PropInfo[id][PropEZ], 7.0, PropInfo[id][PropM], 0);
	}
	if(PropInfo[id][PropIsBought] == 1)
	{
	BoughtProps++;
	}
  	}
  	printf("===================================");
	printf("||    Se creo %d propiedades  	 ||", PropiedadesC);
	printf("||	  %d estan compradas      ||", BoughtProps);
	printf("===================================");
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
if(ECarrera[playerid] == 1)
{
switch(CPP[playerid])
{
case 1:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP2X],CarreraI[CP2Y],CarreraI[CP2Z],CarreraI[CP3X],CarreraI[CP3Y],CarreraI[CP3Z],10);CPP[playerid]++;}
case 2:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP3X],CarreraI[CP3Y],CarreraI[CP3Z],CarreraI[CP4X],CarreraI[CP4Y],CarreraI[CP4Z],10);CPP[playerid]++;}
case 3:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP4X],CarreraI[CP4Y],CarreraI[CP4Z],CarreraI[CP5X],CarreraI[CP5Y],CarreraI[CP5Z],10);CPP[playerid]++;}
case 4:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP5X],CarreraI[CP5Y],CarreraI[CP5Z],CarreraI[CP6X],CarreraI[CP6Y],CarreraI[CP6Z],10);CPP[playerid]++;}
case 5:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP6X],CarreraI[CP6Y],CarreraI[CP6Z],CarreraI[CP7X],CarreraI[CP7Y],CarreraI[CP7Z],10);CPP[playerid]++;}
case 6:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP7X],CarreraI[CP7Y],CarreraI[CP7Z],CarreraI[CP8X],CarreraI[CP8Y],CarreraI[CP8Z],10);CPP[playerid]++;}
case 7:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP8X],CarreraI[CP8Y],CarreraI[CP8Z],CarreraI[CP9X],CarreraI[CP9Y],CarreraI[CP9Z],10);CPP[playerid]++;}
case 8:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP9X],CarreraI[CP9Y],CarreraI[CP9Z],CarreraI[CP10X],CarreraI[CP10Y],CarreraI[CP10Z],10);CPP[playerid]++;}
case 9:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP10X],CarreraI[CP10Y],CarreraI[CP10Z],CarreraI[CP11X],CarreraI[CP11Y],CarreraI[CP11Z],10);CPP[playerid]++;}
case 10:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP11X],CarreraI[CP11Y],CarreraI[CP11Z],CarreraI[CP12X],CarreraI[CP12Y],CarreraI[CP12Z],10);CPP[playerid]++;}
case 11:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP12X],CarreraI[CP12Y],CarreraI[CP12Z],CarreraI[CP13X],CarreraI[CP13Y],CarreraI[CP13Z],10);CPP[playerid]++;}
case 12:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP13X],CarreraI[CP13Y],CarreraI[CP13Z],CarreraI[CP14X],CarreraI[CP14Y],CarreraI[CP14Z],10);CPP[playerid]++;}
case 13:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP14X],CarreraI[CP14Y],CarreraI[CP14Z],CarreraI[CP15X],CarreraI[CP15Y],CarreraI[CP15Z],10);CPP[playerid]++;}
case 14:{SetPlayerRaceCheckpoint(playerid,0,CarreraI[CP15X],CarreraI[CP15Y],CarreraI[CP15Z],CarreraI[CpFinX],CarreraI[CpFinY],CarreraI[CpFinZ],10);CPP[playerid]++;}
case 15:{SetPlayerRaceCheckpoint(playerid,1,CarreraI[CpFinX],CarreraI[CpFinY],CarreraI[CpFinZ],0.0,0.0,0.0,10);CPP[playerid]++;}
case 16:{DisablePlayerRaceCheckpoint(playerid);new string[100];Llegadas++;CPP[playerid] = 0;
switch(Llegadas)
{
case 1:{format(string,sizeof(string),"[CARRERA]: {FFFFFF}%s ganó la carrera. {0000FF}[PUESTO: %d°]",pName(playerid),Llegadas);SendClientMessageToAll(blue,string);DarDinero(playerid,15000);}
case 2..9:{format(string,sizeof(string),"[CARRERA]: {FFFFFF}%s terminó la carrera. {0000FF}[PUESTO: %d°]",pName(playerid),Llegadas);SendClientMessageToAll(blue,string);DarDinero(playerid,5000);}
}
if(posiciones == Llegadas){
for(new i, g = GetMaxPlayers(); i < g; i++){
if(ECarrera[i] == 1){ECarrera[i] = 0;SetPlayerPos(i, 0.0, 0.0, 0.0);SpawnPlayer(i);SCM(i,green,"[CARRERA FINALIZADA]: {FFFFFF}La carrera se finalizó correctamente!");posiciones = 0;Llegadas = 0;carreraon = 0;CPP[i] = 0;DestroyVehicle(TieneAuto[i]);}}}}}}
return 1;}



public OnPlayerSpawn(playerid)
{
if(Spawneo[playerid] == 0){SetTimerEx("db",1,false,"d",playerid);TextDrawShowForPlayer(playerid,Textdraw[10]);TextDrawShowForPlayer(playerid,Textdraw[9]);
for(new i;i<Zonas;i++)
{
GangZoneShowForPlayer(playerid,ZonaInfo[i][Zcreada],green);
}
new stringa[145];
new TC[10];
new TVIP[10];
new TMODO[12];
if(PlayerGang[playerid] == 0){TC = "N/A";}
if(PlayerGang[playerid] > 0){format(TC,sizeof(TC),"%s",GangInfo[PlayerGang[playerid]][GANG_NAME]);}
switch(Usuario[playerid][pVip])
{
case 0: TVIP = "N/A";
case 1: TVIP = "Bronce";
case 2: TVIP = "Plata";
case 3: TVIP = "Oro";
case 4: TVIP = "Elite";
case 5: TVIP = "Dios";
case 6: TVIP = "Supremo";
}
switch(Usuario[playerid][Modo])
{
case 0: TMODO = "N/A";
case 1: TMODO = "Freeroam";
case 2: TMODO = "DM";
case 3: TMODO = "Carreras";
}
format(stringa,sizeof(stringa),"~>~~b~Stats~w~~<~ ~r~Score~w~: %d ~y~Dinero~w~: $%d ~g~Clan~w~: %s ~p~Nivel~w~: %d ~b~VIP~w~: %s ~r~Modo~w~: %s",GetPlayerScore(playerid),GetPlayerMoney(playerid),TC,GetPlayerNivel(playerid),TVIP,TMODO);TextDrawSetString(Stats[playerid],stringa);TextDrawShowForPlayer(playerid,Stats[playerid]);
Spawneo[playerid] = 1;
TextDrawShowForPlayer(playerid,FPSP[playerid]);TextDrawShowForPlayer(playerid,Textdraw[1]);
GivePlayerWeapon(playerid,24,300);GivePlayerWeapon(playerid,25,300);GivePlayerWeapon(playerid,28,300);GivePlayerWeapon(playerid,30,300);SetPlayerInterior(playerid,0);SetPlayerVirtualWorld(playerid,0);
}
if(Spawneo[playerid] == 1 && GetTickCount() - TSPAWN[playerid] < 100){new id = playerid;BanA(id,"ClassFlood");}
if(Spawneo[playerid] == 1 && TSPAWN[playerid] == 0){TSPAWN[playerid] = GetTickCount();}
if(Spawneo[playerid] == 1 && Usuario[playerid][Modo] == 0){new id = playerid;KickA(id,"NSMD");}
ResetPlayerWeapons(playerid);
if(Skin[playerid] != 0){SetPlayerSkin(playerid,Skin[playerid]);}TogglePlayerControllable(playerid,true);
new file[50];
format(file,sizeof(file),"Player Objects/%s.ini",pName(playerid));
if(!dini_Exists(file)) return 1;
for(new x;x<MAX_OSLOTS;x++)
{format(f1,15,"O_Model_%d",x);format(f2,15,"O_Bone_%d",x);format(f3,15,"O_OffX_%d",x);format(f4,15,"O_OffY_%d",x);format(f5,15,"O_OffZ_%d",x);format(f6,15,"O_RotX_%d",x);format(f7,15,"O_RotY_%d",x);format(f8,15,"O_RotZ_%d",x);format(f9,15,"O_ScaleX_%d",x);format(f10,15,"O_ScaleY_%d",x);format(f11,15,"O_ScaleZ_%d",x);
if(dini_Int(file,f1)!=0 && Desmadre[playerid] == 0){SetPlayerAttachedObject(playerid,x,dini_Int(file,f1),dini_Int(file,f2),dini_Float(file,f3),dini_Float(file,f4),dini_Float(file,f5),dini_Float(file,f6),dini_Float(file,f7),dini_Float(file,f8),dini_Float(file,f9),dini_Float(file,f10),dini_Float(file,f11));}}
if(Desmadre[playerid] == 0 || Usuario[playerid][Aduty] == 0 || Minigun[playerid] == 0)
{
SetPlayerHealth(playerid,100000);SendClientMessage(playerid,green,"[ANTI-SK]: {FFFFFF}Estás protegido por {00FF00}5{FFFFFF} segundos de anti-spawnkill.");
SetTimerEx("AntiSpawnKill", 5000, 0, "i",playerid);
}

if(Usuario[playerid][Modo] == 3)
{
ResetPlayerWeapons(playerid);
SetPlayerPos(playerid,-1408.1006,-265.8621,1043.6563);
SetPlayerInterior(playerid,7);
return 1;
}

if(Spawneo[playerid] == 1 && Zona[playerid] == 1)
{
new casos = random(4);
switch(casos)
{
case 0:{SetPlayerPos(playerid,2662.9497,2789.0850,10.8203);}
case 1:{SetPlayerPos(playerid,2641.3906,2750.8149,23.8222);}
case 2:{SetPlayerPos(playerid,2607.2820,2789.1260,23.4219);}
case 3:{SetPlayerPos(playerid,2585.0920,2808.4495,10.8203);}}
Minijuego[playerid] = 1;RemovePlayerFromVehicle(playerid);ResetPlayerWeapons(playerid);SetPlayerVirtualWorld(playerid,10);SetPlayerInterior(playerid, 0);Zona[playerid] = 1;
SetPlayerHealth(playerid, 100);GivePlayerWeapon(playerid,26,999);GivePlayerWeapon(playerid,28,999);
RemovePlayerAttachedObject(playerid,2);RemovePlayerAttachedObject(playerid,0);RemovePlayerAttachedObject(playerid,1);RemovePlayerAttachedObject(playerid,3);RemovePlayerAttachedObject(playerid,4);RemovePlayerAttachedObject(playerid,5);RemovePlayerAttachedObject(playerid,6);RemovePlayerAttachedObject(playerid,7);RemovePlayerAttachedObject(playerid,8);RemovePlayerAttachedObject(playerid,9);
return 1;
}
		
if(Spawneo[playerid] == 1 && Minijuego[playerid] == 1 && GetPlayerTeam(playerid) == 10){
ResetPlayerWeapons(playerid);SetPlayerVirtualWorld(playerid,10);SetPlayerInterior(playerid, 0);SetPlayerTeam(playerid, 10);SetPlayerHealth(playerid, 100);SetPlayerArmour(playerid, 100);GivePlayerWeapon(playerid,24,999);GivePlayerWeapon(playerid,27,999);GivePlayerWeapon(playerid,31,999);GivePlayerWeapon(playerid,29,999);SetPlayerColor(playerid,blue);SetPlayerSkin(playerid,285);
SetPlayerPos(playerid,2847.9656,-2362.8164,22.7987);RemovePlayerAttachedObject(playerid,2);RemovePlayerAttachedObject(playerid,0);RemovePlayerAttachedObject(playerid,1);RemovePlayerAttachedObject(playerid,3);RemovePlayerAttachedObject(playerid,4);RemovePlayerAttachedObject(playerid,5);RemovePlayerAttachedObject(playerid,6);RemovePlayerAttachedObject(playerid,7);
RemovePlayerAttachedObject(playerid,8);RemovePlayerAttachedObject(playerid,9);return 1;}

if(Spawneo[playerid] == 1 && Minijuego[playerid] == 1 && GetPlayerTeam(playerid) == 11){
ResetPlayerWeapons(playerid);SetPlayerVirtualWorld(playerid,10);SetPlayerInterior(playerid, 0);SetPlayerTeam(playerid, 11);SetPlayerHealth(playerid, 100);SetPlayerArmour(playerid, 100);GivePlayerWeapon(playerid,24,999);
GivePlayerWeapon(playerid,27,999);GivePlayerWeapon(playerid,31,999);SetPlayerPos(playerid,2838.2942,-2531.4246,17.9734);GivePlayerWeapon(playerid,29,999);SetPlayerColor(playerid,red);SetPlayerSkin(playerid,174);RemovePlayerAttachedObject(playerid,2);
RemovePlayerAttachedObject(playerid,0);RemovePlayerAttachedObject(playerid,1);RemovePlayerAttachedObject(playerid,3);RemovePlayerAttachedObject(playerid,4);RemovePlayerAttachedObject(playerid,5);RemovePlayerAttachedObject(playerid,6);RemovePlayerAttachedObject(playerid,7);RemovePlayerAttachedObject(playerid,8);RemovePlayerAttachedObject(playerid,9);
return 1;}

if(Minijuego[playerid] == 1 && Guerra[playerid] == 1){ResetPlayerWeapons(playerid);GivePlayerWeapon(playerid,31,999);GivePlayerWeapon(playerid,24,999);GivePlayerWeapon(playerid,27,999);SetPlayerVirtualWorld(playerid,25);
new spawnea = random(6);
switch(spawnea)
{
case 0: SetPlayerPos(playerid,293.0795,1864.1844,17.6406);
case 1: SetPlayerPos(playerid,349.9177,2015.4403,22.6406);
case 2: SetPlayerPos(playerid,281.6288,2050.0801,18.0417);
case 3: SetPlayerPos(playerid,251.7110,1916.5933,17.6406);
case 4: SetPlayerPos(playerid,170.7848,1935.5001,18.3500);
case 5: SetPlayerPos(playerid,122.5128,1908.8268,18.7340);
}
return 1;
}

if(Spawneo[playerid] == 1 && Desmadre[playerid] == 1){
new r = random(sizeof(DESMADRER));
ResetPlayerWeapons(playerid);GivePlayerWeapon(playerid, 24, 9999);GivePlayerWeapon(playerid, 25, 9999);GivePlayerWeapon(playerid, 34, 9999);SetPlayerPos(playerid, DESMADRER[r][0], DESMADRER[r][1], DESMADRER[r][2]);
SetPlayerFacingAngle(playerid,random(9000));SetPlayerVirtualWorld(playerid, 3);SetPlayerInterior(playerid, 1);SetPlayerHealth(playerid, 100);
return SetPlayerArmour(playerid, 0);}
if(Spawneo[playerid] == 1 && Minigun[playerid] == 1){
new r = random(sizeof(MINIGUN));
ResetPlayerWeapons(playerid);GivePlayerWeapon(playerid, 38, 9999);SetPlayerPos(playerid, MINIGUN[r][0], MINIGUN[r][1], MINIGUN[r][2]);
SetPlayerFacingAngle(playerid,random(9000));SetPlayerVirtualWorld(playerid, 12);SetPlayerInterior(playerid, 10);SetPlayerHealth(playerid, 100);
return SetPlayerArmour(playerid, 0);}
GivePlayerWeapon(playerid,24,300);GivePlayerWeapon(playerid,25,300);GivePlayerWeapon(playerid,28,300);GivePlayerWeapon(playerid,30,300);SetPlayerInterior(playerid,0);SetPlayerVirtualWorld(playerid,0);
if(Spawneo[playerid] == 1 && Desmadre[playerid] == 0 && Minijuego[playerid] == 0 && Usuario[playerid][Modo] == 1)
{
new casos = random(6);
switch(casos)
{
case 0:{SetPlayerPos(playerid,2507.9573,-1924.9025,13.5469);SetPlayerFacingAngle(playerid,186.8500);}//LS
case 1:{SetPlayerPos(playerid,2291.7930,-1083.0052,47.6686);SetPlayerFacingAngle(playerid,342.0150);}//LS
case 2:{SetPlayerPos(playerid,2295.9983,626.5709,10.8203);SetPlayerFacingAngle(playerid,37.0000);}//LV
case 3:{SetPlayerPos(playerid,2917.5547,2455.0981,11.0703);SetPlayerFacingAngle(playerid,177.0504);}//LV
case 4:{SetPlayerPos(playerid,-2077.0234,1430.8273,7.1016);SetPlayerFacingAngle(playerid,358.0000);}//SF
case 5:{SetPlayerPos(playerid,-2903.3372,-171.4756,3.5388);SetPlayerFacingAngle(playerid,84.0000);}//SF
}
}
return 1;}


stock GuardarPropiedades()
{
	for(new id; id < PropiedadesC; id++)
	{
	new gfile[100];
	format(gfile, sizeof(gfile), DIRECCION,id);
	if(dini_Exists(gfile))
	{
	dini_Set(gfile, "Propiedad", PropInfo[id][PropName]);
    dini_Set(gfile, "Propietario", PropInfo[id][PropOwner]);
	dini_FloatSet(gfile, "PosX", PropInfo[id][PropX]);
	dini_FloatSet(gfile, "PosY", PropInfo[id][PropY]);
	dini_FloatSet(gfile, "PosZ", PropInfo[id][PropZ]);
	dini_IntSet(gfile, "PropValor", PropInfo[id][PropValue]);
	dini_IntSet(gfile, "PropGastos", PropInfo[id][PropEarning]);
	dini_IntSet(gfile, "PropVenta", PropInfo[id][PropIsBought]);
	dini_IntSet(gfile, "PropO", PropInfo[id][PropO]);
	dini_IntSet(gfile, "PropMundo", PropInfo[id][PropM]);
	dini_FloatSet(gfile, "PosEX",PropInfo[id][PropEX]);
	dini_FloatSet(gfile, "PosEY",PropInfo[id][PropEY]);
	dini_FloatSet(gfile, "PosEZ",PropInfo[id][PropEZ]);
	dini_IntSet(gfile, "Interior",PropInfo[id][PropI]);
  	}
  	}
 	printf("Se guardaron %d propiedades!", PropiedadesC);
}

stock ContarPropiedades()
{
	PropiedadesC = 0;
    for(new i;i < 100;i++)
    {new archivos[56];format(archivos,sizeof(archivos),"Propiedades/%d.ini",i);
	if(dini_Exists(archivos)){PropiedadesC++;}}
	return 1;
}

stock CargarZonas()
{
	ContarZonas();
	for(new i = 0;i<Zonas;i++)
	{
	new file[25];
	format(file,sizeof(file),"Zonas/%d.ini",i);
	ZonaInfo[i][ZPosX] = dini_Float(file,"PosX");
	ZonaInfo[i][ZPosY] = dini_Float(file,"PosY");
	ZonaInfo[i][Pos2X] = dini_Float(file,"Pos2X");
	ZonaInfo[i][Pos2Y] = dini_Float(file,"Pos2Y");
	ZonaInfo[i][Zconquistada] = dini_Int(file,"Conquistado");
	format(ZonaInfo[i][Zcolor],20,"%s",dini_Get(file,"Color"));
	format(ZonaInfo[i][Znombre],8,"%s",dini_Get(file,"Znombre"));
	ZonaInfo[i][Zcreada] = GangZoneCreate(ZonaInfo[i][ZPosX],ZonaInfo[i][ZPosY],ZonaInfo[i][Pos2X],ZonaInfo[i][Pos2Y]);
	}
	print("========================");
	printf("Se crearon %d zonas!",Zonas);
	print("========================");
}

stock ContarZonas()
{
	Zonas = 1;
    for(new i;i < 100;i++)
    {new archivos[56];format(archivos,sizeof(archivos),"Zonas/%d.ini",i);
	if(dini_Exists(archivos)){Zonas++;}}
	return 1;
}


stock GuardarZonas()
{
    for(new i;i<Zonas;i++)
	{
	new file[25];
	format(file,sizeof(file),ZONE_FILE,i);
	if(dini_Exists(file))
	{
	dini_IntSet(file,"Conquistado",ZonaInfo[i][Zconquistada]);
	dini_Set(file,"Znombre",ZonaInfo[i][Znombre]);
	}
	}
	printf("Se guardaron %d zonas de clanes!",Zonas);
	Zonas = 0;
}


forward IsPlayerNearProperty(playerid);
public IsPlayerNearProperty(playerid)
{
	for(new prop; prop<PropiedadesC+1; prop++)
	{
	new Float:Distance;
    Distance = GetDistanceToProperty(playerid, prop);
    if(Distance < 2.0)
    {
    return prop;
	}
	}
	return -1;
}

public OnPlayerExitVehicle(playerid,vehicleid)
{
	if(ECarrera[playerid] == 1)
	{
	SetPlayerPos(playerid,0,0,0);SpawnPlayer(playerid);posiciones--;SCM(playerid,green,"[INFO]: {FFFFFF}Saliste de la carrera correctamente!");ECarrera[playerid] = 0;CPP[playerid] = 0;DestroyVehicle(TieneAuto[playerid]);
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(GetPVarInt(playerid, "camara") == 0)
	{
	InterpolateCameraPos(playerid,-2076.4629, 350.8492, 94.7493,-2073.8516, 467.4952, 40.9395, 6500);
	InterpolateCameraLookAt(playerid, -2076.4624, 351.8487, 94.5343, -2073.8613, 468.4947, 40.8745, 6500);
	SetPVarInt(playerid, "camara", 1);
	}
    SetPlayerInterior(playerid, 0);SetPlayerVirtualWorld(playerid,0);SetPlayerTime(playerid,12,0);SetPlayerPos(playerid,-2073.8005,481.1946,38.9171);SetPlayerFacingAngle(playerid,178.4240);
	new Animaciones=random(11);
	switch(Animaciones)
	{
	case 0:{ApplyAnimation(playerid,"DANCING","bd_clap", 2.0, 1, 1, 0, 0, 0);}
	case 1:{ApplyAnimation(playerid,"DANCING","bd_clap1", 2.0, 1, 1, 0, 0, 0);}
	case 2:{ApplyAnimation(playerid,"DANCING","dance_loop", 2.0, 1, 1, 0, 0, 0);}
	case 3:{ApplyAnimation(playerid,"DANCING","DAN_Down_A", 2.0, 1, 1, 0, 0, 0);}
	case 4:{ApplyAnimation(playerid,"DANCING","DAN_Left_A",2.0,1,1,1,1,1);}
	case 5:{ApplyAnimation(playerid,"DANCING","DAN_Loop_A",2.0,1,1,1,1,1);}
	case 6:{ApplyAnimation(playerid,"DANCING", "DAN_Right_A", 2.0, 1, 0, 0, 0, 0);}
	case 7:{ApplyAnimation(playerid,"DANCING", "DAN_Right_A", 2.0, 1, 0, 0, 0,0);}
	case 8:{ApplyAnimation(playerid,"DANCING", "dnce_M_b", 2.0, 1, 1, 0, 1,500);}
	case 9:{ApplyAnimation(playerid,"DANCING", "dnce_M_c", 2.0, 1, 1, 1, 0, 4000);}
	case 10:{ApplyAnimation(playerid,"DANCING", "dnce_M_e", 2.0, 1, 1, 0, 0, 0);}
	}
	return 1;
}

forward Float:GetDistanceToProperty(playerid, Property);
public Float:GetDistanceToProperty(playerid, Property)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	GetPlayerPos(playerid,x1,y1,z1);x2 = PropInfo[Property][PropX];y2 = PropInfo[Property][PropY];z2 = PropInfo[Property][PropZ];return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

stock GetPlayerID(const Name[])
{
	for(new i; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
 	        if(strcmp(Name, pName(i), true)==0)
	        {
	            return i;
			}
		}
	}
	return -1;
}


stock MapIconStreamer()
{
	for(new i; i<MP; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new Float:SmallestDistance = 99999.9;
	        new CP, Float:OldDistance;
	        for(new propid; propid<PropiedadesC; propid++)
	        {
	            OldDistance = GetDistanceToProperty(i, propid);
	            if(OldDistance < SmallestDistance)
	            {
	                SmallestDistance = OldDistance;
	                CP = propid;
				}
			}
			RemovePlayerMapIcon(i, 31);
			if(PropInfo[CP][PropIsBought] == 1 && PropInfo[CP][PropO] == 0)
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

forward CarreraSA();
public CarreraSA()
{
	if(carreraon == 0)
	{
	new CC[25];
	new carga = random(6);
	switch(carga)
	{
	case 0:{CC = "Turismo";}
	case 1:{CC = "Picada";}
	case 2:{CC = "Drift";}
	case 3:{CC = "NRG";}
	case 4:{CC = "Rally";}
	case 5:{CC = "Euros";}
	}
	new file[40];
	format(file,sizeof(file),"Carreras/%s.ini",CC);
	format(CarreraI[CN],25,"%s",CC);CarreraI[CPS] = dini_Int(file,"CPS");CarreraI[SCX] = dini_Float(file,"SpawnX");CarreraI[SCY] = dini_Float(file,"SpawnY");CarreraI[SCZ] = dini_Float(file,"SpawnZ");
	CarreraI[SCX2] = dini_Float(file,"SpawnX2");CarreraI[SCY2] = dini_Float(file,"SpawnY2");CarreraI[SCZ2] = dini_Float(file,"SpawnZ2");CarreraI[SCX3] = dini_Float(file,"SpawnX3");CarreraI[SCY3] = dini_Float(file,"SpawnY3");CarreraI[SCZ3] = dini_Float(file,"SpawnZ3");CarreraI[SCX4] = dini_Float(file,"SpawnX4");CarreraI[SCY4] = dini_Float(file,"SpawnY4");CarreraI[SCZ4] = dini_Float(file,"SpawnZ4");
	CarreraI[SCX5] = dini_Float(file,"SpawnX5");CarreraI[SCY5] = dini_Float(file,"SpawnY5");CarreraI[SCZ5] = dini_Float(file,"SpawnZ5");CarreraI[SCX6] = dini_Float(file,"SpawnX6");CarreraI[SCY6] = dini_Float(file,"SpawnY6");CarreraI[SCZ6] = dini_Float(file,"SpawnZ6");CarreraI[SCX7] = dini_Float(file,"SpawnX7");CarreraI[SCY7] = dini_Float(file,"SpawnY7");CarreraI[SCZ7] = dini_Float(file,"SpawnZ7");
	CarreraI[SCX8] = dini_Float(file,"SpawnX8");CarreraI[SCY8] = dini_Float(file,"SpawnY8");CarreraI[SCZ8] = dini_Float(file,"SpawnZ8");CarreraI[SCX9] = dini_Float(file,"SpawnX9");CarreraI[SCY9] = dini_Float(file,"SpawnY9");CarreraI[SCZ9] = dini_Float(file,"SpawnZ9");CarreraI[CP1X] = dini_Float(file,"CP1X");CarreraI[CP1Y] = dini_Float(file,"CP1Y");CarreraI[CP1Z] = dini_Float(file,"CP1Z");
	CarreraI[CP2X] = dini_Float(file,"CP2X");CarreraI[CP2Y] = dini_Float(file,"CP2Y");CarreraI[CP2Z] = dini_Float(file,"CP2Z");CarreraI[CP3X] = dini_Float(file,"CP3X");CarreraI[CP3Y] = dini_Float(file,"CP3Y");CarreraI[CP3Z] = dini_Float(file,"CP3Z");CarreraI[CP4X] = dini_Float(file,"CP4X");CarreraI[CP4Y] = dini_Float(file,"CP4Y");CarreraI[CP4Z] = dini_Float(file,"CP4Z");
	CarreraI[CP5X] = dini_Float(file,"CP5X");CarreraI[CP5Y] = dini_Float(file,"CP5Y");CarreraI[CP5Z] = dini_Float(file,"CP5Z");CarreraI[CP6X] = dini_Float(file,"CP6X");CarreraI[CP6Y] = dini_Float(file,"CP6Y");CarreraI[CP6Z] = dini_Float(file,"CP6Z");CarreraI[CP7X] = dini_Float(file,"CP7X");CarreraI[CP7Y] = dini_Float(file,"CP7Y");CarreraI[CP7Z] = dini_Float(file,"CP7Z");
	CarreraI[CP8X] = dini_Float(file,"CP8X");CarreraI[CP8Y] = dini_Float(file,"CP8Y");CarreraI[CP8Z] = dini_Float(file,"CP8Z");CarreraI[CP9X] = dini_Float(file,"CP9X");CarreraI[CP9Y] = dini_Float(file,"CP9Y");CarreraI[CP9Z] = dini_Float(file,"CP9Z");CarreraI[CP10X] = dini_Float(file,"CP10X");CarreraI[CP10Y] = dini_Float(file,"CP10Y");CarreraI[CP10Z] = dini_Float(file,"CP10Z");
	CarreraI[CP11X] = dini_Float(file,"CP11X");CarreraI[CP11Y] = dini_Float(file,"CP11Y");CarreraI[CP11Z] = dini_Float(file,"CP11Z");CarreraI[CP12X] = dini_Float(file,"CP12X");CarreraI[CP12Y] = dini_Float(file,"CP12Y");CarreraI[CP12Z] = dini_Float(file,"CP12Z");CarreraI[CP13X] = dini_Float(file,"CP13X");CarreraI[CP13Y] = dini_Float(file,"CP13Y");CarreraI[CP13Z] = dini_Float(file,"CP13Z");
	CarreraI[CP14X] = dini_Float(file,"CP14X");CarreraI[CP14Y] = dini_Float(file,"CP14Y");CarreraI[CP14Z] = dini_Float(file,"CP14Z");CarreraI[CP15X] = dini_Float(file,"CP15X");
	CarreraI[CP15Y] = dini_Float(file,"CP15Y");CarreraI[CP15Z] = dini_Float(file,"CP15Z");CarreraI[CA] = dini_Int(file,"Auto");CarreraI[CpFinX] = dini_Float(file,"CpFinX");CarreraI[CpFinY] = dini_Float(file,"CpFinY");CarreraI[CpFinZ] = dini_Float(file,"CpFinZ");
	new string[120];
	format(string,sizeof(string),"[CARRERA]: {FFFFFF}La carrera {0000FF}%s{FFFFFF} está por comenzar [30 SEGUNDOS]. {FF0000}[/unirme]",CC);
	SendClientMessageToAll(green,string);
	CarreraT = SetTimer("CierraR",30000,false);
	carreraon = 1;
	Llegadas = 0;
	carrerae = 0;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	{
	if(Usuario[i][Modo] == 3 && Spawneo[i] == 1)
	{
	posiciones++;
	SetPlayerVirtualWorld(i,15);
	SetPlayerInterior(i,0);
	switch(posiciones)
	{
	case 1:{SetPlayerPos(i,CarreraI[SCX],CarreraI[SCY],CarreraI[SCZ]);}
	case 2:{SetPlayerPos(i,CarreraI[SCX2],CarreraI[SCY2],CarreraI[SCZ2]);}
	case 3:{SetPlayerPos(i,CarreraI[SCX3],CarreraI[SCY3],CarreraI[SCZ3]);}
	case 4:{SetPlayerPos(i,CarreraI[SCX4],CarreraI[SCY4],CarreraI[SCZ4]);}
	case 5:{SetPlayerPos(i,CarreraI[SCX5],CarreraI[SCY5],CarreraI[SCZ5]);}
	case 6:{SetPlayerPos(i,CarreraI[SCX6],CarreraI[SCY6],CarreraI[SCZ6]);}
	case 7:{SetPlayerPos(i,CarreraI[SCX7],CarreraI[SCY7],CarreraI[SCZ7]);}
	case 8:{SetPlayerPos(i,CarreraI[SCX8],CarreraI[SCY8],CarreraI[SCZ8]);}
	case 9:{SetPlayerPos(i,CarreraI[SCX9],CarreraI[SCY9],CarreraI[SCZ9]);}
	case 10..99:{SCM(i,red,"[ERROR]: {FFFFFF}La carrera está llena!");SpawnPlayer(i);SetPlayerVirtualWorld(i,0);return 1;}
	}
	ECarrera[i] = 1;
	SetPlayerFacingAngle(i,90);
	TogglePlayerControllable(i,false);
	if(TieneAuto[i] > 0){DestroyVehicle(TieneAuto[i]);}
	SCM(i,green,"[MODOS]: {FFFFFF}Fuiste metido automáticamente a la carrera por tener tu MODO en carrera.");
	}
	}
	}
	return 1;
}

forward Cuenta(playerid,id,id2);
public Cuenta(playerid,id,id2)
{
if(IsPlayerConnected(id) && IsPlayerConnected(id2))
{
if(PlayerGang[id] != PlayerGang[playerid] || PlayerGang[id2] != PlayerGang[playerid] || PlayerGang[id] != PlayerGang[id2] || PlayerGang[id2] != PlayerGang[id]) return SCM(playerid,red,"[ERROR]: {FFFFFF}Una de las ID's ingresadas no son del mismo clan.");
for(new i;i<Zonas;i++)
{
if(IsPlayerInArea(playerid,ZonaInfo[i][ZPosX],ZonaInfo[i][ZPosY],ZonaInfo[i][Pos2X],ZonaInfo[i][Pos2Y]) && IsPlayerInArea(id,ZonaInfo[i][ZPosX],ZonaInfo[i][ZPosY],ZonaInfo[i][Pos2X],ZonaInfo[i][Pos2Y]) && IsPlayerInArea(id2,ZonaInfo[i][ZPosX],ZonaInfo[i][ZPosY],ZonaInfo[i][Pos2X],ZonaInfo[i][Pos2Y]))
{
tiempo++;
}
else
{
SendClientMessage(id,green,"[ZONA]: {FFFFFF}Uno de los miembros salió de la zona.");
SendClientMessage(id2,green,"[ZONA]: {FFFFFF}Uno de los miembros salió de la zona.");
SendClientMessage(playerid,green,"[ZONA]: {FFFFFF}Uno de los miembros salió de la zona.");
tiempo = 0;
KillTimer(Capturando);
}
}
}
if(tiempo == 30)
{
for(new i;i<Zonas;i++)
{
ZonaInfo[i][Zconquistada] = 1;
format(ZonaInfo[i][Znombre],8,"%s",GangInfo[PlayerGang[playerid]][GANG_NAME]);
}
SendClientMessage(id,green,"[ZONA]: {FFFFFF}Conquistaste correctamente la zona! Felicidades, +5 de score clan.");
SendClientMessage(id2,green,"[ZONA]: {FFFFFF}Conquistaste correctamente la zona! Felicidades, +5 de score clan.");
SendClientMessage(playerid,green,"[ZONA]: {FFFFFF}Conquistaste correctamente la zona! Felicidades, +5 de score clan.");
GangInfo[PlayerGang[playerid]][GANG_SCORE] += 5;
tiempo = 0;
KillTimer(Capturando);
}
return tiempo;
}

stock IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY)
	{
	return 1;
	}
	return -1;
}


forward CobraCosto();
public CobraCosto()
{
	new string[70];
	for(new i, g = GetMaxPlayers(); i < g; i++)
	{
	for(new propid; propid < PropiedadesC; propid++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PlayerProps[i] > 0 && PropInfo[propid][PropO] == 1)
	        {
	            SendClientMessage(i,-1,"-------------------------------PAGOS-------------------------------------");
				format(string, sizeof(string), "Ganancias: {00FF00}+$%d{FFFFFF}. (Por restaurantes & otros)", GananciaJugador[i]);
				SendClientMessage(i, 0xFFFFFFFF, string);
				SendClientMessage(i,-1,"-------------------------------------------------------------------------");
				DarDinero(i, GananciaJugador[i]);
			}
		}
	}
}
}

forward CarSpawner1(playerid,model);
public CarSpawner1(playerid,model)
{
	if(IsPlayerInAnyVehicle(playerid))
	{SendClientMessage(playerid, -1, "[ERROR]: {FFFFFF}Ya tienes un vehículo!");return 1;}
	else{
   	if(TieneAuto[playerid] > 0){DestroyVehicle(TieneAuto[playerid]);TieneAuto[playerid] = 0;}
    new Float:x, Float:y, Float:z, Float:angle;
	GetPlayerPos(playerid, x, y, z);GetPlayerFacingAngle(playerid, angle);new vehicleid=CreateVehicle(model, x, y, z, angle, -1, -1, -1);
	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));TieneAuto[playerid] = vehicleid;PutPlayerInVehicle(playerid, vehicleid, 0);ChangeVehicleColor(vehicleid,0,7);}
	return 1;
}

stock Loguear(playerid)
{
    new Version[56], string[356], string2[120], string3[120];
	GetPlayerVersion(playerid,Version,56);format(string,sizeof(string),"Bienvenido a {B9C9BF}.:|Revolución Latina FR(0.3.7) [Español]|:.{FFFFFF}. Su versión de SA-MP es  {B9C9BF}%s{FFFFFF}.",Version);SendClientMessage(playerid,-1,string);SendClientMessage(playerid,blue,".:|RL|:.{FFFFFF} Usa {00FF00}/ayuda {FFFFFF}-{00FF00} /admins{FFFFFF}-{00FF00} /teles{FFFFFF}-{00FF00} /juegos{FFFFFF}.");
	SendClientMessage(playerid,blue,".:|RL|:.{FFFFFF} Recuerda que el servidor está realizado desde {00FF00}0 {FFFFFF}. Cualquier error avisarlo inmediatamente.");SendClientMessage(playerid,blue,".:|RL|:.{FFFFFF} Si tienes dudas o problemas no debes dudar en contactar al {00FF00}STAFF{FFFFFF} del servidor.");format(string2,sizeof(string2),"{FFFFFF}Bienvenido {00FF00}%s{FFFFFF}.\nEsta cuenta no se encuentra registrada, ingresa una contraseña para comenzar.",pName(playerid));
	format(string3,sizeof(string3),"{FFFFFF}Bienvenido {00FF00}%s{FFFFFF}.\nEsta cuenta se encuentra registrada, ingresa una contraseña para comenzar.",pName(playerid));
	Spawneo[playerid] = 0;
	if(!udb_Exists(pName(playerid))){ShowPlayerDialog(playerid,REGISTRO,DIALOG_STYLE_INPUT,"|| Registro ||",string2,"Registrar","Cancelar");
	} else	ShowPlayerDialog(playerid,LOGUEO,DIALOG_STYLE_PASSWORD,"|| Logueo ||",string3,"Loguear","Cancelar");
	return 1;
}

stock pName(playerid)
{
	new Nombre[MAX_PLAYER_NAME];
	GetPlayerName(playerid,Nombre,sizeof(Nombre));
	return Nombre;
}

forward Kickear(playerid);
public Kickear(playerid)
{
	SendClientMessage(playerid,-1,"{D8CEF6}El servidor cerró la conexión.");
	Kick(playerid);
	return 1;
}

forward KickA(id,razon[]);
public KickA(id,razon[])
{
	new text[100];
	format(text,sizeof(text),"[ANTICHEAT]: {FFFFFF}%s fue kickeado automáticamente. [Razón: %s]",pName(id),razon);
	SendClientMessageToAll(red,text);
	Kick(id);
	return 1;
}

forward BanA(id,razon[]);
public BanA(id,razon[])
{
	new text[100];
	format(text,sizeof(text),"[ANTICHEAT]: {FFFFFF}%s fue baneado automáticamente. [Razón: %s]",pName(id),razon);
	SendClientMessageToAll(red,text);
	Ban(id);
	return 1;
}

forward Banear(playerid);
public Banear(playerid)
{
SendClientMessage(playerid,-1,"{D8CEF6}El servidor cerró la conexión.");
new pos, oldpos,tmp[128], ip[15], ip2[15];
GetPlayerIp(playerid, ip, sizeof(ip));pos = strfind(ip, ".", true);pos++;
for(new i = 0; i < pos; i++)
{
ip2[i] = ip[pos-pos+i];
}
pos--;
ip[pos] = ' ';
oldpos = pos;
oldpos++;
pos = strfind(ip, ".", true);
pos++;
for(new i = oldpos; i < pos; i++)
{ip2[i] = ip[pos-pos+i];}
format(ip2, sizeof(ip2), "%s*.*", ip2);format(tmp, sizeof(tmp), "banip %s", ip2);SendRconCommand(tmp);
return 1;
}


stock LimpiarConsola(playerid)
{
	for(new i;i<100;i++) SendClientMessage(playerid,-1,"");
	return 1;
}

stock CargarUsuario(playerid)
{
	new file[50];
	format(file,sizeof(file),"/Usuarios/%s.ini",pName(playerid));
    Usuario[playerid][Dinero] = dUserINT(pName(playerid)).("Dinero");
    Usuario[playerid][Correo] = dUserINT(pName(playerid)).("Correo");
	Usuario[playerid][pVip] = dUserINT(pName(playerid)).("VIP");
    Usuario[playerid][pAdmin] = dUserINT(pName(playerid)).("AdminNivel");
    Usuario[playerid][Nivel] = dUserINT(pName(playerid)).("Nivel");
    Usuario[playerid][Ano] = dUserINT(pName(playerid)).("Ano");
    Usuario[playerid][Mes] = dUserINT(pName(playerid)).("Mes");
    Usuario[playerid][Dia] = dUserINT(pName(playerid)).("Dia");
    Usuario[playerid][Kicks] = dUserINT(pName(playerid)).("Kicks");
    Usuario[playerid][Bann] = dUserINT(pName(playerid)).("Baneo");
    Usuario[playerid][Advs] = dUserINT(pName(playerid)).("Advs");
    Usuario[playerid][Cargos] = dUserINT(pName(playerid)).("Cargos");
    Usuario[playerid][Muertes] = dUserINT(pName(playerid)).("Muertes");
    Usuario[playerid][Asesinatos] = dUserINT(pName(playerid)).("Asesinatos");
    format(Usuario[playerid][Registro], 64, "%s", dini_Get(file, "Registro"));
    format(Usuario[playerid][Fbaneo], 64, "%s", dini_Get(file, "Fbaneo"));
    format(Usuario[playerid][Razon], 64, "%s", dini_Get(file, "Razon"));
    PlayerGang[playerid] = dUserINT(pName(playerid)).("clan");
	PlayerLider[playerid] = dUserINT(pName(playerid)).("lider");
	Usuario[playerid][Eslider] = dUserINT(pName(playerid)).("Lider2");
	SetPlayerScore(playerid,Usuario[playerid][Asesinatos]);ResetPlayerMoney(playerid);GivePlayerMoney(playerid,Usuario[playerid][Dinero]);
    MostrarTexts(playerid);TextDrawHideForPlayer(playerid,Textdraw[6]);TextDrawHideForPlayer(playerid,Textdraw[7]);TextDrawHideForPlayer(playerid,Textdraw[8]);
	if(Usuario[playerid][Bann] == 1)
	{
	LimpiarConsola(playerid);new stringa[87], stringa2[84],stringa3[80];format(stringa,sizeof(stringa),"Nombre baneado: {00FF00}%s",pName(playerid));format(stringa2,sizeof(stringa2),"Fecha: {00FF00}%s",Usuario[playerid][Fbaneo]);
	format(stringa3,sizeof(stringa3),"Razón: {FF0000}%s",Usuario[playerid][Razon]);SendClientMessage(playerid,red,"+====================BANEO========================+");SendClientMessage(playerid,-1,stringa);SendClientMessage(playerid,-1,stringa2);SendClientMessage(playerid,-1,stringa3);SendClientMessage(playerid,-1,"En caso de errores avisar a los administradores por facebook.");SendClientMessage(playerid,red,"+====================ADIÓS========================+");
	SetTimerEx("Kickear",500,false,"d",playerid);
	return 1;
	}
	new string[95], string1[80];
	format(string,sizeof(string),"Bienvenido de nuevo {00FF00}%s{FFFFFF}. Introduciste tu contraseña correctamente.",pName(playerid));
	format(string1,sizeof(string1),"Última vez que entraste al servidor: {00FF00}%d/%d/%d{FFFFFF}.",Usuario[playerid][Dia],Usuario[playerid][Mes],Usuario[playerid][Ano]);
	LimpiarConsola(playerid);
	SendClientMessage(playerid,-1,"+===============================================================+");SendClientMessage(playerid,-1,string);SendClientMessage(playerid,-1,string1);SendClientMessage(playerid,-1,"+===============================================================+");
	if(PlayerProps[playerid] > 0){ new str[128];format(str, 128, "{FFFFFF}Tú tienes actualmente {0000FF}%d{FFFFFF} propiedades en tu nombre.", PlayerProps[playerid]);SendClientMessage(playerid, 0x99FF66AA, str);}
    new file1[50];
    format(file1,sizeof(file1),"Player Objects/%s.ini",pName(playerid));
    if(!dini_Exists(file1)) return 1;
    for(new x;x<MAX_OSLOTS;x++)
    {
    format(f1,15,"O_Model_%d",x);format(f2,15,"O_Bone_%d",x);format(f3,15,"O_OffX_%d",x);format(f4,15,"O_OffY_%d",x);format(f5,15,"O_OffZ_%d",x);format(f6,15,"O_RotX_%d",x);format(f7,15,"O_RotY_%d",x);format(f8,15,"O_RotZ_%d",x);format(f9,15,"O_ScaleX_%d",x);format(f10,15,"O_ScaleY_%d",x);format(f11,15,"O_ScaleZ_%d",x);
	}
     return 1;
}

stock MostrarTexts(playerid)
{
//31 - FREEROAM | 32 - DM | 33 - Carreras
	new string[25],string2[25],string3[25];
	new enfr,endm,encc;
	for(new i,g = GetMaxPlayers();i<g;i++)
	{
	switch(Usuario[i][Modo])
	{
	case 1: enfr++;
	case 2: endm++;
	case 3: encc++;
	}
	}
	format(string,sizeof(string),"Jugadores: %d",enfr);
	format(string2,sizeof(string2),"Jugadores: %d",endm);
	format(string3,sizeof(string3),"Jugadores: %d",encc);
	TextDrawSetString(Textdraw[31],string);TextDrawSetString(Textdraw[32],string2);TextDrawSetString(Textdraw[33],string3);
    SelectTextDraw(playerid,red);
	TextDrawShowForPlayer(playerid,Textdraw[12]);TextDrawShowForPlayer(playerid,Textdraw[13]);TextDrawShowForPlayer(playerid,Textdraw[14]);TextDrawShowForPlayer(playerid,Textdraw[15]);TextDrawShowForPlayer(playerid,Textdraw[16]);TextDrawShowForPlayer(playerid,Textdraw[17]);TextDrawShowForPlayer(playerid,Textdraw[18]);TextDrawShowForPlayer(playerid,Textdraw[19]);TextDrawShowForPlayer(playerid,Textdraw[20]);TextDrawShowForPlayer(playerid,Textdraw[21]);TextDrawShowForPlayer(playerid,Textdraw[22]);
	TextDrawShowForPlayer(playerid,Textdraw[23]);TextDrawShowForPlayer(playerid,Textdraw[24]);TextDrawShowForPlayer(playerid,Textdraw[25]);TextDrawShowForPlayer(playerid,Textdraw[26]);TextDrawShowForPlayer(playerid,Textdraw[27]);TextDrawShowForPlayer(playerid,Textdraw[28]);TextDrawShowForPlayer(playerid,Textdraw[29]);TextDrawShowForPlayer(playerid,Textdraw[30]);TextDrawShowForPlayer(playerid,Textdraw[31]);TextDrawShowForPlayer(playerid,Textdraw[32]);TextDrawShowForPlayer(playerid,Textdraw[33]);
}

stock OcultarTexts(playerid)
{
    CancelSelectTextDraw(playerid);
    TextDrawHideForPlayer(playerid,Textdraw[12]);TextDrawHideForPlayer(playerid,Textdraw[13]);TextDrawHideForPlayer(playerid,Textdraw[14]);TextDrawHideForPlayer(playerid,Textdraw[15]);TextDrawHideForPlayer(playerid,Textdraw[16]);TextDrawHideForPlayer(playerid,Textdraw[17]);TextDrawHideForPlayer(playerid,Textdraw[18]);TextDrawHideForPlayer(playerid,Textdraw[19]);TextDrawHideForPlayer(playerid,Textdraw[20]);TextDrawHideForPlayer(playerid,Textdraw[21]);TextDrawHideForPlayer(playerid,Textdraw[22]);
	TextDrawHideForPlayer(playerid,Textdraw[23]);TextDrawHideForPlayer(playerid,Textdraw[24]);TextDrawHideForPlayer(playerid,Textdraw[25]);TextDrawHideForPlayer(playerid,Textdraw[26]);TextDrawHideForPlayer(playerid,Textdraw[27]);TextDrawHideForPlayer(playerid,Textdraw[28]);TextDrawHideForPlayer(playerid,Textdraw[29]);TextDrawHideForPlayer(playerid,Textdraw[30]);TextDrawHideForPlayer(playerid,Textdraw[31]);TextDrawHideForPlayer(playerid,Textdraw[32]);TextDrawHideForPlayer(playerid,Textdraw[33]);
}


public OnPlayerClickTextDraw(playerid,Text:clickedid)
{
	if(clickedid == Textdraw[24])//carrera
	{
	Usuario[playerid][Modo] = 3;
	SCM(playerid,green,"[MODO]: {FFFFFF}Seleccionaste el modo de carrera! Elige un skin y espera a que se active la carrera.");
	OcultarTexts(playerid);
	CancelSelectTextDraw(playerid);
	}
	if(clickedid == Textdraw[25])//Freeroam
	{
	Usuario[playerid][Modo] = 1;
	SCM(playerid,green,"[MODO]: {FFFFFF}Seleccionaste el modo de Freeroam! Para cambiar de modo usa /modos.");
	OcultarTexts(playerid);
	CancelSelectTextDraw(playerid);
	}
	if(clickedid == Textdraw[26])//DM
	{
	Usuario[playerid][Modo] = 2;
	SCM(playerid,green,"[MODO]: {FFFFFF}Seleccionaste el modo de DeathMatch! Para cambiar de modo usa /modos.");
	OcultarTexts(playerid);
	CancelSelectTextDraw(playerid);
 	new string4[150];
	format(string4,sizeof(string4),"{FFFFFF}Desmadre {00FF00}[Jugadores: %d]\n{FFFFFF}Swat vs Terroristas [DK|M4|MP5|EDC]\nZona abandonada [MicroUzi|ShawOff]\nMinigun\nGuerra Total",endesmadre);
    ShowPlayerDialog(playerid,277,DIALOG_STYLE_LIST,"|| DeathMatch ||",string4,"Aceptar","");
	}
	return 1;
}


stock CMDMessageToAdmins(playerid,command[])
{
	new TxAdm[30],string[115];
	switch(Usuario[playerid][pAdmin])
	{
	case 0: TxAdm = "Normal";
	case 1: TxAdm = "Ayudante";
	case 2: TxAdm = "Moderador a Prueba";
	case 3: TxAdm = "Moderador";
	case 4: TxAdm = "Moderador Global";
	case 5: TxAdm = "Administrador a Prueba";
	case 6: TxAdm = "Co-administrador";
	case 7: TxAdm = "Administrador";
	case 8: TxAdm = "Administrador Global";
	case 9: TxAdm = "Encargado";
	case 10: TxAdm = "Dueño";
	}
	format(string,sizeof(string),"[COMANDOS]: {FFFFFF}El %s %s [%d] uso el comando {00FF00}%s",TxAdm,pName(playerid),playerid,command);
	return MessageToAdmins(yellow,string);
}

forward MessageToAdmins(color,const string[]);
public MessageToAdmins(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) == 1) if (Usuario[i][pAdmin] >= 1) SendClientMessage(i, color, string);
	}
	return 1;
}

forward MessageToAdminsA(color,const string[]);
public MessageToAdminsA(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) == 1) if (Usuario[i][pAdmin] >= 8) SendClientMessage(i, color, string);
	}
	return 1;
}

forward MessageToDuenos(color,const string[]);
public MessageToDuenos(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) == 1) if (Usuario[i][pAdmin] == 10) SendClientMessage(i, color, string);
	}
	return 1;
}

forward MessageToVips(color,const string[]);
public MessageToVips(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) == 1) if(Usuario[i][pVip] >=1) SendClientMessage(i, color, string);
	}
	return 1;
}

public Cambia(text[])
{
TextDrawHideForAll(Textdraw[0]);
TextDrawSetString(Textdraw[0],text);
TextDrawShowForAll(Textdraw[0]);
return 1;
}

public ChangeWebsite()
{
if(TextWebsiteCount > websitecount) TextWebsiteCount = 0;
switch(TextWebsiteCount)
{
case 0:{Cambia("~w~R");}
case 1:{Cambia("~w~R~b~e");}
case 2:{Cambia("~w~R~b~e~y~v");}
case 3:{Cambia("~w~R~b~e~y~v~p~o");}
case 4:{Cambia("~w~R~b~e~y~v~p~o~g~l");}
case 5:{Cambia("~w~R~b~e~y~v~p~o~g~l~r~u");}
case 6:{Cambia("~w~R~b~e~y~v~p~o~g~l~r~u~w~c");}
case 7:{Cambia("~w~R~b~e~y~v~p~o~g~l~r~u~w~c~b~i");}
case 8:{Cambia("~w~R~b~e~y~v~p~o~g~l~r~u~w~c~b~i~y~o");}
case 9:{Cambia("~r~R~g~e~p~v~y~o~b~l~y~u~b~c~w~i~g~o~p~n");}
case 10:{Cambia("~b~R~y~e~p~v~g~o~r~l~g~u~b~c~g~i~p~o~r~n");}
case 11:{Cambia("~p~R~w~e~r~v~g~o~y~l~b~u~r~c~w~i~y~o~g~n");}
case 12:{Cambia("~g~R~r~e~g~v~b~o~y~l~p~u~r~c~g~i~y~o~b~n");}
case 13:{Cambia("~w~Revolucion");}
}
TextWebsiteCount++;
}

forward SubeNivel();
public SubeNivel()
{
	for(new i, g = GetMaxPlayers(); i < g; i++)
	{
	Usuario[i][Nivel]++;
	GameTextForPlayer(i,"~n~_~n~~w~Nivel ~g~aumentado~w~. ~b~Felicidades~w~!",5000,3);PlayerPlaySound(i,1139,0.0,0.0,0.0);DarDinero(i,200);
	new extra = random(6);
	switch(extra)
	{
	case 0:{SendClientMessage(i,-1,"No obtuviste ningún extra por tu nivel.");}
	case 1:{Usuario[i][Ammopacks] += 15;SendClientMessage(i,green,"[NIVEL]: {FFFFFF}Obtuviste {00FF00}15{FFFFFF} ammopacks de regalo. ¡Felicidades!");}
	case 2:{DarDinero(i,1000);SendClientMessage(i,green,"[NIVEL]: {FFFFFF}Obtuviste {00FF00}$1000{FFFFFF} de regalo. ¡Felicidades!");}
	case 3:{Usuario[i][Nivel]++;SendClientMessage(i,green,"[NIVEL]: {FFFFFF}Obtuviste {00FF00}1{FFFFFF} nivel extra. ¡Felicidades!");}
	case 4:{DarDinero(i,1500);SendClientMessage(i,green,"[NIVEL]: {FFFFFF}Obtuviste {00FF00}$1500{FFFFFF} de regalo. ¡Felicidades!");}
	case 5:{DarDinero(i,2000);SendClientMessage(i,green,"[NIVEL]: {FFFFFF}Obtuviste {00FF00}$2000{FFFFFF} de regalo. ¡Felicidades!");}}}return 1;}

forward Muteando(player1);
public Muteando(player1)
{
    TiempoMute[player1] = SetTimerEx("MuteRelease",Usuario[player1][Mtiempo],0,"d",player1);Usuario[player1][Muteado] = 1;
	return 1;
}

forward MuteRelease(player1);
public MuteRelease(player1)
{
	KillTimer(TiempoMute[player1]);
	Usuario[player1][Mtiempo] = 0;
	Usuario[player1][Muteado] = 0;
	PlayerPlaySound(player1,1057,0.0,0.0,0.0);
	GameTextForPlayer(player1,"~g~Ya puedes hablar por el chat!",3000,3);
	return 1;
}

stock GuardarUsuario(playerid)
{
	new dia,mes,ano;
	getdate(ano,mes,dia);
	Usuario[playerid][Dia] = dia;
	Usuario[playerid][Mes] = mes;
	Usuario[playerid][Ano] = ano;
    dUserSetINT(pName(playerid)).("Dinero",GetPlayerMoney(playerid));
    dUserSetINT(pName(playerid)).("Asesinatos",Usuario[playerid][Asesinatos]);
    dUserSetINT(pName(playerid)).("Muertes",Usuario[playerid][Muertes]);
    dUserSetINT(pName(playerid)).("Nivel",Usuario[playerid][Nivel]);
    dUserSetINT(pName(playerid)).("VIP",Usuario[playerid][pVip]);
    if(Temporal[playerid] == 0){dUserSetINT(pName(playerid)).("AdminNivel",Usuario[playerid][pAdmin]);}
    dUserSetINT(pName(playerid)).("Ano",Usuario[playerid][Ano]);
    dUserSetINT(pName(playerid)).("Mes",Usuario[playerid][Mes]);
    dUserSetINT(pName(playerid)).("Dia",Usuario[playerid][Dia]);
    dUserSetINT(pName(playerid)).("Baneo",Usuario[playerid][Bann]);
    dUserSetINT(pName(playerid)).("Kicks",Usuario[playerid][Kicks]);
    dUserSetINT(pName(playerid)).("Advs",Usuario[playerid][Advs]);
    dUserSetINT(pName(playerid)).("Cargos",Usuario[playerid][Cargos]);
	dUserSetINT(pName(playerid)).("Puntos",Usuario[playerid][Puntos]);
	dUserSetINT(pName(playerid)).("clan",PlayerGang[playerid]);
	dUserSetINT(pName(playerid)).("lider",PlayerLider[playerid]);
	dUserSetINT(pName(playerid)).("Lider2",Usuario[playerid][Eslider]);
}


stock DetectarSpam(SPAM[])
{
    new SSPAM;
    new CUENTAP,CUENTAN,CUENTAW,CUENTADP,CUENTAGB;
	for(SSPAM = 0; SSPAM < strlen(SPAM); SSPAM ++)
	{
	    if(SPAM[SSPAM] == '.') CUENTAP ++; //Cuenta los Puntos
	    if(SPAM[SSPAM] == '0' || SPAM[SSPAM] == '1' || SPAM[SSPAM] == '2' || SPAM[SSPAM] == '3' || SPAM[SSPAM] == '4' || SPAM[SSPAM] == '5' || SPAM[SSPAM] == '6' || SPAM[SSPAM] == '7' || SPAM[SSPAM] == '8' || SPAM[SSPAM] == '9') CUENTAN ++; //Cuenta los Numeros
	    if(SPAM[SSPAM] == ':') CUENTADP ++; //Cuenta los ":"
	    if(SPAM[SSPAM] == '_') CUENTAGB ++; //Cuenta los "_"
	}
 	if(CUENTAP >= 4 && CUENTAN >= 4) return 1;
 	if(CUENTAW >= 3) return 1;
 	if(CUENTAN >= 8) return 1;
 	if(CUENTAGB >= 2 && CUENTAN >= 3) return 1;
 	if(strfind(SPAM, ".com", true) != -1 || strfind(SPAM, ".com.ar", true) != -1 || strfind(SPAM, ".org", true) != -1 || strfind(SPAM, "www.", true) != -1 || strfind(SPAM, ".net", true) != -1 || strfind(SPAM, ".es", true) != -1 || strfind(SPAM, ".tk", true) != -1) return 1;
 	if(CUENTADP >= 1 && CUENTAN >= 4) return 1;
 	return 0;
}

forward Descongelar(playerid);
public Descongelar(playerid)
{
    TogglePlayerControllable(playerid,true);
	return 1;
}

forward Congelar(playerid);
public Congelar(playerid)
{
    TogglePlayerControllable(playerid,false);
    return 1;
}

forward SaleP(playerid);
public SaleP(playerid)
{
	SendClientMessage(playerid,-1,"Cumpliste la condena, ya eres libre.");Usuario[playerid][Cargos] = 0;SetPlayerWantedLevel(playerid,0);
	Usuario[playerid][Encarcelado] = 0;SetPlayerInterior(playerid,0);SetPlayerVirtualWorld(playerid,0);SetPlayerPos(playerid,1546.0880,-1675.6528,13.5616);
	SetPlayerFacingAngle(playerid,86.0000);dUserSetINT(pName(playerid)).("Cargos",0);
	return 1;
}

forward Jail1(player1);
public Jail1(player1)
{
	TogglePlayerControllable(player1,false);
	new Float:x, Float:y, Float:z;	GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+10,y,z+10);SetPlayerCameraLookAt(player1,x,y,z);
	SetTimerEx("Jail2",1000,0,"d",player1);
}

forward Jail2(player1);
public Jail2(player1)
{
	new Float:x, Float:y, Float:z; GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+7,y,z+5); SetPlayerCameraLookAt(player1,x,y,z);
	if(GetPlayerState(player1) == PLAYER_STATE_ONFOOT) SetPlayerSpecialAction(player1,SPECIAL_ACTION_HANDSUP);
	GameTextForPlayer(player1,"~r~Atrapado",3000,3);
	SetTimerEx("Jail3",1000,0,"d",player1);
}

forward Jail3(player1);
public Jail3(player1)
{
	new Float:x, Float:y, Float:z; GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+3,y,z); SetPlayerCameraLookAt(player1,x,y,z);
}

forward Encarcelar(player1);
public Encarcelar(player1)
{

    SetPlayerVirtualWorld(player1, 16);
	new carcel = random(6);
	switch(carcel)
	{
	case 0:{SetPlayerPos(player1,1769.9115,-1582.1240,1738.7173);}
	case 1:{SetPlayerPos(player1,1778.6125,-1583.1396,1734.9430);}
	case 2:{SetPlayerPos(player1,1774.3070,-1583.1366,1734.9430);}
	case 3:{SetPlayerPos(player1,1778.2595,-1563.2678,1734.9430);}
	case 4:{SetPlayerPos(player1,1769.9763,-1564.4614,1734.9430);}
	case 5:{SetPlayerPos(player1,1761.7946,-1563.5764,1734.9430);}
	}
	ResetPlayerWeapons(player1);SetCameraBehindPlayer(player1);Tcarcel[player1] = SetTimerEx("Encarcelar1",Usuario[player1][Ctiempo],false,"d",player1);
	Usuario[player1][Encarcelado] = 1;SetTimerEx("Descongelar",5000,false,"d",player1);
}

forward Encarcelar1(player1);
public Encarcelar1(player1)
{
	KillTimer(Tcarcel[player1]);Usuario[player1][Ctiempo] = 0;Usuario[player1][Encarcelado] = 0;SetPlayerInterior(player1,0);
	SetPlayerVirtualWorld(player1,0);SetPlayerPos(player1, 0.0, 0.0, 0.0);SpawnPlayer(player1);GameTextForPlayer(player1,"~g~Libre ~n~de la carcel",3000,3);
}


stock StartSpectate(playerid, specplayerid)
{
	for(new x=0; x<MAX_PLAYERS; x++) {
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Usuario[x][SpecID] == playerid) {
	       AdvanceSpectate(x);
		}
	}
	SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
	SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(specplayerid));
	TogglePlayerSpectating(playerid, 1);
	if(IsPlayerInAnyVehicle(specplayerid)) {
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid));
		Usuario[playerid][SpecID] = specplayerid;
		Usuario[playerid][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
	}
	else {
		PlayerSpectatePlayer(playerid, specplayerid);
		Usuario[playerid][SpecID] = specplayerid;
		Usuario[playerid][SpecType] = ADMIN_SPEC_TYPE_PLAYER;
	}
	new Float:hp, Float:ar, string2[300];
	GetPlayerName(specplayerid,string2,sizeof(string2));
	GetPlayerHealth(specplayerid, hp);	GetPlayerArmour(specplayerid, ar);
	if(Usuario[playerid][pAdmin] >= 1) { format(string2,sizeof(string2),"~n~~n~~n~~n~~n~~n~~n~~w~- %s[%d] ~n~~y~Vida: ~w~%0.1f ~l~- ~y~Chaleco: ~w~%0.1f ~l~- ~y~Money: ~w~$%d", string2,specplayerid,hp,ar,GetPlayerMoney(specplayerid) ); }
	GameTextForPlayer(playerid,string2,25000,3);
	return 1;
}

stock StopSpectate(playerid)
{
	TogglePlayerSpectating(playerid, 0);Usuario[playerid][SpecID] = INVALID_PLAYER_ID;Usuario[playerid][SpecType] = ADMIN_SPEC_TYPE_NONE;if(Usuario[playerid][pAdmin] >= 1){GameTextForPlayer(playerid,"~n~~n~~n~~w~MODO SPECTADOR DESACTIVADO",4000,3);}
	return 1;
}

stock AdvanceSpectate(playerid)
{
    if(Usuarios() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Usuario[playerid][SpecID] != INVALID_PLAYER_ID)
	{
	    for(new x=Usuario[playerid][SpecID]+1; x<=MAX_PLAYERS; x++)
		{
	    	if(x == MAX_PLAYERS) x = 0;
	        if(IsPlayerConnected(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Usuario[x][SpecID] != INVALID_PLAYER_ID || (GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{continue;}
				else{
					StartSpectate(playerid, x);
					break;}}}}
	return 1;
}

stock ReverseSpectate(playerid)
{
    if(Usuarios() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Usuario[playerid][SpecID] != INVALID_PLAYER_ID)
	{
	    for(new x=Usuario[playerid][SpecID]-1; x>=0; x--)
		{
	    	if(x == 0) x = MAX_PLAYERS;
	        if(IsPlayerConnected(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Usuario[x][SpecID] != INVALID_PLAYER_ID || (GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}else{StartSpectate(playerid, x);break;
				}}}}
	return 1;
}

forward FPSUP();
public FPSUP()
{
for(new i, g = GetMaxPlayers(); i < g; i++)
{if(IsPlayerConnected(i)){
new stringa[145];
new TC[10];
new TVIP[10];
new TMODO[12];
if(PlayerGang[i] == 0){TC = "N/A";}
if(PlayerGang[i] > 0){format(TC,sizeof(TC),"%s",GangInfo[PlayerGang[i]][GANG_NAME]);}
switch(Usuario[i][pVip]){
case 0: TVIP = "N/A";
case 1: TVIP = "Bronce";
case 2: TVIP = "Plata";
case 3: TVIP = "Oro";
case 4: TVIP = "Elite";
case 5: TVIP = "Dios";
case 6: TVIP = "Supremo";}
switch(Usuario[i][Modo]){
case 0: TMODO = "N/A";
case 1: TMODO = "Freeroam";
case 2: TMODO = "DM";
case 3: TMODO = "Carreras";}
format(stringa,sizeof(stringa),"~>~~b~Stats~w~~<~ ~r~Score~w~: %d ~y~Dinero~w~: $%d ~g~Clan~w~: %s ~p~Nivel~w~: %d ~b~VIP~w~: %s ~r~Modo~w~: %s",GetPlayerScore(i),GetPlayerMoney(i),TC,Usuario[i][Nivel],TVIP,TMODO);TextDrawSetString(Stats[i],stringa);
new string[95];
format(string,sizeof(string),"~r~FPS~w~: %d - ~b~Ping~w~: %d",FPS2[i],GetPlayerPing(i));TextDrawSetString(FPSP[i],string);}continue;
}}

stock GetPlayerNivel(playerid)
{
	return Usuario[playerid][Nivel];
}

stock IsNumeric(const string[])
{
for (new i = 0, j = strlen(string); i < j; i++)
{
if (string[i] > '9' || string[i] < '0') return 0;
}
return 1;
}

forward c4();
public c4()
{
	GameTextForAll("~b~4",1000,3);
	SetTimer("c3",1000,false);
	PlayerPlaySoundForAll(1056, 0.0, 0.0, 0.0);
	return 1;
}

forward c3();
public c3()
{
    GameTextForAll("~g~3",1000,3);
	SetTimer("c2",1000,false);
	PlayerPlaySoundForAll(1056, 0.0, 0.0, 0.0);
	return 1;
}

forward c2();
public c2()
{
    GameTextForAll("~p~2",1000,3);
	SetTimer("c1",1000,false);
	PlayerPlaySoundForAll(1056, 0.0, 0.0, 0.0);
	return 1;
}

forward c1();
public c1()
{
    GameTextForAll("~y~1",1000,3);
	SetTimer("c0",1000,false);
	PlayerPlaySoundForAll(1056, 0.0, 0.0, 0.0);
	return 1;
}

forward c0();
public c0()
{
    GameTextForAll("~r~Y~b~A~g~!",1000,3);
    conteo1 = 0;
    PlayerPlaySoundForAll(1057, 0.0, 0.0, 0.0);
	return 1;
}


forward cc4(i);
public cc4(i)
{
	if(ECarrera[i] == 1){
	GameTextForPlayer(i,"~b~4",1000,3);
	SetTimerEx("cc3",1000,false,"d",i);}
}

forward cc3(i);
public cc3(i)
{
    if(ECarrera[i] == 1){
    GameTextForPlayer(i,"~g~3",1000,3);
	SetTimerEx("cc2",1000,false,"d",i);}
}

forward cc2(i);
public cc2(i)
{
    if(ECarrera[i] == 1){
    GameTextForPlayer(i,"~p~2",1000,3);
	SetTimerEx("cc1",1000,false,"d",i);}
}

forward cc1(i);
public cc1(i)
{
    if(ECarrera[i] == 1){
    GameTextForPlayer(i,"~y~1",1000,3);
	SetTimerEx("cc0",1000,false,"d",i);}
}

forward cc0(i);
public cc0(i)
{
    if(ECarrera[i] == 1){
    GameTextForPlayer(i,"~r~Y~b~A~g~!",1000,3);
	TogglePlayerControllable(i,true);}
}

forward CierraR();
public CierraR()
{
	if(posiciones <= 1)
	{
	SendClientMessageToAll(red,"[CARRERAS]: {FFFFFF}Carrera suspendida por falta de competidores.");
	carreraon = 0;
	carrerae = 0;
	Llegadas = 0;
	KillTimer(CarreraT);
	for(new i, g = GetMaxPlayers(); i < g; i++)
	{
	if(ECarrera[i] == 1)
	{
	SetPlayerPos(i,0,0,0);
	SpawnPlayer(i);
	ECarrera[i] = 0;
	}
	}
	return 1;
	}
	for(new i, g = GetMaxPlayers(); i < g; i++)
	{
	if(ECarrera[i] == 1)
	{
	CPP[i] = 1;
	SetPlayerRaceCheckpoint(i,0,CarreraI[CP1X],CarreraI[CP1Y],CarreraI[CP1Z],CarreraI[CP2X],CarreraI[CP2Y],CarreraI[CP2Z],10);
	GameTextForPlayer(i,"~r~5",1000,3);
	SetTimerEx("cc4",1000,false,"d",i);
	CarSpawner1(i,CarreraI[CA]);
	}
	}
	SendClientMessageToAll(green,"[CARRERA]: {FFFFFF}La carrera acaba de comenzar!");
	carrerae = 1;
	KillTimer(CarreraT);
	return 1;
}


stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);
	if (GetPlayerVehicleID(playerid))
	{
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

forward Rapidoseva(playerid);
public Rapidoseva(playerid)
{
	SendClientMessage(playerid,red,"[INFO]: {FFFFFF}Perdiste la súper velocidad.");
	SuperSprint[playerid] = 0;
	return 1;
}

forward CMDMessageToVips(playerid,command[]);
public CMDMessageToVips(playerid,command[])
{
	new Vip[50], string2[110];
	switch(Usuario[playerid][pVip])
	{
	case 1: Vip = "Bronce";
	case 2: Vip = "Plata";
	case 3: Vip = "Oro";
	case 4: Vip = "Elite";
	case 5: Vip = "Dios";
	case 6: Vip = "Supremo";
	}
	GetPlayerName(playerid,string2,sizeof(string2));
	format(string2,sizeof(string2),"[INFO]: El VIP %s %s [%d] usó el comando {FFFFFF}%s",Vip,string2,playerid,command);
	return MessageToAdmins(LIGHTBLUE,string2);
}

forward TuneLCar(VehicleID);
public TuneLCar(VehicleID)
{
	ChangeVehicleColor(VehicleID,0,7);
	AddVehicleComponent(VehicleID, 1010);
	AddVehicleComponent(VehicleID, 1087);
	return 1;
}


public ChauBengala(playerid)
{
    new Float:X,Float:Y,Float:Z;
	GetObjectPos(OBengala[playerid],X,Y,Z);
	DestroyObject(OBengala[playerid]);
	CreateExplosion(X,Y,Z,6,10.0);
	return 1;
}

public ChauBengala2(playerid)
{
    new Float:X,Float:Y,Float:Z;
	GetObjectPos(OBengala[playerid],X,Y,Z);
	DestroyObject(OBengala[playerid]);
	CreateExplosion(X+2,Y,Z,6,10.0);
	return 1;
}

public ChauBengala3(playerid)
{
    new Float:X,Float:Y,Float:Z;
	GetObjectPos(OBengala[playerid],X,Y,Z);
	DestroyObject(OBengala[playerid]);
	CreateExplosion(X,Y+2,Z,6,10.0);
	return 1;
}

stock Nitro(vehicleid)
{
new nos = GetVehicleModel(vehicleid);
switch(nos)
{
case 444:return 0;case 581:return 0;case 586:return 0;case 481:return 0;case 509:return 0;case 446:return 0;case 556:return 0;case 443:return 0;case 452:return 0;case 453:return 0;
case 454:return 0;case 472:return 0;case 473:return 0;case 484:return 0;case 493:return 0;case 595:return 0;case 462:return 0;case 463:return 0;case 468:return 0;case 521:return 0;
case 522:return 0;case 417:return 0;case 425:return 0;case 447:return 0;case 487:return 0;case 488:return 0;case 497:return 0;case 501:return 0;case 548:return 0;case 563:return 0;
case 406:return 0;case 520:return 0;case 539:return 0;case 553:return 0;case 557:return 0;case 573:return 0;case 460:return 0;case 593:return 0;case 464:return 0;case 476:return 0;
case 511:return 0;case 512:return 0;case 577:return 0;case 592:return 0;case 471:return 0;case 448:return 0;case 461:return 0;case 523:return 0;case 510:return 0;case 430:return 0;
case 465:return 0;case 469:return 0;case 513:return 0;case 519:return 0; }
	return 1;
}

InitFly(playerid)
{
	OnFly[playerid] = false;
	return;
}

bool:StartFly(playerid)
{
	if(OnFly[playerid])
 	return false;
    OnFly[playerid] = true;
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	SetPlayerPos(playerid,x,y,z+5.0);
	ApplyAnimation(playerid,"PARACHUTE","PARA_steerR",6.1,1,1,1,1,0,1);
	Fly(playerid);
	GameTextForPlayer(playerid,"~y~Modo Vuelo~n~~r~Clic Izq ~w~- Subes~n~~r~Clic Derecho ~w~- Bajas~n~ ~r~Espacio ~w~- Rapido~n~~r~Alt Izq ~w~- Lento",10000,3);
	return true;
}

public Fly(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1; new k, ud,lr; GetPlayerKeys(playerid,k,ud,lr);
	new Float:v_x,Float:v_y,Float:v_z, Float:x,Float:y,Float:z; if(ud < 0) { GetPlayerCameraFrontVector(playerid,x,y,z); v_x = x+0.1; v_y = y+0.1; }
	if(k & 128) v_z = -0.2; else if(k & KEY_FIRE) v_z = 0.2; if(k & KEY_WALK) { v_x /=5.0; v_y /=5.0; v_z /=5.0; }
	if(k & KEY_SPRINT) { v_x *=4.0; v_y *=4.0; v_z *=4.0; }
	if(v_z == 0.0) v_z = 0.025; SetPlayerVelocity(playerid,v_x,v_y,v_z);
	if(v_x == 0 && v_y == 0) { if(GetPlayerAnimationIndex(playerid) == 959) ApplyAnimation(playerid,"PARACHUTE","PARA_steerR",6.1,1,1,1,1,0,1); } else { GetPlayerCameraFrontVector(playerid,v_x,v_y,v_z); GetPlayerCameraPos(playerid,x,y,z); SetPlayerLookAt(playerid,v_x*500.0+x,v_y*500.0+y); if(GetPlayerAnimationIndex(playerid) != 959) ApplyAnimation(playerid,"PARACHUTE","FALL_SkyDive_Accel",6.1,1,1,1,1,0,1); }
	if(OnFly[playerid]) SetTimerEx("Fly",80,0,"i",playerid); return 1; }
	bool:StopFly(playerid) { if(!OnFly[playerid]) return false; new Float:x,Float:y,Float:z; GetPlayerPos(playerid,x,y,z); SetPlayerPos(playerid,x,y,z); OnFly[playerid] = false; return true; }
	static SetPlayerLookAt(playerid,Float:x,Float:y) { new Float:Px, Float:Py, Float: Pa; GetPlayerPos(playerid, Px, Py, Pa); Pa = floatabs(atan((y-Py)/(x-Px))); if (x <= Px && y >= Py) 		Pa = floatsub(180.0, Pa); else if (x < Px && y < Py) 		Pa = floatadd(Pa, 180.0); else if (x >= Px && y <= Py)	Pa = floatsub(360.0, Pa); Pa = floatsub(Pa, 90.0); if (Pa >= 360.0) Pa = floatsub(Pa, 360.0); SetPlayerFacingAngle(playerid, Pa);
	return;
}

GetVehicleModelIDFromName(vname[])
{
	for(new i = 0; i < 211; i++)
	{
		if ( strfind(VehicleNames[i], vname, true) != -1 )
			return i + 400;
	}
	return 0;
}

stock EnviarComandoTele(playerid,command[])
{
	if(Desmadre[playerid] == 1)
	{
	new string0[120];
	format(string0,sizeof(string0),"[TELES]: {FFFFFF}El jugador {FF0000}%s{FFFFFF} se teletransportó a {00FF00}[/%s]. {FFFFFF}(Jugadores: %d)",pName(playerid),command,endesmadre);
	return SendClientMessageToAll(blue,string0);
	}
	else
	{
	new string0[120];
	format(string0,sizeof(string0),"[TELES]: {FFFFFF}El jugador {FF0000}%s{FFFFFF} se teletransportó a {0000FF}[/%s]",pName(playerid),command);
	SendClientMessageToAll(blue,string0);
	}
	return 1;
}


stock JugadorEnBici(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 481 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 509 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 510) return 1;
	}
	return 0;
}

forward SeVantd(playerid);
public SeVantd(playerid)
{
	TextDrawHideForPlayer(playerid,Textdraw[4]);
	TextDrawHideForPlayer(playerid,TextdrawM[playerid]);
}


forward Message2Gang(gangid, text[]);
public Message2Gang(gangid, text[])
{
	for(new i, g = GetMaxPlayers(); i < g; i++)
	{
	    if(IsPlayerConnected(i))
		{
	    if(Usuario[i][pAdmin] > 3)
		{
		SendClientMessage(i,lightblue,text);
		}
		if(PlayerGang[i] == gangid)
		{
		SendClientMessage(i, GangInfo[gangid][GANG_COLOR], text);
		}
	}
	}
	return 1;
}

stock IsValidName(string[])
	{
	    for(new i = 0, j = strlen(string); i < j; i++)
	    {
	        switch(string[i])
	        {
	            case '0' .. '9': continue;
	            case 'a' .. 'z': continue;
	            case 'A' .. 'Z': continue;
	            case '_': continue;
	            case '$': continue;
	            case '.': continue;
	            case '=': continue;
	            case '(': continue;
	            case ')': continue;
	            case '[': continue;
	            case ']': continue;
	            default: return 0;
	        }
	    }
	    return 1;
	}

stock IsValidWeapon(weaponid)
{
    if (weaponid > 0 && weaponid < 19 || weaponid > 21 && weaponid < 47) return 1;
    return 0;
}
	
public JoinGang(playerid, gangid)
{
	new name[MAX_PLAYER_NAME];
	new gfile[100], string2[200];
	format(gfile, sizeof(gfile), GANG_FILE, gangid);
	GetPlayerName(playerid, name, sizeof(name));
	dUserSetINT(pName(playerid)).("clan", gangid);
	dUserSetINT(pName(playerid)).("lider",0);
	dUserSetINT(pName(playerid)).("Eslider",0);
	PlayerGang[playerid] = 1;
	PlayerLider[playerid] = 0;
	Usuario[playerid][Eslider] = 0;
    new stringeng[100];
	PlayerGang[playerid] = gangid;
	GangInfo[gangid][GANG_MEMBERS]++;
	format(string2, sizeof(string2), "[CLAN]:{FFFFFF} Te uniste éxitosamente a %s. [MIEMBROS: %d]", GangInfo[gangid][GANG_NAME], GangInfo[gangid][GANG_MEMBERS]);
	SendClientMessage(playerid, COLOR_GREEN, string2);
	format(stringeng, sizeof(stringeng), "[CLAN]: {FFFFFF}%s se unió al clan %s.", name , GangInfo[gangid][GANG_NAME]);
	SendClientMessageToAll(COLOR_GREEN, stringeng);
	SetPlayerColor(playerid, GangInfo[gangid][GANG_COLOR]);
	SpawnPlayer(playerid);
	GuardarUsuario(playerid);

	dini_IntSet(gfile, "GANG_MEMBERS", GangInfo[gangid][GANG_MEMBERS]);
	return 1;
}

//---- Gang Radar Timer
public GangRadar(playerid)
{
    for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
		if(PlayerGang[playerid] != PlayerGang[i] && gradar[playerid] == 1) SetPlayerMarkerForPlayer(playerid, i, (GetPlayerColor(i) & 0xFFFFFF00));
	}
}

public LeaveGang(playerid, gangid)
{
	new name[MAX_PLAYER_NAME];
	new gfile[100];
	format(gfile, sizeof(gfile), GANG_FILE, gangid);
	GetPlayerName(playerid, name, sizeof(name));

	dUserSetINT(pName(playerid)).("clan",0);
	dUserSetINT(pName(playerid)).("lider",0);
	dUserSetINT(pName(playerid)).("Eslider",0);

	new stringeng[100];
	format(stringeng, sizeof(stringeng), "[CLAN]: {FFFFFF}Saliste del clan %s.", GangInfo[gangid][GANG_NAME]);
	SendClientMessage(playerid, COLOR_ROJO, stringeng);
	format(stringeng, sizeof(stringeng), "[CLAN]: {FFFFFF}%s abandonó el clan %s!", name , GangInfo[gangid][GANG_NAME]);
	SendClientMessageToAll(COLOR_ROJO, stringeng);
	PlayerGang[playerid] = 0;
	PlayerLider[playerid] = 0;
	Usuario[playerid][Eslider] = 0;
	SpawnPlayer(playerid);
	GangInfo[gangid][GANG_MEMBERS]--;
	SetPlayerColor(playerid, RandomColors[playerid]);
	if(GangInfo[gangid][GANG_MEMBERS] == 0)
	{
	dini_Remove(gfile);
	}
	dini_IntSet(gfile, "GANG_MEMBERS", GangInfo[gangid][GANG_MEMBERS]);
	return 1;
}

forward CountTillEvento(playerid);
public CountTillEvento(playerid)
{
	new string2[120];
    format(string2,sizeof(string2),"[EVENTO %s]:{FFFFFF} Quedan %d segundos para ingresar, usa {00FF00}/irevento{FFFFFF}.",EventInfo[Nome],CountAmountEvento);
	switch(CountAmountEvento)
	{
	case 40: {SendClientMessageToAll(green,string2);}
	case 30: {SendClientMessageToAll(blue,string2);}
	case 20: {SendClientMessageToAll(yellow,string2);}
	case 10: {SendClientMessageToAll(red,string2);}
	}
	if(CountAmountEvento == 0)
	{
		EventInfo[Cerrado] = 1;
		KillTimer(CountTimerEvento);
		for(new i, g = GetMaxPlayers(); i < g; i++)
		{
			if(PlayerInfoE[i][NoEvento] == 0)
		    {
				format(string2,sizeof(string2), "[INFO]: {FFFFFF}El evento ya ha cerrado!");
				SendClientMessage(i,red, string2);
			}
		}
	}
	return CountAmountEvento--;
}


stock DestruirEvento(playerid)
{
	EventInfo[Xq] = 0;
	EventInfo[Yq] = 0;
	EventInfo[Zq] = 0;
	EventInfo[Aq] = 0;
	EventInfo[VirtualWorld] = 0;
	EventInfo[Interior] = 0;
	EventInfo[Criado] = 0;
	EventInfo[Aberto] = 0;
	EventInfo[Cerrado] = 0;
	EventInfo[Premio1] = 0;
	EventInfo[Premio2] = 0;
	EventInfo[Premio3] = 0;
	EventInfo[PremioS] = 0;
	EventInfo[PremioN] = 0;
	EventInfo[Carro] = 0;
	EventInfo[Cor1] = 0;
	EventInfo[Cor2] = 0;
	EventInfo[Arma] = 0;
	EventInfo[Vida] = 0;
	SEVENTO = 0;
	for(new p, g = GetMaxPlayers(); p < g; p++)
    {
       	if(PlayerInfoE[p][NoEvento] == 1)
		{
			SetPlayerVirtualWorld(p, 0);
			SetPlayerInterior(p, 0);
			SpawnPlayer(p);
			PlayerInfoE[p][NoEvento] = 0;
			if(PlayerInfoE[p][Carro] >= 1)
			{
				DestroyVehicle(PlayerInfoE[p][Carro]);
				PlayerInfoE[p][Carro] = 0;
			}
		}
    }
	GetPlayerName(playerid, NomePlayer, MAX_PLAYER_NAME);
	format(Format, sizeof(Format), "[EVENTO]:{FFFFFF} %s entregó los premios y cerró el evento.", NomePlayer);
	SendClientMessageToAll(COR_EVENTO, Format);
	return 1;
}

stock SendEventMessage(color, string[])
{
	for(new p, g = GetMaxPlayers(); p < g; p++)
	{
		if(IsPlayerConnected(p))
		{
		    if(PlayerInfoE[p][NoEvento] == 1)
		    {
				SendClientMessage(p, color, string);
			}
		}
	}
	return 1;
}

public OnPlayerEditAttachedObject( playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{

    SetPlayerAttachedObject(playerid,index,modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);
    SendClientMessage(playerid, 0xFFFFFFFF, "[INFO]: Terminaste de editar los objetos, todo fue guardado en la base de datos.");

    new file[256];
    new name[24];
    GetPlayerName(playerid,name,24);
    format(file,sizeof(file),"Player Objects/%s.ini",name);
    if(!dini_Exists(file)) return 1;
    format(f1,15,"O_Model_%d",index);
    format(f2,15,"O_Bone_%d",index);
    format(f3,15,"O_OffX_%d",index);
    format(f4,15,"O_OffY_%d",index);
    format(f5,15,"O_OffZ_%d",index);
    format(f6,15,"O_RotX_%d",index);
    format(f7,15,"O_RotY_%d",index);
    format(f8,15,"O_RotZ_%d",index);
    format(f9,15,"O_ScaleX_%d",index);
    format(f10,15,"O_ScaleY_%d",index);
    format(f11,15,"O_ScaleZ_%d",index);
    dini_IntSet(file,f1,modelid);
    dini_IntSet(file,f2,boneid);
    dini_FloatSet(file,f3,fOffsetX);
    dini_FloatSet(file,f4,fOffsetY);
    dini_FloatSet(file,f5,fOffsetZ);
    dini_FloatSet(file,f6,fRotX);
    dini_FloatSet(file,f7,fRotY);
    dini_FloatSet(file,f8,fRotZ);
    dini_FloatSet(file,f9,fScaleX);
    dini_FloatSet(file,f10,fScaleY);
    dini_FloatSet(file,f11,fScaleZ);
    return 1;
}

public OnPlayerModelSelectionEx(playerid, response, extraid, modelid)
{
        if(extraid==DIALOG_ATTACH_MODEL_SELECTION)
        {
            if(!response)
        {   ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT_SELECTION,DIALOG_STYLE_LIST,"Objeto de usuarios: Selecciona.","Opción:1 :: "COL_GREY"Objetos del servidor\n"COL_WHITE"Opción:2 :: "COL_GREY"Objeto por ID","Siguiente(>>)","Atrás(<<)");    }
            if(response)
            {
                    if(GetPVarInt(playerid, "AttachmentUsed") == 1) EditAttachedObject(playerid, modelid);
                    else
                    {
                            SetPVarInt(playerid, "AttachmentModelSel", modelid);
                new string[256+1];
                                new dialog[500];
                                for(new x;x<sizeof(AttachmentBones);x++)
                        {
                                        format(string, sizeof(string), "Parte:%s\n", AttachmentBones[x]);
                                        strcat(dialog,string);
                                }
                                ShowPlayerDialog(playerid, DIALOG_ATTACH_BONE_SELECTION, DIALOG_STYLE_LIST, \
                                "{FF0000}Modificación de objetos", dialog, "Seleccionar", "Cancelar");
                    }
                }
        }
        return 1;
}


forward AntiSpawnKill(playerid);
public AntiSpawnKill(playerid)
{
	if(Usuario[playerid][Aduty] == 0 || Desmadre[playerid] == 0)
	{
	SetPlayerHealth(playerid,100);
	}
	return 1;
}


stock PlayAudioStreamForAll(url[])
{
	for(new i, g = GetMaxPlayers(); i < g; i++)
	{
	PlayAudioStreamForPlayer(i,url);
	}
	return 1;
}

stock GetPlayerHighestScores(array[][rankingEnum], left, right)
{
    new
        tempLeft = left,
        tempRight = right,
        pivot = array[(left + right) / 2][player_Score],
        tempVar
    ;
    while(tempLeft <= tempRight)
    {
        while(array[tempLeft][player_Score] > pivot) tempLeft++;
        while(array[tempRight][player_Score] < pivot) tempRight--;

        if(tempLeft <= tempRight)
        {
            tempVar = array[tempLeft][player_Score], array[tempLeft][player_Score] = array[tempRight][player_Score], array[tempRight][player_Score] = tempVar;
            tempVar = array[tempLeft][player_ID], array[tempLeft][player_ID] = array[tempRight][player_ID], array[tempRight][player_ID] = tempVar;
            tempLeft++, tempRight--;
        }
    }
    if(left < tempRight) GetPlayerHighestScores(array, left, tempRight);
    if(tempLeft < right) GetPlayerHighestScores(array, tempLeft, right);
}

forward MiniGm1(playerid);
public MiniGm1(playerid)
{
new Float:X,Float:Y,Float:Z;
GetObjectPos(Objeto0,X,Y,Z);
if(X == -3062.55103 && Y == 1792.47119 && Z == 176.24059)
{
MoveObject(Objeto0,-3094.2478, 1796.9939, 176.2406,10);
}
else if(X == -3094.2478 && Y == 1796.9939 && Z == 176.2406)
{
MoveObject(Objeto0,-3062.55103,1792.47119,176.24059,10);
}
new Float:XX,Float:YY,Float:ZZ;
GetObjectPos(Objeto1,XX,YY,ZZ);
if(XX == -3232.74219 && YY == 1779.52771 && ZZ == 200.02237)//1
{
MoveObject(Objeto1,-3232.3911, 1788.4939, 200.0224,5);
}
else if(XX == -3232.3911 && YY == 1788.4939 && ZZ == 200.0224)//2
{
MoveObject(Objeto1,-3232.74219, 1779.52771, 200.02237,5);
}
new Float:XXX,Float:YYY,Float:ZZZ;
GetObjectPos(Objeto2,XXX,YYY,ZZZ);
if(XXX== -3251.51953 && YYY == 1779.73401 && ZZZ == 200.02237)//1
{
MoveObject(Objeto2,-3250.4006, 1790.4146, 200.0224,5);
}
else if(XXX == -3250.4006 && YYY == 1790.4146 && ZZZ == 200.0224)//2
{
MoveObject(Objeto2,-3251.51953, 1779.73401, 200.02237,5);
}
new Float:XXXX,Float:YYYY,Float:ZZZZ;
GetObjectPos(Objeto3,XXXX,YYYY,ZZZZ);
if(XXXX== -3265.85938 && YYYY == 1779.79602 && ZZZZ == 200.02237)//1
{
MoveObject(Objeto3,-3266.1738, 1789.8718, 200.0224,5);
}
else if(XXXX == -3266.1738 && YYYY == 1789.8718 && ZZZZ == 200.0224)//2
{
MoveObject(Objeto3,-3265.85938, 1779.79602, 200.02237,5);
}
new Float:XXXXX,Float:YYYYY,Float:ZZZZZ;
GetObjectPos(Objeto4,XXXXX,YYYYY,ZZZZZ);
if(XXXXX== -3411.35791 && YYYYY == 1921.13452 && ZZZZZ == 202.97330)//1
{
MoveObject(Objeto4,-3411.3579, 1921.1345, 195.3406,5);
}
else if(XXXXX == -3411.3579 && YYYYY == 1921.1345 && ZZZZZ == 195.3406)//2
{
MoveObject(Objeto4,-3411.35791, 1921.13452, 202.97330,5);
}
new Float:XXXXXX,Float:YYYYYY,Float:ZZZZZZ;
GetObjectPos(Objeto5,XXXXXX,YYYYYY,ZZZZZZ);
if(XXXXXX== -3415.75854 && YYYYYY == 1921.37939 && ZZZZZZ == 202.97330)//1
{
MoveObject(Objeto5,-3415.7585, 1921.3794, 195.4064,5);
}
else if(XXXXXX == -3415.7585 && YYYYYY == 1921.3794 && ZZZZZZ == 195.4064)//2
{
MoveObject(Objeto5,-3415.75854, 1921.37939, 202.97330,5);
}
new Float:XXXXXXX,Float:YYYYYYY,Float:ZZZZZZZ;
GetObjectPos(Objeto6,XXXXXXX,YYYYYYY,ZZZZZZZ);
if(XXXXXXX== -3420.13965 && YYYYYYY == 1921.67639 && ZZZZZZZ == 202.97330)//1
{
MoveObject(Objeto6,-3420.1396, 1921.6764, 195.4423,5);
}
else if(XXXXXXX == -3420.1396 && YYYYYYY == 1921.6764 && ZZZZZZZ == 195.4423)//2
{
MoveObject(Objeto6,-3420.13965, 1921.67639, 202.97330,5);
}
new Float:XXXXXXXX,Float:YYYYYYYY,Float:ZZZZZZZZ;
GetObjectPos(Objeto7,XXXXXXXX,YYYYYYYY,ZZZZZZZZ);
if(XXXXXXXX== -3424.56616 && YYYYYYYY == 1922.15442 && ZZZZZZZZ == 202.97330)//1
{
MoveObject(Objeto7,-3424.5662, 1922.1544, 195.2697,5);
}
else if(XXXXXXXX == -3424.5662 && YYYYYYYY == 1922.1544 && ZZZZZZZZ == 195.2697)//2
{
MoveObject(Objeto7,-3424.56616, 1922.15442, 202.97330,5);
}
new Float:XXXXXXXXX,Float:YYYYYYYYY,Float:ZZZZZZZZZ;
GetObjectPos(Objeto9,XXXXXXXXX,YYYYYYYYY,ZZZZZZZZZ);
if(XXXXXXXXX== -3522.62183 && YYYYYYYYY == 1968.65247 && ZZZZZZZZZ == 245.18481)//1
{
MoveObject(Objeto9,-3549.9734, 1995.9203, 245.1848,15);
}
else if(XXXXXXXXX == -3549.9734 && YYYYYYYYY == 1995.9203 && ZZZZZZZZZ == 245.1848)//2
{
MoveObject(Objeto9,-3522.62183, 1968.65247, 245.18481,15);
}
new Float:XXXXXXXXXX,Float:YYYYYYYYYY,Float:ZZZZZZZZZZ;
GetObjectPos(Objeto8,XXXXXXXXXX,YYYYYYYYYY,ZZZZZZZZZZ);

if(XXXXXXXXXX== -3513.78052 && YYYYYYYYYY == 1975.95789 && ZZZZZZZZZZ == 245.28682)//1
{
MoveObject(Objeto8,-3537.2717, 2006.2999, 245.2868,10);
}
else if(XXXXXXXXXX == -3537.2717 && YYYYYYYYYY == 2006.2999 && ZZZZZZZZZZ == 245.2868)//2
{
MoveObject(Objeto8,-3513.78052, 1975.95789, 245.28682,10);
}
return 1;
}


stock AntiFlood_Hack(playerid)
{
AntiFlood_Data[playerid][UltimoUpd] = GetTickCount();
AntiFlood_Data[playerid][VelocidadFlood] = 0;
}

stock Antiflood( playerid, bool:inc=true )
	{
	AntiFlood_Data[playerid][VelocidadFlood] += inc ? RATE_INC : 0;
	AntiFlood_Data[playerid][VelocidadFlood] = AntiFlood_Data[playerid][VelocidadFlood] - ( GetTickCount() - AntiFlood_Data[playerid][UltimoUpd] );
	AntiFlood_Data[playerid][UltimoUpd] = GetTickCount();
	AntiFlood_Data[playerid][VelocidadFlood] = AntiFlood_Data[playerid][VelocidadFlood] < 0 ? 0 : AntiFlood_Data[playerid][VelocidadFlood];
	if ( AntiFlood_Data[playerid][VelocidadFlood] >= RATE_MAX && Usuario[playerid][pAdmin] == 0)
	{
	#if THRESOLD_ACTION == 1
	new msg[220], name[MAX_PLAYER_NAME];
	GetPlayerName( playerid, name, sizeof( name ) );
	format( msg, sizeof( msg ), "[INFO]: {FFFFFF}%s fue kickeado automáticamente. {00FF00}[Razón: Intento de Chat Cmd/Flood]",pName(playerid));
	SendClientMessageToAll(0xFF0000AA,msg);
	printf("%s",msg);
	Kick(playerid);
	#endif
	return false;
	}
	return true;
	}
	
forward Conectar(playerid);
public Conectar(playerid)
{
	OnPlayerConnect(playerid);
	SpawnPlayer(playerid);
	ForceClassSelection(playerid);
}

forward Reportando(playerid);
public Reportando(playerid)
{
	Reporto[playerid] = 0;
}

forward Skins(playerid);
public Skins(playerid)
{
	SpawnPlayer(playerid);
	ForceClassSelection(playerid);
}

stock Flood(playerid)
    {
        if(GetTickCount() -Antiflood[playerid] < 2000)
        return 1;

        return 0;
    }
    
stock DarDinero(playerid,monto)
{
Usuario[playerid][Dinero] += monto;
GivePlayerMoney(playerid, monto);
return 1;
}

stock QuitarDinero(playerid,monto)
{
Usuario[playerid][Dinero] -= monto;
GivePlayerMoney(playerid, -monto);
return 1;
}

CountIP(ip[])
{
        new countip;
	    for(new i = 0; i < GetMaxPlayers(); i++)
                if(IsPlayerConnected(i) && !strcmp(PlayerIP(i),ip))
                        countip++;
        return countip;
}

PlayerIP(playerid)
{
        new ip[16];
        GetPlayerIp(playerid,ip,sizeof(ip));
        return ip;
}

stock PlayerPlaySoundForAll(soundid,Float:x,Float:y,Float:z)
{
for(new p, g = GetMaxPlayers(); p < g; p++)
{
PlayerPlaySound(p,soundid,Float:x,Float:y,Float:z);
}
}


forward NuevoConcurso();
public NuevoConcurso()
{
RespuestaConcurso = MINIMUM_VALUE + random(MAXIMUM_VALUE-MINIMUM_VALUE);
new string2[120];
format(string2,sizeof string2,"[TEST DE REACCIÓN]: {FFFFFF}¡Vamos, rápido, escribre {00FF00}%d{FFFFFF} para ganar $%d y 3 de NIVEL!",RespuestaConcurso,PREMIO_CONCURSO);
SendClientMessageToAll(orange,string2);
return 1;
}

stock JugadorGanaConcurso(playerid)
{
new string2[110];
format(string2,sizeof string2,"[TEST DE REACCIÓN]: {FFFFFF}El jugador {00FF00}%s (%d){FFFFFF} ganó el TEST DE REACCIÓN!",pName(playerid),playerid,PREMIO_CONCURSO);
SendClientMessageToAll(orange,string2);DarDinero(playerid,PREMIO_CONCURSO);Usuario[playerid][Nivel] += 3;RespuestaConcurso = -1;
return 1;
}

stock IpToCountry_db(IpInfo[])
{
	new	DB:database,
		DBResult:result,
		query[256];
	database = db_open(DATABASENAME);
	if(database)
	{
		if(strcmp("127.0.0.1", IpInfo, true) == 0)
		{
			query = "Localhost";
		} else {
			new	IPsplit[4][10];
			if(sscanf(IpInfo, "p<.>s[10]s[10]s[10]s[10]", IPsplit[0], IPsplit[1], IPsplit[2], IPsplit[3])) { query = "Invalid IP"; }
			else {
				format(query, sizeof query, "\
				SELECT `Country`\
				FROM `countrydetected`\
				WHERE `Ip_From` <= ((16777216*%d) + (65536*%d) + (256*%d) + %d)\
				AND `Ip_to` >= ((16777216*%d) + (65536*%d) + (256*%d) + %d) LIMIT 1",
				strval(IPsplit[0]), strval(IPsplit[1]), strval(IPsplit[2]), strval(IPsplit[3]),
				strval(IPsplit[0]), strval(IPsplit[1]), strval(IPsplit[2]), strval(IPsplit[3]));

				result = db_query(database, query);
				if(!db_get_field_assoc(result, "Country", query, sizeof query))
				{
					query = "Desconocido";
				}
				db_free_result(result);
			}
		}
		db_close(database);
	} else query = "Failed. Not Open "DATABASENAME"";
	return query;
}
public OnReverseDNS(ip[], host[], extra)
{
        if(strfind(host,"anchorfree.com", true) != -1)
		{
		new id = extra;
		KickA(id,"Proxy IP");
		}
        return 1;
}
