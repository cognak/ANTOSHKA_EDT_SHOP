
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗначениеПараметраКомпоновкиДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ЗначениеПараметраКомпоновкиДанных <> Неопределено
		И КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЗначениеПараметраКомпоновкиДанных.ИдентификаторПользовательскойНастройки) <> Неопределено
	Тогда
		ПользовательскаяНастройкаПериод = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЗначениеПараметраКомпоновкиДанных.ИдентификаторПользовательскойНастройки);
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
		Если ПользовательскаяНастройкаПериод.Значение.ДатаНачала > КонецДня(ТекущаяДатаСеанса) Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Некорректно указан период. %1 Дата начала периода не должна быть больше текущей даты (%2)'"),
				Символы.ПС,
				Формат(ТекущаяДатаСеанса, "ДФ = дд.ММ.гггг")
				);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"КомпоновщикНастроек.ПользовательскиеНастройки",
				,
				Отказ
			);
		КонецЕсли;
		Если ПользовательскаяНастройкаПериод.Значение.ДатаНачала = '0001-01-01'
			ИЛИ ПользовательскаяНастройкаПериод.Значение.ДатаОкончания = '0001-01-01'
		Тогда
			ТекстОшибки = НСтр("ru = 'Для корректной работы отчета необходимо указать период.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"КомпоновщикНастроек.ПользовательскиеНастройки",
				,
				Отказ
			);
		КонецЕсли;
	КонецЕсли;
	
	ЗначениеПараметраКомпоновкиДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СпособРасчетаДнейТорговли"));
	Если ЗначениеПараметраКомпоновкиДанных <> Неопределено
		И КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЗначениеПараметраКомпоновкиДанных.ИдентификаторПользовательскойНастройки) <> Неопределено
	Тогда
		ПользовательскаяНастройкаСпособРасчета = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЗначениеПараметраКомпоновкиДанных.ИдентификаторПользовательскойНастройки);
		Если НЕ ЗначениеЗаполнено(ПользовательскаяНастройкаСпособРасчета.Значение) Тогда
			ТекстОшибки = НСтр("ru = 'Для корректной работы отчета необходимо указать параметр ""Рассчитывать дни торговли относительно показателя продаж.""'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"КомпоновщикНастроек.ПользовательскиеНастройки",
				,
				Отказ
			);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	УчитыватьСебестоимость = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьУчетСебестоимости");
	ПараметрКомпоновкиДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("УчитыватьСебестоимость"));
	ПараметрКомпоновкиДанных.Значение = УчитыватьСебестоимость;
	ПараметрКомпоновкиДанных.Использование = Истина;
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "ИспользоватьПрименениеЦен", ПолучитьФункциональнуюОпцию("ИспользоватьПрименениеЦен"));
	
	АссортиментСервер.ПроверитьНеобходимостьПереопределенияИВывестиОтчет(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
	ОбщегоНазначенияРТСервер.ВывестиДатуФормированияОтчета(ДокументРезультат);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
