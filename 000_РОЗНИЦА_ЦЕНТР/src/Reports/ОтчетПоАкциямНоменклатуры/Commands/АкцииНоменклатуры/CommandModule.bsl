
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПериодОтчета = Новый СтандартныйПериод;
	ПериодОтчета.ДатаНачала    = НачалоДня(ТекущаяДата());
	ПериодОтчета.ДатаОкончания = КонецДня(ТекущаяДата());
	
	ТекущийМагазин = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(ТекущийМагазин);
	
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Период"                , ПериодОтчета);
	ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Номенклатура"          , ПараметрКоманды);
	Если ЗначениеЗаполнено(ТекущийМагазин) тогда 
		СкладУправляющейСистемы = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекущийМагазин,"СкладУправляющейСистемы");
		Если НЕ СкладУправляющейСистемы тогда 
			ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Магазин"          	  , ТекущийМагазин);
		КонецЕсли;	
	КонецЕсли;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии"  , Истина);
	ПараметрыОткрытия.Вставить("КлючВарианта"             , "Отчет по акциям номенклатуры");
	ПараметрыОткрытия.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки);
	
	ОткрытьФорму("Отчет.ОтчетПоАкциямНоменклатуры.Форма",
				 ПараметрыОткрытия,
				 ПараметрыВыполненияКоманды.Источник,
				 ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор,
				 ПараметрыВыполненияКоманды.Окно);
				 
				 
КонецПроцедуры
