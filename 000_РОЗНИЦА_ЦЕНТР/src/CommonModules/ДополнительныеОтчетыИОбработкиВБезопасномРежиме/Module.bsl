////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки", расширение безопасного режима
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Создает объект ЧтениеXML и инициализирует его данными файла, помещенном во временное хранилище
// по адресу, переданному в качестве значения параметра АдресДвоичныхДанных.
//
// Параметры:
//  АдресДвоичныхДанных - строка, адрес во временном хранилище, по которому были
//    помещены двоичные данные файла,
//  ПараметрыЧтения - ПараметрыЧтенияXML, которые будут использоваться при чтении.
//
// Возвращаемое значение: ЧтениеXML.
//
Функция ЧтениеXMLИзДвоичныхДанных(Знач АдресДвоичныхДанных, Знач ПараметрыЧтения = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	Строка = ДополнительныеОтчетыИОбработкиВБезопасномРежимеВызовСервера.СтрокаИзДвоичныхДанных(
		АдресДвоичныхДанных);
	
	ЧтениеXML = Новый ЧтениеXML();
	ЧтениеXML.УстановитьСтроку(Строка);
	
	Возврат ЧтениеXML;
	
КонецФункции

// Записывает содержимое объекта ЗаписьXML во временный файл, помещает двоичные данные во временное хранилище
// и возвращает адрес двоичных данных файла во временном хранилище.
//
// Параметры:
//  ЗаписьXML - объект типа ЗаписьXML или КаноническаяЗаписьXML, содержимое которого необходимо записать.
//  Адрес - строка или УникальныйИдентификатор, адрес во временном хранилище, по которому надо поместить данные
//    или уникальный идентификатор формы, во временное хранилище которой, надо поместить данные и
//    вернуть новый адрес, см. описание метода глобального контекста ПоместитьВоВременноеХранилище
//    В синтаксис-помощнике.
//
// Возвращаемое значение - строка, адрес во временном хранилище.
//
Функция ЗаписьXMLВДвоичныеДанные(Знач ЗаписьXML, Знач Адрес) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ЗаписьXML.УстановитьСтроку();
	Строка = ЗаписьXML.Закрыть();
	Адрес = ДополнительныеОтчетыИОбработкиВБезопасномРежимеВызовСервера.СтрокаВДвоичныеДанные(
		Строка,
		,
		,
		,
		Адрес
	);
	
КонецФункции

// Создает объект ЧтениеHTML и инициализирует его данными файла, помещенном во временное хранилище
// по адресу, переданному в качестве значения параметра АдресДвоичныхДанных.
//
// Параметры:
//  АдресДвоичныхДанных - строка, адрес во временном хранилище, по которому были
//    помещены двоичные данные файла,
//  Кодировка - строка, указывает кодировку, которая будет использоваться в механизме
//    разбора HTML для преобразования.
//
// Возвращаемое значение: ЧтениеXML.
//
Функция ЧтениеHTMLИзДвоичныхДанных(Знач АдресДвоичныхДанных, Знач Кодировка = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	Строка = ДополнительныеОтчетыИОбработкиВБезопасномРежимеВызовСервера.СтрокаИзДвоичныхДанных(
		АдресДвоичныхДанных);
	
	ЧтениеHTML = Новый ЧтениеHTML();
	ЧтениеHTML.УстановитьСтроку(Строка);
	
	Возврат ЧтениеHTML;
	
КонецФункции

// Записывает содержимое объекта ЗаписьHTML во временный файл, помещает двоичные данные во временное хранилище
// и возвращает адрес двоичных данных файла во временном хранилище.
//
// Параметры:
//  ЗаписьHTML - объект типа ЗаписьHTML, содержимое которого необходимо записать.
//  Адрес - строка или УникальныйИдентификатор, адрес во временном хранилище, по которому надо поместить данные
//    или уникальный идентификатор формы, во временное хранилище которой, надо поместить данные и
//    вернуть новый адрес, см. описание метода глобального контекста ПоместитьВоВременноеХранилище
//    В синтаксис-помощнике.
//
// Возвращаемое значение - строка, адрес во временном хранилище.
//
Функция ЗаписьHTMLВДвоичныеДанные(Знач ЗаписьHTML, Знач Адрес) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ЗаписьHTML.УстановитьСтроку();
	Строка = ЗаписьHTML.Закрыть();
	Адрес = ДополнительныеОтчетыИОбработкиВБезопасномРежимеВызовСервера.СтрокаВДвоичныеДанные(
		Строка,
		,
		,
		,
		Адрес
	);
	
КонецФункции

// Создает объект ЧтениеFastInfoset и инициализирует его данными файла, помещенном во временное хранилище
// по адресу, переданному в качестве значения параметра АдресДвоичныхДанных.
//
// Параметры:
//  АдресДвоичныхДанных - строка, адрес во временном хранилище, по которому были
//    помещены двоичные данные файла.
//
// Возвращаемое значение: ЧтениеFastInfoset.
//
Функция ЧтениеFastInfosetИзДвоичныхДанных(Знач АдресДвоичныхДанных) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	Данные = ПолучитьИзВременногоХранилища(АдресДвоичныхДанных);
	ЧтениеFastInfoset = Новый ЧтениеFastInfoset();
	ЧтениеFastInfoset.УстановитьДвоичныеДанные(Данные);
	
	Возврат ЧтениеFastInfoset;
	
КонецФункции

// Записывает содержимое объекта ЗаписьFastInfoSet во временный файл, помещает двоичные данные во временное хранилище
// и возвращает адрес двоичных данных файла во временном хранилище.
//
// Параметры:
//  ЗаписьFastInfoSet - объект типа ЗаписьFastInfoSet, содержимое которого необходимо записать.
//  Адрес - строка или УникальныйИдентификатор, адрес во временном хранилище, по которому надо поместить данные
//    или уникальный идентификатор формы, во временное хранилище которой, надо поместить данные и
//    вернуть новый адрес, см. описание метода глобального контекста ПоместитьВоВременноеХранилище
//    В синтаксис-помощнике.
//
// Возвращаемое значение - строка, адрес во временном хранилище.
//
Функция ЗаписьFastInfosetВДвоичныеДанные(Знач ЗаписьFastInfoset, Знач Адрес) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ЗаписьFastInfoset.УстановитьДвоичныеДанные();
	Данные = ЗаписьFastInfoset.Закрыть();
	Адрес = ПоместитьВоВременноеХранилище(Данные, Адрес);
	
	Возврат Адрес;
	
КонецФункции

// Функция выполняет создание COM-объекта для использования его в дополнительных
// отчетах и обработках, выполняющихся в контексте сервера.
//
// Объекту, вызывающему функцию, должно быть предоставлено разрешение
// {http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1}CreateComObject
//
// Параметры:
//  КлючСессии - УникальныйИдентификатор, ключ сессии расширения безопасного режима;
//  ProgId - строка, ProgID класса COM, с которым он зарегистрирован в системе.
//    Например, "Excel.Application".
//
// Результат:
//  COMОбъект
//
Функция СоздатьComОбъект(Знач КлючСессии, Знач ProgId) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПроверитьЛегитимностьВыполненияОперации(КлючСессии,
		ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.РазрешениеСозданиеCOMОбъекта(
			ProgId
		)
	);
	
	Возврат Новый COMОбъект(ProgId);
	
КонецФункции

// Функция выполняет подключение внешней компоненты из общего макета конфигурации,
// для использования ее в дополнительных отчетах и обработках, выполняющихся в
// контексте сервера.
//
// Объекту, вызывающему функцию, должно быть предоставлено разрешение
// {http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1}AttachAddin
//
// Параметры:
//  КлючСессии - УникальныйИдентификатор, ключ сессии расширения безопасного режима;
//  ИмяОбщегоМакета - строка, имя общего макета конфигурации, в котором расположена
//    внешняя компонента. Например, "КомпонентаПечатьШтрихкодов",
//  СимволическоеИмя - строка, символическое имя подключаемой внешней компоненты,
//  ТипКомпоненты - ТипВнешнейКомпоненты.
//
// Результат: Булево, Истина - подключение прошло успешно.
//  
//
Функция ПодключитьВнешнююКомпонентуИзОбщегоМакетаКонфигурации(Знач КлючСессии, Знач ИмяОбщегоМакета, Знач СимволическоеИмя, Знач ТипКомпоненты) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПроверитьЛегитимностьВыполненияОперации(КлючСессии,
		ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.РазрешениеПодключениеВнешнейКомпонентыИзОбщегоМакетаКонфигурации(
			ИмяОбщегоМакета
		)
	);
	
	Возврат ПодключитьВнешнююКомпоненту(
		"ОбщийМакет." + ИмяОбщегоМакета,
		СимволическоеИмя,
		ТипКомпоненты
	);
	
КонецФункции

// Функция выполняет подключение внешней компоненты из макета объекта метаданных конфигурации,
// для использования ее в дополнительных отчетах и обработках, выполняющихся в
// контексте сервера.
//
// Объекту, вызывающему функцию, должно быть предоставлено разрешение
// {http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1}AttachAddin
//
// Параметры:
//  КлючСессии - УникальныйИдентификатор, ключ сессии расширения безопасного режима,
//  ОбъектМетаданных, ОбъектМетаданных, которому принадлежит макет с внешней компонентой,
//  ИмяМакета - строка, имя макета конфигурации, в котором расположена
//    внешняя компонента. Например, "КомпонентаПечатьШтрихкодов",
//  СимволическоеИмя - строка, символическое имя подключаемой внешней компоненты,
//  ТипКомпоненты - ТипВнешнейКомпоненты.
//
// Результат: Булево, Истина - подключение прошло успешно.
//  
//
Функция ПодключитьВнешнююКомпонентуИзМакетаКонфигурации(Знач КлючСессии, Знач ОбъектМетаданных, Знач ИмяМакета, Знач СимволическоеИмя, Знач ТипКомпоненты) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПроверитьЛегитимностьВыполненияОперации(КлючСессии,
		ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.РазрешениеПодключениеВнешнейКомпонентыИзМакетаКонфигурации(
			ОбъектМетаданных, ИмяМакета
		)
	);
	
	Возврат ПодключитьВнешнююКомпоненту(
		ОбъектМетаданных.ПолноеИмя() + ".Макет." + ИмяМакета,
		СимволическоеИмя,
		ТипКомпоненты
	);
	
КонецФункции

// Выполняет получение файла из внешнего объекта, помещает полученный файл во временное хранилище
// и возвращает адрес двоичных данных полученного файла во временном хранилище.
//
// Объекту, вызывающему функцию, должно быть предоставлено разрешение
// {http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1}GetFileFromExternalSoftware
//
// Параметры:
//  КлючСессии - УникальныйИдентификатор, ключ сессии расширения безопасного режима;
//  ВнешнийОбъект - ВнешнийОбъект, внешний объект, из которого необходимо получить файл,
//  ИмяМетода - строка, имя метода внешнего объекта, который необходимо вызвать для получения
//    файла из внешнего объекта,
//  Параметры - Массив(Произвольный), параметры вызова метода получения файла из внешнего объекта.
//    Для параметра, в качестве которого должно передаваться имя файла в файловой системе, в массив
//    следует добавлять ОбъектXDTO
//    {http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/a.b.c.d}InternalFileHandler.
//  Адрес - строка или УникальныйИдентификатор, адрес во временном хранилище, по которому надо поместить данные
//    или уникальный идентификатор формы, во временное хранилище которой, надо поместить данные и
//    вернуть новый адрес, см. описание метода глобального контекста ПоместитьВоВременноеХранилище
//    В синтаксис-помощнике.
//
// Возвращаемое значение:
//  Строка, адрес во временном хранилище.
//
Функция ПолучитьФайлИзВнешнегоОбъекта(Знач КлючСессии, ВнешнийОбъект, Знач ИмяМетода, Знач Параметры, Знач Адрес = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПроверитьЛегитимностьВыполненияОперации(КлючСессии,
		ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.РазрешениеПолучениеФайлаИзВнешнегоОбъекта());
	
	ПроверитьКорректностьИмениМетодаВнешнегоОбъекта(ИмяМетода);
	
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	СтрокаПараметров = СформироватьСтрокуПараметровДляМетодаВнешнегоОбъекта(Параметры);
	Выполнить("ВнешнийОбъект." + ИмяМетода + "(" + СтрокаПараметров + ");");
	
	Адрес = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ВременныйФайл), Адрес);
	Попытка
		УдалитьФайлы(ВременныйФайл);
	Исключение
	КонецПопытки;
	Возврат Адрес;
	
КонецФункции

// Выполняет получение файла из временного хранилища и передает его во внешний объект.
//
// Объекту, вызывающему функцию, должно быть предоставлено разрешение
// {http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1}SendFileToExternalSoftware
//
// Параметры:
//  КлючСессии - УникальныйИдентификатор, ключ сессии расширения безопасного режима;
//  ВнешнийОбъект - ВнешнийОбъект, внешний объект, из которого необходимо получить файл,
//  АдресДвоичныхДанных - строка, адрес во временном хранилище, по которому были
//    помещены двоичные данные файла.
//  ИмяМетода - строка, имя метода внешнего объекта, который необходимо вызвать для передачи
//    файла во внешний объект,
//  Параметры - Массив(Произвольный), параметры вызова метода передачи файла во внешний объект.
//    Для параметра, в качестве которого должно передаваться имя файла в файловой системе, в массив
//    следует добавлять ОбъектXDTO
//    {http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/a.b.c.d}InternalFileHandler.
//
Процедура ПередатьФайлВоВнешнийОбъект(Знач КлючСессии, ВнешнийОбъект, Знач АдресДвоичныхДанных, Знач ИмяМетода, Знач Параметры) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПроверитьЛегитимностьВыполненияОперации(КлючСессии,
		ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.РазрешениеПередачаФайлаВоВнешнийОбъект());
	
	ПроверитьКорректностьИмениМетодаВнешнегоОбъекта(ИмяМетода);
	
	ВременныйФайл = ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПолучитьФайлИзВременногоХранилища(АдресДвоичныхДанных);
	СтрокаПараметров = СформироватьСтрокуПараметровДляМетодаВнешнегоОбъекта(Параметры);
	Выполнить("ВнешнийОбъект." + ИмяМетода + "(" + СтрокаПараметров + ");");
	
	Попытка
		УдалитьФайлы(ВременныйФайл);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

// Функция выполняет получение файла из сети Интернет по протоколам HTTP(S)/FTP.
//
// Объекту, вызывающему функцию, должно быть предоставлено разрешение
// {http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1}GetFileFromInternet
//
// Параметры:
//  КлючСессии - УникальныйИдентификатор, ключ сессии расширения безопасного режима;
//  URL - строка, URL файла, который необходимо загрузить,
//  Порт - число, номер сетевого порта,
//  ИмяПользователя - строка, имя пользователя для авторизации на удаленном сервере
//    (необходимо указывать только если для получения файла по указанному URL
//    требуется прохождение авторизации),
//  Пароль - строка, пароль пользователя для прохождения авторизации на удаленном
//    сервере (необходимо указывать только если для получения файла по указанному URL
//    требуется прохождение авторизации),
//  Таймаут - таймаут на выполнение операции в секундах, по-умолчанию - 20 секунд,
//    максимальное значение - 10 минут.
//
// Результат:
//  Строка, адрес во временном хранилище, по которому был помещен файл, полученный по
//    указанному URL.
//
Функция ПолучитьФайлИзИнтернета(Знач КлючСессии, Знач URL, Знач Порт = 0, Знач ИмяПользователя = "", Знач Пароль = "", Знач Таймаут = 20,Знач ЗащищенноеСоединение = Неопределено, Знач ПассивноеСоединение = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	Если Не ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		ВызватьИсключение НСтр("ru = 'В данной конфигурации не поддерживается вызов функции ДополнительныеОтчетыИОбработкиВБезопасномРежиме.ПолучитьФайлИзИнтернета!'");
	КонецЕсли;
	
	ОбработчикПолученияФайлов = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПолучениеФайловИзИнтернетаКлиентСервер");
	
	Если Порт = 0 Тогда
		
		ПолнаяСтруктураURL = ОбработчикПолученияФайлов.СтруктураURI(URL);
		
		Если НЕ ПустаяСтрока(ПолнаяСтруктураURL.Порт) Тогда
			ИмяСервера = ПолнаяСтруктураURL.Хост;
			Порт = ПолнаяСтруктураURL.Порт;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Таймаут > 600 Тогда
		Таймаут = 600;
	КонецЕсли;
	
	СтруктураURL = ОбработчикПолученияФайлов.РазделитьURL(URL);
	Протокол = СтруктураURL.Протокол;
	ИмяСервера = СтруктураURL.ИмяСервера;
	ПутьКФайлуНаСервере  = СтруктураURL.ПутьКФайлуНаСервере;
	
	Если Порт = 0 Тогда
		
		Если ВРег(Протокол) = "HTTP" Тогда
			Порт = 80;
		ИначеЕсли ВРег(Протокол) = "FTP" Тогда
			Порт = 21;
		ИначеЕсли ВРег(Протокол) = "HTTPS" Тогда
			Порт = 443;
		КонецЕсли;
		
	КонецЕсли;
	
	ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПроверитьЛегитимностьВыполненияОперации(КлючСессии,
		ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.РазрешениеПолучениеДанныхИзИнтернет(
			Протокол, ИмяСервера, Порт
		)
	);
	
	Результат = ОбработчикПолученияФайлов.ПодготовитьПолучениеФайла(
		URL,
		ИмяПользователя,
		Пароль,
		Порт,
		Таймаут,
		ЗащищенноеСоединение,
		ПассивноеСоединение,
		Новый Структура(
			"МестоХранения, Путь",
			"ВременноеХранилище",
			Неопределено
		)
	);
	
	Если Результат.Статус Тогда
		Возврат Результат.Путь;
	Иначе
		ВызватьИсключение Результат.СообщениеОбОшибке;
	КонецЕсли;
	
КонецФункции

// Функция выполняет передачу файла в сеть Интернет по протоколам HTTP(S)/FTP.
//
// Объекту, вызывающему функцию, должно быть предоставлено разрешение
// {http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1}SendFileToInternet
//
// Параметры:
//  КлючСессии - УникальныйИдентификатор, ключ сессии расширения безопасного режима;
//  АдресДвоичныхДанных - строка, адрес во временном хранилище, по которому были
//    помещены двоичные данные файла, который необходимо передать в Интернет.
//  URL - строка, URL файла, который необходимо загрузить,
//  Порт - число, номер сетевого порта,
//  ИмяПользователя - строка, имя пользователя для авторизации на удаленном сервере
//    (необходимо указывать только если для получения файла по указанному URL
//    требуется прохождение авторизации),
//  Пароль - строка, пароль пользователя для прохождения авторизации на удаленном
//    сервере (необходимо указывать только если для получения файла по указанному URL
//    требуется прохождение авторизации),
//  Таймаут - таймаут на выполнение операции в секундах, по-умолчанию - 20 секунд,
//    максимальное значение - 10 минут.
//
Функция ПередатьФайлВИнтернет(Знач КлючСессии, Знач АдресДвоичныхДанных, Знач URL, Знач Порт = 0, Знач ИмяПользователя = "", Знач Пароль = "", Знач Таймаут = 20,Знач ЗащищенноеСоединение = Неопределено, Знач ПассивноеСоединение = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	Если Не ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		ВызватьИсключение НСтр("ru = 'В данной конфигурации не поддерживается вызов функции ДополнительныеОтчетыИОбработкиВБезопасномРежиме.ПередатьФайлВИнтернет!'");
	КонецЕсли;
	
	ОбработчикПолученияФайлов = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПолучениеФайловИзИнтернетаКлиентСервер");
	
	Если Порт = 0 Тогда
		
		ПолнаяСтруктураURL = ОбработчикПолученияФайлов.СтруктураURI(URL);
		
		Если НЕ ПустаяСтрока(ПолнаяСтруктураURL.Порт) Тогда
			ИмяСервера = ПолнаяСтруктураURL.Хост;
			Порт = ПолнаяСтруктураURL.Порт;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Таймаут > 600 Тогда
		Таймаут = 600;
	КонецЕсли;
	
	СтруктураURL = ОбработчикПолученияФайлов.РазделитьURL(URL);
	Протокол = СтруктураURL.Протокол;
	ИмяСервера = СтруктураURL.ИмяСервера;
	ПутьКФайлуНаСервере  = СтруктураURL.ПутьКФайлуНаСервере;
	
	ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПроверитьЛегитимностьВыполненияОперации(КлючСессии,
		ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.РазрешениеПередачаДанныхВИнтернет(
			Протокол, ИмяСервера, Порт
		)
	);
	
	ВременныйФайл = ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПолучитьФайлИзВременногоХранилища(АдресДвоичныхДанных);
	
	Если Протокол = "HTTPS" Тогда
		ЗащищенноеСоединение = Истина;
	КонецЕсли;
	
	Прокси = ОбработчикПолученияФайлов.ПолучитьПрокси(Протокол);
	
	ПараметрыСоединения = Новый Массив;
	ПараметрыСоединения.Добавить(ИмяСервера);
	ПараметрыСоединения.Добавить(Порт);
	ПараметрыСоединения.Добавить(ИмяПользователя);
	ПараметрыСоединения.Добавить(Пароль);
	ПараметрыСоединения.Добавить(Прокси);
	
	Если Протокол = "FTP" Тогда
		
		ПараметрыСоединения.Добавить(ПассивноеСоединение);
		
		ПараметрыСоединения.Добавить(Таймаут);
		
		Попытка
			Соединение = Новый(Тип("FTPСоединение"), ПараметрыСоединения);
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			СообщениеОбОшибке = НСтр("ru = 'Ошибка при создании FTP-соединения с сервером %1:'") + Символы.ПС + "%2";
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				СообщениеОбОшибке, ИмяСервера, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
			КонецПопытки;
			
	Иначе
		
		ПараметрыСоединения.Добавить(Таймаут);
		
		Если ЗащищенноеСоединение = Истина Тогда
			ИмяТип = "ЗащищенноеСоединениеOpenSSL";
			ЗащищенноеСоединение = Новый(Тип(ИмяТип));
		Иначе
			ЗащищенноеСоединение = Неопределено;
		КонецЕсли;
		ПараметрыСоединения.Добавить(ЗащищенноеСоединение);
		
		Попытка
			Соединение = Новый(Тип("HTTPСоединение"), ПараметрыСоединения);
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			СообщениеОбОшибке = НСтр("ru = 'Ошибка при создании HTTP-соединения с сервером %1:'") + Символы.ПС + "%2";
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ИмяСервера, 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
		КонецПопытки;
	КонецЕсли;
	
	Попытка
		Соединение.Записать(ВременныйФайл, ПутьКФайлуНаСервере);
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СообщениеОбОшибке = НСтр("ru = 'Ошибка при передаче файла на сервер %1:'") + Символы.ПС + "%2";
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ИмяСервера, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
	КонецПопытки;
	
КонецФункции

// Функция создает объект WSПрокси для подключения к веб-сервису.
//
// Объекту, вызывающему функцию, должно быть предоставлено разрешение
// {http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1}SoapConnect
//
// Параметры:
//  КлючСессии - УникальныйИдентификатор, ключ сессии расширения безопасного режима;
//  АдресWSDL - Строка - месторасположение wsdl
//  URIПространстваИмен - Строка - URI пространства имен web-сервиса
//  ИмяСервиса - Строка - имя сервиса
//  ИмяТочкиПодключения - Строка - если не задано, образуется как <ИмяСервиса>Soap
//  ИмяПользователя - Строка - имя пользователя для входа на сервер
//  Пароль - Строка - пароль пользователя
//  Таймаут - Число - таймаут на операции выполняемые через полученное прокси 
//
// Возвращаемое значение: WSПрокси.
//
Функция WSСоединение(Знач КлючСессии, Знач АдресWSDL, Знач URIПространстваИмен, Знач ИмяСервиса, Знач ИмяТочкиПодключения = "", Знач ИмяПользователя = "", Знач Пароль = "", Знач Таймаут = 20) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	Если Таймаут > 600 Тогда
		Таймаут = 600;
	КонецЕсли;
	
	ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПроверитьЛегитимностьВыполненияОперации(КлючСессии,
		ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.РазрешениеWSСоединение(
			АдресWSDL
		)
	);
	
	Возврат ОбщегоНазначения.WSПрокси(
		АдресWSDL,
		URIПространстваИмен,
		ИмяСервиса,
		ИмяТочкиПодключения,
		ИмяПользователя,
		Пароль,
		Таймаут
	);
	
КонецФункции

// Функция выполняет запись документов с проведением / отменой проведения.
//
// Объекту, вызывающему функцию, должно быть предоставлено разрешение
// {http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1}DocumentPosting
//
// Параметры:
//  КлючСессии - УникальныйИдентификатор, ключ сессии расширения безопасного режима;
//  Документы - Массив(ДокументОбъект), массив документов, которые необходимо записать,
//  РежимЗаписи - РежимЗаписиДокумента, режим, в котором необходимо записывать документы.
//  РежимПроведения - РежимПроведенияДокумента.
//
Функция ПроведениеДокументов(Знач КлючСессии, Документы, Знач РежимЗаписи = Неопределено, Знач РежимПроведения = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	Если РежимЗаписи = Неопределено Тогда
		РежимЗаписи = РежимЗаписиДокумента.Запись;
	КонецЕсли;
	
	Если РежимПроведения = Неопределено Тогда
		РежимПроведения = РежимПроведенияДокумента.Оперативный;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого Документ Из Документы Цикл
			
			Если РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
				
				Если Документ.Проведен Тогда
					ПроверяемыйРежимЗаписи = РежимЗаписиДокумента.Проведение;
				Иначе
					ПроверяемыйРежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения;
				КонецЕсли;
				
			Иначе
				
				ПроверяемыйРежимЗаписи = РежимЗаписи;
				
			КонецЕсли;
			
			ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПроверитьЛегитимностьВыполненияОперации(КлючСессии,
				ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.РазрешениеПроведениеДокументов(
					Документ.Метаданные().ПолноеИмя, ПроверяемыйРежимЗаписи
				)
			);
			
			Документ.Записать(РежимЗаписи, РежимПроведения);
			
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьКорректностьИмениМетодаВнешнегоОбъекта(Знач ИмяМетода)
	
	ЗапрещенныеСимволы = Новый Массив();
	ЗапрещенныеСимволы.Добавить(",");
	ЗапрещенныеСимволы.Добавить("(");
	ЗапрещенныеСимволы.Добавить(")");
	ЗапрещенныеСимволы.Добавить(";");
	
	Для Каждого ЗапрещенныйСимвол Из ЗапрещенныеСимволы Цикл
		
		Если Найти(ИмяМетода, ЗапрещенныйСимвол) > 0 Тогда
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 не является корректным именем метода для COM-объекта или объекта внешней компоненты!'"),
				ИмяМетода
			);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция СформироватьСтрокуПараметровДляМетодаВнешнегоОбъекта(Знач Параметры)
	
	СтрокаПараметров = "";
	Итератор = 0;
	Для Каждого Параметр Из Параметры Цикл
		
		Если Не ПустаяСтрока(СтрокаПараметров) Тогда
			СтрокаПараметров = СтрокаПараметров + ", ";
		КонецЕсли;
		
		ПередачаФайла = Ложь;
		Если ТипЗнч(Параметр) = Тип("ТипОбъектаXDTO") Тогда
			Если Параметр = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ПараметрПередаваемыйФайл() Тогда
				ПередачаФайла = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ПередачаФайла Тогда
			СтрокаПараметров = СтрокаПараметров + "ВременныйФайл";
		Иначе
			СтрокаПараметров = СтрокаПараметров + "Параметры[" + Формат(Итератор, "ЧДЦ=0; ЧН=0; ЧГ=0") + "]";
		КонецЕсли;
		
		Итератор = Итератор + 1;
		
	КонецЦикла;
	
	Возврат СтрокаПараметров;
	
КонецФункции

Процедура ПроверитьКорректностьВызоваПоОкружению()
	
	Если Не ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПроверитьКорректностьВызоваПоОкружению() Тогда
		
		ВызватьИсключение НСтр("ru = 'Некорректный вызов функции общего модуля ДополнительныеОтчетыИОбработкиВБезопасномРежиме!
                                |Экспортируемые функции данного модуля для использования в безопасном режиме должны вызываться только
                                |из сценария!'");
		
	КонецЕсли;
	
КонецПроцедуры