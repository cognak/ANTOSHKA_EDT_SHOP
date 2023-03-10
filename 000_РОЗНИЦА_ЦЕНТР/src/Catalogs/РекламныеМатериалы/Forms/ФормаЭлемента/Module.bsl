
&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайлов(Команда)
	СтруктураПараметров = Новый Структура("ВладелецФайла, ЗакрыватьПриВыборе", Объект.Ссылка, Истина);
	ЗначениеВыбора = ОткрытьФормуМодально("ОбщаяФорма.ВыборПрисоединенныхФайлов", СтруктураПараметров);
	Если ЗначениеЗаполнено(ЗначениеВыбора) Тогда
		Объект.ФайлКартинки = ЗначениеВыбора;
		АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, УникальныйИдентификатор)
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображение(Команда)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Записать();
		Иначе 
			Возврат
		КонецЕсли;
	КонецЕсли;
	
	ВыборИзображения = Истина;
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	ПрисоединенныеФайлыКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла);
	ВыборИзображения = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображение(Команда)
	Объект.ФайлКартинки = ПредопределенноеЗначение("Справочник.НоменклатураПрисоединенныеФайлы.ПустаяСсылка");
	АдресКартинки = "";
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьИзображение(Команда)
	
	ПросмотретьПрисоединенныйФайл();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьИзображение(Команда)
	ОчиститьСообщения();
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		ПрисоединенныеФайлыКлиент.ОткрытьФормуПрисоединенногоФайла(Объект.ФайлКартинки);
	Иначе
		ТекстСообщения = НСтр("ru='Отсутстует изображение для редактирования'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ПрисоединенныйФайл" Тогда
		СсылкаНаФайл = ?(ТипЗнч(Источник) = Тип("Массив"), Источник[0], Источник);
		Если ВыборИзображения Тогда
			Объект.ФайлКартинки = СсылкаНаФайл;
			АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, УникальныйИдентификатор);
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Если Не Объект.ФайлКартинки.Пустая() Тогда
		АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, УникальныйИдентификатор)
	Иначе
		АдресКартинки = "";
	Конецесли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция НавигационнаяСсылкаКартинки(ФайлКартинки, ИдентификаторФормы)

	УстановитьПривилегированныйРежим(Истина);

	Возврат ПрисоединенныеФайлы.ПолучитьДанныеФайла(ФайлКартинки, ИдентификаторФормы).СсылкаНаДвоичныеДанныеФайла;

КонецФункции

&НаКлиенте
Процедура ПросмотретьПрисоединенныйФайл()
	ОчиститьСообщения();
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		ДанныеФайла = ПрисоединенныеФайлыСлужебныйВызовСервера.ПолучитьДанныеФайла(ЭтотОбъект.Объект.ФайлКартинки, УникальныйИдентификатор);
		ПрисоединенныеФайлыКлиент.ОткрытьФайл(ДанныеФайла);
	Иначе
		ТекстСообщения = НСтр("ru='Отсутстует изображение для просмотра'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресКартинкиНажатие(Элемент, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	ДобавитьИзображениеНаКлиенте();

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиенте()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Записать();
		Иначе 
			Возврат
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		ПросмотретьПрисоединенныйФайл();
	ИначеЕсли ЗначениеЗаполнено(Объект.Ссылка) Тогда
		//Если Не ЕстьПравоРедактирования Тогда
		//	ТекстИсключения = НСтр("ru = 'Нарушение прав доступа!'");
		//	ВызватьИсключение ТекстИсключения;
		//КонецЕсли;
		ВыборИзображения = Истина;
		ИдентификаторФайла = Новый УникальныйИдентификатор;
		Фильтр = НСтр("ru = 'Все картинки (*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf)|*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf"
									+ "|Все файлы(*.*)|*.*"
									+ "|Формат bmp(*.bmp*;*.dib;*.rle)|*.bmp;*.dib;*.rle"
									+ "|Формат GIF(*.gif*)|*.gif"
									+ "|Формат JPEG(*.jpeg;*.jpg)|*.jpeg;*.jpg"
									+ "|Формат PNG(*.png*)|*.png"
									+ "|Формат TIFF(*.tif)|*.tif"
									+ "|Формат icon(*.ico)|*.ico"
									+ "|Формат метафайл(*.wmf;*.emf)|*.wmf;*.emf'");
		ПрисоединенныеФайлыКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла, Фильтр);
		ВыборИзображения = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНавигационнуюСсылкуКартинки(ФайлКартинки, ИдентификаторФормы)

	НавигационнаяСсылка = "";
	УстановитьПривилегированныйРежим(Истина);
    ВерсияСсылка = Неопределено;
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайла(ФайлКартинки, ВерсияСсылка);
	Если ВерсияСсылка = Неопределено Тогда
		ВерсияСсылка = ФайлКартинки.ТекущаяВерсия;
	КонецЕсли;	
	Если ЗначениеЗаполнено(ВерсияСсылка) Тогда
		ТипХраненияФайла = ВерсияСсылка.ТипХраненияФайла;
		Если ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
			Если НЕ ВерсияСсылка.Том.Пустая() Тогда
				ПолныйПуть = ФайловыеФункции.ПолныйПутьТома(ВерсияСсылка.Том) + ВерсияСсылка.ПутьКФайлу; 
				Попытка
					ДвоичныеДанные = Новый ДвоичныеДанные(ПолныйПуть);
					НавигационнаяСсылка = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ИдентификаторФормы);
				Исключение
					// запись в журнал регистрации
					СообщениеОбОшибке = РаботаСФайламиВызовСервера.СформироватьТекстОшибкиПолученияФайлСТомаДляАдминистратора(ИнформацияОбОшибке(), ВерсияСсылка.Владелец);
					ЗаписьЖурналаРегистрации("Открытие файла", УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.Файлы, ВерсияСсылка.Владелец, СообщениеОбОшибке);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ошибка открытия файла картинки - файл не найден на сервере. Возможно он удален антивирусной программой. Обратитесь к администратору.
						| Файл: ""%1.%2""'"),
						ВерсияСсылка.ПолноеНаименование,
						ВерсияСсылка.Расширение)
						);
				КонецПопытки;
			КонецЕсли;			
		Иначе
			ДвоичныеДанные = ВерсияСсылка.ФайлХранилище.Получить();
			НавигационнаяСсылка = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ИдентификаторФормы);			
		КонецЕсли;
	КонецЕсли;
	
	Возврат НавигационнаяСсылка;
	
КонецФункции

&НаКлиенте
Процедура ФайлКартинкиПриИзменении(Элемент)
	
	Если Не Объект.ФайлКартинки.Пустая() Тогда
		АдресКартинки = ПолучитьНавигационнуюСсылкуКартинки(Объект.ФайлКартинки, УникальныйИдентификатор)
	Иначе
		АдресКартинки = "";
	Конецесли;
	
КонецПроцедуры // ФайлКартинкиПриИзменении()


&НаКлиенте
Процедура ШиринаПриИзменении(Элемент)
	Площадь = Объект.Ширина*Объект.Высота/1000000;
КонецПроцедуры

&НаКлиенте
Процедура ВысотаПриИзменении(Элемент)
	Площадь = Объект.Ширина*Объект.Высота/1000000;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Площадь = Ширина*Высота; 
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Площадь = Объект.Ширина*Объект.Высота/1000000;  
КонецПроцедуры
