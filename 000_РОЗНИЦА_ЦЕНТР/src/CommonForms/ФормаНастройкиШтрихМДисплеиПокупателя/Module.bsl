
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест"
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='ДП'") + " """ + Строка(Идентификатор) + """";

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СпПорт = Элементы.Порт.СписокВыбора;
	Для Номер = 1 По 32 Цикл
		СпПорт.Добавить(Номер, "COM" + Формат(Номер, "ЧЦ=2; ЧДЦ=0; ЧН=0; ЧГ=0"));
	КонецЦикла;
	
	СпМодель = Элементы.Модель.СписокВыбора;
	СпМодель.Добавить(0, "Встроенный дисплей 'ШТРИХ-LightPOS-Pro'");
	
	СпОтображатьНаДисплее = Элементы.ОтображатьНаДисплее.СписокВыбора;
	СпОтображатьНаДисплее.Добавить(1, "Наименование товара");
	СпОтображатьНаДисплее.Добавить(2, "Итоговую сумму");

	времПорт                = Неопределено;
	времТаймаут             = Неопределено;
	времКолвоПовторов       = Неопределено;
	времОтображатьНаДисплее = Неопределено;

	Параметры.Свойство("Порт"               , времПорт);
	Параметры.Свойство("Таймаут"            , времТаймаут);
	Параметры.Свойство("КолвоПовторов"      , времКолвоПовторов);
	Параметры.Свойство("ОтображатьНаДисплее", времОтображатьНаДисплее);

	Порт                = ?(времПорт                = Неопределено,   1, времПорт);
	Таймаут             = ?(времТаймаут             = Неопределено, 100, времТаймаут);
	КолвоПовторов       = ?(времКолвоПовторов       = Неопределено,   1, времКолвоПовторов);
	ОтображатьНаДисплее = ?(времОтображатьНаДисплее = Неопределено,   2, времОтображатьНаДисплее);
	Модель = 0;

	Элементы.ТестУстройства.Видимость    = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);

КонецПроцедуры

// Процедура - обработчик события "Перед открытием" формы.
//
// Параметры:
//  Отказ                - <Булево>
//                       - Признак отказа от открытия формы. Если в теле
//                         процедуры-обработчика установить данному параметру
//                         значение Истина, открытие формы выполнено не будет.
//                         Значение по умолчанию: Ложь 
//
//  СтандартнаяОбработка - <Булево>
//                       - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события. Если в
//                         теле процедуры-обработчика установить данному
//                         параметру значение Ложь, стандартная обработка
//                         события производиться не будет. Отказ от стандартной
//                         обработки не отменяет открытие формы.
//                         Значение по умолчанию: Истина 
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

	УстановитьДоступностьЭлементов();

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

	Параметры.ПараметрыНастройки.Добавить(Порт					, "Порт");
	Параметры.ПараметрыНастройки.Добавить(Таймаут				, "Таймаут");
	Параметры.ПараметрыНастройки.Добавить(КолвоПовторов			, "КолвоПовторов");
	Параметры.ПараметрыНастройки.Добавить(ОтображатьНаДисплее	, "ОтображатьНаДисплее");
	ОчиститьСообщения();
	Закрыть(КодВозвратаДиалога.ОК);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	МенеджерОборудованияКлиент.УстановитьДрайвер(Идентификатор);

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)

	РезультатТеста = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт", Порт);
	времПараметрыУстройства.Вставить("Таймаут", Таймаут);
	времПараметрыУстройства.Вставить("КолвоПовторов", КолвоПовторов);
	времПараметрыУстройства.Вставить("ОтображатьНаДисплее", ОтображатьНаДисплее);
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);

	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.'");
		ПоказатьОповещениеПользователя(ТекстСообщения);
	Иначе
		ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
		                           И ВыходныеПараметры.Количество() >= 2,
		                           НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
		                           "");


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

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()

	Элементы.Порт.Доступность              = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт", Порт);
	времПараметрыУстройства.Вставить("Таймаут", Таймаут);
	времПараметрыУстройства.Вставить("КолвоПовторов", КолвоПовторов);
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
