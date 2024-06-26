&НаСервере
Перем МассивИспользованныхСерийныхНомеровСервер;
///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;

	Параметры.Свойство("РесурсWebRetailДоступен", РесурсWebRetailДоступен);
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("Магазин", Магазин);	//	LNK 28.02.2024 07:40:20

	ЗаполнитьСписокВыбора(Параметры.МассивСерийныхНомеров);

	// +HVOYA. 24.02.2017 18:25:10, Львова Е.А.
    Если Параметры.Свойство("МассивНеуникальныхСертификатов") Тогда
    	ЗаполнитьСписокВыбораНеуникальнымиСертификатами(Параметры.МассивНеуникальныхСертификатов);
    КонецЕсли;     
    // -HVOYA. 24.02.2017 18:25:13, Львова Е.А.
	
	ИспользованныеСерийныеНомера.ЗагрузитьЗначения(Параметры.МассивИспользованныхСерийныхНомеров);
    
    // +HVOYA. 24.02.2017 20:37:50, Львова Е.А.
    Элементы.Декорация1.Заголовок = Строка("СУМА ВВЕДЕНИХ СЕРТИФІКАТІВ: " + Список.Итог("Номинал") + " грн.");
    // -HVOYA. 24.02.2017 20:37:54, Львова Е.А.
    
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если Источник = "ПодключаемоеОборудование" Тогда

		Если ИмяСобытия = "ScanData" Тогда

			Если Параметр[1] = Неопределено Тогда

					Штрихкод = Параметр[0];

			Иначе	Штрихкод = Параметр[1][1];

			КонецЕсли;

			ТекстСообщения = "";

		//	LNK 20.02.2020 13:24:15
		//	Проверяем номерной сертификат..
			МаскаСертификата = Лев(Штрихкод, ПодарочныеСертификатыПовтИсп.ДлинаМаски());

			Если ПодарочныеСертификатыПовтИсп.МаскиСертификатов().Получить(МаскаСертификата) = Истина Тогда

					МассВозврата = Новый Массив;

			Иначе	МассВозврата = ВернутьСертификатШК(СокрЛП(Штрихкод), ТекстСообщения, "СКАНЕР");

			КонецЕсли;

			Если МассВозврата.Количество() = 0 ИЛИ НЕ ПустаяСтрока(ТекстСообщения) Тогда

				Если ПустаяСтрока(ТекстСообщения) Тогда

					ТекстСообщения = "Дані щодо коду не знайдені: " + Штрихкод;

				КонецЕсли;

				ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМК(ТекстСообщения);

			Иначе

				ДополнитьСписокСертификатов(МассВозврата);

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры
	
#КонецОбласти
//	---------------------------------------------------------------------------------------

&НаСервере
Процедура ЗаполнитьСписокВыбора(МассивСерийныхНомеров)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СерийныеНомера.Владелец КАК ПодарочныйСертификат,
	|	СерийныеНомера.Ссылка КАК СерийныйНомер,
	|	СерийныеНомера.Владелец.Номинал КАК Номинал,
	|	СерийныеНомера.Владелец.ИспользоватьСерийныеНомера КАК ИспользоватьСерийныеНомера
	|ИЗ
	|	Справочник.СерийныеНомера КАК СерийныеНомера
	|ГДЕ
	|	СерийныеНомера.Ссылка В(&МассивСерийныхНомеров)";
	
	Запрос.УстановитьПараметр("МассивСерийныхНомеров", МассивСерийныхНомеров);
	
	Результат = Запрос.Выполнить();
	Список.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

// +HVOYA. 24.02.2017 18:28:17, Львова Е.А.
&НаСервере
Процедура ЗаполнитьСписокВыбораНеуникальнымиСертификатами(МассивНеуникальныхСертификатов)
    
    Если НЕ МассивНеуникальныхСертификатов = Неопределено Тогда
        
        Для каждого Сертификат Из МассивНеуникальныхСертификатов Цикл
            НоваяСтрока = Список.Добавить();
            НоваяСтрока.СерийныйНомер = Справочники.СерийныеНомера.ПустаяСсылка();
            НоваяСтрока.ПодарочныйСертификат = Сертификат.Ссылка;
            НоваяСтрока.Номинал = Сертификат.Номинал;
            НоваяСтрока.ИспользоватьСерийныеНомера = Ложь;    
        КонецЦикла;
        
    КонецЕсли; 
            
КонецПроцедуры
// -HVOYA. 24.02.2017 18:28:20, Львова Е.А.


///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаВниз(Команда)
	
	ПередвинутьПозицию(1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВверх(Команда)
	
	ПередвинутьПозицию(-1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	// + HVOYA 19.11.2016 22:44:38, Латышев А.А.
	Отбор = Новый Структура("ПодарочныйСертификат", ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
	МассивСтрок = Список.НайтиСтроки(Отбор);
	Для каждого Эл Из МассивСтрок Цикл
		Список.Удалить(Эл);
	КонецЦикла; 	
	// - HVOYA 19.11.2016 22:44:38, Латышев А.А.

	Отказ = Ложь;

	Для каждого СтрокаТаблицы Из Список Цикл
		
		Если СтрокаТаблицы.ИспользоватьСерийныеНомера И СтрокаТаблицы.СерийныйНомер.Пустая() Тогда

			Отказ = Истина;
			Прервать;

		КонецЕсли;

	КонецЦикла;
	
	Если НЕ Отказ Тогда

		Закрыть(АдресТаблицыПогашениеПодарочныхСертификатов());

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавить(Команда)
	
	ТекущаяСтрока = Список.Добавить();
	
	ТекущийЭлемент = Элементы.Список;
	Элементы.Список.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
	Элементы.Список.ТекущийЭлемент = Элементы.СписокПодарочныйСертификат;
	Элементы.Список.ИзменитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУдалить(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если Не ТекущиеДанные = Неопределено Тогда
		
		Список.Удалить(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПодарочныйСертификатПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	ЗаполнитьДанныеСтрокиСервер(ТекущаяСтрока.ПодарочныйСертификат, ТекущаяСтрока.Номинал, ТекущаяСтрока.ИспользоватьСерийныеНомера);
	
	ТекущийЭлемент = Элементы.Список;
	Элементы.Список.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
	Элементы.Список.ТекущийЭлемент = Элементы.СписокСерийныйНомер;
	Элементы.Список.ИзменитьСтроку();
    
    // +HVOYA. 24.02.2017 20:37:50, Львова Е.А.
    Элементы.Декорация1.Заголовок = Строка("ЗАГАЛЬНА СУМА ВВЕДЕНИХ СЕРТИФІКАТІВ" + Список.Итог("Номинал"));
    // -HVOYA. 24.02.2017 20:37:54, Львова Е.А.
КонецПроцедуры

&НаКлиенте
Процедура СерийныйНомерПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Отказ = Ложь;
	Если ЗначениеЗаполнено(ТекущаяСтрока.СерийныйНомер) Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("СерийныйНомер", ТекущаяСтрока.СерийныйНомер);
		
		СтрокиТаблицы = Список.НайтиСтроки(СтруктураПоиска);
		
		Если СтрокиТаблицы.Количество() > 1 Тогда
			ТекущаяСтрока.СерийныйНомер = "";
			Отказ = Истина;
			
			ТекстСообщения = "Номер подарункового сертифікату вже було вказано у документі!"; 
			ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМК(ТекстСообщения);
		ИначеЕсли НЕ ИспользованныеСерийныеНомера.НайтиПоЗначению(ТекущаяСтрока.СерийныйНомер) = Неопределено Тогда
			Отказ = Истина;
			
			ТекстСообщения = "Номер подарункового сертифікату вже було вказано у документі!"; 
			ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМК(ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		Элементы.Список.ЗакончитьРедактированиеСтроки(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастьКодаПриИзменении(Элемент)

	ОбработатьВведенныйТекстСерийногоНомера(ЧастьКода, Ложь, Истина)

КонецПроцедуры

&НаКлиенте
Процедура ЧастьКодаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
//	ОбработатьВведенныйТекстСерийногоНомера(Текст, СтандартнаяОбработка, Ложь)
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастьКодаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
//	ОбработатьВведенныйТекстСерийногоНомера(Текст, СтандартнаяОбработка, Истина)
	
КонецПроцедуры

// +HVOYA. 24.02.2017 20:06:55, Львова Е.А.
&НаКлиенте
Процедура РедактироватьТаблицу(Команда)
    
    Если НЕ ЭтотОбъект.ТекущийЭлемент = Элементы.Список Тогда // переходим на редактирование таблицы сертификатов
		ЭтотОбъект.ТекущийЭлемент = Элементы.Список;
	Иначе
		ЭтотОбъект.ТекущийЭлемент = Элементы.Штрихкод; // возвращаемся к строке ввода штрихкода сертификата
	КонецЕсли;
    
КонецПроцедуры
// -HVOYA. 24.02.2017 20:06:58, Львова Е.А.


///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Передвинуть позицию в списке
//
// Параметры:
// Движение = 1 (вниз) или -1 (вверх)
// 
&НаКлиенте
Процедура ПередвинутьПозицию(Движение)
	// Вставить содержимое обработчика.
	Если Список.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено  Тогда
		ИндексСтроки = 0;
	Иначе
		ИндексСтроки = Список.Индекс(ТекущиеДанные);
	КонецЕсли;
	
	ИндексСтроки = ИндексСтроки + Движение;
	
	Если ИндексСтроки > (Список.Количество() - 1) Тогда
		ИндексСтроки = 0;
	ИначеЕсли ИндексСтроки < 0 Тогда
		ИндексСтроки = Список.Количество() - 1;
	КонецЕсли;
	
	ТекущиеДанные = Список[ИндексСтроки];
	Элементы.Список.ТекущаяСтрока = ТекущиеДанные.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВведенныйТекстСерийногоНомера(Текст, СтандартнаяОбработка, ВыводитьСообщения)

	Если ЗначениеЗаполнено(Текст)  Тогда

		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ЭтоРеализация"          , Ложь);
		СтруктураПараметров.Вставить("Дата"                   , ОбщегоНазначенияВызовСервера.ТекущаяДатаСервера());
		СтруктураПараметров.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
		СтруктураПараметров.Вставить("СерийныеНомера"         , Список);

		СтруктураПараметров.Вставить("МассивИспользованныхСерийныхНомеров", ИспользованныеСерийныеНомера.ВыгрузитьЗначения());

		РезультатОбработки = МаркетинговыеАкцииСервер.ОбработатьВведенныйТекстСерийногоНомера(СтруктураПараметров, Текст, СтандартнаяОбработка);

		Если ТипЗнч(РезультатОбработки) = Тип("Структура") Тогда

			СтрокаТаблицы = Список.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, РезультатОбработки);

			ЖурналСобытий.Регистрация("СЕРТИФИКАТЫ", "Примечание"
				, "Метаданные.Справочники.СерийныеНомера"
				, СтрокаТаблицы.ПодарочныйСертификат
				,
				, "[РУЧНОЙ ВВОД]:[СНОМ]:[КОД " + ЧастьКода + "]:WebRetail-" + ВРег(СокрЛП(РесурсWebRetailДоступен)) + Символы.ПС
				+ "Состояние ПС - «НЕ ОБРАБАТЫВАЛОСЬ»"
				, СокрЛП(СтрокаТаблицы.ПодарочныйСертификат)
				, Ложь
			);

			ЧастьКода = "";

		ИначеЕсли ТипЗнч(РезультатОбработки) = Тип("Массив") Тогда
			
			ПараметрыЗаполнения = Новый Структура;
			
			ПараметрыЗаполнения.Вставить("МассивСерийныхНомеров",РезультатОбработки);
			
			РезультатВыбора = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораСерийногоНомера",ПараметрыЗаполнения, ЭтотОбъект);
			
			Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
				
				СтрокаТаблицы = Список.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, РезультатВыбора);

				ЖурналСобытий.Регистрация("СЕРТИФИКАТЫ", "Примечание"
					, "Метаданные.Справочники.СерийныеНомера"
					, СтрокаТаблицы.ПодарочныйСертификат
					,
					, "[РУЧНОЙ ВВОД]:[СНОМ]:[КОД " + ЧастьКода + "]:WebRetail-" + ВРег(СокрЛП(РесурсWebRetailДоступен)) + Символы.ПС
					+ "Состояние ПС - «НЕ ОБРАБАТЫВАЛОСЬ»"
					, СокрЛП(СтрокаТаблицы.ПодарочныйСертификат)
					, Ложь
				);

				ЧастьКода = "";

			КонецЕсли;

		Иначе

			ТекстСообщения = "Немає номерів подарункових сертифікатів, які відповідають пошуку."; 

			Если ВыводитьСообщения = Истина Тогда

				ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМК(ТекстСообщения);

			КонецЕсли;

			ЖурналСобытий.Регистрация("СЕРТИФИКАТЫ", "Ошибка"
				, "Метаданные.Справочники.СерийныеНомера"
				,
				,
				, "[РУЧНОЙ ВВОД]:[СНОМ]:[КОД " + ЧастьКода + "]:WebRetail-" + ВРег(СокрЛП(РесурсWebRetailДоступен)) + Символы.ПС
				+ "Поиск в локальных ресурсах НЕ вернул данных" + Символы.ПС + ТекстСообщения
				,
				, Ложь
			);

			ЧастьКода = "";

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСтрокиСервер(ПодарочныйСертификат, Номинал, ИспользоватьСерийныеНомера);

	Номинал = ПодарочныйСертификат.Номинал;
	ИспользоватьСерийныеНомера = ПодарочныйСертификат.ИспользоватьСерийныеНомера

КонецПроцедуры

&НаСервере
Функция АдресТаблицыПогашениеПодарочныхСертификатов()
	
	АдресТаблицы = ПоместитьВоВременноеХранилище(Список.Выгрузить(), Новый УникальныйИдентификатор);
	
	Возврат АдресТаблицы;
	
КонецФункции // АдресТаблицыПогашениеПодарочныхСертификатов()

&НаКлиенте
Процедура ШтрихкодПриИзменении(Элемент)
	
//	LNK 20.02.2020 13:24:15
//	Проверяем номерной сертификат..
	МаскаСертификата = Лев(Штрихкод, ПодарочныеСертификатыПовтИсп.ДлинаМаски());

	Если ПодарочныеСертификатыПовтИсп.МаскиСертификатов().Получить(МаскаСертификата) = Истина Тогда

		Штрихкод = "";
		Сообщить("Получен недопустимый штрихкод!");

	Иначе

		ТекстСообщения = "";
		МассВозврата = ВернутьСертификатШК(СокрЛП(Штрихкод), ТекстСообщения, "РУЧНОЙ ВВОД");
		
		Если МассВозврата.Количество() = 0 ИЛИ НЕ ПустаяСтрока(ТекстСообщения) Тогда

			Если ПустаяСтрока(ТекстСообщения) Тогда

				ТекстСообщения = "Дані щодо коду не знайдені: " + Штрихкод;

			КонецЕсли;

			ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМК(ТекстСообщения);

	    Иначе

			ДополнитьСписокСертификатов(МассВозврата);

		КонецЕсли;

		Штрихкод = "";
	    Элементы.Декорация1.Заголовок = Строка("СУМА ВВЕДЕНИХ СЕРТИФІКАТІВ: " + Список.Итог("Номинал") + " грн.");

	КонецЕсли;
	
КонецПроцедуры

//+HVOYA Mykhailo
&НаСервере
Функция ВернутьСертификатШК(КодШК, ТекстСообщения, МеткаВызова)

//	LNK 01.09.2020 05:03:33 - обновим флаг доступа принудительно..
	РесурсWebRetailДоступен = РозничныеПродажиСлужебный.РесурсWebRetailДоступен();
//	LNK 28.02.2024 07:38:34
	КонтрольОрганизацииПодарочногоСертификата = РозничныеПродажиСерверПовтИсп.КонтрольОрганизацииПодарочногоСертификата(Магазин);

//	Только цифры говорит о том, что это точно не секретный код..
	ТолькоЦифры    = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(КодШК);
	МассивВозврата = Новый Массив;
	
	СоставОбъекта = ПодарочныеСертификатыСервер.ПолучитьСостояниеПодарочногоСертификатаКлюч(КодШК, РесурсWebRetailДоступен);	//	НаборПравИНастроек.РесурсWebRetailДоступен

	Если СоставОбъекта.Найден Тогда

		Если НЕ Организация = СоставОбъекта.ОрганизацияАктивации И КонтрольОрганизацииПодарочногоСертификата = Истина Тогда	//	LNK 29.12.2023 10:34:23

			ТекстСообщения = "Організація активації сертифіката не відповідає організації поточного чека!";

		ИначеЕсли СоставОбъекта.Состояние = Перечисления.СостоянияСерийныхНомеров.Активен И СоставОбъекта.ДатаОкончанияДействия >= ТекущаяДата() Тогда

			Результат = Новый Структура;
			Результат.Вставить("СерийныйНомер"             , СоставОбъекта.СерийныйНомер);
			Результат.Вставить("ПодарочныйСертификат"      , СоставОбъекта.Владелец);
			Результат.Вставить("Номинал"                   , СоставОбъекта.Номинал);
			Результат.Вставить("ИспользоватьСерийныеНомера", Истина);

			МассивВозврата.Добавить(Результат);

		Иначе

			Если НЕ СоставОбъекта.Состояние = Перечисления.СостоянияСерийныхНомеров.Активен Тогда

					ТекстСообщения = "Відмовлено. Сертифікат не активний.";

			Иначе	ТекстСообщения = "Відмовлено. Сертифікат прострочений (діє до " + Формат(СоставОбъекта.ДатаОкончанияДействия, "ДФ=dd.MM.yyyy") + ").";

			КонецЕсли;

		КонецЕсли;

		ЖурналСобытий.Регистрация("СЕРТИФИКАТЫ", ?(СоставОбъекта.Состояние = Перечисления.СостоянияСерийныхНомеров.Активен И Организация = СоставОбъекта.ОрганизацияАктивации
				, УровеньЖурналаРегистрации.Информация, УровеньЖурналаРегистрации.Предупреждение)
			, Метаданные.Справочники.СерийныеНомера
			, СоставОбъекта.СерийныйНомер
			,
			, "[" + МеткаВызова + "]:[ПСПС]:[ШК " + Штрихкод + "]:WebRetail-" + ВРег(СокрЛП(РесурсWebRetailДоступен)) + Символы.ПС
			+ "Стан ПС - «" + СоставОбъекта.Состояние + "»" + Символы.ПС
			+ "Організація активації «" + СоставОбъекта.ОрганизацияАктивации + "»" + Символы.ПС
			+ ?(НЕ ПустаяСтрока(ТекстСообщения), ТекстСообщения, "")
			, СокрЛП(СоставОбъекта.СерийныйНомер)
			, Ложь
		);

		Штрихкод = "";

	Иначе

		ЖурналСобытий.Регистрация("СЕРТИФИКАТЫ", ?(ТолькоЦифры, УровеньЖурналаРегистрации.Предупреждение, УровеньЖурналаРегистрации.Ошибка)
			, Метаданные.Справочники.СерийныеНомера
			,
			,
			, "[" + МеткаВызова + "]:[ПСПС]:[ШК " + Штрихкод + "]:WebRetail-" + ВРег(СокрЛП(РесурсWebRetailДоступен)) + Символы.ПС
			+ "Контроль стану [ПолучитьСостояниеПодарочногоСертификатаКлюч] НЕ виконаний.
			  |Виконання пошуку на локальному ресурсі [РегистрыСведений.Штрихкоды]"
			,
			, Ложь
		);
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СерийныеНомера.Ссылка КАК СерийныйНомер,
		|	Номенклатура.Ссылка КАК ПодарочныйСертификат,
		|	Номенклатура.Номинал КАК Номинал,
		|	Номенклатура.ИспользоватьСерийныеНомера КАК ИспользоватьСерийныеНомера
		|ИЗ
		|	РегистрСведений.Штрихкоды КАК Штрихкоды
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерийныеНомера КАК СерийныеНомера
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
		|			ПО СерийныеНомера.Владелец = Номенклатура.Ссылка
		|		ПО Штрихкоды.Владелец = СерийныеНомера.Ссылка
		|ГДЕ
		|	Штрихкоды.Штрихкод = &Штрихкод
		|	И Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.СкидочныйКупон)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Справочник.СерийныеНомера.ПустаяСсылка),
		|	Номенклатура.Ссылка,
		|	Номенклатура.Номинал,
		|	Номенклатура.ИспользоватьСерийныеНомера
		|ИЗ
		|	РегистрСведений.Штрихкоды КАК Штрихкоды
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
		|		ПО Штрихкоды.Владелец = Номенклатура.Ссылка
		|ГДЕ
		|	Штрихкоды.Штрихкод = &Штрихкод
		|	И Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат)
		|	И Номенклатура.ИспользоватьСерийныеНомера = ЛОЖЬ"
		);
		Запрос.УстановитьПараметр("Штрихкод",КодШК);

		Результат = Запрос.Выполнить();

		Если НЕ Результат.Пустой() Тогда

			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			Результат = Новый Структура;
			Результат.Вставить("СерийныйНомер"				, Выборка.СерийныйНомер);
			Результат.Вставить("ПодарочныйСертификат"		, Выборка.ПодарочныйСертификат);
			Результат.Вставить("Номинал"					, Выборка.Номинал);
			Результат.Вставить("ИспользоватьСерийныеНомера"	, Выборка.ИспользоватьСерийныеНомера);

			МассивВозврата.Добавить(Результат);

			ЖурналСобытий.Регистрация("СЕРТИФИКАТЫ", УровеньЖурналаРегистрации.Примечание
				, Метаданные.Справочники.СерийныеНомера
				, Выборка.ПодарочныйСертификат
				,
				, "[" + МеткаВызова + "]:[РСШК]:[ШК " + Штрихкод + "]:WebRetail-" + ВРег(СокрЛП(РесурсWebRetailДоступен)) + Символы.ПС
				+ "Стан ПС - «НЕ ОБРОБЛЮВАЛОСЯ»"
				, СокрЛП(Выборка.ПодарочныйСертификат)
				, Ложь
			);

		Иначе

			ЖурналСобытий.Регистрация("СЕРТИФИКАТЫ", УровеньЖурналаРегистрации.Ошибка
				, Метаданные.Справочники.СерийныеНомера
				,
				,
				, "[" + МеткаВызова + "]:[РСШК]:[ШК " + Штрихкод + "]:WebRetail-" + ВРег(СокрЛП(РесурсWebRetailДоступен)) + Символы.ПС
				+ "Виконання пошуку на локальному ресурсі [РегистрыСведений.Штрихкоды] НЕ повернув даних"
				,
				, Ложь
			);

		КонецЕсли;

	КонецЕсли;
	
	Возврат МассивВозврата;
	
КонецФункции

// +HVOYA. 27.02.2017 12:56:14, Львова Е.А.
&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
    
    Элементы.Декорация1.Заголовок = Строка("СУМА ВВЕДЕНИХ СЕРТИФІКАТІВ: " + Список.Итог("Номинал") + " грн.");
    
КонецПроцедуры
// -HVOYA. 27.02.2017 12:56:22, Львова Е.А.

&НаКлиенте	//	LNK 24.02.2020 12:45:40
Процедура ДополнитьСписокСертификатов(СписокДанных)

	Для каждого ДанныеСертификата Из СписокДанных Цикл

		СтрокиСписка = Список.НайтиСтроки(Новый Структура("ИспользоватьСерийныеНомера, СерийныйНомер", Истина, ДанныеСертификата.СерийныйНомер));

		Если НЕ СтрокиСписка.Количество() = 0 Тогда

			ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМК("Цей серійний номер вже використаний у цьому списку!");
            Прервать;

        Иначе

			СтрокаТаблицы = Список.Добавить();
            ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ДанныеСертификата);

        КонецЕсли;             

	КонецЦикла;

КонецПроцедуры





