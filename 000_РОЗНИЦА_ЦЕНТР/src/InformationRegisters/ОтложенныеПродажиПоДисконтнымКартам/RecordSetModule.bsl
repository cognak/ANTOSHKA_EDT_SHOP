//	LNK 06.08.2018 11:57:36
Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли;

	Для каждого ЗаписьНабора Из ЭтотОбъект Цикл

		ЗаписьНабора.ДатаИзменения = ТекущаяДата();

	КонецЦикла;

КонецПроцедуры
