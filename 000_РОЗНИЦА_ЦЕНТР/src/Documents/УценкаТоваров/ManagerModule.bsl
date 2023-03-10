#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает параметры указания серий для товаров, указанных в документе
//
// Параметры:
//	Объект - ДокументОъъект или ДанныеФормыСтруктура - документ, для которого нужно сфомировать параметры проверки
//
// Возвращаемое значение:
//	Структура - Состав полей определяется требованиями фукнции ОбработкаТабличнойЧастиСервер.ЗаполнитьСтатусыУказанияСерий
//
Функция ПараметрыУказанияСерий(Объект)	Экспорт
	
	ПоляСвязи = Новый Массив;
	
	ПараметрыУказанияСерий = Новый Структура;
	ИспользованиеСерийСклад = Ложь;
	
	ИспользованиеСерийСклад = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	
	ПараметрыУказанияСерий.Вставить("ИспользоватьСерииНоменклатуры", ИспользованиеСерийСклад);
	ПараметрыУказанияСерий.Вставить("ПоляСвязи",ПоляСвязи);
	ПараметрыУказанияСерий.Вставить("ЭтоОрдер", Истина);
	
	СкладскиеОперации = Новый Массив;
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваров") Тогда
		СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтгрузкаКлиенту);
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
		СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтгрузкаПоВозвратуПоставщику);
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтгрузкаПоПеремещению);
	Иначе
		СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтгрузкаКлиенту);
	КонецЕсли;
	
	ПараметрыУказанияСерий.Вставить("СкладскиеОперации", СкладскиеОперации);
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Проведение

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст ="ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Склад КАК Склад,
	|	ДанныеДокумента.Магазин КАК Магазин,
	|	ДанныеДокумента.ДокументОснование КАК Основание,
	|	ДанныеДокумента.ДокументОснование.Организация КАК Организация,
	|	(НЕ ДанныеДокумента.Магазин.СкладУправляющейСистемы) КАК ФормироватьДвижения
	|ИЗ
	|	Документ.УценкаТоваров КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Реквизиты = РезультатЗапроса.Выбрать();
	Реквизиты.Следующий(); 
	
	ОбщегоНазначенияРТ.ПеренестиСтрокуВыборкиВПараметрыЗапроса(РезультатЗапроса, Реквизиты, Запрос);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Ссылка КАК Ссылка,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Количество КАК Количество,
	|	&Магазин КАК Магазин,
	|	ТаблицаТовары.Цена КАК Цена,
	|	ТаблицаТовары.ПроцентУценки КАК ПроцентУценки,
	|	ТаблицаТовары.СуммаУценки КАК СуммаУценки,
	|	ТаблицаТовары.ЦенаПослеУценки КАК ЦенаПослеУценки,
	|	ТаблицаТовары.ПричинаУценки КАК ПричинаУценки
	|ПОМЕСТИТЬ ВтТаблицаТовары
	|ИЗ
	|	Документ.УценкаТоваров.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И НЕ ТаблицаТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|	И &ФормироватьДвижения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ТаблицаТовары.Магазин КАК Магазин,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.Цена КАК Цена,
	|	ТаблицаТовары.ПроцентУценки КАК ПроцентУценки,
	|	ТаблицаТовары.СуммаУценки КАК СуммаУценки,
	|	ТаблицаТовары.ЦенаПослеУценки КАК ЦенаПослеУценки,
	|	ТаблицаТовары.ПричинаУценки КАК ПричинаУценки
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	&ФормироватьДвижения
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	              
	             	
	Результат = Запрос.ВыполнитьПакет();
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаУцененныхТоваров", Результат[1].Выгрузить());

КонецПроцедуры

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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "УценкаТоваров") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "УценкаТоваров",
				"Уценка товаров",
				ПечатьУценкиТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,,Истина);

	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктУценки") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "АктУценки",
				"НН",
				ПечатьАктаУценки(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,,Истина)
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьУценкиТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
		
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;

	ВыводитьУпаковки      = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");
	ТабличныйДокумент     = Новый ТабличныйДокумент;
	РеквизитыДокумента    = Новый Структура("Номер, Дата, Префикс");
	СинонимДокумента      = НСтр("ru='Уценка товаров';uk='Уценка Товаров'", КодЯзыкаПечать);
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УценкаТоваров_УценкаТоваров";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Документ.Ссылка КАК Ссылка,
	|	Документ.Номер КАК Номер,
	|	Документ.Дата КАК Дата,
	|	Документ.Магазин КАК Магазин,
	|	Документ.ДокументОснование.Организация КАК Организация,
	|	Документ.Склад КАК Склад,
	|	Документ.ДокументОснование КАК Основание,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Магазин) КАК МагазинПредставление,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Склад) КАК СкладПредставление,
	|	ПРЕДСТАВЛЕНИЕ(Документ.ДокументОснование.Организация) КАК ОрганизацияПредставление,
	|	ПРЕДСТАВЛЕНИЕ(Документ.ДокументОснование) КАК ОснованиеПредставление,
	|	Документ.Ответственный.ФизЛицо КАК Ответственный
	|ИЗ
	|	Документ.УценкаТоваров КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивОбъектов)
	|	И Документ.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Номенклатура.Код КАК Код,
	|	ТаблицаТовары.Номенклатура.Артикул КАК Артикул,
	|	ТаблицаТовары.Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Характеристика) КАК ХарактеристикаПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Номенклатура.ЕдиницаИзмерения) КАК ПредставлениеБазовойЕдиницыИзмерения,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
	|			ТОГДА ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Упаковка.ЕдиницаИзмерения)
	|		ИНАЧЕ ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Номенклатура.ЕдиницаИзмерения)
	|	КОНЕЦ КАК ПредставлениеЕдиницыИзмеренияУпаковки,
	|	ТаблицаТовары.Номенклатура.Производитель.Представление КАК ПредставлениеПроизводителя,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТаблицаТовары.Цена КАК Цена,
	|	ТаблицаТовары.Сумма КАК Сумма,
	|	ТаблицаТовары.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.УценкаТоваров.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка В(&МассивОбъектов)
	|	И ТаблицаТовары.Ссылка.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Код КАК Код,
	|	ТаблицаТовары.Артикул КАК Артикул,
	|	ТаблицаТовары.НоменклатураПредставление,
	|	ТаблицаТовары.ХарактеристикаПредставление,
	|	ТаблицаТовары.ПредставлениеБазовойЕдиницыИзмерения,
	|	ТаблицаТовары.ПредставлениеЕдиницыИзмеренияУпаковки,
	|	ТаблицаТовары.ПредставлениеПроизводителя,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТаблицаТовары.Цена КАК Цена,
	|	ТаблицаТовары.Сумма КАК Сумма,
	|	ТаблицаТовары.Ссылка КАК Ссылка
	|ИЗ
	|	Товары КАК ТаблицаТовары
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Штрихкоды.Владелец КАК Номенклатура,
	|	Штрихкоды.Характеристика,
	|	Штрихкоды.Штрихкод КАК Штрихкод
	|ИЗ
	|	Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
	|		ПО Товары.Номенклатура = Штрихкоды.Владелец
	|			И Товары.Характеристика = Штрихкоды.Характеристика
	|ГДЕ
	|	Штрихкоды.Владелец ССЫЛКА Справочник.Номенклатура
	|	И ЕСТЬNULL(Штрихкоды.Упаковка.Коэффициент, 1) = 1
	|
	|УПОРЯДОЧИТЬ ПО
	|	Штрихкод"
	);
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Макет = УправлениеПечатью.ПолучитьМакет("Документ.УценкаТоваров.ПФ_MXL_Уценка", КодЯзыкаПечать);
	
	ОбластьЗаголовок 		= Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
	
	ОбластьШапкаТаблицыНачало 	= Макет.ПолучитьОбласть("ШапкаТаблицы|НачалоСтроки");
	ОбластьСтрокаТаблицыНачало 	= Макет.ПолучитьОбласть("СтрокаТаблицы|НачалоСтроки");
	ОбластьПодвалТаблицыНачало 	= Макет.ПолучитьОбласть("ПодвалТаблицы|НачалоСтроки");
	
	ОбластьШапкаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
	ОбластьСтрокаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаКодов");
	ОбластьПодвалТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаКодов");
	
	ОбластьШапкаТаблицыКолонкаУпаковок 		= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаУпаковок");
	ОбластьСтрокаТаблицыКолонкаУпаковок 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаУпаковок");
	ОбластьПодвалТаблицыКолонкаУпаковок		= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаУпаковок");
	
	ОбластьКолонкаТоваров = Макет.Область("КолонкаТоваров");
	
	Если НЕ ВыводитьУпаковки Тогда
		
		ОбластьКолонкаТоваров.ШиринаКолонки = ОбластьКолонкаТоваров.ШиринаКолонки + Макет.Область("КолонкаУпаковокКоличество").ШиринаКолонки
		+ Макет.Область("КолонкаУпаковокПредставление").ШиринаКолонки; 		
		
	КонецЕсли;
	
	ОбластьШапкаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаТоваров");
	ОбластьСтрокаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаТоваров");
	ОбластьПодвалТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаТоваров");
	
	ОбластьШапкаТаблицыКонец 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КонецСтроки");
	ОбластьСтрокаТаблицыКонец 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КонецСтроки");
	ОбластьПодвалТаблицыКонец 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КонецСтроки");
	
	ОбластьПодписей       = Макет.ПолучитьОбласть("Подписи");
	ОбластьИтого          = Макет.ПолучитьОбласть("Итого");
	ОбластьСуммаПрописью  = Макет.ПолучитьОбласть("СуммаПрописью");
	
	ВыборкаПоДокументам = Результаты[0].Выбрать();
	ВыборкаПоТабличнымЧастям = Результаты[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Штрихкоды = Новый ПостроительЗапроса;
	Штрихкоды.ИсточникДанных = Новый ОписаниеИсточникаДанных(Результаты[3].Выгрузить());
	Штрихкоды.Отбор.Добавить("Номенклатура");
	Штрихкоды.Отбор.Добавить("Характеристика");
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоДокументам.Ссылка)) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ВыборкаПоСтрокамТЧ = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Если НЕ ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		//ЗАГОЛОВОК
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.Заполнить(ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = ФормированиеПечатныхФормСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента, СинонимДокумента, КодЯзыкаПечать);
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		//ШАПКА
		ОбластьШапка.Параметры.Заполнить(ВыборкаПоДокументам);	
		ТабличныйДокумент.Вывести(ОбластьШапка);
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицыНачало);
		
		ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаКодов);
		ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаТоваров);
		
		Если ВыводитьУпаковки Тогда
			
			ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаУпаковок);
			
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКонец);
		ВсегоНаименований = 0;
		Итого             = 0;
		//СТРОКИ ТЧ
		Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл
			
		//	LNK 26.10.2016 11:27:18
			Штрихкоды.Отбор.Номенклатура.Установить(ВыборкаПоСтрокамТЧ.Номенклатура);
			Штрихкоды.Отбор.Характеристика.Установить(ВыборкаПоСтрокамТЧ.Характеристика);
			Штрихкоды.Выполнить();

			ТекстШтрихкодов  = "";
			ШтрихкодыВыборка = Штрихкоды.Результат.Выбрать();

			Пока ШтрихкодыВыборка.Следующий() Цикл

				Если НЕ ПустаяСтрока(ШтрихкодыВыборка.Штрихкод) Тогда

					ТекстШтрихкодов = ТекстШтрихкодов + ?(ПустаяСтрока(ТекстШтрихкодов), "", Символы.ПС) + СокрЛП(ШтрихкодыВыборка.Штрихкод);

				КонецЕсли;

			КонецЦикла;
			
			ОбластьСтрокаТаблицыНачало.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицыНачало);
			
		//	LNK 26.10.2016 11:29:20
			ОбластьСтрокаТаблицыКолонкаКодов.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ОбластьСтрокаТаблицыКолонкаКодов.Параметры.Штрихкод = ТекстШтрихкодов;
			ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаКодов);
			
			ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Товар =
				?(ПустаяСтрока(ВыборкаПоСтрокамТЧ.ПредставлениеПроизводителя), "", СокрЛП(ВыборкаПоСтрокамТЧ.ПредставлениеПроизводителя) + Символы.ПС)
				+ ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаПоСтрокамТЧ.НоменклатураПредставление,ВыборкаПоСтрокамТЧ.ХарактеристикаПредставление);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаТоваров);
			
			Если ВыводитьУпаковки Тогда
				
				ОбластьСтрокаТаблицыКолонкаУпаковок.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
				ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаУпаковок);
				
			КонецЕсли;
			
			ОбластьСтрокаТаблицыКонец.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКонец);	
			
			ВсегоНаименований = ВсегоНаименований + 1;
			Итого             = Итого + ВыборкаПоСтрокамТЧ.Сумма;
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьПодвалТаблицыНачало);
		
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаКодов);
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаТоваров);
		
		Если ВыводитьУпаковки Тогда
			
			ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаУпаковок);
			
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКонец);
		
		//ИТОГО
		ТекстИтоговойСтроки = НСтр("ru = '%Итого%'");
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%Итого%", ФормированиеПечатныхФормСервер.ФорматСумм(Итого));
		ОбластьИтого.Параметры.Итого = ТекстИтоговойСтроки;
		
		ТабличныйДокумент.Вывести(ОбластьИтого);

		//СУММА ПРОПИСЬЮ
		
		ОбластьСуммаПрописью.Параметры.СуммаПрописью = ФормированиеПечатныхФормСервер.СформироватьСуммуПрописью(Итого, , КодЯзыкаПечать);
		
		ТекстИтоговойСтроки = НСтр("ru = 'Всего наименований %ВсегоНаименований%, на сумму %Итого%';uk='Усього найменувань %ВсегоНаименований%, на суму %Итого%'", КодЯзыкаПечать);
			
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%ВсегоНаименований%", ВсегоНаименований);
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%Итого%", ФормированиеПечатныхФормСервер.ФорматСумм(Итого));
				
		ОбластьСуммаПрописью.Параметры.ИтоговаяСтрока = ТекстИтоговойСтроки;

		ТабличныйДокумент.Вывести(ОбластьСуммаПрописью);
            
				
		//ПОДПИСИ
		ОбластьПодписей.Параметры.Заполнить(ВыборкаПоДокументам);
		ОбластьПодписей.Параметры.ОтветственныйПредставление = ФормированиеПечатныхФормСервер.ФамилияИнициалыФизЛица(ВыборкаПоДокументам.Ответственный);
		ТабличныйДокумент.Вывести(ОбластьПодписей);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции


Функция ПечатьАктаУценки(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
		
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;

	КолонкаКодов       = ФормированиеПечатныхФормСервер.ИмяДополнительнойКолонки();
	ВыводитьУпаковки   = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");
	ТабличныйДокумент  = Новый ТабличныйДокумент;
	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс");
	СинонимДокумента   = НСтр("ru='Счет на оплату';uk='Рахунок на оплату'", КодЯзыкаПечать);
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_НН";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УценкаТоваровТовары.НомерСтроки КАК НомерПП,
		|	УценкаТоваровТовары.Номенклатура,
		|	УценкаТоваровТовары.Количество,
		|	УценкаТоваровТовары.Цена,
		|	УценкаТоваровТовары.Сумма,
		|	УценкаТоваровТовары.ПроцентУценки,
		|	УценкаТоваровТовары.СуммаУценки,
		|	УценкаТоваровТовары.ЦенаПослеУценки,
		|	УценкаТоваровТовары.СуммаПослеУценки,
		|	УценкаТоваровТовары.ПричинаУценки,
		|	УценкаТоваровТовары.Номенклатура.IDN КАК Код,
		|	УценкаТоваровТовары.Номенклатура.Производитель.Наименование КАК Производитель,
		|	УценкаТоваровТовары.Номенклатура.Артикул КАК Артикул
		|ИЗ
		|	Документ.УценкаТоваров.Товары КАК УценкаТоваровТовары
		|ГДЕ
		|	УценкаТоваровТовары.Ссылка = &МассивОбъектов
		|
		|УПОРЯДОЧИТЬ ПО
		|	УценкаТоваровТовары.НомерСтроки";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Таб = РезультатЗапроса.ВЫгрузить();
	
	
Макет = УправлениеПечатью.ПолучитьМакет("Документ.УценкаТоваров.ПФ_MXL_АктУценки", КодЯзыкаПечать);
Область = Макет.ПолучитьОбласть("ОбластьЗаголовок");
Область.Параметры.Номер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МассивОбъектов, "Номер");
Область.Параметры.Дата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МассивОбъектов, "Дата");
ТабличныйДокумент.Вывести(Область); 


Область = Макет.ПолучитьОбласть("ОбластьСтрока");

Для Каждого СтрСостава Из Таб Цикл 
     Область.Параметры.Заполнить(СтрСостава);
     ТабличныйДокумент.Вывести(Область);  	 
КонецЦикла;
НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
Область = Макет.ПолучитьОбласть("ОбластьИтог");
Область.Параметры.СуммаИтого = Таб.Итог("СуммаПослеУценки");
Область.Параметры.КоличествоИтого = Таб.Итог("Количество");
Область.Параметры.СуммаУценкиИтого = Таб.Итог("СуммаУценки");

ТабличныйДокумент.Вывести(Область);
	
	
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, МассивОбъектов);
		
	
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецЕсли
