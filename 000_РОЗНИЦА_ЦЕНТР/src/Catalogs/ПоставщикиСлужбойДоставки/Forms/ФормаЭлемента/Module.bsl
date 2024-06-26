
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОтображениеЭлементов()
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтправкаИзОтделенияПриИзменении(Элемент)
	
	ОтображениеЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура АдресСлужбыДоставкиПриИзменении(Элемент)
	АдресСлужбыДоставкиПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтображениеЭлементов()
	
	Элементы.ОтправкаНаАдрес.Видимость = Не Объект.ОтправкаИзОтделения;
	Элементы.ОтправкаНаОтделение.Видимость = Объект.ОтправкаИзОтделения;
	Элементы.Город.ТолькоПросмотр = Не Объект.ОтправкаИзОтделения;
	
КонецПроцедуры

&НаСервере
Процедура АдресСлужбыДоставкиПриИзмененииНаСервере()
	
	Объект.Город = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.АдресСлужбыДоставки, "ИДГорода");

КонецПроцедуры

#КонецОбласти
