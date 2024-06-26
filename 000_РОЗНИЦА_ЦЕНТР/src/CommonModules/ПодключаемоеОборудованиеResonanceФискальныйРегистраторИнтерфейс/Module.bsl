#Область ПодключениеОтключение

Функция Подключить(ОбъектДрайвера, Параметры) Экспорт

	Перем Порт, Скорость, Модель;

	Параметры.Свойство("Порт"	 , Порт);
	Параметры.Свойство("Скорость", Скорость);
	Параметры.Свойство("Модель"	 , Модель);

	Результат = Истина;

//	Проверка параметров
	Если Порт = Неопределено ИЛИ Скорость = Неопределено Тогда

		Результат = Ложь;

	Иначе

	//	Начало работы с «Resonance OLE Manager»

	//	Если НЕ ОбъектДрайвера.Init(Порт, СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(ПользователиКлиентСервер.ТекущийПользователь())) = 1 Тогда
		Если НЕ ОбъектДрайвера.Init(Порт, СокрЛП(ПользователиКлиентСервер.ТекущийПользователь())) = 1 Тогда
			
		//	Проблема.. завершение работы с «Resonance OLE Manager»
			ОбъектДрайвера.Done();

			Результат = Ложь;

		ИначеЕсли ТипЗнч(Скорость) = Тип("Число") Тогда

			Значение = СписокСкоростейПорта().Получить(Скорость);

			Если НЕ Значение = Неопределено Тогда

				ОбъектДрайвера.SerialPortRate = Значение;

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьОшибку(ОбъектДрайвера, ОписаниеОшибки) Экспорт
	
	ОписаниеОшибки = ОбъектДрайвера.LastErrorMessage;

	Возврат ОбъектДрайвера.LastErrorCode;
	
КонецФункции

Функция Отключить(ОбъектДрайвера) Экспорт
	
//	Отключение устройства.
	ОбъектДрайвера.Done();
	
КонецФункции

#КонецОбласти

#Область РаботаСФискальнымЧеком

Функция ОткрытьЧек(ОбъектДрайвера, ФискальныйЧек, ЧекВозврата,  АннулироватьОткрытыйЧек, НомерЧека, НомерСмены) Экспорт

	Результат  = Истина;

	Если ФискальныйЧек Тогда

	//	Открытие фискального чека ФР

		Если НЕ ЧекВозврата = Истина Тогда

			Успешно = ОбъектДрайвера.OpenCheck() = 1;

		Иначе

			Успешно = ОбъектДрайвера.OpenReturnCheck() = 1;

		КонецЕсли;

	Иначе

	//	Открытие нефискального (чека комментариев) ФР
		Успешно = ОбъектДрайвера.OpenTextDocument() = 1;

	КонецЕсли;

	Если НЕ Успешно Тогда 

		Результат = Ложь;

	Иначе

		НомерСмены = ОбъектДрайвера.NextZNumber;			//	Получение номера смены фискального регистратора (номер Z-отчета)
		НомерЧека  = ОбъектДрайвера.LastCheckNumber + 1;	//	Получение номера последнего фискального чека плюс 1 - текущий номер

	КонецЕсли;

	Возврат Результат;
	
КонецФункции

Функция ЗакрытьЧек(ОбъектДрайвера, НаличнаяОплата, ОплатаКартой, ОплатаКредитом, ОплатаСертификатом, ОплатаПослеплата, ФискальныйЧек, СлужебнаяИнформация = Неопределено) Экспорт
	
	Результат  = Истина;

	Если ФискальныйЧек Тогда

	//	Выполнение оплат только для фискального чека

		Если НЕ СлужебнаяИнформация = Неопределено Тогда

			Для НомерСтроки = 1 По СтрЧислоСтрок(СлужебнаяИнформация) Цикл

				ТекстСообщения = СтрПолучитьСтроку(СлужебнаяИнформация, НомерСтроки);

				Успешно = ОбъектДрайвера.FreeTextLine(0, 0, 0, ТекстСообщения) = 1;

				Если НЕ Успешно Тогда 

					Результат = Ложь;

					Возврат Результат;

				КонецЕсли;

			КонецЦикла;

		КонецЕсли; 
		
		// ОПЛАТА НАЛИЧНЫМ ТИПОМ
		Если НЕ УстановитьОплату(НаличнаяОплата, 0, ОбъектДрайвера) Тогда

			Возврат Ложь;

		КонецЕсли;
		
	//	ОПЛАТА БЕЗНАЛИЧНЫМ ТИПОМ
		Если НЕ УстановитьОплату(ОплатаКредитом, 1, ОбъектДрайвера) Тогда

			Возврат Ложь;

		КонецЕсли;
		
	//	ОПЛАТА БЕЗНАЛИЧНЫМ ТИПОМ
		Если НЕ УстановитьОплату(ОплатаСертификатом, 2, ОбъектДрайвера) Тогда

			Возврат Ложь;

		КонецЕсли;

	//	ОПЛАТА БЕЗНАЛИЧНЫМ ТИПОМ
		Если НЕ УстановитьОплату(ОплатаКартой, 3, ОбъектДрайвера) Тогда

			Возврат Ложь;

		КонецЕсли;

	//	ОПЛАТА БЕЗНАЛИЧНЫМ ТИПОМ
		Если НЕ УстановитьОплату(ОплатаПослеплата, 4, ОбъектДрайвера) Тогда

			Возврат Ложь;

		КонецЕсли;

		Успешно = НЕ ОбъектДрайвера.CloseCheck() = 0;		//	Закрытие фискального чека

	Иначе

		Успешно = ОбъектДрайвера.CloseTextDocument() = 1;	//	Закрытие нефискального чека (чека комментариев)

	КонецЕсли;

	Если НЕ Успешно Тогда 

		Результат = Ложь;

	КонецЕсли;

	Возврат Результат;
	
КонецФункции
														
Функция ОтменитьЧек(ОбъектДрайвера) Экспорт
	
	Результат  = Истина;

//	Аннулировать чек
	Результат = ОбъектДрайвера.AbortCheck();

	Возврат Результат;
	
КонецФункции

Функция НапечататьФискСтроку(ОбъектДрайвера, Наименование, Количество, Цена, Сумма, НомерСекции, НДС, ДопРеквизиты, Параметры) Экспорт

	ТаблицаСоответствий = Новый Массив;

	Результат = Истина;
	
	СуммоваяСкидка    = Окр(Количество * Цена - Сумма, 2);
	НаправлениеСкидки = ?(СуммоваяСкидка < 0, 1, ?(СуммоваяСкидка > 0, 0, -1));
	НазваниеСкидки    = "";	//	можно чемнить заполнить.
	НалоговаяГруппа   = 0;

	ДопРеквизиты = МенеджерОборудованияСервер.ПолучитьТаблицуДопРеквизитов(ДопРеквизиты);
	
	Параметры.Свойство("ТаблицаСоответствийНалоговыхГрупп", ТаблицаСоответствий);

	Для каждого Строка из ТаблицаСоответствий Цикл

		Если Строка[1] = ДопРеквизиты[0] И Строка[2] = ДопРеквизиты[1] Тогда

			НалоговаяГруппа = Строка[0];
			Прервать;

		КонецЕсли;

	КонецЦикла;

//	Печать строки чека
	Результат = НЕ ОбъектДрайвера.FiscalLineEx(
		  Наименование
		, Количество
		, Цена * 100
		, 0
		, НалоговаяГруппа
		, 0
		, 0
		, НаправлениеСкидки
		, НазваниеСкидки
		, ОбщегоНазначенияКлиентСервер.АБС(СуммоваяСкидка * 100)) = 0;
		
//	int FiscalLineEx(
//		  string название
//		, int количество
//		, int цена
//		, int делимость
//		, int налог1
//		, int налог2
//		, int код_артикула opt
//		, int направление_скидки opt
//		, string название_скидки opt
//		, int сумма_скидки opt)

//	Параметры
//		название: название товара
//		количество: количество в штуках или граммах (см. параметр GoodsDividual). При желании не печатать явно единичное количество товара, укажите значение параметра 0
//		цена: цена в копейках
//		делимость: делимость товара. 0 - неделимый товар, параметр Qty интерпретируется как "штуки", 1 - делимый товар, параметр Qty интерпретируется как "граммы"
//		налог1: номер схемы налогообложения товара (1-8, или 0, если не подлежит налогообложению)
//		налог2: дополнительная схема налогообложения (0-8)
//		код_артикула: код артикула (1..999999999) (при указании значений 0 или null используется автоматическое назначение кода) (необязательный параметр)
//		направление_скидки: направление скидки. значения: -1/0/1 – нет_скидки/скидка/надбавка (необязательный параметр)
//		название_скидки: название скидки (необязательный параметр)
//		сумма_скидки: сумма скидки в копейках (необязательный параметр)

//		Возвращаемое значение: Сумму в копейках по данной строке чека в случае успеха, 0 в случае неудачи

	Возврат Результат;
	
КонецФункции
	
#КонецОбласти

#Область ФискальныеОтчеты

Функция НапечататьОтчетБезГашения(ОбъектДрайвера) Экспорт

	Результат = Истина;

//	Печать X-отчёта фискального регистратора
	Успешно = ОбъектДрайвера.XReport() = 1;

	Если НЕ Успешно Тогда

		Результат = Ложь;
	Иначе

		НомерСмены = ОбъектДрайвера.NextZNumber;		//	Получение номера смены фискального регистратора (номер Z-отчета)
		НомерЧека  = ОбъектДрайвера.LastCheckNumber;	//	Получение номера последнего фискального чека

	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НапечататьОтчетСГашением(ОбъектДрайвера) Экспорт
	
	Результат = Истина;

//	Снятие Z-отчёта фискального регистратора
    Успешно = ОбъектДрайвера.CloseBusinessDay() = 1;

	Если НЕ Успешно Тогда 

		Результат = Ложь;

	Иначе

		НомерСмены = ОбъектДрайвера.NextZNumber;		//	Получение номера смены фискального регистратора (номер Z-отчета)
		НомерЧека  = ОбъектДрайвера.LastCheckNumber;	//	Получение номера последнего фискального чека

	КонецЕсли;

	Возврат Результат;
	
КонецФункции
	
#КонецОбласти

#Область РаботаСДисплеемПокупателя

Функция ВывестиИнформациюНаДисплейПокупателя(ОбъектДрайвера, Параметры, ТекстПолей, Сумма) Экспорт

	Результат  = Ложь;
	ДлинаПоля  = 16;
	ЧислоСтрок = СтрЧислоСтрок(ТекстПолей);

	Если НЕ Сумма = 0 И НЕ ПустаяСтрока(Сумма) И НЕ Сумма = "0.00"  Тогда

			СуммаТекст = Формат(Сумма, "ЧДЦ=2; ЧН=0.00; ЧГ=");

	Иначе	СуммаТекст = "";
	
	КонецЕсли;

	Если ЧислоСтрок = 1 И СуммаТекст = "" Тогда

		ОчиститьДисплейПокупателя(ОбъектДрайвера);
		Результат = ВывестиСтрокуНаДисплей(2, СтрПолучитьСтроку(ТекстПолей, 1), ДлинаПоля,, ОбъектДрайвера);

	ИначеЕсли ЧислоСтрок = 1 И НЕ ПустаяСтрока(СуммаТекст) Тогда

		Результат = ВывестиСтрокуНаДисплей(1, СтрПолучитьСтроку(ТекстПолей, 1), ДлинаПоля,, ОбъектДрайвера)
				  И ВывестиСтрокуНаДисплей(2, СуммаТекст, ДлинаПоля, Истина, ОбъектДрайвера);

	Иначе

		Результат = ВывестиСтрокуНаДисплей(1, СтрПолучитьСтроку(ТекстПолей, 1), ДлинаПоля,, ОбъектДрайвера)
				  И ВывестиСтрокуНаДисплей(2, СтрПолучитьСтроку(ТекстПолей, 2), ДлинаПоля,, ОбъектДрайвера);

	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция ОчиститьДисплейПокупателя(ОбъектДрайвера) Экспорт

	Результат = Ложь;

	МассивСтрок = ОбъектДрайвера.Passthrough("DISP");

	Для каждого Команда Из МассивСтрок Цикл

		Если Команда = "DONE" Тогда

			Результат = Истина;
			Прервать;

		КонецЕсли;

	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция ВывестиСтрокуНаДисплей(Ряд, Знач ТекстПоля, ДлинаПоля, ЭтоСумма = Ложь, ОбъектДрайвера)

//	Результат = ОбъектДрайвера.PutToDisplay(ТекстПоля, Сумма) = 1;
//	ОбъектДрайвера.PutSumToDisplay(100, 3)
//	ОбъектДрайвера.PutToDisplay("ВАРТІСТЬ", "300") "ВАРТІСТЬ"/"СУМА"/"ЗДАЧА"
//	ОбъектДрайвера.Passthrough("DISP1ПЕТЯ")

	Результат = Ложь;

	Если ЭтоСумма Тогда

		ТекстПоля = ОбщегоНазначенияКлиентСервер.PAD(СокрЛП(ТекстПоля) + " грн", ДлинаПоля, Истина,, Истина);

	КонецЕсли;

	МассивСтрок = ОбъектДрайвера.Passthrough("DISP" + Ряд + ТекстПоля);

	Для каждого Команда Из МассивСтрок Цикл

		Если Команда = "DONE" Тогда

			Результат = Истина;
			Прервать;

		КонецЕсли;

	КонецЦикла;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ПечатьПериодическихОтчетов

Функция НапечататьПериодическийОтчетПоДатам(ОбъектДрайвера, ПериодНачало, ПериодКонец, Сокращенный) Экспорт

	ФорматДаты = "ДФ=дд/ММ/гг";

	ДатаНачала    = Формат(ПериодНачало, ФорматДаты);
	ДатаОкончания = Формат(ПериодКонец , ФорматДаты);

	Результат = ОбъектДрайвера.PeriodicalFiscalReportDateEx(ДатаНачала, ДатаОкончания, НЕ Сокращенный) = 1;

	Возврат Результат;
	
КонецФункции

Функция НапечататьПериодическийОтчетПоНомерам(ОбъектДрайвера, НомерНачало, НомерКонец, Сокращенный) Экспорт

	Результат = ОбъектДрайвера.PeriodicalFiscalReportEx(НомерНачало, НомерКонец, НЕ Сокращенный) = 1;

	Возврат Результат;
	
КонецФункции

Функция НапечататьОтчетОПроданныхТоварах(ОбъектДрайвера) Экспорт

	Результат = ОбъектДрайвера.ArticleReport() = 1;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ПрочиеМетоды

Функция НапечататьНулевойЧек(ОбъектДрайвера) Экспорт

	Результат  = Истина;

	Результат = ОбъектДрайвера.NullCheck() = 1;

	Возврат Результат;

КонецФункции
																										
Функция НапечататьНефискСтроку(ОбъектДрайвера, СтрокаТекста, НомерШрифта) Экспорт
	
	Результат = Истина;

	Результат = ОбъектДрайвера.FreeTextLine(0, 0, НомерШрифта, СтрокаТекста) = 1;

	Возврат Результат;
	
КонецФункции

Функция НапечататьЧекВнесенияВыемки(ОбъектДрайвера, ТипИнкассации, Сумма) Экспорт

	Результат  = Истина;

//	"ТипИнкассации" - 0/1 - изъятие/внесение
//	"Сумма" - сумма в копейках.
	Результат = ОбъектДрайвера.MoveCash(ТипИнкассации, Сумма * 100) = 1;

	Возврат Результат;
	
КонецФункции

Функция НапечататьШтрихКод(ОбъектДрайвера, ТипШтрихКода, Штрихкод) Экспорт

	Если ТипШтрихКода = "EAN13" Тогда

		Формат = 1; // 1 - EAN13

	Иначе

		Формат = 2; // 2 - CODE128

	КонецЕсли;

	ТекстКодов  = "PCOD" + "1" + "0" + ?(Формат = 1, Символ(69), "C") + ?(Формат = 1, "", Символ(103)) + Штрихкод;
	МассивСтрок = ОбъектДрайвера.Passthrough(ТекстКодов);

	Для каждого Команда Из МассивСтрок Цикл

		Если Команда = "DONE" Тогда

			Результат = Истина;
			Прервать;

		КонецЕсли;

	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция ОткрытьДенежныйЯщик(ОбъектДрайвера) Экспорт

	Результат  = Истина;

//	Открытие денежного ящика (сейфа)
	Результат = ОбъектДрайвера.OpenCashBox() = 1;

	Возврат Результат;
	
КонецФункции

Функция ПолучитьШиринуСтроки(ОбъектДрайвера, ШиринаСтроки) Экспорт

	ШиринаСтроки = 34;

	Возврат Истина;

КонецФункции

Функция НапечататьQRКод(ОбъектДрайвера, ДанныеКода, РазмерКода, Коррекция)	Экспорт

//	int PrintQR ( string data , int size opt , int error_correction_level opt )
//		Печатает QR-код на чеке
//	Параметры
//		data: текст для кодирования и печати
//		size: размер QR-кода (10..100) при печати, в процентах от ширины бумаги (по-умолчанию: 67%) (необязательный параметр)
//		error_correction_level: уровень коррекции ошибок (значения: 1(7%),2(15%),3(25%),4(30%) или 7,15,25,30) (необязательный параметр)
//	Возвращаемое значение: 1 в случае успеха, 0 в случае ошибки

	Результат = 0;

	Если Коррекция = Неопределено Тогда

			Результат = ОбъектДрайвера.PrintQR(ДанныеКода, РазмерКода);

	Иначе	Результат = ОбъектДрайвера.PrintQR(ДанныеКода, РазмерКода, Коррекция);

	КонецЕсли;

	Возврат Результат = 1;

КонецФункции

#КонецОбласти

#Область СервисныеМетоды

Функция ТестУстройства(ОбъектДрайвера, РезультатТеста, Параметры) Экспорт

	Результат = Подключить(ОбъектДрайвера, Параметры);

	Если НЕ Результат Тогда

		ПолучитьОшибку(ОбъектДрайвера, РезультатТеста);

	КонецЕсли;
	
	Отключить(ОбъектДрайвера);

	Возврат Результат;

КонецФункции

Функция ПолучитьНомерВерсии(ОбъектДрайвера)	Экспорт

//	Возврат "4.1.20191004";
	Возврат ОбъектДрайвера.Version;

КонецФункции

Функция ПолучитьОписание(ОбъектДрайвера, Наименование, Описание, ТипОборудования, РевизияИнтерфейса, ИнтеграционнаяБиблиотека, ОсновнойДрайверУстановлен, ПолучитьURLCкачивания) Экспорт

	Наименование    = "Резонанс: OLE manager для фискальных регистраторов";
	Описание        = "OLE-automation сервер предназначен для работы с ЭККА «Мария-301MTM» T7-T11, «Мария-M304» в операционных системах MS Windows";
	ТипОборудования = "ФискальныйРегистратор";
	ИнтеграционнаяБиблиотека = "Resonance.OLEManager.dll";
	РевизияИнтерфейса = "1.0";
	ОсновнойДрайверУстановлен = Истина;
	ПолучитьURLCкачивания = "http://support.ekka.com.ua/download/282/";

КонецФункции
																			
Функция ПолучитьПараметры(ОбъектДрайвера, ТаблицаПараметров) Экспорт

	ТаблицаПараметров = "";

	Возврат Истина;

КонецФункции

Функция ПолучитьДополнительныеДействия(ОбъектДрайвера, ДополнительныеДействия) Экспорт

	ДополнительныеДействия = "";

	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция УстановитьОплату(СуммаОплаты, ФормаОплаты, ОбъектДрайвера)

	Результат = Истина;

	Если СуммаОплаты > 0 Тогда

		Если НЕ ОбъектДрайвера.AddPayment(СуммаОплаты * 100, ФормаОплаты) = 1 Тогда

			Результат = Ложь;

		КонецЕсли;

	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция УстановитьВремяРегистратора(ОбъектДрайвера)	Экспорт

	ВремяСервера = ОбщегоНазначенияВызовСервера.ТекущаяДатаСервера();

	Результат = ОбъектДрайвера.SetInternalTime(Час(ВремяСервера), Минута(ВремяСервера), Секунда(ВремяСервера));

	Возврат Результат;

КонецФункции // УстановитьВремяРегистратора()

Функция СписокСкоростейПорта()	Экспорт

	СписокСкоростей = Новый Соответствие;

	СписокСкоростей.Вставить(1,   4800);
	СписокСкоростей.Вставить(2,   9600);
	СписокСкоростей.Вставить(3,  19200);
	СписокСкоростей.Вставить(4,  38400);
	СписокСкоростей.Вставить(5,  57600);
	СписокСкоростей.Вставить(6, 115200);

	Возврат СписокСкоростей;

КонецФункции

#КонецОбласти





