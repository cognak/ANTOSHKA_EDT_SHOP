#Область ПрограммныйИнтерфейс

// Отправляет SMS через настроенного поставщика услуги, возвращает идентификатор сообщения.
//
// Параметры:
//  НомераПолучателей  - Массив - массив строк номеров получателей в формате +7ХХХХХХХХХХ;
//  Текст              - Строка - текст сообщения, максимальная длина у операторов может быть разной;
//  ИмяОтправителя     - Строка - имя отправителя, которое будет отображаться вместо номера у получателей.
//  ПеревестиВТранслит - Булево - Истина, если требуется переводить текст сообщения в транслит перед отправкой.
//
// Возвращаемое значение:
//  Структура - результат отправки:
//    * ОтправленныеСообщения - Массив - массив структур:
//      ** НомерПолучателя - Строка - номер получателя SMS.
//      ** ИдентификаторСообщения - Строка - идентификатор SMS, присвоенный провайдером для отслеживания доставки.
//    * ОписаниеОшибки - Строка - пользовательское представление ошибки, если пустая строка, то ошибки нет.
//
Функция ОтправитьSMS(НомераПолучателей, Знач Текст, ИмяОтправителя = Неопределено, ПеревестиВТранслит = Ложь)	Экспорт

	Если НЕ ПривилегированныйРежим() Тогда

		УстановитьПривилегированныйРежим(Истина);

	КонецЕсли;

	Результат = ОтправкаSMS.ОписаниеРезультата();
	
	Попытка

		Если ПеревестиВТранслит Тогда

			Текст = СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(Текст);

		КонецЕсли;

		Если НЕ НастройкаОтправкиSMSВыполнена() Тогда

			Результат.Ошибка = Истина;
			Результат.ОписаниеОшибки = "Помилково задані налаштування провайдера для надсилання SMS.";

		Иначе

			НастройкиОтправкиSMS = ОтправкаSMSПовтИсп.НастройкиОтправкиSMS();

			Если ИмяОтправителя = Неопределено Тогда

				ИмяОтправителя = НастройкиОтправкиSMS.ИмяОтправителя;

			КонецЕсли;

			Если НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.GMSU Тогда

				Результат = ОтправкаSMSЧерезGMSU.ОтправитьSMS(НомераПолучателей
						, Текст
						, ИмяОтправителя
						, НастройкиОтправкиSMS.Логин
						, НастройкиОтправкиSMS.Пароль
						, НастройкиОтправкиSMS.Таймаут
				);

			ИначеЕсли НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.Infobip Тогда

				Результат = ОтправкаSMSЧерезInfobip.ОтправитьSMS(НомераПолучателей
						, Текст
						, ИмяОтправителя
						, НастройкиОтправкиSMS.Логин
						, НастройкиОтправкиSMS.Пароль
						, НастройкиОтправкиSMS.Таймаут
				);

			Иначе

				Результат.Ошибка = Истина;
				Результат.ОписаниеОшибки = "Немає визначення провайдера або не описаний обробник провайдера!";

			КонецЕсли;

		КонецЕсли;

	Исключение

		Результат.Ошибка = Истина;
		Результат.ОписаниеОшибки = ОписаниеОшибки();

	КонецПопытки;

	Если Результат.Ошибка = Истина Тогда

		ПредставлениеНомера = "";

		Для каждого НомерПолучателя Из НомераПолучателей Цикл

			ПредставлениеНомера = ПредставлениеНомера
				+ ?(ПустаяСтрока(ПредставлениеНомера), "", ", ")
				+ НомерПолучателя
			;

		КонецЦикла;

		ЗаписьЖурналаРегистрации("SMS", УровеньЖурналаРегистрации.Ошибка
			,
			,
			, ПредставлениеНомера + Символы.ПС + Результат.ОписаниеОшибки
			, РежимТранзакцииЗаписиЖурналаРегистрации.Независимая
		);

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Проверяет правильность сохраненных настроек отправки SMS.
//
// Возвращаемое значение:
//  Булево - Истина, если отправка SMS уже настроена.
Функция НастройкаОтправкиSMSВыполнена() Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Результат = Истина;

	НастройкиОтправкиSMS = ОтправкаSMSПовтИсп.НастройкиОтправкиSMS();
	Провайдер = НастройкиОтправкиSMS.Провайдер;

	Если ЗначениеЗаполнено(НастройкиОтправкиSMS.Провайдер) Тогда

		Отказ = Ложь;
		ОтправкаSMSПереопределяемый.ПриПроверкеНастроекОтправкиSMS(НастройкиОтправкиSMS, Отказ);
		Результат = НЕ Отказ;

	Иначе

		Результат = Ложь;

	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПодготовитьНомерТелефона(Знач НомерТелефона, Безусловно = Ложь)	Экспорт

	Если НЕ ПустаяСтрока(НомерТелефона) Тогда

		НастройкиОтправкиSMS = ОтправкаSMSПовтИсп.НастройкиОтправкиSMS();

		Если Безусловно = Истина ИЛИ НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.GMSU Тогда

			НомерТелефона = ОтправкаSMSЧерезGMSU.ПодготовитьНомерТелефона(НомерТелефона);

		Иначе

			НомерТелефона = СтрЗаменить(НомерТелефона, "(", "");
			НомерТелефона = СтрЗаменить(НомерТелефона, ")", "");
			НомерТелефона = СтрЗаменить(НомерТелефона, " ", "");
			НомерТелефона = СтрЗаменить(НомерТелефона, "+", "");

			Если Лев(НомерТелефона, 2) = "38" Тогда

				НомерПредставление = Сред(НомерТелефона, 3);

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат НомерТелефона;

КонецФункции

Функция ОписаниеРезультата()	Экспорт	//	LNK 05.01.2023 05:23:07

	Результат = Новый Структура(
		"ОтправленныеСообщения, ОписаниеОшибки, Идентификатор, Ошибка, КодОтвета"
		, Новый Массив
		, ""
		, ""
		, Ложь
		, 0
	);

	Возврат Результат;

КонецФункции

#КонецОбласти

