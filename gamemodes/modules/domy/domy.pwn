//domy.pwn

//----------------------------------------------<< Source >>-------------------------------------------------//
//------------------------------------------[ Modu�: domy.pwn ]----------------------------------------------//
//Opis:
/*
	Co zawiera SYSTEM DOM�W:
		- Kupowanie domu
			- Licytacja dom�w (mo�na te� offline)
		- Sprzedawanie domu
		- Wymiana domu
		- Zarz�dzanie dodatkami domu
			- Nat�enie �wiat�a
			- Brawa �wiat�a (pogoda)
		- Meblowanie domu
			- Stawianie mebli
			- Kupowanie mebli
				- Od systemu
			- Sprzedawanie mebli za p� ceny
			- Edytowanie mebli
			- Stawianie specjalnych mebli (dodaj�cych funkcjonalno�ci do domu)
				- Sejf
				- Zbrojownia
				- Szafa
				- Radio/G�o�niki
		- Stawianie �cian i sufit�w i pod��g
			- Aby edytowa� dom trzeba wyrobi� patent budowlany w DMV
			- Stawianie �/s/p
			- Kupowanie �/s/p
			- Sprzedawanie �/s/p
			- Edytowanie �/s/p
		- Zamykanie drzwi domu
		- Dawanie kluczy do domu
		- Wygasanie domu po miesi�cu nieaktywno�ci
			- 5 dni przed wyga�ni�ciem rozpoczyna si� licytacja domu w kt�rej gracze mog� bra� udzia� (je�eli gracz wejdzie licytacja przepada)
		- Limity
			- Limit maksymalnej ilo�ci pomieszcze� (/wejdz, /wyjdz)
			- Limit maksymalnej powierzchni jak� mo�na umeblowa� (powinna by� taka sama jak gabaryty domu na zewn�trz)
		- Premium
			- Mo�liwo�� zakupienia dodatkowej powierzchni zawartej w innym pomieszczeniu
			- Mo�liwo�� zakupienia r�nych specjalnych pomieszcze� w innym pomieszczeniu (takich jak basen, strzelnica, piwnica itd)
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


//------------------<[ MySQL: ]>--------------------
stock domy_ORM(id)
{
	new ORM:oid = Dom[id][ORM] = orm_create(TABLE_DOMY);
	
	orm_addvar_int(oid, Dom[id][ID], "ID");
	orm_addvar_int(oid, Dom[id][Budynek], "Budynek");
	orm_addvar_int(oid, Dom[id][Cena], "Cena");
	orm_addvar_int(oid, Dom[id][Wlasciciel], "Cena");
	//orm_addvar_string(oid, Dom[id][Nazwa], MAX_BUDYNEK_NAME, "Nazwa");
	
	orm_setkey(oid, "ID");
}

//-----------------<[ Komendy: ]>-------------------
/*YCMD:stworzdrzwi(playerid, params[], help)
{
    if(help)
	{
		//Pomoc
		return 1;
	}
	
	//Lista parametr�w:
	new Float:x, Float:y, Float:z, Float:a, p, nazwa[MAX_BUDYNEK_NAME];
	
	if(sscanf(params, "dffffs["#MAX_POMIESZCZENIE_NAME"]", p, x, y, z, a, nazwa)) 
	{
		CMDInfo(playerid, "U�ycie: /stworzdrzwi [pomieszczenie] [x] [y] [z] [a] [nazwa]");
		return 1;
	}
	else
	{
		//Cia�o komendy:
		new Float:gx, Float:gy, Float:gz, Float:ga;
		GetPlayerPos(playerid, gx, gy, gz);
		GetPlayerFacingAngle(playerid, ga);
		StworzDrzwi(IloscDrzwi++, nazwa, gx, gy, gz, ga, "Wejscie", 1239, 1, x, y, z, a, "Wyjscie", 1239, p, false, playerid);
		return 1;
	}
}*/

//end