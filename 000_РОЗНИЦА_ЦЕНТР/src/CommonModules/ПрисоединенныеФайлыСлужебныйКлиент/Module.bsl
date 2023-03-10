////////////////////////////////////////////////////////////////////////////////
// Подсистема "Присоединенные файлы".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Добавляет файлы перетаскиванием в список файлов.
//
// Параметры:
//  ВладелецФайла      - Ссылка - владелец файла.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
//  МассивИменФайлов   - Массив Строк - путей к файлам.
//
Процедура ДобавитьФайлыПеретаскиванием(Знач ВладелецФайла, Знач ИдентификаторФормы, Знач МассивИменФайлов) Экспорт
	
	ПрисоединенныеФайлыМассив = Новый Массив;
	ПоместитьВыбранныеФайлыВХранилище(
		МассивИменФайлов,
		ВладелецФайла,
		ПрисоединенныеФайлыМассив,
		ИдентификаторФормы);
	
	Если ПрисоединенныеФайлыМассив.Количество() = 1 Тогда
		ПрисоединенныйФайл = ПрисоединенныеФайлыМассив[0];
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Создание'"),
			ПолучитьНавигационнуюСсылку(ПрисоединенныйФайл),
			ПрисоединенныйФайл,
			БиблиотекаКартинок.Информация32);
		
		ПараметрыФормы = Новый Структура("ПрисоединенныйФайл, ЭтоНовый", ПрисоединенныйФайл, Истина);
		ОткрытьФорму("ОбщаяФорма.ПрисоединенныйФайл", ПараметрыФормы, , ПрисоединенныйФайл);
	КонецЕсли;
	
	Если ПрисоединенныеФайлыМассив.Количество() > 0 Тогда
		ОповеститьОбИзменении(ПрисоединенныеФайлыМассив[0]);
		Оповестить("Запись_ПрисоединенныйФайл", Новый Структура("ЭтоНовый", Истина), ПрисоединенныеФайлыМассив);
	КонецЕсли;
	
КонецПроцедуры

#Если ВебКлиент Тогда
// Помещает файл с диска в хранилище присоединенных файлов (веб-клиент).
// 
// Параметры:
//  ВладелецФайла           - Ссылка на владельца файла.
//  НастройкиРаботыСФайлами - Структура.
//  ИдентификаторФормы      - УникальныйИдентификатор формы.
//
// Возвращаемое значение:
//  Ссылка на файл.
//
Функция ПоместитьВыбранныеФайлыВХранилищеВеб(Знач ВладелецФайла, Знач ИдентификаторФормы) Экспорт
	
	АдресВременногоХранилищаФайла = "";
	ИмяФайла = "";
	Если НЕ ПоместитьФайл(АдресВременногоХранилищаФайла, ИмяФайла, ИмяФайла, Истина, ИдентификаторФормы) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтрокиПути = ОбщегоНазначенияКлиентСервер.РазложитьСтрокуПоТочкамИСлэшам(ИмяФайла);
	
	Если СтрокиПути.Количество() >= 2 Тогда
		Расширение = СтрокиПути[СтрокиПути.Количество()-1];
		ИмяБезРасширения = СтрокиПути[СтрокиПути.Количество()-2];
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при помещении файла
			           |""%1""
			           |во временное хранилище.'"),
			ИмяФайла);
	КонецЕсли;
	
	ФайловыеФункцииСлужебныйКлиентСервер.ПроверитьРасширениеФайлаДляЗагрузки(Расширение);
	
	// Создание карточки Файла в базе данных.
	ПрисоединенныйФайл = ПрисоединенныеФайлыСлужебныйВызовСервера.ДобавитьФайл(
		ВладелецФайла,
		ИмяБезРасширения,
		Расширение,
		,
		,
		АдресВременногоХранилищаФайла,
		"");
	
	Возврат ПрисоединенныйФайл;
	
КонецФункции
#КонецЕсли

// Помещает отредактированные файлы в хранилище.
// Используется, как обработчик команды окончания редактирования файлов.
//
// Параметры
//  ДанныеФайла        - Структура с данными файла.
//  ИнформацияОФайле   - Структура (возвращаемое значение) - информация о файле.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
//
// Возвращаемое значение:
//  Истина - файл успешно помещен во временное хранилище.
//
Функция ПоместитьРедактируемыйФайлНаДискеВХранилище(Знач ДанныеФайла, ИнформацияОФайле, Знач ИдентификаторФормы) Экспорт
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	Если ПодключитьРасширениеРаботыСФайлами()Тогда
		
		РабочийКаталогПользователя = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
		
		ПолноеИмяФайлаНаКлиенте = РабочийКаталогПользователя + ДанныеФайла.ОтносительныйПуть + ДанныеФайла.ИмяФайла;
		
		Файл = Новый Файл(ПолноеИмяФайлаНаКлиенте);
		Если НЕ Файл.Существует() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Файл не найден в рабочем каталоге.'"));
			Возврат Ложь;
		КонецЕсли;
		
		Возврат ПрисоединенныеФайлыКлиент.ПоместитьФайлНаДискеВХранилище(
			ДанныеФайла, ИнформацияОФайле, ПолноеИмяФайлаНаКлиенте, ИдентификаторФормы);
		
	Иначе
#Если ВебКлиент Тогда
		Результат = ПоместитьФайлНаДискеВХранилищеВеб(ДанныеФайла, ИнформацияОФайле, ИдентификаторФормы);
		
		Если НЕ Результат Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если ДанныеФайла.ИмяФайла <> ИнформацияОФайле.ИмяФайла Тогда
			
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Имя выбранного файла
				           |""%1""
				           |отличается от имени файла в хранилище
				           |""%2"".
				           |
				           |Продолжить?'"),
				ИнформацияОФайле.ИмяФайла,
				ДанныеФайла.ИмяФайла);
			
			Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
			Если Ответ <> КодВозвратаДиалога.ОК Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Возврат Результат;
#КонецЕсли
	КонецЕсли;
	
КонецФункции

// Выбирает файл с диска и помещает его во временное хранилище на сервере.
//
// Параметры:
//  ДанныеФайла        - Структура с данными файла.
//  ИнформацияОФайле   - Структура (возвращаемое значение) - информация о файле.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
//
// Возвращаемое значение:
//  Истина - файл успешно выбран и помещен во временное хранилище, иначе Ложь.
//
Функция ВыбратьФайлНаДискеИПоместитьВХранилище(Знач ДанныеФайла, ИнформацияОФайле, Знач ИдентификаторФормы) Экспорт
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	Если ПодключитьРасширениеРаботыСФайлами()Тогда
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ВыборФайла.МножественныйВыбор = Ложь;
		ВыборФайла.ПолноеИмяФайла     = ДанныеФайла.Наименование + "." + ДанныеФайла.Расширение;
		ВыборФайла.Расширение         = ДанныеФайла.Расширение;
		ВыборФайла.Фильтр             = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		                                НСтр("ru = 'Все файлы (*.%1)|*.%1'"), ДанныеФайла.Расширение);
		
		Если НЕ ВыборФайла.Выбрать() Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Возврат ПрисоединенныеФайлыКлиент.ПоместитьФайлНаДискеВХранилище(
			ДанныеФайла, ИнформацияОФайле, ВыборФайла.ПолноеИмяФайла, ИдентификаторФормы);
		
	Иначе
#Если ВебКлиент Тогда
		Возврат ПоместитьФайлНаДискеВХранилищеВеб(ДанныеФайла, ИнформацияОФайле, ИдентификаторФормы);
#КонецЕсли
	КонецЕсли;
	
КонецФункции

#Если ВебКлиент Тогда
// Помещает файл с диска клиента во временное хранилище.
//  Аналог функции ПоместитьФайлНаДискеВХранилище
// для веб-клиента без расширения для работы с файлами.
//
// Параметры:
//  ДанныеФайла             - Структура с данными файла.
//  ИнформацияОФайле        - Структура (возвращаемое значение) с информацией о файле.
//  ИдентификаторФормы      - УникальныйИдентификатор формы.
//
// Возвращаемое значение:
//  Булево - Истина - файл успешно помещен в хранилище, иначе Ложь.
//
Функция ПоместитьФайлНаДискеВХранилищеВеб(Знач ДанныеФайла, ИнформацияОФайле, Знач ИдентификаторФормы)
	
	АдресВременногоХранилищаФайла = "";
	ВыбранноеИмяФайла = "";
	
	Если Не ПоместитьФайл(АдресВременногоХранилищаФайла, ДанныеФайла.ИмяФайла, ВыбранноеИмяФайла, Истина, ИдентификаторФормы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтрокиПути = ОбщегоНазначенияКлиентСервер.РазложитьСтрокуПоТочкамИСлэшам(ВыбранноеИмяФайла);
	
	Если СтрокиПути.Количество() >= 2 Тогда
		НовоеИмя = СтрокиПути[СтрокиПути.Количество()-2];
		НовоеРасширение = СтрокиПути[СтрокиПути.Количество()-1];
		ИмяФайла = НовоеИмя + "." + НовоеРасширение;
		
	ИначеЕсли СтрокиПути.Количество() = 1 Тогда
		НовоеИмя = СтрокиПути[0];
		НовоеРасширение = "";
		ИмяФайла = НовоеИмя;
	КонецЕсли;
	
	ФайловыеФункцииСлужебныйКлиентСервер.ПроверитьРасширениеФайлаДляЗагрузки(НовоеРасширение);
	
	ИнформацияОФайле = Новый Структура;
	ИнформацияОФайле.Вставить("ДатаМодификацииУниверсальная",   Неопределено);
	ИнформацияОФайле.Вставить("АдресФайлаВоВременномХранилище", АдресВременногоХранилищаФайла);
	ИнформацияОФайле.Вставить("АдресВременногоХранилищаТекста", "");
	ИнформацияОФайле.Вставить("ИмяФайла",                       ИмяФайла);
	ИнформацияОФайле.Вставить("Расширение",                     НовоеРасширение);
	
	Возврат Истина;
	
КонецФункции
#КонецЕсли

// Открывает каталог с файлом (при необходимости получает файл из хранилища).
// Используется, как обработчик команды открытия каталога с файлом.
//
// Параметры:
//  ДанныеФайла - Структура с данными файла.
//
Процедура ОткрытьКаталогСФайлом(Знач ДанныеФайла) Экспорт
	
	Перем ПолноеИмяФайла;
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		
		РабочийКаталогПользователя = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
		
		Если ПустаяСтрока(РабочийКаталогПользователя) Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Не задан рабочий каталог'"));
			Возврат;
		КонецЕсли;
		
		ПолныйПуть = РабочийКаталогПользователя + ДанныеФайла.ОтносительныйПуть + ДанныеФайла.ИмяФайла;
		
		Файл = Новый Файл(ПолныйПуть);
		
		Если НЕ Файл.Существует() Тогда
			Ответ = Вопрос(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Файл ""%1""
				           |отсутствует в рабочем каталоге.
				           |
				           |Получить файл из хранилища файлов?'"),
				Файл.Имя),
			РежимДиалогаВопрос.ДаНет);
			
			Если Ответ <> КодВозвратаДиалога.Да Тогда
				Возврат;
			КонецЕсли;
			
			ПолноеИмяФайлаНаКлиенте = "";
			ПрисоединенныеФайлыКлиент.ПолучитьФайлВРабочийКаталог(
				ДанныеФайла.СсылкаНаДвоичныеДанныеФайла,
				ДанныеФайла.ОтносительныйПуть,
				ДанныеФайла.ДатаМодификацииУниверсальная,
				ДанныеФайла.ИмяФайла,
				РабочийКаталогПользователя,
				ПолноеИмяФайлаНаКлиенте);
			
		КонецЕсли;
		
		ФайловыеФункцииСлужебныйКлиент.ОткрытьПроводникСФайлом(ПолныйПуть);
	Иначе
#Если ВебКлиент Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСФайлами();
#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЭЦП

// Подписывает присоединенный файл:
// - предлагает пользователю выбрать ЭЦП для подписания и получает данные подписи,
// - записывает файл с эцп в хранилище.
// Используется в обработчике команды "Подписать" формы списка.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка присоединенный файл.
//  ДанныеФайла        - Структура с данными файла.
//
// Возвращаемое значение:
//  Булево - Истина - файл успешно подписан и сохранен в хранилище,
//           Ложь - ошибки или отказ во время работы.
//
Функция СформироватьПодписьФайла(Знач ПрисоединенныйФайл, Знач ДанныеФайла) Экспорт
	
	ДанныеПодписи = Неопределено;
	
	Если ВыбратьСертификатыЭЦПИСформироватьДанныеПодписи(ПрисоединенныйФайл, ДанныеФайла, ДанныеПодписи) Тогда
		
		ПрисоединенныеФайлыСлужебныйВызовСервера.ЗанестиИнформациюОднойПодписи(
			ПрисоединенныйФайл, ДанныеПодписи);
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Формирует подпись для двоичных данных файла:
// - предлагает пользователю диалог выбора сертификатов ЭЦП,
// - подписывает двоичные данные присоединенного файла с целью получения подписи.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на файл.
//  ДанныеФайла        - Структура с данными файла.
//  ДанныеПодписи      - Структура (возвращаемое значение) - сформированная подпись.
//
// Возвращаемое значение:
//  Булево - Истина, если данные присоединенного файла успешно подписаны,
//           Ложь, если пользователь отказался от подписания или произошла ошибка.
//
Функция ВыбратьСертификатыЭЦПИСформироватьДанныеПодписи(Знач ПрисоединенныйФайл, Знач ДанныеФайла, ДанныеПодписи) Экспорт
	
#Если ВебКлиент Тогда
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСКриптографией();
		Возврат Ложь;
	КонецЕсли;
#КонецЕсли
	
	МассивСтруктурСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Истина);
	
	ПараметрыФормы = Новый Структура("МассивСтруктурСертификатов, ОбъектСсылка", МассивСтруктурСертификатов, ПрисоединенныйФайл);
	
	СтруктураПараметровПодписи = ОткрытьФормуМодально("ОбщаяФорма.УстановкаПодписиЭЦП", ПараметрыФормы);
	
	Если ТипЗнч(СтруктураПараметровПодписи) <> Тип("Структура") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
	
	Отказ = Ложь;
	МенеджерКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМенеджерКриптографии(Отказ);
	Если Отказ Тогда
		Возврат Ложь
	КонецЕсли;
	
	ДанныеПодписи = ЭлектроннаяЦифроваяПодписьКлиент.СформироватьДанныеПодписи(
		МенеджерКриптографии,
		ПрисоединенныйФайл,
		ДвоичныеДанные,
		СтруктураПараметровПодписи);
	
	Возврат Истина;
	
КонецФункции

// Добавляет ЭЦП из файла(ов) на диске.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на файл, которому требуется добавить подпись.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
//
Процедура ДобавитьЭЦПИзФайла(Знач ПрисоединенныйФайл, Знач ИдентификаторФормы = Неопределено) Экспорт
	
#Если ВебКлиент Тогда
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСКриптографией();
		Возврат;
	КонецЕсли;
#КонецЕсли
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		МассивПодписей = ПолучитьМассивПодписей(ПрисоединенныйФайл, ИдентификаторФормы);
		
		Если МассивПодписей.Количество() > 0 Тогда
			
			ПрисоединенныеФайлыСлужебныйВызовСервера.ЗанестиИнформациюОПодписях(
				ПрисоединенныйФайл, МассивПодписей);
			
			ОповеститьОДобавленииПодписиИзФайла(ПрисоединенныйФайл, МассивПодписей.Количество());
		КонецЕсли;
	Иначе
#Если ВебКлиент Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСФайлами();
#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

// Возвращает подписи, для чего вызывает диалог добавления подписей.
//
// ОСОБЫЕ УСЛОВИЯ
// Требуется наличие подключенного расширения для работы с файлами
// и расширения для работы со средствами криптографии.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на файл.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
//
// Возвращаемое значение:
//  Массив Структур подписей.
//
Функция ПолучитьМассивПодписей(Знач ПрисоединенныйФайл, Знач ИдентификаторФормы = Неопределено) Экспорт
	
	МассивФайловПодписей = ОткрытьФормуМодально("ОбщаяФорма.ДобавлениеПодписиИзФайла");
	
	Если ТипЗнч(МассивФайловПодписей) <> Тип("Массив") ИЛИ МассивФайловПодписей.Количество() = 0 Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Возврат ЭлектроннаяЦифроваяПодписьКлиент.СформироватьПодписиДляЗанесениюВБазу(
		ПрисоединенныйФайл, МассивФайловПодписей, ИдентификаторФормы);
	
КонецФункции

// Служебная процедура используется для оповещения системы об изменении объекта,
// а так же для отображения оповещения пользователя о добавлении подписей.
// Параметры
//  ПрисоединенныйФайл - ссылка на файл с добавленными подписями
//  КоличествоПодписей - количество добавленных подписей
//
Процедура ОповеститьОДобавленииПодписиИзФайла(ПрисоединенныйФайл, КоличествоПодписей) Экспорт
	
	ОповеститьОбИзменении(ПрисоединенныйФайл);
	
	Если КоличествоПодписей = 1 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Добавлена подпись из файла для ""%1"".'"),
			ПрисоединенныйФайл);
	Иначе
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Добавлены подписи из файлов для ""%1"".'"),
			ПрисоединенныйФайл);
	КонецЕсли;
	
	Состояние(ТекстСообщения);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Шифрование.

// Шифрует файл в хранилище:
// - предлагает пользователю выбрать сертификаты для шифрования,
// - выполняет шифрование файла,
// - записывает зашифрованные данные вместе с отпечатками в хранилище,
// - оповещает систему и пользователя об изменениях.
// Используется в обработчике команды шифрования файла.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на файл, который требуется зашифровать.
//  ДанныеФайла        - Структура с данными файла.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
// 
Процедура Зашифровать(Знач ПрисоединенныйФайл, Знач ДанныеФайла, Знач ИдентификаторФормы) Экспорт
	
	ЗашифрованныеДанные = Неопределено;
	МассивОтпечатков = Новый Массив;
	
	Если НЕ ПолучитьЗашифрованныеДанные(ПрисоединенныйФайл,
	                                    ДанныеФайла,
	                                    ИдентификаторФормы,
	                                    ЗашифрованныеДанные,
	                                    МассивОтпечатков) Тогда
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыСлужебныйВызовСервера.Зашифровать(ПрисоединенныйФайл, ЗашифрованныеДанные, МассивОтпечатков);
	
	ОповеститьОбИзмененииИУдалитьФайлВРабочемКаталоге(ПрисоединенныйФайл, ДанныеФайла);
	
КонецПроцедуры

// Шифрует двоичные данные файла с помощью сертификатов, выбранных пользователем.
//
// Параметры:
//  ПрисоединенныйФайл  - Ссылка на файл.
//  ДанныеФайла         - Структура с данными файла.
//  ИдентификаторФормы  - УникальныйИдентификатор формы.
//  ЗашифрованныеДанные - Структура (возвращаемое значение) - содержит зашифрованные данные файла (для записи).
//  МассивОтпечатков    - Массив    (возвращаемое значение) - содержит отпечатки.
//
// Возвращаемое значение:
//  Истина, если данные успешно зашифрованы, Ложь - иначе.
//
Функция ПолучитьЗашифрованныеДанные(Знач ПрисоединенныйФайл,
                                    Знач ДанныеФайла,
                                    Знач ИдентификаторФормы,
                                    ЗашифрованныеДанные,
                                    МассивОтпечатков) Экспорт
	
#Если ВебКлиент Тогда
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСКриптографией();
		Возврат Ложь;
	КонецЕсли;
#КонецЕсли
	
	Если ДанныеФайла.Зашифрован Тогда
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файл ""%1""
			           |уже зашифрован.'"), Строка(ПрисоединенныйФайл)));
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ДанныеФайла.Редактирует.Пустая() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя зашифровать занятый файл.'"));
		Возврат Ложь;
	КонецЕсли;
	
	МассивСтруктурСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Ложь);
	
	ОтпечатокЛичногоСертификатаДляШифрования = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().ОтпечатокЛичногоСертификатаДляШифрования;
	
	// Отпечаток сохраненный в ХранилищеНастроек мог устареть - сертификат могли уже удалить.
	Если ОтпечатокЛичногоСертификатаДляШифрования <> Неопределено И НЕ ПустаяСтрока(ОтпечатокЛичногоСертификатаДляШифрования) Тогда
		Сертификат = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьСертификатПоОтпечатку(ОтпечатокЛичногоСертификатаДляШифрования, Истина); // ТолькоЛичные
		Если Сертификат = Неопределено Тогда
			ОтпечатокЛичногоСертификатаДляШифрования = "";
		КонецЕсли;
	КонецЕсли;
	
	Если ОтпечатокЛичногоСертификатаДляШифрования = Неопределено
	 ИЛИ ПустаяСтрока(ОтпечатокЛичногоСертификатаДляШифрования) Тогда
		
		МассивСтруктурЛичныхСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Истина); // ТолькоЛичные
		
		ПараметрыФормы = Новый Структура("МассивСтруктурСертификатов", МассивСтруктурЛичныхСертификатов);
		СтруктураВозврата = ОткрытьФормуМодально("ОбщаяФорма.ВыборСертификата", ПараметрыФормы);
		Если ТипЗнч(СтруктураВозврата) = Тип("Структура") Тогда
			ОтпечатокЛичногоСертификатаДляШифрования = СтруктураВозврата.Отпечаток;
			ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения(
				"ЭЦП",
				"ОтпечатокЛичногоСертификатаДляШифрования",
				ОтпечатокЛичногоСертификатаДляШифрования);
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Не выбран персональный сертификат для шифрования.'"));
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МассивСтруктурСертификатов",               МассивСтруктурСертификатов);
	ПараметрыФормы.Вставить("ФайлСсылка",                               ПрисоединенныйФайл);
	ПараметрыФормы.Вставить("ОтпечатокЛичногоСертификатаДляШифрования", ОтпечатокЛичногоСертификатаДляШифрования);
	
	МассивСертификатов = ОткрытьФормуМодально("ОбщаяФорма.ВыборСертификатовШифрования", ПараметрыФормы);
	
	Если ТипЗнч(МассивСертификатов) = Тип("Массив") Тогда
		
		Возврат ВыполнитьШифрованиеПоПараметрам(МассивСертификатов,
		                                        ДанныеФайла,
		                                        ИдентификаторФормы,
		                                        ЗашифрованныеДанные,
		                                        МассивОтпечатков);
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Шифрует двоичные данные файла по указанному массиву сертификатов.
//
// Параметры:
//  МассивСертификатов  - Массив сертификатов для шифрования.
//  ДанныеФайла         - Структура данных файла.
//  ИдентификаторФормы  - УникальныйИдентификатор формы.
//  ЗашифрованныеДанные - Структура (возвращаемое значение) - содержит зашифрованные данные файла.
//  МассивОтпечатков    - Массив    (возвращаемое значение) - содержит отпечатки.
//
// Возвращаемое значение:
//  Истина - шифрование выполнено успешно, иначе Ложь.
//
Функция ВыполнитьШифрованиеПоПараметрам(Знач МассивСертификатов,
                                        Знач ДанныеФайла,
                                        Знач ИдентификаторФормы,
                                        ЗашифрованныеДанные,
                                        МассивОтпечатков)
	
	МассивОтпечатков = Новый Массив;
	
	Для Каждого Сертификат Из МассивСертификатов Цикл
		Отпечаток = Base64Строка(Сертификат.Отпечаток);
		Представление = ЭлектроннаяЦифроваяПодписьКлиентСервер.ПолучитьПредставлениеПользователя(Сертификат.Субъект);
		ДвоичныеДанныеСертификата = Сертификат.Выгрузить();
		
		ОтпечатокСтруктура = Новый Структура("Отпечаток, Представление, Сертификат", Отпечаток, Представление, ДвоичныеДанныеСертификата);
		МассивОтпечатков.Добавить(ОтпечатокСтруктура);
	КонецЦикла;
	
	Состояние(НСтр("ru = 'Выполняется шифрование ...'"));
	
	Отказ = Ложь;
	МенеджерКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМенеджерКриптографии(Отказ);
	Если Отказ Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
	ШифрованныйФайлДвоичныеДанные = МенеджерКриптографии.Зашифровать(ДвоичныеДанные, МассивСертификатов);
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ШифрованныйФайлДвоичныеДанные, ИдентификаторФормы);
	
	ЗашифрованныеДанные = Новый Структура;
	ЗашифрованныеДанные.Вставить("АдресВременногоХранилища", АдресВременногоХранилища);
	
	Состояние(НСтр("ru = 'Шифрование завершено.'"));
	
	Возврат Истина;
	
КонецФункции

// Удаляет файл из рабочего каталога, оповещает об изменениях открытые формы.
Процедура ОповеститьОбИзмененииИУдалитьФайлВРабочемКаталоге(Знач ПрисоединенныйФайл, Знач ДанныеФайла) Экспорт
	
	ОповеститьОбИзменении(ПрисоединенныйФайл);
	
	Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Файл ""%1""
		           |зашифрован.'"),
		ПрисоединенныйФайл) );
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	Если ПодключитьРасширениеРаботыСФайлами()Тогда
		
		РабочийКаталогПользователя = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
		ПолныйПутьКФайлу = РабочийКаталогПользователя + ДанныеФайла.ИмяФайла;
		
		Файл = Новый Файл(ПолныйПутьКФайлу);
		
		Если Файл.Существует() Тогда
			Попытка
				Файл.УстановитьТолькоЧтение(Ложь);
				УдалитьФайлы(ПолныйПутьКФайлу);
			Исключение
				// Попытка удалить файл с диска.
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Расшифровывает файл в хранилище:
// - показывает пользователю диалог с предложением расшифровать файл,
// - получает двоичные данные и массив отпечатков,
// - производит расшифровку,
// - записывает расшифрованные данные файла в хранилище.
// Используется как обработчик команды расшифровки файла.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на файл.
//  ДанныеФайла        - Структура с данными файла.
//  ИдентификаторФормы - УникальныйИдентификатор формы.
//
Процедура Расшифровать(Знач ПрисоединенныйФайл, Знач ДанныеФайла, Знач ИдентификаторФормы) Экспорт
	
	РасшифрованныеДанные = Неопределено;
	
	Если НЕ ПолучитьРасшифрованныеДанные(ПрисоединенныйФайл, ДанныеФайла, РасшифрованныеДанные, ИдентификаторФормы) Тогда
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыСлужебныйВызовСервера.Расшифровать(ПрисоединенныйФайл, РасшифрованныеДанные);
	
	ОповеститьОРасшифровкеФайла(ПрисоединенныйФайл);
	
КонецПроцедуры

// Получает расшифрованные данные файла.
//
// Параметры:
//  ПрисоединенныйФайл   - Ссылка на файл.
//  ДанныеФайла          - Структура с данными файла.
//  РасшифрованныеДанные - Структура (возвращаемое значение) - содержит расшифрованные данные.
//  ИдентификаторФормы   - УникальныйИдентификатор формы.
//
// Возвращаемое значение:
//  Истина - данные успешно расшифрованы, Ложь - данные не расшифрованы.
// 
Функция ПолучитьРасшифрованныеДанные(Знач ПрисоединенныйФайл, Знач ДанныеФайла, РасшифрованныеДанные, Знач ИдентификаторФормы) Экспорт
	
#Если ВебКлиент Тогда
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСКриптографией();
		Возврат Ложь;
	КонецЕсли;
#КонецЕсли
	
	ПредставленияСертификатов = "";
	
	МассивСертификатовШифрования = ДанныеФайла.МассивСертификатовШифрования;
	Для Каждого СтруктураСертификата Из МассивСертификатовШифрования Цикл
		Отпечаток = СтруктураСертификата.Отпечаток;
		Сертификат = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьСертификатПоОтпечатку(Отпечаток, Истина);
		Если Сертификат <> Неопределено Тогда 
			Если НЕ ПустаяСтрока(ПредставленияСертификатов) Тогда
				ПредставленияСертификатов = ПредставленияСертификатов + Символы.ПС;
			КонецЕсли;
			ПредставленияСертификатов = ПредставленияСертификатов + СтруктураСертификата.Представление;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",                 НСтр("ru = 'Введите пароль для расшифровки'"));
	ПараметрыФормы.Вставить("ПредставленияСертификатов", ПредставленияСертификатов);
	ПараметрыФормы.Вставить("Файл",                      ПрисоединенныйФайл);
	
	КодВозврата = ОткрытьФормуМодально("ОбщаяФорма.ВводПароляСОписаниями", ПараметрыФормы);
	
	Если ТипЗнч(КодВозврата) = Тип("Строка") Тогда
		Пароль = КодВозврата;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется расшифровка ...'"));
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
	
	Отказ = Ложь;
	МенеджерКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМенеджерКриптографии(Отказ);
	Если Отказ Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = Пароль;
	ДвоичныеДанныеРасшифрованные = МенеджерКриптографии.Расшифровать(ДвоичныеДанные);
	
	АдресВременногоХранилищаРасшифрованныхДанных = ПоместитьВоВременноеХранилище(
		ДвоичныеДанныеРасшифрованные, ИдентификаторФормы);
	
#Если ВебКлиент Тогда
	АдресВременногоХранилищаТекста = "";
#Иначе
	ИзвлекатьТекстыФайловНаСервере = ФайловыеФункцииСлужебныйКлиентСервер.ОбщиеНастройкиРаботыСФайлами(
		).ИзвлекатьТекстыФайловНаСервере;
	
	Если НЕ ИзвлекатьТекстыФайловНаСервере Тогда
		
		ПолныйПутьКФайлу = ПолучитьИмяВременногоФайла(ДанныеФайла.Расширение);
		ДвоичныеДанныеРасшифрованные.Записать(ПолныйПутьКФайлу);
		
		АдресВременногоХранилищаТекста =
			ФайловыеФункцииСлужебныйКлиентСервер.ИзвлечьТекстВоВременноеХранилище(
				ПолныйПутьКФайлу, ИдентификаторФормы);
		
		УдалитьФайлы(ПолныйПутьКФайлу);
	Иначе
		АдресВременногоХранилищаТекста = "";
	КонецЕсли;
#КонецЕсли
	
	РасшифрованныеДанные = Новый Структура;
	РасшифрованныеДанные.Вставить("АдресВременногоХранилища",       АдресВременногоХранилищаРасшифрованныхДанных);
	РасшифрованныеДанные.Вставить("АдресВременногоХранилищаТекста", АдресВременногоХранилищаТекста);
	
	Состояние(НСтр("ru = 'Расшифровка завершена.'"));
	
	Возврат Истина;
	
КонецФункции

// Оповещает систему и пользователя о расшифровке файла.
// 
// Параметры:
//  ПрисоединенныйФайл - Ссылка на файл.
//
Процедура ОповеститьОРасшифровкеФайла(Знач ПрисоединенныйФайл) Экспорт
	
	ОповеститьОбИзменении(ПрисоединенныйФайл);
	
	Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Файл ""%1""
		           |расшифрован.'"),
		ПрисоединенныйФайл) );
	
КонецПроцедуры

// Помещает файлы с диска в хранилище присоединенных файлов.
// 
// Параметры:
//  ВыбранныеФайлы                 - Массив - пути к файлам на диске.
//  ВладелецФайла                  - Ссылка на владельца файла.
//  НастройкиРаботыСФайлами        - Структура.
//  ПрисоединенныеФайлыМассив      - Массив (возвращаемое значение) - заполняется ссылками
//                                   на добавленные файлы.
//  ИдентификаторФормы             - УникальныйИдентификатор формы.
//
Процедура ПоместитьВыбранныеФайлыВХранилище(Знач ВыбранныеФайлы,
                                            Знач ВладелецФайла,
                                            ПрисоединенныеФайлыМассив,
                                            Знач ИдентификаторФормы) Экспорт
	
	ОбщиеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ОбщиеНастройкиРаботыСФайлами();
	
	ТекущаяПозиция = 0;
	
	ПоследнийСохраненныйФайл = Неопределено;
	
	Для Каждого ПолноеИмяФайла Из ВыбранныеФайлы Цикл
		
		ТекущаяПозиция = ТекущаяПозиция + 1;
		
		Файл = Новый Файл(ПолноеИмяФайла);
		
		ФайловыеФункцииСлужебныйКлиентСервер.ПроверитьВозможностьЗагрузкиФайла(Файл);
		
		Если ОбщиеНастройки.ИзвлекатьТекстыФайловНаСервере Тогда
			АдресВременногоХранилищаТекста = "";
		Иначе
			АдресВременногоХранилищаТекста =
				ФайловыеФункцииСлужебныйКлиентСервер.ИзвлечьТекстВоВременноеХранилище(
					ПолноеИмяФайла, ИдентификаторФормы);
		КонецЕсли;
	
		ВремяИзмененияУниверсальное = Файл.ПолучитьУниверсальноеВремяИзменения();
		
		ОбновитьСостояниеОСохраненииФайлов(ВыбранныеФайлы, Файл, ТекущаяПозиция);
		ПоследнийСохраненныйФайл = Файл;
		
		ПомещаемыеФайлы = Новый Массив;
		Описание = Новый ОписаниеПередаваемогоФайла(Файл.ПолноеИмя, "");
		ПомещаемыеФайлы.Добавить(Описание);
		
		ПомещенныеФайлы = Новый Массив;
		
		Если НЕ ПоместитьФайлы(ПомещаемыеФайлы, ПомещенныеФайлы, , Ложь, ИдентификаторФормы) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при помещении файла
					           |""%1""
					           |во временное хранилище.'"),
					Файл.ПолноеИмя) );
			Продолжить;
		КонецЕсли;
		
		АдресВременногоХранилищаФайла = ПомещенныеФайлы[0].Хранение;
		
		// Создание карточки Файла в базе данных.
		ПрисоединенныйФайл = ПрисоединенныеФайлыСлужебныйВызовСервера.ДобавитьФайл(
			ВладелецФайла,
			Файл.ИмяБезРасширения,
			ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(Файл.Расширение),
			,
			ВремяИзмененияУниверсальное,
			АдресВременногоХранилищаФайла,
			АдресВременногоХранилищаТекста);
		
		Если ПрисоединенныйФайл = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ПрисоединенныеФайлыМассив.Добавить(ПрисоединенныйФайл);
		
	КонецЦикла;
	
	ОбновитьСостояниеОСохраненииФайлов(ВыбранныеФайлы, ПоследнийСохраненныйФайл);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Процедура ОбновитьСостояниеОСохраненииФайлов(Знач ВыбранныеФайлы, Знач Файл, Знач ТекущаяПозиция = Неопределено);
	
	Если Файл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РазмерВМб = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьСтрокуСРазмеромФайла(Файл.Размер() / (1024 * 1024));
	
	Если ВыбранныеФайлы.Количество() > 1 Тогда
		
		Если ТекущаяПозиция = Неопределено Тогда
			Состояние(НСтр("ru = 'Сохранение файлов завершено.'"));
		Иначе
			ИндикаторПроцент = ТекущаяПозиция * 100 / ВыбранныеФайлы.Количество();
			
			НадписьПодробнее = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сохраняется файл ""%1"" (%2 Мб) ...'"), Файл.Имя, РазмерВМб);
				
			ТекстСостояния = НСтр("ru = 'Сохранение нескольких файлов.'");
			
			Состояние(ТекстСостояния, ИндикаторПроцент, НадписьПодробнее, БиблиотекаКартинок.Информация32);
		КонецЕсли;
	Иначе
		Если ТекущаяПозиция = Неопределено Тогда
			ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сохранение файла ""%1"" (%2 Мб)
				           |завершено.'"), Файл.Имя, РазмерВМб);
		Иначе
			ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сохраняется файл ""%1"" (%2 Мб).
				           |Пожалуйста, подождите...'"), Файл.Имя, РазмерВМб);
		КонецЕсли;
		Состояние(ТекстПояснения);
	КонецЕсли;
	
КонецПроцедуры
