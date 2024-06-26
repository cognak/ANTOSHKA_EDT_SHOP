#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;

//	Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);

//	LNK 02.10.2016 12:32:18
	ИменаОтбора = Новый Массив;
	ИменаОтбора.Добавить("Покупатель");
	ИменаОтбора.Добавить("Поставщик");

	Для каждого ИмяОтбора Из ИменаОтбора Цикл

		Если Параметры.Свойство(ИмяОтбора) Тогда

			Параметры.Отбор.Вставить(ИмяОтбора, Параметры[ИмяОтбора]);

		КонецЕсли;

	КонецЦикла;
	
	Если Параметры.Свойство("Заголовок", Заголовок) Тогда

		АвтоЗаголовок = Ложь;

	КонецЕсли;

	Если УправлениеПользователями.ПолучитьБулевоЗначениеПраваПользователя("АдминистраторПолномочный", Ложь) = Истина Тогда

		Элементы.Список.Вывод = ИспользованиеВывода.Авто;

	КонецЕсли;
	Если РольДоступна(Метаданные.Роли.АдминистраторСистемы) или РольДоступна(Метаданные.Роли.ДобавлениеИзменениеИнформацииПоКонтрагентам) тогда
		Элементы.ГруппаЮрЛицо.Видимость = Истина;
	Иначе
		Элементы.ГруппаЮрЛицо.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте	//	LNK 27.04.2020 07:28:24
Процедура ПриОткрытии(Отказ)

	УстановитьОформлениеЭлементовФормы();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура КлючРеквизитаПриИзменении(Элемент)

	ЗначениеРеквизита = "";
	ЗначениеРеквизитаНаСервере();

	УстановитьОформлениеЭлементовФормы();

КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаПриИзменении(Элемент)

	Если ЗначениеРеквизитаНаСервере() Тогда

		ПоказатьОповещениеПользователя("Найден " + ЗначениеРеквизита,, "Список позиционирован на элементе «" + Элементы.Список.ТекущаяСтрока + "»", БиблиотекаКартинок.Информация32);

		СпискиВыбораКлиентСервер.ОбновитьСписокВыбора(Элементы.ЗначениеРеквизита.СписокВыбора, ЗначениеРеквизита);
		СпискиВыбораКлиентСервер.Сохранить("ЗначениеРеквизитаКонтрагенты.Список." + Формат(КлючРеквизита, "ЧЦ=4; ЧН=0000; ЧВН=; ЧГ="), Элементы.ЗначениеРеквизита.СписокВыбора);

	ИначеЕсли НЕ ПустаяСтрока(ЗначениеРеквизита) Тогда

		ПоказатьОповещениеПользователя("Не найден!",, "Реквизит " + СокрЛП(ЗначениеРеквизита) + " не удалось обнаружить в справочнике.", БиблиотекаКартинок.Ошибка32);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаОчистка(Элемент, СтандартнаяОбработка)

	ЗначениеРеквизитаНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаОткрытие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ЗначениеРеквизитаНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	СпискиВыбораКлиентСервер.АвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);

КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере	//	LNK 23.04.2020 15:03:33
Функция ЗначениеРеквизитаНаСервере()

	Если ПустаяСтрока(ЗначениеРеквизита) Тогда

		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
			Список, 
			"Ссылка", 
			, 
			Ложь
		);
		Элементы.Список.Отображение = ОтображениеТаблицы.ИерархическийСписок;

		Возврат Ложь;

	КонецЕсли;

	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаКонтакты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Контрагенты.КонтактнаяИнформация КАК ТаблицаКонтакты
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &КлючРеквизита = 0
	|				ТОГДА ТаблицаКонтакты.НомерТелефона = &ЗначениеРеквизита
	|						И ТаблицаКонтакты.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	|			ИНАЧЕ ТаблицаКонтакты.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|					И (ТаблицаКонтакты.АдресЭП = &ЗначениеРеквизита
	|						ИЛИ ТаблицаКонтакты.Представление = &ЗначениеРеквизита)
	|		КОНЕЦ"
	);
	Запрос.УстановитьПараметр("КлючРеквизита"    , КлючРеквизита);
	Запрос.УстановитьПараметр("ЗначениеРеквизита", ?(КлючРеквизита = 0, ОтправкаSMS.ПодготовитьНомерТелефона(ЗначениеРеквизита), ЗначениеРеквизита));
	
	Результат = Запрос.Выполнить();
	Найден    = НЕ Результат.Пустой();

	Если Найден Тогда

		СписокСсылок = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");

		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
			Список, 
			"Ссылка", 
			СписокСсылок, 
			Истина,
			ВидСравненияКомпоновкиДанных.ВСписке
		);
		Элементы.Список.ТекущаяСтрока = СписокСсылок[0];
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;

	Иначе

		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
			Список, 
			"Ссылка", 
			, 
			Ложь
		);
		Элементы.Список.Отображение = ОтображениеТаблицы.ИерархическийСписок;

	КонецЕсли;

	Возврат Найден;

КонецФункции

&НаКлиенте
Процедура УстановитьОформлениеЭлементовФормы()

	Если КлючРеквизита = 0 Тогда

		Элементы.ЗначениеРеквизита.Маска          = "+380 99 999 99 99";
		Элементы.ЗначениеРеквизита.ПодсказкаВвода = "+380 99 999 99 99";

	Иначе

		Элементы.ЗначениеРеквизита.Маска          = "";
		Элементы.ЗначениеРеквизита.ПодсказкаВвода = "joker@gmail.com";

	КонецЕсли;

	СпискиВыбораКлиентСервер.Загрузить("ЗначениеРеквизитаКонтрагенты.Список." + Формат(КлючРеквизита, "ЧЦ=4; ЧН=0000; ЧВН=; ЧГ="), Элементы.ЗначениеРеквизита.СписокВыбора);

КонецПроцедуры

#КонецОбласти












