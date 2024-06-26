
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест"
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='СШК'") + " """ + Строка(Идентификатор) + """";

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СпПорт = Элементы.Порт.СписокВыбора;
	Для Индекс = 1 По 32 Цикл
		СпПорт.Добавить(Индекс, "COM" + СокрЛП(Индекс));
	КонецЦикла;


	времПорт      = Неопределено;
	времСкорость  = Неопределено;
	времБитДанных = Неопределено;
	времСтопБит   = Неопределено;
	времПрефикс   = Неопределено;
	времСуффикс   = Неопределено;
	времМодель    = Неопределено;

	Параметры.Свойство("Порт",      времПорт);
	Параметры.Свойство("Модель",    времМодель);

	Порт        = ?(времПорт      = Неопределено,         1, времПорт);

	Модель      = ?(времМодель    = Неопределено, Элементы.Модель.СписокВыбора[0], времМодель);

	Элементы.ТестУстройства.Видимость          = (ПараметрыСеанса.РабочееМестоКлиента
	                                              = Идентификатор.РабочееМесто);
	Элементы.ПараметрыЖурналирования.Видимость = (ПараметрыСеанса.РабочееМестоКлиента
	                                              = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость       = (ПараметрыСеанса.РабочееМестоКлиента
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


	ПортПриИзменении();

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПортПриИзменении()


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

	Параметры.ПараметрыНастройки.Добавить(Порт,              "Порт");
	Параметры.ПараметрыНастройки.Добавить(Модель,            "Модель");

	ОчиститьСообщения();
	Закрыть(КодВозвратаДиалога.ОК);

КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"     , Порт);
	времПараметрыУстройства.Вставить("Модель"   , Модель);

	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("""" + Модель + """: " + ВыходныеПараметры[1] + "(код ошибки " + ВыходныеПараметры[0] + ")");
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("""" + Модель + """: " + ВыходныеПараметры[1] );
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЖурналирования(Команда)

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"     , Порт);
	времПараметрыУстройства.Вставить("Модель"   , Модель);

	МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПараметрыЖурналирования",
	                                                          ВходныеПараметры,
	                                                          ВыходныеПараметры,
	                                                          Идентификатор,
	                                                          времПараметрыУстройства);

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
	времПараметрыУстройства.Вставить("Порт"     , Порт);
	времПараметрыУстройства.Вставить("Модель"   , Модель);

	
	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		//драйвер может уже инициализирован. попробуем получить информацию с него.
		Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(Идентификатор,
		                                                        "ПолучитьВерсиюДрайвера",
		                                                        ВходныеПараметры,
		                                                        ВыходныеПараметры);
		Если Результат Тогда
			Драйвер = ВыходныеПараметры[0];
			Версия  = ВыходныеПараметры[1];
		Иначе
			Если ВыходныеПараметры.Количество()>1 Тогда
				Драйвер = ВыходныеПараметры[1];
			КонецЕсли;
			Версия  = НСтр("ru='Не определена'"); 
		КонецЕсли;
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);

КонецПроцедуры
