&НаКлиенте
Перем ИмяРедактируемогоРеквизита;

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		КодБанка 		  = "";
		НаименованиеБанка = "";
		ГородБанка        = "";
		
		Если Объект.РучноеИзменениеРеквизитовБанка Тогда
			КодБанка          = Объект.КодБанка;
			НаименованиеБанка = Объект.НаименованиеБанка;
			ГородБанка        = Объект.ГородБанка;
		Иначе
			Если НЕ Объект.Банк.Пустая() Тогда
				ЗаполнитьРеквизитыБанкаПоБанку("Банк", Объект.Банк, Ложь);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			Если Объект.РучноеИзменениеРеквизитовБанка Тогда
				КодБанка          = Объект.КодБанка;
				НаименованиеБанка = Объект.НаименованиеБанка;
				ГородБанка        = Объект.ГородБанка;
			Иначе
				Если НЕ Объект.Банк.Пустая() Тогда
					ЗаполнитьРеквизитыБанкаПоБанку("Банк", Объект.Банк, Ложь);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
	
	ЗаполнитьСписокВидовСчета();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ВидСчета = Элементы.ВидСчета.СписокВыбора[0];
	КонецЕсли;
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
	УправлениеЭлементамиФормы();
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	СформироватьАвтоНаименование();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.РучноеИзменениеРеквизитовБанка Тогда
		Если КодБанка <> Объект.КодБанка Тогда
			Объект.КодБанка = КодБанка;
		КонецЕсли;	
		Если НаименованиеБанка <> Объект.НаименованиеБанка Тогда
			Объект.НаименованиеБанка = НаименованиеБанка;
		КонецЕсли;
		Если ГородБанка <> Объект.ГородБанка Тогда
			Объект.ГородБанка = ГородБанка;
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = СформироватьАвтоНаименование();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)

	Если (ИсточникВыбора.ИмяФормы = "Справочник.БанковскиеСчетаКонтрагентов.Форма.РеквизитыБанка") Тогда
		Если Не ПустаяСтрока(РезультатВыбора) Тогда
			Если РезультатВыбора.Реквизит = "КодБанка" Тогда
				Объект.РучноеИзменениеРеквизитовБанка = РезультатВыбора.РучноеИзменение;
				Если РезультатВыбора.РучноеИзменение Тогда
					Объект.Банк              = "";
					Объект.КодБанка			 = РезультатВыбора.ЗначенияПолей.КодБанка;
					Объект.НаименованиеБанка = РезультатВыбора.ЗначенияПолей.Наименование;
					Объект.ГородБанка        = РезультатВыбора.ЗначенияПолей.Город;
					Объект.АдресБанка        = РезультатВыбора.ЗначенияПолей.Адрес;
					Объект.ТелефоныБанка     = РезультатВыбора.ЗначенияПолей.Телефоны;
					
					КодБанка		  = РезультатВыбора.ЗначенияПолей.КодБанка;
					НаименованиеБанка = РезультатВыбора.ЗначенияПолей.Наименование;
					ГородБанка        = РезультатВыбора.ЗначенияПолей.Город;
				Иначе
					Объект.Банк              = РезультатВыбора.Банк;
					Объект.КодБанка			 = "";
					Объект.НаименованиеБанка = "";
					Объект.ГородБанка        = "";
					Объект.АдресБанка        = "";
					Объект.ТелефоныБанка     = "";
					
					ЗаполнитьРеквизитыБанкаПоБанку("Банк", Объект.Банк, Ложь);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли (ИсточникВыбора.ИмяФормы = "Справочник.КлассификаторБанков.Форма.ФормаВыбора") Тогда	
		Если ТипЗнч(РезультатВыбора) = Тип("СправочникСсылка.КлассификаторБанков") Тогда
			Если ИмяРедактируемогоРеквизита = "КодБанка" Тогда
				Объект.Банк              = РезультатВыбора;
				Объект.КодБанка			 = "";
				Объект.НаименованиеБанка = "";
				Объект.ГородБанка        = "";
				Объект.АдресБанка        = "";
				Объект.ТелефоныБанка     = "";

				ЗаполнитьРеквизитыБанкаПоБанку("Банк", РезультатВыбора, Ложь);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура РучноеИзменениеРеквизитовБанкаПриИзменении(Элемент)
	ЗаписьОБанке = "";
	Если Объект.РучноеИзменениеРеквизитовБанка Тогда
		Если НЕ Объект.Банк.Пустая() Тогда
			ЗаполнитьРеквизитыБанкаПоБанку("Банк", Объект.Банк, Истина);
		КонецЕсли;
		Объект.Банк = "";
	Иначе
		ЗаполнитьРеквизитыБанкаПоКоду(Объект.КодБанка, "Банк", Истина);
		Объект.КодБанка			 = "";
		Объект.НаименованиеБанка = "";
		Объект.ГородБанка        = "";
		Объект.АдресБанка        = "";
		Объект.ТелефоныБанка     = "";
	КонецЕсли;
	
	СформироватьАвтоНаименование();
	УправлениеЭлементамиФормы();

КонецПроцедуры

&НаКлиенте
Процедура НомерСчетаПриИзменении(Элемент)

	СформироватьАвтоНаименование();

КонецПроцедуры

&НаКлиенте
Процедура ВидСчетаПриИзменении(Элемент)

	СформироватьАвтоНаименование();

КонецПроцедуры


&НаКлиенте
Процедура КодБанкаПриИзменении(Элемент)

	ИмяРедактируемогоРеквизита = "КодБанка";
	РеквизитБанкаПриИзменении("КодБанка");

	СформироватьАвтоНаименование();

КонецПроцедуры

&НаКлиенте
Процедура КодБанкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ИмяРедактируемогоРеквизита = "КодБанка";
	РеквизитБанкаПриВыборе("КодБанка", ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КодБанкаОткрытие(Элемент, СтандартнаяОбработка)
	ИмяРедактируемогоРеквизита = "КодБанка";
	СтандартнаяОбработка = Ложь;
	РеквизитБанкаОткрытие("КодБанка");
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция формирует наименование банковского счета.
//
&НаКлиенте
Функция СформироватьАвтоНаименование()
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	Если Объект.РучноеИзменениеРеквизитовБанка Тогда
		СтрокаНаименования = Прав(СокрЛП(Объект.НомерСчета), 4) 
		+ ?(ЗначениеЗаполнено(Объект.НаименованиеБанка), " в " + Строка(Объект.НаименованиеБанка), "")
		+ ", " + СокрЛП(Объект.Владелец);
		СтрокаНаименования = Лев(СтрокаНаименования, 150);
		
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
		
		СтрокаНаименования = ?(ЗначениеЗаполнено(Объект.НаименованиеБанка), Строка(Объект.НаименованиеБанка), "")
		+ ", " + СокрЛП(объект.Владелец);
		СтрокаНаименования = Лев(СтрокаНаименования, 150);
		
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
		
	Иначе
		
		СтрокаНаименования = Прав(СокрЛП(Объект.НомерСчета), 4) 
		+ ?(ЗначениеЗаполнено(Объект.Банк), " в " + Строка(Объект.Банк), "")
		+ ", " + СокрЛП(Объект.Владелец);
		СтрокаНаименования = Лев(СтрокаНаименования, 150);
		
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
		
		СтрокаНаименования = ?(ЗначениеЗаполнено(Объект.Банк), Строка(Объект.Банк), "")
		+ ", " + СокрЛП(объект.Владелец);
		СтрокаНаименования = Лев(СтрокаНаименования, 150);
		
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
		
	КонецЕсли;
	
	Возврат СтрокаНаименования;

КонецФункции

&НаКлиенте
Процедура РеквизитБанкаПриВыборе(ИмяЭлемента, Форма)
	Если ИмяЭлемента = "КодБанка" Тогда
		Если Не Объект.РучноеИзменениеРеквизитовБанка Тогда
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
       		ОткрытьФорму("Справочник.КлассификаторБанков.Форма.ФормаВыбора", СтруктураПараметров, Форма);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаОткрытие(ИмяЭлемента)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
	ЗначенияПараметров = Новый Структура;
	
	Если ИмяЭлемента = "КодБанка" Тогда
		
		СтруктураПараметров.Вставить("РучноеИзменение", Объект.РучноеИзменениеРеквизитовБанка);
		
		Если Объект.РучноеИзменениеРеквизитовБанка Тогда
			ЗначенияПараметров.Вставить("КодБанка", КодБанка);
			ЗначенияПараметров.Вставить("Наименование", НаименованиеБанка);
			ЗначенияПараметров.Вставить("Город", ГородБанка);
			ЗначенияПараметров.Вставить("Адрес", Объект.АдресБанка);
			ЗначенияПараметров.Вставить("Телефоны", Объект.ТелефоныБанка);
		Иначе
			СтруктураПараметров.Вставить("Банк", Объект.Банк);
		КонецЕсли;
		
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияПолей", ЗначенияПараметров);
	ОткрытьФорму("Справочник.БанковскиеСчетаКонтрагентов.Форма.РеквизитыБанка",СтруктураПараметров, ЭтотОбъект);
			    	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаПриИзменении(ИмяЭлемента)

	Если (ИмяЭлемента = "КодБанка") Тогда
		Если Не Объект.РучноеИзменениеРеквизитовБанка Тогда
			Если Не ЗаполнитьРеквизитыБанкаПоКоду(КодБанка, "Банк", Истина) Тогда
				СписокВариантовОтветовНаВопрос = Новый СписокЗначений;
				СписокВариантовОтветовНаВопрос.Добавить("ВыбратьИзСписка", "Выбрать из списка");
				СписокВариантовОтветовНаВопрос.Добавить("ПродолжитьВвод",  "Продолжить ввод");
				СписокВариантовОтветовНаВопрос.Добавить("ОтменитьВвод",	   "Отменить ввод");
				
				ТекстВопроса = НСтр("ru = 'Банк с МФО %Значение% не найден в справочнике банков.'");
				ТекстВопроса = СтрЗаменить(ТекстВопроса,"%Значение%",КодБанка);
				
				Ответ = Вопрос(ТекстВопроса, СписокВариантовОтветовНаВопрос, 0,,НСтр("ru = 'Выбор банка из классификатора'"));
				
				Если Ответ = "ОтменитьВвод" Тогда
					КодБанка = "";
				ИначеЕсли Ответ = "ПродолжитьВвод" Тогда
					Объект.РучноеИзменениеРеквизитовБанка = Истина;
					Объект.КодБанка = КодБанка;
				ИначеЕсли Ответ = "ВыбратьИзСписка" Тогда
					СтруктураПараметров = Новый Структура;
					СтруктураПараметров.Вставить("Реквизит", "КодБанка");
                	ОткрытьФорму("Справочник.КлассификаторБанков.Форма.ФормаВыбора", СтруктураПараметров, ЭтотОбъект);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
	УправлениеЭлементамиФормы();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьРеквизитыБанкаПоКоду(Код = "", ТипБанка, ПеренестиЗначенияРеквизитов = Ложь)
	
	НашлиПоКоду	 = Ложь;
	ЗаписьОБанке = "";
	
	Если ТипБанка = "Банк" Тогда
		КодБанка		  = "";
		НаименованиеБанка = "";
		ГородБанка        = "";
		
		РаботаСБанками.ПолучитьДанныеКлассификатора(Код,,ЗаписьОБанке);
		
		Если НЕ ПустаяСтрока(ЗаписьОБанке) Тогда
			КодБанка		  = ЗаписьОБанке.Код;
			НаименованиеБанка = ЗаписьОБанке.Наименование;
			ГородБанка        = ЗаписьОБанке.Город;
			НашлиПоКоду		  = Истина;
			Если ПеренестиЗначенияРеквизитов Тогда
				Объект.КодБанка			 = "";
				Объект.НаименованиеБанка = "";
				Объект.ГородБанка        = "";
				Объект.АдресБанка        = "";
				Объект.ТелефоныБанка     = "";
				Объект.Банк              = ЗаписьОБанке;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НашлиПоКоду;
КонецФункции


&НаСервере
Функция ЗаполнитьРеквизитыБанкаПоБанку(ТипБанка, Банк = "", ПеренестиЗначенияРеквизитов = Ложь)
	Если ТипЗнч(Банк) = Тип("СправочникСсылка.КлассификаторБанков") Тогда
		Если ТипБанка = "Банк" Тогда
			КодБанка		  = Банк.Код;
			НаименованиеБанка = Банк.Наименование;
			ГородБанка        = Банк.Город;
			Если ПеренестиЗначенияРеквизитов Тогда
				Объект.КодБанка			 = Банк.Код;
				Объект.НаименованиеБанка = Банк.Наименование;
				Объект.ГородБанка        = Банк.Город;
				Объект.АдресБанка        = Банк.Адрес;
				Объект.ТелефоныБанка     = Банк.Телефоны;
				Объект.Банк              = "";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	РучноеИзменение = Объект.РучноеИзменениеРеквизитовБанка;
	
	// Установим использование банка для расчетов.
	Элементы.НаименованиеБанка.ТолькоПросмотр = НЕ РучноеИзменение;
	Элементы.ГородБанка.ТолькоПросмотр        = НЕ РучноеИзменение;
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Результат = ОткрытьФормуМодально("Справочник.БанковскиеСчетаКонтрагентов.Форма.РазблокированиеРеквизитов");
		Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
			ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтотОбъект, Результат);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ЗаполнитьСписокВидовСчета()
	
	СписокВидСчета = Элементы.ВидСчета.СписокВыбора;
	СписокВидСчета.Добавить("Текущий");
	СписокВидСчета.Добавить("Депозитный");
	СписокВидСчета.Добавить("Ссудный");
	СписокВидСчета.Добавить("Иной");
	
КонецПроцедуры



