
&НаКлиенте
Процедура ИзменениеПароляПользователя(Команда)
	
	ОткрытьФорму("Обработка.ИзменениеПароляПользователяИБ.Форма");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерсональныеНастройкиРаботыСФайлами(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПерсональныеНастройкиРаботыСФайлами");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерсональнаяНастройкаПроксиСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера",
	                  Новый Структура("НастройкаПроксиНаКлиенте", Истина));
	
 КонецПроцедуры

&НаКлиенте
Процедура ИзменениеТекущегоМагазина(Команда)
	
	ОткрытьФорму("Обработка.ИзменениеТекущегоМагазина.Форма");

КонецПроцедуры
