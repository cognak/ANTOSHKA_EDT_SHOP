&НаКлиенте	//	LNK 30.10.2019 11:25:48
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если Истина ИЛИ УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда

		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.РасходныйКассовыйОрдер",
				"АктСписанияДенежныхСредств",
				ПараметрКоманды,
				ПараметрыВыполненияКоманды.Источник,
				Неопределено);

	КонецЕсли;

КонецПроцедуры
