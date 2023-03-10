
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Магазин") Тогда
		
		ОтборМагазин = Параметры.Отбор.Магазин;
		Элементы.ОтборМагазин.Доступность = Ложь;
		
	КонецЕсли;
	
	НачалоНедели = ТекущаяДата() - (ДеньНедели(ТекущаяДата())-1)*86400;
	ПредыдущееНачалоНедели = НачалоНедели;
	ПредыдущийМагазин      = ОтборМагазин;
	ЗаполнитьГрафикРаботПоСотрудникам();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Перем ТекущееНачалоНедели;
	
	Если Не ПараметрыЗаписи.Свойство("НомерГода", ТекущееНачалоНедели) Тогда
		
		ТекущееНачалоНедели = НачалоНедели;
		
	КонецЕсли;
	
	ЗаписатьГрафикРаботыВРегистрСервер(ОтборМагазин, ТекущееНачалоНедели);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОтборМагазинПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ОтборМагазин) 
		И ЗначениеЗаполнено(ПредыдущийМагазин) Тогда
		
		ОтборМагазин = ПредыдущийМагазин;
		Возврат;
		
	КонецЕсли;
	
	ПроверкаУспешна = Истина;
	ЗаписатьГрафикРаботыВРегистрКлиент(ПредыдущийМагазин, НачалоНедели, ПроверкаУспешна, Ложь);
	
	Если ПроверкаУспешна Тогда
		
		ПредыдущийМагазин = ОтборМагазин;
		ЗаполнитьГрафикРаботПоСотрудникам();
		
	Иначе
		
		ОтборМагазин = ПредыдущийМагазин;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоНеделиПриИзменении(Элемент)
	
	ПриИзмененииНедели();

КонецПроцедуры

&НаКлиенте
Процедура ОтборМагазинОчистка(Элемент, СтандартнаяОбработка)
	
	ПроверитьЗаполнение();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЧНОЙ ЧАСТИ "ТаблицаРегистра"

&НаКлиенте
Процедура ТаблицаРегистраПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегистраПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ИмяКолонки        = Элемент.ТекущийЭлемент.Имя;
	ТекущаяСтрока     = Элемент.ТекущиеДанные;
	ТекущийПоказатель = ТекущаяСтрока[ИмяКолонки];
	
	Если НЕ ЗначениеЗаполнено(ТекущийПоказатель) Тогда
		
		ИндексИнтервала = Прав(ИмяКолонки, СтрДлина(ИмяКолонки)- Найти(ИмяКолонки,"Добавлен") - 7);
		ТекущаяСтрока[ИмяКолонки] = ДлинаРабочегоДня(Число(ИндексИнтервала));
		
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегистраПередНачаломИзменения(Элемент, Отказ)
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	
	Если ТекущаяСтрока.РаботаСотрудник = Неопределено 
		ИЛИ ТипЗнч(ТекущаяСтрока.РаботаСотрудник) <> Тип("СправочникСсылка.ФизическиеЛица") Тогда
		
		ИмяКолонки                = Элемент.ТекущийЭлемент.Имя;
		ТекущаяСтрока[ИмяКолонки] = Дата('00010101');
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаполнитьАктуальныйГрафикРаботы(Команда)
	
	ЗаполнитьАктуальныйГрафикРаботыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаборЗаписейГрафикаРабот(Команда)
	
	ПроверкаУспешна = Истина;
	ЗаписатьГрафикРаботыВРегистрКлиент(ОтборМагазин, НачалоНедели, ПроверкаУспешна, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГрафикРаботыСледующейНедели(Команда)
	
	НачалоНедели = НачалоНедели + 86400*7;
	ПриИзмененииНедели();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГрафикРаботыПрошлойНедели(Команда)
	
	НачалоНедели = НачалоНедели - 86400*7;
	ПриИзмененииНедели();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДлинуРабочегоДняПоГрафикуРаботы(Команда)
	РассчитатьДлинуРабочегоДня();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДлинуРабочегоДняПоГрафикуРаботыНаВсюНеделю(Команда)
	Для каждого РодительскийЭлемент Из ТаблицаРегистра.ПолучитьЭлементы() Цикл
		Для каждого СтрокаСотрудника Из РодительскийЭлемент.ПолучитьЭлементы() Цикл
			РассчитатьДлинуРабочегоДняНаНеделю(СтрокаСотрудника);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДлинуРабочегоДняПоГрафикуРаботыНаВюНеделюДляРаботника(Команда)
	РассчитатьДлинуРабочегоДня(Истина);
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьАктуальныйГрафикРаботыНаСервере()
	
	Если ПроверитьЗаполнение() Тогда
		
		ЗаполнитьГрафикРаботПоСотрудникам();
		Модифицированность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

//Возвращает плановое время рабочего дня по индексу интервала.
//Параметры - ИндексИнтервала - Число
//Возвращаемое значение - Дата
//
&НаСервере
Функция ДлинаРабочегоДня(ИндексИнтервала)
	
	Интервал = Интервалы[ИндексИнтервала];
	РазностьВСекундах = Интервал.Значение.ОкончаниеИнтервала - Интервал.Значение.НачалоИнтервала;
	
	Если РазностьВСекундах > 0 Тогда
		
		ДлинаРабочегоВремени = ОбщегоНазначенияРТКлиентСервер.ПреобразоватьСекундыВДату(РазностьВСекундах);
		
	Иначе
		
		ДлинаРабочегоВремени = Дата("00010101000000");
		
	КонецЕсли;
	
	Возврат ДлинаРабочегоВремени;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииНедели()
	
	Если НачалоНедели < Дата(2000,1,1) Тогда
		
		НачалоНедели = ПредыдущееНачалоНедели;
		Возврат;
		
	КонецЕсли;
	
	НачалоНедели = НачалоНедели - (ДеньНедели(НачалоНедели)-1)*86400;
	ПроверкаУспешна = Истина;
	ЗаписатьГрафикРаботыВРегистрКлиент(ОтборМагазин, ПредыдущееНачалоНедели, ПроверкаУспешна, Ложь);
	
	Если ПроверкаУспешна Тогда
		
		ПредыдущееНачалоНедели = НачалоНедели;
		ЗаполнитьГрафикРаботПоСотрудникам();
		
	Иначе
		
		НачалоНедели = ПредыдущееНачалоНедели;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекстНадписиИнтервалыМагазинов()
	
	Если НЕ ЗначениеЗаполнено(ОтборМагазин) Тогда
		
		ТекстЗаголовка = "Выберите магазин";
		
	ИначеЕсли Интервалы.Количество() = 0 Тогда
		
		ТекстЗаголовка = "У магазина не заданы интервалы работы или графики работы";
		
	Иначе
		
		ТекстЗаголовка = "";
		
	КонецЕсли;
	
	Если ТекстЗаголовка <> Элементы.ДекорацияИнтервалыМагазинов.Заголовок Тогда
		
		Элементы.ДекорацияИнтервалыМагазинов.Заголовок = ТекстЗаголовка;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьГрафикРаботыВРегистрСервер(Магазин, ТекущееНачалоНедели)
	
	СтруктураДатИКолонок = Новый Структура;
	День = 0;
	
	Для каждого ЗначениеПеречисления Из Перечисления.ДниНедели Цикл
		
		СтруктураДатИКолонок.Вставить(Строка(ЗначениеПеречисления),НачалоДня(ТекущееНачалоНедели) + День);
		День = День + 86400;
		
	КонецЦикла;
	
	ТаблицаЗаписи = Новый ТаблицаЗначений;
	ТаблицаЗаписи.Колонки.Добавить("ИнтервалРаботыМагазинов", Новый ОписаниеТипов("СправочникСсылка.ИнтервалыРаботыМагазинов"));
	ТаблицаЗаписи.Колонки.Добавить("РаботаВыполняемаяСотрудниками", Новый ОписаниеТипов("СправочникСсылка.РаботаВыполняемаяСотрудниками"));
	ТаблицаЗаписи.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаЗаписи.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	ТаблицаЗаписи.Колонки.Добавить("ДатаОкончания", Новый ОписаниеТипов("Дата"));
	ТаблицаЗаписи.Колонки.Добавить("ДлинаРабочегоВремени", Новый ОписаниеТипов("Дата"));
	ТаблицаЗаписи.Колонки.Добавить("Очистить", Новый ОписаниеТипов("Булево"));
	
	Дерево = РеквизитФормыВЗначение("ТаблицаРегистра");
	
	СтруктураИнтерваловИКолонок = Новый Структура;
	
	Для каждого Колонка Из Дерево.Колонки Цикл
		
		ПозицияСимвола = Найти(Колонка.Имя,"Добавлен");
		
		Если ПозицияСимвола > 0 Тогда
			
			ИндексИнтервала = Число(Прав(Колонка.Имя,СтрДлина(Колонка.Имя) - ПозицияСимвола - 7));
			СтруктураИнтерваловИКолонок.Вставить(Колонка.Имя,Интервалы[ИндексИнтервала].Значение);
			ИмяЗначенияПеречисления = Лев(Колонка.Имя, ПозицияСимвола-1);
			День = СтруктураДатИКолонок[ИмяЗначенияПеречисления];
			СтруктураДатИКолонок.Вставить(Колонка.Имя, День);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого СтрокаРабота Из Дерево.Строки Цикл
		
		Для каждого СтрокаСотрудник Из СтрокаРабота.Строки Цикл
			
			Для каждого Колонка Из Дерево.Колонки Цикл
				
				Если Колонка.Имя <> "РаботаСотрудник" Тогда
					
					СтрокаЗаписи = ТаблицаЗаписи.Добавить();
					СтрокаЗаписи.ИнтервалРаботыМагазинов       = СтруктураИнтерваловИКолонок[Колонка.Имя];
					СтрокаЗаписи.РаботаВыполняемаяСотрудниками = СтрокаРабота.РаботаСотрудник;
					СтрокаЗаписи.Сотрудник                     = СтрокаСотрудник.РаботаСотрудник;
					СтрокаЗаписи.ДлинаРабочегоВремени          = СтрокаСотрудник[Колонка.Имя];
					СтрокаЗаписи.Период                        = ОбщегоНазначенияРТКлиентСервер.СложитьДатуИВремя(СтруктураДатИКолонок[Колонка.Имя],СтруктураИнтерваловИКолонок[Колонка.Имя].НачалоИнтервала);
					СтрокаЗаписи.ДатаОкончания                 = ОбщегоНазначенияРТКлиентСервер.СложитьДатуИВремя(СтруктураДатИКолонок[Колонка.Имя],СтруктураИнтерваловИКолонок[Колонка.Имя].ОкончаниеИнтервала);
					СтрокаЗаписи.Очистить                      = НЕ ЗначениеЗаполнено(СтрокаСотрудник[Колонка.Имя]);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	РегистрыСведений.ПланируемоеРабочееВремяСотрудников.ЗаписатьПланируемоеРабочееВремяСотрудников(ТаблицаЗаписи);
	
	СтруктураДатИКолонок.Очистить();
	СтруктураИнтерваловИКолонок.Очистить();
	ТаблицаЗаписи.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьГрафикРаботыВРегистрКлиент(Магазин, ТекущееНачалоНедели, ПроверкаУспешна, БезВопроса)
	
	ПроверкаУспешна = ПроверитьЗаполнение();
	
	Если ПроверкаУспешна Тогда
		
		Если Модифицированность Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Записать измененные данные за неделю с %1 по %2?'"), Формат(ПредыдущееНачалоНедели, "ДФ=dd.MM.yy"), Формат(ПредыдущееНачалоНедели + 86400*7, "ДФ=dd.MM.yy"));
			
			Если БезВопроса 
				ИЛИ Вопрос(ТекстСообщения, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
				
				ЗаписатьГрафикРаботыВРегистрСервер(ОтборМагазин, ПредыдущееНачалоНедели);
				
			КонецЕсли;
			
			Модифицированность = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьГрафикРаботПоСотрудникам()
	
	Интервалы.Очистить();
	
	//Заголовки групп колонок
	Элементы.Понедельник.Заголовок = НСтр("ru = 'Понедельник '") + Формат(НачалоНедели,"Л=ru; ДФ=dd.MM.yy");
	Элементы.Вторник.Заголовок     = НСтр("ru = 'Вторник '")     + Формат(НачалоНедели+86400,"Л=ru; ДФ=dd.MM.yy");
	Элементы.Среда.Заголовок       = НСтр("ru = 'Среда '")       + Формат(НачалоНедели+86400*2,"Л=ru; ДФ=dd.MM.yy");
	Элементы.Четверг.Заголовок     = НСтр("ru = 'Четверг '")     + Формат(НачалоНедели+86400*3,"Л=ru; ДФ=dd.MM.yy");
	Элементы.Пятница.Заголовок     = НСтр("ru = 'Пятница '")     + Формат(НачалоНедели+86400*4,"Л=ru; ДФ=dd.MM.yy");
	Элементы.Суббота.Заголовок     = НСтр("ru = 'Суббота '")     + Формат(НачалоНедели+86400*5,"Л=ru; ДФ=dd.MM.yy");
	Элементы.Воскресенье.Заголовок = НСтр("ru = 'Воскресенье '") + Формат(НачалоНедели+86400*6,"Л=ru; ДФ=dd.MM.yy");
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГрафикиРаботыМагазинов.ДатаКалендаря  КАК ДатаКалендаря,
	|	Интервалы.ДеньНедели                  КАК ДеньНедели,
	|	Интервалы.Ссылка.НачалоИнтервала      КАК НачалоИнтервала,
	|	Интервалы.Ссылка.ОкончаниеИнтервала   КАК ОкончаниеИнтервала,
	|	Интервалы.Ссылка.ДлинаРабочегоВремени КАК ДлинаРабочегоВремени,
	|	Интервалы.Ссылка                      КАК Интервал,
	|	ГрафикиРаботыМагазинов.РабочийДень    КАК РабочийДень
	|ПОМЕСТИТЬ Интервалы
	|ИЗ
	|	РегистрСведений.ГрафикиРаботыМагазинов КАК ГрафикиРаботыМагазинов
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Справочник.ИнтервалыРаботыМагазинов.ДниНедели КАК Интервалы
	|ПО
	|	(ДЕНЬНЕДЕЛИ(ГрафикиРаботыМагазинов.ДатаКалендаря) = Интервалы.ДеньНедели.Порядок + 1)
	|	И ГрафикиРаботыМагазинов.Магазин = Интервалы.Ссылка.Магазин
	|ГДЕ
	|	ГрафикиРаботыМагазинов.Магазин = &Магазин
	|	И ГрафикиРаботыМагазинов.ДатаКалендаря >= НАЧАЛОПЕРИОДА(&НачалоНедели, ДЕНЬ)
	|	И ГрафикиРаботыМагазинов.ДатаКалендаря <= КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(&НачалоНедели, ДЕНЬ, 7), ДЕНЬ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Интервалы.Интервал              КАК Интервал,
	|	Интервалы.ДеньНедели            КАК ДеньНедели,
	|	МАКСИМУМ(Интервалы.РабочийДень) КАК РабочийДень
	|ИЗ
	|	Интервалы КАК Интервалы
	|
	|СГРУППИРОВАТЬ ПО
	|	Интервалы.Интервал,
	|	Интервалы.ДеньНедели
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РаботаСотрудников.Сотрудник                     КАК Сотрудник,
	|	РаботаСотрудников.РаботаВыполняемаяСотрудниками КАК Работа
	|ПОМЕСТИТЬ РаботаСотрудники
	|ИЗ
	|	РегистрСведений.РаботаВыполняемаяСотрудниками КАК РаботаСотрудников
	|ГДЕ
	|	(НЕ РаботаСотрудников.Сотрудник.ПометкаУдаления)
	|	И РаботаСотрудников.Сотрудник.Сотрудник
	|	И РаботаСотрудников.Сотрудник.Магазин = &Магазин
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПланируемоеВремя.Сотрудник                              КАК Сотрудник,
	|	ПланируемоеВремя.Работа                                 КАК Работа,
	|	ПланируемоеВремя.ДеньНедели                             КАК ДеньНедели,
	|	ПланируемоеВремя.Интервал                               КАК Интервал,
	|	ПланируемоеРабочееВремяСотрудников.ДлинаРабочегоВремени КАК ДлинаРабочегоВремени,
	|	ПланируемоеВремя.ДатаКалендаря                          КАК ДатаКалендаря,
	|	ПланируемоеВремя.РабочийДень                            КАК РабочийДень
	|ИЗ
	|	(ВЫБРАТЬ
	|		РаботаСотрудники.Сотрудник КАК Сотрудник,
	|		РаботаСотрудники.Работа    КАК Работа,
	|		Интервалы.ДатаКалендаря    КАК ДатаКалендаря,
	|		Интервалы.ДеньНедели       КАК ДеньНедели,
	|		Интервалы.Интервал         КАК Интервал,
	|		Интервалы.РабочийДень      КАК РабочийДень
	|	ИЗ
	|		РаботаСотрудники КАК РаботаСотрудники,
	|		Интервалы КАК Интервалы
	|	) КАК ПланируемоеВремя
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ПланируемоеРабочееВремяСотрудников КАК ПланируемоеРабочееВремяСотрудников
	|	ПО
	|		ПланируемоеВремя.Сотрудник = ПланируемоеРабочееВремяСотрудников.Сотрудник
	|		И ПланируемоеВремя.Работа = ПланируемоеРабочееВремяСотрудников.РаботаВыполняемаяСотрудниками
	|		И ПланируемоеВремя.Интервал = ПланируемоеРабочееВремяСотрудников.ИнтервалРаботыМагазинов
	|		И (НАЧАЛОПЕРИОДА(ПланируемоеВремя.ДатаКалендаря, ДЕНЬ) = НАЧАЛОПЕРИОДА(ПланируемоеРабочееВремяСотрудников.Период, ДЕНЬ))
	|ИТОГИ
	|	МАКСИМУМ(ДлинаРабочегоВремени)
	|ПО
	|	Работа,
	|	Сотрудник,
	|	ДеньНедели,
	|	Интервал");
	Запрос.УстановитьПараметр("Магазин",ОтборМагазин);
	Запрос.УстановитьПараметр("НачалоНедели",НачалоНедели);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	РезультатПоИнтервалам = МассивРезультатов[1];
	ВыборкаПоИнтервалам = РезультатПоИнтервалам.Выбрать();
	
	ДобавляемыеРеквизиты = Новый Массив();
	УдаляемыеРеквизиты   = Новый Массив();
	
	СуществующиеРеквизиты = Новый Массив;
	РеквизитыФормы = ПолучитьРеквизиты("ТаблицаРегистра");
	
	Для каждого РеквизитФормы Из РеквизитыФормы Цикл
		
		Если Найти(РеквизитФормы.Имя,"Добавлен") Тогда
			
			СуществующиеРеквизиты.Добавить(РеквизитФормы);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого СуществующийРеквизит Из СуществующиеРеквизиты Цикл
		
		УдаляемыеРеквизиты.Добавить(СуществующийРеквизит);
		
	КонецЦикла;
	
	//Массив элементов - групп колонок, в которых необходимо создать доп. колонки
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить(Элементы.Понедельник);
	МассивЭлементов.Добавить(Элементы.Вторник);
	МассивЭлементов.Добавить(Элементы.Среда);
	МассивЭлементов.Добавить(Элементы.Четверг);
	МассивЭлементов.Добавить(Элементы.Пятница);
	МассивЭлементов.Добавить(Элементы.Суббота);
	МассивЭлементов.Добавить(Элементы.Воскресенье);
	
	ОписаниеТипов = Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.Время));
	
	Пока ВыборкаПоИнтервалам.Следующий() Цикл
		
		Для каждого ЭлементГруппа Из МассивЭлементов Цикл
			
			Если ЭлементГруппа.Имя = Строка(ВыборкаПоИнтервалам.ДеньНедели) Тогда
				
				ЭлементВСпискеИнтервалов = Интервалы.НайтиПоЗначению(ВыборкаПоИнтервалам.Интервал);
				
				Если ЭлементВСпискеИнтервалов = Неопределено Тогда
					
					Интервалы.Добавить(ВыборкаПоИнтервалам.Интервал,,?(ВыборкаПоИнтервалам.РабочийДень <> 1, Ложь, Истина));
					ИндексЭлемента = Интервалы.Количество() -1;
					
				Иначе
					
					ЭлементВСпискеИнтервалов.Пометка = ?(ВыборкаПоИнтервалам.РабочийДень <> 1, Ложь, Истина);
					ИндексЭлемента = Интервалы.Индекс(ЭлементВСпискеИнтервалов);
					
				КонецЕсли;
				
				ПозицияСимвола = Найти(ЭлементГруппа.Заголовок," (выходной)");
				
				Если ВыборкаПоИнтервалам.РабочийДень = 1 
					И ПозицияСимвола  > 0
					Тогда
					
					ЭлементГруппа.Заголовок = Лев(ЭлементГруппа.Заголовок, СтрДлина(ЭлементГруппа.Заголовок) - ПозицияСимвола - 1);
					
				ИначеЕсли ВыборкаПоИнтервалам.РабочийДень <> 1
					И ПозицияСимвола = 0
					Тогда
						
						ЭлементГруппа.Заголовок = ЭлементГруппа.Заголовок + " (выходной)";
						
				КонецЕсли;
					
				ИмяЭлемента = ЭлементГруппа.Имя + "Добавлен" + ИндексЭлемента;
				
				ЭлементНайден = Ложь;
				
				Для каждого СуществующийРеквизит Из СуществующиеРеквизиты Цикл
					
					Если СуществующийРеквизит.Имя = ИмяЭлемента Тогда
						
						ЭлементНайден = Истина;
						СуществующийРеквизит.Заголовок = Строка(ВыборкаПоИнтервалам.Интервал);
						
						КоличествоРеквизитов = УдаляемыеРеквизиты.Количество()-1;
						Для Инд = 0 По КоличествоРеквизитов Цикл
							
							Если УдаляемыеРеквизиты[КоличествоРеквизитов-Инд] = СуществующийРеквизит Тогда
								
								УдаляемыеРеквизиты.Удалить(КоличествоРеквизитов-Инд);
								
							КонецЕсли;
							
						КонецЦикла;
						
						Прервать;
						
					КонецЕсли;
					
				КонецЦикла;
					
				Если НЕ ЭлементНайден Тогда
					
					Реквизит = Новый РеквизитФормы(ИмяЭлемента, ОписаниеТипов,"ТаблицаРегистра", Строка(ВыборкаПоИнтервалам.Интервал),Истина);
					ДобавляемыеРеквизиты.Добавить(Реквизит);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	//Очищаем массив существующих реквизитов
	СуществующиеРеквизиты.Очистить();
	
	КоличествоРеквизитов = УдаляемыеРеквизиты.Количество()-1;
	
	Для Инд = 0 По КоличествоРеквизитов Цикл
		
		ИмяРеквизита            = УдаляемыеРеквизиты[Инд].Путь + "." + УдаляемыеРеквизиты[Инд].Имя;
		УдаляемыеРеквизиты[Инд] = ИмяРеквизита;
		
	КонецЦикла;
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты, УдаляемыеРеквизиты);
	//Удаление элементов
	УдаляемыеЭлементы = Новый Массив;
	
	Для каждого ПодчиненныйЭлемент Из Элементы Цикл
		
		Если Найти(ПодчиненныйЭлемент.Имя,"Добавлен") > 0 
			И ТипЗнч(ПодчиненныйЭлемент) = Тип("ПолеФормы")
			Тогда
			
			УдаляемыеЭлементы.Добавить(ПодчиненныйЭлемент);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
		
		Элементы.Удалить(УдаляемыйЭлемент);
		
	КонецЦикла;
	//Добавление элементов
	ВыборкаПоИнтервалам.Сбросить();
	
	Пока ВыборкаПоИнтервалам.Следующий() Цикл
		
		Для каждого ЭлементГруппа Из МассивЭлементов Цикл
			
			Если ЭлементГруппа.Имя = Строка(ВыборкаПоИнтервалам.ДеньНедели) Тогда
				
				ИндексЭлемента               = Интервалы.Индекс(Интервалы.НайтиПоЗначению(ВыборкаПоИнтервалам.Интервал));
				Родитель                     = ЭлементГруппа;
				Элемент                      = Элементы.Добавить(ЭлементГруппа.Имя + "Добавлен"+  ИндексЭлемента, Тип("ПолеФормы"), Родитель);
				Элемент.Вид                  = ВидПоляФормы.ПолеВвода;
				Элемент.ПутьКДанным          = "ТаблицаРегистра." + ЭлементГруппа.Имя + "Добавлен" + ИндексЭлемента;
				Элемент.Формат               = "ДФ=ЧЧ:мм";
				Элемент.ФорматРедактирования = "ДФ=ЧЧ:мм";
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Дерево = РеквизитФормыВЗначение("ТаблицаРегистра");
	Дерево.Строки.Очистить();
	РезультатЗапроса = МассивРезультатов[3];
	ВыборкаРабота = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаРабота.Следующий() Цикл
		
		СтрокаРабота = Дерево.Строки.Добавить();
		СтрокаРабота.РаботаСотрудник = ВыборкаРабота.Работа;
		ВыборкаСотрудник = ВыборкаРабота.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаСотрудник.Следующий() Цикл
			
			СтрокаСотрудник = СтрокаРабота.Строки.Добавить();
			СтрокаСотрудник.РаботаСотрудник = ВыборкаСотрудник.Сотрудник;
			ВыборкаДеньНедели = ВыборкаСотрудник.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаДеньНедели.Следующий() Цикл
				
				ВыборкаИнтервал = ВыборкаДеньНедели.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока ВыборкаИнтервал.Следующий() Цикл
					
					ИндексИнтервала = Интервалы.Индекс(Интервалы.НайтиПоЗначению(ВыборкаИнтервал.Интервал));
					ИмяДняНедели    = Строка(ВыборкаИнтервал.ДеньНедели);
					ИмяКолонки      = ИмяДняНедели + "Добавлен" + ИндексИнтервала;
					СтрокаСотрудник[ИмяКолонки] = ВыборкаИнтервал.ДлинаРабочегоВремени;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево,"ТаблицаРегистра");
	
	ОбновитьТекстНадписиИнтервалыМагазинов();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьДлинуРабочегоДня(РассчитатьНаВсюНеделю = Ложь)
	ТекущаяСтрока     = Элементы.ТаблицаРегистра.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено
		И ТекущаяСтрока.Свойство("РаботаСотрудник")
		И ТипЗнч(ТекущаяСтрока.РаботаСотрудник) = Тип("СправочникСсылка.ФизическиеЛица") 
		И ЗначениеЗаполнено(ТекущаяСтрока.РаботаСотрудник) Тогда
		
		Если РассчитатьНаВсюНеделю Тогда
			РассчитатьДлинуРабочегоДняНаНеделю(ТекущаяСтрока);
		Иначе
			ИмяКолонки = Элементы.ТаблицаРегистра.ТекущийЭлемент.Имя;
			Если Найти(ИмяКолонки,"Добавлен") > 0 Тогда
				ИндексИнтервала = Прав(ИмяКолонки, СтрДлина(ИмяКолонки)- Найти(ИмяКолонки,"Добавлен") - 7);
				ТекущаяСтрока[ИмяКолонки] = ДлинаРабочегоДня(Число(ИндексИнтервала));
				Модифицированность = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьДлинуРабочегоДняНаНеделю(ТекущаяСтрока, ПодчиненныеЭлементыПараметр = Неопределено)
	Если ПодчиненныеЭлементыПараметр = Неопределено Тогда
		Для каждого ПодчиненныйЭлемент Из Элементы.ТаблицаРегистра.ПодчиненныеЭлементы Цикл
			РассчитатьДлинуРабочегоДняНаНеделю(ТекущаяСтрока, ПодчиненныйЭлемент);
		КонецЦикла;
	Иначе
		Если ТипЗнч(ПодчиненныеЭлементыПараметр) = Тип("ПолеФормы") Тогда
			ИмяКолонки = ПодчиненныеЭлементыПараметр.Имя;
			Если Найти(ИмяКолонки,"Добавлен") > 0 Тогда
				ИндексИнтервала = Прав(ИмяКолонки, СтрДлина(ИмяКолонки)- Найти(ИмяКолонки,"Добавлен") - 7);
				ТекущаяСтрока[ИмяКолонки] = ДлинаРабочегоДня(Число(ИндексИнтервала));
				Модифицированность = Истина;
			КонецЕсли;
		Иначе
			Для каждого ПодчиненныйЭлемент Из ПодчиненныеЭлементыПараметр.ПодчиненныеЭлементы Цикл
				РассчитатьДлинуРабочегоДняНаНеделю(ТекущаяСтрока, ПодчиненныйЭлемент);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры