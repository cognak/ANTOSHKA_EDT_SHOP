#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Запись ключевых атребутов запроса доступности.
// 
// Параметры:
//  СтруктураЗаписи - Структура - Структура для изменения регистра:
//		* ЗапросДоступности - ДокументСсылка.ЗапросДоступностиТоваров
//		* СтатусЗапроса - ПеречислениеСсылка.СтатусыЗапросовДоступностиТоваровШапка
//		* ОтправкаПочты - Булево 
//		* ОправленоВNavision - ПеречислениеСсылка.СтатусыЗапросаДоступностиВNavision
Процедура ЗаписьКлючевыхАтребутовЗапросаДоступности(СтруктураЗаписи) Экспорт

	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Отбор.Период.Установить(ТекущаяДатаСеанса());
	НаборЗаписей.Отбор.ЗапросДоступности.Установить(СтруктураЗаписи.ЗапросДоступности);

	ЗаписьНабора = НаборЗаписей.Добавить();

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ТаблицаРегистра.Период КАК Период,
		|	ТаблицаРегистра.ЗапросДоступности КАК ЗапросДоступности,
		|	ТаблицаРегистра.СтатусЗапроса КАК СтатусЗапроса,
		|	ТаблицаРегистра.ОтправкаПочты КАК ОтправкаПочты,
		|	ТаблицаРегистра.ДатаИзменения КАК ДатаИзменения,
		|	ТаблицаРегистра.Примечание КАК Примечание,
		|	ТаблицаРегистра.ОправленоВNavision КАК ОправленоВNavision,
		|	ТаблицаРегистра.ХешЗапроса
		|ИЗ
		|	РегистрСведений.КлючевыеАтрибутыЗапросовДоступности.СрезПоследних(, ЗапросДоступности = &ЗапросДоступности) КАК
		|		ТаблицаРегистра";
	
	Запрос.УстановитьПараметр("ЗапросДоступности", СтруктураЗаписи.ЗапросДоступности);
	
	ТЗАтрибутов = Запрос.Выполнить().Выгрузить();
	
	Если ТЗАтрибутов.Количество() = 0 Тогда
		СтрокаАтрибутов = ТЗАтрибутов.Добавить();
		СтрокаАтрибутов.ЗапросДоступности = СтруктураЗаписи.ЗапросДоступности;
	Иначе
		СтрокаАтрибутов = ТЗАтрибутов[0];
	КонецЕсли;
	
	ЗаписатьРегистр = Ложь;

	Для Каждого КлючЗначение Из СтруктураЗаписи Цикл

		Если КлючЗначение.Значение = СтрокаАтрибутов[КлючЗначение.Ключ]
				Или КлючЗначение.Значение = Неопределено Тогда

			Продолжить;
			
		Иначе
			
			СтрокаАтрибутов[КлючЗначение.Ключ] = КлючЗначение.Значение;
			ЗаписатьРегистр = Истина;

		КонецЕсли;
	
	КонецЦикла;
	
	Если ЗаписатьРегистр Тогда
		
		ЗаполнитьЗначенияСвойств(ЗаписьНабора, СтрокаАтрибутов);
		ЗаписьНабора.Период			 = НаборЗаписей.Отбор.Период.Значение;
		ЗаписьНабора.ЗапросДоступности = НаборЗаписей.Отбор.ЗапросДоступности.Значение;
		ЗаписьНабора.ДатаИзменения = ТекущаяДатаСеанса();

		НаборЗаписей.Записать();
		
	КонецЕсли;

КонецПроцедуры

// Инициализация структуры записи регистра.
// 
// Параметры:
//  ЗапросДоступности - ДокументСсылка.ЗапросДоступностиТоваров
// 
// Возвращаемое значение:
// 	Структура - структура регистр для записи:
//		* ЗапросДоступности - ДокументСсылка.ЗапросДоступностиТоваров
//		* СтатусЗапроса - ПеречислениеСсылка.СтатусыЗапросовДоступностиТоваровШапка
//		* ОтправкаПочты - Булево 
//		* ОправленоВNavision - ПеречислениеСсылка.СтатусыЗапросаДоступностиВNavision
//		* ХешЗапроса - Строка
//  
Функция ИнициализацияСтруктурыЗаписиРегистра(ЗапросДоступности) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ЗапросДоступности",		ЗапросДоступности);
	Результат.Вставить("СтатусЗапроса",			Неопределено);
	Результат.Вставить("ОтправкаПочты",			Неопределено);
	Результат.Вставить("ОправленоВNavision",	Неопределено);
	Результат.Вставить("ХешЗапроса",	Неопределено);

	Возврат Результат;
	
КонецФункции

// Получение статуса записи в Navision.
// 
// Параметры:
//  ЗапросДоступности - ДокументСсылка.ЗапросДоступностиТоваров
// 
// Возвращаемое значение:
// 	ПеречислениеСсылка.СтатусыЗапросаДоступностиВNavision
//  
Функция ПолучитьСтатусЗаписиВNavision(ЗапросДоступности) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КлючевыеАтрибутыЗапросовДоступностиСрезПоследних.ОправленоВNavision
		|ИЗ
		|	РегистрСведений.КлючевыеАтрибутыЗапросовДоступности.СрезПоследних(, ЗапросДоступности = &ЗД) КАК
		|		КлючевыеАтрибутыЗапросовДоступностиСрезПоследних";
	
	Запрос.УстановитьПараметр("ЗД", ЗапросДоступности);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Результат = Выборка.ОправленоВNavision;
		
	Иначе
		
		Результат = Перечисления.СтатусыЗапросаДоступностиВNavision.ПустаяСсылка();
		
	КонецЕсли; 

	Возврат Результат;
	
КонецФункции

// Проверка и запись хеша.
// 
// Параметры:
//  ЗапросДоступности - ДокументОбъект.ЗапросДоступностиТоваров
//  ТекстЗапроса - Строка - Текст запроса
// 
// Возвращаемое значение:
//  Булево - Истина если хеш совпадает, Ложь - хеш не совпадает и записывается в регистр
Функция ПроверкаИЗаписьХеша(ЗапросДоступности, ТекстЗапроса) Экспорт
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA256);
	ХешированиеДанных.Добавить(ТекстЗапроса);
	СтрокаХеша = СокрЛП(Base64Строка(ХешированиеДанных.ХешСумма));

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаАтрибвтов.ХешЗапроса
		|ИЗ
		|	РегистрСведений.КлючевыеАтрибутыЗапросовДоступности.СрезПоследних(, ЗапросДоступности = &ЗД) КАК ТаблицаАтрибвтов";
	
	Запрос.УстановитьПараметр("ЗД", ЗапросДоступности.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтарыйХеш = СокрЛП(Выборка.ХешЗапроса);
	Иначе
		СтарыйХеш = "";
	КонецЕсли;
	
	Если СтрокаХеша = СтарыйХеш Тогда
		Результат = Истина;
	Иначе
		Результат = Ложь;
		СтруктураЗаписи = ИнициализацияСтруктурыЗаписиРегистра(ЗапросДоступности.Ссылка);
		СтруктураЗаписи.ХешЗапроса = СтрокаХеша;
		ЗаписьКлючевыхАтребутовЗапросаДоступности(СтруктураЗаписи);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти
	
#КонецЕсли
