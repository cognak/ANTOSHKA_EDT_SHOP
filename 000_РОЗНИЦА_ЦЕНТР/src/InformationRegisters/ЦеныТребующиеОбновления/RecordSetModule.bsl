Процедура ПередЗаписью(Отказ, Замещение)	//	LNK 01.03.2021 17:03:06

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли;

	Для каждого ЗаписьНабора Из ЭтотОбъект Цикл

		ЗаписьНабора.ДатаИзменения = ТекущаяДата();

	КонецЦикла;

КонецПроцедуры
