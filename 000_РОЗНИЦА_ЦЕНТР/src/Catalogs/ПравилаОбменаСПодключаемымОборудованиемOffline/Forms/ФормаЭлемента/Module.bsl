///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВерхняяГраницаДиапазонаSKUВесовогоТовара = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ВерхняяГраницаДиапазонаSKUВесовогоТовара");
	SKUУстанавливаетсяВГлавномУзлеРИБ = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("SKUУстанавливаетсяВГлавномУзлеРИБ");
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект); 
	Элементы.НастройкаPLU.Видимость       = Объект.ТипПодключаемогоОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Элементы.МаксимальныйКодPLU.Видимость = Объект.СвояНумерацияPLUНаОборудовании;   
	Элементы.ТоварыPLU.Видимость          = Элементы.НастройкаPLU.Видимость;
	ДополнительныеКолонкиНоменклатуры = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ДополнительнаяКолонкаПриОтображенииНоменклатуры");
	
	Элементы.ТоварыСоздатьSKUДляТоваров.Доступность = 
		(НЕ ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("SKUУстанавливаетсяВГлавномУзлеРИБ") ИЛИ (ОбменДаннымиПовтИсп.ГлавныйУзел() = Неопределено));
	Если НЕ Элементы.ТоварыСоздатьSKUДляТоваров.Доступность Тогда
		ЭтотОбъект.Команды.СоздатьSKUДляТоваров.Подсказка = НСтр("ru = 'Cоздание SKU в главном узле РИБ'");
	КонецЕсли;
	
	Настроить();
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОтборИзменен;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ИзмененПорядГенерацииPLU Тогда
	
		ТекстВопроса = НСтр("ru = 'Изменение порядка нумерации PLU на оборудовании приведет их перегенерации.  
				|Продолжить операцию?'");
		Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		Если Результат <> КодВозвратаДиалога.ОК Тогда 
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.НастройкиКомпоновкиДанных = Новый ХранилищеЗначения(КомпоновщикНастроек.ПолучитьНастройки());
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Настроить();
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ИзмененПорядГенерацииPLU Тогда
		
		Состояние(НСтр("ru = 'Выполняется обновление PLU...'"));
		ОбновитьСписокТоваровНаСервере(Ложь, Истина);
		ДанныеЗагружены = Истина;
		
		ИзмененПорядГенерацииPLU = Ложь;
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСписокТоваров;
	КонецЕсли;
	
	Оповестить("Запись_ПравилаОбменаСПодключаемымОборудованиемOffline", ПараметрыЗаписи, Объект.Ссылка);

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПриИзменении(Элемент)
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОтборИзменен;
	ОтборИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТипПодключаемогоОборудованияПриИзменении(Элемент)
	Настроить();
	Элементы.НастройкаPLU.Видимость = Объект.ТипПодключаемогоОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток");
	Элементы.ТоварыPLU.Видимость = Элементы.НастройкаPLU.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура ТипПодключаемогоОборудованияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СвояНумерацияPLUНаОборудованииПриИзменении(Элемент)
	
	Элементы.МаксимальныйКодPLU.Видимость = Объект.СвояНумерацияPLUНаОборудовании;
	Элементы.МаксимальныйКодPLU.ТолькоПросмотр = Ложь;
	ИзмененПорядГенерацииPLU = Истина;
		
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	Настроить();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьSKUДляТоваров(Команда)
	
	Состояние(НСтр("ru = 'Выполняется обновление данных...'"));
	ОбновитьСписокТоваровНаСервере(Истина, Истина);
	ДанныеЗагружены = Истина;
		
	ИзмененПорядГенерацииPLU = Ложь;
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСписокТоваров;

КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьНастройкиОтбораПоУмолчанию(Команда)
	ЗагрузитьНастройкиОтбораПоУмолчанию();   
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	Если ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект) Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСписокТоваров(Команда)
	
	ДанныеЗагружены = Ложь;
	
	Если (ОтборИзменен ИЛИ ЭтотОбъект.Модифицированность) ИЛИ НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
		ТекстВопроса = НСтр("ru = 'Выполнение действия возможно только после записи данных.
				|Данные будут записаны.'");
		Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		Если Результат <> КодВозвратаДиалога.ОК Тогда 
			Возврат;
		КонецЕсли;
		
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		ОтборИзменен = Ложь;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется обновление списка товаров...'"));
	
	Если НЕ ДанныеЗагружены Тогда
		ОбновитьСписокТоваровНаСервере(Ложь);
	КонецЕсли;
	
	ДанныеЗагружены = Ложь;

	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСписокТоваров;
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ЗарегистрироватьИзмененияДляПравилаОбмена(Объект.Ссылка);

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьСписокТоваровНаСервере(ОбновитьSKU = Истина, ПересоздатьPLU = Ложь)
	
	ТаблицаТоваров = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьПоРозничнымЦенам(Объект.Ссылка, ОбновитьSKU, ПересоздатьPLU);
	
	Если ТаблицаТоваров <> Неопределено Тогда
		Товары.Загрузить(ТаблицаТоваров);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиОтбораПоУмолчанию()
	
	Если ИспользоватьАссортимент Тогда
		СхемаКомпоновкиДанных = Справочники.ПравилаОбменаСПодключаемымОборудованиемOffline.ПолучитьМакет("ОбновлениеКодовSKUАссортимент");
	Иначе
		СхемаКомпоновкиДанных = Справочники.ПравилаОбменаСПодключаемымОборудованиемOffline.ПолучитьМакет("ОбновлениеКодовSKU");
	КонецЕсли;
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор))
	);
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	Если ИспользоватьАссортимент Тогда
		ОбщегоНазначенияРТКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "ОбъектПланирования", ФорматМагазина);
		ОбщегоНазначенияРТКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "НаДату", ТекущаяДатаСеанса());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Настроить()
	
	Магазин = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Склад, "Магазин");
	ИспользоватьАссортимент = АссортиментСервер.ПолучитьФункциональнуюОпциюКонтроляАссортимента(Магазин);
	ФорматМагазина = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Магазин, "ФорматМагазина");
	
	Если ИспользоватьАссортимент Тогда
		СхемаКомпоновкиДанных = Справочники.ПравилаОбменаСПодключаемымОборудованиемOffline.ПолучитьМакет("ОбновлениеКодовSKUАссортимент");
	Иначе
		СхемаКомпоновкиДанных = Справочники.ПравилаОбменаСПодключаемымОборудованиемOffline.ПолучитьМакет("ОбновлениеКодовSKU");
	КонецЕсли;

	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
    КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));

	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПравилаОбменаСПодключаемымОборудованиемOffline.НастройкиКомпоновкиДанных КАК НастройкиКомпоновкиДанных
		|ИЗ
		|	Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline КАК ПравилаОбменаСПодключаемымОборудованиемOffline
		|ГДЕ
		|	ПравилаОбменаСПодключаемымОборудованиемOffline.Ссылка = &ПравилоОбмена");
		
		Запрос.УстановитьПараметр("ПравилоОбмена", Объект.Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			НастройкиКомпоновкиДанных = Выборка.НастройкиКомпоновкиДанных.Получить();
			Если ЗначениеЗаполнено(НастройкиКомпоновкиДанных) Тогда
				КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновкиДанных);
			Иначе
				КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	Если ИспользоватьАссортимент Тогда
		ОбщегоНазначенияРТКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "ОбъектПланирования", ФорматМагазина);
		ОбщегоНазначенияРТКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "НаДату", ТекущаяДатаСеанса());
	КонецЕсли;
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

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
