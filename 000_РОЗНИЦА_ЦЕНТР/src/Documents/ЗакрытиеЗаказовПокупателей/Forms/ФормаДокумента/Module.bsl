#Область ОбработчикиОсновныхСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;
	
//	Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);

	ОбщегоНазначенияРТ.ЗаполнитьШапкуДокумента(Объект,КартинкаСостоянияДокумента, СостояниеДокумента, РазрешеноПроведение);

	УправлениеДоступомРТ.ПриСозданииФормыНаСервере(ЭтотОбъект);	//	LNK 17.10.2019 14:30:01
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

//	СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
//	Конец СтандартныеПодсистемы.Свойства

	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(Объект, СостояниеДокумента, КартинкаСостоянияДокумента, РазрешеноПроведение);

	УстановитьУникальныйИдентификатор();

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(Объект, СостояниеДокумента, КартинкаСостоянияДокумента, РазрешеноПроведение);

	ОповеститьОбИзменении(Тип("ДокументСсылка.ЗаказПокупателя"));

КонецПроцедуры

&НаСервере	//	LNK 05.01.2021 08:10:50
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	УстановитьУникальныйИдентификатор();

КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура МагазинПриИзменении(Элемент)

	УстановитьОрганизациюПоМагазину();

КонецПроцедуры

&НаКлиенте
Процедура РеестрЗаказПокупателяПриИзменении(Элемент)

	УстановитьУникальныйИдентификатор(Элементы.Реестр.ТекущаяСтрока);

КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьВсеПросроченныеРезервы(Команда)

	ПолучитьВсеПросроченныеРезервыНаСервере();

КонецПроцедуры
	
#КонецОбласти

#Область ПоддержкаФункционалаФормы

&НаСервере
Процедура ПолучитьВсеПросроченныеРезервыНаСервере()

	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьРеестрПросроченнымиРезевами();

	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");

	УстановитьУникальныйИдентификатор();

КонецПроцедуры

&НаСервере
Процедура УстановитьУникальныйИдентификатор(ТекущаяСтрока = Неопределено)

	Если ТекущаяСтрока = Неопределено Тогда

		КоллекцияСтрок = Объект.Реестр;

	Иначе

		КоллекцияСтрок = Новый Массив;
		КоллекцияСтрок.Добавить(Объект.Реестр.НайтиПоИдентификатору(ТекущаяСтрока));
	
	КонецЕсли;

	Для каждого СтрокаРеестра Из КоллекцияСтрок Цикл

		СтрокаРеестра.УникальныйИдентификатор = СтрокаРеестра.ЗаказПокупателя.УникальныйИдентификатор();

	КонецЦикла;

КонецПроцедуры

&НаСервере	//	LNK 15.07.2023 07:36:29
Процедура УстановитьОрганизациюПоМагазину()

	Объект.Организация = Документы.ЗакрытиеЗаказовПокупателей.УстановитьОрганизациюПоМагазину(Объект.Магазин);

КонецПроцедуры

//А++ 20250121 по задаче Сергея 
&НаСервере
Функция  ВернутьПраваАдмина()
	Возврат Документы.ЗакрытиеЗаказовПокупателей.ВернутьПраваАдминистратора();
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ВернутьПраваАдмина() Тогда
		Предупреждение(НСтр("ru = 'Доступ запрещен!'; uk = 'Доступ заборонено!'"),,"Ошибка доступа!");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры
//А++ 20250121 по задаче Сергея 


#КонецОбласти




