//chaty.pwn

//----------------------------------------------<< Source >>-------------------------------------------------//
//------------------------------------------[ Modu�: chaty.pwn ]---------------------------------------------//
//Opis:
/*
	Zawiera chaty dost�pne dla wszystkich graczy oraz globalne chaty.
	Lista chat�w:
		- lokalny /l
		- krzyk /k
		- szept /s
		- lokalny ooc /b
		- globalny ooc /o
		- opisuj�cy akcje /me
		- opisuj�cy otoczenie /do
		- cb-radio /cb
		- prywatne wiadomo�ci /w
*/
//Adnotacje:
/*
	W razie lag�w mo�na to zoptymalizowa� by ca�e parsowanie textu by�o w 1 funkcji
	TODO:
	regex'y dla chat�w IC (dozwolone tylko konkretne znaki)
	Anty reklama i anty bluzgi na chatach globalnych
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
chaty_Init()
{
	chaty_LoadCommands();
}

stock ChatICAdditions(playerid, text[])
{
	new string[256];
	strcat(string, ZamienZnalezioneBindy(playerid, text));
	format(string, sizeof(string), "%s", WykonajEmotki(playerid, string));
	format(string, sizeof(string), "%s", KolorujWstawkiMe(string));
	return string;
}

stock ChatOOCAdditions(playerid, text[])
{
	new string[256]; 
	strcat(string, ZamienZnalezioneBindy(playerid, text));
	return string;
}

stock WykonajEmotki(playerid, text[])
{
	new string[256];
	new emotki[7][] = {
		":)",
		";)",
		":(",
		":D",
		";D",
		"xD",
		":P"
	};
	
	strcat(string, text);
	new bool:brakZamian;
	do
	{
		brakZamian = false;
		for(new i=0; i<sizeof(emotki); i++)
		{
			new pozycjaEmotki = strfind(string, emotki[i]);
			if(pozycjaEmotki != -1)
			{
				defer WyswietlMeEmotki(playerid, i);
				strdel(string, pozycjaEmotki, pozycjaEmotki+strlen(emotki[i]));
				brakZamian = true;
			}
		}
	}
	while(brakZamian);
	return string;
}

timer WyswietlMeEmotki[0](playerid, emotka)
{
	new emotki[7][] = {
		"u�miecha si�.",
		"puszcza oczko.",
		"zasmuci� si�.",
		"�mieje si�.",
		"puszcza oczko wpadaj�c w gromki �miech.",
		"skis� ze �miechu.",
		"wystawia j�zyk."
	};
	Me(playerid, emotki[emotka]);
}

stock KolorujWstawkiMe(text[])
{
	new string[256];
	strcat(string, text);
	new stars = strfind(string, "**");
	if(stars != -1)
	{
		new nextStars = strfind(string, "**", true, stars+2);
		if(nextStars != -1)
		{
			strdel(string, nextStars+2, strlen(string));
			strins(string, INCOLOR_PURPLE, stars);
		}
	}
	return string;
}


//----------< Chaty > --------------
stock Chat(playerid, text[])
{
	if(text[0] =='\0') return 1;
	
	new string[256];
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{ //(w poje�dzie)
		format(string, sizeof(string), "M�wi: %s", text);
		SetPlayerChatBubble(playerid,string, COLOR_FADE1, CHAT_RANGE, CHATBUBBLE_TIME);
		format(string, sizeof(string), "%s M�wi(w poje�dzie): %s", GetNick(playerid), text);
		RangeMessageGradient(playerid, string, CHAT_RANGE, COLOR_FADE1, COLOR_FADE5);
	}
	else
	{ //na zewn�trz
		format(string, sizeof(string), "M�wi: %s", text);
		SetPlayerChatBubble(playerid,string,COLOR_FADE1, CHAT_RANGE, CHATBUBBLE_TIME);
		format(string, sizeof(string), "%s M�wi: %s", GetNick(playerid), text);
		RangeMessageGradient(playerid, string, CHAT_RANGE, COLOR_FADE1, COLOR_FADE5);
		ApplyAnimation(playerid,"PED","IDLE_CHAT",4.0,0,0,0,4,4); //animacja mowy
	}
	Log(ChatLog, INFO, text);
	return 1;
}

stock Krzyk(playerid, text[])
{
	if(text[0] =='\0') return 1;

	new string[256];
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{ //(w poje�dzie)
		format(string, sizeof(string), "Krzyczy: %s!!",text);
		SetPlayerChatBubble(playerid,string,COLOR_FADE1, KRZYK_RANGE, CHATBUBBLE_TIME);
		format(string, sizeof(string), "%s Krzyczy(w poje�dzie): %s!!", GetNick(playerid), text);
		RangeMessageGradient(playerid, string, KRZYK_RANGE, COLOR_WHITE,COLOR_FADE2);
	}
	else
	{ //na zewn�trz
		format(string, sizeof(string), "Krzyczy: %s!!",text);
		SetPlayerChatBubble(playerid,string,COLOR_FADE1, KRZYK_RANGE, CHATBUBBLE_TIME);
		format(string, sizeof(string), "%s Krzyczy: %s!!", GetNick(playerid), text);
		RangeMessageGradient(playerid, string, KRZYK_RANGE, COLOR_WHITE,COLOR_FADE2);
		//ApplyAnimation(playerid,"PED","IDLE_CHAT",4.0,0,0,0,4,4);
	}
	Log(ChatLog, INFO, text);
	return 1;
}

stock Szept(playerid, text[])
{
	if(text[0] =='\0') return 1;
	
	new string[256];
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{ //(w poje�dzie)
		format(string, sizeof(string), "Szepcze: %s", text);
		SetPlayerChatBubble(playerid,string, COLOR_FADE1, SZEPT_RANGE, CHATBUBBLE_TIME);
		format(string, sizeof(string), "%s Szepcze(w poje�dzie): %s", GetNick(playerid), text);
		RangeMessageGradient(playerid, string, SZEPT_RANGE, COLOR_FADE1, COLOR_FADE5);
	}
	else
	{ //na zewn�trz
		format(string, sizeof(string), "Szepcze: %s", text);
		SetPlayerChatBubble(playerid,string, COLOR_FADE1, SZEPT_RANGE, CHATBUBBLE_TIME);
		format(string, sizeof(string), "%s Szepcze: %s", GetNick(playerid), text);
		RangeMessageGradient(playerid, string, SZEPT_RANGE, COLOR_FADE1, COLOR_FADE5);
		//ApplyAnimation(playerid,"PED","IDLE_CHAT",4.0,0,0,0,4,4);
	}
	Log(ChatLog, INFO, text);
	return 1;
}

stock ChatOOC(playerid, text[])
{
	new string[256];
	format(string, sizeof(string), "(( %s ))", text);
	SetPlayerChatBubble(playerid,string, COLOR_FADE1, CHAT_RANGE, CHATBUBBLE_TIME);
	format(string, sizeof(string), "%s [%d] Czat OOC: %s", GetNick(playerid), playerid, string);
    RangeMessageGradient(playerid, string, CHAT_RANGE, COLOR_FADE1, COLOR_FADE5);
	Log(ChatLog, INFO, string);
	return 1;
}

stock GlobalOOC(playerid, text[])
{
	format(string, sizeof(string), "(( %s [%d]: %s ))", GetNick(playerid), playerid, text);
    MruMessageToAll(playerid, COLOR_WHITE, string);
	Log(ChatLog, INFO, string);
	return 1;
}

stock Me(playerid, text[], Float:zasieg=ME_RANGE)
{
    new string[256];
	format(string, sizeof(string), "* %s *", text);
	SetPlayerChatBubble(playerid,string, COLOR_PURPLE, zasieg, CHATBUBBLE_TIME);
    format(string, sizeof(string), "* %s %s", GetNick(playerid), text);
    RangeMessage(playerid, COLOR_PURPLE, string, zasieg);
	format(string, sizeof(string), "%s [/me:] %s", GetNick(playerid), text);
	Log(ChatLog, INFO, string);
	return 1;
}

stock Do(playerid, text[], Float:zasieg=ME_RANGE)
{
    new string[256];
	format(string, sizeof(string), "** %s **", text);
	SetPlayerChatBubble(playerid,string, COLOR_PURPLE, zasieg, CHATBUBBLE_TIME);
    format(string, sizeof(string), "* %s ((%s))", text, GetNick(playerid));
    RangeMessage(playerid, COLOR_PURPLE, string, zasieg);
	format(string, sizeof(string), "%s [/do:] %s", GetNick(playerid), text);
	Log(ChatLog, INFO, string);
	return 1;
}

stock CBRadio(playerid, text[])
{
	new string[256];
	format(string, sizeof(string), "%s m�wi przez CB-Radio: %s", GetNick(playerid), text);
	foreach( new i : GroupMember(LoggedPlayers))
	{
		if(IsPlayerInAnyVehicle(i))
		{
			MruMessage(i, COLOR_GREEN, string);
		}
	}
	Log(ChatLog, INFO, string);
}

stock PrywatnaWiadomosc(playerid, giveplayerid, text[])
{
	MruMessageF(giveplayerid, COLOR_NEWS, "� %s (ID: %d) wiadomo��: %s", GetNick(playerid), playerid, text);
	MruMessageF(playerid,  COLOR_YELLOW, "� Wiadomo�� wys�ana do %s (ID: %d)%s: %s", GetNick(giveplayerid), giveplayerid, (!IsPlayerPaused(giveplayerid)) ? (""): (" [AFK] "), text);
	
	PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	PlayerPlaySound(giveplayerid, 1057, 0.0, 0.0, 0.0);
	
	Log(ChatLog, INFO, "Gracz %s wys�a� prywatn� wiadomo�� do %s o tre�ci: %s", GetNick(playerid), GetNick(giveplayerid), text);
	return 1;
}

//------------------<[ MySQL: ]>--------------------

//---

//-----------------<[ Komendy: ]>-------------------
chaty_LoadCommands()
{
	Command_AddAlt(YCMD:l, "local");
	Command_AddAlt(YCMD:l, "say");
	Command_AddAlt(YCMD:l, "powiedz");
	Group_SetCommand(LoggedPlayers, YCMD:l, true);
	
	Command_AddAlt(YCMD:k, "shout");
	Command_AddAlt(YCMD:k, "krzyk");
	Command_AddAlt(YCMD:k, "krzycz");
	Group_SetCommand(LoggedPlayers, YCMD:k, true);
	
	Command_AddAlt(YCMD:s, "szept");
	Command_AddAlt(YCMD:s, "szepcz");
	Group_SetCommand(LoggedPlayers, YCMD:s, true);
	
	Command_AddAlt(YCMD:me, "ja");
	Group_SetCommand(LoggedPlayers, YCMD:me, true);
	
	Command_AddAlt(YCMD:do, "akcja");
	Group_SetCommand(LoggedPlayers, YCMD:do, true);
	
	Group_SetCommand(LoggedPlayers, YCMD:b, true);
	
	Command_AddAlt(YCMD:cb, "cbradio");
	Group_SetCommand(LoggedPlayers, YCMD:cb, true);
	
	Command_AddAlt(YCMD:w, "pm");
	Command_AddAlt(YCMD:w, "wiadomosc");
	Command_AddAlt(YCMD:w, "whisper");
	Group_SetCommand(LoggedPlayers, YCMD:w, true);
}

YCMD:l(playerid, params[], help)
{ //chat
    if ( help ) return CMDHelp(playerid, "Podstawowy czat IC (mowa postaci).");
	
	if (isnull(params)) return CMDInfo(playerid, "U�ycie: /l [tekst]");
	
	Chat(playerid, ChatICAdditions(playerid, params));
    return 1;
}

YCMD:k(playerid, params[], help)
{ //krzyk
    if ( help ) return CMDHelp(playerid, "Podstawowy czat IC (krzyk postaci).");
	
	if (isnull(params)) return CMDInfo(playerid, "U�ycie: /k [tekst]");
	
	Krzyk(playerid, ChatICAdditions(playerid, params));
    return 1;
}

YCMD:s(playerid, params[], help)
{ //szept
    if ( help ) return CMDHelp(playerid, "Podstawowy czat IC (szept postaci).");
	
	if (isnull(params)) return CMDInfo(playerid, "U�ycie: /s [tekst]");
	
	Szept(playerid, ChatICAdditions(playerid, params));
    return 1;
}

YCMD:b(playerid, params[], help)
{ //szept
    if ( help ) return CMDHelp(playerid, "Podstawowy czat OOC (wiadomo�� do graczy woko�o).");
	
	if (isnull(params)) return CMDInfo(playerid, "U�ycie: /b [tekst]");
	
	ChatOOC(playerid, ChatOOCAdditions(playerid, params));
    return 1;
}

YCMD:o(playerid, params[], help)
{ //szept
    if ( help ) return CMDHelp(playerid, "Globalny czat OOC (widoczny dla wszystkich graczy na serwerze).");
	
	if (isnull(params)) return CMDInfo(playerid, "U�ycie: /o [tekst]");
	
	ChatOOC(playerid, ChatOOCAdditions(playerid, params));
    return 1;
}

YCMD:me(playerid, params[], help)
{ //ja
    if ( help ) return CMDHelp(playerid, "S�u�y do opisu czynno�ci kt�re wykonuje posta�.");
	
	if (isnull(params)) return CMDInfo(playerid, "U�ycie: /me [akcja]");
	
	Me(playerid, ZamienZnalezioneBindy(playerid, params));
    return 1;
}

YCMD:do(playerid, params[], help)
{ //do
    if ( help ) return CMDHelp(playerid, "S�u�y do opisu otoczenia, wygl�du czy sytuacji w jakiej znalaz�a si� nasza posta�.");
	
	if (isnull(params)) return CMDInfo(playerid, "U�ycie: /do [akcja]");
	
	Do(playerid, ZamienZnalezioneBindy(playerid, params));
    return 1;
}

YCMD:cb(playerid, params[], help)
{ //chat
    if ( help ) return CMDHelp(playerid, "CB radio pozwala si� komunikowa� z graczami, kt�rzy s� w samochodzie z zakupionym CB-radiem.");
	
	if (isnull(params)) return CMDInfo(playerid, "U�ycie: /cb [tekst]");
	
	CBRadio(playerid, ZamienZnalezioneBindy(playerid, params));
    return 1;
}

YCMD:w(playerid, params[], help)
{ //chat
    if ( help ) return CMDHelp(playerid, "Wysy�a prywatn� wiadomo�� do drugiego gracza.");
	
	new string[256], giveplayerid;
	
	if(sscanf(params, "us[256]", giveplayerid, string)) 
		return CMDInfo(playerid, "U�ycie: /w [ID/Nick] [wiadomo��]");
		
	PrywatnaWiadomosc(playerid, giveplayerid, ZamienZnalezioneBindy(playerid, string));
    return 1;
}

//end