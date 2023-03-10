////////////////////////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация"
// 
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

//  Возвращает код дополнительной части адреса для сериализации 
//
//  Параметры:
//      СтрокаЗначения - значение для поиска, например "Дом", "Корпус", "Литера"
//
Функция КодСериализацииОбъектаАдресации(СтрокаЗначения) Экспорт
	Ключ = ВРег(СокрЛП(СтрокаЗначения));
	Для Каждого Элемент Из КонтактнаяИнформацияКлиентСерверПовтИсп.ТипыОбъектовАдресацииАдресаРФ() Цикл
		Если Элемент.Ключ = Ключ Тогда
			Возврат Элемент.Код;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

//  Возвращает код дополнительной части адреса для почтового индекса
//
Функция КодСериализацииПочтовогоИндекса() Экспорт
	Возврат КонтактнаяИнформацияКлиентСерверПовтИсп.КодСериализацииОбъектаАдресации("Почтовый индекс");
КонецФункции

//  Возвращает XPath для почтового индекса
//
Функция XPathПочтовогоИндекса() Экспорт
	Возврат "ДопАдрЭл[ТипАдрЭл='" + КонтактнаяИнформацияКлиентСерверПовтИсп.КодСериализацииПочтовогоИндекса() + "']";
КонецФункции

//  Возвращает XPath для района
//
Функция XPathРайона() Экспорт
	Возврат "СвРайМО/Район";
КонецФункции

//  Возвращает XPath для дополнительного объекта адресации
//
//  Параметры;
//      СтрокаЗначения - искомый тип, например "Дом", "Корпус"
//
Функция XPathНомераДополнительногоОбъектаАдресации(СтрокаЗначения) Экспорт
	Код = КонтактнаяИнформацияКлиентСерверПовтИсп.КодСериализацииОбъектаАдресации(СтрокаЗначения);
	Если Код=Неопределено Тогда
		Код = СтрЗаменить(СтрокаЗначения, "'", "");
	КонецЕсли;
	Возврат "ДопАдрЭл/Номер[Тип='" + Код + "']";
КонецФункции

//  Возвращает строку с описанием типа по коду части адреса.
//  Противоположность функции "КодСериализацииОбъектаАдресации"
//
//  Параметры:
//      Код (Строка) - код
//
Функция ТипОбъектаПоКодуСериализации(Код) Экспорт
	Для Каждого Элемент Из КонтактнаяИнформацияКлиентСерверПовтИсп.ТипыОбъектовАдресацииАдресаРФ() Цикл
		Если Элемент.Код = Код Тогда
			Возврат Элемент;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

//  Возвращает пространство имен для оперирования с XDTO контактной информации
//
Функция ПространствоИмен() Экспорт
	Возврат "http://www.v8.1c.ru/ssl/contactinfo";
КонецФункции

//  Возвращает имя формы для редактирования типа контактной информации
//
//  Параметры:
//      ВидИнформации - запрашиваемый тип. Может принимать тип ПеречислениеСсылка.ТипыКонтактнойИнформации
//                      или СправочникСсылка.ВидыКонтактнойИнформации 
//
Функция ИмяФормыВводаКонтактнойИнформации(ВидИнформации) Экспорт
	
	Тип = ТипЗнч(ВидИнформации);
	Если Тип=Тип("ПеречислениеСсылка.ТипыКонтактнойИнформации") Тогда
		ТипИнформации = ВидИнформации;
	ИначеЕсли Тип=Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ТолстыйКлиентУправляемоеПриложение Или ВнешнееСоединение Тогда
		ТипИнформации = ВидИнформации.Тип;
#Иначе
		ТипИнформации = КонтактнаяИнформацияВызовСервера.ТипВидаКонтактнойИнформации(ВидИнформации);
#КонецЕсли
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	ВсеТипы = "Перечисление.ТипыКонтактнойИнформации.";
	Если ТипИнформации=ПредопределенноеЗначение(ВсеТипы + "Адрес") Тогда
		Возврат "Обработка.ВводКонтактнойИнформации.Форма.ВводАдреса";
		
	ИначеЕсли ТипИнформации=ПредопределенноеЗначение(ВсеТипы + "Телефон") Тогда
		Возврат "Обработка.ВводКонтактнойИнформации.Форма.ВводТелефона";
		
	ИначеЕсли ТипИнформации=ПредопределенноеЗначение(ВсеТипы + "Факс") Тогда
		Возврат "Обработка.ВводКонтактнойИнформации.Форма.ВводТелефона";
		
	ИначеЕсли ТипИнформации=ПредопределенноеЗначение(ВсеТипы + "ВебСтраница") Тогда
		Возврат "Обработка.ВводКонтактнойИнформации.Форма.ВводДругого";
		
	ИначеЕсли ТипИнформации=ПредопределенноеЗначение(ВсеТипы + "АдресЭлектроннойПочты") Тогда
		Возврат "Обработка.ВводКонтактнойИнформации.Форма.ВводДругого";
		
	ИначеЕсли ТипИнформации=ПредопределенноеЗначение(ВсеТипы + "Другое") Тогда
		Возврат "Обработка.ВводКонтактнойИнформации.Форма.ВводДругого";
		
	КонецЕсли;
	
	Возврат Неопределено;    
КонецФункции

//  Возвращает флаг того, что вид контактной информации можно активировать
//
//  Параметры:
//      ВидИнформации - запрашиваемый тип. Может принимать тип ПеречислениеСсылка.ТипыКонтактнойИнформации
//                      или СправочникСсылка.ВидыКонтактнойИнформации 
//
Функция ВидИнформацииМожноАктивировать(ВидИнформации) Экспорт
	
	Тип = ТипЗнч(ВидИнформации);
	Если Тип=Тип("ПеречислениеСсылка.ТипыКонтактнойИнформации") Тогда
		ТипИнформации = ВидИнформации;
	ИначеЕсли Тип=Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда         
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ТолстыйКлиентУправляемоеПриложение Или ВнешнееСоединение Тогда
		ТипИнформации = ВидИнформации.Тип;
#Иначе
		ТипИнформации = КонтактнаяИнформацияВызовСервера.ТипВидаКонтактнойИнформации(ВидИнформации);
#КонецЕсли
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	ВсеТипы = "Перечисление.ТипыКонтактнойИнформации.";
	Если ТипИнформации=ПредопределенноеЗначение(ВсеТипы + "АдресЭлектроннойПочты") Тогда
		Возврат Истина;
		
	ИначеЕсли ТипИнформации=ПредопределенноеЗначение(ВсеТипы + "ВебСтраница") Тогда
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

//  Возвращает массив вариантов наименований по типу (по признаку владения, строения, и т.п)
Функция НаименованияОбъектовАдресацииПоТипу(Тип, ДопускатьПовторыКода=Истина) Экспорт
	Результат = Новый Массив;
	Повторы   = Новый Соответствие;
	
	Для Каждого Элемент Из КонтактнаяИнформацияКлиентСерверПовтИсп.ТипыОбъектовАдресацииАдресаРФ() Цикл
		Если Элемент.Тип = Тип Тогда
			Если ДопускатьПовторыКода Тогда
				Результат.Добавить(Элемент.Наименование);
			Иначе
				Если Повторы.Получить(Элемент.Код)=Неопределено Тогда
					Результат.Добавить(Элемент.Наименование);
				КонецЕсли;
				Повторы.Вставить(Элемент.Код, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции    

//  Возвращает массив структур с информацией о частях адреса согласно приказу ФНС ММВ-7-1/525 от 31.08.2011
//
//  Поле структуры "Тип" принимает значения: 1 - владение, 2 - здание, 3 - помещение
//
Функция ТипыОбъектовАдресацииАдресаРФ() Экспорт
	
	Результат = Новый Массив;
	
	// Код, Наименование, Тип, Порядок, КодФИАС
	Результат.Добавить(СтрокаОбъектаАдресации("1010", "Дом",          1, 1, 2));
	Результат.Добавить(СтрокаОбъектаАдресации("1020", "Владение",     1, 2, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("1030", "Домовладение", 1, 3, 3));
	
	Результат.Добавить(СтрокаОбъектаАдресации("1050", "Корпус",     2, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("1060", "Строение",   2, 2, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("1080", "Литера",     2, 3, 3));
	Результат.Добавить(СтрокаОбъектаАдресации("1070", "Сооружение", 2, 4, 2));
	Результат.Добавить(СтрокаОбъектаАдресации("1040", "Участок",    2, 5));
	
	Результат.Добавить(СтрокаОбъектаАдресации("2010", "Квартира",  3, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("2030", "Офис",      3, 2));
	Результат.Добавить(СтрокаОбъектаАдресации("2040", "Бокс",      3, 3));
	Результат.Добавить(СтрокаОбъектаАдресации("2020", "Помещение", 3, 4));
	Результат.Добавить(СтрокаОбъектаАдресации("2050", "Комната",   3, 5));
	//  Наши сокращения для поддержки обратной совместимости при парсинге
	Результат.Добавить(СтрокаОбъектаАдресации("2010", "кв.",       3, 6));
	Результат.Добавить(СтрокаОбъектаАдресации("2030", "оф.",       3, 7));
	
	// Уточняющие объекты
	Результат.Добавить(СтрокаОбъектаАдресации("10100000", "Почтовый индекс"));
	Результат.Добавить(СтрокаОбъектаАдресации("10200000", "Адресная точка"));
	Результат.Добавить(СтрокаОбъектаАдресации("10300000", "Садовое товарищество"));
	Результат.Добавить(СтрокаОбъектаАдресации("10400000", "Элемент улично-дорожной сети, планировочной структуры дополнительного адресного элемента"));
	Результат.Добавить(СтрокаОбъектаАдресации("10500000", "Промышленная зона"));
	Результат.Добавить(СтрокаОбъектаАдресации("10600000", "Гаражно-строительный кооператив"));
	Результат.Добавить(СтрокаОбъектаАдресации("10700000", "Территория"));
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция СтрокаОбъектаАдресации(Код, Наименование, Тип=0, Порядок=0, КодФИАС=0)
	Возврат Новый Структура("Код, Наименование, Тип, Порядок, КодФИАС, Сокращение, Ключ",
		Код, Наименование, Тип, Порядок, КодФИАС, НРег(Наименование), ВРег(Наименование)
	);
КонецФункции

//	LNK 27.02.2019 06:45:39
Функция ПустоеНаименование()	Экспорт

	Возврат "##Клиент+IDN##";

КонецФункции // ПустоеНаименование()


