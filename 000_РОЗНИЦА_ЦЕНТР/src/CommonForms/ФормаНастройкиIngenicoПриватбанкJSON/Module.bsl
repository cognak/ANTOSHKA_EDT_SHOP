
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ          

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Перем времИмяУстройства, времАдресУстройства,времПортУстройства,времСОМПорт, времОтладка, времПодключениеПоСети;
	Перем времДлительностьТаймаута;
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест"
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	
	//ЗначениеПараметров  = Параметры.ПараметрыОбработки;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='ДП'") + " """ + Строка(Идентификатор) + """";

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;
	
	Элементы.ТестУстройства.Видимость    = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	
	
	
	Параметры.Свойство("ИдентификаторУстройства", времИмяУстройства);
	Параметры.Свойство("ИмяУстройства"			, времИмяУстройства);
	Параметры.Свойство("АдресУстройства"		, времАдресУстройства);
	Параметры.Свойство("ПортУстройства"			, времПортУстройства);
	Параметры.Свойство("СОМПорт"				, времСОМПорт);
	Параметры.Свойство("Отладка"				, времОтладка);
	Параметры.Свойство("ДлительностьТаймаута"				, времДлительностьТаймаута);
	Параметры.Свойство("ПодключениеПоСети"		, времПодключениеПоСети);

	ИдентификаторУстройства = ?(времИмяУстройства = Неопределено, "", времИмяУстройства); 
	ИмяУстройства	= ?(времИмяУстройства = Неопределено, "", времИмяУстройства);	
	АдресУстройства	= ?(времАдресУстройства = Неопределено, "localhost", времАдресУстройства);
	ПортУстройства	= ?(времПортУстройства = Неопределено, 2000, времПортУстройства);
	СОМПорт			= ?(времСОМПорт = Неопределено, 1, времСОМПорт);
	Отладка			= ?(времОтладка = Неопределено, Ложь, времОтладка); 
	ДлительностьТаймаута			= ?(времДлительностьТаймаута = Неопределено, 60, времДлительностьТаймаута); 
	
	ПодключениеПоСети	= ?(времПодключениеПоСети = Неопределено, Истина, ЗначениеЗаполнено(АдресУстройства));
	
	Элементы.СОМПорт.Видимость = НЕ ПодключениеПоСети;
	Элементы.АдресУстройства.Видимость = ПодключениеПоСети;
	Элементы.ПортУстройства.Видимость = ПодключениеПоСети;
	
КонецПроцедуры

// Процедура - обработчик события "Перед открытием" формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьИнформациюОДрайвере();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура УстановитьДрайвер(Команда)
	
	Если ИнтеграционнаяБиблиотека Тогда
		Текст = "ru = 'Для установки драйвера необходимо подключение к Интернету.
			|Продолжить выполнение операции?'";
    	Ответ = Вопрос(НСтр(Текст), РежимДиалогаВопрос.ДаНет, 0);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ЗапуститьПриложение(АдресЗагрузкиДрайвера, , Истина);
		КонецЕсли;
	Иначе
		МенеджерОборудованияКлиент.УстановитьДрайвер(Идентификатор);
	КонецЕсли;
	
	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
    
	РезультатТеста = Неопределено;
	ДемонстрационныйРежим = "";
	Элементы.ГруппаДемонстрационныйРежим.Видимость = Ложь;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	ПараметрыУстройства = Неопределено;
	ОписаниеОшибки = "";

	
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
																   ВходныеПараметры,
																   ВыходныеПараметры,
																   Идентификатор,
																   ПолучитьНастройки()); 
	Если Не Результат Тогда															   
		Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(Идентификатор,"CheckHealth", 
																			ВходныеПараметры, 
																			ВыходныеПараметры);
	КонецЕсли;
	
	
	ДополнительноеОписание = "";
	Если ТипЗнч(ВыходныеПараметры) = Тип("Массив") Тогда
		
		Если  ВыходныеПараметры.Количество() >= 2 Тогда
			ДополнительноеОписание = ДополнительноеОписание + НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1];
		КонецЕсли;
		
		Если  ВыходныеПараметры.Количество() >= 3 И НЕ ПустаяСтрока(ВыходныеПараметры[2])  Тогда
			ДемонстрационныйРежим = ВыходныеПараметры[2];
			// ДополнительноеОписание = ДополнительноеОписание + Символы.ПС + НСтр("ru = 'Ограничение:'") + " " + ВыходныеПараметры[2];
			Элементы.ГруппаДемонстрационныйРежим.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли;
		
	ТекстСообщения = ?(Результат,  НСтр("ru = 'Тест успешно выполнен.%ДополнительноеОписание%'"),
	                               НСтр("ru = 'Тест не пройден.%ДополнительноеОписание%'"));
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
	                             "", Символы.ПС + ДополнительноеОписание));
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);

КонецПроцедуры

// Процедура представляет обработчик события "Нажатие" кнопки
//
&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	Параметры.ПараметрыНастройки.Добавить(Идентификатор	, "Идентификатор");
	//Параметры.ПараметрыНастройки.Добавить(ИмяУстройства	, "ИдентификаторУстройства");
	//Параметры.ПараметрыНастройки.Добавить(ИмяУстройства	, "ИмяУстройства");	
	Параметры.ПараметрыНастройки.Добавить(АдресУстройства	, "АдресУстройства");
	Параметры.ПараметрыНастройки.Добавить(ПортУстройства		, "ПортУстройства");
	Параметры.ПараметрыНастройки.Добавить(Отладка		, "Отладка");
	Параметры.ПараметрыНастройки.Добавить(ДлительностьТаймаута		, "ДлительностьТаймаута");
	Параметры.ПараметрыНастройки.Добавить(СОМПорт	, "СОМПорт");
	Параметры.ПараметрыНастройки.Добавить(ПодключениеПоСети	, "ПодключениеПоСети");
	
	//Закрыть(ПолучитьНастройки());   
	Закрыть(КодВозвратаДиалога.ОК);   

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ПолучитьНастройки()
	            
	ПараметрыДрайвера = Новый Структура;
	ПараметрыДрайвера.Вставить("ПодключениеПоСети", ПодключениеПоСети);
	Если ПодключениеПоСети Тогда
		ПараметрыДрайвера.Вставить("АдресУстройства", АдресУстройства);
		ПараметрыДрайвера.Вставить("ПортУстройства", ПортУстройства);
	Иначе	
		ПараметрыДрайвера.Вставить("АдресУстройства", "");
		ПараметрыДрайвера.Вставить("ПортУстройства", ПортУстройства);
	КонецЕсли;
	ПараметрыДрайвера.Вставить("Отладка", Отладка);
	ПараметрыДрайвера.Вставить("ДлительностьТаймаута", ДлительностьТаймаута);
	

	Возврат ПараметрыДрайвера;
	
КонецФункции


&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	ПараметрыУстройства = Неопределено;
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьОписаниеДрайвера",
																   ВходныеПараметры,
																   ВыходныеПараметры,
																   Идентификатор,
																   ПараметрыУстройства); 
	Если Не Результат Тогда															   
		Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(Идентификатор,"ПолучитьОписаниеДрайвера", 
																			ВходныеПараметры, 
																			ВыходныеПараметры);
	КонецЕсли;
	
	Если Результат  Тогда
		ДрайверУстановлен         = ВыходныеПараметры[0];
		ВерсияДрайвера            = ВыходныеПараметры[1];
		
		НаименованиеДрайвера      = ВыходныеПараметры[2];
		ОписаниеДрайвера          = ВыходныеПараметры[3];
		ТипОборудования           = ВыходныеПараметры[4];
		РевизияИнтерфейса         = ВыходныеПараметры[5];
		ИнтеграционнаяБиблиотека  = ВыходныеПараметры[6];
		ОсновнойДрайверУстановлен = ВыходныеПараметры[7];
		АдресЗагрузкиДрайвера     = ВыходныеПараметры[8];
		ПараметрыДравера          = ВыходныеПараметры[9];
		
		
		Если ИнтеграционнаяБиблиотека И НЕ ОсновнойДрайверУстановлен Тогда
			ДрайверУстановлен = НСтр("ru='Установлена интеграционная библиотека'");
			ВерсияДрайвера = НСтр("ru='Не определена'");
			Элементы.УстановитьДрайвер.Заголовок = НСтр("ru='Установить основную поставку драйвера'");		
		КонецЕсли
		
	Иначе
		Если ВыходныеПараметры.Количество()>2 Тогда
			ДрайверУстановлен = ВыходныеПараметры[2];
		Иначе
			ДрайверУстановлен = Истина;
		КонецЕсли;
		ВерсияДрайвера  = НСтр("ru='Не определена'");
	КонецЕсли;
	
	Элементы.Драйвер.ЦветТекста = ?(ВерсияДрайвера = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = Элементы.Драйвер.ЦветТекста ;
	Элементы.НаименованиеДрайвера.ЦветТекста = ?(НаименованиеДрайвера = НСтр("ru='Не определено'"), ЦветОшибки, ЦветТекста);
	Элементы.ОписаниеДрайвера.ЦветТекста     = ?(ОписаниеДрайвера     = НСтр("ru='Не определено'"), ЦветОшибки, ЦветТекста);
	Элементы.ОписаниеДрайвера.Видимость = НЕ ПустаяСтрока(ОписаниеДрайвера);
	
	Элементы.УстановитьДрайвер.Доступность = Не (ДрайверУстановлен = НСтр("ru='Установлен'"));
	Элементы.ТестУстройства.Доступность = (НЕ ДрайверУстановлен = НСтр("ru='Не установлен'")) 
	                                      И (НЕ ИнтеграционнаяБиблиотека ИЛИ (ИнтеграционнаяБиблиотека И ОсновнойДрайверУстановлен))
   
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеПоСетиПриИзменении(Элемент)
	Элементы.СОМПорт.Видимость = НЕ ПодключениеПоСети;
	Элементы.АдресУстройства.Видимость = ПодключениеПоСети;
	Элементы.ПортУстройства.Видимость = ПодключениеПоСети;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОписаниеОшибки = "";
	РезультатЭТ = МенеджерОборудованияКлиент.ОтключитьОборудованиеПоИдентификатору(ЭтотОбъект,
																							Идентификатор,
																							ОписаниеОшибки);
	
КонецПроцедуры
