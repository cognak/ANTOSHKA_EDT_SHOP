#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура обновляет данные регистра при изменении конфигурации.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьДанныеРегистра(ЕстьИзменения = Неопределено, ТолькоПроверка = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВозможныеПраваОбъектовМетаданных = ВозможныеПраваОбъектовМетаданных();
	ПраваРолей = РегистрыСведений.ПраваРолей.СоздатьНаборЗаписей().Выгрузить();
	ОбъектОтсутствует = Ложь;
	
	Для каждого ВозможныеПрава Из ВозможныеПраваОбъектовМетаданных Цикл
		Для каждого ОбъектМетаданных Из Метаданные[ВозможныеПрава.Коллекция] Цикл
			
			Идентификатор = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектМетаданных);

		//	LNK 31.10.2016 12:28:49
			Если Идентификатор.Пустая() Тогда

				ОбъектОтсутствует = Истина;
				Продолжить;

			КонецЕсли;

			Поля = ВсеПоляОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных);
			
			Для каждого Роль Из Метаданные.Роли Цикл
				
				Если ПравоДоступа("Чтение", ОбъектМетаданных, Роль) Тогда

				//	LNK 19.10.2016 15:51:13
					ИдентификаторРоли = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Роль);

					Если НЕ ЗначениеЗаполнено(ИдентификаторРоли) Тогда

						ОбъектОтсутствует = Истина;
						Продолжить;

					КонецЕсли;

					НоваяСтрока = ПраваРолей.Добавить();
					
					НоваяСтрока.Роль              = ИдентификаторРоли;
					НоваяСтрока.ОбъектМетаданных  = Идентификатор;
					
					НоваяСтрока.Добавление = ВозможныеПрава.ПравоДобавления
					                       И ПравоДоступа("Добавление", ОбъектМетаданных, Роль);
					
					НоваяСтрока.Изменение  = ВозможныеПрава.ПравоИзменения
					                       И ПравоДоступа("Изменение", ОбъектМетаданных, Роль);
					
					НоваяСтрока.Удаление   = ВозможныеПрава.ПравоУдаления
					                       И ПравоДоступа("Удаление", ОбъектМетаданных, Роль);
					
					НоваяСтрока.ЧтениеБезОграничения =
						НЕ ПараметрыДоступа("Чтение",       ОбъектМетаданных, Поля, Роль).ОграничениеУсловием;
					
					НоваяСтрока.ДобавлениеБезОграничения =
						НоваяСтрока.Добавление
						И НЕ ПараметрыДоступа("Добавление", ОбъектМетаданных, Поля, Роль).ОграничениеУсловием;
					
					НоваяСтрока.ИзменениеБезОграничения =
						НоваяСтрока.Изменение
						И НЕ ПараметрыДоступа("Изменение",  ОбъектМетаданных, Поля, Роль).ОграничениеУсловием;
					
					НоваяСтрока.УдалениеБезОграничения =
						НоваяСтрока.Удаление
						И НЕ ПараметрыДоступа("Удаление",   ОбъектМетаданных, Поля, Роль).ОграничениеУсловием;
					
					НоваяСтрока.Просмотр = ПравоДоступа("Просмотр", ОбъектМетаданных, Роль);
					
					НоваяСтрока.Редактирование = ВозможныеПрава.ПравоИзменения
					                           И ПравоДоступа("Редактирование", ОбъектМетаданных, Роль);
					
					НоваяСтрока.ИнтерактивноеДобавление =
						ВозможныеПрава.ПравоДобавления
						И ПравоДоступа("ИнтерактивноеДобавление", ОбъектМетаданных, Роль);
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
	КонецЦикла;
	
//	LNK 31.10.2016 12:17:38
	Если ОбъектОтсутствует И НЕ ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

	//	В конфигурации появился новый объект метаданных. Но соответствующий ему элемент
	//	справочника "ИдентификаторыОбъектовМетаданных" ещё не приехал из ЦБ.
	//	Нужно позволить системе запуститься, иначе по коду ниже будет валиться в ошибку.
		Возврат;

	КонецЕсли;

	ТекстЗапросовВременныхТаблиц =
	"ВЫБРАТЬ
	|	НовыеДанные.ОбъектМетаданных,
	|	НовыеДанные.Роль,
	|	НовыеДанные.Добавление,
	|	НовыеДанные.Изменение,
	|	НовыеДанные.Удаление,
	|	НовыеДанные.ЧтениеБезОграничения,
	|	НовыеДанные.ДобавлениеБезОграничения,
	|	НовыеДанные.ИзменениеБезОграничения,
	|	НовыеДанные.УдалениеБезОграничения,
	|	НовыеДанные.Просмотр,
	|	НовыеДанные.ИнтерактивноеДобавление,
	|	НовыеДанные.Редактирование
	|ПОМЕСТИТЬ НовыеДанные
	|ИЗ
	|	&ПраваРолей КАК НовыеДанные";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НовыеДанные.ОбъектМетаданных,
	|	НовыеДанные.Роль,
	|	НовыеДанные.Добавление,
	|	НовыеДанные.Изменение,
	|	НовыеДанные.Удаление,
	|	НовыеДанные.ЧтениеБезОграничения,
	|	НовыеДанные.ДобавлениеБезОграничения,
	|	НовыеДанные.ИзменениеБезОграничения,
	|	НовыеДанные.УдалениеБезОграничения,
	|	НовыеДанные.Просмотр,
	|	НовыеДанные.ИнтерактивноеДобавление,
	|	НовыеДанные.Редактирование,
	|	&ПодстановкаПоляВидИзмененияСтроки
	|ИЗ
	|	НовыеДанные КАК НовыеДанные";
	
	// Подготовка выбираемых полей с необязательным отбором.
	Поля = Новый Массив;
	Поля.Добавить(Новый Структура("ОбъектМетаданных"));
	Поля.Добавить(Новый Структура("Роль"));
	Поля.Добавить(Новый Структура("Добавление"));
	Поля.Добавить(Новый Структура("Изменение"));
	Поля.Добавить(Новый Структура("Удаление"));
	Поля.Добавить(Новый Структура("ЧтениеБезОграничения"));
	Поля.Добавить(Новый Структура("ДобавлениеБезОграничения"));
	Поля.Добавить(Новый Структура("ИзменениеБезОграничения"));
	Поля.Добавить(Новый Структура("УдалениеБезОграничения"));
	Поля.Добавить(Новый Структура("Просмотр"));
	Поля.Добавить(Новый Структура("ИнтерактивноеДобавление"));
	Поля.Добавить(Новый Структура("Редактирование"));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПраваРолей", ПраваРолей);
	
	Запрос.Текст = УправлениеДоступомСлужебный.ТекстЗапросаВыбораИзменений(
		ТекстЗапроса, Поля, "РегистрСведений.ПраваРолей", ТекстЗапросовВременныхТаблиц);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыОграниченияДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПраваРолей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Изменения = Запрос.Выполнить().Выгрузить();
		
		УправлениеДоступомСлужебный.ОбновитьРегистрСведений(
			РегистрыСведений.ПраваРолей, Изменения, ЕстьИзменения, , , ТолькоПроверка);
		
		Если ТолькоПроверка Тогда
			ЗафиксироватьТранзакцию();
			Возврат;
		КонецЕсли;
		
		Изменения.Свернуть(
			"ОбъектМетаданных, Роль, Добавление, Изменение, Удаление", "ВидИзмененияСтроки");
		
		ЛишниеСтроки = Изменения.НайтиСтроки(Новый Структура("ВидИзмененияСтроки", 0));
		Для каждого Строка Из ЛишниеСтроки Цикл
			Изменения.Удалить(Строка);
		КонецЦикла;
		
		Изменения.Свернуть("ОбъектМетаданных");
		
		Если НЕ ТолькоПроверка Тогда
			ОбновлениеИнформационнойБазы.ДобавитьИзмененияПараметраРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"ОбъектыМетаданныхПравРолей",
				ОбщегоНазначения.ФиксированныеДанные(
					Изменения.ВыгрузитьКолонку("ОбъектМетаданных")));
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбновитьДанныеРегистра_ТИПОВАЯ(ЕстьИзменения = Неопределено, ТолькоПроверка = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТолькоПроверка ИЛИ МонопольныйРежим() Тогда
		СнятьМонопольныйРежим = Ложь;
	Иначе
		СнятьМонопольныйРежим = Истина;
		УстановитьМонопольныйРежим(Истина);
	КонецЕсли;
	
	ВозможныеПраваОбъектовМетаданных = ВозможныеПраваОбъектовМетаданных();
	ПраваРолей = РегистрыСведений.ПраваРолей.СоздатьНаборЗаписей().Выгрузить();
	ОбъектОтсутствует = Ложь;
	
	Для каждого ВозможныеПрава Из ВозможныеПраваОбъектовМетаданных Цикл
		Для каждого ОбъектМетаданных Из Метаданные[ВозможныеПрава.Коллекция] Цикл
			
			Идентификатор = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектМетаданных);

		//	LNK 31.10.2016 12:28:49
			Если Идентификатор.Пустая() Тогда

				ОбъектОтсутствует = Истина;
				Продолжить;

			КонецЕсли;

			Поля = ВсеПоляОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных);
			
			Для каждого Роль Из Метаданные.Роли Цикл
				
				Если ПравоДоступа("Чтение", ОбъектМетаданных, Роль) Тогда

				//	LNK 19.10.2016 15:51:13
					ИдентификаторРоли = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Роль);

					Если НЕ ЗначениеЗаполнено(ИдентификаторРоли) Тогда

						ОбъектОтсутствует = Истина;
						Продолжить;

					КонецЕсли;

					НоваяСтрока = ПраваРолей.Добавить();
					
					НоваяСтрока.Роль              = ИдентификаторРоли;
					НоваяСтрока.ОбъектМетаданных  = Идентификатор;
					
					НоваяСтрока.Добавление = ВозможныеПрава.ПравоДобавления
					                       И ПравоДоступа("Добавление", ОбъектМетаданных, Роль);
					
					НоваяСтрока.Изменение  = ВозможныеПрава.ПравоИзменения
					                       И ПравоДоступа("Изменение", ОбъектМетаданных, Роль);
					
					НоваяСтрока.Удаление   = ВозможныеПрава.ПравоУдаления
					                       И ПравоДоступа("Удаление", ОбъектМетаданных, Роль);
					
					НоваяСтрока.ЧтениеБезОграничения =
						НЕ ПараметрыДоступа("Чтение",       ОбъектМетаданных, Поля, Роль).ОграничениеУсловием;
					
					НоваяСтрока.ДобавлениеБезОграничения =
						НоваяСтрока.Добавление
						И НЕ ПараметрыДоступа("Добавление", ОбъектМетаданных, Поля, Роль).ОграничениеУсловием;
					
					НоваяСтрока.ИзменениеБезОграничения =
						НоваяСтрока.Изменение
						И НЕ ПараметрыДоступа("Изменение",  ОбъектМетаданных, Поля, Роль).ОграничениеУсловием;
					
					НоваяСтрока.УдалениеБезОграничения =
						НоваяСтрока.Удаление
						И НЕ ПараметрыДоступа("Удаление",   ОбъектМетаданных, Поля, Роль).ОграничениеУсловием;
					
					НоваяСтрока.Просмотр = ПравоДоступа("Просмотр", ОбъектМетаданных, Роль);
					
					НоваяСтрока.Редактирование = ВозможныеПрава.ПравоИзменения
					                           И ПравоДоступа("Редактирование", ОбъектМетаданных, Роль);
					
					НоваяСтрока.ИнтерактивноеДобавление =
						ВозможныеПрава.ПравоДобавления
						И ПравоДоступа("ИнтерактивноеДобавление", ОбъектМетаданных, Роль);
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
	КонецЦикла;
	
//	LNK 31.10.2016 12:17:38
	Если ОбъектОтсутствует И НЕ ОбменДаннымиПовтИсп.ЭтоГлавныйУзел() Тогда

	//	В конфигурации появился новый объект метаданных. Но соответствующий ему элемент
	//	справочника "ИдентификаторыОбъектовМетаданных" ещё не приехал из ЦБ.
	//	Нужно позволить системе запуститься, иначе по коду ниже будет валиться в ошибку.
		Возврат;

	КонецЕсли;

	ТекстЗапросовВременныхТаблиц =
	"ВЫБРАТЬ
	|	НовыеДанные.ОбъектМетаданных,
	|	НовыеДанные.Роль,
	|	НовыеДанные.Добавление,
	|	НовыеДанные.Изменение,
	|	НовыеДанные.Удаление,
	|	НовыеДанные.ЧтениеБезОграничения,
	|	НовыеДанные.ДобавлениеБезОграничения,
	|	НовыеДанные.ИзменениеБезОграничения,
	|	НовыеДанные.УдалениеБезОграничения,
	|	НовыеДанные.Просмотр,
	|	НовыеДанные.ИнтерактивноеДобавление,
	|	НовыеДанные.Редактирование
	|ПОМЕСТИТЬ НовыеДанные
	|ИЗ
	|	&ПраваРолей КАК НовыеДанные";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НовыеДанные.ОбъектМетаданных,
	|	НовыеДанные.Роль,
	|	НовыеДанные.Добавление,
	|	НовыеДанные.Изменение,
	|	НовыеДанные.Удаление,
	|	НовыеДанные.ЧтениеБезОграничения,
	|	НовыеДанные.ДобавлениеБезОграничения,
	|	НовыеДанные.ИзменениеБезОграничения,
	|	НовыеДанные.УдалениеБезОграничения,
	|	НовыеДанные.Просмотр,
	|	НовыеДанные.ИнтерактивноеДобавление,
	|	НовыеДанные.Редактирование,
	|	&ПодстановкаПоляВидИзмененияСтроки
	|ИЗ
	|	НовыеДанные КАК НовыеДанные";
	
	// Подготовка выбираемых полей с необязательным отбором.
	Поля = Новый Массив;
	Поля.Добавить(Новый Структура("ОбъектМетаданных"));
	Поля.Добавить(Новый Структура("Роль"));
	Поля.Добавить(Новый Структура("Добавление"));
	Поля.Добавить(Новый Структура("Изменение"));
	Поля.Добавить(Новый Структура("Удаление"));
	Поля.Добавить(Новый Структура("ЧтениеБезОграничения"));
	Поля.Добавить(Новый Структура("ДобавлениеБезОграничения"));
	Поля.Добавить(Новый Структура("ИзменениеБезОграничения"));
	Поля.Добавить(Новый Структура("УдалениеБезОграничения"));
	Поля.Добавить(Новый Структура("Просмотр"));
	Поля.Добавить(Новый Структура("ИнтерактивноеДобавление"));
	Поля.Добавить(Новый Структура("Редактирование"));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПраваРолей", ПраваРолей);
	
	Запрос.Текст = УправлениеДоступомСлужебный.ТекстЗапросаВыбораИзменений(
		ТекстЗапроса, Поля, "РегистрСведений.ПраваРолей", ТекстЗапросовВременныхТаблиц);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыОграниченияДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПраваРолей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Изменения = Запрос.Выполнить().Выгрузить();
		
		УправлениеДоступомСлужебный.ОбновитьРегистрСведений(
			РегистрыСведений.ПраваРолей, Изменения, ЕстьИзменения, , , ТолькоПроверка);
		
		Если ТолькоПроверка Тогда
			ЗафиксироватьТранзакцию();
			Возврат;
		КонецЕсли;
		
		Изменения.Свернуть(
			"ОбъектМетаданных, Роль, Добавление, Изменение, Удаление", "ВидИзмененияСтроки");
		
		ЛишниеСтроки = Изменения.НайтиСтроки(Новый Структура("ВидИзмененияСтроки", 0));
		Для каждого Строка Из ЛишниеСтроки Цикл
			Изменения.Удалить(Строка);
		КонецЦикла;
		
		Изменения.Свернуть("ОбъектМетаданных");
		
		Если НЕ ТолькоПроверка Тогда
			ОбновлениеИнформационнойБазы.ДобавитьИзмененияПараметраРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"ОбъектыМетаданныхПравРолей",
				ОбщегоНазначения.ФиксированныеДанные(
					Изменения.ВыгрузитьКолонку("ОбъектМетаданных")));
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Если СнятьМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	Если СнятьМонопольныйРежим Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Функция ВозможныеПраваОбъектовМетаданных()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПраваОбъектовМетаданных = Новый ТаблицаЗначений;
	ПраваОбъектовМетаданных.Колонки.Добавить("Коллекция");
	ПраваОбъектовМетаданных.Колонки.Добавить("КоллекцияВЕдЧисле");
	ПраваОбъектовМетаданных.Колонки.Добавить("ПравоДобавления");
	ПраваОбъектовМетаданных.Колонки.Добавить("ПравоИзменения");
	ПраваОбъектовМетаданных.Колонки.Добавить("ПравоУдаления");
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "Справочники";
	Строка.КоллекцияВЕдЧисле = "Справочник";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	Строка.ПравоУдаления     = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "Документы";
	Строка.КоллекцияВЕдЧисле = "Документ";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	Строка.ПравоУдаления     = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "ЖурналыДокументов";
	Строка.КоллекцияВЕдЧисле = "ЖурналДокументов";
	Строка.ПравоДобавления   = Ложь;
	Строка.ПравоИзменения    = Ложь;
	Строка.ПравоУдаления     = Ложь;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "ПланыВидовХарактеристик";
	Строка.КоллекцияВЕдЧисле = "ПланВидовХарактеристик";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	Строка.ПравоУдаления     = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "ПланыСчетов";
	Строка.КоллекцияВЕдЧисле = "ПланСчетов";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	Строка.ПравоУдаления     = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "ПланыВидовРасчета";
	Строка.КоллекцияВЕдЧисле = "ПланВидовРасчета";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	Строка.ПравоУдаления     = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "РегистрыСведений";
	Строка.КоллекцияВЕдЧисле = "РегистрСведений";
	Строка.ПравоДобавления   = Ложь;
	Строка.ПравоИзменения    = Истина;
	Строка.ПравоУдаления     = Ложь;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "РегистрыНакопления";
	Строка.КоллекцияВЕдЧисле = "РегистрНакопления";
	Строка.ПравоДобавления   = Ложь;
	Строка.ПравоИзменения    = Истина;
	Строка.ПравоУдаления     = Ложь;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "РегистрыБухгалтерии";
	Строка.КоллекцияВЕдЧисле = "РегистрБухгалтерии";
	Строка.ПравоДобавления   = Ложь;
	Строка.ПравоИзменения    = Истина;
	Строка.ПравоУдаления     = Ложь;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "РегистрыРасчета";
	Строка.КоллекцияВЕдЧисле = "РегистрРасчета";
	Строка.ПравоДобавления   = Ложь;
	Строка.ПравоИзменения    = Истина;
	Строка.ПравоУдаления     = Ложь;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "БизнесПроцессы";
	Строка.КоллекцияВЕдЧисле = "БизнесПроцесс";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	Строка.ПравоУдаления     = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "Задачи";
	Строка.КоллекцияВЕдЧисле = "Задача";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	Строка.ПравоУдаления     = Истина;
	
	Возврат ПраваОбъектовМетаданных;
	
КонецФункции

// Функция возвращает поля объекта метаданных по которым может ограничиваться доступ.
//
// Параметры:
//  ОбъектМетаданных   - ОбъектМетаданных
//  ОбъектИБ           - Неопределено, COMОбъект
//  ПолучитьМассивИмен - Булево
//
// Возвращаемое значение:
//  Строка (имен через запятую)
//  Если ПолучитьМассивИмен = Истина, тогда Массив строк.
//
Функция ВсеПоляОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных,
                                                   ОбъектИБ = Неопределено,
                                                   ПолучитьМассивИмен = Ложь)
	
	ИменаКоллекций = Новый Массив;
	ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	ИмяТипа = Лев(ПолноеИмя, Найти(ПолноеИмя, ".") - 1);
	
	Если      ИмяТипа = "Справочник" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "Документ" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "ЖурналДокументов" Тогда
		ИменаКоллекций.Добавить("Графы");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "ПланВидовХарактеристик" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "ПланСчетов" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("ПризнакиУчета");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		ИменаКоллекций.Добавить("СтандартныеТабличныеЧасти");
		
	ИначеЕсли ИмяТипа = "ПланВидовРасчета" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		ИменаКоллекций.Добавить("СтандартныеТабличныеЧасти");
		
	ИначеЕсли ИмяТипа = "РегистрСведений" Тогда
		ИменаКоллекций.Добавить("Измерения");
		ИменаКоллекций.Добавить("Ресурсы");
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "РегистрНакопления" Тогда
		ИменаКоллекций.Добавить("Измерения");
		ИменаКоллекций.Добавить("Ресурсы");
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "РегистрБухгалтерии" Тогда
		ИменаКоллекций.Добавить("Измерения");
		ИменаКоллекций.Добавить("Ресурсы");
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "РегистрРасчета" Тогда
		ИменаКоллекций.Добавить("Измерения");
		ИменаКоллекций.Добавить("Ресурсы");
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "БизнесПроцесс" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "Задача" Тогда
		ИменаКоллекций.Добавить("РеквизитыАдресации");
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
	КонецЕсли;
	
	ИменаПолей = Новый Массив;
	Если ОбъектИБ = Неопределено Тогда
		ТипХранилищеЗначения = Тип("ХранилищеЗначения");
	Иначе
		ТипХранилищеЗначения = ОбъектИБ.NewObject("ОписаниеТипов", "ХранилищеЗначения").Типы().Получить(0);
	КонецЕсли;

	Для каждого ИмяКоллекции Из ИменаКоллекций Цикл
		Если ИмяКоллекции = "ТабличныеЧасти"
		 ИЛИ ИмяКоллекции = "СтандартныеТабличныеЧасти" Тогда
			Для каждого ТабличнаяЧасть Из ОбъектМетаданных[ИмяКоллекции] Цикл
				ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, ТабличнаяЧасть.Имя, ИменаПолей, ОбъектИБ);
				Реквизиты = ?(ИмяКоллекции = "ТабличныеЧасти", ТабличнаяЧасть.Реквизиты, ТабличнаяЧасть.СтандартныеРеквизиты);
				Для каждого Поле Из Реквизиты Цикл
					Если Поле.Тип.СодержитТип(ТипХранилищеЗначения) Тогда
						Продолжить;
					КонецЕсли;
					ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, ТабличнаяЧасть.Имя + "." + Поле.Имя, ИменаПолей, ОбъектИБ);
				КонецЦикла;
				Если ИмяКоллекции = "СтандартныеТабличныеЧасти" И ТабличнаяЧасть.Имя = "ВидыСубконто" Тогда
					Для каждого Поле Из ОбъектМетаданных.ПризнакиУчетаСубконто Цикл
						ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, "ВидыСубконто." + Поле.Имя, ИменаПолей, ОбъектИБ);
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для каждого Поле Из ОбъектМетаданных[ИмяКоллекции] Цикл
	 			Если ИмяТипа = "ЖурналДокументов"       И Поле.Имя = "Тип"
	 			 ИЛИ ИмяТипа = "ПланВидовХарактеристик" И Поле.Имя = "ТипЗначения"
	 			 ИЛИ ИмяТипа = "ПланСчетов"             И Поле.Имя = "Вид"
	 			 ИЛИ ИмяТипа = "РегистрНакопления"      И Поле.Имя = "ВидДвижения"
	 			 ИЛИ ИмяТипа = "РегистрБухгалтерии"     И ИмяКоллекции = "СтандартныеРеквизиты" И Найти(Поле.Имя, "Субконто") > 0 Тогда
	 				Продолжить;
	 			КонецЕсли;
				Если ИмяКоллекции = "Графы" ИЛИ
					 Поле.Тип.СодержитТип(ТипХранилищеЗначения) Тогда
					Продолжить;
				КонецЕсли;
				Если (ИмяКоллекции = "Измерения" ИЛИ ИмяКоллекции = "Ресурсы")
				   И ?(ОбъектИБ = Неопределено, Метаданные, ОбъектИБ.Метаданные).РегистрыБухгалтерии.Содержит(ОбъектМетаданных)
				   И НЕ Поле.Балансовый Тогда
					// Дт
					ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, Поле.Имя + "Дт", ИменаПолей, ОбъектИБ);
					// Кт
					ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, Поле.Имя + "Кт", ИменаПолей, ОбъектИБ);
				Иначе
					ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, Поле.Имя, ИменаПолей, ОбъектИБ);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Если ПолучитьМассивИмен Тогда
		Возврат ИменаПолей;
	КонецЕсли;
	
	СписокПолей = "";
	Для каждого ИмяПоля Из ИменаПолей Цикл
		СписокПолей = СписокПолей + ", " + ИмяПоля;
	КонецЦикла;
	
	Возврат Сред(СписокПолей, 3);
	
КонецФункции

Процедура ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных,
                                                          ИмяПоля,
                                                          ИменаПолей,
                                                          ОбъектИБ)
	
	Попытка
		Если ОбъектИБ = Неопределено Тогда
			ПараметрыДоступа("Чтение", ОбъектМетаданных, ИмяПоля, Метаданные.Роли.ПолныеПрава);
		Иначе
			ОбъектИБ.ПараметрыДоступа(
				"Чтение",
				ОбъектМетаданных,
				ИмяПоля,
				ОбъектИБ.Метаданные.Роли.ПолныеПрава);
		КонецЕсли;
		ИменаПолей.Добавить(ИмяПоля);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

#КонецЕсли