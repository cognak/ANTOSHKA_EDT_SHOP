
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.ПустаяСсылка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьСотрудников();
	ПодключитьОбработчикОжидания("ОбновитьСотрудников", 60);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НовыйТекстНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.Новый");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ВРаботеТекстНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.ВРаботе");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ЗапросДоступностиТекстНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.ЗапросДоступности");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ПеремещениеТекстНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.Перемещение");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ПродажаТекстНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.Продажа");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ВсеТекстНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.ПустаяСсылка");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытыеТекстНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.Закрыт");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ДоставкаТекстНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.Доставка");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура НовыйНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.Новый");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ВРаботеНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.ВРаботе");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ЗапросДоступностиНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.ЗапросДоступности");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ПеремещениеНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.Перемещение");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ПродажаНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.Продажа");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

&НаКлиенте
Процедура ДоставкаНажатие(Элемент)
	
	СтатусыЗаказовПокупателей = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовПокупателей.Доставка");
	УстановитьОтображениеЭлементов(); 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудникиКоллЦентра

&НаКлиенте
Процедура СотрудникиКоллЦентраПриАктивизацииСтроки(Элемент)
	
	Если Элементы.СотрудникиКоллЦентра.ТекущиеДанные = Неопределено Тогда
		Ответственный = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	Иначе
		Ответственный = Элементы.СотрудникиКоллЦентра.ТекущиеДанные.Владелец; 
	КонецЕсли; 
	
	ЗаказыКлиентов.Параметры.УстановитьЗначениеПараметра("Ответственный", Ответственный);
	СотрудникКоллЦентра = ЗаказыПокупателейСервер.ЯвляетсяСотрудникомКоллЦентра(Ответственный).СотрудникКоллЦентра;
	ПодключитьОбработчикОжидания("ОбновитьПриАктивации", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиКоллЦентраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	СотрудникиКоллЦентраПеретаскиваниеНаСервере(ПараметрыПеретаскивания.Значение, СотрудникиКоллЦентра.НайтиПоИдентификатору(Строка).Сотрудник);
	УстановитьОтображениеЭлементов();

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаказыКлиентов

&НаКлиенте
Процедура ЗаказыКлиентовПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)

	СтандартнаяОбработка	=	Ложь;
	Элементы.ЗаказыКлиентов.ВыделенныеСтроки.Добавить(Строка);
	Элементы.ЗаказыКлиентов.Обновить();    

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РаспределитьПоУмолчанию(Команда)
	
	РаспределитьПоУмолчаниюНаСервере();
	УстановитьОтображениеЭлементов(); 
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьВыбранныеЗаказы(Команда)
	РаспределитьВыбранныеЗаказыНаСервере(Элементы.СотрудникиКоллЦентра.ТекущиеДанные.Владелец, Элементы.ЗаказыКлиентов.ВыделенныеСтроки);
	УстановитьОтображениеЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСотрудниковКоллЦетра(Команда)
	ОбновитьСотрудников();
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРаботу(Команда)
	ЗаказыПокупателейСервер.СотрудникНаРаботе(СотрудникКоллЦентра, Ложь);
	ОбновитьСотрудников();  
	Если ЗначениеЗаполнено(СотрудникКоллЦентра) тогда 
		СделатьЗаписьВрегистрУход(СотрудникКоллЦентра);  
	КонецЕсли;
	//СотрудникНаРаботе = ЗаказыПокупателейСервер.СотрудникРаботает(СотрудникКоллЦентра);
	//ОтображениеКнопокКЦ();
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДругомуОператору(Команда)

	
	Оповещение = Новый ОписаниеОповещения("ПередатьДругомуОператоруЗавершение", ЭтотОбъект);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	//ПараметрыФормы.Вставить("ТекущаяСтрока", ?(
	//	Ответственный.Пустая(),
	//	Неопределено,
	//	Ответственный));

	
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыФормы.Вставить("ОтборСотрудниковКЦ", Истина);
	
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, , , , Оповещение);


КонецПроцедуры

&НаКлиенте
Процедура НачатьРаботу(Команда)
	ЗаказыПокупателейСервер.СотрудникНаРаботе(СотрудникКоллЦентра, Истина);  
	ОбновитьСотрудников();   
	Если ЗначениеЗаполнено(СотрудникКоллЦентра) тогда 
		СделатьЗаписьВрегистрПриход(СотрудникКоллЦентра);  
	КонецЕсли;
	
	//СотрудникНаРаботе = ЗаказыПокупателейСервер.СотрудникРаботает(СотрудникКоллЦентра);
	//ОтображениеКнопокКЦ(); 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьСотрудников() 
	
	СотрудникНаРаботе = ЗаказыПокупателейСервер.СотрудникРаботает(СотрудникКоллЦентра);	
	ЗапомнитьУказатель = Элементы.СотрудникиКоллЦентра.ТекущаяСтрока;
	ОбновитьСотрудниковКоллЦетраНаСервере();
	Элементы.СотрудникиКоллЦентра.ТекущаяСтрока = ЗапомнитьУказатель;
    УстановитьОтображениеЭлементов();
	
КонецПроцедуры

// Функция возвращает массив динамических списков, для которых требуется установка отбора.
//
&НаСервере
Функция ПолучитьМассивДинамическихСписковНаСервере()

	МассивСписков = Новый Массив;
	МассивСписков.Добавить(ЗаказыКлиентов);
	
	Возврат МассивСписков;

КонецФункции 

// Процедура устанавливает отбор динамических списков формы.
//
&НаСервере
Процедура УстановитьОтображениеЭлементов()
	
	Для Каждого ДинамическийСписок Из ПолучитьМассивДинамическихСписковНаСервере() Цикл

		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ДинамическийСписок, "Статус"   	 , СтатусыЗаказовПокупателей, ЗначениеЗаполнено(СтатусыЗаказовПокупателей), ВидСравненияКомпоновкиДанных.Равно);
		
	КонецЦикла;
	
	Если СотрудникКоллЦентра.Пустая() Тогда
		Элементы.НачатьРаботу.Видимость = Ложь;
		Элементы.ЗакончитьРаботу.Видимость = Ложь;
	Иначе 
		Элементы.НачатьРаботу.Видимость = Не СотрудникНаРаботе;
		Элементы.ЗакончитьРаботу.Видимость = СотрудникНаРаботе;
	КонецЕсли;

	
	Элементы.Новый.Заголовок				= "0";
	Элементы.ВРаботе.Заголовок				= "0";
	Элементы.ЗапросДоступности.Заголовок	= "0";
	Элементы.Перемещение.Заголовок 			= "0";
    Элементы.Продажа.Заголовок				= "0";
    Элементы.Доставка.Заголовок				= "0";
	
	Элементы.Новый.Гиперссылка				= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.Новый);
	Элементы.ВРаботе.Гиперссылка			= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.ВРаботе);
	Элементы.ЗапросДоступности.Гиперссылка	= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.ЗапросДоступности);
	Элементы.Перемещение.Гиперссылка		= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.Перемещение);
	Элементы.Продажа.Гиперссылка			= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.Продажа);
	Элементы.Доставка.Гиперссылка			= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.Доставка);

	Элементы.НовыйТекст.Гиперссылка				= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.Новый);
	Элементы.ВРаботеТекст.Гиперссылка			= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.ВРаботе);
	Элементы.ЗапросДоступностиТекст.Гиперссылка	= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.ЗапросДоступности);
	Элементы.ПеремещениеТекст.Гиперссылка		= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.Перемещение);
	Элементы.ПродажаТекст.Гиперссылка			= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.Продажа);
	Элементы.ДоставкаТекст.Гиперссылка			= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.Доставка);
	Элементы.ВсеТекст.Гиперссылка				= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.ПустаяСсылка());
	Элементы.ЗакрытыеТекст.Гиперссылка			= Не (СтатусыЗаказовПокупателей = Перечисления.СтатусыЗаказовПокупателей.Закрыт);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СостояниеЗаказаПокупателя.ЗаказПокупателя) КАК Количество,
		|	СостояниеЗаказаПокупателя.Статус КАК Статус
		|ИЗ
		|	РегистрСведений.СостояниеЗаказаПокупателя КАК СостояниеЗаказаПокупателя
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя КАК ТаблицаЗаказ
		|		ПО СостояниеЗаказаПокупателя.ЗаказПокупателя = ТаблицаЗаказ.Ссылка
		|ГДЕ
		|	(ТаблицаЗаказ.УчетнаяСистема = ЗНАЧЕНИЕ(Перечисление.УчетныеСистемыКомпании.ПустаяСсылка)
		|	И ТаблицаЗаказ.Дата >= &НачальнаяДата
		|	ИЛИ ТаблицаЗаказ.УчетнаяСистема = ЗНАЧЕНИЕ(Перечисление.УчетныеСистемыКомпании.Розница))
		|	И (СостояниеЗаказаПокупателя.Ответственный = &Ответственный
		|	ИЛИ &ВсеОтветственный)
		|	И ТаблицаЗаказ.Проведен
		|СГРУППИРОВАТЬ ПО
		|	СостояниеЗаказаПокупателя.Статус";
	
	Запрос.УстановитьПараметр("ВсеОтветственный", Не ЗначениеЗаполнено(Ответственный));
	Запрос.УстановитьПараметр("Ответственный", Ответственный);
	Запрос.УстановитьПараметр("НачальнаяДата", Дата(2023,11,12));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Статус = Перечисления.СтатусыЗаказовПокупателей.Новый Тогда 
			Элементы.Новый.Заголовок				= Выборка.Количество;
		ИначеЕсли Выборка.Статус = Перечисления.СтатусыЗаказовПокупателей.ВРаботе Тогда 
			Элементы.ВРаботе.Заголовок				= Выборка.Количество;
		ИначеЕсли Выборка.Статус = Перечисления.СтатусыЗаказовПокупателей.ЗапросДоступности Тогда 
			Элементы.ЗапросДоступности.Заголовок	= Выборка.Количество;
		ИначеЕсли Выборка.Статус = Перечисления.СтатусыЗаказовПокупателей.Перемещение Тогда 
			Элементы.Перемещение.Заголовок		= Выборка.Количество;
		ИначеЕсли Выборка.Статус = Перечисления.СтатусыЗаказовПокупателей.Продажа Тогда 
			Элементы.Продажа.Заголовок 				= Выборка.Количество;
		ИначеЕсли Выборка.Статус = Перечисления.СтатусыЗаказовПокупателей.Доставка Тогда 
			Элементы.Доставка.Заголовок 			= Выборка.Количество;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПриАктивации()
	ОбновитьСотрудников();  
	ОтключитьОбработчикОжидания("ОбновитьПриАктивации");
КонецПроцедуры

&НаСервере
Процедура РаспределитьПоУмолчаниюНаСервере()
	
	Документы.ЗаказПокупателя.РаспределениеЗаказов();

КонецПроцедуры

&НаСервере
Процедура РаспределитьВыбранныеЗаказыНаСервере(ПользовательРаспределения, Знач МассивЗаказов) 
	
	Документы.ЗаказПокупателя.РаспределениеЗаказов(ПользовательРаспределения, МассивЗаказов);  

КонецПроцедуры

&НаСервере
Процедура ОбновитьСотрудниковКоллЦетраНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СотрудникиКЦ.Ссылка КАК Сотрудник,
		|	СотрудникиКЦ.Наименование КАК Наименование,
		|	СотрудникиКЦ.РольСотрудника КАК РольСотрудника,
		|	ВЫБОР
		|		КОГДА РаботаСотрудниковКоллЦентраСрезПоследних.Период = &Период
		|			ТОГДА ЕСТЬNULL(РаботаСотрудниковКоллЦентраСрезПоследних.НаРаботе, ЛОЖЬ)
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК НаРаботе,
		|	СотрудникиКЦ.Владелец КАК Владелец,
		|	СУММА(ВЫБОР
		|		КОГДА СостояниеЗаказаПокупателя.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПокупателей.Новый)
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК Новый,
		|	СУММА(ВЫБОР
		|		КОГДА СостояниеЗаказаПокупателя.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПокупателей.ВРаботе)
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК ВРаботе,
		|	СУММА(ВЫБОР
		|		КОГДА СостояниеЗаказаПокупателя.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПокупателей.ЗапросДоступности)
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК ЗапросДоступности,
		|	СУММА(ВЫБОР
		|		КОГДА СостояниеЗаказаПокупателя.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПокупателей.Продажа)
		|		ИЛИ СостояниеЗаказаПокупателя.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПокупателей.Доставка)
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК Продажа,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ АктивностьПользователей.Хеш) КАК ВремяАктивности,
		|	МАКСИМУМ(УчетРабочегоВремениФакт.Период) КАК НачалоРаботы
		|ИЗ
		|	Справочник.СотрудникиКоллЦентра КАК СотрудникиКЦ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботаСотрудниковКоллЦентра.СрезПоследних(,) КАК
		|			РаботаСотрудниковКоллЦентраСрезПоследних
		|		ПО РаботаСотрудниковКоллЦентраСрезПоследних.Сотрудник = СотрудникиКЦ.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеЗаказаПокупателя КАК СостояниеЗаказаПокупателя
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя КАК ТаблицаЗаказа
		|			ПО СостояниеЗаказаПокупателя.ЗаказПокупателя = ТаблицаЗаказа.Ссылка
		|			И НЕ ТаблицаЗаказа.ПометкаУдаления
		|		ПО СотрудникиКЦ.Владелец = СостояниеЗаказаПокупателя.Ответственный
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АктивностьПользователей КАК АктивностьПользователей
		|		ПО СотрудникиКЦ.Владелец = АктивностьПользователей.Пользователь
		|		И АктивностьПользователей.Период МЕЖДУ &ДатаС И &ДатаПо
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетРабочегоВремениФакт КАК УчетРабочегоВремениФакт
		|		ПО СотрудникиКЦ.Владелец.ФизЛицо = УчетРабочегоВремениФакт.Сотрудник
		|		И УчетРабочегоВремениФакт.ТипВремени = &ТипВремени
		|		И УчетРабочегоВремениФакт.Период > &Период
		|ГДЕ
		|	НЕ СотрудникиКЦ.НеРаботает
		|	И НЕ СотрудникиКЦ.ПометкаУдаления
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА РаботаСотрудниковКоллЦентраСрезПоследних.Период = &Период
		|			ТОГДА ЕСТЬNULL(РаботаСотрудниковКоллЦентраСрезПоследних.НаРаботе, ЛОЖЬ)
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ,
		|	СотрудникиКЦ.Ссылка,
		|	СотрудникиКЦ.Наименование,
		|	СотрудникиКЦ.РольСотрудника,
		|	СотрудникиКЦ.Владелец
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
	ДатаС  = НачалоДня(ТекущаяДатаСеанса());
	ДатаПо = КонецДня(ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Период", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ДатаС", ДатаС);
	Запрос.УстановитьПараметр("ДатаПо", ДатаПо);
	Запрос.УстановитьПараметр("ТипВремени", Перечисления.ТипВремени.Приход);
	
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("Сотрудник", Выборка.Сотрудник);
		НайденнаяСтрока = СотрудникиКоллЦентра.НайтиСтроки(Отбор);
		Если НайденнаяСтрока.Количество() = 0 Тогда
			СтрокаСотрудника = СотрудникиКоллЦентра.Добавить();
		Иначе 
			СтрокаСотрудника = НайденнаяСтрока[0];
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Выборка.НачалоРаботы) тогда
			НачалоРаботы="";
		Иначе  
			НачалоРаботы=Формат(Выборка.НачалоРаботы,"ДФ=HH:mm");
		КонецЕсли;
		СтрокаСотрудника.Сотрудник 			= Выборка.Сотрудник;
		СтрокаСотрудника.Наименование 		= Выборка.Наименование;
		СтрокаСотрудника.РольСотрудника 	= Выборка.РольСотрудника;
		СтрокаСотрудника.Владелец 			= Выборка.Владелец; 
		СтрокаСотрудника.НовыеЗаказы		= Выборка.Новый; 
		СтрокаСотрудника.ВРАботе 			= Выборка.ВРАботе; 
		СтрокаСотрудника.ЗапросДоступности 	= Выборка.ЗапросДоступности; 
		СтрокаСотрудника.Продажа 			= Выборка.Продажа; 
		СтрокаСотрудника.ВремяАктивности 	= Выборка.ВремяАктивности; 	  
		СтрокаСотрудника.НаРаботе 			= Выборка.НаРаботе; 	
		СтрокаСотрудника.НачалоРаботы		= НачалоРаботы; 	
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СотрудникиКоллЦентраПеретаскиваниеНаСервере(ДокументыПереброски, СотрудникКоллЦентра)  
	
	Для Каждого ДокЗаказа Из ДокументыПереброски Цикл
		Если ДокЗаказа.Статус = Перечисления.СтатусыЗаказовПокупателей.Закрыт
				Или ДокЗаказа.Статус = Перечисления.СтатусыЗаказовПокупателей.Отменён Тогда 
			Продолжить;
		КонецЕсли;
		
		ДокументЗаказаОбъект = ДокЗаказа.ПолучитьОбъект();
		ДокументЗаказаОбъект.Ответственный = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СотрудникКоллЦентра, "Владелец", , );
		ДокументЗаказаОбъект.Записать(); 
		ЗаказыПокупателейСервер.СотрудникНовыйЗаказ(СотрудникКоллЦентра);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СделатьЗаписьВрегистрПриход(СотрудникКоллЦентра)
	Пользователь = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СотрудникКоллЦентра, "Владелец");	
	ФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ФизЛицо");
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		//ТипВремени = ПолучитьТипВремени();
			
		ТекДата = ТекущаяДатаСеанса();	
		Магазин = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин;
		Организация  = Справочники.Магазины.РеквизитыМагазина(Магазин, ТекущаяДатаСеанса()).Организация;	//	LNK 15.11.2023 11:55:13
		НаборЗаписей = РегистрыСведений.УчетРабочегоВремениФакт.СоздатьНаборЗаписей(); 

		НаборЗаписей.Отбор.Организация.Установить(Организация);
		НаборЗаписей.Отбор.Магазин.Установить(Магазин);    
		НаборЗаписей.Отбор.Сотрудник.Установить(ФизЛицо); 
		НаборЗаписей.Отбор.период.Установить(ТекДата); 
		НаборЗаписей.Отбор.ТипВремени.Установить(Перечисления.ТипВремени.Приход); 
		НовЗапись = НаборЗаписей.Добавить();
		НовЗапись.Организация = Организация;
		НовЗапись.Магазин = Магазин;
		НовЗапись.Сотрудник = ФизЛицо;
		НовЗапись.период = ТекДата;
		НовЗапись.ЗаписаноЗаданием = Ложь;
		НовЗапись.ТипВремени = Перечисления.ТипВремени.Приход;
		НаборЗаписей.Записать(Истина);
		УстановитьПривилегированныйРежим(Ложь);
	Исключение
		УстановитьПривилегированныйРежим(Ложь);
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура СделатьЗаписьВрегистрУход(СотрудникКоллЦентра)
	Пользователь = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СотрудникКоллЦентра,"Владелец");
	ФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь,"ФизЛицо");	
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		//ТипВремени = ПолучитьТипВремени();
			
		ТекДата =ТекущаяДатаСеанса();	
		Магазин = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин;
		Организация = ПолучитьОрганизацию(Магазин);
		//Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Магазин,"Организация");
		НаборЗаписей = РегистрыСведений.УчетРабочегоВремениФакт.СоздатьНаборЗаписей(); 
		
		НаборЗаписей.Отбор.Организация.Установить(Организация);
		НаборЗаписей.Отбор.Магазин.Установить(Магазин); 
		НаборЗаписей.Отбор.Сотрудник.Установить(ФизЛицо); 
		НаборЗаписей.Отбор.период.Установить(ТекДата); 
		НаборЗаписей.Отбор.ТипВремени.Установить(Перечисления.ТипВремени.Уход); 
		НовЗапись = НаборЗаписей.Добавить();
		НовЗапись.Организация = Организация;
		НовЗапись.Магазин = Магазин;
		НовЗапись.Сотрудник = ФизЛицо;
		НовЗапись.период = ТекДата;
		НовЗапись.ЗаписаноЗаданием = Ложь;
		НовЗапись.ТипВремени = Перечисления.ТипВремени.Уход;
		НаборЗаписей.Записать(Истина);
		УстановитьПривилегированныйРежим(Ложь);
	Исключение
		УстановитьПривилегированныйРежим(Ложь);
	КонецПопытки;
КонецПроцедуры

&НаСервере
Функция ПолучитьОрганизацию(Магазин)
	ОрганизацИЯ = Справочники.Организации.ПустаяСсылка();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ 
		|	ОрганизацииПодразделенийСрезПоследних.Организация КАК Организация
		|ИЗ
		|	РегистрСведений.ОрганизацииПодразделений.СрезПоследних(&ТекДата, Владелец = &Владелец) КАК ОрганизацииПодразделенийСрезПоследних";
	
	Запрос.УстановитьПараметр("ТекДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Владелец", Магазин);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОрганизацИЯ = ВыборкаДетальныеЗаписи.Организация;	
	КонецЦикла;
	Возврат Организация;
КонецФункции

&НаКлиенте
Процедура ПередатьДругомуОператоруЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат = Неопределено Тогда 
		ПередатьДругомуОператоруНаСервере(Результат, Элементы.ЗаказыКлиентов.ВыделенныеСтроки);  
		УстановитьОтображениеЭлементов();
	КонецЕсли;
	
КонецПроцедуры     

&НаСервере
Процедура ПередатьДругомуОператоруНаСервере(ПолучательЗаказа, Знач МассивДокументов)
	
	Для Каждого ДокументЗаказаСсылка Из МассивДокументов Цикл 
		
		ДокументЗаказа = ДокументЗаказаСсылка.ПолучитьОбъект();
		ДокументЗаказа.Ответственный = ПолучательЗаказа;
		ДокументЗаказа.Записать();  
		ПолучательЗаказаСотрудник = Справочники.СотрудникиКоллЦентра.Выбрать(, ПолучательЗаказа);  
		ПолучательЗаказаСотрудник.Следующий();
		ЗаказыПокупателейСервер.СотрудникНовыйЗаказ(ПолучательЗаказаСотрудник.Ссылка);   
		
	КонецЦикла;
	
КонецПроцедуры 

#КонецОбласти
