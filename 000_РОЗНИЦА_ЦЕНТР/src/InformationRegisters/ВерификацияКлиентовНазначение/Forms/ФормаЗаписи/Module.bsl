&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьОтборДинамическихСписков();

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	УстановитьОтборДинамическихСписков();

КонецПроцедуры

&НаСервере	//	LNK 08.02.2019 15:22:07
Процедура УстановитьОтборДинамическихСписков()

	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		ИнформационныеКарты, 
		"ВладелецКарты", 
		Запись.Контрагент, 
		ЗначениеЗаполнено(Запись.Контрагент));

КонецПроцедуры
