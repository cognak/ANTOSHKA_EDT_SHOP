////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Отчет = Параметры.Отчет;
	ИдентификаторРегламентногоЗадания = Параметры.ИдентификаторРегламентногоЗадания;
	Заголовок = Параметры.Заголовок;
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("РегламентныеЗадания") Тогда
		ПодсистемаРегламентныеЗаданияСуществует = Истина;
		Элементы.ИзменитьРасписание.Видимость = Истина;
	Иначе
		Элементы.ИзменитьРасписание.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОтчетОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДатаНачала = Расшифровка.Получить(0);
	ДатаОкончания = Расшифровка.Получить(1);
	СеансРегламентногоЗадания.Очистить();
	СеансРегламентногоЗадания.Добавить(Расшифровка.Получить(2)); 
	ОтборЖурналаРегистрации = Новый Структура("Сеанс, ДатаНачала, ДатаОкончания", СеансРегламентногоЗадания, ДатаНачала, ДатаОкончания);
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ОтборЖурналаРегистрации);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗадания(Команда)
	
	Если ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
		
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ПолучитьРасписание());
		
		Если Диалог.ОткрытьМодально() Тогда
			УстановитьРасписание(Диалог.Расписание);
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Невозможно получить расписание регламентного задания: регламентное задание было удалено или не указано его наименование.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКЖурналуРегистрации(Команда)
	Для Каждого Область Из Отчет.ВыделенныеОбласти Цикл
		Расшифровка = Область.Расшифровка;
		Если Расшифровка = Неопределено
			ИЛИ Область.Верх <> Область.Низ Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Выберите строку или ячейку нужного сеанса задания'"));
			Возврат;
		КонецЕсли;
		ДатаНачала = Расшифровка.Получить(0);
		ДатаОкончания = Расшифровка.Получить(1);
		СеансРегламентногоЗадания.Очистить();
		СеансРегламентногоЗадания.Добавить(Расшифровка.Получить(2));
		ОтборЖурналаРегистрации = Новый Структура("Сеанс, ДатаНачала, ДатаОкончания", СеансРегламентногоЗадания, ДатаНачала, ДатаОкончания);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ОтборЖурналаРегистрации);
	КонецЦикла;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ПолучитьРасписание()
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульРегламентныеЗаданияСервер = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РегламентныеЗаданияСервер");
	Возврат МодульРегламентныеЗаданияСервер.ПолучитьРасписаниеРегламентногоЗадания(
		ИдентификаторРегламентногоЗадания);
	
КонецФункции

&НаСервере
Процедура УстановитьРасписание(Расписание)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульРегламентныеЗаданияСервер = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РегламентныеЗаданияСервер");	
	МодульРегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
		ИдентификаторРегламентногоЗадания,
		Расписание);
	
КонецПроцедуры

