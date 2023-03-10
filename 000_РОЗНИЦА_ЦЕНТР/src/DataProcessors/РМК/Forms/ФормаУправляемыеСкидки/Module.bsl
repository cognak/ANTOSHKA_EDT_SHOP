///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ЗаполнитьСписокВыбора(ПараметрыОткрытия)
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаУправляемыеСкидкиДокумента.Ссылка КАК СкидкаНаценка
	|ПОМЕСТИТЬ ТаблицаВЗапросе
	|ИЗ
	|	Справочник.СкидкиНаценки КАК ТаблицаУправляемыеСкидкиДокумента
	|ГДЕ
	|	ТаблицаУправляемыеСкидкиДокумента.Ссылка В(&МассивУправляемыеСкидкиДокумента)
	|;
	|%ТаблицаСкидокСВыполненнымиУсловиями%
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ВложенныйЗапрос.СкидкаНаценка,
	|	ВложенныйЗапрос.Выбран
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ДействиеСкидокНаценокСрезПоследних.СкидкаНаценка КАК СкидкаНаценка,
	|		ЛОЖЬ КАК Выбран
	|	ИЗ
	|		РегистрСведений.ДействиеСкидокНаценок.СрезПоследних(
	|				&ДатаСкидок,
	|				(ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|					ИЛИ ДатаОкончания >= &ДатаСкидок)
	|					И (Магазин = &Магазин
	|						ИЛИ Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка))
	|					И СкидкаНаценка.СпособПредоставления <> ЗНАЧЕНИЕ(Перечисление.СпособыПредоставленияСкидокНаценок.ЗапретРозничнойПродажи)
	|					И СкидкаНаценка.Управляемая) КАК ДействиеСкидокНаценокСрезПоследних
	|	ГДЕ
	|		НЕ ДействиеСкидокНаценокСрезПоследних.СкидкаНаценка В
	|					(ВЫБРАТЬ
	|						ТаблицаВЗапросе.СкидкаНаценка
	|					ИЗ
	|						ТаблицаВЗапросе КАК ТаблицаВЗапросе)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВЗапросе.СкидкаНаценка,
	|		ИСТИНА
	|	ИЗ
	|		ТаблицаВЗапросе КАК ТаблицаВЗапросе) КАК ВложенныйЗапрос
	|%ТекстСоединенияВыполненныхУсловий%
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.Выбран УБЫВ";
	
	ТекстВыполненныхУсловий = "";
	ТекстСоединенияВыполненныхУсловий = "";
	
	Запрос.УстановитьПараметр("ДатаСкидок", ПараметрыОткрытия.Дата);
	Запрос.УстановитьПараметр("Магазин"   , ПараметрыОткрытия.Магазин);
	Запрос.УстановитьПараметр("МассивУправляемыеСкидкиДокумента", ПараметрыОткрытия.МассивУправляемыеСкидкиДокумента);

	Если ЗначениеЗаполнено(Параметры.АдресСкидокВХранилище) Тогда

		ДанныеРасчетаСкидок = ПолучитьИзВременногоХранилища(Параметры.АдресСкидокВХранилище);
		ПримененныеСкидки   = ДанныеРасчетаСкидок[0].Результаты;

		ТаблицаСкидокСВыполненнымиУсловиями = Новый ТаблицаЗначений;
		ТаблицаСкидокСВыполненнымиУсловиями.Колонки.Добавить("Скидка", Новый ОписаниеТипов("СправочникСсылка.СкидкиНаценки"));

		ПолучитьТаблицуСкидокСВыполненнымиУсловиями(ПримененныеСкидки.ДеревоСкидок.Строки, ТаблицаСкидокСВыполненнымиУсловиями);
		
	//	Нужно обработать ПримененныеСкидки.ДеревоСкидок.Строки сформировав таблицу значений
	//	выбрать из нее управляемые скидки
	//	для которых выполнились условия
	//	добавить соединение в текст запроса с этой таблицей

		ТекстВыполненныхУсловий = "
		|ВЫБРАТЬ
		|	ТаблицаСкидокСВыполненнымиУсловиями.Скидка КАК Скидка
		|ПОМЕСТИТЬ ТаблицаСкидокСВыполненнымиУсловиями
		|ИЗ
		|	&ТаблицаСкидокСВыполненнымиУсловиями КАК ТаблицаСкидокСВыполненнымиУсловиями
		|;";
		ТекстСоединенияВыполненныхУсловий = "
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаСкидокСВыполненнымиУсловиями КАК ТаблицаСкидокСВыполненнымиУсловиями
		|	ПО ТаблицаСкидокСВыполненнымиУсловиями.Скидка = ВложенныйЗапрос.СкидкаНаценка
		|";
		
		Запрос.УстановитьПараметр("ТаблицаСкидокСВыполненнымиУсловиями", ТаблицаСкидокСВыполненнымиУсловиями);
		Если ПримененныеСкидки.Свойство("СведенияДокумента") Тогда
			ОтобразитьНадписьСегменатИсключения(ПримененныеСкидки.СведенияДокумента);
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТаблицаСкидокСВыполненнымиУсловиями%", ТекстВыполненныхУсловий);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТекстСоединенияВыполненныхУсловий%", ТекстСоединенияВыполненныхУсловий);
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	Список.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("МассивУправляемыеСкидкиДокумента") Тогда
		ЗаполнитьСписокВыбора(Параметры);
		
		Если Параметры.Свойство("НадписьПустогоСписка") Тогда
			Элементы.ДекорацияСписокПуст.Заголовок = Параметры.НадписьПустогоСписка;
		КонецЕсли;
		
		Если Список.Количество() = 0 Тогда
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСписокПуст;
		КонецЕсли;
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Выбран = НЕ ТекущиеДанные.Выбран;
	
	ПередвинутьПозицию(1);
	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаВниз(Команда)
	
	ПередвинутьПозицию(1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВверх(Команда)
	
	ПередвинутьПозицию(-1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ЗафиксироватьВыбор();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажки(Команда)
	
	Для каждого СтрокаСписка Из Список Цикл
		СтрокаСписка.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажки(Команда)
	
	Для каждого СтрокаСписка Из Список Цикл
		СтрокаСписка.Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСписокПустНажатие(Элемент)
	
	Закрыть();
	
КонецПроцедуры



///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Передвинуть позицию в списке
//
// Параметры:
// Движение = 1 (вниз) или -1 (вверх)
// 
&НаКлиенте
Процедура ПередвинутьПозицию(Движение)
	// Вставить содержимое обработчика.
	Если Список.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено  Тогда
		ИндексСтроки = 0;
	Иначе
		ИндексСтроки = Список.Индекс(ТекущиеДанные);
	КонецЕсли;
	
	ИндексСтроки = ИндексСтроки + Движение;
	
	Если ИндексСтроки > (Список.Количество() - 1) Тогда
		ИндексСтроки = 0;
	ИначеЕсли ИндексСтроки < 0 Тогда
		ИндексСтроки = Список.Количество() - 1;
	КонецЕсли;
	
	ТекущиеДанные = Список[ИндексСтроки];
	Элементы.Список.ТекущаяСтрока = ТекущиеДанные.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьВыбор()
	
	МассивУправляемыхСкидок = Новый Массив;
	
	Для каждого СтрокаСписка Из Список Цикл
		Если СтрокаСписка.Выбран Тогда
			МассивУправляемыхСкидок.Добавить(СтрокаСписка.СкидкаНаценка);
		КонецЕсли;
	КонецЦикла;
	
	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("МассивУправляемыхСкидок" , МассивУправляемыхСкидок);
	Закрыть(СтруктураСтроки)
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьНадписьСегменатИсключения(СведенияДокумента)
	
	Если ЗначениеЗаполнено(СведенияДокумента.СегментИсключаемойНоменклатуры) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика
		|ПОМЕСТИТЬ втТовары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	втТовары КАК Товары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента
		|		ПО НоменклатураСегмента.Номенклатура = Товары.Номенклатура
		|			И НоменклатураСегмента.Характеристика = Товары.Характеристика
		|ГДЕ
		|	НоменклатураСегмента.Сегмент = &Сегмент
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		Запрос.УстановитьПараметр("Сегмент", СведенияДокумента.СегментИсключаемойНоменклатуры);
		Запрос.УстановитьПараметр("Товары", СведенияДокумента.Товары.Выгрузить());
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() > 0 Тогда
			Элементы.ТекстОбИСключениях.Видимость = Истина;
			СтрокиСИсключениями = "";
			КоличествоСтрок = 0;
			Пока Выборка.Следующий() Цикл
				КоличествоСтрок = КоличествоСтрок + 1;
				Если КоличествоСтрок > 1 Тогда
					СтрокиСИсключениями = СтрокиСИсключениями + ", ";
				КонецЕсли;
				СтрокиСИсключениями = СтрокиСИсключениями + Выборка.НомерСтроки;
			КонецЦикла;
			Если КоличествоСтрок = 1 Тогда
				ТекстЗаголовка = "У рядку %1 міститься номенклатура, що входить до складу сегмента-виключення знижок.
								|У цьому рядку автоматичні та керовані знижки не розраховуватимуться.";
			Иначе	//	LNK 23.11.2022 09:35:19 Хера се!.. одинаковое сообщение - нужно разбираться
				ТекстЗаголовка = "У рядку %1 міститься номенклатура, що входить до складу сегмента-виключення знижок.
								|У цьому рядку автоматичні та керовані знижки не розраховуватимуться.";
			КонецЕсли;
			ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, СтрокиСИсключениями);
			Элементы.ТекстОбИСключениях.Заголовок = ТекстЗаголовка;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуСкидокСВыполненнымиУсловиями(СтрокиДерева, ТаблицаРезультат)
	
	Для Каждого СтрокаДерева ИЗ СтрокиДерева Цикл
		Если СтрокаДерева.ЭтоГруппа Тогда
			ПолучитьТаблицуСкидокСВыполненнымиУсловиями(СтрокаДерева.Строки, ТаблицаРезультат);
		Иначе
			Если СтрокаДерева.Управляемая И СтрокаДерева.ПараметрыУсловий.Свойство("УсловияВыполнены") Тогда
				Если СтрокаДерева.ПараметрыУсловий.УсловияВыполнены Тогда
					НоваяСтрока = ТаблицаРезультат.Добавить();
					НоваяСтрока.Скидка = СтрокаДерева.СкидкаНаценка;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции







