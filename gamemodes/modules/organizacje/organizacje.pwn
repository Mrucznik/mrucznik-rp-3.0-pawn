//organizacje.pwn

//----------------------------------------------<< Source >>-------------------------------------------------//
//---------------------------------------[ Modu�: organizacje.pwn ]------------------------------------------//
//Opis:
/*

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
// ----[ G��wne ]----
organizacje_Init()
{
	Iter_Init(wOrganizacji);
	
	strcat(Organizacja[0][oNazwa], "Groove Street Family", ORG_MAX_NAZWA);
	strcat(Organizacja[0][oSkrot], "GS", ORG_MAX_SKROT);
	strcat(Organizacja[0][oMotto], "Witaj w Groove Street Family, czarnuchu. Liczy si� tylko tw�j gang i wierno�� jego zasadom.", ORG_MAX_MOTD);
	Organizacja[0][oKolor] = HexToInt("00FF00");
	
	for(new i; i<ORG_ILOSC_RANG-1; i++)
	{
		format(oRanga[0][i], ORG_MAX_RANGA, "Ranga %d", i);	
	}
	format(oRanga[0][ORG_ILOSC_RANG-1], ORG_MAX_RANGA, "Lider");	
	
	return 1;
}

organizacje_OnPlayerLogin(playerid)
{
	if(PlayerInfo[playerid][pOrganizacja] != BRAK_ORGANIZACJI)
	{
		Iter_Add(wOrganizacji[PlayerInfo[playerid][pOrganizacja]], playerid);
	}
	return 1;
}

organizacje_OnPlayerDisconnect(playerid)
{
	if(PlayerInfo[playerid][pOrganizacja] != BRAK_ORGANIZACJI)
	{
		Iter_Remove(wOrganizacji[PlayerInfo[playerid][pOrganizacja]], playerid);
	}
	return 1;
}

// ----[ Chaty ]----
stock OrgMessage(id, kolor, text[])
{
	foreach(new i : wOrganizacji[id])
	{
		MruMessage(i, kolor, text);
	}
}

OrgRadio(playerid, text[])
{
	new string[512];
	format(string, sizeof(string), "** %s %s: %s **", oRanga[PlayerInfo[playerid][pOrganizacja]][PlayerInfo[playerid][pRanga]], GetNick(playerid), text);
	OrgMessage(playerid, ORG_RADIO_COLOR, string);
	return 1;
}

// ----[ Dialogi ]----
OrgRadioOOC(playerid, text[])
{
	new string[512];
	format(string, sizeof(string), "** (( %s %s[%d]: %s. )) **", oRanga[PlayerInfo[playerid][pOrganizacja]][PlayerInfo[playerid][pRanga]], GetNick(playerid), playerid, text);
	OrgMessage(playerid, ORG_RADIO_COLOR, string);
	return 1;
}

PanelOrganizacji(org)
{
	new string[512], motto[64], kolor = Organizacja[org][oKolor];
	strcat(motto, Organizacja[org][oMotto], sizeof(motto));
	format(string, sizeof(string), "Nazwa: {%06x}%s\nSkr�t: {%06x}%s\nMotto: {%06x}%s\nKolor: {%06x}%06x\nRangi\nUprawnienia\nInformacje\nDyplomacja\nPracownicy\nFinanse\nAwans organizacji", kolor, Organizacja[org][oNazwa], kolor, Organizacja[org][oSkrot], kolor, motto, kolor, kolor);
	safe_return string;
}

OrgPanelRangi(org, strona)
{
	new string[256];
	#pragma unused strona
	
	for(new i; i<ORG_ILOSC_RANG; i++)
	{
		strcat(string, oRanga[org][i], sizeof(string));
		if(i!=ORG_ILOSC_RANG-1) strcat(string, "\n", sizeof(string));
	}
	
	safe_return string;
}

OrgPanelUprawnienia(org)
{
	new string[256];
	
	//Levele organizacji 1-3
	if(Organizacja[org][oTyp] >= ORG_TYPE_PACZKA)
	{
		strcat(string, "Radio IC\nRadio OOC", sizeof(string));
	}
	if(Organizacja[org][oTyp] >= ORG_TYPE_BANDA)
	{
		//strcat(string, "\nPojazdy\nKomenda /napadnij", sizeof(string));
	}
	if(Organizacja[org][oTyp] >= ORG_TYPE_RODZINA)
	{
		//strcat(string, "\nKomenda /napad\nKomenda porwij\nDyplomacja", sizeof(string));
	}
	
	//Szajka/Gang/Mafia
	if(Organizacja[org][oTyp] >= ORG_TYPE_SZAJKA)
	{
		switch(Organizacja[org][oSpecjalnosc])
		{
			case 0: // Tutaj nazwa pracy
			{
			}
			case 1:
			{
			}
		}
	}
	else if(Organizacja[org][oTyp] >= ORG_TYPE_GANG)
	{
	}
	else if(Organizacja[org][oTyp] >= ORG_TYPE_MAFIA)
	{
	}
	
	//SzajkaX/GangX/MafiaX
	if(Organizacja[org][oTyp] >= ORG_TYPE_SZAJKA_X)
	{
	}
	else if(Organizacja[org][oTyp] >= ORG_TYPE_GANG_X)
	{
	}
	else if(Organizacja[org][oTyp] >= ORG_TYPE_MAFIA_X)
	{
	}

	safe_return string;
}

OrgPanelAwans(org)
{
	new string[256];
	#pragma unused org
	safe_return string;
}

//------------------<[ MySQL: ]>--------------------
//-----------------<[ Komendy: ]>-------------------
//-------------Niekt�re komendy przeniesone do modu�u frakcje.pwn-------------
YCMD:organizacja(playerid, params[], help)
{
	if(help)
	{
		//Pomoc
		return 1;
	}
	
	//Cia�o komendy:
	new org = PlayerInfo[playerid][pOrganizacja];
	new strona=0;
	
	inline iOrganizacja(pid, dialogid, response, listitem, string:inputtext[])
	{
		// --------------- Poziom 1 ---------------
		#pragma unused pid, dialogid, inputtext
		inline iPoziom2(pid2, dialogid2, response2, listitem2, string:inputtext2[])
		{
			// --------------- Poziom 2 ---------------
			#pragma unused pid2, dialogid2
			inline iPoziom3(pid3, dialogid3, response3, listitem3, string:inputtext3[])
			{
				// --------------- Poziom 3 ---------------
				#pragma unused pid3, dialogid3, listitem3
				
				if(response3)
				{
					switch(listitem)
					{
						case 4: //Ustawianie rangi
						{
							if(!isnull(inputtext))
							{
								format(oRanga[org][listitem2], 32, "%s", inputtext3);
								Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_LIST, "Panel organizacji -> rangi", OrgPanelRangi(org, strona), "Wybierz", "Wr��");
							}
							else
							{
								new tytul[32], text[64];
								format(tytul, sizeof(tytul), "Panel organizacji -> ranga %d", listitem2);
								format(text, sizeof(text), "Wpisz now� nazw� rangi %d (max 32 znaki)\n{FF0000}Ranga nie mo�e by� pusta!", listitem2);
								Dialog_ShowCallback(playerid, using inline iPoziom3, DIALOG_STYLE_INPUT, tytul, text, "Ustaw", "Wr��");
							}
						}
					}
				}
				else
				{
					switch(listitem)
					{
						case 4: //Rangi
						{
							Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_LIST, "Panel organizacji -> rangi", OrgPanelRangi(org, strona), "Wybierz", "Wr��");
						}
					}
				}
			}
			
			if(response2)
			{
				switch (listitem)
				{
					case 0: //Zmiana nazwy
					{
						format(Organizacja[org][oNazwa], 64, "%s", inputtext2);
						Dialog_ShowCallback(playerid, using inline iOrganizacja, DIALOG_STYLE_LIST, "Panel organizacji", PanelOrganizacji(org), "Wybierz", "Wr��");
					}
					case 1: //Zmiana skr�tu
					{
						format(Organizacja[org][oSkrot], 8, "%s", inputtext2);
						Dialog_ShowCallback(playerid, using inline iOrganizacja, DIALOG_STYLE_LIST, "Panel organizacji", PanelOrganizacji(org), "Wybierz", "Wr��");
					}
					case 2: //Zmiana motta
					{
						format(Organizacja[org][oMotto], 128, "%s", inputtext2);
						Dialog_ShowCallback(playerid, using inline iOrganizacja, DIALOG_STYLE_LIST, "Panel organizacji", PanelOrganizacji(org), "Wybierz", "Wr��");
					}
					case 3: //Zmiana koloru
					{
						if(IsColorHex(inputtext2))
						{
							Organizacja[org][oKolor] = HexToInt(inputtext2);
						}
						else
						{
							ServerFail(playerid, "Kolor powinien mie� co najmniej 6 znak�w (RRGGBB) oraz by� zapisany jako liczba w systemie szesnastkowym (cyfry 0-9 i litery A-F)!");
						}
						Dialog_ShowCallback(playerid, using inline iOrganizacja, DIALOG_STYLE_LIST, "Panel organizacji", PanelOrganizacji(org), "Wybierz", "Wr��");
					}
					case 4: //Rangi
					{
						new tytul[32], text[64];
						format(tytul, sizeof(tytul), "Panel organizacji -> ranga %d", listitem2);
						format(text, sizeof(text), "Wpisz now� nazw� rangi %d (max 32 znaki)", listitem2);
						Dialog_ShowCallback(playerid, using inline iPoziom3, DIALOG_STYLE_INPUT, tytul, text, "Ustaw", "Wr��");
					}
					case 5: //Uprawnienia
					{
						
					}
					case 6: //Informacje
					{
						Dialog_ShowCallback(playerid, using inline iOrganizacja, DIALOG_STYLE_LIST, "Panel organizacji", PanelOrganizacji(org), "Wybierz", "Wyjd�");
					}
					case 7: //Dyplomacja
					{
						switch(listitem2)
						{
							case 0: //Aktualne stosunki
							{
								Dialog_ShowCallback(playerid, using inline iPoziom3, DIALOG_STYLE_LIST, "Panel organizacji -> dyplomacja -> stosunki", "", "Wybierz", "Wr��");
							}
							case 1: //Dziennik dyplomatyczny
							{
								Dialog_ShowCallback(playerid, using inline iPoziom3, DIALOG_STYLE_LIST, "Panel organizacji -> dyplomacja -> dziennik", "", "Wybierz", "Wr��");
							}
							case 2: //Wypowiedz wojn�
							{
								Dialog_ShowCallback(playerid, using inline iPoziom3, DIALOG_STYLE_LIST, "Panel organizacji -> dyplomacja -> wojna", "", "Wybierz", "Wr��");
							}
							case 3: //Zaproponuj sojusz
							{
								Dialog_ShowCallback(playerid, using inline iPoziom3, DIALOG_STYLE_LIST, "Panel organizacji -> dyplomacja -> sojusz", "", "Wybierz", "Wr��");
							}
						}
					}
					case 8: //Lista pracownik�w
					{
						if(listitem2 >= 0 && listitem2 <= 10)
						{
							//Wyb�r co zrobi� w pracownikiem
							
						}
						else
						{
							//Nast�pna strona
							
						}
					}
					case 9: //Finanse
					{
						switch(listitem2)
						{
							case 0: //Sk�adki
							{
								
							}
							case 1: //Sejf organizacji
							{
								
							}
						}
					}
					case 10: // Awans organizacji
					{
						
					}
					case 11: //Spawny (tylko dla organizacji z wi�cej ni� 1 spawnem)
					{
						
					}
				}
			}
			else
			{
				Dialog_ShowCallback(playerid, using inline iOrganizacja, DIALOG_STYLE_LIST, "Panel organizacji", PanelOrganizacji(org), "Wybierz", "Wr��");
			}
		}
		
		if(response)
		{
			switch(listitem)
			{
				case 0: //Zmiana nazwy
				{
					Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_INPUT, "Panel organizacji -> nazwa", "Wpisz now� nazw� organizacji (max 64 znaki)", "Zmie�", "Wr��");
				}
				case 1: //Zmiana skr�tu
				{
					Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_INPUT, "Panel organizacji -> skr�t", "Wpisz nowy skr�t organizacji (max 8 znak�w)", "Zmie�", "Wr��");
				}
				case 2: //Zmiana motta
				{
					Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_INPUT, "Panel organizacji -> motto", "Wpisz nowe motto organizacji (max 128 znak�w)", "Zmie�", "Wr��");
				}
				case 3: //Zmiana koloru
				{
					Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_INPUT, "Panel organizacji -> kolor", "Wpisz nowy kolor organizacji w formacie RGB Hex", "Zmie�", "Wr��");
				}
				case 4: //Rangi
				{
					Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_LIST, "Panel organizacji -> rangi", OrgPanelRangi(org, strona), "Wybierz", "Wr��");
				}
				case 5: //Uprawnienia
				{
					Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_LIST, "Panel organizacji -> uprawnienia", OrgPanelUprawnienia(org), "Wybierz", "Wr��");
				}
				case 6: //Informacje
				{
					Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_MSGBOX, "Panel organizacji -> informacje", "Informacje o frakcji", "Wr��", "");
				}
				case 7: //Dyplomacja
				{
					Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_LIST, "Panel organizacji -> dyplomacja", "Dziennik dyplomatyczny\nAktualne stosunki\nWypowiedz wojn�\nZaproponuj sojusz", "Wybierz", "Wr��");
				}
				case 8: //Lista pracownik�w
				{
					Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_LIST, "Panel organizacji -> pracownicy", "Pracownik1\nPracownik2\n...\nNast�pna strona", "Wybierz", "Wr��");
				}
				case 9: //Finanse
				{
					Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_LIST, "Panel organizacji -> finanse", "Sk�adki\nSejf organizacji", "Wybierz", "Wr��");
				}
				case 10: // Awans organizacji
				{
					Dialog_ShowCallback(playerid, using inline iPoziom2, DIALOG_STYLE_MSGBOX, "Panel organizacji -> awans", OrgPanelAwans(org), "Wybierz", "Wr��");
				}
			}
		}
	}
	
	Dialog_ShowCallback(playerid, using inline iOrganizacja, DIALOG_STYLE_LIST, "Panel organizacji", PanelOrganizacji(org), "Wybierz", "Wyjd�");
	return 1;
}

//---[ Radio organizacji ]---
YCMD:f(playerid, params[], help)
{
    if(help)
	{
		//Pomoc
		return 1;
	}
	if(isnull(params)) 
	{
		CMDInfo(playerid, "U�ycie: /f [tekst]");
		return 1;
	}
	
	//Cia�o komendy:
	OrgRadio(playerid, ZamienZnalezioneBindy(playerid, params));
    return 1;
}

YCMD:fo(playerid, params[], help)
{
    if(help)
	{
		//Pomoc
		return 1;
	}
	if(isnull(params)) 
	{
		CMDInfo(playerid, "U�ycie: /fo [tekst]");
		return 1;
	}
	
	//Cia�o komendy:
	OrgRadioOOC(playerid, ZamienZnalezioneBindy(playerid, params));
    return 1;
}

//end