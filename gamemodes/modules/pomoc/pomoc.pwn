//pomoc.pwn

//----------------------------------------------<< Source >>-------------------------------------------------//
//------------------------------------------[ Modu�: pomoc.pwn ]---------------------------------------------//
//Opis:
/*
	Pomoc kategorie:
		-Komendy
			-Wszystkie
			-Og�lne
			-Ustawienia
			-Praca
			-Frakcja
			-Admin
		-Tutoriale
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
//-----------------<[ Komendy: ]>-------------------
YCMD:pomoc(playerid, params[], help)
{
    if (help) return SendClientMessage(playerid, -1, "Pokazuje pomoc do okre�lonej komendy");
	
    if (isnull(params)) return SendClientMessage(playerid, -1, "U�ycie: /pomoc [komenda]");
    Command_ReProcess(playerid, params, true);
    return 1;
}

YCMD:komendy(playerid, params[], help)
{
    if ( help ) return SendClientMessage(playerid, -1, "Lists all the commands a player can use.");
    new 
        count = Command_GetPlayerCommandCount( playerid );
    for ( new i = 0; i != count; ++i) SendClientMessage( playerid, -1, Command_GetNext ( i, playerid ) );
    return 1;
}

//end