
///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Для предопределенных элементов получает правильный код операции
//
// Параметры:
//  ИмяПредопределенногоЭлемента - строка имя предопределенного элемента
//
// Возвращаемое значение:
//  Перечисление.ХозяйственныеОперации 
//
Функция ПолучитьПравильнуюХозяйственнуюОперацию(ИмяПредопределенногоЭлемента = "") Экспорт

	Если Ссылка = Справочники.АналитикаХозяйственныхОпераций.ВозвратОтПокупателя Тогда
		
		ИмяПредопределенногоЭлемента = "Возврат от покупателя";
		Возврат Перечисления.ХозяйственныеОперации.ВозвратОтПокупателя;

	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ВозвратПоставщику Тогда
		
		ИмяПредопределенногоЭлемента = "Возврат поставщику";
		Возврат Перечисления.ХозяйственныеОперации.ВозвратПоставщику;

	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.КомплектацияНоменклатуры Тогда
		
		ИмяПредопределенногоЭлемента = "Комплектация номенклатуры";
		Возврат Перечисления.ХозяйственныеОперации.КомплектацияНоменклатуры;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ОприходованиеТоваров Тогда
		
		ИмяПредопределенногоЭлемента = "Оприходование товаров";
		Возврат Перечисления.ХозяйственныеОперации.Оприходование;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПередачаТоваровДоРеализации Тогда
		
		ИмяПредопределенногоЭлемента = "Передача товаров до реализации";
		Возврат Перечисления.ХозяйственныеОперации.ПередачаТоваровДоРеализации;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПередачаТоваровПослеРеализации Тогда
		
		ИмяПредопределенногоЭлемента = "Передача товаров после реализации";
		Возврат Перечисления.ХозяйственныеОперации.ПередачаТоваровПослеРеализации;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПеремещениеТоваров Тогда
		
		ИмяПредопределенногоЭлемента = "Перемещение товаров";
		Возврат Перечисления.ХозяйственныеОперации.ПеремещениеТоваров;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПересортицаТоваров Тогда
		
		ИмяПредопределенногоЭлемента = "Пересортица товаров";
		Возврат Перечисления.ХозяйственныеОперации.ПересортицаТоваров;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПогашениеПодарочныхСертификатов Тогда
		
		ИмяПредопределенногоЭлемента = "Погашение подарочных сертификатов";
		Возврат Перечисления.ХозяйственныеОперации.ПогашениеПодарочныхСертификатов;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПоступлениеТоваров Тогда
		
		ИмяПредопределенногоЭлемента = "Поступление товаров";
		Возврат Перечисления.ХозяйственныеОперации.ПоступлениеТоваров;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПриемТоваровОтДругойОрганизации Тогда
		
		ИмяПредопределенногоЭлемента = "Прием товаров от другой организации";
		Возврат Перечисления.ХозяйственныеОперации.ПриемТоваровОтДругойОрганизации;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.РеализацияТоваров Тогда
		
		ИмяПредопределенногоЭлемента = "Реализация товаров";
		Возврат Перечисления.ХозяйственныеОперации.РеализацияТоваров;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПередачаПодарочныхСертификатовВПодарок Тогда	//	LNK 15.05.2021 06:40:14
		
		ИмяПредопределенногоЭлемента = "Передача подарочных сертификатов в подарок";
		Возврат Перечисления.ХозяйственныеОперации.РеализацияТоваров;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПродажаПодаркаПодарочныйСертификат Тогда	//	LNK 17.05.2021 06:50:33
		
		ИмяПредопределенногоЭлемента = "Продажа подарка «Подарочный сертификат»";
		Возврат Перечисления.ХозяйственныеОперации.РеализацияТоваров;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.СкидкиПодарки Тогда
		
		ИмяПредопределенногоЭлемента = "Списание на затраты (подарки)";
		Возврат Перечисления.ХозяйственныеОперации.СписаниеНаЗатраты;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ОприходованиеПоИнвентаризации Тогда
		
		ИмяПредопределенногоЭлемента = "Оприходование по инвентаризации";
		Возврат Перечисления.ХозяйственныеОперации.ОприходованиеПоИнвентаризации;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.СписаниеПоИнвентаризации Тогда
		
		ИмяПредопределенногоЭлемента = "Списание по инвентаризации";
		Возврат Перечисления.ХозяйственныеОперации.СписаниеПоИнвентаризации;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.СписаниеНаЗатраты Тогда
		
		ИмяПредопределенногоЭлемента = "Списание на прочие затраты";
		Возврат Перечисления.ХозяйственныеОперации.СписаниеНаЗатраты;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ОприходованиеПоИнвентаризацииСамостоятельной Тогда
		
		ИмяПредопределенногоЭлемента = "Оприходование по инвентаризации самостоятельной";
		Возврат Перечисления.ХозяйственныеОперации.ОприходованиеПоИнвентаризации;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.СписаниеПоИнвентаризацииСамостоятельной Тогда
		
		ИмяПредопределенногоЭлемента = "Списание по инвентаризации самостоятельной";
		Возврат Перечисления.ХозяйственныеОперации.СписаниеПоИнвентаризации;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.СборкаТоваровПодЗаказПокупателя Тогда
		
		ИмяПредопределенногоЭлемента = "Сборка товаров под заказ покупателя";
		Возврат Перечисления.ХозяйственныеОперации.ПеремещениеТоваров;
		
	Иначе
		
		Возврат Перечисления.ХозяйственныеОперации.ПустаяСсылка();
		
	КонецЕсли;

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
    		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтоНовый() Тогда 
		
		Если Предопределенный Тогда
			
			ИмяПредопределенногоЭлемента = "";
			ПравильнаяХозяйственнаяОперация = ПолучитьПравильнуюХозяйственнуюОперацию(ИмяПредопределенногоЭлемента);
			
			Если НЕ ПравильнаяХозяйственнаяОперация = ХозяйственнаяОперация Тогда
				
				ТекстОшибки = НСтр("ru = 'Для этого предопределенного элемента 
				|возможно задать только код хозяйственной
				| "+ИмяПредопределенногоЭлемента+"'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					"ХозяйственнаяОперация",
					,
					Отказ);
							
			КонецЕсли;			
			
		ИначеЕсли ЗначениеЗаполнено(Ссылка.ХозяйственнаяОперация) 
			И Не Ссылка.ХозяйственнаяОперация = ХозяйственнаяОперация Тогда
			
			Если НЕ ПроверитьХозяйственнуюОперацию() Тогда
							
				ТекстОшибки = НСтр("ru = 'Нельзя изменить код хозяйственной операции,
				|так как он используется в документах'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					"ХозяйственнаяОперация",
					,
					Отказ);
						
			КонецЕсли;
						
		КонецЕсли;	
				
	КонецЕсли;	
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Проверяет правильность заполнения кода хозяйственной операции
//
// Параметры:
//  Нет
//
// Возвращаемое значение:
//  Булево - "Истина", если ошибка есть 
//
Функция ПроверитьХозяйственнуюОперацию()

	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВозвратТоваровОтПокупателя.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.ВозвратТоваровОтПокупателя КАК ВозвратТоваровОтПокупателя
	|ГДЕ
	|	ВозвратТоваровОтПокупателя.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВозвратТоваровПоставщику.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
	|ГДЕ
	|	ВозвратТоваровПоставщику.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОтчетОРозничныхПродажахВозвращенныеТовары.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах.ВозвращенныеТовары КАК ОтчетОРозничныхПродажахВозвращенныеТовары
	|ГДЕ
	|	ОтчетОРозничныхПродажахВозвращенныеТовары.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекККМ.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОприходованиеТоваров.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК ОприходованиеТоваров
	|ГДЕ
	|	ОприходованиеТоваров.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СписаниеТоваров.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.СписаниеТоваров КАК СписаниеТоваров
	|ГДЕ
	|	СписаниеТоваров.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации");
	
	Запрос.УстановитьПараметр("АналитикаХозяйственнойОперации", Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Пустой();
	

КонецФункции
