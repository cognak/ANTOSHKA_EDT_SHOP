
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПереместитьЭлементВверх()
	
	ПереместитьЭлемент("Вверх");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз()
	
	ПереместитьЭлемент("Вниз");
	
КонецПроцедуры

&НаСервере
Процедура ПереместитьЭлемент(Направление)

	НастройкаПорядкаЭлементов.ПереместитьЭлемент(Список, Элементы.Список, Направление);

КонецПроцедуры

//Процедура - обработчик команды "ИзменитьВыделенные"
//
&НаКлиенте	//	LNK 24.10.2019 07:39:50
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
