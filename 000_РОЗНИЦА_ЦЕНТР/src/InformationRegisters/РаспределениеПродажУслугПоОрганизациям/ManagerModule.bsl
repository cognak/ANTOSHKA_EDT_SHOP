
///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура записывает данные в регистр
//
// Параметры
//	ТаблицаРегистра	- Таблица значений, структура = структура регистра
//
// Возвращаемое значение
//	Нет
//
Процедура ЗаписатьДанныеВРегистр(ТаблицаРегистра) Экспорт
	
	Если ТаблицаРегистра.Количество() > 0 Тогда
		
		Для Каждого СтрокаТаблицыРегистра ИЗ ТаблицаРегистра Цикл
			
				НаборЗаписей = РегистрыСведений.РаспределениеПродажУслугПоОрганизациям.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Магазин.Установить(СтрокаТаблицыРегистра.Магазин);
				НаборЗаписей.Отбор.НоменклатурнаяГруппа.Установить(СтрокаТаблицыРегистра.НоменклатурнаяГруппа);
				НаборЗаписей.Прочитать();
				НаборЗаписей.Очистить();
				
				Если НЕ СтрокаТаблицыРегистра.Очистить Тогда
					
					ЗаписьРегистра = НаборЗаписей.Добавить();
					ЗаполнитьЗначенияСвойств(ЗаписьРегистра, СтрокаТаблицыРегистра);
					
				КонецЕсли;
				
				НаборЗаписей.Записать(Истина);
				
		КонецЦикла;
		
	Иначе
		
		НаборЗаписей = РегистрыСведений.РаспределениеПродажУслугПоОрганизациям.СоздатьНаборЗаписей();
		НаборЗаписей.Прочитать();
		НаборЗаписей.Записать();
		
	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
