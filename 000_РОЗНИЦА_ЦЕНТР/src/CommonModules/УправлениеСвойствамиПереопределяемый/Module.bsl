////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Заполняет наборы свойств объекта. Обычно требуется, если наборов более одного.
//
// Параметры:
//  Объект       - Ссылка на владельца свойств.
//                 Объект владельца свойств.
//                 ДанныеФормыСтруктура (по типу объекта владельца свойств).
//
//  ТипСсылки    - Тип - тип ссылки владельца свойств.
//
//  НаборыСвойств - ТаблицаЗначений с колонками:
//                    Набор - СправочникСсылка.НаборыДополнительныхРеквизитовИСведений.
//
//                    // Далее свойства элемента формы типа ГруппаФормы вида обычная группа
//                    // или страница, которая создается, если наборов больше одного без учета
//                    // пустого набора, который описывает свойства группы удаленных реквизитов.
//                    
//                    // Если значение Неопределено, значит использовать значение по умолчанию.
//                    
//                    // Для любой группы управляемой формы.
//                    Высота                   - Число.
//                    Заголовок                - Строка.
//                    Подсказка                - Строка.
//                    РастягиватьПоВертикали   - Булево.
//                    РастягиватьПоГоризонтали - Булево.
//                    ТолькоПросмотр           - Булево.
//                    ЦветТекстаЗаголовка      - Цвет.
//                    Ширина                   - Число.
//                    ШрифтЗаголовка           - Шрифт.
//                    
//                    // Для обычной группы и страницы.
//                    Группировка              - ГруппировкаПодчиненныхЭлементовФормы.
//                    
//                    // Для обычной группы.
//                    Отображение                - ОтображениеОбычнойГруппы.
//                    ШиринаПодчиненныхЭлементов - ШиринаПодчиненныхЭлементовФормы.
//                    
//                    // Для страницы.
//                    Картинка                 - Картинка.
//                    ОтображатьЗаголовок      - Булево.
//
//  СтандартнаяОбработка - Булево - начальное значение Истина. Указывает получать ли
//                         основной набор, когда НаборыСвойств.Количество() равно нулю.
//
Процедура ЗаполнитьНаборыСвойствОбъекта(Объект, ТипСсылки, НаборыСвойств, СтандартнаяОбработка) Экспорт
	
	Если ТипСсылки = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
		
		ПолучитьНаборыСвойствДляХарактеристикНоменклатуры(Объект, ТипСсылки, НаборыСвойств);
		
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка.Номенклатура") И НЕ Объект.ЭтоГруппа Тогда
		
		ПолучитьНаборыСвойствДляНоменклатуры(Объект, ТипСсылки, НаборыСвойств);
		
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка.Контрагенты") Тогда
		
		ПолучитьНаборыСвойствДляКонтрагента(Объект, ТипСсылки, НаборыСвойств);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает имя реквизита, содержащего вид владельцев свойств (если есть).
// Если возвращается имя реквизита, то вид владельцев свойств
// (например, вид номенклатуры), должен содержать реквизит НаборСвойств
// типа СправочникСсылка.НаборыДополнительныхРеквизитовИСведений.
//
// Параметры:
//  Ссылка       - Ссылка владельца свойств.
//
// Возвращаемые значения:
//  Строка - имя реквизита или пустая строка.
//
Функция ПолучитьИмяРеквизитаВидаОбъекта(Ссылка) Экспорт
	
	
	
	Возврат "";
	
КонецФункции



////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ДЛЯ РАБОТЫ СО СПРАВОЧНИКОМ ХАРАКТЕРИСТИКИ НОМЕНКЛАТУРЫ

Процедура ПолучитьНаборыСвойствДляХарактеристикНоменклатуры(ХарактеристикаНоменклатуры, ТипСсылки, НаборыСвойств) Экспорт
	
	Если ТипЗнч(ХарактеристикаНоменклатуры) = ТипСсылки Тогда
		Объект = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ХарактеристикаНоменклатуры, "Владелец");
	Иначе
		Объект = ХарактеристикаНоменклатуры;
	КонецЕсли;
	
	Строка = НаборыСвойств.Добавить();
	Строка.Набор = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_ХарактеристикиНоменклатуры_Общие;
	Строка.Заголовок = НСтр("ru = 'Общие свойства характеристик'");
	Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	Строка.ОтображатьЗаголовок = Истина;
	
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
		
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = Справочники.ВидыНоменклатуры.ПолучитьНаборСвойствХарактеристик(Объект.Владелец);
		Строка.Заголовок = НСтр("ru = 'Свойства характеристик для вида номенклатуры'");
		Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Строка.ОтображатьЗаголовок = Истина;
		
	ИначеЕсли ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Объект.Владелец);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			
			Строка = НаборыСвойств.Добавить();
			Строка.Набор = Справочники.ВидыНоменклатуры.ПолучитьНаборСвойствХарактеристик(Выборка.ВидНоменклатуры);
			Строка.Заголовок = НСтр("ru = 'Свойства характеристик для вида номенклатуры'");
			Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
			Строка.ОтображатьЗаголовок = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	// Свойства группы удаленных реквизитов.
	Строка = НаборыСвойств.Добавить();
	Строка.Набор = Справочники.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка();
	Строка.Заголовок = НСтр("ru = 'Более не используемые реквизиты'");
	Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	Строка.ОтображатьЗаголовок = Истина;
	
КонецПроцедуры // ПолучитьНаборыСвойствДляХарактеристикНоменклатуры()

Процедура ПолучитьНаборыСвойствДляНоменклатуры(Номенклатура, ТипСсылки, НаборыСвойств) Экспорт
	
	Если ТипЗнч(Номенклатура) = ТипСсылки Тогда
		Объект = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Номенклатура, "ВидНоменклатуры, ЭтоГруппа");
	Иначе
		Объект = Номенклатура;
	КонецЕсли;
	
	Если Объект.ЭтоГруппа = Ложь Тогда
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Номенклатура_Общие;
		Строка.Заголовок = НСтр("ru = 'Общие свойства'");
		Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Строка.ОтображатьЗаголовок = Истина;
		
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = Справочники.ВидыНоменклатуры.ПолучитьНаборСвойств(Объект.ВидНоменклатуры);
		Строка.Заголовок = НСтр("ru = 'Свойства для вида номенклатуры'");
		Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Строка.ОтображатьЗаголовок = Истина;
		
		// Свойства группы удаленных реквизитов.
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = Справочники.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка();
		Строка.Заголовок = НСтр("ru = 'Более не используемые реквизиты'");
		Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Строка.ОтображатьЗаголовок = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПолучитьНаборыСвойствДляНоменклатуры()

Процедура ПолучитьНаборыСвойствДляКонтрагента(Контрагент, ТипСсылки, НаборыСвойств) Экспорт
	
	Если ТипЗнч(Контрагент) = ТипСсылки Тогда
		Объект = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Контрагент, "ЭтоГруппа");
	Иначе
		Объект = Контрагент;
	КонецЕсли;
	
	Если Объект.ЭтоГруппа = Ложь Тогда
		
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Контрагенты;
		Строка.Заголовок = НСтр("ru = 'Дополнительные свойства контрагента'");
		Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Строка.ОтображатьЗаголовок = Истина;
		
		// Свойства группы удаленных реквизитов.
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = Справочники.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка();
		Строка.Заголовок = НСтр("ru = 'Более не используемые реквизиты'");
		Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Строка.ОтображатьЗаголовок = Истина;
		
	КонецЕсли;
	
КонецПроцедуры // ПолучитьНаборыСвойствДляНоменклатуры()

