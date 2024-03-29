#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
///////////////////////////////////////////////////////////////////////////////
#Область ВнешнийИнтерфейс

#Область РеквизитыПараметрыСсылки

// Функция пролучает реквизиты кассы
//
// Параметры:
//  КассаККМ - СправочникСсылка.КассыККМ - Ссылка на кассу ККМ
//
// Возвращаемое значение:
//	Структура - Организация и Валюта выбранной кассы ККМ
//
Функция РеквизитыКассыККМ(КассаККМ) Экспорт

	Если НЕ ПривилегированныйРежим() Тогда	//	LNK 24.02.2023 15:43:54

		УстановитьПривилегированныйРежим(Истина);

	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаСправочник.Ссылка КАК КассаККМ,
	|	ТаблицаСправочник.Владелец КАК Организация,
	|	ТаблицаСправочник.РабочееМесто КАК РабочееМесто,
	|	ТаблицаСправочник.Магазин КАК Магазин,
	|	ТаблицаСправочник.НомерВМагазине КАК НомерВМагазине,
	|	ТаблицаСправочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование,
	|	ЕСТЬNULL(ТаблицаСправочник.ПодключаемоеОборудование.ОбработчикДрайвера, ЗНАЧЕНИЕ(Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ПустаяСсылка)) КАК ОбработчикДрайвера,
	|	ТаблицаСправочник.ШиринаЛенты КАК ШиринаЛенты
	|ИЗ
	|	Справочник.КассыККМ КАК ТаблицаСправочник
	|ГДЕ
	|	ТаблицаСправочник.Ссылка = &КассаККМ"
	);
	Запрос.УстановитьПараметр("КассаККМ", КассаККМ);

	РезультатЗапроса = Запрос.Выполнить();
	Выборка   = РезультатЗапроса.Выбрать();
	Выборка.Следующий();

	СоставРеквизитов = ОбщегоНазначенияРТ.СоздатьСтруктуруПоСтрокеВыборки(РезультатЗапроса
		, Выборка
		, Истина
		, ПолучитьПараметрыКассыККМ(КассаККМ)
		, Ложь
	);

	Возврат СоставРеквизитов;

КонецФункции

//	LNK 08.02.2023 06:17:57 - перенесено
Функция ПолучитьПараметрыКассыККМ(КассаККМ)	Экспорт

	Если НЕ ПривилегированныйРежим() Тогда	//	LNK 14.03.2023 08:31:09

		УстановитьПривилегированныйРежим(Истина);

	КонецЕсли;

	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаСправочник.Магазин КАК Магазин,
	|	Ведущая.КассаККМ КАК КассаККМ,
	|	ЕСТЬNULL(ТаблицаСправочник.ПодключаемоеОборудование, ЗНАЧЕНИЕ(Справочник.ПодключаемоеОборудование.ПустаяСсылка)) КАК ИдентификаторУстройства,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаСправочник.ПодключаемоеОборудование, ЗНАЧЕНИЕ(Справочник.ПодключаемоеОборудование.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.ПодключаемоеОборудование.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИспользоватьБезПодключенияОборудования,
	|	ЕСТЬNULL(ТаблицаСправочник.ПодключаемоеОборудование.ОбработчикДрайвера, ЗНАЧЕНИЕ(Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ПустаяСсылка)) КАК ОбработчикДрайвера,
	|	ЕСТЬNULL(ТаблицаСправочник.ПечатьКодQR, ЛОЖЬ) КАК ПечатьКодQR,
	|	ТаблицаСправочник.ШиринаЛенты КАК ШиринаЛенты,
	|	ЕСТЬNULL(ТаблицаСправочник.ПечатьЧековНаПринтер, ЛОЖЬ) КАК ПечатьЧековНаПринтер,
	|	ЕСТЬNULL(ТаблицаСправочник.ПРРО_ПД_Печать_Z_Отчета, ЛОЖЬ) КАК ПРРО_ПД_Печать_Z_Отчета,
	|	ЕСТЬNULL(ТаблицаСправочник.ПРРО_ПД_ПечатьЧеков, ЛОЖЬ) КАК ПРРО_ПД_ПечатьЧеков,
	|	ЛОЖЬ КАК РасширенныйПериодескийОтчет
	|ИЗ
	|	(ВЫБРАТЬ
	|		&Ссылка КАК КассаККМ) КАК Ведущая
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КассыККМ КАК ТаблицаСправочник
	|		ПО Ведущая.КассаККМ = ТаблицаСправочник.Ссылка"
	);
	Запрос.УстановитьПараметр("Ссылка", КассаККМ);

	РезультатЗапроса = Запрос.Выполнить();
	ПараметрыВыборка = РезультатЗапроса.Выбрать();
	ПараметрыВыборка.Следующий();

	ПараметрыКассы	 = Новый Структура;
	ОбщегоНазначенияРТ.ПеренестиСтрокуВыборкиВСтруктуру(РезультатЗапроса, ПараметрыВыборка, ПараметрыКассы,, Истина); 

	Возврат ПараметрыКассы;

КонецФункции

#КонецОбласти

// Получает кассу по организации и магазину
//
// Параметры:
//  Организация - Справочник Организации
//  Магазин - Справочник Магазины
//
// Вовзращаемое значение:
//  Справочник КассыККМ
//
Функция КассаПоУмолчанию(Организация, Магазин = Неопределено) Экспорт
	Перем КассаПоУмолчанию;
	КассаПоУмолчанию = Справочники.КассыККМ.ПустаяСсылка();
	Запрос = Новый Запрос();
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КассыККМ.Ссылка КАК Касса
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.Владелец = &Организация
	|" + ?(ЗначениеЗаполнено(Магазин), " И КассыККМ.Магазин = &Магазин", "") + "
	|	И НЕ КассыККМ.ПометкаУдаления
	|";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Магазин", Магазин);
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Количество() = 1.00 Тогда
			Выборка.Следующий();
			КассаПоУмолчанию = Выборка.Касса;
		КонецЕсли;
	КонецЕсли;
	Возврат КассаПоУмолчанию;
КонецФункции

Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("Владелец");
	Результат.Добавить("Магазин");
	Результат.Добавить("НомерВМагазине");
	Результат.Добавить("ПРРО");
	
	Возврат Результат;

КонецФункции

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	
	РедактируемыеРеквизиты.Добавить("ФормироватьНефискальныеЧеки");
	РедактируемыеРеквизиты.Добавить("ШиринаЛенты");
	РедактируемыеРеквизиты.Добавить("РучнойРежимФормированияЧека");
	РедактируемыеРеквизиты.Добавить("НоваяФормаЧека");
	РедактируемыеРеквизиты.Добавить("ПечатьКодQR");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

// Процедура получает массивы реквизитов, зависимых от реквизита КассаУправляющейСистемы.
// Параметры:
//           Объект - СправочникСсылка.Кассы или ДинамическийСписок- Элемент правочника для которого устанавливаем доступные реквизиты.
//           МассивВсехРеквизитов - Неопределено - Выходной параметр с типом Массив в который будут помещены имена всех реквизитов справочника
//           МассивРеквизитовОперации - Неопределено - Выходной параметр с типом Массив в который будут помещены имена реквизитов справочника
//
Процедура ПолучитьМассивыРеквизитовЗависимыхОтКассыУправляющейСистемы(Объект, МассивВсехРеквизитов, МассивВидимыхРеквизитов, ДополнительныеСкрываемыеЭлементы = Неопределено) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	Если ДополнительныеСкрываемыеЭлементы = Неопределено Тогда
		ДополнительныеСкрываемыеЭлементы = Новый Структура("Организация");
	КонецЕсли;
	
	МассивВидимыхРеквизитов = Новый Массив;
	Если ТипЗнч(Объект) = Тип("ДинамическийСписок") Тогда
		// процедура вызвана для формы списка
		МассивВсехРеквизитов.Добавить("Наименование");
		МассивВсехРеквизитов.Добавить("Магазин");
		МассивВсехРеквизитов.Добавить("РабочееМесто");
		МассивВсехРеквизитов.Добавить("Организация");
		МассивВсехРеквизитов.Добавить("ОтборМагазин");
		МассивВидимыхРеквизитов.Добавить("Наименование");
		МассивВидимыхРеквизитов.Добавить("Магазин");
		МассивВидимыхРеквизитов.Добавить("РабочееМесто");
		МассивВидимыхРеквизитов.Добавить("Организация");
		МассивВидимыхРеквизитов.Добавить("ОтборМагазин");
		Для Каждого СкрываемоеПоле Из ДополнительныеСкрываемыеЭлементы Цикл
			Если МассивВидимыхРеквизитов.Найти(СкрываемоеПоле.Ключ) <> Неопределено Тогда
				МассивВидимыхРеквизитов.Удалить(МассивВидимыхРеквизитов.Найти(СкрываемоеПоле.Ключ));
			КонецЕсли;
		КонецЦикла;
	Иначе
		// процедура вызвана для формы элемента
		МассивВсехРеквизитов.Добавить("Организация");
		МассивВсехРеквизитов.Добавить("Магазин");
		МассивВсехРеквизитов.Добавить("РабочееМесто");
		МассивВсехРеквизитов.Добавить("Наименование");
		МассивВсехРеквизитов.Добавить("ВнешнееОборудование");
		МассивВсехРеквизитов.Добавить("РегистрационныйНомер");
		МассивВсехРеквизитов.Добавить("СерийныйНомер");
		МассивВсехРеквизитов.Добавить("ШиринаЛенты");
		МассивВсехРеквизитов.Добавить("ШаблонЧекаККМ");
		МассивВсехРеквизитов.Добавить("ФормироватьНефискальныеЧеки");
		МассивВсехРеквизитов.Добавить("РучнойРежимФормированияЧека");
		
		МассивВидимыхРеквизитов.Добавить("Организация");
		МассивВидимыхРеквизитов.Добавить("Магазин");
		МассивВидимыхРеквизитов.Добавить("РабочееМесто");
		МассивВидимыхРеквизитов.Добавить("Наименование");
		МассивВидимыхРеквизитов.Добавить("ВнешнееОборудование");
		МассивВидимыхРеквизитов.Добавить("РегистрационныйНомер");
		МассивВидимыхРеквизитов.Добавить("СерийныйНомер");
		МассивВидимыхРеквизитов.Добавить("ШиринаЛенты");
		МассивВидимыхРеквизитов.Добавить("ШаблонЧекаККМ");
		МассивВидимыхРеквизитов.Добавить("ФормироватьНефискальныеЧеки");
		МассивВидимыхРеквизитов.Добавить("РучнойРежимФормированияЧека");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#КонецЕсли
