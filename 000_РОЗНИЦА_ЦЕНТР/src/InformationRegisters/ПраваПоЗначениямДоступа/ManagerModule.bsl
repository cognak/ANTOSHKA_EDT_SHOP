#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обновляет возможные права по значениям доступа и сохраняет состав последних изменений.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если изменения найдены,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьВозможныеПраваПоЗначенияДоступа(ЕстьИзменения = Неопределено, ТолькоПроверка = Ложь) Экспорт
	
	ВозможныеПрава = ВозможныеПрава();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыОграниченияДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Параметры = ОбновлениеИнформационнойБазы.ПараметрыРаботыПрограммы(
			"ПараметрыОграниченияДоступа");
		
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("ВозможныеПраваПоЗначениямДоступа") Тогда
			Сохраненные = Параметры.ВозможныеПраваПоЗначениямДоступа;
			
			Если НЕ ОбщегоНазначения.ДанныеСовпадают(ВозможныеПрава, Сохраненные) Тогда
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			Если ТолькоПроверка Тогда
				ЗафиксироватьТранзакцию();
				Возврат;
			КонецЕсли;
			ОбновлениеИнформационнойБазы.УстановитьПараметрРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"ВозможныеПраваПоЗначениямДоступа",
				ВозможныеПрава);
		КонецЕсли;
		
		Если НЕ ТолькоПроверка Тогда
			ОбновлениеИнформационнойБазы.ДобавитьИзмененияПараметраРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"ВозможныеПраваПоЗначениямДоступа",
				?(Сохраненные = Неопределено,
				  Новый ФиксированнаяСтруктура("ЕстьИзменения", Истина),
				  Новый ФиксированнаяСтруктура()) );
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбновитьВозможныеПраваПоЗначенияДоступа_ТИПОВАЯ(ЕстьИзменения = Неопределено, ТолькоПроверка = Ложь) Экспорт
	
	Если ТолькоПроверка ИЛИ МонопольныйРежим() Тогда
		СнятьМонопольныйРежим = Ложь;
	Иначе
		СнятьМонопольныйРежим = Истина;
		УстановитьМонопольныйРежим(Истина);
	КонецЕсли;
	
	ВозможныеПрава = ВозможныеПрава();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыОграниченияДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Параметры = ОбновлениеИнформационнойБазы.ПараметрыРаботыПрограммы(
			"ПараметрыОграниченияДоступа");
		
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("ВозможныеПраваПоЗначениямДоступа") Тогда
			Сохраненные = Параметры.ВозможныеПраваПоЗначениямДоступа;
			
			Если НЕ ОбщегоНазначения.ДанныеСовпадают(ВозможныеПрава, Сохраненные) Тогда
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			Если ТолькоПроверка Тогда
				ЗафиксироватьТранзакцию();
				Возврат;
			КонецЕсли;
			ОбновлениеИнформационнойБазы.УстановитьПараметрРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"ВозможныеПраваПоЗначениямДоступа",
				ВозможныеПрава);
		КонецЕсли;
		
		Если НЕ ТолькоПроверка Тогда
			ОбновлениеИнформационнойБазы.ДобавитьИзмененияПараметраРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"ВозможныеПраваПоЗначениямДоступа",
				?(Сохраненные = Неопределено,
				  Новый ФиксированнаяСтруктура("ЕстьИзменения", Истина),
				  Новый ФиксированнаяСтруктура()) );
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Если СнятьМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	Если СнятьМонопольныйРежим Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обновляет вспомогательные данные регистра по результату изменения
// возможных прав по значениям доступа, сохраненных в параметрах ограничения доступа.
//
Процедура ОбновитьВспомогательныеДанныеРегистраПоИзменениямКонфигурации() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = УправлениеДоступомСлужебныйПовтИсп.Параметры();
	
	ПоследниеИзменения = ОбновлениеИнформационнойБазы.ИзмененияПараметраРаботыПрограммы(
		Параметры, "ВозможныеПраваПоЗначениямДоступа");
		
	ТребуетсяОбновление = Ложь;
	Для каждого ЧастьИзменений Из ПоследниеИзменения Цикл
		
		Если ТипЗнч(ЧастьИзменений) = Тип("ФиксированнаяСтруктура")
		   И ЧастьИзменений.Свойство("ЕстьИзменения")
		   И ТипЗнч(ЧастьИзменений.ЕстьИзменения) = Тип("Булево") Тогда
			
			Если ЧастьИзменений.ЕстьИзменения Тогда
				ТребуетсяОбновление = Истина;
				Прервать;
			КонецЕсли;
		Иначе
			ТребуетсяОбновление = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ТребуетсяОбновление Тогда
		ОбновитьВспомогательныеДанныеРегистра();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура обновляет вспомогательные данные регистра при изменении конфигурации.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьВспомогательныеДанныеРегистра(ЕстьИзменения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВозможныеПрава = УправлениеДоступомСлужебныйПовтИсп.Параметры().ВозможныеПраваПоЗначениямДоступа;
	
	ТаблицыПрав = Новый ТаблицаЗначений;
	ТаблицыПрав.Колонки.Добавить("ВладелецПрав", Метаданные.РегистрыСведений.ПраваПоЗначениямДоступа.Измерения.ЗначениеДоступа.Тип);
	ТаблицыПрав.Колонки.Добавить("Право",        Метаданные.РегистрыСведений.ПраваПоЗначениямДоступа.Измерения.Право.Тип);
	ТаблицыПрав.Колонки.Добавить("Таблица",      Метаданные.РегистрыСведений.ПраваПоЗначениямДоступа.Измерения.Таблица.Тип);
	ТаблицыПрав.Колонки.Добавить("Чтение",       Новый ОписаниеТипов("Булево"));
	ТаблицыПрав.Колонки.Добавить("Добавление",   Новый ОписаниеТипов("Булево"));
	ТаблицыПрав.Колонки.Добавить("Изменение",    Новый ОписаниеТипов("Булево"));
	ТаблицыПрав.Колонки.Добавить("Удаление",     Новый ОписаниеТипов("Булево"));
	
	Для каждого КлючИЗначение Из ВозможныеПрава.ПоТипамСсылок Цикл
		ТипВладельцаПрав = КлючИЗначение.Ключ;
		ОписаниеПрав     = КлючИЗначение.Значение;
		
		Если ТаблицыПрав.Колонки.ВладелецПрав.ТипЗначения.СодержитТип(ТипВладельцаПрав) Тогда
			Для каждого КлючИЗначение Из ОписаниеПрав Цикл
				Право         = КлючИЗначение.Ключ;
				ОписаниеПрава = КлючИЗначение.Значение;
				
				Для каждого Таблица Из ОписаниеПрава.ЧтениеВТаблицах Цикл
					НоваяТаблица = ТаблицыПрав.Добавить();
					НоваяТаблица.ВладелецПрав = ОписаниеПрава.ПустаяСсылкаТипаВладельцаПрав;
					НоваяТаблица.Право        = Право;
					НоваяТаблица.Таблица      = Таблица;
					НоваяТаблица.Чтение       = Истина;
				КонецЦикла;
				Для каждого Таблица Из ОписаниеПрава.ДобавлениеВТаблицах Цикл
					НоваяТаблица = ТаблицыПрав.Добавить();
					НоваяТаблица.ВладелецПрав = ОписаниеПрава.ПустаяСсылкаТипаВладельцаПрав;
					НоваяТаблица.Право        = Право;
					НоваяТаблица.Таблица      = Таблица;
					НоваяТаблица.Добавление   = Истина;
				КонецЦикла;
				Для каждого Таблица Из ОписаниеПрава.ИзменениеВТаблицах Цикл
					НоваяТаблица = ТаблицыПрав.Добавить();
					НоваяТаблица.ВладелецПрав = ОписаниеПрава.ПустаяСсылкаТипаВладельцаПрав;
					НоваяТаблица.Право        = Право;
					НоваяТаблица.Таблица      = Таблица;
					НоваяТаблица.Изменение    = Истина;
				КонецЦикла;
				Для каждого Таблица Из ОписаниеПрава.УдалениеВТаблицах Цикл
					НоваяТаблица = ТаблицыПрав.Добавить();
					НоваяТаблица.ВладелецПрав = ОписаниеПрава.ПустаяСсылкаТипаВладельцаПрав;
					НоваяТаблица.Право        = Право;
					НоваяТаблица.Таблица      = Таблица;
					НоваяТаблица.Удаление     = Истина;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ТекстЗапросовВременныхТаблиц =
	"ВЫБРАТЬ
	|	ТаблицыПрав.ВладелецПрав,
	|	ТаблицыПрав.Право,
	|	ТаблицыПрав.Таблица,
	|	ТаблицыПрав.Чтение,
	|	ТаблицыПрав.Добавление,
	|	ТаблицыПрав.Изменение,
	|	ТаблицыПрав.Удаление
	|ПОМЕСТИТЬ ТаблицыПрав
	|ИЗ
	|	&ТаблицыПрав КАК ТаблицыПрав
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПраваПоЗначениямДоступа.ЗначениеДоступа КАК ЗначениеДоступа,
	|	ПраваПоЗначениямДоступа.Пользователь КАК Пользователь,
	|	ПраваПоЗначениямДоступа.Право КАК Право,
	|	МАКСИМУМ(ПраваПоЗначениямДоступа.Запрещено) КАК Запрещено,
	|	МАКСИМУМ(ПраваПоЗначениямДоступа.РаспространяетсяВИерархии) КАК РаспространяетсяВИерархии
	|ПОМЕСТИТЬ ПраваПоЗначениям
	|ИЗ
	|	РегистрСведений.ПраваПоЗначениямДоступа КАК ПраваПоЗначениямДоступа
	|
	|СГРУППИРОВАТЬ ПО
	|	ПраваПоЗначениямДоступа.ЗначениеДоступа,
	|	ПраваПоЗначениямДоступа.Пользователь,
	|	ПраваПоЗначениямДоступа.Право
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПраваПоЗначениям.ЗначениеДоступа КАК ЗначениеДоступа,
	|	ПраваПоЗначениям.Пользователь КАК Пользователь,
	|	ПраваПоЗначениям.Право КАК Право,
	|	ЕСТЬNULL(ТаблицыПрав.Таблица, ЗНАЧЕНИЕ(Справочник.ИдентификаторыОбъектовМетаданных.ПустаяСсылка)) КАК Таблица,
	|	ПраваПоЗначениям.Запрещено КАК Запрещено,
	|	ПраваПоЗначениям.РаспространяетсяВИерархии КАК РаспространяетсяВИерархии,
	|	ВЫБОР
	|		КОГДА ПраваПоЗначениям.Запрещено
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ЕСТЬNULL(ТаблицыПрав.Чтение, ЛОЖЬ)
	|	КОНЕЦ КАК Чтение,
	|	ВЫБОР
	|		КОГДА ПраваПоЗначениям.Запрещено
	|			ТОГДА ЕСТЬNULL(ТаблицыПрав.Чтение, ЛОЖЬ)
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЧтениеЗапрещено,
	|	ВЫБОР
	|		КОГДА ПраваПоЗначениям.Запрещено
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ЕСТЬNULL(ТаблицыПрав.Добавление, ЛОЖЬ)
	|	КОНЕЦ КАК Добавление,
	|	ВЫБОР
	|		КОГДА ПраваПоЗначениям.Запрещено
	|			ТОГДА ЕСТЬNULL(ТаблицыПрав.Добавление, ЛОЖЬ)
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ДобавлениеЗапрещено,
	|	ВЫБОР
	|		КОГДА ПраваПоЗначениям.Запрещено
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ЕСТЬNULL(ТаблицыПрав.Изменение, ЛОЖЬ)
	|	КОНЕЦ КАК Изменение,
	|	ВЫБОР
	|		КОГДА ПраваПоЗначениям.Запрещено
	|			ТОГДА ЕСТЬNULL(ТаблицыПрав.Изменение, ЛОЖЬ)
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИзменениеЗапрещено,
	|	ВЫБОР
	|		КОГДА ПраваПоЗначениям.Запрещено
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ЕСТЬNULL(ТаблицыПрав.Удаление, ЛОЖЬ)
	|	КОНЕЦ КАК Удаление,
	|	ВЫБОР
	|		КОГДА ПраваПоЗначениям.Запрещено
	|			ТОГДА ЕСТЬNULL(ТаблицыПрав.Удаление, ЛОЖЬ)
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК УдалениеЗапрещено
	|ПОМЕСТИТЬ НовыеДанные
	|ИЗ
	|	ПраваПоЗначениям КАК ПраваПоЗначениям
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицыПрав КАК ТаблицыПрав
	|		ПО (ТИПЗНАЧЕНИЯ(ПраваПоЗначениям.ЗначениеДоступа) = ТИПЗНАЧЕНИЯ(ТаблицыПрав.ВладелецПрав))
	|			И ПраваПоЗначениям.Право = ТаблицыПрав.Право
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТаблицыПрав
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПраваПоЗначениям";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НовыеДанные.ЗначениеДоступа,
	|	НовыеДанные.Пользователь,
	|	НовыеДанные.Право,
	|	НовыеДанные.Таблица,
	|	НовыеДанные.Запрещено,
	|	НовыеДанные.РаспространяетсяВИерархии,
	|	НовыеДанные.Чтение,
	|	НовыеДанные.ЧтениеЗапрещено,
	|	НовыеДанные.Добавление,
	|	НовыеДанные.ДобавлениеЗапрещено,
	|	НовыеДанные.Изменение,
	|	НовыеДанные.ИзменениеЗапрещено,
	|	НовыеДанные.Удаление,
	|	НовыеДанные.УдалениеЗапрещено,
	|	&ПодстановкаПоляВидИзмененияСтроки
	|ИЗ
	|	НовыеДанные КАК НовыеДанные";
	
	// Подготовка выбираемых полей с необязательным отбором.
	Поля = Новый Массив;
	Поля.Добавить(Новый Структура("ЗначениеДоступа"));
	Поля.Добавить(Новый Структура("Пользователь"));
	Поля.Добавить(Новый Структура("Право"));
	Поля.Добавить(Новый Структура("Таблица"));
	Поля.Добавить(Новый Структура("Запрещено"));
	Поля.Добавить(Новый Структура("РаспространяетсяВИерархии"));
	Поля.Добавить(Новый Структура("Чтение"));
	Поля.Добавить(Новый Структура("ЧтениеЗапрещено"));
	Поля.Добавить(Новый Структура("Добавление"));
	Поля.Добавить(Новый Структура("ДобавлениеЗапрещено"));
	Поля.Добавить(Новый Структура("Изменение"));
	Поля.Добавить(Новый Структура("ИзменениеЗапрещено"));
	Поля.Добавить(Новый Структура("Удаление"));
	Поля.Добавить(Новый Структура("УдалениеЗапрещено"));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицыПрав", ТаблицыПрав);
	
	Запрос.Текст = УправлениеДоступомСлужебный.ТекстЗапросаВыбораИзменений(
		ТекстЗапроса, Поля, "РегистрСведений.ПраваПоЗначениямДоступа", ТекстЗапросовВременныхТаблиц);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПраваПоЗначениямДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Изменения = Запрос.Выполнить().Выгрузить();
		
		УправлениеДоступомСлужебный.ОбновитьРегистрСведений(
			РегистрыСведений.ПраваПоЗначениямДоступа, Изменения, ЕстьИзменения);
			
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

// Возвращает таблицу описаний возможных прав значений доступа,
// созданную с использованием процедуры, подготовленной прикладным разработчиком:
// УправлениеДоступомПереопределяемый.ЗаполнитьВозможныеПраваПоЗначениямДоступа().
//
// Описание возможных прав - это описание связей:
// <владелец прав> - <право> - <таблица прав> - <ограничиваемые права таблицы>,
// где
//   владелец прав - это таблица, по элементам которой записываются назначенные права,
//           например, Справочник.ПапкиФайлов;
//   право - это набор из ограничиваемых, интерактивных, дополнительных прав,
//           например, ДобавлениеИзменениеПапокИФайлов, ЭлектроннаяПодписьФайлов;
//   таблица прав - это таблица, для которой предназначены ограничиваемые права,
//           например Справочник.ПапкиФайлов, Справочник.Файлы;
//   ограничиваемые права - это права чтение, добавление, изменение, удаление к объектам метаданных.
//
//  <Таблиц прав> и <ограничиваемых прав> может не быть, например, в случае дополнительных прав ПометкаУдаления.
// Эти связи требуются при заполнения данных для стандартных шаблонов ограничения доступа.
// 
// Возвращаемое значение:
//  ТаблицаЗначений
//   ВладелецПрав - Строка - полное имя таблицы значения доступа,
//   Имя         - Строка - идентификатор права, например, ЧтениеПапокИФайлов,
//                 право с имененем "УправлениеПравами" должно быть обязательно определено для общей формы настройки прав
//                 "Права доступа", "Управление правами" - это право на изменение прав по владельцу прав,
//                 которое проверяется при открытии РегистрСведений.ПраваПоЗначениямДоступа.Форма.ПраваПоЗначениямДоступа;
//   Синоним     - Строка - полное наименование права, например, "Чтение папок и файлов";
//   Сокращение  - Строка - краткое наименование права среди прав одного владельца, например "Чтение";
//   Заголовок   - Строка - заголовок права в форме "Права по значениям доступа", например "Чт";
//   НачальноеЗначение - Булево - начальное значение флажка права при добавлении новой строки в форме "Права по значениям доступа";
//   ТребуемыеПрава - Массив строк - имена прав, требуемых для от этого права,
//                 например, право "ДобавлениеПапокИФайлов" требует право "ЧтениеПапокИФайлов" и
//                 право "ИзменениеПапокИФайлов"
//   ТребуемаяРоль - Массив строк - содержащий роли, хотя бы одна из которых, обязательна для работы права,
//                 используется в функции УправлениеДоступом.ЕстьПраво();
//   ЧтениеВТаблицах - Массив строк - полные имена таблиц, для которых устанавливается право чтения
//                 (требуется для работы шаблонов ограничения доступа);
//   ДобавлениеВТаблицах - Массив строк - полные имена таблиц, для которых устанавливается право добавления
//                 (требуется для работы шаблонов ограничения доступа);
//   ИзменениеВТаблицах - Массив строк - полные имена таблиц, для которых устанавливается право изменения
//                 (требуется для работы шаблонов ограничения доступа);
//   УдалениеВТаблицах - Массив строк - полные имена таблиц, для которых устанавливается право удаления
//                 (требуется для работы шаблонов ограничения доступа);
//
Функция ВозможныеПрава()
	
	ВозможныеПрава = Новый ТаблицаЗначений();
	ВозможныеПрава.Колонки.Добавить("ВладелецПрав",        Новый ОписаниеТипов("Строка"));
	ВозможныеПрава.Колонки.Добавить("Имя",                 Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(60)));
	ВозможныеПрава.Колонки.Добавить("Синоним",             Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150)));
	ВозможныеПрава.Колонки.Добавить("Сокращение",          Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150)));
	ВозможныеПрава.Колонки.Добавить("Заголовок",           Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(40)));
	ВозможныеПрава.Колонки.Добавить("НачальноеЗначение",   Новый ОписаниеТипов("Булево"));
	ВозможныеПрава.Колонки.Добавить("ТребуемыеПрава",      Новый ОписаниеТипов("Массив"));
	ВозможныеПрава.Колонки.Добавить("ТребуемаяРоль",       Новый ОписаниеТипов("Массив"));
	ВозможныеПрава.Колонки.Добавить("ЧтениеВТаблицах",     Новый ОписаниеТипов("Массив"));
	ВозможныеПрава.Колонки.Добавить("ДобавлениеВТаблицах", Новый ОписаниеТипов("Массив"));
	ВозможныеПрава.Колонки.Добавить("ИзменениеВТаблицах",  Новый ОписаниеТипов("Массив"));
	ВозможныеПрава.Колонки.Добавить("УдалениеВТаблицах",   Новый ОписаниеТипов("Массив"));
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.УправлениеДоступом\ПриЗаполненииВозможныхПравПоЗначениямДоступа");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриЗаполненииВозможныхПравПоЗначениямДоступа(ВозможныеПрава);
	КонецЦикла;
	
	УправлениеДоступомПереопределяемый.ЗаполнитьВозможныеПраваПоЗначениямДоступа(ВозможныеПрава);
	
	ЗаголовокОшибки =
		НСтр("ru = 'Ошибка в процедуре ЗаполнитьВозможныеПраваПоЗначениямДоступа
		           |общего модуля УправлениеДоступомПереопределяемый.
		           |
		           |'");
	
	ПоТипам        = Новый Соответствие;
	ПоТипамСсылок  = Новый Соответствие;
	ПоПолнымИменам = Новый Соответствие;
	
	ТипыИзмеренияЗначениеДоступаРегистраПрав =
		УправлениеДоступомСлужебныйПовтИсп.ТипыПоляТаблицы(
			"РегистрСведений.ПраваПоЗначениямДоступа", "Измерения", "ЗначениеДоступа");
	
	ТипыИзмеренияЗначениеДоступаРегистраГрупп =
		УправлениеДоступомСлужебныйПовтИсп.ТипыПоляТаблицы(
			"РегистрСведений.ГруппыЗначенийДоступа", "Измерения", "ЗначениеДоступа");
	
	ТипыПодпискиОбновитьГруппыЗначенийДоступа =
		УправлениеДоступомСлужебныйПовтИсп.ТипыОбъектовВПодпискахНаСобытия(
			"ОбновитьГруппыЗначенийДоступа");
	
	СвойстваВидовДоступа = ОбновлениеИнформационнойБазы.ПараметрыРаботыПрограммы(
		"ПараметрыОграниченияДоступа").СвойстваВидовДоступа;
	
	Для каждого ВозможноеПраво Из ВозможныеПрава Цикл
		ОбъектМетаданныхВладельца = Метаданные.НайтиПоПолномуИмени(ВозможноеПраво.ВладелецПрав);
		
		Если ОбъектМетаданныхВладельца = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ЗаголовокОшибки + НСтр("ru = 'Не найден владельц прав ""%1"".'"),
				ВозможноеПраво.ВладелецПрав);
		КонецЕсли;
		
		ЗаполнитьИдентификаторы("ТребуемаяРоль", ВозможноеПраво, ЗаголовокОшибки,
			НСтр("ru = 'Не найдена требуемая роль ""%1"".'"), Истина);
		
		ЗаполнитьИдентификаторы("ЧтениеВТаблицах", ВозможноеПраво, ЗаголовокОшибки,
			НСтр("ru = 'Не найдена таблица для чтения ""%1"".'"));
		
		ЗаполнитьИдентификаторы("ДобавлениеВТаблицах", ВозможноеПраво, ЗаголовокОшибки,
			НСтр("ru = 'Не найдена таблица для добавления ""%1"".'"));
		
		ЗаполнитьИдентификаторы("ИзменениеВТаблицах", ВозможноеПраво, ЗаголовокОшибки,
			НСтр("ru = 'Не найдена таблица для изменения ""%1"".'"));
		
		ЗаполнитьИдентификаторы("УдалениеВТаблицах", ВозможноеПраво, ЗаголовокОшибки,
			НСтр("ru = 'Не найдена таблица для удаления ""%1"".'"));
		
		ПраваВладельца = ПоПолнымИменам[ВозможноеПраво.ВладелецПрав];
		Если ПраваВладельца = Неопределено Тогда
			ИндексПрава = 0;
			ПраваВладельца = Новый Соответствие;
			
			ТипСсылки = СтандартныеПодсистемыСервер.ТипСсылкиИлиКлючаЗаписиОбъектаМетаданных(
				ОбъектМетаданныхВладельца);
			
			ТипОбъекта = СтандартныеПодсистемыСервер.ТипОбъектаИлиНабораЗаписейОбъектаМетаданных(
				ОбъектМетаданныхВладельца);
			
			ПоПолнымИменам.Вставить(ВозможноеПраво.ВладелецПрав, ПраваВладельца);
			ПоТипамСсылок.Вставить(ТипСсылки,  ПраваВладельца);
			ПоТипам.Вставить(ТипСсылки,  ПраваВладельца);
			ПоТипам.Вставить(ТипОбъекта, ПраваВладельца);
			
			// Проверка наличия типа ссылки в измерениях используемых регистров.
			
			Если ТипыИзмеренияЗначениеДоступаРегистраПрав.Получить(ТипСсылки) = Неопределено Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ЗаголовокОшибки +
					НСтр("ru = 'Тип владельца прав ""%1""
					           |не указан в измерении ""Значение доступа""
					           |регистра сведений ""Права по значениям доступа"".'"),
					Строка(ТипСсылки));
			КонецЕсли;
			
			Если ТипыИзмеренияЗначениеДоступаРегистраГрупп.Получить(ТипСсылки) = Неопределено Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ЗаголовокОшибки +
					НСтр("ru = 'Тип владельца прав ""%1""
					           |не указан в измерении ""Значение доступа""
					           |регистра сведений ""Группы значений доступа"".'"),
					Строка(ТипСсылки));
			КонецЕсли;
			
			Если ТипыПодпискиОбновитьГруппыЗначенийДоступа.Получить(ТипОбъекта) = Неопределено Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ЗаголовокОшибки +
					НСтр("ru = 'Тип владельца прав ""%1""
					           |не указан в подписке на событие ""Обновить группы значений доступа"".'"),
					Строка(ТипОбъекта));
			КонецЕсли;
			
			// Проверка наличия вида доступа для владельца прав.
			ВидыДоступа = СвойстваВидовДоступа.ВидыДоступаЗначенийДоступа.ПоТипам.Получить(ТипСсылки);
			
			Если ВидыДоступа = Неопределено 
			 ИЛИ ВидыДоступа.Количество() = 0 Тогда
				
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ЗаголовокОшибки +
					НСтр("ru = 'Для типа владельцев прав по значениям доступа
					           |""%1"" не настроено
					           |ни одного вида доступа в процедуре ЗаполнитьСвойстваВидаДоступа
					           |общего модуля УправлениеДоступомПереопределяемый.'"),
					Строка(ТипСсылки));
			КонецЕсли;
			
			Если ВидыДоступа.Количество() > 1 Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ЗаголовокОшибки +
					НСтр("ru = 'Для типа владельцев прав по значениям доступа
					           |""%1"" настроено
					           |более одного вида доступа в процедуре ЗаполнитьСвойстваВидаДоступа
					           |общего модуля УправлениеДоступомПереопределяемый.'"),
					Строка(ТипСсылки));
			КонецЕсли;
			
			СвойстваВидаДоступа = СвойстваВидовДоступа.ПоСсылкам.Получить(ВидыДоступа.Получить(0));
			
			Если НЕ СвойстваВидаДоступа.ВидДоступаЧерезПраваПоЗначениямДоступа Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ЗаголовокОшибки +
					НСтр("ru = 'Для типа владельцев прав по значениям доступа
					           |""%1"" настроен
					           |вид доступа без свойства ВидДоступаЧерезПраваПоЗначениямДоступа
					           |в процедуре ЗаполнитьСвойстваВидаДоступа
					           |общего модуля УправлениеДоступомПереопределяемый.'"),
					Строка(ТипСсылки));
			КонецЕсли;
		КонецЕсли;
		
		СвойстваВозможногоПрава = Новый Структура(
			"ВладелецПрав,
			|Имя,
			|Синоним,
			|Сокращение,
			|Заголовок,
			|НачальноеЗначение,
			|ТребуемыеПрава,
			|ТребуемаяРоль,
			|ЧтениеВТаблицах,
			|ДобавлениеВТаблицах,
			|ИзменениеВТаблицах,
			|УдалениеВТаблицах,
			|ИндексПрава,
			|ПустаяСсылкаТипаВладельцаПрав");
		ЗаполнитьЗначенияСвойств(СвойстваВозможногоПрава, ВозможноеПраво);
		
		СвойстваВозможногоПрава.ИндексПрава = ИндексПрава;
		ИндексПрава = ИндексПрава + 1;
		
		СвойстваВозможногоПрава.ПустаяСсылкаТипаВладельцаПрав =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				ВозможноеПраво.ВладелецПрав).ПустаяСсылка();
		
		ПраваВладельца.Вставить(ВозможноеПраво.Имя, СвойстваВозможногоПрава);
	КонецЦикла;
	
	ВозможныеПрава = Новый Структура;
	ВозможныеПрава.Вставить("ПоТипам",        ПоТипам);
	ВозможныеПрава.Вставить("ПоТипамСсылок",  ПоТипамСсылок);
	ВозможныеПрава.Вставить("ПоПолнымИменам", ПоПолнымИменам);
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ВозможныеПрава);
	
КонецФункции

Процедура ЗаполнитьИдентификаторы(Свойство, ВозможноеПраво, ЗаголовокОшибки, ОписаниеОшибки, ЭтоРоли = Ложь)
	
	Массив = Новый Массив;
	
	Для каждого Значение Из ВозможноеПраво[Свойство] Цикл
		
		Если ЭтоРоли Тогда
			Значение = "Роль." + Значение;
		КонецЕсли;
		
		Если Метаданные.НайтиПоПолномуИмени(Значение) = Неопределено Тогда
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ЗаголовокОшибки + ОписаниеОшибки,
				Значение);
		Иначе
			Массив.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Значение));
		КонецЕсли;
		
	КонецЦикла;
	
	ВозможноеПраво[Свойство] = Массив;
	
КонецПроцедуры

#КонецЕсли