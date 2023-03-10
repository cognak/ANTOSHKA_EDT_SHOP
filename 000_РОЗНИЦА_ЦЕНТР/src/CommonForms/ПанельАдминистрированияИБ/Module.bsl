////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьТекущийРазделПоПараметрамНавигации(Элементы, Заголовок, Параметры);
	
	// Инициализация набора констант
	НаборКонстантОбъект = ДанныеФормыВЗначение(НаборКонстант, Тип("КонстантыНабор"));
	НаборКонстантОбъект.Прочитать();
	ЗначениеВДанныеФормы(НаборКонстантОбъект, НаборКонстант);
	
	ИнформационнаяБазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	Элементы.ГруппаПараметрыАдминистрированияИБ.Видимость 		 = НЕ ИнформационнаяБазаФайловая;
	Элементы.ГруппаУправлениеКаталогамиСообщенийОбмена.Видимость = НЕ ИнформационнаяБазаФайловая;
	Элементы.ГруппаКомментарийКаталогиСообщенийОбмена.Видимость  = ИнформационнаяБазаФайловая;
	
	МаксимальныйРазмерФайла = ФайловыеФункции.МаксимальныйРазмерФайла() / (1024*1024);
	
	КластерСервера1СПредприятияРазвернутНаНесколькихМашинах =
		ЗначениеЗаполнено(НаборКонстант.КаталогВременныхФайловДляWindows)
		ИЛИ ЗначениеЗаполнено(НаборКонстант.КаталогВременныхФайловДляLinux);
	
	УстановитьВидимостьДоступностьЗависимыхЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ТребуетсяОбновлениеИнтерфейса Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПереключениеРазделаАдминистрированияИБ" Тогда
		УстановитьТекущийРазделПоПараметрамНавигации(Элементы, Заголовок, Параметр);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// Обмен данными

&НаКлиенте
Процедура КластерСервера1СПредприятияРазвернутНаНесколькихМашинахПриИзменении(Элемент)
	
	Элементы.ГруппаВременныеКаталогиСообщенийОбмена.Видимость = КластерСервера1СПредприятияРазвернутНаНесколькихМашинах;
	
	УстановитьЗначенияЗависимыхКонстант(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогВременныхФайловСообщенийОбменаДляWindowsПриИзменении(Элемент)
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогВременныхФайловСообщенийОбменаДляLinuxПриИзменении(Элемент)
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки работы с файлами

&НаКлиенте
Процедура ХранитьФайлыВТомахНаДискеПриИзменении(Элемент)
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаПриИзменении(Элемент)
	
	НаборКонстант.МаксимальныйРазмерФайла = МаксимальныйРазмерФайла * (1024*1024);
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗапрещенныхРасширенийПриИзменении(Элемент)
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийФайловOpenDocumentПриИзменении(Элемент)
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийТекстовыхФайловПриИзменении(Элемент)
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// Общие настройки

&НаКлиенте
Процедура ПараметрыАдминистрированияИБ(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыАдминистрированияСервернойИБ");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПараметрыПроксиСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", , ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки работы с файлами

&НаКлиенте
Процедура ОткрытьТомаХраненияФайлов(Команда)
	
	ОткрытьФорму("Справочник.ТомаХраненияФайлов.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// При изменении реквизитов

&НаСервере 
Процедура СохранитьЗначениеКонстанты(ИмяКонстанты)
	
	УстановитьЗначениеКонстантыПоИмени(ИмяКонстанты);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаСервере 
Процедура УстановитьЗначениеКонстантыПоИмени(ИмяКонстанты)
	
	Если Константы[ИмяКонстанты].Получить() <> НаборКонстант[ИмяКонстанты] Тогда
		Константы[ИмяКонстанты].Установить(НаборКонстант[ИмяКонстанты]);
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЗависимыхЭлементовФормы(ИмяКонстанты);
	
	УстановитьЗначенияЗависимыхКонстант(ИмяКонстанты);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьЗависимыхЭлементовФормы(ИмяКонстанты = Неопределено)
	
	Если ИмяКонстанты = "ХранитьФайлыВТомахНаДиске" Или ИмяКонстанты = Неопределено Тогда
		Элементы.ОткрытьТомаХраненияФайлов.Доступность = НаборКонстант.ХранитьФайлыВТомахНаДиске;
	КонецЕсли;
	
	Если ИмяКонстанты = "КластерСервера1СПредприятияРазвернутНаНесколькихМашинах" Или ИмяКонстанты = Неопределено Тогда
		Элементы.ГруппаВременныеКаталогиСообщенийОбмена.Видимость = КластерСервера1СПредприятияРазвернутНаНесколькихМашинах;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура УстановитьЗначенияЗависимыхКонстант(ИмяРодительскойКонстанты)
	
	Если ИмяРодительскойКонстанты = "КластерСервера1СПредприятияРазвернутНаНесколькихМашинах" Тогда
		
		Если Не КластерСервера1СПредприятияРазвернутНаНесколькихМашинах Тогда
			
			Если ЗначениеЗаполнено(НаборКонстант.КаталогВременныхФайловДляLinux) Тогда
				НаборКонстант.КаталогВременныхФайловДляLinux   = "";
				УстановитьЗначениеКонстантыПоИмени("КаталогВременныхФайловДляLinux");
			КонецЕсли;
			
			Если ЗначениеЗаполнено(НаборКонстант.КаталогВременныхФайловДляWindows) Тогда
				НаборКонстант.КаталогВременныхФайловДляWindows = "";
				УстановитьЗначениеКонстантыПоИмени("КаталогВременныхФайловДляWindows");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Процедура ПодключитьОбработчикОжиданияОбновленияИнтерфейса()
	
	ТребуетсяОбновлениеИнтерфейса = Истина;
	
	#Если НЕ ВебКлиент Тогда
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбновленияИнтерфейса", 1, Истина);
	#КонецЕсли 
	
КонецПроцедуры

&НаКлиенте 
Процедура ОбработчикОжиданияОбновленияИнтерфейса()
	
	ОбновитьИнтерфейс();
	
	ТребуетсяОбновлениеИнтерфейса = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаКлиентеНаСервереБезКонтекста 
Процедура УстановитьТекущийРазделПоПараметрамНавигации(Элементы, Заголовок, ПараметрыНавигации)
	
	Если ПараметрыНавигации.Свойство("ТекущийРаздел") Тогда
		
		НовыйТекущийРаздел = Элементы.СтраницыПараметровИБ.ПодчиненныеЭлементы["Страница" + ПараметрыНавигации.ТекущийРаздел];
		Заголовок 		   = НовыйТекущийРаздел.Заголовок;
		
		Элементы.СтраницыПараметровИБ.ТекущаяСтраница = НовыйТекущийРаздел;
		
	КонецЕсли;
	
КонецПроцедуры
