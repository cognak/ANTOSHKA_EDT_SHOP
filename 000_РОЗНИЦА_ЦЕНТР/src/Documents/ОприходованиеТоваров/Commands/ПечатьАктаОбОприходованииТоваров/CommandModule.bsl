
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда

		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ОприходованиеТоваров",
				"АктОбОприходованииТоваров",
				ПараметрКоманды,
				ПараметрыВыполненияКоманды.Источник,
				Неопределено);

	КонецЕсли;

КонецПроцедуры
