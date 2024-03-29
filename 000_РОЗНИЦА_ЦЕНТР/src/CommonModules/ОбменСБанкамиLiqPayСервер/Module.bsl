#Область ОбщийИнтерфейс

Функция ОплатитьНаСервере(НомерЗаказа, СсылкаНаДокумент, НомерТелефонаКлиента, НомерОплаты, СуммаОплаты, ПрошлыйИД, НоваяОплата = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеLiqPay = ОбменСБанкамиПовтИсп.ДанныеLiqPay();
	
 	АдресСайта = ДанныеLiqPay.АдресСайта;
	Порт = ДанныеLiqPay.Порт;
	Логин = ДанныеLiqPay.Логин;
	Пароль = ДанныеLiqPay.Пароль;
	ИмяКаталога = "/";
	FTPСоединение = Новый FTPСоединение(АдресСайта,Порт,Логин,Пароль);
	FTPСоединение.УстановитьТекущийКаталог(ИмяКаталога);
	FTPСоединение.Удалить(ИмяКаталога, ПрошлыйИД + ".html");  
	
	order_УН = СтрЗаменить(Новый УникальныйИдентификатор, "-", "");

	Если НоваяОплата Тогда 
	
		order_id = СокрЛП(НомерЗаказа) + ?(НомерОплаты = 0, "", "-" + Строка(НомерОплаты));
		summa = Формат(СуммаОплаты, "ЧРД=.; ЧГ=0");
		
		public_key = ДанныеLiqPay.public_key; 
		
		СтруктураЗапроса = Новый Структура;
		СтруктураЗапроса.Вставить("action", "pay");
		СтруктураЗапроса.Вставить("amount", summa);
		СтруктураЗапроса.Вставить("currency", "UAH");
		СтруктураЗапроса.Вставить("description", "Заказ № " + order_id);
		СтруктураЗапроса.Вставить("order_id", order_id);
		СтруктураЗапроса.Вставить("version", "3");
		СтруктураЗапроса.Вставить("server_url", "https://cbone.antoshka.ua/" + order_УН);
		СтруктураЗапроса.Вставить("public_key", public_key); 
		
		ЗаписьJSON = Новый ЗаписьJSON; 
	    ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет)); 
		ЗаписатьJSON(ЗаписьJSON,СтруктураЗапроса);
	    СтрокаJSON = ЗаписьJSON.Закрыть();
	    СтрокаJSON = СтрЗаменить(СтрокаJSON, " ", "");
		
		ДанныеДляОтправки = ОбменСБанкамиСервер.СформироватьДанныеLiqPay(СтрокаJSON);
		
		ТекстДокумента = "<!DOCTYPE html>";
		ТекстДокумента = ТекстДокумента + "<html><head><title>Главная страница сайта</title></head>";
		ТекстДокумента = ТекстДокумента + "<body><h1>Заказ № " + order_id + ". Сумма оплаты: " + Формат(summa, "ЧРД=.; ЧГ=0") + "</h1>";
		ТекстДокумента = ТекстДокумента + "<form method='post' action='https://www.liqpay.ua/api/3/checkout/' accept-charset='utf-8'>";
		ТекстДокумента = ТекстДокумента + "<input type='hidden' name='data' value='" + ДанныеДляОтправки.Данные + "'/>";
		ТекстДокумента = ТекстДокумента + "<input type='hidden' name='signature' value='" + ДанныеДляОтправки.Сигнатура + "'/>";
		ТекстДокумента = ТекстДокумента + "<input type='image' src='//static.liqpay.ua/buttons/p1ru.radius.png' name='btn_text' />";
		ТекстДокумента = ТекстДокумента + "</form></body></html>";
		
		ТекстовыйДок = Новый ТекстовыйДокумент;
		ТекстовыйДок.ДобавитьСтроку(ТекстДокумента);
		ВременныйФайл = ПолучитьИмяВременногоФайла();
		ТекстовыйДок.Записать(ВременныйФайл);
		FTPСоединение.Записать(ВременныйФайл, order_УН + ".html");
		
		ДатаСообщения = ТекущаяДатаСеанса();
		
		ТекстСообщенияКлиенту = "Посилання для оплати https://cbone.antoshka.ua/" + order_УН; 
		
		СтруктураСообщенияКлиенту = РегистрыСведений.СообщениеКлиенту.СтруктураЗаписиРегистра(); 
		
		СтруктураСообщенияКлиенту.Дата 						= ДатаСообщения;
		СтруктураСообщенияКлиенту.ИДСообщения 				= "Новое";
		СтруктураСообщенияКлиенту.ТекстСообщения 			= ТекстСообщенияКлиенту;
		СтруктураСообщенияКлиенту.ТипСообщения 				= Перечисления.ТипыСообщенийКлиенту.Viber;
		СтруктураСообщенияКлиенту.СостояниеСообщения 		= Перечисления.СостояниеСообщенийКлиенту.Новое;
		СтруктураСообщенияКлиенту.Телефон 					= НомерТелефонаКлиента;
		СтруктураСообщенияКлиенту.ДатаСледующейОтправки 	= ДатаСообщения; 
		
		РегистрыСведений.СообщениеКлиенту.ЗаписьСообщенияВРегистр(СтруктураСообщенияКлиенту);  
		
		РегистрыСведений.КомментарийИнтернетЗаказа.ЗаписьКомментария(СсылкаНаДокумент, ПараметрыСеанса.ТекущийПользователь, ТекстСообщенияКлиенту);
		
		УдалитьФайлы(ВременныйФайл);
	КонецЕсли;
	Возврат order_УН;

КонецФункции


#КонецОбласти