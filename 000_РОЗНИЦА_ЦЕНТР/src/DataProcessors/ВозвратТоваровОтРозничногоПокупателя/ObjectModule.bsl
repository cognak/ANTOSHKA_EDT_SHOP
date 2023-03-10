
///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Коллекция колонок табличного поля "Товары".
Перем мСклонение;

Перем МассивСформированныхДокументов;

// Выводит в окне информацию об ошибке
//
// Параметры
//  ТекстОшибки - строка
//
Процедура ВывестиИнформациюОбОшибке(ТекстОшибки) Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	ФормаИнформацииОбОшибке = ПолучитьОбщуюФорму("ФормаИнформацииОбОшибке");
	ФормаИнформацииОбОшибке.ТекстОшибки = ТекстОшибки;
	ФормаИнформацииОбОшибке.ОткрытьМодально();
	#КонецЕсли
	
КонецПроцедуры

// Процедура создает новый документ  ВозвратТоваровОтПокупателя
//
Процедура СформироватьВозвратТоваровОтПокупателя() Экспорт

	ВозвратТоваровОтПокупателя = Документы.ВозвратТоваровОтПокупателя.СоздатьДокумент();

	ВозвратТоваровОтПокупателя.Склад                 = Склад;
	ВозвратТоваровОтПокупателя.Магазин               = Склад.Магазин;
	ВозвратТоваровОтПокупателя.Ответственный         = Пользователи.ТекущийПользователь();
	ВозвратТоваровОтПокупателя.АналитикаХозяйственнойОперации = АналитикаХозяйственнойОперации;
	ВозвратТоваровОтПокупателя.Организация           = Организация;
	
	ЗаполнитьЗначенияСвойств(ВозвратТоваровОтПокупателя, ЭтотОбъект);
	
	УчитыватьНДС = ОпределитьУчетНДС();
	ВозвратТоваровОтПокупателя.УчитыватьНДС    = УчитыватьНДС;
	ВозвратТоваровОтПокупателя.ЦенаВключаетНДС = УчитыватьНДС; //в обработке всегда сумма включает НДС
	
	ВозвратТоваровОтПокупателя.УстановитьНовыйНомер();
	ВозвратТоваровОтПокупателя.Товары.Загрузить(Товары.Выгрузить());
	ВозвратТоваровОтПокупателя.Серии.Загрузить(Серии.Выгрузить());
	
	ЕстьОшибки = Ложь;
	
	ПродажиСервер.ПроверитьВозможностьВозвратаОтПокупателя( ВозвратТоваровОтПокупателя, ЕстьОшибки, ЭтотОбъект);
	
	Если НЕ ЕстьОшибки Тогда
		ВозвратТоваровОтПокупателя.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
		МассивСформированныхДокументов.Добавить(ВозвратТоваровОтПокупателя.Ссылка);
		ИсторияРаботыПользователя.Добавить(ВозвратТоваровОтПокупателя.Ссылка);
	Иначе
		ВозвратТоваровОтПокупателя.Удалить();
	КонецЕсли;
	
КонецПроцедуры

// Процедура создает новый документ  РасходныйКассовыйОрдер
//
Процедура СформироватьРасходныйКассовыйОрдер() Экспорт

	РасходныйКассовыйОрдер = Документы.РасходныйКассовыйОрдер.СоздатьДокумент();

	СуммаВозвратаНаличными = 0.00;
	Для Каждого СтрокаОплаты Из Оплата Цикл
		Если ЗначениеЗаполнено(СтрокаОплаты.ВидОплаты) И СтрокаОплаты.ВидОплаты = Справочники.ВидыОплатЧекаККМ.Наличные Тогда
			СуммаВозвратаНаличными = СуммаВозвратаНаличными + СтрокаОплаты.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	Если СуммаВозвратаНаличными = 0.00 Тогда
		
		Если Не РасходныйКассовыйОрдер.ЭтоНовый() Тогда //уже записали
			РасходныйКассовыйОрдер.Удалить();
			РасходныйКассовыйОрдер = Документы.РасходныйКассовыйОрдер.СоздатьДокумент();
		КонецЕсли;
		
		//наличными ничего не возвращаем, значит РКО делать и не надо
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ЗаполнениеВозвратТоваровОтРозничногоПокупателя");
	СтруктураПараметров.Вставить("Организация", Организация);
	СтруктураПараметров.Вставить("Дата", Дата);
	СтруктураПараметров.Вставить("Касса", Касса);
	СтруктураПараметров.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту);
	СтруктураПараметров.Вставить("Контрагент", Контрагент);
	СтруктураПараметров.Вставить("Выдать", ФИОФизЛица);
	СтруктураПараметров.Вставить("Основание", Основание);
	СтруктураПараметров.Вставить("ПоДокументу", ПоДокументу);
	СтруктураПараметров.Вставить("Приложение", Приложение + ", Чек № " + ЧекНомер + " от " + Формат(ЧекДата, "ДЛФ=DD"));
	СтруктураПараметров.Вставить("СуммаДокумента", СуммаВозвратаНаличными);
	СтруктураПараметров.Вставить("СтатьяДвиженияДенежныхСредств", СтатьяДвиженияДенежныхСредств);
	СтруктураПараметров.Вставить("ДокументРасчетовСКонтрагентом", ВозвратТоваровОтПокупателя.Ссылка);
	РасходныйКассовыйОрдер.Заполнить(СтруктураПараметров);
	
	РасходныйКассовыйОрдер.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
	МассивСформированныхДокументов.Добавить(РасходныйКассовыйОрдер.Ссылка);
	ИсторияРаботыПользователя.Добавить(РасходныйКассовыйОрдер.Ссылка);
КонецПроцедуры

// Сообщение пользователю
//
Процедура СообщитьПользователюСУчетомРежима(ТекстОшибки) Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ВывестиИнформациюОбОшибке(ТекстОшибки);
	#Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки);
	#КонецЕсли
	

КонецПроцедуры

// Формирует документы возврата
//
// Возвращаемое значение:
//  Булево - Результат, формирования документов
//
Функция СформироватьДокументы() Экспорт
	
	Результат = Истина;
	МассивСформированныхДокументов = Новый Массив;
	
	ПредупредитьОБК = Ложь;
	Для Каждого СтрокаОплаты Из Оплата Цикл
		Если ЗначениеЗаполнено(СтрокаОплаты.ВидОплаты)
		 И СтрокаОплаты.ВидОплаты.ТипОплаты = Перечисления.ТипыОплатЧекаККМ.БанковскийКредит Тогда
			ПредупредитьОБК = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПредупредитьОБК Тогда
		ТекстОшибки = НСтр("ru='Документы возврата денежных средств по банковскому кредиту сформированы не были." + Символы.ПС + "Автоматическое оформление возврата денежных средств по кредиту не реализованно в системе.'");
			
		СообщитьПользователюСУчетомРежима(ТекстОшибки)
	КонецЕсли;
	
	УдалитьДокументы();
	
	Попытка
		СформироватьВозвратТоваровОтПокупателя();
	Исключение
		
		ТекстОшибки = НСтр("ru='Документы не сформированы!" + Символы.ПС +
		 "Не удалось сформировать документ ""Возврат товаров от покупателя""'");
		
		СообщитьПользователюСУчетомРежима(ТекстОшибки);
		Результат = Ложь;
		
	КонецПопытки;
	
	Попытка
		
		СформироватьОплатуОтПокупателяПлатежнойКартой();
		
	Исключение
		
		ТекстОшибки = НСтр("ru='Документы не сформированы!" + Символы.ПС +
		 "Не удалось сформировать документ ""Операция по платежной карте""'");
			
		СообщитьПользователюСУчетомРежима(ТекстОшибки);
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Попытка
		
		СформироватьРасходныйКассовыйОрдер();
		
	Исключение
		
		ТекстОшибки = НСтр("ru='Документы не сформированы!" + Символы.ПС +
		 "Не удалось сформировать документ ""Расходный кассовый ордер"".'");
			
		СообщитьПользователюСУчетомРежима(ТекстОшибки);
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Если Не Результат Тогда
		УдалитьДокументы();
	Иначе
		ТекстОшибки = НСтр("ru='Документы успешно созданы!'");
			
		СообщитьПользователюСУчетомРежима(ТекстОшибки);
	КонецЕсли;
	
	РезультатСтруктура = Новый Структура;
	РезультатСтруктура.Вставить("Результат", Результат);
	РезультатСтруктура.Вставить("МассивСформированныхДокументов", МассивСформированныхДокументов);
	Возврат РезультатСтруктура;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	РазрешитьОформлениеВозвратовОтПокупателяБезДокументовПродажи = УправлениеПользователями.ПолучитьБулевоЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьОформлениеВозвратовОтПокупателяБезДокументовПродажи, Ложь);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если РазрешитьОформлениеВозвратовОтПокупателяБезДокументовПродажи Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ДокументПродажи");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Склад");
	
	Если ПереключательОплатаСложная ТОгда
		МассивНепроверяемыхРеквизитов.Добавить("СуммаОплаты");
		МассивНепроверяемыхРеквизитов.Добавить("ВидОплаты");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Оплата");
		МассивНепроверяемыхРеквизитов.Добавить("Оплата.ВидОплаты");
		МассивНепроверяемыхРеквизитов.Добавить("Оплата.Сумма");
	КонецЕсли;
	
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,Документы.ВозвратТоваровОтПокупателя.ПараметрыУказанияСерий(ЭтотОбъект),Отказ);
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		
		СтрокаЗаголовкаОшибки = НСтр("ru = 'Ошибки заполнения'");
		ТекстОшибки = "";
		
		МассивРеквизитовТоваров = Новый Массив;
		МассивРеквизитовОплат   = Новый Массив;
		МассивРеквизитовСерии   = Новый Массив;
		Для каждого ПроверяемыйРеквизит Из ПроверяемыеРеквизиты Цикл
			Если СтрНайти(ПроверяемыйРеквизит, "Товары.") > 0 Тогда
				МассивРеквизитовТоваров.Добавить(СтрЗаменить(ПроверяемыйРеквизит, "Товары.", ""));
			ИначеЕсли СтрНайти(ПроверяемыйРеквизит, "Оплата.") > 0 Тогда
				МассивРеквизитовОплат.Добавить(СтрЗаменить(ПроверяемыйРеквизит, "Оплата.", ""));
			ИначеЕсли СтрНайти(ПроверяемыйРеквизит, "Серии.") > 0 Тогда
				МассивРеквизитовСерии.Добавить(СтрЗаменить(ПроверяемыйРеквизит, "Серии.", ""));
			ИначеЕсли ПроверяемыйРеквизит = "Товары" Тогда
				Если Товары.Количество() = 0  Тогда
					ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Не введено ни одной строки в список Товары.'");
					Отказ = Истина;
				КонецЕсли;
			ИначеЕсли ПроверяемыйРеквизит = "Оплата" Тогда
				Если Оплата.Количество() = 0  Тогда
					ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Не введено ни одной строки в список Оплата.'");
					Отказ = Истина;
				КонецЕсли;
			ИначеЕсли НЕ ЗначениеЗаполнено(ЭтотОбъект[ПроверяемыйРеквизит]) Тогда
				ТекстОшибки = ТекстОшибки + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Поле %1 не заполнено'"),
				ПроверяемыйРеквизит);
				Отказ = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если МассивРеквизитовТоваров.Количество() > 0 Тогда
			Для каждого СтрокаТаблицы Из Товары Цикл
				Для каждого ЭлементМассиваПроверки Из МассивРеквизитовТоваров Цикл
					Если НЕ ЗначениеЗаполнено(СтрокаТаблицы[ЭлементМассиваПроверки]) Тогда
						ТекстОшибки = ТекстОшибки + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не заполнена колонка %1 в строке %2 списка Товары'"),
						ЭлементМассиваПроверки,
						СтрокаТаблицы.НомерСтроки);
						Отказ = Истина;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
		Если МассивРеквизитовОплат.Количество() > 0 Тогда
			Для каждого СтрокаТаблицы Из Оплата Цикл
				Для каждого ЭлементМассиваПроверки Из МассивРеквизитовОплат Цикл
					Если НЕ ЗначениеЗаполнено(СтрокаТаблицы[ЭлементМассиваПроверки]) Тогда
						ТекстОшибки = ТекстОшибки + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не заполнена колонка %1 в строке %2 списка Оплата'"),
						ЭлементМассиваПроверки,
						СтрокаТаблицы.НомерСтроки);
						Отказ = Истина;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
		Если МассивРеквизитовСерии.Количество() > 0 Тогда
			Для каждого СтрокаТаблицы Из Серии Цикл
				Для каждого ЭлементМассиваПроверки Из МассивРеквизитовСерии Цикл
					Если НЕ ЗначениеЗаполнено(СтрокаТаблицы[ЭлементМассиваПроверки]) Тогда
						Если ЗначениеЗаполнено(СтрокаТаблицы.Характеристика)  Тогда
							ТекстОшибки = ТекстОшибки + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Не заполнена колонка %1 для номенклатуры %2' (%3)"),
							ЭлементМассиваПроверки,
							СтрокаТаблицы.Номенклатура,
							СтрокаТаблицы.Характеристика);
						Иначе
							ТекстОшибки = ТекстОшибки + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Не заполнена колонка %1 для номенклатуры %2'"),
							ЭлементМассиваПроверки,
							СтрокаТаблицы.Номенклатура);
						КонецЕсли;
						Отказ = Истина;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
		
		Если Отказ Тогда
			ТекстОшибки = СтрокаЗаголовкаОшибки + Символы.ПС + ТекстОшибки;
			ВывестиИнформациюОбОшибке(ТекстОшибки);
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Печать

Функция ПодключитьКомпонентуСклонение()
	
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		
		Компонента = "NameDecl.dll";
		Попытка
			ЗагрузитьВнешнююКомпоненту(Компонента);
			Результат = Новый("AddIn.NameDeclension");
		Исключение
			Результат = Неопределено;
		КонецПопытки;
	#Иначе
		Результат = Неопределено;
	#КонецЕсли
	
	Возврат Результат;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Прочее

Процедура СформироватьОплатуОтПокупателяПлатежнойКартой()
	
	СуммаВозвратаПлатежнойКартой = 0.00;
	Для Каждого СтрокаОплаты Из Оплата Цикл
		Если ЗначениеЗаполнено(СтрокаОплаты.ВидОплаты)
		 И СтрокаОплаты.ВидОплаты.ТипОплаты = Перечисления.ТипыОплатЧекаККМ.ПлатежнаяКарта Тогда
			СуммаВозвратаПлатежнойКартой = СуммаВозвратаПлатежнойКартой + СтрокаОплаты.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	Если СуммаВозвратаПлатежнойКартой = 0.00 Тогда
		//платежными картами ничего не возвращаем, значит возврат покупателю платежной картой делать и не надо
		Возврат;
	КонецЕсли;
	
	//получим таблицу оплат, свернутую по виду оплат
	СвернутыеОплаты = Оплата.Выгрузить();
	
	Для Каждого СтрокаОплаты Из СвернутыеОплаты Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаОплаты.ВидОплаты)
		 ИЛИ СтрокаОплаты.ВидОплаты.ТипОплаты <> Перечисления.ТипыОплатЧекаККМ.ПлатежнаяКарта Тогда
			Продолжить;
		КонецЕсли;
		
		ОплатаОтПокупателяПлатежнойКартой = Документы.ОплатаОтПокупателяПлатежнойКартой.СоздатьДокумент();
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("ЗаполнениеВозвратТоваровОтРозничногоПокупателя");
		СтруктураПараметров.Вставить("Организация", Организация);
		СтруктураПараметров.Вставить("Дата", Дата);
		СтруктураПараметров.Вставить("Магазин", Магазин);
		СтруктураПараметров.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту);
		СтруктураПараметров.Вставить("ДоговорЭквайринга", СтрокаОплаты.ЭквайринговыйТерминал.Владелец);
		СтруктураПараметров.Вставить("ЭквайринговыйТерминал", СтрокаОплаты.ЭквайринговыйТерминал);
		СтруктураПараметров.Вставить("СтатьяДвиженияДенежныхСредств", СтатьяДвиженияДенежныхСредств);
		СтруктураПараметров.Вставить("ДокументРасчетовСКонтрагентом", ВозвратТоваровОтПокупателя.Ссылка);
		СтруктураПараметров.Вставить("Эквайрер", ?(ЗначениеЗаполнено(СтрокаОплаты.ЭквайринговыйТерминал), СтрокаОплаты.ЭквайринговыйТерминал.Владелец.Эквайрер, Справочники.Контрагенты.ПустаяСсылка()));
		СтруктураПараметров.Вставить("ВидОплаты", СтрокаОплаты.ВидОплаты);
		СтруктураПараметров.Вставить("Контрагент", Контрагент);
		СтруктураПараметров.Вставить("СуммаДокумента", СтрокаОплаты.Сумма);
		СтруктураПараметров.Вставить("ПроцентТорговойУступки", СтрокаОплаты.ПроцентТорговойУступки);
		СтруктураПараметров.Вставить("СуммаТорговойУступки", СтрокаОплаты.СуммаТорговойУступки);
		
		ОплатаОтПокупателяПлатежнойКартой.Заполнить(СтруктураПараметров);
		ОплатаОтПокупателяПлатежнойКартой.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
		
		//поместим ссылку на документ в список, чтобы в случае переформирования документов удалить старые
		СписокДокументовОплатаОтПокупателяПлатежнойКартой.Добавить(ОплатаОтПокупателяПлатежнойКартой.Ссылка);
		
		МассивСформированныхДокументов.Добавить(ОплатаОтПокупателяПлатежнойКартой.Ссылка);
		ИсторияРаботыПользователя.Добавить(ОплатаОтПокупателяПлатежнойКартой.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

// Удаляет документы из базы
//
Процедура УдалитьДокументы()
	
	// Очищает список перед созданием
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого СсылкаНаДокумент Из СписокДокументовОплатаОтПокупателяПлатежнойКартой Цикл
		
		ДокументОбъект = СсылкаНаДокумент.Значение.ПолучитьОбъект();
		
		Если ДокументОбъект.Проведен Тогда 
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			
		КонецЕсли;
		
		ДокументОбъект.ПометкаУдаления = Истина;
		ДокументОбъект.Записать();
		ДокументОбъект.Удалить();
		
	КонецЦикла;
	
	СписокДокументовОплатаОтПокупателяПлатежнойКартой.Очистить();
	
	Если ЗначениеЗаполнено(ВозвратТоваровОтПокупателя.Ссылка) Тогда
		
		ДокументОбъект = ВозвратТоваровОтПокупателя.Ссылка.ПолучитьОбъект();
		Если ДокументОбъект.Проведен Тогда 
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			
		КонецЕсли;
		
		ДокументОбъект.ПометкаУдаления = Истина;
		ДокументОбъект.Записать();
		ДокументОбъект.Удалить();
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РасходныйКассовыйОрдер.Ссылка) Тогда
		
		ДокументОбъект = РасходныйКассовыйОрдер.Ссылка.ПолучитьОбъект();
		Если ДокументОбъект.Проведен Тогда 
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			
		КонецЕсли;
		
		ДокументОбъект.ПометкаУдаления = Истина;
		ДокументОбъект.Записать();
		ДокументОбъект.Удалить();
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОпределитьУчетНДС()
	
	Для Каждого СтрокаТоваров Из Товары Цикл
		
		Если СтрокаТоваров.СтавкаНДС <> Перечисления.СтавкиНДС.БезНДС Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мСклонение = ПодключитьКомпонентуСклонение();
