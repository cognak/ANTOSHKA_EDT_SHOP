#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;

	Параметры.Свойство("Заголовок", Заголовок);
	Параметры.Свойство("ТекстСообщения", ТекстовоеСообщение);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)


КонецПроцедуры
	
#КонецОбласти