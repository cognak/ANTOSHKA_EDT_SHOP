///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция возвращает максимальное SKU
//
Функция ПолучитьМаксимальныйКодSKU(Весовой, НижняяГраницаВесовогоТовара, ВерхняяГраницаВесовогоТовара) Экспорт
		
	Текст = "ВЫБРАТЬ
	|	МАКСИМУМ(КодыТоваровSKU.SKU) КАК SKU
	|ИЗ
	|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|ГДЕ КодыТоваровSKU.SKU >= &Значение1";
	
	Если Весовой Тогда
		Текст = Текст + " И КодыТоваровSKU.SKU < &Значение2";
		Запрос = Новый Запрос(Текст);
		Запрос.УстановитьПараметр("Значение1", НижняяГраницаВесовогоТовара);
		Запрос.УстановитьПараметр("Значение2", ВерхняяГраницаВесовогоТовара);
		Результат = НижняяГраницаВесовогоТовара + 1;
	Иначе
		Запрос = Новый Запрос(Текст);
		Запрос.УстановитьПараметр("Значение1", ВерхняяГраницаВесовогоТовара);
		Результат = ВерхняяГраницаВесовогоТовара + 1;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если ЗначениеЗаполнено(Выборка.SKU) Тогда
			Результат = Выборка.SKU + 1;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат; 

КонецФункции 

// Функция выполняет проверку регистра на свободные SKU
//
Функция ПолучитьСвободныеSKU(НижняяГраница = 1, ВерхняяГраница = Неопределено, Первые = Неопределено) Экспорт

	Текст = "ВЫБРАТЬ "+?(Первые = Неопределено,"","Первые")+" "+?(Первые = Неопределено,"",Формат(Первые,"ЧН=0; ЧГ=0"))+"
	|	КодыТоваровSKU.SKU КАК SKU
	|ИЗ
	|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|ГДЕ
	|	КодыТоваровSKU.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	И КодыТоваровSKU.Характеристика= ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	И КодыТоваровSKU.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
	|	И КодыТоваровSKU.SKU >= &НижняяГраница ";
	
	Если ВерхняяГраница <> Неопределено Тогда
		Текст = Текст + "
		|	И КодыТоваровSKU.SKU <= &ВерхняяГраница ";
	КонецЕсли;
	
	Текст = Текст + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	SKU";
	
	Запрос = Новый Запрос(Текст);
	Запрос.УстановитьПараметр("НижняяГраница", НижняяГраница);
	Запрос.УстановитьПараметр("ВерхняяГраница", ВерхняяГраница);
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции 

Функция ПолучитьСвободныеSKUМетодомОбъединения(НижняяГраница = 1, ВерхняяГраница = Неопределено) Экспорт

	Текст = "ВЫБРАТЬ
	|	КодыТоваровSKU.SKU КАК Код
	|ИЗ
	|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|ГДЕ
	|	КодыТоваровSKU.SKU >= &НижняяГраница - 1
	|";
	
	Если ВерхняяГраница <> Неопределено Тогда
		Текст = Текст+"
		|	И КодыТоваровSKU.SKU < (&ВерхняяГраница + 1)";
	КонецЕсли;
	
	Текст = Текст+"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&НижняяГраница - 1 КАК Код
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&ВерхняяГраница + 1 КАК Код
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код";
	
	Запрос = Новый Запрос(Текст);
	Запрос.УстановитьПараметр("НижняяГраница", НижняяГраница);
	Запрос.УстановитьПараметр("ВерхняяГраница", ВерхняяГраница);
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	ТаблицаДиапазонов = Новый ТаблицаЗначений;
	ТаблицаДиапазонов.Колонки.Добавить("НачалоИнтервала"       , Новый ОписаниеТипов("Число"));
	ТаблицаДиапазонов.Колонки.Добавить("КонецИнтервала"        , Новый ОписаниеТипов("Число"));
	ТаблицаДиапазонов.Колонки.Добавить("КоличествоСвободныхSKU", Новый ОписаниеТипов("Число"));
	ТаблицаДиапазонов.Колонки.Добавить("SKU"                   , Новый ОписаниеТипов("Число"));
	
	Если ТаблицаЗапроса.Количество() > 1 Тогда
		
		Для Итератор = 2 По ТаблицаЗапроса.Количество() Цикл
			
			СтрокаПредыдущая = ТаблицаЗапроса[Итератор - 2];
			СтрокаТекущая    = ТаблицаЗапроса[Итератор - 1];
			
			Если СтрокаТекущая.Код - СтрокаПредыдущая.Код > 1 Тогда
				
				СтрокаДиапазона = ТаблицаДиапазонов.Добавить();
				СтрокаДиапазона.НачалоИнтервала        = СтрокаПредыдущая.Код + 1;
				СтрокаДиапазона.КонецИнтервала         = СтрокаТекущая.Код - 1;
				СтрокаДиапазона.КоличествоСвободныхSKU = СтрокаДиапазона.КонецИнтервала - СтрокаДиапазона.НачалоИнтервала;
				СтрокаДиапазона.SKU                    = СтрокаДиапазона.НачалоИнтервала;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ТаблицаДиапазонов;

КонецФункции 

Функция ПолучитьПервоеСводобноеSKU(ТаблицаСвободныхSKU) Экспорт

	Если ТаблицаСвободныхSKU.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;	
	СтрокаТаблицы = ТаблицаСвободныхSKU[0];
	СвободныйSKU = СтрокаТаблицы.SKU;
	СтрокаТаблицы.SKU = СтрокаТаблицы.SKU + 1;
	Если СтрокаТаблицы.SKU > СтрокаТаблицы.КонецИнтервала Тогда
		ТаблицаСвободныхSKU.Удалить(0);
	КонецЕсли;
	
	Возврат СвободныйSKU;
	
КонецФункции

// Очистить регистр
//
Процедура ОчиститьРегистр() Экспорт
	
	НаборЗаписей = РегистрыСведений.КодыТоваровSKU.СоздатьНаборЗаписей();
	НаборЗаписей.Записать();

КонецПроцедуры

// Записать SKU
//
Процедура ЗаписатьSKU(Номенклатура, Характеристика, Упаковка, SKU) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.КодыТоваровSKU.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.SKU = SKU;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Номенклатура   = Номенклатура;
		МенеджерЗаписи.Упаковка       = Упаковка;
		МенеджерЗаписи.Характеристика = Характеристика;
		МенеджерЗаписи.Записать();
	Иначе
		МенеджерЗаписи = РегистрыСведений.КодыТоваровSKU.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Номенклатура   = Номенклатура;
		МенеджерЗаписи.Упаковка       = Упаковка;
		МенеджерЗаписи.Характеристика = Характеристика;
		МенеджерЗаписи.SKU            = SKU;
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Удалить SKU
// 
Процедура УдалитьSKU(Номенклатура, Характеристика, Упаковка, SKU) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.КодыТоваровSKU.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Номенклатура   = Номенклатура;
	МенеджерЗаписи.Характеристика = Характеристика;
	МенеджерЗаписи.Упаковка       = Упаковка;
	МенеджерЗаписи.SKU            = SKU;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Удалить();
	КонецЕсли;
	
 КонецПроцедуры

// Функция выполняет проверку массива номенклатура на наличие SKU
// и в случае необходимости создает отсутствующие SKU
// 
Функция ВыполнитьПроверкуSKU(Номенклатура, НеПроверятьИспользованиеSKU = Ложь) Экспорт
	
	ВерхняяГраница = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ВерхняяГраницаДиапазонаSKUВесовогоТовара");
	НижняяГраница  = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("НижняяГраницаДиапазонаSKUВесовогоТовара");
	Количество     = 0;

	ВыборкаТоваров = ПолучитьРазрезыБезSKU(Номенклатура);   
	
	МаксимальныйКодSKU = ПолучитьМаксимальныйКодSKU(Номенклатура.Весовой, НижняяГраница, ВерхняяГраница);         
		
	Если НЕ ВыборкаТоваров.Пустой() Тогда                                       
		SKU = МаксимальныйКодSKU;
		Выборка = ВыборкаТоваров.Выбрать();
		Итератор = 0;
		Пока Выборка.Следующий() Цикл      
			ЗаписатьSKU(Выборка.Номенклатура, Выборка.Характеристика, Выборка.Упаковка, SKU);
			SKU = SKU + 1;
			Количество = Количество + 1;
		КонецЦикла;  
		  
	КонецЕсли;
	
	Возврат Количество;
	
КонецФункции

// Функция возвращает разрезы Номенклатура - Характеристика - Упаковка
// для которых не заполнено SKU в регистре сведений коды товаров SKU
Функция ПолучитьРазрезыБезSKU(Номенклатура)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
		|ИсходныеДанные.Номенклатура,
		|ИсходныеДанные.Упаковка,
		|ИсходныеДанные.Характеристика
		|ИЗ
		|(ВЫБРАТЬ
		|	ПодЗапрос.Номенклатура КАК Номенклатура,
		|	ПодЗапрос.ВидНоменклатуры КАК ВидНоменклатуры,
		|	ПодЗапрос.НаборУпаковок КАК НаборУпаковок,
		|	ПодЗапрос.Характеристика КАК Характеристика,
		|	Упаковки.Упаковка КАК Упаковка
		|ИЗ
		|	(ВЫБРАТЬ
		|		Номенклатура.Ссылка КАК Номенклатура,
		|		Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
		|		Номенклатура.НаборУпаковок КАК НаборУпаковок,
		|		ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика
		|	ИЗ
		|		Справочник.Номенклатура КАК Номенклатура
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
		|			ПО (ВидыНоменклатуры.Ссылка = Номенклатура.ВидНоменклатуры)
		|	ГДЕ
		|		(НЕ Номенклатура.ЭтоГруппа)
		|		И ВидыНоменклатуры.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать)
		|		И (&ВсеТовары
		|				ИЛИ Номенклатура.Ссылка В (&Ссылка))
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Номенклатура.Ссылка,
		|		Номенклатура.ВидНоменклатуры,
		|		Номенклатура.НаборУпаковок,
		|		ХарактеристикиНоменклатуры.Ссылка
		|	ИЗ
		|		Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
		|			ПО (Номенклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец)
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
		|			ПО (ВидыНоменклатуры.Ссылка = Номенклатура.ВидНоменклатуры)
		|	ГДЕ
		|		(НЕ Номенклатура.ЭтоГруппа)
		|		И ВидыНоменклатуры.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ИндивидуальныеДляНоменклатуры)
		|		И (&ВсеТовары
		|				ИЛИ Номенклатура.Ссылка В (&Ссылка))
		|	ОБЪЕДИНИТЬ ВСЕ
		|	ВЫБРАТЬ
		|		Номенклатура.Ссылка,
		|		Номенклатура.ВидНоменклатуры,
		|		Номенклатура.НаборУпаковок,
		|		ХарактеристикиНоменклатуры.Ссылка
		|	ИЗ
		|		Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
		|			ПО (Номенклатура.ВидНоменклатуры = ХарактеристикиНоменклатуры.Владелец)
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
		|			ПО (ВидыНоменклатуры.Ссылка = ХарактеристикиНоменклатуры.Владелец)
		|	ГДЕ
		|		(НЕ Номенклатура.ЭтоГруппа)
		|		И ВидыНоменклатуры.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ОбщиеДляВидаНоменклатуры)
		|		И (&ВсеТовары
		|				ИЛИ Номенклатура.Ссылка В (&Ссылка))) КАК ПодЗапрос
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ЕСТЬNULL(СпрУпаковки.Ссылка, ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)) КАК Упаковка,
		|			СпрНоменклатура.Ссылка КАК Номенклатура
		|		ИЗ
		|			Справочник.Номенклатура КАК СпрНоменклатура
		|				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиНоменклатуры КАК СпрУпаковки
		|				ПО (СпрУпаковки.Владелец = ВЫБОР
		|						КОГДА СпрНоменклатура.НаборУпаковок = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
		|							ТОГДА СпрНоменклатура.Ссылка
		|						КОГДА СпрНоменклатура.НаборУпаковок <> ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ПустаяСсылка)
		|							ТОГДА СпрНоменклатура.НаборУпаковок
		|						ИНАЧЕ ЛОЖЬ
		|					КОНЕЦ)
		|		ГДЕ
		|			(НЕ СпрНоменклатура.ЭтоГруппа)
		|			И (&ВсеТовары
		|					ИЛИ СпрНоменклатура.Ссылка В (&Ссылка))
		|		ОБЪЕДИНИТЬ
		|		
		|		ВЫБРАТЬ
		|			ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка),
		|			СпрНоменклатура.Ссылка
		|		ИЗ
		|			Справочник.Номенклатура КАК СпрНоменклатура
		|		ГДЕ
		|			(НЕ СпрНоменклатура.ЭтоГруппа)
		|			И (&ВсеТовары
		|					ИЛИ СпрНоменклатура.Ссылка В (&Ссылка))) КАК Упаковки
		|		ПО ПодЗапрос.Номенклатура = Упаковки.Номенклатура) КАК ИсходныеДанные
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|	ПО ИсходныеДанные.Номенклатура = КодыТоваровSKU.Номенклатура
		|		И ИсходныеДанные.Характеристика = КодыТоваровSKU.Характеристика
		|		И ИсходныеДанные.Упаковка = КодыТоваровSKU.Упаковка
		|ГДЕ  
		|КодыТоваровSKU.SKU ЕСТЬ NULL");
	
	Запрос.УстановитьПараметр("ВсеТовары", Номенклатура=Неопределено);
	Запрос.УстановитьПараметр("Ссылка", Номенклатура);
	Возврат Запрос.Выполнить();

КонецФункции

 
