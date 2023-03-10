////////////////////////////////////////////////////////////////////////////////
// Подсистема "Резервное копирование ИБ".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура проверяет необходимость проведения резервного копирования
// или показа пользователю необходимого информационного сообщения.
Процедура ПриНачалеРаботыСистемы(Знач ОбрабатыватьПараметрыЗапуска = Ложь) Экспорт
	
	ПараметрыРаботы = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботы.РазделениеВключено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыНастроек = ПараметрыРаботы.ПараметрыРезервногоКопированияИБ;
	
	// настройки не определены только в том случае, если у пользователя нет доступа к подсистеме
	Если ПараметрыНастроек = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Настройки резервного копирования присваиваем глобальной переменной.
	ПараметрыРезервногоКопированияИБ = ПараметрыНастроек;
	Если ПараметрыРезервногоКопированияИБ.ПроцессВыполняется Тогда 
		РезервноеКопированиеИБВызовСервера.УстановитьЗначениеНастройки("ПроцессВыполняется", Ложь, ПараметрыРезервногоКопированияИБ);
	КонецЕсли;
	
	ОповещатьОРезервномКопированииПриЗавершенииСеанса = Ложь;
	ДатаОтложенногоРезервногоКопирования = Дата('00010101');
	ПодключитьОбработчикОжидания("ОбработчикДействийРезервногоКопирования", 60);
	
	ВариантОповещения = ПараметрыНастроек.ПараметрОповещения;
	Если ВариантОповещения = "Просрочено" Или ВариантОповещения = "Напомнить" Или ВариантОповещения = "ЕщеНеНастроено" Тогда
		ОповеститьПользователяОРезервномКопировании(ВариантОповещения);
	КонецЕсли;
	
	ПроверитьРезервноеКопированиеИБ(ПараметрыНастроек);
	
	Если ПараметрыНастроек.ПроведеноВосстановление Тогда
		ТекстОповещения = НСтр("ru = 'Восстановление данных проведено успешно.'");
		ПоказатьОповещениеПользователя(НСтр("ru = 'Данные восстановлены.'"), , ТекстОповещения);
	КонецЕсли;
	
КонецПроцедуры

// Подключает обработчик ожидания начала резервного копирования.
Процедура ПодключитьОжиданиеРезервногоКопирования() Экспорт
	
	РезервноеКопированиеИБВызовСервера.УстановитьЗначениеНастройки("ОтложенноеРезервноеКопирование", Истина, ПараметрыРезервногоКопированияИБ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Запускает резервное копирование по расписанию.
// Состоит из двух этапов: 1 - очистка каталога с копиями, 2 - непосредственно резервное копирование.
Процедура ПровестиРезервноеКопирование() Экспорт
	
	// Очистка архива с копиями.
	НастройкиУдаления = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПараметрыРезервногоКопированияИБ;
	КаталогХранения = НастройкиУдаления.КаталогХраненияРезервныхКопий;
	
	Если НастройкиУдаления.ПроизводитьУдаление И КаталогХранения <> Неопределено Тогда
		
		Попытка
			Файл = Новый Файл(КаталогХранения);
			Если НЕ Файл.ЭтоКаталог() Тогда
				Возврат;
			КонецЕсли;
			
			МассивФайлов = НайтиФайлы(КаталогХранения, "*", Истина);
			СписокУдаляемыхФайлов = Новый СписокЗначений;
			
			// Удаление резервных копий.
			Если НастройкиУдаления.УдалятьПоПериоду Тогда
				Для Каждого ЭлементФайл Из МассивФайлов Цикл
					ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
					ПараметрУдаления = ?((ТекущаяДата - НастройкиУдаления.ЗначениеПараметра) > ЭлементФайл.ПолучитьВремяИзменения(), Истина, Ложь);
					Если ПараметрУдаления Тогда
						СписокУдаляемыхФайлов.Добавить(ЭлементФайл);
					КонецЕсли;
				КонецЦикла;
				
			ИначеЕсли МассивФайлов.Количество() >= НастройкиУдаления.ЗначениеПараметра Тогда				
				СписокФайлов = Новый СписокЗначений;
				СписокФайлов.ЗагрузитьЗначения(МассивФайлов);
				
				Для Каждого Файл Из СписокФайлов Цикл
					Файл.Значение = Файл.Значение.ПолучитьВремяИзменения();
				КонецЦикла;
				
				СписокФайлов.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
				Индекс = НастройкиУдаления.ЗначениеПараметра;
				ДатаПоследнегоАрхива = СписокФайлов[Индекс-1].Значение;
				
				Для Каждого ЭлементФайл Из МассивФайлов Цикл
					
					Если ЭлементФайл.ПолучитьВремяИзменения() < ДатаПоследнегоАрхива Тогда
						СписокУдаляемыхФайлов.Добавить(ЭлементФайл);
					КонецЕсли;
					
				КонецЦикла;								
				
			КонецЕсли;
			
			Для Каждого УдаляемыйФайл Из СписокУдаляемыхФайлов Цикл
				УдалитьФайлы(УдаляемыйФайл.Значение.ПолноеИмя);
			КонецЦикла;
			
		Исключение
			
			ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(),"Ошибка",
			НСтр("ru = 'Не удалось провести очистку каталога с резервными копиями.'"),,Истина);
			
		КонецПопытки;
		
	КонецЕсли;
	
	// резервное копирование
	РезервноеКопированиеИБВызовСервера.УстановитьДатуСледующегоАвтоматическогоКопирования(ПараметрыРезервногоКопированияИБ);
	ПараметрыФормы = Новый Структура("ТипВызова, ТекущаяСтраница", 2, "СтраницаИнформацииИВыполненияРезервногоКопирования");
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеИнформационнойБазы", ПараметрыФормы);
	
КонецПроцедуры

// При старте системы проверяет, первый ли это запуск после проведения резервного копирования. 
// Если да - выводит форму обработчика с результатами резервного копирования.
//
// Параметры:
//	ПараметрыРезервногоКопирования - Структура - параметры резервного копирования.
//
Процедура ПроверитьРезервноеКопированиеИБ(ПараметрыРезервногоКопирования) Экспорт
	
	ЗначениеНастройкиРезервногоКопирования = ПараметрыРезервногоКопирования;
	
	Если ЗначениеНастройкиРезервногоКопирования.ПроведеноКопирование Тогда	
		
		ПараметрыФормы = Новый Структура("ТипВызова", 2);
		НазваниеТекущейСтраницы = "";
		
		Если ЗначениеНастройкиРезервногоКопирования.РезультатКопирования Тогда
			НазваниеТекущейСтраницы = "СтраницаУспешногоВыполненияКопирования";
		Иначе
			НазваниеТекущейСтраницы = "СтраницаОшибокПриКопировании";
		КонецЕсли;
		
		ПараметрыФормы.Вставить("ТекущаяСтраница", НазваниеТекущейСтраницы);
		ПараметрыФормы.Вставить("ТекстПути",  ЗначениеНастройкиРезервногоКопирования.ИмяФайлаРезервнойКопии);
		ФормаОповещения = ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеИнформационнойБазы", ПараметрыФормы);
		
	КонецЕсли;
КонецПроцедуры

 // По результатам анализа параметров резервного копирования выдает соответствующее оповещение.
//
// Параметры: 
//   ВариантОповещения - Строка - результат проверки на посылку оповещения
//
Процедура ОповеститьПользователяОРезервномКопировании(ВариантОповещения) Экспорт
	
	ТекстПояснения = "";
	Если ВариантОповещения = "Просрочено" Тогда
		
		ТекстПояснения = НСтр("ru = 'Автоматическое резервное копирование не было выполнено.'"); 
		ПоказатьОповещениеПользователя(НСтр("ru = 'Резервное копирование.'"),
			"e1cib/app/Обработка.РезервноеКопированиеИБ", ТекстПояснения, БиблиотекаКартинок.Предупреждение32);
		
	ИначеЕсли ВариантОповещения = "Напомнить" Тогда
		
		НастройкаОповещения = ПараметрыРезервногоКопированияИБ.ДатаПоследнегоРезервногоКопирования;
		ТекстПояснения = НСтр("ru = 'Резервное копирование не выполнялось с %1.'");
		
		МассивЗамены = Новый Массив;
		МассивЗамены.Добавить(НастройкаОповещения);
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(ТекстПояснения, МассивЗамены);
		
		ТекстПояснения = СтрЗаменить(ТекстПояснения,"%НастройкаОповещения%",НастройкаОповещения);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Резервное копирование.'"),
			"e1cib/app/Обработка.РезервноеКопированиеИБ", ТекстПояснения, БиблиотекаКартинок.Предупреждение32);
		
	ИначеЕсли ВариантОповещения = "ЕщеНеНастроено" Тогда
		
		ТекстПояснения = НСтр("ru = 'Рекомендуется настроить резервное копирование информационной базы.'"); 
		ПоказатьОповещениеПользователя(НСтр("ru = 'Резервное копирование.'"),
			"e1cib/app/Обработка.НастройкаРезервногоКопированияИБ", ТекстПояснения, БиблиотекаКартинок.Предупреждение32);
		ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
		РезервноеКопированиеИБВызовСервера.УстановитьДатуПоследнегоНапоминания(ТекущаяДата);
	КонецЕсли;	
КонецПроцедуры

// Получает каталог файла по его имени
//
// Параметры: ПутьКФайлу - Строка, путь к указанному файлу.
//
// Возвращаемое значение: Строка, путь к каталогу с указанным файлом.
//
Функция ПолучитьКаталогФайла(Знач ПутьКФайлу) Экспорт
	ПозицияСимвола = ПолучитьНомерПоследнегоСимвола(ПутьКФайлу, "\"); 
	Если ПозицияСимвола > 1 Тогда
		Возврат Сред(ПутьКФайлу, 1, ПозицияСимвола - 1); 
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

// Возвращает позицию последнего передаваемого символа.
//
// Параметры:
//	ИсходнаяСтрока - Строка - строка, в которой осуществляется поиск.
//	СимволПоиска - Строка - символ поиска.
//	
// Возвращаемое значение - Число - позиция символа.
//
Функция ПолучитьНомерПоследнегоСимвола(Знач ИсходнаяСтрока, Знач СимволПоиска)
	ПозицияСимвола = СтрДлина(ИсходнаяСтрока);
	Пока ПозицияСимвола >= 1 Цикл
		
		Если Сред(ИсходнаяСтрока, ПозицияСимвола, 1) = СимволПоиска Тогда
			Возврат ПозицияСимвола; 
		КонецЕсли;
		
		ПозицияСимвола = ПозицияСимвола - 1;	
	КонецЦикла;
	Возврат 0;
КонецФункции

// Возвращает значение глобальной переменной модуля приложения.
// Используется для обработчиков ожидания из глобального клиентского модуля.
//
// Возвращаемое значение - Дата - дата отложенного резервного копирования.
//
Функция ПолучитьДатуКопирования() Экспорт
	
	Возврат ДатаОтложенногоРезервногоКопирования;
	
КонецФункции

// Возвращает тип события журнала регистрации для данной подсистемы.
//
// Возвращаемое значение - Строка - тип события журнала регистрации.
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Резервное копирование информационной базы'");
	
КонецФункции

// Возвращает параметры скрипта резервного копирования.
//
// Возвращаемое значение - Структура - структура скрипта резервного копирования.
//
Функция КлиентскиеПараметрыРезервногоКопирования() Экспорт
	#Если НЕ ВебКлиент Тогда
		
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("ДатаВремяОбновленияУстановлена", Ложь);
		
		// Имена служебных файлов
		#Если ТонкийКлиент Тогда
			СтруктураПараметров.Вставить("ИмяФайлаПрограммы", "1cv8c.exe");
		#КонецЕсли
		
		#Если ТолстыйКлиентОбычноеПриложение Тогда
			СтруктураПараметров.Вставить("ИмяФайлаПрограммы", "1cv8.exe");
		#КонецЕсли
		
		#Если ТолстыйКлиентУправляемоеПриложение Тогда
			СтруктураПараметров.Вставить("ИмяФайлаПрограммы", "1cv8.exe");
		#КонецЕсли
		
		СтруктураПараметров.Вставить("СобытиеЖурналаРегистрации", НСтр("ru = 'Резервное копирование ИБ'"));
		
		// Определение каталога временных файлов.
		ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
		СтруктураПараметров.Вставить("КаталогВременныхФайловОбновления"	, КаталогВременныхФайлов() + "1Cv8Backup." + Формат(ТекущаяДата, "ДФ=ггММддЧЧммсс") + "\");
		
		Возврат СтруктураПараметров;
	#КонецЕсли
КонецФункции

// Возвращает параметры резервного копирования 
// из глобальной переменной "ПараметрыРезервногоКопированияИБ".
//
// Возвращаемое значение - Структура - параметры резервного копирования ИБ.
//
Функция ПолучитьПараметрыРезервногоКопированияИБ() Экспорт
	
	Возврат ПараметрыРезервногоКопированияИБ;
	
КонецФункции

// Проверяет необходимость проведения автоматического резервного копирования.
//
// Возвращаемое значение - Булево - Истина, если необходима, Ложь - иначе.
//
Функция НеобходимостьАвтоматическогоРезервногоКопирования() Экспорт
	Параметры = ПолучитьПараметрыРезервногоКопированияИБ();
	Если Параметры = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Расписание = Параметры.РасписаниеКопирования;
	Если Расписание = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ПроцессВыполняется") Тогда 
		Если Параметры.ПроцессВыполняется Тогда 
			Возврат Ложь;
		КонецЕсли;	
	КонецЕсли;
	
	ДатаПроверки = ОбщегоНазначенияКлиент.ДатаСеанса();
	Если Параметры.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования > ДатаПроверки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДатаНачалаПроверки = Параметры.ДатаПоследнегоРезервногоКопирования;
	РасписаниеЗначение = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание);
	Возврат РасписаниеЗначение.ТребуетсяВыполнение(ДатаПроверки, ДатаНачалаПроверки);
КонецФункции

// Устанавливает передаваемое значение клиентской глобальной переменной "ПараметрыРезервногоКопированияИБ".
//
// Параметры:
//	Параметры - Структура - передаваемое значение.
//
Процедура УстановитьПараметрыРезервногоКопирования(Параметры) Экспорт
	
	ПараметрыРезервногоКопированияИБ = Параметры;
	
КонецПроцедуры

// Функция проверяет настройки резервного копирования.
//
// Возвращаемое значение:
//	Неопределено - если нет резервного копирования,
//	Дата - если имеется отложенное резервное копирование,
//	Булево - если имеется резервное копирование при завершении работы.
//
Функция ПроверитьНаличиеРезервногоКопирования() 
#Если ВебКлиент Тогда
	Возврат Неопределено;
#КонецЕсли

	Если Не СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗавершении().ПараметрыРезервногоКопированияИБ.ДоступностьРолейОповещения Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОповещатьПостоянно = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗавершении().ПараметрыРезервногоКопированияИБ.ПроводитьРезервноеКопированиеПриЗавершенииРаботы;
	ОповещатьПостоянно = ?(ОповещатьПостоянно = Неопределено, Ложь, ОповещатьПостоянно);
	КоличествоАктивныхАдминистраторов = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗавершении().ПараметрыРезервногоКопированияИБ.КоличествоАктивныхПользователей;
	// Переменная ОповещатьОРезервномКопированииПриЗавершенииСеанса сравнивается явно с Истина, 
	// так как может быть не проинициализирована при аварийном завершении.
	Если ОповещатьОРезервномКопированииПриЗавершенииСеанса = Истина ИЛИ (ОповещатьПостоянно И КоличествоАктивныхАдминистраторов = 1) Тогда
		Возврат Истина;
	Иначе // Если нет резервного копирования при завершении работы системы.
		// Переменная ДатаОтложенногоРезервногоКопирования может быть не проинициализирована при аварийном завершении.
		Если ДатаОтложенногоРезервногоКопирования = Неопределено Тогда
			ДатаОтложенногоРезервногоКопирования = Дата('00010101');
		КонецЕсли;
		ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
		Если ДатаОтложенногоРезервногоКопирования > ТекущаяДата Тогда
			Возврат ДатаОтложенногоРезервногоКопирования;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Формирует вопросы при завершении работы системы.
//
// Параметры:
//	Предупреждения - Массив - список предупреждений.
//
Процедура ПриЗавершенииРаботыСистемы(Предупреждения) Экспорт
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().РазделениеВключено Тогда
		Возврат;
	КонецЕсли;
	
	Ответ = ПроверитьНаличиеРезервногоКопирования();
	ТипОтвета = ТипЗнч(Ответ);
	ИмеетсяРезервноеКопирование = Ложь;
	Если ТипОтвета = Тип("Дата") Тогда 
		ТекстФлажка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Завершить работу системы после резервного копирования %1'"), Ответ);
		
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(Ответ);
		ПараметрыФормы = Новый Структура("ТипВызова, ТекущаяСтраница, ЗаголовокНадписи", 
			1, "СтраницаИнформацииИВыполненияРезервногоКопирования", 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(НСтр("ru = 'Резервное копирование будет произведено автоматически не позднее %1'"), 
			МассивПараметров));
		ФормаОбработки = "Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеИнформационнойБазы";
		
		ИмеетсяРезервноеКопирование = Истина;
	ИначеЕсли ТипОтвета = Тип("Булево") Тогда 
		ТекстФлажка 	= НСтр("ru = 'Выполнить резервное копирование'");
		ПараметрыФормы 	= Новый Структура("ТипВызова, ТекущаяСтраница", 2, "СтраницаИнформацииИВыполненияРезервногоКопирования");
		ФормаОбработки 	= "Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеИнформационнойБазы";
		
		ИмеетсяРезервноеКопирование = Истина;
	КонецЕсли;	
	
	Если ИмеетсяРезервноеКопирование Тогда
		ДействиеПриУстановленномФлажке = Новый Структура("Форма, ПараметрыФормы", ФормаОбработки, ПараметрыФормы);
		СтруктураПредупреждения = Новый Структура("ТекстФлажка, ДействиеПриУстановленномФлажке, Приоритет", ТекстФлажка, ДействиеПриУстановленномФлажке, 90);
		Предупреждения.Добавить(СтруктураПредупреждения);
	КонецЕсли;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП

// Доопределяет список предупреждений пользователю перед завершением работы системы.
//
// Параметры:
//  Предупреждения - Массив, в который можно добавить элементы типа Структура с полями:
//    ТекстФлажка      - Строка - текст флажка.
//    ПоясняющийТекст  - Строка - текст, выводимый в форме сверху
//                       управляющего элемента (флажок или гиперссылка).
//    ТекстГиперссылки - Строка - текст гиперссылки.
//    ДействиеПриУстановленномФлажке - Структура с полями:
//      Форма          - путь к открываемой форме.
//      ПараметрыФормы - произвольная структура параметров формы Форма. 
//    ДействиеПриНажатииГиперссылки - Структура с полями:
//      Форма          - Строка    - путь к форме, которая должна открываться по нажатию на гиперссылку.
//      ПараметрыФормы - Структура - произвольная структура параметров для вышеописанной формы.
//      ПрикладнаяФормаПредупреждения - Строка - путь к форме, которая должна открываться сразу
//                                      вместо универсальной формы в случае, когда в списке 
//                                      предупреждений оказывается только одно данное предупреждение.
//      ПараметрыПрикладнойФормыПредупреждения - Структура - произвольная структура
//                                               параметров для вышеописанной формы.
//
Процедура ПриПолученииСпискаПредупрежденийЗавершенияРаботы(Предупреждения) Экспорт
	
	ПриЗавершенииРаботыСистемы(Предупреждения);
	
КонецПроцедуры

