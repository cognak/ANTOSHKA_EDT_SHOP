#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Перем времIP, времПортIP, времТокен, времИмяУстройства, времПоследнийАртикул;
	Перем времТаблицаНалоговыхГрупп, времТаблицаТиповОплат;
	Перем времНаПринтер, ВремПечатьПодвала, времВидСообщения;

//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест"
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;

	ЗаполнитьОбразцыСоответствий();

	Параметры.Свойство("Идентификатор", Идентификатор);

	Заголовок	= НСтр("ru='ФР';uk='ФР'") + " """ + Строка(Идентификатор) + """";
	ЦветТекста	= ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки	= ЦветаСтиля.ЦветОтрицательногоЧисла;

	Параметры.Свойство("ИдентификаторУстройства", времИмяУстройства);
	Параметры.Свойство("ИмяУстройства"			, времИмяУстройства);
	Параметры.Свойство("Токен"					, времТокен);
	Параметры.Свойство("IP"						, времIP);
	Параметры.Свойство("ПортIP"					, времПортIP);
	Параметры.Свойство("ТаблицаСоответствийНалоговыхГрупп", времТаблицаНалоговыхГрупп);
	Параметры.Свойство("ТаблицаТиповОплат"		, времТаблицаТиповОплат);
	Параметры.Свойство("НаПринтер"				, времНаПринтер);
	Параметры.Свойство("ПечатьПодвала"			, времПечатьПодвала);
	Параметры.Свойство("ВидСообщения"			, времВидСообщения);

	ИдентификаторУстройства = ?(времИмяУстройства = Неопределено, "", времИмяУстройства); 
	ИмяУстройства	= ?(времИмяУстройства = Неопределено, "", времИмяУстройства);	
	IP				= ?(времIP = Неопределено, "localhost", времIP);
	ПортIP			= ?(времПортIP = Неопределено, 3939, времПортIP);
	Токен			= ?(времТокен = Неопределено, "", времТокен);
	НаПринтер		= ?(времНаПринтер = Неопределено, Ложь, времНаПринтер); 
	ПечатьПодвала	= ?(времПечатьПодвала = Неопределено, Ложь, времПечатьПодвала); 
	ВидСообщения	= ?(времВидСообщения = Неопределено, Перечисления.ВидыСообщений.НеСообщать, времВидСообщения); 
	
	
	ЗаполнитьТаблицуСоответствийИзПараметров(времТаблицаНалоговыхГрупп);
	
	ЗаполнитьТаблицуТиповОплатИзПараметров(времТаблицаТиповОплат);

	Элементы.ТестУстройства.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто)
			ИЛИ ТехническаяПоддержкаВызовСервера.ОтладочныйРежимРаботы();	//	LNK 02.03.2024 06:33:33

//	дефолтное заполнение, если таблицы пустые
	ЗаполнитьТаблицуНалоговыхГрупп();	//	LNK 04.01.2023 14:09:42
	ЗаполнитьТаблицуТиповОплат();		//	LNK 04.01.2023 14:09:42

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

	Если ЗначениеЗаполнено(ТекстПредупрежденияПриСтарте) Тогда
		ПоказатьПредупреждение(,ТекстПредупрежденияПриСтарте,,НСтр("ru='Внимание!';uk='Увага!'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ТаблицаНалоговыхГруппСтавкаНДСПриИзменении(Элемент)

	Элементы.ТаблицаНалоговыхГрупп.ТекущиеДанные.СтавкаНДССтрокой = СтрЗаменить(ЭтаФорма.Элементы.ТаблицаНалоговыхГрупп.ТекущиеДанные.СтавкаНДС,"%","");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

// Процедура представляет обработчик события "Нажатие" кнопки
// "ОК" командной панели "ОсновныеДействияФормы".
//
// Параметры:
//  Кнопка - <КнопкаКоманднойПанели>
//         - Кнопка, с которой связано данное событие (кнопка "ОК").
//
&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	Параметры.ПараметрыНастройки.Добавить(Идентификатор	, "Идентификатор");
	Параметры.ПараметрыНастройки.Добавить(ИмяУстройства	, "ИдентификаторУстройства");
	Параметры.ПараметрыНастройки.Добавить(ИмяУстройства	, "ИмяУстройства");	
	Параметры.ПараметрыНастройки.Добавить(IP			, "IP");
	Параметры.ПараметрыНастройки.Добавить(ПортIP		, "ПортIP");
	Параметры.ПараметрыНастройки.Добавить(Токен			, "Токен");
	Параметры.ПараметрыНастройки.Добавить(ПолучитьПараметрыНалоговыхГрупп()	, "ТаблицаСоответствийНалоговыхГрупп");
	Параметры.ПараметрыНастройки.Добавить(ПолучитьПараметрыТиповОплат()		, "ТаблицаТиповОплат");
	Параметры.ПараметрыНастройки.Добавить(НаПринтер		, "НаПринтер");
	Параметры.ПараметрыНастройки.Добавить(ПечатьПодвала	, "ПечатьПодвала");
	Параметры.ПараметрыНастройки.Добавить(ВидСообщения	, "ВидСообщения");

	ОчиститьСообщения();
	Закрыть(КодВозвратаДиалога.ОК);

КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)

	РезультатТеста    = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("ИмяУстройства"   , ИмяУстройства);	
	времПараметрыУстройства.Вставить("ИдентификаторУстройства"   , ИмяУстройства);	
	времПараметрыУстройства.Вставить("ПоследнийАртикул" 		 , ПоследнийАртикул);	
	времПараметрыУстройства.Вставить("IP"                        , IP);
	времПараметрыУстройства.Вставить("ПортIP"                    , ПортIP);
	времПараметрыУстройства.Вставить("Токен"                  , Токен);
	времПараметрыУстройства.Вставить("ТаблицаСоответствийНалоговыхГрупп", ПолучитьПараметрыНалоговыхГрупп());
	времПараметрыУстройства.Вставить("ТаблицаТиповОплат", ПолучитьПараметрыТиповОплат());
	времПараметрыУстройства.Вставить("НаПринтер", НаПринтер);


	ОбъектРРО = ПодключаемоеОборудованиеDeviceManagerФискальныйРегистратор.СоздатьОбъектДрайвера(времПараметрыУстройства);
	Результат = ПодключаемоеОборудованиеDeviceManagerФискальныйРегистратор.ТестУстройства(ОбъектРРО, времПараметрыУстройства,
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры);
	ДополнительноеОписание = ОбъектРРО.ДополнительноеОписание;

	Если Результат Тогда

		ТекстСообщения = НСтр("ru='Тест успешно выполнен.%ПереводСтроки%%ДополнительноеОписание%';uk='Тест успішно виконаний.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);

	Иначе

		ТекстСообщения = НСтр("ru='Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%';uk='Тест не пройдений.%ПереводСтроки%%ДополнительноеОписание%'");
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
Процедура Xотчет(Команда)
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	ПараметрыПодключения= Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("ИмяУстройства"   , ИмяУстройства);	
	времПараметрыУстройства.Вставить("ИдентификаторУстройства"   , ИмяУстройства);	
	времПараметрыУстройства.Вставить("ПоследнийАртикул" 		 , ПоследнийАртикул);	
	времПараметрыУстройства.Вставить("IP"                        , IP);
	времПараметрыУстройства.Вставить("ПортIP"                    , ПортIP);
	времПараметрыУстройства.Вставить("Токен"                  , Токен);
	времПараметрыУстройства.Вставить("ТаблицаСоответствийНалоговыхГрупп", ПолучитьПараметрыНалоговыхГрупп());
	времПараметрыУстройства.Вставить("ТаблицаТиповОплат", ПолучитьПараметрыТиповОплат());


	ОбъектРРО = ПодключаемоеОборудованиеDeviceManagerФискальныйРегистратор.СоздатьОбъектДрайвера(времПараметрыУстройства);
	Результат = ПодключаемоеОборудованиеDeviceManagerФискальныйРегистратор.ТестУстройства(ОбъектРРО,времПараметрыУстройства,
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры);
	ВходныеПараметры  = Новый Массив();
	ВыходныеПараметры = Неопределено;
	
	ПодключаемоеОборудованиеDeviceManagerФискальныйРегистратор. ВыполнитьКоманду("PrintXReport", ВходныеПараметры, ВыходныеПараметры,
                         ОбъектРРО, времПараметрыУстройства, ПараметрыПодключения)

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	Драйвер = НСтр("ru='Установлен';uk='Встановлений'");
	Версия  = "6.22";
	
	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен';uk='Не встановлений'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена';uk='Не визначена'"), ЦветОшибки, ЦветТекста);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСоответствийИзПараметров(ТаблицаНалоговыхГруппИзПараметров = Неопределено)
	
	ТаблицаНалоговыхГрупп.Очистить();
	
	Если ТаблицаНалоговыхГруппИзПараметров = Неопределено Тогда

		Возврат;

	КонецЕсли;
	
	Для каждого Элемент Из ТаблицаНалоговыхГруппИзПараметров Цикл
		
		Строка = ТаблицаНалоговыхГрупп.Добавить();
		
		Строка.НалоговаяГруппаРРО = Элемент[0];
		Строка.СтавкаНДС          = Элемент[1];
		Строка.ПодакцизныйТовар   = Элемент[2];
		Строка.СтавкаНДССтрокой   = Элемент[3];
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТиповОплатИзПараметров(ТаблицаПараметровТиповОплат = Неопределено)
	
	ТаблицаТиповОплат.Очистить();
	
	Если ТаблицаПараметровТиповОплат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Элемент Из ТаблицаПараметровТиповОплат Цикл
		
		Строка = ТаблицаТиповОплат.Добавить();
		
		Строка.ID = Элемент[0];
		Строка.ТипОплаты = Элемент[1];
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыНалоговыхГрупп()
	
	Результат = Новый Массив;
	
	Для каждого Строка Из ТаблицаНалоговыхГрупп Цикл
		
		Элемент = Новый Массив(4);
		
		Элемент[0] = Строка.НалоговаяГруппаРРО;
		Элемент[1] = Строка.СтавкаНДС;
		Элемент[2] = Строка.ПодакцизныйТовар;
		Элемент[3] = Строка.СтавкаНДССтрокой;
		
		Результат.Добавить(Элемент);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьПараметрыТиповОплат()
	
	ТаблицаТиповОплат.Сортировать("ID");

	Результат = Новый Массив;
	
	Для каждого СтрокаТаблицы Из ТаблицаТиповОплат Цикл
		
		ЭлементМассива = Новый Массив;
		
		ЭлементМассива.Добавить(СтрокаТаблицы.ID);
		ЭлементМассива.Добавить(СтрокаТаблицы.ТипОплаты);

		Результат.Добавить(ЭлементМассива);

	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере	//	LNK 19.02.2022 07:08:56
Процедура ЗаполнитьОбразцыСоответствий()

	МакетСоответствий = ПолучитьОбщийМакет("ПРРО_СоответствиеСтавокНалоговыхГрупп");

	ОбразецСоответствийНалогов.Очистить();
	ОбразецСоответствийВидовОплат.Очистить();

	ОбразецСоответствийНалогов.Вывести(МакетСоответствий.ПолучитьОбласть("ТаблицаСоответствийНалогов"));
	ОбразецСоответствийВидовОплат.Вывести(МакетСоответствий.ПолучитьОбласть("ТаблицаСоответствийВидовОплат"));

КонецПроцедуры

&НаСервере	//	LNK 04.01.2023 14:09:53
Процедура ЗаполнитьТаблицуНалоговыхГрупп()

	Если ТаблицаНалоговыхГрупп.Количество() = 0 Тогда

		СтрокаТаблицы = ТаблицаНалоговыхГрупп.Добавить();
		СтрокаТаблицы.НалоговаяГруппаРРО = 1;
		СтрокаТаблицы.ПодакцизныйТовар	 = Ложь;
		СтрокаТаблицы.СтавкаНДС = Перечисления.СтавкиНДС.НДС20;

		СтрокаТаблицы = ТаблицаНалоговыхГрупп.Добавить();
		СтрокаТаблицы.НалоговаяГруппаРРО = 2;
		СтрокаТаблицы.ПодакцизныйТовар	 = Ложь;
		СтрокаТаблицы.СтавкаНДС = Перечисления.СтавкиНДС.БезНДС;

		СтрокаТаблицы = ТаблицаНалоговыхГрупп.Добавить();
		СтрокаТаблицы.НалоговаяГруппаРРО = 3;
		СтрокаТаблицы.ПодакцизныйТовар	 = Истина;
		СтрокаТаблицы.СтавкаНДС = Перечисления.СтавкиНДС.НДС20;

		СтрокаТаблицы = ТаблицаНалоговыхГрупп.Добавить();
		СтрокаТаблицы.НалоговаяГруппаРРО = 4;
		СтрокаТаблицы.ПодакцизныйТовар	 = Ложь;
		СтрокаТаблицы.СтавкаНДС = Перечисления.СтавкиНДС.НДС7;

		СтрокаТаблицы = ТаблицаНалоговыхГрупп.Добавить();
		СтрокаТаблицы.НалоговаяГруппаРРО = 5;
		СтрокаТаблицы.ПодакцизныйТовар	 = Ложь;
		СтрокаТаблицы.СтавкаНДС = Перечисления.СтавкиНДС.НДС0;

		СтрокаТаблицы = ТаблицаНалоговыхГрупп.Добавить();
		СтрокаТаблицы.НалоговаяГруппаРРО = 6;
		СтрокаТаблицы.ПодакцизныйТовар	 = Истина;
		СтрокаТаблицы.СтавкаНДС = Перечисления.СтавкиНДС.БезНДС;

		СтрокаТаблицы = ТаблицаНалоговыхГрупп.Добавить();
		СтрокаТаблицы.НалоговаяГруппаРРО = 7;
		СтрокаТаблицы.ПодакцизныйТовар	 = Ложь;
		СтрокаТаблицы.СтавкаНДС = Перечисления.СтавкиНДС.НеНДС;

		СтрокаТаблицы = ТаблицаНалоговыхГрупп.Добавить();
		СтрокаТаблицы.НалоговаяГруппаРРО = 9;
		СтрокаТаблицы.ПодакцизныйТовар	 = Ложь;
		СтрокаТаблицы.СтавкаНДС = Перечисления.СтавкиНДС.НДС14;

		Для каждого СтрокаТаблицы Из ТаблицаНалоговыхГрупп Цикл

			СтрокаТаблицы.СтавкаНДССтрокой = СтрЗаменить(СтрокаТаблицы.СтавкаНДС,"%","")

		КонецЦикла;

		Модифицированность = Истина;

	КонецЕсли;

КонецПроцедуры

&НаСервере	//	LNK 04.01.2023 14:11:56
Процедура ЗаполнитьТаблицуТиповОплат()

	Если ТаблицаТиповОплат.Количество() = 0 Тогда

		СтрокаТаблицы = ТаблицаТиповОплат.Добавить();
		СтрокаТаблицы.ID = 0;
		СтрокаТаблицы.ТипОплаты = Перечисления.ТипыОплатЧекаККМ.Наличные;

		СтрокаТаблицы = ТаблицаТиповОплат.Добавить();
		СтрокаТаблицы.ID = 1;
		СтрокаТаблицы.ТипОплаты = Перечисления.ТипыОплатЧекаККМ.ПлатежнаяКарта;

		СтрокаТаблицы = ТаблицаТиповОплат.Добавить();
		СтрокаТаблицы.ID = 2;
		СтрокаТаблицы.ТипОплаты = Перечисления.ТипыОплатЧекаККМ.ПлатежнаяКарта;

		СтрокаТаблицы = ТаблицаТиповОплат.Добавить();
		СтрокаТаблицы.ID = 3;
		СтрокаТаблицы.ТипОплаты = Перечисления.ТипыОплатЧекаККМ.Предоплата;

		СтрокаТаблицы = ТаблицаТиповОплат.Добавить();
		СтрокаТаблицы.ID = 4;
		СтрокаТаблицы.ТипОплаты = Перечисления.ТипыОплатЧекаККМ.Послеплата;

		СтрокаТаблицы = ТаблицаТиповОплат.Добавить();
		СтрокаТаблицы.ID = 5;
		СтрокаТаблицы.ТипОплаты = Перечисления.ТипыОплатЧекаККМ.БанковскийКредит;

		СтрокаТаблицы = ТаблицаТиповОплат.Добавить();
		СтрокаТаблицы.ID = 6;
		СтрокаТаблицы.ТипОплаты = Перечисления.ТипыОплатЧекаККМ.ПодарочныйСертификат;

		Модифицированность = Истина;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти
















