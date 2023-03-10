// По переданному значению перечисления ЮрФизЛицо определяет, является ли оно признаком ЮрЛица
//
// Параметры
//  ЮрФизЛицо  -   Перечисления.ЮрФизЛицо 
// Возвращаемое значение:
//   Булево   - Истина, если юридическое лицо, Ложь если нет.
//
Функция ЭтоЮрЛицо(ЮрФизЛицо) 

	Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо ИЛИ ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент Тогда
		Возврат Истина;
	ИначеЕсли ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо ИЛИ ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции // ЭтоЮрЛицо()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроверкиЗаполнения".
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Перем ТекстСообщения;


КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;


КонецПроцедуры // ПередЗаписью()
