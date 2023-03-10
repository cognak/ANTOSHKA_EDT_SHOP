#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Применяет настройки панели отчетов для текущего пользователя
//
Процедура СохранитьНастройкиПользователяВРазделе(ИзмененныеНастройки) Экспорт
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	Для Каждого Настройка Из ИзмененныеНастройки Цикл
		
		МенеджерЗаписи = СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Настройка, "Вариант, РазделИлиГруппа, Видимость, БыстрыйДоступ");
		МенеджерЗаписи.Пользователь = ТекущийПользователь;
		МенеджерЗаписи.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

// Очищает настройки текущего пользователя в разделе.
//
Процедура СброситьНастройкиПользователяВРазделе(РазделСсылка, Пользователь = Неопределено) Экспорт
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РазделСсылка", РазделСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ИОМ.Ссылка
	|ИЗ
	|	Справочник.ИдентификаторыОбъектовМетаданных КАК ИОМ
	|ГДЕ
	|	ИОМ.Ссылка В ИЕРАРХИИ(&РазделСсылка)";
	МассивПодсистем = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь, Истина);
	Для Каждого ПодсистемаСсылка Из МассивПодсистем Цикл
		НаборЗаписей.Отбор.РазделИлиГруппа.Установить(ПодсистемаСсылка, Истина);
		НаборЗаписей.Записать(Истина);
	КонецЦикла; 
	
КонецПроцедуры

// Очищает настройки по варианту отчета.
//
Процедура СброситьНастройкиВариантаОтчета(ВариантСсылка) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Вариант.Установить(ВариантСсылка, Истина);
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

#КонецЕсли