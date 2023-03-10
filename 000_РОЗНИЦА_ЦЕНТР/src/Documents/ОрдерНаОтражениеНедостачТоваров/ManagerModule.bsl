#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

//Возвращает параметры указания серий для товаров, указанных в документе
//Параметры
//			Объект - ДокументОбъект или ДанныеФормыСтруктура - документ, для которого нужно сфомировать параметры проверки
//Возвращаемое значение
//			Тип Структура
//				Состав полей определяется требованиями фукнции ОбработкаТабличнойЧастиСервер.ЗаполнитьСтатусыУказанияСерий
Функция ПараметрыУказанияСерий(Объект)Экспорт
	
	ПоляСвязи = Новый Массив;
	СкладскиеОперации = Новый Массив;
	СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтражениеНедостач);
	
	
	ПараметрыУказанияСерий = Новый Структура;
	ИспользованиеСерийСклад = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	ПараметрыУказанияСерий.Вставить("ИспользоватьСерииНоменклатуры", ИспользованиеСерийСклад);
	ПараметрыУказанияСерий.Вставить("ПоляСвязи",ПоляСвязи);
	ПараметрыУказанияСерий.Вставить("ЭтоОрдер", Истина);
	ПараметрыУказанияСерий.Вставить("ИмяТЧСерии", "Товары");
	ПараметрыУказанияСерий.Вставить("Склад", Объект.Склад);
	
	ПараметрыУказанияСерий.Вставить("СкладскиеОперации", СкладскиеОперации);
	
	Возврат ПараметрыУказанияСерий;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеШапки.Дата КАК Период,
	|	ДанныеШапки.Склад КАК Склад,
	|	ДанныеШапки.Ссылка КАК Ссылка,
	|	ДанныеШапки.Магазин,
	|	ДанныеШапки.Организация,
	|	ДанныеШапки.Ответственный,
	|	(НЕ ДанныеШапки.Магазин.СкладУправляющейСистемы) КАК ФормироватьДвижения
	|ИЗ
	|	Документ.ОрдерНаОтражениеНедостачТоваров КАК ДанныеШапки
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	РезультатЗапроса = Запрос.Выполнить();
	Реквизиты = РезультатЗапроса.Выбрать();
	Реквизиты.Следующий();
	
	ОбщегоНазначенияРТ.ПеренестиСтрокуВыборкиВПараметрыЗапроса(РезультатЗапроса, Реквизиты, Запрос);

	Запрос.Текст = "
	// 0 ТаблицаТоварыКОформлениюИзлишковНедостач
	|ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	МАКСИМУМ(ТаблицаТовары.НомерСтроки) КАК НомерСтроки,
	|	СУММА(ТаблицаТовары.Количество) КАК КОформлениюАктов,
	|	0 КАК КОформлениюОрдеров,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	&Склад КАК Склад,
	|	&Ссылка КАК ДокументОснование
	|ИЗ
	|	Документ.ОрдерНаОтражениеНедостачТоваров.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 1 ТаблицаТоварыНаСкладах
	|ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	СУММА(ТаблицаТовары.Количество) КАК Количество,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	МАКСИМУМ(ТаблицаТовары.НомерСтроки) КАК НомерСтроки,
	|	&Склад КАК Склад
	|ИЗ
	|	Документ.ОрдерНаОтражениеНедостачТоваров.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 2 ТаблицаДвиженияСерийТоваров
	|ВЫБРАТЬ
	|	ТаблицаСерии.Номенклатура КАК Номенклатура,
	|	ТаблицаСерии.Характеристика КАК Характеристика,
	|	ТаблицаСерии.Серия КАК Серия,
	|	ТаблицаСерии.Количество КАК Количество,
	|	&Склад КАК Склад,
	|	&Магазин КАК Магазин,
	|	ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтражениеНедостач) КАК СкладскаяОперация,
	|	&Ссылка КАК Документ,
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	ТаблицаСерии.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Документ.ОрдерНаОтражениеНедостачТоваров.Товары КАК ТаблицаСерии
	|
	|ГДЕ
	|	ТаблицаСерии.Ссылка = &Ссылка
	|	И ТаблицаСерии.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результат = Запрос.ВыполнитьПакет();

	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;

	ТаблицыДляДвижений.Вставить("ТаблицаТоварыКОформлениюИзлишковНедостач", Результат[0].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаТоварыНаСкладах"		, Результат[1].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаТоварыНаМагазинах"		, Результат[1].Выгрузить());	//	LNK 31.08.2021 13:07:46
	ТаблицыДляДвижений.Вставить("ТаблицаДвиженияСерийТоваров"	, Результат[2].Выгрузить());

	ТаблицыДляДвижений.ТаблицаТоварыНаМагазинах.Колонки.Удалить("Склад");	//	LNK 31.08.2021 13:07:46
	ТаблицыДляДвижений.ТаблицаТоварыНаМагазинах.Колонки.Вставить(0, "Магазин", Новый ОписаниеТипов("СправочникСсылка.Магазины"));
	ТаблицыДляДвижений.ТаблицаТоварыНаМагазинах.ЗаполнитьЗначения(Запрос.Параметры.Магазин, "Магазин");

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОрдерНаОтражениеНедостачТоваров") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ОрдерНаОтражениеНедостачТоваров",
			"Отражение недостач товаров",
			ПечатьОтраженияНедостачТоваровНаСкладе(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,,Истина);
		
	КонецЕсли;
КонецПроцедуры

Функция ПечатьОтраженияНедостачТоваровНаСкладе(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
		
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;

	УстановитьПривилегированныйРежим(Истина);
	
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОрдерНаОтражениеНедостачТоваров_ОтражениеНедостачТоваров";
	
	КолонкаКодов = ФормированиеПечатныхФормСервер.ИмяДополнительнойКолонки();
	ВыводитьКоды = ЗначениеЗаполнено(КолонкаКодов);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОрдерНаОтражениеНедостачТоваров.Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Склад) КАК СкладПредставление,
	|	ОрдерНаОтражениеНедостачТоваров.Дата,
	|	ОрдерНаОтражениеНедостачТоваров.Номер,
	|	ОрдерНаОтражениеНедостачТоваров.Ответственный.ФизЛицо КАК Кладовщик,
	|	ОрдерНаОтражениеНедостачТоваров.Ответственный.ФизЛицо КАК Ответственный,
	|	ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Магазин) КАК МагазинПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Организация) КАК ОрганизацияПредставление
	|ИЗ
	|	Документ.ОрдерНаОтражениеНедостачТоваров КАК ОрдерНаОтражениеНедостачТоваров
	|ГДЕ
	|	ОрдерНаОтражениеНедостачТоваров.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОрдерНаОтражениеНедостачТоваров.Ссылка КАК Ссылка,
	|	ОрдерНаОтражениеНедостачТоваров.НомерСтроки КАК НомерСтроки,
	|	ОрдерНаОтражениеНедостачТоваров.Номенклатура.НаименованиеПолное КАК ПредставлениеНоменклатуры,
	|	" + ?(ВыводитьКоды, "ОрдерНаОтражениеНедостачТоваров.Номенклатура." + КолонкаКодов +" КАК ДопКолонка,", "") + "
	|	ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Характеристика) КАК ПредставлениеХарактеристики,
	|	ОрдерНаОтражениеНедостачТоваров.Серия.Наименование КАК ПредставлениеСерии,
	|	ОрдерНаОтражениеНедостачТоваров.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ОрдерНаОтражениеНедостачТоваров.Количество КАК Количество,
	|	ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Номенклатура.ЕдиницаИзмерения) КАК ПредставлениеБазовойЕдиницыИзмерения,
	|	ВЫБОР
	|		КОГДА ОрдерНаОтражениеНедостачТоваров.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
	|			ТОГДА ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Упаковка)
	|		ИНАЧЕ ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Номенклатура.ЕдиницаИзмерения)
	|	КОНЕЦ КАК ПредставлениеЕдининицыИзмеренияУпаковки
	|ИЗ
	|	Документ.ОрдерНаОтражениеНедостачТоваров.Товары КАК ОрдерНаОтражениеНедостачТоваров
	|ГДЕ
	|	ОрдерНаОтражениеНедостачТоваров.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	ВыборкаПоДокументам = Результаты[0].Выбрать();
	ВыборкаПоТабличнымЧастям = Результаты[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс");
	
	СинонимДокумента = НСтр("ru = 'Ордер на отражение недостач товаров';uk='Ордер на відбиття недостач товарів'", КодЯзыкаПечать);
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоДокументам.Ссылка)) Тогда
			Продолжить;
		КонецЕсли;
		
		//Макет получаем в цикле,т.к. ширина колонок зависит от склада и помещения в документе
		Макет = УправлениеПечатью.ПолучитьМакет("Документ.ОрдерНаОтражениеНедостачТоваров.ПФ_MXL_ОрдерНаОтражениеНедостачТоваров", КодЯзыкаПечать);
		
		ОбластьЗаголовок 		= Макет.ПолучитьОбласть("Заголовок");
		ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
		
		ОбластьШапкаТаблицыНачало 	= Макет.ПолучитьОбласть("ШапкаТаблицы|НачалоСтроки");
		ОбластьСтрокаТаблицыНачало 	= Макет.ПолучитьОбласть("СтрокаТаблицы|НачалоСтроки");
		ОбластьПодвалТаблицыНачало 	= Макет.ПолучитьОбласть("ПодвалТаблицы|НачалоСтроки");
		
		ОбластьШапкаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ШапкаТаблицыБезЯчУп|КолонкаКодовБезЯчейки");
		ОбластьСтрокаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("СтрокаТаблицыБезЯчУп|КолонкаКодовБезЯчейки");
		ОбластьПодвалТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаКодовБезЯчейки");
		
		ОбластьШапкаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ШапкаТаблицыБезЯчУп|ТоварБезУпаковок");
		ОбластьСтрокаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("СтрокаТаблицыБезЯчУп|ТоварБезУпаковок");
		ОбластьПодвалТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ПодвалТаблицы|ТоварБезУпаковок");
		
		
		ОбластьШапкаТаблицыКолонкаКодов.Параметры.ИмяКолонкиКодов = КолонкаКодов; 
		ОбластьПодписей = Макет.ПолучитьОбласть("Подписи");
		
		ОбластьКолонкаТоваров = Макет.Область("ТоварБезУпаковок");
		
		Если НЕ ВыводитьКоды Тогда
			ОбластьКолонкаТоваров.ШиринаКолонки = ОбластьКолонкаТоваров.ШиринаКолонки 
					+ Макет.Область("КолонкаКодовБезЯчейки").ШиринаКолонки; 
		КонецЕсли;
		
		ОбластьШапкаТаблицыКонец 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КонецСтроки");
		ОбластьСтрокаТаблицыКонец 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КонецСтроки");
		ОбластьПодвалТаблицыКонец 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КонецСтроки");
		
		ВыборкаПоСтрокамТЧ = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента,ВыборкаПоДокументам);
		
		Если Не ЗначениеЗаполнено(СинонимДокумента) Тогда
			МетаданныеДокумента = ВыборкаПоДокументам.Ссылка.Метаданные();
			Если Не ЗначениеЗаполнено(МетаданныеДокумента.ПредставлениеОбъекта) Тогда
				СинонимДокумента = МетаданныеДокумента.Синоним;
			Иначе
				СинонимДокумента = МетаданныеДокумента.ПредставлениеОбъекта;
			КонецЕсли;
		КонецЕсли;
		
		Заголовок = ФормированиеПечатныхФормСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента, СинонимДокумента, КодЯзыкаПечать);
		
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = Заголовок;
		
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		ОбластьШапка.Параметры.Заполнить(ВыборкаПоДокументам);
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицыНачало);
		
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаКодов);
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаТоваров);
		
		ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКонец);
		
		Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл
			
			ОбластьСтрокаТаблицыНачало.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицыНачало);
			
			Если ВыводитьКоды Тогда
				ОбластьСтрокаТаблицыКолонкаКодов.Параметры.Артикул = ВыборкаПоСтрокамТЧ.ДопКолонка;
				ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаКодов);
			КонецЕсли;
			
			ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Товар = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(
				ВыборкаПоСтрокамТЧ.ПредставлениеНоменклатуры,
				ВыборкаПоСтрокамТЧ.ПредставлениеХарактеристики,
				, // Упаковка
				ВыборкаПоСтрокамТЧ.ПредставлениеСерии
			);
			
			ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаТоваров);
			
			ОбластьСтрокаТаблицыКонец.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКонец);	
				
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьПодвалТаблицыНачало);
		
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаКодов);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаТоваров);
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКонец);
		
		// Вывод подписей.
		ОбластьПодписей.Параметры.Ответственный = ФизическиеЛица.ФамилияИнициалыФизЛица(ВыборкаПоДокументам.Ответственный);
		ОбластьПодписей.Параметры.Кладовщик = ФизическиеЛица.ФамилияИнициалыФизЛица(ВыборкаПоДокументам.Кладовщик);		
		ТабличныйДокумент.Вывести(ОбластьПодписей);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
КонецФункции

#КонецЕсли
