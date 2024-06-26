
Перем мТекстСводныхОтчетов, мЕстьОтличия;

#Область ОбработчикиСобытийОбъекта

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

//	LNK 30.05.2020 06:00:36
//	Состояние и наличие подарочных сертификатов НЕ проверяем!
//	Это должно происходить на уровне чека, а теперь уже поздно чего проверять.
//	Есть вероятность, что администратор может добавить какую чушь.. нужно
//	в дальнейшем подумать, как этот момент протоколировать.
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ОтчетОРозничныхПродажах.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПодготовитьНаборыЗаписейКРегистрацииДвижений(Отказ, РежимПроведения);	//	LNK 08.11.2022 06:42:18 - локальный метод
	
	ПродажиСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	ПродажиСервер.ОтразитьПродажиПоДисконтнымКартам(ДополнительныеСвойства, Движения, Отказ);
	ПродажиСервер.ОтразитьПродажиПоПлатежнымКартам(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ПроведениеСервер.ОтразитьДвиженияПоРегистру("ТоварыНаМагазинах", ДополнительныеСвойства, Движения, Отказ); 
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийныхНомеров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваККМ(ДополнительныеСвойства, Движения, Отказ);
//	LNK 13.12.2017 16:24:39
	МотивационнаяПрограммаСервер.ОтразитьПродажиПоЗаказамПокупателей(ДополнительныеСвойства, Движения, Отказ);

	Если НЕ ДополнительныеСвойства.УчетнаяПолитика.ИнтернетМагазин = Магазин Тогда	//	LNK 01.04.2020 08:22:14

	//	LNK 03.10.2017 12:41:28	
		ПроведениеСервер.ОтразитьДвиженияПоРегистру("ЗаказыПокупателей", ДополнительныеСвойства, Движения, Отказ); 

	КонецЕсли;

//	LNK 06.03.2020 12:23:16
	ПроведениеСервер.ОтразитьДвиженияПоРегистру("СостоянияСерийныхНомеров", ДополнительныеСвойства, Движения, Отказ); 

	Если НЕ Движения.СостоянияСерийныхНомеров.Количество() = 0 Тогда	//	очистка, например, и сама доедет.

		Движения.СостоянияСерийныхНомеров.ДополнительныеСвойства.Вставить("УведомитьОбИзменении", Истина);

	КонецЕсли;

	ПроведениеСервер.ОтразитьДвиженияПоРегистру("БонусныеБаллы"			, ДополнительныеСвойства, Движения, Отказ); 
	ПроведениеСервер.ОтразитьДвиженияПоРегистру("БонусныеБаллыВРезерве"	, ДополнительныеСвойства, Движения, Отказ); 
	ПроведениеСервер.ОтразитьДвиженияПоРегистру("СписанныеБонусныеБаллы", ДополнительныеСвойства, Движения, Отказ, "НомерСтрокиДокумента"); 

	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

	Если НЕ Отказ Тогда	//	LNK 03.11.2017 09:25:22

		Если НЕ ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

			СписокПроектов = РозничныеПродажиСервер.ПолучитьПроектыПогашенныхСертификатов(Ссылка);

			Для каждого Проект Из СписокПроектов Цикл

				ТехническаяПоддержка.НазначитьОбъектуДействие(Ссылка, Проект, "ВЕРНУТЬ_СЕРТИФИКАТЫ", Ложь, ПараметрыСеанса.ТекущийПользователь);	//	LNK 09.07.2020 05:48:24

			КонецЦикла;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// В погашении только подарочные сертификаты.
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ВозвращенныеТовары");
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Склад");
	МассивНепроверяемыхРеквизитов.Добавить("ВозвращенныеТовары.Склад");
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ, Новый Структура("ИмяТЧ", "ВозвращенныеТовары"));	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,Документы.ОтчетОРозничныхПродажах.ПараметрыУказанияСерий(ЭтотОбъект),Отказ);
	
	ПродажиСервер.ПроверитьЗаполнениеСклада(
		ЭтотОбъект,
		"Товары",
		Отказ
	);
	
	ПродажиСервер.ПроверитьЗаполнениеСклада(
		ЭтотОбъект,
		"ВозвращенныеТовары",
		Отказ
	);
	
	МаркетинговыеАкцииСервер.ПроверитьЦеныСертификатов(
		ЭтотОбъект,
		"Товары",
		Отказ
	);
	
	МаркетинговыеАкцииСервер.ПроверитьТабличнуюЧастьПогашения(
		ЭтотОбъект,
		Отказ
	);
	
	МаркетинговыеАкцииСервер.ПроверитьЗаполнениеТабличнойЧастиСерийныеНомера(
		ЭтотОбъект,
		"Товары",
		"СерийныеНомера",
		Отказ,,,,
		"Товары"
	);
	
	МаркетинговыеАкцииСервер.ПроверитьЗаполнениеТабличнойЧастиСерийныеНомера(	//	LNK 13.02.2020 09:45:51
		ЭтотОбъект,
		"ВозвращенныеТовары",
		"СерийныеНомера",
		Отказ,,,,
		"ВозвращенныеТовары"
	);
	
	ОбщаяСумма = ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	ОплатаПревышенаОднимВидом = Ложь;
	РеквизитПриСмешанномПревышении = "";
	
//	LNK 11.09.2020 07:00:59 - НИЖЕ удалить позже. 
	//Если ОплатаПодарочнымиСертификатами > ОбщаяСумма Тогда
	//	ТекстОшибки = НСтр("ru='Сумма оплаты подарочными сертификатами превышает сумму документа'");
	//	
	//	РеквизитПриСмешанномПревышении = "ОплатаПодарочнымиСертификатами";
	//	
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
	//		ТекстОшибки,
	//		ЭтотОбъект,
	//		РеквизитПриСмешанномПревышении,
	//		,
	//		Отказ);
	//	ОплатаПревышенаОднимВидом = Истина;
	//КонецЕсли;
	
	СуммаОплатыПлатежнымиКартами = ОплатаПлатежнымиКартами.Итог("Сумма");
	Если СуммаОплатыПлатежнымиКартами > ОбщаяСумма Тогда
		
		ТекстОшибки = НСтр("ru='Сумма оплаты платежными картами превышает сумму документа'");
		
		РеквизитПриСмешанномПревышении = "ОплатаПлатежнымиКартами";
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			РеквизитПриСмешанномПревышении,
			,
			Отказ);
		ОплатаПревышенаОднимВидом = Истина;
	КонецЕсли;
	
	Если НЕ ОплатаПревышенаОднимВидом Тогда
		
		СуммаРазница = (СуммаОплатыПлатежнымиКартами + ОплатаПодарочнымиСертификатами) - ОбщаяСумма;

		Если СуммаРазница > 0 И ОплатаПодарочнымиСертификатами > 0 Тогда

		//	LNK 31.08.2020 09:33:01. Остаток при оплате ПС не гасится. Поэтому можем учесть его в разнице.
			СуммаРазница = Макс(СуммаРазница - ОплатаПодарочнымиСертификатами, 0);

		КонецЕсли;

		Если СуммаРазница > 0 Тогда

			ТекстОшибки = НСтр("ru='Суммы оплаты превышают сумму документа'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				РеквизитПриСмешанномПревышении,
				,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
//	Начисления мотивации выполняются регламентом. Поэтому делаем отметку о необходимости повторного начисления.
//	ВнешниеИсточникиСобытия.УстановитьОбъектДляОбработки("", "НАЧИСЛИТЬ_ПРОГРАММУ_МОТИВАЦИЙ", Ссылка);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
//	LNK 16.02.2017 14:33:05
	ЗаполнениеОбъектовСобытия.ОбщиеДействияПередЗаписью(ЭтотОбъект, Отказ);
	ДополнительныеСвойства.Вставить("УчетнаяПолитика", ОбщегоНазначенияРТповтИсп.ПолучитьУчетнуюПолитику());	//	LNK 01.04.2020 08:23:01
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	ДополнительныеСвойства.Вставить("ПометкаУдаления", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления", Ложь));
	ДополнительныеСвойства.Вставить("Проведен"       , ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Проведен", Ложь));
	ДополнительныеСвойства.Вставить("ЕстьМотивационнаяПрограмма", Ложь);
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;

	СкидкиНаценкиКлиентСервер.РасчитатьПроцентСкидкиПоТабличнойЧасти(Товары, УчитыватьНДС, ЦенаВключаетНДС);				//	LNK 01.07.2021 11:10:12
	СкидкиНаценкиКлиентСервер.РасчитатьПроцентСкидкиПоТабличнойЧасти(ВозвращенныеТовары, УчитыватьНДС, ЦенаВключаетНДС);	//	LNK 01.07.2021 11:10:12

	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И НЕ ДополнительныеСвойства.Проведен = Истина Тогда

		ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения", Истина);

		Для каждого НаборЗаписей Из Движения Цикл

			НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения", Истина);

		КонецЦикла;

	КонецЕсли;
	
//	LNK 20.09.2016 09:50:56
//	NAV:БлокировкаДанныхУчестьДокументВNavision
	Если НЕ ТехническаяПоддержкаВызовСервера.ИсключительныйРежим() И НЕ ЭтоНовый() Тогда

		Если ВнешниеИсточникиСобытия.ПередачаNavision(Ссылка) Тогда

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ «" + СокрЛП(Ссылка) + "» учтён в КСУ Navision! Изменения запрещены. Отказано.", Ссылка,,, Отказ);
			Возврат;

		КонецЕсли;

	КонецЕсли;
	
	ПроверитьНаличиеСсылокВСводномОтчетеПоКассовойСмене();
	
	СуммаВозвратов = ВозвращенныеТовары.Итог("Сумма");
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	ОбщегоНазначенияРТСервер.УдалитьНеиспользуемыеСтрокиСерий(ЭтотОбъект,Документы.ОтчетОРозничныхПродажах.ПараметрыУказанияСерий(ЭтотОбъект));

//	LNK 27.02.2017 12:25:16
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда

		Если АвторасчетНДС И НДСИсходящийСервер.НуженАвторасчетНДС(Товары, ЦенаВключаетНДС,,,,Неопределено) Тогда

			// соответствие для хранения погрешностей округлений
			ПогрешностиОкругления = Новый Соответствие();
			// пересчет сумм НДС с учетом ошибок округления
			НДСИсходящийСервер.ПересчитатьНДСсУчетомПогрешностиОкругления(Товары, ЭтотОбъект, ЦенаВключаетНДС, ПогрешностиОкругления, "Товары", "грн",,, Неопределено);

		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияРТ.УстановитьНовоеЗначениеРеквизита(
		ЭтотОбъект,
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС) - ПолучитьСуммуВозвратовНеЭтойСмены(),
		"СуммаДокумента");

	Если НЕ Отказ Тогда

		РозничныеПродажиСервер.ПроверитьКоличествоПоУпаковкам(Товары);	//	LNK 21.10.2019 10:57:47

	КонецЕсли;

//	\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\/

	Если НЕ ЭтоНовый() Тогда

		УстановитьПривилегированныйРежим(Истина);

		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ТаблицаРегистра.НомерСтроки) КАК Размер
		|ИЗ
		|	РегистрНакопления.НачисленияМотивационныхПрограмм КАК ТаблицаРегистра
		|ГДЕ
		|	ТаблицаРегистра.Регистратор = &Регистратор"
		);
		Запрос.УстановитьПараметр("Регистратор", Ссылка);

		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();

		ДополнительныеСвойства.ЕстьМотивационнаяПрограмма = НЕ Выборка.Размер = 0;

	КонецЕсли;

КонецПроцедуры

//	LNK 20.09.2016 09:50:56
Процедура ПриЗаписи(Отказ)

   	Если ДополнительныеСвойства.ЭтоНовый = Истина Тогда
		УстановитьПривилегированныйРежим(Истина);			
		ОснОрганизация = ОбщегоНазначенияРТ.ПолучитьУчетнуюПолитику().ОсновнаяОрганизация;
		Если Организация = ОснОрганизация тогда
			Для каждого УзелПолучатель Из ОбменBigQueryПовтИсп.ПолучитьМассивУзлов() Цикл
				  ПланыОбмена.ЗарегистрироватьИзменения(УзелПолучатель, Ссылка);
			КонецЦикла;
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);		
	КонецЕсли;	

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли;

//	NAV:БлокировкаДанныхУчестьДокументВNavision
	Если ОбщегоНазначенияКлиентСервер.ЗначениеКлючаСтруктуры(ДополнительныеСвойства, "РегистрацияПередачиВNavision", Ложь) Тогда

		ВнешниеИсточникиСобытия.УстановитьПереданоNavision(Ссылка, ОбщегоНазначенияРТСервер.ПолучитьМагазиныПоОбъекту(Ссылка), Перечисления.ВидыПередачиNavision.ТолькоБлокирован,,,, Истина);

	КонецЕсли;

//	LNK 29.12.2016 16:19:21
	Если НЕ ДополнительныеСвойства.ЭтоНовый = Истина Тогда

		ЖурналСобытий.ФиксироватьСостояниеДокумента(Ссылка, Новый Структура("ПометкаУдаления, Проведен", ПометкаУдаления, Проведен), ДополнительныеСвойства);

	КонецЕсли;

	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение
	ИЛИ  ДополнительныеСвойства.ЕстьМотивационнаяПрограмма = Истина Тогда

	//	ВнешниеИсточникиСобытия.УстановитьОбъектДляОбработки("", "НАЧИСЛИТЬ_ПРОГРАММУ_МОТИВАЦИЙ", Ссылка);

	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	IDN = "";
	КассоваяСмена = Неопределено;

	Серии.Очистить();
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

//	LNK 08.11.2022 07:03:42
Процедура ПодготовитьНаборыЗаписейКРегистрацииДвижений(Отказ, РежимПроведения)

//	Отключим регистрацию в обмены регистры, формируемые только в ЦБ!
//	При этом неважно, где мы сейчас находимся - ЦБ или ПБ.
	ИменаРегистров = Новый Массив;

	Если ДополнительныеСвойства.УчетнаяПолитика.ДвиженияБонусныхБалловТолькоВЦентре = Истина Тогда	//	LNK 08.11.2022 06:37:19

		ИменаРегистров.Добавить("БонусныеБаллы");
		ИменаРегистров.Добавить("БонусныеБаллыВРезерве");
		ИменаРегистров.Добавить("СписанныеБонусныеБаллы");
		ИменаРегистров.Добавить("БонусныеБаллыПоЗаказамПокупателей");
		ИменаРегистров.Добавить("БонусныеБаллыПогашение");
		
	КонецЕсли;

	Для каждого ИмяРегистра Из ИменаРегистров Цикл

		Если НЕ Движения.Найти(ИмяРегистра) = Неопределено Тогда	//	проверка на всякий случай

			Движения[ИмяРегистра].ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов", Истина);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Дата = ?(Дата = '00010101', ТекущаяДата(), Дата);	//	LNK 26.06.2021 07:07:56
	Ответственный = Пользователи.ТекущийПользователь();

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда

		Если ДанныеЗаполнения.Свойство("КассаККМ") Тогда

			КассаККМ      = ДанныеЗаполнения.КассаККМ;
			Магазин       = КассаККМ.Магазин;
			Организация   = КассаККМ.Владелец;

		Иначе

			Магазин       = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);
			Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация, Ответственный);
			КассаККМ      = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(Организация,, КассаККМ, Магазин,);

		КонецЕсли;

	КонецЕсли;

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда

		Если ДанныеЗаполнения.Свойство("КассаККМ")
			И НЕ ЗначениеЗаполнено(КассаККМ) Тогда

			Если ЗначениеЗаполнено(Организация) Тогда

				Если ДанныеЗаполнения.КассаККМ.Владелец <> Организация Тогда
					ДанныеЗаполнения.КассаККМ = Справочники.КассыККМ.ПустаяСсылка();
				КонецЕсли;

			Иначе
				Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.КассаККМ, "Организация");
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	УчитыватьНДС	= НДСОбщегоНазначенияСервер.ОрганизацияКонтрагентПлательщикНДС(Организация, Дата);
	ЦенаВключаетНДС = ОбщегоНазначенияРТСервер.ПолучитьЗначениеРеквизитаВПривилегированномРежиме(Магазин.ПравилоЦенообразования, "ЦенаВключаетНДС");
	АвторасчетНДС   = НДСИсходящийСервер.ПолучитьФлагАвторасчетНДС(УчитыватьНДС, Магазин, Дата, Истина);

КонецПроцедуры

#КонецОбласти

///////////////////////////////////////////////////////////////////////////////
// Прочее

// Рассчитывает сумму неотмененных строк заказа
//
Функция ПолучитьСуммуВозвратовНеЭтойСмены() Экспорт
	
	СуммаВозвратовНеЭтойСмены = 0;
	
	НайденныеСтроки = ВозвращенныеТовары.НайтиСтроки(Новый Структура("ВозвратНеЭтойСмены", Истина));
	Если НайденныеСтроки.Количество() <> 0 Тогда
		
		Строки = ВозвращенныеТовары.Выгрузить(НайденныеСтроки, "Сумма, СуммаНДС");
		Строки.Свернуть( ,"Сумма, СуммаНДС");
		СуммаВозвратовНеЭтойСмены = Строки[0].Сумма + ?(Не ЦенаВключаетНДС, Строки[0].СуммаНДС, 0);
		
	КонецЕсли;
	
	Возврат СуммаВозвратовНеЭтойСмены;
	
КонецФункции

//Процедура формирует массив имен регистров для контроля проведения
//
Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;

	// При проведении выполняется контроль превышения остатков на складах
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение 
		И НЕ ДополнительныеСвойства.Свойство("ЗагрузкаДанныхИзРабочегоМеста") Тогда
		
	//	LNK 13.10.2016 11:56:20
		//Массив.Добавить(Движения.ТоварыНаСкладах);
		//Массив.Добавить(Движения.ДвиженияСерийныхНомеров);
		
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

// Проверяет наличие ссылок на текущий документ в проведенных сводных отчетах по кассовой смене
//
Процедура ПроверитьНаличиеСсылокВСводномОтчетеПоКассовойСмене()
	
	Если ЭтоНовый() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(СводныйОтчетПоКассовойСменеОтчетыОРозничныхПродажах.Ссылка) КАК ПредставлениеСводногоОтчета
	|ИЗ
	|	Документ.СводныйОтчетПоКассовойСмене.ОтчетыОРозничныхПродажах КАК СводныйОтчетПоКассовойСменеОтчетыОРозничныхПродажах
	|ГДЕ
	|	СводныйОтчетПоКассовойСменеОтчетыОРозничныхПродажах.ОтчетОРозничныхПродажах = &ДокументСсылка";
	
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат;
		
	Иначе
		
		мТекстСводныхОтчетов = "";
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ПустаяСтрока(мТекстСводныхОтчетов) Тогда
				
				мТекстСводныхОтчетов = мТекстСводныхОтчетов + "," + Символы.ПС;
				
			КонецЕсли;
			
			мТекстСводныхОтчетов = мТекстСводныхОтчетов + " " + Выборка.ПредставлениеСводногоОтчета;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// определим, есть ли отличия 
	мЕстьОтличия = Ложь;
	Если Ссылка.Проведен <> Проведен Тогда
		
		мЕстьОтличия = Истина;
		
	Иначе
		
		Если Ссылка.КассаККМ <> КассаККМ Тогда
			
			мЕстьОтличия = Истина;
			
		Иначе
			
			//нужно проверять суммы выручки и суммы возвратов
			ЗапросПоСсылке = Новый Запрос;
			ЗапросПоСсылке.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	СУММА(ВложенныйЗапрос.Выручка) КАК Выручка,
			|	СУММА(ВложенныйЗапрос.Возвраты) КАК Возвраты
			|ИЗ
			|	(ВЫБРАТЬ
			|		ВЫБОР
			|			КОГДА ОтчетОРозничныхПродажахТовары.Количество > 0
			|				ТОГДА ВЫБОР
			|						КОГДА ОтчетОРозничныхПродажахТовары.Ссылка.ЦенаВключаетНДС
			|							ТОГДА ОтчетОРозничныхПродажахТовары.Сумма
			|						ИНАЧЕ ОтчетОРозничныхПродажахТовары.Сумма + ОтчетОРозничныхПродажахТовары.СуммаНДС
			|					КОНЕЦ
			|			ИНАЧЕ 0
			|		КОНЕЦ КАК Выручка,
			|		ВЫБОР
			|			КОГДА ОтчетОРозничныхПродажахТовары.Количество < 0
			|				ТОГДА ВЫБОР
			|						КОГДА ОтчетОРозничныхПродажахТовары.Ссылка.ЦенаВключаетНДС
			|							ТОГДА -ОтчетОРозничныхПродажахТовары.Сумма
			|						ИНАЧЕ -(ОтчетОРозничныхПродажахТовары.Сумма + ОтчетОРозничныхПродажахТовары.СуммаНДС)
			|					КОНЕЦ
			|			ИНАЧЕ 0
			|		КОНЕЦ КАК Возвраты,
			|		ОтчетОРозничныхПродажахТовары.Ссылка КАК ОтчетОРозничныхПродажах
			|	ИЗ
			|		Документ.ОтчетОРозничныхПродажах.Товары КАК ОтчетОРозничныхПродажахТовары
			|	ГДЕ
			|		ОтчетОРозничныхПродажахТовары.Ссылка = &ДокументСсылка
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		0,
			|		ВЫБОР
			|			КОГДА ОтчетОРозничныхПродажахВозвращенныеТовары.Ссылка.ЦенаВключаетНДС
			|				ТОГДА ОтчетОРозничныхПродажахВозвращенныеТовары.Сумма
			|			ИНАЧЕ ОтчетОРозничныхПродажахВозвращенныеТовары.Сумма + ОтчетОРозничныхПродажахВозвращенныеТовары.СуммаНДС
			|		КОНЕЦ,
			|		ОтчетОРозничныхПродажахВозвращенныеТовары.Ссылка
			|	ИЗ
			|		Документ.ОтчетОРозничныхПродажах.ВозвращенныеТовары КАК ОтчетОРозничныхПродажахВозвращенныеТовары
			|	ГДЕ
			|		ОтчетОРозничныхПродажахВозвращенныеТовары.Ссылка = &ДокументСсылка) КАК ВложенныйЗапрос";
			
			ЗапросПоСсылке.УстановитьПараметр("ДокументСсылка", Ссылка);
			
			ВыборкаПоСсылке = ЗапросПоСсылке.Выполнить().Выбрать();
			ВыборкаПоСсылке.Следующий();
			
			ЗапросПоОбъекту = Новый Запрос;
			ЗапросПоОбъекту.Текст =
			"ВЫБРАТЬ
			|	ТабличнаяЧастьТовары.Количество,
			|	ТабличнаяЧастьТовары.Сумма,
			|	ТабличнаяЧастьТовары.СуммаНДС
			|ПОМЕСТИТЬ Товары
			|ИЗ
			|	&ТабличнаяЧастьТовары КАК ТабличнаяЧастьТовары
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТабличнаяЧастьВозвращенныеТовары.Сумма,
			|	ТабличнаяЧастьВозвращенныеТовары.СуммаНДС
			|ПОМЕСТИТЬ ВозвращенныеТовары
			|ИЗ
			|	&ТабличнаяЧастьВозвращенныеТовары КАК ТабличнаяЧастьВозвращенныеТовары
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	СУММА(ВложенныйЗапрос.Выручка) КАК Выручка,
			|	СУММА(ВложенныйЗапрос.Возвраты) КАК Возвраты
			|ИЗ
			|	(ВЫБРАТЬ
			|		ВЫБОР
			|			КОГДА Товары.Количество > 0
			|				ТОГДА ВЫБОР
			|						КОГДА &ЦенаВключаетНДС
			|							ТОГДА Товары.Сумма
			|						ИНАЧЕ Товары.Сумма + Товары.СуммаНДС
			|					КОНЕЦ
			|			ИНАЧЕ 0
			|		КОНЕЦ КАК Выручка,
			|		ВЫБОР
			|			КОГДА Товары.Количество < 0
			|				ТОГДА ВЫБОР
			|						КОГДА &ЦенаВключаетНДС
			|							ТОГДА -Товары.Сумма
			|						ИНАЧЕ -(Товары.Сумма + Товары.СуммаНДС)
			|					КОНЕЦ
			|			ИНАЧЕ 0
			|		КОНЕЦ КАК Возвраты
			|	ИЗ
			|		Товары КАК Товары
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		0,
			|		ВЫБОР
			|			КОГДА &ЦенаВключаетНДС
			|				ТОГДА ВозвращенныеТовары.Сумма
			|			ИНАЧЕ ВозвращенныеТовары.Сумма + ВозвращенныеТовары.СуммаНДС
			|		КОНЕЦ
			|	ИЗ
			|		ВозвращенныеТовары КАК ВозвращенныеТовары) КАК ВложенныйЗапрос";
			
			ЗапросПоОбъекту.УстановитьПараметр("ЦенаВключаетНДС", ЦенаВключаетНДС);
			ЗапросПоОбъекту.УстановитьПараметр("ТабличнаяЧастьТовары", Товары);
			ЗапросПоОбъекту.УстановитьПараметр("ТабличнаяЧастьВозвращенныеТовары", ВозвращенныеТовары);
			
			ВыборкаПоОбъекту = ЗапросПоОбъекту.Выполнить().Выбрать();
			ВыборкаПоОбъекту.Следующий();
			
			Если ВыборкаПоСсылке.Выручка <> ВыборкаПоОбъекту.Выручка Или ВыборкаПоСсылке.Возвраты <> ВыборкаПоОбъекту.Возвраты Тогда
				
				мЕстьОтличия = Истина;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если мЕстьОтличия Тогда
		
		Заголовок = "Запись документа: " + ЭтотОбъект;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Изменен документ, который уже был включен в сводный отчет по кассовой смене: " + мТекстСводныхОтчетов + "! " + Символы.ПС + "Рекомендуется заново распечатать сводный отчет!");
		
	КонецЕсли;
	
КонецПроцедуры

//	Подвал
мТекстСводныхОтчетов = "";
мЕстьОтличия         = Ложь;













