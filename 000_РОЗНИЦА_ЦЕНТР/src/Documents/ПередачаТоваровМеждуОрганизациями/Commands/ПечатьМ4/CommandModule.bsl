
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда

		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ПередачаТоваровМеждуОрганизациями",
				"М4",
				ПараметрКоманды,
				ПараметрыВыполненияКоманды.Источник,
				Неопределено);

	КонецЕсли;

КонецПроцедуры
