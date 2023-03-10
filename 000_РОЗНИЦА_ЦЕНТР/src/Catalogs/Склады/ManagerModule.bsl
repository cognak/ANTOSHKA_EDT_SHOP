#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Получает склад, если склад один в справочнике
// Параметры:
// Магазин - СправочникСсылка.Магазины
// ТипСклада - ПеречислениеСсылка.ТипыСкладов
//
// Возвращаемое значение:
// СправочникСсылка.Склады - Найденный склад
// Неопределено - если складов нет или больше одного
//
Функция ПолучитьСкладПоУмолчанию(Магазин, ТипСклада) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Склады.Ссылка КАК Склад
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	(НЕ Склады.ПометкаУдаления)
	|	И (Склады.Магазин = &Магазин
	|			ИЛИ &Магазин = НЕОПРЕДЕЛЕНО)
	|	И (Склады.ТипСклада = &ТипСклада
	|			ИЛИ &ТипСклада = НЕОПРЕДЕЛЕНО)");
	
	Запрос.УстановитьПараметр("Магазин", ?(ЗначениеЗаполнено(Магазин), Магазин, Неопределено));
	Запрос.УстановитьПараметр("ТипСклада", ?(ЗначениеЗаполнено(ТипСклада), ТипСклада, Неопределено));
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Склад = Выборка.Склад;
	Иначе
		Склад = Справочники.Склады.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Склад;

КонецФункции

// Получает склад поступления по умолчанию
// Параметры:
// Магазин - СправочникСсылка.Магазины
// ТипСклада - ПеречислениеСсылка.ТипыСкладов
//
// Возвращаемое значение:
// СправочникСсылка.Склады - Найденный склад
// Неопределено - если склад не найден
//
Функция ПолучитьСкладПоступленияПоУмолчанию(Магазин, ТипСклада) Экспорт
	
	Возврат ПолучитьСкладПоУмолчанию(Магазин, ТипСклада);

КонецФункции

// Получает склад поступления по умолчанию
// Параметры:
// Магазин - СправочникСсылка.Магазины
// ТипСклада - ПеречислениеСсылка.ТипыСкладов
//
// Возвращаемое значение:
// СправочникСсылка.Склады - Найденный склад
// Неопределено - если склад не найден
//
Функция ПолучитьСкладПродажиПоУмолчанию(Магазин, ТипСклада) Экспорт
	
	Возврат ПолучитьСкладПоУмолчанию(Магазин, ТипСклада);

КонецФункции

// Проверяет принадлежность склада магазину
// Параметры:
// Магазин - СправочникСсылка.Магазины
// Склад - СправочникСсылка.Склады
// Возвращаемое значение:
// Результат проверки - Булево
Функция ПроверитьПринадлежностьСкладаМагазину(Магазин, Склад) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Склады.Ссылка
	|ИЗ
	|	Справочник.Склады КАК Склады
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Магазины КАК Магазины
	|		ПО Склады.Магазин = Магазины.Ссылка
	|ГДЕ
	|	Склады.Магазин = &Магазин
	|	И Склады.Ссылка = &Склад
	|	И (НЕ Магазины.СкладУправляющейСистемы)");
	Запрос.УстановитьПараметр("Магазин", Магазин);
	Запрос.УстановитьПараметр("Склад", Склад);
	РезультатЗапроса = Запрос.Выполнить();
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Возвращаемое значение:
//	Массив - блокируемые реквизиты объекта
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("Организация");
	Результат.Добавить("Магазин");
	Результат.Добавить("ТипСклада");
		
	Возврат Результат;

КонецФункции

#Область ОбработчикиСобытийМенеджераОбъекта

//	LNK 08.11.2017 15:43:40
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)

	а = 22;

КонецПроцедуры

#КонецОбласти

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#КонецЕсли
