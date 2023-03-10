&НаКлиенте
Перем ОтменаВсехДействий;
&НаКлиенте
Перем ЗакрытиеЛЖ;

&НаКлиенте
Процедура СканироватьТовар(Команда)
	Элементы.Анкета.Видимость = Ложь;
	Элементы.Товар.Видимость = Истина;
	Элементы.Группа1.ТекущаяСтраница = Элементы.Товар;
	//ЭтотОбъект.Товар = Элементы.ПоискШК;
	Элементы.ПрименитьРедактирование.Видимость = Ложь;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЛистЖеланий = Параметры.Заказ;
	Операция = Параметры.Операция;
	Корзина  = Параметры.Корзина;
	СуммаДокумента = 0;
	Если ЗначениеЗаполнено(ЛистЖеланий) Тогда
		ЗаполнитьРеквизитыФормы();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОтменаВсехДействий = Истина;
	ЗакрытиеЛЖ = Ложь;	
	Если ЗначениеЗаполнено(ЛистЖеланий) Тогда
		Элементы.Анкета.Видимость = Ложь;
		Элементы.Товар.Видимость = Истина;
		Элементы.Товары.АктивизироватьПоУмолчанию = Истина;
	Иначе
		Элементы.Анкета.Видимость = Истина;
		Элементы.Товар.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормы()
	Анкета = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ЛистЖеланий, "Анкета");
	РеквизитыАнкеты = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Анкета, "Наименование, ИмяИмениника, ПолИмениника, НомерТелефонаРодителя, ЭлектроннаяПочтаРодителя,
	| ДатаРожденияИменинника, ДатаПразднования, Продавец, РазрешениеНаИспользованиеДанных");
	ФИОРодителя = Анкета.Наименование;
	ИмяИмениника = Анкета.ИмяИмениника;
	ПолИмениника = Анкета.ПолИмениника;
	НомерТелефонаРодителя = Анкета.НомерТелефонаРодителя ;
	ИмяПочтовогоЯщика = Лев(Анкета.ЭлектроннаяПочтаРодителя, СтрНайти(Анкета.ЭлектроннаяПочтаРодителя,"@")-1);
	ДоменПочтовогоЯщика = Сред(Анкета.ЭлектроннаяПочтаРодителя, СтрНайти(Анкета.ЭлектроннаяПочтаРодителя,"@")+1);
	ДатаРожденияИменинника = Анкета.ДатаРожденияИменинника;
	ДатаПразднования = Анкета.ДатаПразднования;
	Продавец = Анкета.Продавец;
	РазрешениеНаИспользованиеДанных = Анкета.РазрешениеНаИспользованиеДанных;
	Элементы.Декорация2.Заголовок = Строка(Продавец);
	Элементы.СсылкаНаЛистЖеланий.Заголовок = Строка(ЛистЖеланий);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛистыЖеланийОстатки.Магазин,
		|	ЛистыЖеланийОстатки.ЛистЖеланий,
		|	ЛистыЖеланийОстатки.Корзина,
		|	ЛистыЖеланийОстатки.Номенклатура,
		|	ЛистыЖеланийОстатки.Характеристика,
		|	ЛистыЖеланийОстатки.КоличествоОстаток как Количество
		|ИЗ
		|	РегистрНакопления.ЛистыЖеланий.Остатки(, ЛистЖеланий = &ЛистЖеланий) КАК ЛистыЖеланийОстатки";
	
	Запрос.УстановитьПараметр("ЛистЖеланий", ЛистЖеланий);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		Цена = ПолучитьЦенуНаСервере(Выборка.Номенклатура, Выборка.Характеристика);
		Если Цена > 0 Тогда
			НоваяСтрока.Цена = Цена;
		Иначе
			НоваяСтрока.Цена = 0;
		КонецЕсли;
		СуммаДокумента = СуммаДокумента + Цена;
	КонецЦикла;
	
	ЗапросЛОГ = Новый Запрос;
	ЗапросЛОГ.Текст = 
		"ВЫБРАТЬ
		|	ЛистыЖеланий.Магазин,
		|	ЛистыЖеланий.ЛистЖеланий,
		|	ЛистыЖеланий.Корзина,
		|	ЛистыЖеланий.Номенклатура,
		|	ЛистыЖеланий.Характеристика,
		|	ЛистыЖеланий.Количество,
		|	ЛистыЖеланий.Операция,
		|	ЛистыЖеланий.Период КАК ДатаОперации
		|ИЗ
		|	РегистрНакопления.ЛистыЖеланий КАК ЛистыЖеланий
		|ГДЕ
		|	ЛистыЖеланий.ЛистЖеланий = &ЛистЖеланий";
	
	ЗапросЛОГ.УстановитьПараметр("ЛистЖеланий", ЛистЖеланий);
	
	РезультатЗапроса = ЗапросЛОГ.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ИсторияЛЖ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
	КонецЦикла;
	
	ИсторияЛЖ.Сортировать("ДатаОперации");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАнкету(Команда)
	Элементы.Анкета.Видимость = Истина;
	Элементы.Товар.Видимость = Ложь;
	Элементы.Группа1.ТекущаяСтраница = Элементы.Анкета;
	Элементы.ПрименитьРедактирование.Видимость = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомандаВниз(Команда)
	
	ПередвинутьПозицию(1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВверх(Команда)
	
	ПередвинутьПозицию(-1)
	
КонецПроцедуры

&НаКлиенте
Процедура ПередвинутьПозицию(Движение)
	Если Товары.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено  Тогда
		ИндексСтроки = 0;
	Иначе
		ИндексСтроки = Товары.Индекс(ТекущиеДанные);
	КонецЕсли;
	
	ИндексСтроки = ИндексСтроки + Движение;
	
	Если ИндексСтроки > (Товары.Количество() - 1) Тогда
		ИндексСтроки = 0;
	ИначеЕсли ИндексСтроки < 0 Тогда
		ИндексСтроки = Товары.Количество() - 1;
	КонецЕсли;
	
	ТекущиеДанные = Товары[ИндексСтроки];
	Элементы.Товары.ТекущаяСтрока = ТекущиеДанные.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если Не ЗакрытиеЛЖ Тогда
		
		Если ОтменаВсехДействий Тогда
			ТекстИнформации = "Вы собираетесь закрыть форму листа желаний без сохранения информации!";
			Информация = "Все данные будут удалены! Вы уверены что хотите закрыть форму?";
			ОтветПользователя = ОбщегоНазначенияРТКлиент.ВывестиВопросДляРМК(ТекстИнформации, Информация, "НЕТ"); 
			Если ОтветПользователя = "Нет" Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли; 
		КонецЕсли; 
		
		ПараметрыИнформации = ОбщегоНазначенияРТКлиентСервер.ПолучитьСтруктуруВыводимойВРМКИнформации();
		
		Если Не ОтменаВсехДействий Тогда
			Если Операция = "Создание" Тогда
				Анкета = СоздатьАнкету();
				Результат = СоздатьДокументЛистЖеланий(Анкета);
				Если Не Результат Тогда
					ПараметрыИнформации.ЗаголовокИнформации = "Создание " + ЛистЖеланий;
					ПараметрыИнформации.ТекстИнформации = ОписаниеОшибки();
					ОбщегоНазначенияРТКлиент.ОткрытьФормуИнформацииДляРМК(ПараметрыИнформации,,ЭтотОбъект);
				Иначе
					ПараметрыИнформации.ЗаголовокИнформации = "Создание " + ЛистЖеланий;
					ПараметрыИнформации.ТекстИнформации = "Создан " + ЛистЖеланий + Символы.ПС
					+ "Для именинника: " + ИмяИмениника + Символы.ПС
					+ "Корзина № " + Корзина + Символы.ПС
					+ "Срок действия листа желаний " + ДатаПразднования;
					ОбщегоНазначенияРТКлиент.ОткрытьФормуИнформацииДляРМК(ПараметрыИнформации,,ЭтотОбъект);
				КонецЕсли; 
			Иначе
				Результат = СоздатьДокументКорректировкиЛистаЖеланий();
				Если Результат = Неопределено Тогда
				ИначеЕсли Не Результат Тогда
					ПараметрыИнформации.ЗаголовокИнформации = "Корректировка " + ЛистЖеланий;
					ПараметрыИнформации.ТекстИнформации = ОписаниеОшибки();
					ОбщегоНазначенияРТКлиент.ОткрытьФормуИнформацииДляРМК(ПараметрыИнформации,,ЭтотОбъект);
				Иначе
					ПараметрыИнформации.ЗаголовокИнформации = "Корректировка " + ЛистЖеланий;
					СтрокаИнформации = "С листом желаний производились следующие операции:" + Символы.ПС;
					Для каждого Строка Из Товары Цикл
						Если Строка.Операция = ПредопределенноеЗначение("Перечисление.ОперацияЛистаЖеланий.Добавление")  Тогда
							СтрокаИнформации = СтрокаИнформации + "Добавлена номенклатура " + Строка.Номенклатура + Символы.ПС; 
						ИначеЕсли Строка.Операция = ПредопределенноеЗначение("Перечисление.ОперацияЛистаЖеланий.Отказ")  Тогда
							СтрокаИнформации = СтрокаИнформации + "Удалена номенклатура " + Строка.Номенклатура + Символы.ПС; 
						ИначеЕсли Строка.Операция = ПредопределенноеЗначение("Перечисление.ОперацияЛистаЖеланий.Продажа")  Тогда
							СтрокаИнформации = СтрокаИнформации + "Продана номенклатура " + Строка.Номенклатура + Символы.ПС; 
						КонецЕсли; 
					КонецЦикла;
					ПараметрыИнформации.ТекстИнформации = СтрокаИнформации;
					ОбщегоНазначенияРТКлиент.ОткрытьФормуИнформацииДляРМК(ПараметрыИнформации,,ЭтотОбъект);
				КонецЕсли; 
				Результат = СоздатьДокументЗакрытияЛистаЖеланий(Истина);
				Если ТипЗнч(Результат) = Тип("Строка") Тогда
					ПараметрыИнформации.ЗаголовокИнформации = "Закрытие " + ЛистЖеланий;
					ПараметрыИнформации.ТекстИнформации = Результат;
					ОбщегоНазначенияРТКлиент.ОткрытьФормуИнформацииДляРМК(ПараметрыИнформации,,ЭтотОбъект);
				Иначе
					Если Не Результат Тогда
						ПараметрыИнформации.ЗаголовокИнформации = "Закрытие " + ЛистЖеланий;
						ПараметрыИнформации.ТекстИнформации = ОписаниеОшибки();
						ОбщегоНазначенияРТКлиент.ОткрытьФормуИнформацииДляРМК(ПараметрыИнформации);
					Иначе
						ПараметрыИнформации.ЗаголовокИнформации = Строка(ЛистЖеланий) + " закрыт!";
						ПараметрыИнформации.ТекстИнформации = "";
						ОбщегоНазначенияРТКлиент.ОткрытьФормуИнформацииДляРМК(ПараметрыИнформации,,ЭтотОбъект);
					КонецЕсли; 
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если Не ЗакрытиеЛЖ Тогда
		Если Не ОтменаВсехДействий Тогда
			МассивЛЖ = Новый Массив;
			Для каждого СтрокаТоваров Из Товары Цикл
				Если СтрокаТоваров.Операция = ПредопределенноеЗначение("Перечисление.ОперацияЛистаЖеланий.Продажа") Тогда
					СтруктураСтрокТч = Новый Структура("Номенклатура, Характеристика, Количество, Продавец, ЛистЖеланий",СтрокаТоваров.Номенклатура, СтрокаТоваров.Характеристика, СтрокаТоваров.Количество, Продавец, ЛистЖеланий); 
					МассивЛЖ.Добавить(СтруктураСтрокТч);
				КонецЕсли; 
			КонецЦикла; 
			Если МассивЛЖ.Количество() > 0 Тогда
				Оповестить("ПродажаИзВишЛиста", МассивЛЖ, "ЛистЖеланий");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ТекстИнформации = "Вы собираетесь закрыть форму листа желаний без сохранения информации!";
	Информация = "Все данные будут удалены! Вы уверены что хотите закрыть форму?";
	ОтветПользователя = ОбщегоНазначенияРТКлиент.ВывестиВопросДляРМК(ТекстИнформации, Информация, "НЕТ"); 
	Если ОтветПользователя = "Нет" Тогда
		Возврат;
	КонецЕсли; 
	
	Если Товары.Количество() > 0 Тогда
		Товары.Очистить();
	КонецЕсли;
	ОтменаВсехДействий = Истина;
	Закрыть();
КонецПроцедуры

&НаСервере
Функция СоздатьДокументЛистЖеланий(Анкета)
	ДокументЛистЖеланий = Документы.ЛистЖеланий.СоздатьДокумент();
	ДокументЛистЖеланий.Анкета = Анкета;
	ДокументЛистЖеланий.Дата = ТекущаяДата();
	ДокументЛистЖеланий.Магазин = ПараметрыСеанса.ТекущийМагазин;
	ДокументЛистЖеланий.Корзина = Корзина;
	ДокументЛистЖеланий.СрокДействия = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Анкета, "ДатаПразднования");
	Для каждого Строка Из Товары Цикл
		Если Строка.Операция = Перечисления.ОперацияЛистаЖеланий.Добавление Тогда
			НоваяСтрока = ДокументЛистЖеланий.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		КонецЕсли; 
	КонецЦикла;
	Попытка
		ДокументЛистЖеланий.Записать(РежимЗаписиДокумента.Проведение);
		ЛистЖеланий = ДокументЛистЖеланий.Ссылка;
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки; 
КонецФункции // СоздатьДокументЛистЖеланий()

&НаСервере
Функция СоздатьДокументКорректировкиЛистаЖеланий()
	ДокументКорректировкиЛистаЖеланий = Документы.КорректировкаЛистаЖеланий.СоздатьДокумент();
	ДокументКорректировкиЛистаЖеланий.Анкета = Анкета;
	ДокументКорректировкиЛистаЖеланий.Дата = ТекущаяДата();
	ДокументКорректировкиЛистаЖеланий.Магазин = ПараметрыСеанса.ТекущийМагазин;
	ДокументКорректировкиЛистаЖеланий.Корзина = Корзина;
	ДокументКорректировкиЛистаЖеланий.РедактируемыйДокумент = ЛистЖеланий;
	Для каждого Элемент Из Товары Цикл
		Если Элемент.Операция = Перечисления.ОперацияЛистаЖеланий.Продажа или Не ЗначениеЗаполнено(Элемент.Операция) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ДокументКорректировкиЛистаЖеланий.Товары.Добавить();
		НоваяСтрока.Номенклатура = Элемент.Номенклатура;
		НоваяСтрока.Количество = Элемент.Количество;
		НоваяСтрока.Характеристика = Элемент.Характеристика;
		НоваяСтрока.Операция = Элемент.Операция;
	КонецЦикла;
	Если ДокументКорректировкиЛистаЖеланий.Товары.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Попытка
		ДокументКорректировкиЛистаЖеланий.Записать(РежимЗаписиДокумента.Проведение);
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки; 
КонецФункции // СоздатьДокументкорректировкиЛистаЖеланий()

&НаСервере
Функция СоздатьДокументЗакрытияЛистаЖеланий(ПроверкаИтогов)
	Если ПроверкаИтогов Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛистыЖеланийОстатки.Магазин,
		|	ЛистыЖеланийОстатки.ЛистЖеланий,
		|	ЛистыЖеланийОстатки.Корзина,
		|	ЛистыЖеланийОстатки.Номенклатура,
		|	ЛистыЖеланийОстатки.Характеристика,
		|	ЛистыЖеланийОстатки.КоличествоОстаток как Количество
		|ИЗ
		|	РегистрНакопления.ЛистыЖеланий.Остатки(, ЛистЖеланий = &ЛистЖеланий) КАК ЛистыЖеланийОстатки";
		
		Запрос.УстановитьПараметр("ЛистЖеланий", ЛистЖеланий);
		
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЕсли; 
	
	ДокументЗакрытияЛистаЖеланий = Документы.ЗакрытиеЛистаЖеланий.СоздатьДокумент();
	ДокументЗакрытияЛистаЖеланий.Анкета = Анкета;
	ДокументЗакрытияЛистаЖеланий.Дата = ТекущаяДата();
	ДокументЗакрытияЛистаЖеланий.Магазин = ПараметрыСеанса.ТекущийМагазин;
	ДокументЗакрытияЛистаЖеланий.Корзина = Корзина;
	ДокументЗакрытияЛистаЖеланий.ЛистЖеланий = ЛистЖеланий;
	Попытка
		ДокументЗакрытияЛистаЖеланий.Записать(РежимЗаписиДокумента.Проведение);
		Возврат Истина
	Исключение
		ДокументЗакрытияЛистаЖеланий.Записать(РежимЗаписиДокумента.Проведение);
		Возврат ОписаниеОшибки();
	КонецПопытки; 
	
КонецФункции // СоздатьДокументЗакрытияЛистаЖеланий()

&НаСервере
Функция СоздатьАнкету()
	АнкетаОбъект = Справочники.АнкетаЛистаЖеланий.СоздатьЭлемент();
	АнкетаОбъект.Наименование = ФИОРодителя;
	АнкетаОбъект.ИмяИмениника = ИмяИмениника;
	АнкетаОбъект.НомерТелефонаРодителя = НомерТелефонаРодителя;
	АнкетаОбъект.ЭлектроннаяПочтаРодителя = ИмяПочтовогоЯщика + "@" + ДоменПочтовогоЯщика;
	АнкетаОбъект.ДатаРожденияИменинника = ДатаРожденияИменинника;
	АнкетаОбъект.ДатаПразднования = ДатаПразднования;
	АнкетаОбъект.ДатаСозданияАнкеты = ТекущаяДата();
	АнкетаОбъект.Продавец = Продавец;
	АнкетаОбъект.РазрешениеНаИспользованиеДанных = РазрешениеНаИспользованиеДанных;
	АнкетаОбъект.Записать();
	Возврат АнкетаОбъект.Ссылка;
КонецФункции // СоздатьАнкету()()

&НаСервере
Функция НайтиТоварПоКоду(Штрихкод)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Номенклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Код = &Код
	|	И Номенклатура.ПометкаУдаления = ЛОЖЬ
	|	И Номенклатура.ЭтоГруппа = ЛОЖЬ"
	);
	Запрос.УстановитьПараметр("Код", Штрихкод);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Справочники.Номенклатура.ПустаяСсылка();
	КонецЕсли; 
	Выборка = РезультатЗапроса.Выбрать();
	
	Выборка.Следующий();
	
	Возврат Выборка.Номенклатура;
	
КонецФункции	

Функция НайтиТоварПоШК(Штрихкод) 
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаСправочник.Ссылка КАК Номенклатура,
	|	ТаблицаШтрихкоды.Упаковка КАК Упаковка,
	|	ТаблицаШтрихкоды.Характеристика КАК Характеристика,
	|	ТаблицаСправочник.НазначениеТовара КАК НазначениеТовара,
	|	ТаблицаСправочник.ТипНоменклатуры КАК ТипНоменклатуры
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК ТаблицаШтрихкоды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК ТаблицаСправочник
	|		ПО ТаблицаШтрихкоды.Владелец = ТаблицаСправочник.Ссылка
	|ГДЕ
	|	ТаблицаШтрихкоды.Штрихкод = &Штрихкод
	|	И ТаблицаШтрихкоды.Владелец ССЫЛКА Справочник.Номенклатура"
	);
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Справочники.Номенклатура.ПустаяСсылка();
	КонецЕсли; 
	Выборка = РезультатЗапроса.Выбрать();
	
	Выборка.Следующий();
	
	Возврат Выборка.Номенклатура;
	
КонецФункции	

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	ОтменаВсехДействий = Ложь;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	ФИОРодителя = "";
	ИмяИмениника = "";
	НомерТелефонаРодителя  = "";
	ИмяПочтовогоЯщика  = "";
	ДоменПочтовогоЯщика = "";
	ДатаРожденияИменинника = Дата("00010101");
	ДатаПразднования = Дата("00010101");
КонецПроцедуры

&НаСервере
Процедура ПрименитьРедактированиеНаСервере()
	АнкетаОбъект = Анкета.ПолучитьОбъект();
	Если АнкетаОбъект.ДатаПразднования <> ДатаПразднования Тогда
		ОбъектЛЖ = ЛистЖеланий.ПолучитьОбъект();
		ОбъектЛЖ.СрокДействия = ДатаПразднования;
		Попытка
			ОбъектЛЖ.Записать();
		Исключение
		КонецПопытки; 
	КонецЕсли; 
	АнкетаОбъект.Наименование = ФИОРодителя;
	АнкетаОбъект.ИмяИмениника = ИмяИмениника;
	АнкетаОбъект.НомерТелефонаРодителя = НомерТелефонаРодителя;
	АнкетаОбъект.ЭлектроннаяПочтаРодителя = ИмяПочтовогоЯщика + "@" + ДоменПочтовогоЯщика;
	АнкетаОбъект.ДатаРожденияИменинника = ДатаРожденияИменинника;
	АнкетаОбъект.ДатаПразднования = ДатаПразднования;
	АнкетаОбъект.Продавец = Продавец;
	АнкетаОбъект.РазрешениеНаИспользованиеДанных = РазрешениеНаИспользованиеДанных;	
	АнкетаОбъект.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьРедактирование(Команда)
	ПрименитьРедактированиеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если Не ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные.Операция = ПредопределенноеЗначение("Перечисление.ОперацияЛистаЖеланий.Отказ");
	КонецЕсли;
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если Не ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные.Операция = ПредопределенноеЗначение("Перечисление.ОперацияЛистаЖеланий.Продажа");
	КонецЕсли;
	ТекущийЭлемент = Элементы.Товары;
КонецПроцедуры

&НаКлиенте
Процедура ПоискШКПриИзменении(Элемент)
	Если СтрДлина(СокрЛП(ПоискШК))<4 Тогда
		ТекущийЭлемент = Элементы.ПоискШК;
		Возврат;
	КонецЕсли;
	
	// разделяем количество и штрихкод
	СтрокаПоискаФормат = СокрЛП(Формат(ПоискШК, "ЧЦ=128; ЧДЦ=0; ЧГ=0"));
	ПоискШК = "";
	
	КодЗначение = СтрокаПоискаФормат;

	Если ЗначениеЗаполнено(КодЗначение)  Тогда
		ТекущийЭлемент = Элементы.Товары;
		Если СтрДлина(КодЗначение)<8 Тогда
			Номенклатура = НайтиТоварПоКоду(КодЗначение);
		Иначе
			Номенклатура = НайтиТоварПоШК(КодЗначение);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Номенклатура) Тогда
			ПоказатьПредупреждение(, "Номенклатура с кодом/штрихкодом " + КодЗначение + " не найдена!", 10);
			ТекущийЭлемент = Элементы.ПоискШК;
			Возврат;
		КонецЕсли; 
		
		СтрокаТоваров = Товары.Добавить();
		СтрокаТоваров.Номенклатура = Номенклатура;
		СтрокаТоваров.Количество = 1;
		СтрокаТоваров.Операция = ПредопределенноеЗначение("Перечисление.ОперацияЛистаЖеланий.Добавление");
		
		Цена = ПолучитьЦенуНаСервере(Номенклатура, СтрокаТоваров.Характеристика);
		
		Если Цена > 0 Тогда
			СтрокаТоваров.Цена = Цена;
		Иначе
			СтрокаТоваров.Цена = 0;
		КонецЕсли;
		СуммаДокумента = СуммаДокумента + Цена;
		ТекущийЭлемент = Элементы.ПоискШК;
	КонецЕсли; 
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЦенуНаСервере(Номенклатура, Характеристика)
	Возврат ЗапасыСервер.ПолучитьЦенуПродажи(ПараметрыСеанса.ТекущийМагазин, ТекущаяДата(), Номенклатура, Характеристика,
		Справочники.УпаковкиНоменклатуры.ПустаяСсылка(), Истина);
КонецФункции // ()
 


&НаКлиенте
Процедура ШКПродавцаПриИзменении(Элемент)
	Если СтрДлина(СокрЛП(ШКПродавца))<4 Тогда
		Возврат;
	КонецЕсли;
	
	// разделяем количество и штрихкод
	СтрокаПоискаФормат = СокрЛП(Формат(ШКПродавца, "ЧЦ=128; ЧДЦ=0; ЧГ=0"));
	ШКПродавца = "";
	
	КодЗначение = СтрокаПоискаФормат;

	Если ЗначениеЗаполнено(КодЗначение)  Тогда
		Продавец = НайтиПродавца(КодЗначение);
		
		Если Не ЗначениеЗаполнено(Продавец) Тогда
			ПоказатьПредупреждение(, "Продавец с кодом/штрихкодом " + КодЗначение + " не найден!", 10);
			Возврат;
		КонецЕсли; 
		Элементы.Декорация2.Заголовок = Строка(Продавец);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция	НайтиПродавца(Штрихкод)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Штрихкоды.Владелец
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК Штрихкоды
	|ГДЕ
	|	Штрихкоды.Штрихкод = &Штрихкод
	|	И ВЫРАЗИТЬ(Штрихкоды.Владелец КАК Справочник.ИнформационныеКарты) ССЫЛКА Справочник.ИнформационныеКарты";
	Запрос.УстановитьПараметр("Штрихкод",Штрихкод);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.ФизическиеЛица.ПустаяСсылка();
	КонецЕсли; 
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Владелец = Выборка.Владелец;
	
	Возврат ОбщегоНазначения.ПолучитьЗначениеРеквизита(Владелец, "ВладелецКарты");
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьЛистЖеланий(Команда)
	ТекстИнформации = "Вы собираетесь закрыть " + ЛистЖеланий;
	Если ДатаПразднования < ОбщегоНазначенияВызовСервера.ТекущаяДатаСервера() Тогда
		Информация = "Лист желаний был просрочен " + ДатаПразднования + Символы.ПС + 
					"При закрытии будут снята с резерва следующая номенклатура:" + Символы.ПС;
	Иначе
		Информация = "Лист желаний ещё не просрочен, дата празднования " + ДатаПразднования + Символы.ПС + 
					"При закрытии будут снята с резерва следующая номенклатура:" + Символы.ПС;
	КонецЕсли;
	Для каждого Строка Из Товары Цикл
		Информация = Информация + Строка.Номенклатура + Символы.ПС;
	КонецЦикла;
	Информация = Информация + "Вы уверены что хотите закрыть лист желаний?";
	ОтветПользователя = ОбщегоНазначенияРТКлиент.ВывестиВопросДляРМК(ТекстИнформации, Информация, "НЕТ"); 
	Если ОтветПользователя = "Нет" Тогда
		Возврат;
	КонецЕсли; 
	СоздатьДокументЗакрытияЛистаЖеланий(Ложь);
	ЗакрытиеЛЖ = Истина;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Источник = "ПодключаемоеОборудование" Тогда
		Если ИмяСобытия = "ScanData" Тогда
			Если Параметр[1] = Неопределено Тогда
				ТекКод = Параметр[0];
			Иначе
				ТекКод = Параметр[1][1];
			КонецЕсли;
		КонецЕсли;
		Если ТекущийЭлемент.Имя = "ШКПродавца" Тогда
			ШКПродавца = ТекКод;
			ШКПродавцаПриИзменении(ТекущийЭлемент);
		ИначеЕсли ТекущийЭлемент.Имя = "ПоискШК" Тогда
			ПоискШК = ТекКод;
			ПоискШКПриИзменении(ТекущийЭлемент);
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры
