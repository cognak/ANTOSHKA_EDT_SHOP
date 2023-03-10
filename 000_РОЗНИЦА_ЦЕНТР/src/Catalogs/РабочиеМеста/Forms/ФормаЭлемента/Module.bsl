
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест"
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();

	#Если Не ВебКлиент Тогда
	Объект.ИмяКомпьютера = ИмяКомпьютера();
	#КонецЕсли
	Объект.СетевойПорт   = МенеджерОборудованияКлиентСервер.ПолучитьСетевойПортПоУмолчанию();

	УстановитьДоступностьЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ПустаяСтрока(Объект.Код) Тогда

		СистемнаяИнформация = Новый СистемнаяИнформация();
		Объект.Код = ВРег(СистемнаяИнформация.ИдентификаторКлиента);

	КонецЕсли;
	
	МенеджерОборудованияКлиентСервер.ЗаполнитьНаименованиеРабочегоМеста(Объект, ТекущийПользователь);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	Место = ТекущийОбъект.Ссылка;

	СписокУстройств = МенеджерОборудованияСервер.ПолучитьСписокОборудования( , , Место);
	Для Каждого Элемент Из СписокУстройств Цикл
		Если Элемент.РабочееМесто = Место Тогда
			ЛокальноеОборудование.Добавить(Элемент.Ссылка,Элемент.Наименование, Ложь, ПолучитьКартинку(Элемент.ТипОборудования, 16));
		Иначе
			УдаленноеОборудование.Добавить(Элемент.Ссылка,Элемент.Наименование, Ложь, ПолучитьКартинку(Элемент.ТипОборудования, 16));
		КонецЕсли;
	КонецЦикла

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если Не ПроверкаУникальности()Тогда
		Ответ = Вопрос(НСтр("ru='Указано неуникальное наименование рабочего места!
		                    |Возможно в дальнейшем это затруднит идентификацию и выбор рабочего места.
		                    |Рекомендуется указывать уникальное наименование рабочих мест.
		                    |Продолжить сохранение с указанным наименованием?'"),
		               РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	СистемнаяИнформация = Новый СистемнаяИнформация();
	Если Объект.Код = ВРег(СистемнаяИнформация.ИдентификаторКлиента) Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	МенеджерОборудованияКлиентСервер.ЗаполнитьНаименованиеРабочегоМеста(Объект, ТекущийПользователь);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ПроверкаУникальности()

	Результат = Истина;

	Если Не ПустаяСтрока(Объект.Наименование) Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|    1
		|ИЗ
		|    Справочник.РабочиеМеста КАК РабочиеМеста
		|ГДЕ
		|    РабочиеМеста.Наименование = &Наименование
		|    И РабочиеМеста.Ссылка <> &Ссылка
		|");

		Запрос.УстановитьПараметр("Наименование", Объект.Наименование);
		Запрос.УстановитьПараметр("Ссылка"      , Объект.Ссылка);

		Результат = Запрос.Выполнить().Пустой();
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервере
Функция ПолучитьКартинку(ТипОборудования, Размер)

	Попытка // Может прийти пустая ссылка или неопределено, может не быть картинки
		МтОбъект = ТипОборудования.Метаданные();
		Индекс = Перечисления.ТипыПодключаемогоОборудования.Индекс(ТипОборудования);
		ИмяКартинки = МтОбъект.ЗначенияПеречисления[Индекс].Имя;
		ИмяКартинки = "ПодключаемоеОборудование" + ИмяКартинки + Размер;
		Картинка = БиблиотекаКартинок[ИмяКартинки]
	Исключение
		Картинка = Неопределено;
	КонецПопытки;

	Возврат Картинка;

КонецФункции

&НаСервере
Процедура УстановитьДоступностьЭлементов()

	Если ТехническаяПоддержкаВызовСервера.ИсключительныйРежим() Тогда

		Элементы.Код.ТолькоПросмотр = Ложь;
		Элементы.Код.Доступность    = Истина;
		Элементы.Код.РедактированиеТекста = Истина;

	КонецЕсли;

	Если ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

		Элементы.РабочееМестоНаПериферии.Видимость = Объект.Магазин.Пустая();
		Элементы.РабочееМестоНаПериферии.ТолькоПросмотр = НЕ ТехническаяПоддержкаВызовСервера.ИсключительныйРежим();

	Иначе

		Элементы.РабочееМестоНаПериферии.Видимость = Ложь;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РабочееМестоНаПериферииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)


КонецПроцедуры




