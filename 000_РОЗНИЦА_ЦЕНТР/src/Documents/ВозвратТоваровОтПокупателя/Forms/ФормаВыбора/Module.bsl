
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//А++ 20250211 по задаче https://awdev.atlassian.net/browse/RETAIL1C-1078 
	Если НЕ ВернутьПраваАдмина() Тогда
		Предупреждение(НСтр("ru = 'Доступ запрещен!'; uk = 'Доступ заборонено!'"),,НСтр("ru = 'Ошибка доступа!'; uk = 'Помилка доступу!'"));
		Отказ = Истина;
	КонецЕсли;
	//А++ 20250211 по задаче https://awdev.atlassian.net/browse/RETAIL1C-1078 
КонецПроцедуры

//А++ 20250211 по задаче https://awdev.atlassian.net/browse/RETAIL1C-1078 
&НаСервере
Функция  ВернутьПраваАдмина()
	Возврат Документы.ЗакрытиеЗаказовПокупателей.ВернутьПраваАдминистратора();
КонецФункции

