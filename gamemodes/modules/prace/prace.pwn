//prace.pwn

//----------------------------------------------<< Source >>-------------------------------------------------//
//------------------------------------------[ Modu�: prace.pwn ]---------------------------------------------//
//Opis:
/*

*/
//Adnotacje:
/*
	Prace do stworzenia:
	 Legalne prace:
		-Mechanik							0%
			-Naprawa aut
			-Tankowanie aut
			-Tuning aut
			-Ulepszenia aut
		-Prawnik							0%
			-Zbijanie WL
				-Przy wi�kszym skillu mo�esz zbija� wy�szy WL
			-Czyszczenie kartotek
			-Uwalnianie z wi�zienia
				-Za zgod� od PD'ka
				-Zgoda uprawnia do uwolnienia 1,2 i 3 wi�ni�w przy skilach (odpowiednio) 1,3,5
			-Kupowanie mo�liwo�ci wyj�cia za kaucja (gdy kupisz mo�esz wyj�� z paki za kaucj�)
				-Im wy�szy skill tym wi�cej wa�ne wyj�cie
		-�owca Nagr�d						0%
			-�apanie przest�pc�w z WL
				-Im wy�szy skill tym wi�ksze WL do z�apania = wi�ksze nagrody
			-
		-Busiarz							0%
			-Je�d�enie busami
			-Wy�szy skill - jazda tax�wk�
			-Mistrzowski skill - taxi ka�dym autem
		-Bokser(instruktor walki)			0%
		-Roznosiciel						0%
		-Trucker							0%
	 Nielegalne prace:
		-Diler broni						0%
			-Zbieranie materia��w z fabryki (kursy)
			-Sprzeda� klamek
				-Im wy�szy skil tym lepsze klamy
		-Przemytnik							0%
			-Kradzie� materia��w ze statku NG (kursy)
			-Sprzeda� �adunk�w wybuchowych
			-Sprzeda� wytrych�w
			-Sprzeda� wszystkich innych przedmiot�w przest�pczych opr�cz broni
		-Diler narkotyk�w					0%
			-Sprzeda� narkotyk�w (w trakcie wymy�lania)
		-Z�odziej							0%
			-Kradzie� kieszonkowa
			-Kradzie� aut
			-W�amania do dom�w
			-W�amania do biznes�w
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
stock prace_Init()
{
	return 1;
}

stock prace_Exit()
{
	return 1;
}

stock PracaSpawn(playerid)
{
	new job = PlayerInfo[playerid][pPraca];
	SetPlayerPos(playerid, SpawnPrac[job][0], SpawnPrac[job][1], SpawnPrac[job][2]);
	SetPlayerFacingAngle(playerid, SpawnPrac[job][3]);
	return 1;
}

stock ePrace:ZnajdzPracePozycja(playerid)
{
	for(new ePrace:i; i<ePrace; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, INVITE_RANGE, InvitePlace[i][0], InvitePlace[i][1], InvitePlace[i][2]))
			return i;
	}
	return ePrace:BRAK_PRACY;
}

stock PracaDolacz(playerid)
{
	new ePrace:job=ZnajdzPracePozycja(playerid);
	
	if(job)
	{
		inline iDialog(pid, dialogid, response, listitem, string:inputtext[])
		{
			#pragma unused pid, dialogid, listitem, inputtext
			if(response)
				PracaZatrudnij(playerid, job);
		}
		new tytul[32], text[256];
		format(tytul, sizeof(tytul), "Praca - %s", NazwyPrac[job]);
		format(text, sizeof(text), "Witaj %s! A wi�c chcesz zosta� %s?\nAby to zrobi�, musisz podpisa� 5-cio godzinny kontrakt.\nNa czas trwania kontraktu nie b�dziesz m�g� si� zwolni� ani zatrudni� w innej pracy.\nNaci�nij \"Podpisz\" aby podpisa� kontrakt i dosta� t� prac�.", GetNick(playerid), NazwyPrac2[job]);
		Dialog_ShowCallback(playerid, using inline iDialog, DIALOG_STYLE_MSGBOX, tytul, text, "Podpisz", "Anuluj");
	}
	else
	{
		ServerFail(playerid, "W pobli�u nie ma �adnej pracy, do kt�rej mo�na by do��czy�.");
	}
	return 1;
}

stock PracaZatrudnij(playerid, ePrace:job)
{
	ServerInfoF(playerid, "Gratulacje, jeste� teraz %s! Powodzenia w zarabianiu pieni�dzy w twoim nowym fachu.", NazwyPrac2[job]);
	PlayerInfo[playerid][pPraca] = job;
	PracaInfo[playerid][pKontrakt] = 5;
	
	DajUprawnieniaPracy(playerid, job);
	return 1;
}

stock PracaZwolnij(playerid)
{	
	ZabierzUprawnieniaPracy(playerid, PlayerInfo[playerid][pPraca]);
	return 1;
}

stock DajUprawnieniaPracy(playerid, ePrace:job)
{
	#pragma unused playerid
	switch(job)
	{
		case MECHANIK:
		{
			//Daj uprawnie� mechanika, np. uprawnienia do komend
		}
		case PRAWNIK:
		{
		}
		case BUSIARZ:
		{
		}
		case LOWCA:
		{
		}
		case TRUCKER:
		{
		}
		case DILER_BRONI:
		{
		}
		case DILER_DRAGOW:
		{
		}
		case PRZEMYTNIK:
		{
		}
		case ZLODZIEJ:
		{
		}
	}
}

stock ZabierzUprawnieniaPracy(playerid, ePrace:job)
{
	switch(job)
	{
		case MECHANIK:
		{
			//Zabranie uprawnie� mechanika, np. uprawnienia do komend
		}
		case PRAWNIK:
		{
		}
		case BUSIARZ:
		{
		}
		case LOWCA:
		{
		}
		case TRUCKER:
		{
		}
		case DILER_BRONI:
		{
		}
		case DILER_DRAGOW:
		{
		}
		case PRZEMYTNIK:
		{
		}
		case ZLODZIEJ:
		{
		}
	}
}

//------------------<[ MySQL: ]>--------------------
//-----------------<[ Komendy: ]>-------------------
YCMD:dolacz(playerid, params[], help)
{
	if(help) return SendClientMessage(playerid, -1, "Pozwala zatrudni� si� w pracy.");

	if(PlayerInfo[playerid][pPraca] == 0)
	{
		PracaDolacz(playerid);
	}
	else
	{
		ServerFail(playerid, "Posiadasz ju� prac�, najpierw musisz si� zwolni�, aby zatrudni� si� w innej.");
	}
	return 1;
}

//end