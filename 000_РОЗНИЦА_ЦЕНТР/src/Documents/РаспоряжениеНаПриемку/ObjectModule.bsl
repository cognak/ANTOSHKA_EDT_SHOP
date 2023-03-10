
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.РаспоряжениеНаПриемку.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ПроведениеСервер.ОтразитьДвиженияПоРегистру("РекламныеМатериалы",ДополнительныеСвойства, Движения, Отказ);
	ПроведениеСервер.ОтразитьДвиженияПоРегистру("РекламныеМатериалыКПриемке",ДополнительныеСвойства, Движения, Отказ);
	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()

	СписокОбъектов = Новый Массив;
	СписокОбъектов.Добавить(Движения.РекламныеМатериалы);
	СписокОбъектов.Добавить(Движения.РекламныеМатериалыКПриемке);

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", СписокОбъектов);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ЗаполнениеОбъектовСобытия.ОбщиеДействияПередЗаписью(ЭтотОбъект, Отказ);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли; 
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение тогда
		Отказ = КонтрольЗанятостиПлоскостей();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли; 
КонецПроцедуры

Функция КонтрольЗанятостиПлоскостей()
	Отказ = Ложь;
	
	Для Каждого строка из РекламныеМатериалы цикл
		Если ЗначениеЗаполнено(строка.РекламнаяПлоскость)  тогда 
			
		Отказ = ПроверитьСтроку(Строка.РекламнаяПлоскость);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Отказ; 
КонецФункции



Функция ПроверитьСтроку(РекламнаяПлоскость)
	Отказ = Ложь;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РекламныеМатериалы.ДатаС КАК ДатаС,
		|	РекламныеМатериалы.ДатаПо КАК ДатаПо,
		|	РекламныеМатериалы.РекламныйМатериал КАК РекламныйМатериал,
		|	РекламныеМатериалы.РаспоряжениеНаПриемку КАК РаспоряжениеНаПриемку
		|ИЗ
		|	РегистрСведений.РекламныеМатериалы КАК РекламныеМатериалы
		|ГДЕ
		|	РекламныеМатериалы.РекламнаяПлоскость = &РекламнаяПлоскость
		|	И РекламныеМатериалы.Магазин = &Магазин
		|	И (РекламныеМатериалы.ДатаС МЕЖДУ &ДатаС И &ДатаПо
		|			ИЛИ РекламныеМатериалы.ДатаПо МЕЖДУ &ДатаС И &ДатаПо)
		|	И РекламныеМатериалы.Регистратор <> &Регистратор";
	
	Запрос.УстановитьПараметр("ДатаПо", ДатаПо);
	Запрос.УстановитьПараметр("ДатаС", ДатаС);
	Запрос.УстановитьПараметр("Магазин", Магазин);
	Запрос.УстановитьПараметр("РекламнаяПлоскость", РекламнаяПлоскость);
	Запрос.УстановитьПараметр("Регистратор", ЭтотОбъект.Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ТекстСообщения = "";
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
        ТекстСообщения =ТекстСообщения + "Рекламная плоскость " + РекламнаяПлоскость + " занята " +  ВыборкаДетальныеЗаписи.РекламныйМатериал + " с " + выборкаДетальныеЗаписи.ДатаС + " по " + выборкаДетальныеЗаписи.ДатаПо+ "!   ";
	КонецЦикла;
	
	Если НЕ РезультатЗапроса.Пустой() тогда
		Сообщение = Новый СообщениеПользователю;
    	Сообщение.Текст = ТекстСообщения;
        Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Возврат Отказ; 
КонецФункции
