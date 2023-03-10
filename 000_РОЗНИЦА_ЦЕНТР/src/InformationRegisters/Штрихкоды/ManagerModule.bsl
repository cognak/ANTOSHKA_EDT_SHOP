Функция ПолучитьДанныеПоШтрихкодам(Штрихкоды, ВернутьСписокВыбора = Ложь) Экспорт

	Если ВернутьСписокВыбора Тогда

			ДанныеПоШтрихкодам = Новый СписокЗначений;

	Иначе	ДанныеПоШтрихкодам = Новый Соответствие;

	КонецЕсли;

	МассивШтрихкодов = Новый Массив;

	Для Каждого ТекШтрихкод Из Штрихкоды Цикл

		МассивШтрихкодов.Добавить(ТекШтрихкод);

		Если НЕ ВернутьСписокВыбора Тогда

			ДанныеПоШтрихкодам.Вставить(ТекШтрихкод, Новый Структура);

		КонецЕсли;

	КонецЦикла;

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Штрихкоды.Владелец.Код КАК Код,
	|	Штрихкоды.Штрихкод КАК Штрихкод,
	|	Штрихкоды.Владелец КАК Номенклатура,
	|	Штрихкоды.Характеристика КАК Характеристика,
	|	Штрихкоды.Упаковка КАК Упаковка,
	|	Штрихкоды.Владелец.Наименование КАК КлючПорядка
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК Штрихкоды
	|ГДЕ
	|	Штрихкоды.Штрихкод В(&МассивШтрихкодов)
	|	И Штрихкоды.Владелец ССЫЛКА Справочник.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	КлючПорядка"
	);
	Запрос.УстановитьПараметр("МассивШтрихкодов", МассивШтрихкодов);

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл

		Если ВернутьСписокВыбора Тогда

			ДанныеПоШтрихкодам.Добавить(Выборка.Номенклатура, "(" + СокрЛП(Выборка.Код) + ") " + СокрЛП(Выборка.Номенклатура) + " -> ШК");

		Иначе

			ТекДанные = ДанныеПоШтрихкодам[Выборка.Штрихкод];
			ТекДанные.Вставить("Номенклатура"  , Выборка.Номенклатура);
			ТекДанные.Вставить("Характеристика", Выборка.Характеристика);
			ТекДанные.Вставить("Упаковка"      , Выборка.Упаковка);

		КонецЕсли;

	КонецЦикла;

	Возврат ДанныеПоШтрихкодам;

КонецФункции








