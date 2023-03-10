
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваров") Тогда
		
		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
		
		ЗаполнитьЗначенияСвойств(
			ЭтотОбъект, 
			ДанныеЗаполнения,
			"Склад, Магазин, Контрагент, Организация, АвторасчетНДС, УчитыватьНДС, ЦенаВключаетНДС, ДисконтнаяКарта, ВладелецДисконтнойКарты, Продавец");
			
		ДокументОснование = ДанныеЗаполнения;
		
		Для каждого СтрокаТЧ Из ДанныеЗаполнения.Товары Цикл
			
			СтрокаОбъекта = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаОбъекта, СтрокаТЧ);
			СтрокаОбъекта.ДокументПродажи = ДанныеЗаполнения;
			
			СтрокаОбъекта.Цена = ?(СтрокаОбъекта.КоличествоУпаковок = 0, СтрокаОбъекта.Цена, СтрокаОбъекта.Сумма / СтрокаОбъекта.КоличествоУпаковок);
			
		КонецЦикла;

		СерийныеНомера.Загрузить(ДанныеЗаполнения.СерийныеНомера.Выгрузить());

	Иначе

		ВызватьИсключение "Запрещён новый возврат БЕЗ основания (Реализация товаров)";

	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Если НЕ ПодарочныеСертификатыСервер.ОбработкаПроведенияКонтроль("Возврат", ЭтотОбъект, Отказ) Тогда

		Возврат;	//	LNK 05.03.2020 10:39:13

	КонецЕсли;
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ВозвратТоваровОтПокупателя.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПродажиСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	ПродажиСервер.ОтразитьПродажиПоДисконтнымКартам(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ПроведениеСервер.ОтразитьДвиженияПоРегистру("ТоварыНаМагазинах", ДополнительныеСвойства, Движения, Отказ); 
	ЗапасыСервер.ОтразитьТоварыКПоступлению(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);

	ЗапасыСервер.ОтразитьДвиженияСерийныхНомеров(ДополнительныеСвойства, Движения, Отказ);	//	LNK 18.08.2020 09:19:02

//	LNK 19.08.2020 06:51:22
	ПроведениеСервер.ОтразитьДвиженияПоРегистру("СостоянияСерийныхНомеров", ДополнительныеСвойства, Движения, Отказ); 

	Если НЕ Движения.СостоянияСерийныхНомеров.Количество() = 0 Тогда	//	очистка, например, и сама доедет.

		Движения.СостоянияСерийныхНомеров.ДополнительныеСвойства.Вставить("УведомитьОбИзменении", Истина);

	КонецЕсли;

	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Магазин.СкладУправляющейСистемы Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,Документы.ВозвратТоваровОтПокупателя.ПараметрыУказанияСерий(ЭтотОбъект),Отказ);
	
	РазрешитьОформлениеВозвратовОтПокупателяБезДокументовПродажи = УправлениеПользователями.ПолучитьБулевоЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьОформлениеВозвратовОтПокупателяБезДокументовПродажи, Ложь);
	
	Если РазрешитьОформлениеВозвратовОтПокупателяБезДокументовПродажи Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ДокументПродажи");
	КонецЕсли;
	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ПродажиСервер.ПроверитьВозможностьВозвратаОтПокупателя(
		ЭтотОбъект,
		Отказ
	);
	
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
//	LNK 16.02.2017 14:33:05
	ЗаполнениеОбъектовСобытия.ОбщиеДействияПередЗаписью(ЭтотОбъект, Отказ);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	ОбщегоНазначенияРТСервер.УдалитьНеиспользуемыеСтрокиСерий(ЭтотОбъект,Документы.ВозвратТоваровОтПокупателя.ПараметрыУказанияСерий(ЭтотОбъект));
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение И АвторасчетНДС И НДСИсходящийСервер.НуженАвторасчетНДС(Товары, ЦенаВключаетНДС,,,,Неопределено) Тогда
		// соответствие для хранения погрешностей округлений
		ПогрешностиОкругления = Новый Соответствие();
		// пересчет сумм НДС с учетом ошибок округления
		НДСИсходящийСервер.ПересчитатьНДСсУчетомПогрешностиОкругления(Товары, ЭтотОбъект, ЦенаВключаетНДС, ПогрешностиОкругления, "Товары", "грн",,,Неопределено);
		
	КонецЕсли;
	
	ОбщегоНазначенияРТ.УстановитьНовоеЗначениеРеквизита(
		ЭтотОбъект,
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС),
		"СуммаДокумента");

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Серии.Очистить();
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Инициализация и заполнение

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	
	Магазин       = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация,Ответственный);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПродажиПоУмолчанию(Магазин,,Склад, Ответственный);
	Контрагент    = ЗначениеНастроекПовтИсп.ПолучитьПокупателяПоУмолчанию(Контрагент, Ответственный);
	АналитикаХозяйственнойОперации = ЗначениеНастроекПовтИсп.ПолучитьАналитикуХозяйственнойОперацииПоУмолчанию(АналитикаХозяйственнойОперации, Перечисления.ХозяйственныеОперации.ВозвратОтПокупателя);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
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
	КонецЕсли;
	
	Если НЕ Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(ДанныеЗаполнения)) ИЛИ ДанныеЗаполнения = Неопределено Тогда
		УчитыватьНДС     = НДСОбщегоНазначенияСервер.ПоставщикНеплательщикНДС(Организация, Контрагент, Дата, Истина);
		АвторасчетНДС    = НДСИсходящийСервер.ПолучитьФлагАвторасчетНДС(УчитыватьНДС, Магазин, Дата, Ложь);
	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры
