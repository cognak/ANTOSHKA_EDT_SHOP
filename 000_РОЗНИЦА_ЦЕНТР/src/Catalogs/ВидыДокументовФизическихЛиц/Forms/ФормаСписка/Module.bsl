////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ НАСТРОЙКИ ПОРЯДКА ЭЛЕМЕНТОВ

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	
	ПереместитьЭлемент("Вверх");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	
	ПереместитьЭлемент("Вниз");
	
КонецПроцедуры

&НаСервере
Процедура ПереместитьЭлемент(Направление)

	НастройкаПорядкаЭлементов.ПереместитьЭлемент(Список, Элементы.Список, Направление);

КонецПроцедуры
