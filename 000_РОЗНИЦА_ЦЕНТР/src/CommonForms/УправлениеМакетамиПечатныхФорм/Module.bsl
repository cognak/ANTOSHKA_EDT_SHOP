&НаСервереБезКонтекста
Процедура ЗаполнитьДеревоПоКоллекцииМетаданных(СписокМакетовДерево,
												КоллекцияМетаданных,
												знач КоллекцияМакетов = Ложь,
												Фильтр = Неопределено)
	
	Если КоллекцияМакетов Тогда
		ДобавитьКоллекциюМакетов(КоллекцияМетаданных,
								СписокМакетовДерево,
								"ОбщийМакет",
								"Общие макеты",
								Фильтр);
	Иначе
		Для Каждого ЭлементОбъектМД Из КоллекцияМетаданных Цикл
			ДобавитьКоллекциюМакетов(ЭлементОбъектМД.Макеты,
									СписокМакетовДерево,
									ЭлементОбъектМД.ПолноеИмя(),
									ЭлементОбъектМД.Синоним,
									Фильтр);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьКоллекциюМакетов(Макеты, СписокМакетовДерево, ПолноеИмя, Представление, Фильтр)
	
	Перем ТипМакета;
	
	Если ЗначениеЗаполнено(Фильтр) И Врег(СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолноеИмя, ".")[1]) <> ВРег(Фильтр) Тогда
		Возврат;
	КонецЕсли;
	
	ПервыйМакетПФ = Истина;
	
	Для Каждого ЭлементМакет Из Макеты Цикл
		Если ЭтоПечатнаяФорма(ЭлементМакет.Имя, ТипМакета) Тогда
			Если ПервыйМакетПФ Тогда
				НоваяСтрокаОМ = СписокМакетовДерево.Строки.Добавить();
				НоваяСтрокаОМ.ЭтоКлассификатор	= Истина;
				НоваяСтрокаОМ.ПолноеИмяОМ		= ПолноеИмя;
				НоваяСтрокаОМ.Представление		= Представление;
				НоваяСтрокаОМ.Картинка			= ПолучитьКодКартинки(ПолноеИмя);
				ПервыйМакетПФ = Ложь;
			КонецЕсли;
			НоваяСтрокаМакет = НоваяСтрокаОМ.Строки.Добавить();
			НоваяСтрокаМакет.ИмяМакета     = ЭлементМакет.Имя;
			НоваяСтрокаМакет.Представление = ЭлементМакет.Синоним;
			НоваяСтрокаМакет.ТипМакета     = ТипМакета;
			НоваяСтрокаМакет.Использование = Ложь;
			НоваяСтрокаМакет.ЕстьПользовательскийМакет = Ложь;
			НоваяСтрокаМакет.ЭтоКлассификатор = Ложь;
			НоваяСтрокаМакет.Картинка = ПолучитьКодКартинки(ТипМакета);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Проверяет каждый объект метаданных - документ на печатные формы подсистем
// (по префиксу ПФ_<тип печатной формы>) далее заполняет список выбора на форме
//
&НаСервере
Процедура ЗаполнитьСписокМетаданных(Фильтр = Неопределено)
	
	СписокМакетовДерево = РеквизитФормыВЗначение("СписокМакетов");
	
	ЗаполнитьДеревоПоКоллекцииМетаданных(СписокМакетовДерево, Метаданные.Документы, Ложь, Фильтр);
	ЗаполнитьДеревоПоКоллекцииМетаданных(СписокМакетовДерево, Метаданные.Обработки);
	ЗаполнитьДеревоПоКоллекцииМетаданных(СписокМакетовДерево, Метаданные.ОбщиеМакеты, Истина);
	
	Если СписокМакетовДерево.Строки.Количество() > 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ Объект, ИмяМакета, Использование
						|ИЗ
						|	РегистрСведений.ПользовательскиеМакетыПечати";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			СтрокаДерева = СписокМакетовДерево.Строки.СтрНайти(Выборка.Объект, "ПолноеИмяОМ");
			Если СтрокаДерева = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СтрокаОписанияМакета = СтрокаДерева.Строки.СтрНайти(Выборка.ИмяМакета, "ИмяМакета");
			Если СтрокаОписанияМакета <> Неопределено Тогда
				СтрокаОписанияМакета.ЕстьПользовательскийМакет = Истина;
				СтрокаОписанияМакета.Использование = Выборка.Использование;
				СтрокаОписанияМакета.Картинка = ПолучитьКодКартинки(СтрокаОписанияМакета.ТипМакета)
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(СписокМакетовДерево, "СписокМакетов");
	
КонецПроцедуры // ЗаполнитьСписокМетаданных()

// Проверяет по переданному наименованию макета (из метаданных), что это печатная форма
//
&НаСервереБезКонтекста
Функция ЭтоПечатнаяФорма(ИмяМакета, ТипМакета = "")
	
	Позиция = СтрНайти(ИмяМакета, "ПФ_DOC");
	Позиция = ?(Позиция = 0, СтрНайти(ИмяМакета, "ПФ_ODT"), Позиция);
	Позиция = ?(Позиция = 0, СтрНайти(ИмяМакета, "ПФ_MXL"), Позиция);
	
	Если Позиция = 0 Тогда
		Возврат Ложь;
	Иначе
		ТипМакета = Сред(ИмяМакета, Позиция + 3, 3);
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Процедура используется для установления доступности кнопок формы,
// в зависимости от выбранных данных
//
&НаКлиенте
Процедура ОбновитьЭлементыУправления()
	
	ВыделенныеСтроки = Элементы.СписокМакетов.ВыделенныеСтроки;
	
	ВсеНеРедактируемые			= Истина;
	ВсеРедактируемые			= Истина;
	ВсеСНеИспользуемымИНеРедактируемымПМ = Истина;
	ЕстьСНеИспользуемымПМ		= Ложь;
	ЕстьСИспользуемымПМ			= Ложь;
	ЕстьВыделенныеЭлементы		= Ложь;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		ЭлементДерева = Элементы.СписокМакетов.ДанныеСтроки(Строка);
		
		Если ЭлементДерева.ЭтоКлассификатор Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьВыделенныеЭлементы = Истина;
		
		Если ЭлементДерева.Редактируется Тогда
			ВсеНеРедактируемые = Ложь;
		Иначе
			ВсеРедактируемые = Ложь;
		КонецЕсли;
		
		Если ЭлементДерева.ЕстьПользовательскийМакет Тогда
			Если ЭлементДерева.Использование Тогда
				ЕстьСИспользуемымПМ = Истина;
				ВсеСНеИспользуемымИНеРедактируемымПМ = Ложь;
			Иначе
				ЕстьСНеИспользуемымПМ = Истина;
				Если ЭлементДерева.Редактируется Тогда
					ВсеСНеИспользуемымИНеРедактируемымПМ = Ложь;
				КонецЕсли;
			КонецЕсли;
		Иначе
			ВсеСНеИспользуемымИНеРедактируемымПМ = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьВыделенныеЭлементы Тогда
		// запрещающая политика - закрываем доступность команды если хотя бы один выделенный объект не подходит
		// все не редактируемые
		ОткрытьДляПросмотра	= ВсеНеРедактируемые;
		Редактировать		= ВсеНеРедактируемые;
		// все редактируемые
		ЗавершитьРедактирование = ВсеРедактируемые;
		ОтменитьРедактирование = ВсеРедактируемые;
		// у всех есть пользовательский макет, который не редактируется и не используется
		УдалитьИЗИБ = ВсеСНеИспользуемымИНеРедактируемымПМ;
		// разрешающая политика - открываем доступность команды если хотя бы один выделенный объект подходит
		// хотя бы один у которого есть пользовательский макет и он не используется
		ИспользоватьПользовательскийМакет = ЕстьСНеИспользуемымПМ;
		// хотя бы один у которого есть пользовательский макет и используется
		ИспользоватьПоставляемыйМакет = ЕстьСИспользуемымПМ;
	Иначе
		ОткрытьДляПросмотра					= Ложь;
		Редактировать						= Ложь;
		ЗавершитьРедактирование				= Ложь;
		ОтменитьРедактирование				= Ложь;
		УдалитьИЗИБ							= Ложь;
		ИспользоватьПользовательскийМакет	= Ложь;
		ИспользоватьПоставляемыйМакет		= Ложь;
	КонецЕсли;
	
	Элементы.СписокМакетовОткрытьДляПросмотра.Доступность				= ОткрытьДляПросмотра;
	Элементы.СписокМакетовРедактировать.Доступность						= Редактировать;
	Элементы.СписокМакетовЗавершитьРедактирование.Доступность			= ЗавершитьРедактирование;
	Элементы.СписокМакетовОтменитьРедактирование.Доступность			= ОтменитьРедактирование;
	Элементы.СписокМакетовУдалитьИЗИБ.Доступность						= УдалитьИЗИБ;
	Элементы.СписокМакетовИспользоватьПользовательскийМакет.Доступность	= ИспользоватьПользовательскийМакет;
	Элементы.СписокМакетовИспользоватьПоставляемыйМакет.Доступность		= ИспользоватьПоставляемыйМакет;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
//                 ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ УПРАВЛЕНИЯ МАКЕТАМИ                //
////////////////////////////////////////////////////////////////////////////////

&НаСервереБезКонтекста
Функция ПолучитьДвоичныеДанныеМакетов(ПутиКМакетам)
	
	СоотвДвоичныеДанные = Новый Соответствие;
	
	Для Каждого ПутьКМакету Из ПутиКМакетам Цикл
		Данные = УправлениеПечатью.ПолучитьМакет(ПутьКМакету.Значение + "." + ПутьКМакету.Ключ);
		Если ТипЗнч(Данные) = Тип("ТабличныйДокумент") Тогда
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
			Данные.Записать(ИмяВременногоФайла);
			Данные = Новый ДвоичныеДанные(ИмяВременногоФайла);
			УдалитьФайлы(ИмяВременногоФайла);
		КонецЕсли;
		СоотвДвоичныеДанные.Вставить(
					ПутьКМакету.Ключ,
					Данные);
	КонецЦикла;
	
	Возврат СоотвДвоичныеДанные;
	
КонецФункции


&НаКлиенте
Функция СохранитьМакетПечатнойФормыНаДиск(ДвоичныеДанныеМакета, ТипМакета)
#Если Не ВебКлиент Тогда
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(ТипМакета);
	ДвоичныеДанныеМакета.Записать(ИмяВременногоФайла);
	
	Возврат ИмяВременногоФайла;
#КонецЕсли
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьИспользованиеМакета(УстанавливаемыеМакеты, Использование)
	
	Для Каждого Макет Из УстанавливаемыеМакеты Цикл
		Запись = РегистрыСведений.ПользовательскиеМакетыПечати.СоздатьМенеджерЗаписи();
		Запись.Объект				= Макет.ИмяОМ;
		Запись.ИмяМакета	= Макет.ИмяМакета;
		Запись.Прочитать();
		Если НЕ ПустаяСтрока(Запись.Объект) Тогда
			Запись.Использование		= Использование;
			Запись.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМакетПечатнойФормы(знач НаименованиеОМ, знач ИмяМакета)
	
	Возврат УправлениеПечатью.ПолучитьМакет(НаименованиеОМ+"."+ИмяМакета);
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьМакетыВИнформационнойБазе(знач СохраняемыеМакеты, знач ПомещенныеФайлы = Неопределено)
	
	Для Каждого СохраняемыйМакет Из СохраняемыеМакеты Цикл
		
		Запись = РегистрыСведений.ПользовательскиеМакетыПечати.СоздатьМенеджерЗаписи();
		
		Запись.Объект				= СохраняемыйМакет.ИмяОМ;
		Запись.ИмяМакета			= СохраняемыйМакет.ИмяМакета;
		Запись.Использование		= Истина;
		
		Если ПомещенныеФайлы <> Неопределено Тогда
			Значение = ПолучитьДвоичныеДанныеПолученногоФайлаПоИмениМакета(СохраняемыйМакет.ИмяМакета, ПомещенныеФайлы);
			Запись.Макет = Новый ХранилищеЗначения(Значение, Новый СжатиеДанных(9));
		Иначе
			Запись.Макет = Новый ХранилищеЗначения(СохраняемыйМакет.ДанныеМакета, Новый СжатиеДанных(9));
		КонецЕсли;
		
		Запись.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДвоичныеДанныеПолученногоФайлаПоИмениМакета(ИмяМакета, ПомещенныеФайлы)
	
	Для Каждого ОписаниеПередаваемогоФайла ИЗ ПомещенныеФайлы Цикл
		ИмяФайла = ОписаниеПередаваемогоФайла.Имя;
		ИмяФайла = Лев(ИмяФайла, СтрДлина(ИмяФайла) - 4);
		Пока Найти(ИмяФайла, "\") <> 0 Цикл
			Позиция = Найти(ИмяФайла, "\");
			ИмяФайла = Прав(ИмяФайла, СтрДлина(ИмяФайла) - Позиция);
		КонецЦикла;
		Если ВРег(ИмяФайла) = ВРег(ИмяМакета) Тогда
			Возврат ПолучитьИзВременногоХранилища(ОписаниеПередаваемогоФайла.Хранение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

// Удаляет пользовательский макет из информационной базы
//
&НаСервереБезКонтекста
Процедура УдалитьМакетИзИнформационнойБазы(УдаляемыеМакеты)
	
	Для Каждого УдаляемыйМакет Из УдаляемыеМакеты Цикл
		МенеджерЗаписи = РегистрыСведений.ПользовательскиеМакетыПечати.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Объект = УдаляемыйМакет.ПолноеИмяОМ;
		МенеджерЗаписи.ИмяМакета = УдаляемыйМакет.ИмяМакета;
		МенеджерЗаписи.Удалить();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМакетыПечатнойФормы(знач Редактировать = Ложь)
	
	ВыделенныеСтроки = Элементы.СписокМакетов.ВыделенныеСтроки;
	
#Если ВебКлиент Тогда
	ПутиКМакетам = Новый Соответствие;
	ТипыМакетов = Новый Соответствие;
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		ЭлементДерева = Элементы.СписокМакетов.ДанныеСтроки(Строка);
		Если ЭлементДерева.ЭтоКлассификатор Тогда
			Продолжить;
		КонецЕсли;
		ПутиКМакетам.Вставить(ЭлементДерева.ИмяМакета, ЭлементДерева.ПолучитьРодителя().ПолноеИмяОМ);
		ТипыМакетов.Вставить(ЭлементДерева.ИмяМакета, ЭлементДерева.ТипМакета);
	КонецЦикла;
	НаборДвоичныхДанных = ПолучитьДвоичныеДанныеМакетов(ПутиКМакетам);
	
	ПриведенныйНаборДвоичныхДанных = Новый Соответствие;
	
	Для Каждого ТипМакета Из ТипыМакетов Цикл
		ПриведенныйНаборДвоичныхДанных.Вставить(ТипМакета.Ключ+"."+ТипМакета.Значение, НаборДвоичныхДанных[ТипМакета.Ключ]);
	КонецЦикла;
	
	Результат = УправлениеПечатьюКлиент.ПолучитьФайлыВКаталогФайловПечати(ПутьККаталогуФайловПечати, ПриведенныйНаборДвоичныхДанных);
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПутьККаталогуФайловПечати = Результат;
	
	ТекстПредупреждения = "";
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		ЭлементДерева = Элементы.СписокМакетов.ДанныеСтроки(Строка);
		Если ЭлементДерева.ЭтоКлассификатор Тогда
			Продолжить;
		КонецЕсли;
		
		ПутьКФайлуМакета = ПутьККаталогуФайловПечати + ЭлементДерева.ИмяМакета + "." + ЭлементДерева.ТипМакета;
		
		Если ЭлементДерева.ТипМакета = "MXL" И Редактировать Тогда
			ТекстПредупреждения = ?(ПустаяСтрока(ТекстПредупреждения),
									НСтр("ru = 'Файлы макетов табличных документов сохранены на диск.'"),
									ТекстПредупреждения);
									
			ТекстПредупреждения = ТекстПредупреждения
					+ Символы.ПС
					+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Макет ""%1"" сохранен на диск под именем
									|""%2"".'"),
						ЭлементДерева.ИмяМакета,
						ПутьКФайлуМакета);
		Иначе
			ОткрытьФайл(ПутьКФайлуМакета);
		КонецЕсли;
		
		Если Редактировать Тогда
			ЭлементДерева.Редактируется = Истина;
			ЭлементДерева.ПутьКФайлуМакета = ПутьКФайлуМакета;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПустаяСтрока(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
#Иначе
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		ЭлементДерева = Элементы.СписокМакетов.ДанныеСтроки(Строка);
		
		Если ЭлементДерева.ЭтоКлассификатор Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭлементДерева.ТипМакета = "MXL" Тогда
			ТабличныйДокумент = ПолучитьМакетПечатнойФормы(
									ЭлементДерева.ПолучитьРодителя().ПолноеИмяОМ,
									ЭлементДерева.ИмяМакета);
			
			Если Редактировать Тогда
				ПутьКФайлуМакета = ПолучитьИмяВременногоФайла(ЭлементДерева.ТипМакета);
				ТабличныйДокумент.Показать(ЭлементДерева.Представление, ПутьКФайлуМакета);
				ЭлементДерева.ПутьКФайлуМакета = ПутьКФайлуМакета;
				ЭлементДерева.Редактируется = Истина;
			Иначе
				ТабличныйДокумент.Показать(ЭлементДерева.Представление);
			КонецЕсли;
		Иначе
			ДвоичныеДанныеМакета = ПолучитьМакетПечатнойФормы(
									ЭлементДерева.ПолучитьРодителя().ПолноеИмяОМ,
									ЭлементДерева.ИмяМакета);
			
			ПутьКФайлуМакета = СохранитьМакетПечатнойФормыНаДиск(ДвоичныеДанныеМакета, ЭлементДерева.ТипМакета);
			
			ЗапуститьПриложение(ПутьКФайлуМакета);
			Если Редактировать Тогда
				ЭлементДерева.Редактируется = Истина;
				ЭлементДерева.ПутьКФайлуМакета = ПутьКФайлуМакета;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
#КонецЕсли
	
	ОбновитьЭлементыУправления();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИспользованиеМакетаПоЗначению(Значение)
	
	УстанавливаемыеМакеты = Новый Массив;
	
	ВыделенныеСтроки = Элементы.СписокМакетов.ВыделенныеСтроки;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		
		ЭлементДерева = Элементы.СписокМакетов.ДанныеСтроки(Строка);
		
		Если ЭлементДерева.ЭтоКлассификатор Тогда
			Продолжить;
		КонецЕсли;
		
		Если Значение И НЕ ЭлементДерева.ЕстьПользовательскийМакет Тогда
			Продолжить;
		КонецЕсли;
			
		УстанавливаемыеМакеты.Добавить(Новый Структура("ИмяОМ, ИмяМакета",
														ЭлементДерева.ПолучитьРодителя().ПолноеИмяОМ,
														ЭлементДерева.ИмяМакета));
		ЭлементДерева.Использование = Значение;
		ЭлементДерева.Картинка = ПолучитьКодКартинки(ЭлементДерева.ТипМакета);
	КонецЦикла;
	
	Если УстанавливаемыеМакеты.Количество() > 0 Тогда
		УстановитьИспользованиеМакета(УстанавливаемыеМакеты, Значение);
	КонецЕсли;
	
	ОбновитьЭлементыУправления();
	
КонецПроцедуры

// Получить номер картинки по типу макету и его использованию
//
&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьКодКартинки(ТипМакетаИмяОМ)
	
	Если		ВРег(ТипМакетаИмяОМ) = "DOC" Тогда
		Картинка = 0;
	ИначеЕсли	ВРег(ТипМакетаИмяОМ) = "ODT" Тогда
		Картинка = 1;
	ИначеЕсли	ВРег(ТипМакетаИмяОМ) = "MXL" Тогда
		Картинка = 2;
	Иначе
		ИмяВладельца = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТипМакетаИмяОМ, ".")[0];
		Если		ВРег(ИмяВладельца) = "ДОКУМЕНТ" Тогда
			Картинка = 4;
		ИначеЕсли	ВРег(ИмяВладельца) = "ОБРАБОТКА" Тогда
			Картинка = 3;
		ИначеЕсли	ВРег(ИмяВладельца) = "ОБЩИЕМАКЕТЫ" Тогда
			Картинка = 5;
		Иначе
			Картинка = 4;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Картинка;
	
КонецФункции // ПолучитьКодКартинки()

////////////////////////////////////////////////////////////////////////////////
//                 ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ УПРАВЛЕНИЯ МАКЕТАМИ                //
////////////////////////////////////////////////////////////////////////////////

#Если ВебКлиент Тогда
&НаКлиенте
Процедура ОткрытьФайл(ИмяОткрываемогоФайла)
	
	Попытка
		ЗапуститьПриложение(ИмяОткрываемогоФайла);
	Исключение
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Описание=""%1""'"),
						ИнформацияОбОшибке().Описание));
	КонецПопытки;
	
КонецПроцедуры // ОткрытьФайл()
#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
//                      ОБРАБОТЧИКИ СОБЫТИЯ КОМАНД ФОРМЫ                      //
////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура ОткрытьДляПросмотра(Команда)
	
	ОткрытьМакетыПечатнойФормы(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	ОткрытьМакетыПечатнойФормы(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	СохраняемыеМакеты = Новый Массив;
	
#Если ВебКлиент Тогда
	ПомещаемыеФайлы = Новый Массив;
	ПомещенныеФайлы = Новый Массив;
#КонецЕсли
	
	ВыделенныеСтроки = Элементы.СписокМакетов.ВыделенныеСтроки;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		ЭлементДерева = Элементы.СписокМакетов.ДанныеСтроки(Строка);
		Если ЭлементДерева.ЭтоКлассификатор Тогда
			Продолжить;
		КонецЕсли;
		
		Файл = Новый Файл(ЭлементДерева.ПутьКФайлуМакета);
		
		Если Файл.Существует() Тогда
#Если ВебКлиент Тогда
			ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(Файл.ПолноеИмя, ""));
			СохраняемыеМакеты.Добавить(Новый Структура("ИмяОМ, ИмяМакета",
											ЭлементДерева.ПолучитьРодителя().ПолноеИмяОМ,
											ЭлементДерева.ИмяМакета));
#Иначе
			Попытка
				ДанныеМакета = Новый ДвоичныеДанные(ЭлементДерева.ПутьКФайлуМакета)
			Исключение
				СообщениеОбОшибке = ОбщегоНазначенияКлиентСервер.ПолучитьПредставлениеОписанияОшибки(ИнформацияОбОшибке());
				СообщениеОбОшибке = СообщениеОбОшибке + Символы.ПС + 
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Убедитесь, что приложение работы с файлом %1 закрыто'"),
							ЭлементДерева.Представление);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
				Продолжить;
			КонецПопытки;
			
			СохраняемыеМакеты.Добавить(Новый Структура("ИмяОМ, ИмяМакета, ДанныеМакета",
											ЭлементДерева.ПолучитьРодителя().ПолноеИмяОМ,
											ЭлементДерева.ИмяМакета,
											ДанныеМакета));

			УдалитьФайлы(ЭлементДерева.ПутьКФайлуМакета);
			
			ЭлементДерева.Использование = Истина;
			ЭлементДерева.ЕстьПользовательскийМакет = Истина;
			ЭлементДерева.Картинка = ПолучитьКодКартинки(ЭлементДерева.ТипМакета);
#КонецЕсли
		КонецЕсли;
#Если НЕ ВебКлиент Тогда
		ЭлементДерева.Редактируется = Ложь;
		ЭлементДерева.ПутьКФайлуМакета = "";
#КонецЕсли
	КонецЦикла;
	
#Если ВебКлиент Тогда
	Попытка
		Если НЕ ПоместитьФайлы(ПомещаемыеФайлы, ПомещенныеФайлы, , Ложь) Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Ошибка при помещении файлов в хранилище.'"));
			Возврат;
		КонецЕсли;
	Исключение
		СообщениеОбОшибке = ОбщегоНазначенияКлиентСервер.ПолучитьПредставлениеОписанияОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при помещении файла в хранилище: %1. Убедитесь, что приложение работы с файлом закрыто.'"), СообщениеОбОшибке));
		Возврат;
	КонецПопытки;
#КонецЕсли

#Если ВебКлиент Тогда
	СохранитьМакетыВИнформационнойБазе(СохраняемыеМакеты, ПомещенныеФайлы);
	
	ВыделенныеСтроки = Элементы.СписокМакетов.ВыделенныеСтроки;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		ЭлементДерева = Элементы.СписокМакетов.ДанныеСтроки(Строка);
		Если ЭлементДерева.ЭтоКлассификатор Тогда
			Продолжить;
		КонецЕсли;
		
		Файл = Новый Файл(ЭлементДерева.ПутьКФайлуМакета);
		
		Если Файл.Существует() Тогда
			УдалитьФайлы(ЭлементДерева.ПутьКФайлуМакета);
		КонецЕсли;
		
		ЭлементДерева.Использование = Истина;
		ЭлементДерева.ЕстьПользовательскийМакет = Истина;
		ЭлементДерева.Картинка = ПолучитьКодКартинки(ЭлементДерева.ТипМакета);
		ЭлементДерева.Редактируется = Ложь;
		ЭлементДерева.ПутьКФайлуМакета = "";
	КонецЦикла;
#Иначе
	СохранитьМакетыВИнформационнойБазе(СохраняемыеМакеты);
#КонецЕсли

    КоличествоМакетов = ВыделенныеСтроки.Количество();
	Если КоличествоМакетов = 1 Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Макет изменен'"),, 
			Элементы.СписокМакетов.ДанныеСтроки(ВыделенныеСтроки[0]).Представление);
	ИначеЕсли КоличествоМакетов > 1 Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Макеты изменены'"),,
			НСтр("ru = 'Количество макетов: '") + КоличествоМакетов);
	КонецЕсли;
	
	ОбновитьЭлементыУправления();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРедактирование(Команда)
	
	ВыделенныеСтроки = Элементы.СписокМакетов.ВыделенныеСтроки;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		ЭлементДерева = Элементы.СписокМакетов.ДанныеСтроки(Строка);
		Если ЭлементДерева.ЭтоКлассификатор Тогда
			Продолжить;
		КонецЕсли;
		УдалитьФайлы(ЭлементДерева.ПутьКФайлуМакета);
		ЭлементДерева.Редактируется = Ложь;
		ЭлементДерева.ПутьКФайлуМакета = "";
	КонецЦикла;
	
	ОбновитьЭлементыУправления();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИЗИБ(Команда)
	
	УдаляемыеМакеты = Новый Массив;
	
	ВыделенныеСтроки = Элементы.СписокМакетов.ВыделенныеСтроки;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		ЭлементДерева = Элементы.СписокМакетов.ДанныеСтроки(Строка);
		Если ЭлементДерева.ЭтоКлассификатор Тогда
			Продолжить;
		КонецЕсли;
		
		УдаляемыеМакеты.Добавить(Новый Структура("ПолноеИмяОМ, ИмяМакета",
									ЭлементДерева.ПолучитьРодителя().ПолноеИмяОМ,
									ЭлементДерева.ИмяМакета));
		ЭлементДерева.ЕстьПользовательскийМакет = Ложь;
	КонецЦикла;
	
	Если УдаляемыеМакеты.Количество() > 0 Тогда
		УдалитьМакетИзИнформационнойБазы(УдаляемыеМакеты);
		ОбновитьЭлементыУправления();
	КонецЕсли;
	
    КоличествоМакетов = ВыделенныеСтроки.Количество();
	Если КоличествоМакетов = 1 Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Удален пользовательский макет'"),,
			Элементы.СписокМакетов.ДанныеСтроки(ВыделенныеСтроки[0]).Представление);
	ИначеЕсли КоличествоМакетов > 1 Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Удалены пользовательские макеты'"),,
			НСтр("ru = 'Количество макетов: '" + КоличествоМакетов));
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПользовательскийМакет(Команда)
	
	УстановитьИспользованиеМакетаПоЗначению(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПоставляемыйМакет(Команда)
	
	УстановитьИспользованиеМакетаПоЗначению(Ложь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
//         ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ И ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ФОРМЫ             //
////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		Результат = Вопрос(НСтр("ru = 'Не подключено расширение для работы с файлами в Веб-клиенте. Возможно расширение не установлено. Установить?'"), РежимДиалогаВопрос.ДаНет);
		Если Результат = КодВозвратаДиалога.Да Тогда
			УстановитьРасширениеРаботыСФайлами();
		КонецЕсли;
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем Фильтр;
	Параметры.Свойство("Фильтр", Фильтр);
	Если ЗначениеЗаполнено(Фильтр) Тогда
		Фильтр = Фильтр.Метаданные().Имя;
	КонецЕсли;
	ЗаполнитьСписокМетаданных(Фильтр);
	
	ПутьККаталогуФайловПечати = УправлениеПечатью.ПолучитьЛокальныйКаталогФайловПечати();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокМакетовПриАктивизацииСтроки(Элемент)
	
	ОбновитьЭлементыУправления();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ЕстьРедактируемые = Ложь;
	
	Для Каждого ГруппаМакетов Из СписокМакетов.ПолучитьЭлементы() Цикл
		ЭлементыГруппы = ГруппаМакетов.ПолучитьЭлементы();
		Для Каждого ЭлементОМ Из ЭлементыГруппы Цикл
			Если ЭлементОМ.Редактируется Тогда
				ЕстьРедактируемые = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЕстьРедактируемые Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьРедактируемые Тогда
		Результат = Вопрос(НСтр("ru = 'Внимание, в списке остались макеты отмеченные как редактируемые. Продолжить с закрытием формы?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет,);
		Если Результат = КодВозвратаДиалога.Нет Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
