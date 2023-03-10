//	LNK 21.04.2017 15:57:55
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда

		Если НЕ ЭтоНовый() И ЗначениеЗаполнено(ОбменДанными.Отправитель) Тогда

		//	Объект приехал откуда-то куда-то.

			Если ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

				ВосстановитьДанныеВГлавномУзле();

			Иначе

			//	В чём проблема - в узле "аналоге" заполняются следующие данные:
			//	Реквизиты шапки, "Пользователи", "РезервныеКопии", "СетевыеИнтерфейсы"

				ДанныеУзла = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла();

			//	Находимся именно в том узле, которому соответствует текущий элемент
				Если ДанныеУзла.ЭлементСтруктуры = Ссылка Тогда

					ВосстановитьДанныеВУзлеСоответствия();

				КонецЕсли;

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

//	LNK 25.04.2017 09:10:45
Процедура ВосстановитьДанныеВГлавномУзле()

//	Не помню, зачем были добавлены эти реквизиты шапки? Пока примем централизванное их назначение.
	УстановитьДанныеОбъектаПоСсылке(
	"ВЫБРАТЬ
	|	СтруктураУзлов.Account КАК Account,
	|	СтруктураУзлов.BaseName КАК BaseName,
	|	СтруктураУзлов.Password КАК Password,
	|	СтруктураУзлов.ServerAddress КАК ServerAddress,
	|	СтруктураУзлов.Алгоритмы.(
	|		Алгоритм КАК Алгоритм,
	|		ВыполнятьАлгоритм КАК ВыполнятьАлгоритм
	|	) КАК Алгоритмы,
	|	СтруктураУзлов.Магазины.(
	|		Магазин КАК Магазин
	|	) КАК Магазины
	|ИЗ
	|	Справочник.СтруктураУзлов КАК СтруктураУзлов
	|ГДЕ
	|	СтруктураУзлов.Ссылка = &Ссылка"
	);

КонецПроцедуры

//	LNK 21.04.2017 16:35:32
Процедура ВосстановитьДанныеВУзлеСоответствия()

	УстановитьДанныеОбъектаПоСсылке(
	"ВЫБРАТЬ
	|	СтруктураУзлов.Родитель,
	|	СтруктураУзлов.Код,
	|	СтруктураУзлов.Наименование,
	|	СтруктураУзлов.Версия,
	|	СтруктураУзлов.ВидУзла,
	|	СтруктураУзлов.КаталогФайловОбновления,
	|	СтруктураУзлов.КаталогФайловРезервныхКопий,
	|	СтруктураУзлов.Магазин,
	|	СтруктураУзлов.Пользователи.(
	|		Имя,
	|		ПолноеИмя,
	|		УникальныйИдентификатор
	|	),
	|	СтруктураУзлов.РезервныеКопии.(
	|		ИмяФайла,
	|		ДатаСоздания,
	|		ДатаИзменения
	|	),
	|	СтруктураУзлов.СетевыеИнтерфейсы.(
	|		Адрес,
	|		ДатаИзменения
	|	)
	|ИЗ
	|	Справочник.СтруктураУзлов КАК СтруктураУзлов
	|ГДЕ
	|	СтруктураУзлов.Ссылка = &Ссылка"
	);

КонецПроцедуры

//	LNK 25.04.2017 09:11:57
Процедура УстановитьДанныеОбъектаПоСсылке(ТекстЗапроса)

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда

		ТипРезультат = Новый ОписаниеТипов("РезультатЗапроса");
		Выборка = Результат.Выбрать();
		Выборка.Следующий();

		Для каждого Колонка Из Результат.Колонки Цикл

			Если Колонка.ТипЗначения = ТипРезультат Тогда

				ЭтотОбъект[Колонка.Имя].Загрузить(Выборка[Колонка.Имя].Выгрузить());

			Иначе

				ЭтотОбъект[Колонка.Имя] = Выборка[Колонка.Имя];
			
			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

