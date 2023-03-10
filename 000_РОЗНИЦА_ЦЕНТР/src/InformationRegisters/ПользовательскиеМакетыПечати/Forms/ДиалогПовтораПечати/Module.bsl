////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КаталогДляСохраненияДанныхПечати = УправлениеПечатью.ПолучитьЛокальныйКаталогФайловПечати();
	Элементы.Сообщение.Заголовок = Элементы.Сообщение.Заголовок + Символы.ПС + Параметры.СообщениеОбОшибке;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ИзменитьРабочийКаталогПечати(Команда)
	
	Результат = ОткрытьФормуМодально("РегистрСведений.ПользовательскиеМакетыПечати.Форма.НастройкаКаталогаФайловПечати");
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		КаталогДляСохраненияДанныхПечати = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПовторитьПечать(Команда)
	Закрыть(КаталогДляСохраненияДанныхПечати);
КонецПроцедуры
