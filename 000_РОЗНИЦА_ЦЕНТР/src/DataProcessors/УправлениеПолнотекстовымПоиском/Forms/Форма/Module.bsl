////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновитьСтатус();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОбновитьИндекс(Команда)
	Состояние(
		НСтр("ru = 'Идет обновление полнотекстового индекса...
		|Пожалуйста, подождите.'")
	);
	
	ОбновитьИндексСервер();
	
	Состояние(НСтр("ru = 'Обновление полнотекстового индекса завершено.'"));
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИндекс(Команда)
	Состояние(
		НСтр("ru = 'Идет очистка полнотекстового индекса...
		|Пожалуйста, подождите.'")
	);
	
	ОчиститьИндексСервер();
	
	Состояние(НСтр("ru = 'Очистка полнотекстового индекса завершена.'"));
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьИндексСервер()
	ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Ложь);
	ОбновитьСтатус();
КонецПроцедуры

&НаСервере
Процедура ОчиститьИндексСервер()
	ПолнотекстовыйПоиск.ОчиститьИндекс();
	ОбновитьСтатус();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатус()
	// Доступность кнопок, дата актуальности индекса.
	
	РазрешитьПолнотекстовыйПоиск = (ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить);
	Если РазрешитьПолнотекстовыйПоиск Тогда
		ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
		ИндексАктуален = ПолнотекстовыйПоискСервер.ИндексПоискаАктуален();
		Элементы.ФормаОбновитьИндекс.Доступность = НЕ ИндексАктуален;
		Если ИндексАктуален Тогда
			СтатусИндекса = НСтр("ru = 'Обновление не требуется'");
		Иначе
			СтатусИндекса = НСтр("ru = 'Требуется обновление'");
		КонецЕсли;
	Иначе
		ДатаАктуальностиИндекса = '00010101';
		ИндексАктуален = Ложь;
		Элементы.ФормаОбновитьИндекс.Доступность = Ложь;
		СтатусИндекса = НСтр("ru = 'Полнотекстовый поиск отключен'");
	КонецЕсли;
	
КонецПроцедуры
