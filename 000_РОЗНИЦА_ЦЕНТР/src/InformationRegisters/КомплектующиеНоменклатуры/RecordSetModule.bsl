
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для каждого ЗаписьРегистра Из ЭтотОбъект Цикл
		
		Если (ЗаписьРегистра.Комплектующая = ЗаписьРегистра.Номенклатура)
			И ЗначениеЗаполнено(ЗаписьРегистра.Номенклатура) Тогда
			
			
			ТекстОшибки = НСтр("ru = 'Номенклатура не может совпадать с комплектующей'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,,Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
