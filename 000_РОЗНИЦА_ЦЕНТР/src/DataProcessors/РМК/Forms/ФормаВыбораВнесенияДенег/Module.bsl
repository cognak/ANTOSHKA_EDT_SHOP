#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;

	Параметры.Свойство("ТекКассаККМ", ТекКассаККМ)
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ЗаполнитьСписокВыбора();

КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЗафиксироватьВыборСтроки();
	
КонецПроцедуры

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВниз(Команда)
	
	ПередвинутьПозицию(1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВверх(Команда)
	
	ПередвинутьПозицию(-1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ЗафиксироватьВыборСтроки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

// Передвинуть позицию в списке
//
// Параметры:
// Движение = 1 (вниз) или -1 (вверх)
// 
&НаКлиенте
Процедура ПередвинутьПозицию(Движение)
	// Вставить содержимое обработчика.
	Если Список.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено  Тогда
		ИндексСтроки = 0;
	Иначе
		ИндексСтроки = Список.Индекс(ТекущиеДанные);
	КонецЕсли;
	
	ИндексСтроки = ИндексСтроки + Движение;
	
	Если ИндексСтроки > (Список.Количество() - 1) Тогда
		ИндексСтроки = 0;
	ИначеЕсли ИндексСтроки < 0 Тогда
		ИндексСтроки = Список.Количество() - 1;
	КонецЕсли;
	
	ТекущиеДанные = Список[ИндексСтроки];
	Элементы.Список.ТекущаяСтрока = ТекущиеДанные.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьВыборСтроки()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Закрыть();
	Иначе
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Касса"                 , ТекущиеДанные.Касса);
		СтруктураСтроки.Вставить("РасходныйКассовыйОрдер", ТекущиеДанные.РасходныйКассовыйОрдер);
		СтруктураСтроки.Вставить("Сумма"                 , ТекущиеДанные.Сумма);
		Закрыть(СтруктураСтроки)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбора()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК РасходныйКассовыйОрдер,
	|	ТаблицаДокумента.Номер КАК Номер,
	|	ТаблицаДокумента.Дата КАК Дата,
	|	ТаблицаКПоступлению.Организация КАК Организация,
	|	ТаблицаКПоступлению.Касса КАК Касса,
	|	ТаблицаКПоступлению.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваКПоступлениюНаличные.Остатки(, Касса = &ТекКассаККМ) КАК ТаблицаКПоступлению
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйКассовыйОрдер КАК ТаблицаДокумента
	|		ПО ТаблицаКПоступлению.Документ = ТаблицаДокумента.Ссылка
	|ГДЕ
	|	ЕСТЬNULL(ТаблицаКПоступлению.СуммаОстаток, 0) > 0"
	);

	Запрос.УстановитьПараметр("ТекКассаККМ", ТекКассаККМ);

	Результат = Запрос.Выполнить();

	Список.Загрузить(Результат.Выгрузить());

КонецПроцедуры

#КонецОбласти




