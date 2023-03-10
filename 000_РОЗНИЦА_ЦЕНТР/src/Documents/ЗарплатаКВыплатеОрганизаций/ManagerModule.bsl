#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает информацию по платежной ведомости:
// - результат запроса 1, содержит информацию выплаченной зарплаты работнику (оформлен расходный кассовый ордер).
// - результат запроса 2, содержит информацию, что ведомость оплачена полностью и признак, что ведомость оплачена частично
//
Функция ДанныеПоВыплаченностиВедомости(Объект) Экспорт
	Запрос = Новый Запрос();
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗарплатаТаблицаФормы.НомерСтроки КАК НомерСтроки,
	|	ЗарплатаТаблицаФормы.ФизЛицо     КАК ФизЛицо
	|ПОМЕСТИТЬ ЗарплатаТаблицаФормы
	|ИЗ
	|	&ЗарплатаТаблицаФормы КАК ЗарплатаТаблицаФормы
	|;
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеОрганизацийЗарплата.НомерСтроки           КАК НомерСтроки,
	|	ЗарплатаКВыплатеОрганизацийЗарплата.ФизЛицо               КАК ФизЛицо,
	|	ЗарплатаКВыплатеОрганизацийЗарплата.ВыплаченностьЗарплаты КАК ВыплаченностьЗарплаты,
	|	ВЫБОР	КОГДА ВыплаченнаяЗарплата.Регистратор ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|	КОНЕЦ                                                     КАК ФлагРКО,
	|	ЕСТЬNULL(ВыплаченнаяЗарплата.Регистратор, ЗНАЧЕНИЕ(Документ.РасходныйКассовыйОрдер.ПустаяСсылка)) КАК РКО,
	|	ПРЕДСТАВЛЕНИЕ(ВыплаченнаяЗарплата.Регистратор)            КАК ПредставлениеРКО
	|ИЗ
	|	ЗарплатаТаблицаФормы КАК ЗарплатаТаблицаФормы
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.ЗарплатаКВыплатеОрганизаций.Зарплата КАК ЗарплатаКВыплатеОрганизацийЗарплата
	|ПО
	|	ЗарплатаКВыплатеОрганизацийЗарплата.НомерСтроки = ЗарплатаТаблицаФормы.НомерСтроки
	|	И ЗарплатаКВыплатеОрганизацийЗарплата.ФизЛицо = ЗарплатаТаблицаФормы.ФизЛицо
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ВыплаченнаяЗарплата КАК ВыплаченнаяЗарплата
	|ПО
	|	ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка = ВыплаченнаяЗарплата.ПлатежнаяВедомость
	|	И ЗарплатаКВыплатеОрганизацийЗарплата.Физлицо = ВыплаченнаяЗарплата.Работник
	|	И ЗарплатаКВыплатеОрганизацийЗарплата.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Выплачено)
	|ГДЕ
	|	ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка = &Ссылка
	|;
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка КАК Ссылка,
	|	ВЫБОР	КОГДА СУММА(ЕСТЬNULL(ЗарплатаКВыплатеОрганизацийЗарплата.Сумма, 0.00)) = СУММА(ЕСТЬNULL(ВыплаченнаяЗарплата.Сумма, 0.00))
	|			ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                      КАК ВедомостьОплаченаПолностью,
	|	ВЫБОР	КОГДА СУММА(ЕСТЬNULL(ВыплаченнаяЗарплата.Сумма, 0.00)) > 0.00
	|			ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                      КАК ВедомостьОплаченаНеПолностью
	|ИЗ
	|	Документ.ЗарплатаКВыплатеОрганизаций.Зарплата КАК ЗарплатаКВыплатеОрганизацийЗарплата
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ВыплаченнаяЗарплата КАК ВыплаченнаяЗарплата
	|ПО
	|	ВыплаченнаяЗарплата.ПлатежнаяВедомость = &Ссылка
	|	И ВыплаченнаяЗарплата.Работник = ЗарплатаКВыплатеОрганизацийЗарплата.ФизЛицо
	|ГДЕ
	|	ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка = &Ссылка
	|	И (ЗарплатаКВыплатеОрганизацийЗарплата.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Выплачено)
	|	ИЛИ ЗарплатаКВыплатеОрганизацийЗарплата.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.НеВыплачено))
	|СГРУППИРОВАТЬ ПО
	|	ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка
	|";
	
	Запрос.УстановитьПараметр("ЗарплатаТаблицаФормы", Объект.Зарплата.Выгрузить());
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	МассивРезультатовЗапросов = Запрос.ВыполнитьПакет();
	возврат МассивРезультатовЗапросов;
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает результат запроса с данными для печати
//
// Параметры:
//  Режим - Строка - выборка данных для печати шапки документа либо выборка для печати данных по работникам ведомости.
//
// Возвращаемое значение:
//  Результат запроса - данные для печати 
//
Функция РезультатЗапросаДанныхВедомостиДляПечати(Режим, ДанныеПечати)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", ДанныеПечати.Ссылка);
	Запрос.УстановитьПараметр("ДатаДокумента", ДанныеПечати.Дата);
	Запрос.УстановитьПараметр("Задепонировано", Перечисления.ВыплаченностьЗарплаты.Задепонировано);
	Запрос.УстановитьПараметр("Выплачено", Перечисления.ВыплаченностьЗарплаты.Выплачено);

	Если Режим = "ПоРеквизитамДокумента" Тогда

		Запрос.УстановитьПараметр("Руководитель", Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
		Запрос.УстановитьПараметр("ГлавныйБухгалтер", Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
		Запрос.УстановитьПараметр("НомерДок", ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ДанныеПечати.Номер, ПустаяСтрока(ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы")), Истина));
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	&НомерДок                                                  КАК НомерДок,
		|	ЗарплатаКВыплатеОрганизаций.Дата                           КАК ДатаДок,
		|	ЗарплатаКВыплатеОрганизаций.Организация                    КАК Организация,
		|	ЗарплатаКВыплатеОрганизаций.Организация.НаименованиеПолное КАК НазваниеОрганизации,
		|	ЗарплатаКВыплатеОрганизаций.Организация.КодПоЕДРПОУ          КАК КодПоЕДРПОУ,
		|	ЕСТЬNULL(СправочникМагазины.Наименование, """")            КАК Подразделение,
		|	ЕСТЬNULL(ФИОФизЛицСрезПоследнихРуководитель.Фамилия +
		|			ВЫБОР	КОГДА ПОДСТРОКА(ФИОФизЛицСрезПоследнихРуководитель.Имя, 1, 1) <> """"
		|					ТОГДА "" "" + ПОДСТРОКА(ФИОФизЛицСрезПоследнихРуководитель.Имя, 1, 1) + "".""
		|					ИНАЧЕ """"
		|			КОНЕЦ +
		|			ВЫБОР	КОГДА ПОДСТРОКА(ФИОФизЛицСрезПоследнихРуководитель.Отчество, 1, 1) <> """"
		|					ТОГДА "" "" + ПОДСТРОКА(ФИОФизЛицСрезПоследнихРуководитель.Отчество, 1, 1) + "".""
		|					ИНАЧЕ """"
		|			КОНЕЦ, ОтветственныеЛицаОрганизацийСрезПоследнихРуководитель.ФизическоеЛицо.Наименование) КАК ФИОРуководителя,
		|	ОтветственныеЛицаОрганизацийСрезПоследнихРуководитель.Должность.Наименование КАК ДолжностьРуководителя,
		|	ЕСТЬNULL(ФИОФизЛицСрезПоследнихГлБух.Фамилия +
		|			ВЫБОР	КОГДА ПОДСТРОКА(ФИОФизЛицСрезПоследнихГлБух.Имя, 1, 1) <> """"
		|					ТОГДА "" "" + ПОДСТРОКА(ФИОФизЛицСрезПоследнихГлБух.Имя, 1, 1) + "".""
		|					ИНАЧЕ """"
		|			КОНЕЦ +
		|			ВЫБОР	КОГДА ПОДСТРОКА(ФИОФизЛицСрезПоследнихГлБух.Отчество, 1, 1) <> """"
		|					ТОГДА "" "" + ПОДСТРОКА(ФИОФизЛицСрезПоследнихГлБух.Отчество, 1, 1) + "".""
		|					ИНАЧЕ """"
		|			КОНЕЦ, ОтветственныеЛицаОрганизацийСрезПоследнихГлБух.ФизическоеЛицо.Наименование) КАК ФИОГлБуха,
		|	ЕСТЬNULL(ЗарплатаКВыплатеОрганизацийЗарплата.Сумма, 0.00)             КАК Сумма,
		|	ЕСТЬNULL(ЗарплатаКВыплатеОрганизацийЗарплата.ВсегоВыплачено, 0.00)    КАК ВсегоВыплачено,
		|	ЕСТЬNULL(ЗарплатаКВыплатеОрганизацийЗарплата.ВсегоДепонировано, 0.00) КАК ВсегоДепонировано,
		|	ВЫБОР	КОГДА ЕСТЬNULL(ЗарплатаКВыплатеОрганизацийЗарплата.Сумма, 0.00) = ЕСТЬNULL(ЗарплатаКВыплатеОрганизацийЗарплата.ОплаченныеСуммы, 0.00)
		|			ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ                                                                 КАК ОплаченоПолностью,
		|	ЗарплатаКВыплатеОрганизацийЗарплата.КоличествоРКО                     КАК КоличествоРКО
		|ИЗ
		|	Документ.ЗарплатаКВыплатеОрганизаций КАК ЗарплатаКВыплатеОрганизаций
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	Справочник.Магазины КАК СправочникМагазины
		|ПО
		|	СправочникМагазины.Ссылка = ЗарплатаКВыплатеОрганизаций.Магазин
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&ДатаДокумента, ОтветственноеЛицо = &Руководитель) КАК ОтветственныеЛицаОрганизацийСрезПоследнихРуководитель
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ФИОФизЛиц.СрезПоследних(&ДатаДокумента, ) КАК ФИОФизЛицСрезПоследнихРуководитель
		|ПО
		|	ОтветственныеЛицаОрганизацийСрезПоследнихРуководитель.ФизическоеЛицо = ФИОФизЛицСрезПоследнихРуководитель.ФизЛицо
		|ПО
		|	ЗарплатаКВыплатеОрганизаций.Организация = ОтветственныеЛицаОрганизацийСрезПоследнихРуководитель.СтруктурнаяЕдиница
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&ДатаДокумента, ОтветственноеЛицо = &ГлавныйБухгалтер) КАК ОтветственныеЛицаОрганизацийСрезПоследнихГлБух
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ФИОФизЛиц.СрезПоследних(&ДатаДокумента, ) КАК ФИОФизЛицСрезПоследнихГлБух
		|ПО
		|	ОтветственныеЛицаОрганизацийСрезПоследнихГлБух.ФизическоеЛицо = ФИОФизЛицСрезПоследнихГлБух.ФизЛицо
		|ПО
		|	ЗарплатаКВыплатеОрганизаций.Организация = ОтветственныеЛицаОрганизацийСрезПоследнихГлБух.СтруктурнаяЕдиница
		|ЛЕВОЕ СОЕДИНЕНИЕ (
		|		ВЫБРАТЬ
		|			ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка КАК Ссылка,
		|			СУММА(ЗарплатаКВыплатеОрганизацийЗарплата.Сумма) КАК Сумма,
		|			СУММА(	ВЫБОР	КОГДА ЗарплатаКВыплатеОрганизацийЗарплата.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Задепонировано)
		|							ТОГДА ЗарплатаКВыплатеОрганизацийЗарплата.Сумма
		|							ИНАЧЕ 0.00
		|					КОНЕЦ) КАК ВсегоДепонировано,
		|			СУММА(	ВЫБОР	КОГДА ЗарплатаКВыплатеОрганизацийЗарплата.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Выплачено)
		|							ТОГДА ЗарплатаКВыплатеОрганизацийЗарплата.Сумма
		|							ИНАЧЕ 0.00
		|					КОНЕЦ) КАК ВсегоВыплачено,
		|			СУММА(	ВЫБОР	КОГДА СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.Регистратор ЕСТЬ НЕ NULL 
		|							ТОГДА ЗарплатаКВыплатеОрганизацийЗарплата.Сумма
		|							ИНАЧЕ 0.00
		|					КОНЕЦ) КАК ОплаченныеСуммы,
		|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫРАЗИТЬ(СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.Регистратор КАК Документ.РасходныйКассовыйОрдер)) КАК КоличествоРКО
		|		ИЗ
		|			Документ.ЗарплатаКВыплатеОрганизаций.Зарплата КАК ЗарплатаКВыплатеОрганизацийЗарплата
		|		ЛЕВОЕ СОЕДИНЕНИЕ
		|			РегистрСведений.ВыплаченнаяЗарплата КАК СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям
		|		ПО
		|			ЗарплатаКВыплатеОрганизацийЗарплата.Физлицо = СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.Работник
		|			И ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка = СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.ПлатежнаяВедомость
		|		ГДЕ
		|			ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка = &ДокументСсылка
		|		СГРУППИРОВАТЬ ПО
		|			ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка
		|	) КАК ЗарплатаКВыплатеОрганизацийЗарплата
		|		ПО ЗарплатаКВыплатеОрганизаций.Ссылка = ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка
		|ГДЕ
		|	ЗарплатаКВыплатеОрганизаций.Ссылка = &ДокументСсылка";

	ИначеЕсли Режим = "ПоТабличнойЧастиДокумента" Тогда
		
		Запрос.УстановитьПараметр("Организация", ДанныеПечати.Организация);
	
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗарплатаКВыплатеОрганизацийЗарплата.НомерСтроки    КАК НомерСтроки,
		|	ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия +
		|		ВЫБОР	КОГДА ПОДСТРОКА(ФИОФизЛицСрезПоследних.Имя, 1, 1) <> """"
		|				ТОГДА "" "" + ПОДСТРОКА(ФИОФизЛицСрезПоследних.Имя, 1, 1) + "".""
		|				ИНАЧЕ """"
		|		КОНЕЦ +
		|		ВЫБОР	КОГДА ПОДСТРОКА(ФИОФизЛицСрезПоследних.Отчество, 1, 1) <> """"
		|				ТОГДА "" "" + ПОДСТРОКА(ФИОФизЛицСрезПоследних.Отчество, 1, 1) + "".""
		|				ИНАЧЕ """"
		|		КОНЕЦ, ЗарплатаКВыплатеОрганизацийЗарплата.Физлицо.Наименование) КАК ФизЛицо,
		|	ЗарплатаКВыплатеОрганизацийЗарплата.ТабельныйНомер КАК ТабельныйНомер,
		|	ЗарплатаКВыплатеОрганизацийЗарплата.Сумма          КАК Сумма,
		|	ВЫБОР	КОГДА ЗарплатаКВыплатеОрганизацийЗарплата.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Выплачено)
		|				И СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.Регистратор ЕСТЬ НЕ NULL
		|			ТОГДА СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.Регистратор.Представление
		|			ИНАЧЕ """"
		|	КОНЕЦ                                              КАК ПредставлениеДокумента,
		|	ВЫБОР	КОГДА ЗарплатаКВыплатеОрганизацийЗарплата.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Выплачено)
		|				И СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.Регистратор ЕСТЬ НЕ NULL
		|			ТОГДА СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.Регистратор.Номер
		|			ИНАЧЕ """"
		|	КОНЕЦ                                              КАК НомерРКО,
		|	ВЫБОР	КОГДА ЗарплатаКВыплатеОрганизацийЗарплата.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Выплачено)
		|				И СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.Регистратор ЕСТЬ НЕ NULL
		|			ТОГДА СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.Регистратор.Дата
		|			ИНАЧЕ """"
		|	КОНЕЦ                                              КАК ДатаРКО,
		|	ВЫБОР	КОГДА ЗарплатаКВыплатеОрганизацийЗарплата.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Задепонировано)
		|			ТОГДА ""Депоновано""
		|			ИНАЧЕ """"
		|	КОНЕЦ                                              КАК ЗаписьОДепонировании
		|ИЗ
		|	Документ.ЗарплатаКВыплатеОрганизаций.Зарплата КАК ЗарплатаКВыплатеОрганизацийЗарплата
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ФИОФизЛиц.СрезПоследних(
		|		&ДатаДокумента,
		|		Физлицо В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				ЗарплатаКВыплатеОрганизацийЗарплата.Физлицо КАК Физлицо
		|			ИЗ
		|				Документ.ЗарплатаКВыплатеОрганизаций.Зарплата КАК ЗарплатаКВыплатеОрганизацийЗарплата
		|			ГДЕ
		|				ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка = &ДокументСсылка)
		|	) КАК ФИОФизЛицСрезПоследних
		|ПО
		|	ЗарплатаКВыплатеОрганизацийЗарплата.Физлицо = ФИОФизЛицСрезПоследних.ФизЛицо
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ВыплаченнаяЗарплата КАК СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям
		|ПО
		|	ЗарплатаКВыплатеОрганизацийЗарплата.Физлицо = СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.Работник
		|	И ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка = СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям.ПлатежнаяВедомость
		|ГДЕ
		|	ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка = &ДокументСсылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";

	Иначе
		Возврат Неопределено
	КонецЕсли;

	Возврат Запрос.Выполнить();

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Печать

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Ведомость") Тогда
	
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Ведомость",
				"Платежная ведомость",
				СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает табличный документ печатной формы.
//
// Возвращаемое значение:
//   Табличный документ - печатная форма 
//
Функция СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати)


	ТабДокумент = Новый ТабличныйДокумент;
	СинонимДокумента   = НСтр("ru='Ведомость'");
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗарплатаКВыплатеОрганизаций_Ведомость";
	ТабДокумент.ПолеСлева = 15;
	ТабДокумент.ПолеСправа = 15;
	Запрос = Новый Запрос();
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗарплатаКВыплатеОрганизаций.Ссылка                   КАК Ссылка,
	|	ЗарплатаКВыплатеОрганизаций.Дата                     КАК Дата,
	|	ЗарплатаКВыплатеОрганизаций.Организация              КАК Организация,
	|	ЗарплатаКВыплатеОрганизаций.ПериодРегистрации        КАК ПериодРегистрации,
	|	ЕСТЬNULL(СправочникМагазины.Наименование, """")      КАК ПодразделениеОрганизации,
	|	ЗарплатаКВыплатеОрганизаций.Номер                    КАК Номер
	|ИЗ
	|	Документ.ЗарплатаКВыплатеОрганизаций КАК ЗарплатаКВыплатеОрганизаций
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Справочник.Магазины КАК СправочникМагазины
	|ПО
	|	СправочникМагазины.Ссылка = ЗарплатаКВыплатеОрганизаций.Магазин
	|ГДЕ
	|	ЗарплатаКВыплатеОрганизаций.Ссылка В (&МассивОбъектов)
	|";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Макет = ПолучитьМакет("Ведомость");
	ДанныеПечати = Запрос.Выполнить().Выбрать();
	Пока ДанныеПечати.Следующий() Цикл
		// получаем данные для печати
		ВыборкаДляШапки   = РезультатЗапросаДанныхВедомостиДляПечати("ПоРеквизитамДокумента", ДанныеПечати).Выбрать();
		ВыборкаРаботники = РезультатЗапросаДанныхВедомостиДляПечати("ПоТабличнойЧастиДокумента", ДанныеПечати).Выбрать();
		
		// подсчитываем количество страниц документа - для корректного разбиения на страницы
		ВсегоСтрокДокумента = ВыборкаРаботники.Количество();
		
		ОбластьМакетаШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
		ОбластьМакетаШапка          = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакетаСтрока         = Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаИтогПоСтранице = Макет.ПолучитьОбласть("ИтогПоЛисту");
		ОбластьМакетаПодвал         = Макет.ПолучитьОбласть("Подвал");
		
		// массив с двумя строками - для разбиения на страницы
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		ВыводимыеОбласти.Добавить(ОбластьМакетаИтогПоСтранице);
		

		// выводим данные о руководителях организации
		Пока ВыборкаДляШапки.Следующий() Цикл
			СведенияОбОрганизации = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата);
			
			ОбластьМакетаШапкаДокумента.Параметры.Подразделение = Строка(ДанныеПечати.ПодразделениеОрганизации);
			ОбластьМакетаШапкаДокумента.Параметры.Заполнить(ВыборкаДляШапки); // Шапка документа.
			ОбластьМакетаШапкаДокумента.Параметры.НазваниеОрганизации = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,");
			ОбластьМакетаШапкаДокумента.Параметры.ДатаВыплаты = ДанныеПечати.ПериодРегистрации;
			
			СуммаДок = ?(ВыборкаДляШапки.Сумма = NULL, 0, ВыборкаДляШапки.Сумма);
			СтрокаСуммы = ФормированиеПечатныхФормСервер.СформироватьСуммуПрописью(СуммаДок,,"uk");
			СтрокаСуммы = СтрокаСуммы + " (" + Цел(СуммаДок) + " грн. " + Формат((СуммаДок - Цел(СуммаДок)) * 100, "ЧЦ=2; ЧН=00; ЧВН=") + " коп.)";
		    ОбластьМакетаШапкаДокумента.Параметры.СуммаДок = СтрокаСуммы;
			
			СуммаДепонировано = ?(ВыборкаДляШапки.ВсегоДепонировано = NULL, 0, ВыборкаДляШапки.ВсегоДепонировано);
			Если СуммаДепонировано > 0 Тогда
				ОбластьМакетаШапкаДокумента.Параметры.СуммаЗадеп = ФормированиеПечатныхФормСервер.СформироватьСуммуПрописью(СуммаДепонировано,,"uk");
			Иначе
				ОбластьМакетаШапкаДокумента.Параметры.СуммаЗадеп = ("");
			КонецЕсли;
			
			СуммаВыплачено = ?(ВыборкаДляШапки.ВсегоВыплачено = NULL, 0, ВыборкаДляШапки.ВсегоВыплачено);
			Если СуммаВыплачено > 0 Тогда
				ОбластьМакетаШапкаДокумента.Параметры.СуммаВып = ФормированиеПечатныхФормСервер.СформироватьСуммуПрописью(СуммаВыплачено,,"uk");
			Иначе
				ОбластьМакетаШапкаДокумента.Параметры.СуммаВып = ("");
			КонецЕсли;
			
			ОбластьМакетаШапкаДокумента.Параметры.НомерВедомости           = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ДанныеПечати.Номер, Истина, Истина);
			
		КонецЦикла;
		
		ТабДокумент.Вывести(ОбластьМакетаШапкаДокумента);
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ТабДокумент.Вывести(ОбластьМакетаШапка);
		
		ВыведеноСтраниц = 1; ВыведеноСтрок = 0; ИтогоНаСтранице = 0;
		// выводим данные по строкам документа.
		Пока ВыборкаРаботники.Следующий() Цикл
		
			ОбластьМакетаСтрока.Параметры.Заполнить(ВыборкаРаботники);
			СокращенноеПредставлениеДокумента = "";
			Если ЗначениеЗаполнено(ВыборкаРаботники.НомерРКО) Тогда
				СокращенноеПредставлениеДокумента = "№" + ВыборкаРаботники.НомерРКО + " от " + Формат(ВыборкаРаботники.ДатаРКО, "ДЛФ=Д");
			КонецЕсли;
			
			// разбиение на страницы
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу
			ВывестиПодвалЛиста = Не ТабДокумент.ПроверитьВывод(ВыводимыеОбласти);
			Если Не ВывестиПодвалЛиста и ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ТабДокумент.ПроверитьВывод(ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				
				ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
				ТабДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабДокумент.Вывести(ОбластьМакетаШапка);
				ВыведеноСтраниц = ВыведеноСтраниц + 1;
				ИтогоНаСтранице = 0;
				
			КонецЕсли;
			
			ТабДокумент.Вывести(ОбластьМакетаСтрока);
			ИтогоНаСтранице = ИтогоНаСтранице + ВыборкаРаботники.Сумма;
			
		КонецЦикла;
		
		ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
		ТабДокумент.Область("R23C10").Текст = ?(ВыведеноСтрок = 0,"",ВыведеноСтраниц + 1);
	
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		ВыводимыеОбласти.Добавить(ОбластьМакетаИтогПоСтранице);
		ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
		Для Сч = 1 По ОбластьМакетаСтрока.Параметры.Количество() Цикл
			ОбластьМакетаСтрока.Параметры.Установить(Сч - 1,""); 
		КонецЦикла;
		ОбластьМакетаСтрока.Параметры.Физлицо = " " + Символы.ПС + " ";
		
		ТабДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
		ТабДокумент.Вывести(ОбластьМакетаПодвал);
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

#КонецЕсли
