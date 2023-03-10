&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;

	ЗаполнитьТаблицуДокументов();

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ЗафиксироватьВыборСтроки();

КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)

	ЗафиксироватьВыборСтроки();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуДокументов()

	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаДоговоры.Дата КАК Дата,
	|	ТаблицаДоговоры.Ссылка КАК Ссылка,
	|	ТаблицаДоговоры.НомерДоговора,
	|	ТаблицаДоговоры.СуммаСтраховогоВзноса,
	|	ТаблицаДоговоры.Контрагент,
	|	ТаблицаДоговоры.Номенклатура КАК Номенклатура,
	|	ТаблицаДоговоры.ИнформационнаяКарта,
	|	ЗНАЧЕНИЕ(Справочник.СегментыНоменклатуры.РазрешеноСтраховать) КАК Сегмент
	|ПОМЕСТИТЬ Реестр
	|ИЗ
	|	РегистрНакопления.ДоговорыСтрахованияОплаченные.Остатки(, ) КАК ТаблицаРегистра
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ДоговорСтрахования КАК ТаблицаДоговоры
	|		ПО ТаблицаРегистра.ДоговорСтрахования = ТаблицаДоговоры.Ссылка
	|ГДЕ
	|	ТаблицаДоговоры.Магазин = &Магазин
	|	И ТаблицаДоговоры.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&ТекущаяДата, ДЕНЬ) И КОНЕЦПЕРИОДА(&ТекущаяДата, ДЕНЬ)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Реестр.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ Сегменты
	|ИЗ
	|	Реестр КАК Реестр
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСегмента КАК ТаблицаСегмента
	|		ПО Реестр.Сегмент = ТаблицаСегмента.Сегмент
	|			И Реестр.Номенклатура = ТаблицаСегмента.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реестр.Дата,
	|	Реестр.Ссылка,
	|	Реестр.НомерДоговора,
	|	Реестр.СуммаСтраховогоВзноса,
	|	Реестр.Контрагент,
	|	Реестр.Номенклатура,
	|	Реестр.ИнформационнаяКарта,
	|	ВЫБОР
	|		КОГДА Сегменты.Номенклатура ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК РазрешеноСтраховать
	|ИЗ
	|	Реестр КАК Реестр
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сегменты КАК Сегменты
	|		ПО Реестр.Номенклатура = Сегменты.Номенклатура"
	);
	Запрос.УстановитьПараметр("Магазин"    , Параметры.Магазин);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	ТаблицаДокументов.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьВыборСтроки()
	
	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда

		Закрыть();

	Иначе

		Если НЕ ТекущиеДанные.РазрешеноСтраховать Тогда

			ПараметрыИнформации = ОбщегоНазначенияРТКлиентСервер.ПолучитьСтруктуруВыводимойВРМКИнформации();
			ПараметрыИнформации.ЗаголовокИнформации = "Ограничение номенклатуры страхования";
			ПараметрыИнформации.ТекстИнформации = "Отказано!" + Символы.ПС + "Товар «" + ТекущиеДанные.Номенклатура
				+ "» не может быть застрахован! Он не входит в состав сегмента, назначенного для страхования.";
			ОбщегоНазначенияРТКлиент.ОткрытьФормуИнформацииДляРМК(ПараметрыИнформации);

		Иначе

			СтруктураСтроки = Новый Структура(
				"Ссылка, СуммаСтраховогоВзноса, Контрагент, ИнформационнаяКарта, Номенклатура"
				, ТекущиеДанные.Ссылка, ТекущиеДанные.СуммаСтраховогоВзноса, ТекущиеДанные.Контрагент, ТекущиеДанные.ИнформационнаяКарта, ТекущиеДанные.Номенклатура);
			Закрыть(СтруктураСтроки)

		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры





