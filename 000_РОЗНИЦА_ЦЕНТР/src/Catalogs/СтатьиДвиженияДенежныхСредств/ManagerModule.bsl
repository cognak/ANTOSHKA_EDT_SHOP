#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает статью движения денежных средств для выбранной хозяйственной операции.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа для которой получаем статью движения денежных средств.
//
// Возвращаемое значение:
// 	СправочникСсылка.СтатьиДвиженияДенежныхСредств - Найденная статья ДДС
//
Функция СтатьяДвиженияДенежныхСредствПоХозяйственнойОперации(ХозяйственнаяОперация) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ТаблицаСправочник.Предопределенный
	|			ТОГДА ""0""
	|		ИНАЧЕ ""1""
	|	КОНЕЦ + ""."" + ТаблицаСправочник.Код КАК КлючПорядка,
	|	ТаблицаСправочник.Ссылка КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Справочник.СтатьиДвиженияДенежныхСредств КАК ТаблицаСправочник
	|ГДЕ
	|	НЕ ТаблицаСправочник.ПометкаУдаления
	|	И ТаблицаСправочник.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|
	|УПОРЯДОЧИТЬ ПО
	|	КлючПорядка"
	);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.СтатьяДвиженияДенежныхСредств;

КонецФункции

//	LNK 27.06.2017 12:11:26
Функция СтатьиДвиженияДенежныхСредствПоХозяйственнойОперации(ХозяйственнаяОперация) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ТаблицаСправочник.Предопределенный
	|			ТОГДА ""0""
	|		ИНАЧЕ ""1""
	|	КОНЕЦ + ""."" + ТаблицаСправочник.Код КАК КлючПорядка,
	|	ТаблицаСправочник.Ссылка КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Справочник.СтатьиДвиженияДенежныхСредств КАК ТаблицаСправочник
	|ГДЕ
	|	НЕ ТаблицаСправочник.ПометкаУдаления
	|	И ТаблицаСправочник.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|
	|УПОРЯДОЧИТЬ ПО
	|	КлючПорядка"
	);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	РезультатЗапроса = Запрос.Выполнить();

	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("СтатьяДвиженияДенежныхСредств");

КонецФункции // СтатьиДвиженияДенежныхСредствПоХозяйственнойОперации()

// Заполняет хозяйственную операцию для предопределенных элементов статей денежных средств
//
Процедура ЗаполнитьХозяйственнуюОперациюПредопределеннымСтатьямДДС() Экспорт
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу,
		Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюОрганизацию,
		Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюОрганизацию);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзБанка,
		Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзКассыККМ,
		Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.СдачаДенежныхСредствВБанк,
		Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗарплатыСотрудникам,
		Перечисления.ХозяйственныеОперации.ВыплатаЗаработнойПлатыПоВедомостям);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗарплатыСотрудникам,
		Перечисления.ХозяйственныеОперации.ВыплатаЗаработнойПлатыРаботнику);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеОплатыОтКлиента,
		Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВозвратОплатыКлиенту,
		Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту);

	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВКассуККМ,
		Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ);
		
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВозвратНеинкассированнойВыручки,
		Перечисления.ХозяйственныеОперации.ПрочиеДоходы);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.НедостачаДенежныхСредств,
		Перечисления.ХозяйственныеОперации.ПрочиеРасходы);

	Для Каждого Элемент Из Соответствие Цикл
	
		СтатьяДДСОбъект = Элемент.Ключ.ПолучитьОбъект();
		СтатьяДДСОбъект.ХозяйственнаяОперация = Элемент.Значение;
		Попытка
			СтатьяДДСОбъект.Записать();
		Исключение
		КонецПопытки;
		
	КонецЦикла;
	
//*	ВыдачаДенежныхСредствВДругуюКассу
//*	ВыдачаДенежныхСредствВДругуюОрганизацию
//* ВыдачаДенежныхСредствВКассуККМ
//* ПоступлениеДенежныхСредствИзБанка
//* ПоступлениеДенежныхСредствИзКассыККМ
//* СдачаДенежныхСредствВБанк
//** ВыплатаЗарплатыСотрудникам
//* ПоступлениеОплатыОтКлиента
//* ВозвратОплатыКлиенту
//ОплатаФизическомуЛицу
//ПоступлениеРазменнойМонетыИзКассыККМ
//ВыдачаРазменнойМонетыВКассуККМ
//ВводОстатковДенежныхСредств
//ПоступлениеДенежныхСредствИзКассыККМЗаУслуги
//* ВозвратНеинкассированнойВыручки
//* НедостачаДенежныхСредств

КонецПроцедуры

// Получает предопределенную статью движения денежных средств для выбранной хозяйственной операции.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа
//
// Возвращаемое значение:
// 	СправочникСсылка.СтатьиДвиженияДенежныхСредств - Предопределенная статья ДДС
//
Функция ПредопределеннаяСтатьяДДСПоХозяйственнойОперации(ХозяйственнаяОперация, ПлановоеЗначение = Истина) Экспорт
	
	Перем СтатьяДвиженияДенежныхСредств;

	Если НЕ ПлановоеЗначение = Истина Тогда

		Если НЕ ПривилегированныйРежим() Тогда

			УстановитьПривилегированныйРежим(Истина);

		КонецЕсли;

		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаСправочник.Ссылка КАК СтатьяДвиженияДенежныхСредств,
		|	ТаблицаСправочник.Код КАК Код
		|ИЗ
		|	Справочник.СтатьиДвиженияДенежныхСредств КАК ТаблицаСправочник
		|ГДЕ
		|	ТаблицаСправочник.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И ТаблицаСправочник.СтатьяХозяйственнойОперацииПоУмолчанию
		|	И НЕ ТаблицаСправочник.ПометкаУдаления
		|	И НЕ ТаблицаСправочник.ЭтоГруппа
		|
		|УПОРЯДОЧИТЬ ПО
		|	Код УБЫВ"
		);
		Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда

			СтатьяДвиженияДенежныхСредств = Выборка.СтатьяДвиженияДенежныхСредств;

		КонецЕсли;

	КонецЕсли;

	Если СтатьяДвиженияДенежныхСредств = Неопределено Тогда

		СтатьяДвиженияДенежныхСредств = СоответствиеХозоперацииСтатьеДДС().Получить(ХозяйственнаяОперация);

		Если СтатьяДвиженияДенежныхСредств = Неопределено Тогда

			СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка();

		КонецЕсли;

	КонецЕсли;

	Возврат СтатьяДвиженияДенежныхСредств;
	
КонецФункции

Функция СоответствиеХозоперацииСтатьеДДС()	//	LNK 25.03.2020 08:12:31
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу,
		Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу);
		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюОрганизацию,
		Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюОрганизацию);
		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ,
		Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу);
		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка,
		Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзБанка);
		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы,
		Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеРазменнойМонетыИзДругойКассыККМ);
		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации,
		Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюОрганизацию);
		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ,
		Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу);
		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк,
		Справочники.СтатьиДвиженияДенежныхСредств.СдачаДенежныхСредствВБанк);
		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ,
		Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВКассуККМ);
		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ,
		Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзКассыККМ);
		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыплатаЗаработнойПлатыПоВедомостям,
		Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗарплатыСотрудникам);
		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыплатаЗаработнойПлатыРаботнику,
		Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗарплатыСотрудникам);
//	LNK 24.10.2019 11:33:11		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ОплатаФизическомуЛицу,
		Справочники.СтатьиДвиженияДенежныхСредств.ОплатаФизическомуЛицу);
//	LNK 24.10.2019 11:33:15		
	Соответствие.Вставить(Перечисления.ХозяйственныеОперации.СписаниеРасхожденийДенежныхСредств,
		Справочники.СтатьиДвиженияДенежныхСредств.СписаниеРасхожденийДенежныхСредств);

	Возврат Соответствие;

КонецФункции

// Получает хозяйственную операцию на предопределенную статью ДДС
//
Функция ХозяйственнаяОперацияПредопределеннойСтатьиДДС(ПредопределеннаяСтатья) Экспорт
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу,
		Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзБанка,
		Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.СдачаДенежныхСредствВБанк,
		Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюОрганизацию,
		Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюОрганизацию);

	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВКассуККМ,
		Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаРазменнойМонетыВКассуККМ,
		Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ);	//	LNK 27.06.2017 10:36:39
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзКассыККМ,
		Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеРазменнойМонетыИзКассыККМ,
		Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ);	//	LNK 27.06.2017 10:36:21
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеРазменнойМонетыИзДругойКассыККМ,
		Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы);	//	LNK 24.03.2020 06:36:53
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзКассыККМЗаУслугиПарикмахерской,
		Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ);	//	LNK 30.06.2017 17:43:50
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзКассыККМЗаУслугиУпаковки,
		Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ);	//	LNK 17.12.2018 14:49:10

	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗарплатыСотрудникам,
		Перечисления.ХозяйственныеОперации.ВыплатаЗаработнойПлатыПоВедомостям);
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ОплатаФизическомуЛицу,
		Перечисления.ХозяйственныеОперации.ОплатаФизическомуЛицу);
//	LNK 24.10.2019 11:28:05
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.СписаниеРасхожденийДенежныхСредств,
		Перечисления.ХозяйственныеОперации.СписаниеРасхожденийДенежныхСредств);
		
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВводОстатковДенежныхСредств,
		Перечисления.ХозяйственныеОперации.ПрочиеДоходы);	//	LNK 30.06.2017 17:56:25

	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВозвратНеинкассированнойВыручки,
		Перечисления.ХозяйственныеОперации.ПрочиеДоходы);	//	LNK 29.08.2018 11:20:10
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.НедостачаДенежныхСредств,
		Перечисления.ХозяйственныеОперации.ПрочиеРасходы);	//	LNK 29.08.2018 11:20:10

		
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзКассыККМпроколюванняВух,
		Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ);	//	Бакан 08.08.2023
		ХозяйственнаяОперация = Соответствие.Получить(ПредопределеннаяСтатья);

		
	Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВозвратОплатыКлиентуЗаУслугиПарикмахерской,
		Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту);	//	Бакан 01.11.2023
		ХозяйственнаяОперация = Соответствие.Получить(ПредопределеннаяСтатья);
		
	Если ХозяйственнаяОперация = Неопределено Тогда

		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПустаяСсылка();;

	КонецЕсли;

	Возврат ХозяйственнаяОперация;

КонецФункции

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	Результат = Новый Массив;
	Результат.Добавить("ХозяйственнаяОперация");
	Результат.Добавить("СтатьяХозяйственнойОперацииПоУмолчанию");
	Возврат Результат;
КонецФункции

#КонецЕсли
