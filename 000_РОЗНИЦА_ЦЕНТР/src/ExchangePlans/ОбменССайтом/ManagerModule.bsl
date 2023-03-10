
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		ВыбраннаяФорма = "ФормаУзла";
		ОбменССайтомВызовСервера.ПереопределитьФормуУзла(ВыбраннаяФорма);
		Если Не ВыбраннаяФорма = "ФормаУзла" Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//	LNK 08.06.2022 08:40:22
Функция ПрименитьОбъектПриКоллизииИзменений(УзелИнформационнойБазы, Объект)	Экспорт

	Возврат Истина;

КонецФункции

#Область ОбработчикиОбновлений

// Устанавливает значение реквизитов формы узла обмена
//
Процедура УстановитьЗначениеРеквизитовВыгрузки() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбменССайтом.Ссылка КАК УзелОбмена,
	|	ОбменССайтом.РежимВыгрузки КАК РежимВыгрузки
	|ИЗ
	|	ПланОбмена.ОбменССайтом КАК ОбменССайтом
	|ГДЕ
	|	НЕ ОбменССайтом.Ссылка = &ЭтотУзел";
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.ОбменССайтом.ЭтотУзел());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьПрикладныеПараметрыУзла(Выборка.УзелОбмена, Выборка.РежимВыгрузки);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет реквизит формы узла плана обмена СоответствиеСтатусовЗаказов
// данными табличной части "УдалитьСоответствиеСтатусовЗаказов"
//
Процедура ЗаполнитьРеквизитФормыСоответствиеСтатусовЗаказов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОбменССайтом.Ссылка КАК Узел
	|ИЗ
	|	ПланОбмена.ОбменССайтом.УдалитьСоответствиеСтатусовЗаказов КАК ОбменССайтом
	|ГДЕ
	|	НЕ ОбменССайтом.Ссылка = &ЭтотУзел";
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.ОбменССайтом.ЭтотУзел());

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		УзелОбъект = Выборка.Узел.ПолучитьОбъект();
		ПрикладныеПараметры = УзелОбъект.ПараметрыПрикладногоРешения.Получить();
		
		ПараметрыПрикладногоРешения = Неопределено;
		Если Не ПрикладныеПараметры.Свойство("ПараметрыПрикладногоРешения", ПараметрыПрикладногоРешения)
			Или ПараметрыПрикладногоРешения = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтатусыЗаказов = Неопределено;
		Если Не ПараметрыПрикладногоРешения.Свойство("СоответствиеСтатусовЗаказов", СтатусыЗаказов)
			Или СтатусыЗаказов = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтатусыЗаказов.Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтатусыЗаказов = Новый ТаблицаЗначений;
		СтатусыЗаказов.Колонки.Добавить("СтатусЗаказаВБазе");
		СтатусыЗаказов.Колонки.Добавить("СтатусЗаказаНаСайте");
		
		Для Каждого ТекСтрока Из Выборка.Узел.УдалитьСоответствиеСтатусовЗаказов Цикл
			
			НоваяСтрока = СтатусыЗаказов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			
		КонецЦикла;
		
		ПараметрыПрикладногоРешения.Вставить("СоответствиеСтатусовЗаказов", СтатусыЗаказов);
		
		ПрикладныеПараметры.Вставить("ПараметрыПрикладногоРешения", ПараметрыПрикладногоРешения);
		
		УзелОбъект.ПараметрыПрикладногоРешения = Новый ХранилищеЗначения(ПрикладныеПараметры);
		
		УзелОбъект.ОбменДанными.Загрузка = Истина;
		УзелОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет реквизит формы узла плана обмена ЕдиницаИзмеренияНовойНоменклатуры
//
Процедура ЗаполнитьРеквизитФормыЕдиницаИзмеренияНовойНоменклатуры() Экспорт
	
	ОбменССайтомВызовСервера.ПереопределитьОбработчикОбновления("ЗаполнитьРеквизитФормыЕдиницаИзмеренияНовойНоменклатуры");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПрикладныеПараметрыУзла(УзелОбмена, РежимВыгрузки)
	
	ВыгружатьТовары = Ложь;
	ВыгружатьЦеныОстатки = Ложь;
	
	Если РежимВыгрузки = 0 Тогда
		ВыгружатьТовары = Истина;
		ВыгружатьЦеныОстатки = Истина;
		
	ИначеЕсли РежимВыгрузки = 1 Тогда
		ВыгружатьТовары = Истина;
		ВыгружатьЦеныОстатки = Ложь;
		
	ИначеЕсли РежимВыгрузки = 2 Тогда
		ВыгружатьТовары = Ложь;
		ВыгружатьЦеныОстатки = Истина;
		
	ИначеЕсли РежимВыгрузки = 3 Тогда
		// Устанавливает флаг в значение Истина,
		// т.к. один из двух флагов должен быть на форме заполнен.
		ВыгружатьТовары = Истина;
		
	КонецЕсли;
	
	ОбновитьПараметры = Ложь;
	
	УзелОбъект = УзелОбмена.ПолучитьОбъект();
	СохраненныеНастройки = УзелОбъект.ПараметрыПрикладногоРешения.Получить();
	
	Если Не ТипЗнч(СохраненныеНастройки) = Тип("Структура") Тогда
		СохраненныеНастройки = Новый Структура;
		
		ОбновитьПараметры = Истина;
		
	КонецЕсли;
	
	ПараметрыПрикладногоРешения = Неопределено;
	Если Не СохраненныеНастройки.Свойство("ПараметрыПрикладногоРешения", ПараметрыПрикладногоРешения) Тогда
		ПараметрыПрикладногоРешения = Новый Структура;
		
		ОбновитьПараметры = Истина;
		
	КонецЕсли;
	
	Если Не ПараметрыПрикладногоРешения.Свойство("ВыгружатьТовары") Тогда
		ПараметрыПрикладногоРешения.Вставить("ВыгружатьТовары", ВыгружатьТовары);
		
		ОбновитьПараметры = Истина;
		
	КонецЕсли;
	
	Если Не ПараметрыПрикладногоРешения.Свойство("ВыгружатьЦеныОстатки") Тогда
		ПараметрыПрикладногоРешения.Вставить("ВыгружатьЦеныОстатки", ВыгружатьЦеныОстатки);
		
		ОбновитьПараметры = Истина;
		
	КонецЕсли;
	
	Если ОбновитьПараметры Тогда
		
		СохраненныеНастройки.Вставить("ПараметрыПрикладногоРешения", ПараметрыПрикладногоРешения);
		УзелОбъект.ПараметрыПрикладногоРешения = Новый ХранилищеЗначения(СохраненныеНастройки);
		
		УзелОбъект.Записать();
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
