#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение непроверяемых реквизитов
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Проверка условий
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА &Подготовлена = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ПериодичностьРасписания,
	|	ВЫБОР
	|		КОГДА &Подготовлена = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Отчеты,
	|	ВЫБОР
	|		КОГДА &Подготовлена = ИСТИНА
	|				И &ИспользоватьПапку = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Папка,
	|	ВЫБОР
	|		КОГДА &Подготовлена = ИСТИНА
	|				И &ИспользоватьСетевойКаталог = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СетевойКаталогWindows,
	|	ВЫБОР
	|		КОГДА &Подготовлена = ИСТИНА
	|				И &ИспользоватьСетевойКаталог = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СетевойКаталогLinux,
	|	ВЫБОР
	|		КОГДА &Подготовлена = ИСТИНА
	|				И &ИспользоватьFTPРесурс = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК FTPСервер,
	|	ВЫБОР
	|		КОГДА &Подготовлена = ИСТИНА
	|				И &ИспользоватьFTPРесурс = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК FTPПорт,
	|	ВЫБОР
	|		КОГДА &Подготовлена = ИСТИНА
	|				И &ИспользоватьFTPРесурс = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК FTPКаталог,
	|	ВЫБОР
	|		КОГДА &Подготовлена = ИСТИНА
	|				И &ИспользоватьЭлектроннуюПочту = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК УчетнаяЗапись,
	|	ВЫБОР
	|		КОГДА &Подготовлена = ИСТИНА
	|				И &ИспользоватьЭлектроннуюПочту = ИСТИНА
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ВидПочтовогоАдресаПолучателей,
	|	ВЫБОР
	|		КОГДА &Подготовлена = ИСТИНА
	|				И &ИспользоватьЭлектроннуюПочту = ИСТИНА
	|				И &Личная = ЛОЖЬ
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Получатели";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подготовлена",                 Подготовлена);
	Запрос.УстановитьПараметр("ИспользоватьПапку",            ИспользоватьПапку);
	Запрос.УстановитьПараметр("ИспользоватьСетевойКаталог",   ИспользоватьСетевойКаталог);
	Запрос.УстановитьПараметр("ИспользоватьFTPРесурс",        ИспользоватьFTPРесурс);
	Запрос.УстановитьПараметр("ИспользоватьЭлектроннуюПочту", ИспользоватьЭлектроннуюПочту);
	Запрос.УстановитьПараметр("Личная",                       Личная);
	Запрос.Текст = ТекстЗапроса;
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Если Таблица.Количество() > 0 Тогда
		
		Для Каждого Реквизит Из Таблица.Колонки Цикл
			
			Если Таблица[0][Реквизит.Имя] = Истина Тогда
				МассивНепроверяемыхРеквизитов.Добавить(Реквизит.Имя);
			КонецЕсли;

		КонецЦикла;
		
	КонецЕсли;
	
	// Удаление непроверяемых реквизитов
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	 
	// Дополнительный анализ
	Если НЕ Подготовлена И ИспользоватьЭлектроннуюПочту И НЕ Личная Тогда
		Если НЕ ЗначениеЗаполнено(ТипПолучателейРассылки) Тогда
			Отказ = Истина;
			ТекстСообщения = НСтр("ru = 'Поле ""Получатели"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , "ТипПолучателейРассылки");
		КонецЕсли;
		Если Получатели.Количество() > 0 Тогда
			ВключенныеПолучатели = Получатели.НайтиСтроки(Новый Структура("Исключен", Ложь));
			Если ВключенныеПолучатели.Количество() = 0 Тогда
				Отказ = Истина;
				ТекстСообщения = НСтр("ru = 'Необходимо включить хотя бы одного получателя.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Получатели[0].Исключен");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	// Вызывается непосредственно до записи объекта в базу данных
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Создание регламентное задание (получение уникального идентификатора)
	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(РегламентноеЗадание);
	Если Задание = Неопределено Тогда
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(Метаданные.РегламентныеЗадания.РассылкаОтчетов);
		Задание.ИмяПользователя = РассылкаОтчетов.ПолучитьИмяПользователяИБ(Автор);
		Задание.Использование = ВыполнятьПоРасписанию;
		Задание.Наименование = ПредставлениеЗаданияПоРассылке(Наименование);
		Задание.Расписание = ДополнительныеСвойства.Расписание;
		Задание.Записать();
		
 		РегламентноеЗадание = Задание.УникальныйИдентификатор;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	// Соответствие флага подготовленности рассылки и задания пометке удаления рассылки
	Если ПометкаУдаления И Подготовлена Тогда
		Подготовлена = Ложь;
	КонецЕсли;
	
	// Соответствие группы признаку личной рассылки по электронной почте
	// Пользовательские проверки расположены в форме элемента
	// Эти проверки обеспечивают жесткие привязки
	ВыбранаГруппаЛичныхРассылок = (Родитель = Справочники.РассылкиОтчетов.ЛичныеРассылки);
	Если Личная <> ВыбранаГруппаЛичныхРассылок Тогда
		Родитель = ?(Личная, Справочники.РассылкиОтчетов.ЛичныеРассылки, Справочники.РассылкиОтчетов.ПустаяСсылка());
	КонецЕсли;
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(РегламентноеЗадание);
	Если Задание <> Неопределено Тогда
		Задание.Удалить();
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	РегламентноеЗадание = Неопределено;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	// Вызывается непосредственно после записи объекта в базу данных
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(РегламентноеЗадание);
	Если Задание <> Неопределено Тогда
		ЗаданиеИзменено = Ложь;
		
		Если Задание.Использование <> ВыполнятьПоРасписанию Тогда
			Задание.Использование = ВыполнятьПоРасписанию;
			ЗаданиеИзменено = Истина;
		КонецЕсли;
		
		// Расписание устанавливается в форме элемента
		Если ДополнительныеСвойства.Свойство("Расписание") 
				И ТипЗнч(ДополнительныеСвойства.Расписание) = Тип("РасписаниеРегламентногоЗадания")
				И Строка(ДополнительныеСвойства.Расписание) <> Строка(Задание.Расписание)
			Тогда
			Задание.Расписание = ДополнительныеСвойства.Расписание;
			ЗаданиеИзменено = Истина;
		КонецЕсли;
		
		ИмяПользователя = РассылкаОтчетов.ПолучитьИмяПользователяИБ(Автор);
		Если Задание.ИмяПользователя <> ИмяПользователя Тогда
			Задание.ИмяПользователя = ИмяПользователя;
			ЗаданиеИзменено = Истина;
		КонецЕсли;
		
		НаименованиеЗадания = ПредставлениеЗаданияПоРассылке(Наименование);
		Если Задание.Наименование <> НаименованиеЗадания Тогда
			Задание.Наименование = НаименованиеЗадания;
			ЗаданиеИзменено = Истина;
		КонецЕсли;
		
		Если Задание.Параметры.Количество() <> 1 ИЛИ Задание.Параметры[0] <> Ссылка Тогда
			ПараметрыЗадания = Новый Массив;
			ПараметрыЗадания.Добавить(Ссылка);
			Задание.Параметры = ПараметрыЗадания;
			ЗаданиеИзменено = Истина;
		КонецЕсли;
			
		Если ЗаданиеИзменено Тогда
			Задание.Записать();
		КонецЕсли; 
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПредставлениеЗаданияПоРассылке(НаименованиеРассылки)
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Рассылка отчетов: %1'"), 
		СокрЛП(НаименованиеРассылки)
	);
КонецФункции

#КонецЕсли