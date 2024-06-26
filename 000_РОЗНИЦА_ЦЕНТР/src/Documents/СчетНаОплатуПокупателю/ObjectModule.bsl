#Область ОбработчикиСобытийОбъекта

Процедура ОбработкаПроведения(Отказ, РежимПроведения)


КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
		
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Проведен", Ложь) = Ложь Тогда 
        	ВызватьИсключение "Документ основания должен быть проведен!!!"; 
		КонецЕсли;
		//
		//КредитнаяПрограммаАльфаБанк = Документы.СчетНаОплатуПокупателю.ПроверкаВозвратаАльфаБанк(ДанныеЗаполнения);
		//
		//КредитнаяПрограмма = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "КредитныеПрограммы");
		//КредитнаяПрограммаАльфаБанк = Ложь;
		//Если Не КредитнаяПрограмма = Неопределено Тогда
		//	ВыборкаКредитнаяПрограмма = КредитнаяПрограмма.Выбрать();
		//	Если Не ВыборкаКредитнаяПрограмма.Количество() = 0 Тогда
		//		ВыборкаКредитнаяПрограмма.Следующий();
		//		
		//		КредитРеквизиты = ОбменСБанкамиСервер.ПолучитьДанныеПрограммы(ВыборкаКредитнаяПрограмма.УслугаБанка);
		//		КредитСостояние   = ОбменСБанкамиСервер.ПолучитьСостояниеКредитнойПрограммы(ДанныеЗаполнения, ВыборкаКредитнаяПрограмма.УслугаБанка);
		//		Если КредитРеквизиты.ТипИнтернетБанкинга = Перечисления.ТипыИнтернетБанкинга.Альфабанк
		//			 И КредитРеквизиты.ТипУслуги = Перечисления.ТипыУслугБанка.ОплатаЧастями  
		//			 И КредитСостояние.Статус = Перечисления.СтатусыЗаявкиНаОформлениеКредита.ЗаявкаЗавершена 
		//			 И КредитСостояние.СтатусВозврата = Перечисления.СтатусыЗаявкиНаОформлениеКредита.СозданиеВозврата Тогда 
		//			КредитнаяПрограммаАльфаБанк = Истина;
		//		КонецЕсли;
		//	КонецЕсли;
		//КонецЕсли;
		//
		Если ОбменСБанкамиСервер.ПроверкаСтатусаВозвратаАльфаБанк(ДанныеЗаполнения, Перечисления.СтатусыЗаявкиНаОформлениеКредита.СозданиеВозврата) Тогда 
			ЗаполнитьДокументНаОснованииСчетНаОплатуПокупателю(ДанныеЗаполнения);
		Иначе 
        	ВызватьИсключение "Возврат может быть только по завершонной оплате частями Альфа-банк или для данной программы уже есть возврат!!! "; 
		КонецЕсли;
	Иначе
		ИнициализироватьДокумент(ДанныеЗаполнения);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если ВидОперации.Пустая() Тогда

		Если НЕ КредитныеПрограммы.Количество() = 0 И НЕ КредитныеПрограммы[0].УслугаБанка.Пустая() Тогда
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ТаблицаСправочник.ТипУслуги КАК ТипУслуги
			|ИЗ
			|	Справочник.УслугиБанка КАК ТаблицаСправочник
			|ГДЕ
			|	ТаблицаСправочник.Ссылка = &УслугаБанка"
			);
			Запрос.УстановитьПараметр("УслугаБанка", КредитныеПрограммы[0].УслугаБанка);
			
			Выборка = Запрос.Выполнить().Выбрать();
			Выборка.Следующий();

			ВидОперации = ОбменСБанкамиПовтИсп.ТипыУслугБанкаВидамОперацииСчетуНаОплатуПокупателю(Выборка.ТипУслуги);

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	РеквизитыСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Номер, Дата, Проведен, ПометкаУдаления");
	ДополнительныеСвойства.Вставить("ПометкаУдаления", РеквизитыСсылки.ПометкаУдаления);
	ДополнительныеСвойства.Вставить("Проведен"       , РеквизитыСсылки.Проведен);
	ДополнительныеСвойства.Вставить("Номер"          , РеквизитыСсылки.Номер);
	ДополнительныеСвойства.Вставить("Дата"           , РеквизитыСсылки.Дата);

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли;

	Если ЭтоНовый() Тогда


	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли;


КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	НомерТелефонаПодтвержден = Ложь;
	ОформлениеЗавершено = Ложь;

	СкидкиРассчитаны    = Ложь;
	СкидкиНаценкиСервер.ОтменитьСкидки(ЭтотОбъект, "Товары");

	БонусАкцияСписан = 0;
	БонусБазаСписан  = 0;
	
	Серии.Очистить();
	
	ИнициализироватьДокумент();

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	//ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	//
	//ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	//
	//СформироватьСписокРегистровДляКонтроля();

	//ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	//ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	//ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДокументНаОснованииСчетНаОплатуПокупателю(ДанныеЗаполнения)
	// Заполнение шапки
	Автор = ДанныеЗаполнения.Автор;
	АвторасчетНДС = ДанныеЗаполнения.АвторасчетНДС;
	БонусАкцияСписан = ДанныеЗаполнения.БонусАкцияСписан;
	БонусБазаСписан = ДанныеЗаполнения.БонусБазаСписан;
	ВидОперации = Перечисления.ВидыОперацийСчетНаОплатуПокупателю.ВозвратОплатаЧастями;
	ДисконтнаяКарта = ДанныеЗаполнения.ДисконтнаяКарта;
	Комментарий = ДанныеЗаполнения.Комментарий;
	Контрагент = ДанныеЗаполнения.Контрагент;
	Магазин = ДанныеЗаполнения.Магазин;
	НомерТелефона = ДанныеЗаполнения.НомерТелефона;
	НомерТелефонаПодтвержден = ДанныеЗаполнения.НомерТелефонаПодтвержден;
	Организация = ДанныеЗаполнения.Организация;
	Ответственный = Пользователи.ТекущийПользователь();
	СкидкиРассчитаны = ДанныеЗаполнения.СкидкиРассчитаны;
	СуммаБонусныхБалловСписано = ДанныеЗаполнения.СуммаБонусныхБалловСписано;
	СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	УзелСоздания = ДанныеЗаполнения.УзелСоздания;
	УчитыватьНДС = ДанныеЗаполнения.УчитыватьНДС;
	ЦенаВключаетНДС = ДанныеЗаполнения.ЦенаВключаетНДС;
	Для Каждого ТекСтрокаБонусныеБаллы Из ДанныеЗаполнения.НачислениеБонусныхБаллов Цикл
		НоваяСтрока = НачислениеБонусныхБаллов.Добавить();
		НоваяСтрока.ДатаНачисления = ТекСтрокаБонусныеБаллы.ДатаНачисления;
		НоваяСтрока.ДатаСписания = ТекСтрокаБонусныеБаллы.ДатаСписания;
		НоваяСтрока.ПрограммаЛояльности = ТекСтрокаБонусныеБаллы.ПрограммаЛояльности;
		НоваяСтрока.СуммаБонусныхБаллов = ТекСтрокаБонусныеБаллы.СуммаБонусныхБаллов;
	КонецЦикла;
	Для Каждого ТекСтрокаКредитныеПрограммы Из ДанныеЗаполнения.КредитныеПрограммы Цикл
		НоваяСтрока = КредитныеПрограммы.Добавить();
		НоваяСтрока.КартаКлиентаДляОплатыЧастями = ТекСтрокаКредитныеПрограммы.КартаКлиентаДляОплатыЧастями;
		НоваяСтрока.УслугаБанка = ТекСтрокаКредитныеПрограммы.УслугаБанка;
		НоваяСтрока.УслугаБанкаПериодПредоставления = ТекСтрокаКредитныеПрограммы.УслугаБанкаПериодПредоставления;
	КонецЦикла;
	Для Каждого ТекСтрокаОплата Из ДанныеЗаполнения.Оплата Цикл
		НоваяСтрока = Оплата.Добавить();
		НоваяСтрока.ВидОплаты = ТекСтрокаОплата.ВидОплаты;
		НоваяСтрока.ДанныеПереданыВБанк = ТекСтрокаОплата.ДанныеПереданыВБанк;
		НоваяСтрока.НомерПлатежнойКарты = ТекСтрокаОплата.НомерПлатежнойКарты;
		НоваяСтрока.НомерЧекаЭТ = ТекСтрокаОплата.НомерЧекаЭТ;
		НоваяСтрока.СсылочныйНомер = ТекСтрокаОплата.СсылочныйНомер;
		НоваяСтрока.Сумма = ТекСтрокаОплата.Сумма;
	КонецЦикла;
	Для Каждого ТекСтрокаСерии Из ДанныеЗаполнения.Серии Цикл
		НоваяСтрока = Серии.Добавить();
		НоваяСтрока.Количество = ТекСтрокаСерии.Количество;
		НоваяСтрока.Номенклатура = ТекСтрокаСерии.Номенклатура;
		НоваяСтрока.Серия = ТекСтрокаСерии.Серия;
		НоваяСтрока.Характеристика = ТекСтрокаСерии.Характеристика;
	КонецЦикла;
	Для Каждого ТекСтрокаСерийныеНомера Из ДанныеЗаполнения.СерийныеНомера Цикл
		НоваяСтрока = СерийныеНомера.Добавить();
		НоваяСтрока.КлючСвязиСерийныхНомеров = ТекСтрокаСерийныеНомера.КлючСвязиСерийныхНомеров;
		НоваяСтрока.СерийныйНомер = ТекСтрокаСерийныеНомера.СерийныйНомер;
	КонецЦикла;
	Для Каждого ТекСтрокаСкидкиНаценки Из ДанныеЗаполнения.СкидкиНаценки Цикл
		НоваяСтрока = СкидкиНаценки.Добавить();
		НоваяСтрока.КлючСвязи = ТекСтрокаСкидкиНаценки.КлючСвязи;
		НоваяСтрока.ОграниченаМинимальнойЦеной = ТекСтрокаСкидкиНаценки.ОграниченаМинимальнойЦеной;
		НоваяСтрока.Расшифровка = ТекСтрокаСкидкиНаценки.Расшифровка;
		НоваяСтрока.СкидкаНаценка = ТекСтрокаСкидкиНаценки.СкидкаНаценка;
		НоваяСтрока.СпособПримененияСкидки = ТекСтрокаСкидкиНаценки.СпособПримененияСкидки;
		НоваяСтрока.Сумма = ТекСтрокаСкидкиНаценки.Сумма;
		НоваяСтрока.УникальныйИдентификатор = ТекСтрокаСкидкиНаценки.УникальныйИдентификатор;
	КонецЦикла;
	Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
		НоваяСтрока = Товары.Добавить();
		НоваяСтрока.АкционнаяЦена = ТекСтрокаТовары.АкционнаяЦена;
		НоваяСтрока.БонусАкцияНачислен = ТекСтрокаТовары.БонусАкцияНачислен;
		НоваяСтрока.БонусАкцияСписан = ТекСтрокаТовары.БонусАкцияСписан;
		НоваяСтрока.БонусБазаНачислен = ТекСтрокаТовары.БонусБазаНачислен;
		НоваяСтрока.БонусБазаСписан = ТекСтрокаТовары.БонусБазаСписан;
		НоваяСтрока.КлючСвязи = ТекСтрокаТовары.КлючСвязи;
		НоваяСтрока.КлючСвязиСерийныхНомеров = ТекСтрокаТовары.КлючСвязиСерийныхНомеров;
		НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
		НоваяСтрока.КоличествоУпаковок = ТекСтрокаТовары.КоличествоУпаковок;
		НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
		НоваяСтрока.ПродажаПодарка = ТекСтрокаТовары.ПродажаПодарка;
		НоваяСтрока.ПроцентАвтоматическойСкидки = ТекСтрокаТовары.ПроцентАвтоматическойСкидки;
		НоваяСтрока.ПроцентРучнойСкидки = ТекСтрокаТовары.ПроцентРучнойСкидки;
		НоваяСтрока.СтавкаНДС = ТекСтрокаТовары.СтавкаНДС;
		НоваяСтрока.СтатусУказанияСерий = ТекСтрокаТовары.СтатусУказанияСерий;
		НоваяСтрока.Сумма = ТекСтрокаТовары.Сумма;
		НоваяСтрока.СуммаАвтоматическойСкидки = ТекСтрокаТовары.СуммаАвтоматическойСкидки;
		НоваяСтрока.СуммаБонусныхБалловНачислено = ТекСтрокаТовары.СуммаБонусныхБалловНачислено;
		НоваяСтрока.СуммаБонусныхБалловСписано = ТекСтрокаТовары.СуммаБонусныхБалловСписано;
		НоваяСтрока.СуммаНДС = ТекСтрокаТовары.СуммаНДС;
		НоваяСтрока.СуммаРучнойСкидки = ТекСтрокаТовары.СуммаРучнойСкидки;
		НоваяСтрока.Упаковка = ТекСтрокаТовары.Упаковка;
		НоваяСтрока.Характеристика = ТекСтрокаТовары.Характеристика;
		НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
	КонецЦикла;
КонецПроцедуры

			
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;

	Ответственный = Пользователи.ТекущийПользователь();

	Магазин       = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация, Ответственный);

	УчитыватьНДС     = НДСОбщегоНазначенияСервер.ПоставщикНеплательщикНДС(Организация, Контрагент, Дата, Истина);
	АвторасчетНДС    = НДСИсходящийСервер.ПолучитьФлагАвторасчетНДС(УчитыватьНДС, Магазин, Дата, Ложь);
	
КонецПроцедуры

//Процедура формирует массив имен регистров для контроля проведения
//
Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;

//	При проведении выполняется контроль превышения остатков на складах
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

#КонецОбласти







