#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//	Стартовая процедура процесса получения, загрузки и применения конфигурации 
Процедура ОбновлениеКонфигурации()	Экспорт

	Перем КодВозврата;

	Если ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

	//	Пока что отрежем такую возможность.. не предусмотрено.
		Возврат;

	КонецЕсли;

	ЗаписьЖурналаРегистрации("Поддержка конфигурации", УровеньЖурналаРегистрации.Примечание
		,,, "2. Вход в процедуру «ОбновлениеКонфигурации» и проверка возможности получения обновлений.");

	Если НЕ ПривилегированныйРежим() Тогда

		УстановитьПривилегированныйРежим(Истина);

	КонецЕсли;

//	Проверяем "бесправного" администратора, предназначенного для запуска конфигуратора.
//	Описывает его предопределённый элемент "Справочники.Пользователи.АдминистраторАвтоматов"
	УправлениеДоступомСлужебный.ПроверитьАдминистратораАвтоматов();

	ОбновитьПовторноИспользуемыеЗначения();
	ПараметрыОбновления = УправлениеДоступомСлужебныйПовтИсп.ПолучитьПараметрыОбновления();

	Если ПроверитьВозможностьПолученияКонфигурации(ПараметрыОбновления) Тогда
		
		Если СтрНайти(ПараметрыОбновления.ВерсияПлатформы, "8.3.24") = 0 Тогда 
			
			ИмяГлавногоФайлаСкрипта	= СформироватьФайлыСкриптаОбновления(ПараметрыОбновления);

			СкриптОбъект = Новый Файл(ИмяГлавногоФайлаСкрипта);

		//	через отдельную переменную для того, чтобы можно было "на лету" (в отладке) заменить содержимое.
			СтрокаКоманды = "cscript.exe """ + СкриптОбъект.ПолноеИмя + """";
			ЗапуститьПриложение(СтрокаКоманды, СкриптОбъект.Путь,, КодВозврата);

			ЖурналСобытий.Регистрация("Поддержка конфигурации", УровеньЖурналаРегистрации.Примечание
			,,,, СтрокаКоманды, "КодВозврата=[" + КодВозврата + "]", Истина);
			
		Иначе 
			
			ИмяГлавногоФайлаСкрипта	= СформироватьФайлыСкриптаОбновленияНовое(ПараметрыОбновления);
			СкриптОбъект = Новый Файл(ИмяГлавногоФайлаСкрипта);

		//	через отдельную переменную для того, чтобы можно было "на лету" (в отладке) заменить содержимое.
			СтрокаКоманды = СкриптОбъект.ПолноеИмя + " > " + СкриптОбъект.Путь + "log.txt";
			ЗапуститьПриложение(СтрокаКоманды, СкриптОбъект.Путь,, КодВозврата);

			ЖурналСобытий.Регистрация("Поддержка конфигурации", УровеньЖурналаРегистрации.Примечание
			,,,, СтрокаКоманды, "КодВозврата=[" + КодВозврата + "]", Истина);
			
			
		КонецЕсли;
		
	Иначе

		ЗаписьЖурналаРегистрации("Поддержка конфигурации", УровеньЖурналаРегистрации.Примечание
			,,, "3. Обновление конфигурации не требуется.");

	КонецЕсли;

КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПроверитьВозможностьПолученияКонфигурации(ПараметрыОбновления)

	ТекущаяПлатформа = ТехническаяПоддержкаВызовСервера.ТипПлатформыСистемы();
//	Получим назначенные данные для обновления...
	ВерсияТребуется  = Константы.МиграцияВерсия.Получить();

//	Памятка:	Интерпретация сравнения - первый параметр меньше второго.
//				То есть, Отказ = "НЕ (текущая меньше новой версии)"
	Отказ = ПустаяСтрока(ВерсияТребуется)
	ИЛИ НЕ (ОбщегоНазначенияКлиентСервер.СравнитьВерсии(Метаданные.Версия, ВерсияТребуется) < 0);

	Если ПроверитьНазначениеПримененияКонфигурации(ПараметрыОбновления, Отказ) Тогда

		ДанныеКонфигурации = Константы.МиграцияДанные.Получить().Получить();

		Если НЕ ДанныеКонфигурации.Версия = ВерсияТребуется Тогда

			ТекстОшибки = "Предупреждение: Обнаружено отличие версии полученного обновления и версии назначенной!";
			ВызватьИсключениеИЗафиксироватьСобытие(ТекстОшибки, УровеньЖурналаРегистрации.Примечание, ПараметрыОбновления.СобытиеЖурналаРегистрации);

			ВызватьИсключение ТекстОшибки;

		КонецЕсли;

		ФайлОбновления = Новый Файл(
			ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
				ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
					ПараметрыОбновления.КаталогФайловОбновленияОбъект.ПолноеИмя, ТекущаяПлатформа)
				+ ВерсияТребуется, ТекущаяПлатформа)
				+ ДанныеКонфигурации.ИмяФайла);
				
		Попытка

		//	Проверим существование каталога файла обновления ..
			РаботаСФайлами.ПроверитьСуществованиеКаталога(ФайлОбновления.Путь);

		Исключение

			ТекстОшибки = "Критическая ошибка: Нет доступа к каталогу обновления «" + ФайлОбновления.Путь + "»: " + Символы.ПС + ОписаниеОшибки();
			ВызватьИсключениеИЗафиксироватьСобытие(ТекстОшибки, УровеньЖурналаРегистрации.Ошибка, ПараметрыОбновления.СобытиеЖурналаРегистрации);

			ВызватьИсключение ТекстОшибки;

		КонецПопытки;
				
		Попытка

		//	Проверим существование каталога, предназначенного для журнала событий обнолвения ..
			РаботаСФайлами.ПроверитьСуществованиеКаталога(ПараметрыОбновления.КаталогЖурналовОбъект.ПолноеИмя);

		Исключение

			ТекстОшибки = "Критическая ошибка: Нет доступа к каталогу регистрации событий «" + ПараметрыОбновления.КаталогЖурналовОбъект.ПолноеИмя + "»: " + Символы.ПС + ОписаниеОшибки();
			ВызватьИсключениеИЗафиксироватьСобытие(ТекстОшибки, УровеньЖурналаРегистрации.Ошибка, ПараметрыОбновления.СобытиеЖурналаРегистрации);

			ВызватьИсключение ТекстОшибки;

		КонецПопытки;

	//	Выполним предварительную очистку содержимого каталога ..
		Попытка
			
			УдалитьФайлы(ФайлОбновления.Путь, "*.*");
		
		Исключение

			ТекстОшибки = "Не удалось очистить каталог: " + ФайлОбновления.Путь + Символы.ПС + ОписаниеОшибки();
			ВызватьИсключениеИЗафиксироватьСобытие(ТекстОшибки, УровеньЖурналаРегистрации.Ошибка, ПараметрыОбновления.СобытиеЖурналаРегистрации);
		
		КонецПопытки;

		Попытка

			ДанныеКонфигурации.ДвоичныеДанные.Записать(ФайлОбновления.ПолноеИмя);

		Исключение

			ТекстОшибки = "Критическая ошибка при записи «" + ФайлОбновления.ПолноеИмя + "»: " + Символы.ПС + ОписаниеОшибки();
			ВызватьИсключениеИЗафиксироватьСобытие(ТекстОшибки, УровеньЖурналаРегистрации.Ошибка, ПараметрыОбновления.СобытиеЖурналаРегистрации);

		КонецПопытки;

		Отказ = НЕ ФайлОбновления.Существует();

		Если НЕ Отказ Тогда

			ПараметрыОбновления.ФайлОбновленияОбъект = ФайлОбновления;

		КонецЕсли;

	КонецЕсли;

	Возврат НЕ Отказ;

КонецФункции // ПроверитьВозможностьПолученияКонфигурации()

Функция ПроверитьНазначениеПримененияКонфигурации(ПараметрыОбновления, Отказ)

//	Ограничим запуск обновления в период между 7:40 и 8:05 - в 8:00 происходит рестарт систем на периферии.
//	Во избежание, так сказать...
	ВремяТекущее = Час(ТекущаяДатаСеанса()) * 3600 + Минута(ТекущаяДатаСеанса()) * 60 + Секунда(ТекущаяДатаСеанса());

	Если ВремяТекущее >= (7 * 3600 + 40 * 60) И ВремяТекущее < (8 * 3600 + 5 * 60) Тогда

		Отказ = Истина;

	КонецЕсли;

	Если НЕ Отказ Тогда

		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЧАС(ТаблицаНазначений.ВремяНачала) * 3600 + МИНУТА(ТаблицаНазначений.ВремяНачала) * 60 + СЕКУНДА(ТаблицаНазначений.ВремяНачала) КАК ВремяНачала,
		|	ВЫБОР
		|		КОГДА ТаблицаНазначений.ВремяОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|			ТОГДА 8 * 3600 + 20 * 60
		|		ИНАЧЕ ЧАС(ТаблицаНазначений.ВремяОкончания) * 3600 + МИНУТА(ТаблицаНазначений.ВремяОкончания) * 60 + СЕКУНДА(ТаблицаНазначений.ВремяОкончания)
		|	КОНЕЦ КАК ВремяОкончания,
		|	ТаблицаНазначений.ДинамическоеПрименение КАК ДинамическоеПрименение,
		|	ТаблицаНазначений.Запрещено КАК Запрещено,
		|	ВЫБОР
		|		КОГДА ТаблицаНазначений.Магазин = &Магазин
		|			ТОГДА 0
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК КлючПорядка
		|ИЗ
		|	РегистрСведений.ПрименениеКонфигурации КАК ТаблицаНазначений
		|ГДЕ
		|	ТаблицаНазначений.Магазин В (&Магазин, ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка))
		|
		|УПОРЯДОЧИТЬ ПО
		|	КлючПорядка"
		);
	//	Если время окончания применения не задано, считаем, что оно равно 8:20 (как бы должно хватить до открытия магазина)
		Запрос.УстановитьПараметр("Магазин", ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин);
		
		Результат = Запрос.Выполнить();
		Отказ     = Результат.Пустой();

		Если НЕ Отказ Тогда

		//	обновим текущее время...
			ВремяТекущее = Час(ТекущаяДатаСеанса()) * 3600 + Минута(ТекущаяДатаСеанса()) * 60 + Секунда(ТекущаяДатаСеанса());

			Выборка = Результат.Выбрать();

			Если Выборка.Следующий() Тогда

				Если Выборка.Запрещено Тогда

					Отказ = Истина;

				Иначе

					Если Выборка.ВремяНачала > Выборка.ВремяОкончания Тогда

					//		Видим, что задан "обратный" интервал, например, с 21:00 (вечера) до 6:00 (утра).
							Отказ = НЕ (ВремяТекущее >= Выборка.ВремяНачала ИЛИ ВремяТекущее < Выборка.ВремяОкончания);

					Иначе	Отказ = НЕ (ВремяТекущее >= Выборка.ВремяНачала И ВремяТекущее < Выборка.ВремяОкончания);

					КонецЕсли;

					ПараметрыОбновления.Вставить("ДинамическоеПрименение", Выборка.ДинамическоеПрименение);

				КонецЕсли;

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат НЕ Отказ;

КонецФункции // ПроверитьНазначениеПримененияКонфигурации()

Процедура ВызватьИсключениеИЗафиксироватьСобытие(ТекстОшибки, УровеньЖурнала, СобытиеЖурнала)

	ЖурналСобытий.Регистрация(СобытиеЖурнала, УровеньЖурнала
		, Метаданные.Справочники.СтруктураУзлов, ОбменДаннымиПовтИсп.ПолучитьЭтотУзелПоМагазинуИлиПоРабочемуМесту()
		,
		, ТекстОшибки,, Истина);

	ВызватьИсключение ТекстОшибки;

КонецПроцедуры


#Область ПодготовкаТекстовИФайловСкриптов

Функция СформироватьФайлыСкриптаОбновления(ПараметрыОбновления)

	ТекущаяПлатформа = ТехническаяПоддержкаВызовСервера.ТипПлатформыСистемы();

	ИмяКаталога = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПараметрыОбновления.КаталогФайловОбновленияОбъект.ПолноеИмя, ТекущаяПлатформа);
//	ИмяКаталога = "D:\1C.ENT\Script's\MUPDATER\";
	
//	Вспомогательный файл: addfunctions.js
	ФайлСкрипта       = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ПолучитьМакет("БиблиоткаДополнительная").ПолучитьТекст());
	ФайлСкрипта.Записать(ИмяКаталога + "addfunctions.js", КодировкаТекста.UTF16);
	
//	Вспомогательный файл: mainfunctions.js
	ФайлСкрипта       = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ПолучитьТекстСкрипта(ПараметрыОбновления));
	ФайлСкрипта.Записать(ИмяКаталога + "mainfunctions.js", КодировкаТекста.UTF16);

//	Главный файл: mupdater.js
	ИмяГлавногоФайлаСкрипта = ИмяКаталога + "mupdater.js";
	ФайлСкрипта             = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод       = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ПолучитьМакет("ОбновлениеКонфигурации").ПолучитьТекст());
	ФайлСкрипта.Записать(ИмяГлавногоФайлаСкрипта, КодировкаТекста.UTF16);

	Возврат ИмяГлавногоФайлаСкрипта;

КонецФункции

Функция СформироватьФайлыСкриптаОбновленияНовое(ПараметрыОбновления)

	ТекущаяПлатформа = ТехническаяПоддержкаВызовСервера.ТипПлатформыСистемы();

	ИмяКаталога = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПараметрыОбновления.КаталогФайловОбновленияОбъект.ПолноеИмя, ТекущаяПлатформа);
//	ИмяКаталога = "D:\1C.ENT\Script's\MUPDATER\";

	ИмяГлавногоФайлаСкрипта = ИмяКаталога + "update.bat";
	ФайлСкрипта             = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ПолучитьТекстСкриптаНовый(ПараметрыОбновления));
	ФайлСкрипта.Записать(ИмяГлавногоФайлаСкрипта, КодировкаТекста.OEM);

	Возврат ИмяГлавногоФайлаСкрипта;

КонецФункции

Функция ПолучитьТекстСкрипта(ПараметрыОбновления)
	
	ШаблонСкрипта = ПолучитьМакет("БиблиотекаОсновная");
	
	СкриптПараметры = ШаблонСкрипта.ПолучитьОбласть("ОбластьПараметров");
	СкриптПараметры.УдалитьСтроку(1);
	СкриптПараметры.УдалитьСтроку(СкриптПараметры.КоличествоСтрок());
	
	СкриптТекст = ШаблонСкрипта.ПолучитьОбласть("ОбластьОбновленияКонфигурации");
	СкриптТекст.УдалитьСтроку(1);
	СкриптТекст.УдалитьСтроку(СкриптТекст.КоличествоСтрок());
	
	Возврат ВставитьПараметрыСкрипта(СкриптПараметры.ПолучитьТекст(), ПараметрыОбновления) + СкриптТекст.ПолучитьТекст();
	
КонецФункции

Функция ПолучитьТекстСкриптаНовый(ПараметрыОбновления)
	
	Если ПараметрыОбновления.ДинамическоеПрименение Тогда
		Результат = ВставитьПараметрыСкрипта(ПолучитьМакет("ОбновлениеНовоеДинамическое").ПолучитьТекст(), ПараметрыОбновления);
	Иначе
		Результат = ВставитьПараметрыСкрипта(ПолучитьМакет("ОбновлениеНовое").ПолучитьТекст(), ПараметрыОбновления);
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

Функция ВставитьПараметрыСкрипта(Знач Текст, Знач ПараметрыОбновления)
	
	Результат = Текст;

	СтрокаСоединенияИнформационнойБазы = ПараметрыОбновления.СтрокаСоединенияИнформационнойБазы + ПараметрыОбновления.СтрокаПодключения; 

	Если Прав(СтрокаСоединенияИнформационнойБазы, 1) = ";" Тогда

		СтрокаСоединенияИнформационнойБазы = Лев(СтрокаСоединенияИнформационнойБазы, СтрДлина(СтрокаСоединенияИнформационнойБазы) - 1);

	КонецЕсли;

	ИмяИсполняемогоФайлаКонфигуратора = ПараметрыОбновления.КаталогПрограммы + ПараметрыОбновления.ИмяИсполняемогоФайлаКонфигуратора;
	ИмяИсполняемогоФайлаКлиента       = ПараметрыОбновления.КаталогПрограммы + ПараметрыОбновления.ИмяИсполняемогоФайлаКлиента;
	
//	Определение пути к информационной базе.
	ПризнакФайловогоРежима = Неопределено;
	ПутьКИнформационнойБазе = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(ПризнакФайловогоРежима, 0);
	
	ПараметрПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима, "/F", "/S") + ПутьКИнформационнойБазе;
	КаталогОбновления = ПараметрыОбновления.ФайлОбновленияОбъект.Путь;
	КаталогОбновления = Лев(КаталогОбновления, СтрДлина(КаталогОбновления) - 1); 
	
	Результат = СтрЗаменить(Результат, "[ИмяФайлаОбновления]"					, ПодготовитьТекст(ПараметрыОбновления.ФайлОбновленияОбъект.ПолноеИмя));
	Результат = СтрЗаменить(Результат, "[ИмяИсполняемогоФайлаКонфигуратора]"	, ПодготовитьТекст(ИмяИсполняемогоФайлаКонфигуратора));
	Результат = СтрЗаменить(Результат, "[ИмяИсполняемогоФайлаКлиента]"			, ПодготовитьТекст(ИмяИсполняемогоФайлаКлиента));
	Результат = СтрЗаменить(Результат, "[ПараметрПутиКИнформационнойБазе]"		, ПодготовитьТекст(ПараметрПутиКИнформационнойБазе));
	Результат = СтрЗаменить(Результат, "[СтрокаСоединенияИнформационнойБазы]"	, ПодготовитьТекст(СтрокаСоединенияИнформационнойБазы));
	Результат = СтрЗаменить(Результат, "[ПараметрыАутентификацииПользователя]"	, ПодготовитьТекст(ПараметрыОбновления.ПараметрыАутентификации));

	Результат = СтрЗаменить(Результат, "[ИмяКаталогаЖурналаСобытий]"			, ПодготовитьТекст(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПараметрыОбновления.КаталогЖурналовОбъект.ПолноеИмя, ТехническаяПоддержкаВызовСервера.ТипПлатформыСистемы())));
	Результат = СтрЗаменить(Результат, "[ИмяФайлаЖурналаСобытий]"				, ПодготовитьТекст("log" + Формат(ТекущаяДатаСеанса(), "ДФ=_yyyy_MM_dd") + ".txt"));

	Результат = СтрЗаменить(Результат, "[ИмяАдминистратора]"					, ПодготовитьТекст(ПараметрыОбновления.ИмяАдминистратора));
	Результат = СтрЗаменить(Результат, "[ПарольАдминистратора]"					, ПодготовитьТекст(ПараметрыОбновления.ПарольАдминистратора));

	Результат = СтрЗаменить(Результат, "[ИмяАдминистратораКластера]"			, ПодготовитьТекст(ПараметрыОбновления.ИмяАдминистратораКластера));
	Результат = СтрЗаменить(Результат, "[ПарольАдминистратораКластера]"			, ПодготовитьТекст(ПараметрыОбновления.ПарольАдминистратораКластера));

	Результат = СтрЗаменить(Результат, "[ИмяСервера]"							, ПодготовитьТекст(ПараметрыОбновления.ИмяСервера));
	Результат = СтрЗаменить(Результат, "[ПортСервера]"							, ПодготовитьТекст(ПараметрыОбновления.ПортСервера));
	Результат = СтрЗаменить(Результат, "[ИмяИнформационнойБазы]"				, ПодготовитьТекст(ПараметрыОбновления.ИмяИнформационнойБазы));

	Результат = СтрЗаменить(Результат, "[ИмяАдминистратораОбновления]"			, ПодготовитьТекст(УправлениеДоступомСлужебныйПовтИсп.ИмяАдминистратораАвтоматов()));
	Результат = СтрЗаменить(Результат, "[ИмяCOMСоединителя]"					, ПодготовитьТекст(ПараметрыОбновления.ИмяCOMСоединителя));

	Результат = СтрЗаменить(Результат, "[ВыполнитьДинамическоеОбновление]"		, ?(ПараметрыОбновления.ДинамическоеПрименение, "true", "false"));

	Результат = СтрЗаменить(Результат, "[КаталогПрограммы]"						, ПараметрыОбновления.КаталогПрограммы);
	Результат = СтрЗаменить(Результат, "[КаталогОбновления]"					, КаталогОбновления);
	Результат = СтрЗаменить(Результат, "[ИмяСервераНовая]"						, ПараметрыОбновления.ИмяСервера);
	Результат = СтрЗаменить(Результат, "[ИмяИнформационнойБазыНовая]"			, ПараметрыОбновления.ИмяИнформационнойБазы);
    Результат = СтрЗаменить(Результат, "[ИмяАдминистратораНовая]"				, ПараметрыОбновления.ИмяАдминистратора);
	Результат = СтрЗаменить(Результат, "[ПарольАдминистратораНовая]"			, ПараметрыОбновления.ПарольАдминистратора);

	Возврат Результат;
	
КонецФункции

Функция ПодготовитьТекст(Знач Текст)
	
	Текст = СтрЗаменить(Текст, "\", "\\");
	Текст = СтрЗаменить(Текст, """", "\""");
	Текст = СтрЗаменить(Текст, "'", "\'");
	
	Возврат "'" + Текст + "'";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли