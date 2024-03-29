
&НаСервере
Процедура МагазинПриИзмененииНаСервере()
	
	Объект.ТЧ.Очистить();	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДоступноеКоличествоРазмещенийРекламныхМатериаловСрезПоследних.Магазин КАК Магазин,
		|	ДоступноеКоличествоРазмещенийРекламныхМатериаловСрезПоследних.РазмещениеРекламныхМатериалов КАК РазмещениеРекламныхМатериалов,
		|	ДоступноеКоличествоРазмещенийРекламныхМатериаловСрезПоследних.ДоступноеРазмещение КАК ДоступноеРазмещение
		|ИЗ
		|	РегистрСведений.ДоступноеКоличествоРазмещенийРекламныхМатериалов.СрезПоследних(, Магазин = &Магазин) КАК ДоступноеКоличествоРазмещенийРекламныхМатериаловСрезПоследних";
	
	Запрос.УстановитьПараметр("Магазин",Объект.Магазин);
	РезультатЗапроса = Запрос.Выполнить();
	Объект.ТЧ.Загрузить(РезультатЗапроса.Выгрузить());
	КонецПроцедуры

&НаКлиенте
Процедура МагазинПриИзменении(Элемент)
	МагазинПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()
	Для каждого строка из Объект.ТЧ цикл
		НаборЗаписей = РегистрыСведений.ДоступноеКоличествоРазмещенийРекламныхМатериалов.СоздатьНаборЗаписей(); 

		НаборЗаписей.Отбор.Магазин.Установить(Объект.Магазин);
		НаборЗаписей.Отбор.Период.Установить(ТекущаяДата()); 
		НаборЗаписей.Отбор.РазмещениеРекламныхМатериалов.Установить(Строка.РазмещениеРекламныхМатериалов);

		НовЗапись = НаборЗаписей.Добавить();
		НовЗапись.Магазин = Объект.Магазин;
		НовЗапись.Период = ТекущаяДата();
		НовЗапись.РазмещениеРекламныхМатериалов = Строка.РазмещениеРекламныхМатериалов;
		НовЗапись.ДоступноеРазмещение = Строка.ДоступноеРазмещение; 

		НаборЗаписей.Записать(Истина);	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьНаСервере();
КонецПроцедуры
