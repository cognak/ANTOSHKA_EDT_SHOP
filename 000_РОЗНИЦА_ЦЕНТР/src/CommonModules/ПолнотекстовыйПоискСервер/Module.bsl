////////////////////////////////////////////////////////////////////////////////
// Подсистема "Полнотекстовый поиск".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обновляет индекс полнотекстового поиска.
//
Процедура ОбновлениеИндексаППД() Экспорт
	
	ОбновитьИндекс(НСтр("ru = 'Обновление индекса ППД'"), Ложь, Истина);
	
КонецПроцедуры

// Выполняет слияние индексов полнотекстового поиска.
//
Процедура СлияниеИндексаППД() Экспорт
	
	ОбновитьИндекс(НСтр("ru = 'Слияние индекса ППД'"), Истина);
	
КонецПроцедуры

// Возвращает, актуален ли индекс полнотекстового поиска.
//  Проверка функциональной опции "ИспользоватьПолнотекстовыйПоиск" выполняется в вызывающем коде.
//
Функция ИндексПоискаАктуален() Экспорт
	
	Возврат (
		// Операции не разрешены,
		// или индекс полностью соответствует текущему состоянию информационной базы,
		// или индекс обновлялся менее 5 минут назад.
		НЕ ОперацииРазрешены()
		ИЛИ ПолнотекстовыйПоиск.ИндексАктуален()
		ИЛИ ТекущаяДата() < ПолнотекстовыйПоиск.ДатаАктуальности() + 300 // Исключение из правила ТекущаяДатаСеанса().
	);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Добавление обработчиков служебных событий (подписок)

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"ПолнотекстовыйПоискСервер");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.0.0";
	Обработчик.Процедура = "ПолнотекстовыйПоискСервер.ИнициализироватьФункциональнуюОпциюПолнотекстовыйПоиск";
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры

// Устанавливает значение константы ИспользоватьПолнотекстовыйПоиск.
//  Используется для синхронизации значения
//  функциональной опции "ИспользоватьПолнотекстовыйПоиск"
//  с "ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска()".
//
Процедура ИнициализироватьФункциональнуюОпциюПолнотекстовыйПоиск() Экспорт
	
	ЗначениеКонстанты = ОперацииРазрешены();
	Константы.ИспользоватьПолнотекстовыйПоиск.Установить(ЗначениеКонстанты);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Общая процедура для обновления и слияния индекса ППД.
//
Процедура ОбновитьИндекс(ПредставлениеПроцедуры, РазрешитьСлияние = Ложь, Порциями = Ложь)
	
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Если НЕ ОперацииРазрешены() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписьЖурнала(Неопределено, НСтр("ru = 'Запуск процедуры ""%1"".'"), , ПредставлениеПроцедуры);
	
	Попытка
		ПолнотекстовыйПоиск.ОбновитьИндекс(РазрешитьСлияние, Порциями);
		ЗаписьЖурнала(Неопределено, НСтр("ru = 'Успешное завершение процедуры ""%1"".'"), , ПредставлениеПроцедуры);
	Исключение
		ЗаписьЖурнала(Неопределено, НСтр("ru = 'Ошибка выполнения процедуры ""%1"":'"), ИнформацияОбОшибке(), ПредставлениеПроцедуры);
	КонецПопытки;
	
КонецПроцедуры

// Возвращает разрешены ли операции полнотекстового поиска: обновление индексов, очистка индексов, поиск.
//
Функция ОперацииРазрешены()
	
	Возврат ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить;
	
КонецФункции

// Создает запись в журнале регистрации и сообщениях пользователю;
//   Поддерживает до 3х параметров в комментарии при помощи функции
//   СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку.
//   Поддерживает передачу информации об ошибке, подробное представление
//   ошибки добавляется в комментарий записи в журнал регистрации.
//
// Параметры:
//   УровеньЖурнала          (УровеньЖурналаРегистрации) Важность сообщения для администратора.
//   КомментарийСПараметрами (Строка) Комментарий, который может содержать параметры %1, %2 и %3.
//   ИнформацияОбОшибке      (...)    Информация об ошибке, которая будет размещена после комментария.
//       |- (ИнформацияОбОшибке)
//       |- (Строка)
//   Параметр1 (Строка) Для подстановки в КомментарийСПараметрами вместо %1.
//   Параметр2 (Строка) Для подстановки в КомментарийСПараметрами вместо %2.
//   Параметр3 (Строка) Для подстановки в КомментарийСПараметрами вместо %3.
//
Процедура ЗаписьЖурнала(УровеньЖурнала = Неопределено, КомментарийСПараметрами = "",
	ИнформацияОбОшибке = Неопределено,
	Параметр1 = Неопределено,
	Параметр2 = Неопределено,
	Параметр3 = Неопределено)
	
	// Определение уровня журнала регистрации на основе типа переданного сообщения об ошибке
	Если ТипЗнч(УровеньЖурнала) <> Тип("УровеньЖурналаРегистрации") Тогда
		Если ТипЗнч(ИнформацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
			УровеньЖурнала = УровеньЖурналаРегистрации.Ошибка;
		ИначеЕсли ТипЗнч(ИнформацияОбОшибке) = Тип("Строка") Тогда
			УровеньЖурнала = УровеньЖурналаРегистрации.Предупреждение;
		Иначе
			УровеньЖурнала = УровеньЖурналаРегистрации.Информация;
		КонецЕсли;
	КонецЕсли;
	
	// Комментарий для журнала регистрации
	ТекстДляЖурнала = КомментарийСПараметрами;
	Если Параметр1 <> Неопределено Тогда
		ТекстДляЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстДляЖурнала, Параметр1, Параметр2, Параметр3
		);
	КонецЕсли;
	Если ТипЗнч(ИнформацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
		ТекстДляЖурнала = ТекстДляЖурнала + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	ИначеЕсли ТипЗнч(ИнформацияОбОшибке) = Тип("Строка") Тогда
		ТекстДляЖурнала = ТекстДляЖурнала + Символы.ПС + ИнформацияОбОшибке;
	КонецЕсли;
	ТекстДляЖурнала = СокрЛП(ТекстДляЖурнала);
	
	// Запись в журнал регистрации 
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Полнотекстовое индексирование'"), 
		УровеньЖурнала, , , 
		ТекстДляЖурнала
	);
	
КонецПроцедуры

