#Область ОбработчикиОсновныхсобытийОбъекта

//Процедура - обработчик события "ОбработкаПроверкиЗаполнения"
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЭтоГруппа Тогда
		
		Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
			Если ВидНоменклатуры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга Тогда
				МассивНепроверяемыхРеквизитов.Добавить("ЕдиницаИзмерения");
			КонецЕсли;
		КонецЕсли;
		
		Если ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Номинал");
			МассивНепроверяемыхРеквизитов.Добавить("ТипСрокаДействия");
		КонецЕсли;
		
		Если НЕ ИспользоватьСерийныеНомера Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ТипСерийногоНомера");
		КонецЕсли;
		
		Если ТипСрокаДействия <> Перечисления.СрокДействияПодарочныхСертификатов.СОграничениемНаДату Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ДатаОкончанияДействия");
		КонецЕсли;
		
		Если ТипСрокаДействия <> Перечисления.СрокДействияПодарочныхСертификатов.ПериодПослеПродажи Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Периодичность");
			МассивНепроверяемыхРеквизитов.Добавить("КоличествоПериодовДействия");
		КонецЕсли;
		
		ИспользоватьАссортимент = АссортиментСервер.ПолучитьФункциональнуюОпциюИспользованияАссортимента();
		Если ИспользоватьАссортимент Тогда
			ВладелецКатегории = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТоварнаяКатегория, "Владелец");
			Если ЗначениеЗаполнено(ТоварнаяКатегория) И ВладелецКатегории <> ВидНоменклатуры Тогда
				ТекстСообщения = НСтр("ru = 'Владелец товарной категории не соответствует виду номенклатуры'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					Ссылка,
					"ТоварнаяКатегория",
					"Объект");
				Отказ=Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	
КонецПроцедуры

//Процедура - обработчик события "ПередЗаписью"
//
Процедура ПередЗаписью(Отказ)

	РеквизитыСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Родитель, Эксклюзив, Новинка, НовинкаДо, IDNG");
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("Родитель", РеквизитыСсылки.Родитель);
	ДополнительныеСвойства.Вставить("IDNG"    , РеквизитыСсылки.IDNG);

	УстановитьДатуИзменения(РеквизитыСсылки);
	
//	LNK 06.09.2016 09:19:35
	Если ОбменДанными.Загрузка ИЛИ НЕ ПроверитьУникальностьIDN(Отказ) Тогда
		
		Возврат;
		
	КонецЕсли;

//	LNK 17.01.2017 10:25:38
	Если НЕ ЭтоГруппа
	И НЕ (ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга ИЛИ ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат) Тогда

		НуженТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидНоменклатуры, "ТипНоменклатуры");

		Если НЕ ТипНоменклатуры = НуженТипНоменклатуры Тогда

			ТипНоменклатуры = НуженТипНоменклатуры;

		КонецЕсли;

	ИначеЕсли ЭтоГруппа Тогда

	//	LNK 18.01.2021 06:43:27 - только при загрузке из NAV!
	//	IDNG = Справочники.Номенклатура.СформироватьIDNGroup(IDN, Родитель, Ссылка);

	КонецЕсли;

//	LNK 17.01.2017 10:25:33
	Если ПроверитьДопустимостьЗаписиОбъекта(Отказ) Тогда

		Если НЕ ЭтоГруппа Тогда
			
			Если НЕ (ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат				// +HVOYA. 23.08.2016 22:59:42, Львова Е.А.
				ИЛИ  ТипНоменклатуры = Перечисления.ТипыНоменклатуры.СкидочныйКупон) Тогда
			
				ИспользоватьСерийныеНомера = Ложь;

			КонецЕсли;
					
			Если ЗначениеЗаполнено(НаборУпаковок)
				И НаборУпаковок <> Справочники.НаборыУпаковок.ИндивидуальныйДляНоменклатуры
				И ЕдиницаИзмерения <> НаборУпаковок.ЕдиницаИзмерения Тогда
				
				ЕдиницаИзмерения = НаборУпаковок.ЕдиницаИзмерения; 
				
			КонецЕсли;
				
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

//	LNK 31.01.2017 11:36:35
Процедура ПриЗаписи(Отказ)
	
	Если ЭтоГруппа И ДополнительныеСвойства.Свойство("ОбменДаннымиNavision") И ДополнительныеСвойства.ОбменДаннымиNavision = Истина Тогда

	//	LNK 01.07.2020 09:36:55
		РегистрыСведений.КлассификаторХарактеристикЦенников.КорректировкаИдентификаторов(ДополнительныеСвойства.IDNG, IDNG, Ссылка);

	КонецЕсли;
	
	//А++ 20240918 по задаче Кешбэка
	Если Не ЭтоГруппа Тогда
		РегистрыСведений.ИсторияИзмененияРеквизитовНоменклатуры.ЗаписатьИсториюРеквизита(Ссылка,"Кешбек",Кешбек,ОбменДанными.Загрузка);
	КонецЕсли;
	//А++ 20240918 по задаче Кешбэка

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли;

	Если НЕ ДополнительныеСвойства.ЭтоНовый И НЕ ДополнительныеСвойства.Родитель = Родитель Тогда

		ЖурналСобытий.Регистрация("Номенклатура.Родитель", УровеньЖурналаРегистрации.Предупреждение, Метаданные(), Ссылка,
		, "Родитель изменён с «" + ДополнительныеСвойства.Родитель + "» на «" + Родитель + "»."
		, СокрЛП(Ссылка), Истина);

	КонецЕсли;
	
	
КонецПроцедуры

//Процедура - обработчик события "ОбработкаЗаполнения"
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если НЕ ЭтоГруппа Тогда
		
		ВидНоменклатуры = Справочники.ВидыНоменклатуры.ПолучитьВидНоменклатурыПоУмолчанию();
		
		Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда

			ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидНоменклатуры, "ТипНоменклатуры", Перечисления.ТипыНоменклатуры.Товар, Ложь);

		КонецЕсли;
		
		ЕдиницаИзмерения = Справочники.БазовыеЕдиницыИзмерения.ПолучитьЕдиницуИзмеренияПоУмолчанию();

		IDNG = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "IDNG", "", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ЭтоГруппа Тогда

		ФайлКартинки = Справочники.НоменклатураПрисоединенныеФайлы.ПустаяСсылка();
		НаименованиеПолное = "";

		WEB_АвторепрайсЦен	= Ложь;
		WEB_Выгружать		= Ложь;
		WEB_МониторингЦен	= Ложь;

	КонецЕсли;

	IDN  = "";
	IDNG = "";
	КодИзменения = "";
	
КонецПроцедуры
	
#КонецОбласти

#Область ПоддержкаФункционалаМодуля

//	LNK 06.09.2016 09:20:44
Функция ПроверитьУникальностьIDN(Отказ)

	Если ЭтоНовый() И НЕ ПустаяСтрока(IDN) Тогда

		УстановитьПривилегированныйРежим(Истина);

		ЭлементСправочника = Справочники.Номенклатура.НайтиПоРеквизиту("IDN", IDN);

		Если ЗначениеЗаполнено(ЭлементСправочника) Тогда

			Отказ = Истина;
			ТекстСообщения = "IDN = [" + IDN + "] - блокирована попытка создания дубля! Отказано.";
			ЗаписьЖурналаРегистрации("IDN.Уникальность", УровеньЖурналаРегистрации.Ошибка, Метаданные(), ЭлементСправочника, ТекстСообщения, РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
			Сообщить(ТекстСообщения);

		КонецЕсли;

		УстановитьПривилегированныйРежим(Ложь);

	КонецЕсли;

	Возврат НЕ Отказ;

КонецФункции // ПроверитьУникальностьIDN()

//	LNK 17.01.2017 09:53:09
Функция ПроверитьДопустимостьЗаписиОбъекта(Отказ)

	Если НЕ Справочники.Номенклатура.ТипыИсключенийНоменклатуры().Получить(ТипНоменклатуры) = Истина Тогда

		ЕстьРазрешениеИзменения = (ТехническаяПоддержкаВызовСервера.ИсключительныйРежим() И ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() ИЛИ ПараметрыСеанса.ВыполняютсяСлужебныеДействия)
						ИЛИ ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().ВидУзла = Перечисления.ВидыУзлов.ТестовыйУзел	//	LNK 18.02.2022 11:34:33
						ИЛИ ТехническаяПоддержкаВызовСервера.ОтладочныйРежимРаботы();	//	LNK 21.02.2022 14:17:51

		ЖурналСобытий.Регистрация("Номенклатура", УровеньЖурналаРегистрации.Предупреждение
		, Метаданные()
		, Ссылка
		,
		, "Фиксация изменений справочника «Номенклатура»" + ?(ЕстьРазрешениеИзменения, ". Получено разрешение на изменение.", "")
		, СокрЛП(Ссылка)
		, Истина);

		Если НЕ ЕстьРазрешениеИзменения Тогда

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Отказано. Изменения справочника «Номенклатура» запрещены!",,,, Отказ);

		КонецЕсли;

	КонецЕсли;

	Возврат НЕ Отказ;

КонецФункции

Процедура УстановитьДатуИзменения(РеквизитыСсылки)

	Если НЕ ЭтоНовый() И НЕ ЭтоГруппа И ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

		Если РеквизитыСсылки.Эксклюзив <> Эксклюзив ИЛИ РеквизитыСсылки.Новинка <> Новинка тогда

			ДатаИзменения = ТекущаяДата();

		КонецЕсли;

		Если Новинка тогда

			Если РеквизитыСсылки.НовинкаДо <> НовинкаДо тогда

				Если РеквизитыСсылки.НовинкаДо >= ТекущаяДата() тогда

					Если НовинкаДо < ТекущаяДата() Тогда

						ДатаИзменения = ТекущаяДата();	

					КонецЕсли;				

				Иначе	

					Если НовинкаДо > ТекущаяДата() Тогда

						ДатаИзменения = ТекущаяДата();	

					КонецЕсли; 				

				КонецЕсли;			

			КонецЕсли;

		КонецЕсли;  					

	КонецЕсли;

КонецПроцедуры
	
#КонецОбласти










