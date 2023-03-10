////////////////////////////////////////////////////////////////////////////////
// Подсистема "Регламентные задания".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает использование регламентного задания.
//  Перед вызовом требуется иметь право Администрирования
// или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор регламентного задания.
//                - Строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание.
//
// Возвращаемое значение:
//  Булево.
// 
Функция ПолучитьИспользованиеРегламентногоЗадания(Знач Идентификатор) Экспорт
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Возврат Задание.Использование;
	
КонецФункции

// Устанавливает использование регламентного задания.
//  Перед вызовом требуется иметь право Администрирования
// или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор регламентного задания.
//                - Строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание.
//
// Использование  - Булево.
// 
Процедура УстановитьИспользованиеРегламентногоЗадания(Знач Идентификатор, Знач Использование) Экспорт
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если Задание.Использование <> Использование Тогда
		Задание.Использование = Использование;
	КонецЕсли;
	
	Задание.Записать();
	
КонецПроцедуры

// Возвращает расписание регламентного задания.
//  Перед вызовом требуется иметь право Администрирования
// или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор регламентного задания.
//                - Строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание.
//
// ВСтруктуре     - Булево, если Истина, тогда расписание будет преобразовано
//                  в структуру, которую можно передать на клиент.
// 
// Возвращаемое значение:
//  Булево.
// 
Функция ПолучитьРасписаниеРегламентногоЗадания(Знач Идентификатор, Знач ВСтруктуре = Ложь) Экспорт
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если ВСтруктуре Тогда
		Возврат ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Задание.Расписание);
	КонецЕсли;
	
	Возврат Задание.Расписание;
	
КонецФункции

// Устанавливает расписание регламентного задания.
//  Перед вызовом требуется иметь право Администрирования
// или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор регламентного задания.
//                - Строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание.
//
// Расписание     - РасписаниеРегламентногоЗадания.
//                - Структура расписания, как возвращает функция
//                  ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру.
// 
Процедура УстановитьРасписаниеРегламентногоЗадания(Знач Идентификатор, Знач Расписание) Экспорт
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если ТипЗнч(Расписание) = Тип("РасписаниеРегламентногоЗадания") Тогда
		Задание.Расписание = Расписание;
	Иначе
		Задание.Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание);
	КонецЕсли;
	
	Задание.Записать();
	
КонецПроцедуры

// Возвращает РегламентноеЗадание из информационной базы.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор регламентного задания.
//                - Строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание из которого нужно получить уникальный
//                  идентификатор для получения свежей копии регламентного задания.
// 
// Возвращаемое значение:
//  РегламентноеЗадание, прочитанное из базы данных.
//
Функция ПолучитьРегламентноеЗадание(Знач Идентификатор) Экспорт
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
		РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Идентификатор);
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	КонецЕсли;
	
	Если РегламентноеЗадание = Неопределено Тогда
		ВызватьИсключение( НСтр("ru = 'Регламентное задание не найдено.
		                              |Возможно, оно удалено другим пользователем.'") );
	КонецЕсли;
	
	Возврат РегламентноеЗадание;
	
КонецФункции

Процедура СохранитьРазмерыЦенников(Знач МассивТЗ) Экспорт
	Если ТипЗнч(МассивТЗ) = Тип("Массив") Тогда
		Для Каждого ТаблицаЗаписией Из МассивТЗ Цикл
			ЗаписатьВРегистр(ТаблицаЗаписией);
		КонецЦикла;
	Иначе
		ЗаписатьВРегистр(ТаблицаЗаписией);	
	КонецЕсли;

	
	
КонецПроцедуры


Процедура ЗаписатьВРегистр(ТаблицаЗаписией) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таб.Номенклатура КАК Номенклатура,
		|	Выразить(Таб.ШаблонЦенника КАК Справочник.ХранилищеШаблонов) КАК ШаблонЦенника
		|ПОМЕСТИТЬ Таб2
		|ИЗ
		|	&Таб КАК Таб
		|ГДЕ
		|	Таб.Выбран = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таб2.Номенклатура КАК Номенклатура,
		|	Таб2.ШаблонЦенника.РазмерЦенника КАК РазмерЦенника,
		|	РазмерыЦенников.РазмерЦенника КАК РазмерЦенника1
		|ИЗ
		|	Таб2 КАК Таб2
		|		ЛЕвое СОЕДИНЕНИЕ РегистрСведений.РазмерыЦенников КАК РазмерыЦенников
		|		ПО Таб2.Номенклатура = РазмерыЦенников.Номенклатура
		|			И (РазмерыЦенников.Магазин = &Магазин)
		|ГДЕ
		|	Таб2.ШаблонЦенника.РазмерЦенника <> РазмерыЦенников.РазмерЦенника ИЛИ (РазмерыЦенников.РазмерЦенника ЕСТЬ  NULL и  Таб2.ШаблонЦенника.РазмерЦенника <> ЗНАЧЕНИЕ(Перечисление.РазмерЦенника.ПустаяСсылка))
		|
		|СГРУППИРОВАТЬ ПО
		|	Таб2.Номенклатура,
		|	Таб2.ШаблонЦенника.РазмерЦенника,
		|	РазмерыЦенников.РазмерЦенника";
	
	Магазин = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин;
	Запрос.УстановитьПараметр("Магазин", Магазин); 	
	Запрос.УстановитьПараметр("Таб",ТаблицаЗаписией);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	
	
	
	
	Для каждого строка из РезультатЗапроса цикл
		
		НаборЗаписей = РегистрыСведений.РазмерыЦенников.СоздатьНаборЗаписей(); 

		НаборЗаписей.Отбор.Номенклатура.Установить(строка.Номенклатура);
		НаборЗаписей.Отбор.Магазин.Установить(Магазин); 

		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись. Номенклатура = строка.Номенклатура;
		НоваяЗапись.Магазин = Магазин;
		НоваяЗапись.РазмерЦенника = строка.РазмерЦенника; 

		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполениеИнформацииДляВоблеромИМ() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИМ = ПолучитьИМ();	
	Если ЗначениеЗаполнено(ИМ) тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДействиеСкидокНаценокСрезПоследних.Магазин КАК Магазин,
			|	МАКСИМУМ(ДействиеСкидокНаценокСрезПоследних.СкидкаНаценка.ЗначениеСкидкиНаценки) КАК АкцНачислениеБонусов,
			|	НоменклатураСегмента.Номенклатура КАК Номенклатура
			|ПОМЕСТИТЬ ТабПолная
			|ИЗ
			|	РегистрСведений.ДействиеСкидокНаценок.СрезПоследних КАК ДействиеСкидокНаценокСрезПоследних
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента
			|		ПО ДействиеСкидокНаценокСрезПоследних.СкидкаНаценка.СегментНоменклатурыПредоставления = НоменклатураСегмента.Сегмент
			|ГДЕ
			|	ДействиеСкидокНаценокСрезПоследних.Период <= &ТекДата
			|	И ДействиеСкидокНаценокСрезПоследних.ДатаОкончания >= &ТекДата
			|	И (ДействиеСкидокНаценокСрезПоследних.Магазин = &ИМ
			|			ИЛИ ДействиеСкидокНаценокСрезПоследних.ИспользоватьИнтернетМагазин)
			|	И ДействиеСкидокНаценокСрезПоследних.СкидкаНаценка.ТипСкидкиНаценки = &ТипСкидкиНаценки
			|
			|СГРУППИРОВАТЬ ПО
			|	ДействиеСкидокНаценокСрезПоследних.Магазин,
			|	НоменклатураСегмента.Номенклатура
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ИнформацияДляЦенниковСрезПоследних.Магазин КАК Магазин,
			|	0 КАК БонусБазаНачислен,
			|	ИнформацияДляЦенниковСрезПоследних.Номенклатура КАК Номенклатура,
			|	0 КАК БонусБазаНачисленСумма
			|ПОМЕСТИТЬ ТабСрез
			|ИЗ
			|	РегистрСведений.ИнформацияДляЦенников.СрезПоследних КАК ИнформацияДляЦенниковСрезПоследних
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТабПолная КАК ТабПолная
			|		ПО (ТабПолная.Номенклатура = ИнформацияДляЦенниковСрезПоследних.Номенклатура)
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДействующиеЦеныНоменклатуры.СрезПоследних(, ОбъектЦенообразования = &ИМ) КАК ДействующиеЦеныНоменклатурыСрезПоследних
			|		ПО ИнформацияДляЦенниковСрезПоследних.Номенклатура = ДействующиеЦеныНоменклатурыСрезПоследних.Номенклатура
			|ГДЕ
			|	ТабПолная.АкцНачислениеБонусов ЕСТЬ NULL
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТабПолная.Магазин КАК Магазин,
			|	ТабПолная.АкцНачислениеБонусов КАК БонусБазаНачислен,
			|	ТабПолная.Номенклатура КАК Номенклатура,
			|	ТабПолная.АкцНачислениеБонусов * ДействующиеЦеныНоменклатурыСрезПоследних.Цена / 100 КАК БонусБазаНачисленСумма
			|ПОМЕСТИТЬ ТабДейстующиеАкции
			|ИЗ
			|	ТабПолная КАК ТабПолная
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДействующиеЦеныНоменклатуры.СрезПоследних(, ОбъектЦенообразования = &ИМ) КАК ДействующиеЦеныНоменклатурыСрезПоследних
			|		ПО (ДействующиеЦеныНоменклатурыСрезПоследних.Номенклатура = ТабПолная.Номенклатура)
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИнформацияДляЦенников.СрезПоследних КАК ИнформацияДляЦенниковСрезПоследних
			|		ПО ТабПолная.Номенклатура = ИнформацияДляЦенниковСрезПоследних.Номенклатура
			|ГДЕ
			|	(ТабПолная.АкцНачислениеБонусов * ДействующиеЦеныНоменклатурыСрезПоследних.Цена / 100 <> ИнформацияДляЦенниковСрезПоследних.БонусБазаНачисленСумма
			|			ИЛИ ИнформацияДляЦенниковСрезПоследних.БонусБазаНачисленСумма ЕСТЬ NULL)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТабДейстующиеАкции.Магазин КАК Магазин,
			|	ТабДейстующиеАкции.БонусБазаНачислен КАК БонусБазаНачислен,
			|	ТабДейстующиеАкции.Номенклатура КАК Номенклатура,
			|	ТабДейстующиеАкции.БонусБазаНачисленСумма КАК БонусБазаНачисленСумма
			|ИЗ
			|	ТабДейстующиеАкции КАК ТабДейстующиеАкции
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ТабСрез.Магазин,
			|	ТабСрез.БонусБазаНачислен,
			|	ТабСрез.Номенклатура,
			|	ТабСрез.БонусБазаНачисленСумма
			|ИЗ
			|	ТабСрез КАК ТабСрез
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|УНИЧТОЖИТЬ ТабПолная
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|УНИЧТОЖИТЬ ТабСрез
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|УНИЧТОЖИТЬ ТабДейстующиеАкции";
		
		Запрос.УстановитьПараметр("ИМ", ИМ);
		Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
		Запрос.УстановитьПараметр("ТипСкидкиНаценки", Перечисления.ТипСкидкиНаценки.НачислениеБонусов);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ТекДата = ТекущаяДата();
			НаборЗаписей = РегистрыСведений.ИнформацияДляЦенников.СоздатьНаборЗаписей(); 
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов", Истина);
			НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения"  , Истина);
			НаборЗаписей.Отбор.Номенклатура.Установить(ВыборкаДетальныеЗаписи.Номенклатура);
			НаборЗаписей.Отбор.Магазин.Установить(ВыборкаДетальныеЗаписи.Магазин); 
			НаборЗаписей.Отбор.Период.Установить(ТекДата); 

			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Период = ТекДата; 
			НоваяЗапись.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
			НоваяЗапись.Магазин = ВыборкаДетальныеЗаписи.Магазин;
//			НоваяЗапись.БонусАкцияСписан = ВыборкаДетальныеЗаписи.БонусАкцияСписан;
			НоваяЗапись.БонусБазаНачислен = ВыборкаДетальныеЗаписи.БонусБазаНачислен;
//			НоваяЗапись.БонусАкцияСписанСумма = ВыборкаДетальныеЗаписи.БонусАкцияСписанСумма;
			НоваяЗапись.БонусБазаНачисленСумма = ВыборкаДетальныеЗаписи.БонусБазаНачисленСумма;
			НоваяЗапись.ДатаИзменения = ТекущаяДата();
			НаборЗаписей.Записать();
			// Зарегистрировть номенклатуру в узле
		    МассивУзловТовары = ОбменССайтомПовтИсп.МассивУзловДляРегистрации(Истина);
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзловТовары, ВыборкаДетальныеЗаписи.Номенклатура);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры


Функция ПолучитьИМ()
	им = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетнаяПолитикаСрезПоследних.ИнтернетМагазин КАК ИнтернетМагазин
		|ИЗ
		|	РегистрСведений.УчетнаяПолитика.СрезПоследних КАК УчетнаяПолитикаСрезПоследних";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ИМ = ВыборкаДетальныеЗаписи.ИнтернетМагазин; 
	КонецЦикла;
	Возврат ИМ
КонецФункции

Процедура ПроверитьСтатусЗаказаПокупателя() Экспорт

	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатусыТТН.ДокументРегистратор КАК ДокументРегистратор,
		|	СтатусыТТН.ДокументРегистратор.ДокументОснование.СуммаОплаты КАК СуммаОплаты,
		|	СтатусыТТН.ДокументРегистратор.СуммаДокумента КАК СуммаДокумента,
		|	СтатусыТТН.ДокументРегистратор.ДокументОснование.СуммаДокумента КАК СуммаЗаказа,
		|	СтатусыТТН.ДокументРегистратор.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	РегистрСведений.СтатусыЭН КАК СтатусыТТН
		|ГДЕ
		|	СтатусыТТН.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|	И СтатусыТТН.Статус = &Статус
		|
		|СГРУППИРОВАТЬ ПО
		|	СтатусыТТН.ДокументРегистратор,
		|	СтатусыТТН.ДокументРегистратор.ДокументОснование.СуммаОплаты,
		|	СтатусыТТН.ДокументРегистратор.СуммаДокумента,
		|	СтатусыТТН.ДокументРегистратор.ДокументОснование.СуммаДокумента";
	
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("Статус", "Завершенно");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
		Если ВыборкаДетальныеЗаписи.СуммаОплаты > 0 тогда 
			Если ВыборкаДетальныеЗаписи.СуммаОплаты = ВыборкаДетальныеЗаписи.СуммаДокумента тогда 
				ПоменятьСтатусИДобавитьОплатуОднаПосылка(ВыборкаДетальныеЗаписи.ДокументРегистратор,ВыборкаДетальныеЗаписи.ДокументОснование,ВыборкаДетальныеЗаписи.СуммаДокумента);
			Иначе
				ПоменятьСтатусИДобавитьОплатуНесколькоПосылок(ВыборкаДетальныеЗаписи.ДокументРегистратор,ВыборкаДетальныеЗаписи.ДокументОснование,ВыборкаДетальныеЗаписи.СуммаДокумента);
			КонецЕсли;
		ИначеЕсли ВыборкаДетальныеЗаписи.СуммаЗаказа = ВыборкаДетальныеЗаписи.СуммаДокумента тогда  
			ПоменятьСтатусОднаПосылка(ВыборкаДетальныеЗаписи.ДокументРегистратор,ВыборкаДетальныеЗаписи.ДокументОснование);	
		Иначе
			ПоменятьСтатусНесколькоПосылок(ВыборкаДетальныеЗаписи.ДокументРегистратор,ВыборкаДетальныеЗаписи.ДокументОснование);	
		КонецЕсли;
	КонецЦикла;
	

	
КонецПроцедуры

Процедура ПоменятьСтатусОднаПосылка(ДокументРегистратор,ДокументОснование)
   
	ЗапросДоступности = ДокументРегистратор.ПолучитьОбъект();
	ЗапросДоступности.Статус = Перечисления.СтатусыЗапросовДоступностиТоваровШапка.Закрыт; 
	
	Попытка 
		ЗапросДоступности.Записать(РежимЗаписиДокумента.Проведение);
	
	
		Если НЕ ДокументОснование = Документы.ЗаказПокупателя.ПустаяСсылка() тогда

			Заказ = ДокументОснование.ПолучитьОбъект();
			#Если _ Тогда
			Заказ =Документы.ЗаказПокупателя.СоздатьДокумент();
			#КонецЕсли

			Заказ.Статус = Перечисления.СтатусыЗаказовПокупателей.Закрыт;
			
			Попытка 
				Заказ.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				// сделать запись в журнал
			КонецПопытки 
		КонецЕсли;
	Исключение	
				// сделать запись в журнал   
	КонецПопытки;
	КонецПроцедуры   
	
Процедура ПоменятьСтатусИДобавитьОплатуОднаПосылка(ДокументРегистратор,ДокументОснование,СуммаОплаты)
	ЗапросДоступности = ДокументРегистратор.ПолучитьОбъект();
	ЗапросДоступности.Статус = Перечисления.СтатусыЗапросовДоступностиТоваровШапка.Закрыт;     
	Попытка 
		ЗапросДоступности.Записать(РежимЗаписиДокумента.Проведение);
		Если НЕ ДокументОснование = Документы.ЗаказПокупателя.ПустаяСсылка() тогда

			Заказ = ДокументОснование.ПолучитьОбъект();
			#Если _ Тогда
			Заказ =Документы.ЗаказПокупателя.СоздатьДокумент();
			#КонецЕсли

			Заказ.Статус = Перечисления.СтатусыЗаказовПокупателей.Закрыт;
			СтрокаОплаты = Заказ.ОплатаЗаказа.Добавить();	 
			СтрокаОплаты.ТипОплаты = Перечисления.ТипОплатыЗаказПокупателя.Наличные;
			СтрокаОплаты.Сумма = СуммаОплаты;
			Попытка 
				Заказ.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				// сделать запись в журнал
			КонецПопытки; 
		КонецЕсли;
	Исключение	
		// сделать запись в журнал
	КонецПопытки;
	
КонецПроцедуры
	
	
Процедура ПоменятьСтатусНесколькоПосылок(ДокументРегистратор,ДокументОснование)
	ЗапросДоступности = ДокументРегистратор.ПолучитьОбъект();
	ЗапросДоступности.Статус = Перечисления.СтатусыЗапросовДоступностиТоваровШапка.Закрыт;     
	Попытка 
		ЗапросДоступности.Записать(РежимЗаписиДокумента.Проведение);
	    ВсеЗапросыЗакрыты = ПроверитьВсеЗапросы(ДокументОснование); 
		Если ВсеЗапросыЗакрыты тогда 
			Если НЕ ДокументОснование = Документы.ЗаказПокупателя.ПустаяСсылка() тогда

				Заказ = ДокументОснование.ПолучитьОбъект();
				#Если _ Тогда
				Заказ =Документы.ЗаказПокупателя.СоздатьДокумент();
				#КонецЕсли

				Заказ.Статус = Перечисления.СтатусыЗаказовПокупателей.Закрыт;
				
				Попытка 
					Заказ.Записать(РежимЗаписиДокумента.Проведение);
				Исключение
					// сделать запись в журнал
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
	Исключение
		// сделать запись в журнал
	КонецПопытки;
	КонецПроцедуры   


Процедура ПоменятьСтатусИДобавитьОплатуНесколькоПосылок(ДокументРегистратор,ДокументОснование,СуммаОплаты)
	ЗапросДоступности = ДокументРегистратор.ПолучитьОбъект();
	ЗапросДоступности.Статус = Перечисления.СтатусыЗапросовДоступностиТоваровШапка.Закрыт;     
	Попытка 
		ЗапросДоступности.Записать(РежимЗаписиДокумента.Проведение);

		
		Если НЕ ДокументОснование = Документы.ЗаказПокупателя.ПустаяСсылка() тогда

			Заказ = ДокументОснование.ПолучитьОбъект();
			#Если _ Тогда
			Заказ =Документы.ЗаказПокупателя.СоздатьДокумент();
			#КонецЕсли
		    ВсеЗапросыЗакрыты = ПроверитьВсеЗапросы(ДокументОснование); 
			Если ВсеЗапросыЗакрыты тогда 
				Заказ.Статус = Перечисления.СтатусыЗаказовПокупателей.Закрыт; 
			КонецЕсли;
			СтрокаОплаты = Заказ.ОплатаЗаказа.Добавить();	 
			СтрокаОплаты.ТипОплаты = Перечисления.ТипОплатыЗаказПокупателя.Наличные;
			СтрокаОплаты.Сумма = СуммаОплаты;
			Попытка 
				Заказ.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				// сделать запись в журнал
			КонецПопытки;
		КонецЕсли;
	Исключение	
		// сделать запись в журнал
	КонецПопытки;
	КонецПроцедуры
	
	Функция ПроверитьВсеЗапросы(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗапросДоступностиТоваров.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗапросДоступностиТоваров КАК ЗапросДоступностиТоваров
		|ГДЕ
		|	ЗапросДоступностиТоваров.ДокументОснование = &ДокументОснование
		|	И НЕ ЗапросДоступностиТоваров.СтатусЗапроса = &СтатусЗапроса
		|	И ЗапросДоступностиТоваров.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("СтатусЗапроса", Перечисления.СтатусыЗапросовДоступностиТоваровШапка.Закрыт);
	
	РезультатЗапроса = Запрос.Выполнить();

	Возврат РезультатЗапроса.Пустой(); 
	
	КонецФункции