////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВариантГруппировки = "ПоПолучателю";
	
	УстановитьГруппировкуСписка();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВариантГруппировкиПриИзменении(Элемент)
	
	УстановитьГруппировкуСписка();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОтправитьИПолучитьСообщения(Команда)
	
	ОбменСообщениямиКлиент.ОтправитьИПолучитьСообщения();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Настройка(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкаОбменаСообщениями",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Если Элементы.Список.ТекущиеДанные.Свойство("ГруппировкаСтроки")
			И ТипЗнч(Элементы.Список.ТекущиеДанные.ГруппировкаСтроки) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Действие недоступно для строки группировки списка.'"));
			
		Иначе
			
			Если Элементы.Список.ВыделенныеСтроки.Количество() > 1 Тогда
				
				СтрокаВопроса = НСтр("ru = 'Удалить выделенные сообщения?'");
				
			Иначе
				
				СтрокаВопроса = НСтр("ru = 'Удалить сообщение ""[Сообщение]""?'");
				СтрокаВопроса = СтрЗаменить(СтрокаВопроса, "[Сообщение]", Элементы.Список.ТекущиеДанные.Наименование);
				
			КонецЕсли;
			
			Ответ = Вопрос(СтрокаВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
			
			Если Ответ = КодВозвратаДиалога.Да Тогда
				
				УдалитьСообщениеНепосредственно(Элементы.Список.ВыделенныеСтроки);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьГруппировкуСписка()
	
	Если ВариантГруппировки = "БезГруппировки" Тогда
		
		Список.Группировка.Элементы[0].Использование = Ложь;
		Список.Группировка.Элементы[1].Использование = Ложь;
		
		Элементы.Отправитель.Видимость = Истина;
		Элементы.Получатель.Видимость = Истина;
		
	Иначе
		
		Использование = (ВариантГруппировки = "ПоПолучателю");
		
		Список.Группировка.Элементы[0].Использование = Использование;
		Список.Группировка.Элементы[1].Использование = Не Использование;
		
		Элементы.Отправитель.Видимость = Использование;
		Элементы.Получатель.Видимость = Не Использование;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСообщениеНепосредственно(Знач Сообщения)
	
	Для Каждого Сообщение Из Сообщения Цикл
		
		Если ТипЗнч(Сообщение) <> Тип("СправочникСсылка.СообщенияОбластейДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектСообщения = Сообщение.ПолучитьОбъект();
		
		Если ОбъектСообщения <> Неопределено Тогда
			
			ОбъектСообщения.Заблокировать();
			
			Если ЗначениеЗаполнено(ОбъектСообщения.Отправитель)
				И ОбъектСообщения.Отправитель <> ОбменСообщениямиВнутренний.ЭтотУзел() Тогда
				
				ОбъектСообщения.ОбменДанными.Получатели.Добавить(ОбъектСообщения.Отправитель);
				ОбъектСообщения.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
				
			КонецЕсли;
			
			ОбъектСообщения.ОбменДанными.Загрузка = Истина; // Наличие ссылок на справочник не должно препятствовать или замедлять удаление элементов справочника.
			ОбъектСообщения.Удалить();
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

