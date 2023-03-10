#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура Регистрация(Объект, ТипРегистрации, ПараметрыРегистрации)	Экспорт

	Если НЕ ПривилегированныйРежим() Тогда

		УстановитьПривилегированныйРежим(Истина);

	КонецЕсли;

	Если НЕ ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

		Возврат;

	КонецЕсли;

	#Если _ Тогда
	Объект = Документы.ЗаказПокупателя.СоздатьДокумент();
	#КонецЕсли

	Если ТипРегистрации = Перечисления.ТипыРегистрацииMagento.БонусныеНакопления Тогда

		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаШапка.Дата КАК Дата,
		|	ТаблицаШапка.Ссылка КАК Объект,
		|	ТаблицаШапка.СтатусИМ КАК СтатусИМ
		|ПОМЕСТИТЬ Фильтр
		|ИЗ
		|	Документ.ЗаказПокупателя КАК ТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя.НачислениеБонусныхБаллов КАК ТабличнаяЧасть
		|		ПО ТаблицаШапка.Ссылка = ТабличнаяЧасть.Ссылка
		|ГДЕ
		|	ТаблицаШапка.Ссылка = &Объект
		|	И ТаблицаШапка.Проведен
		|	И НЕ ТабличнаяЧасть.СуммаБонусныхБаллов = 0
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ТаблицаШапка.Дата,
		|	ТаблицаШапка.Ссылка,
		|	ТаблицаШапка.СтатусИМ
		|ИЗ
		|	Документ.ЗаказПокупателя КАК ТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя.ОплатаБонуснымиБаллами КАК ТабличнаяЧасть
		|		ПО ТаблицаШапка.Ссылка = ТабличнаяЧасть.Ссылка
		|ГДЕ
		|	ТаблицаШапка.Ссылка = &Объект
		|	И ТаблицаШапка.Проведен
		|	И НЕ ТабличнаяЧасть.СуммаБонусныхБаллов = 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ТаблицаКлючевыеАтрибуты.ДатаИзмененияСтатуса ЕСТЬ NULL
		|			ТОГДА Ведущая.Дата
		|		КОГДА ТаблицаКлючевыеАтрибуты.ДатаИзмененияСтатуса = ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ТаблицаКлючевыеАтрибуты.Период
		|		ИНАЧЕ ТаблицаКлючевыеАтрибуты.ДатаИзмененияСтатуса
		|	КОНЕЦ КАК ДатаНачисления,
		|	Ведущая.Объект КАК Объект
		|ИЗ
		|	Фильтр КАК Ведущая
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КлючевыеАтрибутыЗаказовПокупателей КАК ТаблицаКлючевыеАтрибуты
		|		ПО Ведущая.Объект = ТаблицаКлючевыеАтрибуты.ЗаказПокупателя
		|			И (ТаблицаКлючевыеАтрибуты.СтатусИМ = ЗНАЧЕНИЕ(Перечисление.СтатусыИнтернетМагазина.delivered))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацияОбъектовMagento КАК ТаблицаРегистраций
		|		ПО Ведущая.Объект = ТаблицаРегистраций.Объект
		|			И (ТаблицаРегистраций.ТипРегистрации = &ТипРегистрации)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЧекККМ КАК ТаблицаЧеки
		|		ПО Ведущая.Объект = ТаблицаЧеки.ЗаказПокупателя
		|ГДЕ
		|	ТаблицаРегистраций.Объект ЕСТЬ NULL
		|	И ТаблицаЧеки.Ссылка ЕСТЬ NULL
		|	И ВЫБОР
		|			КОГДА ТаблицаКлючевыеАтрибуты.ЗаказПокупателя ЕСТЬ NULL
		|				ТОГДА Ведущая.СтатусИМ = ЗНАЧЕНИЕ(Перечисление.СтатусыИнтернетМагазина.delivered)
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачисления,
		|	Объект
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ Фильтр"
		);
	//	запросом, собственно, проверяем наличие строк в табличных частях..
	//	а записи в регистре может ещё и не быть!
	//	а так же отсутствие записи в регистрации, плюс к тому отсутствие "на основании" чека ККМ.
		Запрос.УстановитьПараметр("Объект"		  , Объект);
		Запрос.УстановитьПараметр("ТипРегистрации", ТипРегистрации);
		
		РезультатЗапроса = Запрос.Выполнить();

		Если НЕ РезультатЗапроса.Пустой() Тогда

			ДанныеВыборка = РезультатЗапроса.Выбрать();
			ДанныеВыборка.Следующий();

			Если ПараметрыРегистрации.Свойство("ДатаНачисления") И ТипЗнч(ПараметрыРегистрации.ДатаНачисления) = Тип("Дата") Тогда

					ДатаНачисления = ПараметрыРегистрации.ДатаНачисления;

			Иначе	ДатаНачисления = ДанныеВыборка.ДатаНачисления;

			КонецЕсли;

			Если ТипЗнч(ДатаНачисления) = Тип("Дата") И НЕ ДатаНачисления = '00010101' Тогда

				НаборЗаписей = РегистрыСведений.РегистрацияОбъектовMagento.СоздатьНаборЗаписей();
				НаборЗаписей.ОбменДанными.Загрузка = Истина;

				НаборЗаписей.Отбор.Объект.Установить(Объект);
				НаборЗаписей.Отбор.ТипРегистрации.Установить(ТипРегистрации);

				ЗаписьНабора = НаборЗаписей.Добавить();
				ЗаписьНабора.Объект = НаборЗаписей.Отбор.Объект.Значение;
				ЗаписьНабора.ТипРегистрации = НаборЗаписей.Отбор.ТипРегистрации.Значение;

				ЗаписьНабора.ДатаНачисления = ДатаНачисления;
				ЗаписьНабора.ДатаИзменения	= ТекущаяДата();

				НаборЗаписей.Записать();

			КонецЕсли;

		Иначе

			ЗаписьЖурналаРегистрации("РЕГ.MAGENTO", УровеньЖурналаРегистрации.Информация
				, Объект.Метаданные()
				, Объект
				, "Отказано в регистрации для выгрузки в NAV"
			);

		КонецЕсли;

	Иначе


	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
