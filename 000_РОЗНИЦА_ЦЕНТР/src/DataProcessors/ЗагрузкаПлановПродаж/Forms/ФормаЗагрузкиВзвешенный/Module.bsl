&НаСервере
Процедура ЗанестиДанныеВРегистр(КодМагазина,ПРОЕКТ,ДАТА,Сумма,Взвешенный)
	
	
	КодМагазина = Число(КодМагазина);
	Магазин =  Справочники.Магазины.НайтиПоРеквизиту("НомерМагазина",КодМагазина); 
	Если не Магазин=Справочники.Магазины.ПустаяСсылка() Тогда
		Если НЕ Взвешенный тогда
			НовыйПлан = РегистрыСведений.ПланыПродаж.СоздатьНаборЗаписей();
		Иначе
			НовыйПлан = РегистрыСведений.ПланыПродажВзвешенные.СоздатьНаборЗаписей();
		КонецЕсли;
		//НовыйПлан.Период=НачалоМесяца(ДатаЗагрузки);
		НовыйПлан.Отбор.Магазин.Установить(Магазин);  
		НовыйПлан.Отбор.Период.Установить(НачалоДня(ДАТА));
		Проект = Справочники.ВидыНоменклатуры.НайтиПоРеквизиту("IDN",ПРОЕКТ);
		НовыйПлан.Отбор.ПРОЕКТ.Установить(Проект);
		//НовыйПлан.Магазин=Магазин;
		
		Если ЗначениеЗаполнено(Проект) Тогда
			попытка
				ЗаписьГигиена =  НовыйПлан.Добавить();
				ЗаписьГигиена.Магазин = Магазин;
				ЗаписьГигиена.Период = НачалоДня(ДАТА);
				ЗаписьГигиена.Проект = Проект;
				ЗаписьГигиена.Сумма=Сумма;
				//СуммаПлана=СуммаПлана+Число(ГИГИЕНА);
				ЗаписьГигиена.Активность = Истина;
			Исключение
				Сообщить("ОШИБКА Проект "+ПРОЕКТ+" "+КодМагазина);
			КонецПопытки
		Конецесли;
		
		
			//попытка
			//	НовыйПлан.Сумма=Число(СуммаПлана);
			//Исключение
			//	Сообщить("ОШИБКА СуммаПлана "+Строка(СуммаПлана)+" "+КодМагазина);
			//КонецПопытки;
			попытка		
				НовыйПлан.Записать(Истина);
			исключение
				Сообщить("не удалось записать магазин - "+ КодМагазина);

			КонецПопытки
	Иначе
		Сообщить("не найден магазин - "+ КодМагазина);
	Конецесли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьТаблицу(Команда)
	ошибка=ложь;
	НомерСтроки=2;
	
		

	КодМагазина = СокрЛП(ТабличныйДокумент.Область("R"+Формат(НомерСтроки,"ЧГ=")+"C"+Формат(2,"ЧГ=")).Текст);
	ДатаСтрока = ТабличныйДокумент.Область("R"+Формат(НомерСтроки,"ЧГ=")+"C"+1).Текст;	
//пока ЗначениеЗаполнено(КодМагазина) цикл
пока  КодМагазина<>"" И  ДатаСтрока<>"" цикл 
	//НомерСтроки=НомерСтроки+1;
		ДатаСтрока = ТабличныйДокумент.Область("R"+Формат(НомерСтроки,"ЧГ=")+"C"+1).Текст;
		КодМагазина = СокрЛП(ТабличныйДокумент.Область("R"+Формат(Формат(НомерСтроки,"ЧГ="),"ЧГ=")+"C"+Формат(2,"ЧГ=")).Текст);
		ПРОЕКТ = СтрЗаменить(СокрЛП(ТабличныйДокумент.Область("R"+Формат(Формат(НомерСтроки,"ЧГ="),"ЧГ=")+"C"+Формат(3,"ЧГ=")).Текст)," ","");
		ДАТА = ПривестиКТипуДата(ДатаСтрока);
		Сумма = СтрЗаменить(СокрЛП(ТабличныйДокумент.Область("R"+Формат(Формат(НомерСтроки,"ЧГ="),"ЧГ=")+"C"+Формат(4,"ЧГ=")).Текст)," ","");
		Если ЗначениеЗаполнено(КодМагазина) Тогда
			ЗанестиДанныеВРегистр(КодМагазина,ПРОЕКТ,ДАТА,Число(Сумма),Взвешенный);
			Состояние(Строка(НомерСтроки));	
		конецесли;
		
		НомерСтроки=НомерСтроки+1;
		
		//КодМагазина = СокрЛП(ТабличныйДокумент.Область("R"+Формат(НомерСтроки,"ЧГ=")+"C"+Формат(2,"ЧГ=")).Текст);
		обработкапрерыванияпользователя();
		
	конеццикла;
    ПоказатьПредупреждение(, "Данные загружены");	

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаЗагрузки = НачалоМесяца(текущаядата());
КонецПроцедуры


&НаСервере
Функция ПривестиКТипуДата(СтрДата)
    День = Сред(СтрДата, 1, 2);
    Месяц = Сред(СтрДата, 4, 2);
    Год = Сред(СтрДата, 7, 4);
    Возврат(Дата(Год+Месяц+День));
КонецФункции

&НаКлиенте
Процедура ВзешенныйПриИзменении(Элемент)
	ВзешенныйПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВзешенныйПриИзмененииНаСервере()
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ВставитьОбласть(ТабличныйДокумент.Область("ОбластьШапка"));
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.ВставитьОбласть(ТабДок.Область("ОбластьШапка"),ТабличныйДокумент.Область(1,1));
КонецПроцедуры
