//	LNK 29.03.2017 08:06:49
Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли;

//	\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\/

	Для каждого ЗаписьНабора Из ЭтотОбъект Цикл

		ЗаписьНабора.ДатаИзменения = ТекущаяДатаСеанса();

	КонецЦикла;

КонецПроцедуры
