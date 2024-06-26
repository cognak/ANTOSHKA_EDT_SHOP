
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
//	Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда

		Возврат;

	КонецЕсли;

	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	ИспользоватьАссортимент = АссортиментСервер.ПолучитьФункциональнуюОпциюИспользованияАссортимента();
	Если НЕ ИспользоватьАссортимент Тогда
		Элементы.ФорматМагазина.Видимость=Ложь;
		Элементы.КонтролироватьАссортимент.Видимость=Ложь;
	КонецЕсли;

	Список.Параметры.УстановитьЗначениеПараметра("Период", ТекущаяДата());	//	LNK 15.11.2023 12:50:00
	Список.Параметры.УстановитьЗначениеПараметра("ИсключительныйРежим", ТехническаяПоддержкаВызовСервера.ИсключительныйРежим());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СозданНовыйМагазин" И ТипЗнч(Параметр) = Тип("СправочникСсылка.Магазины") Тогда
		
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = Параметр;
		
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Копирование Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Копирование магазинов запрещено.'"));		
	Иначе  	
		ОткрытьФорму("Справочник.Магазины.Форма.ПомощникНового",,ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьПодпись(Команда)
	
	ОПовещение = Новый ОписаниеОповещения("ОбработкаФайлавыбора",ЭтотОбъект,Элементы.Список.ТекущиеДанные.Ссылка);	
	НачатьПомещениеФайла(ОПовещение,,,Истина,УникальныйИдентификатор);
	
КонецПроцедуры

	
&НаСервере
Процедура ОбработкаФайлавыбора(Результат, Адрес, ВыбранноеИмя,ДополнительныеПараметры)
	Если Не Результат тогда
		Возврат;
	КонецЕсли;
	Если ЭтоАдресВременногоХранилища(Адрес) тогда
		Если РольДоступна("АдминистраторСистемы") тогда
			Спр = ДополнительныеПараметры.ПолучитьОбъект();
		Иначе
			Спр = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин.ПолучитьОбъект();
		КонецЕсли;
		Спр.ОбменДанными.Загрузка = Истина;
		Спр.Подпись =  Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Адрес));;
		УстановитьПривилегированныйРежим(Истина);
		Спр.Записать();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
