
Функция ПолучитьТочкуВхода() Экспорт

	WSURLВебСервиса = "https://api.novaposhta.ua/v2.0/xml/";
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПараметрыСоединения.ServerAddress
		|ИЗ
		|	РегистрСведений.ПараметрыСоединения КАК ПараметрыСоединения
		|ГДЕ
		|	ПараметрыСоединения.Источник = ЗНАЧЕНИЕ(Перечисление.ВнешниеИсточники.НоваяПочта)
		|	И ПараметрыСоединения.Активен";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.ServerAddress) Тогда
			WSURLВебСервиса = Выборка.ServerAddress;
		КонецЕсли;
	КонецЦикла;
	
	Возврат  WSURLВебСервиса;
	
КонецФункции


Функция ПолучитьКлючAPI() Экспорт
	
	APIКлюч = "";

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПараметрыСоединения.Токен
		|ИЗ
		|	РегистрСведений.ПараметрыСоединения КАК ПараметрыСоединения
		|ГДЕ
		|	ПараметрыСоединения.Источник = ЗНАЧЕНИЕ(Перечисление.ВнешниеИсточники.НоваяПочта)
		|	И ПараметрыСоединения.Активен";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Токен) Тогда
			APIКлюч = ВыборкаДетальныеЗаписи.Токен;
		КонецЕсли;
	КонецЦикла;

	Возврат  APIКлюч;
	
КонецФункции



