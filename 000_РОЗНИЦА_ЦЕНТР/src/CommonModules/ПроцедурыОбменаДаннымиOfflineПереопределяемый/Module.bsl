
// Функция создаёт узел для данного экземпляра подключаемого оборудования и возвращает ссылку на него
// Применяется перед записью элемента справочника Подключаемое оборудование
Функция ПолучитьУзелРИБ(ПодключаемоеОборудованиеОбъект) Экспорт
	
	УзелОбъект = ПланыОбмена.ОбменСПодключаемымОборудованиемOffline.СоздатьУзел();
	УзелОбъект.УстановитьНовыйКод();
	УзелОбъект.Наименование = ПодключаемоеОборудованиеОбъект.Наименование;
	УзелОбъект.Записать();
	
	Возврат УзелОбъект.Ссылка;
	
КонецФункции

// Функция возвращает параметры выбора для поля ввода ПравилоОбмена.
//
Функция ПолучитьПараметрыВыбораПравилаОбмена(ПодключаемоеОборудованиеОбъект) Экспорт
	
	Если ПодключаемоеОборудованиеОбъект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипПодключаемогоОборудования", Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток);
	ИначеЕсли ПодключаемоеОборудованиеОбъект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМOffline Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипПодключаемогоОборудования", Перечисления.ТипыПодключаемогоОборудования.ККМOffline);
	КонецЕсли;
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(НовыйПараметр);
	Возврат Новый ФиксированныйМассив(ПараметрыВыбора);
	
КонецФункции

// Функция возвращает префикс весового товара применяемого для генерации штрихкода.
// Используется при выгрузке в весы с печатью этикеток
Функция ПолучитьПрефиксВесовогоТовара(ПодключаемоеОборудованиеСсылка) Экспорт
	
	Префикс = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ПрефиксВнутреннегоШтрихкодаВесовогоТовара");
	Возврат Префикс;
	
КонецФункции

// Функция возвращает префикс штучного товара применяемого для генерации штрихкода.
// Используется при выгрузке в весы с печатью этикеток
Функция ПолучитьПрефиксШтучногоТовара(ПодключаемоеОборудованиеСсылка) Экспорт
	
	Префикс  = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ПрефиксВнутреннегоШтрихкодаШтучногоФасованногоТовара");
	Возврат Префикс;
	
КонецФункции
