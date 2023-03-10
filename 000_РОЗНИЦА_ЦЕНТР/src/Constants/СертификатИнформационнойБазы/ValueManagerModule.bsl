#Область ОбработчикиСобытийОбъекта

//	LNK 18.05.2018 14:28:04
Процедура ПередЗаписью(Отказ)

	Значение = НРег(Значение);

КонецПроцедуры
	
#КонецОбласти

#Область ПолучениеИУстановкаАктуальныхДанных

//	LNK 24.08.2016 09:37:08
Функция ПроверитьСертификатИнформационнойБазы(ПроверитьКонтекст = Истина)	Экспорт

	Если НЕ ПривилегированныйРежим() Тогда

		УстановитьПривилегированныйРежим(Истина);

	КонецЕсли;

	СертификатСоответствует = -1;

	Если ПроверитьКонтекст Тогда

			Отказ = НЕ КонтекстПриложения.ЭтоКлиентскоеСоединение();

	Иначе	Отказ = Ложь;

	КонецЕсли;

	Если НЕ Отказ Тогда

		СертификатСоответствует = ?(Константы.СертификатИнформационнойБазы.Получить() = ПолучитьСертификатИнформационнойБазы(), 1, 0);

	КонецЕсли;

//	Возвращаем:
//	-1 в случае, если не смогли получить какие-либо данные (мало-ли - блокировки какие)
//	1 сертификат соответствует
//	0 сертификат НЕ соответствует
	Возврат СертификатСоответствует;

КонецФункции // ПроверитьСертификатИнформационнойБазы()

//	LNK 18.05.2018 14:24:57
Функция ПолучитьСертификатИнформационнойБазы()	Экспорт

	СертификатИнформационнойБазы = "";

	ИдентификаторЗапроса = СокрЛП(Новый УникальныйИдентификатор);

	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ИдентификаторЗапроса);
//	Значение сертификата получаем в фоновом процессе, так как текущий сеанс может быть подключен по другому имени
//	сервера (например, по IP). А в фоновом будет получено то имя, которое является актуальным.
	КлючЗадания = ?(ПустаяСтрока(ИмяПользователя()), "БезАвторизации", ИмяПользователя())
				+ "_" + Формат(НомерСоединенияИнформационнойБазы(), "ЧЦ=10; ЧДЦ=; ЧН=0; ЧВН=; ЧГ=");
	ФоновыеЗадания.Выполнить("ОбменДаннымиСервер.НачатьПроверкуСертификатаИнформационнойБазы", ПараметрыЗадания, КлючЗадания);

//	Делаем паузу, всё-таки запись в регистр. Ждём пару секунд, в общем...
	ОбщегоНазначенияКлиентСервер.Пауза(2 * 1000);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаРегистра.СертификатИнформационнойБазы КАК СертификатИнформационнойБазы
	|ИЗ
	|	РегистрСведений.ПроверкаСертификатаИнформационнойБазы КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Идентификатор = &Идентификатор"
	);
	Запрос.УстановитьПараметр("Идентификатор", ИдентификаторЗапроса);

//	В цикле делаем несколько попыток получить запись с нашим идентификаторов. Делаем паузу между попытками.
	Для Счётчик = 1 По 5 Цикл

		Результат = Запрос.Выполнить();

		Если Результат.Пустой() Тогда

		//	... опять ждём пару секунд
			ОбщегоНазначенияКлиентСервер.Пауза(2 * 1000);

		Иначе

			Выборка = Запрос.Выполнить().Выбрать();
			Выборка.Следующий();

			СертификатИнформационнойБазы = НРег(Выборка.СертификатИнформационнойБазы);

		//	... подчищаем за собой!
			МенеджерЗаписи = РегистрыСведений.ПроверкаСертификатаИнформационнойБазы.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Идентификатор = ИдентификаторЗапроса;
			МенеджерЗаписи.Удалить();

			Прервать;

		КонецЕсли;

	КонецЦикла;

	Возврат СертификатИнформационнойБазы;

КонецФункции // ПолучитьСертификатИнформационнойБазы()
	
#КонецОбласти