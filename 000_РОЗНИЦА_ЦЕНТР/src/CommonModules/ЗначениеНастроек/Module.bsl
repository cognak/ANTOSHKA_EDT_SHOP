//	LNK 21.04.2017 12:03:34
Процедура УстановитьОрганизациюПоУмолчанию(Организация, Знач Пользователь = Неопределено, УстановитьНастройкуПользователя = Истина)	Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Если Пользователь = Неопределено Тогда

		Пользователь = Пользователи.ТекущийПользователь();

	КонецЕсли;

//	LNK 15.11.2023 16:39:58
	ОрганизацияМагазина = Справочники.Магазины.РеквизитыМагазина(ПараметрыСеанса.ТекущийМагазин).Организация;

	Если НЕ Организация = ОрганизацияМагазина Тогда

		Если ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

		//	В Центральной базе мы не сможет однозначно установить магазин по организации... таких тут много.
		//	Поэтому откатываемся к организации, указанной для магазина.
			Организация = ОрганизацияМагазина;

		Иначе

		//	А здесь магазины, имеющие место в узле, хранятся в элементе структуры данных.
		//	Вот из этих магазинов и выбираем по нужной организации. Если такой не найдём, то
		//	результат будет такой же, как и в "верхней" ветке условия.
			ДанныеУзла = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла();

			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
			|	МагазиныУзла.Магазин КАК Магазин,
			|	МагазиныУзла.Магазин.НомерМагазина КАК КлючПорядка,
			|	0 КАК НомерЗапроса
			|ИЗ
			|	Справочник.СтруктураУзлов.Магазины КАК МагазиныУзла
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОрганизацииПодразделений.СрезПоследних(&Период, ) КАК ТаблицаОрганизаций
			|		ПО МагазиныУзла.Магазин = ТаблицаОрганизаций.Владелец
			|ГДЕ
			|	МагазиныУзла.Ссылка = &ЭлементСтруктуры
			|	И ТаблицаОрганизаций.Организация = &Организация
			|	И НЕ ТаблицаОрганизаций.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	ТаблицаУзлы.Магазин,
			|	ТаблицаУзлы.Магазин.НомерМагазина,
			|	1
			|ИЗ
			|	ПланОбмена.ПоМагазину КАК ТаблицаУзлы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланОбмена.ПоМагазину.Организации КАК ТабличнаяЧасть
			|		ПО ТаблицаУзлы.Ссылка = ТабличнаяЧасть.Ссылка
			|ГДЕ
			|	ТаблицаУзлы.ЭтотУзел
			|	И ТабличнаяЧасть.Организация = &Организация
			|	И НЕ ТабличнаяЧасть.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
			|
			|УПОРЯДОЧИТЬ ПО
			|	КлючПорядка"
			);
			Запрос.УстановитьПараметр("Период", ТекущаяДата());	//	LNK 16.11.2023 05:28:26
			Запрос.УстановитьПараметр("Организация", Организация);
			Запрос.УстановитьПараметр("ЭлементСтруктуры", ДанныеУзла.ЭлементСтруктуры);

			Выборка = Запрос.Выполнить().Выбрать();

			Если Выборка.Следующий() Тогда

				ПараметрыСеанса.ТекущийМагазин = Выборка.Магазин;

			Иначе

				Организация = ОрганизацияМагазина;

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	ПараметрыСеанса.ТекущаяОрганизация = Организация;

	Если УстановитьНастройкуПользователя Тогда

		МенеджерЗаписи = РегистрыСведений.НастройкиПользователей.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Пользователь = Пользователь;
		МенеджерЗаписи.Магазин      = ПараметрыСеанса.ТекущийМагазин;
		МенеджерЗаписи.Настройка    = ПланыВидовХарактеристик.НастройкиПользователей.ОсновнаяОрганизация;
		МенеджерЗаписи.Значение     = ПараметрыСеанса.ТекущаяОрганизация;

		МенеджерЗаписи.Записать();

	КонецЕсли;

КонецПроцедуры


