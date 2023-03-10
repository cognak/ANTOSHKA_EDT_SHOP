#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ТаблицаРолей.Параметры.УстановитьЗначениеПараметра("Пользователь" , "");
	ТаблицаРолей.Параметры.УстановитьЗначениеПараметра("ТекущаяСсылка", Объект.Ссылка);

	Элементы.СтраницаПараметрыСоединения.Видимость =
		Объект.ВидУзла = Перечисления.ВидыУзлов.КСУ_Navision
		И Объект.Предопределенный
		И ОбменДаннымиПовтИсп.ЭтоГлавныйУзел();

	УстановитьОформлениеЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)


КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("СтруктураУзлов.ЗаписанЭлемент", Объект.Ссылка, ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ТаблицаРолей.Параметры.УстановитьЗначениеПараметра("ТекущаяСсылка", ТекущийОбъект.Ссылка);
	Элементы.ТаблицаРолей.Обновить();
	УстановитьОформлениеЭлементов();

КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПользователиПриАктивизацииСтроки(Элемент)

	Параметр = "";

	Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда

		Параметр = Элемент.ТекущиеДанные.Имя;

	КонецЕсли;

	ТаблицаРолей.Параметры.УстановитьЗначениеПараметра("Пользователь", Параметр);

	Элемент.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура СужебныйКаталогФайловОткрытие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбора.Каталог   = Объект[Элемент.Имя];
	ДиалогВыбора.Заголовок = "Укажите каталог, в котором будут размещаться файлы"
		+ ?(Элемент.Имя = "КаталогФайловОбновления"    , " обновления (*.cfu):"
		, ?(Элемент.Имя = "КаталогФайловРезервныхКопий", " резервных копий (*.bak):", ":"));

	Если ДиалогВыбора.Выбрать() Тогда

		Объект[Элемент.Имя] = ДиалогВыбора.Каталог;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте	//	LNK 11.04.2022 07:32:50
Процедура ЧрезвычайноеПоложениеПриИзменении(Элемент)

	УстановитьОформлениеЭлементов();

КонецПроцедуры

#Область СлужебныеПроцедурыФункции

&НаСервере	//	LNK 11.04.2022 07:40:18
Процедура УстановитьОформлениеЭлементов()

	Элементы.ЧрезвычайноеПоложение.ЦветТекстаЗаголовка = ?(Объект.ЧрезвычайноеПоложение
		, ЦветаСтиля.ЦветНепроведенногоДокумента
		, Новый Цвет)
	;

КонецПроцедуры

#КонецОбласти