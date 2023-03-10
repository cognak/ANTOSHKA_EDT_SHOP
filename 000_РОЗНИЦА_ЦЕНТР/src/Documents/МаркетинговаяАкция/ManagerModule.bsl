#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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

	Если ДокументСсылка.ДляВсехМагазинов ИЛИ НЕ ДокументСсылка.ДляВсехМагазиновОдноРасписаниеСкидок Тогда

		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТабличнаяЧасть.Ссылка КАК Ссылка,
		|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки,
		|	ТабличнаяЧасть.ДатаНачала КАК Период,
		|	ТабличнаяЧасть.ДатаОкончания КАК ДатаОкончания,
		|	ТабличнаяЧасть.Магазин КАК Магазин,
		|	ТабличнаяЧасть.СкидкаНаценка КАК СкидкаНаценка,
		|	ТабличнаяЧасть.Ссылка.ИспользоватьИнтернетМагазин КАК ИспользоватьИнтернетМагазин
		|ИЗ
		|	Документ.МаркетинговаяАкция.СкидкиНаценки КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.Ссылка = &Ссылка";
		
		Результат = Запрос.ВыполнитьПакет();
		
		ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
		ТаблицыДляДвижений.Вставить("ТаблицаДействиеСкидокНаценок", Результат[0].Выгрузить());

	Иначе

		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаСкидкиНаценки.ДатаОкончания КАК ДатаОкончания,
		|	ТаблицаСкидкиНаценки.ДатаНачала КАК ДатаНачала,
		|	ТаблицаСкидкиНаценки.СкидкаНаценка КАК СкидкаНаценка,
		|	ТаблицаСкидкиНаценки.Ссылка КАК Ссылка,
		|	ТаблицаСкидкиНаценки.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ТаблицаСкидок
		|ИЗ
		|	Документ.МаркетинговаяАкция.СкидкиНаценки КАК ТаблицаСкидкиНаценки
		|ГДЕ
		|	ТаблицаСкидкиНаценки.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаМагазины.Ссылка КАК Ссылка,
		|	ТаблицаМагазины.Магазин КАК Магазин
		|ПОМЕСТИТЬ ТаблицаМагазинов
		|ИЗ
		|	Документ.МаркетинговаяАкция.Магазины КАК ТаблицаМагазины
		|ГДЕ
		|	ТаблицаМагазины.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаМагазинов.Магазин КАК Магазин,
		|	ТаблицаСкидок.ДатаОкончания КАК ДатаОкончания,
		|	ТаблицаСкидок.ДатаНачала КАК Период,
		|	ТаблицаСкидок.СкидкаНаценка КАК СкидкаНаценка,
		|	ТаблицаСкидок.НомерСтроки КАК НомерСтроки,
		|	ЛОЖЬ КАК ИспользоватьИнтернетМагазин
		|ИЗ
		|	ТаблицаСкидок КАК ТаблицаСкидок
		|		ПОЛНОЕ СОЕДИНЕНИЕ ТаблицаМагазинов КАК ТаблицаМагазинов
		|		ПО ТаблицаСкидок.Ссылка = ТаблицаМагазинов.Ссылка";
		
		Результат = Запрос.ВыполнитьПакет();
		
		ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
		ТаблицыДляДвижений.Вставить("ТаблицаДействиеСкидокНаценок", Результат[2].Выгрузить());

	КонецЕсли;
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "МаркетинговаяАкция") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "МаркетинговаяАкция",
				"Маркетинговая акция",
				ПечатьДокумента(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,,Истина);
		
	КонецЕсли;
			
КонецПроцедуры

// Функция формирует табличный документ с печатной формой.
//
// Возвращаемое значение:
//  ТабличныйДокумент - печатная форма.
//
Функция ПечатьДокумента(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
		
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;

	ТабличныйДокумент  = Новый ТабличныйДокумент;
	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс");
	СинонимДокумента   = НСтр("ru='Маркетинговая акция';uk='Маркетингова акція'", КодЯзыкаПечать);
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_МаркетинговаяАкция";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Документ.Ссылка,
	|	Документ.Дата,
	|	Документ.ДляВсехМагазинов,
	|	Документ.ДляВсехМагазиновОдноРасписаниеСкидок,
	|	Документ.НаименованиеАкции,
	|	Документ.Описание,
	|	Документ.ДатаНачалаДействия,
	|	Документ.ДатаОкончанияДействия
	|ИЗ
	|	Документ.МаркетинговаяАкция КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивОбъектов)
	|	И Документ.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документ.Ссылка,
	|	Документ.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МаркетинговаяАкцияМагазины.Ссылка КАК Ссылка,
	|	МаркетинговаяАкцияМагазины.НомерСтроки,
	|	МаркетинговаяАкцияМагазины.Магазин
	|ИЗ
	|	Документ.МаркетинговаяАкция.Магазины КАК МаркетинговаяАкцияМагазины
	|ГДЕ
	|	МаркетинговаяАкцияМагазины.Ссылка В(&МассивОбъектов)
	|	И МаркетинговаяАкцияМагазины.Ссылка.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|ИТОГИ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МаркетинговаяАкцияСкидкиНаценки.Ссылка КАК Ссылка,
	|	МаркетинговаяАкцияСкидкиНаценки.НомерСтроки,
	|	МаркетинговаяАкцияСкидкиНаценки.ДатаНачала,
	|	МаркетинговаяАкцияСкидкиНаценки.ДатаОкончания,
	|	МаркетинговаяАкцияСкидкиНаценки.Магазин КАК Магазин,
	|	МаркетинговаяАкцияСкидкиНаценки.СкидкаНаценка,
	|	ВЫБОР
	|		КОГДА МаркетинговаяАкцияСкидкиНаценки.Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПустойМагазин
	|ИЗ
	|	Документ.МаркетинговаяАкция.СкидкиНаценки КАК МаркетинговаяАкцияСкидкиНаценки
	|ГДЕ
	|	МаркетинговаяАкцияСкидкиНаценки.Ссылка В(&МассивОбъектов)
	|	И МаркетинговаяАкцияСкидкиНаценки.Ссылка.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	ПустойМагазин
	|ИТОГИ ПО
	|	Ссылка,
	|	Магазин");
	
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Макет = УправлениеПечатью.ПолучитьМакет("Документ.МаркетинговаяАкция.ПФ_MXL_МаркетинговаяАкция", КодЯзыкаПечать);
	
	ОбластьЗаголовок           = Макет.ПолучитьОбласть("Заголовок");
	ОбластьИнформационноеПоле  = Макет.ПолучитьОбласть("ИнформационноеПоле");
	ОбластьШапкаСкидкиНаценки  = Макет.ПолучитьОбласть("ШапкаСкидкиНаценки");
	ОбластьСтрокаСкидкиНаценки = Макет.ПолучитьОбласть("СтрокаСкидкиНаценки");
	
	ОбластьШапкаМагазины  = Макет.ПолучитьОбласть("ШапкаМагазины");
	ОбластьСтрокаМагазины = Макет.ПолучитьОбласть("СтрокаМагазины");
	
	ОбластьШапкаМагазиныСкидки  = Макет.ПолучитьОбласть("ШапкаМагазиныСкидки");
	ОбластьСтрокаМагазиныСкидки = Макет.ПолучитьОбласть("СтрокаМагазиныСкидки");
	
	// +HVOYA. 27.10.2016 14:04:01, Львова Е.А.
	ОбластьШапкаТоварыУсловия  = Макет.ПолучитьОбласть("ШапкаТоварыУсловия");
	ОбластьТоварыУсловияСтрока = Макет.ПолучитьОбласть("ТоварыУсловияСтрока");
	
	ОбластьШапкаТоварыСкидки  = Макет.ПолучитьОбласть("ШапкаТоварыСкидки");
	ОбластьСтрокаТоварыСкидки = Макет.ПолучитьОбласть("СтрокаТоварыСкидки");
    
    // +HVOYA. 05.01.2017 11:00:21, Львова Е.А.
    ОбластьШапкаКартыУсловия  = Макет.ПолучитьОбласть("ШапкаКартыУсловия");
	ОбластьКартыУсловияСтрока = Макет.ПолучитьОбласть("КартыУсловияСтрока");
    // -HVOYA. 05.01.2017 11:00:24, Львова Е.А.
    
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	
	СписокСкидок = Новый СписокЗначений;
	// -HVOYA. 27.10.2016 14:04:04, Львова Е.А.
	
	ВыборкаПоДокументам = Результаты[0].Выбрать();
	ВыборкаПоТаблицыМагазины = Результаты[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаПоТаблицеСкидкиНаценки = Результаты[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		Если НЕ ВыборкаПоТаблицеСкидкиНаценки.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоДокументам.Ссылка)) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ВыборкаПоСтрокамТЧГруппировкаМагазин = ВыборкаПоТаблицеСкидкиНаценки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		ЕстьМагазины = Истина;
		Если НЕ ВыборкаПоТаблицыМагазины.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоДокументам.Ссылка)) Тогда
			ЕстьМагазины = Ложь;
		Иначе
			ВыборкаПоСтрокамТЧМагазины = ВыборкаПоТаблицыМагазины.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		КонецЕсли;
		
		Если НЕ ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьЗаголовок.Параметры.Наименование   = ВыборкаПоДокументам.НаименованиеАкции;
		ОбластьЗаголовок.Параметры.Описание       = ВыборкаПоДокументам.Описание;
		
		ДатаОкончанияДействияВОтчет = ВыборкаПоДокументам.ДатаОкончанияДействия;
		
		Если Не ДатаОкончанияДействияВОтчет = Дата('00010101000000') Тогда
			ДатаОкончанияДействияВОтчет = КонецДня(ДатаОкончанияДействияВОтчет)
		КонецЕсли;
		
		ОбластьЗаголовок.Параметры.ПериодДействия = ПредставлениеПериода(ВыборкаПоДокументам.ДатаНачалаДействия, ДатаОкончанияДействияВОтчет);
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		
		Если ВыборкаПоДокументам.ДляВсехМагазинов Тогда
			
			ОбластьИнформационноеПоле.Параметры.ИнформацияОДанных = НСтр("ru='Для всех магазинов';uk='Для всіх магазинів'", КодЯзыкаПечать);
			ТабличныйДокумент.Вывести(ОбластьИнформационноеПоле);
			//ТабличныйДокумент.Вывести(ОбластьШапкаСкидкиНаценки);
			
			Если ВыборкаПоСтрокамТЧГруппировкаМагазин.Следующий() Тогда
				
				ВыборкаПоСтрокамТЧ = ВыборкаПоСтрокамТЧГруппировкаМагазин.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл
					
					ОбластьСтрокаСкидкиНаценки.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
					// +HVOYA. 27.10.2016 16:40:04, Львова Е.А.
					ТабличныйДокумент.Вывести(ОбластьШапкаСкидкиНаценки);
					// -HVOYA. 27.10.2016 16:40:10, Львова Е.А.
                    
					ТабличныйДокумент.Вывести(ОбластьСтрокаСкидкиНаценки);
					
                    // +HVOYA. 27.10.2016 14:06:12, Львова Е.А.
                    РезультатЗапросаПоТоварамСкидки = ВернутьТаблицуНоменклатурыДляСкидки(ВыборкаПоСтрокамТЧ.СкидкаНаценка);
                  
                    ТаблицаТоваровУсловий = РезультатЗапросаПоТоварамСкидки[1].Выгрузить();
                    
                    Если НЕ ТаблицаТоваровУсловий.Количество()=0 Тогда
                        // +HVOYA. 05.05.2017 12:15:04, Львова Е.А.
                        НумерацияСтрок = Новый Массив;
                        Для Н=1 По ТаблицаТоваровУсловий.Количество() Цикл
                            НумерацияСтрок.Добавить(Н);
                        КонецЦикла;
                        ТаблицаТоваровУсловий.ЗагрузитьКолонку(НумерацияСтрок,"НомерСтроки");
                        // -HVOYA. 05.05.2017 12:15:08, Львова Е.А.
                        
                        ТабличныйДокумент.Вывести(ОбластьШапкаТоварыУсловия);
                        
                        Для Каждого СтрУсловий из ТаблицаТоваровУсловий Цикл
                            ОбластьТоварыУсловияСтрока.Параметры.Заполнить(СтрУсловий);
                            ТабличныйДокумент.Вывести(ОбластьТоварыУсловияСтрока);
                        КонецЦикла;                            
                        
                    КонецЕсли; 
                    
                    // +HVOYA. 05.01.2017 11:00:21, Львова Е.А.
                    ТаблицаКартУсловий = РезультатЗапросаПоТоварамСкидки[2].Выгрузить();
                    Если НЕ ТаблицаКартУсловий.Количество()=0 Тогда
                        // +HVOYA. 05.05.2017 12:15:04, Львова Е.А.
                        НумерацияСтрок = Новый Массив;
                        Для Н=1 По ТаблицаКартУсловий.Количество() Цикл
                            НумерацияСтрок.Добавить(Н);
                        КонецЦикла;
                        ТаблицаКартУсловий.ЗагрузитьКолонку(НумерацияСтрок,"НомерСтроки");
                        // -HVOYA. 05.05.2017 12:15:08, Львова Е.А.

                        ТабличныйДокумент.Вывести(ОбластьШапкаКартыУсловия);
                        
                        Для Каждого СтрКарт из ТаблицаКартУсловий Цикл
                            ОбластьКартыУсловияСтрока.Параметры.Заполнить(СтрКарт);
                            ТабличныйДокумент.Вывести(ОбластьКартыУсловияСтрока);
                        КонецЦикла;                            
                        
                    КонецЕсли;
                    // -HVOYA. 05.01.2017 11:00:24, Львова Е.А.
                    
                    ТаблицаТоваровСкидки = РезультатЗапросаПоТоварамСкидки[0].Выгрузить();
                    Если НЕ ТаблицаТоваровСкидки.Количество()=0 Тогда
                        // +HVOYA. 05.05.2017 12:15:04, Львова Е.А.
                        НумерацияСтрок = Новый Массив;
                        Для Н=1 По ТаблицаТоваровСкидки.Количество() Цикл
                            НумерацияСтрок.Добавить(Н);
                        КонецЦикла;
                        ТаблицаТоваровСкидки.ЗагрузитьКолонку(НумерацияСтрок,"НомерСтроки");
                        // -HVOYA. 05.05.2017 12:15:08, Львова Е.А.
                        
                        ТабличныйДокумент.Вывести(ОбластьШапкаТоварыСкидки);
                        
                        Для Каждого СтрСкидки из ТаблицаТоваровСкидки Цикл
                            ОбластьСтрокаТоварыСкидки.Параметры.Заполнить(СтрСкидки);
                            ТабличныйДокумент.Вывести(ОбластьСтрокаТоварыСкидки);
                        КонецЦикла;
                        
                    КонецЕсли;     				
					
					ТабличныйДокумент.Вывести(ОбластьПустаяСтрока);
					ТабличныйДокумент.Вывести(ОбластьПустаяСтрока);
					ТабличныйДокумент.Вывести(ОбластьПустаяСтрока);
					// -HVOYA. 27.10.2016 14:06:15, Львова Е.А.
					
				КонецЦикла;
			КонецЕсли;
			
		ИначеЕсли ВыборкаПоДокументам.ДляВсехМагазиновОдноРасписаниеСкидок Тогда
			
			Если Не ЕстьМагазины Тогда
				Продолжить;
			КонецЕсли;
			
			ОбластьИнформационноеПоле.Параметры.ИнформацияОДанных = НСтр("ru='Одно расписание для магазинов';uk='Один розклад для магазинів'", КодЯзыкаПечать);
			ТабличныйДокумент.Вывести(ОбластьИнформационноеПоле);
			ТабличныйДокумент.Вывести(ОбластьШапкаМагазиныСкидки);
			
			
			Если ВыборкаПоСтрокамТЧГруппировкаМагазин.Следующий() Тогда
				
				ВыборкаПоСтрокамТЧ = ВыборкаПоСтрокамТЧГруппировкаМагазин.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				КоличествоМагазинов = ВыборкаПоСтрокамТЧМагазины.Количество();
				КоличествоСкидок    = ВыборкаПоСтрокамТЧ.Количество();
			
				Для Индекс = 1 По Макс(КоличествоМагазинов,КоличествоСкидок) Цикл
				    					
					Если Индекс <= КоличествоСкидок Тогда
						ВыборкаПоСтрокамТЧ.Следующий();
						ОбластьСтрокаМагазиныСкидки.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
						// +HVOYA. 27.10.2016 17:41:00, Львова Е.А.
						СписокСкидок.Добавить(ВыборкаПоСтрокамТЧ.СкидкаНаценка);
						// -HVOYA. 27.10.2016 17:41:02, Львова Е.А.
					КонецЕсли;
					
					Если Индекс <= КоличествоМагазинов Тогда
						ВыборкаПоСтрокамТЧМагазины.Следующий();
						ОбластьСтрокаМагазиныСкидки.Параметры.Магазин = ВыборкаПоСтрокамТЧМагазины.Магазин;
					КонецЕсли;
					
					ТабличныйДокумент.Вывести(ОбластьСтрокаМагазиныСкидки);
				КонецЦикла;
				
				// +HVOYA. 27.10.2016 17:41:31, Львова Е.А. 								
                Для Каждого Скидка из СписокСкидок Цикл
                    РезультатЗапросаПоТоварамСкидки = ВернутьТаблицуНоменклатурыДляСкидки(Скидка.Значение);
                    
                    ТаблицаТоваровУсловий = РезультатЗапросаПоТоварамСкидки[1].Выгрузить();
                    Если НЕ ТаблицаТоваровУсловий.Количество()=0 Тогда
                        // +HVOYA. 05.05.2017 12:15:04, Львова Е.А.
                        НумерацияСтрок = Новый Массив;
                        Для Н=1 По ТаблицаТоваровУсловий.Количество() Цикл
                            НумерацияСтрок.Добавить(Н);
                        КонецЦикла;
                        ТаблицаТоваровУсловий.ЗагрузитьКолонку(НумерацияСтрок,"НомерСтроки");
                        // -HVOYA. 05.05.2017 12:15:08, Львова Е.А.

                        ТабличныйДокумент.Вывести(ОбластьШапкаТоварыУсловия);
                        
                        Для Каждого СтрУсловий из ТаблицаТоваровУсловий Цикл
                            ОбластьТоварыУсловияСтрока.Параметры.Заполнить(СтрУсловий);
                            ТабличныйДокумент.Вывести(ОбластьТоварыУсловияСтрока);
                        КонецЦикла;
                        
                    КонецЕсли;  					
                    
                    // +HVOYA. 05.01.2017 11:00:21, Львова Е.А.
                    ТаблицаКартУсловий = РезультатЗапросаПоТоварамСкидки[2].Выгрузить();
                    Если НЕ ТаблицаКартУсловий.Количество()=0 Тогда
                        // +HVOYA. 05.05.2017 12:15:04, Львова Е.А.
                        НумерацияСтрок = Новый Массив;
                        Для Н=1 По ТаблицаКартУсловий.Количество() Цикл
                            НумерацияСтрок.Добавить(Н);
                        КонецЦикла;
                        ТаблицаКартУсловий.ЗагрузитьКолонку(НумерацияСтрок,"НомерСтроки");
                        // -HVOYA. 05.05.2017 12:15:08, Львова Е.А.

                        ТабличныйДокумент.Вывести(ОбластьШапкаКартыУсловия);
                        
                        Для Каждого СтрКарт из ТаблицаКартУсловий Цикл
                            ОбластьКартыУсловияСтрока.Параметры.Заполнить(СтрКарт);
                            ТабличныйДокумент.Вывести(ОбластьКартыУсловияСтрока);
                        КонецЦикла;                            
                        
                    КонецЕсли;
                    // -HVOYA. 05.01.2017 11:00:24, Львова Е.А.
                    
                    ТаблицаТоваровСкидки = РезультатЗапросаПоТоварамСкидки[0].Выгрузить();
                    Если НЕ ТаблицаТоваровСкидки.Количество()=0 Тогда
                        // +HVOYA. 05.05.2017 12:15:04, Львова Е.А.
                        НумерацияСтрок = Новый Массив;
                        Для Н=1 По ТаблицаТоваровСкидки.Количество() Цикл
                            НумерацияСтрок.Добавить(Н);
                        КонецЦикла;
                        ТаблицаТоваровСкидки.ЗагрузитьКолонку(НумерацияСтрок,"НомерСтроки");
                        // -HVOYA. 05.05.2017 12:15:08, Львова Е.А.

                        ТабличныйДокумент.Вывести(ОбластьШапкаТоварыСкидки);
                        
                        Для Каждого СтрСкидки из ТаблицаТоваровСкидки Цикл
                            ОбластьСтрокаТоварыСкидки.Параметры.Заполнить(СтрСкидки);
                            ТабличныйДокумент.Вывести(ОбластьСтрокаТоварыСкидки);
                        КонецЦикла;   
                        
                    КонецЕсли; 
                    
                КонецЦикла;
				// -HVOYA. 27.10.2016 17:41:34, Львова Е.А.
			КонецЕсли;
		Иначе
			
			Пока ВыборкаПоСтрокамТЧГруппировкаМагазин.Следующий() Цикл
				Если ВыборкаПоСтрокамТЧГруппировкаМагазин.ПустойМагазин Тогда
					ОбластьИнформационноеПоле.Параметры.ИнформацияОДанных = НСтр("ru='Для всех магазинов';uk='Для всіх магазинів'", КодЯзыкаПечать);
				Иначе
					ОбластьИнформационноеПоле.Параметры.ИнформацияОДанных = ВыборкаПоСтрокамТЧГруппировкаМагазин.Магазин;
				КонецЕсли;
				
				ТабличныйДокумент.Вывести(ОбластьИнформационноеПоле);
				ТабличныйДокумент.Вывести(ОбластьШапкаСкидкиНаценки);
				
				ВыборкаПоСтрокамТЧ = ВыборкаПоСтрокамТЧГруппировкаМагазин.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл
					ОбластьСтрокаСкидкиНаценки.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
					ТабличныйДокумент.Вывести(ОбластьСтрокаСкидкиНаценки);
					// +HVOYA. 27.10.2016 17:41:00, Львова Е.А.
					СкидкаУжеЕсть = СписокСкидок.НайтиПоЗначению(ВыборкаПоСтрокамТЧ.СкидкаНаценка);
					Если СкидкаУжеЕсть = Неопределено Тогда
						СписокСкидок.Добавить(ВыборкаПоСтрокамТЧ.СкидкаНаценка);
					КонецЕсли;
					// -HVOYA. 27.10.2016 17:41:02, Львова Е.А.
				КонецЦикла;
				
			КонецЦикла;
			// +HVOYA. 27.10.2016 17:41:31, Львова Е.А. 								
            Для Каждого Скидка из СписокСкидок Цикл
                РезультатЗапросаПоТоварамСкидки = ВернутьТаблицуНоменклатурыДляСкидки(Скидка.Значение);
                
                ТаблицаТоваровУсловий = РезультатЗапросаПоТоварамСкидки[1].Выгрузить();
                Если НЕ ТаблицаТоваровУсловий.Количество()=0 Тогда
                    // +HVOYA. 05.05.2017 12:15:04, Львова Е.А.
                        НумерацияСтрок = Новый Массив;
                        Для Н=1 По ТаблицаТоваровУсловий.Количество() Цикл
                            НумерацияСтрок.Добавить(Н);
                        КонецЦикла;
                        ТаблицаТоваровУсловий.ЗагрузитьКолонку(НумерацияСтрок,"НомерСтроки");
                        // -HVOYA. 05.05.2017 12:15:08, Львова Е.А.

                    ТабличныйДокумент.Вывести(ОбластьШапкаТоварыУсловия);
                    
                    Для Каждого СтрУсловий из ТаблицаТоваровУсловий Цикл
                        ОбластьТоварыУсловияСтрока.Параметры.Заполнить(СтрУсловий);
                        ТабличныйДокумент.Вывести(ОбластьТоварыУсловияСтрока);
                    КонецЦикла;
                    
                КонецЕсли;
                
                // +HVOYA. 05.01.2017 11:00:21, Львова Е.А.
                ТаблицаКартУсловий = РезультатЗапросаПоТоварамСкидки[2].Выгрузить();
                Если НЕ ТаблицаКартУсловий.Количество()=0 Тогда
                    // +HVOYA. 05.05.2017 12:15:04, Львова Е.А.
                        НумерацияСтрок = Новый Массив;
                        Для Н=1 По ТаблицаКартУсловий.Количество() Цикл
                            НумерацияСтрок.Добавить(Н);
                        КонецЦикла;
                        ТаблицаКартУсловий.ЗагрузитьКолонку(НумерацияСтрок,"НомерСтроки");
                        // -HVOYA. 05.05.2017 12:15:08, Львова Е.А.

                    ТабличныйДокумент.Вывести(ОбластьШапкаКартыУсловия);
                    
                    Для Каждого СтрКарт из ТаблицаКартУсловий Цикл
                        ОбластьКартыУсловияСтрока.Параметры.Заполнить(СтрКарт);
                        ТабличныйДокумент.Вывести(ОбластьКартыУсловияСтрока);
                    КонецЦикла;                            
                    
                КонецЕсли;
                // -HVOYA. 05.01.2017 11:00:24, Львова Е.А.
                
                ТаблицаТоваровСкидки = РезультатЗапросаПоТоварамСкидки[0].Выгрузить();
                Если НЕ ТаблицаТоваровСкидки.Количество()=0 Тогда
                    // +HVOYA. 05.05.2017 12:15:04, Львова Е.А.
                        НумерацияСтрок = Новый Массив;
                        Для Н=1 По ТаблицаТоваровСкидки.Количество() Цикл
                            НумерацияСтрок.Добавить(Н);
                        КонецЦикла;
                        ТаблицаТоваровСкидки.ЗагрузитьКолонку(НумерацияСтрок,"НомерСтроки");
                        // -HVOYA. 05.05.2017 12:15:08, Львова Е.А.

                    ТабличныйДокумент.Вывести(ОбластьШапкаТоварыСкидки);
                    
                    Для Каждого СтрСкидки из ТаблицаТоваровСкидки Цикл
                        ОбластьСтрокаТоварыСкидки.Параметры.Заполнить(СтрСкидки);
                        ТабличныйДокумент.Вывести(ОбластьСтрокаТоварыСкидки);
                    КонецЦикла;
                    
                КонецЕсли;				
            КонецЦикла;
			// -HVOYA. 27.10.2016 17:41:34, Львова Е.А.

		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
КонецФункции

Функция ВернутьТаблицуНоменклатурыДляСкидки(СкидкаНаценка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ДействиеСкидокНаценокТоварыСкидки.СкидкаНаценка КАК СкидкаНаценка,
	|	НоменклатураСегментаСкидки.Сегмент КАК Сегмент,
	|	НоменклатураСегментаСкидки.Номенклатура КАК Номенклатура,
	|	НоменклатураСегментаСкидки.Номенклатура.Код КАК Код,
	|	НоменклатураСегментаСкидки.Номенклатура.Артикул КАК Артикул,
	|	НоменклатураСегментаСкидки.Номенклатура.Производитель КАК Производитель,
	|	0 КАК НомерСтроки
	|ИЗ
	|	РегистрСведений.НоменклатураСегмента КАК НоменклатураСегментаСкидки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДействиеСкидокНаценок КАК ДействиеСкидокНаценокТоварыСкидки
	|		ПО НоменклатураСегментаСкидки.Сегмент = ДействиеСкидокНаценокТоварыСкидки.СкидкаНаценка.СегментНоменклатурыПредоставления
	|ГДЕ
	|	ДействиеСкидокНаценокТоварыСкидки.СкидкаНаценка В(&СкидкаНаценка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДействиеСкидокНаценокТоварыСкидки.СкидкаНаценка,
	|	NULL,
	|	СкидкиНаценкиНаборПодарков.Номенклатура,
	|	СкидкиНаценкиНаборПодарков.Номенклатура.Код,
	|	СкидкиНаценкиНаборПодарков.Номенклатура.Артикул,
	|	СкидкиНаценкиНаборПодарков.Номенклатура.Производитель,
	|	0
	|ИЗ
	|	РегистрСведений.ДействиеСкидокНаценок КАК ДействиеСкидокНаценокТоварыСкидки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СкидкиНаценки.НаборПодарков КАК СкидкиНаценкиНаборПодарков
	|		ПО ДействиеСкидокНаценокТоварыСкидки.СкидкаНаценка = СкидкиНаценкиНаборПодарков.Ссылка
	|ГДЕ
	|	ДействиеСкидокНаценокТоварыСкидки.СкидкаНаценка В(&СкидкаНаценка)
	|	И ДействиеСкидокНаценокТоварыСкидки.СкидкаНаценка.СпособПредоставления = ЗНАЧЕНИЕ(Перечисление.СпособыПредоставленияСкидокНаценок.Подарок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкидкиНаценкиУсловияПредоставления.Ссылка,
	|	НоменклатураСегментаУсловия.Сегмент,
	|	НоменклатураСегментаУсловия.Номенклатура,
	|	НоменклатураСегментаУсловия.Номенклатура.Код,
	|	НоменклатураСегментаУсловия.Номенклатура.Артикул,
	|	НоменклатураСегментаУсловия.Номенклатура.Производитель,
	|	0
	|ИЗ
	|	Справочник.СкидкиНаценки.УсловияПредоставления КАК СкидкиНаценкиУсловияПредоставления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСегмента КАК НоменклатураСегментаУсловия
	|		ПО СкидкиНаценкиУсловияПредоставления.УсловиеПредоставления.СегментНоменклатурыОграничения = НоменклатураСегментаУсловия.Сегмент
	|ГДЕ
	|	СкидкиНаценкиУсловияПредоставления.Ссылка В(&СкидкаНаценка)
	|	И СкидкиНаценкиУсловияПредоставления.Ссылка.СпособПредоставления = ЗНАЧЕНИЕ(Перечисление.СпособыПредоставленияСкидокНаценок.ДиапазонПроцентов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СкидкиНаценкиУсловияПредоставления.Ссылка КАК Ссылка,
	|	НоменклатураСегментаУсловия.Сегмент КАК Сегмент,
	|	НоменклатураСегментаУсловия.Номенклатура КАК НоменклатураУсловия,
	|	НоменклатураСегментаУсловия.Номенклатура.Код КАК КодУсловия,
	|	НоменклатураСегментаУсловия.Номенклатура.Артикул КАК АртикулУсловия,
	|	НоменклатураСегментаУсловия.Номенклатура.Производитель КАК ПроизводительУсловия,
	|	0 КАК НомерСтроки
	|ИЗ
	|	Справочник.СкидкиНаценки.УсловияПредоставления КАК СкидкиНаценкиУсловияПредоставления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСегмента КАК НоменклатураСегментаУсловия
	|		ПО СкидкиНаценкиУсловияПредоставления.УсловиеПредоставления.СегментНоменклатурыОграничения = НоменклатураСегментаУсловия.Сегмент
	|ГДЕ
	|	СкидкиНаценкиУсловияПредоставления.Ссылка В(&СкидкаНаценка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СкидкиНаценкиУсловияПредоставления.Ссылка,
	|	NULL,
	|	УсловияПредоставленияСкидокНаценокКомплектПокупки.Номенклатура,
	|	УсловияПредоставленияСкидокНаценокКомплектПокупки.Номенклатура.Код,
	|	УсловияПредоставленияСкидокНаценокКомплектПокупки.Номенклатура.Артикул,
	|	УсловияПредоставленияСкидокНаценокКомплектПокупки.Номенклатура.Производитель,
	|	0
	|ИЗ
	|	Справочник.СкидкиНаценки.УсловияПредоставления КАК СкидкиНаценкиУсловияПредоставления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УсловияПредоставленияСкидокНаценок.КомплектПокупки КАК УсловияПредоставленияСкидокНаценокКомплектПокупки
	|		ПО СкидкиНаценкиУсловияПредоставления.УсловиеПредоставления = УсловияПредоставленияСкидокНаценокКомплектПокупки.Ссылка
	|ГДЕ
	|	СкидкиНаценкиУсловияПредоставления.УсловиеПредоставления.УсловиеПредоставления = ЗНАЧЕНИЕ(Перечисление.УсловияПредоставленияСкидокНаценок.ЗаКомплектПокупки)
	|	И СкидкиНаценкиУсловияПредоставления.Ссылка В(&СкидкаНаценка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СкидкиНаценкиУсловияПредоставления.Ссылка,
	|	NULL,
	|	УсловияПредоставленияСкидокНаценокПолучатели.Получатель.Ссылка,
	|	Штрихкоды.Штрихкод,
	|	УсловияПредоставленияСкидокНаценокПолучатели.Получатель.Артикул,
	|	NULL,
	|	0
	|ИЗ
	|	Справочник.СкидкиНаценки.УсловияПредоставления КАК СкидкиНаценкиУсловияПредоставления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УсловияПредоставленияСкидокНаценок.Получатели КАК УсловияПредоставленияСкидокНаценокПолучатели
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
	|			ПО УсловияПредоставленияСкидокНаценокПолучатели.Получатель.Ссылка = Штрихкоды.Владелец
	|		ПО СкидкиНаценкиУсловияПредоставления.УсловиеПредоставления = УсловияПредоставленияСкидокНаценокПолучатели.Ссылка
	|ГДЕ
	|	СкидкиНаценкиУсловияПредоставления.УсловиеПредоставления.УсловиеПредоставления = ЗНАЧЕНИЕ(Перечисление.УсловияПредоставленияСкидокНаценок.ПоТипуПолучателя)
	|	И СкидкиНаценкиУсловияПредоставления.Ссылка В(&СкидкаНаценка)
	|	И НЕ УсловияПредоставленияСкидокНаценокПолучатели.Получатель ССЫЛКА Справочник.ИнформационныеКарты
	|
	|УПОРЯДОЧИТЬ ПО
	|	КодУсловия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СкидкиНаценкиУсловияПредоставленияДК.Ссылка КАК Ссылка,
	|	УсловияПредоставленияСкидокНаценокПолучателиДК.Получатель.ВладелецКарты КАК ВладелецКарты,
	|	УсловияПредоставленияСкидокНаценокПолучателиДК.Получатель.Ссылка КАК НомерКарты,
	|	УсловияПредоставленияСкидокНаценокПолучателиДК.Получатель.ВидКарты КАК ВидКарты,
	|	УсловияПредоставленияСкидокНаценокПолучателиДК.Получатель.ВидДисконтнойКарты КАК ВидДисконтнойКарты,
	|	0 КАК НомерСтроки
	|ИЗ
	|	Справочник.СкидкиНаценки.УсловияПредоставления КАК СкидкиНаценкиУсловияПредоставленияДК
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УсловияПредоставленияСкидокНаценок.Получатели КАК УсловияПредоставленияСкидокНаценокПолучателиДК
	|		ПО СкидкиНаценкиУсловияПредоставленияДК.УсловиеПредоставления = УсловияПредоставленияСкидокНаценокПолучателиДК.Ссылка
	|ГДЕ
	|	СкидкиНаценкиУсловияПредоставленияДК.УсловиеПредоставления.УсловиеПредоставления = ЗНАЧЕНИЕ(Перечисление.УсловияПредоставленияСкидокНаценок.ПоТипуПолучателя)
	|	И СкидкиНаценкиУсловияПредоставленияДК.Ссылка В(&СкидкаНаценка)
	|	И УсловияПредоставленияСкидокНаценокПолучателиДК.Получатель ССЫЛКА Справочник.ИнформационныеКарты
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерКарты"
	);

	Запрос.УстановитьПараметр("СкидкаНаценка", СкидкаНаценка);
	
	Возврат Запрос.ВыполнитьПакет();

КонецФункции

#КонецЕсли

