
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДокументыМассив = Новый Массив;
	ДокументыМассив.Добавить(ПараметрКоманды);
	
	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ДокументыМассив) Тогда
		
		ПараметрыФормы = Новый Структура("ДокументОснование", ПараметрКоманды);
		ОткрытьФорму("Документ.ПересортицаТоваров.Форма.ПодборПересортицыТоваров", ПараметрыФормы)
		
	КонецЕсли;
	
	
КонецПроцедуры
