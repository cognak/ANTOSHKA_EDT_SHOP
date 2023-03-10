///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоСимволовПослеЗапятой = 0;
	ПервыйВвод = Истина;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	// + HVOYA 08.12.2016 13:14:46, Латышев А.А.
	Если Параметры.Свойство("НоменклатураСкидочногоКупона") Тогда
		НоменклатураСкидочногоКупона    = Параметры.НоменклатураСкидочногоКупона;
	КонецЕсли;
	// - HVOYA 08.12.2016 13:14:46, Латышев А.А. 
КонецПроцедуры

&НаКлиенте
Процедура КомандаOK(Команда)
	
	Если ЗначениеЗаполнено(СтрокаНомера) Тогда
		Результат = ПроверитьСоответствиеШтрихкода(СтрокаНомера);
		Если Результат Тогда
			Закрыть(СтрокаНомера);
		Иначе
			ПоказатьПредупреждение(, "Не вірний купон знижок, спробуйте інший купон!",10);
			СтрокаНомера = "";
			Возврат;
		КонецЕсли; 
	Иначе
		ПоказатьПредупреждение(, "Купон на знижку НЕ ЗНАЙДЕНИЙ",1);
	КонецЕсли;
	
КонецПроцедуры
  
&НаСервере
Функция ПроверитьСоответствиеШтрихкода(СтрокаНомера)
	Результат = Ложь;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Штрихкоды.Владелец КАК Справочник.Номенклатура) КАК Номенклатура,
	|	Штрихкоды.Упаковка КАК Упаковка,
	|	Штрихкоды.Характеристика КАК Характеристика
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК Штрихкоды
	|ГДЕ
	|	Штрихкоды.Штрихкод = &Штрихкод
	|	И Штрихкоды.Владелец ССЫЛКА Справочник.Номенклатура");
	Запрос.УстановитьПараметр("Штрихкод", СтрокаНомера);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Номенклатура = НоменклатураСкидочногоКупона Тогда
			Результат = Истина;
		КонецЕсли; 
	КонецЦикла;
	
	Если Не Результат Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ 
		|	Штрихкоды.Владелец КАК СерийныйНомер
		|ИЗ
		|	РегистрСведений.Штрихкоды КАК Штрихкоды
		|ГДЕ
		|	Штрихкоды.Штрихкод = &Штрихкод
		|	И Штрихкоды.Владелец ССЫЛКА Справочник.СерийныеНомера");
		Запрос.УстановитьПараметр("Штрихкод", СтрокаНомера);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.СерийныйНомер.Владелец = НоменклатураСкидочногоКупона Тогда
				Результат = Истина;
			КонецЕсли; 
		КонецЦикла;;
	КонецЕсли; 
	
	возврат Результат;
КонецФункции // ПроверитьСоответствиеШтрихкода(СтрокаНомера)()
 
// - HVOYA 08.12.2016 13:19:57, Латышев А.А. 



