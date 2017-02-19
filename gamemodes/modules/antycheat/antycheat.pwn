//MODULE_NAME.pwn

//----------------------------------------------<< Source >>-------------------------------------------------//
//---------------------------------------[ Modu�: MODULE_NAME.pwn ]------------------------------------------//
//Opis:
/*
	Antyczit podzielony na sekcje/modu�y. Zarz�dzaniem nim poprzez funkcje, nie odwo�ujemy si� raczej do zmiennych zadeklarowanych w module.
	Ka�d� sekcj� mo�na wy��czy� czasowo lub okre�li� dla niej wyj�tek. 
	Je�eli sekcja jest wy��czona antycheat przez okreslony czas nie b�dzie reagowa� na wykryte niezgodno�ci z danej sekcji.
	Je�eli sekcja posiada wyj�tek/wyj�tki, jedna wykryta niezgodno�� usunie/odejmie jeden wyj�tek.
	
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

antycheat_Init()
{
	return 1;
}

//-----[ AC na �ycie ]------
stock AC_Health(playerid, Float:oldhealth, Float:newhealth)
{
	if( newhealth-oldhealth > 0) //wyj�tki dla niezgodno�ci
	{
		if(AC_Check(playerid, AC_HP))
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else
		return 0;
}

//-----[ AC na pancerz ]------
stock AC_Armor(playerid, Float:oldarmor, Float:newarmor)
{
	if( newarmor-oldarmor > 0) //wyj�tki dla niezgodno�ci
	{
		if(AC_Check(playerid, AC_ARMOR))
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else
		return 0;
}

//-----[ AC na hajs ]------
stock AC_Money(playerid)
{
	if(AC_Check(playerid, AC_MONEY))
	{
		if(PlayerInfo[playerid][pHajs] != GetPlayerMoney(playerid))
		{
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid, PlayerInfo[playerid][pHajs]);
			return 1;
		}
		else
			return 0;
	}
	else
		return 0;
}

//-----[ AC na bro� ]------
stock AC_Weapon(playerid)
{
	if(AC_Check(playerid, AC_WEAPON))
	{
		if( true ) //warunki na czita
		{
			//dzia�ania
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else
		return 0;
}

//---------------------------------------------------
//---------------[ SILNIK ANTYCZITA ]----------------
//---------------------------------------------------
//-----[ Sprawdzanie stanu sekcji ]------
stock AC_Check(playerid, AC_MODULES:module)
{
	if(IsACDisabled(playerid, module))
	{
		ServerInfo(playerid, "AC Disabled");
		return 0;
	}
	else
	{
		if(IsACExpected(playerid, module))
		{
			ACExpectationDetected(playerid, module);
			ServerInfo(playerid, "AC Expectation");
			return 0;
		}
		else
		{
			return 1;
		}
	}
}

//-----[ Funkcje w��czania sekcji antycheata ]------
stock AC_Disable(playerid, AC_MODULES:module=AC_ALL, time=-1 )
{
	if(module==AC_ALL)
	{
		for(new AC_MODULES:i; i<AC_MODULES; i++)
		{
			ACstate[playerid][i] = true;
			if(time>0)
			{
				SetTimerEx("timer_ACDisableTime", time, 0, "dd", playerid, _:i);
			}
			else if (time==-1)
			{
				SetTimerEx("timer_ACDisableTime", AC_DISABLE_TIMES[AC_ALL], 0, "dd", playerid, _:i);
			}
		}
	}
	else
	{
		ACstate[playerid][module] = true;
		if(time>0)
		{
			SetTimerEx("timer_ACDisableTime", time, 0, "dd", playerid, _:module);
		}
		else if (time==-1)
		{
			SetTimerEx("timer_ACDisableTime", AC_DISABLE_TIMES[module], 0, "dd", playerid, _:module);
		}
	}
	return 1;
}

stock AC_Enable(playerid, AC_MODULES:module)
{
	ACstate[playerid][module] = false;
	return 1;
}

stock IsACDisabled(playerid, AC_MODULES:module)
{
	return ACstate[playerid][module];
}

//-----[ Funkcje oczekiwa� antycheata ]------
stock ACExpect(playerid, AC_MODULES:module, times=1, expirationtime=AC_ExpirationTime)
{
	ACexpect[playerid][module] += times;
	if(expirationtime>0) SetTimerEx("timer_ACExpirationOfExpectation", expirationtime, 0, "ddd", playerid, _:module, ACexpect[playerid][module]);
	return 1;
}

stock IsACExpected(playerid, AC_MODULES:module)
{
	if(ACexpect[playerid][module] > 0)
		return 1;
	else 
		return 0;
}

stock ACExpectationDetected(playerid, AC_MODULES:module)
{
	ACexpect[playerid][module]--;
	return 1;
}

//-----[ Funkcje warning�w antycheata ]------
/*stock ACWarning(playerid, AC_MODULES:module)
{
	ACWarning[playerid][module]++;
	if(ACWarning[playerid][module] > AC_MAX_WARNINGS[module])
	{
		ACReport(playerid, module);
	}
}

ACReport(playerid, AC_MODULES:module)
{
	
}*/

//-----------------<[ Timery: ]>--------------------
public timer_ACDisableTime(playerid, AC_MODULES:module)
{
	AC_Enable(playerid, AC_MODULES:module);
}

public timer_ACExpirationOfExpectation(playerid, AC_MODULES:module, value) //czas wyga�ni�cia oczekiwania
{
	if(ACexpect[playerid][module] == value && value > 0)
	{
		ACExpectationDetected(playerid, AC_MODULES:module);
	}
}

//------------------<[ MySQL: ]>--------------------
//-----------------<[ Komendy: ]>-------------------

//end