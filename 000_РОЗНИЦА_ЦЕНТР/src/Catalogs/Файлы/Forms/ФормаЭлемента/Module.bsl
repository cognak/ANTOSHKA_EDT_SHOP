////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	КолонкиМассив = Новый Массив;
	Для Каждого ОписаниеКолонки Из РеквизитФормыВЗначение("ТаблицаПодписей").Колонки Цикл
		КолонкиМассив.Добавить(ОписаниеКолонки.Имя);
	КонецЦикла;
	ОписаниеКолонокТаблицыПодписей = Новый ФиксированныйМассив(КолонкиМассив);
	
	ДанныеФайлаКорректны = Ложь;
	
	Если Параметры.Свойство("РежимСоздания") Тогда 
		РежимСоздания = Параметры.РежимСоздания;
	КонецЕсли;
	
	Если Параметры.Ключ = Неопределено Или Параметры.Ключ.Пустая() Тогда
		
		НовыйФайл = Истина;
		
		Если Параметры.ЗначениеКопирования.Пустая() Тогда
			Объект.ВладелецФайла = Параметры.ВладелецФайла;
		Иначе
			Объект.ТекущаяВерсия = Справочники.ВерсииФайлов.ПустаяСсылка();
			Параметры.ФайлОснование = Параметры.ЗначениеКопирования;
		КонецЕсли;
		
	КонецЕсли;
	
	ДокОснование = Параметры.ФайлОснование;
	Если Не ДокОснование.Пустая() Тогда
		
		Объект.ПолноеНаименование = ДокОснование.ПолноеНаименование;
		Объект.Наименование = Объект.ПолноеНаименование;
		Объект.ХранитьВерсии = ДокОснование.ХранитьВерсии;
		
	КонецЕсли;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Объект.Ссылка);
		ДанныеФайлаКорректны = Истина;
	КонецЕсли;
	
	ТипВладельца = ТипЗнч(Объект.ВладелецФайла);
	Элементы.Владелец.Заголовок = ТипВладельца;
	
	НовыйФайлЗаписан = Ложь;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Параметры.Свойство("КарточкаОткрытаПослеСозданияФайла") Тогда
		Если Параметры.КарточкаОткрытаПослеСозданияФайла Тогда
			
			Попытка
				ЗаблокироватьДанныеФормыДляРедактирования();
			Исключение
			КонецПопытки;
			
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Объект.ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
		ОбновитьПолныйПуть();
	КонецЕсли;
	
	Если Не Параметры.ФайлОснование.Пустая() Тогда
		ФайлОснованиеПодписан = Параметры.ФайлОснование.ПодписанЭЦП;
	КонецЕсли;
	
	Если РаботаСФайламиСлужебныйВызовСервера.ПолучитьИспользоватьЭлектронныеЦифровыеПодписиИШифрование() = Ложь Тогда
		Элементы.ГруппаДополнительныеДанныеСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	Иначе
		ЗаполнитьСписокПодписей();
		ЗаполнитьСписокШифрования();
	КонецЕсли;
	
	ОбщиеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ОбщиеНастройкиРаботыСФайлами();
	
	РасширениеФайлаВСписке = ФайловыеФункцииСлужебныйКлиентСервер.РасширениеФайлаВСписке(
		ОбщиеНастройки.СписокРасширенийТекстовыхФайлов, Объект.ТекущаяВерсияРасширение);
	
	Если РасширениеФайлаВСписке Тогда
		Если ЗначениеЗаполнено(Объект.ТекущаяВерсия) Тогда
			
			КодировкаЗначение = РаботаСФайламиСлужебныйВызовСервера.ПолучитьКодировкуВерсииФайла(
				Объект.ТекущаяВерсия);
			
			СписокКодировок = РаботаСФайламиСлужебный.ПолучитьСписокКодировок();
			ЭлементСписка = СписокКодировок.НайтиПоЗначению(КодировкаЗначение);
			Если ЭлементСписка = Неопределено Тогда
				Кодировка = КодировкаЗначение;
			Иначе
				Кодировка = ЭлементСписка.Представление;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Кодировка) Тогда
			Кодировка = НСтр("ru = 'По умолчанию'");
		КонецЕсли;
		
	Иначе
		Элементы.Кодировка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьЭлементовФормы();
	
	НаименованиеДоЗаписи = Объект.Наименование;
	
	Если Не Параметры.ФайлОснование.Пустая() И ФайлОснованиеПодписан Тогда
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файл ""%1"" подписан.
			           |Копирование сведений об ЭЦП в новый файл сделает его недоступным для изменения.
			           |
			           |Скопировать сведения об ЭЦП в новый файл?'"),
			Строка(Параметры.ФайлОснование));
		
		Ответ = Вопрос(Текст, РежимДиалогаВопрос.ДаНет);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			КопироватьПодписиЭЦП = Истина;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьДоступностьКомандСпискаЭЦП();
	УстановитьДоступностьКомандСпискаШифрования();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ФайлРедактировался И СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().АвторизованныйПользователь = Объект.Редактирует Тогда 
		
		Ответ = Вопрос(
			НСтр("ru = 'Файл занят вами для редактирования.
			           |
			           |Закрыть карточку?'"),
			РежимДиалогаВопрос.ДаНет,
			,
			КодВозвратаДиалога.Нет);
		
		Если Ответ = КодВозвратаДиалога.Нет Тогда 
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если РежимСоздания = "ИзШаблона" И НЕ Объект.ПодписанЭЦП Тогда
		
		СтрокаВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Открыть файл ""%1"" для редактирования?'"),
			СокрЛП(Объект.ПолноеНаименование) );
		
		Если НовыйФайл И НовыйФайлЗаписан И (Не ФайлРедактировался) Тогда
			
			Ответ = Вопрос(СтрокаВопроса, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Да);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				РаботаСФайламиКлиент.Редактировать(Объект.Ссылка, УникальныйИдентификатор);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ФайлОткрыт" И Источник = Объект.Ссылка Тогда
		НовыйФайл = Ложь;
	КонецЕсли;

	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ФайлРедактировался" И Источник = Объект.Ссылка Тогда
		ФайлРедактировался = Истина;
	КонецЕсли;

	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ОбъектПодписан" И Источник = Объект.Ссылка Тогда
		Прочитать();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "АктивнаяВерсияИзменена" И Источник = Объект.Ссылка Тогда
		Прочитать();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ)
	
	Объект.Наименование = Объект.ПолноеНаименование;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект)
	
	Если НаименованиеДоЗаписи <> ТекущийОбъект.Наименование Тогда
		Если ТекущийОбъект.ТекущаяВерсия.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
			
			РаботаСФайламиСлужебныйВызовСервера.ПереименоватьФайлВерсииНаДиске(
				ТекущийОбъект.ТекущаяВерсия,
				НаименованиеДоЗаписи,
				ТекущийОбъект.Наименование,
				УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	Если НовыйФайл Тогда 
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Объект.Ссылка);
		ДанныеФайлаКорректны = Истина;
	КонецЕсли;
	
	Если Не Параметры.ФайлОснование.Пустая() И Объект.ТекущаяВерсия.Пустая() Тогда
		СоздатьКопиюВерсии(Объект.Ссылка, Параметры.ФайлОснование, КопироватьПодписиЭЦП);
		Модифированность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи()
	Если НовыйФайл Тогда 
		НовыйФайлЗаписан = Истина;
		
		ПараметрыОповещения = Новый Структура("Владелец, Файл, Событие", Объект.ВладелецФайла, Объект.Ссылка, "СозданФайл");
		Оповестить("Запись_Файл", ПараметрыОповещения);
		
	Иначе
		Если НаименованиеДоЗаписи <> Объект.Наименование Тогда
			// в кеше обновить файл
			РаботаСФайламиСлужебныйКлиент.ОбновитьИнформациюВРабочемКаталоге(
				Объект.ТекущаяВерсия, Объект.Наименование);
			
			НаименованиеДоЗаписи = Объект.Наименование;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьДоступностьЭлементовФормы();
	УстановитьДоступностьКомандСпискаЭЦП();
	УстановитьДоступностьКомандСпискаШифрования();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПолноеНаименованиеПриИзменении(Элемент)
	Объект.ПолноеНаименование = СокрЛП(Объект.ПолноеНаименование);
	Попытка
		ФайловыеФункцииСлужебныйКлиент.КорректноеИмяФайла(Объект.ПолноеНаименование, Истина);
	Исключение
		ПоказатьПредупреждение(, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Объект.Наименование = СокрЛП(Объект.ПолноеНаименование);
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	Если ТипЗнч(Объект.ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
		ОбновитьПолныйПуть();
	КонецЕсли;
	
	ТипВладельца = ТипЗнч(Объект.ВладелецФайла);
	Элементы.Владелец.Заголовок = ТипВладельца;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ТаблицаПодписей

&НаКлиенте
Процедура ТаблицаПодписейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ЭлектроннаяЦифроваяПодписьКлиент.ОткрытьПодпись(Элементы.ТаблицаПодписей.ТекущиеДанные);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СертификатыШифрования

&НаКлиенте
Процедура СертификатыШифрованияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьСертификатШифрованияВыполнить();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Занять(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	РаботаСФайламиКлиент.Занять(Объект.Ссылка, УникальныйИдентификатор);
	
	Прочитать();
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Записать();
	КонецЕсли;
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	РаботаСФайламиКлиент.Редактировать(Объект.Ссылка, УникальныйИдентификатор);
	
	Прочитать();
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРедактирование(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	ПолучитьДанныеФайлаЕслиНекорректны();
	
	РаботаСФайламиКлиент.ОсвободитьФайл(
		ДанныеФайла.Ссылка,
		ДанныеФайла.ХранитьВерсии,
		ДанныеФайла.РедактируетТекущийПользователь,
		ДанныеФайла.Редактирует,
		УникальныйИдентификатор);
		
	Прочитать();
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	ПолучитьДанныеФайлаЕслиНекорректны();
	
	РаботаСФайламиКлиент.ЗакончитьРедактирование(
		ДанныеФайла.Ссылка,
		УникальныйИдентификатор,
		ДанныеФайла.ХранитьВерсии,
		ДанныеФайла.РедактируетТекущийПользователь,
		ДанныеФайла.Редактирует);
		
	Прочитать();
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОпубликоватьФайл(Объект.Ссылка, УникальныйИдентификатор);
	
	Прочитать();
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		Объект.Ссылка, Неопределено, УникальныйИдентификатор);
	
	РаботаСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(
		Объект.Ссылка, Неопределено, УникальныйИдентификатор);
	
	РаботаСФайламиКлиент.СохранитьКак(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Объект.Ссылка);
	
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДиске(ДанныеФайла, УникальныйИдентификатор);
	
	Прочитать();
	
КонецПроцедуры

&НаКлиенте
Процедура Подписать(Команда)
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСКриптографией(
			Команды.Найти("Подписать").Заголовок);
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда 
		
		ТекстВопроса =
			НСтр("ru = 'Данные еще не записаны. Выполнение команды
			           |""Подписать"" возможно только после записи данных.
			           |
			           |Данные будут записаны.'");
		Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		Если Результат <> КодВозвратаДиалога.ОК Тогда 
			Возврат;
		КонецЕсли;
		
		Если Не Записать() Тогда
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Создание:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	Иначе
		
		Если Модифицированность Тогда
			Если Не Записать() Тогда 
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Объект.Ссылка);
	
	ДанныеПодписи = Неопределено;
	Если РаботаСФайламиКлиент.СформироватьПодписьФайла(ДанныеФайла, ДанныеПодписи) Тогда
		
		ПодписатьЭЦПСервер(ДанныеПодписи);
		
		ЭлектроннаяЦифроваяПодписьКлиент.ИнформироватьОПодписанииОбъекта(ДанныеФайла.Ссылка);
		
		Оповестить(
			"Запись_Файл",
			Новый Структура("Событие", "ПрисоединенныйФайлПодписан"),
			ДанныеФайла.Владелец);
		
		УстановитьДоступностьЭлементовФормы();
		УстановитьДоступностьКомандСпискаЭЦП();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Зашифровать(Команда)
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСКриптографией(
			Команды.Найти("Зашифровать").Заголовок);
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда 
		
		ТекстВопроса =
			НСтр("ru = 'Данные еще не записаны. Выполнение команды
			           |""Зашифровать"" возможно только после записи данных.
			           |
			           |Данные будут записаны.'");
		Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		Если Результат <> КодВозвратаДиалога.ОК Тогда 
			Возврат;
		КонецЕсли;
		
		Если Не Записать() Тогда
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Создание:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(Объект.Ссылка);
	
	МассивДанныхДляЗанесенияВБазу = Новый Массив;
	МассивОтпечатков = Новый Массив;
	
	ФайлЗашифрован = РаботаСФайламиКлиент.Зашифровать(
		ДанныеФайла,
		УникальныйИдентификатор,
		МассивДанныхДляЗанесенияВБазу,
		МассивОтпечатков);
	
	Если НЕ ФайлЗашифрован Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРабочегоКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	
	ЗашифроватьСервер(МассивДанныхДляЗанесенияВБазу, МассивОтпечатков,
		МассивФайловВРабочемКаталогеДляУдаления,
		ИмяРабочегоКаталога);
		
	РаботаСФайламиКлиент.ИнформироватьОШифровании(
		МассивФайловВРабочемКаталогеДляУдаления, ДанныеФайла.Владелец, Объект.Ссылка);
	
	УстановитьДоступностьЭлементовФормы();
	УстановитьДоступностьКомандСпискаШифрования();
	
КонецПроцедуры

&НаКлиенте
Процедура Расшифровать(Команда)
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(Объект.Ссылка);
	
	МассивДанныхДляЗанесенияВБазу = Новый Массив;
	
	ФайлРасшифрован = РаботаСФайламиКлиент.Расшифровать(
		ДанныеФайла, УникальныйИдентификатор, МассивДанныхДляЗанесенияВБазу);
	
	Если НЕ ФайлРасшифрован Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРабочегоКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	
	РасшифроватьСервер(МассивДанныхДляЗанесенияВБазу, ИмяРабочегоКаталога);
	
	РаботаСФайламиКлиент.ИнформироватьОРасшифровке(
		ДанныеФайла.Владелец, Объект.Ссылка);
	
	УстановитьДоступностьЭлементовФормы();
	
	УстановитьДоступностьКомандСпискаШифрования();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЭЦПИзФайла(Команда)
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Объект.Ссылка);
	
	Если РаботаСФайламиКлиент.ДобавитьЭЦПИзФайла(ДанныеФайла, УникальныйИдентификатор) Тогда
		УстановитьДоступностьЭлементовФормы();
		ЗаполнитьСписокПодписей();
		УстановитьДоступностьКомандСпискаЭЦП();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВместеСЭЦП(Команда)
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(Объект.Ссылка);
	
	РаботаСФайламиКлиент.СохранитьВместеСЭЦП(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодпись(Команда)
	ЭлектроннаяЦифроваяПодписьКлиент.ОткрытьПодпись(Элементы.ТаблицаПодписей.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ВыполнятьПроверкуЭЦПНаСервере = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьПерсональныеНастройкиРаботыСЭЦП().ВыполнятьПроверкуЭЦПНаСервере;
	
	Если ВыполнятьПроверкуЭЦПНаСервере И НЕ Объект.Зашифрован Тогда
		ДанныеВыделенныхСтрок = Новый Массив;
		ИменаКолонок = "";
		Для Каждого ИмяКолонки Из ОписаниеКолонокТаблицыПодписей Цикл
			ИменаКолонок = ИменаКолонок + ИмяКолонки + ",";
		КонецЦикла;
		ИменаКолонок = Лев(ИменаКолонок, СтрДлина(ИменаКолонок)-1);
		
		Для Каждого Элемент Из Элементы.ТаблицаПодписей.ВыделенныеСтроки Цикл
			ДанныеСтроки = Новый Структура(ИменаКолонок);
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, ТаблицаПодписей.НайтиПоИдентификатору(Элемент));
			ДанныеВыделенныхСтрок.Добавить(ДанныеСтроки);
		КонецЦикла;
		
		ПроверитьПодписиНаСервере(ДанныеВыделенныхСтрок);
		
		Индекс = 0;
		Для Каждого Элемент Из Элементы.ТаблицаПодписей.ВыделенныеСтроки Цикл
			Строка = ТаблицаПодписей.НайтиПоИдентификатору(Элемент);
			Строка.Статус = ДанныеВыделенныхСтрок[Индекс].Статус;
			Строка.Неверна = ДанныеВыделенныхСтрок[Индекс].Неверна;
			Индекс = Индекс + 1;
		КонецЦикла;
	Иначе
	
		ПолучитьДанныеФайлаЕслиНекорректны();
		
		МенеджерКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМенеджерКриптографии();
		
		Пароль = "";
		
		Если Не ПолучитьПарольДляРасшифровки(Пароль) Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого Элемент Из Элементы.ТаблицаПодписей.ВыделенныеСтроки Цикл
			ДанныеСтроки = Элементы.ТаблицаПодписей.ДанныеСтроки(Элемент);
			
			Если ДанныеСтроки.Объект <> Неопределено И (НЕ ДанныеСтроки.Объект.Пустая()) Тогда
				ПроверитьОднуПодпись(ДанныеСтроки, МенеджерКриптографии, Пароль);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВсе(Команда)
	
	ВыполнятьПроверкуЭЦПНаСервере = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьПерсональныеНастройкиРаботыСЭЦП().ВыполнятьПроверкуЭЦПНаСервере;
	
	Если ВыполнятьПроверкуЭЦПНаСервере И НЕ Объект.Зашифрован Тогда
		ДанныеСтрок = Новый Массив;
		ИменаКолонок = "";
		Для Каждого ИмяКолонки Из ОписаниеКолонокТаблицыПодписей Цикл
			ИменаКолонок = ИменаКолонок + ИмяКолонки + ",";
		КонецЦикла;
		ИменаКолонок = Лев(ИменаКолонок, СтрДлина(ИменаКолонок)-1);
		
		Для Каждого СтрокаТЗ Из ТаблицаПодписей Цикл
			ДанныеСтроки = Новый Структура(ИменаКолонок);
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаТЗ);
			ДанныеСтрок.Добавить(ДанныеСтроки);
		КонецЦикла;
		
		ПроверитьПодписиНаСервере(ДанныеСтрок);
		
		Индекс = 0;
		Для Каждого СтрокаТЗ Из ТаблицаПодписей Цикл
			СтрокаТЗ.Статус = ДанныеСтрок[Индекс].Статус;
			СтрокаТЗ.Неверна = ДанныеСтрок[Индекс].Неверна;
			Индекс = Индекс + 1;
		КонецЦикла;
	Иначе
		
		МенеджерКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМенеджерКриптографии();
		
		Пароль = "";
		Если Не ПолучитьПарольДляРасшифровки(Пароль) Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого Строка Из ТаблицаПодписей Цикл
			Если Строка.Объект <> Неопределено И (НЕ Строка.Объект.Пустая()) Тогда
				ПроверитьОднуПодпись(Строка, МенеджерКриптографии, Пароль);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если Элементы.ТаблицаПодписей.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.ТаблицаПодписей.ТекущиеДанные.Объект <> Неопределено И (НЕ Элементы.ТаблицаПодписей.ТекущиеДанные.Объект.Пустая()) Тогда
		ЭлектроннаяЦифроваяПодписьКлиент.СохранитьПодпись(Элементы.ТаблицаПодписей.ТекущиеДанные.АдресПодписи);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	
	Ответ = Вопрос(НСтр("ru = 'Удалить выделенные подписи?'"), РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитПодписанИзменен = Ложь;
	УдалитьПодписиИОбновитьСписок(РеквизитПодписанИзменен);
	
	Если РеквизитПодписанИзменен Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		Прочитать();
	КонецЕсли;
	
	Оповестить("Запись_Файл", Новый Структура("Событие", "ПрисоединенныйФайлПодписан"), Объект.ВладелецФайла);
	
	УстановитьДоступностьКомандСпискаЭЦП();
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификатШифрования(Команда)
	ОткрытьСертификатШифрованияВыполнить();
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Процедура ПроверитьПодписиНаСервере(ДанныеВыделенныхСтрок)
	
	ФайловыеФункцииСлужебный.ПроверитьПодписиВСтрокахКоллекции(ДанныеВыделенныхСтрок);
	
КонецПроцедуры

// Копирует последнюю версию из Файла-источника в Файл-приемник.
//
// Параметры:
//  Приемник - ссылка на "Файл" куда   копируется прикрепленный Файл.
//  Источник - ссылка на "Файл" откуда копируется прикрепленный Файл.
//
&НаСервере
Функция СоздатьКопиюВерсии(Приемник, Источник, КопироватьПодписиЭЦП)
	
	Если Не Источник.ТекущаяВерсия.Пустая() Тогда
		
		ХранилищеФайла = Неопределено;
		Если Источник.ТекущаяВерсия.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
			ХранилищеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьХранилищеФайлаИзИнформационнойБазы(Источник.ТекущаяВерсия);
		КонецЕсли;
		
		Версия = РаботаСФайламиСлужебныйВызовСервера.СоздатьВерсию(
			ТекущаяДатаСеанса(),
			ТекущаяУниверсальнаяДата(),
			Приемник,
			Объект.Наименование,
			Источник.ТекущаяВерсия.Размер,
			Источник.ТекущаяВерсия.Расширение,
			ХранилищеФайла,
			Источник.ТекущаяВерсия.ТекстХранилище,
			Ложь,
			Источник.ТекущаяВерсия);

		// Обновим форму Файла (ведь запись может произойти и не при закрытии формы)
		Объект.ТекущаяВерсия = Версия.Ссылка;
		
		// Обновим запись в информационной базе
		РаботаСФайламиСлужебныйВызовСервера.ОбновитьВерсиюВФайле(
			Приемник, Версия, Источник.ТекущаяВерсия.ТекстХранилище, УникальныйИдентификатор);
		
		Прочитать();
		
		Если КопироватьПодписиЭЦП Тогда
			
			ФайлОбъект = Объект.Ссылка.ПолучитьОбъект();
			ФайлОбъект.ПодписанЭЦП = Истина;
			ФайлОбъект.Записать();
			
			ВерсияОбъект = Объект.ТекущаяВерсия.ПолучитьОбъект();
			
			Для Каждого Строка Из Источник.ТекущаяВерсия.ЭлектронныеЦифровыеПодписи Цикл
				НоваяСтрока = ВерсияОбъект.ЭлектронныеЦифровыеПодписи.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			КонецЦикла;
			
			ВерсияОбъект.ПодписанЭЦП = Истина;
			ВерсияОбъект.Записать();
			
			ПрочитатьИЗаполнитьПодписи();
			
		КонецЕсли;	
		
		Если Источник.Зашифрован Тогда
			
			ФайлОбъект = Объект.Ссылка.ПолучитьОбъект();
			ФайлОбъект.Зашифрован = Истина;
			
			Для Каждого Строка Из Источник.СертификатыШифрования Цикл
				НоваяСтрока = ФайлОбъект.СертификатыШифрования.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			КонецЦикла;
			
			ФайлОбъект.Записать();
			
			ВерсияОбъект = Объект.ТекущаяВерсия.ПолучитьОбъект();
			ВерсияОбъект.Зашифрован = Истина;
			ВерсияОбъект.Записать();
			
			ПрочитатьИЗаполнитьШифрование();
			
		КонецЕсли;	
		
	КонецЕсли;
	
КонецФункции // СоздатьКопиюВерсии()

&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы()
	
	ДоступныДействияСФайлом = Не Объект.ТекущаяВерсия.Пустая() И Не Объект.Ссылка.Пустая();
	
	Элементы.ХранитьВерсии.Доступность = ДоступныДействияСФайлом И Не Объект.ПометкаУдаления;
	Элементы.ОтменитьРедактирование.Доступность = Не Объект.Редактирует.Пустая();
	Элементы.ОткрытьКаталогФайла.Доступность = ДоступныДействияСФайлом;
	Элементы.СохранитьКак.Доступность = ДоступныДействияСФайлом;
	
	Элементы.Редактировать.Доступность = НЕ Объект.ПодписанЭЦП;
	Элементы.ЗакончитьРедактирование.Доступность = Не Объект.Редактирует.Пустая();
	Элементы.ПолноеНаименование.ТолькоПросмотр = НЕ Объект.Редактирует.Пустая();
	Элементы.Занять.Доступность = Объект.Редактирует.Пустая() И (ДоступныДействияСФайлом) И НЕ Объект.ПодписанЭЦП;
	Элементы.СохранитьИзменения.Доступность = Не Объект.Редактирует.Пустая();
	
	Элементы.ОбновитьИзФайлаНаДиске.Доступность = ДоступныДействияСФайлом И НЕ Объект.ПодписанЭЦП;
	
	Элементы.ФормаПодписать.Доступность = (ДоступныДействияСФайлом И Объект.Редактирует.Пустая()) ИЛИ НЕ ДоступныДействияСФайлом;
	Элементы.ФормаЗашифровать.Доступность = (ДоступныДействияСФайлом И Объект.Редактирует.Пустая() И НЕ Объект.Зашифрован) ИЛИ НЕ ДоступныДействияСФайлом;
	
	Элементы.ФормаДобавитьЭЦПИзФайла.Доступность = ДоступныДействияСФайлом И Объект.Редактирует.Пустая();
	Элементы.ФормаСохранитьВместеСЭЦП.Доступность = ДоступныДействияСФайлом И Объект.ПодписанЭЦП;
	Элементы.ФормаРасшифровать.Доступность = ДоступныДействияСФайлом И Объект.Зашифрован;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить()
	Записать();
	Прочитать();
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьВыполнить()
	
	РаботаСФайламиКлиент.СкопироватьФайл(Объект.ВладелецФайла, Объект.Ссылка);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокШифрования()
	
	СертификатыШифрования.Очистить();
	
	Если Объект.Зашифрован Тогда
		МассивСертификатовШифрования = РаботаСФайламиСлужебныйВызовСервера.ПолучитьМассивСертификатовШифрования(Объект.Ссылка);
		Для Каждого СтруктураСертификата Из МассивСертификатовШифрования Цикл
			НоваяСтрока = СертификатыШифрования.Добавить();
			НоваяСтрока.Представление = СтруктураСертификата.Представление;
			НоваяСтрока.Отпечаток = СтруктураСертификата.Отпечаток;
			Если СтруктураСертификата.Сертификат <> Неопределено Тогда
				НоваяСтрока.АдресСертификата = ПоместитьВоВременноеХранилище(СтруктураСертификата.Сертификат, УникальныйИдентификатор);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если СертификатыШифрования.Количество() = 0 Тогда
		ТекстЗаголовка = НСтр("ru = 'Зашифрован для'");
	Иначе
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Зашифрован для (%1)'"),
			Формат(СертификатыШифрования.Количество(), "ЧГ="));
	КонецЕсли;
	Элементы.ГруппаШифрование.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПодписей()
	
	ТаблицаПодписей.Очистить();
		
	Если Объект.ПодписанЭЦП Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ЭлектронныеЦифровыеПодписи.КомуВыданСертификат КАК КомуВыданСертификат,
		               |	ЭлектронныеЦифровыеПодписи.ДатаПодписи КАК ДатаПодписи,
		               |	ЭлектронныеЦифровыеПодписи.Комментарий КАК Комментарий,
		               |	ЭлектронныеЦифровыеПодписи.Подпись КАК Подпись,
		               |	ЭлектронныеЦифровыеПодписи.Отпечаток КАК Отпечаток,
		               |	ЭлектронныеЦифровыеПодписи.УстановившийПодпись КАК УстановившийПодпись,
		               |	ЭлектронныеЦифровыеПодписи.НомерСтроки КАК НомерСтроки,
		               |	ЭлектронныеЦифровыеПодписи.Сертификат КАК Сертификат
		               |ИЗ
		               |	Справочник.ВерсииФайлов.ЭлектронныеЦифровыеПодписи КАК ЭлектронныеЦифровыеПодписи
		               |ГДЕ
		               |	ЭлектронныеЦифровыеПодписи.Ссылка = &ОбъектСсылка";
					   
		Запрос.Параметры.Вставить("ОбъектСсылка", Объект.ТекущаяВерсия);
		ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаЗапроса.Следующий() Цикл
			НоваяСтрока = ТаблицаПодписей.Добавить();
			
			НоваяСтрока.КомуВыданСертификат = ВыборкаЗапроса.КомуВыданСертификат;
			НоваяСтрока.ДатаПодписи = ВыборкаЗапроса.ДатаПодписи;
			НоваяСтрока.Комментарий = ВыборкаЗапроса.Комментарий;
			НоваяСтрока.Объект 		= Объект.ТекущаяВерсия;
			НоваяСтрока.Отпечаток 	= ВыборкаЗапроса.Отпечаток;
			НоваяСтрока.НомерСтроки = ВыборкаЗапроса.НомерСтроки;
			НоваяСтрока.УстановившийПодпись = ВыборкаЗапроса.УстановившийПодпись;
			НоваяСтрока.Неверна 	= Ложь;
			НоваяСтрока.ИндексКартинки = -1;
			
			ДвоичныеДанные = ВыборкаЗапроса.Подпись.Получить();
			Если ДвоичныеДанные <> Неопределено Тогда 
				НоваяСтрока.АдресПодписи = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
			КонецЕсли;
			
			ДвоичныеДанныеСертификата = ВыборкаЗапроса.Сертификат.Получить();
			Если ДвоичныеДанныеСертификата <> Неопределено Тогда 
				НоваяСтрока.АдресСертификата = ПоместитьВоВременноеХранилище(ДвоичныеДанныеСертификата, УникальныйИдентификатор);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Если ТаблицаПодписей.Количество() = 0 Тогда
		ТекстЗаголовка = НСтр("ru = 'ЭЦП'");
	Иначе
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'ЭЦП (%1)'"),
			Формат(ТаблицаПодписей.Количество(), "ЧГ="));
	КонецЕсли;
	Элементы.ГруппаЭЦП.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры


&НаСервере
Процедура ОбновитьПолныйПуть()
	
	Если ТипЗнч(Объект.ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
		
		ПапкаРодитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ВладелецФайла");
		
		Если ЗначениеЗаполнено(ПапкаРодитель) Тогда
		
			ПолныйПуть = "";
			
			Пока ЗначениеЗаполнено(ПапкаРодитель) Цикл
				
				Если Не ПустаяСтрока(ПолныйПуть) Тогда
					ПолныйПуть = "\" + ПолныйПуть;
				КонецЕсли;	
				
				ПолныйПуть = Строка(ПапкаРодитель) + ПолныйПуть;
				
				ПапкаРодитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПапкаРодитель, "Родитель");
				Если Не ЗначениеЗаполнено(ПапкаРодитель) Тогда
					Прервать;
				КонецЕсли;	
				
			КонецЦикла;

			Элементы.Владелец.Подсказка = ПолныйПуть;
			
		КонецЕсли;	
			
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ОткрытьФайлВыполнить()
	
	Если Объект.Ссылка.Пустая() Тогда
		Записать();
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		Объект.Ссылка, Неопределено, УникальныйИдентификатор);

	РаботаСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеФайлаЕслиНекорректны()
	
	Если ДанныеФайла = Неопределено ИЛИ НЕ ДанныеФайлаКорректны Тогда
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Объект.Ссылка);
		ДанныеФайлаКорректны = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьИЗаполнитьПодписи()
	
	Прочитать();
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Объект.Ссылка);
	ДанныеФайлаКорректны = Истина;
	ЗаполнитьСписокПодписей();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьИЗаполнитьШифрование()
	
	Прочитать();
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Объект.Ссылка);
	ДанныеФайлаКорректны = Истина;
	ЗаполнитьСписокШифрования();
	
КонецПроцедуры

&НаСервере
Процедура ПодписатьЭЦПСервер(ДанныеПодписи)
	
	РаботаСФайламиСлужебныйВызовСервера.ЗанестиИнформациюОднойПодписи(
		ДанныеПодписи, УникальныйИдентификатор);
	
	ПрочитатьИЗаполнитьПодписи();
	
КонецПроцедуры

&НаСервере
Процедура ЗашифроватьСервер(МассивДанныхДляЗанесенияВБазу,
                            МассивОтпечатков,
                            МассивФайловВРабочемКаталогеДляУдаления,
                            ИмяРабочегоКаталога)
	
	Зашифровать = Истина;
	
	РаботаСФайламиСлужебныйВызовСервера.ЗанестиИнформациюОШифровании(
		Объект.Ссылка,
		Зашифровать,
		МассивДанныхДляЗанесенияВБазу,
		УникальныйИдентификатор,
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		МассивОтпечатков);
		
	Прочитать();
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Объект.Ссылка);
	ЗаполнитьСписокШифрования();
	
КонецПроцедуры

&НаСервере
Процедура РасшифроватьСервер(МассивДанныхДляЗанесенияВБазу,
                             ИмяРабочегоКаталога)
	
	Зашифровать = Ложь;
	МассивОтпечатков = Новый Массив;
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	
	РаботаСФайламиСлужебныйВызовСервера.ЗанестиИнформациюОШифровании(
		Объект.Ссылка,
		Зашифровать,
		МассивДанныхДляЗанесенияВБазу,
		УникальныйИдентификатор,
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		МассивОтпечатков);
		
	Прочитать();
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Объект.Ссылка);
	ЗаполнитьСписокШифрования();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОднуПодпись(ДанныеСтроки, МенеджерКриптографии, Пароль)
	
	АдресПодписи = ДанныеСтроки.АдресПодписи;
	
	СтруктураВозврата = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИДвоичныеДанные(
		Объект.Ссылка, Неопределено, АдресПодписи);
	
	ДвоичныеДанныеФайла = СтруктураВозврата.ДвоичныеДанные;
	ДвоичныеДанныеПодписи = СтруктураВозврата.ДвоичныеДанныеПодписи;
	
	Попытка
		Если Объект.Зашифрован Тогда
			МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = Пароль;
			ДвоичныеДанныеФайла = МенеджерКриптографии.Расшифровать(ДвоичныеДанныеФайла);
		КонецЕсли;	
		
		ЭлектроннаяЦифроваяПодписьКлиент.ПроверитьПодпись(МенеджерКриптографии, ДвоичныеДанныеФайла, ДвоичныеДанныеПодписи);
		
		ДанныеСтроки.Статус = НСтр("ru = 'Верна'");
		ДанныеСтроки.Неверна = Ложь;
	Исключение
		ДанныеСтроки.Статус =
			НСтр("ru = 'Неверна.'") + " " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ДанныеСтроки.Неверна = Истина;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПарольДляРасшифровки(Пароль)
	Пароль = "";
	
	Если Объект.Зашифрован Тогда
		
		ПредставленияСертификатов = "";
		Для Каждого СтруктураСертификата Из ДанныеФайла.МассивСертификатовШифрования Цикл
			
			Отпечаток = СтруктураСертификата.Отпечаток;
			
			ТолькоВЛичномХранилище = Истина;
			Сертификат = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьСертификатПоОтпечатку(Отпечаток, ТолькоВЛичномХранилище);
			Если Сертификат <> Неопределено Тогда // тут собираем только личные сертификаты - с закрытым ключом
				Если НЕ ПустаяСтрока(ПредставленияСертификатов) Тогда
					ПредставленияСертификатов = ПредставленияСертификатов + Символы.ПС;
				КонецЕсли;
				ПредставленияСертификатов = ПредставленияСертификатов + СтруктураСертификата.Представление;
			КонецЕсли;
			
		КонецЦикла;
		
		Пароль = "";
		ЗаголовокФормы = НСтр("ru = 'Введите пароль для расшифровки'");
		ПараметрыФормы = Новый Структура("Заголовок, ПредставленияСертификатов, Файл", 
			ЗаголовокФормы, ПредставленияСертификатов, Объект.Ссылка);
		КодВозврата = ОткрытьФормуМодально("ОбщаяФорма.ВводПароляСОписаниями", ПараметрыФормы);
		Если ТипЗнч(КодВозврата) = Тип("Строка") Тогда
			Пароль = КодВозврата;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

&НаСервере
Процедура УдалитьПодписиИОбновитьСписок(РеквизитПодписанИзменен)
	
	ТаблицаВыделенныеСтроки = Новый ТаблицаЗначений;
	ТаблицаВыделенныеСтроки.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));
	
	Для Каждого Элемент Из Элементы.ТаблицаПодписей.ВыделенныеСтроки Цикл
		ДанныеСтроки = ТаблицаПодписей.НайтиПоИдентификатору(Элемент);
		
		Если ДанныеСтроки.Объект <> Неопределено И (НЕ ДанныеСтроки.Объект.Пустая()) Тогда
			
			НоваяСтрока = ТаблицаВыделенныеСтроки.Добавить();
			НоваяСтрока.НомерСтроки = ДанныеСтроки.НомерСтроки;
			
		КонецЕсли;
	КонецЦикла;
	
	РаботаСФайламиСлужебныйВызовСервера.УдалитьПодписиВерсииФайла(
		Объект.ТекущаяВерсия,
		ТаблицаВыделенныеСтроки,
		РеквизитПодписанИзменен,
		УникальныйИдентификатор);
	
	ЗаполнитьСписокПодписей();
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьДоступностьКомандСпискаЭЦП()
	
	ЕстьПодписи = (ТаблицаПодписей.Количество() <> 0);
	
	Элементы.ТаблицаПодписейПроверить.Доступность = ЕстьПодписи;
	Элементы.ТаблицаПодписейПроверитьВсе.Доступность = ЕстьПодписи;
	Элементы.ТаблицаПодписейОткрытьСертификат.Доступность = ЕстьПодписи;
	Элементы.ТаблицаПодписейУдалить.Доступность = ЕстьПодписи;
	Элементы.ТаблицаПодписейСохранить.Доступность = ЕстьПодписи;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандСпискаШифрования()
	
	Элементы.СертификатыШифрованияОткрытьСертификатШифрования.Доступность = Объект.Зашифрован;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификатШифрованияВыполнить()
	
	ТекущиеДанные = Элементы.СертификатыШифрования.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отпечаток = ТекущиеДанные.Отпечаток;
	
	Сертификат = Неопределено;
	СтруктураСертификата = Неопределено;
	Если НЕ ПустаяСтрока(ТекущиеДанные.АдресСертификата) Тогда
		ДвоичныеДанныеСертификата = ПолучитьИзВременногоХранилища(ТекущиеДанные.АдресСертификата);
		Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
		СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(Сертификат);
	Иначе
		СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиент.ЗаполнитьСтруктуруСертификатаПоОтпечатку(Отпечаток);
	КонецЕсли;	
	
	Если СтруктураСертификата <> Неопределено Тогда
		ЭлектроннаяЦифроваяПодписьКлиент.ОткрытьСертификатСоСтруктурой(СтруктураСертификата, Отпечаток, ТекущиеДанные.АдресСертификата);
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства
