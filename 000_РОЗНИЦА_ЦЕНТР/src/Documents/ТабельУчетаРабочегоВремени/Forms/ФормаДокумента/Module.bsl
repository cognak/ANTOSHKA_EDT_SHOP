
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не ЗначениеЗаполнено(Объект.ПериодРегистрации) тогда 
		Объект.ПериодРегистрации = ТекущаяДата() + 15*24*60*60;	
	КонецЕсли;
	Если не ЗначениеЗаполнено(Объект.ПериодРегистрации) тогда 
		
		Объект.ПериодРегистрации = ТекущаяДата() + 15*24*60*60;	
	КонецЕсли;
	Если не ЗначениеЗаполнено(Объект.ПериодВводаДанныхОВремени) тогда 
		Если НачалоМесяца(Объект.ПериодРегистрации) =  НачалоМесяца(ТекущаяДата()) тогда 
			Объект.ПериодВводаДанныхОВремени = ПредопределенноеЗначение("Перечисление.ПериодыВводаДанныхОВремени.ВтораяПоловинаТекущегоМесяца");	
		Иначе
			Объект.ПериодВводаДанныхОВремени = ПредопределенноеЗначение("Перечисление.ПериодыВводаДанныхОВремени.ПерваяПоловинаТекущегоМесяца");	
		КонецЕсли;
	КонецЕсли;
	УчетРабочегоВремениРасширенныйФормы.ТабельУчетаПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	Если не ЗначениеЗаполнено(Объект.Магазин) тогда 
		Объект.Магазин = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин;	
	КонецЕсли;
	
	Если не ЗначениеЗаполнено(Объект.Организация) тогда 
		Объект.Организация = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин,"Организация");	
	КонецЕсли;
	
	Если не ЗначениеЗаполнено(Объект.Ответственный) тогда 
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;	
	КонецЕсли;
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцРегистрацииСтрокой");
	УчетРабочегоВремениРасширенныйФормы.ТабельУчетаПериодРегистрацииПриИзменении(ЭтаФорма);
	ЗаполнитьЧасы();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЧасы()
	Для каждого строка из Объект.ДанныеОВремени цикл
		НомерДняНачалаПериода = День(Объект.ДатаНачалаПериода);
		НомерДняОкончанияПериода = День(Объект.ДатаОкончанияПериода);
		Для НомерДня = НомерДняНачалаПериода По НомерДняОкончанияПериода Цикл
			строка["ЧасовА" + НомерДня] =  Дата(1,1,1) + строка["ЧасовФактАвто" + НомерДня]*60*60;	
			строка["ЧасовР" + НомерДня] =  Дата(1,1,1) + строка["ЧасовФакт" + НомерДня]*60*60;	
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЧасыТолькоАвто()
	Для каждого строка из Объект.ДанныеОВремени цикл
		НомерДняНачалаПериода = День(Объект.ДатаНачалаПериода);
		НомерДняОкончанияПериода = День(Объект.ДатаОкончанияПериода);
		Для НомерДня = НомерДняНачалаПериода По НомерДняОкончанияПериода Цикл
			строка["ЧасовА" + НомерДня] =  Дата(1,1,1) + строка["ЧасовФактАвто" + НомерДня]*60*60;	
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура ПериодВводаДанныхОВремениПриИзмененииНаСервере()
	УчетРабочегоВремениРасширенныйФормы.ТабельУчетаПериодРегистрацииПриИзменении(ЭтаФорма);
КонецПроцедуры


&НаКлиенте
Процедура ПериодВводаДанныхОВремениПриИзменении(Элемент)
	ПериодВводаДанныхОВремениПриИзмененииНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьНаСервере()
	
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		
	 "ВЫБРАТЬ
	 |	НАЧАЛОПЕРИОДА(УчетРабочегоВремениФакт.Период, ДЕНЬ) КАК День,
	 |	УчетРабочегоВремениФакт.Сотрудник КАК Сотрудник,
	 |	УчетРабочегоВремениФакт.Период КАК Начало
	 |ПОМЕСТИТЬ Таб
	 |ИЗ
	 |	РегистрСведений.УчетРабочегоВремениФакт КАК УчетРабочегоВремениФакт
	 |ГДЕ
	 |	УчетРабочегоВремениФакт.Магазин = &Магазин
	 |	И УчетРабочегоВремениФакт.Организация = &Организация
	 |	И УчетРабочегоВремениФакт.Период МЕЖДУ &ПериодС И &ПериодПо
	 |	И УчетРабочегоВремениФакт.ТипВремени = ЗНАЧЕНИЕ(Перечисление.ТипВремени.Приход)
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |	Таб.День КАК День,
	 |	Таб.Сотрудник КАК Сотрудник,
	 |	Таб.Начало КАК Начало,
	 |	МИНИМУМ(УчетРабочегоВремениФакт.Период) КАК Конец
	 |ПОМЕСТИТЬ ТабВремя
	 |ИЗ
	 |	Таб КАК Таб
	 |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетРабочегоВремениФакт КАК УчетРабочегоВремениФакт
	 |		ПО Таб.Сотрудник = УчетРабочегоВремениФакт.Сотрудник
	 |			И Таб.Начало < УчетРабочегоВремениФакт.Период
	 |ГДЕ
	 |	УчетРабочегоВремениФакт.ТипВремени = ЗНАЧЕНИЕ(Перечисление.ТипВремени.Уход)
	 |	И УчетРабочегоВремениФакт.Организация = &Организация
	 |	И УчетРабочегоВремениФакт.Период МЕЖДУ &ПериодС И &ПериодПо
	 |
	 |СГРУППИРОВАТЬ ПО
	 |	Таб.День,
	 |	Таб.Сотрудник,
	 |	Таб.Начало
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |	РабочийГрафик.Сотрудник КАК Сотрудник,
	 |	СУММА(РабочийГрафик.Часы) КАК Часы,
	 |	НАЧАЛОПЕРИОДА(РабочийГрафик.Период, ДЕНЬ) КАК День
	 |ПОМЕСТИТЬ ТабГрафик
	 |ИЗ
	 |	РегистрНакопления.РабочийГрафик КАК РабочийГрафик
	 |ГДЕ
	 |	РабочийГрафик.Период МЕЖДУ &ПериодС И &ПериодПо
	 |	И РабочийГрафик.Организация = &Организация
	 |	И РабочийГрафик.Магазин = &Магазин
	 |
	 |СГРУППИРОВАТЬ ПО
	 |	РабочийГрафик.Сотрудник,
	 |	НАЧАЛОПЕРИОДА(РабочийГрафик.Период, ДЕНЬ)
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |	Таб.Сотрудник КАК Сотрудник,
	 |	ВЫРАЗИТЬ(РАЗНОСТЬДАТ(Таб.Начало, Таб.Конец, МИНУТА) / 60 КАК ЧИСЛО(5, 2)) КАК Часы,
	 |	Таб.День КАК День,
	 |	0 КАК ЧасыГрафик
	 |ПОМЕСТИТЬ ТабИтог
	 |ИЗ
	 |	ТабВремя КАК Таб
	 |
	 |ОБЪЕДИНИТЬ ВСЕ
	 |
	 |ВЫБРАТЬ
	 |	ТабГрафик.Сотрудник,
	 |	0,
	 |	ТабГрафик.День,
	 |	ТабГрафик.Часы
	 |ИЗ
	 |	ТабГрафик КАК ТабГрафик
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |	ТабИтог.Сотрудник КАК Сотрудник,
	 |	СУММА(ТабИтог.Часы) КАК Часы,
	 |	ТабИтог.День КАК День,
	 |	СУММА(ТабИтог.ЧасыГрафик) КАК ЧасыГрафик
	 |ИЗ
	 |	ТабИтог КАК ТабИтог
	 |
	 |СГРУППИРОВАТЬ ПО
	 |	ТабИтог.Сотрудник,
	 |	ТабИтог.День
	 |ИТОГИ ПО
	 |	Сотрудник
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |УНИЧТОЖИТЬ Таб
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |УНИЧТОЖИТЬ ТабВремя
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |УНИЧТОЖИТЬ ТабИтог
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |УНИЧТОЖИТЬ ТабГрафик";
	
	
		
	Запрос.УстановитьПараметр("Магазин", Объект.Магазин);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ПериодПо", КонецДня(Объект.ДатаОкончанияПериода));
	Запрос.УстановитьПараметр("ПериодС", Объект.ДатаНачалаПериода);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Сотрудник");
	
	Пока Выборка.Следующий() Цикл
		ПараметрыОтбора = Новый Структура; 
		ПараметрыОтбора.Вставить("Сотрудник", Выборка.Сотрудник);
		НайденнаяСтрока = Объект.ДанныеОВремени.НайтиСтроки(ПараметрыОтбора);
		Если НайденнаяСтрока.Количество() = 0 тогда 
			Строка = Объект.ДанныеОВремени.Добавить();
			Строка.Сотрудник =Выборка.Сотрудник; 
		Иначе
			Строка = Объект.ДанныеОВремени[НайденнаяСтрока[0].НомерСтроки-1];
		КонецЕсли;
	    ВыборкаДетальная =  Выборка.Выбрать();
		Строка.Должность = ПолучитьДолжность(Выборка.Сотрудник);
		НомерДняНачалаПериода = День(Объект.ДатаНачалаПериода);
		НомерДняОкончанияПериода = День(Объект.ДатаОкончанияПериода);
		Для НомерДня = НомерДняНачалаПериода По НомерДняОкончанияПериода Цикл
			Строка["ЧасовФактАвто" +НомерДня] = 0;
		КонецЦикла;	
		Пока ВыборкаДетальная.Следующий() Цикл
			НомерДня =  День(ВыборкаДетальная.День);
			Строка["ЧасовФактАвто" +НомерДня] = ВыборкаДетальная.Часы;	
			Строка["Часов" +НомерДня] = ВыборкаДетальная.ЧасыГрафик;
		КонецЦикла;
	КонецЦикла;
	ЗаполнитьЧасыТолькоАвто();	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецПроцедуры


&НаСервере
Процедура ДанныеОВремениЧасовФакт1ПриИзмененииНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры


&НаКлиенте
Процедура ДанныеОВремениЧасовФакт1ПриИзменении(Элемент)
	ТекДанные = Элементы.ДанныеОВремени.ТекущиеДанные;
	Если СтрДлина(Элемент.Имя) = 22 тогда 
		Номер = Прав(Элемент.Имя,2);
	Иначе
		Номер = Прав(Элемент.Имя,1);
	КонецЕсли;
	Если НЕ Элемент.ТекстРедактирования = "  :  " и ТекДанные["Комментарий" + Номер] = ""   тогда
		Сообщить("Заполните комментарий");
		ТекДанные["ЧасовР"+Номер] = ДАта(1,1,1);
	КонецЕсли;
	
	ДанныеОВремениЧасовФакт1ПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениЧасовФактПриИзменении(Элемент)
	ТекДанные = Элементы.ДанныеОВремени.ТекущиеДанные;
	Если СтрДлина(Элемент.Имя) = 22 тогда 
		Номер = Прав(Элемент.Имя,2);
	Иначе
		Номер = Прав(Элемент.Имя,1);
	КонецЕсли;
	Если НЕ Элемент.ТекстРедактирования = "0,00" и ТекДанные["Комментарий" + Номер] = ""   тогда
		Сообщить("Заполните комментарий");
		ТекДанные["ЧасовФакт"+Номер] = 0;
	КонецЕсли;
	
	ДанныеОВремениЧасовФакт1ПриИзмененииНаСервере();
КонецПроцедуры



&НаКлиенте
Процедура МесяцРегистрацииСтрокойПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцРегистрацииСтрокой", Модифицированность);
	
	ПериодРегистрацииПриИзменении();
КонецПроцедуры


&НаКлиенте
Процедура МесяцРегистрацииСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	Оповещение = Новый ОписаниеОповещения("ПериодРегистрацииНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцРегистрацииСтрокой", , Оповещение);
КонецПроцедуры


&НаКлиенте
Процедура МесяцРегистрацииСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцРегистрацииСтрокой", Направление, Модифицированность);
	
	ПериодРегистрацииПриИзменении();
КонецПроцедуры


&НаКлиенте
Процедура МесяцРегистрацииСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры


&НаКлиенте
Процедура МесяцРегистрацииСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ПериодРегистрацииПриИзменении()
	УчетРабочегоВремениРасширенныйФормы.ТабельУчетаПериодРегистрацииПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
 	//ПересчитатьЧасы(ТекущийОбъект);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) тогда 
		ПроверитьИзменения();
  	КонецЕсли;
  
КонецПроцедуры

&НаСервере
Процедура ПересчитатьЧасы()
	
		Для Каждого Cтрока Из Объект.ДанныеОВремени Цикл 
			НомерДняНачалаПериода = День(Объект.ДатаНачалаПериода);
			НомерДняОкончанияПериода = День(Объект.ДатаОкончанияПериода);
			Для НомерДня = НомерДняНачалаПериода По НомерДняОкончанияПериода Цикл

				ЧасовЧислоА = Число((Cтрока["ЧасовА"+ НомерДня]-Дата(1,1,1))/(60*60)); 
				Cтрока["ЧасовФактАвто" + НомерДня]= ЧасовЧислоА;

				ЧасовЧислоР = Число((Cтрока["ЧасовР"+ НомерДня]-Дата(1,1,1))/(60*60)); 
				Cтрока["ЧасовФакт" + НомерДня]= ЧасовЧислоР;
				
			КонецЦикла;	
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ПроверитьИзменения()
	Таб = Новый ТаблицаЗначений;
	Таб.Колонки.Добавить("ТабельУчетаРабочегоВремени", Новый ОписаниеТипов("ДокументСсылка.ТабельУчетаРабочегоВремени"));
	Таб.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	Таб.Колонки.Добавить("НомерДня", Новый ОписаниеТипов("Число"));
	Таб.Колонки.Добавить("Часов", Новый ОписаниеТипов("Число"));
	Таб.Колонки.Добавить("Комментарий", Новый ОписаниеТипов("Строка"));
	
		Для Каждого СтрокаДанныхОВремени Из Объект.ДанныеОВремени Цикл 
		НомерСтр = СтрокаДанныхОВремени.НомерСтроки;
		ОбрабатываемаяДата = Объект.ДатаНачалаПериода;
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Сотрудник",СтрокаДанныхОВремени.Сотрудник);
		Строки = Объект.Ссылка.ДанныеОВремени.НайтиСтроки(ПараметрыОтбора);
		НомерДняНачалаПериода = День(Объект.ДатаНачалаПериода);
		НомерДняОкончанияПериода = День(Объект.ДатаОкончанияПериода);
		Если НЕ Строки.Количество() = 0 тогда 
		Для НомерДня = НомерДняНачалаПериода По НомерДняОкончанияПериода Цикл

			Если Строки[0]["Комментарий" + НомерДня] <> СтрокаДанныхОВремени["Комментарий" + НомерДня] ИЛИ Строки[0]["ЧасовФакт" + НомерДня] <> СтрокаДанныхОВремени["ЧасовФакт" + НомерДня] тогда 
			Стр = Таб.Добавить();
			Стр.ТабельУчетаРабочегоВремени = Объект.Ссылка;
			Стр.Сотрудник = СтрокаДанныхОВремени.Сотрудник;
			Стр.НомерДня = НомерДня;
			Стр.Часов = Строки[0]["ЧасовФакт" + НомерДня];
			Стр.Комментарий = Строки[0]["Комментарий" + НомерДня];
			
			КонецЕсли;	
			ОбрабатываемаяДата = ОбрабатываемаяДата + 86400;
		КонецЦикла;	
		КонецЕсли;
	КонецЦикла;	
	Если Таб.Количество() <> 0 тогда 
		ЗаписатьИсториюВрегистр(Таб)
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ЗаписатьИсториюВрегистр(Таб)
текДАта =ТекущаяДата();	
	
Для Каждого строка из Таб цикл 
НаборЗаписей = РегистрыСведений.ТабельУчетаРабочегоВремениИсторияИзменений.СоздатьНаборЗаписей(); 

НаборЗаписей.Отбор.ТабельУчетаРабочегоВремени.Установить(Строка.ТабельУчетаРабочегоВремени);
НаборЗаписей.Отбор.НомерДня.Установить(Строка.НомерДня); 
НаборЗаписей.Отбор.Сотрудник.Установить(Строка.Сотрудник); 
НаборЗаписей.Отбор.период.Установить(текДАта); 
НовЗапись = НаборЗаписей.Добавить();
НовЗапись.ТабельУчетаРабочегоВремени = Строка.ТабельУчетаРабочегоВремени;
НовЗапись.НомерДня = Строка.НомерДня;
НовЗапись.Сотрудник = Строка.Сотрудник;
НовЗапись.период = текДАта;
НовЗапись.Комментарий = Строка.Комментарий;
НовЗапись.Часов = Строка.Часов;
НаборЗаписей.Записать(Истина);
КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура История(Команда)
	Сотрудник = Элементы.ДанныеОВремени.ТекущиеДанные.Сотрудник; 
	
	УсловияОтбора = Новый Структура();
	УсловияОтбора.Вставить("Сотрудник",Сотрудник);
	УсловияОтбора.Вставить("ТабельУчетаРабочегоВремени",Объект.Ссылка);
	
ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", УсловияОтбора, Истина);

	
	//
	//Сотрудник = Элементы.ДанныеОВремени.ТекущиеДанные.Сотрудник; 
	//ПараметрыФормы = Новый Структура;
	//ПараметрыФормы.Вставить("Сотрудник",Сотрудник);
	//ПараметрыФормы.Вставить("Документ",Объект.Ссылка);
	ОткрытьФорму("Отчет.ТабельУчетаИстория.Форма.ФормаОтчета",ПараметрыФормы);	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениПередУдалением(Элемент, Отказ)
	Ответ = Вопрос(НСтр("ru = 'Удалить строку с данным сотрудником ?'"), РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет); 
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениСотрудникПриИзменении(Элемент)
	ТекДанные = Элементы.ДанныеОВремени.ТекущиеДанные;
	ТекДанные.Должность = ПолучитьДолжность(ТекДанные.Сотрудник);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры


&НаСервере
Функция ПолучитьДолжность(Сотрудник)
	Должность = Справочники.РаботаВыполняемаяСотрудниками.ПустаяСсылка();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	РаботникиОрганизаций.Должность КАК Должность,
		|	РаботникиОрганизаций.ПериодНачала КАК ПериодНачала
		|ИЗ
		|	РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
		|ГДЕ
		|	РаботникиОрганизаций.Сотрудник = &Сотрудник
		|	И РаботникиОрганизаций.ВидЗанятости = &ВидЗанятости
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПериодНачала УБЫВ";
	Запрос.УстановитьПараметр("ВидЗанятости", Перечисления.ВидыЗанятости.ОсновноеМестоРаботы);
	Запрос.УстановитьПараметр("Сотрудник",Сотрудник);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Должность =  ВыборкаДетальныеЗаписи.Должность;
	КонецЦикла;
	
	Возврат Должность;
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
ПересчитатьЧасы()
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	//Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ЗаполнитьЧасы();
КонецПроцедуры

&НаСервере
Функция ПодписатьИОтправитьНаСервере()
	Успешно = ОбменWebRetailСервер.ПередатьДанныеНаСервер(Объект.Ссылка);
	Если Успешно Тогда
		Объект.Подписан = Истина;
	КонецЕсли;
	Возврат Успешно;
КонецФункции

&НаКлиенте
Процедура ПодписатьИОтправить(Команда)
	Если Модифицированность = Истина Тогда
		Ответ = Вопрос("Перед отправкой нужно записать документ. Вы хотите записать его сейчас?",РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		Записать(Новый Структура("РежимЗаписи",РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	Успешно = ПодписатьИОтправитьНаСервере();
	УстановитьДоступность();
	Если Успешно Тогда
		Записать(Новый Структура("РежимЗаписи",РежимЗаписиДокумента.Запись));
		Предупреждение("Документ успешно отправлен в отдел персонала!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()
	Если Объект.Подписан Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
		Элементы.ФормаКоманднаяПанель.ПодчиненныеЭлементы.ФормаПодписатьИОтправить.Доступность = Ложь;
		ЭтаФорма.Заголовок = "(ПОДПИСАН)";
	Иначе
		ЭтаФорма.Заголовок = "Табель учета рабочего времени №"+Объект.Номер+" от "+Объект.Дата;
		ЭтаФорма.ТолькоПросмотр = Ложь;
		Элементы.ФормаКоманднаяПанель.ПодчиненныеЭлементы.ФормаПодписатьИОтправить.Доступность = Истина;
	КонецЕсли;
	Если ДоступностьРоли("АдминистраторСистемы") Тогда
		Элементы.ФормаКомандаОтменитьПодпись.Видимость = Истина;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	 УстановитьДоступность();
	 
	 УстановитьВыборКомментария();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыборКомментария()
	СписокДоступныхКомментариев = Новый Массив;
	СписокДоступныхКомментариев.Добавить("отпуск");
	СписокДоступныхКомментариев.Добавить("не отсканировался");
	СписокДоступныхКомментариев.Добавить("не правильно отсканировался");
	СписокДоступныхКомментариев.Добавить("отсутствие света");
	СписокДоступныхКомментариев.Добавить("тревога");
	СписокДоступныхКомментариев.Добавить("технические проблемы");
	СписокДоступныхКомментариев.Добавить("отгул");
	СписокДоступныхКомментариев.Добавить("прогул");
	СписокДоступныхКомментариев.Добавить("болел");
	СписокДоступныхКомментариев.Добавить("дист.работа/работа в другой ТТ");
	
	Для н = 1 По 31 Цикл
		ЭлементФормыКомментарий = Элементы["ДанныеОВремениКомментарий"+н];	
		ЭлементФормыКомментарий.КнопкаВыпадающегоСписка = Истина;
		ЭлементФормыКомментарий.СписокВыбора.ЗагрузитьЗначения(СписокДоступныхКомментариев);
		ЭлементФормыКомментарий.РедактированиеТекста = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтменитьПодпись(Команда)
	Объект.Подписан = Ложь;
	УстановитьДоступность();	
КонецПроцедуры

&НаСервере
Функция ДоступностьРоли(НазваниеРоли)
	Возврат РольДоступна(НазваниеРоли);
КонецФункции



//&НаСервере
//Функция ПолучитьДолжность(Сотрудник)
//	Должность = Справочники.РаботаВыполняемаяСотрудниками.ПустаяСсылка();
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	РаботаВыполняемаяСотрудникамиСрезПоследних.РаботаВыполняемаяСотрудниками КАК Должность
//		|ИЗ
//		|	РегистрСведений.РаботаВыполняемаяСотрудниками.СрезПоследних КАК РаботаВыполняемаяСотрудникамиСрезПоследних
//		|ГДЕ
//		|	РаботаВыполняемаяСотрудникамиСрезПоследних.Сотрудник = &Сотрудник
//		|	И РаботаВыполняемаяСотрудникамиСрезПоследних.ОсновноеМестоРаботы = ИСТИНА";
//	Запрос.УстановитьПараметр("Сотрудник",Сотрудник);
//	РезультатЗапроса = Запрос.Выполнить();
//	
//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
//	
//	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
//		Должность =  ВыборкаДетальныеЗаписи.Должность;
//	КонецЦикла;
//	
//Возврат Должность;
//КонецФункции