
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда

		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ЗаказПоставщику",
				"ЗаказПоставщику",
				ПараметрКоманды,
				ПараметрыВыполненияКоманды.Источник,
				Неопределено);

	КонецЕсли;

КонецПроцедуры
