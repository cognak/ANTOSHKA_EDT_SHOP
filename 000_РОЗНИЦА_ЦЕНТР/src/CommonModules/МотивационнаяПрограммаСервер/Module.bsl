#Область ПроцедурыПроведения

//	LNK 18.07.2017 13:32:15
Процедура ОтразитьДействиеМотивационныхПрограмм(ДополнительныеСвойства, Движения, Отказ) Экспорт

	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДействиеМотивационныхПрограмм;

	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда

		Возврат;

	КонецЕсли;

	Движения.ДействиеМотивационныхПрограмм.Записывать = Истина;
	Движения.ДействиеМотивационныхПрограмм.Загрузить(Таблица);
	
КонецПроцедуры

//	LNK 12.12.2017 12:00:25
Процедура ОтразитьПродажиПоЗаказамПокупателей(ДополнительныеСвойства, Движения, Отказ) Экспорт

	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПродажиПоЗаказамПокупателей;

	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда

		Возврат;

	КонецЕсли;

	Движения.ПродажиПоЗаказамПокупателей.Записывать = Истина;
	Движения.ПродажиПоЗаказамПокупателей.Загрузить(Таблица);

КонецПроцедуры

#КонецОбласти

#Область НачисленияПоМотивационнымПрограммам

//	LNK 17.05.2018 09:29:08
Функция ВыполнитьНачисленияМотивационнойПрограммы(Знач Период = '00010101', ДокументПродажи = Неопределено)	Экспорт

	НачислениеВыполнено = Ложь;	//	ВНИМАНИЕ! Имеет смысл только при указании "ДокументПродажи" (т.е. для одного документа)
	РеестрРегистраторов = Новый Соответствие;

	Если НЕ ДокументПродажи = Неопределено Тогда

		РеестрРегистраторов.Вставить(ДокументПродажи, Истина);

		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.Дата, ДЕНЬ) КАК Период,
		|	ТаблицаДокумента.Магазин КАК Магазин
		|ПОМЕСТИТЬ Источник
		|ИЗ
		|	Документ.ОтчетОРозничныхПродажах КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &ДокументПродажи
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Источник.Период КАК Период
		|ИЗ
		|	Источник КАК Источник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Источник.Магазин КАК Магазин
		|ИЗ
		|	Источник КАК Источник"
		);
		Запрос.УстановитьПараметр("ДокументПродажи", ДокументПродажи);

		Результаты = Запрос.ВыполнитьПакет();

		Выборка = Результаты[1].Выбрать();

		Если Выборка.Следующий() Тогда

			Период = Выборка.Период;

		КонецЕсли;

		МагазиныВыборка = Результаты[2].Выбрать();

	Иначе

		Период = ?(Период = '00010101', ТекущаяДатаСеанса() - 86400, Период);

		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокументы.Магазин КАК Магазин,
		|	ТаблицаДокументы.Магазин.НомерМагазина КАК КлючПорядка
		|ИЗ
		|	Документ.ОтчетОРозничныхПродажах КАК ТаблицаДокументы
		|ГДЕ
		|	ТаблицаДокументы.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) И КОНЕЦПЕРИОДА(&Период, ДЕНЬ)
		|	И ТаблицаДокументы.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	КлючПорядка"
		);
		Запрос.УстановитьПараметр("Период", Период);

		МагазиныВыборка = Запрос.Выполнить().Выбрать();

	КонецЕсли;
	
	ТаблицаАнализ = Новый ТаблицаЗначений;
	ТаблицаАнализ.Колонки.Добавить("Склад");
	ТаблицаАнализ.Колонки.Добавить("Программа");
	ТаблицаАнализ.Колонки.Добавить("СпособПредоставления");
	ТаблицаАнализ.Колонки.Добавить("ПредметПрограммы");
	ТаблицаАнализ.Колонки.Добавить("РаботаВыполняемаяСотрудниками");
	ТаблицаАнализ.Колонки.Добавить("Приоритет");
	ТаблицаАнализ.Колонки.Добавить("ДополнительнаяАналитика");
	ТаблицаАнализ.Колонки.Добавить("СуммаНачисления");
	ТаблицаАнализ.Колонки.Добавить("СуммаПродажи");
	ТаблицаАнализ.Колонки.Добавить("Значение");

	ТаблицаАнализ.Индексы.Добавить("Склад, Программа, ПредметПрограммы, РаботаВыполняемаяСотрудниками");

	Запрос = Новый Запрос(ТекстЗапросаНачисления());
//	По дефолту период начисления определяем, как "вчера".
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("ДокументПродажи", ?(ДокументПродажи = Неопределено, Документы.ОтчетОРозничныхПродажах.ПустаяСсылка(), ДокументПродажи));

//	Основной цикл по магазинам.
//	---------------------------------------------------------------------------------------
	Пока МагазиныВыборка.Следующий() Цикл

		Если ДокументПродажи = Неопределено Тогда

		//	Передана дата... нужно получить все регистраторы раздела учета за этот день.
			УстановитьРеестрРегистраторовМотивационнойПрограммы(Период, МагазиныВыборка.Магазин, РеестрРегистраторов);

		КонецЕсли;

		Запрос.УстановитьПараметр("Магазин", МагазиныВыборка.Магазин);

		Если ДокументПродажи = Неопределено Тогда

			ЗаписьЖурналаРегистрации("НачислениеМотивации.Мониторинг", УровеньЖурналаРегистрации.Примечание
			,,, "Начало выполнения запроса по магазину «" + МагазиныВыборка.Магазин + "» за день " + Формат(Период, "ДФ=dd.MM.yyyy"), РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);

		КонецЕсли;

		ДокументыРезультат = Запрос.Выполнить();

		Если ДокументыРезультат.Пустой() Тогда

			Если НЕ ДокументПродажи = Неопределено Тогда

			//	В документе продажи нет указания продавцов... начисления быть не может.
			//	Регистр будет очищен ниже (в конце процедуры), так как ссылка содержится в реестре регистраторов.
				НачислениеВыполнено = Истина;

			КонецЕсли;

		Иначе

			ДокументыВыборка = ДокументыРезультат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

			Если ДокументПродажи = Неопределено Тогда

				ЗаписьЖурналаРегистрации("НачислениеМотивации.Мониторинг", УровеньЖурналаРегистрации.Примечание
				,,, "Конец выполнения запроса по магазину «" + МагазиныВыборка.Магазин + "» за день " + Формат(Период, "ДФ=dd.MM.yyyy"), РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);

			КонецЕсли;

			Пока ДокументыВыборка.Следующий() Цикл

				НаборЗаписей = РегистрыНакопления.НачисленияМотивационныхПрограмм.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Регистратор.Установить(ДокументыВыборка.ДокументПродажи);
				ТаблицаНабора = НаборЗаписей.ВыгрузитьКолонки();

				ПолучитьТаблицуНабораЗаписей(ДокументыВыборка, ТаблицаНабора, ТаблицаАнализ);

			//	Набор записей записываем независимо от заполненности таблицы движений... может быть, нужно её очистить?
				НаборЗаписей.Загрузить(ТаблицаНабора);

				Попытка

					НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения"  , Истина);
					НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов", Истина);
					НаборЗаписей.ОбменДанными.Загрузка = Истина;
					ОбменДаннымиСервер.УстановитьПолучателейМагазина(НаборЗаписей.ОбменДанными.Получатели, МагазиныВыборка.Магазин, Ложь);

					НаборЗаписей.Записать();
					НачислениеВыполнено = Истина;

					РеестрРегистраторов.Удалить(ДокументыВыборка.ДокументПродажи);

					ВнешниеИсточникиСобытия.ОчиститьОбъектДляОбработки(,, "НАЧИСЛИТЬ_ПРОГРАММУ_МОТИВАЦИЙ", ДокументыВыборка.ДокументПродажи);

				Исключение

					ВнешниеИсточникиСобытия.УстановитьОбъектДляОбработки("", "НАЧИСЛИТЬ_ПРОГРАММУ_МОТИВАЦИЙ", ДокументыВыборка.ДокументПродажи);

				КонецПопытки;

			КонецЦикла;

		КонецЕсли;

	//	Подбираем оставшиеся хвосты... только для случая "проведения" по дню
		Если ДокументПродажи = Неопределено Тогда

			УбратьХвостыМотивационныхНачислений(РеестрРегистраторов);

		КонецЕсли;

	//	Теперь нужно почистить движения регистраторов, которые по каким-то причинам не попали в текущее начисление.

		НаборЗаписей = РегистрыНакопления.НачисленияМотивационныхПрограмм.СоздатьНаборЗаписей();

		Для каждого КлючЗначение Из РеестрРегистраторов Цикл

			НаборЗаписей.Отбор.Регистратор.Установить(КлючЗначение.Ключ);
			НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения", Истина);
			НаборЗаписей.Записать();

		КонецЦикла;

	КонецЦикла;

	Возврат НачислениеВыполнено;

КонецФункции // ВыполнитьНачисленияМотивационнойПрограммы()

Процедура ПолучитьТаблицуНабораЗаписей(ДокументыВыборка, ТаблицаНабора, ТаблицаАнализ)

	КлючиОтбора = Новый Структура("Склад, Программа, ПредметПрограммы, РаботаВыполняемаяСотрудниками");

	ПродавцыВыборка = ДокументыВыборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ПродавцыВыборка.Следующий() Цикл

		АналитикаВыборка = ПродавцыВыборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		Пока АналитикаВыборка.Следующий() Цикл

			ТоварыВыборка = АналитикаВыборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

			Пока ТоварыВыборка.Следующий() Цикл

				ТаблицаАнализ.Очистить();
				ДеталиВыборка = ТоварыВыборка.Выбрать();

				Пока ДеталиВыборка.Следующий() Цикл

					ЗаполнитьЗначенияСвойств(КлючиОтбора, ДеталиВыборка);

					Если ТаблицаАнализ.НайтиСтроки(КлючиОтбора).Количество() = 0 Тогда

					//	Заполняем строки таблицы определения максимального значения ...
						СтрокаАнализ = ТаблицаАнализ.Добавить();
					//	ЗаполнитьЗначенияСвойств(СтрокаАнализ, ДеталиВыборка);
						СтрокаАнализ.Склад     = ДеталиВыборка.Склад;
						СтрокаАнализ.Программа = ДеталиВыборка.Программа;
						СтрокаАнализ.СпособПредоставления = ДеталиВыборка.СпособПредоставления;
						СтрокаАнализ.ПредметПрограммы     = ДеталиВыборка.ПредметПрограммы;
						СтрокаАнализ.РаботаВыполняемаяСотрудниками = ДеталиВыборка.РаботаВыполняемаяСотрудниками;
						СтрокаАнализ.Приоритет               = ДеталиВыборка.Приоритет;
						СтрокаАнализ.ДополнительнаяАналитика = ДеталиВыборка.ДополнительнаяАналитика;
						СтрокаАнализ.СуммаНачисления         = ДеталиВыборка.СуммаНачисления;
						СтрокаАнализ.СуммаПродажи            = ДеталиВыборка.СуммаПродажи;
						СтрокаАнализ.Значение                = ДеталиВыборка.Значение;

					КонецЕсли;

				КонецЦикла;

			//	Определяем строку с максимальным значением начисления и учитываем в таблице для движений.
				ТаблицаАнализ.Сортировать("Приоритет Убыв, СуммаНачисления Убыв");

				Если НЕ ТаблицаАнализ.Количество() = 0 И НЕ ТаблицаАнализ[0].СуммаНачисления = 0 Тогда

					ЗаписьНабора = ТаблицаНабора.Добавить();
					ЗаписьНабора.Активность = Истина;
				//	Значения для отбора набора записей ...
					ЗаписьНабора.Период = ДокументыВыборка.Период;
					ЗаписьНабора.Регистратор = ДокументыВыборка.ДокументПродажи;
				//	Измерения ...
					ЗаписьНабора.Склад           = ТаблицаАнализ[0].Склад;
					ЗаписьНабора.Номенклатура    = ТоварыВыборка.Номенклатура;
					ЗаписьНабора.ДокументПродажи = ДокументыВыборка.ДокументПродажи;
					ЗаписьНабора.Продавец        = ПродавцыВыборка.Продавец;
					ЗаписьНабора.СпособПредоставления = ТаблицаАнализ[0].СпособПредоставления;
					ЗаписьНабора.ПредметПрограммы     = ТаблицаАнализ[0].ПредметПрограммы;
					ЗаписьНабора.Программа            = ТаблицаАнализ[0].Программа;
					ЗаписьНабора.РаботаВыполняемаяСотрудниками = ТаблицаАнализ[0].РаботаВыполняемаяСотрудниками;
					ЗаписьНабора.Приоритет               = ТаблицаАнализ[0].Приоритет;
					ЗаписьНабора.ДополнительнаяАналитика = ТаблицаАнализ[0].ДополнительнаяАналитика;
				//	Ресурсы ...
					ЗаписьНабора.Сумма        = ТаблицаАнализ[0].СуммаНачисления;
					ЗаписьНабора.Значение     = ТаблицаАнализ[0].Значение;
					ЗаписьНабора.СуммаПродажи = ТаблицаАнализ[0].СуммаПродажи;
				//	Реквизиты ... нужно добавить позже, если будет нужно.

				КонецЕсли;

			КонецЦикла;

		КонецЦикла;

	КонецЦикла;

//	... уберём утечку памяти
	ТаблицаАнализ.Очистить();

КонецПроцедуры // ПолучитьТаблицуНабораЗаписей()

//	LNK 17.05.2018 09:41:22	= запрос с отбором по одному магазину!
Функция ТекстЗапросаНачисления()

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Дата КАК Период,
	|	ТаблицаДокумента.Ссылка КАК ДокументПродажи,
	|	ТаблицаДокумента.Магазин КАК Магазин,
	|	ТаблицаДокумента.Магазин.СкладПродажи КАК Склад,
	|	ТаблицаДокумента.УчитыватьНДС КАК УчитыватьНДС,
	|	ТаблицаДокумента.ЦенаВключаетНДС КАК ЦенаВключаетНДС
	|ПОМЕСТИТЬ Реестр
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Проведен
	|	И ТаблицаДокумента.Магазин = &Магазин
	|	И ВЫБОР
	|			КОГДА &ДокументПродажи = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|				ТОГДА ТаблицаДокумента.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) И КОНЕЦПЕРИОДА(&Период, ДЕНЬ)
	|			ИНАЧЕ ТаблицаДокумента.Ссылка = &ДокументПродажи
	|		КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДокументПродажи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.Период КАК Период,
	|	ТаблицаТовары.Склад КАК Склад,
	|	ТаблицаТовары.Магазин КАК Магазин,
	|	ТаблицаТовары.ДокументПродажи КАК ДокументПродажи,
	|	ТаблицаТовары.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.ВидНоменклатуры КАК ВидНоменклатуры,
	|	ТаблицаТовары.Продавец КАК Продавец,
	|	ТаблицаТовары.ДополнительнаяАналитика КАК ДополнительнаяАналитика,
	|	СУММА(ТаблицаТовары.КоличествоПродажи) КАК КоличествоПродажи,
	|	СУММА(ТаблицаТовары.СуммаПродажи) КАК СуммаПродажи
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	(ВЫБРАТЬ
	|		Реестр.Период КАК Период,
	|		Реестр.Склад КАК Склад,
	|		Реестр.Магазин КАК Магазин,
	|		Реестр.ДокументПродажи КАК ДокументПродажи,
	|		ВЫБОР
	|			КОГДА НЕ ТаблицаТовары.ДополнительнаяАналитика = НЕОПРЕДЕЛЕНО
	|					И ТаблицаТовары.ДополнительнаяАналитика ССЫЛКА Документ.ЗаказПокупателя
	|				ТОГДА ТаблицаТовары.ДополнительнаяАналитика
	|			ИНАЧЕ ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|		КОНЕЦ КАК ЗаказПокупателя,
	|		ТаблицаТовары.Номенклатура КАК Номенклатура,
	|		ТаблицаТовары.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
	|		ТаблицаТовары.Продавец КАК Продавец,
	|		ТаблицаТовары.ДополнительнаяАналитика КАК ДополнительнаяАналитика,
	|		ТаблицаТовары.Количество КАК КоличествоПродажи,
	|		ТаблицаТовары.Сумма + ВЫБОР
	|			КОГДА Реестр.УчитыватьНДС
	|					И НЕ Реестр.ЦенаВключаетНДС
	|				ТОГДА ТаблицаТовары.СуммаНДС
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК СуммаПродажи
	|	ИЗ
	|		Реестр КАК Реестр
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах.Товары КАК ТаблицаТовары
	|			ПО Реестр.ДокументПродажи = ТаблицаТовары.Ссылка
	|	ГДЕ
	|		НЕ ТаблицаТовары.Продавец = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Реестр.Период,
	|		Реестр.Склад,
	|		Реестр.Магазин,
	|		Реестр.ДокументПродажи,
	|		ВЫБОР
	|			КОГДА НЕ ТаблицаВозвраты.ДополнительнаяАналитика = НЕОПРЕДЕЛЕНО
	|					И ТаблицаВозвраты.ДополнительнаяАналитика ССЫЛКА Документ.ЗаказПокупателя
	|				ТОГДА ТаблицаВозвраты.ДополнительнаяАналитика
	|			ИНАЧЕ ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|		КОНЕЦ,
	|		ТаблицаВозвраты.Номенклатура,
	|		ТаблицаВозвраты.Номенклатура.ВидНоменклатуры,
	|		ТаблицаВозвраты.Продавец,
	|		ТаблицаВозвраты.ДополнительнаяАналитика,
	|		ТаблицаВозвраты.Количество,
	|		ТаблицаВозвраты.Сумма + ВЫБОР
	|			КОГДА Реестр.УчитыватьНДС
	|					И НЕ Реестр.ЦенаВключаетНДС
	|				ТОГДА ТаблицаВозвраты.СуммаНДС
	|			ИНАЧЕ 0
	|		КОНЕЦ
	|	ИЗ
	|		Реестр КАК Реестр
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах.ВозвращенныеТовары КАК ТаблицаВозвраты
	|			ПО Реестр.ДокументПродажи = ТаблицаВозвраты.Ссылка
	|	ГДЕ
	|		ТаблицаВозвраты.ВозвратНеЭтойСмены = ЛОЖЬ
	|		И НЕ ТаблицаВозвраты.Продавец = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Реестр.Период,
	|		Реестр.Склад,
	|		Реестр.Магазин,
	|		Реестр.ДокументПродажи,
	|		ВЫБОР
	|			КОГДА НЕ ТаблицаВозвраты.ДополнительнаяАналитика = НЕОПРЕДЕЛЕНО
	|					И ТаблицаВозвраты.ДополнительнаяАналитика ССЫЛКА Документ.ЗаказПокупателя
	|				ТОГДА ТаблицаВозвраты.ДополнительнаяАналитика
	|			ИНАЧЕ ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|		КОНЕЦ,
	|		ТаблицаВозвраты.Номенклатура,
	|		ТаблицаВозвраты.Номенклатура.ВидНоменклатуры,
	|		ТаблицаВозвраты.Продавец,
	|		ТаблицаВозвраты.ДополнительнаяАналитика,
	|		-ТаблицаВозвраты.Количество,
	|		-(ТаблицаВозвраты.Сумма + ВЫБОР
	|			КОГДА Реестр.УчитыватьНДС
	|					И НЕ Реестр.ЦенаВключаетНДС
	|				ТОГДА ТаблицаВозвраты.СуммаНДС
	|			ИНАЧЕ 0
	|		КОНЕЦ)
	|	ИЗ
	|		Реестр КАК Реестр
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах.ВозвращенныеТовары КАК ТаблицаВозвраты
	|			ПО Реестр.ДокументПродажи = ТаблицаВозвраты.Ссылка
	|	ГДЕ
	|		НЕ ТаблицаВозвраты.Продавец = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК ТаблицаТовары
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Период,
	|	ТаблицаТовары.Склад,
	|	ТаблицаТовары.Магазин,
	|	ТаблицаТовары.ДокументПродажи,
	|	ТаблицаТовары.ЗаказПокупателя,
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.ВидНоменклатуры,
	|	ТаблицаТовары.Продавец,
	|	ТаблицаТовары.ДополнительнаяАналитика
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТаблицаТовары.Магазин,
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.ВидНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыПроданные.ДокументПродажи КАК ДокументПродажи,
	|	ТоварыПроданные.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ТоварыПроданные.Номенклатура КАК Номенклатура,
	|	ТоварыПроданные.Продавец КАК Продавец,
	|	ТоварыПроданные.СуммаПродажи КАК СуммаПродажи
	|ПОМЕСТИТЬ Заказы
	|ИЗ
	|	Товары КАК ТоварыПроданные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя.Товары КАК ТоварыЗаказанные
	|		ПО ТоварыПроданные.ЗаказПокупателя = ТоварыЗаказанные.Ссылка
	|			И ТоварыПроданные.Номенклатура = ТоварыЗаказанные.Номенклатура
	|			И (НЕ ТоварыПроданные.Продавец = ТоварыЗаказанные.Продавец)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Период КАК Период,
	|	Товары.Склад КАК Склад,
	|	Товары.Магазин КАК Магазин,
	|	Товары.ДокументПродажи КАК ДокументПродажи,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.ВидНоменклатуры КАК ВидНоменклатуры,
	|	Товары.Продавец КАК Продавец,
	|	Товары.ДополнительнаяАналитика КАК ДополнительнаяАналитика,
	|	Товары.КоличествоПродажи КАК КоличествоПродажи,
	|	Товары.СуммаПродажи КАК СуммаПродажи
	|ПОМЕСТИТЬ БазаНачисления
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Заказы КАК ФильтрЗаказов
	|		ПО Товары.ДокументПродажи = ФильтрЗаказов.ДокументПродажи
	|			И Товары.ЗаказПокупателя = ФильтрЗаказов.ЗаказПокупателя
	|			И Товары.Номенклатура = ФильтрЗаказов.Номенклатура
	|			И Товары.Продавец = ФильтрЗаказов.Продавец
	|ГДЕ
	|	ФильтрЗаказов.Номенклатура ЕСТЬ NULL
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Магазин,
	|	Номенклатура,
	|	ВидНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаПрограммы.Магазин КАК Магазин,
	|	ТаблицаПрограммы.ПредметПрограммы КАК ПредметПрограммы,
	|	ТаблицаПрограммы.РаботаВыполняемаяСотрудниками КАК РаботаВыполняемаяСотрудниками,
	|	ТаблицаПрограммы.ПредметПрограммы КАК КлючСвязи,
	|	ТаблицаПрограммы.Значение КАК Значение,
	|	ТаблицаПрограммы.СпособПредоставления КАК СпособПредоставления,
	|	ТаблицаПрограммы.КритерийПредоставления КАК КритерийПредоставления,
	|	ТаблицаПрограммы.ЗначениеКритерия КАК ЗначениеКритерия,
	|	ТаблицаПрограммы.Программа КАК Программа,
	|	ТаблицаПрограммы.Приоритет КАК Приоритет
	|ПОМЕСТИТЬ ВидыНоменклатуры
	|ИЗ
	|	РегистрСведений.ДействиеМотивационныхПрограмм.СрезПоследних(
	|			КОНЕЦПЕРИОДА(&Период, ДЕНЬ),
	|			ПредметМотивационнойПрограммы = ЗНАЧЕНИЕ(Перечисление.ПредметыМотивационныхПрограмм.ВидНоменклатуры)
	|				И Магазин В (&Магазин, ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка))
	|				И ПредметПрограммы В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						БазаНачисления.ВидНоменклатуры
	|					ИЗ
	|						БазаНачисления
	|			
	|					ОБЪЕДИНИТЬ
	|			
	|					ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						БазаНачисления.ВидНоменклатуры
	|					ИЗ
	|						БазаНачисления)) КАК ТаблицаПрограммы
	|ГДЕ
	|	(КОНЕЦПЕРИОДА(ТаблицаПрограммы.ДатаОкончания, ДЕНЬ) >= КОНЕЦПЕРИОДА(&Период, ДЕНЬ)
	|			ИЛИ ТаблицаПрограммы.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Магазин,
	|	КлючСвязи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПрограммы.Магазин КАК Магазин,
	|	ТаблицаПрограммы.ПредметПрограммы КАК ПредметПрограммы,
	|	ТаблицаПрограммы.РаботаВыполняемаяСотрудниками КАК РаботаВыполняемаяСотрудниками,
	|	ТаблицаСегменты.Номенклатура КАК КлючСвязи,
	|	ТаблицаПрограммы.Значение КАК Значение,
	|	ТаблицаПрограммы.СпособПредоставления КАК СпособПредоставления,
	|	ТаблицаПрограммы.КритерийПредоставления КАК КритерийПредоставления,
	|	ТаблицаПрограммы.ЗначениеКритерия КАК ЗначениеКритерия,
	|	ТаблицаПрограммы.Программа КАК Программа,
	|	ТаблицаПрограммы.Приоритет КАК Приоритет
	|ПОМЕСТИТЬ СегментыНоменклатуры
	|ИЗ
	|	РегистрСведений.ДействиеМотивационныхПрограмм.СрезПоследних(
	|			КОНЕЦПЕРИОДА(&Период, ДЕНЬ),
	|			ПредметМотивационнойПрограммы = ЗНАЧЕНИЕ(Перечисление.ПредметыМотивационныхПрограмм.СегментНоменклатуры)
	|				И Магазин В (&Магазин, ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка))) КАК ТаблицаПрограммы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТаблицаСегменты.Номенклатура КАК Номенклатура,
	|			ТаблицаСегменты.Сегмент КАК Сегмент
	|		ИЗ
	|			РегистрСведений.НоменклатураСегмента КАК ТаблицаСегменты
	|		ГДЕ
	|			ТаблицаСегменты.Номенклатура В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						БазаНачисления.Номенклатура
	|					ИЗ
	|						БазаНачисления)) КАК ТаблицаСегменты
	|		ПО ТаблицаПрограммы.ПредметПрограммы = ТаблицаСегменты.Сегмент
	|ГДЕ
	|	(КОНЕЦПЕРИОДА(ТаблицаПрограммы.ДатаОкончания, ДЕНЬ) >= КОНЕЦПЕРИОДА(&Период, ДЕНЬ)
	|			ИЛИ ТаблицаПрограммы.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Магазин,
	|	КлючСвязи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаПрограммы.Магазин КАК Магазин,
	|	ТаблицаПрограммы.ПредметПрограммы КАК ПредметПрограммы,
	|	ТаблицаПрограммы.РаботаВыполняемаяСотрудниками КАК РаботаВыполняемаяСотрудниками,
	|	ТаблицаПрограммы.ПредметПрограммы КАК КлючСвязи,
	|	ТаблицаПрограммы.Значение КАК Значение,
	|	ТаблицаПрограммы.СпособПредоставления КАК СпособПредоставления,
	|	ТаблицаПрограммы.КритерийПредоставления КАК КритерийПредоставления,
	|	ТаблицаПрограммы.ЗначениеКритерия КАК ЗначениеКритерия,
	|	ТаблицаПрограммы.Программа КАК Программа,
	|	ТаблицаПрограммы.Приоритет КАК Приоритет
	|ПОМЕСТИТЬ Номенклатура
	|ИЗ
	|	РегистрСведений.ДействиеМотивационныхПрограмм.СрезПоследних(
	|			КОНЕЦПЕРИОДА(&Период, ДЕНЬ),
	|			ПредметМотивационнойПрограммы = ЗНАЧЕНИЕ(Перечисление.ПредметыМотивационныхПрограмм.Номенклатура)
	|				И Магазин В (&Магазин, ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка))
	|				И ПредметПрограммы В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						БазаНачисления.Номенклатура
	|					ИЗ
	|						БазаНачисления
	|			
	|					ОБЪЕДИНИТЬ
	|			
	|					ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						БазаНачисления.Номенклатура
	|					ИЗ
	|						БазаНачисления)) КАК ТаблицаПрограммы
	|ГДЕ
	|	(КОНЕЦПЕРИОДА(ТаблицаПрограммы.ДатаОкончания, ДЕНЬ) >= КОНЕЦПЕРИОДА(&Период, ДЕНЬ)
	|			ИЛИ ТаблицаПрограммы.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Магазин,
	|	КлючСвязи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистра.Сотрудник КАК Продавец,
	|	ТаблицаРегистра.РаботаВыполняемаяСотрудниками КАК РаботаВыполняемаяСотрудниками
	|ПОМЕСТИТЬ Назначение
	|ИЗ
	|	РегистрСведений.РаботаВыполняемаяСотрудниками КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Сотрудник В
	|			(ВЫБРАТЬ
	|				БазаНачисления.Продавец
	|			ИЗ
	|				БазаНачисления)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Продавец,
	|	РаботаВыполняемаяСотрудниками
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Данные.Период КАК Период,
	|	Данные.Магазин КАК Магазин,
	|	Данные.Склад КАК Склад,
	|	Данные.Номенклатура КАК Номенклатура,
	|	Данные.ДокументПродажи КАК ДокументПродажи,
	|	Данные.Продавец КАК Продавец,
	|	Данные.СпособПредоставления КАК СпособПредоставления,
	|	Данные.ПредметПрограммы КАК ПредметПрограммы,
	|	Данные.Программа КАК Программа,
	|	Данные.РаботаВыполняемаяСотрудниками КАК РаботаВыполняемаяСотрудниками,
	|	Данные.Приоритет КАК Приоритет,
	|	Данные.ДополнительнаяАналитика КАК ДополнительнаяАналитика,
	|	Данные.КритерийПредоставления КАК КритерийПредоставления,
	|	Данные.ЗначениеКритерия КАК ЗначениеКритерия,
	|	Данные.КоличествоПродажи КАК КоличествоПродажи,
	|	ВЫБОР
	|		КОГДА Данные.СпособПредоставления = ЗНАЧЕНИЕ(Перечисление.СпособыПредоставленияСкидокНаценок.Процент)
	|			ТОГДА ВЫРАЗИТЬ(Данные.СуммаПродажи / 100 * Данные.Значение КАК ЧИСЛО(17, 4))
	|		ИНАЧЕ Данные.Значение
	|	КОНЕЦ * ВЫБОР
	|		КОГДА Данные.КритерийПредоставления = ЗНАЧЕНИЕ(Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Количество)
	|				И Данные.КоличествоПродажи * ВЫБОР
	|					КОГДА Данные.КоличествоПродажи < 0
	|						ТОГДА -1
	|					ИНАЧЕ 1
	|				КОНЕЦ >= Данные.ЗначениеКритерия
	|			ТОГДА 1
	|		КОГДА Данные.КритерийПредоставления = ЗНАЧЕНИЕ(Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Сумма)
	|				И Данные.СуммаПродажи * ВЫБОР
	|					КОГДА Данные.СуммаПродажи < 0
	|						ТОГДА -1
	|					ИНАЧЕ 1
	|				КОНЕЦ >= Данные.ЗначениеКритерия
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаНачисления,
	|	Данные.Значение КАК Значение,
	|	Данные.СуммаПродажи КАК СуммаПродажи,
	|	Данные.НомерЗапроса КАК НомерЗапроса
	|ИЗ
	|	(ВЫБРАТЬ
	|		БазаНачисления.Период КАК Период,
	|		БазаНачисления.Магазин КАК Магазин,
	|		БазаНачисления.Склад КАК Склад,
	|		БазаНачисления.Номенклатура КАК Номенклатура,
	|		БазаНачисления.ДокументПродажи КАК ДокументПродажи,
	|		БазаНачисления.Продавец КАК Продавец,
	|		БазаНачисления.КоличествоПродажи КАК КоличествоПродажи,
	|		БазаНачисления.СуммаПродажи КАК СуммаПродажи,
	|		ТаблицаПрограммы.ПредметПрограммы КАК ПредметПрограммы,
	|		ТаблицаПрограммы.Значение КАК Значение,
	|		ТаблицаПрограммы.СпособПредоставления КАК СпособПредоставления,
	|		ТаблицаПрограммы.КритерийПредоставления КАК КритерийПредоставления,
	|		ТаблицаПрограммы.ЗначениеКритерия КАК ЗначениеКритерия,
	|		ТаблицаПрограммы.Приоритет КАК Приоритет,
	|		ТаблицаПрограммы.Программа КАК Программа,
	|		ТаблицаПрограммы.РаботаВыполняемаяСотрудниками КАК РаботаВыполняемаяСотрудниками,
	|		БазаНачисления.ДополнительнаяАналитика КАК ДополнительнаяАналитика,
	|		1 КАК НомерЗапроса
	|	ИЗ
	|		БазаНачисления КАК БазаНачисления
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВидыНоменклатуры КАК ТаблицаПрограммы
	|			ПО (БазаНачисления.Магазин = ТаблицаПрограммы.Магазин
	|					ИЛИ ТаблицаПрограммы.Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка))
	|				И БазаНачисления.ВидНоменклатуры = ТаблицаПрограммы.КлючСвязи
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		БазаНачисления.Период,
	|		БазаНачисления.Магазин,
	|		БазаНачисления.Склад,
	|		БазаНачисления.Номенклатура,
	|		БазаНачисления.ДокументПродажи,
	|		БазаНачисления.Продавец,
	|		БазаНачисления.КоличествоПродажи,
	|		БазаНачисления.СуммаПродажи,
	|		ТаблицаПрограммы.ПредметПрограммы,
	|		ТаблицаПрограммы.Значение,
	|		ТаблицаПрограммы.СпособПредоставления,
	|		ТаблицаПрограммы.КритерийПредоставления,
	|		ТаблицаПрограммы.ЗначениеКритерия,
	|		ТаблицаПрограммы.Приоритет,
	|		ТаблицаПрограммы.Программа,
	|		ТаблицаПрограммы.РаботаВыполняемаяСотрудниками,
	|		БазаНачисления.ДополнительнаяАналитика,
	|		2
	|	ИЗ
	|		БазаНачисления КАК БазаНачисления
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ СегментыНоменклатуры КАК ТаблицаПрограммы
	|			ПО (БазаНачисления.Магазин = ТаблицаПрограммы.Магазин
	|					ИЛИ ТаблицаПрограммы.Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка))
	|				И БазаНачисления.Номенклатура = ТаблицаПрограммы.КлючСвязи
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		БазаНачисления.Период,
	|		БазаНачисления.Магазин,
	|		БазаНачисления.Склад,
	|		БазаНачисления.Номенклатура,
	|		БазаНачисления.ДокументПродажи,
	|		БазаНачисления.Продавец,
	|		БазаНачисления.КоличествоПродажи,
	|		БазаНачисления.СуммаПродажи,
	|		ТаблицаПрограммы.ПредметПрограммы,
	|		ТаблицаПрограммы.Значение,
	|		ТаблицаПрограммы.СпособПредоставления,
	|		ТаблицаПрограммы.КритерийПредоставления,
	|		ТаблицаПрограммы.ЗначениеКритерия,
	|		ТаблицаПрограммы.Приоритет,
	|		ТаблицаПрограммы.Программа,
	|		ТаблицаПрограммы.РаботаВыполняемаяСотрудниками,
	|		БазаНачисления.ДополнительнаяАналитика,
	|		3
	|	ИЗ
	|		БазаНачисления КАК БазаНачисления
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Номенклатура КАК ТаблицаПрограммы
	|			ПО (БазаНачисления.Магазин = ТаблицаПрограммы.Магазин
	|					ИЛИ ТаблицаПрограммы.Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка))
	|				И БазаНачисления.Номенклатура = ТаблицаПрограммы.КлючСвязи) КАК Данные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Назначение КАК Назначение
	|		ПО (ВЫБОР
	|				КОГДА Данные.РаботаВыполняемаяСотрудниками = ЗНАЧЕНИЕ(Справочник.РаботаВыполняемаяСотрудниками.ПустаяСсылка)
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ (Данные.Продавец, Данные.РаботаВыполняемаяСотрудниками) В
	|						(ВЫБРАТЬ
	|							Назначение.Продавец,
	|							Назначение.РаботаВыполняемаяСотрудниками
	|						ИЗ
	|							Назначение)
	|			КОНЕЦ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период,
	|	Данные.ДокументПродажи,
	|	Продавец,
	|	Данные.Номенклатура,
	|	СуммаНачисления УБЫВ
	|ИТОГИ
	|	МАКСИМУМ(Период),
	|	МАКСИМУМ(КоличествоПродажи),
	|	КОЛИЧЕСТВО(Значение),
	|	МАКСИМУМ(СуммаПродажи)
	|ПО
	|	ДокументПродажи,
	|	Продавец,
	|	ДополнительнаяАналитика,
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ Реестр
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ Заказы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ БазаНачисления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВидыНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СегментыНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ Назначение";

	Возврат ТекстЗапроса;

КонецФункции // ТекстЗапросаНачисления()

//	LNK 03.11.2017 09:52:52
Процедура УстановитьРеестрРегистраторовМотивационнойПрограммы(Период, Магазин, РеестрРегистраторов)

	РеестрРегистраторов.Очистить();

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаСправочник.Ссылка КАК Склад
	|ПОМЕСТИТЬ Фильтр
	|ИЗ
	|	Справочник.Склады КАК ТаблицаСправочник
	|ГДЕ
	|	ТаблицаСправочник.Магазин = &Магазин
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.НачисленияМотивационныхПрограмм КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) И КОНЕЦПЕРИОДА(&Период, ДЕНЬ)
	|	И ТаблицаРегистра.Склад В
	|			(ВЫБРАТЬ
	|				фильтр.Склад
	|			ИЗ
	|				фильтр)"
	);
	Запрос.УстановитьПараметр("Период" , Период);
	Запрос.УстановитьПараметр("Магазин", Магазин);
	
	ДокументыВыборка = Запрос.Выполнить().Выбрать();
	
	Пока ДокументыВыборка.Следующий() Цикл

		РеестрРегистраторов.Вставить(ДокументыВыборка.Регистратор, Истина);

	КонецЦикла;

КонецПроцедуры

//	LNK 23.11.2017 13:29:42
Процедура УбратьХвостыМотивационныхНачислений(РеестрРегистраторов)	Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаНазначено.Период КАК Период,
	|	ТаблицаНазначено.Магазин КАК Магазин,
	|	ТаблицаНазначено.Индекс КАК Индекс,
	|	ТаблицаНазначено.Объект КАК Объект
	|ИЗ
	|	РегистрСведений.ОбъектыДляОбработки КАК ТаблицаНазначено
	|ГДЕ
	|	ТаблицаНазначено.ДействиеКоманда = ""НАЧИСЛИТЬ_ПРОГРАММУ_МОТИВАЦИЙ""
	|	И ТаблицаНазначено.Объект ССЫЛКА Документ.ОтчетОРозничныхПродажах
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период,
	|	Объект
	|ИТОГИ ПО
	|	Объект"
	);
	ОбъектыВыборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ОбъектыВыборка.Следующий() Цикл

		Если ВыполнитьНачисленияМотивационнойПрограммы(, ОбъектыВыборка.Объект) Тогда

			ДеталиВыборка = ОбъектыВыборка.Выбрать();

			Пока ДеталиВыборка.Следующий() Цикл

				МенеджерЗаписи = РегистрыСведений.ОбъектыДляОбработки.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДеталиВыборка);
				МенеджерЗаписи.Удалить();

			КонецЦикла;

			РеестрРегистраторов.Удалить(ОбъектыВыборка.Объект);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

