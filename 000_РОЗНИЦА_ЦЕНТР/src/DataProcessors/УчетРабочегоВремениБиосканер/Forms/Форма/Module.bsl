//&НаКлиенте
//Перем мДрайвер;


&НаКлиенте
Процедура ПодключитьУстройство(Команда)
	ОписаниеОшибки = "";
			
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("БиометрическийСканер");
	
	МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО, ОписаниеОшибки);				
	
	Если ОписаниеОшибки <> "" Тогда
		Предупреждение(ОписаниеОшибки);	
	Иначе  
		ИдентификаторУстройства = МенеджерОборудованияКлиент.ВыбратьУстройство("БиометрическийСканер","Выберите устройство","Устройство не подключено!"); 
		СтруктураПараметров = ПолучитьПараметрыУстройства(ИдентификаторУстройства);
		ВходныеПараметры  = Неопределено;
		ВыходныеПараметры = Неопределено;

		мДрайвер = МенеджерОборудованияКлиент.ПолучитьОбъектДрайвера(СтруктураПараметров.ОбработчикДрайвера,"",СтруктураПараметров.Параметры);
		
	КонецЕсли;        
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	Результат = Ложь;
	ОписаниеОшибки = "";	

	Если Не ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		ИдентификаторУстройства = МенеджерОборудованияКлиент.ВыбратьУстройство("БиометрическийСканер","Выберите устройство","Устройство не подключено!");
	КонецЕсли;

	Результат = МенеджерОборудованияКлиент.ПодключитьОборудованиеПоИдентификатору(ЭтотОбъект, ИдентификаторУстройства, ОписаниеОшибки);

	Если Результат Тогда

		ВходныеПараметры  = Неопределено;
		ВыходныеПараметры = Неопределено;

		Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
		                                                        "ТестУстройства",
		                                                        ВходныеПараметры,
		                                                        ВыходныеПараметры);

		Если НЕ Результат Тогда
			Предупреждение("Ошибка при тестировании устройства!");
		Иначе
			Предупреждение(ВыходныеПараметры[1]);
		КонецЕсли;

		МенеджерОборудованияКлиент.ОтключитьОборудованиеПоИдентификатору(ЭтотОбъект,
		                                                                 ИдентификаторУстройства);

	Иначе

		Сообщить("При підключенні пристрою (Біосканер) сталася помилка." + Символы.ПС + ОписаниеОшибки);

	КонецЕсли;

	

КонецПроцедуры

&НаКлиенте
Процедура ОтключитьУстройство(Команда)
	Результат = Ложь;
	ОписаниеОшибки = "";	

	Если Не ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		ИдентификаторУстройства = МенеджерОборудованияКлиент.ВыбратьУстройство("БиометрическийСканер","Выберите устройство","Устройство не подключено!");
	КонецЕсли;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
	                                                        "ОтключитьУстройство",
	                                                        ВходныеПараметры,
	                                                        ВыходныеПараметры);

	Если НЕ Результат Тогда
		Предупреждение(ВыходныеПараметры[1]);
	Иначе
		Элементы.СтатусСканера.Заголовок = "Не подключен";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Идентификация(Команда)
	Результат = Ложь;
	ОписаниеОшибки = "";	
    ПредпоследнийОтпечаток = "";
	
	Если Не ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		ИдентификаторУстройства = МенеджерОборудованияКлиент.ВыбратьУстройство("БиометрическийСканер","Выберите устройство","Устройство не подключено!");
	КонецЕсли;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
	                                                        "ЗахватОтпечатка",
	                                                        ВходныеПараметры,
	                                                        ВыходныеПараметры);

	Если НЕ Результат Тогда
		Предупреждение(ВыходныеПараметры[1]);
	Иначе
		Элементы.СтатусСканера.Заголовок = "Идентификация";
		Элементы.Ожидание.Видимость = Истина;
		ПодключитьОбработчикОжидания("ПроверкаВводаОтпечатка",1);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьИдентификацию(Команда)
	Результат = Ложь;
	ОписаниеОшибки = "";	

	Если Не ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		ИдентификаторУстройства = МенеджерОборудованияКлиент.ВыбратьУстройство("БиометрическийСканер","Выберите устройство","Устройство не подключено!");
	КонецЕсли;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
	                                                        "ОстановитьЗахват",
	                                                        ВходныеПараметры,
	                                                        ВыходныеПараметры);

	Если НЕ Результат Тогда
		Предупреждение(ВыходныеПараметры[1]);
	Иначе
		Элементы.СтатусСканера.Заголовок = "Подключен";         
		Элементы.Ожидание.Видимость = Ложь;
		ЭтаФорма.Ожидание = 0;  
		ОтключитьОбработчикОжидания("ПроверкаВводаОтпечатка");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Зарегистрировать(Команда)
	Результат = Ложь;
	ОписаниеОшибки = "";	

	
	Если Не ЗначениеЗаполнено(Сотрудник) Тогда
		Предупреждение("Укажите сотрудника у которого снимается отпечаток!");
		Возврат;
	КонецЕсли;
	
	Элементы.СтатусСканера.Заголовок = "Регистрация";
	Если Не ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		ИдентификаторУстройства = МенеджерОборудованияКлиент.ВыбратьУстройство("БиометрическийСканер","Выберите устройство","Устройство не подключено!");
	КонецЕсли;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	
	//в х64 разрядной версии проблема с подключением к контексту 1С. Драйвер не может генерировать внешнее событие. Поэтому регистрация отпечатка будет происходить
	//по следующей схеме: снимаем 3 отпечатка, закидываем в библиотеку и получаем зарегистрированный вариант.
	//Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
	//                                                        "РегистрацияОтпечатка",
	//                                                        ВходныеПараметры,
	//                                                        ВыходныеПараметры);

	НомерРегистрации = 0;     
	ПредпоследнийОтпечаток = "";
	Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
	                                                        "ЗахватОтпечатка",
	                                                        ВходныеПараметры,
	                                                        ВыходныеПараметры);
	Если НЕ Результат Тогда
		Предупреждение(ВыходныеПараметры[1]);
	Иначе   
		ПодключитьОбработчикОжидания("РегистрацияОтпечаткаХ64",1);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияОтпечаткаХ64() Экспорт     
	
	ОтключитьОбработчикОжидания("РегистрацияОтпечаткаХ64");
	//Элементы.Информация.Заголовок = "Приложите палец к сенсору. Попытка №"+(НомерРегистрации+1);
	ЭтаФорма.Информация = "Приложите палец к сенсору. Попытка №"+(НомерРегистрации+1); 
	ЭтаФорма.ОбновитьОтображениеДанных(Элементы.Информация);
	Если Не ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		ИдентификаторУстройства = МенеджерОборудованияКлиент.ВыбратьУстройство("БиометрическийСканер","Выберите устройство","Устройство не подключено!");
	КонецЕсли;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
	                                                        "ПоследнийОтпечаток",
	                                                        ВходныеПараметры,
	                                                        ВыходныеПараметры);
	Если НЕ Результат Тогда
		Предупреждение(ВыходныеПараметры[1]);
		Сообщить("Регистрация неуспешно!");
		Возврат;
	КонецЕсли;
	
	ПоследнийОтпечаток = ВыходныеПараметры[0];
	Если ((ПоследнийОтпечаток <> ПредпоследнийОтпечаток) И (ПоследнийОтпечаток <> "")) Тогда  
		//Элементы.Информация.Заголовок = "Зафиксировано!";  
		//проверим, что это не палец какого-то другого сотрудника
		Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
		                                                        "НайтиПоБД",
		                                                        ВходныеПараметры,
		                                                        ВыходныеПараметры);

		Если Не Результат Тогда      
			//Проверим что прикладывается один и тот же палец 
			РазрешаемРегистрироватьПопытку = Истина;
			Если НомерРегистрации > 0 Тогда
				ВходныеПараметры = Новый Массив;
				ВходныеПараметры.Добавить(ПоследнийОтпечаток);
				ВходныеПараметры.Добавить(ПредпоследнийОтпечаток);
				Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
			                                                        "СравнитьОтпечатки",
			                                                        ВходныеПараметры,
			                                                        ВыходныеПараметры);
				Если Результат Тогда
					Если ВыходныеПараметры[0]<90 Тогда
						РазрешаемРегистрироватьПопытку = Ложь;
						ЭтаФорма.Информация = "Нужно прикладывать один и тот же палец!";
					КонецЕсли;
				КонецЕсли;   
			КонецЕсли;                                                        
			
			Если РазрешаемРегистрироватьПопытку Тогда
				ЭтаФорма.Информация = "Зафиксировано";
				ПредпоследнийОтпечаток = ПоследнийОтпечаток;
				Если АдресРегистрации = "" Тогда
					МассивОтпечатков = Новый Массив;
				Иначе
					МассивОтпечатков = ПолучитьИзВременногоХранилища(АдресРегистрации);
				КонецЕсли;
				МассивОтпечатков.Добавить(ПоследнийОтпечаток);  
				НомерРегистрации = НомерРегистрации + 1;        
				АдресРегистрации = ПоместитьВоВременноеХранилище(МассивОтпечатков);
			КонецЕсли;			
		Иначе          
			НомерСотрудника = ВыходныеПараметры[0]-1;
			//Сообщить("Номер сотрудника в БД "+НомерСотрудника);
			
			СтрокаСотрудник = Сотрудники[НомерСотрудника];
			ЭтаФорма.Информация = "Пересадка пальца?"+Символы.ПС+"Данные уже зарегестрированы за сотрудником "+СтрокаСотрудник.ФизЛицо;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НомерРегистрации < 3 Тогда
		Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
	                                                        "ЗахватОтпечатка",
	                                                        ВходныеПараметры,
	                                                        ВыходныеПараметры); 
															
		ПодключитьОбработчикОжидания("РегистрацияОтпечаткаХ64",1); 
	Иначе
        ВходныеПараметры = Новый Массив;
		ВходныеПараметры.Добавить(МассивОтпечатков);
		Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
	                                                        "РегистрацияПоДанным",
	                                                        ВходныеПараметры,
	                                                        ВыходныеПараметры);
		Если Результат Тогда
			СохранитьОтпечатокВБазе(ВыходныеПараметры[0]);
		Иначе
			ЭтаФорма.Информация = ""+ВыходныеПараметры[1];
		КонецЕсли;													

		ЭтаФорма.Информация = "";
		ЭтаФорма.ОбновитьОтображениеДанных(Элементы.Информация);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Сообщить("Источник: "+Источник);
	Сообщить("Событие: "+Событие);
	Сообщить("Данные: "+Данные);

	СканОтпечатка = Неопределено;
	ПоследнийОтпечаток = Неопределено;
	Если Событие = "Identify" ИЛИ Событие = "Enroll_OK" ИЛИ Событие = "Enroll_END" Тогда
		ВходныеПараметры  = Неопределено;
		ВыходныеПараметры = Неопределено;

		Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
		                                                        "ПоследнийОтпечаток",
		                                                        ВходныеПараметры,
		                                                        ВыходныеПараметры); 
		Если Результат Тогда
			ПоследнийОтпечаток = ВыходныеПараметры[0];
			СканОтпечатка = ВыходныеПараметры[1];
			
			//АдресКартинки = ПоместитьВоВременноеХранилище(СканОтпечатка); 
			//ПолучитьОтпечаток(СканОтпечатка);
		Иначе
			Сообщить("Ошибка: "+ВыходныеПараметры[1]);
		КонецЕсли;

	КонецЕсли;
	Если Событие = "Enroll_END" Тогда
		Если ПоследнийОтпечаток<>Неопределено Тогда
			СохранитьОтпечатокВБазе(ПоследнийОтпечаток);	
		КонецЕсли;
		
		Элементы.СтатусСканера.Заголовок = "Подключен: Идентификация отпечатка";
	КонецЕсли;
	
	Если Событие = "Identify" Тогда
		ПровестиИдентификациюСотрудника(ПоследнийОтпечаток,СканОтпечатка);	
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПровестиИдентификациюСотрудника(ПоследнийОтпечаток,СканОтпечатка)
	Результат = Ложь;
	ОписаниеОшибки = "";	

	
	Если Не ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		ИдентификаторУстройства = МенеджерОборудованияКлиент.ВыбратьУстройство("БиометрическийСканер","Выберите устройство","Устройство не подключено!");
	КонецЕсли;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
	                                                        "НайтиПоБД",
	                                                        ВходныеПараметры,
	                                                        ВыходныеПараметры);

	Если Не Результат Тогда
		Предупреждение(ВыходныеПараметры[1],3);
		Сотрудник = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
		АдресКартинки = "";
	Иначе          
		НомерСотрудника = ВыходныеПараметры[0]-1;
		//Сообщить("Номер сотрудника в БД "+НомерСотрудника);
		
		СтрокаСотрудник = Сотрудники[НомерСотрудника];
		Сотрудник = СтрокаСотрудник.ФизЛицо;
		//ОткрытьФорму("Обработка.УчетРабочегоВремениБиосканер.Форма",Новый Структура("Сотрудник",Сотрудник),ЭтаФорма);
		//АдресКартинки = ПоместитьВоВременноеХранилище(СканОтпечатка); 
		СделатьЗаписьВрегистр();	
	КонецЕсли;
	
	

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
	                                                        "ЗахватОтпечатка",
	                                                        ВходныеПараметры,
	                                                        ВыходныеПараметры);
	ПодключитьОбработчикОжидания("ПроверкаВводаОтпечатка",1);

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОтпечаток(СканОтпечатка)
	Если СканОтпечатка <> Неопределено Тогда
		ДвоичныеДанные2 = ДвоичныеДанныеИзSafe(СканОтпечатка);
		Картинка_ = Новый Картинка(ДвоичныеДанные2);
		//АдресКартинки = ПоместитьВоВременноеХранилище(Картинка_); 
	КонецЕсли;
КонецПроцедуры


&НаСервере
Функция ПолучитьПараметрыУстройства(ИдентификаторУстройства)
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Параметры",ИдентификаторУстройства.Параметры.Получить());
	СтруктураПараметры.Вставить("ОбработчикДрайвера",ИдентификаторУстройства.ОбработчикДрайвера);
	
	Возврат СтруктураПараметры;
КонецФункции

&НаКлиенте
Процедура СохранитьОтпечатокВБазе(Отпечаток)
	Если СохранитьОтпечатокВБазеСервер(Отпечаток) Тогда
		Строка_ = Сотрудники.Добавить();
		Строка_.ФизЛицо = Сотрудник;
		Строка_.Биометрия = Отпечаток;
		Предупреждение("Отпечаток сохранен в базе данных!");
	Иначе
		Предупреждение("Не удалось сохранить отпечаток в базе данных");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СохранитьОтпечатокВБазеСервер(Отпечаток)
	Возврат РаботаСБиометричекимиДанными.УстановитьБиометриюСотруднику(Сотрудник,Отпечаток);
КонецФункции

&НаКлиенте
Функция SafeИзДвоичныхДанных(ДвоичныеДанные)
    Если ТипЗнч(ДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
                Буфер = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ДвоичныеДанные);
    КонецЕсли;
    
    Байтов = Буфер.Размер;
    COMSafeArray = Новый COMSafeArray("VT_UI1", Байтов);//однобайтовый без знака
    Для сч = 0 по Байтов-1 Цикл
        COMSafeArray.SetValue(сч, Буфер.Получить(сч));
    КонецЦикла;
    Возврат COMSafeArray;
КонецФункции

&НаКлиенте
Функция ДвоичныеДанныеИзSafe(SafeArray)
	Массив = SafeArray.Выгрузить();
    Длинна = Массив.Количество();
    Буфер = Новый БуферДвоичныхДанных(Длинна);
    Для индекс = 0 по Длинна - 1 Цикл
        Буфер.Установить(индекс,Массив[индекс]);    
    КонецЦикла;    
    Поток = Новый ПотокВПамяти(Буфер);
    ДД = Поток.ЗакрытьИПолучитьДвоичныеДанные();    
	
	Возврат ДД;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОписаниеОшибки = "";
			
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("БиометрическийСканер");
	
	МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО, ОписаниеОшибки);				
	
	Если ОписаниеОшибки <> "" Тогда
		Предупреждение(ОписаниеОшибки);	
		Элементы.СтатусСканера.Заголовок = "Не подключен";
	Иначе  
		ИдентификаторУстройства = МенеджерОборудованияКлиент.ВыбратьУстройство("БиометрическийСканер","Выберите устройство","Устройство не подключено!");
		ИнициализироватьБДСканера();
		СтруктураПараметров = ПолучитьПараметрыУстройства(ИдентификаторУстройства);
		ВходныеПараметры  = Неопределено;
		ВыходныеПараметры = Неопределено;

		Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
		                                                        "ЗахватОтпечатка",
		                                                        ВходныеПараметры,
		                                                        ВыходныеПараметры);
		//мДрайвер = МенеджерОборудованияКлиент.ПолучитьОбъектДрайвера(СтруктураПараметров.ОбработчикДрайвера,"",СтруктураПараметров.Параметры);
		//мДрайвер.ЗахватОтпечатка();
		Если Результат Тогда  
			ПодключитьОбработчикОжидания("ПроверкаВводаОтпечатка",1);
			Элементы.СтатусСканера.Заголовок = "Идентификация";
			//Элементы.СтатусСканера.Заголовок = "Подключен: Идентификация отпечатка";
		Иначе
			Элементы.СтатусСканера.Заголовок = "Подключен";
		КонецЕсли;
	КонецЕсли;        
	
КонецПроцедуры                                                       

&НаКлиенте
Процедура  ПроверкаВводаОтпечатка()  Экспорт
	Элементы.Ожидание.Видимость = Истина;
	Если ЭтаФорма.Ожидание = 100 Тогда
		ЭтаФорма.Ожидание = 0;
	КонецЕсли;
	ЭтаФорма.Ожидание = ЭтаФорма.Ожидание + 10;   
		ИдентификаторУстройства = МенеджерОборудованияКлиент.ВыбратьУстройство("БиометрическийСканер","Выберите устройство","Устройство не подключено!");
		СтруктураПараметров = ПолучитьПараметрыУстройства(ИдентификаторУстройства);
		ВходныеПараметры  = Неопределено;
		ВыходныеПараметры = Неопределено;

		Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
		                                                        "ПоследнийОтпечаток",
		                                                        ВходныеПараметры,
		                                                        ВыходныеПараметры);
		Если Результат Тогда
			ПоследнийОтпечаток = ВыходныеПараметры[0];
			СканОтпечатка = ВыходныеПараметры[1];
			Если ((ПоследнийОтпечаток <> ПредпоследнийОтпечаток)И(ПоследнийОтпечаток <> "")) Тогда
				ОтключитьОбработчикОжидания("ПроверкаВводаОтпечатка");
				ВходныеПараметры  = Неопределено;
				ВыходныеПараметры = Неопределено;

				Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
				                                                        "ОстановитьЗахват",
				                                                        ВходныеПараметры,
				                                                        ВыходныеПараметры);
				//ЭтаФорма.Ожидание = 0;
				//Элементы.Ожидание.Видимость = Ложь;
				ПредпоследнийОтпечаток = ПоследнийОтпечаток;
				ПровестиИдентификациюСотрудника(ПоследнийОтпечаток,СканОтпечатка);	
			КонецЕсли;
		КонецЕсли;															
КонецПроцедуры

&НаСервере()
Процедура СделатьЗаписьВрегистр()
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		ТипВремени = ПолучитьТипВремени();
			
		текДАта =ТекущаяДата();	
		Магазин = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин;
		//Организация = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Магазин,"Организация");
		Организация = ПолучитьОрганизацию(Магазин);		
		НаборЗаписей = РегистрыСведений.УчетРабочегоВремениФакт.СоздатьНаборЗаписей(); 

		НаборЗаписей.Отбор.Организация.Установить(Организация);
		НаборЗаписей.Отбор.Магазин.Установить(Магазин); 
		НаборЗаписей.Отбор.Сотрудник.Установить(Сотрудник); 
		НаборЗаписей.Отбор.период.Установить(текДАта); 
		НаборЗаписей.Отбор.ТипВремени.Установить(ТипВремени); 
		НовЗапись = НаборЗаписей.Добавить();
		НовЗапись.Организация = Организация;
		НовЗапись.Магазин = Магазин;
		НовЗапись.Сотрудник = Сотрудник;
		НовЗапись.период = текДАта;
		НовЗапись.ЗаписаноЗаданием = Ложь;
		НовЗапись.ТипВремени = ТипВремени;
		НаборЗаписей.Записать(Истина);
		УстановитьПривилегированныйРежим(Ложь); 
	Исключение
		УстановитьПривилегированныйРежим(Ложь);
	КонецПопытки;   
	
	
КонецПроцедуры


&НаСервере()
Функция ПолучитьОрганизацию(Магазин)
	ОрганизацИЯ = Справочники.Организации.ПустаяСсылка();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ 
		|	ОрганизацииПодразделенийСрезПоследних.Организация КАК Организация
		|ИЗ
		|	РегистрСведений.ОрганизацииПодразделений.СрезПоследних(&ТекДата, Владелец = &Владелец) КАК ОрганизацииПодразделенийСрезПоследних";
	
	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
	Запрос.УстановитьПараметр("Владелец", Магазин);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОрганизацИЯ = ВыборкаДетальныеЗаписи.Организация;	
	КонецЦикла;
	Возврат Организация;
КонецФункции

&НаСервере()
Функция ПолучитьТипВремени()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УчетРабочегоВремениФакт.ТипВремени КАК ТипВремени,
		|	УчетРабочегоВремениФакт.Период КАК Период
		|ИЗ
		|	РегистрСведений.УчетРабочегоВремениФакт КАК УчетРабочегоВремениФакт
		|ГДЕ
		|	УчетРабочегоВремениФакт.Сотрудник = &Сотрудник
		|	И УчетРабочегоВремениФакт.Период МЕЖДУ &ПериодС И &ПериодПо
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ";
	
	Запрос.УстановитьПараметр("ПериодПо", КонецДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("ПериодС", НачалоДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() тогда 
		ТипВремени = Перечисления.ТипВремени.Приход;
	КонецЕсли;
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.ТипВремени = Перечисления.ТипВремени.Приход тогда
			ТипВремени = Перечисления.ТипВремени.Уход;
		Иначе
			ТипВремени = Перечисления.ТипВремени.Приход;
		КонецЕсли;
	КонецЦикла;
	Возврат ТипВремени;
КонецФункции

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	МенеджерОборудованияКлиент.ОтключитьОборудованиеПоИдентификатору(УникальныйИдентификатор,ИдентификаторУстройства);	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеФункции(Команда)
	Если Не ЭтоАдминистратор() Тогда
		Возврат;
	КонецЕсли;  

	Если Элементы.ГруппаПраво.Видимость Тогда
		Элементы.ГруппаПраво.Видимость = Ложь;
		Элементы.Сотрудник.Видимость = Ложь;
		Элементы.Сотрудники.Видимость = Ложь;     
	Иначе
		Элементы.ГруппаПраво.Видимость = Истина;
		Элементы.Сотрудник.Видимость = Истина;
		Элементы.Сотрудники.Видимость = Истина;     
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЭтоАдминистратор()
	Возврат РольДоступна("АдминистраторСистемы");
КонецФункции

&НаСервере
Функция ПолучитьКолонкуТаблицы(ИмяКолонки)
	Возврат Сотрудники.Выгрузить(,ИмяКолонки).ВыгрузитьКолонку(ИмяКолонки);
КонецФункции                

&НаКлиенте
Процедура ИнициализироватьБДСканера()
	ИнцициализироватьБДСканераСервер();
	МассивБиометрия = ПолучитьКолонкуТаблицы("Биометрия");
	МассивСотрудники = ПолучитьКолонкуТаблицы("ФизЛицо");
	
	Результат = Ложь;
	ОписаниеОшибки = "";	

	
	Если Не ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		ИдентификаторУстройства = МенеджерОборудованияКлиент.ВыбратьУстройство("БиометрическийСканер","Выберите устройство","Устройство не подключено!");
	КонецЕсли;

	ВходныеПараметры  = Новый Массив;
	ВыходныеПараметры = Неопределено;
	
	ВходныеПараметры.Добавить(МассивБиометрия);
	ВходныеПараметры.Добавить(МассивСотрудники);

	Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(ИдентификаторУстройства,
	                                                        "ИнициализацияБД",
	                                                        ВходныеПараметры,
	                                                        ВыходныеПараметры);

	Если Не Результат Тогда
		Предупреждение(ВыходныеПараметры[1]); 
	Иначе
		//Сообщить("Инициализация БД успешно!");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнцициализироватьБДСканераСервер()
	ТаблицаСотрудников = РаботаСБиометричекимиДанными.ПолучитьСотрудниковСБиометрией();
	
	//ТаблицаСотрудников = ПолучитьИзВременногоХранилища(АдресТаблицы);
	Сотрудники.Загрузить(ТаблицаСотрудников);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьБД(Команда)
	ИнициализироватьБДСканера();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройки(Команда)
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.Форма.ПодключениеИНастройкаОборудования",Новый Структура,ЭтаФорма);
КонецПроцедуры
