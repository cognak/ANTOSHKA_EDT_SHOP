
// Функция получения параметров для анализа пересортицы
//
Функция ПолучитьМассивПараметровАнализаПересортицы(ПараметрыАнализаПересортицы) Экспорт
	
	МассивПараметровПоУмолчанию = СкладскиеОперацииКлиентСерверПовтИсп.ПолучитьМассивПараметровАнализаПересортицыПоУмолчанию();
	
	Если НЕ ЗначениеЗаполнено(ПараметрыАнализаПересортицы) Тогда
		Возврат МассивПараметровПоУмолчанию;
	КонецЕсли;
	
	МассивПараметров = Новый Массив;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ПараметрыАнализаПересортицы);
	
	Для НомерСтроки = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
		
		СтрокаПараметра = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
		
		Если НЕ МассивПараметровПоУмолчанию.Найти(СтрокаПараметра) = Неопределено Тогда
			
			МассивПараметров.Добавить(СтрокаПараметра);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивПараметров.Количество() = 0  Тогда
		Возврат МассивПараметровПоУмолчанию;
	КонецЕсли;
	
	Возврат МассивПараметров;
	
КонецФункции

#Если Клиент Тогда

#Область РезультатыИнвентаризацииВТекстовыйФайл

Процедура ЗаписатьРезультатыИнвентаризацииВТекстовыйФайл(ДокументыПараметр, ВидНоменклатуры, ПолноеИмяФайла, КлючИмени = "")	Экспорт

	ДополнительныеПараметры = Новый Структура("СписокДокументов", Новый Массив);

	Если ТипЗнч(ДокументыПараметр) = Тип("Массив") Тогда

			ДополнительныеПараметры.СписокДокументов = ДокументыПараметр;

	Иначе	ДополнительныеПараметры.СписокДокументов.Добавить(ДокументыПараметр);

	КонецЕсли;

	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьВыгрузкуРезультатовВТекстовыйФайл", ЭтотОбъект, ДополнительныеПараметры);
	ДиалогВыбораФайла  = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогВыбораФайла.Заголовок = "Укажите текстовый файл для записи результатов";
	ДиалогВыбораФайла.Фильтр = НСтр("ru = 'Текстовый файл'") + " (*.txt)|*.txt|";
	ДиалогВыбораФайла.ПолноеИмяФайла = ?(ПустаяСтрока(ПолноеИмяФайла)
			, ?(ПустаяСтрока(КлючИмени)
				, СкладскиеОперацииСервер.ПолучитьСтрокуНомеровДокументов(ДополнительныеПараметры.СписокДокументов)
				, КлючИмени
			) + "_" + СокрЛП(ВидНоменклатуры) + ".txt"
			, ПолноеИмяФайла);
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Ложь;

	ДиалогВыбораФайла.Показать(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыгрузкуРезультатовВТекстовыйФайл(СписокФайлов, ДополнительныеПараметры)	Экспорт

	Если СписокФайлов.Количество() = 0 Тогда

		Возврат;

	КонецЕсли;

	ПолноеИмяФайла = СокрЛП(СписокФайлов[0]);

	ЗаписьТекста = Новый ЗаписьТекста(ПолноеИмяФайла, КодировкаТекста.ANSI);
	ЗаписьТекста.Записать(СкладскиеОперацииСервер.ПолучитьТекстРезультатовИнвентаризации(ДополнительныеПараметры.СписокДокументов));
	ЗаписьТекста.Закрыть();

	ПоказатьОповещениеПользователя("Файл записан!",
		, "Результаты записаны в файл «" + ПолноеИмяФайла + "»"
		, БиблиотекаКартинок.Информация32
	);

КонецПроцедуры
	
#КонецОбласти

#КонецЕсли


