//konta.pwn

//----------------------------------------------<< Source >>-------------------------------------------------//
//------------------------------------------[ Modu�: konta.pwn ]---------------------------------------------//
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

stock konta_Logowanie(playerid)
{
	new query[128];
    mysql_format(gMySQL, query, sizeof(query), "SELECT `UID`, `Pass`, `PassPos` FROM `"#TABLE_KONTA"` WHERE `Nick` = '%e' LIMIT 1", GetNick(playerid));

    inline qKonto()
    {
        new rows;
        
		cache_get_row_count(rows);
        if(rows) //Czy istnieje konto o podanym nicku
		{
			//Konto istnieje
			new logowania;
			
			cache_get_value_index_int(0, 0, PlayerInfo[playerid][pUID]);
			cache_get_value_index(0, 1, PlayerInfo[playerid][pPass], PASSWORD_HASH_LENGTH);
			cache_get_value_index_int(0, 2, PlayerInfo[playerid][pPassPos]);
			
			inline iLogowanie( pid, dialogid, response, listitem, string:inputtext[] ) 
			{
				#pragma unused pid, dialogid, listitem
				if(response) // Zaloguj/Anuluj
				{
					//Sprawdzanie d�ugo�ci wpisanego has�a
					if(strlen(inputtext) < MIN_PASSWORD_LENGHT || strlen(inputtext) > MAX_PASSWORD_LENGHT)
					{
						ServerFail(playerid, "Has�o musi mie� od "#MIN_PASSWORD_LENGHT" do "#MAX_PASSWORD_LENGHT" znak�w.");
						Dialog_ShowCallback(playerid, using inline iLogowanie, DIALOG_STYLE_INPUT, "Logowanie", "Wcisnij zaloguj aby si� zalogowa�", "Zaloguj", "Wyjd�");
						return 1;
					}
					
					//Por�wnynwanie hase�
					if(CheckPassword(playerid, inputtext))
					{
						//Has�o prawid�owe
						CreateORM(playerid);
						konta_LoadAccount(playerid);
					}
					else
					{
						//Has�o nieprawid�owe
						if(logowania != LOGIN_TRIES)
						{
							ServerInfoF(playerid, "Z�e has�o! pozosta�%s %d pr�b%s", ((logowania == LOGIN_TRIES-1) ? ("a") : ("y")), LOGIN_TRIES-logowania, ((logowania == LOGIN_TRIES-1) ? ("a") : ("y")) );
							logowania++;
							Dialog_ShowCallback(playerid, using inline iLogowanie, DIALOG_STYLE_INPUT, "Logowanie", "Wcisnij zaloguj aby si� zalogowa�", "Zaloguj", "Wyjd�");
						}
						else
						{
							ServerInfo(playerid, "Przekroczy�e� dozwolon� ilo�� z�ych logowa�. Zostajesz wyrzucony z serwera.");
							Log(LoginLog, WARNING, "%s przekroczyl limit zlych hasel ("#LOGIN_TRIES"), zostal skickowany. IP: %s", GetNick(playerid), GetIp(playerid));
							KickEx(playerid);
						}
					}
				}
				else
				{
					//Anulowanie logowania
					ServerInfo(playerid, "Wyszed�e� z serwera.");
					KickEx(playerid);
				}
			}
			Dialog_ShowCallback(playerid, using inline iLogowanie, DIALOG_STYLE_INPUT, "Logowanie", "Wcisnij zaloguj aby si� zalogowa�", "Zaloguj", "Wyjd�");
        }
        else 
		{
            //Konto nie istnieje - rejestracja
			konto_Rejestracja(playerid);
        }
    }
    mysql_pquery_inline(gMySQL, query, using inline qKonto, "");
	return 1;
}

stock konto_Rejestracja(playerid)
{
	//Dialog 2 - rejestracja
	inline iRejestracja(pid, dialogid, response, listitem, string:inputtext[])
	{ 
		#pragma unused pid, dialogid, listitem
		if(response)
		{
			if(strlen(inputtext) < MIN_PASSWORD_LENGHT || strlen(inputtext) > MAX_PASSWORD_LENGHT)
			{
				ServerFail(playerid, "Has�o musi mie� od "#MIN_PASSWORD_LENGHT" do "#MAX_PASSWORD_LENGHT" znak�w.");
				Dialog_ShowCallback(playerid, using inline iRejestracja, DIALOG_STYLE_INPUT, "Rejestracja", "Wci�nij rejestruj aby si� zarejestrowa�", "Rejestruj", "Wyjd�");
				return 1;
			}
			
			CreatePassword(playerid, inputtext);
			CreateORM(playerid);
			konta_CreateAccount(playerid);
		}
		else
		{
			ServerInfo(playerid, "Wyszed�e� z serwera.");
			KickEx(playerid);
		}
	}

	//Dialog 1 - regulamin
	inline iRegulamin(pid, dialogid, response, listitem, string:inputtext[])
	{ 
		#pragma unused pid, dialogid, listitem, inputtext
		if(response)
		{
			Dialog_ShowCallback(playerid, using inline iRejestracja, DIALOG_STYLE_INPUT, "Rejestracja", "Wci�nij rejestruj aby si� zarejestrowa�", "Rejestruj", "Wyjd�");
		}
		else
		{
			ServerInfo(playerid, "Odrzuci�e� regulamin, zostajesz wyrzucony z serwera!");
			KickEx(playerid);
		}
	}
	Dialog_ShowCallback(playerid, using inline iRegulamin, DIALOG_STYLE_MSGBOX, "Rejestracja", "Jeste� tu nowy, akceptuj regulamin", "Akceptuj", "Wyjd�");
	return 1;
}

stock Samouczek(playerid, rejestracja=true)
{
	//Dialog 2, przewodnik po mie�cie, samouczek dt. rozgrywki
	inline iPrzewodnik(pid, dialogid, response, listitem, string:inputtext[])
	{
		#pragma unused pid, dialogid, listitem, inputtext
		if(response)
		{
			//Samouczek dt. rozgrywki
		}
		else
		{
			//Koniec samouczka
			if(rejestracja)
				Dialog_Show(playerid, DIALOG_STYLE_MSGBOX, "Witamy na Mrucznik-RP!", "Gratulacje! Jeste� teraz pe�noprawnym cz�onkiem spo�eczno�ci M-RP", "Graj!", "");
		}
	}

	//Dialog 1, zasady RP
	inline iZasadyRP(pid, dialogid, response, listitem, string:inputtext[])
	{
		#pragma unused pid, dialogid, listitem, inputtext
		if(response)
		{
			//Zasady RP
		}
		else
		{
			Dialog_ShowCallback(playerid, using inline iPrzewodnik, DIALOG_STYLE_MSGBOX, "Samouczek", "Czy chcesz samouczek dotycz�cy rozgrywki na serwerze?\nJest on bardzo przydatny dla nowych graczy, pokazuje jak zarobi� oraz przedstawia taktyk� na pierwsze godziny rozgrywki.", "Tak", "Nie");
		}
	}
	
	Dialog_ShowCallback(playerid, using inline iZasadyRP, DIALOG_STYLE_MSGBOX, "Samouczek", "Czy chcesz samouczek dotycz�cy obowi�zuj�cych zasad RP na serwerze?", "Tak", "Nie");
	return 1;
}

CreatePassword(playerid, pass[])
{
	new password[PASSWORD_LENGTH],
		len = strlen(pass),
		ins = random(len);
	strcat(password, pass, sizeof(password));
	strins(password, PASSWORD_SALT, ins, sizeof(password));
	WP_Hash(PlayerInfo[playerid][pPass], PASSWORD_HASH_LENGTH, password);
	PlayerInfo[playerid][pPassPos] = ins+len;
}

CheckPassword(playerid, wpisane[])
{
	new tmp[PASSWORD_LENGTH], password[PASSWORD_HASH_LENGTH], ins = abs(PlayerInfo[playerid][pPassPos]-strlen(wpisane));
	strcat(tmp, wpisane, sizeof(tmp));
	strins(tmp, PASSWORD_SALT, ins, sizeof(tmp));
	WP_Hash(password, PASSWORD_HASH_LENGTH, tmp);
	 
	if(strcmp(PlayerInfo[playerid][pPass], password, false ) == 0 && !isnull(PlayerInfo[playerid][pPass]))
	{
		return 1;
	}
	else
	{
		Log(LoginLog, WARNING, "%s podal z�e has�o. IP: %s", GetNick(playerid), GetIp(playerid));
		return 0;
	}
}

//------------------<[ MySQL: ]>--------------------
stock static CreateORM(playerid)
{
	new ORM:id = PlayerInfo[playerid][pORM] = orm_create(TABLE_KONTA);
	new ORM:stat = PlayerInfo[playerid][pStatystyki] = orm_create(TABLE_KONTA_STATYSTYKI);
	
	//------------------------[ Konta ]----------------------------------------------
	//Must have
	orm_addvar_int(id, PlayerInfo[playerid][pUID], "UID");
	orm_addvar_string(id, PlayerInfo[playerid][pNick], MAX_PLAYER_NAME, "Nick");
	orm_addvar_string(id, PlayerInfo[playerid][pPass], PASSWORD_HASH_LENGTH, "Pass");
	orm_addvar_int(id, PlayerInfo[playerid][pPassPos], "PassPos");
	orm_addvar_int(id, PlayerInfo[playerid][pOnline], "Online");
	
	//Og�lne:
	orm_addvar_int(id, PlayerInfo[playerid][pLevel], "Level");
	orm_addvar_int(id, PlayerInfo[playerid][pRespekt], "Respekt");
	orm_addvar_int(id, PlayerInfo[playerid][pKP], "KP");
	orm_addvar_int(id, PlayerInfo[playerid][pWiek], "Wiek");
	orm_addvar_int(id, PlayerInfo[playerid][pRasa], "Rasa");
	orm_addvar_int(id, PlayerInfo[playerid][pSkin], "Skin");
	
	//Ustawienia:
	orm_addvar_int(id, PlayerInfo[playerid][pSpawn], "Spawn");
	//orm_addvar_int(id, PlayerInfo[playerid][pDoorSettings], "DoorSettings");
	//orm_addvar_int(id, PlayerInfo[playerid][pDoorKey], "DoorKey");
	orm_addvar_int(id, PlayerInfo[playerid][pBitUstawienia], "BitUstawienia");
	
	//Warto�ciowe:
	orm_addvar_int(id, PlayerInfo[playerid][pMC], "MrucznikCoins");
	orm_addvar_int(id, PlayerInfo[playerid][pHajs], "Hajs");
	orm_addvar_int(id, PlayerInfo[playerid][pBank], "Bank");
	
	//Kary:
	orm_addvar_int(id, PlayerInfo[playerid][pWarn], "Warn");
	orm_addvar_int(id, PlayerInfo[playerid][pAJ], "AJ");
	
	//Prace:
	orm_addvar_int(id, PlayerInfo[playerid][pFrakcja], "Frakcja");
	orm_addvar_int(id, PlayerInfo[playerid][pOrganizacja], "Organizacja");
	orm_addvar_int(id, PlayerInfo[playerid][pRanga], "Ranga");
	orm_addvar_int(id, PlayerInfo[playerid][pPraca], "Praca");
	
	//Przywileje:
	orm_addvar_int(id, PlayerInfo[playerid][pAdmin], "Admin");
	
	//Przest�pstwa
	orm_addvar_int(id, PlayerInfo[playerid][pWL], "WantedLevel");
	
	//Pozycja i HP
	orm_addvar_int(id, PlayerInfo[playerid][pHP], "Health");
	orm_addvar_int(id, PlayerInfo[playerid][pArmor], "Armor");
	orm_addvar_float(id, PlayerInfo[playerid][pX], "X");
	orm_addvar_float(id, PlayerInfo[playerid][pY], "Y");
	orm_addvar_float(id, PlayerInfo[playerid][pZ], "Z");
	orm_addvar_float(id, PlayerInfo[playerid][pA], "A");
	orm_addvar_int(id, PlayerInfo[playerid][pInt], "Interior");
	orm_addvar_int(id, PlayerInfo[playerid][pVW], "VirtualWorld");
	
	orm_setkey(id, "UID");
	
	//------------------------[ Statystyki ]----------------------------------------------
	orm_addvar_int(stat, PlayerInfo[playerid][pCzasOnline], "CzasOnline");
}

stock konta_DestroyORM(playerid)
{
	orm_destroy(PlayerInfo[playerid][pORM]);
	orm_destroy(PlayerInfo[playerid][pStatystyki]);
}

stock konta_CreateAccount(playerid)
{
	inline Create()
	{
		ServerInfoF(playerid, "Poprawnie stworzono i zalagowano konto, UID: %d", PlayerInfo[playerid][pUID]);
		OnPlayerRegister(playerid);
		Samouczek(playerid);
	}
	orm_insert_inline(PlayerInfo[playerid][pORM], using inline Create, "");
	orm_insert(PlayerInfo[playerid][pStatystyki]);
	return 1;
}

stock konta_SaveAccount(playerid)
{
	orm_update(PlayerInfo[playerid][pORM]);
	orm_update(PlayerInfo[playerid][pStatystyki]);
	return 1;
}

stock konta_LoadAccount(playerid)
{
	inline Load()
	{
		ServerInfoF(playerid, "Poprawnie za�adowano i zalagowano konto, UID: %d", PlayerInfo[playerid][pUID]);
		OnPlayerLogin(playerid);
	}
	orm_select_inline(PlayerInfo[playerid][pORM], using inline Load, "");
	orm_select(PlayerInfo[playerid][pStatystyki]);
	return 1;
}

//-----------------<[ Komendy: ]>-------------------
