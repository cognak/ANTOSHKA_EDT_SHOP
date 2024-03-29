#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = СокрЛП(КонтактноеЛицо);
	Код = СокрЛП(Идентификатор);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;

	МассивНепроверяемыхРеквизитов.Добавить("Телефон");
	
	Если СокрЛП(Телефон) <> "" Тогда
		Если СтрДлина(СокрЛП(Телефон)) = 10 и Лев(СокрЛП(Телефон),2) <> "38" Тогда
			ТелефонКонтакт = "38"+СокрЛП(Телефон);
		ИначеЕсли НЕ (СтрДлина(СокрЛП(Телефон)) = 12 и Лев(СокрЛП(Телефон),2) = "38") Тогда

			ТекстОшибки = НСтр("ru = 'Телефон задан неверно! Пожалуйста, введите телефон в формате 38-код-номер';
					|uk = 'Телефон неправильний! Будь ласка, введіть телефон у форматі 38-код-номер'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Телефон",
				,
				Отказ
				);
	
		КонецЕсли;
	КонецЕсли;	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры


Процедура ПриКопировании(ОбъектКопирования)
	
	Идентификатор = "";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Код процедур и функций
#КонецОбласти

#Область Инициализация

#КонецОбласти

#Иначе
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли