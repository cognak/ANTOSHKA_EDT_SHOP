
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "Контрагент" И НЕ Элемент.ТекущиеДанные = Неопределено Тогда

		СтандартнаяОбработка = Ложь;

		ПараметрыОткрытия = Новый Структура("Ключ", Элемент.ТекущиеДанные.Контрагент);
		ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект, ЭтотОбъект);

	КонецЕсли;

КонецПроцедуры
