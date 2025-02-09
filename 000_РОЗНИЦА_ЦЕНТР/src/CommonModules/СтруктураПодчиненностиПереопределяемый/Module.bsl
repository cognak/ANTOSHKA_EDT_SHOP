
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Структура подчиненности"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Формирует массив реквизитов документа. 
// 
// Параметры: 
// ИмяДокумента - Строка - имя документа.
// 
// Возвращаемое значение: 
// Массив - массив наименований реквизитов документа. 
// 
Функция МассивДополнительныхРеквизитовДокумента(ИмяДокумента) Экспорт
	
	МассивДопРеквизитов = Новый Массив;
	
	
	
	Возврат МассивДопРеквизитов
	
КонецФункции

// Получает представление документа для печати
//
// Параметры
//  Выборка  - КоллекцияДанных - структура или выборка из результатов запроса
//                 в которой содержатся дополнительные реквизиты, на основании
//                 которых можно сформировать переопределенное представление до-
//                 кумента для вывода в отчет "Структура подчиненности"
//
// Возвращаемое значение:
//   Строка,Неопределено   - переопределенное представление документа, или Неопределено,
//                           если для данного типа документов такое не задано.
//
Функция ПолучитьПредставлениеДокументаДляПечати(Выборка) Экспорт

	//СЮП 06.08.2024 06.19.42 
	Если ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.ВозвратИнтернетЗаказа") Тогда
		
		ПредставлениеДокумента = Выборка.Представление;
		Если (Выборка.СуммаДокумента <> 0) И (Выборка.СуммаДокумента <> NULL) Тогда
			ПредставлениеДокумента = ПредставлениеДокумента + " " + НСтр("ru='на сумму'") + " " + Выборка.СуммаДокумента + ".";
		КонецЕсли;

		СтатусВозврата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Ссылка, "Статус");
		ПредставлениеДокумента = ПредставлениеДокумента + " Статус: " + Статусвозврата;
		
	Иначе
		
		ПредставлениеДокумента = Неопределено;
		
	КонецЕсли;
	
	Возврат ПредставлениеДокумента;	

КонецФункции
