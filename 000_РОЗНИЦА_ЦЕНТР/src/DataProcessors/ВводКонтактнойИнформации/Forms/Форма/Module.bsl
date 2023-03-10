////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТипИнформации = Параметры.ВидКонтактнойИнформации.Тип;
	ИмяФормыВидаКонтактнойИнформации = КонтактнаяИнформацияКлиентСерверПовтИсп.ИмяФормыВводаКонтактнойИнформации(
		ТипИнформации
	);
	
	Если ИмяФормыВидаКонтактнойИнформации=Неопределено Тогда
		Ошибка = НСтр("ru='Вид информации : ""%1""' нельзя открыть в диалоге");
		ВызватьИсключение СтрЗаменить(Ошибка, "%1", ТипИнформации);
	КонецЕсли;
	
	// Транслируем параметры
	ПараметрыОткрываемойФормы = Новый Структура;
	ПараметрыОткрываемойФормы.Вставить("ВидКонтактнойИнформации", Параметры.ВидКонтактнойИнформации);
	ПараметрыОткрываемойФормы.Вставить("Заголовок",               Параметры.Заголовок);
	ПараметрыОткрываемойФормы.Вставить("ЗначенияПолей",           Параметры.ЗначенияПолей);
	ПараметрыОткрываемойФормы.Вставить("Представление",           Параметры.Представление);
	
	ПараметрыОткрываемойФормы.Вставить("ЗакрыватьПриВыборе", ЗакрыватьПриВыборе);
	ПараметрыОткрываемойФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", ЗакрыватьПриЗакрытииВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отказ = Истина;
	//Если МодальныйРежим Тогда
	//	Закрыть( ОткрытьФормуМодально(ИмяОткрываемойФормы, ПараметрыОткрываемойФормы, ВладелецФормы) );
	//Иначе
		ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыОткрываемойФормы, ВладелецФормы, ,Окно);
	//КонецЕсли;
КонецПроцедуры

