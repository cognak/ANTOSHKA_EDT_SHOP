#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства)	Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Магазин КАК Магазин,
	|	ДанныеДокумента.Магазин.ОбособленноеПодразделениеОрганизации КАК ОбособленноеПодразделениеОрганизации
	|ИЗ
	|	Документ.УстановкаЛимитовРучныхСкидокМагазин КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка"
	);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);

	РезультатЗапроса = Запрос.Выполнить();
	Реквизиты = РезультатЗапроса.Выбрать();
	Реквизиты.Следующий(); 
	
	ОбщегоНазначенияРТ.ПеренестиСтрокуВыборкиВПараметрыЗапроса(РезультатЗапроса, Реквизиты, Запрос);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	&Магазин КАК Магазин,
	|	&ОбособленноеПодразделениеОрганизации КАК ОбособленноеПодразделениеОрганизации,
	|	ТаблицаДокументы.ПричинаРучнойСкидки,
	|	ТаблицаДокументы.Сумма,
	|	ТаблицаДокументы.НомерСтроки
	|ПОМЕСТИТЬ Источник
	|ИЗ
	|	Документ.УстановкаЛимитовРучныхСкидокМагазин.Лимиты КАК ТаблицаДокументы
	|ГДЕ
	|	ТаблицаДокументы.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокументы.Период КАК Период,
	|	ТаблицаДокументы.Регистратор КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	НАЧАЛОПЕРИОДА(ТаблицаДокументы.Период, МЕСЯЦ) КАК ПериодЛимита,
	|	ТаблицаДокументы.ПричинаРучнойСкидки,
	|	ТаблицаДокументы.ОбособленноеПодразделениеОрганизации,
	|	ТаблицаДокументы.Сумма,
	|	ТаблицаДокументы.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Источник КАК ТаблицаДокументы
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокументы.Период КАК Период,
	|	ТаблицаДокументы.Регистратор КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	НАЧАЛОПЕРИОДА(ТаблицаДокументы.Период, МЕСЯЦ) КАК ПериодЛимита,
	|	ТаблицаДокументы.ПричинаРучнойСкидки,
	|	ТаблицаДокументы.Магазин,
	|	ТаблицаДокументы.Сумма,
	|	ТаблицаДокументы.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Источник КАК ТаблицаДокументы
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки"
	;
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);

	Результаты = Запрос.ВыполнитьПакет();

	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаЛимитыРучныхСкидокРегионы" , Результаты[1].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаЛимитыРучныхСкидокМагазины", Результаты[2].Выгрузить());

КонецПроцедуры

#КонецОбласти

#КонецЕсли

