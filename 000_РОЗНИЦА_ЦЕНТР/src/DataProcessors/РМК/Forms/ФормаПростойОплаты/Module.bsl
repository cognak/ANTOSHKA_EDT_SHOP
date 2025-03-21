////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

&НаКлиенте
Перем ЦветФонаСдачи;

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;
	
	ЭтотОбъект().Журнал(ИмяФормы + ".ПриСозданииНаСервере");		//	LNK 02.08.2019 10:56:00

	Параметры.Свойство("Магазин", Магазин);							//	LNK 28.02.2024 08:10:14
	Параметры.Свойство("ВидОперации", ВидОперации);					//	LNK 12.03.2021 09:18:26
	Параметры.Свойство("РазрешитьОкругление", РазрешитьОкругление);
	Параметры.Свойство("ЦенаВключаетНДС"	, ЦенаВключаетНДС);		//	LNK 05.04.2021 09:26:39
	Параметры.Свойство("СуммаБонусныхБаллов", СуммаБонусныхБаллов);	//	LNK 26.02.2021 11:33:47
	Параметры.Свойство("ОплатаБалламиНазначенаЗаказомПокупателя", ОплатаБалламиНазначенаЗаказомПокупателя);	//	LNK 07.12.2021 04:52:59
	Параметры.Свойство("СуммаНаличныхОграничение", СуммаНаличныхОграничение);	//	LNK 10.01.2023 06:30:12

	Параметры.Свойство("ЗапретитьОплатуБонусами", ЗапретитьОплатуБонусами);		//	LNK 23.06.2021 11:13:51
	
	ИспользоватьБонуснуюСистему = БонусныеБаллыПовтИсп.ИспользоватьБонуснуюСистему() И ВидОперации = Перечисления.ВидыОперацийЧекККМ.Продажа;

	Если Параметры.ВидОперации = Перечисления.ВидыОперацийЧекККМ.Возврат Тогда

		Заголовок = "Повернення коштів";
		Элементы.ОплатитьКартой.Заголовок = "ПОВЕРНЕННЯ НА КАРТУ (F4)";

		Если Параметры.Свойство("ЧекККМПродажа") И ЗначениеЗаполнено(Параметры.ЧекККМПродажа) Тогда

			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ТаблицаОплата.ВидОплаты КАК ВидОплаты
			|ИЗ
			|	Документ.ЧекККМ.Оплата КАК ТаблицаОплата
			|ГДЕ
			|	ТаблицаОплата.Ссылка = &ЧекККМПродажа
			|	И ТаблицаОплата.ВидОплаты.ТипОплаты = ЗНАЧЕНИЕ(Перечисление.ТипыОплатЧекаККМ.ПлатежнаяКарта)"
			);
			Запрос.УстановитьПараметр("ЧекККМПродажа", Параметры.ЧекККМПродажа);
		//	Запрос.УстановитьПараметр("СуммаИтоговая", Параметры.СуммаИтоговая);
		
			//2025-03-15 sa Новое правило, если в чеке продажи было несколько видов оплаты, то возврат такого чека только за Наличные.
			БылаОплатаКартойПриПродаже =  НЕ Запрос.Выполнить().Пустой();
			БылаСмешаннаяОплата =   Параметры.ЧекККМПродажа.Оплата.Количество()>1;
			Элементы.ОплатитьКартой.Доступность = БылаОплатаКартойПриПродаже И НЕ БылаСмешаннаяОплата;
		КонецЕсли;

		Элементы.ПолеВводимоеЧисло.Заголовок = "Видано";
		Элементы.ИтогПоЧеку.Заголовок        = "До повернення";

	КонецЕсли;

	Параметры.Свойство("БлокироватьИзменениеСуммыОплаты", БлокироватьИзменениеСуммыОплаты);	//	LNK 23.11.2017 08:32:22

	КоличествоСимволовПослеЗапятой = ?(РазрешитьОкругление, 1, 2);
	ПервыйВвод = Истина;
	
	ЗаполнитьИзменяемыеРеквизиты(Параметры);
	
	Если ИтогПоЧеку = 0 Тогда

			Отказ = Истина;

	Иначе	ТабличноеПолеЧеков.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыЧеков));

	КонецЕсли;

КонецПроцедуры

&НаКлиенте	//+HVOYA Mykhailo
Процедура ПриОткрытии(Отказ)
	
	УстановитьОформлениеЭлементов();

	БонусныеБаллыКлиент.ПроверитьНачисленияПоКредитнойОплате(ВладелецФормы.Объект, ВладелецФормы);	//	LNK 30.07.2021 13:59:24
	
КонецПроцедуры

&НаКлиенте	//	LNK 26.02.2021 11:35:49
Процедура УстановитьОформлениеЭлементов()

	Элементы.КомандаИспользованиеБонусов.Видимость =
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЧекККМ.Продажа")
		И ИспользоватьБонуснуюСистему
		И НЕ ПустаяСтрока(ВладелецФормы.Объект.НомерТелефона)
		И НЕ СуммаБонусныхБаллов = 0
		И НЕ ОплатаБалламиНазначенаЗаказомПокупателя;

	ДоступностьКоманды = Элементы.КомандаИспользованиеБонусов.Доступность;
	Элементы.КомандаИспользованиеБонусов.Доступность = НЕ ЗапретитьОплатуБонусами;

	Если Элементы.КомандаИспользованиеБонусов.Видимость И НЕ Элементы.КомандаИспользованиеБонусов.Доступность = ДоступностьКоманды Тогда

		ПоказатьОповещениеПользователя("Оплата бонусними балами",, "Оплата бонусними балами заборонена!", БиблиотекаКартинок.Предупреждение32);

	КонецЕсли;
	
КонецПроцедуры


&НаСервере	//	LNK 16.07.2019 11:09:02
Функция ЭтотОбъект(ТекущийОбъект = Неопределено) 

	Если ТекущийОбъект = Неопределено Тогда

		Возврат РеквизитФормыВЗначение("Объект");

	КонецЕсли;

	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");

	Возврат Неопределено;

КонецФункции

&НаСервере	//	LNK 16.09.2019 12:52:00
Процедура ЗаполнитьИзменяемыеРеквизиты(ПараметрыФормы)

	Элементы.СуммаБезСкидки.Заголовок =  Формат(ПараметрыФормы.СуммаИтоговая + ПараметрыФормы.СуммаСкидки, "ЧЦ=15; ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	Элементы.СуммаСкидки.Заголовок	  =  Формат(ПараметрыФормы.СуммаСкидки  , "ЧЦ=15; ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	Элементы.СуммаКОПлате.Заголовок	  =  Формат(ПараметрыФормы.СуммаИтоговая, "ЧЦ=15; ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	
	ПараметрыФормы.Свойство("ИтогПоЧеку", СуммаОплаты);
	ПараметрыФормы.Свойство("ИтогПоЧеку", ИтогПоЧеку);

	СуммаСдачи    = 0;
	ВводимоеЧисло = Формат(СуммаОкругленная(СуммаОплаты), "ЧЦ=15; ЧДЦ=2; ЧГ=3,0");

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Команда0(Команда)
	
	ДобавитьЦифру("0")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда1(Команда)
	
	ДобавитьЦифру("1")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда2(Команда)
	
	ДобавитьЦифру("2")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда3(Команда)
	
	ДобавитьЦифру("3")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда4(Команда)
	
	ДобавитьЦифру("4")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда5(Команда)
	
	ДобавитьЦифру("5")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда6(Команда)
	
	ДобавитьЦифру("6")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда7(Команда)
	
	ДобавитьЦифру("7")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда8(Команда)
	
	ДобавитьЦифру("8")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда9(Команда)
	
	ДобавитьЦифру("9")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда0ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("0")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда1ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("1")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда2ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("2")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда3ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("3")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда4ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("4")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда5ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("5")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда6ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("6")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда7ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("7")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда8ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("8")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда9ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("9")
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаТочка(Команда)
	
	Если ПервыйВвод Тогда
		ВводимоеЧисло = "";
		ПервыйВвод = Ложь;
	КонецЕсли;
	
	Если ВводимоеЧисло = "" Тогда
		ВводимоеЧисло = "0";
	КонецЕсли;
	
	ЧислоВхождений = СтрЧислоВхождений(ВводимоеЧисло, ",");
	
	Если Не ЧислоВхождений > 0 Тогда
		ВводимоеЧисло = ВводимоеЧисло + ",";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаСтереть(Команда)

	ТекущийЭлемент = Элементы.КомандаEnterПраваяКлавиатура;	//	LNK 14.07.2017 08:36:36

//	LNK 07.07.2017 09:56:08
	ВводимоеЧисло = Лев(ВводимоеЧисло, СтрДлина(ВводимоеЧисло) - 1);
	ПересчитатьСуммыНаФорме();

КонецПроцедуры

&НаКлиенте
Процедура КомандаEnter(Команда)

	СуммаОплатыЧисло = ПривестиСтрокуКЧислу(ВводимоеЧисло, Ложь);

	Если СуммаОплатыЧисло = 0 ИЛИ СуммаОплатыЧисло > СуммаНаличныхОграничение Тогда

		ПараметрыИнформации = ОбщегоНазначенияРТКлиентСервер.ПолучитьСтруктуруВыводимойВРМКИнформации();
		ПараметрыИнформации.ЗаголовокИнформации = "ПОГАНА СУМА ОПЛАТИ";

		Если СуммаОплатыЧисло = 0 Тогда

			ПараметрыИнформации.ТекстИнформации = "Сума оплати має бути заповнена!";

		Иначе

			ПараметрыИнформации.ТекстИнформации =
			"Сума готівки не може перевищувати ліміт одномоментної готівкової оплати (" + Формат(СуммаНаличныхОграничение, "ЧДЦ=2; ЧН=0,00") + ")!";

		КонецЕсли;

		ОбщегоНазначенияРТКлиент.ОткрытьФормуИнформацииДляРМК(ПараметрыИнформации);

		Возврат;

	КонецЕсли;

	ВыполнитьОкругление(СуммаОплатыЧисло);	//	LNK 17.09.2019 11:13:42

	СтуктураОтвета = Новый Структура;
	СтуктураОтвета.Вставить("Действие", "Закрыть чек");

	Для каждого СтрокаТабличноеПолеЧеков Из ТабличноеПолеЧеков Цикл

		СтрокаОплаты = Объект.Оплата.Добавить();
		СтрокаОплаты.ВидОплаты   = ПредопределенноеЗначение("Справочник.ВидыОплатЧекаККМ.Наличные");
		СтрокаОплаты.Организация = СтрокаТабличноеПолеЧеков.Организация;
		СтрокаОплаты.Сумма       = СтрокаТабличноеПолеЧеков.Сумма;

	КонецЦикла;

	Сдача = СуммаОплатыЧисло - Объект.Оплата.Итог("Сумма");

	Если Сдача > 0 Тогда

		СтрокаОплаты.Сумма = СтрокаОплаты.Сумма + Сдача;

	КонецЕсли;

	СтуктураОтвета.Вставить("АдресТаблицыОплата", АдресТаблицыОплата());

	Закрыть(СтуктураОтвета);
	
КонецПроцедуры

&НаКлиенте	//	LNK 17.09.2019 11:13:17
Процедура ВыполнитьОкругление(СуммаОплатыЧисло)

	Если РазрешитьОкругление Тогда

		ВладелецФормы.ВыполнитьОкруглениеСуммыОплаты();

		ЗаполнитьИзменяемыеРеквизиты(ВладелецФормы.ПолучитьПараметрыОплаты(ВладелецФормы.ТабличноеПолеЧеков[0], Ложь, 0));

		Если ТабличноеПолеЧеков.Количество() = 1 Тогда

			ТабличноеПолеЧеков[0].Сумма = СуммаОплатыЧисло;

		Иначе

			Для каждого СтрокаТабличноеПолеЧеков Из ТабличноеПолеЧеков.НайтиСтроки(Новый Структура("Организация", Объект.Организация)) Цикл

				СтрокаТабличноеПолеЧеков.Сумма = СуммаОплатыЧисло;

			КонецЦикла;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте	//	LNK 26.02.2021 12:36:10
Процедура КомандаИспользованиеБонусов(Команда)

	ВладелецФормы.ОткрытьФормуИспользованияБонусов(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте	//	LNK 18.06.2021 10:07:43
Процедура КомандаИспользованиеБонусовЗавершение(ДанныеПрименения, ДополнительныеПараметры)	Экспорт

	Если ТипЗнч(ДанныеПрименения) = Тип("Структура") Тогда

		КомандаИспользованиеБонусовОбновитьДанныеФормы(
			ВладелецФормы.КомандаИспользованиеБонусовЗавершение(ДанныеПрименения, ДополнительныеПараметры)
		);
		Элементы.КомандаИспользованиеБонусов.Доступность = Ложь;	//	LNK 20.09.2021 14:40:33

	КонецЕсли;

КонецПроцедуры

&НаКлиенте	//	LNK 23.06.2021 08:44:11
Процедура КомандаИспользованиеБонусовОбновитьДанныеФормы(РезультатПогашения)	Экспорт

	ЗаполнитьИзменяемыеРеквизиты(РезультатПогашения);

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ДобавитьЦифру(ВведеннаяЦифраСтрокой)
	
	ТекущийЭлемент = Элементы.КомандаEnterПраваяКлавиатура;	//	LNK 14.07.2017 08:36:36

	Если ПервыйВвод Тогда

		ВводимоеЧисло = "";
		ПервыйВвод = Ложь;

	КонецЕсли;

	Запятая = Сред(ВводимоеЧисло, СтрДлина(ВводимоеЧисло) - КоличествоСимволовПослеЗапятой, 1);
	
	Если НЕ Запятая = "," Тогда

		ВводимоеЧисло = ВводимоеЧисло + ВведеннаяЦифраСтрокой;

	КонецЕсли;

	ПересчитатьСуммыНаФорме();

	Элементы.СуммаСдачи.ЦветФона = ЦветФонаСдачи;
	
	ЗапретитьОплатуБонусами = Истина;
	УстановитьОформлениеЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммыНаФорме()

	СуммаОплаты = ПривестиСтрокуКЧислу(ВводимоеЧисло, Истина);

	Если СуммаОплаты >= СуммаОкругленная(ИтогПоЧеку) Тогда

		СуммаСдачи = ПолучитьСуммуСдачи();

		Элементы.КомандаEnterПраваяКлавиатура.Доступность = Истина;
		Элементы.КомандаEnter.Доступность = Истина;
		ЦветФонаСдачи = Новый Цвет(226, 240, 226);
		ТекущийЭлемент = Элементы.КомандаEnter;

	Иначе

		СуммаСдачи = 0;

		Элементы.КомандаEnterПраваяКлавиатура.Доступность = Ложь;
		Элементы.КомандаEnter.Доступность = Ложь;
		ЦветФонаСдачи = Новый Цвет();

	КонецЕсли;

	Элементы.СуммаСдачи.ЦветФона = ЦветФонаСдачи;

КонецПроцедуры

&НаКлиенте	//	LNK 17.09.2019 11:19:12
Функция ПолучитьСуммуСдачи()

	Если РазрешитьОкругление Тогда

		Значение = ?(СуммаОплаты = ИтогПоЧеку, 0, СуммаОплаты - СуммаОкругленная(ИтогПоЧеку));

	Иначе

		Значение = СуммаОплаты - ИтогПоЧеку;

	КонецЕсли;

	Возврат Значение;

КонецФункции

&НаСервере	//	LNK 23.09.2019 12:01:53
Функция СуммаОкругленная(СуммаПараметр)

	Если РазрешитьОкругление Тогда

		Значение = Окр(СуммаПараметр, 1, РежимОкругления.Окр15как20);

	Иначе

		Значение = СуммаПараметр;

	КонецЕсли;

	Возврат Значение;

КонецФункции

//	функция выполняет приведение строки к числу
// Параметры:
//  ЧислоСтрокой           - Строка - Строка приводимая к числу
//  ВозвращатьНеопределено - Булево - Если Истина и строка содержит некорректное значение, то возвращать Неопределено
//
// Возвращаемое значение:
//  Число
//
&НаКлиенте
Функция ПривестиСтрокуКЧислу(ЧислоСтрокой, ВозвращатьНеопределено = Ложь) Экспорт
	
	ОписаниеТипаЧисла = Новый ОписаниеТипов("Число");
	ЗначениеЧисла = ОписаниеТипаЧисла.ПривестиЗначение(ЧислоСтрокой);
	
	Если ВозвращатьНеопределено И (ЗначениеЧисла = 0) Тогда
		
		Стр = Строка(ЧислоСтрокой);
		Если Стр = "" Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Стр = СтрЗаменить(СокрЛП(Стр), "0", "");
		Если (Стр <> "") И (Стр <> ".") И (Стр <> ",") Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗначениеЧисла;
	
КонецФункции

&НаСервере
Функция АдресТаблицыОплата()
	
	АдресТаблицыОплата = ПоместитьВоВременноеХранилище(Объект.Оплата.Выгрузить(), Новый УникальныйИдентификатор);
	
	Возврат АдресТаблицыОплата;
	
КонецФункции

&НаКлиенте	// + HVOYA 06.10.2016 13:23:09, Латышев А.А.
Процедура ОплатитьКартой(Команда)

	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЧекККМ.Продажа") Тогда

		Если ВладелецФормы.ОтменитьРучнуюОплатуБонуснымиБалламиНаСервере() Тогда

			ПоказатьОповещениеПользователя("Оплата бонусними балами"
				,
				, "Очищено суму балів, яку введено вручну!"
				, БиблиотекаКартинок.Предупреждение32
			);

		КонецЕсли;

	КонецЕсли;

	Закрыть("ОплатаКартой");

КонецПроцедуры






