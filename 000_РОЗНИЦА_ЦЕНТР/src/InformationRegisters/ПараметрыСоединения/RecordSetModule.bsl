Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли;

	Если ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

		Если НЕ ТехническаяПоддержкаВызовСервера.ВыполняютсяСлужебныеДействия() Тогда

			Отказ = Истина;
			Сообщить("Отказано! Недопустимый контекст изменения данных (только «ВыполняютсяСлужебныеДействия»).");

		КонецЕсли;

	Иначе

		Если НЕ УправлениеПользователями.ПолучитьБулевоЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьИзменениеПараметровСоединенияСВнешнимиИсточниками, Ложь)	Тогда

			Отказ = Истина;
			Сообщить("Отказано! Нет дополнительных прав на изменение текущей информации.");

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры
