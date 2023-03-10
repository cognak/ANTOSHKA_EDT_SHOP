

&НаСервере
Процедура СменитьПароль(Пароль)
		НаборЗаписей = РегистрыСведений.ПаролиДиректоров.СоздатьНаборЗаписей(); 
		Магазин = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин;
		НаборЗаписей.Отбор.Магазин.Установить(Магазин);
        НаборЗаписей.Записать();
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Магазин = Магазин;
		НоваяЗапись.Пароль = Пароль;

		НаборЗаписей.Записать();	

	
КонецПроцедуры


&НаКлиенте
Процедура Сменить(Команда)
	Если Пароль = "" тогда 
		ПоказатьПредупреждение(,"Заполните пароль!",5,"Проверьте пароль и подтверждение пароля!");
	Иначе
		Если НЕ Пароль =  ПодтверждениеПароля тогда
			ПоказатьПредупреждение(,"Пароли не совпадают!",5,"Проверьте пароль и подтверждение пароля!");
			Возврат;
		Иначе 
			СменитьПароль(Пароль);
			ПоказатьОповещениеПользователя("Пароль изменен!",,,,,);
			Закрыть();
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

