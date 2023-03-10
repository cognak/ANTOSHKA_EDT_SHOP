
&НаСервере
Функция ЧекНаВозврат(ЧекККМ)
	
	Возврат ЧекККМ.ВидОперации = Перечисления.ВидыОперацийЧекККМ.Возврат;
	
КонецФункции // СписокПолучателей()

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//МассивНепроведенныхДокументов = ФормированиеПечатныхФормСервер.ПолучитьМассивНепроведенныхДокументов(ПараметрКоманды);
	//
	//Если МассивНепроведенныхДокументов.Количество() > 0 Тогда

	//	Если МассивНепроведенныхДокументов.Количество() = 1 Тогда
	//		ТекстВопроса = НСтр("ru = 'Печать возможна только после проведения документа, провести документ?'")
	//	Иначе
	//		ТекстВопроса = НСтр("ru = 'Печать возможна только после проведения документов, провести документы?'")
	//	КонецЕсли;

	//	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	//	Если Ответ = КодВозвратаДиалога.Да Тогда
	//		МассивНепроведенныхДокументов = ФормированиеПечатныхФормСервер.ПровестиДокументы(МассивНепроведенныхДокументов);
	//	КонецЕсли;

	//КонецЕсли;
	
	Если Не ЧекНаВозврат(ПараметрКоманды[0]) Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Печатается только для Чека на возврат.'"));
		Возврат;

	КонецЕсли;

//	Если МассивНепроведенныхДокументов.Количество() = 0 Тогда

		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЧекККМВозврат", ПараметрКоманды[0]);
		ПараметрыФормы.Вставить("ТипОткрытияФормы", ПредопределенноеЗначение("Перечисление.СпособыОткрытияОбработкиВозвратаОтПокупателя.ТолькоДляПечати"));
		
		ОткрытьФорму("Обработка.ВозвратТоваровОтРозничногоПокупателя.Форма", ПараметрыФормы , ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
			
//	КонецЕсли;

КонецПроцедуры
