
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	МассивНепроведенныхДокументов = ФормированиеПечатныхФормСервер.ПолучитьМассивНепроведенныхДокументов(ПараметрКоманды);
	
	Если МассивНепроведенныхДокументов.Количество() > 0 Тогда

		Если МассивНепроведенныхДокументов.Количество() = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Печать возможна только после проведения документа, провести документ?'")
		Иначе
			ТекстВопроса = НСтр("ru = 'Печать возможна только после проведения документов, провести документы?'")
		КонецЕсли;

		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			МассивНепроведенныхДокументов = ФормированиеПечатныхФормСервер.ПровестиДокументы(МассивНепроведенныхДокументов);
		КонецЕсли;

	КонецЕсли;

	Если МассивНепроведенныхДокументов.Количество() = 0 Тогда

		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ЛистЖеланий",
				"ЛистЖеланий",
				ПараметрКоманды,
				ПараметрыВыполненияКоманды.Источник,
				);

	КонецЕсли;
КонецПроцедуры
