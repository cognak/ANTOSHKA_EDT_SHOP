
///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция возвращает список подключенного в справочнике ПО
//
Функция ПолучитьСписокОборудования(ТипыПО = Неопределено, Идентификатор = Неопределено, РабочееМесто = Неопределено) Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьСписокОборудования(ТипыПО, Идентификатор, РабочееМесто);

КонецФункции

// Возвращает структуру параметров конкретного экземпляра устройства
// При первом обращении получает из БД сохраненные ранее параметры.
Функция ПолучитьПараметрыУстройства(Идентификатор) Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьПараметрыУстройства(Идентификатор);

КонецФункции

// Функция возвращает структуру с данными устройства
//(со значениями реквизитов элемента справочника)
Функция ПолучитьДанныеУстройства(Идентификатор) Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьДанныеУстройства(Идентификатор);

КонецФункции

// Возвращает имя формы настройки обработчика драйвера
// При первом обращении возвращает сформированное на сервере имя
Функция ПолучитьИмяФормыНастройкиПараметров(НаименованиеОбработчикаДрайвера) Экспорт

	НаименованиеФормыНастройки = 
	    СтрЗаменить(МенеджерОборудованияСервер.ПолучитьИмяДрайвераЭкземпляра(НаименованиеОбработчикаДрайвера),
	                "Обработчик",
	                "ФормаНастройки");

	Возврат НаименованиеФормыНастройки;

КонецФункции

// Возвращает имя компьютера клиента
// При первом обращении получает имя компьютера из переменной сеанса
Функция ПолучитьРабочееМестоКлиента() Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьРабочееМестоКлиента();

КонецФункции

// Возвращает имя компьютера клиента
// При первом обращении получает имя компьютера из переменной сеанса
Функция НайтиРабочиеМестаПоИД(ИдентификаторКлиента) Экспорт

	Возврат МенеджерОборудованияСервер.НайтиРабочиеМестаПоИД(ИдентификаторКлиента);

КонецФункции

// Возвращает макет слип чека по наименованию макета
//
Функция ПолучитьСлипЧек(ИмяМакета, ШиринаСлипЧека, Параметры, АвторизацияПИН = Ложь) Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьСлипЧек(ИмяМакета, ШиринаСлипЧека, Параметры, АвторизацияПИН);

КонецФункции

// Функция возвращает имя перечисления из его метаданных
//
Функция ПолучитьИмяТипаОборудования(ТипОборудования) Экспорт

	Перем ИмяТипа;

	Если ТипЗнч(глТипыОборудования) = Тип("Соответствие") Тогда

		ИмяТипа = глТипыОборудования.Получить(ТипОборудования);

	КонецЕсли;

	Если ИмяТипа = Неопределено Тогда

		ИмяТипа = МенеджерОборудованияСервер.ПолучитьИмяТипаОборудования(ТипОборудования);

	КонецЕсли;

	Возврат ИмяТипа;

КонецФункции

// Функция возвращает пользовательские настройки подключаемого оборудования
//
Функция ПолучитьПользовательскиеНастройкиПодключаемогоОборудования() Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьПользовательскиеНастройкиПодключаемогоОборудования();

КонецФункции
