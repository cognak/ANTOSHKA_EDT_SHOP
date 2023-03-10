&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда
		ТекстОшибки = "";
		ТаблицаОписьСдаваемыхНаличныхДенег = Неопределено;
		Если ПараметрыВыполненияКоманды.Источник.Элементы.Найти("ТаблицаОписьСдаваемыхНаличныхДенег") = Неопределено Тогда
			ТекстОшибки = НСтр("ru = 'Печать необходимо выполнять из открытой формы документа.'");
		Иначе
			ТаблицаОписьСдаваемыхНаличныхДенег = ПараметрыВыполненияКоманды.Источник.Объект.ТаблицаОписьСдаваемыхНаличныхДенег;
		КонецЕсли;
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.РасходныйКассовыйОрдер",
				"ПечатьОписьЦенностейПриложение4",
				ПараметрКоманды,
				ПараметрыВыполненияКоманды.Источник,
				Новый Структура("ТаблицаОписьСдаваемыхНаличныхДенег, ТекстОшибки, ЧтоПечатается", ТаблицаОписьСдаваемыхНаличныхДенег, ТекстОшибки, "ПечатьОписьЦенностейПриложение4"));
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаКоманды()