////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Создавать и отключать автономные рабочие места может только администратор абонента.
	Если Не Пользователи.РолиДоступны("ПолныеПрава") Тогда
		
		ВызватьИсключение НСтр("ru = 'Нарушение прав доступа!'");
		
	ИначеЕсли Не АвтономнаяРаботаСлужебный.АвтономнаяРаботаПоддерживается() Тогда
		
		ВызватьИсключение НСтр("ru = 'Автономная работа для конфигурации не поддерживается!'");
		
	КонецЕсли;
	
	ОбновитьМониторАвтономнойРаботыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьМониторАвтономнойРаботы", 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если    ИмяСобытия = "Создание_АвтономноеРабочееМесто"
		ИЛИ ИмяСобытия = "Запись_АвтономноеРабочееМесто"
		ИЛИ ИмяСобытия = "Удаление_АвтономноеРабочееМесто" Тогда
		
		ОбновитьМониторАвтономнойРаботы();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьАвтономноеРабочееМесто(Команда)
	
	ОткрытьФорму("Обработка.ПомощникСозданияАвтономногоРабочегоМеста.Форма.НастройкаНаСторонеСервиса",, ЭтотОбъект, "1");
	
КонецПроцедуры

&НаКлиенте
Процедура СменитьПарольДляСинхронизацииДанных(Команда)
	
	СменитьПарольДляСинхронизаци(АвтономноеРабочееМесто);
	
КонецПроцедуры

&НаКлиенте
Процедура СменитьПарольДляСинхронизацииДанныхВСписке(Команда)
	
	ТекущиеДанные = Элементы.СписокАвтономныхРабочихМест.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		СменитьПарольДляСинхронизаци(ТекущиеДанные.АвтономноеРабочееМесто);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрекратитьСинхронизациюСАвтономнымРабочимМестом(Команда)
	
	ОтключитьАвтономноеРабочееМесто(АвтономноеРабочееМесто);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрекратитьСинхронизациюСАвтономнымРабочимМестомВСписке(Команда)
	
	ТекущиеДанные = Элементы.СписокАвтономныхРабочихМест.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОтключитьАвтономноеРабочееМесто(ТекущиеДанные.АвтономноеРабочееМесто);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьАвтономноеРабочееМесто(Команда)
	
	Если АвтономноеРабочееМесто <> Неопределено Тогда
		
		ОткрытьЗначение(АвтономноеРабочееМесто);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьАвтономноеРабочееМестоВСписке(Команда)
	
	ТекущиеДанные = Элементы.СписокАвтономныхРабочихМест.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОткрытьЗначение(ТекущиеДанные.АвтономноеРабочееМесто);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьМониторАвтономнойРаботы();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАвтономныхРабочихМестВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.СписокАвтономныхРабочихМест.ТекущиеДанные.АвтономноеРабочееМесто);
	
КонецПроцедуры

&НаКлиенте
Процедура КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяМакета", "КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие");
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Как установить или обновить версию платформы 1С:Предприятие'"));
	
	ОткрытьФорму("Обработка.ПомощникСозданияАвтономногоРабочегоМеста.Форма.ДополнительноеОписание", ПараметрыФормы, ЭтотОбъект, "КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие");
	
КонецПроцедуры

&НаКлиенте
Процедура КакНастроитьАвтономноеРабочееМесто(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяМакета", "ИнструкцияПоНастройкеАвтономногоРабочегоМеста");
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Как настроить автономное рабочее место'"));
	
	ОткрытьФорму("Обработка.ПомощникСозданияАвтономногоРабочегоМеста.Форма.ДополнительноеОписание", ПараметрыФормы, ЭтотОбъект, "ИнструкцияПоНастройкеАвтономногоРабочегоМеста");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьМониторАвтономнойРаботыНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	КоличествоАвтономныхРабочихМест = АвтономнаяРаботаСлужебный.КоличествоАвтономныхРабочихМест();
	
	Если КоличествоАвтономныхРабочихМест = 0 Тогда
		
		Элементы.АвтономнаяРаботаНеНастроена.Видимость = Истина;
		
		Элементы.АвтономнаяРабота.ТекущаяСтраница = Элементы.АвтономнаяРаботаНеНастроена;
		Элементы.ОдноАвтономноеРабочееМесто.Видимость = Ложь;
		Элементы.НесколькоАвтономныхРабочихМест.Видимость = Ложь;
		
	ИначеЕсли КоличествоАвтономныхРабочихМест = 1 Тогда
		
		Элементы.ОдноАвтономноеРабочееМесто.Видимость = Истина;
		
		Элементы.АвтономнаяРабота.ТекущаяСтраница = Элементы.ОдноАвтономноеРабочееМесто;
		Элементы.АвтономнаяРаботаНеНастроена.Видимость = Ложь;
		Элементы.НесколькоАвтономныхРабочихМест.Видимость = Ложь;
		
		АвтономноеРабочееМесто = АвтономнаяРаботаСлужебный.АвтономноеРабочееМесто();
		
		Элементы.ИнформацияОПоследнейСинхронизации.Заголовок = ОбменДаннымиСервер.ПредставлениеДатыСинхронизации(
			АвтономнаяРаботаСлужебный.ДатаПоследнейУспешнойСинхронизации(АвтономноеРабочееМесто)
		);
		
		Элементы.ОписаниеОграниченийПередачиДанных.Заголовок = АвтономнаяРаботаСлужебный.ОписаниеОграниченийПередачиДанных(АвтономноеРабочееМесто);
		
	ИначеЕсли КоличествоАвтономныхРабочихМест > 1 Тогда
		
		Элементы.НесколькоАвтономныхРабочихМест.Видимость = Истина;
		
		Элементы.АвтономнаяРабота.ТекущаяСтраница = Элементы.НесколькоАвтономныхРабочихМест;
		Элементы.АвтономнаяРаботаНеНастроена.Видимость = Ложь;
		Элементы.ОдноАвтономноеРабочееМесто.Видимость = Ложь;
		
		СписокАвтономныхРабочихМест.Загрузить(АвтономнаяРаботаСлужебный.МониторАвтономныхРабочихМест());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекущийИндексСтроки(ИмяТаблицы)
	
	// возвращаемое значение функции
	ИндексСтроки = Неопределено;
	
	// при обновлении монитора выполняем позиционирование курсора
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ИндексСтроки = ЭтотОбъект[ИмяТаблицы].Индекс(ТекущиеДанные);
		
	КонецЕсли;
	
	Возврат ИндексСтроки;
КонецФункции

&НаКлиенте
Процедура ВыполнитьПозиционированиеКурсора(ИмяТаблицы, ИндексСтроки)
	
	Если ИндексСтроки <> Неопределено Тогда
		
		// выполняем проверки позиционирования курсора после получения новых данных
		Если ЭтотОбъект[ИмяТаблицы].Количество() <> 0 Тогда
			
			Если ИндексСтроки > ЭтотОбъект[ИмяТаблицы].Количество() - 1 Тогда
				
				ИндексСтроки = ЭтотОбъект[ИмяТаблицы].Количество() - 1;
				
			КонецЕсли;
			
			// позиционируем курсор
			Элементы[ИмяТаблицы].ТекущаяСтрока = ЭтотОбъект[ИмяТаблицы][ИндексСтроки].ПолучитьИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
	// если спозициронировать строку не удалось, то устанавливаем текущей первую строку
	Если Элементы[ИмяТаблицы].ТекущаяСтрока = Неопределено
		И ЭтотОбъект[ИмяТаблицы].Количество() <> 0 Тогда
		
		Элементы[ИмяТаблицы].ТекущаяСтрока = ЭтотОбъект[ИмяТаблицы][0].ПолучитьИдентификатор();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьМониторАвтономнойРаботы()
	
	ИндексСтроки = ПолучитьТекущийИндексСтроки("СписокАвтономныхРабочихМест");
	
	ОбновитьМониторАвтономнойРаботыНаСервере();
	
	// выполняем позиционирование курсора
	ВыполнитьПозиционированиеКурсора("СписокАвтономныхРабочихМест", ИндексСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьАвтономноеРабочееМесто(ОтключаемоеАвтономноеРабочееМесто)
	
	ПараметрыФормы = Новый Структура("АвтономноеРабочееМесто", ОтключаемоеАвтономноеРабочееМесто);
	
	ОткрытьФорму("ОбщаяФорма.ОтключениеАвтономногоРабочегоМеста", ПараметрыФормы, ЭтотОбъект, ОтключаемоеАвтономноеРабочееМесто);
	
КонецПроцедуры

&НаКлиенте
Процедура СменитьПарольДляСинхронизаци(АвтономноеРабочееМесто)
	
	ПараметрыФормы = Новый Структура("АвтономноеРабочееМесто", АвтономноеРабочееМесто);
	
	ОткрытьФорму("ОбщаяФорма.ПарольДляСинхронизацииДанных", ПараметрыФормы, ЭтотОбъект, АвтономноеРабочееМесто);
	
КонецПроцедуры
