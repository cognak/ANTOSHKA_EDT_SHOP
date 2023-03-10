////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("РежимВыбора", РежимВыбора);
	
	Если РежимВыбора И Параметры.Свойство("ПредставлениеВарианта") И ЗначениеЗаполнено(Параметры.ПредставлениеВарианта) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменение настроек отчета ""%1""'"),
			Параметры.ПредставлениеВарианта
		);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	Если РежимВыбора Тогда
		ОповеститьОВыборе(Отчет.КомпоновщикНастроек);
	Иначе
		Закрыть(Истина);
	КонецЕсли;
КонецПроцедуры
