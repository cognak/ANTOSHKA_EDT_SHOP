#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Осуществляет формирование новой СКД
//
// Возвращаемое значение:
//	СхемаКомпоновкиДанных
//
Функция СформироватьНовуюСхемуКомпоновкиДанных(ЭлементСсылка) Экспорт
	
	Если ЭлементСсылка = Справочники.ПравилаОтбораТоваров.ИнвентаризацияЗапрещенныхКПродаже Тогда
		Возврат Справочники.ПравилаОтбораТоваров.ПолучитьМакет("ИнвентаризацияЗапрещенныхКПродаже");
	Иначе
		Возврат Справочники.ПравилаОтбораТоваров.ПолучитьМакет("ПолнаяИнвентаризация");
	КонецЕсли;

КонецФункции

// Возвращает структуру с синонимом и схемой компоновки
// данных по имени макета
//
// Параметры:
//	Ссылка - СправочникСсылка.ПравилаОтбораТоваров - ссылка на вид цены
//	ИмяМакета - Строка - имя макета, из которого необходимо получить описание и схему
//
// Возвращаемое значение:
//	Структура - описание и схема компоновки данных
//
Функция ОписаниеИСхемаКомпоновкиДанныхПоИмениМакета(Ссылка, ИмяМакета = Неопределено) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Описание",                  "");
	ВозвращаемоеЗначение.Вставить("СхемаКомпоновкиДанных",     Неопределено);
	ВозвращаемоеЗначение.Вставить("НастройкиКомпоновкиДанных", Неопределено);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПравилаОтбораТоваров.ХранилищеСхемыКомпоновкиДанных КАК ХранилищеСхемыКомпоновкиДанных,
	|	ПравилаОтбораТоваров.ХранилищеНастроекКомпоновкиДанных КАК ХранилищеНастроекКомпоновкиДанных
	|ИЗ
	|	Справочник.ПравилаОтбораТоваров КАК ПравилаОтбораТоваров
	|ГДЕ
	|	ПравилаОтбораТоваров.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Не ЗначениеЗаполнено(ИмяМакета) Тогда
		
		ВозвращаемоеЗначение.Описание = ИмяМакета;
		Если Выборка.Следующий() Тогда
			
			СхемаКомпоновкиДанных = Выборка.ХранилищеСхемыКомпоновкиДанных.Получить();
			Если СхемаКомпоновкиДанных = Неопределено Тогда
				ВозвращаемоеЗначение.СхемаКомпоновкиДанных = СформироватьНовуюСхемуКомпоновкиДанных(Ссылка);
				ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Неопределено;
			Иначе
				ВозвращаемоеЗначение.СхемаКомпоновкиДанных = СхемаКомпоновкиДанных;
				ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		МетаданныеМакет = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Макеты.Найти(ИмяМакета);
		Если МетаданныеМакет <> Неопределено Тогда
			ВозвращаемоеЗначение.Описание = МетаданныеМакет.Синоним;
			ВозвращаемоеЗначение.СхемаКомпоновкиДанных = Справочники.ПравилаОтбораТоваров.ПолучитьМакет(ИмяМакета);
			Если Выборка.Следующий() Тогда
				ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
			КонецЕсли;
		Иначе
			ВозвращаемоеЗначение.Описание = ИмяМакета;
			Если Выборка.Следующий() Тогда
				
				СхемаКомпоновкиДанных = Выборка.ХранилищеСхемыКомпоновкиДанных.Получить();
				Если СхемаКомпоновкиДанных = Неопределено Тогда
					ВозвращаемоеЗначение.СхемаКомпоновкиДанных = СформироватьНовуюСхемуКомпоновкиДанных(Ссылка);
					ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Неопределено;
				Иначе
					ВозвращаемоеЗначение.СхемаКомпоновкиДанных = СхемаКомпоновкиДанных;
					ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Возвращает результат проверки возможности использования макета в зависисмости от функциональных опций
Функция ПроверитьЗависимостьОтФункциональныхОпций(ИмяМакета) Экспорт

	Если ИмяМакета = "ПоПопыткамПродажПревышающихОстатокПредопределенный" 
		И НЕ ПолучитьФункциональнуюОпцию("ФиксироватьПопыткиПродажПревышающихОстаток") Тогда
		Возврат Ложь;
	ИначеЕсли ИмяМакета = "ТоварнаяКатегорияПредопределенный" 
		И НЕ АссортиментВызовСервера.ПолучитьФункциональнуюОпциюИспользованияАссортимента() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции // ПроверитьЗависимостьОтФункциональныхОпций()

#КонецЕсли
