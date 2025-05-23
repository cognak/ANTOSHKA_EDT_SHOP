
&НаСервере
Процедура НайтиВАрхивеНаСервереПоТелефону()
	Объект.НайденныеКлиенты.Очистить();
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИсторияИзмененияРеквизитовНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
		|	ИсторияИзмененияРеквизитовНоменклатурыСрезПоследних.ЗначенияПолей КАК ЗначенияПолей
		|ИЗ
		|	РегистрСведений.ИсторияИзмененияРеквизитовНоменклатуры.СрезПоследних КАК ИсторияИзмененияРеквизитовНоменклатурыСрезПоследних
		|ГДЕ
		|	НЕ ИсторияИзмененияРеквизитовНоменклатурыСрезПоследних.Номенклатура.ЭтоГруппа
		|	И ИсторияИзмененияРеквизитовНоменклатурыСрезПоследних.Номенклатура.Архивный";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СтрокуJSONВСтруктуру = КонтактнаяИнформацияСлужебный.ДесериализацияТелефона(ВыборкаДетальныеЗаписи.ЗначенияПолей);
		
		Если "+"+СокрЛП(СтрокуJSONВСтруктуру.Представление)  = СтрЗаменить(ЗначениеРеквизита," ","") Тогда
			СтрКонтрагентов = Объект.НайденныеКлиенты.Добавить();
			СтрКонтрагентов.Восстановить = Истина;
			СтрКонтрагентов.Контрагент = ВыборкаДетальныеЗаписи.Номенклатура;
			СтрКонтрагентов.Данные =  ВыборкаДетальныеЗаписи.ЗначенияПолей;
			Прервать;
		КонецЕсли;
			                              
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НайтиВАрхивеНаСервереПоЕМАИЛ()
	Объект.НайденныеКлиенты.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтрагентыКонтактнаяИнформация.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
		|ГДЕ
		|	КонтрагентыКонтактнаяИнформация.Ссылка.Родитель = &ГруппаАрхив
		|	И НЕ КонтрагентыКонтактнаяИнформация.Ссылка.ЭтоГруппа
		|	И НЕ КонтрагентыКонтактнаяИнформация.Ссылка.ПометкаУдаления
		|	И КонтрагентыКонтактнаяИнформация.Ссылка.Архивный
		|	И КонтрагентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
		|	И КонтрагентыКонтактнаяИнформация.АдресЭП = &АдресЭП";
	
	Запрос.УстановитьПараметр("АдресЭП", ЗначениеРеквизита);
	Запрос.УстановитьПараметр("ГруппаАрхив", Справочники.Контрагенты.НайтиПоКоду("000-0431748"));
	
	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрКонтрагентов = Объект.НайденныеКлиенты.Добавить();
		СтрКонтрагентов.Восстановить = Истина;
		СтрКонтрагентов.Контрагент = ВыборкаДетальныеЗаписи.Ссылка;
		//СтрКонтрагентов.Данные =  ВыборкаДетальныеЗаписи.ЗначенияПолей;
		Прервать;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиВАрхиве(Команда)
	Если КлючРеквизита = 0 ТОгда
		НайтиВАрхивеНаСервереПоТелефону();
	Иначе
		НайтиВАрхивеНаСервереПоЕМАИЛ();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНаСервере()
	
	Для Каждого СтрТ Из Объект.НайденныеКлиенты Цикл
		
		Если НЕ СтрТ.Восстановить тогда
			Продолжить;
		КонецЕсли;
		
		ОБКонтрагент = СтрТ.Контрагент.ПолучитьОбъект();
		
		//ОБКонтрагент = Справочники.Контрагенты.СоздатьЭлемент();
		
		Поиск = Новый Структура("Тип,Вид",Перечисления.ТипыКонтактнойИнформации.Телефон,Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента);
		Телефон =  ОБКонтрагент.КонтактнаяИнформация.НайтиСтроки(Поиск);
		
		Если Телефон = Неопределено или Телефон.Количество() = 0 Тогда
			Стр = ОБКонтрагент.КонтактнаяИнформация.Добавить();
			//Стр.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента;
			//СТр.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
			СтрокуJSONВСтруктуру = КонтактнаяИнформацияСлужебный.ДесериализацияТелефона(СтрТ.Данные);
			УправлениеКонтактнойИнформацией.ЗаписатьКонтактнуюИнформацию(ОБКонтрагент, СтрТ.Данные, Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента, Перечисления.ТипыКонтактнойИнформации.Телефон, Стр) ;
		ИначеЕсли Телефон.Количество() > 0 ТОгда
			СтрокуJSONВСтруктуру = КонтактнаяИнформацияСлужебный.ДесериализацияТелефона(СтрТ.Данные);
			УправлениеКонтактнойИнформацией.ЗаписатьКонтактнуюИнформацию(ОБКонтрагент, СтрТ.Данные, Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента, Перечисления.ТипыКонтактнойИнформации.Телефон, Телефон[0]);
		КонецЕсли;	
		
		Попытка
			ОБКонтрагент.Родитель = Справочники.Контрагенты.Покупатели;
			ОБКонтрагент.Архивный = ЛОЖЬ;
			ОБКонтрагент.Записать();
			Сообщить("Записан элемент "+ОБКонтрагент.Наименование+ " " + ОБКонтрагент.Код);
			
			НаборЗаписей = РегистрыСведений.ИсторияИзмененияРеквизитовНоменклатуры.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Номенклатура.Установить(СтрТ.Контрагент);
			НаборЗаписей.Отбор.Реквизит.Установить("ТелефонКонтрагента");
			НаборЗаписей.Записать(Истина);
			Объект.НайденныеКлиенты.Удалить(СтрТ);
			
		Исключение
			Сообщить("НЕ Записан элемент "+ОБКонтрагент.Наименование+ " " + ОБКонтрагент.Код+" "+ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Восстановить(Команда)
	ВосстановитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КлючРеквизитаПриИзменении(Элемент)
	ЗначениеРеквизита = "";
	УстановитьОформлениеЭлементовФормы();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОформлениеЭлементовФормы()

	Если КлючРеквизита = 0 Тогда

		Элементы.ЗначениеРеквизита.Маска          = "+380 99 999 99 99";
		Элементы.ЗначениеРеквизита.ПодсказкаВвода = "+380 99 999 99 99";

	Иначе

		Элементы.ЗначениеРеквизита.Маска          = "";
		Элементы.ЗначениеРеквизита.ПодсказкаВвода = "joker@gmail.com";

	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ЗаполнитьПоУдаленнымНаСервере()
	Объект.НайденныеКлиенты.Очистить();
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИсторияИзмененияРеквизитовНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
		|	ИсторияИзмененияРеквизитовНоменклатурыСрезПоследних.ЗначенияПолей КАК ЗначенияПолей
		|ИЗ
		|	РегистрСведений.ИсторияИзмененияРеквизитовНоменклатуры.СрезПоследних КАК ИсторияИзмененияРеквизитовНоменклатурыСрезПоследних
		|ГДЕ
		|	НЕ ИсторияИзмененияРеквизитовНоменклатурыСрезПоследних.Номенклатура.ЭтоГруппа
		|	И ИсторияИзмененияРеквизитовНоменклатурыСрезПоследних.Номенклатура.Архивный";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СтрокуJSONВСтруктуру = КонтактнаяИнформацияСлужебный.ДесериализацияТелефона(ВыборкаДетальныеЗаписи.ЗначенияПолей);
		
		СтрКонтрагентов = Объект.НайденныеКлиенты.Добавить();
		СтрКонтрагентов.Восстановить = ЛОЖЬ;
		СтрКонтрагентов.Контрагент = ВыборкаДетальныеЗаписи.Номенклатура;
		СтрКонтрагентов.Данные =  ВыборкаДетальныеЗаписи.ЗначенияПолей;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоУдаленным(Команда)
	ЗаполнитьПоУдаленнымНаСервере();
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)  
	//ЭтоАдмин = Пользователи.ЭтоПолноправныйПользователь();
	Если НЕ РольДоступна("АрхивированиеРазархивированиеКлиентов") ТОгда
		
		Сообщить("У Вас нет прав на открытие обработки!");
		Отказ = Истина;
		
	КонецЕсли;

	АдминРежим = ЛОЖЬ;
	Элементы.АдминРежим.Видимость = АдминРежим;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьЭлементов()
	Элементы.ОбычныйРежимГруппа.Видимость = НЕ АдминРежим;
	Элементы.АдминРежимГруппа.Видимость = АдминРежим;
КонецПроцедуры

&НаКлиенте
Процедура АдминРежимПриИзменении(Элемент)
	УстановитьВидимостьЭлементов();
КонецПроцедуры

&НаСервере
Процедура НайденныеКлиентыВостанновить1ПриИзмененииНаСервере(Контрагент,Восстановить)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнформационныеКарты.Ссылка КАК Ссылка,
		|	ИнформационныеКарты.ВладелецКарты КАК ВладелецКарты
		|ИЗ
		|	Справочник.ИнформационныеКарты КАК ИнформационныеКарты
		|ГДЕ
		|	ИнформационныеКарты.ВладелецКарты = &Контрагент
		|	И ИнформационныеКарты.Блокирован
		|	И НЕ ИнформационныеКарты.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ПараметрыОтбора  = Новый Структура("ИнформационныеКарты",ВыборкаДетальныеЗаписи.Ссылка);
		СтрокиКарт = Объект.СкидочныеКарты.НайтиСтроки(ПараметрыОтбора);
		
		Если СтрокиКарт.количество() > 0 Тогда
			Для Каждого СтрКарт Из СтрокиКарт Цикл
				СтрКарт.Восстановить =  Восстановить;
			КонецЦикла;
		Иначе
			СтрКарт = Объект.СкидочныеКарты.Добавить();
			СтрКарт.Восстановить = Восстановить;
			СтрКарт.ИнформационныеКарты = ВыборкаДетальныеЗаписи.Ссылка;
			СтрКарт.Контрагент = ВыборкаДетальныеЗаписи.ВладелецКарты;
		КонецЕсли;
		
	КонецЦикла;		
КонецПроцедуры

&НаКлиенте
Процедура НайденныеКлиентыВостанновить1ПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.НайденныеКлиенты1.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		НайденныеКлиентыВостанновить1ПриИзмененииНаСервере(ТекущаяСтрока.Контрагент,ТекущаяСтрока.Восстановить);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьАдмНаСервере()
	
	ВосстановитьНаСервере();
	ВосстановитьСкидочныеНаСервере();
	Объект.НайденныеКлиенты.Очистить();
	Объект.СкидочныеКарты.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьАдм(Команда)
	ВосстановитьАдмНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВосстановитьСкидочныеНаСервере()
	
	Для Каждого СтрКарт Из Объект.СкидочныеКарты Цикл
		Если НЕ СтрКарт.Восстановить ТОгда
			Продолжить;
		КонецЕсли;
		ИнформационнаяКарта = СтрКарт.ИнформационныеКарты.ПолучитьОбъект();
		ИнформационнаяКарта.ДатаЗакрытия = Дата(1,1,1);
		ИнформационнаяКарта.Блокирован = ЛОЖЬ;
		ИнформационнаяКарта.Записать();
		
	КонецЦикла;
	
КонецПроцедуры





