//define.pwn

//-----------------------------------------------<< System >>------------------------------------------------//
//-------------------------------------------[ Modu�: define.pwn ]-------------------------------------------//
//----------------------------------------------------*------------------------------------------------------//
//----[                                                                                                 ]----//
//----[         |||||             |||||                       ||||||||||       ||||||||||               ]----//
//----[        ||| |||           ||| |||                      |||     ||||     |||     ||||             ]----//
//----[       |||   |||         |||   |||                     |||       |||    |||       |||            ]----//
//----[       ||     ||         ||     ||                     |||       |||    |||       |||            ]----//
//----[      |||     |||       |||     |||                    |||     ||||     |||     ||||             ]----//
//----[      ||       ||       ||       ||     __________     ||||||||||       ||||||||||               ]----//
//----[     |||       |||     |||       |||                   |||    |||       |||                      ]----//
//----[     ||         ||     ||         ||                   |||     ||       |||                      ]----//
//----[    |||         |||   |||         |||                  |||     |||      |||                      ]----//
//----[    ||           ||   ||           ||                  |||      ||      |||                      ]----//
//----[   |||           ||| |||           |||                 |||      |||     |||                      ]----//
//----[  |||             |||||             |||                |||       |||    |||                      ]----//
//----[                                                                                                 ]----//
//----------------------------------------------------*------------------------------------------------------//

//------------------<[ Makra: ]>-------------------
#define SetPlayerArmorEx SetPlayerArmourEx
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define PRESSING(%0,%1) \
	(%0 & (%1))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

//------------------<[ Define: ]>-------------------
#define MAX_MESSAGE_LENGHT 			144 		//maksymalna liczba znak�w jaka mo�e zosta� wy�wietlona na ekranie
#define MAX_STREAM_LENGTH 			128			//maksymalna d�ugo�� linku dla PlayAudioStreamForPlayer
#define BYTES_PER_CELL 				4 			//u�ywane w SendClientMessageF
#define SPAM_PROTECTION_VALUE 		3 			//ilo�� dzia�a� kt�re mo�na wykona� przed w��czeniem ochrony antyspamowej 
#define COLOR_STRING_LENGTH			6			//d�ugo�� ci�gu znak�w odpowiedzialna za kolor
#define NOT_FOUND					-1			//u�ywane do strfind

//end