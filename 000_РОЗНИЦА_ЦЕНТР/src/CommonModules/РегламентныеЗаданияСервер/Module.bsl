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

Процедура ОтправкаРеализацийНаПочту() Экспорт
	УчетнаяЗапись 	  = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	
	ВложенияПисьма 	  = Новый Соответствие;	
	ПараметрыДоставки = Новый Структура;
	Успешно			  = Истина;
	
	Запрос 		      = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеализацииДляОтправки.ДокументРеализации КАК ДокументРеализации
		|ИЗ
		|	РегистрСведений.РеализацииДляОтправки КАК РеализацииДляОтправки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	                                                                                  
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ИмяВложения = ПолучитьВложение(ВыборкаДетальныеЗаписи.ДокументРеализации);
		ВложенияПисьма.Вставить(ВыборкаДетальныеЗаписи.ДокументРеализации.Номер,ИмяВложения);
	КонецЦикла;
	
	Запрос2 = Новый Запрос;
	Запрос2.Текст = 
		"ВЫБРАТЬ
		|	ПользователиКонтактнаяИнформация.АдресЭП КАК АдресЭП
		|ИЗ
		|	РегистрСведений.ПолучателиРеализаций КАК ПолучателиРеализаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
		|		ПО ПолучателиРеализаций.Пользователь = ПользователиКонтактнаяИнформация.Ссылка
		|ГДЕ
		|	ПользователиКонтактнаяИнформация.Тип = &Тип
		|
		|СГРУППИРОВАТЬ ПО
		|	ПользователиКонтактнаяИнформация.АдресЭП";
	
	Запрос2.УстановитьПараметр("тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	
	РезультатЗапроса2 = Запрос2.Выполнить();
		
	Выборка = РезультатЗапроса2.Выбрать();
		
	Пока Выборка.Следующий() Цикл
		Попытка
			ПараметрыДоставки.Вставить("УчетнаяЗапись",УчетнаяЗапись);
			ОтправитьНакладные(ВложенияПисьма, ПараметрыДоставки,Выборка.АдресЭП);
			Успешно = Истина;
		Исключение
			ЗаписьЖурналаРегистрации("Ошибка реализации на почту ", УровеньЖурналаРегистрации.Ошибка,,,  ИнформацияОбОшибке());
			Успешно = Ложь;
		КонецПопытки;
	КонецЦикла;
	
	Если Успешно тогда
		УдалитьДанныеРегистра();
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьВложение(ДокументСсылка)
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(ДокументСсылка);



	Путь = КаталогВременныхФайлов() + ДокументСсылка.Номер + ".XLSX";
	Накладная =     ПечатьНакладная(МассивОбъектов);
	Накладная.Записать(Путь, ТипФайлаТабличногоДокумента.XLSX);
	Вложение =  Путь;
	Возврат	   Вложение;
КонецФункции


// Отправка
Процедура ОтправитьНакладные(Вложения, ПараметрыДоставки, СтрокаПолучатель = Неопределено)
	
	Получатель = ?(СтрокаПолучатель = Неопределено, Неопределено, СтрокаПолучатель);
	ПараметрыПисьма = Новый Структура;
	// Вложения - отчеты
	ПараметрыПисьма.Вставить("Вложения", Вложения);
	
	
	// Тема и тело сообщения
	ПараметрыПисьма.Вставить("Тема", "Реалізації товарів");
	ПараметрыПисьма.Вставить("Тело", " ");
	
	// Тема и тело сообщения
	КлючАдресаДоставки = "Кому";
	
	Если НЕ Получатель = Неопределено Тогда
		// Доставка конкретному получателю
		
		// Получатель
		ПараметрыПисьма.Вставить(КлючАдресаДоставки, Получатель);
		//УстановитьОтветственныхВСтрокеСлепыеКопии(ПараметрыДоставки, ПараметрыПисьма);	//	LNK 01.02.2018 12:41:49                  ТипЗнч(Новый ИнтернетПочта) <> Тип("ИнтернетПочта")
		
		// Отправляем письмо                                                                          
		ЭлектроннаяПочта.ОтправитьПочтовоеСообщение(ПараметрыДоставки.УчетнаяЗапись, ПараметрыПисьма, ТипЗнч(Новый ИнтернетПочта));  
		
	КонецЕсли;
	
КонецПроцедуры

//
Процедура УдалитьДанныеРегистра()
	
НаборЗаписей = РегистрыСведений.РеализацииДляОтправки.СоздатьНаборЗаписей();
НаборЗаписей.Записать();	
КонецПроцедуры


// Функция формирует табличный документ с печатной формой.
//
// Возвращаемое значение:
//  ТабличныйДокумент - печатная форма.
//
Функция ПечатьНакладная(МассивОбъектов)
	КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм();
	//КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;

	КолонкаКодов       = ФормированиеПечатныхФормСервер.ИмяДополнительнойКолонки();
	ВыводитьКоды       = ЗначениеЗаполнено(КолонкаКодов);
	ВыводитьУпаковки   = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");
	ТабличныйДокумент  = Новый ТабличныйДокумент;
	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс");
	СинонимДокумента   = НСтр("ru='Расходная накладная';uk='Видаткова накладна'", КодЯзыкаПечать);
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеализацияТоваров_Накладная";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Документ.Ссылка КАК Ссылка,
	|	Документ.Номер КАК Номер,
	|	Документ.Дата КАК Дата,
	|	Документ.Магазин КАК Магазин,
	|	ВЫБОР
	|		КОГДА Документ.Организация.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ЮрЛицо)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОрганизацияЮридическоеЛицо,
	|	Документ.Организация КАК Поставщик,
	|	Документ.СуммаДокумента КАК СуммаДокумента,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Магазин) КАК МагазинПредставление,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Организация) КАК ПредставлениеПоставщика,
	|	Документ.Ответственный.ФизЛицо КАК Ответственный,
	|	Документ.Контрагент КАК Получатель,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Контрагент) КАК ПредставлениеПолучателя,
	|	Документ.УчитыватьНДС,
	|	Документ.ЦенаВключаетНДС
	|ИЗ
	|	Документ.РеализацияТоваров КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивОбъектов)
	|	И Документ.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	" + ?(ВыводитьКоды, "ТаблицаТовары.Номенклатура." + КолонкаКодов +" КАК КолонкаКодов,", "") + "
	|	ТаблицаТовары.Номенклатура.Представление КАК Товар,
	|	ТаблицаТовары.Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Характеристика) КАК ХарактеристикаПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Номенклатура.ЕдиницаИзмерения) КАК ПредставлениеБазовойЕдиницыИзмерения,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
	|			ТОГДА ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Упаковка.ЕдиницаИзмерения)
	|		ИНАЧЕ ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Номенклатура.ЕдиницаИзмерения)
	|	КОНЕЦ КАК ЕдиницаИзмерения,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ВЫБОР КОГДА ТаблицаТовары.Количество = 0 ТОГДА ТаблицаТовары.Количество
	|	ИНАЧЕ ТаблицаТовары.Сумма / ТаблицаТовары.Количество
	|	КОНЕЦ КАК Цена,
	|	ТаблицаТовары.Сумма КАК Сумма,
	|	ТаблицаТовары.Ссылка КАК Ссылка,
	|	ТаблицаТовары.Сумма +
	|	ТаблицаТовары.СуммаРучнойСкидки +
	|	ТаблицаТовары.СуммаАвтоматическойСкидки   КАК СуммаБезСкидки,
	|	ТаблицаТовары.СуммаРучнойСкидки +
	|	ТаблицаТовары.СуммаАвтоматическойСкидки   КАК Скидка,
	|	ТаблицаТовары.СуммаНДС,
	|	ТаблицаТовары.СтавкаНДС
	|ИЗ
	|	Документ.РеализацияТоваров.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка В(&МассивОбъектов)
	|	И ТаблицаТовары.Ссылка.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка");
	
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Макет = УправлениеПечатью.ПолучитьМакет("Документ.РеализацияТоваров.ПФ_MXL_Накладная", КодЯзыкаПечать);

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	
	ОбластьШапкаНомера         = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
	ОбластьШапкаКодов          = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
	ОбластьШапкаДанных         = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");
	ОбластьШапкаСкидок         = Макет.ПолучитьОбласть("ШапкаТаблицы|Скидка");
	ОбластьШапкаСуммы          = Макет.ПолучитьОбласть("ШапкаТаблицы|Сумма");
	
	ОбластьКолонкаТовар = Макет.Область("Товар");
	Если Не ВыводитьКоды Тогда
		ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки
		                                  + Макет.Область("КолонкаКодов").ШиринаКолонки;
	КонецЕсли;
	ОбластьСтрокаНомера         = Макет.ПолучитьОбласть("Строка|НомерСтроки");
	ОбластьСтрокаКодов          = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
	ОбластьСтрокаДанных         = Макет.ПолучитьОбласть("Строка|Данные");
	ОбластьСтрокаСкидок         = Макет.ПолучитьОбласть("Строка|Скидка");
	ОбластьСтрокаСуммы          = Макет.ПолучитьОбласть("Строка|Сумма");
	
	ОбластьИтогоНДСНомера = Макет.ПолучитьОбласть("ИтогоНДС|НомерСтроки");
	ОбластьИтогоНДСКодов  = Макет.ПолучитьОбласть("ИтогоНДС|КолонкаКодов");
	ОбластьИтогоНДСДанных = Макет.ПолучитьОбласть("ИтогоНДС|Данные");
	ОбластьИтогоНДССкидок = Макет.ПолучитьОбласть("ИтогоНДС|Скидка");
	ОбластьИтогоНДССуммы  = Макет.ПолучитьОбласть("ИтогоНДС|Сумма");
	
	// Вывести Итого.
	ОбластьИтогоНомера         = Макет.ПолучитьОбласть("Итого|НомерСтроки");
	ОбластьИтогоКодов          = Макет.ПолучитьОбласть("Итого|КолонкаКодов");
	ОбластьИтогоДанных         = Макет.ПолучитьОбласть("Итого|Данные");
	ОбластьИтогоСкидок         = Макет.ПолучитьОбласть("Итого|Скидка");
	ОбластьИтогоСуммы          = Макет.ПолучитьОбласть("Итого|Сумма");
	
	ОбластьСуммаПрописью = Макет.ПолучитьОбласть("СуммаПрописью");
	ОбластьПодписей      = Макет.ПолучитьОбласть("Подписи");
	
	
	ВыборкаПоДокументам = Результаты[0].Выбрать();
	ВыборкаПоТабличнымЧастям = Результаты[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоДокументам.Ссылка)) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ВыборкаПоСтрокамТЧ = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Если НЕ ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.Заполнить(ВыборкаПоДокументам);
		
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = ФормированиеПечатныхФормСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента, СинонимДокумента, КодЯзыкаПечать);
		ПредставлениеПоставщика = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ВыборкаПоДокументам.Поставщик, ВыборкаПоДокументам.Дата), "ПолноеНаименование,ИНН,ЮридическийАдрес,НомерСчета,Банк,МФО,КодПоЕДРПОУ",,КодЯзыкаПечать);
		//ПредставлениеПоставщика = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ВыборкаПоДокументам.Поставщик, ВыборкаПоДокументам.Дата), "ПолноеНаименование,");
		ОбластьЗаголовок.Параметры.ПредставлениеПоставщика = ПредставлениеПоставщика;
		
		//ПредставлениеПолучателя = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ВыборкаПоДокументам.Получатель, ВыборкаПоДокументам.Дата), "ПолноеНаименование,");
		ПредставлениеПолучателя = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ВыборкаПоДокументам.Получатель, ВыборкаПоДокументам.Дата), "ПолноеНаименование,ИНН,ЮридическийАдрес,НомерСчета,Банк,МФО,КодПоЕДРПОУ",,КодЯзыкаПечать);
		
		ОбластьЗаголовок.Параметры.ПредставлениеПолучателя = ПредставлениеПолучателя;
		
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		//Шапка
		
		ТабличныйДокумент.Вывести(ОбластьШапкаНомера);
		Если ВыводитьКоды Тогда
			ОбластьШапкаКодов.Параметры.ИмяКолонкиКодов = КолонкаКодов;
			ТабличныйДокумент.Присоединить(ОбластьШапкаКодов);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьШапкаДанных);
		ТабличныйДокумент.Присоединить(ОбластьШапкаСкидок);
		ТабличныйДокумент.Присоединить(ОбластьШапкаСуммы);
		
		
		ВсегоНаименований = 0;
		Сумма             = 0;
		ВсегоСкидок       = 0;
		ВсегоБезСкидок    = 0;
		СуммаНДС          = 0;
		ЕстьНДС = Ложь;
		//СТРОКИ ТЧ
		Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл
			Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамТЧ.Номенклатура) Тогда
				Продолжить;
			КонецЕсли;
			Если ВыборкаПоСтрокамТЧ.СтавкаНДС = Перечисления.СтавкиНДС.НДС7 или  ВыборкаПоСтрокамТЧ.СтавкаНДС = Перечисления.СтавкиНДС.НДС20 или ВыборкаПоСтрокамТЧ.СтавкаНДС = Перечисления.СтавкиНДС.НДС14 тогда
				ЕстьНДС = Истина;	
			КонецЕсли;
			ОбластьСтрокаНомера.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Вывести(ОбластьСтрокаНомера);

			Если ВыводитьКоды Тогда
				
				ОбластьСтрокаКодов.Параметры.Артикул = ВыборкаПоСтрокамТЧ["КолонкаКодов"];
				ТабличныйДокумент.Присоединить(ОбластьСтрокаКодов);
				
			КонецЕсли;

			ОбластьСтрокаДанных.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ОбластьСтрокаДанных.Параметры.Товар = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаПоСтрокамТЧ.НоменклатураПредставление,ВыборкаПоСтрокамТЧ.ХарактеристикаПредставление);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаДанных);
			
			ОбластьСтрокаСкидок.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаСкидок);

			ОбластьСтрокаСуммы.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаСуммы);
			
			ВсегоНаименований = ВсегоНаименований + 1;
			
			Сумма          = Сумма       + ВыборкаПоСтрокамТЧ.Сумма;
			ВсегоСкидок    = ВсегоСкидок + ВыборкаПоСтрокамТЧ.Скидка;
			ВсегоБезСкидок = Сумма       + ВсегоСкидок;
			СуммаНДС       = СуммаНДС    + Окр(ВыборкаПоСтрокамТЧ.СуммаНДС, 2, 1);
			
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьИтогоНомера);
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьИтогоКодов);
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьИтогоДанных);
		ОбластьИтогоСкидок.Параметры.ВсегоСкидок    = ВсегоСкидок;
		ОбластьИтогоСкидок.Параметры.ВсегоБезСкидок = ВсегоБезСкидок;
		ТабличныйДокумент.Присоединить(ОбластьИтогоСкидок);
		ОбластьИтогоСуммы.Параметры.Всего = Сумма;
		ТабличныйДокумент.Присоединить(ОбластьИтогоСуммы);
		
		
		// Вывести ИтогоНДС
		ТабличныйДокумент.Вывести(ОбластьИтогоНДСНомера);
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьИтогоНДСКодов);
		КонецЕсли;
		
		ОбластьИтогоНДСДанных.Параметры.НДС = ?(ЕстьНДС, НСтр("ru = 'У тому числі ПДВ:';uk='У тому числі ПДВ:'", КодЯзыкаПечать), НСтр("ru = 'Сума ПДВ:';uk='Сума ПДВ:'", КодЯзыкаПечать));
		ТабличныйДокумент.Присоединить(ОбластьИтогоНДСДанных);
		ТабличныйДокумент.Присоединить(ОбластьИтогоНДССкидок);
		
		Если НЕ ЕстьНДС Тогда
			СуммаНДССтрока = НСтр("ru = 'Без ПДВ';uk='Без ПДВ'", КодЯзыкаПечать);
		Иначе
			СуммаНДССтрока = Строка(СуммаНДС);
		КонецЕсли;
		
		ОбластьИтогоНДССуммы.Параметры.ВсегоНДС = СуммаНДССтрока;
		ТабличныйДокумент.Присоединить(ОбластьИтогоНДССуммы);
		
		
		// Вывести Сумму прописью.
		
		ТекстИтоговойСтроки = НСтр("ru = 'Всего наименований %ВсегоНаименований%, на сумму %Итого%';uk='Усього найменувань %ВсегоНаименований%, на суму %Итого%'", КодЯзыкаПечать);
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%ВсегоНаименований%", ВсегоНаименований);
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%Итого%", ФормированиеПечатныхФормСервер.ФорматСумм(Сумма));
		
		ОбластьСуммаПрописью.Параметры.ИтоговаяСтрока = ТекстИтоговойСтроки;
		ОбластьСуммаПрописью.Параметры.СуммаПрописью = ФормированиеПечатныхФормСервер.СформироватьСуммуПрописью(Сумма, , КодЯзыкаПечать);
		
		ТабличныйДокумент.Вывести(ОбластьСуммаПрописью);
		
		//ПОДПИСИ
		ОбластьПодписей.Параметры.Заполнить(ВыборкаПоДокументам);
		ОбластьПодписей.Параметры.ОтветственныйПредставление = ФормированиеПечатныхФормСервер.ФамилияИнициалыФизЛица(ВыборкаПоДокументам.Ответственный);
		ТабличныйДокумент.Вывести(ОбластьПодписей);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, Новый СписокЗначений, ВыборкаПоДокументам.Ссылка);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
КонецФункции
