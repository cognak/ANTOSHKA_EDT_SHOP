
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузкаСтарыхЦен   = Параметры.ЗагрузкаСтарыхЦен;
	ОкруглениеРучныхЦен = Параметры.ОкруглениеРучныхЦен;
	
	ЗагрузитьВидыЦен();
	
	ТолькоВыделенныеСтроки = 0;
	ТолькоНезаполненные    = 0;
	ДатаСтарыхЦен          = ТекущаяДатаСеанса();
	ПрименятьОкругление    = Истина;
	
	СпособыЗаданияЦенЗаполнятьПоДаннымИБ          = Перечисления.СпособыЗаданияЦен.ЗаполнятьПоДаннымИБ;
	СпособыЗаданияЦенРассчитыватьПоДругимВидамЦен = Перечисления.СпособыЗаданияЦен.РассчитыватьПоДругимВидамЦен;
	
	Элементы.ОК.Заголовок                                = ?(ЗагрузкаСтарыхЦен, "Загрузить", ?(ОкруглениеРучныхЦен, "Округлить", "Рассчитать"));
	Элементы.ВидыЦенПересчитать.Заголовок                = ?(ЗагрузкаСтарыхЦен, "Загрузить", ?(ОкруглениеРучныхЦен, "Округлить", "Пересчитать"));
	Элементы.ТолькоВыделенныеСтроки.Заголовок            = ?(ОкруглениеРучныхЦен, "Округлить строки документа", "Пересчитать строки документа");
	Элементы.ГруппаПараметрыПересчетаСтарыхЦен.Видимость = ЗагрузкаСтарыхЦен;
	Элементы.НадписьОкругление.Видимость                 = ОкруглениеРучныхЦен;
	Элементы.ВидыЦенСпособЗаданияЦены.Видимость          = Не ЗагрузкаСтарыхЦен И Не ОкруглениеРучныхЦен;
	Элементы.ТолькоНезаполненные.Видимость               = Не ОкруглениеРучныхЦен;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЧНОЙ ЧАСТИ "ВидыЦен"

// Процедура - обработчик события "Выбор" таблицы "ВыбранныеЦены".
//
&НаКлиенте
Процедура ВидыЦенВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначение(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Процедура - обработчик команды "ВидыЦенВыбратьВсе".
//
&НаКлиенте
Процедура ВидыЦенВыбратьВсе(Команда)
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если Не ВидЦены.Пересчитать Тогда
			ВидЦены.Пересчитать = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура - обработчик команды "ВидыЦенСброситьВсе".
//
&НаКлиенте
Процедура ВидыЦенИсключитьВсе(Команда)
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если ВидЦены.Пересчитать Тогда
			ВидЦены.Пересчитать = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура - обработчик команды "ОК".
//
&НаКлиенте
Процедура ОК(Команда)
	
	МассивВидовЦен = Новый Массив();
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		
		Если ВидЦены.Пересчитать Тогда
			МассивВидовЦен.Добавить(ВидЦены.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Результат = Новый Структура();
	Результат.Вставить("ЗагрузкаСтарыхЦен",      ЗагрузкаСтарыхЦен);
	Результат.Вставить("ОкруглениеРучныхЦен",    ОкруглениеРучныхЦен);
	Результат.Вставить("ВидыЦен",                МассивВидовЦен);
	Результат.Вставить("ТолькоВыделенныеСтроки", ТолькоВыделенныеСтроки = 1);
	Результат.Вставить("ТолькоНезаполненные",    ТолькоНезаполненные = 1);
	
	Если ЗагрузкаСтарыхЦен Тогда
		
		Результат.Вставить("ДатаСтарыхЦен",        ДатаСтарыхЦен);
		Результат.Вставить("ПроцентИзмененияЦены", ПроцентИзмененияЦены);
		Результат.Вставить("ПрименятьОкругление",  ПрименятьОкругление);
		
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура загружает виды цен в таблицу ВидыЦен в порядке,
// соответвующим порядку в документе
&НаСервере
Процедура ЗагрузитьВидыЦен()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыЦен.Ссылка            КАК Ссылка,
		|	ВидыЦен.СпособЗаданияЦены КАК СпособЗаданияЦены,
		|	ВЫБОР
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.Вручную)
		|		ТОГДА
		|			0
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗаполнятьПоДаннымИБ)
		|		ТОГДА
		|			1
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.РассчитыватьПоДругимВидамЦен)
		|		ТОГДА
		|			2
		|	КОНЕЦ КАК ИндексКартинки
		|ИЗ
		|	Справочник.ВидыЦен КАК ВидыЦен
		|ГДЕ
		|	ВидыЦен.Ссылка В(&МассивВидовЦен)";
		
	Запрос.УстановитьПараметр("МассивВидовЦен", Параметры.ВидыЦен);
	ТаблицаВидовЦен = Запрос.Выполнить().Выгрузить();
	
	// Для того, чтобы виды цен в списке были в том же порядке, как и на форме документа,
	// загружаем их вручную
	Для Каждого ВидЦен Из Параметры.ВидыЦен Цикл
		
		НайденныйВидЦен = ТаблицаВидовЦен.Найти(ВидЦен, "Ссылка");
		
		СтрокаВидаЦен                   = ВидыЦен.Добавить();
		СтрокаВидаЦен.Ссылка            = ВидЦен;
		СтрокаВидаЦен.СпособЗаданияЦены = НайденныйВидЦен.СпособЗаданияЦены;
		СтрокаВидаЦен.Пересчитать = Истина;
		СтрокаВидаЦен.ИндексКартинки    = НайденныйВидЦен.ИндексКартинки;
		
	КонецЦикла;
	
КонецПроцедуры
