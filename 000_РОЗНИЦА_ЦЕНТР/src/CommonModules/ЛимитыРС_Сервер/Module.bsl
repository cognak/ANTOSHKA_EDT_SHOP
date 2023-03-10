Процедура ОтразитьЛимитыРучныхСкидокРегионы(ДополнительныеСвойства, Движения, Отказ)	Экспорт

	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЛимитыРучныхСкидокРегионы;

	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда

		Возврат;

	КонецЕсли;

	Движения.ЛимитыРучныхСкидокРегионы.Записывать = Истина;
	Движения.ЛимитыРучныхСкидокРегионы.Загрузить(Таблица);

КонецПроцедуры

Процедура ОтразитьЛимитыРучныхСкидокУстановлены(ДополнительныеСвойства, Движения, Отказ)	Экспорт

	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЛимитыРучныхСкидокУстановлены;

	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда

		Возврат;

	КонецЕсли;

	Движения.ЛимитыРучныхСкидокУстановлены.Записывать = Истина;
	Движения.ЛимитыРучныхСкидокУстановлены.Загрузить(Таблица);

КонецПроцедуры

Процедура ОтразитьЛимитыРучныхСкидокМагазины(ДополнительныеСвойства, Движения, Отказ)	Экспорт

	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЛимитыРучныхСкидокМагазины;

	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда

		Возврат;

	КонецЕсли;

	Движения.ЛимитыРучныхСкидокМагазины.Записывать = Истина;
	Движения.ЛимитыРучныхСкидокМагазины.Загрузить(Таблица);

КонецПроцедуры
