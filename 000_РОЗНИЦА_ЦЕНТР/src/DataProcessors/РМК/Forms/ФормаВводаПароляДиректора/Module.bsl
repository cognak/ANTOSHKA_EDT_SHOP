
&НаКлиенте
Процедура ОК(Команда)
	Если  ПарольДиректора = ПарольДиректораРегистр тогда
		Закрыть(Истина);
	Иначе
		ПарольДиректора = "";
		ПоказатьПредупреждение(,"Пароль не верен!",5,"Проверьте ввод пароля!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОТМЕНА(Команда)
		Закрыть(ложь);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект().Журнал(ИмяФормы + ".ПриСозданииНаСервере");	//	LNK 02.08.2019 10:56:00

    Если Параметры.Свойство("ПарольДиректораРегистр") тогда
        ПарольДиректораРегистр = Параметры.ПарольДиректораРегистр;
	КонецЕсли;

КонецПроцедуры

&НаСервере	//	LNK 16.07.2019 11:09:02
Функция ЭтотОбъект(ТекущийОбъект = Неопределено) 

	Если ТекущийОбъект = Неопределено Тогда

		Возврат РеквизитФормыВЗначение("Объект");

	КонецЕсли;

	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");

	Возврат Неопределено;

КонецФункции
