#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура заполняет предопределенные элементы статей движения денежных средств.
//
Процедура ЗаполнитьПредопределенные() Экспорт
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Справочники.ВидыОплатЧекаККМ.Наличные,
		Перечисления.ТипыОплатЧекаККМ.Наличные);
	Соответствие.Вставить(Справочники.ВидыОплатЧекаККМ.ОплатаПодарочнымСертификатом,
		Перечисления.ТипыОплатЧекаККМ.ПодарочныйСертификат);
	Соответствие.Вставить(Справочники.ВидыОплатЧекаККМ.Послеплата,
		Перечисления.ТипыОплатЧекаККМ.Послеплата);
	Соответствие.Вставить(Справочники.ВидыОплатЧекаККМ.Предоплата,
		Перечисления.ТипыОплатЧекаККМ.Предоплата);
		
	Для Каждого Элемент Из Соответствие Цикл
	
		СправочникОбъект = Элемент.Ключ.ПолучитьОбъект();
		Если НЕ СправочникОбъект.ТипОплаты = Элемент.Значение Тогда
			СправочникОбъект.ТипОплаты = Элемент.Значение;
			Попытка
				СправочникОбъект.УстановитьНовыйКод();
				СправочникОбъект.Записать();
			Исключение
			КонецПопытки;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	
	НеРедактируемыеРеквизиты.Добавить("ТипОплаты");
	НеРедактируемыеРеквизиты.Добавить("ИмяПредопределенныхДанных");
	НеРедактируемыеРеквизиты.Добавить("ТипОплаты_ПРРО");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#КонецЕсли
