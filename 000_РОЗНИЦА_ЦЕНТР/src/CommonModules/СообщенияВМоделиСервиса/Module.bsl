
///////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает новое сообщение.
//
// Параметры:
//  ТипТелаСообщения - ТипОбъектаXDTO - тип тела сообщения которое требуется создать
//
// Возвращаемое значение:
//  ОбъектXDTO - объект требуемого типа
Функция НовоеСообщение(Знач ТипТелаСообщения) Экспорт
	
	Сообщение = ФабрикаXDTO.Создать(СообщенияВМоделиСервисаПовтИсп.ТипСообщение());
	
	Сообщение.Header = ФабрикаXDTO.Создать(СообщенияВМоделиСервисаПовтИсп.ТипЗаголовокСообщения());
	Сообщение.Header.Id = Новый УникальныйИдентификатор;
	Сообщение.Header.Created = ТекущаяУниверсальнаяДата();
	
	Сообщение.Body = ФабрикаXDTO.Создать(ТипТелаСообщения);
	
	Возврат Сообщение;
	
КонецФункции

// Отправляет сообщение
//
// Параметры:
//  Сообщение - ОбъектXDTO - сообщение
//  Получатель - ПланОбменаСсылка.ОбменСообщениями - получатель сообщения
//  Сейчас - Булево - отправить сообщений через механизм быстрых сообщений
//
Процедура ОтправитьСообщение(Знач Сообщение, Знач Получатель = Неопределено, Знач Сейчас = Ложь) Экспорт
	
	Сообщение.Header.Sender = ОписаниеУзлаОбменаСообщениями(ПланыОбмена.ОбменСообщениями.ЭтотУзел());
	
	Если ЗначениеЗаполнено(Получатель) Тогда
		Сообщение.Header.Recipient = ОписаниеУзлаОбменаСообщениями(Получатель);
	КонецЕсли;
	
	СтруктураНастроек = РегистрыСведений.НастройкиТранспортаОбмена.НастройкиТранспортаWS(Получатель);
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("URL",      СтруктураНастроек.WSURLВебСервиса);
	ПараметрыПодключения.Вставить("UserName", СтруктураНастроек.WSИмяПользователя);
	ПараметрыПодключения.Вставить("Password", СтруктураНастроек.WSПароль);

	ТранслироватьСообщениеВВерсиюКорреспондентаПриНеобходимости(
		Сообщение, 
		ПараметрыПодключения,
		Строка(Получатель)
	);
	
	НетипизированноеТело = ЗаписатьСообщениеВНетипизированноеТело(Сообщение);
	
	КаналСообщений = ИмяКаналаПоТипуСообщения(Сообщение.Body.Тип());
	
	Если Сейчас Тогда
		ОбменСообщениями.ОтправитьСообщениеСейчас(КаналСообщений, НетипизированноеТело, Получатель);
	Иначе
		ОбменСообщениями.ОтправитьСообщение(КаналСообщений, НетипизированноеТело, Получатель);
	КонецЕсли;
	
КонецПроцедуры

// Получает список обработчиков сообщений по пространству имен
// 
// Параметры:
//  Обработчики - ТаблицаЗначений - состав полей см. в ОбменСообщениями.НоваяТаблицаОбработчиковСообщений
//  ПространствоИмен - Строка - uri пространства имен в котором определены типы тел сообщений
//  ОбщийМодуль - общий модуль в котором содержаться обработчики сообщений
// 
Процедура ПолучитьОбработчикиКаналовСообщений(Знач Обработчики, Знач ПространствоИмен, Знач ОбщийМодуль) Экспорт
	
	ИменаКаналов = СообщенияВМоделиСервисаПовтИсп.ПолучитьКаналыПакета(ПространствоИмен);
	
	Для каждого ИмяКанала Из ИменаКаналов Цикл
		Обработчик = Обработчики.Добавить();
		Обработчик.Канал = ИмяКанала;
		Обработчик.Обработчик = ОбщийМодуль;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает имя канала сообщений соответствующего типу сообщения.
//
// Параметры:
//  ТипСообщения - ТипОбъектаXDTO - тип сообщения удаленного администрирования
//
// Возвращаемое значение:
//  Строка - имя канала сообщений соответствующее переданному типу сообщения
//
Функция ИмяКаналаПоТипуСообщения(Знач ТипСообщения) Экспорт
	
	Возврат СериализаторXDTO.XMLСтрока(Новый РасширенноеИмяXML(ТипСообщения.URIПространстваИмен, ТипСообщения.Имя));
	
КонецФункции

// Возвращает тип сообщений удаленного администрирования по 
// имени канала сообщений
//
// Параметры:
//  ИмяКанала - Строка - имя канала сообщений соответствующее переданному типу сообщения
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - тип сообщения удаленного администрирования
//
Функция ТипСообщенияПоИмениКанала(Знач ИмяКанала) Экспорт
	
	Возврат ФабрикаXDTO.Тип(СериализаторXDTO.XMLЗначение(Тип("РасширенноеИмяXML"), ИмяКанала));
	
КонецФункции

// Вызывает исключение при получении сообщения в неизвестный канал.
//
// Параметры:
//  КаналСообщений - Строка - имя неизвестного канала сообщений.
//
Процедура ОшибкаНеизвестноеИмяКанала(Знач КаналСообщений) Экспорт
	
	ШаблонСообщения = НСтр("ru = 'Неизвестное имя канала сообщений %1'");
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КаналСообщений);
	ВызватьИсключение(ТекстСообщения);
	
КонецПроцедуры

// Читает сообщение из нетипизированного тела сообщения
//
// Параметры:
//  НетипизированноеТело - Строка - нетипизированное тело сообщения
//
// Возвращаемое значение:
//  {http://www.1c.ru/SaaS/Messages}Message - сообщение
//
Функция ПрочитатьСообщениеИзНетипизированногоТела(Знач НетипизированноеТело) Экспорт
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(НетипизированноеТело);
	
	Сообщение = ФабрикаXDTO.ПрочитатьXML(Чтение, СообщенияВМоделиСервисаПовтИсп.ТипСообщение());
	
	Чтение.Закрыть();
	
	Возврат Сообщение;
	
КонецФункции

// Записывает сообщение в нетипизированное тело сообщения
//
// Параметры:
//  Сообщение - {http://www.1c.ru/SaaS/Messages}Message - сообщение
//
// Возвращаемое значение:
//  Строка - нетипизированное тело сообщения
//
Функция ЗаписатьСообщениеВНетипизированноеТело(Знач Сообщение) Экспорт
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	ФабрикаXDTO.ЗаписатьXML(Запись, Сообщение, , , , НазначениеТипаXML.Явное);
	
	Возврат Запись.Закрыть();
	
КонецФункции

// Записывает в журнал регистрации событие начала обработки сообщения
//
// Параметры:
//  Сообщение - {http://www.1c.ru/SaaS/Messages}Message - сообщение
//
Процедура ЗаписатьСобытиеНачалоОбработки(Знач Сообщение) Экспорт
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Сообщения в модели сервиса. Начало обработки'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,
		,
		,
		ПредставлениеСообщенияДляЖурнала(Сообщение));
	
КонецПроцедуры

// Записывает в журнал регистрации событие окончания обработки сообщения
//
// Параметры:
//  Сообщение - {http://www.1c.ru/SaaS/Messages}Message - сообщение
//
Процедура ЗаписатьСобытиеОкончаниеОбработки(Знач Сообщение) Экспорт
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Сообщения в модели сервиса. Окончание обработки'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,
		,
		,
		ПредставлениеСообщенияДляЖурнала(Сообщение));
	
	КонецПроцедуры

// Выполняет доставку быстрых сообщений.
//
Процедура ДоставитьБыстрыеСообщения() Экспорт
	
	Если ТранзакцияАктивна() Тогда
		ВызватьИсключение(НСтр("ru = 'Доставка быстрых сообщений невозможна в транзакции'"));
	КонецЕсли;
	
	ИмяМетодаЗадания = "ОбменСообщениями.ДоставитьСообщения";
	КлючЗадания = 1;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОтборЗаданий = Новый Структура;
	ОтборЗаданий.Вставить("ИмяМетода", ИмяМетодаЗадания);
	ОтборЗаданий.Вставить("Ключ", КлючЗадания);
	ОтборЗаданий.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	
	Задания = ФоновыеЗадания.ПолучитьФоновыеЗадания(ОтборЗаданий);
	Если Задания.Количество() > 0 Тогда
		Попытка
			Задания[0].ОжидатьЗавершения(3);
		Исключение
			
			Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Задания[0].УникальныйИдентификатор);
			Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно
				И Задание.ИнформацияОбОшибке <> Неопределено Тогда
				
				ВызватьИсключение(ПодробноеПредставлениеОшибки(Задание.ИнформацияОбОшибке));
			КонецЕсли;
			
			Возврат;
		КонецПопытки;
	КонецЕсли;
		
	Попытка
		ФоновыеЗадания.Выполнить(ИмяМетодаЗадания, , КлючЗадания, НСтр("ru = 'Доставка быстрых сообщений'"))
	Исключение
		// Дополнительная обработка исключения не требуется
		// ожидаемое исключение - дублирование задания с таким же ключом
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Доставка быстрых сообщений'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , ,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Обработчик события перед отправкой сообщения.
// Обработчик данного события вызывается перед запись сообщения для последующей отправки
// Обработчик вызывается для каждого отправляемого сообщения.
//
//  Параметры:
// КаналСообщений (только чтение) Тип: Строка. Идентификатор канала сообщений, из которого получено сообщение.
// ТелоСообщения (чтение и запись) Тип: Произвольный. Тело записываемого сообщения.
//
Процедура ПередОтправкойСообщения(Знач КаналСообщений, Знач ТелоСообщения) Экспорт
	
	Если НЕ ОбщегоНазначения.ИспользованиеРазделителяСеанса() Тогда
		Возврат;
	КонецЕсли;
	
	Сообщение = Неопределено;
	Если ТелоСодержитТипизированноеСообщение(ТелоСообщения, Сообщение) Тогда
		Если СообщенияВМоделиСервисаПовтИсп.ТипТелоОбласти().ЭтоПотомок(Сообщение.Body.Тип()) Тогда
			Если ОбщегоНазначения.ЗначениеРазделителяСеанса() <> Сообщение.Body.Zone Тогда
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Сообщения в модели сервиса. Отправка сообщения'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					,
					,
					ПредставлениеСообщенияДляЖурнала(Сообщение));
					
				ШаблонОшибки = НСтр("ru = 'Ошибка при отправке сообщения. Область данных %1 не совпадает с текущей (%2).'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки, 
					Сообщение.Body.Zone, ОбщегоНазначения.ЗначениеРазделителяСеанса());
					
				ВызватьИсключение(ТекстОшибки);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события при отправке сообщения.
// Обработчик данного события вызывается перед помещением сообщения в XML-поток.
// Обработчик вызывается для каждого отправляемого сообщения.
//
//  Параметры:
// КаналСообщений (только чтение) Тип: Строка. Идентификатор канала сообщений, в который отправляется сообщение.
// ТелоСообщения (чтение и запись) Тип: Произвольный. Тело отправляемого сообщения.
// В обработчике события тело сообщения может быть изменено, например, дополнено информацией.
//
Процедура ПриОтправкеСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения) Экспорт
	
	Сообщение = Неопределено;
	Если ТелоСодержитТипизированноеСообщение(ТелоСообщения, Сообщение) Тогда
		
		Сообщение.Header.Sent = ТекущаяУниверсальнаяДата();
		ТелоСообщения = ЗаписатьСообщениеВНетипизированноеТело(Сообщение);
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Сообщения в модели сервиса. Отправка'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,
			,
			,
			ПредставлениеСообщенияДляЖурнала(Сообщение));
		
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("СообщенияВМоделиСервисаРазделениеДанных");
		Модуль.ПриОтправкеСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения);
		
	КонецЕсли;
	
	СообщенияВМоделиСервисаПереопределяемый.ПриОтправкеСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения);
	
КонецПроцедуры

// Обработчик события при получении сообщения.
// Обработчик данного события вызывается при получении сообщения из XML-потока.
// Обработчик вызывается для каждого получаемого сообщения.
//
//  Параметры:
// КаналСообщений (только чтение) Тип: Строка. Идентификатор канала сообщений, из которого получено сообщение.
// ТелоСообщения (чтение и запись) Тип: Произвольный. Тело полученного сообщения.
// В обработчике события тело сообщения может быть изменено, например, дополнено информацией.
//
Процедура ПриПолученииСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения) Экспорт
	
	Сообщение = Неопределено;
	Если ТелоСодержитТипизированноеСообщение(ТелоСообщения, Сообщение) Тогда
		
		Сообщение.Header.Delivered = ТекущаяУниверсальнаяДата();
		
		ТелоСообщения = ЗаписатьСообщениеВНетипизированноеТело(Сообщение);
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Сообщения в модели сервиса. Получение'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,
			,
			,
			ПредставлениеСообщенияДляЖурнала(Сообщение));
		
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("СообщенияВМоделиСервисаРазделениеДанных");
		Модуль.ПриПолученииСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения);
		
	КонецЕсли;
	
	СообщенияВМоделиСервисаПереопределяемый.ПриПолученииСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения);
	
КонецПроцедуры

Функция ОписаниеУзлаОбменаСообщениями(Знач Узел)
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Узел,
		Новый Структура("Код, Наименование"));
	
	Описание = ФабрикаXDTO.Создать(СообщенияВМоделиСервисаПовтИсп.ТипУзелОбменаСообщениями());
	Описание.Code = Реквизиты.Код;
	Описание.Presentation = Реквизиты.Наименование;
	
	Возврат Описание;
	
КонецФункции

// Для внутреннего использования
//
Функция ТелоСодержитТипизированноеСообщение(Знач НетипизированноеТело, Сообщение) Экспорт
	
	Если ТипЗнч(НетипизированноеТело) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Лев(НетипизированноеТело, 1) <> "<" ИЛИ Прав(НетипизированноеТело, 1) <> ">" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Чтение = Новый ЧтениеXML;
		Чтение.УстановитьСтроку(НетипизированноеТело);
		
		Сообщение = ФабрикаXDTO.ПрочитатьXML(Чтение);
		
		Чтение.Закрыть();
		
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Сообщение.Тип() = СообщенияВМоделиСервисаПовтИсп.ТипСообщение();
	
КонецФункции

Функция ПредставлениеСообщенияДляЖурнала(Знач Сообщение)
	
	Шаблон = НСтр("ru = 'Канал: %1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, 
		ИмяКаналаПоТипуСообщения(Сообщение.Body.Тип()));
		
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	ФабрикаXDTO.ЗаписатьXML(Запись, Сообщение.Header, , , , НазначениеТипаXML.Явное);
		
	Шаблон = НСтр("ru = 'Заголовок:
		|%1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Представление = Представление + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, 
		Запись.Закрыть());
		
	Если СообщенияВМоделиСервисаПовтИсп.ТипТелоОбласти().ЭтоПотомок(Сообщение.Body.Тип()) Тогда
		Шаблон = НСтр("ru = 'Область данных: %1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		Представление = Представление + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, 
			Формат(Сообщение.Body.Zone, "ЧН=0; ЧГ="));
	КонецЕсли;
		
	Возврат Представление;
	
КонецФункции

// Выполняет трансляцию отправляемого сообщения в версию, поддерживаемую ИБ-корреспондентом
//
// Параметры:
//  Сообщение: ОбъектXDTO, отправляемое сообщение
//  ИнформацияПодключения - структура, параметры подключения к ИБ-получателю
//  ПредставлениеПолучателя - строка, представление ИБ-получателя
//
// Возвращаемое значение:
//  ОбъектXDTO, сообщение, транслированное в версию ИБ-получателя
//
Процедура ТранслироватьСообщениеВВерсиюКорреспондентаПриНеобходимости(Сообщение, Знач ИнформацияПодключения, Знач ПредставлениеПолучателя) Экспорт
	
	ИнтерфейсСообщения = ТрансляцияXDTOСлужебный.ПолучитьИнтерфейсСообщения(Сообщение);
	Если ИнтерфейсСообщения = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не удалось определить интерфейс отправляемого сообщения: ни для одного из типов, используемых в сообщении, не зарегистрирован обработчик интерфейса!'");
	КонецЕсли;
	
	Если Не ИнформацияПодключения.Свойство("URL") 
			Или Не ЗначениеЗаполнено(ИнформацияПодключения.URL) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не задан URL сервиса обмена сообщениями с информационной базой %1'"), ПредставлениеПолучателя);
	КонецЕсли;
	
	ВерсияКорреспондента = ИнтерфейсыСообщенийВМоделиСервиса.ВерсияИнтерфейсаКорреспондента(
			ИнтерфейсСообщения.ПрограммныйИнтерфейс, ИнформацияПодключения, ПредставлениеПолучателя);
	
	Если ВерсияКорреспондента = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Корреспондент %1 не поддерживает получение версий сообщений интерфейса %2, поддерживаемых текущей информационной базой!'"),
			ПредставлениеПолучателя, ИнтерфейсСообщения.ПрограммныйИнтерфейс);
	КонецЕсли;
	
	ОтправляемаяВерсия = ИнтерфейсыСообщенийВМоделиСервиса.ПолучитьВерсииОтправляемыхСообщений().Получить(ИнтерфейсСообщения.ПрограммныйИнтерфейс);
	Если ОтправляемаяВерсия = ВерсияКорреспондента Тогда
		Возврат;
	КонецЕсли;
	
	Сообщение = ТрансляцияXDTO.ТранслироватьВВерсию(Сообщение, ВерсияКорреспондента, ИнтерфейсСообщения.ПространствоИмен);
	
КонецПроцедуры
