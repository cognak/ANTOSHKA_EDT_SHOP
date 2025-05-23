&НаКлиенте
Перем ЗакрытиеСанкционировано;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;

//	Этот реквизит формы используем, как отладочный, снимающий "фатальные" ограничения.
	ОтладочныйРежим = ТехническаяПоддержкаВызовСервера.ОтладочныйРежимРаботы();

	Если НЕ ПустаяСтрока(Параметры.ДанныеКонтрагента.НомерТелефона) Тогда

		СписокАбонентов = Справочники.Контрагенты.ПолучитьСписокПоНомеруТелефона(ОтправкаSMS.ПодготовитьНомерТелефона(Параметры.ДанныеКонтрагента.НомерТелефона),);

		Если СписокАбонентов.Количество() = 0 Тогда

			НомерТелефона    = Параметры.ДанныеКонтрагента.НомерТелефона;
			ДокументПродажи  = Параметры.ДокументПродажи;
			НазначениеДанных = Параметры.НазначениеДанных;

			Если НЕ Лев(НомерТелефона, 1) = "+" И НЕ ПустаяСтрока(НомерТелефона) Тогда

				НомерТелефона = "+" + НомерТелефона;

			КонецЕсли;

		Иначе

			ТекстОшибокЗаполнения = "Номер телефона уже имеется в базе данных.";

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ЗакрытиеСанкционировано = Ложь;

	Если НЕ ПустаяСтрока(ТекстОшибокЗаполнения) Тогда

		Отказ = Истина;
		ПоказатьПредупреждение(, "Отказано! " + ТекстОшибокЗаполнения, 10, "Данные покупателя");

	ИначеЕсли ПустаяСтрока(НомерТелефона) Тогда

		Отказ = Истина;
		ПоказатьПредупреждение(, "Отказано! Не указан номер телефона.", 10, "Данные покупателя");

	Иначе

		Подключаемый_ДоступностьWebRetail();
		УстановитьДоступностьЭлементовФормы();

		ПодключитьОбработчикОжидания("Подключаемый_ДоступностьWebRetail", 10, Ложь);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если НЕ ЗакрытиеСанкционировано = Истина Тогда

		Отказ = Истина;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗакрытьБезСохранения(Команда)

	Если Модифицированность Тогда

		ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытьБезСохраненияЗавершение", ЭтотОбъект);

		ПоказатьВопрос(ОписаниеОповещения
		, "Подтвердите закрытие без применения введенных данных"
		, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Да
		, "Введенные данные будут потеряны", КодВозвратаДиалога.Нет
		);

	Иначе

		ЗакрытьБезСохраненияЗавершение(КодВозвратаДиалога.Да,);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьБезСохраненияЗавершение(КодВозврата, ДополнительныеПараметры)	Экспорт

	Если КодВозврата = КодВозвратаДиалога.Да Тогда

		ЗакрытиеСанкционировано = Истина;
		Закрыть();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПолПриИзменении(Элемент)

	УстановитьДоступностьЭлементовФормы();

КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)

	Имя = РеквизитИмяСсылка(ИмяСсылка);
	СтроковыеФункцииКлиентСервер.ПривестиНаименование(Имя, Истина, Истина);

	УстановитьДоступностьЭлементовФормы();

КонецПроцедуры

&НаКлиенте	//	LNK 20.07.2021 06:35:58
Процедура ИмяАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	Если НЕ ПустаяСтрока(Текст) Тогда

		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ПолучитьДанныеВыбораИмени(Текст, Пол, Истина);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИмяИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)

	Если Пол.Пустая() Тогда

		Имя = "";
		СтандартнаяОбработка = Ложь;
		ПоказатьОповещениеПользователя("Укажите пол покупателя!",, "Для определения имени человека обязательно нужно указать пол", БиблиотекаКартинок.Ошибка32);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличногоПоляДети

&НаКлиенте
Процедура ТаблицаДетиИмяПриИзменении(Элемент)

	ТекущиеДанные = Элементы.ТаблицаДети.ТекущиеДанные;

	Если НЕ ТекущиеДанные = Неопределено Тогда

		СтроковыеФункцииКлиентСервер.ПривестиНаименование(ТекущиеДанные.Имя, Истина, Истина);

		Если НЕ ПроверитьИмяФизЛица(ТекущиеДанные.Имя, ТекущиеДанные.Пол) Тогда

			//А++ 20250116 по задаче  https://awdev.atlassian.net/browse/RETAIL1C-1055
			//Сообщить("Очищено! Имя «" + ТекущиеДанные.Имя + "» НЕ найдено в справочнике имён людей.");
			//ТекущиеДанные.Имя = "";
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Имя «%1» НЕ найдено в справочнике имён людей.'; uk = 'Ім''я %1 не знайдено у довіднику імен людей.'"),
							ТекущиеДанные.Имя);
			Сообщить(ТекстСообщения);
			//А++ 20250116 по задаче  https://awdev.atlassian.net/browse/RETAIL1C-1055


		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДетиПолПриИзменении(Элемент)

	ТекущиеДанные = Элементы.ТаблицаДети.ТекущиеДанные;

	Если НЕ ТекущиеДанные = Неопределено Тогда

		ТекущиеДанные.Имя = "";

	КонецЕсли;

КонецПроцедуры

&НаКлиенте	//	LNK 12.06.2019 13:33:17
Процедура ТаблицаДетиИмяАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	Если НЕ ПустаяСтрока(Текст) И НЕ Элементы.ТаблицаДети.ТекущиеДанные = Неопределено Тогда

		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ПолучитьДанныеВыбораИмени(Текст, Элементы.ТаблицаДети.ТекущиеДанные.Пол, Ложь);

	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста	//	LNK 12.06.2019 13:15:50
Функция ПолучитьДанныеВыбораИмени(Текст, Пол, ВернутьСсылки)

	Возврат Справочники.ИменаЛюдей.ПолучитьДанныеВыбораИмени(Текст, Пол, ВернутьСсылки);

КонецФункции
	
#КонецОбласти

#Область ОтправкаСообщенияSMS

&НаКлиенте
Процедура ОтправитьКодПодтвержденияSMS(Команда)

	Подключаемый_ДоступностьWebRetail();

	Если НЕ РесурсWebRetailДоступен Тогда

		ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМК(
			"SMS аутентификация"
			, "НЕТ доступа к серверу ЦБ. Попытайтесь выполнить позже позже."
		);
		Возврат;

	КонецЕсли;

	Если ПроверитьЗаполнение() Тогда

		ПоказатьВопрос(Новый ОписаниеОповещения("ОтправитьКодПодтвержденияSMSЗавершение", ЭтотОбъект)
			, "Будет отправлено SMS по указанному номеру. Подтвердите своё решение:", РежимДиалогаВопрос.ОКОтмена
			, 60, КодВозвратаДиалога.ОК, "ИДЕНТИФИКАЦИЯ", КодВозвратаДиалога.Отмена);

	Иначе

		ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМК("В действии отказано!", "Необходимо заполнить все обязательные поля:" + ТекстОшибокЗаполнения);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьКодПодтвержденияSMSЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда

		Если ОтладочныйРежим ИЛИ ОтправитьКодПодтвержденияSMSНаСервере(НомерТелефона, ИмяКомпьютера(), ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка")) Тогда

			ПодтверждениеОтправлено = Истина;
			ПоказатьОповещениеПользователя("Код успешно отправлен на телефон" + Символы.ПС + "«" + НомерТелефона + "»");

		КонецЕсли;

		УстановитьДоступностьЭлементовФормы();

		ТекущийЭлемент = Элементы.КодПодтверждения;

	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтправитьКодПодтвержденияSMSНаСервере(НомерТелефона, ИмяКлиентскогоКомпьютера, Контрагент)

	ДополнительныеПараметры = Новый Структура(
		"ИмяКомпьютера, Контрагент", ИмяКлиентскогоКомпьютера, Контрагент);

	Возврат ВерификацияКлиентовСервер.ОтправитьКодПодтверждения(ОтправкаSMS.ПодготовитьНомерТелефона(НомерТелефона), ДополнительныеПараметры, Истина);

КонецФункции

#КонецОбласти

#Область ПолучениеКодаПодтверждения

&НаКлиенте
Процедура КодПодтвержденияПриИзменении(Элемент)

	ПоказатьОповещениеПользователя("Проверка номера телефона"
	,, "Отправлен запрос на получение последнего кода подтверждения ..."
	, БиблиотекаКартинок.Вопрос32, СтатусОповещенияПользователя.Информация);

	ПодтверждениеПолучено = Ложь;	//	сбросим возможное подтверждение

	Если ОтладочныйРежим Тогда

		ДанныеКлиента = Новый Структура(
			"Указан, КодКлиента"
			, Истина
			, КодПодтверждения
		);

	Иначе

		ДанныеКлиента = КодПодтвержденияПриИзмененииНаСервере(НомерТелефона);

	КонецЕсли;

	Если ДанныеКлиента.Указан Тогда

		Если СокрЛП(ДанныеКлиента.КодКлиента) = СокрЛП(КодПодтверждения) Тогда

			ПодтверждениеПолучено = Истина;

			ПоказатьОповещениеПользователя("Проверка номера телефона"
			,, "Поздравляем! Код подтверждения соответствует"
			, БиблиотекаКартинок.Информация32, СтатусОповещенияПользователя.Информация);

			ТекущийЭлемент = Элементы.РегистрацияКлиента;

		Иначе

			ПоказатьОповещениеПользователя("Проверка номера телефона"
			,, "Код подтверждения не совпадает с отправленным на номер телефона «" + НомерТелефона + "»"
			, БиблиотекаКартинок.Ошибка32, СтатусОповещенияПользователя.Важное);

			ТекущийЭлемент = Элементы.КодПодтверждения;

		КонецЕсли;

	Иначе

		ПоказатьОповещениеПользователя("Проверка номера телефона"
		,, "Код подтверждения не получен. Возможно, не соответствует номер телефона «" + НомерТелефона + "»"
		, БиблиотекаКартинок.Ошибка32, СтатусОповещенияПользователя.Важное);

		ТекущийЭлемент = Элементы.КодПодтверждения;
	
	КонецЕсли;

	УстановитьДоступностьЭлементовФормы();

КонецПроцедуры

&НаСервереБезКонтекста
Функция КодПодтвержденияПриИзмененииНаСервере(НомерТелефона)

	Возврат ВерификацияКлиентовСервер.ПолучитьКодПодтверждения(ОтправкаSMS.ПодготовитьНомерТелефона(НомерТелефона), Истина);

КонецФункции // КодПодтвержденияПриИзмененииНаСервере()
	
#КонецОбласти

#Область РегистрацияНовогоКлиентаНаКассе

&НаКлиенте
Процедура РегистрацияКлиента(Команда)

	Подключаемый_ДоступностьWebRetail();

	Если РесурсWebRetailДоступен Тогда

		СоставДанных = РегистрацияКлиентаНаСервере();

		Если НЕ СоставДанных.Ошибка Тогда

		//	В случае успеха переменная "ДанныеКонтрагента" содержит структуру вида "СоставДанных".
			ЗакрытиеСанкционировано = Истина;
			Закрыть(СоставДанных);

		Иначе

			ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМК(
				"Неудачная регистрация нового покупателя. Возможно, имеет место проблема связи с сервером ЦБ."
				, СоставДанных.ОписаниеОшибки
			);

		КонецЕсли;

	Иначе

		ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМК(
			"Неудачная регистрация нового покупателя"
			, "НЕТ доступа к серверу ЦБ. Попытайтесь выполнить регистрацию позже."
		);

	КонецЕсли;

КонецПроцедуры

&НаСервере	//	LNK 15.08.2019 12:49:11
Функция РегистрацияКлиентаНаСервере()

	Попытка

		ДанныеКонтрагента = ОбменMicrosoftDynamicsСервер.ИнициализацияДанныхКонтрагента();

		ДанныеКонтрагента.НомерТелефона = ОтправкаSMS.ПодготовитьНомерТелефона(НомерТелефона);
		ДанныеКонтрагента.Пол      = Пол;
		ДанныеКонтрагента.Фамилия  = СтроковыеФункцииКлиентСервер.ПривестиНаименование(Фамилия, Истина);
		ДанныеКонтрагента.Имя      = СтроковыеФункцииКлиентСервер.ПривестиНаименование(Имя, Истина);
		ДанныеКонтрагента.Отчество = СтроковыеФункцииКлиентСервер.ПривестиНаименование(Отчество, Истина);

		ДанныеКонтрагента.ДатаРождения = ДатаРождения;
		ДанныеКонтрагента.Email = СокрЛП(Электропочта);
		ДанныеКонтрагента.Дети  = ТаблицаДети.Выгрузить();

		СоставДанных = РозничныеПродажиСлужебный.ВыполнитьКомплексДанныхКонтрагента(
			  ""
			, ДанныеКонтрагента.НомерТелефона
			, ДанныеКонтрагента
			, Перечисления.НазначениеКонтрагентовОтложенных.ПроверкаВРознице
			, Неопределено
		);

		Если НЕ СоставДанных.Ошибка Тогда

			Модифицированность = Ложь;

		КонецЕсли;

	Исключение

		СоставДанных = ОбменMicrosoftDynamicsСервер.ИнициализироватьСоставДанных();

		СоставДанных.Ошибка = Истина;
		СоставДанных.ОписаниеОшибки = ОписаниеОшибки();

		ЖурналСобытий.Регистрация("Контрагент.Новый", УровеньЖурналаРегистрации.Ошибка
			, Метаданные.ПланыОбмена.ОбменMicrosoftDynamics
			,
			,
			, "Ошибка передачи:" + Символы.ПС + СоставДанных.ОписаниеОшибки
			,
			,
			Ложь
		);	//	LNK 21.05.2020 07:03:26

	КонецПопытки;

	Возврат СоставДанных;

КонецФункции
	
#КонецОбласти

&НаСервереБезКонтекста
Функция ПроверитьИмяФизЛица(Имя, Пол)

	Возврат Справочники.ИменаЛюдей.ИмяКорректно(Имя, Пол);

КонецФункции

#Область ПоддержкаОбщегоФункционалаФормы

&НаКлиенте	//	LNK 12.08.2019 12:40:27
Процедура Подключаемый_ДоступностьWebRetail()

	РесурсWebRetailДоступен = РозничныеПродажиСлужебный.РесурсWebRetailДоступен();

	Если РесурсWebRetailДоступен Тогда

			Элементы.ИндикаторПодключения.Картинка = БиблиотекаКартинок.RFDIОперацииВыполнены;

	Иначе	Элементы.ИндикаторПодключения.Картинка = БиблиотекаКартинок.RFDIЗапись;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте	//	LNK 24.07.2019 09:48:08
Процедура УстановитьДоступностьЭлементовФормы()

	УказаныОбязательные = НЕ (ПустаяСтрока(Имя) ИЛИ Пол.Пустая());

	Элементы.ОтправитьКодПодтвержденияSMS.Доступность = НЕ ПодтверждениеОтправлено И УказаныОбязательные И НЕ ПустаяСтрока(НомерТелефона);
	Элементы.КодПодтверждения.ТолькоПросмотр          = НЕ ПодтверждениеОтправлено;

	Элементы.Пол.ТолькоПросмотр      = ПодтверждениеОтправлено;
	Элементы.Фамилия.ТолькоПросмотр  = ПодтверждениеОтправлено;
	Элементы.Имя.ТолькоПросмотр      = ПодтверждениеОтправлено;
	Элементы.Отчество.ТолькоПросмотр = ПодтверждениеОтправлено;

	Элементы.РегистрацияКлиента.Доступность = ПодтверждениеПолучено;
	Элементы.РегистрацияКлиента.ЦветФона = ?(ПодтверждениеПолучено, WebЦвета.БледноЗеленый, Новый Цвет);

	Элементы.ГруппаТелефонОтправкаSMS.Видимость = НЕ ПодтверждениеПолучено;

КонецПроцедуры

&НаСервере	//	LNK 23.07.2019 13:21:56
Функция ЭтотОбъект(ТекущийОбъект = Неопределено) 

	Если ТекущийОбъект = Неопределено Тогда

		Возврат РеквизитФормыВЗначение("Объект");

	КонецЕсли;

	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");

	Возврат Неопределено;

КонецФункции

&НаСервере	//	LNK 20.07.2021 18:35:21
Функция РеквизитИмяСсылка(ИмяСсылка)

	Возврат ЭтотОбъект().РеквизитИмяСсылка(ИмяСсылка);

КонецФункции

#КонецОбласти














