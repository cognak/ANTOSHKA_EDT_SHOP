#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//	LNK 15.03.2017 12:08:56
Процедура ФиксироватьПроведениеТоварногоОрдера(ДокументОбъект)	Экспорт

	Перем Проведен, IDN;

	УстановитьПривилегированныйРежим(Истина);

	Если НЕ ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

	//	Работаем только в ЦБ
		Возврат;

	КонецЕсли;

	Если НЕ ПустаяСтрока(ДокументОбъект.IDN)
	И ДокументОбъект.ДополнительныеСвойства.Свойство("Проведен", Проведен) = Истина
	И ДокументОбъект.ДополнительныеСвойства.Свойство("IDN", IDN) = Истина  Тогда

	//	В структуре "ДополнительныеСвойства" ключи "Проведен" и "IDN" содержат значения, полученные
	//	по ссылке в обработчике "ПередЗаписью".

		Если НЕ ДокументОбъект.Проведен = Проведен ИЛИ НЕ ДокументОбъект.IDN = IDN Тогда

		//	Изменилось состояние документа! Нужно назначить его для создания задания
		//	в транспортной таблице Navision.

			ВнешниеИсточникиСобытия.УстановитьОбъектДляОбработки(ДокументОбъект.IDN, "ОРДЕР_ПРОВЕДЕН", ДокументОбъект.Ссылка);

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

//	LNK 05.04.2017 10:03:17
Функция ПолучитьИндекс(Период, Магазин)	Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаРегистра.Индекс) КАК Индекс
	|ИЗ
	|	РегистрСведений.ОбъектыДляОбработки КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Период = &Период
	|	И ТаблицаРегистра.Магазин = &Магазин"
	);
	Запрос.УстановитьПараметр("Период" , Период);
	Запрос.УстановитьПараметр("Магазин", Магазин);

	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() И НЕ Выборка.Индекс = NULL Тогда

			Индекс = Выборка.Индекс + 1;

	Иначе	Индекс = 0;

	КонецЕсли;

	Возврат Индекс;

КонецФункции // ПолучитьИндекс()

//	LNK 17.05.2018 12:51:48
Процедура РегламентнаяОчистка()	Экспорт

	Если НЕ ПривилегированныйРежим() Тогда

		УстановитьПривилегированныйРежим(Истина);

	КонецЕсли;

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаРегистра.Период КАК Период,
	|	ТаблицаРегистра.Магазин КАК Магазин,
	|	ТаблицаРегистра.Индекс КАК Индекс
	|ИЗ
	|	РегистрСведений.ОбъектыДляОбработки КАК ТаблицаРегистра
	|ГДЕ
	|	ВЫБОР
	|			КОГДА ТаблицаРегистра.ДействиеКоманда В (""WEB_ЗАКРЫТЬ_ЗАКАЗ_ПОКУПАТЕЛЯ"", ""ОРДЕР_ПРОВЕДЕН"")
	|						И ТаблицаРегистра.Период <= КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(&ТекущаяДата, ДЕНЬ, -1), ДЕНЬ)
	|					ИЛИ ТаблицаРегистра.Период <= КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(&ТекущаяДата, ДЕНЬ, -3), ДЕНЬ)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период"
	);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.ОбъектыДляОбработки.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения"  , Истина);
	НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов", Истина);
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;

	Пока Выборка.Следующий() Цикл

		НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
		НаборЗаписей.Отбор.Магазин.Установить(Выборка.Магазин);
		НаборЗаписей.Отбор.Индекс.Установить(Выборка.Индекс);

		НаборЗаписей.ОбменДанными.Получатели.Очистить();

		Если ЗначениеЗаполнено(Выборка.Магазин) Тогда

			ОбменДаннымиСервер.УстановитьПолучателейМагазина(НаборЗаписей.ОбменДанными.Получатели, НаборЗаписей.Отбор.Магазин.Значение, Ложь);

		Иначе

			ОбменДаннымиСервер.УстановитьВсехПолучателей(НаборЗаписей.ОбменДанными.Получатели, "ПоМагазину");
		
		КонецЕсли;

		НаборЗаписей.Записать();

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти
	
#КонецЕсли
