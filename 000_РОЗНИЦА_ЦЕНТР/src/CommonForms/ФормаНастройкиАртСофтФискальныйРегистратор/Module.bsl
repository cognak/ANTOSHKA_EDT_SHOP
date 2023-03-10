
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест"
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;

	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='ФР'") + " """ + Строка(Идентификатор) + """";

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СпПорт = Элементы.Порт.СписокВыбора;
	Индекс = Неопределено;
	Для Индекс = 1 По 99 Цикл
		СпПорт.Добавить(Индекс, "COM" + СокрЛП(Индекс));
	КонецЦикла;

	СпСкорость = Элементы.Скорость.СписокВыбора;
	СпСкорость.Добавить(1,   "4800");
	СпСкорость.Добавить(2,   "9600");
	СпСкорость.Добавить(3,  "19200");
	СпСкорость.Добавить(4,  "38400");
	СпСкорость.Добавить(5,  "57600");
	СпСкорость.Добавить(6, "115200");
	
	СпМодель = Элементы.Модель.СписокВыбора;
	СпМодель.Добавить("001", "Datecs FP3530T (протокол Datecs)");
	СпМодель.Добавить("101", "Datecs FP3530T (протокол Krypton)");
	СпМодель.Добавить("102", "Datecs FP-3141T (протокол Krypton)");
	СпМодель.Добавить("103", "Datecs FP-T260 (протокол Krypton)");
	СпМодель.Добавить("104", "Datecs CMP-10 (протокол Krypton)");
	СпМодель.Добавить("105", "Datecs FP–Т88 (протокол Krypton)");
	СпМодель.Добавить("106", "Datecs FP–320  (протокол Krypton)");
	СпМодель.Добавить("002", "Екселліо FPU-550");
	СпМодель.Добавить("003", "Екселліо FPU-550ES");
	СпМодель.Добавить("004", "Екселліо LP-1000");
	СпМодель.Добавить("005", "Екселліо FP-700");
	СпМодель.Добавить("006", "Екселліо FP-2000");
	СпМодель.Добавить("007", "Екселліо FPР-350");
	СпМодель.Добавить("201", "Марія 301МТМ");
	СпМодель.Добавить("202", "Марія 304Т");
	СпМодель.Добавить("203", "Марія 304Т1");
	СпМодель.Добавить("204", "Марія 304Т2");
	СпМодель.Добавить("205", "Марія 304Т3");	
	СпМодель.Добавить("301", "IKС-483 LT");
	СпМодель.Добавить("302", "IKС-Е260Т");
	СпМодель.Добавить("303", "ІКС-Е810Т");
	СпМодель.Добавить("304", "ІКС-С651Т");
	СпМодель.Добавить("305", "ІКС-А8800");
	СпМодель.Добавить("306", "MG-T808TL");
	СпМодель.Добавить("307", "ФР7");
	СпМодель.Добавить("401", "Міні-ФП6");
	СпМодель.Добавить("501", "Міні-ФП54.01");
	СпМодель.Добавить("502", "Міні-ФП81.01");
	СпМодель.Добавить("503", "Міні-ФП82.01");
	СпМодель.Добавить("504", "Міні-Т 400ME");
	СпМодель.Добавить("505", "Міні-Т 51.01");
	СпМодель.Добавить("506", "Міні-Т 61.01");

	времПорт                       = Неопределено;
	времСкорость                   = Неопределено;
	времМодель                     = Неопределено;
	времТаблицаСоответствий        = Неопределено;

	Параметры.Свойство("Порт"                      , времПорт);
	Параметры.Свойство("Скорость"                  , времСкорость);
	Параметры.Свойство("Модель"                    , времМодель);
	Параметры.Свойство("ТаблицаСоответствийНалоговыхГрупп", времТаблицаСоответствий);

	Порт                       = ?(времПорт                       = Неопределено,      1, времПорт);
	Скорость                   = ?(времСкорость                   = Неопределено,      0, времСкорость);
	Модель                     = ?(времМодель                     = Неопределено, Элементы.Модель.СписокВыбора[0], времМодель);
	ЗаполнитьТаблицуСоответствийИзПараметров(времТаблицаСоответствий);
	Элементы.ТестУстройства.Видимость    = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);

//	LNK 02.05.2017 11:44:28
	Если ТаблицаСоответствий.Количество() < 3 Тогда

		НалоговыеСтавкиИзменены = Истина;
		МенеджерОборудованияСервер.ТаблицаНалоговыхГруппПоУмолчанию(ТаблицаСоответствий);
	
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

	Если НалоговыеСтавкиИзменены Тогда

		Модифицированность = Истина;
		ПоказатьОповещениеПользователя("Налоговые ставки изменены!"
		,, "Налоговые ставки установлены в состояние «По умолчанию», так как их количество было менее трёх."
		, БиблиотекаКартинок.Информация32);

	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Процедура представляет обработчик события "Нажатие" кнопки
// "ОК" командной панели "ОсновныеДействияФормы".
//
// Параметры:
//  Кнопка - <КнопкаКоманднойПанели>
//         - Кнопка, с которой связано данное событие (кнопка "ОК").
//
&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	Если ТаблицаСоответствий.Количество() = 0 Тогда	//+HVOYA Mykhailo
		Сообщить("Заполните НАЛОГОВЫЕ СТАВКИ");
		Возврат;
	КонецЕсли;

	Параметры.ПараметрыНастройки.Добавить(Порт                      , "Порт");
	Параметры.ПараметрыНастройки.Добавить(Скорость                  , "Скорость");
	Параметры.ПараметрыНастройки.Добавить(Модель                    , "Модель");
	Параметры.ПараметрыНастройки.Добавить(ПолучитьПараметрыИзТаблицыСоответствий(), "ТаблицаСоответствийНалоговыхГрупп");

	ОчиститьСообщения();
	Закрыть(КодВозвратаДиалога.ОК);

КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)

	РезультатТеста    = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"                      , Порт);
	времПараметрыУстройства.Вставить("Скорость"                  , Скорость);
	времПараметрыУстройства.Вставить("Модель"                    , Модель);
	времПараметрыУстройства.Вставить("ТаблицаСоответствийНалоговыхГрупп", ПолучитьПараметрыИзТаблицыСоответствий());

	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);

	ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
	                           И ВыходныеПараметры.Количество(),
	                           НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
	                           "");
	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	МенеджерОборудованияКлиент.УстановитьДрайвер(Идентификатор);

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"                      , Порт);
	времПараметрыУстройства.Вставить("Скорость"                  , Скорость);
	времПараметрыУстройства.Вставить("Модель"                    , Модель);
	времПараметрыУстройства.Вставить("ТаблицаСоответствийНалоговыхГрупп", ПолучитьПараметрыИзТаблицыСоответствий());

	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		Драйвер = ВыходныеПараметры[2];
		Версия  = НСтр("ru='Не определена'");
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);

	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен'"));

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСоответствийИзПараметров(ТаблицаСоответствийИзПараметров = Неопределено)
	
	ТаблицаСоответствий.Очистить();
	
	Если ТаблицаСоответствийИзПараметров = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Элемент Из ТаблицаСоответствийИзПараметров Цикл
		
		Строка = ТаблицаСоответствий.Добавить();
		
		Строка.НалоговаяГруппаРРО = Элемент[0];
		Строка.СтавкаНДС          = НДСОбщегоНазначенияКлиентСервер.ПолучитьПоСтрокеСтавкуНДС(Элемент[1]);
		Строка.ПодакцизныйТовар   = Элемент[2];
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыИзТаблицыСоответствий()
	
	Результат = Новый Массив;
	
	Для каждого Строка Из ТаблицаСоответствий Цикл
		
		Элемент = Новый Массив(3);
		
		Элемент[0] = Строка.НалоговаяГруппаРРО;
		Элемент[1] = НДСОбщегоНазначенияКлиентСервер.ПолучитьСтавкуНДССтрокой(Строка.СтавкаНДС);
		Элемент[2] = Строка.ПодакцизныйТовар;
		
		Результат.Добавить(Элемент);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
