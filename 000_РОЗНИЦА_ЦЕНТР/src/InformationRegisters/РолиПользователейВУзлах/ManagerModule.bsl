//	LNK 26.12.2016 13:17:19
Процедура ОбновитьИнформациюОРоляхПользователя()	Экспорт

	ДанныеЭтогоУзла = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла(ОбменДаннымиПовтИсп.ПолучитьЭтотУзелПоМагазинуИлиПоРабочемуМесту());

	Если НЕ ПустаяСтрока(ДанныеЭтогоУзла.Код) И НЕ ДанныеЭтогоУзла.ЭлементСтруктуры.Пустая() Тогда

		ПользовательИБ  = ПользователиИнформационнойБазы.ТекущийПользователь();

		ТаблицаИмен = Новый ТаблицаЗначений;
		ТаблицаИмен.Колонки.Добавить("ЭлементСтруктуры", Новый ОписаниеТипов("СправочникСсылка.СтруктураУзлов"));
		ТаблицаИмен.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));

		Если ПустаяСтрока(ПользовательИБ.Имя) Тогда

		//	Под пустым пользователем запускаются фоновые задания... почистим в этом режиме
		//	записи в регистре, оставшиеся от, возможно, удалённых пользователей ИБ.

			ТекстЗапроса = ТекстЗапросаУборкиРегистра();

			Для каждого ПользовательИБ Из ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл

				СтрокаРоли = ТаблицаИмен.Добавить();
				СтрокаРоли.ЭлементСтруктуры = ДанныеЭтогоУзла.ЭлементСтруктуры;
				СтрокаРоли.Имя  = ПользовательИБ.Имя;

			КонецЦикла;

		Иначе

		//	Пользователь ИБ авторизован. Пусть установит информацию о "своих" ролях.

			ТекстЗапроса = ТекстЗапросаАвторизованногоПользователя();

			ТаблицаИмен.Колонки.Добавить("Роль"   , Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));
			ТаблицаИмен.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200)));
			ТаблицаИмен.Колонки.Добавить("ДатаНазначения", Новый ОписаниеТипов("Дата"));

			ДатаНазначения = ТекущаяДатаСеанса();

			Для каждого Роль Из ПользовательИБ.Роли Цикл

				СтрокаРоли = ТаблицаИмен.Добавить();
				СтрокаРоли.ЭлементСтруктуры = ДанныеЭтогоУзла.ЭлементСтруктуры;
				СтрокаРоли.Имя     = ПользовательИБ.Имя;
				СтрокаРоли.Роль    = Роль.Имя;
				СтрокаРоли.Синоним = Роль.Синоним;
				СтрокаРоли.ДатаНазначения = ДатаНазначения;

			КонецЦикла;

		КонецЕсли;

		Если НЕ ТаблицаИмен.Количество() = 0 Тогда

			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.УстановитьПараметр("ТаблицаИмен", ТаблицаИмен);
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл

				МенеджерЗаписи = РегистрыСведений.РолиПользователейВУзлах.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);

				Если Выборка.Действие = "добавить" Тогда

						МенеджерЗаписи.Записать(Истина);

				Иначе	МенеджерЗаписи.Удалить();

				КонецЕсли;

			КонецЦикла;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Функция ТекстЗапросаУборкиРегистра()

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаИмен.ЭлементСтруктуры КАК ЭлементСтруктуры,
	|	ТаблицаИмен.Имя КАК Имя
	|ПОМЕСТИТЬ Роли
	|ИЗ
	|	&ТаблицаИмен КАК ТаблицаИмен
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЭлементСтруктуры,
	|	Имя
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РолиТекущие.ЭлементСтруктуры КАК ЭлементСтруктуры,
	|	РолиТекущие.Имя КАК Имя,
	|	РолиТекущие.Роль КАК Роль,
	|	""удалить"" КАК Действие
	|ИЗ
	|	РегистрСведений.РолиПользователейВУзлах КАК РолиТекущие
	|		ЛЕВОЕ СОЕДИНЕНИЕ Роли КАК РолиФильтр
	|		ПО РолиТекущие.ЭлементСтруктуры = РолиФильтр.ЭлементСтруктуры
	|			И РолиТекущие.Имя = РолиФильтр.Имя
	|ГДЕ
	|	РолиТекущие.ЭлементСтруктуры В
	|			(ВЫБРАТЬ
	|				Роли.ЭлементСтруктуры
	|			ИЗ
	|				Роли)
	|	И РолиФильтр.Имя ЕСТЬ NULL";

	Возврат ТекстЗапроса;

КонецФункции // ТекстЗапросаУборкиРегистра()

Функция ТекстЗапросаАвторизованногоПользователя()

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаИмен.ЭлементСтруктуры КАК ЭлементСтруктуры,
	|	ТаблицаИмен.Имя КАК Имя,
	|	ТаблицаИмен.Роль КАК Роль,
	|	ТаблицаИмен.Синоним КАК Синоним,
	|	ТаблицаИмен.ДатаНазначения КАК ДатаНазначения
	|ПОМЕСТИТЬ Роли
	|ИЗ
	|	&ТаблицаИмен КАК ТаблицаИмен
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЭлементСтруктуры,
	|	Имя,
	|	Роль
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РолиНовые.ЭлементСтруктуры КАК ЭлементСтруктуры,
	|	РолиНовые.Имя КАК Имя,
	|	РолиНовые.Роль КАК Роль,
	|	РолиНовые.Синоним КАК Синоним,
	|	РолиНовые.ДатаНазначения КАК ДатаНазначения,
	|	""добавить"" КАК Действие
	|ИЗ
	|	Роли КАК РолиНовые
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РолиПользователейВУзлах КАК РолиТекущие
	|		ПО РолиНовые.ЭлементСтруктуры = РолиТекущие.ЭлементСтруктуры
	|			И РолиНовые.Имя = РолиТекущие.Имя
	|			И РолиНовые.Роль = РолиТекущие.Роль
	|ГДЕ
	|	РолиТекущие.ЭлементСтруктуры ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	РолиТекущие.ЭлементСтруктуры,
	|	РолиТекущие.Имя,
	|	РолиТекущие.Роль,
	|	РолиТекущие.Синоним,
	|	РолиТекущие.ДатаНазначения,
	|	""удалить""
	|ИЗ
	|	РегистрСведений.РолиПользователейВУзлах КАК РолиТекущие
	|		ЛЕВОЕ СОЕДИНЕНИЕ Роли КАК РолиНовые
	|		ПО РолиТекущие.ЭлементСтруктуры = РолиНовые.ЭлементСтруктуры
	|			И РолиТекущие.Имя = РолиНовые.Имя
	|			И РолиТекущие.Роль = РолиНовые.Роль
	|ГДЕ
	|	РолиНовые.ЭлементСтруктуры ЕСТЬ NULL
	|	И (РолиТекущие.ЭлементСтруктуры, РолиТекущие.Имя) В
	|			(ВЫБРАТЬ
	|				Роли.ЭлементСтруктуры,
	|				Роли.Имя
	|			ИЗ
	|				Роли)";

	Возврат ТекстЗапроса;

КонецФункции
