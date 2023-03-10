// Процедура пересчитывает сумму в шапке документа, если она отличается от сумм в табличной части.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий документ
//
Процедура ПересчетСуммыДокументаПоРасшифровкеПлатежа(Объект) Экспорт
	
	Если Объект.РасшифровкаПлатежа.Количество() > 0
	   И Объект.СуммаДокумента <> Объект.РасшифровкаПлатежа.Итог("Сумма")
	Тогда
		
		ТекстВопроса = НСтр("ru = 'Сумма по строкам в табличной части не равна сумме документа, пересчитать сумму документа?'");
		
		КодОтвета = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если КодОтвета = КодВозвратаДиалога.Да Тогда
			Объект.СуммаДокумента = Объект.РасшифровкаПлатежа.Итог("Сумма");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПересчетСуммыДокументаПоРасшифровкеПлатежа()

// Процедура пересчитывает сумму в строке табличной части "Расшифровка платежа" при изменении суммы в шапке документа.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий документ
//	СуммаДокумента - Число - Сумма документа
//
Процедура ПересчетСуммыВСтрокеРасшифровкиПлатежа(Объект, СуммаДокумента) Экспорт
	
	Если Объект.РасшифровкаПлатежа.Количество() = 1 Тогда
		
		СтрокаТаблицы = Объект.РасшифровкаПлатежа[0];
		СтрокаТаблицы.Сумма = СуммаДокумента;
		
	КонецЕсли;
	
КонецПроцедуры // ПересчетСуммыВСтрокеРасшифровкиПлатежа()

// Функция проверяет возможность печати чека на фискальном регистраторе.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма документа
//
// Возвращаемое значение:
//	Булево - Признак возможности печати
//
Функция ПроверитьВозможностьПечатиЧека(Форма) Экспорт
	
	ПечататьЧек = Истина;
	
	// Если объект не проведен или модифицирован - выполним проведение.
	Если НЕ Форма.Объект.Проведен
		ИЛИ Форма.Модифицированность Тогда
		
		КодОтвета = Вопрос(НСтр("ru = 'Операция возможна только после проведения документа, провести документ?'"), РежимДиалогаВопрос.ДаНет);
		Если КодОтвета = КодВозвратаДиалога.Да Тогда
			
			Попытка
				Если НЕ Форма.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение)) Тогда
					ПечататьЧек = Ложь;
				КонецЕсли;
			Исключение
				ПоказатьПредупреждение(, НСтр("ru = 'Не удалось выполнить проведение документа'"));
				ПечататьЧек = Ложь;
			КонецПопытки;
			
		Иначе
			ПечататьЧек = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПечататьЧек;

КонецФункции // ПроверитьВозможностьПечатиЧека()