#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Объект.Ссылка.Пустая() Тогда
		
		Записать();
		
	КонецЕсли;

	ОтображениеЭлементов();
	ПодключитьОбработчикОжидания("ОтображениеЭлементов", 60);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Статусы.Параметры.УстановитьЗначениеПараметра("Регистратор", Объект.Ссылка);
	
	Элементы.МагазинПолучатель.Видимость = Не Объект.МагазинПолучатель.Пустая();
	
	ВозможностьРедактировать = Не ТехническаяПоддержкаВызовСервера.ИсключительныйРежим();
	
	Элементы.Номер.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.Дата.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ВнешняяСсылка.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ДатаДоставки.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.Реестр.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ЗаказПокупателя.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ДокументОснование.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ОператорДоставки.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ПутьКФайлуСтикера.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ПутьКФайлуТТН.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.СуммаДоставки.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.НашаСуммаДоставки.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.КонтрагентОтправитель.ТолькоПросмотр = ВозможностьРедактировать;
	//Элементы.НомерТелефонаОтправитель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.КонтактноеЛицоОтправитель.ТолькоПросмотр = ВозможностьРедактировать;
	//Элементы.ГородОтправитель.ТолькоПросмотр = ВозможностьРедактировать;
	//Элементы.УлицаОтправитель.ТолькоПросмотр = ВозможностьРедактировать;
	//Элементы.НомерДомаОтправитель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.АдресОтправитель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ОтделениеОтправитель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ФамилияПолучатель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ИмяПолучатель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ОтчествоПолучатель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ТелефонПолучатель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ОбластьПолучатель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ГородПолучатель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.РайонПолучатель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.УлицаПолучатель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ДомПолучатель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.КвартираПолучатель.ТолькоПросмотр = ВозможностьРедактировать;
	Элементы.ОтделениеПолучатель.ТолькоПросмотр = ВозможностьРедактировать;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если ЗначениеЗаполнено(Объект.ДокументОснование)
		И ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗапросДоступностиТоваров") Тогда
		
		ВГХНеЗаполнены = Не ПроверкаПравильностиВГХ();
	
		Если ВГХНеЗаполнены	Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заповнені ВГХ';uk = 'Не заповнені ВГХ'"),
				,
				,
				,
				Отказ);
		КонецЕсли;
		
		Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование,"ОператорДоставки")
				= ПредопределенноеЗначение("Перечисление.ОператорыДоставки.ВнутренняяЛогистика") Тогда
		 
			Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ЗаказПокупателя,"ДоставкаНаАдрес") Тогда
				
				Отделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ЗаказПокупателя,"Отделение");
				
				Если ПустаяСтрока(Отделение)
						Или Отделение = ПредопределенноеЗначение("Справочник.Отделения.ПустаяСсылка")
						Или Отделение = ПредопределенноеЗначение("Справочник.Почтоматы.ПустаяСсылка") Тогда

					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						НСтр("ru = 'Не заповнене відділення';uk = 'Не заповнене відділення'"),
						,
						,
						,
						Отказ);

				КонецЕсли;
				
				ОбъемныйВесПревышен = ПроверитьОбъемныйВес();  
				Если ОбъемныйВесПревышен Тогда

					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						НСтр("ru = 'Перевищена максимальна об''ємна вага для цього відділення!';
						|		uk = 'Перевищена максимальна об''ємна вага для цього відділення!'"),
						,
						,
						,
						Отказ);

				КонецЕсли; 
			Иначе

				Если ПустаяСтрока(Объект.ГородПолучатель)
						Или ПустаяСтрока(Объект.УлицаПолучатель)
						Или ПустаяСтрока(Объект.ДомПолучатель)
						Или Объект.ГородПолучатель = ПредопределенноеЗначение("Справочник.ГородаДоставки.ПустаяСсылка")
						Или Объект.УлицаПолучатель = ПредопределенноеЗначение("Справочник.Улицы.ПустаяСсылка") Тогда 

					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						НСтр("ru = 'Не заповнені адресні дані';uk = 'Не заповнені адресні дані'"),
						,
						,
						,
						Отказ);

				КонецЕсли; 
				
			КонецЕсли;
	
			Если ПустаяСтрока(Объект.ИмяПолучатель) Тогда

				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Не заповнено ім''я!';uk = 'Не заповнено ім''я!'"),
					,
					,
					,
					Отказ);

			КонецЕсли;    

			Если ПустаяСтрока(Объект.ФамилияПолучатель) тогда

				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Чи не заповнене прізвище!';uk = 'Чи не заповнене прізвище!'"),
					,
					,
					,
					Отказ);

			КонецЕсли;    
			
			Телефон = СокрЛП(Объект.ТелефонПолучатель); 
			Если СтрДлина(Телефон)<> 12 или Лев(Телефон,3)<>"380"	тогда

				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Неправильний номер телефону.';uk = 'Неправильний номер телефону.'"),
					,
					,
					,
					Отказ);

			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗаписанаЭлектроннаяНакладная");
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерТелефонаОтправительПриИзменении(Элемент)
	Если Не ПустаяСтрока(Объект.ТелефонПолучатель) тогда
		Поз = СтрНайти(Объект.ТелефонПолучатель, " ");
		Если Поз <> 0 тогда    

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Неправильно введено телефон!';uk = 'Неправильно введено телефон!'"),
				,
				"ТелефонПолучатель",
				"Объект",
				);

		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтправкаИзМагазинаПриИзменении(Элемент)
	ОтображениеЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ОтделениеПолучательПриИзменении(Элемент)
	
	ОтображениеЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура КонтактноеЛицоОтправительПриИзменении(Элемент)
	
	ИзменитьТелефон();

КонецПроцедуры

&НаКлиенте
Процедура АдресОтправительПриИзменении(Элемент)
	
	ИзменитьАдрес();

КонецПроцедуры

&НаКлиенте
Процедура ПоставщикСлужбойДоставкиПриИзменении(Элемент)
	
	ДанныеПоставщика = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ПоставщикСлужбойДоставки, "АдресСлужбыДоставки,
								| КонтактноеЛицоСлужбыДоставки,
								| Город,
								| Отделение,
								| ОтправкаИзОтделения");
	Объект.КонтактноеЛицоОтправитель = ДанныеПоставщика.КонтактноеЛицоСлужбыДоставки;
	Объект.АдресОтправитель = ДанныеПоставщика.АдресСлужбыДоставки;
	Объект.ГородОтправитель = ДанныеПоставщика.Город;
	Объект.ОтделениеОтправитель = ДанныеПоставщика.Отделение;
	Объект.ОтправкаИзМагазина = Не ДанныеПоставщика.ОтправкаИзОтделения;
	
	ИзменитьТелефон();

	Если Не ДанныеПоставщика.ОтправкаИзОтделения Тогда
		ИзменитьАдрес();
	КонецЕсли;

	ОтображениеЭлементов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерезаполнитьДокумент(Команда)
	
	ПерезаполнитьДокументНаСервере();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПосылкаПолучена(Команда)
	ПосылкаПолученаНаСервере();
	ОтображениеЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДокументы(Команда)
	ПолучитьДокументыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьНакладную(Команда)
	
	ОтменитьНакладнуюНаСервере();
	ОтображениеЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНакладную(Команда)
	Если Модифицированность Или Объект.Ссылка.Пустая() Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Треба записати документ.';uk = 'Треба записати документ.'"));

	Иначе
		
		Если Объект.ОператорДоставки = ПредопределенноеЗначение("Перечисление.ОператорыДоставки.НоваяПочта") Тогда
			Если ПустаяСтрока(Объект.ВнешняяСсылка) тогда
				ТТННаСервере();
			Иначе

				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'ТТН вже створено, повторне створення неможливе!';
					|		uk = 'ТТН вже створено, повторне створення неможливе!'"));

			КонецЕсли;
		Иначе 

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Створення ТТН можливе лише для оператора НОВА ПОШТА!';
				|		uk = 'Створення ТТН можливе лише для оператора НОВА ПОШТА!'"));

		КонецЕсли;    
	КонецЕсли;

	ОтображениеЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСтатус(Команда)
	ПолучитьСтатусНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает признак рабочего отделения.
// 
// Параметры:
//  СсылкаНаОтделение - СправочникСсылка, Строка - Ссылка на отделение
// 
// Возвращаемое значение:
//  Булево - Отделение не работает
&НаСервереБезКонтекста
Функция ОтделениеНеРаботает(СсылкаНаОтделение)
	
	Возврат Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаОтделение, "Работает", Ложь, Ложь);
	
КонецФункции

&НаСервере
Функция ПроверитьОбъемныйВес() 
	
	Возврат ОбменНПСервер.ПроверитьОбъемныйВес(Объект.ДокументОснование, Объект.ОтделениеПолучатель);

КонецФункции

&НаСервере
Процедура ПолучитьСтатусНаСервере()
	
	Если Не ПустаяСтрока(Объект.Номер) Тогда
		
		ОбменНПСервер.ПолучитьСтатусТТН(, Объект.Номер);
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОтменитьНакладнуюНаСервере()
	
	Если ПустаяСтрока(Объект.Номер) Тогда
		
		РегистрыСведений.СтатусыЭН.ОтменитьПосылку(Объект); 
	
	Иначе 
			
		Если РегистрыСведений.СтатусыЭН.ПосылкаВДороге(Объект) Тогда
	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'За цим документом ініційовано рух посилки, редагування заборонено!';
				|		uk = 'За цим документом ініційовано рух посилки, редагування заборонено!'"));
	
		Иначе

			ОбменНПСервер.УдалитьИзРеестра(Объект.Ссылка, Объект.ВнешняяСсылка);
			Объект.Реестр = Документы.РеестрЭН.ПустаяСсылка();

			Если СокрЛП(Объект.ВнешняяСсылка) = СокрЛП(ОбменНПСервер.УдалитьНакладную(Объект.ВнешняяСсылка)) Тогда
		
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Накладну видалено';uk = 'Накладну видалено'"));
						
				ОбменНПСервер.ПолучитьСтатусТТН(, Объект.Номер);

				Записать();
				
			Иначе
		
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Помилка видалення накладної. Спробуйте через деякий час.';
					|		uk = 'Помилка видалення накладної. Спробуйте через деякий час.'"));
	
			КонецЕсли;
	
		КонецЕсли;
			
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПолучитьДокументыНаСервере()
	СтруктураОтветаЭН = ОбменНПСервер.СтруктураОтветаПоЭНИнициализация(Объект.ДокументОснование);
	
	СтруктураОтветаЭН.НомерТТН = СокрЛП(Объект.Номер);
	СтруктураОтветаЭН.ТТНRef = Объект.ВнешняяСсылка;
	ФайлыДляНакладной = ОбменНПСервер.СохранитьТТНвPDF(СтруктураОтветаЭН);
	
	Объект.ПутьКФайлуТТН = ФайлыДляНакладной.ПутьКФайлуТТН;
	Объект.ПутьКФайлуТТННакладная = ФайлыДляНакладной.ПутьКФайлуТТННакладная;
	Объект.ПутьКФайлуСтикера = ФайлыДляНакладной.ПутьКФайлуСтикера;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПосылкаПолученаНаСервере()
	
	ТекДата = ТекущаяДатаСеанса();
	
	СтатусПосылки = ОбменНПСервер.ПолучитьСтатусЭН(Объект.Ссылка);

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КодыСтатусовТТН.Ссылка
		|ИЗ
		|	Справочник.КодыСтатусовТТН КАК КодыСтатусовТТН
		|ГДЕ
		|	КодыСтатусовТТН.ОператорДоставки = &ОператорДоставки
		|	И КодыСтатусовТТН.СтатусПосылки = &СтатусПосылки";
	
	Запрос.УстановитьПараметр("ОператорДоставки", Объект.ОператорДоставки);

	Если СтатусПосылки.СтатусСлужбыДоставки = ПредопределенноеЗначение("Перечисление.СтатусыПосылокСлужбыДоставки.Новая") Тогда
	
		ПараметрСтатусПосылки = Перечисления.СтатусыПосылокСлужбыДоставки.ВДороге;

	ИначеЕсли СтатусПосылки.СтатусСлужбыДоставки = ПредопределенноеЗначение("Перечисление.СтатусыПосылокСлужбыДоставки.ВДороге") Тогда 
	
		ПараметрСтатусПосылки = Перечисления.СтатусыПосылокСлужбыДоставки.Доставлена;

	ИначеЕсли СтатусПосылки.СтатусСлужбыДоставки = ПредопределенноеЗначение("Перечисление.СтатусыПосылокСлужбыДоставки.Доставлена") Тогда 
	
		ПараметрСтатусПосылки = Перечисления.СтатусыПосылокСлужбыДоставки.Получена;

	Иначе
	
		ПараметрСтатусПосылки = Перечисления.СтатусыПосылокСлужбыДоставки.ПустаяСсылка();

	КонецЕсли;
	
	Если Не ПараметрСтатусПосылки = Перечисления.СтатусыПосылокСлужбыДоставки.ПустаяСсылка() Тогда
		
		Запрос.УстановитьПараметр("СтатусПосылки", ПараметрСтатусПосылки);
	
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			СтатусТТН = Выборка.Ссылка;
			
			НаборЗаписей = РегистрыСведений.СтатусыЭН.СоздатьНаборЗаписей(); 
	
			НаборЗаписей.Отбор.ДокументРегистратор.Установить(Объект.Ссылка); 
			НаборЗаписей.Отбор.Период.Установить(ТекДата); 
	
			НоваяЗапись 					= НаборЗаписей.Добавить();
			НоваяЗапись.ДокументРегистратор = Объект.Ссылка; 
			НоваяЗапись.Период 				= ТекДата;
			НоваяЗапись.СтатусЭН   			= СтатусТТН; 
			НаборЗаписей.Записать();  
		КонецЕсли;
				
	КонецЕсли;


КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьДокументНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьДокумент(ДокументОбъект, Объект.ДокументОснование);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Функция НакладнаяУОператора()

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	СтатусыЭНСрезПоследних.СтатусЭН.СтатусПосылки КАК СтатусПосылки
		|ИЗ
		|	РегистрСведений.СтатусыЭН.СрезПоследних(, ДокументРегистратор = &ДокументРегистратор) КАК СтатусыЭНСрезПоследних";
	
	Запрос.УстановитьПараметр("ДокументРегистратор", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Результат = Не (Выборка.СтатусПосылки = Перечисления.СтатусыПосылокСлужбыДоставки.Новая);
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ОтображениеЭлементов()

	СтатусПосылки = ПолучитьСтатусЭН();
	СтатусДокумента = СтатусПосылки.СтатусЭН;
	ПосылкаОтменена = (СтатусПосылки.СтатусСлужбыДоставки = ПредопределенноеЗначение("Перечисление.СтатусыПосылокСлужбыДоставки.Отменена"));
	ПосылкаСоздана = Не ПустаяСтрока(Объект.ВнешняяСсылка);

	Элементы.ГруппаОтправительАдрес.Видимость = Объект.ОтправкаИзМагазина;
	Элементы.ГруппаОтправительОтделение.Видимость = Не Объект.ОтправкаИзМагазина;
	Элементы.ГородОтправитель.ТолькоПросмотр = Объект.ОтправкаИзМагазина;

	Элементы.ГруппаПолучательАдрес.Видимость = Объект.ДоставкаНаАдрес;
	Элементы.ГруппаПолучательОтделение.Видимость = Не Объект.ДоставкаНаАдрес;
	
	Элементы.ФормаОтменитьНакладную.Видимость = Не НакладнаяУОператора();
												
	Элементы.ФормаСоздатьНакладную.Видимость = Не ПосылкаСоздана И Не ПосылкаОтменена;

	Элементы.ПерезаполнитьДокумент.Видимость = Не ПосылкаСоздана И Не ПосылкаОтменена;

	Элементы.ФормаПолучитьДокументы.Видимость = ПосылкаСоздана И Не ПосылкаОтменена;
												
	Если СтатусПосылки.СтатусСлужбыДоставки = ПредопределенноеЗначение("Перечисление.СтатусыПосылокСлужбыДоставки.Новая") Тогда
		
		ЗаголовокКнопки = "Отдана курьеру";
		ВидимостьКнопки = Истина;
		
	ИначеЕсли СтатусПосылки.СтатусСлужбыДоставки = ПредопределенноеЗначение("Перечисление.СтатусыПосылокСлужбыДоставки.ВДороге") Тогда 
		
		ЗаголовокКнопки = "Посылка доставлена";
		ВидимостьКнопки = Истина;
		
	ИначеЕсли СтатусПосылки.СтатусСлужбыДоставки = ПредопределенноеЗначение("Перечисление.СтатусыПосылокСлужбыДоставки.Доставлена") Тогда 
		
		ЗаголовокКнопки = "Посылка получена";
		ВидимостьКнопки = Истина;
		
	Иначе

		ВидимостьКнопки = Ложь;
		
	КонецЕсли;
	
	Элементы.ПосылкаПолучена.Видимость = ВидимостьКнопки;
	Элементы.ПосылкаПолучена.Заголовок = ЗаголовокКнопки;

	Элементы.Статусы.Обновить();

	Элементы.ОтделениеНеРаботает.Видимость = ОтделениеНеРаботает(Объект.ОтделениеПолучатель);
	
	Элементы.ПоставщикСлужбойДоставки.Видимость = Объект.СтороннийОтправитель;

	Оповестить();

КонецПроцедуры

&НаСервере
Функция ПолучитьСтатусЭН()

	Возврат ОбменНПСервер.ПолучитьСтатусЭН(Объект.Ссылка);
	
КонецФункции

&НаСервере
Процедура ТТННаСервере()

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ТаблицаЗаказа.ТипОплаты,
		|			ЗНАЧЕНИЕ(Перечисление.ТипОплатыЗаказПокупателя.Наличные)) = ЗНАЧЕНИЕ(Перечисление.ТипОплатыЗаказПокупателя.Наличные)
		|		ИЛИ ЕСТЬNULL(ТаблицаЗаказа.ТипОплаты,
		|			ЗНАЧЕНИЕ(Перечисление.ТипОплатыЗаказПокупателя.БРПостоплата)) = ЗНАЧЕНИЕ(Перечисление.ТипОплатыЗаказПокупателя.БРПостоплата)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ТаблицаЗаказа.СтатусОплаты = ЗНАЧЕНИЕ(Перечисление.СтатусОплаты.Оплачен)
		|	КОНЕЦ КАК ПрошлаБезнальнаяОплата,
		|	ЭлектроннаяНакладная.Ссылка
		|ИЗ
		|	Документ.ЭлектроннаяНакладная КАК ЭлектроннаяНакладная
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя КАК ТаблицаЗаказа
		|		ПО ЭлектроннаяНакладная.ЗаказПокупателя = ТаблицаЗаказа.Ссылка
		|ГДЕ
		|	ЭлектроннаяНакладная.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Если Выборка.ПрошлаБезнальнаяОплата Тогда

		ОтветЭН = ОбменНПСервер.РегистрацияЕН(Объект.Ссылка);
		Если ОтветЭН.Успех Тогда
			
			ПараметрыЗаписи = Новый Структура;
			ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Електронна накладна зареєстрована';uk = 'Електронна накладна зареєстрована'"));
	
			Объект.ДатаДоставки = ОтветЭН.ДатаДоставки;
			Объект.СуммаДоставки = ОтветЭН.СуммаОтОператора;
			Объект.Номер = ОтветЭН.НомерТТН;
			Объект.ВнешняяСсылка = ОтветЭН.ТТНRef;
			Записать(ПараметрыЗаписи);
			ОбменНПСервер.ПолучитьСтатусТТН(, Объект.Номер, Истина);
	
			ФайлыДляНакладной = ОбменНПСервер.СохранитьТТНвPDF(ОтветЭН);
			Объект.ПутьКФайлуТТН = ФайлыДляНакладной.ПутьКФайлуТТН;
			Объект.ПутьКФайлуТТННакладная = ФайлыДляНакладной.ПутьКФайлуТТННакладная;
			Объект.ПутьКФайлуСтикера = ФайлыДляНакладной.ПутьКФайлуСтикера;
	
			Записать(ПараметрыЗаписи);
		Иначе
	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Внаслідок реєстрації електронної накладної виникла помилка! Спробуйте через деякий час.';
				|		uk = 'Внаслідок реєстрації електронної накладної виникла помилка! Спробуйте через деякий час.'"));
	
		КонецЕсли;
	Иначе

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Заказ имеет безналичную форму оплаты, но не оплачен. Свяжитесь с КЦ.';
			|		uk = 'Замовлення має безготівкову форму оплати, але не сплачено. Зв`яжіться з КЦ.'"));

	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПроверкаПравильностиВГХ()

	 Запрос = Новый Запрос;
	 Запрос.Текст =
	 	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	 	|	ЗапросДоступностиТоваровУпаковки.Ссылка
	 	|ИЗ
	 	|	Документ.ЗапросДоступностиТоваров.Упаковки КАК ЗапросДоступностиТоваровУпаковки
	 	|ГДЕ
	 	|	ЗапросДоступностиТоваровУпаковки.Ссылка = &Ссылка
	 	|	И (Не (ЗапросДоступностиТоваровУпаковки.Ширина = 0
	 	|	ИЛИ ЗапросДоступностиТоваровУпаковки.Высота = 0
	 	|	ИЛИ ЗапросДоступностиТоваровУпаковки.Глубина = 0
	 	|	ИЛИ ЗапросДоступностиТоваровУпаковки.Вес = 0))";
	 
	 Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
	 
	 Результат = Не Запрос.Выполнить().Пустой();

	Возврат Результат; 

КонецФункции

&НаКлиенте
Процедура ИзменитьТелефон()

	ТелефонКонтактногоЛица = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.КонтактноеЛицоОтправитель, "Телефон");
	Объект.НомерТелефонаОтправитель = ТелефонКонтактногоЛица;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьАдрес()

	ДанныеАдреса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.АдресОтправитель, "ИДГорода, ИДУлицы, Дом");
	Объект.ГородОтправитель = ДанныеАдреса.ИДГорода;
	Объект.УлицаОтправитель = ДанныеАдреса.ИДУлицы;
	Объект.НомерДомаОтправитель = ДанныеАдреса.Дом;

КонецПроцедуры

#КонецОбласти
