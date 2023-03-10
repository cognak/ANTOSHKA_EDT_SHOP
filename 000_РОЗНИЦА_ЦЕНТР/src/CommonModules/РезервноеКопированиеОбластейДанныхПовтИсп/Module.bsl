
////////////////////////////////////////////////////////////////////////////////
// РезервноеКопированиеОбластейДанныхПовтИсп.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает соответствие русских названий полей программных системных настроек
// английским из XDTO-пакета ZoneBackupControl Менеджера сервиса
// (тип: {http://www.1c.ru/SaaS/1.0/XMLSchema/ZoneBackupControl}Settings).
//
// Возвращаемое значение:
// ФиксированноеСоответствие.
//
Функция СоответствиеРусскихИменПолейНастроекАнглийским() Экспорт
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("CreateDailyBackup", "ФормироватьЕжедневныеКопии");
	Результат.Вставить("CreateMonthlyBackup", "ФормироватьЕжемесячныеКопии");
	Результат.Вставить("CreateYearlyBackup", "ФормироватьЕжегодныеКопии");
	Результат.Вставить("BackupCreationTime", "ВремяФормированияКопий");
	Результат.Вставить("MonthlyBackupCreationDay", "ЧислоМесяцаФормированияЕжемесячныхКопий");
	Результат.Вставить("YearlyBackupCreationMonth", "МесяцФормированияЕжегодныхКопий");
	Результат.Вставить("YearlyBackupCreationDay", "ЧислоМесяцаФормированияЕжегодныхКопий");
	Результат.Вставить("KeepDailyBackups", "КоличествоЕжедневныхКопий");
	Результат.Вставить("KeepMonthlyBackups", "КоличествоЕжемесячныхКопий");
	Результат.Вставить("KeepYearlyBackups", "КоличествоЕжегодныхКопий");
	Результат.Вставить("CreateDailyBackupOnUserWorkDaysOnly", "ФормироватьЕжедневныеКопииТолькоВДниРаботыПользователей");
	
	Возврат Новый ФиксированноеСоответствие(Результат);

КонецФункции	

// Определяет, поддерживает ли приложение функциональность резервного копирования.
//
// Возвращаемое значение:
// Булево - Истина, если приложение поддерживает функциональность резервного копирования.
//
Функция МенеджерСервисаПоддерживаетРезервноеКопирование() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПоддерживаемыеВерсии = ОбщегоНазначения.ПолучитьВерсииИнтерфейса(
		Константы.ВнутреннийАдресМенеджераСервиса.Получить(),
		Константы.ИмяСлужебногоПользователяМенеджераСервиса.Получить(),
		Константы.ПарольСлужебногоПользователяМенеджераСервиса.Получить(),
		"РезервноеКопированиеОбластейДанных");
		
	Возврат ПоддерживаемыеВерсии.Найти("1.0.1.1") <> Неопределено;
	
КонецФункции

// Возвращает прокси web-сервиса контроля резервного копирования.
// 
// Возвращаемое значение: 
// WSПрокси.
// Прокси менеджера сервиса. 
// 
Функция ПроксиКонтроляРезервногоКопирования() Экспорт
	
	АдресМенеджераСервиса = Константы.ВнутреннийАдресМенеджераСервиса.Получить();
	Если Не ЗначениеЗаполнено(АдресМенеджераСервиса) Тогда
		ВызватьИсключение(НСтр("ru = 'Не установлены параметры связи с менеджером сервиса.'"));
	КонецЕсли;
	
	АдресСервиса = АдресМенеджераСервиса + "/ws/ZoneBackupControl?wsdl";
	ИмяПользователя = Константы.ИмяСлужебногоПользователяМенеджераСервиса.Получить();
	ПарольПользователя = Константы.ПарольСлужебногоПользователяМенеджераСервиса.Получить();
	
	Прокси = ОбщегоНазначения.WSПрокси(АдресСервиса, "http://www.1c.ru/SaaS/1.0/WS",
		"ZoneBackupControl", , ИмяПользователя, ПарольПользователя, 10);
		
	Возврат Прокси;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Фоновые задания

// Возвращает имя метода фонового задания выгрузки области в файл.
//
// Возвращаемое значение:
// Строка.
//
Функция ИмяМетодаФоновогоРезервногоКопирования() Экспорт
	
	Возврат "РезервноеКопированиеОбластейДанных.ВыгрузитьОбластьВХранилищеМС";
	
КонецФункции

// Возвращает наименование фонового задания выгрузки области в файл.
//
// Возвращаемое значение:
// Строка.
//
Функция НаименованиеФоновогоРезервногоКопирования() Экспорт
	
	Возврат НСтр("ru = 'Резервное копирование области данных'");
	
КонецФункции
