////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьЭлементовФормы();
	
	Если ЗначениеЗаполнено(Запись.ВидТранспортаСообщенийОбменаПоУмолчанию) Тогда
		
		ИмяСтраницы = "НастройкиТранспорта[ВидТранспорта]";
		ИмяСтраницы = СтрЗаменить(ИмяСтраницы, "[ВидТранспорта]"
		, ОбщегоНазначения.ИмяЗначенияПеречисления(Запись.ВидТранспортаСообщенийОбменаПоУмолчанию));
		
		Если Элементы[ИмяСтраницы].Видимость Тогда
			
			Элементы.СтраницыВидовТранспорта.ТекущаяСтраница = Элементы[ИмяСтраницы];
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура FILEКаталогОбменаИнформациейНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайловогоКаталога(Запись, "FILEКаталогОбменаИнформацией", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура FILEКаталогОбменаИнформациейОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(Запись, "FILEКаталогОбменаИнформацией", СтандартнаяОбработка)
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПроверитьПодключениеFILE(Команда)
	
	ПроверитьПодключение("FILE");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеFTP(Команда)
	
	ПроверитьПодключение("FTP");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПроверитьПодключение(ВидТранспортаСтрокой)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	ПроверитьПодключениеНаСервере(Отказ, ВидТранспортаСтрокой);
	
	Если Отказ Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не удалось установить подключение.'"));
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Подключение успешно установлено.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеНаСервере(Отказ, ВидТранспортаСтрокой)
	
	ОбменДаннымиСервер.ПроверитьПодключениеОбработкиТранспортаСообщенийОбмена(Отказ, Запись, Перечисления.ВидыТранспортаСообщенийОбмена[ВидТранспортаСтрокой]);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	ИспользуемыеТранспорты = Новый Массив;
	ИспользуемыеТранспорты.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	ИспользуемыеТранспорты.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	
	Элементы.ВидТранспортаСообщенийОбменаПоУмолчанию.СписокВыбора.Очистить();
	
	Для Каждого Элемент Из ИспользуемыеТранспорты Цикл
		
		Элементы.ВидТранспортаСообщенийОбменаПоУмолчанию.СписокВыбора.Добавить(Элемент, Строка(Элемент));
		
	КонецЦикла;
	
КонецПроцедуры
