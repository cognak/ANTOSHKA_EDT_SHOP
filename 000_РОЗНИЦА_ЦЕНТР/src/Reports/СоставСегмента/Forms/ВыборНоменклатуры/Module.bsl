
&НаКлиенте
Перем КэшированныеЗначения;

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьХарактеристикуНоменклатуры(ЭтотОбъект, Элемент, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Характеристика);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура", Номенклатура);
	СтруктураСтроки.Вставить("Характеристика", Характеристика);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	
	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(Неопределено, СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);

	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураСтроки);
	
	ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)

	Если Номенклатура.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru= 'Не указана номенклатура.'"),
		                                                  ,
		                                                  "Номенклатура");
		Возврат;
	КонецЕсли;
	
	Если ХарактеристикиИспользуются И Характеристика.Пустая() Тогда
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru= 'Не указана характеристика.'"),
		                                                  ,
		                                                  "Характеристика");
		Возврат;
	
	КонецЕсли;
	
	Закрыть(Новый Структура("Номенклатура, Характеристика", Номенклатура, Характеристика));

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
