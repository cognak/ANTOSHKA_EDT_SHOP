Процедура ПередЗаписью(Отказ, Замещение)	//	LNK 11.10.2022 09:54:39

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли;

	Для каждого ЗаписьНабора Из ЭтотОбъект Цикл

		ЗаписьНабора.ДатаИзменения = ТекущаяДата();

	КонецЦикла;

КонецПроцедуры
