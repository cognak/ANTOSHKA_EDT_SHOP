#Область ОбработчикиОсновныхсобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Отчет.НачалоПериода    = ТекущаяДата();
	Отчет.ОкончаниеПериода = ТекущаяДата();

	Если Отчет.Магазин.Пустая() Тогда

		Отчет.Магазин = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин;

	КонецЕсли;

//	а вдруг все реквизиты указаны?
	ЗаполнитьСписокПродавцов();

КонецПроцедуры
	
#КонецОбласти

&НаСервере
Процедура СформироватьАктАннуляцииНаСервере()

	ОбработкаОбъект = РеквизитФормыВЗначение("Отчет");
	ОбработкаОбъект.СформироватьАктАннуляции(ТабличныйДокумент);

КонецПроцедуры

&НаКлиенте
Процедура СформироватьАктАннуляции(Команда)

	Если ПроверитьЗаполнение() Тогда

		СформироватьАктАннуляцииНаСервере();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)

	ЗаполнитьСписокПродавцов();

КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеПериодаПриИзменении(Элемент)

	ЗаполнитьСписокПродавцов();

КонецПроцедуры

&НаКлиенте
Процедура МагазинПриИзменении(Элемент)

	Отчет.КассаККМ = Неопределено;
	Отчет.Продавец = Неопределено;
	ЗаполнитьСписокПродавцов();

КонецПроцедуры

&НаКлиенте
Процедура КассаККМПриИзменении(Элемент)

	Отчет.Продавец = Неопределено;
	ЗаполнитьСписокПродавцов();

КонецПроцедуры

#Область ПоддержкаФункционалаФормы

&НаСервере
Процедура ЗаполнитьСписокПродавцов()

	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АннуляцияПродажи.Продавец КАК Продавец
	|ИЗ
	|	РегистрСведений.АннуляцияПродажи КАК АннуляцияПродажи
	|ГДЕ
	|	АннуляцияПродажи.Период МЕЖДУ НАЧАЛОПЕРИОДА(&НачалоПериода, ДЕНЬ) И КОНЕЦПЕРИОДА(&ОкончаниеПериода, ДЕНЬ)
	|	И АннуляцияПродажи.Магазин = &Магазин
	|	И ВЫБОР
	|			КОГДА &КассаККМ = ЗНАЧЕНИЕ(Справочник.КассыККМ.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ АннуляцияПродажи.КассаККМ = &КассаККМ
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Продавец"
	);
	Запрос.УстановитьПараметр("НачалоПериода"   , Отчет.НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", Отчет.ОкончаниеПериода);
	Запрос.УстановитьПараметр("Магазин"         , Отчет.Магазин);
	Запрос.УстановитьПараметр("КассаККМ"        , Отчет.КассаККМ);
	
	Элементы.Продавец.СписокВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Продавец"));

КонецПроцедуры

#КонецОбласти