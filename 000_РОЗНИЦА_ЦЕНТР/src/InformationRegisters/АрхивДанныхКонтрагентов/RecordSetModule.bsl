//	LNK 04.09.2019 12:58:27
Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда

		Возврат;

	КонецЕсли;

	Если ПустаяСтрока(ИмяПользователя()) ИЛИ ИмяПользователя() = УправлениеДоступомСлужебныйПовтИсп.ИдентификаторWebПосредника() Тогда
		
		Ответственный = Справочники.Пользователи.АдминистраторАвтоматов;

	Иначе

		Попытка

			Ответственный = ПользователиКлиентСервер.ТекущийПользователь();

		Исключение
		
			Ответственный = Справочники.Пользователи.АдминистраторАвтоматов;

		КонецПопытки;
	
	КонецЕсли;

	Для каждого ЗаписьНабора Из ЭтотОбъект Цикл

		ЗаписьНабора.Ответственный = Ответственный;

		Если ЗаписьНабора.ЭлементСтруктуры.Пустая() Тогда

			ЗаписьНабора.ЭлементСтруктуры = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().ЭлементСтруктуры;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры
