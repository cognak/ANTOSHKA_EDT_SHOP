#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Проведение

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = "ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка                КАК Ссылка,
	|	ДанныеДокумента.Дата                  КАК Период,
	|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Магазин               КАК Магазин,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаРасходованиеДенежныхСредств.Утверждена)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                 КАК Утвеждена
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";

	РезультатЗапроса = Запрос.Выполнить();
	Реквизиты = РезультатЗапроса.Выбрать();
	Реквизиты.Следующий();
	
	СтатьяДвиженияДенежныхСредств = ЗначениеНастроекПовтИсп.ПолучитьСтатьюДвиженияДенежныхСредств(Реквизиты.ХозяйственнаяОперация);
	
	ОбщегоНазначенияРТ.ПеренестиСтрокуВыборкиВПараметрыЗапроса(РезультатЗапроса, Реквизиты, Запрос);
	Запрос.УстановитьПараметр("СтатьяДвиженияДенежныхСредств", СтатьяДвиженияДенежныхСредств);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	&Период                                КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Ссылка                                КАК РаспоряжениеНаРасходованиеДенежныхСредств,
	|	РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом     КАК ДокументРасчета,
	|	ВЫБОР
	|		КОГДА РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)
	|			ТОГДА &СтатьяДвиженияДенежныхСредств
	|		ИНАЧЕ РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств
	|	КОНЕЦ                                  КАК СтатьяДвиженияДенежныхСредств,
	|	РасшифровкаПлатежа.Сумма               КАК Сумма,
	|	&ХозяйственнаяОперация                 КАК ХозяйственнаяОперация,
	|	&Магазин                               КАК Магазин
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств.РасшифровкаПлатежа КАК РасшифровкаПлатежа
	|ГДЕ
	|	РасшифровкаПлатежа.Ссылка = &Ссылка И &Утвеждена";
	
	Результат = Запрос.ВыполнитьПакет();
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваКВыплате", Результат[0].Выгрузить());
	
КонецПроцедуры

#КонецЕсли
