#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//	LNK 13.03.2017 12:55:26
Функция ПроверитьОтчетыОРозничныхПродажахКассовогоДня(КассовыйДень, Магазин, НачалоКассовогоДня, ОкончаниеКассовогоДня)	Экспорт

	УстановитьПривилегированныйРежим(Истина);

	ТекстСообщения = "";

	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаДокументы.Дата,
	|	ТаблицаДокументы.Ссылка,
	|	ТаблицаДокументы.Представление
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ТаблицаДокументы
	|ГДЕ
	|	ТаблицаДокументы.КассоваяСмена.КассовыйДень = &КассовыйДень
	|	И НЕ ТаблицаДокументы.Проведен
	|	И НЕ ТаблицаДокументы.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаДокументы.Дата,
	|	ТаблицаДокументы.Ссылка,
	|	ТаблицаДокументы.Представление
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ТаблицаДокументы
	|ГДЕ
	|	ТаблицаДокументы.Магазин = &Магазин
	|	И ТаблицаДокументы.Дата МЕЖДУ &НачалоКассовогоДня И &ОкончаниеКассовогоДня
	|	И ТаблицаДокументы.КассоваяСмена = ЗНАЧЕНИЕ(Документ.КассоваяСмена.ПустаяСсылка)
	|	И НЕ ТаблицаДокументы.Проведен
	|	И НЕ ТаблицаДокументы.ПометкаУдаления"
	);
	Запрос.УстановитьПараметр("КассовыйДень", КассовыйДень);
	Запрос.УстановитьПараметр("Магазин"     , Магазин);
	Запрос.УстановитьПараметр("НачалоКассовогоДня"   , НачалоКассовогоДня);
//	Если окончание дня после 18:00, то принимаем конц дня по этой дате - "потерянные" отчеты могут быть на конец дня.
	Запрос.УстановитьПараметр("ОкончаниеКассовогоДня", ?((ОкончаниеКассовогоДня - НачалоДня(ОкончаниеКассовогоДня)) > (18 * 3600), КонецДня(ОкончаниеКассовогоДня), ОкончаниеКассовогоДня));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл

		ТекстСообщения = ТекстСообщения + ?(ПустаяСтрока(ТекстСообщения), "", Символы.ПС)
			+ СокрЛП(Выборка.Представление);

	КонецЦикла;

	Возврат ТекстСообщения;

КонецФункции // ПроверитьОтчетыОРозничныхПродажахКассовогоДня()

#Область ПечатныеФормы

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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПроверкаОтклоненийКонтрольныхСумм") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПроверкаОтклоненийКонтрольныхСумм",
		"Проверка отклонений контрольных сумм",
		ПроверкаОтклоненийКонтрольныхСумм(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,,Истина);

	КонецЕсли;
	
КонецПроцедуры

//	LNK 02.01.2018 10:17:59
Функция ПроверкаОтклоненийКонтрольныхСумм(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)

	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;

	ТабличныйДокумент  = Новый ТабличныйДокумент;
	РеквизитыДокумента = Новый Структура("Номер, Дата");
	СинонимДокумента   = НСтр("ru='Проверка отклонений контрольных сумм';uk='Перевірка відхилення контрольних сум'", КодЯзыкаПечать);
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КассовыйДень_ПроверкаОтклоненийКонтрольныхСумм";

	Макет = УправлениеПечатью.ПолучитьМакет("Документ.КассовыйДень.ПФ_MXL_ПроверкаОтклоненийКонтрольныхСумм", КодЯзыкаПечать);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаСмены.КассовыйДень КАК КассовыйДень,
	|	ТаблицаСмены.Ссылка КАК КассоваяСмена
	|ПОМЕСТИТЬ Смены
	|ИЗ
	|	Документ.КассоваяСмена КАК ТаблицаСмены
	|ГДЕ
	|	ТаблицаСмены.КассовыйДень В(&СписокДокументов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КассоваяСмена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокументы.Дата КАК Дата,
	|	ТаблицаДокументы.Ссылка КАК Ссылка,
	|	ТаблицаДокументы.УчитыватьНДС КАК УчитыватьНДС,
	|	ТаблицаДокументы.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ИСТИНА КАК РозничныеПродажи,
	|	Смены.КассовыйДень КАК КассовыйДень
	|ПОМЕСТИТЬ РеестрОбщий
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ТаблицаДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Смены КАК Смены
	|		ПО ТаблицаДокументы.КассоваяСмена = Смены.КассоваяСмена
	|ГДЕ
	|	НЕ ТаблицаДокументы.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	NULL,
	|	ТаблицаРегистраций.Объект,
	|	NULL,
	|	NULL,
	|	ЛОЖЬ,
	|	ТаблицаРегистраций.КассовыйДень
	|ИЗ
	|	РегистрСведений.ОбъектУчтенВNavision КАК ТаблицаРегистраций
	|ГДЕ
	|	ТаблицаРегистраций.КассовыйДень В(&СписокДокументов)
	|	И (ТаблицаРегистраций.Объект ССЫЛКА Документ.ВозвратТоваровОтПокупателя
	|			ИЛИ ТаблицаРегистраций.Объект ССЫЛКА Документ.КорректировкаРегистров
	|			ИЛИ ТаблицаРегистраций.Объект ССЫЛКА Документ.РеализацияТоваров)
	|	И НЕ ТаблицаРегистраций.Объект.ПометкаУдаления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокументы.Ссылка КАК ДокументПродажи,
	|	ТаблицаДокументы.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ИСТИНА КАК УчитыватьНДС,
	|	ИСТИНА КАК Розница,
	|	ТаблицаДокументы.ВидОперации КАК ВидОперации,
	|	ТаблицаДокументы.СуммаДокумента КАК СуммаДокумента,
	|	ТаблицаДокументы.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах,
	|	Смены.КассовыйДень КАК КассовыйДень
	|ПОМЕСТИТЬ РеестрКасса
	|ИЗ
	|	Документ.ЧекККМ КАК ТаблицаДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Смены КАК Смены
	|		ПО ТаблицаДокументы.ОтчетОРозничныхПродажах.КассоваяСмена = Смены.КассоваяСмена
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаРегистраций.Объект,
	|	ЕСТЬNULL(ТаблицаРегистраций.Объект.ЦенаВключаетНДС, ИСТИНА),
	|	ЕСТЬNULL(ТаблицаРегистраций.Объект.УчитыватьНДС, ИСТИНА),
	|	ЛОЖЬ,
	|	НЕОПРЕДЕЛЕНО,
	|	0,
	|	ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка),
	|	ТаблицаРегистраций.КассовыйДень
	|ИЗ
	|	РегистрСведений.ОбъектУчтенВNavision КАК ТаблицаРегистраций
	|ГДЕ
	|	ТаблицаРегистраций.КассовыйДень В(&СписокДокументов)
	|	И (ТаблицаРегистраций.Объект ССЫЛКА Документ.ВозвратТоваровОтПокупателя
	|			ИЛИ ТаблицаРегистраций.Объект ССЫЛКА Документ.КорректировкаРегистров
	|			ИЛИ ТаблицаРегистраций.Объект ССЫЛКА Документ.РеализацияТоваров)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДокументПродажи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРеализация.Ссылка КАК ДокументПродажи,
	|	ТаблицаРеализация.Номенклатура КАК Номенклатура,
	|	СУММА(ТаблицаРеализация.Количество) КАК Количество,
	|	СУММА(ТаблицаРеализация.Сумма) КАК Сумма,
	|	ТаблицаРеализация.КассовыйДень КАК КассовыйДень
	|ПОМЕСТИТЬ ПродажиОбщие
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаПродажи.Период КАК Дата,
	|		РеестрОбщий.Ссылка КАК Ссылка,
	|		ТаблицаПродажи.Номенклатура КАК Номенклатура,
	|		ТаблицаПродажи.КоличествоОборот КАК Количество,
	|		ТаблицаПродажи.СтоимостьОборот КАК Сумма,
	|		РеестрОбщий.КассовыйДень КАК КассовыйДень
	|	ИЗ
	|		РеестрОбщий КАК РеестрОбщий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.Продажи.Обороты(, , Регистратор, ) КАК ТаблицаПродажи
	|			ПО РеестрОбщий.Ссылка = ТаблицаПродажи.Регистратор
	|	ГДЕ
	|		НЕ РеестрОбщий.РозничныеПродажи) КАК ТаблицаРеализация
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРеализация.Ссылка,
	|	ТаблицаРеализация.Номенклатура,
	|	ТаблицаРеализация.КассовыйДень
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаРозница.Ссылка,
	|	ТаблицаРозница.Номенклатура,
	|	СУММА(ТаблицаРозница.Количество),
	|	СУММА(ТаблицаРозница.СуммаСНДС),
	|	ТаблицаРозница.КассовыйДень
	|ИЗ
	|	(ВЫБРАТЬ
	|		РеестрОбщий.Дата КАК Дата,
	|		РеестрОбщий.Ссылка КАК Ссылка,
	|		ТаблицаТовары.Номенклатура КАК Номенклатура,
	|		ТаблицаТовары.Количество КАК Количество,
	|		ТаблицаТовары.Сумма + ВЫБОР
	|			КОГДА НЕ РеестрОбщий.ЦенаВключаетНДС
	|					И РеестрОбщий.УчитыватьНДС
	|				ТОГДА ТаблицаТовары.СуммаНДС
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК СуммаСНДС,
	|		РеестрОбщий.КассовыйДень КАК КассовыйДень
	|	ИЗ
	|		РеестрОбщий КАК РеестрОбщий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах.Товары КАК ТаблицаТовары
	|			ПО РеестрОбщий.Ссылка = ТаблицаТовары.Ссылка
	|	ГДЕ
	|		РеестрОбщий.РозничныеПродажи
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		РеестрОбщий.Дата,
	|		РеестрОбщий.Ссылка,
	|		ТаблицаВозвраты.Номенклатура,
	|		ТаблицаВозвраты.Количество,
	|		ТаблицаВозвраты.Сумма + ВЫБОР
	|			КОГДА НЕ РеестрОбщий.ЦенаВключаетНДС
	|					И РеестрОбщий.УчитыватьНДС
	|				ТОГДА ТаблицаВозвраты.СуммаНДС
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		РеестрОбщий.КассовыйДень
	|	ИЗ
	|		РеестрОбщий КАК РеестрОбщий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах.ВозвращенныеТовары КАК ТаблицаВозвраты
	|			ПО РеестрОбщий.Ссылка = ТаблицаВозвраты.Ссылка
	|	ГДЕ
	|		РеестрОбщий.РозничныеПродажи
	|		И НЕ ТаблицаВозвраты.ВозвратНеЭтойСмены
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		РеестрОбщий.Дата,
	|		РеестрОбщий.Ссылка,
	|		ТаблицаВозвраты.Номенклатура,
	|		-ТаблицаВозвраты.Количество,
	|		-(ТаблицаВозвраты.Сумма + ВЫБОР
	|			КОГДА НЕ РеестрОбщий.ЦенаВключаетНДС
	|					И РеестрОбщий.УчитыватьНДС
	|				ТОГДА ТаблицаВозвраты.СуммаНДС
	|			ИНАЧЕ 0
	|		КОНЕЦ),
	|		РеестрОбщий.КассовыйДень
	|	ИЗ
	|		РеестрОбщий КАК РеестрОбщий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах.ВозвращенныеТовары КАК ТаблицаВозвраты
	|			ПО РеестрОбщий.Ссылка = ТаблицаВозвраты.Ссылка
	|	ГДЕ
	|		РеестрОбщий.РозничныеПродажи
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		РеестрОбщий.Дата,
	|		РеестрОбщий.Ссылка,
	|		ПогашениеСертификатов.ПодарочныйСертификат,
	|		-ПогашениеСертификатов.Количество,
	|		-(0.01 * ПогашениеСертификатов.Количество),
	|		РеестрОбщий.КассовыйДень
	|	ИЗ
	|		Документ.ОтчетОРозничныхПродажах.ПогашениеПодарочныхСертификатов КАК ПогашениеСертификатов
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РеестрОбщий КАК РеестрОбщий
	|			ПО ПогашениеСертификатов.Ссылка = РеестрОбщий.Ссылка
	|	ГДЕ
	|		РеестрОбщий.РозничныеПродажи) КАК ТаблицаРозница
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРозница.Ссылка,
	|	ТаблицаРозница.Номенклатура,
	|	ТаблицаРозница.КассовыйДень
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПродаж.ДокументПродажи КАК ДокументПродажи,
	|	ДанныеПродаж.Номенклатура КАК Номенклатура,
	|	СУММА(ДанныеПродаж.Количество) КАК Количество,
	|	СУММА(ДанныеПродаж.Сумма) КАК Сумма,
	|	ДанныеПродаж.КассовыйДень КАК КассовыйДень
	|ПОМЕСТИТЬ ПродажиКасса
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТовары.Номенклатура КАК Номенклатура,
	|		СУММА(ТаблицаТовары.Количество) КАК Количество,
	|		СУММА(ТаблицаТовары.Сумма + ВЫБОР
	|				КОГДА РеестрКасса.УчитыватьНДС
	|						И НЕ РеестрКасса.ЦенаВключаетНДС
	|					ТОГДА ТаблицаТовары.СуммаНДС
	|				ИНАЧЕ 0
	|			КОНЕЦ) * ВЫБОР
	|			КОГДА РеестрКасса.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЧекККМ.Возврат)
	|				ТОГДА -1
	|			ИНАЧЕ 1
	|		КОНЕЦ КАК Сумма,
	|		ВЫБОР
	|			КОГДА РеестрКасса.ОтчетОРозничныхПродажах = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|				ТОГДА РеестрКасса.ДокументПродажи
	|			ИНАЧЕ РеестрКасса.ОтчетОРозничныхПродажах
	|		КОНЕЦ КАК ДокументПродажи,
	|		РеестрКасса.КассовыйДень КАК КассовыйДень
	|	ИЗ
	|		РеестрКасса КАК РеестрКасса
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМ.Товары КАК ТаблицаТовары
	|			ПО РеестрКасса.ДокументПродажи = ТаблицаТовары.Ссылка
	|	ГДЕ
	|		РеестрКасса.Розница
	|	
	|	СГРУППИРОВАТЬ ПО
	|		РеестрКасса.ВидОперации,
	|		ТаблицаТовары.Номенклатура,
	|		ВЫБОР
	|			КОГДА РеестрКасса.ОтчетОРозничныхПродажах = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|				ТОГДА РеестрКасса.ДокументПродажи
	|			ИНАЧЕ РеестрКасса.ОтчетОРозничныхПродажах
	|		КОНЕЦ,
	|		РеестрКасса.КассовыйДень
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаСертификаты.ПодарочныйСертификат,
	|		-1,
	|		-СУММА(0.01),
	|		ВЫБОР
	|			КОГДА РеестрКасса.ОтчетОРозничныхПродажах = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|				ТОГДА РеестрКасса.ДокументПродажи
	|			ИНАЧЕ РеестрКасса.ОтчетОРозничныхПродажах
	|		КОНЕЦ,
	|		РеестрКасса.КассовыйДень
	|	ИЗ
	|		РеестрКасса КАК РеестрКасса
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМ.ПогашениеПодарочныхСертификатов КАК ТаблицаСертификаты
	|			ПО РеестрКасса.ДокументПродажи = ТаблицаСертификаты.Ссылка
	|	ГДЕ
	|		РеестрКасса.Розница
	|		И РеестрКасса.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЧекККМ.Продажа)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаСертификаты.ПодарочныйСертификат,
	|		ВЫБОР
	|			КОГДА РеестрКасса.ОтчетОРозничныхПродажах = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|				ТОГДА РеестрКасса.ДокументПродажи
	|			ИНАЧЕ РеестрКасса.ОтчетОРозничныхПродажах
	|		КОНЕЦ,
	|		РеестрКасса.КассовыйДень
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаТовары.Номенклатура,
	|		СУММА(ТаблицаТовары.Количество),
	|		СУММА(ТаблицаТовары.Сумма + ВЫБОР
	|				КОГДА РеестрКасса.УчитыватьНДС
	|						И НЕ РеестрКасса.ЦенаВключаетНДС
	|					ТОГДА ТаблицаТовары.СуммаНДС
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		ВЫБОР
	|			КОГДА РеестрКасса.ОтчетОРозничныхПродажах = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|				ТОГДА РеестрКасса.ДокументПродажи
	|			ИНАЧЕ РеестрКасса.ОтчетОРозничныхПродажах
	|		КОНЕЦ,
	|		РеестрКасса.КассовыйДень
	|	ИЗ
	|		РеестрКасса КАК РеестрКасса
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваров.Товары КАК ТаблицаТовары
	|			ПО РеестрКасса.ДокументПродажи = ТаблицаТовары.Ссылка
	|	ГДЕ
	|		НЕ РеестрКасса.Розница
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаТовары.Номенклатура,
	|		ВЫБОР
	|			КОГДА РеестрКасса.ОтчетОРозничныхПродажах = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|				ТОГДА РеестрКасса.ДокументПродажи
	|			ИНАЧЕ РеестрКасса.ОтчетОРозничныхПродажах
	|		КОНЕЦ,
	|		РеестрКасса.КассовыйДень
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаТовары.Номенклатура,
	|		СУММА(-ТаблицаТовары.Количество),
	|		-СУММА(ТаблицаТовары.Сумма + ВЫБОР
	|				КОГДА РеестрКасса.УчитыватьНДС
	|						И НЕ РеестрКасса.ЦенаВключаетНДС
	|					ТОГДА ТаблицаТовары.СуммаНДС
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		ВЫБОР
	|			КОГДА РеестрКасса.ОтчетОРозничныхПродажах = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|				ТОГДА РеестрКасса.ДокументПродажи
	|			ИНАЧЕ РеестрКасса.ОтчетОРозничныхПродажах
	|		КОНЕЦ,
	|		РеестрКасса.КассовыйДень
	|	ИЗ
	|		РеестрКасса КАК РеестрКасса
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровОтПокупателя.Товары КАК ТаблицаТовары
	|			ПО РеестрКасса.ДокументПродажи = ТаблицаТовары.Ссылка
	|	ГДЕ
	|		НЕ РеестрКасса.Розница
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаТовары.Номенклатура,
	|		ВЫБОР
	|			КОГДА РеестрКасса.ОтчетОРозничныхПродажах = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|				ТОГДА РеестрКасса.ДокументПродажи
	|			ИНАЧЕ РеестрКасса.ОтчетОРозничныхПродажах
	|		КОНЕЦ,
	|		РеестрКасса.КассовыйДень) КАК ДанныеПродаж
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПродаж.Номенклатура,
	|	ДанныеПродаж.ДокументПродажи,
	|	ДанныеПродаж.КассовыйДень
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПродаж.ДокументПродажи КАК ДокументПродажи,
	|	ДанныеПродаж.Номенклатура КАК Номенклатура,
	|	СУММА(ДанныеПродаж.Количество) КАК Количество,
	|	СУММА(ДанныеПродаж.Сумма) КАК Сумма,
	|	ДанныеПродаж.Номенклатура.Код КАК КодТовара,
	|	ДанныеПродаж.Номенклатура.Наименование КАК Товар,
	|	ДанныеПродаж.КассовыйДень КАК КассовыйДень,
	|	ДанныеПродаж.КассовыйДень.Номер КАК Номер,
	|	ДанныеПродаж.КассовыйДень.Дата КАК Дата
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПродажиОбщие.ДокументПродажи КАК ДокументПродажи,
	|		ПродажиОбщие.Номенклатура КАК Номенклатура,
	|		ПродажиОбщие.Количество КАК Количество,
	|		ПродажиОбщие.Сумма КАК Сумма,
	|		ПродажиОбщие.КассовыйДень КАК КассовыйДень
	|	ИЗ
	|		ПродажиОбщие КАК ПродажиОбщие
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПродажиКасса.ДокументПродажи,
	|		ПродажиКасса.Номенклатура,
	|		-ПродажиКасса.Количество,
	|		-ПродажиКасса.Сумма,
	|		ПродажиКасса.КассовыйДень
	|	ИЗ
	|		ПродажиКасса КАК ПродажиКасса) КАК ДанныеПродаж
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПродаж.ДокументПродажи,
	|	ДанныеПродаж.Номенклатура,
	|	ДанныеПродаж.КассовыйДень,
	|	ДанныеПродаж.Номенклатура.Код,
	|	ДанныеПродаж.Номенклатура.Наименование
	|
	|ИМЕЮЩИЕ
	|	НЕ СУММА(ДанныеПродаж.Сумма) = 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	КассовыйДень
	|ИТОГИ
	|	МАКСИМУМ(Номер),
	|	МАКСИМУМ(Дата)
	|ПО
	|	КассовыйДень"
	);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);

	КассовыеДниВыборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока КассовыеДниВыборка.Следующий() Цикл

		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, КассовыеДниВыборка);

		Область = Макет.ПолучитьОбласть("Заголовок");
		Область.Параметры.ТекстЗаголовка = ФормированиеПечатныхФормСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента, СинонимДокумента, КодЯзыкаПечать);

		ТабличныйДокумент.Вывести(Область);
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Шапка"));

		ТоварыВыборка = КассовыеДниВыборка.Выбрать();

		Область = Макет.ПолучитьОбласть("Строка");

		Пока ТоварыВыборка.Следующий() Цикл

			Область.Параметры.Заполнить(ТоварыВыборка);
			ТабличныйДокумент.Вывести(Область);

		КонецЦикла;

		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Подвал"));

	КонецЦикла;

	ТабличныйДокумент.АвтоМасштаб = Истина;

	Возврат ТабличныйДокумент;

КонецФункции // ПроверкаОтклоненийКонтрольныхСумм()

#КонецОбласти

#КонецЕсли
