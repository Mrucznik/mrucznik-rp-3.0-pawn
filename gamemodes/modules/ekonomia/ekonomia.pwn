//ekonomia.pwn

//----------------------------------------------<< Source >>-------------------------------------------------//
//---------------------------------------[ Modu�: ekonomia.pwn ]------------------------------------------//
//Opis:
/*
	Modu� zawiera zdefiniowane ceny wszystkiego oraz w przysz�o�ci systemy cen oraz ekonomii kt�re maj� na celu
	usuni�cie sytuacji zbyt du�ej ilo�ci got�wki w�r�d graczy i stworzenie rynkowej ekonomii i dynamicznych cen
*/
//Adnotacje:
/*

*/
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

//

//-----------------<[ Funkcje: ]>-------------------
ekonomia_Init()
{
	ekonomia_LoadCommands();
}

//------------------<[ MySQL: ]>--------------------
//-----------------<[ Komendy: ]>-------------------
ekonomia_LoadCommands()
{
	Command_AddAlt(YCMD:plac, "zaplac");
	Command_AddAlt(YCMD:plac, "pay");
	Group_SetCommand(LoggedPlayers, YCMD:plac, true);
}

YCMD:plac(playerid, params[], help)
{
    if(help)
	{
		//Pomoc
		SendClientMessage(playerid, -1, "P�aci graczowi wpisan� kwot�.");
		return 1;
	}
	
	//Lista parametr�w:
	new giveplayerid;
	new hajs;
	
	if(sscanf(params, "uk<hajs>", giveplayerid, hajs)) 
	{
		CMDInfo(playerid, "U�ycie: /plac [Nick/ID] [ilo��]");
		return 1;
	}
	else
	{
		//Cia�o komendy:
		if(playerid == giveplayerid)
		{
			ServerFail(playerid, "P�acenie samemu sobie nie wydaje si� dobrym pomys�em ;) Czy na pewno taki by� tw�j zamiar?");
			return 1;
		}
		if(!IsPlayerLogged(giveplayerid))
		{
			ServerFail(playerid, "Na serwerze nie ma gracza o podanym Nicku/ID");
			return 1;
		}
		if(hajs <= 5000 && hajs > 0)
		{
			ServerFail(playerid, "T� komend� nie mo�esz p�aci� wi�cej ni� 5000$. U�yj /teczka!");
			return 1;
		}
		if(IsPlayerInRangeToPlayer(playerid, giveplayerid))
		{
			ServerFail(playerid, "Ten gracz jest za daleko od tego gracza, podejd� bli�ej.");
			return 1;
		}
		
		new player[MAX_PLAYER_NAME], giveplayer[MAX_PLAYER_NAME], string[64];
		GetPlayerName(playerid, player, sizeof(player));
		GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
		GivePlayerMoney(playerid, -hajs);
		GivePlayerMoney(giveplayerid, hajs);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		ServerInfoF(playerid, "Da�e� %d$ graczowi %s", hajs, giveplayer);
		ServerInfoF(giveplayerid, "Otrzyma�e� %d$ od gracza %s", hajs, player);
		format(string, sizeof(string), "wyci�ga pieni�dze i daje je %s.", giveplayer);
		Me(playerid, string);
		Log(PayLog, INFO, "da� %s kwot� %d$", giveplayer, hajs);
		
		return 1;
	}
}

//end