stock PanelBudynkow(playerid, domy)
{
	/*
	Zarz�dzanie interiorami:
	Lista budynk�w
		1. Edytuj
			Lista p�l do edytowania + edytuj wszystko
		2. Powi�zane pomieszczenia
			Lista powi�zanych pomieszcze�
				1. Edytuj
					Lista p�l do edytowania + edytuj wszystko
				2. Powi�zane drzwi
					Lista drzwi
						1. Tryb edycji
						2. Usu�
				3. Usu�
		3. Usu�
	*/
	
	new drzwiID, pomieszczenieID, budynekID;
	inline iDialog0(pid, dialogid, response, listitem, string:inputtext[])
	{
		#pragma unused pid, dialogid, inputtext
		inline iDialog1(pid1, dialogid1, response1, listitem1, string:inputtext1[])
		{
			new bool:changedB=false;
			#pragma unused pid1, dialogid1, inputtext1
			inline iDialog2(pid2, dialogid2, response2, listitem2, string:inputtext2[])
			{
				new bool:changedP=false;
				#pragma unused pid2, dialogid2, inputtext2
				inline iDialog3(pid3, dialogid3, response3, listitem3, string:inputtext3[])
				{
					new bool:changedD=false;
					#pragma unused pid3, dialogid3
					inline iDialog4(pid4, dialogid4, response4, listitem4, string:inputtext4[])
					{
						#pragma unused pid4, dialogid4, inputtext4
						inline iDialog5(pid5, dialogid5, response5, listitem5, string:inputtext5[])
						{
							#pragma unused pid5, dialogid5
							inline iDialog6(pid6, dialogid6, response6, listitem6, string:inputtext6[])
							{
								#pragma unused pid6, dialogid6, listitem6
								//Dialog 6
								if(response6)
								{
									switch(listitem5)
									{
										case 0://Nazwa
										{
											if(!isnull(inputtext6))
												format(Drzwi[drzwiID][Nazwa], MAX_POMIESZCZENIE_NAME, "%s", inputtext6);
											else
												ServerFail(playerid, "Nazwa musi zawiera� przynajmniej 1 znak");
										}
										case 1://X,Y,Z,A
										{
											if(sscanf(inputtext6, "ffff", Drzwi[drzwiID][inX], Drzwi[drzwiID][inY], Drzwi[drzwiID][inZ], Drzwi[drzwiID][inA]))
											{
												ServerFail(playerid, "Niepoprawny format");
											}
										}
										case 2://3DText
										{
											if(!isnull(inputtext6))
												format(Drzwi[drzwiID][in3DTextString], MAX_POMIESZCZENIE_NAME, "%s", inputtext6);
											else
												ServerFail(playerid, "3DText musi zawiera� przynajmniej 1 znak");
										}
										case 3://Pickup
										{
											Drzwi[drzwiID][inPickupModel] = strval(inputtext6);
										}
										case 4://Pomieszczenie
										{
											Drzwi[drzwiID][inPomieszczenie] = strval(inputtext6);
										}
										case 5://X,Y,Z,A
										{
											if(sscanf(inputtext6, "ffff", Drzwi[drzwiID][outX], Drzwi[drzwiID][outY], Drzwi[drzwiID][outZ], Drzwi[drzwiID][outA]))
											{
												ServerFail(playerid, "Niepoprawny format");
											}
										}
										case 6://3DText
										{
											if(!isnull(inputtext6))
												format(Drzwi[drzwiID][out3DTextString], MAX_POMIESZCZENIE_NAME, "%s", inputtext6);
											else
												ServerFail(playerid, "3DText musi zawiera� przynajmniej 1 znak");
										}
										case 7://Pickup
										{
											Drzwi[drzwiID][outPickupModel] = strval(inputtext6);
										}
										case 8://Pomieszczenie
										{
											Drzwi[drzwiID][outPomieszczenie] = strval(inputtext6);
										}
										case 9://Lock
										{
											Drzwi[drzwiID][lock] = strval(inputtext6);
										}
										case 10://Usu� drzwi
										{
											interiory_DeleteDrzwi(drzwiID);
											ServerInfoF(playerid, "Drzwi %d usuni�te", drzwiID);
										}
									}
									if(listitem5 == 10)
										Dialog_ShowCallback(playerid, using inline iDialog4, DIALOG_STYLE_LIST, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> powiazane drzwi"), ListaDrzwi(pomieszczenieID), "Wybierz", "Wr��");
									else
									{
										Dialog_ShowCallback(playerid, using inline iDialog5, DIALOG_STYLE_LIST, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> edycja"), DrzwiEdycjaDialog(drzwiID), "Wybierz", "Wr��");
										changedD=true;
									}
								}
								else//nie response dialog 6
								{
									Dialog_ShowCallback(playerid, using inline iDialog5, DIALOG_STYLE_LIST, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> edycja"), DrzwiEdycjaDialog(drzwiID), "Wybierz", "Wr��");
								}
							}
							//Dialog 5
							if(response5)
							{
								if(listitem3 == 0)
								{
									switch(listitem4)
									{
										case 0://Nazwa - wybrano
										{
											if(!isnull(inputtext5))
												format(Pomieszczenia[pomieszczenieID][Nazwa], MAX_POMIESZCZENIE_NAME, "%s", inputtext5);
											else
												ServerFail(playerid, "Nazwa musi zawiera� przynajmniej 1 znak");
										}
										case 1://Budynek - wybrano
										{
											Pomieszczenia[pomieszczenieID][Budynek] = strval(inputtext5);
										}
										case 2://Interior - wybrano
										{
											Pomieszczenia[pomieszczenieID][Interior] = strval(inputtext5);
										} 
										case 3://Oswietlenie - wybrano
										{
											Pomieszczenia[pomieszczenieID][Oswietlenie] = strval(inputtext5);
										}
										case 4://Pogoda - wybrano
										{
											Pomieszczenia[pomieszczenieID][Pogoda] = strval(inputtext5);
										}
										case 5://Muzyka - wybrano
										{
											format(Pomieszczenia[pomieszczenieID][Muzyka], MAX_POMIESZCZENIE_NAME, "%s", inputtext5);
										}
									}
									changedP=true;
									Dialog_ShowCallback(playerid, using inline iDialog4, DIALOG_STYLE_LIST, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> edytuj"), PomieszczeniaEdycjaDialog(pomieszczenieID), "Wybierz", "Wr��");
								}
								else//listitem3=1 edycja usuwanie drzwi
								{
									switch(listitem5)
									{
										case 0://Nazwa
										{
											Dialog_ShowCallback(playerid, using inline iDialog6, DIALOG_STYLE_INPUT, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> Nazwa"), "Wpisz now� nazw�: (max "#MAX_DRZWI_NAME" znak�w)", "Zmie�", "Anuluj");
										}
										case 1://X,Y,Z,A
										{
											Dialog_ShowCallback(playerid, using inline iDialog6, DIALOG_STYLE_INPUT, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> Pozycja"), "Wpisz now� pozycj� (oddzielana spacjami):", "Zmie�", "Anuluj");
										}
										case 2://3DText
										{
											Dialog_ShowCallback(playerid, using inline iDialog6, DIALOG_STYLE_INPUT, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> 3DText"), "Wpisz nowy tekst w 3DTek�cie: (max "#MAX_DRZWI3D_LENGTH" znak�w)", "Zmie�", "Anuluj");
										}
										case 3://Pickup
										{
											Dialog_ShowCallback(playerid, using inline iDialog6, DIALOG_STYLE_INPUT, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> Pickup"), "Wpisz nowy model pickupa (tylko liczby)", "Zmie�", "Anuluj");
										}
										case 4://Pomieszczenie
										{
											Dialog_ShowCallback(playerid, using inline iDialog6, DIALOG_STYLE_INPUT, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> Pomieszczenie"), "Wpisz nowe ID pomieszczenia", "Zmie�", "Anuluj");
										}
										case 5://X,Y,Z,A
										{
											Dialog_ShowCallback(playerid, using inline iDialog6, DIALOG_STYLE_INPUT, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> Pozycja"), "Wpisz now� pozycj� (oddzielana spacjami):", "Zmie�", "Anuluj");
										}
										case 6://3DText
										{
											Dialog_ShowCallback(playerid, using inline iDialog6, DIALOG_STYLE_INPUT, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> 3DText"), "Wpisz nowy tekst w 3DTek�cie: (max "#MAX_DRZWI3D_LENGTH" znak�w)", "Zmie�", "Anuluj");
										}
										case 7://Pickup
										{
											Dialog_ShowCallback(playerid, using inline iDialog6, DIALOG_STYLE_INPUT, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> Pickup"), "Wpisz nowy model pickupa (tylko liczby)", "Zmie�", "Anuluj");
										}
										case 8://Pomieszczenie
										{
											Dialog_ShowCallback(playerid, using inline iDialog6, DIALOG_STYLE_INPUT, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> Pomieszczenie"), "Wpisz nowe ID pomieszczenia", "Zmie�", "Anuluj");
										}
										case 9://Lock
										{
											Dialog_ShowCallback(playerid, using inline iDialog6, DIALOG_STYLE_INPUT, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> Lock"), "Wpisz now� warto�� zamkni�cia", "Zmie�", "Anuluj");
										}
										case 10://Usu� drzwi
										{
											new string[256];
											format(string, sizeof(string), "Czy na pewno chcesz usun�� drzwi %s?", Drzwi[drzwiID][Nazwa]);
											Dialog_ShowCallback(playerid, using inline iDialog6, DIALOG_STYLE_MSGBOX, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> usuwanie"), string, "Usu�", "Anuluj");
										}
									}
								}
							}
							else//nie response dialog 5
							{
								switch(listitem3)
								{
									case 0://edycja pomieszczen
									{
										Dialog_ShowCallback(playerid, using inline iDialog4, DIALOG_STYLE_LIST, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> edytuj"), PomieszczeniaEdycjaDialog(pomieszczenieID), "Wybierz", "Wr��");
									}
									case 1://lista drzwi
									{
										Dialog_ShowCallback(playerid, using inline iDialog4, DIALOG_STYLE_LIST, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> powiazane drzwi"), ListaDrzwi(pomieszczenieID), "Wybierz", "Wr��");
										if(changedD==true)
										{
											interiory_SaveDrzwi(changedD);
											changedD=false;
										}
									}
								}
							}
						}
						//Dialog 4
						if(response4 && inputtext4[0] != '@')
						{
							//Zsota�y tylko pomieszczenia i drzwi
							if(listitem3 == 0)
							{
								switch(listitem4)
								{
									case 0://Nazwa
									{
										Dialog_ShowCallback(playerid, using inline iDialog5, DIALOG_STYLE_INPUT, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> edytuj nazwe"), "Wpisz now� nazw� pomieszczenia (max "#MAX_POMIESZCZENIE_NAME" znak�w)", "Zmie�", "Anuluj");
									}
									case 1://Budynek
									{
										Dialog_ShowCallback(playerid, using inline iDialog5, DIALOG_STYLE_INPUT, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> edytuj budynek"), "Wpisz nowe ID powi�zanego budynku (tylko liczby)", "Zmie�", "Anuluj");
									}
									case 2://Interior
									{
										Dialog_ShowCallback(playerid, using inline iDialog5, DIALOG_STYLE_INPUT, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> edytuj interior"), "Wpisz nowe ID interioru (tylko liczby)", "Zmie�", "Anuluj");
									}
									case 3://Oswietlenie
									{
										Dialog_ShowCallback(playerid, using inline iDialog5, DIALOG_STYLE_INPUT, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> edytuj o�wietlenie"), "Wpisz nowe o�wietlenie-czas (tylko liczby)", "Zmie�", "Anuluj");
									}
									case 4://Pogoda
									{
										Dialog_ShowCallback(playerid, using inline iDialog5, DIALOG_STYLE_INPUT, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> edytuj pogod�"), "Wpisz now� pogod� (tylko liczby)", "Zmie�", "Anuluj");
									}
									case 5://Muzyka
									{
										Dialog_ShowCallback(playerid, using inline iDialog5, DIALOG_STYLE_INPUT, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> edytuj muzyk�"), "Wpisz nowy adres stream'a (max "#MAX_STREAM_LENGTH" znak�w)", "Zmie�", "Anuluj");
									}
								}
							}
							else if(listitem3 == 1)//Lista drzwi - wybrano drzwi
							{
								drzwiID = PowiazaneDrzwi(pomieszczenieID, listitem4);
								Dialog_ShowCallback(playerid, using inline iDialog5, DIALOG_STYLE_LIST, ListaDrzwiNaglowek(budynekID, pomieszczenieID, drzwiID, " -> edycja"), DrzwiEdycjaDialog(drzwiID), "Wybierz", "Wr��");
							}
							else if(listitem3 == 2)//Usu� pomieszczenie - zatwierdzone
							{
								interiory_DeletePomieszczenie(pomieszczenieID);
								Dialog_ShowCallback(playerid, using inline iDialog2, DIALOG_STYLE_LIST, ListaBudynkowNaglowek(budynekID, " -> powi�zane pomieszczenia"), ListaPomieszczen(budynekID), "Wybierz", "Wr��");
							}
							
						}
						else//nie response dialog 4
						{
							Dialog_ShowCallback(playerid, using inline iDialog3, DIALOG_STYLE_LIST, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, "."), "Edytuj\nPowi�zane drzwi\nUsu�", "Wybierz", "Wr��");
						}
					}
					
					//Dialog 3
					if(response3)
					{
						switch(listitem1)
						{
							case 0://Lista edytowana
							{
								if(!isnull(inputtext3))
								{
									switch(listitem2)
									{
										case 0: //Wybrano Nazwa
										{
											if(!isnull(inputtext3))
												format(Budynki[budynekID][Nazwa], MAX_BUDYNEK_NAME, "%s", inputtext3);
											else
												ServerFail(playerid, "Nazwa musi zawiera� przynajmniej 1 znak");
										}
										case 1: //Wybrano Typ
										{
											new typ = strval(inputtext3);
											if(typ >= 1 && typ <= 4)
												Budynki[budynekID][Typ] = typ;
											else
											{
												ServerFail(playerid, "Wpisano niepoprawny typ!");
												Dialog_ShowCallback(playerid, using inline iDialog3, DIALOG_STYLE_INPUT, ListaBudynkowNaglowek(budynekID, " -> edytuj typ"), "Wpisz nowy typ budynku\nPUBLICZNY-1 | FRAKCJA-2 | ORGANIZACJA-3 | GRACZ-4", "Zmie�", "Anuluj");
											}
										}
										case 2: //Wybrano Wlasciciel
										{
											Budynki[budynekID][Wlasciciel] = strval(inputtext3);
										}
										case 3: //Wybrano Virtual Wrold
										{
											Budynki[budynekID][VW] = strval(inputtext3);
										}
									}
									changedB=true;
								}
								Dialog_ShowCallback(playerid, using inline iDialog2, DIALOG_STYLE_LIST, ListaBudynkowNaglowek(budynekID, " -> edytuj"), BudynkiEdycjaDialog(budynekID), "Wybierz", "Wr��");
							}
							case 1://Lista pomieszcze� - wybrano opcje edytowania
							{
								switch(listitem3)
								{
									case 0://Edytowanie pomieszczenia
									{
										Dialog_ShowCallback(playerid, using inline iDialog4, DIALOG_STYLE_LIST, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> edytuj"), PomieszczeniaEdycjaDialog(pomieszczenieID), "Wybierz", "Wr��");
									}
									case 1://Powiazane drzwi
									{
										Dialog_ShowCallback(playerid, using inline iDialog4, DIALOG_STYLE_LIST, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, " -> powiazane drzwi"), ListaDrzwi(pomieszczenieID), "Wybierz", "Wr��");
									}
									case 2://Usu� pomieszczenie
									{
										new string[256];
										format(string, sizeof(string), "Czy na pewno chcesz usun�� pomieszczenie %s?\n"INCOLOR_PANICRED"Ostrze�enie: wszystkie powiazane drzwi zostan� usuni�te razem z nim!", Pomieszczenia[pomieszczenieID][Nazwa]);
										Dialog_ShowCallback(playerid, using inline iDialog4, DIALOG_STYLE_MSGBOX, ListaBudynkowNaglowek(budynekID, " -> usu�"), string, "Usu�", "Anuluj");
									}
								}
							}
						}
					}
					else//nie response dialog 3
					{
						//Z dialogu 1
						switch(listitem1)
						{
							case 0://Edytowanie budynku
							{
								Dialog_ShowCallback(playerid, using inline iDialog2, DIALOG_STYLE_LIST, ListaBudynkowNaglowek(budynekID, " -> edytuj"), BudynkiEdycjaDialog(budynekID), "Wybierz", "Wr��");
							}
							case 1://Powiazane pomieszczenia
							{
								Dialog_ShowCallback(playerid, using inline iDialog2, DIALOG_STYLE_LIST, ListaBudynkowNaglowek(budynekID, " -> powi�zane pomieszczenia"), ListaPomieszczen(budynekID), "Wybierz", "Wr��");
								if(changedP==true)
								{
									interiory_SavePomieszczenie(pomieszczenieID);
									changedP=false;
								}
							}
						}
					}
				}
				
				//Dialog 2
				if(response2 && inputtext2[0] != '@')
				{
					switch(listitem1)
					{
						case 0://Lista edytowana - wybrano opcje
						{
							switch(listitem2)
							{
								case 0: //Nazwa
								{
									Dialog_ShowCallback(playerid, using inline iDialog3, DIALOG_STYLE_INPUT, ListaBudynkowNaglowek(budynekID, " -> edytuj nazwe"), "Wpisz now� nazw� budynku (max "#MAX_BIZNES_NAME" znak�w)", "Zmie�", "Anuluj");
								}
								case 1: //Typ
								{
									Dialog_ShowCallback(playerid, using inline iDialog3, DIALOG_STYLE_INPUT, ListaBudynkowNaglowek(budynekID, " -> edytuj typ"), "Wpisz nowy typ budynku\nPUBLICZNY-1 | FRAKCJA-2 | ORGANIZACJA-3 | GRACZ-4", "Zmie�", "Anuluj");
								}
								case 2: //Wlasciciel
								{
									Dialog_ShowCallback(playerid, using inline iDialog3, DIALOG_STYLE_INPUT, ListaBudynkowNaglowek(budynekID, " -> edytuj wlasciciela"), "Wpisz nowego wlasciciela budynku (tylko liczby)", "Zmie�", "Anuluj");
								}
								case 3: //Virtual Wrold
								{
									Dialog_ShowCallback(playerid, using inline iDialog3, DIALOG_STYLE_INPUT, ListaBudynkowNaglowek(budynekID, " -> edytuj virtualworld"), "Wpisz nowy virtual world budynku (tylko liczby)", "Zmie�", "Anuluj");
								}
							}
						}
						case 1://Lista pomieszcze� - wybrano pomieszczenie
						{
							pomieszczenieID = PowiazanePomieszczenie(listitem, listitem2);
							Dialog_ShowCallback(playerid, using inline iDialog3, DIALOG_STYLE_LIST, ListaPomieszczenNaglowek(budynekID, pomieszczenieID, "-> edytuj"), "Edytuj\nPowi�zane drzwi\nUsu�", "Wybierz", "Wr��");
						}
						case 2://Potwierdzenie usuni�cia
						{
							interiory_DeleteBudynek(budynekID);
							Dialog_ShowCallback(playerid, using inline iDialog0, DIALOG_STYLE_LIST, "Zarz�dzanie budynkami", ListaBudynkow(domy), "Wybierz", "Wyjd�");
						}
					}
				}
				else//nie response dialog 2
				{
					Dialog_ShowCallback(playerid, using inline iDialog1, DIALOG_STYLE_LIST, ListaBudynkowNaglowek(budynekID, "."), "Edytuj\nPowi�zane pomieszczenia\nUsu�", "Wybierz", "Wr��");
					if(changedB==true)
					{
						interiory_SaveBudynek(budynekID);
						changedB=false;
					}
				}
			}
			
			//Dialog 1
			if(response1)
			{
				switch(listitem1)
				{
					case 0://Edytowanie budynku
					{
						Dialog_ShowCallback(playerid, using inline iDialog2, DIALOG_STYLE_LIST, ListaBudynkowNaglowek(budynekID, " -> edytuj"), BudynkiEdycjaDialog(budynekID), "Wybierz", "Wr��");
					}
					case 1://Powiazane pomieszczenia
					{
						Dialog_ShowCallback(playerid, using inline iDialog2, DIALOG_STYLE_LIST, ListaBudynkowNaglowek(budynekID, " -> powi�zane pomieszczenia"), ListaPomieszczen(budynekID), "Wybierz", "Wr��");
					}
					case 2://Usuwanie budynku
					{
						new string[256];
						format(string, sizeof(string), "Czy na pewno chcesz usun�� budynek %s?\n"INCOLOR_PANICRED"Ostrze�enie: wszystkie powiazane pomieszczenia i drzwi zostan� usuni�te razem z nim!", Budynki[budynekID][Nazwa]);
						Dialog_ShowCallback(playerid, using inline iDialog2, DIALOG_STYLE_MSGBOX, ListaBudynkowNaglowek(budynekID, " -> usu�"), string, "Usu�", "Anuluj");
					}
				}
			}
			else//nie response
			{
				Dialog_ShowCallback(playerid, using inline iDialog0, DIALOG_STYLE_LIST, "Zarz�dzanie budynkami", ListaBudynkow(domy), "Wybierz", "Wyjd�");
			}
		}
	
		//Dialog 0
		
		if(response)
		{
			if(inputtext[0] == '@')
			{
				Dialog_ShowCallback(playerid, using inline iDialog0, DIALOG_STYLE_LIST, "Zarz�dzanie budynkami", ListaBudynkow(domy), "Wybierz", "Wyjd�");
			}
			else if(Budynki[BudynkiListitem(listitem, false)][Typ] == 0)
			{
				ServerFail(playerid, "Edycja budynk�w systemowych tylko poprzez baz� danych!");
				Dialog_ShowCallback(playerid, using inline iDialog0, DIALOG_STYLE_LIST, "Zarz�dzanie budynkami", ListaBudynkow(domy), "Wybierz", "Wyjd�");
			}
			else
			{
				budynekID = BudynkiListitem(listitem, false); //true - domy | false - budynki
				Dialog_ShowCallback(playerid, using inline iDialog1, DIALOG_STYLE_LIST, ListaBudynkowNaglowek(budynekID, "."), "Edytuj\nPowi�zane pomieszczenia\nUsu�", "Wybierz", "Wr��");
			}
		}
	}
	Dialog_ShowCallback(playerid, using inline iDialog0, DIALOG_STYLE_LIST, "Zarz�dzanie budynkami", ListaBudynkow(domy), "Wybierz", "Wyjd�");
	
	return 1;
}

stock ListaBudynkow(domy)
{
	new string[1024];
	for(new i; i<MAX_BUDYNKOW; i++)
	{
		if(domy)
		{
			if(Budynki[i][Typ] == OWNER_TYPE_DOM)
				strcat(string, Budynki[i][Nazwa], sizeof(string));
		}
		else
		{
			if(Budynki[i][Typ] != OWNER_TYPE_DOM)
				strcat(string, Budynki[i][Nazwa], sizeof(string));
		}
		if(isnull(Budynki[i+1][Nazwa]))
			break;
		else
			strcat(string, "\n", sizeof(string));
	}
	if(isnull(string))
	{
		strcat(string, "@"INCOLOR_PANICRED"Brak budynk�w!");
	}
	safe_return string;
}

stock ListaPomieszczen(budynek)
{
	new string[1024];
	for(new i; i<MAX_POMIESZCZEN; i++)
	{
		if(Pomieszczenia[i][Budynek] == Budynki[budynek][ID])
		{
			strcat(string, Pomieszczenia[i][Nazwa], sizeof(string));
			if(isnull(Pomieszczenia[i+1][Nazwa]))
				break;
			else
				strcat(string, "\n", sizeof(string));
		}
	}
	if(isnull(string))
	{
		strcat(string, "@"INCOLOR_PANICRED"Brak powi�zanych pomieszcze�!");
	}
	safe_return string;
}

stock ListaDrzwi(pomieszczenie)
{
	new string[1024];
	for(new i; i<MAX_DRZWI; i++)
	{
		if(Drzwi[i][inPomieszczenie] == Pomieszczenia[pomieszczenie][ID])
		{
			strcat(string, INCOLOR_LIGHTGREEN, sizeof(string));
			strcat(string, Drzwi[i][Nazwa], sizeof(string));
			if(isnull(Drzwi[i+1][Nazwa]) && Drzwi[i][outPomieszczenie] != Pomieszczenia[pomieszczenie][ID])
				break;
			else
				strcat(string, "\n", sizeof(string));
		}
		if(Drzwi[i][outPomieszczenie] == Pomieszczenia[pomieszczenie][ID])
		{
			strcat(string, INCOLOR_LIGHTRED, sizeof(string));
			strcat(string, Drzwi[i][Nazwa], sizeof(string));
			if(isnull(Drzwi[i+1][Nazwa]))
				break;
			else
				strcat(string, "\n", sizeof(string));
		}
	}
	if(isnull(string))
	{
		strcat(string, "@"INCOLOR_PANICRED"Brak powi�zanych drzwi!");
	}
	safe_return string;
}

stock BudynkiListitem(zkolei, domy)
{
	new i, r;
	while (i<MAX_BUDYNKOW)
	{
		if(domy)
		{
			if(Budynki[i][Typ] == OWNER_TYPE_DOM)
			{
				if(r==zkolei)
					break;
				r++;
			}
		}
		else
		{
			if(Budynki[i][Typ] != OWNER_TYPE_DOM)
			{
				if(r==zkolei)
					break;
				r++;
			}
		}
		i++;
	}
	
	return i;
}

stock PowiazanePomieszczenie(budynek, zkolei)
{
	new i, r;
	while (i<MAX_POMIESZCZEN)
	{
		if(Pomieszczenia[i][Budynek] == Budynki[budynek][ID])
		{
			if(r==zkolei)
				break;
			r++;
		}
		i++;
	}
	
	return i;
}

stock PowiazaneDrzwi(pomieszczenie, zkolei)
{
	new i, r;
	while (i<MAX_DRZWI)
	{
		if(Drzwi[i][inPomieszczenie] == Pomieszczenia[pomieszczenie][ID])
		{
			if(r==zkolei)
				break;
			r++;
		}
		if(Drzwi[i][outPomieszczenie] == Pomieszczenia[pomieszczenie][ID])
		{
			if(r==zkolei)
				break;
			r++;
		}
		i++;
	}
	
	return i;
}

stock ListaBudynkowNaglowek(budynek, dodatkowy[])
{
	new string[64];
	format(string, sizeof(string), "Budynek %d%s", Budynki[budynek][ID], dodatkowy);
	safe_return string;
}

stock ListaPomieszczenNaglowek(budynek, pomieszczenie, dodatkowy[])
{
	new string[100];
	format(string, sizeof(string), "Budynek %d -> Pomieszczenie %d%s", Budynki[budynek][ID], Pomieszczenia[pomieszczenie][ID], dodatkowy);
	safe_return string;
}

stock ListaDrzwiNaglowek(budynek, pomieszczenie, drzwi, dodatkowy[])
{
	new string[128];
	format(string, sizeof(string), "Budynek %d -> Pom. %d -> Drzwi %d%s", Budynki[budynek][ID], Pomieszczenia[pomieszczenie][ID], Drzwi[drzwi][ID], dodatkowy);
	safe_return string;
}

stock BudynkiEdycjaDialog(budynek)
{
	new string[512];
	new typstring[16];
	switch(Budynki[budynek][Typ])
	{
		case 0:
		{
			strcat(typstring, "System");
		}
		case 1:
		{
			strcat(typstring, "Publiczny");
		}
		case 2:
		{
			strcat(typstring, "Frakcja");
		}
		case 3:
		{
			strcat(typstring, "Organizacja");
		}
		case 4:
		{
			strcat(typstring, "Gracz");
		}
	}
	format(string, sizeof(string), INDIALOG_COLOR"Nazwa: "INCOLOR_WHITE"%s\n"INDIALOG_COLOR"Typ: "INCOLOR_WHITE"%s\n"INDIALOG_COLOR"Wlasciciel: "INCOLOR_WHITE"%d\n"INDIALOG_COLOR"VirtualWorld: "INCOLOR_WHITE"%d", Budynki[budynek][Nazwa], typstring, Budynki[budynek][Wlasciciel], Budynki[budynek][VW]);
	safe_return string;
}

stock PomieszczeniaEdycjaDialog(p)
{
	new string[512];
	format(string, sizeof(string), INDIALOG_COLOR"Nazwa: "INCOLOR_WHITE"%s\n"INDIALOG_COLOR"Budynek: "INCOLOR_WHITE"%d\n"INDIALOG_COLOR"Interior: "INCOLOR_WHITE"%d\n"INDIALOG_COLOR"Oswietlenie: "INCOLOR_WHITE"%d\n"INDIALOG_COLOR"Pogoda: "INCOLOR_WHITE"%d\n"INDIALOG_COLOR"Muzyka: "INCOLOR_WHITE"%s", 
		Pomieszczenia[p][Nazwa], Pomieszczenia[p][Budynek], Pomieszczenia[p][Interior], Pomieszczenia[p][Oswietlenie], Pomieszczenia[p][Pogoda], Pomieszczenia[p][Muzyka]);
	safe_return string;
}

stock DrzwiEdycjaDialog(d)
{
	new string[1024];
	format(string, sizeof(string), INDIALOG_COLOR"Nazwa: "INCOLOR_WHITE"%s\n"INDIALOG_COLOR"In - Pozycja X, Y, Z, A: "INCOLOR_WHITE"%.1f, %.1f, %.1f, %.1f\n"INDIALOG_COLOR"In - 3DText: "INCOLOR_WHITE"%s\n"INDIALOG_COLOR"In - Model pickupu: "INCOLOR_WHITE"%d\n"INDIALOG_COLOR"In - Pomieszczenie: "INCOLOR_WHITE"%d\n", 
		Drzwi[d][Nazwa], Drzwi[d][inX], Drzwi[d][inY], Drzwi[d][inZ], Drzwi[d][inA], Drzwi[d][in3DTextString], Drzwi[d][inPickupModel], Drzwi[d][inPomieszczenie]);
		
	format(string, sizeof(string), "%s"INDIALOG_COLOR"Out - Pozycja X, Y, Z, A: "INCOLOR_WHITE"%.1f, %.1f, %.1f, %.1f\n"INDIALOG_COLOR"Out - 3DText: "INCOLOR_WHITE"%s\n"INDIALOG_COLOR"Out - Model pickupu: "INCOLOR_WHITE"%d\n"INDIALOG_COLOR"Out - Pomieszczenie: "INCOLOR_WHITE"%d\n"INDIALOG_COLOR"Zamkni�te: "INCOLOR_WHITE"%d\n"INCOLOR_PANICRED"Usu�", 
		string, Drzwi[d][outX], Drzwi[d][outY], Drzwi[d][outZ], Drzwi[d][outA], Drzwi[d][out3DTextString], Drzwi[d][outPickupModel], Drzwi[d][outPomieszczenie], Drzwi[d][lock]);
	safe_return string;
}