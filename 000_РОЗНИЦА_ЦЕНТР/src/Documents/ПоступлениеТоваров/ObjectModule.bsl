
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Если НЕ ПодарочныеСертификатыСервер.ОбработкаПроведенияКонтроль("Поступление", ЭтотОбъект, Отказ) Тогда

		Возврат;	//	LNK 05.03.2020 10:39:13

	КонецЕсли;
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ПоступлениеТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ПроведениеСервер.ОтразитьДвиженияПоРегистру("ТоварыНаМагазинах", ДополнительныеСвойства, Движения, Отказ); 
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКПоступлению(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСебестоимостьНоменклатуры(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийныхНомеров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияНоменклатураПоставщиков(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗакупкиСервер.ОтразитьЗаказыТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗакупкиСервер.ОтразитьЗакупкиТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	ДополнительныеСвойства.Вставить("Отказ", Отказ);
	
	Если ЗначениеЗаполнено(ЗаказПоставщику) Тогда
		ЗакупкиСервер.ОбновитьСостояниеОплатыПоступления(ЗаказПоставщику);
	Иначе
		ЗакупкиСервер.ОбновитьСостояниеОплатыПоступления(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
//	LNK 16.02.2017 14:33:05
	ЗаполнениеОбъектовСобытия.ОбщиеДействияПередЗаписью(ЭтотОбъект, Отказ);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Справочники.СерийныеНомера.ОчиститьВДокументеНеиспользуемыеСерийныеНомера(Товары, СерийныеНомера);
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	ОбщегоНазначенияРТСервер.УдалитьНеиспользуемыеСтрокиСерий(ЭтотОбъект,Документы.ПоступлениеТоваров.ПараметрыУказанияСерий(ЭтотОбъект));
	
//	LNK 24.01.2017 13:53:37
//	NAV:БлокировкаДанныхУчестьДокументВNavision
	Если НЕ ТехническаяПоддержкаВызовСервера.ИсключительныйРежим() И НЕ ЭтоНовый() Тогда

		Если ВнешниеИсточникиСобытия.ПередачаNavision(Ссылка) Тогда

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ «" + СокрЛП(Ссылка) + "» учтён в КСУ Navision! Изменения запрещены. Отказано.", Ссылка,,, Отказ);
			Возврат;

		КонецЕсли;

	КонецЕсли;
	
	Если НЕ ОбщегоНазначенияКлиентСервер.ЗначениеКлючаСтруктуры(ДополнительныеСвойства, "РегистрацияПередачиВNavision", Ложь) Тогда

	//	LNK 19.10.2016 13:41:35
		ПроверитьВозможностьВоздействияПриНаличииПодчиненных(Отказ, РежимЗаписи, РежимПроведения);

	КонецЕсли;
	
	ОбщегоНазначенияРТ.УстановитьНовоеЗначениеРеквизита(
		ЭтотОбъект,
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС),
		"СуммаДокумента");
		
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		УстановитьСтатусЗаказаПоставщикуЗакрыт(Истина);
		Если НЕ ЗначениеЗаполнено(ЗаказПоставщику) Тогда
			ЗакупкиСервер.ДобавитьЭтапОплаты(ЭтотОбъект, Дата);
		КонецЕсли;
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		УстановитьСтатусЗаказаПоставщикуЗакрыт(Ложь);
	КонецЕсли;

//	LNK 24.01.2017 13:54:38
	РеквизитыПоставщика = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контрагент, "Поставщик, РазрешитьПрямуюЗакупку");

	Если НЕ РеквизитыПоставщика.Поставщик = Истина Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Контрагент «" + Контрагент + "» не является поставщиком! Отказано.", Контрагент,,, Отказ);

	КонецЕсли;

	Если НЕ РеквизитыПоставщика.РазрешитьПрямуюЗакупку = Истина Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Прямая закупка контрагенту «" + Контрагент + "» НЕ разрешена! Отказано.", Контрагент,,, Отказ);

	КонецЕсли;
	
КонецПроцедуры

//	LNK 24.01.2017 13:56:31
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда

		Возврат;
		
	КонецЕсли;

//	NAV:БлокировкаДанныхУчестьДокументВNavision
	Если ОбщегоНазначенияКлиентСервер.ЗначениеКлючаСтруктуры(ДополнительныеСвойства, "РегистрацияПередачиВNavision", Ложь) Тогда

		ВнешниеИсточникиСобытия.УстановитьПереданоNavision(Ссылка, ОбщегоНазначенияРТСервер.ПолучитьМагазиныПоОбъекту(Ссылка),,,,, Истина);
		
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ЗакупкиСервер.ОбновитьСостояниеОплатыПоступления(Ссылка);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
		
		ЗаказПоставщику = ДанныеЗаполнения;
		
		ЕстьПоступление = Ложь;
		ПроверитьСуществованиеПоступленийПоЗаказу(ЕстьПоступление, Истина);
		
		Если ЕстьПоступление Тогда
			
			ТекстОшибки = НСтр("ru='По документу %1 уже существуют документы поступления товаров. Ввод на основании документа невозможен'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ЗаказПоставщику);
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(
			ЭтотОбъект,
			ДанныеЗаполнения, 
			"Склад, Магазин, Контрагент, УчитыватьНДС, ЦенаВключаетНДС, Организация");
		
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.Товары, Товары);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаказПоставщику = Документы.ЗаказПоставщику.ПустаяСсылка();
	Серии.Очистить();
	ЭтапыОплат.Очистить();
	ИнициализироватьДокумент();
	
	АссортиментСервер.ПроверитьАссортиментТаблицыТоваровДокументаЗакупки(Магазин, Товары, Дата);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьСуществованиеПоступленийПоЗаказу(Отказ);
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Магазин.СкладУправляющейСистемы Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("ИмяТЧ","ТоварыПоДаннымПоставщика");
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,Документы.ПоступлениеТоваров.ПараметрыУказанияСерий(ЭтотОбъект),Отказ);
	
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ВидПлатежа");
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ДатаПлатежа");
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ДокументВзаимозачета");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеТЧПриНаличииОбменаСУправлениемТорговлей(
		ЭтотОбъект,
		Отказ);
	
	МаркетинговыеАкцииСервер.ПроверитьЗаполнениеТабличнойЧастиСерийныеНомера(
		ЭтотОбъект,
		"Товары",
		"СерийныеНомера",
		Отказ
	);
	
	Если Не ЗначениеЗаполнено(ЗаказПоставщику) Тогда
		ЗакупкиСервер.ПроверитьТабличнуюЧастьЭтапыОплат(ЭтотОбъект, Отказ);
	КонецЕсли;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура проверяет существование документа "Поступление товаров" по заказу поставщику
// 
// Параметры
//  Отказ                     - флаг отказа в проведении,
//
Процедура ПроверитьСуществованиеПоступленийПоЗаказу(Отказ, ТолькоРезультат = Ложь)
	
	Если ЗначениеЗаполнено(ЗаказПоставщику) Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ПРЕДСТАВЛЕНИЕ(ПоступлениеТоваров.Ссылка) КАК ПоступлениеТоваров
		|ИЗ
		|	Документ.ПоступлениеТоваров КАК ПоступлениеТоваров
		|ГДЕ
		|	ПоступлениеТоваров.ЗаказПоставщику = &ЗаказПоставщику
		|	И ПоступлениеТоваров.Ссылка <> &ПоступлениеТоваров
		|	И ПоступлениеТоваров.Проведен");
		
		Запрос.УстановитьПараметр("ЗаказПоставщику", ЗаказПоставщику);
		Запрос.УстановитьПараметр("ПоступлениеТоваров", Ссылка);
		
		РезультатЗапросаПроверкаЗаказа = Запрос.Выполнить();
		
		Если НЕ РезультатЗапросаПроверкаЗаказа.Пустой() Тогда
			
			Если ТолькоРезультат Тогда
				
				Отказ = Истина;
				
			Иначе
				
				ТекстСообщения = НСтр("ru = 'Существуют документы поступления, оформленные по документу %ЗаказПоставщику% :'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения,"%ЗаказПоставщику%",ЗаказПоставщику);
				
				ВыборкаРезультатаПроверкаЗаказа = РезультатЗапросаПроверкаЗаказа.Выбрать();
				
				Пока ВыборкаРезультатаПроверкаЗаказа.Следующий() Цикл
					
					ТекстСообщения = ТекстСообщения + Символы.ПС + 
					НСтр("ru = '%ПоступлениеТоваров%'");
					ТекстСообщения = СтрЗаменить(ТекстСообщения,"%ПоступлениеТоваров%",
												ВыборкаРезультатаПроверкаЗаказа.ПоступлениеТоваров);
					
				КонецЦикла;
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ЗаказПоставщику",
					,
					Отказ);
				
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если ДанныеЗаполнения.Свойство("Склад")
			И НЕ ЗначениеЗаполнено(Склад) Тогда
			Если ЗначениеЗаполнено(Магазин) Тогда
				Если НЕ Справочники.Склады.ПроверитьПринадлежностьСкладаМагазину(Магазин, ДанныеЗаполнения.Склад) Тогда
					ДанныеЗаполнения.Склад = Справочники.Склады.ПустаяСсылка();
				КонецЕсли;
			Иначе
				Магазин = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Склад, "Магазин");
			КонецЕсли;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Организация")
			И НЕ ЗначениеЗаполнено(Организация) Тогда
			БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(ДанныеЗаполнения.Организация,,БанковскийСчетОрганизации);
		КонецЕсли;
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	Магазин       = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация,Ответственный);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоступленияПоУмолчанию(Магазин,,Склад, Ответственный);
	Контрагент    = ЗначениеНастроекПовтИсп.ПолучитьПоставщикаПоУмолчанию(Контрагент, Ответственный);
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация,,БанковскийСчетОрганизации);
	БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);
	
КонецПроцедуры

// Устанавливает статус "Закрыт" заказа поставщику
//
Процедура УстановитьСтатусЗаказаПоставщикуЗакрыт(ЗначениеСтатуса)
	
	Если ЗначениеЗаполнено(ЗаказПоставщику) И НЕ ЗаказПоставщику.Закрыт = ЗначениеСтатуса Тогда
		
		ЗаказПоставщикуОбъект = ЗаказПоставщику.ПолучитьОбъект();
		ЗаказПоставщикуОбъект.Закрыт = ЗначениеСтатуса;
		Если ЗаказПоставщику.Проведен Тогда
			ЗаказПоставщикуОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Иначе
			ЗаказПоставщикуОбъект.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение И НЕ ЗначениеЗаполнено(ЭтотОбъект.ЗаказПоставщику) Тогда
		
		Массив.Добавить(Движения.РасчетыСПоставщиками);
		
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

//	LNK 07.02.2017 16:37:03
Функция ПроверитьВозможностьВоздействияПриНаличииПодчиненных(Отказ, РежимЗаписи, РежимПроведения)

	Если НЕ ЭтоНовый() И НЕ РежимЗаписи = РежимЗаписиДокумента.Запись И НЕ ТехническаяПоддержкаВызовСервера.ИсключительныйРежим() Тогда

		УстановитьПривилегированныйРежим(Истина);

		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаДокумент.Дата,
		|	ТаблицаДокумент.Ссылка КАК Ссылка,
		|	ТаблицаДокумент.Проведен,
		|	ТаблицаДокумент.Представление
		|ПОМЕСТИТЬ Перемещения
		|ИЗ
		|	Документ.ПеремещениеТоваров КАК ТаблицаДокумент
		|ГДЕ
		|	ТаблицаДокумент.ДокументОснование = &ТекущийДокумент
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумент.Дата КАК Дата,
		|	ТаблицаДокумент.Ссылка КАК Ссылка,
		|	ТаблицаДокумент.Проведен,
		|	ТаблицаДокумент.Представление
		|ИЗ
		|	Перемещения КАК ТаблицаДокумент
		|ГДЕ
		|	ТаблицаДокумент.Проведен
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ТаблицаДокумент.Дата,
		|	ТаблицаДокумент.Ссылка,
		|	ТаблицаДокумент.Проведен,
		|	ТаблицаДокумент.Представление
		|ИЗ
		|	Перемещения КАК Перемещения
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриходныйОрдерНаТовары КАК ТаблицаДокумент
		|		ПО Перемещения.Ссылка = ТаблицаДокумент.ДокументОснование
		|ГДЕ
		|	ТаблицаДокумент.Проведен
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ТаблицаДокумент.Дата,
		|	ТаблицаДокумент.Ссылка,
		|	ТаблицаДокумент.Проведен,
		|	ТаблицаДокумент.Представление
		|ИЗ
		|	Перемещения КАК Перемещения
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйОрдерНаТовары КАК ТаблицаДокумент
		|		ПО Перемещения.Ссылка = ТаблицаДокумент.ДокументОснование
		|ГДЕ
		|	ТаблицаДокумент.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	Ссылка"
		);
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		
		Результат = Запрос.Выполнить();

		Если НЕ Результат.Пустой() Тогда

			Отказ = Истина;
			Сообщить("Отказано в «" + РежимЗаписи + "» для " + Ссылка + " по следующим причинам:");

			Выборка = Результат.Выбрать();

			Пока Выборка.Следующий() Цикл

				Сообщить("есть " + ?(Выборка.Проведен, "проведенный", "непроведенный") + " " + Выборка.Представление);

			КонецЦикла;

		КонецЕсли;

	КонецЕсли;

	Возврат НЕ Отказ;

КонецФункции // ПроверитьВозможностьВоздействияПриНаличииПодчиненных()
