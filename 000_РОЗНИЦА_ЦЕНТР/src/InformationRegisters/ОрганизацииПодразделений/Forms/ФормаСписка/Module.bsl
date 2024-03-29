#Область ОбработчикиСобытийФормы

&НаСервере	//	LNK 21.11.2023 06:34:48
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;

	АдминистраторПолномочный = УправлениеПользователями.ПолучитьБулевоЗначениеПраваПользователя("АдминистраторПолномочный", Ложь);

КонецПроцедуры

&НаКлиенте	//	LNK 22.11.2023 05:39:57
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	Если НЕ АдминистраторПолномочный Тогда

		Отказ = Истина;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте	//	LNK 22.11.2023 05:40:07
Процедура СписокПередУдалением(Элемент, Отказ)

	Если НЕ АдминистраторПолномочный Тогда

		Отказ = Истина;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте	//	LNK 22.11.2023 18:16:16
Процедура СписокПослеУдаления(Элемент)

	Оповестить("ЗаписьОрганизацииПодразделений"
		, Новый Структура(
			"Магазин, Организация"
			, Неопределено
			, Неопределено
		)
	);

КонецПроцедуры

#КонецОбласти


















