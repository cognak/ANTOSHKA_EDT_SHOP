
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьСклада();
КонецПроцедуры


&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Магазин               = Настройки.Получить("Магазин");
	Склад                 = Настройки.Получить("Склад");
	Организация           = Настройки.Получить("Организация");
	ОрганизацияПолучатель = Настройки.Получить("ОрганизацияПолучатель");
	
	УстановитьОтборДинамическогоСписка("Магазин");
	УстановитьОтборДинамическогоСписка("Склад");
	УстановитьОтборДинамическогоСписка("Организация");
	УстановитьОтборДинамическогоСписка("ОрганизацияПолучатель");

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОтборМагазинПриИзменении(Элемент)
	УстановитьОтборДинамическогоСписка("Магазин");
	УстановитьОтборДинамическогоСписка("Склад");
	УстановитьДоступностьСклада();
КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладПриИзменении(Элемент)
	УстановитьОтборДинамическогоСписка("Склад");
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	УстановитьОтборДинамическогоСписка("Организация");
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПолучательПриИзменении(Элемент)
	УстановитьОтборДинамическогоСписка("ОрганизацияПолучатель");
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьДоступностьСклада()

	Элементы.ОтборСклад.ТолькоПросмотр = НЕ ЗначениеЗаполнено(Магазин);

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическогоСписка(ИмяРеквизита)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Список, 
		ИмяРеквизита, 
		ЭтотОбъект[ИмяРеквизита], 
		ЗначениеЗаполнено(ЭтотОбъект[ИмяРеквизита]));
		
КонецПроцедуры




