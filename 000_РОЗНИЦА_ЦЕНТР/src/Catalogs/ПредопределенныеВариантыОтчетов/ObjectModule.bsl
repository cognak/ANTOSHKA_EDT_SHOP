#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") Тогда
		ВызватьИсключение НСтр("ru = 'Справочник ""Предопределенные варианты отчетов"" изменяется только при автоматическом заполнении его данных.'");
	КонецЕсли;
КонецПроцедуры

#КонецЕсли