////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

//Процедура управляет видимостью и доступностью элементов на форме
//
&НаКлиенте
Процедура УправлениеЭлементамиФормыНаКлиенте()
	
	Если Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо")
		ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент") Тогда
		
		Элементы.ГруппаЮрФизЛицо.ТекущаяСтраница = Элементы.СтраницаЮрЛицо;
		
	Иначе	
		
		Элементы.ГруппаЮрФизЛицо.ТекущаяСтраница = Элементы.СтраницаФизЛицо;
		
	КонецЕсли;	
	
	ЕстьНДС = СистемыНалогообложения.СистемаНалогообложения = ПредопределенноеЗначение("Перечисление.СистемыНалогообложения.ЕдиныйНалогИНДС") ИЛИ
	          СистемыНалогообложения.СистемаНалогообложения = ПредопределенноеЗначение("Перечисление.СистемыНалогообложения.НалогНаПрибыльИНДС");
			  
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПлательщикНДС", "Видимость", ЕстьНДС);
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПлательщикНДС1", "Видимость", ЕстьНДС);
	
//	LNK 01.05.2017 11:19:28
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "IDN", "Видимость", АдминистративныйДоступ);

КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьДанныеОтветственныхЛиц()
	
	ОтветственныеЛица = Новый Массив;
	ОтветственныеЛица.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
	ОтветственныеЛица.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
	ОтветственныеЛица.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.Кассир);
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ОтветственныеЛица.ФизическоеЛицо,
	                      |	ОтветственныеЛица.ОтветственноеЛицо
	                      |ИЗ
	                      |	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(
	                      |			&Период,
	                      |			СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	                      |				И ОтветственноеЛицо В (&ОтветственныеЛица)) КАК ОтветственныеЛица");
						  
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница",Объект.Ссылка);
	Запрос.УстановитьПараметр("ОтветственныеЛица",ОтветственныеЛица);
	Запрос.УстановитьПараметр("Период",ТекущаяДата());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Руководитель Тогда
			
			Руководитель = Выборка.ФизическоеЛицо;
			
		ИначеЕсли Выборка.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер Тогда
			
			Бухгалтер = Выборка.ФизическоеЛицо;
			
		ИначеЕсли Выборка.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Кассир Тогда
			
			Кассир = Выборка.ФизическоеЛицо;

		КонецЕсли;	
		
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Процедура ЗаписатьДанныеОтветственныхЛиц(ТекущийОбъект, СтруктураПараметров);
	
	Для каждого КлючИЗначение Из СтруктураПараметров Цикл
		СтруктураЗаписи = РегистрыСведений.ОтветственныеЛицаОрганизаций.ПолучитьПоследнее(ТекущаяДата(), Новый Структура("СтруктурнаяЕдиница, ОтветственноеЛицо", ТекущийОбъект.Ссылка, КлючИЗначение.Значение));
		Если СтруктураЗаписи.ФизическоеЛицо <> ЭтотОбъект[КлючИЗначение.Ключ] Тогда
			МенеджерЗаписи = РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьМенеджерЗаписи();	
			МенеджерЗаписи.Период = ТекущаяДата();
			МенеджерЗаписи.СтруктурнаяЕдиница = ТекущийОбъект.Ссылка;
			МенеджерЗаписи.ОтветственноеЛицо = КлючИЗначение.Значение;
			МенеджерЗаписи.ФизическоеЛицо = ЭтотОбъект[КлючИЗначение.Ключ];
			МенеджерЗаписи.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьДанныеФИО()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ФИОФизЛицСрезПоследних.Имя,
	|	ФИОФизЛицСрезПоследних.Отчество,
	|	ФИОФизЛицСрезПоследних.Фамилия
	|ИЗ
	|	РегистрСведений.ФИОФизЛиц.СрезПоследних(&Период, ФизЛицо = &Ссылка) КАК ФИОФизЛицСрезПоследних");
	
	Запрос.УстановитьПараметр("Ссылка",Объект.Ссылка);			   
	Запрос.УстановитьПараметр("Период",ТекущаяДата());				   
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			Фамилия = Выборка.Фамилия;
			Имя = Выборка.Имя;
			Отчество = Выборка.Отчество;			
			
		КонецЕсли;
		
	КонецЕсли;	

КонецПроцедуры	
	
&НаСервере
Процедура ЗаписатьДанныеФИО(ТекущийОбъект)
	
	Если ТекущийОбъект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
		
		СтруктураЗаписи = РегистрыСведений.ФИОФизЛиц.ПолучитьПоследнее(ТекущаяДата(), Новый Структура("ФизЛицо", ТекущийОбъект.Ссылка));
		Если СтруктураЗаписи.Фамилия <> Фамилия
			ИЛИ СтруктураЗаписи.Отчество <> Отчество
			ИЛИ СтруктураЗаписи.Имя <> Имя Тогда
			МенеджерЗаписи = РегистрыСведений.ФИОФизЛиц.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ФизЛицо = ТекущийОбъект.Ссылка;
			МенеджерЗаписи.Период = ТекущаяДата();
			МенеджерЗаписи.Фамилия = Фамилия;
			МенеджерЗаписи.Имя = Имя;
			МенеджерЗаписи.Отчество = Отчество;
			МенеджерЗаписи.Записать(Истина);
		КонецЕсли;
		
	Иначе
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ФИОФизЛицСрезПоследних.Имя,
		|	ФИОФизЛицСрезПоследних.Отчество,
		|	ФИОФизЛицСрезПоследних.Фамилия
		|ИЗ
		|	РегистрСведений.ФИОФизЛиц.СрезПоследних(&Период, ФизЛицо = &Ссылка) КАК ФИОФизЛицСрезПоследних");
		
		Запрос.УстановитьПараметр("Ссылка",Объект.Ссылка);			   
		Запрос.УстановитьПараметр("Период",ТекущаяДата());				   
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Фамилия <> Фамилия
				ИЛИ Выборка.Имя <> Имя
				ИЛИ Выборка.Отчество <> Отчество Тогда
				
				МенеджерЗаписи = РегистрыСведений.ФИОФизЛиц.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.ФизЛицо = ТекущийОбъект.Ссылка;
				МенеджерЗаписи.Период = ТекущаяДата();
				МенеджерЗаписи.Фамилия = Фамилия;
				МенеджерЗаписи.Имя = Имя;
				МенеджерЗаписи.Отчество = Отчество;
				МенеджерЗаписи.Записать(Истина);
				
			КонецЕсли;	
						
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик подсистемы "Контактная информация"
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "СтраницаКонтактнаяИнформация");
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
		
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки

//	LNK 01.05.2017 11:26:06
	АдминистративныйДоступ = РольДоступна(Метаданные.Роли.АдминистраторСистемы) И ТехническаяПоддержкаВызовСервера.ИсключительныйРежим();

//	LNK 27.03.2017 09:20:06
	ПроверитьСоставКодыВидовОплат();

	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПрочитатьСистемыНалогообложения();
		
		ЗаполнитьДанныеФИО();
		
		ЗаполнитьДанныеОтветственныхЛиц();
				 	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	// Обработчик подсистемы "Контактная информация"
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	 СтруктураПараметров = Новый Структура;
	 СтруктураПараметров.Вставить("Руководитель",Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
	 СтруктураПараметров.Вставить("Бухгалтер",Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
	 СтруктураПараметров.Вставить("Кассир",Перечисления.ОтветственныеЛицаОрганизаций.Кассир);

	 ЗаписатьДанныеОтветственныхЛиц(ТекущийОбъект, СтруктураПараметров);
	 ЗаписатьДанныеФИО(ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеЭлементамиФормыНаКлиенте();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ЮрФизЛицо <>  Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Фамилия");		
	КонецЕсли;	
	

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаписатьСистемыНалогообложения();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ЮрФизЛицоПриИзменении(Элемент)
	
	УправлениеЭлементамиФормыНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СистемыНалогообложенияПериодПриИзменении(Элемент)
	
	СистемыНалогообложения.Период = НачалоМесяца(СистемыНалогообложения.Период);
	ПрочитатьСистемыНалогообложения();	
	
КонецПроцедуры

&НаКлиенте
Процедура СистемыНалогообложенияСистемаНалогообложенияПриИзменении(Элемент)
	
	УправлениеЭлементамиФормыНаКлиенте();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "КОНТАКТНАЯ ИНФОРМАЦИЯ"

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеНачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеОчистка(ЭтотОбъект, Элемент.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПодключаемаяКоманда(ЭтотОбъект, Команда.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуВводаАдреса(ЭтотОбъект, Результат);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьКонтактнуюИнформацию(Результат = Неопределено)
	
	Возврат УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ПрочитатьСистемыНалогообложения()
	
	ДатаСреза = ?(СистемыНалогообложения.Период = '00010101', НачалоМесяца(ТекущаяДата()), СистемыНалогообложения.Период);
	
	ТаблицаСистемыНалогообложения = РегистрыСведений.СистемыНалогообложенияОрганизаций.СрезПоследних(ДатаСреза, Новый Структура("Организация", Объект.Ссылка));
	
	Если ТаблицаСистемыНалогообложения.Количество() > 0 Тогда
	
		ЗаполнитьЗначенияСвойств(СистемыНалогообложения, ТаблицаСистемыНалогообложения[0]);	
		
	Иначе	
		
		СистемыНалогообложения.Период = ДатаСреза;
		
	КонецЕсли;
	
	 
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСистемыНалогообложения()
	
	Если ЗначениеЗаполнено(СистемыНалогообложения.СистемаНалогообложения) Тогда	
		
		Менеджер = РегистрыСведений.СистемыНалогообложенияОрганизаций.СоздатьМенеджерЗаписи();
		
		ЗаполнитьЗначенияСвойств(Менеджер, СистемыНалогообложения);
		
		Менеджер.Организация = Объект.Ссылка;
		Если НЕ ЗначениеЗаполнено(СистемыНалогообложения.Период) Тогда
			Менеджер.Период = ТекущаяДата();	
		КонецЕсли;
		
		// проверим изменялся ли реально набор записей
		НаборМодифицирован = Ложь;
		
		ТаблицаКоды = РегистрыСведений.СистемыНалогообложенияОрганизаций.СрезПоследних(Менеджер.Период, Новый Структура("Организация", Объект.Ссылка));
        Если ТаблицаКоды.Количество() > 0 Тогда
		    Для каждого Колонка Из ТаблицаКоды.Колонки Цикл
				
				Если Колонка.Имя = "Период" Тогда
					Продолжить;
				КонецЕсли;
				
				Если Менеджер[Колонка.Имя] <> ТаблицаКоды[0][Колонка.Имя] Тогда
				
					 НаборМодифицирован = Истина;
					 Прервать;
				
				КонецЕсли;
			
			КонецЦикла;
			
		Иначе
			НаборМодифицирован = Истина;
		КонецЕсли;
		
		Если НаборМодифицирован Тогда
			Менеджер.Записать(Истина);	
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

//	LNK 27.03.2017 09:20:30
&НаСервере
Процедура ПроверитьСоставКодыВидовОплат()

	Для каждого ЗначениеПеречисления Из Перечисления.ВидыОплатЭККР Цикл

		Если Объект.КодыВидовОплат.НайтиСтроки(Новый Структура("ВидОплаты", ЗначениеПеречисления)).Количество() = 0 Тогда

			ИндексКода = Перечисления.ВидыОплатЭККР.Индекс(ЗначениеПеречисления);

			Если ИндексКода >= Объект.КодыВидовОплат.Количество() Тогда

				СтрокаВида = Объект.КодыВидовОплат.Добавить();

			Иначе

				СтрокаВида = Объект.КодыВидовОплат.Вставить(ИндексКода);

			КонецЕсли;

			СтрокаВида.ВидОплаты = ЗначениеПеречисления;
			СтрокаВида.Код       = ИндексКода;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры





