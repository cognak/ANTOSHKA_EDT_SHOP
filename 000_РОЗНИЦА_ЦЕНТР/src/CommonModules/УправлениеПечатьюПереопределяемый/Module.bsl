////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Выполняет внешнюю обработку печати.
//
// Параметры:
//  ИсточникДанных        - Произвольный    - источник данных;
//  ПараметрыИсточника    - Произвольный    - параметры источника печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - (выходной) см. УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм;
//  ОбъектыПечати         - СписокЗначений  - (выходной) список объектов печати, где значение - Ссылка, а представление - имя области печати;
//  ПараметрыВывода       - Структура       - (выходной) см. УправлениеПечатью.ПодготовитьСтруктуруПараметровВывода.
//
// Возвращаемое значение:
//  Булево - Ложь, если печать не была выполнена.
Функция ПечатьПоВнешнемуИсточнику(ИсточникДанных, ПараметрыИсточника, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	Если ТипЗнч(ИсточникДанных) = Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		ДополнительныеОтчетыИОбработки.ПечатьПоВнешнемуИсточнику(
			ИсточникДанных, ПараметрыИсточника, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
		Возврат Истина;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	Возврат Ложь;
	
КонецФункции

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Вызывается из ОбщегоНазначения.НастройкиФорматовСохраненияТабличногоДокумента()
//
// Параметры
//  ТаблицаФорматов - ТаблицаЗначений:
//                     ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента                 - значение в платформе, соответствующее формату;
//                     Ссылка                      - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на метаданные, где хранится представление;
//                     Представление               - Строка -                                    - представление типа файла (заполняется из перечисления);
//                     Расширение                  - Строка -                                    - тип файла для операционной системы;
//                     Картинка                    - Картинка                                    - значок формата.
//
Процедура ПриЗаполненииНастроекФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
КонецПроцедуры



// Переопределяет список команд печати, получаемый функцией УправлениеПечатью.КомандыПечатиФормы.
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
	Если ИмяФормы = "Документ.ЛистКассовойКниги.Форма.ФормаСпискаДокументов" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.ПриходныйКассовыйОрдер.ДобавитьКомандыПечати(КоллекцияКомандПечати);
		Для Каждого КомандаПечати Из КоллекцияКомандПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ПриходныйКассовыйОрдер";
			КонецЕсли;
		КонецЦикла;
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КоллекцияКомандПечати, "Документ.ПриходныйКассовыйОрдер.Форма.ФормаСписка");
		КоллекцияКомандПечати.ЗаполнитьЗначения("ПриходныеКассовыеОрдераКоманднаяПанель", "МестоРазмещения");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.РасходныйКассовыйОрдер.ДобавитьКомандыПечати(КоллекцияКомандПечати);
		Для Каждого КомандаПечати Из КоллекцияКомандПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.РасходныйКассовыйОрдер";
			КонецЕсли;
		КонецЦикла;
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КоллекцияКомандПечати, "Документ.РасходныйКассовыйОрдер.Форма.ФормаСписка");
		КоллекцияКомандПечати.ЗаполнитьЗначения("РасходныеКассовыеОрдераКоманднаяПанель", "МестоРазмещения");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.ЛистКассовойКниги.ДобавитьКомандыПечати(КоллекцияКомандПечати);
		Для Каждого КомандаПечати Из КоллекцияКомандПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ЛистКассовойКниги";
			КонецЕсли;
		КонецЦикла;
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КоллекцияКомандПечати, "Документ.ЛистКассовойКниги.Форма.ФормаСписка");
		КоллекцияКомандПечати.ЗаполнитьЗначения("КассовыеКнигиКоманднаяПанель", "МестоРазмещения");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
	ИначеЕсли ИмяФормы = "Документ.ОрдерНаОтражениеПорчиТоваров.Форма.ФормаСписка" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.СписаниеБезналичныхДенежныхСредств.ДобавитьКомандыПечати(КоллекцияКомандПечати);
		Для Каждого КомандаПечати Из КоллекцияКомандПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ОрдерНаОтражениеПорчиТоваров";
			КонецЕсли;
		КонецЦикла;
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КоллекцияКомандПечати, "Документ.ОрдерНаОтражениеПорчиТоваров.Форма.ФормаСписка");
		КоллекцияКомандПечати.ЗаполнитьЗначения("СписокОрдеровКоманднаяПанель", "МестоРазмещения");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
	ИначеЕсли ИмяФормы = "Документ.ВыпискаПоРасчетномуСчету.Форма.ФормаСпискаДокументов" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.СписаниеБезналичныхДенежныхСредств.ДобавитьКомандыПечати(КоллекцияКомандПечати);
		Для Каждого КомандаПечати Из КоллекцияКомандПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.СписаниеБезналичныхДенежныхСредств";
			КонецЕсли;
		КонецЦикла;
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КоллекцияКомандПечати, "Документ.СписаниеБезналичныхДенежныхСредств.Форма.ФормаСписка");
		КоллекцияКомандПечати.ЗаполнитьЗначения("СписанияДенежныхСредствКоманднаяПанель", "МестоРазмещения");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
	
	ИначеЕсли ИмяФормы = "ОбщаяФорма.СписокДокументовПродажи" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.РеализацияТоваровУслуг.ДобавитьКомандыПечати(КоллекцияКомандПечати);
		Для Каждого КомандаПечати Из КоллекцияКомандПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.РеализацияТоваровУслуг";
			КонецЕсли;
		КонецЦикла;
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КоллекцияКомандПечати, "Документ.РеализацияТоваровУслуг.Форма.ФормаСписка");
		КоллекцияКомандПечати.ЗаполнитьЗначения("СписокРеализацииТоваровУслугКоманднаяПанель", "МестоРазмещения");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.АктВыполненныхРабот.ДобавитьКомандыПечати(КоллекцияКомандПечати);
		Для Каждого КомандаПечати Из КоллекцияКомандПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.АктВыполненныхРабот";
			КонецЕсли;
		КонецЦикла;
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КоллекцияКомандПечати, "Документ.АктВыполненныхРабот.Форма.ФормаСписка");
		КоллекцияКомандПечати.ЗаполнитьЗначения("СписокАктовВыполненныхРаботКоманднаяПанель", "МестоРазмещения");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
	
	ИначеЕсли ИмяФормы = "ЖурналДокументов.ОтчетыКомитентам.Форма.ФормаСпискаДокументов" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Документы.ОтчетКомитенту.ДобавитьКомандыПечати(КомандыПечати);
		Для Каждого КомандаПечати Из КомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ОтчетКомитенту";
			КонецЕсли;
		КонецЦикла;
		
		ДобавляемыеКомандыПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.ОтчетКомитентуОСписании.ДобавитьКомандыПечати(ДобавляемыеКомандыПечати);
		Для Каждого КомандаПечати Из ДобавляемыеКомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ОтчетКомитентуОСписании";
			КонецЕсли;
			Отбор = Новый Структура("Идентификатор,Представление,МенеджерПечати,Обработчик");
			ЗаполнитьЗначенияСвойств(Отбор, КомандаПечати);
			НайденныеКоманды = КомандыПечати.НайтиСтроки(Отбор);
			Если НайденныеКоманды.Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(КомандыПечати.Добавить(), КомандаПечати);
			КонецЕсли;
		КонецЦикла;
		
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Документ.ОтчетКомитенту.Форма.ФормаСписка");
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Документ.ОтчетКомитентуОСписании.Форма.ФормаСписка");
	
	ИначеЕсли ИмяФормы = "ЖурналДокументов.ПередачиВозвратыТоваровМеждуОрганизациями.Форма.ФормаРабочееМесто" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Документы.ВозвратТоваровМеждуОрганизациями.ДобавитьКомандыПечати(КомандыПечати);
		Для Каждого КомандаПечати Из КомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ВозвратТоваровМеждуОрганизациями";
			КонецЕсли;
		КонецЦикла;
		
		ДобавляемыеКомандыПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.ПередачаТоваровМеждуОрганизациями.ДобавитьКомандыПечати(ДобавляемыеКомандыПечати);
		Для Каждого КомандаПечати Из ДобавляемыеКомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ПередачаТоваровМеждуОрганизациями";
			КонецЕсли;
			Отбор = Новый Структура("Идентификатор,Представление,МенеджерПечати,Обработчик");
			ЗаполнитьЗначенияСвойств(Отбор, КомандаПечати);
			НайденныеКоманды = КомандыПечати.НайтиСтроки(Отбор);
			Если НайденныеКоманды.Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(КомандыПечати.Добавить(), КомандаПечати);
			КонецЕсли;
		КонецЦикла;
		
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Документ.ВозвратТоваровМеждуОрганизациями.Форма.ФормаСписка");
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Документ.ПередачаТоваровМеждуОрганизациями.Форма.ФормаСписка");
	
	ИначеЕсли ИмяФормы = "Документ.ПоступлениеТоваровУслуг.Форма.ФормаВыбораРаспоряжения" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Документы.ЗаказПоставщику.ДобавитьКомандыПечати(КомандыПечати);
		Для Каждого КомандаПечати Из КомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ЗаказПоставщику";
			КонецЕсли;
		КонецЦикла;
		
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Документ.ЗаказПоставщику.Форма.ФормаСписка");
	
	ИначеЕсли ИмяФормы = "Справочник.СертификатыНоменклатуры.Форма.ФормаСпискаКонтекст" 
	 ИЛИ ИмяФормы = "Справочник.СертификатыНоменклатуры.Форма.ФормаСписка" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Справочники.СертификатыНоменклатуры.ДобавитьКомандыПечати(КомандыПечати);	
		КомандыПечати.ЗаполнитьЗначения("КоманднаяПанельСписокСертификатыНоменклатурыПечать", "МестоРазмещения");
		
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, ИмяФормы);
		
	КонецЕсли;
	
КонецПроцедуры
