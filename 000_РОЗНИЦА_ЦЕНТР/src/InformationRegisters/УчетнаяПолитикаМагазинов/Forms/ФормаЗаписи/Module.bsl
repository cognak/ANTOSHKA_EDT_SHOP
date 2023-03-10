#Область ОбработчикиСобытийФормы

&НаСервере	//	LNK 27.07.2021 05:27:24
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если НЕ УправлениеПользователями.ПолучитьБулевоЗначениеПраваПользователя("АдминистраторПолномочный", Ложь) = Истина Тогда

		ТолькоПросмотр = Истина;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если НЕ ПустаяСтрока(ИмяТекущейСтраницы) Тогда

		Элементы.Страницы.ТекущаяСтраница = Элементы[ИмяТекущейСтраницы];

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	ИмяТекущейСтраницы = Элементы.Страницы.ТекущаяСтраница.Имя;

КонецПроцедуры

&НаСервере	//	LNK 03.08.2021 06:41:21
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ОбновитьПовторноИспользуемыеЗначения();

КонецПроцедуры

&НаКлиенте	//	LNK 03.08.2021 06:41:21
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ОбновитьПовторноИспользуемыеЗначения();

КонецПроцедуры

#КонецОбласти
