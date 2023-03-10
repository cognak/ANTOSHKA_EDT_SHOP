
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


//Процедура - обработчик события "ПриСозданииНаСервере" формы
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ГруппаЦеноваяГруппа.Видимость    = ПолучитьФункциональнуюОпцию("ИспользоватьЦеновыеГруппы");
	
	ИспользоватьАссортимент = АссортиментСервер.ПолучитьФункциональнуюОпциюИспользованияАссортимента();
	Элементы.ГруппаМарка.Видимость             = ИспользоватьАссортимент;
	Элементы.ГруппаТоварнаяКатегория.Видимость = ИспользоватьАссортимент;

	АдминистраторСистемы = РольДоступна(Метаданные.Роли.АдминистраторСистемы) И ТехническаяПоддержкаВызовСервера.ИсключительныйРежим() = Истина;

	Элементы.ГруппаАдминистрирование.Видимость = АдминистраторСистемы;
	
	ЗаполнитьСписокРеквизитов();
	
	УстановитьВсеОтметкиСервер(Истина);

КонецПроцедуры // ПриСозданииНаСервере()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

//Процедура - обработчик команды "РазрешитьРедактирование"
//
&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	Результат = Новый Массив;
	
	Если РазрешитьРедактированиеВидНоменклатуры Тогда
		Результат.Добавить("ВидНоменклатуры");       		
	КонецЕсли;
		
	Если РазрешитьРедактированиеСтавкаНДС Тогда
		Результат.Добавить("СтавкаНДС");             		
	КонецЕсли;
	
	Если РазрешитьРедактированиеЦеноваяГруппа Тогда
		Результат.Добавить("ЦеноваяГруппа");        		
	КонецЕсли;
	
	Если РазрешитьРедактированиеНаборУпаковок Тогда
		Результат.Добавить("НаборУпаковок");       		
	КонецЕсли;
	
	Если РазрешитьРедактированиеЕдиницаИзмерения Тогда
		Результат.Добавить("ЕдиницаИзмерения");       		
	КонецЕсли;
	
	Если РазрешитьРедактированиеВесовой Тогда
		Результат.Добавить("Весовой");       		
	КонецЕСли;	
	
	Если РазрешитьРедактированиеТипСерийногоНомера Тогда		
		Результат.Добавить("ТипСерийногоНомера");       		
	КонецЕсли;	
	
	Если РазрешитьРедактированиеИспользоватьСерийныеНомера Тогда
		Результат.Добавить("ИспользоватьСерийныеНомера");       		
	КонецЕсли;	
	
	Если РазрешитьРедактированиеНоминал Тогда
		Результат.Добавить("Номинал");       		
	КонецЕсли;	
	
	Если РазрешитьРедактированиеМарка Тогда
		Результат.Добавить("ТоварнаяКатегория");        		
	КонецЕсли;
	
	Если РазрешитьРедактированиеТоварнаяКатегория Тогда
		Результат.Добавить("Марка");        		
	КонецЕсли;
	
	Если РазрешитьРедактированиеТоварнаяКатегория Тогда
		Результат.Добавить("ПодакцизныйТовар");        		
	КонецЕсли;

	Если АдминистраторСистемы Тогда

		Если РазрешитьРедактированиеНазначениеТовара Тогда
			Результат.Добавить("НазначениеТовара");        		
		КонецЕсли;
		
		Если РазрешитьРедактированиеТипНоменклатуры Тогда
			Результат.Добавить("ТипНоменклатуры");        		
		КонецЕсли;

	КонецЕсли;

	Закрыть(Результат);
	
КонецПроцедуры // РазрешитьРедактирование()

&НаКлиенте
Процедура УстановитьВсеОтметки(Команда)
	
	УстановитьВсеОтметкиКлиент(Истина)
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеОтметки(Команда)
	
	УстановитьВсеОтметкиКлиент(Ложь)
	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьСписокРеквизитов()
	
	Для каждого ЭлементФормы Из Элементы Цикл
		Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") 
			И Найти(ЭлементФормы.Имя, "РазрешитьРедактирование") = 1 Тогда
			СписокРеквизитов.Добавить(ЭлементФормы.Имя);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВсеОтметкиСервер(ЗначениеОтметки)
	
	Для каждого ЭлементСписка из СписокРеквизитов Цикл
		
		ЭтотОбъект[ЭлементСписка.Значение] = ЗначениеОтметки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсеОтметкиКлиент(ЗначениеОтметки)
	
	Для каждого ЭлементСписка из СписокРеквизитов Цикл
		
		ЭтотОбъект[ЭлементСписка.Значение] = ЗначениеОтметки;
		
	КонецЦикла;
	
КонецПроцедуры
