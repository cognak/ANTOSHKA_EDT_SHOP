////////////////////////////////////////////////////////////////////////////////
// Подсистема "Информационный центр".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Определяет заголовок общей формы "ИнформационныйЦентрРабочийСтол".
//
// Параметры:
//	ЗаголовокФормы - Строка - заголовок формы.
//
Процедура ПриОпределенииЗаголовкаОсновнойФормыИнформационныйЦентр(ЗаголовокФормы) Экспорт
	
	
КонецПроцедуры

// Отправляет сообщение пользователя в техподдержку.
//
// Параметры:
//	ПараметрыСообщения - Структура - параметры сообщения.
//	Результат - Булево - Истина, если сообщение отправлено, Ложь - Иначе.
//
Процедура ПриОтправкеСообщенияПользователяВТехподдержку(ПараметрыСообщения, Результат) Экспорт
	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает Прокси Информационного центра Менеджера сервиса.
//
// Возвращаемое значение:
//	WSПрокси - прокси Информационного центра.
//
Функция ПолучитьПроксиИнформационногоЦентра() Экспорт
	
	ВызватьИсключение(НСтр("ru = 'Не возможно подключиться к Менеджеру сервиса.'"));
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает Прокси Информационного центра Менеджера сервиса.
//
// Возвращаемое значение:
//	WSПрокси - прокси Информационного центра.
//
Функция ПолучитьПроксиИнформационногоЦентра_1_0_1_1() Экспорт
	
	ВызватьИсключение(НСтр("ru = 'Не возможно подключиться к Менеджеру сервиса.'"));
	
	Возврат Неопределено;
	
КонецФункции

// Описывает ссылку сайта для для публикации приложений через Интернет.
// 
// Возвращаемое значение:
//	Структура - структура с полями, которые описывают ссылку сайта. 
//	
Функция НовоеОписаниеСсылкиСайтаДляПубликацииПриложенийЧерезИнтернет() Экспорт 
	
	Возврат Новый Структура("Имя, Адрес");
	
КонецФункции

// Возвращает имя события журнала регистрации.
//
// Возвращаемое значение:
//	Строка - имя события журнала регистрации.
//
Функция ПолучитьИмяСобытияДляЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Информационный центр'");
	
КонецФункции

// Описывает структуру полезной ссылки.
// 
// Возвращаемое значение:
//	Структура - структура с полями, которые описывают полезную ссылку:
//		Имя - Строка - наименование полезной ссылки.
//		Адрес - Строка - адрес полезной ссылки.
//		Пояснение - Строка - пояснение полезной ссылки.
//		ДействиеПоНажатию - Строка - процедура-обработчик для полезной ссылки.
//	
// Примечание:
//	Поле "ДействиеПоНажатию" можно не устанавливать, если подразумевается переход по ссылке.
//
Функция НовоеОписаниеПолезнойСсылки() Экспорт
	
	Возврат Новый Структура("Имя, Адрес, Пояснение, ДействиеПоНажатию");
	
КонецФункции

// Описывает структуру статьи.
// 
// Возвращаемое значение:
//	Структура - структура с полями, которые описывают статью. 
//	
Функция НовоеОписаниеСтатьи() Экспорт
	
	Возврат Новый Структура("Имя, Адрес");
	
КонецФункции	

// Определяет список всех новостей.
//
// Возвращаемое значение:
//	ТаблицаЗначений с полями:
//		Наименование - Строка - заголовок новости.
//		Идентификатор - УникальныйИдентификатор - идентификатор новости.
//		Критичность - Число - критичность новости.
//		ВнешняяСсылка - Строка - адрес внешней ссылки.
//
Функция СформироватьСписокВсехНовостей() Экспорт
	
	ЗапросВсехНовостей = Новый Запрос;
	ЗапросВсехНовостей.Текст = 
	"ВЫБРАТЬ
	|	ОбщиеДанныеИнформационногоЦентра.Наименование КАК Наименование,
	|	ОбщиеДанныеИнформационногоЦентра.Критичность КАК Критичность,
	|	ОбщиеДанныеИнформационногоЦентра.Идентификатор КАК Идентификатор,
	|	ОбщиеДанныеИнформационногоЦентра.ВнешняяСсылка КАК ВнешняяСсылка
	|ИЗ
	|	Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
	|ГДЕ
	|	НЕ ОбщиеДанныеИнформационногоЦентра.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности УБЫВ";
	
	Возврат ЗапросВсехНовостей.Выполнить().Выгрузить();
	
КонецФункции

// Формирует список новостей.
//
// Параметры:
//	ТаблицаНовостей - ТаблицаЗначений с колонками:
//		Наименование - Строка - заголовок новости.
//		Идентификатор - УникальныйИдентификатор - идентификатор новости.
//		Критичность - Число - критичность новости.
//		ВнешняяСсылка - Строка - адрес внешней ссылки.
//	КоличествоВыводимыхНовостей - Число - Количество выводимых новостей на рабочем столе.
//
Процедура СформироватьСписокНовостейНаРабочийСтол(ТаблицаНовостей, Знач КоличествоВыводимыхНовостей = 3) Экспорт
	
	КритичныеНовости = СформироватьАктуальныеКритичныеНовости();
	
	КоличествоКритичныхНовостей = ?(КритичныеНовости.Количество() >= КоличествоВыводимыхНовостей, КоличествоВыводимыхНовостей, КритичныеНовости.Количество());
	
	// Добавление новостей в общую таблицу.
	Если КоличествоКритичныхНовостей > 0 Тогда 
		Для Итерация = 0 по КоличествоКритичныхНовостей - 1 Цикл
			Новость = ТаблицаНовостей.Добавить();
			ЗаполнитьЗначенияСвойств(Новость, КритичныеНовости.Получить(Итерация));
		КонецЦикла;	
	КонецЕсли;
	
	Если КоличествоКритичныхНовостей = КоличествоВыводимыхНовостей Тогда 
		Возврат;
	КонецЕсли;
	
	НеКритичныеНовости = СформироватьАктуальныеНеКритичныеНовости();
	
	КоличествоВыводимыхНеКритичныхНовостей = КоличествоВыводимыхНовостей - КоличествоКритичныхНовостей;
	
	КоличествоВыводимыхНеКритичныхНовостей = ?(НеКритичныеНовости.Количество() < КоличествоВыводимыхНеКритичныхНовостей, НеКритичныеНовости.Количество(), КоличествоВыводимыхНеКритичныхНовостей);
	
	Если НеКритичныеНовости.Количество() > 0 Тогда 
		Для Итерация = 0 по КоличествоВыводимыхНеКритичныхНовостей - 1 Цикл
			Новость = ТаблицаНовостей.Добавить();
			ЗаполнитьЗначенияСвойств(Новость, НеКритичныеНовости.Получить(Итерация));
		КонецЦикла;
	КонецЕсли;
	
	Возврат;
	
КонецПроцедуры

// Возвращает список актуальных критичных новостей (критичность > 5).
//
// Возвращаемое значение:
//	ТаблицаЗначений с полями ТаблицыЗначений "ТаблицаНовостей" в процедуре СформироватьСписокНовостейНаРабочийСтол.
//
Функция СформироватьАктуальныеКритичныеНовости()
	
	ЗапросКритичныхНовостей = Новый Запрос;
	
	ЗапросКритичныхНовостей.УстановитьПараметр("ТекущаяДата",     ТекущаяДатаСеанса());
	ЗапросКритичныхНовостей.УстановитьПараметр("КритичностьПять", 5);
	ЗапросКритичныхНовостей.УстановитьПараметр("ПустаяДата",      '00010101');
	ЗапросКритичныхНовостей.Текст = 
	"ВЫБРАТЬ
	|	ОбщиеДанныеИнформационногоЦентра.Наименование КАК Наименование,
	|	ОбщиеДанныеИнформационногоЦентра.Критичность КАК Критичность,
	|	ОбщиеДанныеИнформационногоЦентра.Идентификатор КАК Идентификатор,
	|	ОбщиеДанныеИнформационногоЦентра.ВнешняяСсылка КАК ВнешняяСсылка
	|ИЗ
	|	Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
	|ГДЕ
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности <= &ТекущаяДата
	|	И ОбщиеДанныеИнформационногоЦентра.Критичность > &КритичностьПять
	|	И (ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности >= &ТекущаяДата
	|			ИЛИ ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности = &ПустаяДата)
	|	И НЕ ОбщиеДанныеИнформационногоЦентра.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Критичность УБЫВ,
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности УБЫВ";
	
	Возврат ЗапросКритичныхНовостей.Выполнить().Выгрузить();
	
КонецФункции	

// Возвращает список актуальных некритичных новостей (критичность <= 5).
//
// Возвращаемое значение:
//	ТаблицаЗначений с полями ТаблицыЗначений "ТаблицаНовостей" в процедуре СформироватьСписокНовостейНаРабочийСтол.
//
Функция СформироватьАктуальныеНеКритичныеНовости()
	
	ЗапросНеКритичныхНовостей = Новый Запрос;
	
	ЗапросНеКритичныхНовостей.УстановитьПараметр("ТекущаяДата",     ТекущаяДатаСеанса());
	ЗапросНеКритичныхНовостей.УстановитьПараметр("КритичностьПять", 5);
	ЗапросНеКритичныхНовостей.УстановитьПараметр("ПустаяДата",      '00010101');
	ЗапросНеКритичныхНовостей.Текст =
	"ВЫБРАТЬ
	|	ОбщиеДанныеИнформационногоЦентра.Наименование КАК Наименование,
	|	ОбщиеДанныеИнформационногоЦентра.Критичность КАК Критичность,
	|	ОбщиеДанныеИнформационногоЦентра.Идентификатор КАК Идентификатор,
	|	ОбщиеДанныеИнформационногоЦентра.ВнешняяСсылка КАК ВнешняяСсылка
	|ИЗ
	|	Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
	|ГДЕ
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности <= &ТекущаяДата
	|	И ОбщиеДанныеИнформационногоЦентра.Критичность <= &КритичностьПять
	|	И (ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности >= &ТекущаяДата
	|			ИЛИ ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности = &ПустаяДата)
	|	И НЕ ОбщиеДанныеИнформационногоЦентра.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности УБЫВ";
	
	Возврат ЗапросНеКритичныхНовостей.Выполнить().Выгрузить();
	
КонецФункции	

// Возвращает ссылку на элемент справочника "ТипыИнформацииИнформационногоЦентра" по Наименованию
//
// Параметры:
//	Наименование - Строка - наименования типа новости.
//
// Возвращаемое значение:
//	СправочникСсылка.ТипыИнформацииИнформационногоЦентра - тип информации.
//
Функция ОпределитьСсылкуТипаИнформации(знач Наименование) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Наименование = СокрЛП(Наименование);
	
	НайденнаяСсылка = Справочники.ТипыИнформацииИнформационногоЦентра.НайтиПоНаименованию(Наименование);
	
	Если НайденнаяСсылка.Пустая() Тогда 
		ТипИнформации = Справочники.ТипыИнформацииИнформационногоЦентра.СоздатьЭлемент();
		ТипИнформации.Наименование = Наименование;
		ТипИнформации.Записать();
		
		Возврат ТипИнформации.Ссылка;
	Иначе	
		Возврат НайденнаяСсылка;
	КонецЕсли;	
	
КонецФункции	

// Возвращает строковое представление версии в числовом диапазоне.
//
// Параметры:
//	Версия - Строка - версия.
//
// Возвращаемое значение:
//	Число - представление версии числом.
//
Функция ПолучитьВерсиюЧислом(Версия) Экспорт
	
	МассивЧисел = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Версия, ".");
	
	Итерация           = 1;
	ВерсияЧислом       = 0;
	КоличествоВМассиве = МассивЧисел.Количество();
	
	Если КоличествоВМассиве = 0 Тогда 
		Возврат 0;
	КонецЕсли;
	
	Для Каждого ЧислоВерсии Из МассивЧисел Цикл 
		
		Попытка
			ТекущееЧисло = Число(ЧислоВерсии);
			ВерсияЧислом = ВерсияЧислом + ТекущееЧисло * ВозвестиЧислоВПоложительнуюСтепень(1000, КоличествоВМассиве - Итерация);
		Исключение
			Возврат 0;
		КонецПопытки;
		
		Итерация = Итерация + 1;
		
	КонецЦикла;
	
	Возврат ВерсияЧислом;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Получение параметров для отправки сообщений пользователя

// Возвращает адрес электронной почты текущего пользователя.
//
// Возвращаемое значение:
//	Строка - адрес электронной почты текущего пользователя.
//
Функция ОпределитьАдресЭлектроннойПочтыПользователя() Экспорт 
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Для каждого СтрокаКонтактнойИнформации из ТекущийПользователь.КонтактнаяИнформация Цикл
		Если Не ПустаяСтрока(СтрокаКонтактнойИнформации.АдресЭП) Тогда 
			Возврат СтрокаКонтактнойИнформации.АдресЭП;
		КонецЕсли;
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

// Возвращает шаблон текста в техподдержку.
//
// Возвращаемое значение:
//	Строка - шаблон текста в техподдержку.
//
Функция СформироватьШаблонТекстаВТехПоддержку() Экспорт
	
	Шаблон = "";
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда 
		Шаблон = НСтр("ru = 'Здравствуйте!
			|<p/>
			|<p/>ПозицияКурсора
			|<p/>
			|С уважением, %1.'");
		Шаблон = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, 
				ПараметрыСеанса.ТекущийПользователь.ПолноеНаименование());
	КонецЕсли;
	
	Возврат Шаблон;
	
КонецФункции

// Возвращает текст технических параметров.
//
// Возвращаемое значение:
//	Соответствие:
//		Ключ - строка - наименование вложения.
//		Значение - ДвоичныеДанные - файл вложения.
//
Функция СформироватьXMLСТехническимиПараметрами() Экспорт
	
	МассивПараметров = ОпределитьМассивТехническихПараметров();
	
	ФайлXML = ПолучитьИмяВременногоФайла("xml");
	
	ТекстXML = Новый ЗаписьXML;
	ТекстXML.ОткрытьФайл(ФайлXML);
	ТекстXML.ЗаписатьОбъявлениеXML();
	ЗаписатьПараметрыВXML(ТекстXML, МассивПараметров);
	ТекстXML.Закрыть();
	
	ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ФайлXML);
	
	Попытка
		УдалитьФайлы(ФайлXML);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Информационный центр. Отправка сообщения в техподдержку. Не удалось удалить временный файл технических параметров.'"), 
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Вложение = Новый СписокЗначений;
	Вложение.Добавить(ДвоичныеДанныеФайла, ПолучитьИмяФайлаТехническихПараметровДляСообщенияВТехПоддержку(), Истина);
	Возврат Вложение;
	
КонецФункции

// Возвращает массив технических параметров.
//
// Возвращаемое значение:
//	Массив  - массив структуры технических параметров с полями:
//		Имя - Строка - имя параметра.
//		Значение - Строка - значение параметра.
//
Функция ОпределитьМассивТехническихПараметров()
	
	ИнформацияСистемная = Новый СистемнаяИнформация;
	
	ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
	ОбластьДанных = Строка(Формат(ОбластьДанных, "ЧГ=0"));
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый Структура("Имя, Значение", "ИмяКонфигурации",	Метаданные.Имя));
	МассивПараметров.Добавить(Новый Структура("Имя, Значение", "ВерсияКонфигурации",Метаданные.Версия));
	МассивПараметров.Добавить(Новый Структура("Имя, Значение", "ВерсияПлатформы",	ИнформацияСистемная.ВерсияПриложения));
	МассивПараметров.Добавить(Новый Структура("Имя, Значение", "ОбластьДанных",		ОбластьДанных));
	МассивПараметров.Добавить(Новый Структура("Имя, Значение", "Логин",				ИмяПользователя()));
	
	Возврат МассивПараметров;
	
КонецФункции	

// Записывает параметры в XML.
//
// Параметры:
//	ТекстXML - ЗаписьXML - запись XML.
//	МассивПараметров - массив параметров.
//
Процедура ЗаписатьПараметрыВXML(ТекстXML, МассивПараметров)
	
	ТекстXML.ЗаписатьНачалоЭлемента("parameters");
	Для Итерация = 0 по МассивПараметров.Количество() - 1 Цикл 
		ТекстXML.ЗаписатьНачалоЭлемента("parameter");
		Элемент = МассивПараметров.Получить(Итерация);
		ТекстXML.ЗаписатьАтрибут(Элемент.Имя, Элемент.Значение);
		ТекстXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
	ТекстXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры	

// Возвращает строку с внешней ссылкой.
//
// Параметры:
//	Идентификатор - УникальныйИдентификатор - уникальный идентификатор новости.
//
// Возвращаемое значение:
//	Строка - адрес внешнего ресурса.
//
Функция ПолучитьВнешнююСсылкуПоИдентификаторуНовости(Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	СсылкаНаДанные	= Справочники.ОбщиеДанныеИнформационногоЦентра.НайтиПоРеквизиту("Идентификатор", Идентификатор);
	Если СсылкаНаДанные.Пустая() Тогда 
		Возврат "";
	КонецЕсли;
	
	Возврат СсылкаНаДанные.ВнешняяСсылка;
	
КонецФункции

// Возвращает имя файла, в котором находятся технические параметры
// для службы техподдержки.
//
// Возвращаемое значение:
//	Строка - имя файла.
//
Функция ПолучитьИмяФайлаТехническихПараметровДляСообщенияВТехПоддержку() Экспорт
	
	Возврат "TechnicalParameters.xml";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Информационные ссылки

// Выводит информационные ссылки на форме.
// В данной процедуре 4 необязательных параметра, это проектное решение БСП.
//
// Параметры:
//	Форма - УправляемаяФорма - контекст формы.
//	ГруппаФормы - ЭлементФормы - группа формы, в которой выводятся информационные ссылки.
//	КоличествоГрупп - Число - количество групп информационных ссылок в форме.
//	КоличествоСсылокВГруппе - Число - количество информационных ссылок в группе.
//	ВыводитьСсылкуВсе - Булево - выводить или нет ссылку "Все".
//
Процедура ВывестиКонтекстныеСсылки(Форма, ГруппаФормы, КоличествоГрупп = 3, КоличествоСсылокВГруппе = 1, ВыводитьСсылкуВсе = Истина, ПутьКФорме = "") Экспорт
	
	Попытка
		Если ПустаяСтрока(ПутьКФорме) Тогда 
			ПутьКФорме = Форма.ИмяФормы;
		КонецЕсли;
		
		ТаблицаСсылокФормы = ИнформационныйЦентрСерверПовтИсп.ПолучитьТаблицуИнформационныхСсылокДляФормы(ПутьКФорме);
		Если ТаблицаСсылокФормы.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		
		// Изменение параметров формы
		ГруппаФормы.ОтображатьЗаголовок = Ложь;
		ГруппаФормы.Подсказка   = "";
		ГруппаФормы.Отображение = ОтображениеОбычнойГруппы.Нет;
		ГруппаФормы.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		
		// Добавление списка Информационных ссылок
		ИмяРеквизита = "ИнформационныеСсылки";
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("СписокЗначений")));
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		СформироватьГруппыВывода(Форма, ТаблицаСсылокФормы, ГруппаФормы, КоличествоГрупп, КоличествоСсылокВГруппе, ВыводитьСсылкуВсе);
	Исключение
		ИмяСобытия = ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Формирует элементы формы информационных ссылок в группе.
//
// Параметры:
//	Форма - УправляемаяФорма - контекст формы.
//	ГруппаФормы - ЭлементФормы - группа формы, в которой выводятся информационные ссылки.
//	КоличествоГрупп - Число - количество групп информационных ссылок в форме.
//	КоличествоСсылокВГруппе - Число - количество информационных ссылок в группе.
//	ВыводитьСсылкуВсе - Булево - выводить или нет ссылку "Все".
//
Процедура СформироватьГруппыВывода(Форма, ТаблицаСсылок, ГруппаФормы, КоличествоГрупп, КоличествоСсылокВГруппе, ВыводитьСсылкуВсе)
	
	ТаблицаСсылок.Сортировать("Вес Убыв");
	
	КоличествоСсылок = ?(ТаблицаСсылок.Количество() > КоличествоГрупп * КоличествоСсылокВГруппе, КоличествоГрупп * КоличествоСсылокВГруппе, ТаблицаСсылок.Количество());
	
	КоличествоГрупп = ?(КоличествоСсылок < КоличествоГрупп, КоличествоСсылок, КоличествоГрупп);
	
	НеполноеНаименованиеГруппы = "ГруппаИнформационныхСсылок";
	
	Для Итерация = 1 По КоличествоГрупп Цикл 
		
		ИмяЭлементаФормы                            = НеполноеНаименованиеГруппы + Строка(Итерация);
		РодительскаяГруппа                          = Форма.Элементы.Добавить(ИмяЭлементаФормы, Тип("ГруппаФормы"), ГруппаФормы);
		РодительскаяГруппа.Вид                      = ВидГруппыФормы.ОбычнаяГруппа;
		РодительскаяГруппа.ОтображатьЗаголовок      = Ложь;
		РодительскаяГруппа.Группировка              = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		РодительскаяГруппа.Отображение              = ОтображениеОбычнойГруппы.Нет;
		
	КонецЦикла;
	
	Для Итерация = 1 По КоличествоСсылок Цикл 
		
		ГруппаСсылки = ПолучитьГруппуСсылок(Форма, КоличествоГрупп, НеполноеНаименованиеГруппы, Итерация);
		
		ИмяСсылки      = ТаблицаСсылок.Получить(Итерация - 1).Наименование;
		Адрес          = ТаблицаСсылок.Получить(Итерация - 1).Адрес;
		Подсказка      = ТаблицаСсылок.Получить(Итерация - 1).Подсказка;
		
		ЭлементСсылки                          = Форма.Элементы.Добавить("ЭлементСсылки" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаСсылки);
		ЭлементСсылки.Вид                      = ВидДекорацииФормы.Надпись;
		ЭлементСсылки.Заголовок                = ИмяСсылки;
		ЭлементСсылки.РастягиватьПоГоризонтали = Истина;
		ЭлементСсылки.Высота                   = 1;
		ЭлементСсылки.Гиперссылка              = Истина;
		ЭлементСсылки.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаИнформационнуюСсылку");
		
		Форма.ИнформационныеСсылки.Добавить(ЭлементСсылки.Имя, Адрес);
		
	КонецЦикла;
	
	Если ВыводитьСсылкуВсе Тогда 
		Элемент                         = Форма.Элементы.Добавить("СсылкаВсеИнформационныеСсылки", Тип("ДекорацияФормы"), ГруппаФормы);
		Элемент.Вид                     = ВидДекорацииФормы.Надпись;
		Элемент.Заголовок               = НСтр("ru = 'Все'");
		Элемент.Гиперссылка             = Истина;
		Элемент.ЦветТекста              = WebЦвета.Черный;
		Элемент.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
		Элемент.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки")
	КонецЕсли;
	
КонецПроцедуры

// Возвращает группу, в которой необходимо выводить информационные ссылки.
//
// Параметры:
//	Форма - УправляемаяФорма - контекст формы.
//	КоличествоГрупп - Число - количество групп с информационными ссылками на форме.
//	НеполноеНаименованиеГруппы - Строка - неполное наименование группы.
//	ТекущаяИтерация - Число - текущая итерация.
//
// Возвращаемое значение:
//	ЭлементФормы - группа информационных ссылок или неопределенно.
//
Функция ПолучитьГруппуСсылок(Форма, КоличествоГрупп, НеполноеНаименованиеГруппы, ТекущаяИтерация)
	
	ИмяГруппы = "";
	
	Для ИтерацияГрупп = 1 По КоличествоГрупп Цикл
		
		Если ТекущаяИтерация % ИтерацияГрупп  = 0 Тогда 
			ИмяГруппы = НеполноеНаименованиеГруппы + Строка(ИтерацияГрупп);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Форма.Элементы.Найти(ИмяГруппы);
	
КонецФункции

// Возводит число в степень.
//
// Параметры:
//	Число - Число - число, возводимое в степень.
//	Степень - Число - степень, в которую необходимо возвести число.
//
// Возвращаемое значение:
//	Число - возведенное в степень число.
//
Функция ВозвестиЧислоВПоложительнуюСтепень(Число, Степень)
	
	Если Степень = 0 Тогда 
		Возврат 1;
	КонецЕсли;
	
	Если Степень = 1 Тогда 
		Возврат Число;
	КонецЕсли;
	
	ВозвращаемоеЧисло = Число;
	
	Для Итерация = 2 по Степень Цикл 
		ВозвращаемоеЧисло = ВозвращаемоеЧисло * Число;
	КонецЦикла;
	
	Возврат ВозвращаемоеЧисло;
	
КонецФункции
