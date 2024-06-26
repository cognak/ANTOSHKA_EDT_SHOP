#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//	LNK 20.09.2023 09:15:24
Функция РеквизитыФонда(Фонд, ДатаСреза = '00010101')	Экспорт

	Если НЕ ПривилегированныйРежим() Тогда

		УстановитьПривилегированныйРежим(Истина);

	КонецЕсли;

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаСправочник.Ссылка КАК Фонд,
	|	ТаблицаСправочник.Код КАК Код,
	|	ТаблицаСправочник.Контрагент КАК Контрагент,
	|	ТаблицаСправочник.ПрограммаЛояльности КАК ПрограммаЛояльности
	|ИЗ
	|	Справочник.Фонды КАК ТаблицаСправочник
	|ГДЕ
	|	ТаблицаСправочник.Ссылка = &Фонд"
	);
	Запрос.УстановитьПараметр("Фонд", Фонд);
	Запрос.УстановитьПараметр("ДатаСреза", ?(ДатаСреза = '00010101' ИЛИ ДатаСреза = Неопределено, ТекущаяДатаСеанса(), ДатаСреза));

	РезультатЗапроса = Запрос.Выполнить();
	Выборка			 = РезультатЗапроса.Выбрать();
	Выборка.Следующий();

	СоставРеквизитов = ОбщегоНазначенияРТ.СоздатьСтруктуруПоСтрокеВыборки(РезультатЗапроса, Выборка, Истина);
	
	Возврат СоставРеквизитов;

КонецФункции

#КонецЕсли
