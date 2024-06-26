#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВозвратныйДокумент = Параметры.ВозвратныйДокумент;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	Если Не СтрДлина(Строка(Формат(НомерЭН, "ЧГ=;"))) = 14 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Номер електронної накладної має містити 14 цифр",
			"НомерЭН");
	Иначе
		
		Закрыть(СоздатьЭН(ВозвратныйДокумент, НомерЭН));
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СоздатьЭН(ВозвратныйДокумент, НомерЭН)

	СтруктураЭН = ОбменНПСервер.СтруктураОтветаПоЭНИнициализация(ВозвратныйДокумент);
	СтруктураЭН.НомерТТН = Формат(НомерЭН, "ЧГ=;");

	ЭлектроннаяНакладная = ОбменНПСервер.СоздатьДокументЭН(СтруктураЭН);
	
	ОбменНПСервер.ПолучитьСтатусТТН(, Формат(НомерЭН, "ЧГ=;"), Истина);
	
	Возврат ЭлектроннаяНакладная

КонецФункции

#КонецОбласти