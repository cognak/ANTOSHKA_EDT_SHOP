
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ЗарегистрироватьИзмененияДляПравилаОбмена(Ссылка);
	
КонецПроцедуры
