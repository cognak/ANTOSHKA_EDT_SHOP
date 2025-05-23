#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ТолькоПросмотр = ТолькоПросмотр();
	
	Если Параметры.Отбор.Свойство("СчетНаОплатуПокупателю") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ВсеДанные", Ложь);
		ОснованиеЗаявки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Отбор.СчетНаОплатуПокупателю, "ОснованиеЗаявки"); 
		Если ОснованиеЗаявки = Документы.СчетНаОплатуПокупателю.ПустаяСсылка() Тогда
			Список.Параметры.УстановитьЗначениеПараметра("СчетНаОплатуПокупателю", Параметры.Отбор.СчетНаОплатуПокупателю);
		Иначе 
			Список.Параметры.УстановитьЗначениеПараметра("СчетНаОплатуПокупателю", ОснованиеЗаявки);
		КонецЕсли;
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("ВсеДанные", Истина);
		Список.Параметры.УстановитьЗначениеПараметра("СчетНаОплатуПокупателю", Документы.СчетНаОплатуПокупателю.ПустаяСсылка());
	КонецЕсли;

КонецПроцедуры

&НаКлиенте	//	LNK 12.10.2020 10:44:11
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзменениеСпискаСчетНаОплатуПокупателю" Тогда

		Элементы.Список.Обновить();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Список.Отбор.Элементы.Очистить()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)

	Если ТолькоПросмотр() ИЛИ НЕ ТехническаяПоддержкаВызовСервера.ВыполняютсяСлужебныеДействия() Тогда

		Отказ = Истина;
		ПоказатьОповещениеПользователя("Отказано!",, "Удаление записей регистра запрещено", БиблиотекаКартинок.Ошибка32);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ТолькоПросмотр()

	Возврат НЕ (ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ДанныеКредитныхПрограмм)
		И ТехническаяПоддержкаВызовСервера.ИсключительныйРежим());

КонецФункции

#КонецОбласти
