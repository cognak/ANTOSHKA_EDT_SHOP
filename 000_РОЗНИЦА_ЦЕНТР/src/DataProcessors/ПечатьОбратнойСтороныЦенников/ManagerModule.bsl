
// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "1на1") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "1на1",
				"1на1",
				Печать1на1(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,,Истина)
		
	КонецЕсли;

		Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "2на2") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "2на2",
				"2на2",
				Печать2на2(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,,Истина)
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "7на5") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "7на5",
				"7на5",
				Печать7на5(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,,Истина)
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "3на5") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "3на5",
				"3на5",
				Печать3на5(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,,Истина)
		
	КонецЕсли;
	


КонецПроцедуры
	
Функция Печать1на1(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
ТабличныйДокумент  = Новый ТабличныйДокумент;
КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
Макет = УправлениеПечатью.ПолучитьМакет("Обработка.ПечатьОбратнойСтороныЦенников.ц1на1", КодЯзыкаПечать);
Область = Макет.ПолучитьОбласть("ОбластьЗаголовок");
Область.Параметры.ЦеныНаДату = МассивОбъектов;
Область.Рисунки.D1.Картинка = УправлениеПечатьюВызовСервера.ПолучитьПодписьМагазина();
ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ц1на1";
ТабличныйДокумент.АвтоМасштаб = иСТИНА;
ТабличныйДокумент.Вывести(Область); 
Возврат   ТабличныйДокумент;
	
КонецФункции
	
Функция Печать2на2(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
ТабличныйДокумент  = Новый ТабличныйДокумент;
КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
Макет = УправлениеПечатью.ПолучитьМакет("Обработка.ПечатьОбратнойСтороныЦенников.ц2на2", КодЯзыкаПечать);
Область = Макет.ПолучитьОбласть("ОбластьЗаголовок");
Область.Параметры.ЦеныНаДату = Формат(МассивОбъектов,"ДФ=dd.MM.yyyy");
Ц = 0;
Рисунок = УправлениеПечатьюВызовСервера.ПолучитьПодписьМагазина();
Пока Ц < 4 цикл
ц = ц +1;	
Область.Рисунки["D"+ц].Картинка = Рисунок;
КонецЦикла;
ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ц2на2";
ТабличныйДокумент.АвтоМасштаб = иСТИНА;
ТабличныйДокумент.Вывести(Область); 
Возврат   ТабличныйДокумент;
	
КонецФункции
	
Функция Печать7на5(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
ТабличныйДокумент  = Новый ТабличныйДокумент;
КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
Макет = УправлениеПечатью.ПолучитьМакет("Обработка.ПечатьОбратнойСтороныЦенников.ц7на5", КодЯзыкаПечать);
Область = Макет.ПолучитьОбласть("ОбластьЗаголовок");
Область.Параметры.ЦеныНаДату = Формат(МассивОбъектов,"ДФ=dd.MM.yyyy");
Ц = 0;
Рисунок = УправлениеПечатьюВызовСервера.ПолучитьПодписьМагазина();

Пока Ц < 30 цикл
ц = ц +1;	
Область.Рисунки["B"+ц].Картинка = Рисунок;
КонецЦикла;
ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ц7на5";
ТабличныйДокумент.АвтоМасштаб = иСТИНА;    
ТабличныйДокумент.Вывести(Область); 
Возврат   ТабличныйДокумент;
	
КонецФункции
	
Функция Печать3на5(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
ТабличныйДокумент  = Новый ТабличныйДокумент;
КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
Макет = УправлениеПечатью.ПолучитьМакет("Обработка.ПечатьОбратнойСтороныЦенников.ц3на5", КодЯзыкаПечать);
Область = Макет.ПолучитьОбласть("ОбластьЗаголовок");
Область.Параметры.ЦеныНаДату = Формат(МассивОбъектов,"ДФ=dd.MM.yyyy");
Ц = 0;
Рисунок = УправлениеПечатьюВызовСервера.ПолучитьПодписьМагазина();

Пока Ц < 20 цикл
ц = ц +1;	
Область.Рисунки["B"+ц].Картинка = Рисунок;
КонецЦикла;
ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ц3на5";
ТабличныйДокумент.АвтоМасштаб = иСТИНА;
ТабличныйДокумент.Вывести(Область); 
Возврат   ТабличныйДокумент;
	
КонецФункции
