//	LNK 17.07.2017 09:46:17
Процедура ПередЗаписью(Отказ)

	Если НЕ ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

	//	Эта константа передаётся только "сверху вниз"
		ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов", Истина);

	КонецЕсли;

КонецПроцедуры

//	LNK 17.07.2017 12:33:41
Процедура ПриЗаписи(Отказ)


КонецПроцедуры
