////////////////////////////////////////////////////////////////////////////////
// Подсистема "Даты запрета изменения".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает свойства, характеризующие вариант встраивания.
Функция СвойстваРазделов() Экспорт
	
	Свойства = Новый Структура;
	Свойства.Вставить("ИспользоватьВнешнихПользователей", Ложь);
//	LNK 21.12.2016 13:51:53
	Свойства.Вставить("ИспользоватьПриказыНаИнвентаризацию", Истина);
	
	ДатыЗапретаИзмененияПереопределяемый.НастройкаИнтерфейса(Свойства);
	
	Свойства.Вставить("ПустыеСсылкиУзловПлановОбмена", Новый Массив);
	Свойства.Вставить("ИспользоватьДатыЗапретаЗагрузкиДанных", Ложь);
	
	ТипыАдресатаНастройки = Метаданные.РегистрыСведений.ДатыЗапретаИзменения
		.Измерения.Пользователь.Тип.Типы();
	
	Для каждого ТипАдресатаНастройки Из ТипыАдресатаНастройки Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипАдресатаНастройки);
		Если Метаданные.ПланыОбмена.Содержит(ОбъектМетаданных) Тогда
			Свойства.ИспользоватьДатыЗапретаЗагрузкиДанных = Истина;
			Свойства.ПустыеСсылкиУзловПлановОбмена.Добавить(
				ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
					ОбъектМетаданных.ПолноеИмя()).ПустаяСсылка());
		КонецЕсли;
	КонецЦикла;
	
	Свойства.Вставить("ВсеРазделыБезОбъектов", Истина);
	Свойства.Вставить("БезРазделовИОбъектов");
	Свойства.Вставить("ЕдинственныйРаздел");
	Свойства.Вставить("ПоказыватьРазделы");
	Свойства.Вставить("РазделыБезОбъектов",   Новый СписокЗначений);
	Свойства.Вставить("ТипыОбъектовРазделов", Новый ТаблицаЗначений);
	
	Свойства.ТипыОбъектовРазделов.Колонки.Добавить(
		"Раздел", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения"));
	
	Свойства.ТипыОбъектовРазделов.Колонки.Добавить(
		"ТипыОбъекта", Новый ОписаниеТипов("СписокЗначений"));
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	РазделыДатЗапретаИзменения.Ссылка
	|ИЗ
	|	ПланВидовХарактеристик.РазделыДатЗапретаИзменения КАК РазделыДатЗапретаИзменения
	|ГДЕ
	|	РазделыДатЗапретаИзменения.Предопределенный");
	
	УстановитьПривилегированныйРежим(Истина);
	Разделы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Для каждого Раздел ИЗ Разделы Цикл
		
		ОписаниеРаздела = Свойства.ТипыОбъектовРазделов.Добавить();
		ОписаниеРаздела.Раздел = Раздел;
		ОписаниеРаздела.ТипыОбъекта = Новый СписокЗначений;
		
		Для каждого Тип Из Раздел.ТипЗначения.Типы() Цикл
			Если Тип <> Тип("ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения") Тогда
				Если ОбщегоНазначения.ЭтоСсылка(Тип) Тогда
					МетаданныеТипа = Метаданные.НайтиПоТипу(Тип);
					ОписаниеРаздела.ТипыОбъекта.Добавить(
							МетаданныеТипа.ПолноеИмя(),
							МетаданныеТипа.ПредставлениеОбъекта);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если ОписаниеРаздела.ТипыОбъекта.Количество() <> 0 Тогда
			Свойства.ВсеРазделыБезОбъектов = Ложь;
		Иначе
			Свойства.РазделыБезОбъектов.Добавить(Раздел);
		КонецЕсли;
	КонецЦикла;
	
	Свойства.БезРазделовИОбъектов = Разделы.Количество() = 0;
	Свойства.ЕдинственныйРаздел   = Разделы.Количество() = 1;
	Свойства.ПоказыватьРазделы    = НЕ (НЕ Свойства.ВсеРазделыБезОбъектов
	                                    И  Свойства.ЕдинственныйРаздел);
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// См. комментарий в вызывающей функции ДатыЗапретаИзменения.ШаблонДанныхДляПроверки().
Функция ШаблонДанныхДляПроверки() Экспорт
	
	ДанныеДляПроверки = Новый ТаблицаЗначений;
	
	ДанныеДляПроверки.Колонки.Добавить(
	//	"Дата", Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата)));
		"Дата", Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));	//	LNK 22.01.2018 11:07:58
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Раздел", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения"));
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Объект", Метаданные.ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.Тип);
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Склад", Новый ОписаниеТипов("СправочникСсылка.Склады"));	//	LNK 05.01.2018 13:25:51
	
	Возврат ДанныеДляПроверки;
	
КонецФункции

// Возвращает источники данных, заполненные в процедуре
// ДатыЗапретаИзмененияПереопределяемый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения().
//
Функция ИсточникиДанныхДляПроверкиЗапретаИзменения() Экспорт
	
	ИсточникиДанных = Новый ТаблицаЗначений;
	ИсточникиДанных.Колонки.Добавить("Таблица",     Новый ОписаниеТипов("Строка"));
	ИсточникиДанных.Колонки.Добавить("ПолеДаты",    Новый ОписаниеТипов("Строка"));
	ИсточникиДанных.Колонки.Добавить("Раздел",      Новый ОписаниеТипов("Строка"));
	ИсточникиДанных.Колонки.Добавить("ПолеОбъекта", Новый ОписаниеТипов("Строка"));
	ИсточникиДанных.Колонки.Добавить("ПолеСклада" , Новый ОписаниеТипов("Строка"));	//	LNK 05.01.2018 11:07:31
	
	ДатыЗапретаИзмененияПереопределяемый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(
		ИсточникиДанных);
	
	Возврат ИсточникиДанных;
	
КонецФункции
