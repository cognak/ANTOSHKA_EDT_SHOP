//	LNK 01.12.2016 16:22:24
Процедура ПередЗаписью(Отказ, Замещение)

	УстановитьТипОбъектаСтрокой();

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли;

КонецПроцедуры

//	LNK 14.03.2019 12:14:44
Процедура УстановитьТипОбъектаСтрокой()

	Для каждого ЗаписьНабора Из ЭтотОбъект Цикл

		Если ПустаяСтрока(ЗаписьНабора.ТипОбъектаСтрокой) И НЕ ЗаписьНабора.Объект = Неопределено Тогда

			Попытка
				
				ЗаписьНабора.ТипОбъектаСтрокой = ЗаписьНабора.Объект.Метаданные().ПолноеИмя();

			Исключение

				ТекстОшибки = ОписаниеОшибки();

			КонецПопытки;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры





