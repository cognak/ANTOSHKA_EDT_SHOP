
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест"
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеШаблона = Параметры.ДанныеШаблона;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// ПодключаемоеОборудование
	Если МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда
		ОписаниеОшибки = "";

		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("СчитывательМагнитныхКарт");

		Если Не МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО, ОписаниеОшибки) Тогда
			ТекстСообщения = НСтр("ru = 'При подключении оборудования произошла ошибка:
			                      |""%ОписаниеОшибки%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	// ПодключаемоеОборудование
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("СчитывательМагнитныхКарт");

	МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
	// Конец ПодключаемоеОборудование
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
	   И ВводДоступен() Тогда
		Если ИмяСобытия = "TracksData" Тогда
			Если Параметр[1] = Неопределено Тогда
				ДанныеДорожек = Параметр[0];
			Иначе
				ДанныеДорожек = Параметр[1][1];
			КонецЕсли;
			
			ОчиститьСообщения();
			Если НЕ МенеджерОборудованияКлиент.КодСоответствуетШаблонуМК(ДанныеДорожек, ДанныеШаблона) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Карта не соответствует шаблону!'"));
				Возврат;
			КонецЕсли;
			
			// Выводим зашифрованные поля
			Если Параметр[1][3] = Неопределено
				ИЛИ Параметр[1][3].Количество() = 0 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не удалось распознать ни одного поля. Возможно, поля шаблона настроены неверно.'"));
			Иначе
				НайденШаблон = Неопределено;
				Для каждого текШаблон Из Параметр[1][3] Цикл
					Если текШаблон.Шаблон = ДанныеШаблона.Ссылка Тогда
						НайденШаблон = текШаблон;
					КонецЕсли;
				КонецЦикла;
				Если НайденШаблон = Неопределено Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Код не соответствует данному шаблону. Возможно, шаблон настроен неверно.'"));
				Иначе
					ТекстСообщения = НСтр("ru='Карта соответствует шаблону и содержит следующие поля:'")+Символы.ПС+Символы.ПС;
					Итератор = 1;
					Для каждого текПоле Из НайденШаблон.ДанныеДорожек Цикл
						ТекстСообщения = ТекстСообщения + Строка(Итератор)+". "+?(ЗначениеЗаполнено(текПоле.Поле), Строка(текПоле.Поле), "")+" = "+Строка(текПоле.ЗначениеПоля)+Символы.ПС;
						Итератор = Итератор + 1;
					КонецЦикла;
					ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru='Результат расшифровки кода карты'"));
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
КонецПроцедуры