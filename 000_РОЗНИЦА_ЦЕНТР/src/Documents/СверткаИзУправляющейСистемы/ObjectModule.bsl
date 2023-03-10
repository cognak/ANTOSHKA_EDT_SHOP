////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
//	LNK 16.02.2017 14:33:05
	ЗаполнениеОбъектовСобытия.ОбщиеДействияПередЗаписью(ЭтотОбъект, Отказ);
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;	
			
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
    Документы.СверткаИзУправляющейСистемы.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
    ДенежныеСредстваСервер.ОтразитьДенежныеСредстваККМ(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваНаличные(ДополнительныеСвойства, Движения, Отказ);
	ПродажиСервер.ОтразитьПродажиПоДисконтнымКартам(ДополнительныеСвойства, Движения, Отказ);
	Ценообразование.ОтразитьЦеныНоменклатуры(ДополнительныеСвойства, Движения, Отказ);
	АссортиментСервер.ОтразитьКвотыАссортимента(ДополнительныеСвойства, Движения, Отказ);
	АссортиментСервер.ОтразитьАссортимент(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

КонецПроцедуры

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

КонецПроцедуры

// Процедура - обработчик события "ОбработкаПроверкиЗаполнения".
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если СверкаДанных Тогда
		
		ТекстОшибки = НСтр("ru='Документ передан из управляющей системы для сверки данных,
		|проведение такого документа не предусмотрено'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
			
	КонецЕсли;
    	
	Если ОбменДаннымиПовтИсп.ГлавныйУзел() <> Неопределено Тогда
		
		ТекстОшибки = НСтр("ru='Документ можно провести только в главном узле РИБ'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
			
	КонецЕсли;
    
КонецПроцедуры

