#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыОбеспеченияПечати

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)	Экспорт

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктПереоценкиТоваровНаСкладах") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "АктПереоценкиТоваровНаСкладах", 
			"Акт переоценки товаров на складах", 
			ПечатьАктаПереоценкиТоваровНаСкладах(МассивОбъектов, ОбъектыПечати, ПараметрыВывода,ПараметрыПечати),,,Истина);

	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктПереоценкиТоваровПоСкладам") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "АктПереоценкиТоваровПоСкладам", 
			"Акт переоценки товаров на складах", 
			ПечатьАктаПереоценкиТоваровПоСкладам(МассивОбъектов, ОбъектыПечати, ПараметрыВывода,ПараметрыПечати),,,Истина);
	КонецЕсли;

КонецПроцедуры

Функция ПечатьАктаПереоценкиТоваровНаСкладах(МассивОбъектов, ОбъектыПечати, ПараметрыВывода,ПараметрыПечати)
	
	Если ПараметрыПечати = "Вверх" тогда 
		УсловиеЦены = ">";
	ИначеЕсли ПараметрыПечати = "Вниз" тогда 
		УсловиеЦены = "<";
	Иначе
		УсловиеЦены = "<>";
	КонецЕсли;
	
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;

	ТабличныйДокумент  = Новый ТабличныйДокумент;
	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс");
	СинонимДокумента   = НСтр("ru='Акт переоценки товаров на складах';uk='Акт переоцінки товарів на складах'", КодЯзыкаПечать);

	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктПереоценкиТоваровНаСкладах";

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаДокументы.Дата КАК Дата,
	|	ТаблицаДокументы.Номер КАК Номер,
	|	ТаблицаДокументы.ВидНоменклатуры.Представление КАК ПроектПредставление,
	|	ТаблицаДокументы.Магазин.Представление КАК МагазинПредставление,
	|	ТаблицаДокументы.Ссылка КАК Ссылка,
	|	"""" КАК Префикс,
	|	ТаблицаДокументы.Ответственный.Наименование КАК ОтветственныйПредставление
	|ИЗ
	|	Документ.ПереоценкаТоваровНаСкладах КАК ТаблицаДокументы
	|ГДЕ
	|	ТаблицаДокументы.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.Ссылка КАК Ссылка,
	|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки,
	|	ТабличнаяЧасть.Номенклатура КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика КАК Характеристика,
	|	ТабличнаяЧасть.Упаковка КАК Упаковка,
	|	ТаблицаСведений.Значение КАК Размер,
	|	ТабличнаяЧасть.Номенклатура.Производитель.Наименование КАК Производитель,
	|	ТабличнаяЧасть.Количество КАК Количество,
	|	ТабличнаяЧасть.Цена КАК Цена,
	|	ТабличнаяЧасть.ЦенаНовая КАК ЦенаНовая,
	|	ТабличнаяЧасть.Сумма КАК Сумма,
	|	ТабличнаяЧасть.СуммаНовая КАК СуммаНовая,
	|	ТабличнаяЧасть.СуммаПереоценки КАК СуммаПереоценки,
	|	ТабличнаяЧасть.Акция КАК Акция
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.ПереоценкаТоваровНаСкладах.Товары КАК ТабличнаяЧасть
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура.ДополнительныеРеквизиты КАК ТаблицаСведений
	|		ПО ТабличнаяЧасть.Номенклатура = ТаблицаСведений.Ссылка
	|			И (ТаблицаСведений.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.РазмерностьТовара))
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Номенклатура.Код КАК Код,
	|	Товары.Номенклатура.Артикул КАК Артикул,
	|	Товары.Номенклатура.Наименование КАК Наименование,
	|	Товары.Производитель КАК Производитель,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.Размер КАК Размер,
	|	Товары.Количество КАК Количество,
	|	Товары.Цена КАК Цена,
	|	Товары.ЦенаНовая КАК ЦенаНовая,
	|	Товары.ЦенаНовая - Товары.Цена КАК ЦенаРазница,
	|	Товары.Сумма КАК Сумма,
	|	Товары.СуммаНовая КАК СуммаНовая,
	|	Товары.СуммаПереоценки КАК СуммаПереоценки,
	|	ВЫБОР
	|		КОГДА Товары.Акция = ИСТИНА
	|			ТОГДА ""да""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Акция
	|ИЗ
	|	Товары КАК Товары
	| ГДЕ
	|	Товары.ЦенаНовая"+ УсловиеЦены +" Товары.Цена
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
	|	Штрихкоды.Характеристика КАК Характеристика,
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
	ВыборкаПоДокументам = Результаты[0].Выбрать();
	ВыборкаПоТабличнымЧастям = Результаты[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Макет = УправлениеПечатью.ПолучитьМакет("Документ.ПереоценкаТоваровНаСкладах.ПФ_MXL_АктПереоценкиТоваровНаСкладах", КодЯзыкаПечать);

	ОбластьЗаголовок     = Макет.ПолучитьОбласть("Заголовок");
	ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("Подвал");
	
	Штрихкоды = Новый ПостроительЗапроса;
	Штрихкоды.ИсточникДанных = Новый ОписаниеИсточникаДанных(Результаты[3].Выгрузить());
	Штрихкоды.Отбор.Добавить("Номенклатура");
	Штрихкоды.Отбор.Добавить("Характеристика");
	
	ПервыйДокумент = Истина;

	Пока ВыборкаПоДокументам.Следующий() Цикл

		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(Новый Структура("Ссылка", ВыборкаПоДокументам.Ссылка)) Тогда

			Продолжить;

		КонецЕсли;

		ВыборкаПоСтрокамТЧ = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		Если НЕ ПервыйДокумент Тогда

			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();

		КонецЕсли;

		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

	//	ЗАГОЛОВОК
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.Заполнить(ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = ФормированиеПечатныхФормСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента, СинонимДокумента, КодЯзыкаПечать);
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
	//	ШАПКА
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Шапка"));

		ВсегоНаименований = 0;
		Итого             = 0;
	//	СТРОКИ ТЧ
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
			
			ОбластьСтрокаТаблицы.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ОбластьСтрокаТаблицы.Параметры.Штрихкод = ТекстШтрихкодов;

			Если НЕ ПустаяСтрока(ВыборкаПоСтрокамТЧ.Производитель) Тогда

				ОбластьСтрокаТаблицы.Параметры.Наименование = СокрЛП(ВыборкаПоСтрокамТЧ.Производитель) + ", "
					+ СокрЛП(ОбластьСтрокаТаблицы.Параметры.Наименование);

			КонецЕсли;

			ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);


		КонецЦикла;

		ОбластьПодвалТаблицы.Параметры.Заполнить(ВыборкаПоДокументам);
		ТабличныйДокумент.Вывести(ОбластьПодвалТаблицы);

	КонецЦикла;

	ТабличныйДокумент.АвтоМасштаб = Истина;

	Возврат ТабличныйДокумент;

КонецФункции // ПечатьАктаПереоценкиТоваровНаСкладах()

Функция ПечатьАктаПереоценкиТоваровПоСкладам(МассивОбъектов, ОбъектыПечати, ПараметрыВывода,ПараметрыПечати)
	
	//Если ПараметрыПечати = "Вверх" тогда 
	//	УсловиеЦены = ">";
	//ИначеЕсли ПараметрыПечати = "Вниз" тогда 
	//	УсловиеЦены = "<";
	//Иначе
	//	УсловиеЦены = "<>";
	//КонецЕсли;
	
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;

	ТабличныйДокумент  = Новый ТабличныйДокумент;
	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс");
	СинонимДокумента   = НСтр("ru='Акт переоценки товаров на складах';uk='Акт переоцінки товарів на складах'", КодЯзыкаПечать);

	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктПереоценкиТоваровПоСкладам";

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаДокументы.Дата КАК Дата,
	|	ТаблицаДокументы.Номер КАК Номер,
	|	ТаблицаДокументы.ВидНоменклатуры.Представление КАК ПроектПредставление,
	|	ТаблицаДокументы.Магазин.Представление КАК МагазинПредставление,
	|	ТаблицаДокументы.Ссылка КАК Ссылка,
	|	"""" КАК Префикс,
	|	ТаблицаДокументы.Ответственный.Наименование КАК ОтветственныйПредставление
	|ИЗ
	|	Документ.ПереоценкаТоваровНаСкладах КАК ТаблицаДокументы
	|ГДЕ
	|	ТаблицаДокументы.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.Ссылка КАК Ссылка,
	|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки,
	|	ТабличнаяЧасть.Номенклатура КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика КАК Характеристика,
	|	ТабличнаяЧасть.Упаковка КАК Упаковка,
	|	ТаблицаСведений.Значение КАК Размер,
	|	ТабличнаяЧасть.Номенклатура.Производитель.Наименование КАК Производитель,
	|	ТабличнаяЧасть.Количество КАК Количество,
	|	ТабличнаяЧасть.Цена КАК Цена,
	|	ТабличнаяЧасть.ЦенаНовая КАК ЦенаНовая,
	|	ТабличнаяЧасть.Сумма КАК Сумма,
	|	ТабличнаяЧасть.СуммаНовая КАК СуммаНовая,
	|	ТабличнаяЧасть.СуммаПереоценки КАК СуммаПереоценки,
	|	ТабличнаяЧасть.Акция КАК Акция
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.ПереоценкаТоваровНаСкладах.Товары КАК ТабличнаяЧасть
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура.ДополнительныеРеквизиты КАК ТаблицаСведений
	|		ПО ТабличнаяЧасть.Номенклатура = ТаблицаСведений.Ссылка
	|			И (ТаблицаСведений.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.РазмерностьТовара))
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Номенклатура.Код КАК Код,
	|	Товары.Номенклатура.Артикул КАК Артикул,
	|	Товары.Номенклатура.Наименование КАК Наименование,
	|	Товары.Производитель КАК Производитель,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.Размер КАК Размер,
	|	ТоварыНаСкладахОстатки.КоличествоОстаток КАК Количество,
	|	Товары.Цена КАК Цена,
	|	Товары.ЦенаНовая КАК ЦенаНовая,
	|	Товары.ЦенаНовая - Товары.Цена КАК ЦенаРазница,
	|	Товары.Сумма КАК Сумма,
	|	Товары.СуммаНовая КАК СуммаНовая,
	|	Товары.СуммаПереоценки КАК СуммаПереоценки,
	|	ВЫБОР
	|		КОГДА Товары.Акция = ИСТИНА
	|			ТОГДА ""да""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Акция,
	|	ТоварыНаСкладахОстатки.Склад КАК Склад
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(, Склад.Магазин = &Магазин) КАК ТоварыНаСкладахОстатки
	|		ПО Товары.Номенклатура = ТоварыНаСкладахОстатки.Номенклатура
	|			И Товары.Характеристика = ТоварыНаСкладахОстатки.Характеристика
	|ГДЕ
	|	Товары.ЦенаНовая <> Товары.Цена
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
	|	Штрихкоды.Характеристика КАК Характеристика,
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
	Запрос.УстановитьПараметр("Магазин", ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин);
	Результаты = Запрос.ВыполнитьПакет();
	ВыборкаПоДокументам = Результаты[0].Выбрать();
	ВыборкаПоТабличнымЧастям = Результаты[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Макет = УправлениеПечатью.ПолучитьМакет("Документ.ПереоценкаТоваровНаСкладах.ПФ_MXL_АктПереоценкиТоваровПоСкладам", КодЯзыкаПечать);

	ОбластьЗаголовок     = Макет.ПолучитьОбласть("Заголовок");
	ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("Подвал");
	
	Штрихкоды = Новый ПостроительЗапроса;
	Штрихкоды.ИсточникДанных = Новый ОписаниеИсточникаДанных(Результаты[3].Выгрузить());
	Штрихкоды.Отбор.Добавить("Номенклатура");
	Штрихкоды.Отбор.Добавить("Характеристика");
	
	ПервыйДокумент = Истина;

	Пока ВыборкаПоДокументам.Следующий() Цикл

		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(Новый Структура("Ссылка", ВыборкаПоДокументам.Ссылка)) Тогда

			Продолжить;

		КонецЕсли;

		ВыборкаПоСтрокамТЧ = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		Если НЕ ПервыйДокумент Тогда

			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();

		КонецЕсли;

		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

	//	ЗАГОЛОВОК
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.Заполнить(ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = ФормированиеПечатныхФормСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента, СинонимДокумента, КодЯзыкаПечать);
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
	//	ШАПКА
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Шапка"));

		ВсегоНаименований = 0;
		Итого             = 0;
	//	СТРОКИ ТЧ
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
			
			ОбластьСтрокаТаблицы.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ОбластьСтрокаТаблицы.Параметры.Штрихкод = ТекстШтрихкодов;

			Если НЕ ПустаяСтрока(ВыборкаПоСтрокамТЧ.Производитель) Тогда

				ОбластьСтрокаТаблицы.Параметры.Наименование = СокрЛП(ВыборкаПоСтрокамТЧ.Производитель) + ", "
					+ СокрЛП(ОбластьСтрокаТаблицы.Параметры.Наименование);

			КонецЕсли;

			ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);


		КонецЦикла;

		ОбластьПодвалТаблицы.Параметры.Заполнить(ВыборкаПоДокументам);
		ТабличныйДокумент.Вывести(ОбластьПодвалТаблицы);

	КонецЦикла;

	ТабличныйДокумент.АвтоМасштаб = Истина;

	Возврат ТабличныйДокумент;

КонецФункции // ПечатьАктаПереоценкиТоваровНаСкладах()

#КонецОбласти

#Область ФормированиеДокументов

Функция СформироватьДокументыПереоценки(Магазин, Операция = "ЭтикетировкаТоваров", ДатаПереоценки = '00010101', ДатаНовыхЦен = '00010101')	Экспорт

	Отказ = Ложь;

	ПроверитьПереданныеПараметры(Магазин, ДатаПереоценки, ДатаНовыхЦен);

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаСправочник.Ссылка КАК ВидНоменклатуры
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ТаблицаСправочник
	|ГДЕ
	|	НЕ ТаблицаСправочник.IDN = """""
	);
	
	ПроектыВыборка = Запрос.Выполнить().Выбрать();

	Пока ПроектыВыборка.Следующий() Цикл

		ОбъектПереоценка = Документы.ПереоценкаТоваровНаСкладах.СоздатьДокумент();
		ОбъектПереоценка.Магазин = Магазин;
		ОбъектПереоценка.Дата    = ДатаПереоценки;
		ОбъектПереоценка.ДатаНовыхЦен    = ДатаНовыхЦен;
		ОбъектПереоценка.ВидНоменклатуры = ПроектыВыборка.ВидНоменклатуры;
		ОбъектПереоценка.ВидОперации     = Перечисления.ВидыОперацийПереоценкаТоваровНаСкладах[Операция];

		ОбъектПереоценка.ЗаполнитьДанныеПереоценки(Ложь);

		Если НЕ ОбъектПереоценка.Товары.Количество() = 0 Тогда

			ОбъектПереоценка.Записать();

		КонецЕсли;

	КонецЦикла;

	Возврат НЕ Отказ;

КонецФункции // СформироватьДокументыПереоценки()

Процедура ПроверитьПереданныеПараметры(Магазин, ДатаПереоценки, ДатаНовыхЦен)

	Если ДатаПереоценки = '00010101' Тогда

		ДатаПереоценки = ТекущаяДатаСеанса();

	КонецЕсли;

	Если ДатаНовыхЦен = '00010101' Тогда

		ДатаНовыхЦен = КонецДня(ДатаПереоценки) + 1;

	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Магазин) Тогда

		ВызватьИсключение "Формирование переоценок невозможно - не указан магазин!";

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли











