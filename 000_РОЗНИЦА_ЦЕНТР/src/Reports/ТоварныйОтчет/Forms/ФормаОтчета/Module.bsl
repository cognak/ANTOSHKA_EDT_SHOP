
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Отчет.ДатаНачала) И НЕ ЗначениеЗаполнено(Отчет.ДатаОкончания) Тогда
		
		ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
		
		Отчет.ДатаНачала    = НачалоГода(ТекущаяДата);
		Отчет.ДатаОкончания = ТекущаяДата;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ЗаполнитьЗначениямиПоУмолчанию(Настройки);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	УстановитьСостояниеОтчетНеСформирован();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьСостояниеОтчетНеСформирован();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	УстановитьСостояниеОтчетНеСформирован();
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	УстановитьСостояниеОтчетНеСформирован();
КонецПроцедуры

&НаКлиенте
Процедура НомерОтчетаПриИзменении(Элемент)
	УстановитьСостояниеОтчетНеСформирован();
КонецПроцедуры

&НаКлиенте
Процедура МагазинПриИзменении(Элемент)
	УстановитьСостояниеОтчетНеСформирован();
	Если ЗначениеЗаполнено(Отчет.Магазин) Тогда
		ПриИзмененииМагазина();		
	КонецЕсли;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	
	Диалог.Период.ДатаНачала    = Отчет.ДатаНачала;
	Диалог.Период.ДатаОкончания = Отчет.ДатаОкончания;
	
	Если Диалог.Редактировать() Тогда
		
		Отчет.ДатаНачала    = Диалог.Период.ДатаНачала;
		Отчет.ДатаОкончания = Диалог.Период.ДатаОкончания;
		
		УстановитьСостояниеОтчетНеСформирован();
		
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура заполняет поля отчета значениями по умолчанию если они не заполнены.
//
&НаСервере
Процедура ЗаполнитьЗначениямиПоУмолчанию(Настройки)
	
	Если НЕ ЗначениеЗаполнено(Настройки.Получить("Отчет.Организация")) Тогда
		
		Настройки.Удалить("Отчет.Организация");
		Отчет.Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Отчет.Организация);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Настройки.Получить("Отчет.Магазин")) Тогда
		
		Настройки.Удалить("Отчет.Магазин");
		Отчет.Магазин = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Отчет.Магазин);
		
	КонецЕсли;

	
	Если НЕ ЗначениеЗаполнено(Настройки.Получить("Отчет.Склад")) Тогда
		
		Настройки.Удалить("Отчет.Склад");
		Отчет.Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПродажиПоУмолчанию(Отчет.Магазин,,Отчет.Склад, Пользователи.ТекущийПользователь());
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает отображение состояния "Отчет не сформирован" при изменении полей отчета.
//
&НаКлиенте
Процедура УстановитьСостояниеОтчетНеСформирован()
	
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.Результат.ОтображениеСостояния.Текст = НСтр("ru = 'Отчет не сформирован. Нажмите ""Сформировать"" для получения отчета.'");
	Элементы.Результат.ОтображениеСостояния.Видимость = Истина;
	
КонецПроцедуры

//Процедура заполняет склад при изменении магазина
//
&НаСервере
Процедура ПриИзмененииМагазина()
	Отчет.Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоступленияПоУмолчанию(Отчет.Магазин,,Отчет.Склад, Пользователи.ТекущийПользователь());		
КонецПроцедуры
