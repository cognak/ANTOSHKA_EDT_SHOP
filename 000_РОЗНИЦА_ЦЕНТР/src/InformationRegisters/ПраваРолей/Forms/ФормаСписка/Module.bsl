////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Чтение = Истина;
	
	ТолькоПросмотр = Истина;
	
	Список.Параметры.УстановитьЗначениеПараметра("ОбъектМетаданных", Параметры.ОбъектМетаданных);
	
	Если ЗначениеЗаполнено(Параметры.ОбъектМетаданных) Тогда
		
		Элементы.ОбъектМетаданных.Видимость = Ложь;
		Автозаголовок = Ложь;
		
		Заголовок = УправлениеДоступомСлужебный.ЗаголовокПодчиненнойФормы(
			НСтр("ru = 'Права ролей на объект метаданных: ""%1"" (%2)'"), Параметры.ОбъектМетаданных);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеРегистра(Команда)
	
	ЕстьИзменения = Ложь;
	
	ОбновитьДанныеРегистраНаСервере(ЕстьИзменения);
	
	Если ЕстьИзменения Тогда
		Текст = НСтр("ru = 'Обновление выполнено успешно.'");
	Иначе
		Текст = НСтр("ru = 'Обновление не требуется.'");
	КонецЕсли;
	
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьДанныеРегистраНаСервере(ЕстьИзменения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегистрыСведений.ПраваРолей.ОбновитьДанныеРегистра(ЕстьИзменения);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры
