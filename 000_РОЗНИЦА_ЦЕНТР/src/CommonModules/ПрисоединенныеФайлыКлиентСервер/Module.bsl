
// Обработчик подписки присоединенного файла на событие "Обработка получения формы".
Процедура ПереопределитьПолучаемуюФормуПрисоединенногоФайла(Источник,
                                                      ВидФормы,
                                                      Параметры,
                                                      ВыбраннаяФорма,
                                                      ДополнительнаяИнформация,
                                                      СтандартнаяОбработка) Экспорт
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		ВыбраннаяФорма = "ОбщаяФорма.ПрисоединенныйФайл";
		СтандартнаяОбработка = Ложь;
		
	ИначеЕсли ВидФормы = "ФормаСписка" Тогда
		ВыбраннаяФорма = "ОбщаяФорма.ПрисоединенныеФайлы";
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры
