////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПараметрСписка("РежимВыбора");
	ЗаполнитьПараметрСписка("ВыборГруппИЭлементов");
	ЗаполнитьПараметрСписка("МножественныйВыбор");
	ЗаполнитьПараметрСписка("ТекущаяСтрока");
	
	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	Если НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеРассылокОтчетов") Тогда
		// Только личные рассылки
		// Скрыть лишние колонки
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		// Скрыть группы
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтоГруппа");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Ложь;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ПустаяДата", '00010101');
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики ожидания

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеФоновогоЗадания()
	РассылкаОтчетовКлиент.ПроверитьВыполнениеФоновогоЗадания(ЭтотОбъект);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьПараметрСписка(Ключ)
	Если Параметры.Свойство(Ключ) И ЗначениеЗаполнено(Параметры[Ключ]) Тогда
		Элементы.Список[Ключ] = Параметры[Ключ];
	КонецЕсли;
КонецПроцедуры
