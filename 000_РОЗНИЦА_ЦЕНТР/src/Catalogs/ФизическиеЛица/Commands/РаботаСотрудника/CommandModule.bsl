
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
		
	Отбор = Новый Структура;
	Отбор.Вставить("Сотрудник", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.РаботаВыполняемаяСотрудниками.ФормаСписка",Новый Структура("Отбор", Отбор), ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
