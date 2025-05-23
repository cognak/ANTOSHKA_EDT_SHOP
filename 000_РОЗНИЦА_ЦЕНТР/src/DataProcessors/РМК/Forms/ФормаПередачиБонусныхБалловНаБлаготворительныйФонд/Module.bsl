#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("Контрагент"		, Контрагент);
	Параметры.Свойство("НомерТелефона"	, НомерТелефона);

	Элементы.КомандаОтладкаSMS.Видимость = ТехническаяПоддержкаПовтИсп.ОтладочныйРежимРаботы();

//	Обновим флаг доступа принудительно..
	РесурсWebRetailДоступен = РозничныеПродажиСлужебный.РесурсWebRetailДоступен();

	Если РесурсWebRetailДоступен Тогда

		ЗаполнитьСписокДоступныхФондов();

	Иначе

		Отказ = Истина;
		Сообщить("Відмовлено. Центральний сервер зараз поза доступом");

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если НЕ ПолучитьДанныеБонуснойСистемы() Тогда

		Отказ = Истина;

	КонецЕсли;

	ОформлениеЭлементовФормы();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ФондБлаготворительныйПриИзменении(Элемент)

	ОформлениеЭлементовФормы();

КонецПроцедуры

&НаКлиенте
Процедура ФондБлаготворительныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ФондБлаготворительныйОчистка(Элемент, СтандартнаяОбработка)

	ОформлениеЭлементовФормы();

КонецПроцедуры

&НаКлиенте
Процедура СуммаБонусныхБалловПриИзменении(Элемент)

	ОформлениеЭлементовФормы();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОбновитьДанные(Команда)

	Если ПолучитьДанныеБонуснойСистемы() Тогда

		ПоказатьОповещениеПользователя("Дані оновлені"
			,
			, "Виконано оновлення інформації щодо бонусного рахунку"
			, БиблиотекаКартинок.ИнформацияНовости32Анимированная
		);

	Иначе

		ПоказатьОповещениеПользователя("Не виконано"
			,
			, "Не вдалося отримати дані бонусного рахунку"
			, БиблиотекаКартинок.Ошибка32
		);

	КонецЕсли;

	СуммаБонусныхБаллов = 0;

	ОформлениеЭлементовФормы();

КонецПроцедуры

&НаКлиенте
Процедура КомандаВыполнитьПередачуСуммыБонусов(Команда)

	ОтветПользователя = ОбщегоНазначенияРТКлиент.ВывестиВопросДляРМК(
		  "Ви дійсно бажаєте виконати переказ?"
		, "Переказ '" + Формат(СуммаБонусныхБаллов, "ЧДЦ=2; ЧН=0,00; ЧГ=") + "' балів від «" + Контрагент + "» на фонд «" + ФондБлаготворительный + "»", "Нет");

	Если НЕ ВРЕГ(ОтветПользователя) = "ДА" Тогда

		ПоказатьОповещениеПользователя("Не виконано"
			,
			, "Отримано відмову користувача"
			, БиблиотекаКартинок.Предупреждение32
		);

	Иначе

		ПередачаВыполнена = Истина;	//	LNK 29.09.2023 05:19:52 - блокируем кнопку передачи сразу же!
		ОформлениеЭлементовФормы();

		Если ПолучитьДанныеБонуснойСистемы() Тогда

			ДанныеПередачи = ВыполнитьПередачуСуммыБонусныхБаллов();

			Если ДанныеПередачи.Отказ = Истина Тогда

				ПоказатьОповещениеПользователя("Не виконано"
					,
					, ДанныеПередачи.ТекстСообщения
					, БиблиотекаКартинок.Ошибка32
				);

			Иначе

				ПоказатьОповещениеПользователя("Операцію виконано"
					,
					, ДанныеПередачи.ТекстСообщения
					, БиблиотекаКартинок.ИнформацияНовости32Анимированная
				);

				ОбщегоНазначенияКлиентСервер.Пауза(3000, Истина);	//	пауза 3 сек

				ПоказатьОповещениеПользователя("Межа послідовності"
					,
					, "Виконується відновлення межі послідовності в ЦБ. Зачекайте .."
					, БиблиотекаКартинок.Информация32
				);

				ВосстановитьПоследовательностьНаСервере(Контрагент);

				ПоказатьОповещениеПользователя("Межа послідовності"
					,
					, "Відновлення межі послідовності в ЦБ виконано!"
					, БиблиотекаКартинок.ИнформацияНовости32Анимированная
				);

				ТекстСообщения = "";

			//	LNK 22.09.2023 09:54:58
				Если ОтправитьСообщениеКонтрагенту(НомерТелефона, Контрагент, ДанныеПередачи.Получатель, СуммаБонусныхБаллов, ТекстСообщения) Тогда

					ЗафиксироватьОтправленноеСообщение(НомерТелефона, Контрагент, ТекстСообщения);

				КонецЕсли;

				Закрыть();

			КонецЕсли;

		Иначе

			ПоказатьОповещениеПользователя("Не виконано"
				,
				, "Не вдалося отримати оновлені дані бонусного рахунку"
				, БиблиотекаКартинок.Ошибка32
			);

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

&НаКлиенте
Процедура ОформлениеЭлементовФормы()

	Элементы.ФондБлаготворительный.ТолькоПросмотр	= НЕ СуммаБонусныхБалловАктивных > 0;
	Элементы.СуммаБонусныхБаллов.ТолькоПросмотр		= НЕ (СуммаБонусныхБалловАктивных > 0 И НЕ ФондБлаготворительный.Пустая());
	Элементы.КомандаВыполнитьПередачуСуммыБонусов.Доступность = СуммаБонусныхБаллов > 0 И НЕ ПередачаВыполнена;

	Элементы.СуммаБонусныхБаллов.МаксимальноеЗначение = СуммаБонусныхБалловАктивных;

	Если СуммаБонусныхБаллов > 0 Тогда
		
		ТекущийЭлемент = Элементы.КомандаВыполнитьПередачуСуммыБонусов;

	ИначеЕсли СуммаБонусныхБалловАктивных > 0 Тогда

		Если ФондБлаготворительный.Пустая() Тогда

			ТекущийЭлемент = Элементы.ФондБлаготворительный;

		Иначе

			ТекущийЭлемент = Элементы.СуммаБонусныхБаллов;

		КонецЕсли;

	Иначе

		ТекущийЭлемент = Элементы.КомандаОбновитьДанные;
	
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеБонуснойСистемы()

	ПараметрыЗапроса = Новый Структура(
		"ТипыБонусов, ТолькоТекущийОстаток, Команда"
		, ОбщегоНазначенияКлиентСервер.AAD(Перечисления.ТипыБонусов.Привлечение, Перечисления.ТипыБонусов.Органический, Перечисления.ТипыБонусов.Акционный)
		, Истина
		, "ОбщееСостояниеСчёта"
	);

	ДанныеОтвета = БонусныеБаллыСервер.BPS_ПолучитьОстатокБонусныхБаллов(Контрагент, ПараметрыЗапроса);

	Если НЕ (ДанныеОтвета.Ошибка = Истина ИЛИ НЕ ДанныеОтвета.Свойство("ДанныеСчёта")) Тогда

		СуммаБонусныхБалловАктивных = ДанныеОтвета.СуммаБонусныхБаллов;

	КонецЕсли;

	Возврат НЕ ДанныеОтвета.Ошибка

КонецФункции

&НаСервере	//	LNK 20.09.2023 06:15:37
Процедура ЗаполнитьСписокДоступныхФондов()

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаСправочник.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Фонды КАК ТаблицаСправочник
	|ГДЕ
	|	НЕ(ТаблицаСправочник.ПометкаУдаления
	|				ИЛИ ТаблицаСправочник.Блокирован)"
	);
	
	Элементы.ФондБлаготворительный.СписокВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));

	Если Элементы.ФондБлаготворительный.СписокВыбора.Количество() = 1 Тогда

		ФондБлаготворительный = Элементы.ФондБлаготворительный.СписокВыбора[0].Значение;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПроцедурыПередачиБонусныхБаллов

&НаСервере	//	LNK 20.09.2023 07:45:13
Функция ВыполнитьПередачуСуммыБонусныхБаллов()

	ДанныеПередачи = Новый Структура(
		"Отказ, ТекстСообщения, Получатель"
		, Ложь
		, ""
		, РозничныеПродажиСерверПовтИсп.РеквизитыФонда(ФондБлаготворительный).Контрагент
	);

	УстановитьПривилегированныйРежим(Истина);	//	LNK 03.10.2023 06:02:36

	НачатьТранзакцию();

	Попытка

		ДокументОбъект = Документы.НачислениеИСписаниеБонусныхБаллов.СформироватьДокументПередачиБонусныхБаллов(Контрагент, СуммаБонусныхБаллов, ФондБлаготворительный);

		Если НЕ ДокументОбъект.Модифицированность() И ДокументОбъект.Проведен Тогда

			Если НЕ ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

				ПараметрПодтверждения = ТехническаяПоддержка.НазначитьОбъектуДействие(ДокументОбъект.Ссылка,, "ПЕРЕДАТЬ_В_ЦЕНТР", Истина, ДокументОбъект.Ответственный);

			Иначе

				ПараметрПодтверждения = Новый ТаблицаЗначений;
				ПараметрПодтверждения.Колонки.Добавить("Объект");
				ПараметрПодтверждения.Колонки.Добавить("Результат");

				СтрокаТаблицы = ПараметрПодтверждения.Добавить();
				СтрокаТаблицы.Объект = ДокументОбъект.Ссылка;
				СтрокаТаблицы.Результат = ?(ДокументОбъект.Проведен, "выполнено", "пропущено");

			КонецЕсли;

			Если ТипЗнч(ПараметрПодтверждения) = Тип("ТаблицаЗначений") Тогда

				СтрокаТаблицы = ПараметрПодтверждения.Найти(ДокументОбъект.Ссылка, "Объект");

				Если СтрокаТаблицы = Неопределено ИЛИ НЕ СтрокаТаблицы.Результат = "выполнено" Тогда

					ДанныеПередачи.Отказ = Истина;
					ДанныеПередачи.ТекстСообщения = "не вдалося записати в ЦБ дані поточної операції" + Символы.ПС + СтрокаТаблицы.Сообщение;

				Иначе
					
					ДанныеПередачи.Отказ = Ложь;
					ДанныеПередачи.ТекстСообщения = "інформацію про поточну операцію успішно передано до ЦБ за документом «" + ДокументОбъект + "»";

				КонецЕсли;

			Иначе

				ДанныеПередачи.Отказ = Истина;
				ДанныеПередачи.ТекстСообщения = "не вдалося транспортувати в ЦБ дані поточної операції";

			КонецЕсли;

		Иначе

			ДанныеПередачи.Отказ = Истина;
			ДанныеПередачи.ТекстСообщения = "не вдалося отримати проведений документ";

		КонецЕсли;

	Исключение

		ДанныеПередачи.Отказ = Истина;
		ДанныеПередачи.ТекстСообщения = ОписаниеОшибки();

	КонецПопытки;

//	---------------------------------------------------------------------------------------

	Если ДанныеПередачи.Отказ = Истина Тогда

		ОтменитьТранзакцию();

		ЖурналСобытий.Регистрация("БОНУСЫ_НА_ФОНД", УровеньЖурналаРегистрации.Ошибка
			, Метаданные.Документы.НачислениеИСписаниеБонусныхБаллов
			, //ДокументОбъект.Ссылка
			,
			, ДанныеПередачи.ТекстСообщения
			,
			, Истина
			, Ложь
		);

	Иначе

		ЗафиксироватьТранзакцию();

	КонецЕсли;

	Возврат ДанныеПередачи;

КонецФункции

&НаСервереБезКонтекста	//	LNK 20.09.2023 15:55:25
Процедура ВосстановитьПоследовательностьНаСервере(Контрагент)

	Если ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

		ПараметрыЗадания = Новый Массив;
		ПараметрыЗадания.Добавить(Контрагент);
		ПараметрыЗадания.Добавить(Истина);
		ПараметрыЗадания.Добавить(Истина);
		ПараметрыЗадания.Добавить(Истина);

		БонусныеБаллыПоследовательность.ВыполнитьВосстановлениеПоследовательности(Контрагент, Истина, Истина, Истина);

	Иначе

		БонусныеБаллыСервер.BPS_АвторизацияКонтрагента(Контрагент, Новый Структура);

	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтправитьСообщениеКонтрагенту(Знач НомерТелефона, Контрагент, Получатель, СуммаБонусныхБаллов, ТекстСообщения)

	Если НЕ ПустаяСтрока(НомерТелефона) Тогда

		НомерТелефона	= ОтправкаSMS.ПодготовитьНомерТелефона(НомерТелефона);
		ТекстСообщения	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			  "Дякуємо, Ви успішно перерахували %1 бонусів до фонду %2"
			, Формат(СуммаБонусныхБаллов, "ЧДЦ=2; ЧРГ=; ЧН=0,00")
			, СокрЛП(Получатель)
		);
	//	Транслит.. SMS чёта не хочет отправляться..	
		ТекстСообщения = СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(ТекстСообщения);

	//	---------------------------------------------------------------------------------------
		ДанныеОтправителя = ОбщегоНазначенияКлиентСервер.СериализоватьJSON(Новый Структура(
				"ЭлементСтруктуры, Магазин, ИмяКомпьютера, Контрагент, Пользователь"
				, ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().ЭлементСтруктуры
				, ПараметрыСеанса.ТекущийМагазин
				, ИмяКомпьютера()
				, Контрагент
				, ПараметрыСеанса.ТекущийПользователь
			)
		);
		
		ЧтениеJSON = Новый ЧтениеJSON;

		Если ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

			ЧтениеJSON.УстановитьСтроку(СервисыСервер.SendSMS(ОбщегоНазначенияКлиентСервер.РеквизитПеречисления(Перечисления.ВидыСообщений.SMS)
					, НомерТелефона
					, ТекстСообщения
					, Ложь
					, ДанныеОтправителя
				)
			);

		Иначе

			Подключение = СервисыСервер.Подключение("RetailPack", СервисыСервер.Таймаут("RetailPack.SendSMS.Timeout"));
		
			ЧтениеJSON.УстановитьСтроку(Подключение.SendSMS(ОбщегоНазначенияКлиентСервер.РеквизитПеречисления(Перечисления.ВидыСообщений.SMS)
					, НомерТелефона
					, ТекстСообщения
					, Ложь
					, ДанныеОтправителя
				)
			);

		КонецЕсли;
	
		Результат = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();

		Если Результат.Ошибка Тогда

			Сообщить(Результат.ОписаниеОшибки);

		КонецЕсли;

	Иначе

		Результат = Новый Структура("Ошибка, ОписаниеОшибки", Истина, "Не указан номер телефона");

	КонецЕсли;

	Если Результат.Ошибка = Истина Тогда

		ЖурналСобытий.Регистрация("БОНУСЫ_НА_ФОНД", УровеньЖурналаРегистрации.Ошибка
			, Метаданные.Документы.НачислениеИСписаниеБонусныхБаллов
			, //ДокументОбъект.Ссылка
			,
			, Результат.ОписаниеОшибки
			,
			, Истина
			, Ложь
		);

	КонецЕсли;

	Возврат НЕ Результат.Ошибка;

КонецФункции

&НаСервереБезКонтекста
Процедура ЗафиксироватьОтправленноеСообщение(НомерТелефона, Контрагент, ТекстСообщения)

	Попытка

		ДанныеОповещения = Новый Структура(
			"НомерТелефона, ТекстСообщения, ДатаАннуляции"
			, НомерТелефона
			, ТекстСообщения
			, '00010101'
		);
		РегистрыСведений.ОповещенияКонтрагентов.Регистрация(Контрагент
			, ПредопределенноеЗначение("Перечисление.ВидыОповещений.ПередачаБонусов")
			, ДанныеОповещения
		);

	Исключение

		ЖурналСобытий.Регистрация("БОНУСЫ_НА_ФОНД", УровеньЖурналаРегистрации.Ошибка
			, Метаданные.Документы.НачислениеИСписаниеБонусныхБаллов
			, //ДокументОбъект.Ссылка
			,
			, ОписаниеОшибки()
			,
			, Истина
			, Ложь
		);

	КонецПопытки;

КонецПроцедуры

&НаКлиенте	//	LNK 22.09.2023 11:05:34
Процедура КомандаОтладкаSMS(Команда)

	ОтправитьСообщениеКонтрагенту(НомерТелефона, Контрагент, ФондБлаготворительный, СуммаБонусныхБаллов, "");	//	LNK 22.09.2023 09:54:58

КонецПроцедуры

#КонецОбласти



























