&НаКлиенте	//	LNK 26.02.2019 13:47:09
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле = Элементы.Контрагент И НЕ Элемент.ТекущиеДанные = Неопределено Тогда

		ОткрытьЗначение(Элемент.ТекущиеДанные.Контрагент);
		СтандартнаяОбработка = Ложь;

	КонецЕсли;

КонецПроцедуры
