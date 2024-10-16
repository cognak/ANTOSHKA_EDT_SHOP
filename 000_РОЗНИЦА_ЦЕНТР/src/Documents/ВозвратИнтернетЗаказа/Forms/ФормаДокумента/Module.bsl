
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ТоварыВыбраны = Ложь;

		Если Параметры.Основание = Неопределено Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ можна створювати тільки на підставі!");
			Отказ = Истина;
			
		Иначе
			
			ТоварыВыбраны = (ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.ЭлектроннаяНакладная"));

		КонецЕсли;
		
		
	Иначе
		
		ТоварыВыбраны = Истина;

	КонецЕсли;
	
	КомментарийКВозврату.Параметры.УстановитьЗначениеПараметра("Документ", Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОтображениеЭлементов();
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница.Имя = "ГруппаТовары" И Не ТоварыВыбраны Тогда
		
		ОткрытиеФормыПодбора();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТипВозвратаПриИзменении(Элемент)
	
	ОтображениеЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыВозвращенноеКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ЗаказыПокупателейКлиентСервер.ПодсчетСтрокиВозврата(Объект.ДокументОснование, ТекущаяСтрока);

	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзЗаказа(Команда)

	ОткрытиеФормыПодбора();

 КонецПроцедуры

&НаКлиенте
Процедура СоздатьЭлектроннуюНакладную(Команда)

	Если Модифицированность или Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Сначало запишите документ");
	
	Иначе
	
		ОповещениеПослеОтметкиЭлементов = Новый ОписаниеОповещения(
	     "ЗавершениеВводаНомерЭН", ЭтотОбъект
		 );	
	
		ПараметрыДляФормы = Новый Структура("ВозвратныйДокумент", Объект.Ссылка);
		ОткрытьФорму("Документ.ВозвратИнтернетЗаказа.Форма.ФормаСозданияЭН",
				ПараметрыДляФормы,
				ЭтотОбъект,
				,
				,
				,
				ОповещениеПослеОтметкиЭлементов,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтображениеЭлементов()
	
	ТипВозвратаМагазин = (Объект.ТипВозврата = ПредопределенноеЗначение("Перечисление.ТипыВозвратаИнтернетЗаказа.ВозвратМагазин"));
	
	Элементы.ГруппаЭлектроннойНакладной.Видимость = Не ТипВозвратаМагазин;
	Элементы.ГруппаМагазина.Видимость = ТипВозвратаМагазин;
	ВидимостьЭН = Объект.ЭлектроннаяНакладная.Пустая();
	Элементы.ЭлектроннаяНакладная.Видимость = Не ВидимостьЭН;
	Элементы.СоздатьЭлектроннуюНакладную.Видимость = ВидимостьЭН;

КонецПроцедуры

&НаСервере
Функция ЗаполнитьИзЗаказа()
	
	Результат = Новый Массив;

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаВозврата.КлючСвязиЗапросаДоступности КАК КлючСвязиЗапросаДоступности,
		|	ТаблицаВозврата.КоличествоУпаковок КАК КоличествоУпаковок,
		|	&ЗаказПокупателя КАК ЗаказПокупателя
		|ПОМЕСТИТЬ ТаблицаВозврата
		|ИЗ
		|	&ТаблицаВозврата КАК ТаблицаВозврата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
		|	ЕСТЬNULL(ТаблицаВозврата.КоличествоУпаковок, 0) КАК КоличествоУпаковок,
		|	ТаблицаТоваров.КоличествоУпаковок КАК КоличествоВЗаказе,
		|	ТаблицаТоваров.Упаковка КАК Упаковка,
		|	ТаблицаТоваров.КлючСвязиЗапросаДоступности КАК КлючСвязиЗапросаДоступности,
		|	ВозвратИнтернетЗаказаТовары.КоличествоУпаковок КАК КоличествоУпаковокВВозвратах,
		|	ТаблицаСостоянияСтрок.ЗапросДоступностиТоваров КАК ДокументЗаказа
		|ИЗ
		|	Документ.ЗаказПокупателя.Товары КАК ТаблицаТоваров
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаВозврата КАК ТаблицаВозврата
		|		ПО ТаблицаВозврата.КлючСвязиЗапросаДоступности = ТаблицаТоваров.КлючСвязиЗапросаДоступности
		|		И ТаблицаВозврата.ЗаказПокупателя = ТаблицаТоваров.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратИнтернетЗаказа.Товары КАК ВозвратИнтернетЗаказаТовары
		|		ПО НЕ ВозвратИнтернетЗаказаТовары.Ссылка = &ТекущийВозврат
		|		И ТаблицаТоваров.КлючСвязиЗапросаДоступности = ВозвратИнтернетЗаказаТовары.КлючСвязиЗапросаДоступности
		|		И ВозвратИнтернетЗаказаТовары.Ссылка.ДокументОснование = ТаблицаТоваров.Ссылка
		|		И НЕ ВозвратИнтернетЗаказаТовары.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВозвратаЗаказаПокупателя.Отменён)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеСтрокЗаказаПокупателя КАК ТаблицаСостоянияСтрок
		|		ПО ТаблицаТоваров.Ссылка = ТаблицаСостоянияСтрок.ЗаказПокупателя
		|		И ТаблицаТоваров.КлючСвязиЗапросаДоступности = ТаблицаСостоянияСтрок.КлючСвязи
		|ГДЕ
		|	ТаблицаТоваров.Ссылка = &ЗаказПокупателя";
	
	Запрос.УстановитьПараметр("ЗаказПокупателя", Объект.ДокументОснование);
	Запрос.УстановитьПараметр("ТаблицаВозврата", Объект.Товары.Выгрузить());
	Запрос.УстановитьПараметр("ТекущийВозврат", Объект.Ссылка);

	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТЗ Из РезультатЗапроса Цикл
		
		Результат.Добавить(ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТЗ));

	КонецЦикла;

	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ОткрытиеФормыПодбора()

	ОповещениеПослеОтметкиЭлементов = Новый ОписаниеОповещения(
	     "ПослеОтметкиЭлементов", ЭтотОбъект
	 );	
 
	ПараметрыДляФормы = Новый Структура("ПараметрыФормы", ЗаполнитьИзЗаказа());
	ОткрытьФорму("Документ.ВозвратИнтернетЗаказа.Форма.ФормаВыбораИзЗаказа",
			ПараметрыДляФормы,
			ЭтотОбъект,
			,
			,
			,
			ОповещениеПослеОтметкиЭлементов,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ПослеОтметкиЭлементов(Элементы, Параметры) Экспорт
 
    Если ТипЗнч(Элементы) = Тип("Массив") Тогда
    	Объект.Товары.Очистить();
        Для Каждого СтрокаВозврата Из Элементы Цикл
        	
        	Если Не СтрокаВозврата.КоличествоУпаковок = 0 Тогда
				
				ТоварыВыбраны = Истина;
				НоваяСтрока = Объект.Товары.Добавить();
        	
        		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаВозврата);
        		НоваяСтрока.ВозвращенноеКоличествоУпаковок = НоваяСтрока.КоличествоУпаковок; 
        		
        		ЗаказыПокупателейКлиентСервер.ПодсчетСтрокиВозврата(Объект.ДокументОснование, НоваяСтрока);
        		       		
        	КонецЕсли;

        КонецЦикла;
    КонецЕсли;
    
    Объект.СуммаДокумента = Объект.Товары.Итог("Сумма");
 
КонецПроцедуры

&НаСервере
Функция ТоварыВозвращенноеКоличествоУпаковокПриИзмененииНаСервере(КлючСвязи)

	СтруктураОтвет = Новый Структура;
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаказПокупателяТовары.Цена,
		|	ЗаказПокупателяТовары.СуммаАвтоматическойСкидки,
		|	ЗаказПокупателяТовары.СуммаБонусныхБалловНачислено,
		|	ЗаказПокупателяТовары.СуммаБонусныхБалловСписано,
		|	ЗаказПокупателяТовары.СуммаОкругления,
		|	ЗаказПокупателяТовары.СуммаРучнойСкидки,
		|	ЗаказПокупателяТовары.Сумма
		|ИЗ
		|	Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
		|ГДЕ
		|	ЗаказПокупателяТовары.Ссылка = &Ссылка
		|	И ЗаказПокупателяТовары.КлючСвязиЗапросаДоступности = &КлючСвязиЗапросаДоступности";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
	Запрос.УстановитьПараметр("КлючСвязиЗапросаДоступности", КлючСвязи);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	СтруктураОтвет = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(РезультатЗапроса[0]);
	
	Возврат СтруктураОтвет;

КонецФункции

&НаКлиенте 
Процедура ЗавершениеВводаНомерЭН(Результат, Параметры) Экспорт 
	
	Если ТипЗнч(Результат) = Тип("ДокументСсылка.ЭлектроннаяНакладная") Тогда
		
		Объект.ЭлектроннаяНакладная = Результат;
		Записать();
	
	КонецЕсли;
	
	ОтображениеЭлементов();
	
КонецПроцедуры

#КонецОбласти