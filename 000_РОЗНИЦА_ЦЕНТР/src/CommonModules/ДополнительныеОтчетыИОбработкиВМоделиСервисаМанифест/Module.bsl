////////////////////////////////////////////////////////////////////////////////
// Работа с манифестом дополнительных отчетов и обработок
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Формирует манифест дополнительного отчета или обработки
//
// Параметры:
//  ОбъектОбработки - объект, значения свойств которого будет использоваться в
//    качестве значений свойств дополнительного отчета или обработки (предположительно
//    СправочникОбъект.ДополнительныеОтчетыИОбработки или
//    СправочникОбъект.ПоставляемыеДополнительныеОтчетыИОбработки,
//  ОбъектВерсии - объект, значения свойств которого будет использоваться в
//    качестве значений свойств версии дополнительного отчета или обработки (предположительно
//    СправочникОбъект.ДополнительныеОтчетыИОбработки или
//    СправочникОбъект.ПоставляемыеДополнительныеОтчетыИОбработки,
//  ВариантыОтчета - ТаблицаЗначений, колонки:
//    КлючВарианта - строка, ключ варианта дополнительного отчета,
//    Представление - строка, представление варианта дополнительного отчета,
//    Назначение - ТаблицаЗначений, колонки:
//      РазделИлиГруппа - строка, которой можно сопоставить элемент справочника
//        ИдентификаторыОбъектовМетаданных,
//      Важный - булево,
//      СмТакже - булево.
//
// Возвращаемое значение:
//  ОбъектXDTO {http://www.1c.ru/1cFresh/ApplicationExtensions/Manifest/a.b.c.d}ExtensionManifest -
//    манифест дополнительного отчета или обработки.
//
// Примечание:
//  Помимо кода БСП, данная функция может вызываться из внешней обработки
//   ПодготовкаДополнительныхОтчетовИОбработокКПубликацииВМоделиСервиса.epf, входящей
//   в комлект поставки менеджера сервиса. При изменении структуры параметров данной
//   функции необходимо актуализировать их и в данной внешней обработке.
//
Функция СформироватьМанифест(Знач ОбъектОбработки, Знач ОбъектВерсии, Знач ВариантыОтчета = Неопределено, Знач РасписанияКоманд = Неопределено, Знач РазрешенияОбработки = Неопределено) Экспорт
	
	Манифест = ФабрикаXDTO.Создать(
		ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипМанифест());
	
	Манифест.Name = ОбъектОбработки.Наименование;
	Манифест.ObjectName = ОбъектВерсии.ИмяОбъекта;
	Манифест.Version = ОбъектВерсии.Версия;
	Манифест.SafeMode = ОбъектВерсии.БезопасныйРежим;
	Манифест.Description = ОбъектВерсии.Информация;
	Манифест.FileName = ОбъектВерсии.ИмяФайла;
	Манифест.UseReportVariantsStorage = ОбъектВерсии.ИспользуетХранилищеВариантов;
	
	ВидXDTO = Неопределено;
	СловарьПреобразованияВидовОбработок =
		ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьВидыДополнительныхОтчетовИОбработок();
	Для Каждого ФрагментСловаря Из СловарьПреобразованияВидовОбработок Цикл
		Если ФрагментСловаря.Значение = ОбъектВерсии.Вид Тогда
			ВидXDTO = ФрагментСловаря.Ключ;
		КонецЕсли;
	КонецЦикла;
	Если ЗначениеЗаполнено(ВидXDTO) Тогда
		Манифест.Category = ВидXDTO;
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Вид дополнительных отчетов и обработок %1 не поддерживается в модели сервиса!'"),
			ОбъектВерсии.Вид);
	КонецЕсли;
	
	Если ОбъектВерсии.Команды.Количество() > 0 Тогда
		
		Если ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка Или
				ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
			
			// Обработка назначения разделам
			
			ВыбранныеРазделы = ОбъектВерсии.Разделы.Выгрузить();
			
			ВозможныеРазделы = Новый Массив;
			Если ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка Тогда
				ДополнительныеОтчетыИОбработкиПереопределяемый.ОпределитьРазделыСДополнительнымиОбработками(ВозможныеРазделы);
			Иначе
				ДополнительныеОтчетыИОбработкиПереопределяемый.ОпределитьРазделыСДополнительнымиОтчетами(ВозможныеРазделы);
			КонецЕсли;
			
			РабочийСтол = ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола();
			
			НазначениеXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеРазделам());
			
			Для Каждого Раздел Из ВозможныеРазделы Цикл
				
				Если Раздел = РабочийСтол Тогда
					ИмяРаздела = РабочийСтол;
					ИдентификаторОбъектаМетаданных = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
				Иначе
					ИмяРаздела = Раздел.ПолноеИмя();
					ИдентификаторОбъектаМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Раздел);
				КонецЕсли;
				ПредставлениеОбъектаМетаданных = ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(Раздел);
				
				ОбъектНазначенияXDTO = ФабрикаXDTO.Создать(
					ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипОбъектНазначения());
				ОбъектНазначенияXDTO.ObjectName = ИмяРаздела;
				ОбъектНазначенияXDTO.ObjectType = "SubSystem";
				ОбъектНазначенияXDTO.Representation = ПредставлениеОбъектаМетаданных;
				ОбъектНазначенияXDTO.Enabled = (
					ВыбранныеРазделы.Найти(
						ИдентификаторОбъектаМетаданных, "Раздел"
					) <> Неопределено
				);
				
				НазначениеXDTO.Objects.Добавить(ОбъектНазначенияXDTO);
				
			КонецЦикла;
			
		Иначе
			
			// Обработка назначения объектам метаданных
			
			ВыбранныеОбъектыНазначения = ОбъектВерсии.Назначение.Выгрузить();
			
			ВозможныеОбъектыНазначения = Новый Массив();
			Если ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта Тогда
				ОбщаяКоманда = Метаданные.ОбщиеКоманды.ДополнительныеОтчетыИОбработкиЗаполнениеОбъекта;
			ИначеЕсли ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Тогда
				ОбщаяКоманда = Метаданные.ОбщиеКоманды.ДополнительныеОтчетыИОбработкиОтчеты;
			ИначеЕсли ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма Тогда
				ОбщаяКоманда = Метаданные.ОбщиеКоманды.ДополнительныеОтчетыИОбработкиПечатныеФормы;
			ИначеЕсли ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов Тогда
				ОбщаяКоманда = Метаданные.ОбщиеКоманды.ДополнительныеОтчетыИОбработкиСозданиеСвязанныхОбъектов;
			КонецЕсли;
			Для Каждого ТипПараметраКоманды Из ОбщаяКоманда.ТипПараметраКоманды.Типы() Цикл
				ВозможныеОбъектыНазначения.Добавить(Метаданные.НайтиПоТипу(ТипПараметраКоманды));
			КонецЦикла;
			
			НазначениеXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеСправочникамИДокументам());
			
			Для Каждого ОбъектНазначения Из ВозможныеОбъектыНазначения Цикл
				
				ИдентификаторОбъектаМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектНазначения);
				
				ОбъектНазначенияXDTO = ФабрикаXDTO.Создать(
					ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипОбъектНазначения());
				ОбъектНазначенияXDTO.ObjectName = ОбъектНазначения.ПолноеИмя();
				Если ОбщегоНазначения.ЭтоСправочник(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "Catalog";
				ИначеЕсли ОбщегоНазначения.ЭтоДокумент(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "Document";
				ИначеЕсли ОбщегоНазначения.ЭтоБизнесПроцесс(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "BusinessProcess";
				ИначеЕсли ОбщегоНазначения.ЭтоЗадача(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "Task";
				КонецЕсли;
				ОбъектНазначенияXDTO.Representation = ОбъектНазначения.Представление();
				ОбъектНазначенияXDTO.Enabled = (
					ВыбранныеОбъектыНазначения.Найти(
						ИдентификаторОбъектаМетаданных, "ОбъектНазначения"
					) <> Неопределено
				);
				
				НазначениеXDTO.Objects.Добавить(ОбъектНазначенияXDTO);
				
			КонецЦикла;
			
			НазначениеXDTO.UseInListsForms = ОбъектВерсии.ИспользоватьДляФормыСписка;
			НазначениеXDTO.UseInObjectsForms = ОбъектВерсии.ИспользоватьДляФормыОбъекта;
			
		КонецЕсли;
		
		Манифест.Assignment = НазначениеXDTO;
		
		Для Каждого ОписаниеКоманды Из ОбъектВерсии.Команды Цикл
			
			КомандаXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипКоманда());
			КомандаXDTO.Id = ОписаниеКоманды.Идентификатор;
			КомандаXDTO.Representation = ОписаниеКоманды.Представление;
			
			ТипЗапускаXDTO = Неопределено;
			СловарьПреобразованияСпособовВызова =
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьСпособыВызоваДополнительныхОтчетовИОбработок();
			Для Каждого ФрагментСловаря Из СловарьПреобразованияСпособовВызова Цикл
				Если ФрагментСловаря.Значение = ОписаниеКоманды.ВариантЗапуска Тогда
					ТипЗапускаXDTO = ФрагментСловаря.Ключ;
				КонецЕсли;
			КонецЦикла;
			Если ЗначениеЗаполнено(ТипЗапускаXDTO) Тогда
				КомандаXDTO.StartupType = ТипЗапускаXDTO;
			Иначе
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Способ запуска дополнительных отчетов и обработок %1 не поддерживается в модели сервиса!'"),
					ОписаниеКоманды.ВариантЗапуска);
			КонецЕсли;
			
			КомандаXDTO.ShowNotification = ОписаниеКоманды.ПоказыватьОповещение;
			КомандаXDTO.Modifier = ОписаниеКоманды.Модификатор;
			
			Если ЗначениеЗаполнено(РасписанияКоманд) Тогда
				
				РасписаниеКоманды = Неопределено;
				Если РасписанияКоманд.Свойство(ОписаниеКоманды.Идентификатор, РасписаниеКоманды) Тогда
					
					КомандаXDTO.DefaultSettings = ФабрикаXDTO.Создать(
						ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНастройкиКоманды()
					);
					
					КомандаXDTO.DefaultSettings.Schedule = СериализаторXDTO.ЗаписатьXDTO(РасписаниеКоманды);
					
				КонецЕсли;
				
			КонецЕсли;
			
			Манифест.Commands.Добавить(КомандаXDTO);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВариантыОтчета) Тогда
		
		Для Каждого ВариантОтчета Из ВариантыОтчета Цикл
			
			ВариантXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипВариантОтчета());
			ВариантXDTO.VariantKey = ВариантОтчета.КлючВарианта;
			ВариантXDTO.Representation = ВариантОтчета.Представление;
			
			Если ВариантОтчета.Назначение <> Неопределено Тогда
				
				Для Каждого НазначениеВариантаОтчета Из ВариантОтчета.Назначение Цикл
					
					НазначениеXDTO = ФабрикаXDTO.Создать(
						ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеВариантаОтчета());
					
					НазначениеXDTO.ObjectName = НазначениеВариантаОтчета.ПолноеИмя;
					НазначениеXDTO.Representation = НазначениеВариантаОтчета.Представление;
					НазначениеXDTO.Parent = НазначениеВариантаОтчета.ПолноеИмяРодителя;
					НазначениеXDTO.Enabled = НазначениеВариантаОтчета.Использование;
					
					Если НазначениеВариантаОтчета.Важный Тогда
						НазначениеXDTO.Importance = "High";
					ИначеЕсли НазначениеВариантаОтчета.СмТакже Тогда
						НазначениеXDTO.Importance = "Low";
					Иначе
						НазначениеXDTO.Importance = "Ordinary";
					КонецЕсли;
					
					ВариантXDTO.Assignments.Добавить(НазначениеXDTO);
					
				КонецЦикла;
				
			КонецЕсли;
			
			Манифест.ReportVariants.Добавить(ВариантXDTO);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если РазрешенияОбработки = Неопределено Тогда
		
		РазрешенияОбработки = ОбъектОбработки.Разрешения;
		
	КонецЕсли;
	
	Для Каждого Разрешение Из РазрешенияОбработки Цикл
		
		Если ТипЗнч(Разрешение) = Тип("ОбъектXDTO") Тогда
			
			Манифест.Permissions.Добавить(Разрешение);
			
		Иначе
			
			РазрешениеXDTO = ФабрикаXDTO.Создать(
				ФабрикаXDTO.Тип(
					ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.Пакет(),
					Разрешение.ВидРазрешения
				)
			);
			
			Параметры = Разрешение.Параметры.Получить();
			Если Параметры <> Неопределено Тогда
				
				Для Каждого Параметр Из Параметры Цикл
					
					РазрешениеXDTO[Параметр.Ключ] = Параметр.Значение;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Манифест.Permissions.Добавить(РазрешениеXDTO);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Манифест;
	
КонецФункции

// Заполняет переданные объекты данными, считываемыми из манифеста дополнительного
//  отчета или обработки.
//
// Параметры:
//  Манифест - ОбъектXDTO {http://www.1c.ru/1cFresh/ApplicationExtensions/Manifest/a.b.c.d}ExtensionManifest - манифест
//    дополнительного отчета или обработки,
//  ОбъектОбработки - объект, значения свойств которого будет установлены
//    значениями свойств дополнительного отчета или обработки из манифеста (предположительно
//    СправочникОбъект.ДополнительныеОтчетыИОбработки или
//    СправочникОбъект.ПоставляемыеДополнительныеОтчетыИОбработки,
//  ОбъектВерсии - объект, значения свойств которого будет установлены
//    значениями свойств версии дополнительного отчета или обработки из манифеста (предположительно
//    СправочникОбъект.ДополнительныеОтчетыИОбработки или
//    СправочникОбъект.ПоставляемыеДополнительныеОтчетыИОбработки,
//  ВариантыОтчета - ТаблицаЗначений, колонки:
//    КлючВарианта - строка, ключ варианта дополнительного отчета,
//    Представление - строка, представление варианта дополнительного отчета,
//    Назначение - ТаблицаЗначений, колонки:
//      РазделИлиГруппа - строка, которой можно сопоставить элемент справочника
//        ИдентификаторыОбъектовМетаданных,
//      Важный - булево,
//      СмТакже - булево.
//
Процедура ПрочитатьМанифест(Знач Манифест, ОбъектОбработки, ОбъектВерсии, ВариантыОтчета) Экспорт
	
	ОбъектОбработки.Наименование = Манифест.Name;
	ОбъектВерсии.ИмяОбъекта = Манифест.ObjectName;
	ОбъектВерсии.Версия = Манифест.Version;
	ОбъектВерсии.БезопасныйРежим = Манифест.SafeMode;
	ОбъектВерсии.Информация = Манифест.Description;
	ОбъектВерсии.ИмяФайла = Манифест.FileName;
	ОбъектВерсии.ИспользуетХранилищеВариантов = Манифест.UseReportVariantsStorage;
	
	СловарьПреобразованияВидовОбработок = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьВидыДополнительныхОтчетовИОбработок();
	ОбъектВерсии.Вид = СловарьПреобразованияВидовОбработок[Манифест.Category];
	
	ОбъектВерсии.Команды.Очистить();
	Для Каждого Command Из Манифест.Commands Цикл
		
		СтрокаКоманды = ОбъектВерсии.Команды.Добавить();
		СтрокаКоманды.Идентификатор = Command.Id;
		СтрокаКоманды.Представление = Command.Representation;
		СтрокаКоманды.ПоказыватьОповещение = Command.ShowNotification;
		СтрокаКоманды.Модификатор = Command.Modifier;
		
		СловарьПреобразованияСпособовВызова =
			ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьСпособыВызоваДополнительныхОтчетовИОбработок();
		СтрокаКоманды.ВариантЗапуска = СловарьПреобразованияСпособовВызова[Command.StartupType];
		
	КонецЦикла;
	
	ОбъектВерсии.Разрешения.Очистить();
	Для Каждого Permission Из Манифест.Permissions Цикл
		
		ТипXDTO = Permission.Тип();
		
		Разрешение = ОбъектВерсии.Разрешения.Добавить();
		Разрешение.ВидРазрешения = ТипXDTO.Имя;
		
		Параметры = Новый Структура();
		
		Для Каждого СвойствоXDTO Из ТипXDTO.Свойства Цикл
			
			Контейнер = Permission.ПолучитьXDTO(СвойствоXDTO.Имя);
			
			Если Контейнер <> Неопределено Тогда
				Параметры.Вставить(СвойствоXDTO.Имя, Контейнер.Значение);
			Иначе
				Параметры.Вставить(СвойствоXDTO.Имя);
			КонецЕсли;
			
		КонецЦикла;
		
		Разрешение.Параметры = Новый ХранилищеЗначения(Параметры);
		
	КонецЦикла;
	
КонецПроцедуры